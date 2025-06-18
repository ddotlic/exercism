(module
  (memory (export "mem") 1)

  (data (i32.const 320) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  
  ;; Determines if the brackets in a string are balanced.
  ;;
  ;; @param {i32} text - the offset where the text string begins in memory
  ;; @param {i32} length - the length of the text
  ;;
  ;; @returns {i32} 1 if brackets are in pairs, 0 otherwise
  ;;
  (func (export "isPaired") (param $text i32) (param $length i32) (result i32)
    ;; Please implement the isPaired function.
    (local $stack i32)
    (local $off i32)
    (local $len i32)
    (local $ok i32)
    (local $char i32)

    i32.const 319
    local.set $stack
    i32.const 1
    local.set $ok

    local.get $text
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
        i32.const 40
        i32.eq
        local.get $char
        i32.const 91
        i32.eq
        local.get $char
        i32.const 123
        i32.eq
        i32.or
        i32.or
        if
          local.get $stack
          i32.const 1
          i32.add
          local.set $stack

          local.get $stack
          local.get $char
          i32.store8
          
        end

        local.get $char
        i32.const 41
        i32.eq
        if
          local.get $stack
          i32.load8_u
          i32.const 40
          i32.eq
          if
            local.get $stack
            i32.const 1
            i32.sub
            local.set $stack
          else
            i32.const 0
            local.set $ok
            br $block
          end
        end

        local.get $char
        i32.const 93
        i32.eq
        if
          local.get $stack
          i32.load8_u
          i32.const 91
          i32.eq
          if
            local.get $stack
            i32.const 1
            i32.sub
            local.set $stack
          else
            i32.const 0
            local.set $ok
            br $block
          end
        end

        local.get $char
        i32.const 125
        i32.eq
        if
          local.get $stack
          i32.load8_u
          i32.const 123
          i32.eq
          if
            local.get $stack
            i32.const 1
            i32.sub
            local.set $stack
          else
            i32.const 0
            local.set $ok
            br $block
          end
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

    local.get $ok
    local.get $stack
    i32.const 319
    i32.eq
    i32.and
  )
)
