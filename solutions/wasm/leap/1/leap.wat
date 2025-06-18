(module
  ;;
  ;; Determine if a year is a leap year
  ;;
  ;; @param {i32} year - The year to check
  ;;
  ;; @returns {i32} 1 if leap year, 0 otherwise
  ;;
  (func (export "isLeap") (param $year i32) (result i32)
    (local $result i32)
    
    (block $exit
      local.get $year
      i32.const 4
      i32.rem_u
      i32.eqz
      if
        local.get $year
        i32.const 100
        i32.rem_u
        i32.eqz
        if
          local.get $year
          i32.const 400
          i32.rem_u
          i32.eqz
          if
            i32.const 1
            local.set $result
            br $exit
          end
          br $exit
        end
        i32.const 1
        local.set $result
        br $exit
      end

      br $exit
    )
    local.get $result
  )  
)
