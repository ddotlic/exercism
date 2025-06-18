(module
  (memory (export "mem") 1)
 
  ;;
  ;; Reverse a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the reversed string in linear memory
  ;;
  (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)
    (local $left i32)
    (local $right i32)
    (local $char i32)
    local.get $offset
    local.set $left
    local.get $offset
    local.get $length
    i32.add
    i32.const 1
    i32.sub
    local.set $right
    block $block
      loop $loop
        local.get $left
        i32.load8_u
        local.set $char
        local.get $left
        local.get $right
        i32.load8_u
        i32.store8
        local.get $right
        local.get $char
        i32.store8

        local.get $left
        i32.const 1
        i32.add
        local.set $left
        local.get $right
        i32.const 1
        i32.sub
        local.set $right
        local.get $left
        local.get $right
        i32.ge_u
        br_if $block

        br $loop
      end
    end
    local.get $offset
    local.get $length
  )
)
