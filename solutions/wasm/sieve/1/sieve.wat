(module
  (memory (export "mem") 1)

  ;;
  ;; Determine all the prime numbers below a given limit.
  ;; Return the offset and length of the resulting array of primes.
  ;;
  ;; @param {i32} limit - the upper bound for the prime numbers
  ;;
  ;; @return {i32} - offset off the u32[] array
  ;; @return {i32} - length off the u32[] array in elements
  ;;
  (func (export "primes") (param $limit i32) (result i32 i32)
    (local $num i32)
    (local $mul i32)
    (local $offset i32)

    local.get $limit
    i32.const 2
    i32.lt_u
    if
      i32.const 1024
      i32.const 0
      return
    end

    i32.const 2
    local.set $num

    block $block
      loop $loop
        local.get $num
        local.get $limit
        i32.gt_u
        br_if $block
        
        local.get $num
        i32.load8_u
        i32.eqz
        if
          local.get $num
          local.get $num
          i32.add
          local.set $mul

          block $block1
            loop $loop1
              local.get $mul
              local.get $limit
              i32.gt_u
              br_if $block1

              local.get $mul
              i32.const 1
              i32.store8

              local.get $mul
              local.get $num
              i32.add
              local.set $mul

              br $loop1
            end
          end
        end
        
        local.get $num
        i32.const 1
        i32.add
        local.set $num

        br $loop
      end
    end

    i32.const 1024
    local.set $offset

    i32.const 2
    local.set $num

    block $block2
      loop $loop2
        local.get $num
        local.get $limit
        i32.gt_u
        br_if $block2

        local.get $num
        i32.load8_u
        i32.eqz
        if
          local.get $offset
          local.get $num
          i32.store
          local.get $offset
          i32.const 4
          i32.add
          local.set $offset
        end

        local.get $num
        i32.const 1
        i32.add
        local.set $num

        br $loop2
      end
    end

    i32.const 1024
    local.get $offset
    i32.const 1024
    i32.sub
    i32.const 2
    i32.shr_u
  )
)
