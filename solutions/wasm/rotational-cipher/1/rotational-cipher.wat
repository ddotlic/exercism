(module
  (memory (export "mem") 1)

  (data (i32.const 400) "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789")
  ;;
  ;; Encrypt plaintext using the rotational cipher.
  ;;
  ;; @param {i32} textOffset - The offset of the plaintext input in linear memory.
  ;; @param {i32} textLength - The length of the plaintext input in linear memory.
  ;; @param {i32} shiftKey - The shift key to use for the rotational cipher.
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the ciphertext output in linear memory.
  ;;
  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $result i32)
    (local $kind i32)

    i32.const 400
    local.set $result
    
    local.get $textOffset
    local.set $off
    local.get $textLength
    local.set $len

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.set $char

        i32.const 0
        local.set $kind
        
        local.get $char
        i32.const 65
        i32.ge_u
        local.get $char
        i32.const 90
        i32.le_u
        i32.and
        if
          i32.const 65
          local.set $kind
        end

        local.get $char
        i32.const 97
        i32.ge_u
        local.get $char
        i32.const 122
        i32.le_u
        i32.and
        if
          i32.const 97
          local.set $kind
        end
        
        local.get $kind
        i32.const 0
        i32.gt_u
        if
          local.get $char
          local.get $kind
          i32.sub
          local.get $shiftKey
          i32.add
          i32.const 26
          i32.rem_u
          local.get $kind
          i32.add
          local.set $char
        end

        local.get $result
        local.get $char
        i32.store8
        local.get $result
        i32.const 1
        i32.add
        local.set $result

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

    i32.const 400
    local.get $result
    i32.const 400
    i32.sub
  )
)
