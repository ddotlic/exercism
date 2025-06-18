(module
  (memory (export "mem") 1)

  (data (i32.const 0) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") ;; ABCDEFGHIJKLMNOPQRSTUVWXYZ
  ;;
  ;; Determine if a word or phrase is an isogram.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if pangram, 0 otherwise
  ;;
  (func (export "isIsogram") (param $offset i32) (param $length i32) (result i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $isIsogram i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    (block $block
      (loop $loop
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
        local.get $char
        i32.const 97
        i32.ge_u
        local.get $char
        i32.const 122
        i32.le_u
        i32.and
        i32.or
        if  
          local.get $char
          i32.const 97
          i32.ge_u
          if (result i32)
            i32.const 122
          else
            i32.const 90
          end
          local.get $char
          i32.sub
          local.set $char
          
          local.get $char
          local.get $char
          i32.load8_u
          i32.const 1
          i32.add
          i32.store8 
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
      )
    )

    i32.const 26
    local.set $len
    i32.const 0
    local.set $off

    i32.const 1
    local.set $isIsogram

    (block $block2
      (loop $loop2
        local.get $len
        i32.eqz
        br_if $block2

        local.get $off
        i32.load8_u
        i32.const 1
        i32.gt_u
        if
          i32.const 0
          local.set $isIsogram
          br $block2
        end

        local.get $off
        i32.const 1
        i32.add
        local.set $off

        local.get $len
        i32.const 1
        i32.sub
        local.set $len

        br $loop2
      )
    )
    local.get $isIsogram
  )
)
