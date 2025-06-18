(module
  (func $pow (param $num i32) (param $exp i32) (result i32)
    (local $result i32)
    (local $number i32)
    (local $exponent i32)

    (local.get $num)
    (local.set $number)
    (local.get $exp)
    (local.set $exponent)
    (i32.const 1)
    (local.set $result)

    (block $exit
      (loop $loop
        (local.get $exponent)
        (i32.eqz)
        (br_if $exit)

        (local.get $exponent)
        (i32.const 1)
        (i32.and)
        (if 
          (then 
            (local.get $result)
            (local.get $number)
            (i32.mul)
            (local.set $result)
          )
        )

        (local.get $number)
        (local.get $number)
        (i32.mul)
        (local.set $number)

        (local.get $exponent)
        (i32.const 2)
        (i32.div_s)
        (local.set $exponent)

        (br $loop)
      )
    )
    (local.get $result)
  )

  (func $digits (param $candidate i32) (result i32)
    (local $result i32)
    (i32.const 1)
    (local.set $result)
    (block $exit
      (loop $loop
        

        (local.get $candidate)
        (i32.const 10)
        (i32.div_s)
        (local.set $candidate)

        (local.get $candidate)
        (i32.eqz)
        (br_if $exit)

        (local.get $result)
        (i32.const 1)
        (i32.add)
        (local.set $result)

        (br $loop)
      )
    )
    (local.get $result)
  )
  ;; 
  ;; Determine if a number is an Armstrong number.
  ;;
  ;; @param {i32} candidate - The number to check.
  ;;
  ;; @return {i32} 1 if the number is an Armstrong number, 0 otherwise.
  ;;
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $sum i32)
    (local $result i32)
    (local $digit i32)
    (local $exp i32)
    (local.get $candidate)
    (call $digits)
    (local.set $exp)
    (local.get $candidate)
    (local.set $result)
    (block $exit
      (loop $loop
        (local.get $result)
        (i32.eqz)
        (br_if $exit)

        (local.get $result)
        (i32.const 10)
        (i32.rem_s)
        (local.get $exp)
        (call $pow)

        (local.get $sum)
        (i32.add)
        (local.set $sum)

        (local.get $result)
        (i32.const 10)
        (i32.div_s)
        (local.set $result)
        (br $loop)
      )
    )
    (local.get $sum)
    (local.get $candidate)
    (i32.eq)
  )
)
