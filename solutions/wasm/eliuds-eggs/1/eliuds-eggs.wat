(module
  ;;
  ;; count the number of 1 bits in the binary representation of a number
  ;;
  ;; @param {i32} number - the number to count the bits of
  ;;
  ;; @returns {i32} the number of 1 bits in the binary representation of the number
  ;;
  (func (export "eggCount") (param $number i32) (result i32)
    (local $num i32)
    (local $count i32)

    local.get $number
    local.set $num

    block $block
      loop $loop

        local.get $num
        i32.eqz
        br_if $block

        local.get $num
        i32.const 1
        i32.and
        local.get $count
        i32.add
        local.set $count

        local.get $num
        i32.const 1
        i32.shr_u
        local.set $num
        
        br $loop
      end
    end

    local.get $count
  )
)
