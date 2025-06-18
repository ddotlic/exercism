(module
  (memory (export "mem") 1)

  (data (i32.const 4096) "clover")
  (data (i32.const 4106) "grass")  
  (data (i32.const 4116) "radishes")
  (data (i32.const 4126) "violets")
  (data (i32.const 4136) ", ")
  
  (func $print (param $dest i32) (param $src i32) (param $len i32) (result i32)
    local.get $dest
    local.get $src
    local.get $len
    memory.copy
    local.get $dest
    local.get $len
    i32.add
  )

  (func $plant (param $inputOffset i32) (param $outputOffset i32) (result i32)
    (local $char i32)
    local.get $inputOffset
    i32.load8_u
    local.set $char

    local.get $outputOffset
    i32.const 3072
    i32.gt_u
    if
      local.get $outputOffset
      i32.const 4136
      i32.const 2
      call $print
      local.set $outputOffset
    end

    local.get $char
    i32.const 67
    i32.eq
    if
      local.get $outputOffset
      i32.const 4096
      i32.const 6
      call $print
      local.set $outputOffset
    end

    local.get $char
    i32.const 71
    i32.eq
    if
      local.get $outputOffset
      i32.const 4106
      i32.const 5
      call $print
      local.set $outputOffset
    end

    local.get $char
    i32.const 82
    i32.eq
    if
      local.get $outputOffset
      i32.const 4116
      i32.const 8
      call $print
      local.set $outputOffset
    end

    local.get $char
    i32.const 86
    i32.eq
    if
      local.get $outputOffset
      i32.const 4126
      i32.const 7
      call $print
      local.set $outputOffset
    end

    local.get $outputOffset
  )

  ;;
  ;; Determine which plants a child in the kindergarten class is responsible for.
  ;;
  ;; @param {i32} diagramOffset - The offset of the diagram string in linear memory.
  ;; @param {i32} diagramLength - The length of the diagram string in linear memory.
  ;; @param {i32} studentOffset - The offset of the student string in linear memory.
  ;; @param {i32} studentLength - The length of the student string in linear memory.
  ;;
  ;; @returns {(i32,i32)} - Offset and length of plants string
  ;;                        in linear memory.
  ;;
  (func (export "plants")
    (param $diagramOffset i32) (param $diagramLength i32) (param $studentOffset i32) (param $studentLength i32) (result i32 i32)
    
    (local $column i32)
    (local $result i32)
    (local $rowLen i32)

    local.get $diagramLength
    i32.const 1
    i32.sub
    i32.const 1
    i32.shr_u
    local.set $rowLen

    local.get $studentOffset
    i32.load8_u
    i32.const 65
    i32.sub
    i32.const 1
    i32.shl
    local.set $column

    i32.const 3072
    local.set $result

    local.get $diagramOffset
    local.get $column
    i32.add
    local.get $result
    call $plant
    local.set $result

    local.get $diagramOffset
    local.get $column
    i32.add
    i32.const 1
    i32.add
    local.get $result
    call $plant
    local.set $result
    
    local.get $column
    local.get $rowLen
    i32.add
    i32.const 1
    i32.add
    local.set $column

    local.get $diagramOffset
    local.get $column
    i32.add
    local.get $result
    call $plant
    local.set $result

    local.get $diagramOffset
    local.get $column
    i32.add
    i32.const 1
    i32.add
    local.get $result
    call $plant
    local.set $result

    i32.const 3072
    local.get $result
    i32.const 3072
    i32.sub
  )
)
