(module
  (memory 2)
  (global $max i32 (i32.const 115_000))

  (func $findNext (param $last i32) (result i32)
    (local $k i32)
    local.get $last
    i32.const 1
    i32.add
    local.set $k

    block $block
      loop $loop
        local.get $k
        global.get $max
        i32.ge_u
        br_if $block ;; effectively we fail if we reach this, but we won't since we carefully picked max

        local.get $k
        i32.load8_u
        i32.const 1
        i32.eq
        br_if $block

        local.get $k
        i32.const 1
        i32.add
        local.set $k
        br $loop
      end
    end
    local.get $k
  )

  (func $sieve (param $num i32)
    (local $j i32)
    (local $step i32)

    i32.const 2
    local.set $j

    block $block
      loop $loop
        local.get $j
        local.get $num
        i32.mul
        local.tee $step
        global.get $max
        i32.ge_u
        br_if $block

        local.get $step
        i32.const 0
        i32.store8

        local.get $j
        i32.const 1
        i32.add
        local.set $j
        br $loop
      end
    end
  )
  ;;
  ;; nth_prime - return the nth prime for n > 0
  ;;
  ;; @param {i32} $n - index of the returned prime
  ;;
  ;; @returns {i32} - the $nth prime
  ;;
  (func (export "prime") (param $n i32) (result i32)
    (local $res i32)
    (local $ix i32)

    i32.const 2
    i32.const 1
    global.get $max
    memory.fill

    i32.const 1
    local.set $ix

    i32.const 2
    local.set $res

    block $block
      loop $loop
        local.get $ix
        local.get $n
        i32.eq
        br_if $block
        local.get $res
        call $sieve
        local.get $res
        call $findNext
        local.set $res

        local.get $ix
        i32.const 1
        i32.add
        local.set $ix

        br $loop
      end
    end

    local.get $res
  )
)
