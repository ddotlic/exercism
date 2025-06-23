(module
  (memory (export "mem") 1)

  (data (i32.const 300) "\05black")
  (data (i32.const 320) "\05brown")
  (data (i32.const 340) "\03red")
  (data (i32.const 360) "\06orange")
  (data (i32.const 380) "\06yellow")
  (data (i32.const 400) "\05green")
  (data (i32.const 420) "\04blue")
  (data (i32.const 440) "\06violet")
  (data (i32.const 460) "\04grey")
  (data (i32.const 480) "\05white")
  (data (i32.const 500) "\05 ohms")
  (data (i32.const 510) "\09 kiloohms")
  (data (i32.const 520) "\01\00") ;; helper for printing digits

  (func $print_digit (param $digit i32) (param $dest i32) (result i32)
    i32.const 521
    local.get $digit
    i32.const 48
    i32.add
    i32.store8
    i32.const 520
    local.get $dest
    call $print_string
  )

  (func $print_string (param $source i32) (param $dest i32) (result i32)
    (local $count i32)
    
    local.get $source
    i32.load8_u
    local.set $count
    
    local.get $dest
    
    local.get $source
    i32.const 1
    i32.add

    local.get $count
    memory.copy

    local.get $count
    local.get $dest
    i32.add
  )

   ;;
  ;; Given a valid resistor color, returns the associated value
  ;;
  ;; @param {i32} offset - offset into the color buffer
  ;; @param {i32} len - length of the color string
  ;;
  ;; @returns {i32} - the associated value
  ;;

  (func $colorCode (param $offset i32) (param $length i32) (result i32)
    (local $result i32)
    (local $i i32)
    (local $off i32)
    (local $len i32)
    (local $found i32)
    (local $candidateOffset i32)

    i32.const 0xff
    local.set $result

    block $block
      loop $loop
        local.get $i
        i32.const 10
        i32.ge_u
        br_if $block

        local.get $i
        i32.const 20
        i32.mul
        i32.const 300
        i32.add
        local.tee $candidateOffset
        i32.load8_u
        local.get $length
        i32.eq
        if
          
          local.get $candidateOffset
          i32.const 1
          i32.add
          local.set $candidateOffset
          
          i32.const 1
          local.set $found

          local.get $offset
          local.set $off
          local.get $length
          local.set $len

          block $block2
            loop $loop2

              local.get $len
              i32.eqz
              br_if $block2

              local.get $candidateOffset
              i32.load8_u
              local.get $off
              i32.load8_u
              i32.ne
              if
                i32.const 0
                local.set $found
                br $block2
              end

              local.get $candidateOffset
              i32.const 1
              i32.add
              local.set $candidateOffset

              local.get $off
              i32.const 1
              i32.add
              local.set $off

              local.get $len
              i32.const 1
              i32.sub
              local.set $len
              
              br $loop2
            end
          end

          local.get $found
          if
            local.get $i
            local.set $result
            br $block
          end
        end

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $result
  )  
  ;;
  ;; Converts color codes, as used on resistors, to a string showing the value and unit.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;; @param {i32} thirdOffset - The offset of the third string in linear memory.
  ;; @param {i32} thirdLength - The length of the third string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the resistance specified 
  ;;                        by the color codes as a string in linear memory;
  ;;                        erroneous inputs receive an empty string
  ;;
  (func (export "value")
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32)
    (param $thirdOffset i32) (param $thirdLength i32) (result i32 i32)
    
    (local $offset i32)
    (local $firstDigit i32)
    (local $secondDigit i32)
    (local $numZeroes i32)
    (local $printSecond i32)
    (local $isKilo i32)

    i32.const 1
    local.set $printSecond

    local.get $firstOffset
    local.get $firstLength
    call $colorCode
    local.tee $firstDigit
    i32.const 0xff
    i32.eq
    if
      i32.const 0
      i32.const 0
      return
    end
    
    local.get $secondOffset
    local.get $secondLength
    call $colorCode
    local.tee $secondDigit
    i32.const 0xff
    i32.eq
    if
      i32.const 0
      i32.const 0
      return
    end

    local.get $thirdOffset
    local.get $thirdLength
    call $colorCode
    local.tee $numZeroes
    i32.const 0xff
    i32.eq
    if
      i32.const 0
      i32.const 0
      return
    end

    local.get $secondDigit
    i32.eqz
    if
      i32.const 1
      local.get $numZeroes
      i32.add
      local.tee $numZeroes
      i32.const 2
      i32.gt_u
      if
        i32.const 0
        local.set $printSecond
      end
    end

    local.get $numZeroes
    i32.const 3
    i32.ge_u
    if
      i32.const 1
      local.set $isKilo
      local.get $numZeroes
      i32.const 3
      i32.sub
      local.set $numZeroes
    end
    
    local.get $firstDigit
    local.get $offset
    call $print_digit
    local.set $offset

    local.get $printSecond
    i32.eqz
    if
    else
      local.get $secondDigit
      local.get $offset
      call $print_digit
      local.set $offset
    end

    local.get $numZeroes
    i32.const 1
    i32.gt_u
    if 
      i32.const 0
      local.get $offset
      call $print_digit
      local.set $offset
      i32.const 0
      local.get $offset
      call $print_digit
      local.set $offset
    else
      local.get $numZeroes
      i32.const 0
      i32.gt_u
      if
        i32.const 0
        local.get $offset
        call $print_digit
        local.set $offset
      end
    end
    
    local.get $isKilo
    i32.eqz
    if (result i32)
      i32.const 500
    else
      i32.const 510
    end
    local.get $offset
    call $print_string
    local.set $offset


    i32.const 0
    local.get $offset
  )
)
