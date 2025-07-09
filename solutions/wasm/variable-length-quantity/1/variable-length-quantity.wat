(module
  ;; (import "console" "log_i32_u" (func $log (param i32)))
  
  (memory (export "mem") 1)

  (data (i32.const 400) "\7f\00\00\00") ;; TODO: debug, remove me

  (global $incompleteSequence i32 (i32.const -1))
  (global $outputOffset (mut i32) (i32.const 200))
  (global $tempOffset i32 (i32.const 300))

  (func $encode (param $value i32)
    (local $i i32)
    (local $j i32)
    (local $k i32)
    (local $byte i32)
    (local $highest i32)

    block $block
      loop $loop
        local.get $i
        i32.const 4
        i32.gt_u
        br_if $block

        local.get $value
        local.get $i
        i32.const 7
        i32.mul
        i32.shr_u
        i32.const 0x7f
        i32.and
        local.tee $byte
        i32.const 0
        i32.gt_u
        if
          local.get $i
          local.set $highest
        end

        global.get $tempOffset
        i32.const 4
        local.get $i
        i32.sub
        i32.add
        local.get $byte
        i32.store8

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $highest
    local.set $j
    block $block
      loop $loop
        local.get $j
        i32.eqz
        br_if $block
        global.get $tempOffset
        i32.const 4
        local.get $j
        i32.sub
        i32.add
        local.tee $k
        local.get $k
        i32.load8_u
        i32.const 0x80
        i32.or
        i32.store8
        
        local.get $j
        i32.const 1
        i32.sub
        local.set $j
        br $loop
      end
    end
    
    local.get $highest
    i32.const 1
    i32.add
    local.set $j ;; # of encoded bytes

    global.get $outputOffset
    global.get $tempOffset
    i32.const 4
    local.get $highest
    i32.sub
    i32.add
    local.get $j
    memory.copy
    
    global.get $outputOffset
    local.get $j
    i32.add
    global.set $outputOffset
  )
  ;;
  ;; Encode u32 values into u8 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u32 value array in linear memory
  ;; @param {i32} $inputLength - length of u32 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of u8 value array in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)

    (local $input i32)
    (local $len i32)

    local.get $inputOffset
    local.set $input
    local.get $inputLength
    local.set $len

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $input
        i32.load
        call $encode

        local.get $input
        i32.const 4
        i32.add
        local.set $input

        local.get $len
        i32.const 1
        i32.sub
        local.set $len
        br $loop
      end
    end

    i32.const 200
    global.get $outputOffset
    i32.const 200
    i32.sub
  )

  ;;
  ;; Decode u8 values into u32 with run-length-encoding
  ;;
  ;; @param {i32} $inputOffset - offset of u8 value array in linear memory
  ;; @param {i32} $inputLength - length of u8 value array in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset or error code* and length of u32 value array in linear memory
  ;;                        *if the sequence is incomplete, use (global.get $incompleteSequence)
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $isDecoding i32)
    (local $byte i32)
    (local $decoded i32)
    (local $i i32)
    (local $j i32)
    (local $k i32)

    block $block
      loop $loop
        local.get $i
        local.get $inputLength
        i32.ge_u
        br_if $block

        local.get $j
        i32.const 1
        i32.add
        local.set $j

        local.get $inputOffset
        local.get $i
        i32.add
        i32.load8_u
        i32.const 0x80
        i32.and
        i32.const 0x80
        i32.eq
        if
          i32.const 1
          local.set $isDecoding
        else
          i32.const 0
          local.set $isDecoding

          i32.const 0
          local.set $k
          i32.const 0
          local.set $decoded
          block $block2
            loop $loop2
              local.get $k
              local.get $j
              i32.ge_u
              br_if $block2

              local.get $inputOffset
              local.get $i
              i32.add
              local.get $k
              i32.sub
              i32.load8_u
              i32.const 0x7f
              i32.and
              local.tee $byte
              local.get $k
              i32.const 7
              i32.mul
              i32.shl
              local.get $decoded
              i32.or
              local.set $decoded

              local.get $k
              i32.const 1
              i32.add
              local.set $k
              br $loop2
            end
          end
          global.get $outputOffset
          local.get $decoded
          i32.store
          global.get $outputOffset
          i32.const 4
          i32.add
          global.set $outputOffset
          i32.const 0
          local.set $j
        end

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $isDecoding
    i32.const 1
    i32.eq
    if (result i32 i32)
      global.get $incompleteSequence
      i32.const 0
    else
      i32.const 200
      global.get $outputOffset
      i32.const 200
      i32.sub
      i32.const 2
      i32.shr_u
    end
  )
)
