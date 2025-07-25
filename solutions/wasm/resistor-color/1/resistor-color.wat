(module
  (memory (export "mem") 1)

  (data (i32.const 64) "orange") ;; TODO: remove me
  
  
  (data (i32.const 200) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  (data (i32.const 300) "\05black")
  (data (i32.const 320) "\05brown")
  (data (i32.const 340) "\03red")
  (data (i32.const 360) "\06orange")
  (data (i32.const 380) "\06yellow")
  (data (i32.const 400) "\05green")
  (data (i32.const 420) "\04blue")
  (data (i32.const 440) "\06violet")
  (data (i32.const 460) "\04grey")
  (data (i32.const 480) "\05white")
  ;;
  ;; Return buffer of comma separated colors
  ;; "black,brown,red,orange,yellow,green,blue,violet,grey,white"
  ;;
  ;; @returns {(i32, i32)} - The offset and length of the buffer of comma separated colors
  ;;
  (func (export "colors") (result i32 i32)
    i32.const 200 
    i32.const 58
  )

  ;;
  ;; Given a valid resistor color, returns the associated value
  ;;
  ;; @param {i32} offset - offset into the color buffer
  ;; @param {i32} len - length of the color string
  ;;
  ;; @returns {i32} - the associated value
  ;;
  (func (export "colorCode") (param $offset i32) (param $length i32) (result i32)
    (local $result i32)
    (local $i i32)
    (local $off i32)
    (local $len i32)
    (local $found i32)
    (local $candidateOffset i32)

    i32.const 0xff
    local.set $result

    block $block
      loop $loop
        local.get $i
        i32.const 10
        i32.ge_u
        br_if $block

        local.get $i
        i32.const 20
        i32.mul
        i32.const 300
        i32.add
        local.tee $candidateOffset
        i32.load8_u
        local.get $length
        i32.eq
        if
          
          local.get $candidateOffset
          i32.const 1
          i32.add
          local.set $candidateOffset
          
          i32.const 1
          local.set $found

          local.get $offset
          local.set $off
          local.get $length
          local.set $len

          block $block2
            loop $loop2

              local.get $len
              i32.eqz
              br_if $block2

              local.get $candidateOffset
              i32.load8_u
              local.get $off
              i32.load8_u
              i32.ne
              if
                i32.const 0
                local.set $found
                br $block2
              end

              local.get $candidateOffset
              i32.const 1
              i32.add
              local.set $candidateOffset

              local.get $off
              i32.const 1
              i32.add
              local.set $off

              local.get $len
              i32.const 1
              i32.sub
              local.set $len
              
              br $loop2
            end
          end

          local.get $found
          if
            local.get $i
            local.set $result
            br $block
          end
        end

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        br $loop
      end
    end

    local.get $result
  )  
)
