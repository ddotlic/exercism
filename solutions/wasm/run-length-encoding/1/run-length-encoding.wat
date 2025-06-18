(module
  (memory (export "mem") 1)

  (data (i32.const 320) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  
  (func $outputEncoded (param $offset i32) (param $length i32) (param $char i32) (result i32)
    (local $off i32)

    local.get $offset
    local.set $off

    local.get $length
    i32.const 1
    i32.gt_u
    if
      local.get $length
      i32.const 10
      i32.gt_u
      if
        local.get $off
        local.get $length
        i32.const 10
        i32.div_u
        i32.const 48
        i32.add
        i32.store8
        local.get $off
        i32.const 1
        i32.add
        local.set $off
      end
      local.get $off
      local.get $length
      i32.const 10
      i32.rem_u
      i32.const 48
      i32.add
      i32.store8
      local.get $off
      i32.const 1
      i32.add
      local.set $off
    end
    local.get $off
    local.get $char
    i32.store8
    local.get $off
    i32.const 1
    i32.add
  )
  ;;
  ;; Encode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the input string in linear memory
  ;; @param {i32} inputLength - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $run i32)
    (local $char i32)
    (local $prev i32)
    (local $out i32)

    local.get $inputLength
    i32.eqz
    if
      i32.const 320
      i32.const 0
      return
    end


    local.get $inputOffset
    local.set $off
    local.get $inputLength
    local.set $len
    i32.const 320
    local.set $out

    local.get $off
    i32.load8_u
    local.set $prev

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char
        local.get $prev
        i32.eq
        if
          local.get $run
          i32.const 1
          i32.add
          local.set $run
        else
          local.get $out
          local.get $run
          local.get $prev
          call $outputEncoded
          local.set $out
          i32.const 1
          local.set $run
          local.get $char
          local.set $prev
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

    local.get $out
    local.get $run
    local.get $prev
    call $outputEncoded
    local.set $out

    i32.const 320
    local.get $out
    i32.const 320
    i32.sub
  )

  (func $isNumber (param $char i32) (result i32)
    local.get $char
    i32.const 48
    i32.ge_u
    local.get $char
    i32.const 57
    i32.le_u
    i32.and
  )

  (func $outputDecoded (param $offset i32) (param $length i32) (param $char i32) (result i32)
    (local $off i32)
    (local $len i32)

    local.get $offset
    local.set $off
    local.get $length
    local.tee $len
    i32.eqz
    if
      i32.const 1
      local.set $len
    end

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        local.get $char
        i32.store8

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

    local.get $off
  )

  ;;
  ;; Decode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the string in linear memory
  ;; @param {i32} inputLength - The length of the string in linear memory
  ;;
  ;; returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $run i32)
    (local $char i32)
    (local $out i32)

    local.get $inputLength
    i32.eqz
    if
      i32.const 320
      i32.const 0
      return
    end

    local.get $inputOffset
    local.set $off
    local.get $inputLength
    local.set $len
    i32.const 320
    local.set $out

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char
        
        call $isNumber
        if
          local.get $char
          i32.const 48
          i32.sub
          local.get $run
          i32.const 10
          i32.mul
          i32.add
          local.set $run
        else
          local.get $out
          local.get $run
          local.get $char
          call $outputDecoded
          local.set $out

          i32.const 0
          local.set $run
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
    local.get $out
    i32.const 320
    i32.sub
  )
)
