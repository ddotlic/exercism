(module
    (memory (export "mem") 1)

    (data (i32.const 0) "R")
    (global $error i32 (i32.const -1))
    (global $north i32 (i32.const 0))
    (global $east i32 (i32.const 1))
    (global $south i32 (i32.const 2))
    (global $west i32 (i32.const 3))

    ;;
    ;; evaluate robot placement after running instructions
    ;;
    ;; @param {i32} $direction - 0 = north, 1 = east, 2 = south, 3 = west
    ;; @param {i32} $x - horizontal position
    ;; @param {i32} $y - vertical position
    ;; @param {i32} $offset - the offset of the instructions in linear memory
    ;; @param {i32} $length - the length of the instructions in linear memory
    ;;
    ;; @returns {(i32,i32,i32)} direction, x and y after the instructions
    ;;          direction is -1 on error
    ;;
    (func (export "evaluate") (param $direction i32) (param $x i32) (param $y i32)
        (param $offset i32) (param $length i32) (result i32 i32 i32)
        (local $dir i32)
        (local $pos_x i32)
        (local $pos_y i32)
        (local $off i32)
        (local $len i32)
        (local $char i32)

        local.get $direction
        i32.const 0
        i32.lt_s
        local.get $direction
        i32.const 3
        i32.gt_s
        i32.or
        if
            global.get $error
            global.get $error
            global.get $error
            return
        end

        local.get $direction
        local.set $dir

        local.get $x
        local.set $pos_x
        
        local.get $y
        local.set $pos_y
        
        local.get $offset
        local.set $off
        
        local.get $length
        local.set $len

        block $block
            loop $loop
                local.get $len
                i32.eqz
                br_if $block

                local.get $off
                i32.load8_u
                local.set $char
                
                local.get $char
                i32.const 82 ;; R
                i32.eq
                if
                    local.get $dir
                    i32.const 1
                    i32.add
                    i32.const 4
                    i32.rem_s
                    local.set $dir
                end

                local.get $char
                i32.const 76 ;; L
                i32.eq
                if
                    local.get $dir
                    i32.const 3
                    i32.add
                    i32.const 4
                    i32.rem_s
                    local.set $dir
                end


                local.get $char
                i32.const 65 ;; A
                i32.eq
                if
                    local.get $dir
                    i32.const 0
                    i32.eq
                    if
                        local.get $pos_y
                        i32.const 1
                        i32.add
                        local.set $pos_y
                    end

                    local.get $dir
                    i32.const 1
                    i32.eq
                    if
                        local.get $pos_x
                        i32.const 1
                        i32.add
                        local.set $pos_x
                    end

                    local.get $dir
                    i32.const 2
                    i32.eq
                    if
                        local.get $pos_y
                        i32.const 1
                        i32.sub
                        local.set $pos_y
                    end

                    local.get $dir
                    i32.const 3
                    i32.eq
                    if
                        local.get $pos_x
                        i32.const 1
                        i32.sub
                        local.set $pos_x
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

        local.get $dir
        local.get $pos_x
        local.get $pos_y
    )
)
