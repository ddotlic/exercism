(module
  (memory (export "mem") 1)


  (data (i32.const 0) "__________")
  
  ;;
  ;; Clean up user-entered phone number
  ;;
  ;; @param {i32} textOffset - The offset of the input string in linear memory
  ;; @param {i32} textLength - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the clean phone number in linear memory
  ;;
  (func (export "clean") (param $textOffset i32) (param $textLength i32) (result i32 i32)
    (local $offset i32)
    (local $length i32)
    (local $result i32)
    (local $group i32)
    (local $digit i32)
    (local $useDigit i32)
    (local $char i32)
    (local $isErr i32)

    local.get $textOffset
    local.set $offset
    local.get $textLength
    local.set $length

    block $block
        loop $loop

        local.get $length
        i32.eqz
        br_if $block

        local.get $offset
        i32.load8_u
        local.set $char

        i32.const 1
        local.set $useDigit

        local.get $char
        i32.const 48
        i32.ge_u
        local.get $char
        i32.const 57
        i32.le_u
        i32.and
    
        if ;; a digit
          
          local.get $group
          i32.eqz
          if ;; country code group
            local.get $digit
            i32.eqz
            if ;; check country code
              i32.const 49
              local.get $char
              i32.ne
              if ;; not 1, so not a country code 
                i32.const 1
                local.set $group
              else 
                i32.const 2
                local.set $digit
                i32.const 0
                local.set $useDigit
              end
            end
          end
          
          local.get $group
          i32.const 1
          i32.eq
          local.get $group
          i32.const 2
          i32.eq
          i32.or
          if
            local.get $digit
            i32.eqz
            if ;; check area code
              local.get $char
              i32.const 49
              i32.le_u
              if ;; not 2-9, so an error
                i32.const 1
                local.set $isErr
                br $block
              end
            end
          end

          local.get $digit
          i32.const 1
          i32.add
          local.tee $digit

          i32.const 3
          i32.eq
          if
            local.get $group
            i32.const 1
            i32.add
            local.set $group
            i32.const 0
            local.set $digit
          end

          local.get $useDigit
          if
            local.get $result
            local.get $char
            i32.store8
            local.get $result
            i32.const 1
            i32.add
            local.set $result
          end
        end


        local.get $offset
        i32.const 1
        i32.add
        local.set $offset
        local.get $length
        i32.const 1
        i32.sub
        local.set $length

        br $loop
      end
    end

    i32.const 0   

    local.get $isErr
    i32.const 1
    i32.eq
    local.get $result
    i32.const 10
    i32.ne
    i32.or
    if (result i32)
      i32.const 0
    else
      i32.const 10
    end
  )
)
