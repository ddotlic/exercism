(module
  (memory (export "mem") 1)

  (data (i32.const 200) "you")
  (data (i32.const 210) ", one for me.")
  (data (i32.const 230) "One for ")
  ;;
  ;; Given a string X, return a string that says "One for X, one for me."
  ;; If the X is empty, return the string "One for you, one for me."
  ;;
  ;; @param {i32} $offset - The offset of the name in linear memory.
  ;; @param {i32} $length - The length of the name in linear memory.
  ;; 
  ;; @return {(i32,i32)} - The offset and length the resulting string in linear memory.
  ;;
  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    local.get $length
    if
      local.get $offset
      local.set $off
      local.get $length
      local.set $len
    else
      i32.const 200
      local.set $off
      i32.const 3
      local.set $len
    end
    i32.const 238
    local.get $off
    local.get $len
    memory.copy
    
    i32.const 238
    local.get $len
    i32.add
    i32.const 210
    i32.const 13
    memory.copy
    
    i32.const 230
    i32.const 21
    local.get $len
    i32.add
  )
)
