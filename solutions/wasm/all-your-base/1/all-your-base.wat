(module
  (memory (export "mem") 1)
  (data (i32.const 0) "\08\00\00\00\02\00\00\00")
  (data (i32.const 512) "")
  ;; Status codes returned as res[2]
  (global $ok i32 (i32.const 0))
  (global $inputHasWrongFormat i32 (i32.const -1))
  (global $wrongInputBase i32 (i32.const -2))
  (global $wrongOutputBase i32 (i32.const -3))

  (func $pow (param $num i32) (param $exp i32) (result i32)
        
    (local $result i32)
    (local $number i32)
    (local $exponent i32)

    local.get $num
    local.set $number
    local.get $exp
    local.set $exponent
    i32.const 1
    local.set $result

    block $exit
      loop $loop
        local.get $exponent
        i32.eqz
        br_if $exit

        local.get $exponent
        i32.const 1
        i32.and
        if
          local.get $result
          local.get $number
          i32.mul
          local.set $result
        end

        local.get $number
        local.get $number
        i32.mul
        local.set $number

        local.get $exponent
        i32.const 2
        i32.div_s
        local.set $exponent

        br $loop
      end
    end
    local.get $result
  )

  ;;
  ;; Convert an array of digits in inputBase to an array of digits in outputBase
  ;;
  ;; @param {i32} arrOffset - offset of input u32[] array
  ;; @param {i32} arrLength - length of input u32[] array in elements
  ;; @param {i32} inputBase - base of the input array
  ;; @param {i32} outputBase - base of the output array
  ;;
  ;; @return {i32} - offset of the output u32[] array
  ;; @return {i32} - length of the output u32[] array in elements
  ;; @return {i32} - status code (0, -1, -2, -3)                                
  ;;
  (func (export "convert") (param $arrOffset i32) (param $arrLength i32) (param $inputBase i32) (param $outputBase i32) (result i32 i32 i32)
    (local $status i32)
    (local $digit i32)
    (local $inDigits i32)
    (local $inLen i32)
    (local $outDigits i32)
    (local $outLen i32)
    (local $number i32)
    (local $exp i32)
    
    i32.const 512
    local.set $outDigits
    local.get $arrOffset
    local.set $inDigits
    local.get $arrLength
    local.set $inLen

    local.get $inputBase
    i32.const 1
    i32.le_s
    if
      i32.const 0
      i32.const 0
      global.get $wrongInputBase
      return
    end
    
    local.get $outputBase
    i32.const 1
    i32.le_s
    if
      i32.const 0
      i32.const 0
      global.get $wrongOutputBase
      return
    end
    
    local.get $arrLength
    i32.eqz
    if
      i32.const 0
      i32.const 0
      global.get $inputHasWrongFormat
      return
    end

    local.get $inLen
    i32.const 1
    i32.sub
    local.set $exp

    block $block
      loop $loop
        local.get $inLen
        i32.eqz
        br_if $block

        local.get $inDigits
        i32.load
        local.set $digit

        local.get $digit
        i32.const 0
        i32.lt_s
        local.get $digit
        local.get $inputBase
        i32.ge_s
        i32.or

        local.get $digit
        i32.eqz
        local.get $inDigits
        local.get $arrOffset
        i32.eq
        local.get $inLen
        i32.const 1
        i32.gt_u
        i32.and
        i32.and
        i32.or

        if
          global.get $inputHasWrongFormat
          local.set $status
          br $block
        end

        local.get $inputBase
        local.get $exp
        call $pow
        local.get $digit
        i32.mul
        
        local.get $number
        i32.add
        local.set $number

        local.get $inDigits
        i32.const 4
        i32.add
        local.set $inDigits

        local.get $inLen
        i32.const 1
        i32.sub
        local.set $inLen

        local.get $exp
        i32.const 1
        i32.sub
        local.set $exp

        br $loop
      end
    end

    local.get $status
    i32.eqz
    if
      local.get $number
      i32.eqz
      if
        local.get $outDigits
        i32.const 0
        i32.store
        i32.const 1
        local.set $outLen
      else
        block $block2
          loop $loop2
            local.get $number
            i32.eqz
            br_if $block2

            local.get $number
            local.get $outputBase
            i32.rem_u
            local.set $digit
            local.get $number
            local.get $digit
            i32.sub
            local.get $outputBase
            i32.div_u
            local.set $number

            local.get $outDigits
            i32.const 4
            i32.sub
            local.set $outDigits
            local.get $outDigits
            local.get $digit
            i32.store
            
            local.get $outLen
            i32.const 1
            i32.add
            local.set $outLen

            br $loop2
          end
        end
      end
    end

    local.get $outDigits
    local.get $outLen
    local.get $status

  )
)
