(module
  (memory (export "mem") 1)
  (global $rows (mut i32)  (i32.const 1))
  (global $cols (mut i32)  (i32.const 1))
  (global $nl i32  (i32.const 10))
  (global $spc i32  (i32.const 32))
  (global $storage i32 (i32.const 200))
  (global $output i32 (i32.const 300))
  (data (i32.const 400) "9 8 7\0a5 3 2\0a6 6 7\0a")

  (func $valueAt (param $row i32) (param $col i32) (result i32)
    global.get $storage
    local.get $row
    global.get $cols
    i32.mul
    i32.add
    local.get $col
    i32.add
    i32.load8_u
  )
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
    (local $currRow i32)
    (local $currCol i32)
    (local $treeHeight i32)
    (local $tallestRow i32)
    (local $val i32)
    (local $shortestCol i32)
    (local $r i32)
    (local $c i32)
    (local $out i32)

    local.get $inputLength
    i32.eqz
    if
      global.get $output
      i32.const 0
      return
    end

    local.get $inputOffset
    local.set $offset

    global.get $storage
    local.set $store

    global.get $output
    local.set $out

    block $block
      loop $loop
        local.get $offset
        local.get $inputOffset
        i32.sub
        local.get $inputLength
        i32.const 1
        i32.sub ;; ignore the last trailing newline
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
    local.set $currRow

    block $blockRows
      loop $loopRows
        local.get $currRow
        global.get $rows
        i32.ge_u
        br_if $blockRows

        i32.const 0
        local.set $currCol

        block $blockCols
          loop $loopCols
            local.get $currCol
            global.get $cols
            i32.ge_u
            br_if $blockCols

            ;; now we have ($currRow, $currCol) check if it's "good" and if so, add to the output
            local.get $currRow
            local.get $currCol
            call $valueAt
            local.set $treeHeight

            i32.const 0
            local.set $tallestRow
            i32.const 10
            local.set $shortestCol

            i32.const 0
            local.set $r
            i32.const 0
            local.set $c
            
            block $bInRow
              loop $lInRow
                local.get $c
                global.get $cols
                i32.ge_u
                br_if $bInRow
                
                local.get $currRow
                local.get $c
                call $valueAt
                local.tee $val
                local.get $tallestRow
                i32.ge_u
                if
                  local.get $val
                  local.set $tallestRow
                end

                local.get $c
                i32.const 1
                i32.add
                local.set $c
                br $lInRow
              end
            end

            block $bInCol
              loop $lInCol
                local.get $r
                global.get $rows
                i32.ge_u
                br_if $bInCol

                local.get $r
                local.get $currCol
                call $valueAt
                local.tee $val
                local.get $shortestCol
                i32.le_u
                if
                  local.get $val
                  local.set $shortestCol
                end

                local.get $r
                i32.const 1
                i32.add
                local.set $r
                br $lInCol
              end
            end

            local.get $tallestRow
            local.get $treeHeight
            i32.eq
            local.get $shortestCol
            local.get $treeHeight
            i32.eq
            i32.and
            if
              local.get $out
              local.get $currRow
              i32.const 1
              i32.add
              i32.store8
              local.get $out
              i32.const 1
              i32.add
              local.get $currCol
              i32.const 1
              i32.add
              i32.store8
              local.get $out
              i32.const 2
              i32.add
              local.set $out
            end

            local.get $currCol
            i32.const 1
            i32.add
            local.set $currCol

            br $loopCols
          end
        end

        local.get $currRow
        i32.const 1
        i32.add
        local.set $currRow

        br $loopRows
      end
    end

    global.get $output
    local.get $out
    global.get $output
    i32.sub
  ) 
)
