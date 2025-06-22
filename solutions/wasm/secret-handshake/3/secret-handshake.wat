(module
  (memory (export "mem") 1)

  (data (i32.const 300) "\02, ")
  (data (i32.const 400) "\04wink")
  (data (i32.const 420) "\0cdouble blink")
  (data (i32.const 440) "\0fclose your eyes")
  (data (i32.const 460) "\04jump")

  (func $print_string (param $source i32) (param $dest i32) (result i32)
    (local $count i32)
    
    local.get $source
    i32.load8_u
    local.set $count
    
    local.get $dest
    
    local.get $source
    i32.const 1
    i32.add

    local.get $count
    memory.copy

    local.get $count
    local.get $dest
    i32.add
  )
  ;;
  ;; Output the list of commands to perform the secret handshake as a string, using a comma and a space as separators.
  ;;
  ;; @param {i32} number - the secret number that defines the handshake
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "commands") (param $number i32) (result i32 i32)
    (local $first i32)
    (local $offset i32)
    (local $inc i32)
    (local $pos i32)
    (local $counter i32)

    local.get $number
    i32.const 16
    i32.and
    i32.eqz
    if
      i32.const 0
      local.set $pos
      i32.const 1
      local.set $inc
    else
      i32.const 3
      local.set $pos
      i32.const -1
      local.set $inc
    end

    i32.const 4
    local.set $counter
    block $block
      loop $loop
        local.get $counter
        i32.eqz
        br_if $block

        i32.const 1
        local.get $pos
        i32.shl
        local.get $number
        i32.and
        i32.eqz
        if
        else
          local.get $first
          i32.eqz
          if
            i32.const 1
            local.set $first
          else
            i32.const 300
            local.get $offset
            call $print_string
            local.set $offset
          end
          local.get $pos
          i32.const 20
          i32.mul
          i32.const 400
          i32.add
          local.get $offset
          call $print_string
          local.set $offset
        end
        
        local.get $pos
        local.get $inc
        i32.add
        local.set $pos

        local.get $counter
        i32.const 1
        i32.sub
        local.set $counter
        br $loop
      end
    end
    
    i32.const 0
    local.get $offset

  )
)
