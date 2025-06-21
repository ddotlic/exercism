(module
  (import "math" "random" (func $random (result f64)))
  (memory (export "mem") 1)
  (global $namesPos (mut i32) (i32.const 0))


  (func $emit (param $offset i32) (param $magnitude i32) (param $base i32) (result i32)
    local.get $offset
    local.get $magnitude
    f64.convert_i32_u
    call $random
    f64.mul
    i32.trunc_f64_u
    local.get $base
    i32.add
    i32.store8
    local.get $offset
    i32.const 1
    i32.add
  )
  
  (func $emit_char 
    global.get $namesPos
    i32.const 26
    i32.const 65
    call $emit
    global.set $namesPos
  )

  (func $emit_num 
    global.get $namesPos
    i32.const 9
    i32.const 48
    call $emit
    global.set $namesPos
  )

  (func $find_same (param $offset i32) (result i32)
    (local $off1 i32)
    (local $off2 i32)
    (local $count i32)
    (local $found i32)

    block $block
      loop $loop
        local.get $offset
        local.set $off2
        
        i32.const 0
        local.set $count
        block $block2
          loop $loop2
            local.get $count
            i32.const 5
            i32.ge_u
            if
              i32.const 1
              local.set $found
              br $block2
            end

            local.get $count
            local.get $off1
            i32.add
            i32.load8_u
            
            local.get $count
            local.get $off2
            i32.add
            i32.load8_u
            i32.ne
            br_if $block2
            
            i32.const 1
            local.get $count
            i32.add
            local.set $count
            br $loop2
          end
        end
        local.get $found
        i32.const 1
        i32.eq
        br_if $block
        i32.const 5
        local.get $off1
        i32.add
        local.set $off1
        br $loop
      end
    end
    local.get $off1
  )
  ;;
  ;; Generate a new name for a robot, consisting of two uppercase letters and three numbers,
  ;; avoiding already used names
  ;;
  ;; @results {(i32,i32)} - offset and length in linear memory
  ;;
  (func (export "generateName") (result i32 i32)
    (local $offset i32)
    block $block
      loop $loop
        global.get $namesPos
        local.set $offset
        call $emit_char
        call $emit_char
        call $emit_num
        call $emit_num
        call $emit_num
        local.get $offset
        call $find_same
        local.get $offset
        i32.eq
        br_if $block
        local.get $offset
        global.set $namesPos
        br $loop
      end
    end
    local.get $offset
    i32.const 5
  )

  ;;
  ;; Release already used names so that they can be re-used
  ;;
  (func (export "releaseNames")
    i32.const 0
    global.set $namesPos
  )
)
