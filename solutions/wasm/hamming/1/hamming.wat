(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the hamming distance between two strings.
  ;;
  ;; @param {i32} firstOffset - The offset of the first string in linear memory.
  ;; @param {i32} firstLength - The length of the first string in linear memory.
  ;; @param {i32} secondOffset - The offset of the second string in linear memory.
  ;; @param {i32} secondLength - The length of the second string in linear memory.
  ;;
  ;; @returns {i32} - The hamming distance between the two strings or -1 if the
  ;;                  strings are not of equal length.
  ;;
  (func (export "compute") 
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    (local $distance i32)
    local.get $firstLength
    i32.eqz
    local.get $secondLength
    i32.eqz
    i32.and
    i32.const 0
    local.get $firstLength
    i32.ne
    i32.const 0
    local.get $secondLength
    i32.ne
    i32.and
    local.get $firstLength
    local.get $secondLength
    i32.eq
    i32.and
    i32.or
    i32.eqz
    if
      i32.const -1
      return
    end
    (block $exit
      (loop $loop
        local.get $firstLength ;; by this point, guaranteed to be same as $secondLength
        i32.eqz
        br_if $exit
        local.get $firstOffset
        i32.load8_u
        local.get $secondOffset
        i32.load8_u
        i32.ne
        local.get $distance
        i32.add
        local.set $distance
        local.get $firstOffset
        i32.const 1
        i32.add
        local.set $firstOffset
        local.get $secondOffset
        i32.const 1
        i32.add
        local.set $secondOffset
        local.get $firstLength
        i32.const 1
        i32.sub
        local.set $firstLength
        br $loop
      )
    )
    local.get $distance
  )
)
