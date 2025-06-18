(module
  ;;
  ;; Calculate the square of the sum of the first N natural numbers
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} The square of the sum of the first N natural numbers
  ;;
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (local $result i32)

    block $block
      loop $loop
        local.get $max
        i32.eqz
        br_if $block

        local.get $max
        local.get $result
        i32.add
        local.set $result

        local.get $max
        i32.const 1
        i32.sub
        local.set $max
      br $loop
      end
    end

    local.get $result
    local.get $result
    i32.mul
  )

  ;;
  ;; Calculate the sum of the squares of the first N natural numbers
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} The sum of the squares of the first N natural numbers
  ;;
  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
     (local $result i32)

    block $block
      loop $loop
        local.get $max
        i32.eqz
        br_if $block

        local.get $max
        local.get $max
        i32.mul
        local.get $result
        i32.add
        local.set $result

        local.get $max
        i32.const 1
        i32.sub
        local.set $max
      br $loop
      end
    end
    local.get $result
  )

  ;;
  ;; Calculate the difference between the square of the sum and the sum of the 
  ;; squares of the first N natural numbers.
  ;;
  ;; @param {i32} max - The upper bound (inclusive) of natural numbers to consider
  ;;
  ;; @returns {i32} Difference between the square of the sum and the sum of the
  ;;                squares of the first N natural numbers.
  ;;
  (func (export "difference") (param $max i32) (result i32)
    local.get $max
    call $squareOfSum
    local.get $max
    call $sumOfSquares
    i32.sub
  )
)
