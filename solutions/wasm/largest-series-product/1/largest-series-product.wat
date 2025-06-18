(module
  (memory (export "mem") 1)

  ;;
  ;; Calculate the largest product for a contiguous substring of digits of length n.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} largest digit product
  ;;
  (func (export "largestProduct") (param $offset i32) (param $length i32) (param $span i32) (result i32)
    (local $off1 i32)
    (local $off2 i32)
    (local $off i32)
    (local $char i32)
    (local $end i32)
    (local $sp i32)
    (local $product i32)
    (local $result i32)
    (local $err i32)

    local.get $span
    i32.const 0
    i32.lt_s
    local.get $span
    local.get $length
    i32.gt_s
    i32.or
    if
      i32.const -1
      return
    end

    local.get $span
    i32.eqz
    if
      i32.const 1
      return
    end

    local.get $offset
    local.set $off1
    local.get $offset
    local.get $span
    i32.add
    local.set $off2
    local.get $offset
    local.get $length
    i32.add
    i32.const 1
    i32.add
    local.set $end

    block $block1
      loop $loop1

        local.get $off2
        local.get $end
        i32.eq
        br_if $block1

        i32.const 1
        local.set $product
        local.get $off1
        local.set $off

        block $block2
          loop $loop2
            local.get $off
            local.get $off2
            i32.eq
            br_if $block2
            
            local.get $off
            i32.load8_u
            local.tee $char
            i32.const 48
            i32.ge_u
            local.get $char
            i32.const 57
            i32.le_u
            i32.and
            if
              local.get $char
              i32.const 48
              i32.sub
              local.get $product
              i32.mul
              local.set $product
            else
              i32.const -1
              local.set $err
              br $block2
            end

            local.get $off
            i32.const 1
            i32.add
            local.set $off

            br $loop2
          end
        end

        local.get $product
        local.get $result
        i32.gt_u
        if
          local.get $product
          local.set $result
        end

        local.get $off1
        i32.const 1
        i32.add
        local.set $off1
        local.get $off2
        i32.const 1
        i32.add
        local.set $off2

        br $loop1
      end
    end

    local.get $err
    i32.eqz
    if (result i32)
      local.get $result
    else
      local.get $err
    end
  )
)
