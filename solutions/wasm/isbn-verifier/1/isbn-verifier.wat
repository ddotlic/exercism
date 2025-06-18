(module
  (memory (export "mem") 1)

  (data (i32.const 0) "3-598-21508-8")
  ;;
  ;; Checks if a string is a valid ISBN-10 number.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if valid ISBN-10 number, 0 otherwise
  ;;
  (func (export "isValid") (param $offset i32) (param $length i32) (result i32)
    (local $off i32)
    (local $len i32)
    (local $digit i32)
    (local $char i32)
    (local $sum i32)
    (local $err i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char
        i32.const 48
        i32.ge_u
        local.get $char
        i32.const 57
        i32.le_u
        i32.and
        if ;; a number  
          local.get $char
          i32.const 48
          i32.sub
          local.set $char
        else
          local.get $char
          i32.const 88
          i32.eq
          if
            local.get $digit
            i32.const 9
            i32.eq
            if (result i32)
              i32.const 10
            else
              i32.const 12
            end
            local.set $char
          else
            local.get $char
            i32.const 45
            i32.eq
            if
              i32.const 11
              local.set $char
            else
              i32.const 12
              local.set $char
            end
          end
        end

        local.get $char
        i32.const 12
        i32.eq
        if
          i32.const 1
          local.set $err
          br $block
        end

        local.get $char
        i32.const 11
        i32.lt_u
        if
          local.get $char
          i32.const 10
          local.get $digit
          i32.sub
          i32.mul
          local.get $sum
          i32.add
          local.set $sum
          local.get $digit
          i32.const 1
          i32.add
          local.set $digit
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

    local.get $err
    i32.eqz
    local.get $digit
    i32.const 10
    i32.eq
    i32.and
    if (result i32)
      local.get $sum
      i32.const 11
      i32.rem_u
      i32.eqz
    else
      i32.const 0
    end
  )
)
