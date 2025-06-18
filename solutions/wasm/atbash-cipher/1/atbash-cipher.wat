(module
  (memory (export "mem") 1)

  (data (i32.const 0)  "abcdefghijklmnopqrstuvwxyz")
  (data (i32.const 26) "zyxwvutsrqponmlkjihgfedcba")
  (data (i32.const 320) "                                                                                                                                                                                                                                                             ")
  ;; Encode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $outOff i32)
    (local $outGroup i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len
    i32.const 320
    local.set $outOff

    block $block
      loop $loop

        local.get $len
        i32.eqz
        br_if $block

        local.get $off  
        i32.load8_u
        local.tee $char

        i32.const 65
        i32.ge_u
        local.get $char
        i32.const 90
        i32.le_u
        i32.and
        if ;; uppercase
          local.get $char
          i32.const 39 ;; 65-26
          i32.sub
          i32.load8_u
          local.set $char
        else
          local.get $char
          i32.const 97
          i32.ge_u
          local.get $char
          i32.const 122
          i32.le_u
          i32.and
          if ;; lowercase
            local.get $char
            i32.const 71;; 97-26
            i32.sub
            i32.load8_u
            local.set $char
          else
            local.get $char
            i32.const 48
            i32.ge_u
            local.get $char
            i32.const 57
            i32.le_u
            i32.and
            i32.eqz
            if ;; not a number or letter
              i32.const 0
              local.set $char
            end
          end
        end
        
        local.get $char
        i32.const 0
        i32.gt_u
        if
          local.get $outGroup
          i32.const 1
          i32.add
          local.tee $outGroup
          i32.const 6
          i32.eq
          if (result i32)
            i32.const 1
            local.tee $outGroup
          else
            i32.const 0
          end
          local.get $outOff
          i32.add
          local.tee $outOff
          local.get $char
          i32.store8

          local.get $outOff
          i32.const 1
          i32.add
          local.set $outOff
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

    i32.const 320
    local.get $outOff
    i32.const 320
    i32.sub
  )

  ;;
  ;; Decode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $outOff i32)
    (local $outGroup i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len
    i32.const 320
    local.set $outOff

    block $block
      loop $loop

        local.get $len
        i32.eqz
        br_if $block

        local.get $off  
        i32.load8_u
        local.tee $char

        i32.const 32
        i32.eq
        if (result i32)
          i32.const 0
        else
            local.get $char
            i32.const 48
            i32.ge_u
            local.get $char
            i32.const 57
            i32.le_u
            i32.and
            i32.eqz
            if (result i32)
              local.get $char
              i32.const 71;; 97-26
              i32.sub
              i32.load8_u
            else
              local.get $char
            end
        end
        local.tee $char
        
        i32.const 0
        i32.gt_u
        if
          local.get $outOff
          local.get $char
          i32.store8
          local.get $outOff
          i32.const 1
          i32.add
          local.set $outOff
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

    i32.const 320
    local.get $outOff
    i32.const 320
    i32.sub
  )
)
