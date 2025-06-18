(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the prime factors of the number
  ;;
  ;; @param {i64} $number
  ;;
  ;; @returns {(i32,i32)} - offset and length of the u32 array of prime factors
  ;;
  (func (export "primeFactors") (param $number i64) (result i32 i32)
    (local $offset i32)
    (local $length i32)
    (local $candidate i64)
    (local $result i64)

    i64.const 2
    local.set $candidate
    local.get $number
    local.set $result

    (block $exit
      (loop $loop
        local.get $result
        i64.const 1
        i64.eq
        br_if $exit

        local.get $result
        local.get $candidate
        i64.rem_u
        i64.eqz
        if
          local.get $result
          local.get $candidate
          i64.div_u 
          local.set $result
          local.get $offset
          local.get $candidate
          i32.wrap_i64
          i32.store

          local.get $offset
          i32.const 4
          i32.add
          local.set $offset
          local.get $length
          i32.const 1
          i32.add
          local.set $length
        else
          local.get $candidate
          i64.const 1
          i64.add
          local.set $candidate
        end
        
        br $loop
      )
    )

    i32.const 0
    local.get $length
  )
)
