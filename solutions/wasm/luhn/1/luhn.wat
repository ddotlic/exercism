(module
  (memory (export "mem") 1)

  (data (i32.const 600) "")

  ;;
  ;; Checks if a string is valid per the Luhn formula.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid per Luhn formula, 0 otherwise
  ;;
  (func (export "valid") (param $offset i32) (param $length i32) (result i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $sum i32)
    (local $reversed i32)
    (local $i i32)

    local.get $length
    local.tee $len
    i32.const 1
    i32.le_u
    if
      i32.const 0
      return
    end

    local.get $offset
    local.set $off

    i32.const 600
    local.set $reversed

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off  
        i32.load8_u
        local.set $char

        local.get $char
        i32.const 48
        i32.ge_u
        local.get $char
        i32.const 57
        i32.le_u
        i32.and
        if
          local.get $reversed
          i32.const 1
          i32.sub
          local.tee $reversed
          
          local.get $char
          i32.const 48
          i32.sub
          i32.store8
        else
          local.get $char
          i32.const 32
          i32.ne
          br_if $block
        end        

        local.get $off
        i32.const 1
        i32.add
        local.set $off

        local.get $len
        i32.const 1
        i32.sub
        local.set $len

        br $loop
      end
    end

    local.get $len
    i32.const 0
    i32.gt_u
    if
      i32.const 0
      return
    end

    i32.const 600
    local.get $reversed
    i32.sub
    i32.const 1
    i32.le_u
    if
      i32.const 0
      return
    end

    block $block2
      loop $loop2
        local.get $reversed
        i32.const 600
        i32.eq
        br_if $block2

        local.get $i
        i32.const 1
        i32.and
        if (result i32)
          local.get $reversed
          i32.load8_u
          i32.const 1
          i32.shl
          local.tee $char
          i32.const 9
          i32.gt_u
          if (result i32)
            local.get $char
            i32.const 9
            i32.sub
          else
            local.get $char
          end
        else
          local.get $reversed
          i32.load8_u
        end
        
        local.get $sum
        i32.add
        local.set $sum
        
        local.get $i
        i32.const 1
        i32.add
        local.set $i

        local.get $reversed
        i32.const 1
        i32.add
        local.set $reversed

        br $loop2
      end
    end

    local.get $sum
    i32.const 10
    i32.rem_u
    i32.eqz
  )
)
