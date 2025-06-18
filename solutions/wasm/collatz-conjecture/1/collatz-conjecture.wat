(module
  ;;
  ;; Return the number of steps needed to reach 1 in the Collatz conjecture.
  ;;
  ;; @param {i32} number - The number to start from.
  ;;
  ;; @returns {i32} - The number of steps needed to reach 1.
  ;;
  (func (export "steps") (param $number i32) (result i32)
    (local $num i32)
    (local $steps i32)

    local.get $number
    i32.const 0
    i32.le_s
    if
      i32.const -1
      return
    end

    i32.const 0
    local.set $steps

    local.get $number
    local.set $num

    block $block
      loop $loop
        local.get $num
        i32.const 1
        i32.eq
        br_if $block

        local.get $num
        i32.const 1
        i32.and
        if
          local.get $num
          i32.const 3
          i32.mul
          i32.const 1
          i32.add
          local.set $num
        else
          local.get $num
          i32.const 2
          i32.div_u
          local.set $num
        end

        local.get $steps
        i32.const 1
        i32.add
        local.set $steps
        
        br $loop
      end
    end

    local.get $steps
  )
)
