(module
  (memory (export "mem") 1)

  ;;
  ;; Truncate UTF-8 input string to 5 characters
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the truncated string in linear memory
  ;;
  (func (export "truncate") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $charLen i32)
    (local $found i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    (block $block
      (loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char

        i32.const 0x80
        i32.and
        i32.eqz
        if (result i32)
          i32.const 1
        else
          local.get $char
          i32.const 0xE0
          i32.and
          i32.const 0xC0
          i32.eq
          if (result i32)
            i32.const 2
          else
            local.get $char
            i32.const 0xF0
            i32.and
            i32.const 0xE0
            i32.eq
            if (result i32)
              i32.const 3
            else
              local.get $char
              i32.const 0xF8
              i32.and
              i32.const 0xF0
              i32.eq
              if (result i32)
                i32.const 4
              else
                i32.const 0 ;; Invalid UTF-8 character
              end
            end
          end
        end
        local.set $charLen
        
        local.get $off
        local.get $charLen
        i32.add
        local.set $off

        local.get $len
        local.get $charLen
        i32.sub
        local.set $len

        local.get $found
        i32.const 1
        i32.add
        local.tee $found
        i32.const 5
        i32.eq
        br_if $block

        br $loop
      )
    )
    local.get $offset
    local.get $length
    local.get $len
    i32.sub
  )
)
