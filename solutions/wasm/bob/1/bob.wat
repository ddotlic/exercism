(module
  (memory (export "mem") 1)

  (data (i32.const 400) "Sure.")
  (data (i32.const 410) "Whoa, chill out!")
  (data (i32.const 430) "Fine. Be that way!")
  (data (i32.const 450) "Whatever.")
  (data (i32.const 460) "Calm down, I know what I'm doing!")
  ;;
  ;; Reply to someone when they say something or ask a question
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the reversed string in linear memory
  ;;

  (func $isWhitespace (param $char i32) (result i32)
    local.get $char
    i32.const 32
    i32.eq
    local.get $char
    i32.const 13
    i32.eq
    local.get $char
    i32.const 10
    i32.eq
    local.get $char
    i32.const 9
    i32.eq
    i32.or
    i32.or
    i32.or
  )

  (func (export "response") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $ucCount i32) ;; upper case count
    (local $lcCount i32) ;; lower case count
    (local $wsCount i32) ;; white space count
    (local $isQuestion i32) 

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    local.get $off
    local.get $len
    i32.add
    local.set $off

    block $block
      loop $loop
        local.get $off
        i32.const 1
        i32.sub
        local.tee $off
        local.get $offset
        i32.lt_u
        br_if $block
        local.get $off
        i32.load8_u
        local.tee $char
        call $isWhitespace
        i32.eqz
        if
          local.get $char
          i32.const 63
          i32.eq
          if
            i32.const 1
            local.set $isQuestion
          end
          br $block
        end
      br $loop
      end
    end
    
    local.get $offset
    local.set $off
    
    
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
        if
          local.get $ucCount
          i32.const 1
          i32.add
          local.set $ucCount
        end

        local.get $char
        i32.const 97
        i32.ge_u
        local.get $char
        i32.const 122
        i32.le_u
        i32.and
        if
          local.get $lcCount
          i32.const 1
          i32.add
          local.set $lcCount
        end

        local.get $char
        call $isWhitespace
        if
          local.get $wsCount
          i32.const 1
          i32.add
          local.set $wsCount
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

    local.get $lcCount
    i32.eqz
    local.get $ucCount
    i32.const 0
    i32.gt_u
    i32.and
    if
      local.get $isQuestion
      i32.eqz
      if
        i32.const 410
        i32.const 16
        return
      else
        i32.const 460
        i32.const 33
        return
      end
    end
    local.get $isQuestion
    i32.const 1
    i32.eq
    if
      i32.const 400
      i32.const 5
      return
    end
    local.get $wsCount
    local.get $length
    i32.eq
    if
      i32.const 430
      i32.const 18
      return
    end
    i32.const 450
    i32.const 9
  )
)
