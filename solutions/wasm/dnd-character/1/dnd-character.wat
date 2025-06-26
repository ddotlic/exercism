(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 1)
  
  (global $tempOffset i32 (i32.const 10))
  (global $constitutionBelowThree i32 (i32.const -99999))
  (global $constitutionAboveEighteen i32 (i32.const 99999))

  ;;
  ;; Calculates the ability modifier for the hitpoints of a DnD Character
  ;;
  ;; @param {i32} $constitution
  ;;
  ;; @returns {i32} - modifier for the hitpoints, -99999 if input too small, 99999 if too large
  ;;
  (func $abilityModifier (export "abilityModifier") (param $constitution i32) (result i32)
    local.get $constitution
    i32.const 3
    i32.lt_u
    if
      global.get $constitutionBelowThree
      return
    end

    local.get $constitution
    i32.const 18
    i32.gt_u
    if
      global.get $constitutionAboveEighteen
      return
    end

    local.get $constitution
    i32.const 10
    i32.sub
    f64.convert_i32_s
    f64.const 2
    f64.div
    f64.floor
    i32.trunc_f64_s
  )

  (func $randomValue (result i32)
    f64.const 6
    call $random
    f64.mul
    i32.trunc_f64_u
    i32.const 1
    i32.add
  )
  ;;
  ;; Roll an attribute for a DnD Character
  ;;
  ;; @returns {i32} - the sum of the 3 highest of 4 6-sided dices
  ;;
  (func $rollAbility (export "rollAbility") (result i32)
    (local $i i32)
    (local $j i32)
    (local $k i32)
    (local $ignore i32)
    (local $smallest i32)
    (local $val i32)
    (local $result i32)

    i32.const 7
    local.set $smallest

    block $block
      loop $loop
        local.get $i
        i32.const 3
        i32.gt_u
        br_if $block

        local.get $i
        global.get $tempOffset
        i32.add
        i32.const 2
        i32.shl
        call $randomValue
        i32.store

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    block $block2
      loop $loop2
        local.get $j
        i32.const 3
        i32.gt_u
        br_if $block2

        local.get $j
        global.get $tempOffset
        i32.add
        i32.const 2
        i32.shl
        i32.load
        local.tee $val
        local.get $smallest
        i32.le_u
        if
          local.get $val
          local.set $smallest
          local.get $j
          local.set $ignore
        end

        local.get $j
        i32.const 1
        i32.add
        local.set $j

        br $loop2
      end
    end

    block $block3
      loop $loop3
        local.get $k
        i32.const 3
        i32.gt_u
        br_if $block3

        local.get $k
        local.get $ignore
        i32.ne
        if
          local.get $k
          global.get $tempOffset
          i32.add
          i32.const 2
          i32.shl
          i32.load
          local.get $result
          i32.add
          local.set $result
        end

        local.get $k
        i32.const 1
        i32.add
        local.set $k

        br $loop3
      end
    end
    local.get $result
  )

  ;;
  ;; Generates the attribute values for a DnD Character:
  ;; strength, dexterity, constitution, intelligence, wisdom, charisma and hitpoints
  ;;
  ;; @returns {(i32,i32)} - offset and length of an i32-array of the values
  ;;
  (func (export "createCharacter") (result i32 i32)
    (local $i i32)

    block $block
      loop $loop
        local.get $i
        i32.const 5
        i32.gt_u
        br_if $block

        local.get $i
        i32.const 2
        i32.shl
        call $rollAbility
        i32.store

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    i32.const 24
    i32.const 8
    i32.load
    call $abilityModifier
    i32.const 10
    i32.add
    i32.store

    i32.const 0
    i32.const 28
  )
)
