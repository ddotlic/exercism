(module
  (memory (export "mem") 1)

  (global $out i32 (i32.const 8))

  (func $binomialCoeff (param $n i32) (param $k i32) (result i32)
    (local $res i32)
    (local $nk i32)
    (local $i i32)

    i32.const 1
    local.set $res

    local.get $k
    local.get $n
    local.get $k
    i32.sub
    local.tee $nk
    i32.gt_u
    if
      local.get $nk
      local.set $k
    end

    block $block
      loop $loop
        local.get $i
        local.get $k
        i32.ge_u
        br_if $block

        local.get $res
        local.get $n
        local.get $i
        i32.sub
        i32.mul
        local.set $res

        local.get $res
        local.get $i
        i32.const 1
        i32.add
        i32.div_u
        local.set $res

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $res
  )
  
  ;;
  ;; Provide the numbers for Pascals triangle with a given number of rows
  ;;
  ;; @param {i32} $count - number of rows
  ;;
  ;; @returns {(i32,i32)} - offset and length of the i32-numbers in linear memory
  ;;
  (func (export "rows") (param $count i32) (result i32 i32)
    (local $row i32)
    (local $col i32)
    (local $output i32)

    global.get $out
    local.set $output

    i32.const 0
    local.set $row

    block $block1
      loop $loop1
        local.get $row
        local.get $count
        i32.ge_u
        br_if $block1

        i32.const 0
        local.set $col
        
        block $block2
          loop $loop2
            local.get $col
            local.get $row
            i32.gt_u
            br_if $block2

            local.get $output
            local.get $row
            local.get $col
            call $binomialCoeff
            i32.store

            local.get $output
            i32.const 4
            i32.add
            local.set $output

            local.get $col
            i32.const 1
            i32.add
            local.set $col
            br $loop2
          end
        end

        local.get $row
        i32.const 1
        i32.add
        local.set $row

        br $loop1
      end
    end

    global.get $out
    local.get $output
    global.get $out
    i32.sub
  )
)
