(module
  (memory  1)

  (data (i32.const 0) "") ;; queue of states as i32 packed bytes (b1, b2, actions, 0) 
  (data (i32.const 1024) "") ;; visited states, as i16 packed bytes (b1, b2)

  (global $queueHead (mut i32) (i32.const 0))
  (global $queueTail (mut i32) (i32.const 0))
  (global $statesTail (mut i32) (i32.const 1024))

  (global $bucket1Capacity (mut i32) (i32.const 0))
  (global $bucket2Capacity (mut i32) (i32.const 0))
  (global $initialBucket (mut i32) (i32.const 0))
  (global $desiredVolume (mut i32) (i32.const 0))

  (func $pack (param $b1 i32) (param $b2 i32) (param $actions i32) (result i32)
    local.get $actions
    i32.const 16
    i32.shl
    local.get $b2
    i32.const 8
    i32.shl
    local.get $b1
    i32.or
    i32.or
  )

  (func $unpack (param $packed i32) (result i32 i32 i32)
    i32.const 0xff
    local.get $packed
    i32.and
    local.get $packed
    i32.const 8
    i32.shr_u
    i32.const 0xff
    i32.and
    local.get $packed
    i32.const 16
    i32.shr_u
  )

  (func $pushSeen (param $packed i32)
    global.get $statesTail
    local.get $packed
    i32.const 0xffff
    i32.and    
    i32.store16
    global.get $statesTail
    i32.const 2
    i32.add
    global.set $statesTail
  )

  (func $seen (param $packed i32) (result i32)
    (local $states i32)
    (local $found i32)
    (local $state i32)

    local.get $packed
    i32.const 0xffff
    i32.and
    local.set $state

    i32.const 1024
    local.set $states

    block $block
      loop $loop
        local.get $states
        global.get $statesTail
        i32.eq
        br_if $block

        local.get $states
        i32.load16_u
        local.get $state
        i32.eq
        if
          i32.const 1
          local.set $found
          br $block
        end

        local.get $states
        i32.const 2
        i32.add
        local.set $states

        br $loop
      end
    end

    local.get $found
  )

  (func $enqueue (param $packed i32)
    global.get $queueTail
    local.get $packed
    i32.store
    global.get $queueTail
    i32.const 4
    i32.add
    global.set $queueTail
  )

  (func $isQueueEmpty (result i32)
    global.get $queueHead
    global.get $queueTail
    i32.eq
  )

  (func $dequeue (result i32)
    (local $result i32)
    global.get $queueHead
    i32.load
    local.set $result
    global.get $queueHead
    i32.const 4
    i32.add
    global.set $queueHead
    local.get $result    
  )

  (func $isResult (param $packed i32) (result i32)
    (local $b1 i32)
    (local $b2 i32)

    local.get $packed
    call $unpack
    drop
    local.set $b2
    local.tee $b1
    global.get $desiredVolume
    i32.eq
    local.get $b2
    global.get $desiredVolume
    i32.eq
    i32.or
  )

  (func $enqueueIfValidAndNotSeen (param $state i32)
    (local $b1Level i32)
    (local $b2Level i32)

    local.get $state
    call $unpack
    drop
    local.set $b2Level
    local.set $b1Level

    global.get $initialBucket
    i32.const 2
    i32.eq
    if (result i32 i32)
      local.get $b2Level
      i32.eqz
      global.get $bucket1Capacity
      local.get $b1Level
      i32.eq
    else
      local.get $b1Level
      i32.eqz
      global.get $bucket2Capacity
      local.get $b2Level
      i32.eq
    end
    i32.and
    if
      return ;; invalid state, initial bucket is empty and the other is full
    end

    local.get $state
    call $seen
    i32.eqz
    if
      local.get $state
      call $enqueue
      local.get $state
      call $pushSeen
    end
  )

  ;;
  ;; Get to the goal using two buckets
  ;;
  ;; @param {i32} $bucketOne - capacity of the first bucket
  ;; @param {i32} $bucketTwo - capacity of the second bucket
  ;; @param {i32} $goal - level to achieve by filling / emptying the buckets
  ;; @param {i32} $starterBucket - bucket to start with (1 / 2)
  ;;
  ;; @returns {(i32,i32,i32)} number of moves, winning bucket, level of other bucket;
  ;;                          if unsolvable, make sure moves is -1
  ;;
  (func (export "twoBucket") (param $bucketOne i32) (param $bucketTwo i32)
  (param $goal i32) (param $starterBucket i32) (result i32 i32 i32)
    (local $bucket1Level i32)
    (local $bucket2Level i32)
    (local $actions i32)
    (local $candidate i32)
    (local $found i32)
    (local $state i32)
    (local $transfer i32)

    local.get $bucketOne
    global.set $bucket1Capacity
    local.get $bucketTwo
    global.set $bucket2Capacity
    local.get $starterBucket
    global.set $initialBucket
    local.get $goal
    global.set $desiredVolume

    ;; first, let's eliminate the impossible case
    
    global.get $desiredVolume
    global.get $bucket1Capacity
    i32.gt_u
    global.get $desiredVolume
    global.get $bucket2Capacity
    i32.gt_u
    i32.and
    if
      i32.const -1
      i32.const 0
      i32.const 0
      return
    end

    global.get $initialBucket
    i32.const 2
    i32.eq
    if
      global.get $bucket2Capacity
      local.set $bucket2Level
    else
      global.get $bucket1Capacity
      local.set $bucket1Level
    end
    
    

    local.get $bucket1Level
    local.get $bucket2Level
    i32.const 1
    call $pack
    call $enqueueIfValidAndNotSeen ;; initial action is that starter bucket is full

    block $block
      loop $loop
        
        call $isQueueEmpty
        br_if $block
        
        call $dequeue
        local.tee $candidate
        call $isResult
        if
          i32.const 1
          local.set $found
          br $block
        end

        ;; generate all next states, skipping forbidden one (empty starting bucket while the other bucket is full) and already seen ones
        
        ;; deconstruct the current state
        local.get $candidate
        call $unpack
        local.set $actions
        local.set $bucket2Level
        local.set $bucket1Level
        
        local.get $actions
        i32.const 1
        i32.add
        local.set $actions

        ;; fill bucket 1
        global.get $bucket1Capacity
        local.get $bucket2Level
        local.get $actions
        call $pack
        local.tee $state 
        call $enqueueIfValidAndNotSeen
        
        ;; fill bucket 2
        local.get $bucket1Level
        global.get $bucket2Capacity
        local.get $actions
        call $pack
        local.tee $state 
        call $enqueueIfValidAndNotSeen

        ;; empty bucket 1
        
        i32.const 0
        local.get $bucket2Level
        local.get $actions
        call $pack
        local.tee $state
        call $enqueueIfValidAndNotSeen

        ;; empty bucket 2, if possible (not the starter bucket)
        local.get $bucket1Level
        i32.const 0
        local.get $actions
        call $pack
        local.tee $state
        call $enqueueIfValidAndNotSeen

        ;; pour from 1 to 2
        global.get $bucket2Capacity
        local.get $bucket2Level
        i32.sub
        local.tee $transfer
        local.get $bucket1Level
        i32.gt_u
        if
          local.get $bucket1Level
          local.set $transfer
        end
        local.get $bucket1Level
        local.get $transfer
        i32.sub
        local.get $bucket2Level
        local.get $transfer
        i32.add
        local.get $actions
        call $pack
        local.tee $state
        call $enqueueIfValidAndNotSeen

        ;; pour from 2 to 1

        global.get $bucket1Capacity
        local.get $bucket1Level
        i32.sub
        local.tee $transfer
        local.get $bucket2Level
        i32.gt_u
        if
          local.get $bucket2Level
          local.set $transfer
        end
        local.get $bucket1Level
        local.get $transfer
        i32.add
        local.get $bucket2Level
        local.get $transfer
        i32.sub
        local.get $actions
        call $pack
        local.tee $state
        call $enqueueIfValidAndNotSeen

        br $loop
      end
    end

    local.get $found
    if (result i32 i32 i32)
      local.get $candidate
      call $unpack
      local.set $actions
      local.set $bucket2Level
      local.set $bucket1Level
      local.get $actions
      local.get $bucket2Level
      local.get $goal
      i32.eq
      if (result i32 i32)
        i32.const 2
        local.get $bucket1Level
      else
        i32.const 1
        local.get $bucket2Level
      end
    else
      i32.const -1
      i32.const 0
      i32.const 0
    end

  )
)
