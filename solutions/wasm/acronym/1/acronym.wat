(module
  (memory (export "mem") 1)

  (data (i32.const 64) "Portable Network Graphics") ;; PNG
  (data (i32.const 200) "                                        ");;

  ;; Converts a phrase into an acronym
  ;; i.e. "Ruby on Rails" -> "ROR"
  ;;
  ;; @param {i32} offset - offset of phrase in linear memory
  ;; @param {i32} length - length of phrase in linear memory
  ;;
  ;; @return {(i32, i32)} - offset and length of acronym
  ;;
  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    (local $acronymLen i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $first i32)

    i32.const  1
    local.set $first

    local.get $offset
    local.set $off
    local.get $length
    local.set $len

    (block $block
      (loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char

        i32.const 65
        i32.ge_u
        local.get $char
        i32.const 90
        i32.le_u
        i32.and
        local.get $char
        i32.const 97
        i32.ge_u
        local.get $char
        i32.const 122
        i32.le_u
        i32.and
        local.get $char
        i32.const 39 ;; value of apostrophe
        i32.eq
        i32.or
        i32.or
        if
          local.get $first
          i32.const 1
          i32.eq
          if
            local.get $char
            i32.const 97
            i32.ge_u
            if
              local.get $char
              i32.const 32
              i32.sub
              local.set $char
            end
            i32.const 200
            local.get $acronymLen
            i32.add
            local.get $char
            i32.store8
            i32.const 1
            local.get $acronymLen
            i32.add
            local.set $acronymLen

            i32.const 0
            local.set $first
          end
        else
          i32.const 1
          local.set $first
        end

        local.get $off
        i32.const 1
        i32.add
        local.set $off
        local.get $len
        i32.const 1
        i32.sub
        local.set $len

        br $loop
      )
    )
    i32.const 200
    local.get $acronymLen
  )
)
