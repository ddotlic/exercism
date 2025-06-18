(module
  (memory (export "mem") 1)

  (global $rows (mut i32) (i32.const 0))
  (global $cols (mut i32) (i32.const 0))
  (global $board (mut i32) (i32.const 0))
  

  (func $getOffset (param $row i32) (param $col i32) (result i32)
    (local $cols i32)

    local.get $row
    i32.const 0
    i32.lt_s
    local.get $row
    global.get $rows
    i32.eq
    i32.or
    local.get $col
    i32.const 0
    i32.lt_s
    local.get $col
    global.get $cols
    i32.eq
    i32.or
    i32.or

    if (result i32)
      i32.const 0
    else
      local.get $row
      global.get $cols
      i32.const 1 ;; newline
      i32.add
      i32.mul
      local.get $col
      i32.add
      global.get $board
      i32.add
    end
  )

  (func $hasMine (param $row i32) (param $col i32) (result i32)
    (local $offset i32)

    local.get $row
    local.get $col
    call $getOffset
    local.tee $offset
    i32.eqz
    if (result i32)
      i32.const 0
    else
      local.get $offset
      i32.load8_u
      i32.const 42
      i32.eq
    end
  )

  (func $countMinesLine (param $row i32) (param $col i32) (param $skip i32) (result i32)
    local.get $row
    local.get $col
    i32.const 1
    i32.sub
    call $hasMine
    
    local.get $skip
    i32.eqz
    if (result i32)
      local.get $row
      local.get $col
      call $hasMine
    else
      i32.const 0
    end

    local.get $row
    local.get $col
    i32.const 1
    i32.add
    call $hasMine
    i32.add
    i32.add
  )

  (func $countMines (param $row i32) (param $col i32)
    (local $mines i32)

    local.get $row
    i32.const 1
    i32.sub
    local.get $col
    i32.const 0
    call $countMinesLine
    
    local.get $row
    local.get $col
    i32.const 1
    call $countMinesLine

    local.get $row
    i32.const 1
    i32.add
    local.get $col
    i32.const 0
    call $countMinesLine

    i32.add
    i32.add
    local.tee $mines
    i32.eqz
    if
      return
    else
      local.get $row
      local.get $col
      call $getOffset
    
      local.get $mines
      i32.const 48
      i32.add
      
      i32.store8
    end
    
  )

  ;;
  ;; Adds numbers to a minesweeper board.
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the output string in linear memory
  ;;
  (func (export "annotate") (param $offset i32) (param $length i32) (result i32 i32)
    (local $off i32)
    (local $len i32)
    (local $char i32)
    (local $row i32)
    (local $col i32)


    local.get $offset
    local.set $off

    local.get $offset
    global.set $board

    local.get $length
    local.set $len

    ;; first, count the number of rows and columns
    block $block
      loop $loop
        local.get $len
        i32.eqz
        br_if $block

        local.get $off
        i32.load8_u
        local.tee $char
        i32.const 10
        i32.eq
        if
          global.get $cols
          i32.const 0
          i32.gt_u
          if
            global.get $rows
            local.get $off
            i32.const 1
            i32.sub
            i32.load8_u
            i32.const 10
            i32.ne
            i32.add
            global.set $rows
          end
        else
          global.get $rows
          i32.eqz
          if
            global.get $cols
            i32.const 1
            i32.add
            global.set $cols
          end
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
      end
    end

    block $block_rows
      loop $loop_rows
        local.get $row
        global.get $rows
        i32.eq
        br_if $block_rows

        i32.const 0
        local.set $col
        
        block $block_cols
          loop $loop_cols
            local.get $col
            global.get $cols
            i32.eq
            br_if $block_cols

            local.get $row  
            local.get $col
            call $hasMine
            i32.eqz
            if
              local.get $row
              local.get $col
              call $countMines
            end  

            local.get $col
            i32.const 1
            i32.add
            local.set $col
            
            br $loop_cols
          end
        end

        local.get $row
        i32.const 1
        i32.add
        local.set $row

        br $loop_rows
      end
    end

    local.get $offset
    local.get $length
  )
)
