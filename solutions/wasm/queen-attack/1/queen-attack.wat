

(module
  (memory (export "mem") 1)
  (data (i32.const 0) " ")

  (func $abs (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.lt_s
    if (result i32)
      local.get $x
      i32.const -1
      i32.mul
    else
      local.get $x
    end
  )

  (func $isValid (param $rowOrCol i32) (result i32)
    local.get $rowOrCol
    i32.const 0
    i32.ge_s
    local.get $rowOrCol
    i32.const 8
    i32.lt_s
    i32.and
  )
  ;;
  ;; Checks a queen positioning for validity and the ability to attack
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {i32} -1 if invalid, 0 if cannot attack, 1 if it can attack
  ;;
  (func (export "canAttack") (param $positions i32) (result i32)
    (local $whiteRow i32) 
    (local $whiteCol i32)
    (local $blackRow i32)
    (local $blackCol i32)

    local.get $positions
    call $split
    local.set $whiteRow
    local.set $whiteCol
    local.set $blackRow
    local.set $blackCol

    local.get $whiteRow
    call $isValid
    local.get $whiteCol
    call $isValid
    local.get $blackRow
    call $isValid
    local.get $blackCol
    call $isValid
    i32.and
    i32.and
    i32.and
    i32.eqz
    if
      i32.const -1
      return
    end

    local.get $whiteRow
    local.get $blackRow
    i32.eq
    local.get $whiteCol
    local.get $blackCol
    i32.eq
    i32.and
    if
      i32.const -1
      return
    end

    local.get $whiteRow
    local.get $blackRow
    i32.eq
    local.get $whiteCol
    local.get $blackCol
    i32.eq
    i32.or
    if
      i32.const 1
      return
    end

    local.get $whiteRow
    local.get $blackRow
    i32.sub
    call $abs
    local.get $whiteCol
    local.get $blackCol
    i32.sub
    call $abs
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )

  (func $split (param $positions i32) (result i32 i32 i32 i32)
    local.get $positions
    i32.const 0xff
    i32.and ;; black column
    local.get $positions
    i32.const 8
    i32.shr_u
    i32.const 0xff
    i32.and ;; black row
    local.get $positions
    i32.const 16
    i32.shr_u
    i32.const 0xff
    i32.and ;; white column
    local.get $positions
    i32.const 24
    i32.shr_u
    i32.const 0xff
    i32.and ;; white row
  )
  ;;
  ;; Prints the chess board to linear memory (or return empty string if invalid)
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {(i32,i32)} offset and length of chess board string in memory
  ;;
  (func (export "printBoard") (param $positions i32) (result i32 i32)
    (local $whiteRow i32) 
    (local $whiteCol i32)
    (local $blackRow i32)
    (local $blackCol i32)
    (local $row i32)
    (local $col i32)
    (local $off i32)
    (local $char i32)

    local.get $positions
    call $split
    local.set $whiteRow
    local.set $whiteCol
    local.set $blackRow
    local.set $blackCol

    block $blockRows
      loop $loopRows
        local.get $row
        i32.const 8
        i32.ge_u
        br_if $blockRows

        i32.const 0
        local.set $col

        block $blockCols
          loop $loopCols
            local.get $col
            i32.const 8
            i32.ge_u
            br_if $blockCols

            i32.const 95
            local.set $char

            local.get $row
            local.get $whiteRow
            i32.eq
            local.get $col
            local.get $whiteCol
            i32.eq
            i32.and
            if
              i32.const 87
              local.set $char
            end
            
            local.get $row
            local.get $blackRow
            i32.eq
            local.get $col
            local.get $blackCol
            i32.eq
            i32.and
            if
              i32.const 66
              local.set $char
            end

            local.get $off
            local.get $char
            i32.store8
            local.get $off
            i32.const 1
            i32.add
            local.set $off
            
            local.get $col
            i32.const 7
            i32.lt_u
            if
              local.get $off
              i32.const 32
              i32.store8
              local.get $off
              i32.const 1
              i32.add
              local.set $off
            end

            local.get $col
            i32.const 1
            i32.add
            local.set $col

            br $loopCols
          end
        end

        local.get $off
        i32.const 10
        i32.store8
        local.get $off
        i32.const 1
        i32.add
        local.set $off

        local.get $row
        i32.const 1
        i32.add
        local.set $row

        br $loopRows
      end
    end

    local.get $off
    i32.const 10
    i32.store8
    local.get $off
    i32.const 1
    i32.add
    local.set $off

    i32.const 0
    i32.const 128
  )
)
