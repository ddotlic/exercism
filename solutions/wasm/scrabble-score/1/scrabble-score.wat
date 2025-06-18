(module
  (memory (export "mem") 1)

  ;;                     a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z
  (data (i32.const 0) "\01\03\03\02\01\04\02\04\01\08\05\01\03\01\01\03\0A\01\01\01\01\04\04\08\04\0A") 
  ;;
  ;; Given a word, compute the Scrabble score for that word
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {i32} - the computed score
  ;;
  (func (export "score") (param $offset i32) (param $length i32) (result i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $score i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char

        local.get $char
        i32.const 65
        i32.ge_u
        local.get $char
        i32.const 90
        i32.le_u
        i32.and
        if (result i32)
          i32.const 65
        else
          i32.const 97
        end
        i32.sub
        local.tee $char
        i32.load8_u
        local.get $score
        i32.add
        local.set $score

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

    local.get $score
  )
)
