(module
  (memory (export "mem") 1)

  (global $max (mut i32) (i32.const 0))
  (global $currentLen (mut i32) (i32.const 0))
  (global $items (mut i32) (i32.const 0))
  (global $capacity (mut i32) (i32.const 0))

  (data (i32.const 256) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00") ;; combination indices
  
  (func $getMax
    (local $totalWeight i32)
    (local $totalValue i32)
    (local $j i32)
    (local $index i32)

    block $block
      loop $loop
        local.get $j
        global.get $currentLen
        i32.eq
        br_if $block

        local.get $j
        i32.const 256
        i32.add
        i32.load8_u
        local.set $index

        local.get $index
        i32.const 8
        i32.mul
        local.tee $index
        i32.load
        local.get $totalWeight
        i32.add
        local.set $totalWeight
        local.get $index
        i32.const 4
        i32.add
        i32.load
        local.get $totalValue
        i32.add
        local.set $totalValue

        local.get $j
        i32.const 1
        i32.add
        local.set $j

        br $loop
      end
    end

    local.get $totalWeight
    global.get $capacity
    i32.le_u
    global.get $max
    local.get $totalValue
    i32.lt_u
    i32.and
    if
      local.get $totalValue
      global.set $max
    end
  )
 
  (func $backtrack (param $start i32) (param $k i32)
    (local $i i32)

    local.get $k
    global.get $currentLen
    i32.eq
    if
      call $getMax
      return
    end

    local.get $start
    local.set $i
    block $block
      loop $loop
        local.get $i
        global.get $items
        i32.eq
        br_if $block

        global.get $currentLen
        i32.const 256
        i32.add
        local.get $i
        i32.store8
        global.get $currentLen
        i32.const 1
        i32.add
        global.set $currentLen
        local.get $i
        i32.const 1
        i32.add
        local.get $k
        call $backtrack
  
        global.get $currentLen
        i32.const 1
        i32.sub
        global.set $currentLen

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end
  )

  ;; Determine the maximum total value that can be carried
  ;;
  ;; @param {i32} itemsCount - The number of items
  ;; @param {i32} capacity - How much weight the knapsack can carry
  ;; @returns {i32} the maximum value
  ;;
  (func (export "maximumValue") (param $itemsCount i32) (param $capacityCount i32) (result i32)
    (local $n i32)
    (local $k i32)

    local.get $itemsCount
    global.set $items
    local.get $capacityCount
    global.set $capacity
    
    local.get $itemsCount
    i32.const 1
    i32.add
    local.set $n

    i32.const 1
    local.set $k

    block $block
      loop $loop
        local.get $k
        local.get $n
        i32.eq
        br_if $block

        i32.const 0
        global.set $currentLen
        i32.const 0
        local.get $k
        call $backtrack

        local.get $k
        i32.const 1
        i32.add
        local.set $k

        br $loop
      end
    end

    global.get $max
  )
)
