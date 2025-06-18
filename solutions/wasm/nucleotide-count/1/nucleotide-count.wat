(module
  (memory (export "mem") 1)

  ;;
  ;; Count the number of each nucleotide in a DNA string.
  ;;
  ;; @param {i32} offset - The offset of the DNA string in memory.
  ;; @param {i32} length - The length of the DNA string.
  ;;
  ;; @returns {(i32,i32,i32,i32)} - The number of adenine, cytosine, guanine, 
  ;;                                and thymine nucleotides in the DNA string
  ;;                                or (-1, -1, -1, -1) if the DNA string is
  ;;                                invalid.
  ;;

  (data (i32.const 64) "GGGGGGG")

  (func (export "countNucleotides") (param $offset i32) (param $length i32) (result i32 i32 i32 i32)
    (local $success i32) ;; if it remains zero, the DNA string is invalid
    (local $match i32)
    (local $A i32)
    (local $C i32)
    (local $G i32)
    (local $T i32)
    (local $off i32) 
    (local $len i32)
    (local $letter i32)
    local.get $offset
    local.set $off
    local.get $length
    local.set $len
    i32.const 1
    local.set $success
    (block $exit
      (loop $loop
                
        local.get $len
        i32.eqz
        br_if $exit
        
        i32.const 0
        local.set $success

        local.get $off
        i32.load8_u
        local.set $letter

        local.get $letter
        i32.const 65
        i32.eq
        local.set $match
        local.get $match
        local.get $A
        i32.add
        local.set $A
        local.get $match
        local.get $success
        i32.or
        local.set $success

        local.get $letter
        i32.const 67
        i32.eq
        local.set $match
        local.get $match
        local.get $C
        i32.add
        local.set $C
        local.get $match
        local.get $success
        i32.or
        local.set $success

        local.get $letter
        i32.const 71
        i32.eq
        local.set $match
        local.get $match
        local.get $G
        i32.add
        local.set $G
        local.get $match
        local.get $success
        i32.or
        local.set $success

        local.get $letter
        i32.const 84
        i32.eq
        local.set $match
        local.get $match
        local.get $T
        i32.add
        local.set $T
        local.get $match
        local.get $success
        i32.or
        local.set $success

        local.get $success
        i32.eqz
        br_if $exit

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
    local.get $success
    if (result i32 i32 i32 i32)
      local.get $A
      local.get $C
      local.get $G
      local.get $T
      return
    else
      i32.const -1
      i32.const -1
      i32.const -1
      i32.const -1
    end
  )
)
