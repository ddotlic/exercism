(module
  (memory (export "mem") 1)

  ;;
  ;; Convert a string of DNA to RNA
  ;;
  ;; @param {i32} offset - The offset of the DNA string in linear memory
  ;; @param {i32} length - The length of the DNA string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the RNA string in linear memory
  ;;
  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    block $block
      loop $loop

      local.get $len
      i32.eqz
      br_if $block

      local.get $off

      local.get $off
      i32.load8_u
      local.tee $char
      i32.const 67
      i32.eq
      if (result i32)
        i32.const 71
      else
        local.get $char
        i32.const 71
        i32.eq
        if (result i32)
          i32.const 67
        else
          local.get $char
          i32.const 84
          i32.eq
          if (result i32)
            i32.const 65
          else
            local.get $char
            i32.const 65
            i32.eq
            if (result i32)
              i32.const 85
            else
              i32.const 0 ;; should be unreachable
            end
          end
        end
      end

      i32.store8

      local.get $off
      i32.const 1
      i32.add
      local.set $off
      local.get $len
      i32.const 1
      i32.sub
      local.set $len

      br $loop
      end
    end

    local.get $offset
    local.get $length
  )
)
