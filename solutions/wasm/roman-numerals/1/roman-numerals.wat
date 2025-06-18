(module
  (memory (export "mem") 1)

  (data (i32.const 0) "IVX")
  (data (i32.const 3) "XLC")
  (data (i32.const 6) "CDM")
  (data (i32.const 9) "M__")

  (data (i32.const 12) "\00\00\00\00") ;; temp storage
  (data (i32.const 16) "\00\00\00\00\00\00\00\00\00\00\00\00") ;; result

  
  (func $emit (param $magnitude i32) (param $ordinal i32) (param $offset i32) (result i32)
    (local $char i32)
    
    local.get $magnitude
    local.get $ordinal
    i32.add
    i32.load8_u
    local.set $char

    local.get $offset
    local.get $char
    i32.store8

    local.get $offset
    i32.const 1
    i32.add
  )

  ;;
  ;; Convert a number into a Roman numeral
  ;;
  ;; @param {i32} number - The number to convert
  ;;
  ;; @returns {(i32,i32)} - Offset and length of result string
  ;;                        in linear memory.
  ;;
  (func (export "roman") (param $number i32) (result i32 i32)
    (local $num i32)
    (local $arabic i32)
    (local $roman i32)
    (local $digit i32)
    (local $char i32)
    (local $magnitude i32)
    (local )

    local.get $number
    local.set $num

    i32.const 16
    local.set $arabic

    block $block1
      loop $loop1
        local.get $num
        i32.eqz
        br_if $block1
        
        local.get $arabic
        i32.const 1
        i32.sub
        local.set $arabic

        local.get $arabic
        local.get $num
        i32.const 10
        i32.rem_u
        i32.store8
        local.get $num
        i32.const 10
        i32.div_u
        local.set $num

        br $loop1
      end
    end

    i32.const 15
    local.get $arabic
    i32.sub
    i32.const 3
    i32.mul
    local.set $magnitude

    i32.const 16
    local.set $roman

    block $block2
      loop $loop2
        local.get $magnitude
        i32.const 0
        i32.lt_s
        br_if $block2

        local.get $arabic
        i32.load8_u
        local.set $digit

        local.get $digit
        i32.const 0
        i32.gt_u
        
        if

          local.get $digit
          i32.const 4
          i32.eq
          if
            local.get $magnitude
            i32.const 0
            local.get $roman
            call $emit
            local.set $roman

            local.get $magnitude
            i32.const 1
            local.get $roman
            call $emit
            local.set $roman

            i32.const 0
            local.set $digit
          end

          local.get $digit
          i32.const 9
          i32.eq
          if
            local.get $magnitude
            i32.const 0
            local.get $roman
            call $emit
            local.set $roman

            local.get $magnitude
            i32.const 2
            local.get $roman
            call $emit
            local.set $roman

            i32.const 0
            local.set $digit
          end

          local.get $digit
          i32.const 5
          i32.ge_u
          if
            local.get $magnitude
            i32.const 1
            local.get $roman
            call $emit
            local.set $roman

            local.get $digit
            i32.const 5
            i32.sub
            local.set $digit
          end

          block $block3
            loop $loop3
              local.get $digit
              i32.eqz
              br_if $block3
              local.get $magnitude
              i32.const 0
              local.get $roman
              call $emit
              local.set $roman

              local.get $digit
              i32.const 1
              i32.sub
              local.set $digit

              br $loop3
            end
          end

        end

        local.get $magnitude
        i32.const 3
        i32.sub
        local.set $magnitude

        local.get $arabic
        i32.const 1
        i32.add
        local.set $arabic

        br $loop2
      end
    end

    i32.const 16
    local.get $roman
    i32.const 16
    i32.sub
  )
)
