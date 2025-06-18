(module
  (memory (export "mem") 1)

  ;; error codes
  (global $emptyInput i32 (i32.const -1))
  (global $tooLongSlice i32 (i32.const -2))
  (global $zeroSlice i32 (i32.const -3))
  (global $negativeSlice i32 (i32.const -4))

  ;;
  ;; Creates slices of u8 numbers from a UTF8 string of numbers
  ;;
  ;; @param {i32} $inputOffset - offset of the number string in linear memory
  ;; @param {i32} $inputLength - length of the number string in linear memory
  ;; @param {i32} $sliceLength - length of the slices
  ;;
  ;; @returns {(i32,i32)} - output offset or error code and length of the slices
  ;;
  (func (export "slices") (param $inputOffset i32) (param $inputLength i32) (param $sliceLength i32) (result i32 i32)
    (local $offset i32)
    (local $i i32)
    (local $sliceCount i32)
    (local $output i32)
    
    local.get $inputLength
    i32.eqz
    if
      global.get $emptyInput
      i32.const 0
      return
    end

    local.get $sliceLength
    local.get $inputLength
    i32.gt_s
    if
      global.get $tooLongSlice
      i32.const 0
      return
    end
    
    local.get $sliceLength
    i32.eqz
    if
      global.get $zeroSlice
      i32.const 0
      return
    end
    
    local.get $sliceLength
    i32.const 0
    i32.lt_s
    if
      global.get $negativeSlice
      i32.const 0
      return
    end
    
    local.get $inputLength
    local.get $sliceLength
    i32.sub
    i32.const 1
    i32.add
    local.set $sliceCount

    local.get $inputOffset
    local.set $offset

    i32.const 192
    local.set $output

    (block $exit
      (loop $loop
        local.get $offset
        local.get $inputOffset
        i32.sub
        local.get $sliceCount
        i32.ge_u
        br_if $exit

        i32.const 0
        local.set $i
        
        (block $exit2
          (loop $loop2
            local.get $i
            local.get $sliceLength
            i32.ge_s
            br_if $exit2
            local.get $output
            
            local.get $offset
            local.get $i
            i32.add
            i32.load8_u
            i32.const 48
            i32.sub
            i32.store8
            
            local.get $i
            i32.const 1
            i32.add
            local.set $i
            local.get $output
            i32.const 1
            i32.add
            local.set $output

            br $loop2
          )
        )

        local.get $offset
        i32.const 1
        i32.add
        local.set $offset

        br $loop
      )
    )

    i32.const 192
    local.get $output
    i32.const 192
    i32.sub
  )
)
