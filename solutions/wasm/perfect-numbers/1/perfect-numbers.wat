(module
  (global $nonPositive i32 (i32.const 0))
  (global $deficient i32 (i32.const 1))
  (global $perfect i32 (i32.const 2))
  (global $abundant i32 (i32.const 3))

  ;;
  ;; Determine if a number is perfect
  ;;
  ;; @param {i32} number - The number to check
  ;;
  ;; @returns {i32} 0 if non-positive, 1 if deficient, 2 if perfect, 3 if abundant
  ;;
  (func (export "classify") (param $number i32) (result i32)
    (local $num i32)
    (local $i i32)
    (local $sum i32)

    local.get $number
    local.set $num

    local.get $num
    i32.const 0 
    i32.le_s
    if
      global.get $nonPositive
      return
    end

    local.get $num
    i32.const 1
    i32.shr_u
    local.set $num

    i32.const 1
    local.set $i
    
    block $block
      loop $loop

        local.get $i
        local.get $num
        i32.gt_u
        br_if $block

        local.get $number
        local.get $i
        i32.rem_u
        i32.eqz
        if
          local.get $sum
          local.get $i
          i32.add
          local.set $sum
        end

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $number
    local.get $sum
    i32.eq
    if 
      global.get $perfect
      return
    end

    local.get $number
    local.get $sum
    i32.lt_u
    if 
      global.get $abundant
      return
    end

    local.get $number
    local.get $sum
    i32.gt_u
    if 
      global.get $deficient
      return
    end
    
    global.get $nonPositive
  )
)
