(module
  (memory (export "mem") 1)

  (data (i32.const 30) "Pling")
  (data (i32.const 50) "Plang")
  (data (i32.const 70) "Plong")
  (data (i32.const 100) "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
  ;;
  ;; Convert a number into a string of raindrop sounds
  ;;
  ;; @param {i32} input - The number to convert
  ;;
  ;; @returns {(i32,i32)} - Offset and length of raindrop sounds string 
  ;;                        in linear memory.
  ;;
  (func (export "convert") (param $input i32) (result i32 i32)
    (local $offset i32)
    i32.const 200
    local.set $offset
    
    local.get $input
    i32.const 3
    i32.rem_u
    i32.eqz
    if
      local.get $offset
      i32.const 30
      i32.const 5
      memory.copy
      local.get $offset
      i32.const 5
      i32.add
      local.set $offset
    end

    local.get $input
    i32.const 5
    i32.rem_u
    i32.eqz
    if
      local.get $offset
      i32.const 50
      i32.const 5
      memory.copy
      local.get $offset
      i32.const 5
      i32.add
      local.set $offset
    end

    local.get $input
    i32.const 7
    i32.rem_u
    i32.eqz
    if
      local.get $offset
      i32.const 70
      i32.const 5
      memory.copy
      local.get $offset
      i32.const 5
      i32.add
      local.set $offset
    end

    local.get $offset
    i32.const 200
    i32.eq
    if
      i32.const 220
      local.set $offset

      block $bl
        loop $lp
          local.get $input
          i32.eqz
          br_if $bl
          
          local.get $offset
          
          local.get $input
          i32.const 10
          i32.rem_u
          i32.const 48
          i32.add
          
          i32.store8
          
          local.get $offset
          i32.const 1
          i32.sub
          local.set $offset
          
          local.get $input
          i32.const 10
          i32.div_u
          local.set $input
          br $lp
        end
      end
      local.get $offset
      i32.const 1
      i32.add
      local.tee $offset
      i32.const 221
      local.get $offset
      i32.sub
      return
    end

    i32.const 200
    local.get $offset
    i32.const 200
    i32.sub
  )
)
