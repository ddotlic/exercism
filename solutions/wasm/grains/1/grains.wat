(module
  ;;
  ;; Calculate the number of grains of wheat on the nth square of the chessboard
  ;;
  ;; @param {i32} squareNum - The square of the chessboard to calculate the number of grains for
  ;;
  ;; @returns {i64} - The number of grains of wheat on the nth square of the 
  ;;                  chessboard or 0 if the squareNum is invalid. The result
  ;;                  is unsigned.
  ;;
  (func $square (export "square") (param $squareNum i32) (result i64)
    local.get $squareNum
    i32.const 1
    i32.lt_s
    local.get $squareNum
    i32.const 64
    i32.gt_s
    i32.or
    if (result i64)
      i64.const 0
    else
      i64.const 1
      local.get $squareNum
      i64.extend_i32_u
      i64.const 1
      i64.sub
      i64.shl
    end
  )

  ;;
  ;; Calculate the sum of grains of wheat across all squares of the chessboard
  ;;
  ;; @returns {i64} - The number of grains of wheat on the entire chessboard.
  ;;                  The result is unsigned.
  ;; 1 + 2 + 4 + 8 + ... + 2^63 = 2^64 - 1 = -1
  
  (func (export "total") (result i64)
    i64.const -1
  )
)
