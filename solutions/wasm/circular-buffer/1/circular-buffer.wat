(module
  ;; Linear memory is allocated one page by default.
  ;; A page is 64KiB, and that can hold up to 16384 i32s.
  ;; We will permit memory to grow to a maximum of four pages.
  ;; The maximum capacity of our buffer is 65536 i32s.
  (memory (export "mem") 1 4)
  ;; Add globals here!
  (global $capacity (mut i32) (i32.const 0))
  (global $size (mut i32) (i32.const 0))
  (global $first (mut i32) (i32.const 0))
  (global $next (mut i32) (i32.const 0))
  
  ;;
  ;; Initialize a circular buffer of i32s with a given capacity
  ;;
  ;; @param {i32} newCapacity - capacity of the circular buffer between 0 and 65,536
  ;;                            in order to fit in four 64KiB WebAssembly pages.
  ;;
  ;; @returns {i32} 0 on success or -1 on error
  ;; 
  (func (export "init") (param $newCapacity i32) (result i32)
    (local $havePages i32)
    (local $needPages i32)
    
    local.get $newCapacity
    i32.const -1
    i32.eq
    if
      i32.const -1
      return
    end

    memory.size
    local.set $havePages
    
    local.get $newCapacity
    i32.const 16384
    i32.div_u
    local.set $needPages
    
    local.get $newCapacity
    i32.const 16384
    i32.rem_u
    i32.const 0
    i32.gt_u
    if
      i32.const 1
      local.get $needPages
      i32.add
      local.set $needPages
    end
    
    local.get $havePages
    local.get $needPages
    i32.lt_u
    if
      local.get $needPages
      local.get $havePages
      i32.sub
      memory.grow
      i32.const -1
      i32.eq
      if
        i32.const -1
        return
      end
    end
    local.get $newCapacity
    global.set $capacity
    call $clear
    i32.const 0
  )

  ;;
  ;; Clear the circular buffer
  ;;
  (func $clear (export "clear")
    i32.const 0
    global.set $size
    i32.const 0
    global.set $first
    i32.const 0
    global.set $next
  )

  ;; 
  ;; Add an element to the circular buffer
  ;;
  ;; @param {i32} elem - element to add to the circular buffer
  ;;
  ;; @returns {i32} 0 on success or -1 if full
  ;;
  (func $write (export "write") (param $elem i32) (result i32)
    global.get $capacity
    i32.eqz
    if
      i32.const -1
      return
    end

    global.get $first
    global.get $next
    i32.eq
    global.get $size
    i32.const 0
    i32.gt_u
    i32.and
    if
      i32.const -1
      return
    end
    global.get $next
    i32.const 2
    i32.shl
    local.get $elem
    i32.store
    global.get $next
    i32.const 1
    i32.add
    global.get $capacity
    i32.rem_u
    global.set $next
    global.get $size
    i32.const 1
    i32.add
    global.set $size
    i32.const 0
  )

  ;; 
  ;; Add an element to the circular buffer, overwriting the oldest element
  ;; if the buffer is full
  ;;
  ;; @param {i32} elem - element to add to the circular buffer
  ;;
  ;; @returns {i32} 0 on success or -1 if full (capacity of zero)
  ;;
  (func (export "forceWrite") (param $elem i32) (result i32)
    global.get $capacity
    i32.eqz
    if
      i32.const -1
      return
    end

    local.get $elem
    call $write
    i32.const -1
    i32.eq
    if ;; actually full
      global.get $next
      i32.const 2
      i32.shl
      local.get $elem
      i32.store
      global.get $next
      i32.const 1
      i32.add
      global.get $capacity
      i32.rem_u
      global.set $next
      global.get $next
      global.set $first 
    end
    
    i32.const 0
  )

  ;;
  ;; Read the oldest element from the circular buffer, if not empty
  ;;
  ;; @returns {i32} element on success or -1 if empty
  ;; @returns {i32} status code set to 0 on success or -1 if empty
  ;;
  (func (export "read") (result i32 i32)
    (local $elem i32)
    global.get $size
    i32.eqz
    if
      i32.const -1
      i32.const -1
      return
    end
    global.get $first
    i32.const 2
    i32.shl
    i32.load
    local.set $elem
    global.get $first
    i32.const 1
    i32.add
    global.get $capacity
    i32.rem_u
    global.set $first
    global.get $size
    i32.const 1
    i32.sub
    global.set $size
    local.get $elem
    i32.const 0
  )
)
