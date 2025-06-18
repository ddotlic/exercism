(module
  (memory (export "mem") 1)

  (data (i32.const 0) "\00\00\00\00\00")
  ;;
  ;; add minutes to a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $increase - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func (export "plus") (param $hour i32) (param $minute i32) (param $increase i32) (result i32 i32)
    local.get $hour  
    local.get $minute
    local.get $increase
    i32.add
  )

  ;;
  ;; remove minutes from a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $decrease - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func (export "minus") (param $hour i32) (param $minute i32) (param $decrease i32) (result i32 i32)
    local.get $hour  
    local.get $minute
    local.get $decrease
    i32.sub
  )

  (func $print (param $digit i32) (param $offset i32)
    local.get $offset
    local.get $digit
    i32.const 48
    i32.add
    i32.store8
  )
  ;;
  ;; formats the clock as "HH:MM" string
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "toString") (param $hour i32) (param $minute i32) (result i32 i32)
    (local $normalizedHour i32)
    (local $normalizedMinute i32)

    local.get $minute
    call $extra
    local.get $hour
    i32.add
    i32.const 24
    call $normalize
    
    local.set $normalizedHour
    local.get $minute
    i32.const 60
    call $normalize
    local.set $normalizedMinute
    
    local.get $normalizedHour
    i32.const 10
    i32.div_u
    i32.const 0
    call $print
    local.get $normalizedHour
    i32.const 10
    i32.rem_u
    i32.const 1
    call $print

    i32.const 2
    i32.const 58
    i32.store8

    local.get $normalizedMinute
    i32.const 10
    i32.div_u
    i32.const 3
    call $print
    local.get $normalizedMinute
    i32.const 10
    i32.rem_u
    i32.const 4
    call $print

    i32.const 0
    i32.const 5
  )

  (func $normalize (param $value i32) (param $max i32) (result i32)
    (local $result i32)
    local.get $value
    local.get $max
    i32.rem_s
    local.tee $result
    i32.const 0
    i32.lt_s
    if (result i32)
      local.get $max
      local.get $result
      i32.add
    else
      local.get $result
    end
  )
  
  (func $extra (param $minute i32) (result i32)
    local.get $minute
    i32.const 60
    i32.div_s
    i32.const 24
    i32.rem_s
    local.get $minute
    i32.const 0
    i32.lt_s
    local.get $minute
    i32.const 60
    i32.rem_s
    i32.const 0
    i32.ne
    i32.and
    if (result i32)
      i32.const -1
      else
      i32.const 0
    end
    i32.add
  )
  ;;
  ;; checks if two clocks show the same time
  ;;
  ;; @param {i32} $hourA - the hours on the first clock
  ;; @param {i32} $minuteA - the minutes on the first clock
  ;; @param {i32} $hourB - the hours on the second clock
  ;; @param {i32} $minuteB - the minutes on the second clock
  ;;
  ;; @returns {i32} - 1 if they are equal, 0 if not
  ;;
  (func (export "equals") (param $hourA i32) (param $minuteA i32)
    (param $hourB i32) (param $minuteB i32) (result i32)
    local.get $minuteA
    call $extra
    local.get $hourA
    i32.add
    i32.const 24
    call $normalize
    local.get $minuteB
    call $extra
    local.get $hourB
    i32.add
    i32.const 24
    call $normalize
    i32.eq
    local.get $minuteA
    i32.const 60
    call $normalize
    local.get $minuteB
    i32.const 60
    call $normalize
    i32.eq
    i32.and
  )
)
