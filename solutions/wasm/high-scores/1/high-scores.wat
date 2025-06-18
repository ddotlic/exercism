(module
  (memory (export "mem") 1)

  (func $top3AndLatest (param $inputOffset i32) (param $inputElements i32) (result i32 i32 i32 i32)

    (local $top1 i32)
    (local $top2 i32)
    (local $top3 i32)
    (local $latest i32)
    (local $offset i32)
    (local $len i32)
    (local $current i32)
    (local $isOnTop i32)

    local.get $inputOffset
    local.set $offset
    local.get $inputElements
    local.set $len

    (block $exit
      (loop $loop
        i32.const 0
        local.set $isOnTop

        local.get $len
        i32.eqz
        br_if $exit
        
        local.get $offset
        i32.load
        local.set $current

        local.get $current
        local.get $top1
        i32.ge_u
        if
          local.get $top2
          local.set $top3
          local.get $top1
          local.set $top2
          local.get $current
          local.set $top1
          i32.const 1
          local.set $isOnTop
        else
          local.get $current
          local.get $top2
          i32.ge_u
          if
            local.get $top2
            local.set $top3
            local.get $current
            local.set $top2
            i32.const 1
            local.set $isOnTop
          else
            local.get $current
            local.get $top3
            i32.ge_u
            if
              local.get $current
              local.set $top3
              i32.const 1
              local.set $isOnTop
            end
          end
        end
    
        local.get $isOnTop
        i32.const 1
        i32.eq
        if
          local.get $current
          local.set $latest
        end
                
        local.get $offset
        i32.const 4
        i32.add
        local.set $offset
        local.get $len
        i32.const 1
        i32.sub
        local.set $len

        br $loop
      )
    )
    local.get $top1
    local.get $top2
    local.get $top3
    local.get $latest
  )
  
  ;;
  ;; Get the latest score from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputElements - number of u32 elements in the input
  ;;
  ;; @result {i32} - latest score from the score board
  ;;
  (func (export "latest") (param $inputOffset i32) (param $inputElements i32) (result i32)
    (local $result i32)
    local.get $inputOffset
    local.get $inputElements
    call $top3AndLatest
    local.set $result
    drop
    drop
    drop
    local.get $result
  )

  ;;
  ;; Get the highest score from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputElements - number of u32 elements in the input
  ;;
  ;; @result {i32} - highest score from the score board
  ;;
  (func (export "personalBest") (param $inputOffset i32) (param $inputElements i32) (result i32)
    local.get $inputOffset
    local.get $inputElements
    call $top3AndLatest
    drop
    drop
    drop
  )

  ;;
  ;; Get the three highest scores from the score board
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputElements - number of u32 elements in the input
  ;;
  ;; @result {(i32,i32,i32)} - three highest score from the score board
  ;;
  (func (export "personalTopThree") (param $inputOffset i32) (param $inputElements i32) (result i32 i32 i32)
    local.get $inputOffset
    local.get $inputElements
    call $top3AndLatest
    drop
  )

  
)
