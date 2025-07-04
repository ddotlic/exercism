(module
  (memory (export "mem") 1)
  (global $rows (mut i32)  (i32.const 1))
  (global $cols (mut i32)  (i32.const 1))
  (global $nl i32  (i32.const 10))
  (global $spc i32  (i32.const 32))
  (global $storage i32 (i32.const 200))
  (data (i32.const 400) "3 1 3\0a3 2 4")
  ;;
  ;; Find the points in the matrix that are the largest in row and smallest in column
  ;;
  ;; @param {i32} $inputOffset - offset of the matrix in linear memory
  ;; @param {i32} $inputLength - length of the matrix in linear memory
  ;;
  ;; @result {(i32,i32)} - offset and length of row-column-pairs in linear memory
  ;;
  (func (export "saddlePoints") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $offset i32)
    (local $store i32)
    (local $char i32)

    local.get $inputOffset
    local.set $offset

    global.get $storage
    local.set $store

    block $block
      loop $loop
        local.get $offset
        local.get $inputOffset
        i32.sub
        local.get $inputLength
        i32.ge_u
        br_if $block

        local.get $offset
        i32.load8_u
        local.tee $char

        global.get $nl
        i32.eq
        if
          global.get $rows
          i32.const 1
          i32.add
          global.set $rows
        else
          local.get $char
          global.get $spc
          i32.eq
          if
            global.get $rows
            i32.const 1
            i32.eq
            if
              global.get $cols
              i32.const 1
              i32.add
              global.set $cols
            end
          else
            local.get $store
            local.get $char
            i32.const 48
            i32.sub
            i32.store8
            local.get $store
            i32.const 1
            i32.add
            local.set $store
          end
        end
        
        local.get $offset
        i32.const 1
        i32.add
        local.set $offset

        br $loop
      end
    end
    
    i32.const 0
    i32.const 0
  ) 
)
