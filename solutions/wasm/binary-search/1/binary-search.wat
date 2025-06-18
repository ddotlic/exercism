(module
  (memory (export "mem") 1)
 
  ;;
  ;; Find the first occurrence of the needle in the haystack
  ;;
  ;; @param {i32} base - the base address of the haystack
  ;; @param {i32} nelems - the number of elements in the haystack
  ;; @param {i32} needle - the value to search for
  ;;
  ;; @return {i32} the index of the first occurrence of the needle in the haystack
  ;;               or -1 if the needle is not found.
  ;;
  (func $compare (param $a i32) (param $b i32) (result i32)
   
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $a
      local.get $b
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        local.get $a
        local.get $b
        i32.ge_s
        if (result i32)
          i32.const 0
        else
          unreachable
        end
      end
    end 
  )

  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (local $arr i32)
    (local $lo i32)
    (local $hi i32)
    (local $mid i32)
    (local $num i32)
    (local $val i32)

    local.get $nelems
    i32.eqz
    if
      i32.const -1
      return
    end

    local.get $base
    local.set $arr
    local.get $nelems
    i32.const 1
    i32.sub
    local.set $hi
    local.get $needle
    local.set $val

    block $block
      loop $loop
        local.get $lo
        local.get $hi
        i32.ge_s
        br_if $block

        local.get $lo
        local.get $hi
        i32.add
        i32.const 1
        i32.shr_s
        local.set $mid

        local.get $arr
        local.get $mid
        i32.const 4
        i32.mul
        i32.add
        i32.load
        local.tee $num
        local.get $val
        call $compare
        i32.const 0
        i32.lt_s
        if
          local.get $mid
          i32.const 1
          i32.add
          local.set $lo
        else
          local.get $mid
          local.set $hi
        end

        br $loop
      end
    end

    local.get $arr
    local.get $lo
    i32.const 4
    i32.mul
    i32.add
    i32.load
    local.get $val
    i32.eq
    if (result i32)
      local.get $lo
    else
      i32.const -1
    end
  )
)
