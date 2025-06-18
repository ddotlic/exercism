(module
  (memory (export "mem") 1)
  (data (i32.const 330) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")

  (global $lbrace i32 (i32.const 123))
  (global $rbrace i32 (i32.const 125))
  (global $lbracket i32 (i32.const 91))
  (global $rbracket i32 (i32.const 93))
  (global $quotes i32 (i32.const 34))
  (global $comma i32 (i32.const 44))
  (global $colon i32 (i32.const 58))
  
  ;;
  ;; Rewrite the incoming JSON to the new ETL format
  ;;
  ;; @param {i32} $inputOffset - offset of the JSON input in linear memory
  ;; @param {i32} $inputLength - length of the JSON input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the JSON output in linear memory
  ;;

  (func $readChar (param $offset i32) (param $expected i32) (result i32)
      
    local.get $offset
    i32.load8_s
    local.get $expected
    i32.ne
    if
      unreachable
    end
    local.get $offset
    i32.const 1
    i32.add
  )

  (func $writeChar (param $offset i32) (param $char i32) (result i32)
    local.get $offset
    local.get $char
    i32.store8
    local.get $offset
    i32.const 1
    i32.add
  )

  (func (export "transform") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $outputOffset i32)
    (local $map i32)
    (local $offset i32)
    (local $end i32)
    (local $key i32)
    (local $value i32)
    (local $first i32)

    local.get $inputOffset
    local.tee $offset
    local.get $inputLength
    i32.add
    local.set $end
    
    block $obj_blk
      loop $obj_loop
        local.get $offset
        global.get $lbrace
        call $readChar
        local.set $offset
        block $entry_blk
          loop $entry_loop
          local.get $offset
          global.get $quotes
          call $readChar ;; '"' key start quotes
          local.tee $offset
          i32.load8_u ;; key, a number
          i32.const 48
          i32.sub
          local.set $key
          local.get $offset
          i32.const 1
          i32.add
          local.tee $offset
          ;; check if key has two digits
          i32.load8_u
          global.get $quotes
          i32.ne
          if
            i32.const 10
            local.set $key ;; only possible case is '10'
            local.get $offset
            i32.const 1
            i32.add
            local.set $offset
          end
          local.get $offset
          global.get $quotes
          call $readChar ;; '"' key end quotes
          local.tee $offset
          global.get $colon
          call $readChar ;; ':' colon
          local.tee $offset
          global.get $lbracket
          call $readChar ;; '[' values left bracket
          local.set $offset
          block $value_blk
            loop $value_loop
              local.get $offset
              global.get $quotes ;; '"' value start quotes
              call $readChar
              local.tee $offset
              i32.load8_u
              i32.const 65 ;; 'A'
              i32.sub
              i32.const 330
              i32.add
              local.get $key
              i32.store8
              local.get $offset
              i32.const 1
              i32.add
              local.tee $offset
              global.get $quotes ;; '"' value end quotes
              call $readChar
              local.tee $offset
              i32.load8_u
              global.get $comma
              i32.eq
              if
                i32.const 1
                local.get $offset
                i32.add
                local.set $offset
                br $value_loop
              else
                br $value_blk
              end
            end
          end
          
          local.get $offset
          global.get $rbracket
          call $readChar ;; ']' values right bracket 
          local.tee $offset
          i32.load8_u
          global.get $comma
          i32.eq
          if
            i32.const 1
            local.get $offset
            i32.add
            local.set $offset
            br $entry_loop
          else
            br $entry_blk
          end
          end
        end
        local.get $offset
        global.get $rbrace
        call $readChar
        local.tee $offset
        local.get $end
        i32.eq
        br_if $obj_blk
        unreachable
      end
    end

    ;; now, output the result
    i32.const 400
    local.tee $outputOffset

    global.get $lbrace
    call $writeChar
    local.set $outputOffset

    i32.const 330
    local.set $map
    block $out_blk
      loop $out_loop
        local.get $map
        i32.const 356
        i32.ge_u
        br_if $out_blk
        local.get $map
        i32.load8_u
        local.tee $value
        i32.const 0
        i32.gt_u
        if
          local.get $first
          i32.eqz
          if
            i32.const 1
            local.set $first
          else
            local.get $outputOffset
            global.get $comma
            call $writeChar
            local.set $outputOffset
          end
          local.get $outputOffset
          global.get $quotes
          call $writeChar
          local.tee $outputOffset
          local.get $map
          i32.const 330
          i32.sub
          i32.const 97
          i32.add
          call $writeChar
          local.tee $outputOffset
          global.get $quotes
          call $writeChar
          local.tee $outputOffset
          global.get $colon
          call $writeChar
          local.set $outputOffset
          local.get $value
          i32.const 10
          i32.eq
          if
            local.get $outputOffset
            i32.const 49
            call $writeChar
            local.tee $outputOffset
            i32.const 48
            call $writeChar
            local.set $outputOffset
          else
            local.get $outputOffset
            local.get $value
            i32.const 48
            i32.add
            call $writeChar
            local.set $outputOffset
          end
        end
        local.get $map
        i32.const 1
        i32.add
        local.set $map
        br $out_loop
      end
    end

    local.get $outputOffset
    global.get $rbrace
    call $writeChar
    local.set $outputOffset

    i32.const 400
    local.get $outputOffset
    i32.const 400
    i32.sub
  )
)
