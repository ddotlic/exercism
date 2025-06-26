(module
  (memory (export "mem") 1)

  (global $inputAddr i32 (i32.const 5))
  (global $workspaceAddr i32 (i32.const 25))
  (global $nl i32 (i32.const 10))

  ;;
  ;; Find the anagrams to the first word in the string of subsequent words
  ;;
  ;; @param {i32} $inputOffset - offset of the word list in linear memory
  ;; @param {i32} $inputLength - length of the word list in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output word list
  ;;

  (func $isAnagram (param $wordOff i32) (param $candidateOff i32) (result i32)
    (local $char i32)
    (local $char2 i32)
    (local $len i32)
    (local $i i32)
    (local $j i32)
    (local $found i32)
    (local $same i32)

    local.get $wordOff
    i32.load8_u
    local.tee $len
    local.get $candidateOff
    i32.load8_u
    i32.ne
    if ;; if length differs, not an anagram
      i32.const 0
      return
    end

    i32.const 1
    local.set $same ;; assume the same unless found otherwise

    local.get $wordOff
    i32.const 1
    i32.add
    local.set $i

    block $block
      loop $loop
        local.get $i
        local.get $wordOff
        i32.sub
        local.get $len
        i32.gt_u
        br_if $block

        local.get $i
        i32.load8_u
        local.tee $char
        i32.const 91
        i32.lt_u
        if
          local.get $char
          i32.const 32
          i32.add
          local.set $char
        end
        
        local.get $candidateOff
        i32.const 1
        i32.add
        local.set $j

        block $block2
          loop $loop2
            local.get $j
            local.get $candidateOff
            i32.sub
            local.get $len
            i32.gt_u
            br_if $block2

            local.get $j
            i32.load8_u
            local.tee $char2
            i32.const 91
            i32.lt_u
            if
              local.get $char2
              i32.const 32
              i32.add
              local.set $char2
            end

            local.get $char
            local.get $char2
            i32.eq
            if
              local.get $j
              i32.const 0
              i32.store8
              i32.const 1
              local.get $found
              i32.add
              local.set $found

              local.get $i
              local.get $wordOff
              i32.sub
              local.get $j
              local.get $candidateOff
              i32.sub
              i32.eq
              local.get $same
              i32.and
              local.set $same
              br $block2
            end

            local.get $j
            i32.const 1
            i32.add
            local.set $j
            
            br $loop2
          end
        end

        local.get $i
        i32.const 1
        i32.add
        local.set $i
      
        br $loop
      end
    end

    local.get $len
    local.get $found
    i32.eq
    local.get $same
    i32.eqz
    i32.and
  )

  (func $pullWord (param $inputOffset i32) (param $outputOffset i32) (result i32)
    (local $len i32)
    (local $inOff i32)
    
    local.get $inputOffset
    local.set $inOff

    block $block
      loop $loop

        local.get $inOff
        i32.load8_u
        global.get $nl
        i32.eq
        br_if $block

        local.get $inOff
        i32.const 1
        i32.add
        local.set $inOff

        br $loop
      end
    end

    local.get $inOff
    local.get $inputOffset
    i32.sub
    local.tee $len
    i32.eqz
    if
    else 
      local.get $outputOffset
      local.get $len
      i32.store8
      local.get $outputOffset
      i32.const 1
      i32.add
      local.get $inputOffset
      local.get $len
      memory.copy
    end
    local.get $len
  )

  (func (export "findAnagrams") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $inputOff i32)
    (local $outputOff i32)
    (local $len i32)

    i32.const 400
    local.set $outputOff

    local.get $inputOffset
    local.set $inputOff

    local.get $inputOffset
    global.get $inputAddr
    call $pullWord
    local.get $inputOff
    i32.add
    i32.const 1
    i32.add ;; skip newline
    local.set $inputOff

    block $block
      loop $loop
        local.get $inputOff
        local.get $inputOffset
        i32.sub
        local.get $inputLength
        i32.ge_u
        br_if $block

        local.get $inputOff
        global.get $workspaceAddr
        call $pullWord
        local.set $len
                
        global.get $inputAddr
        global.get $workspaceAddr
        call $isAnagram
        i32.const 1
        i32.eq
        if
          local.get $outputOff
          local.get $inputOff
          local.get $len
          i32.const 1
          i32.add
          memory.copy
          local.get $outputOff
          local.get $len
          i32.add
          i32.const 1
          i32.add
          local.set $outputOff
        end

        local.get $inputOff
        local.get $len
        i32.add
        i32.const 1
        i32.add
        local.set $inputOff
        
        br $loop
      end
    end

    i32.const 400
    local.get $outputOff
    i32.const 400
    i32.sub
  )
)
