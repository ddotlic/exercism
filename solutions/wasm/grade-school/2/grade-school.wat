(module
  (memory (export "mem") 1)

  ;; (data (i32.const 64) "Aimee") ;; for testing, remove me

  (data (i32.const 64) "Blair") ;; for testing, remove me
  (data (i32.const 80) "James") ;; for testing, remove me
  (data (i32.const 96) "Paul") ;; for testing, remove me

  ;; (data (i32.const 112) "Chelsea") ;; for testing, remove me
  ;; (data (i32.const 128) "Logan") ;; for testing, remove me

  (global $gradeStore i32 (i32.const 600))
  (global $studentStore (mut i32) (i32.const 800))
  (global $gradeOutput i32 (i32.const 1000))
  (global $rosterOutput i32 (i32.const 1200))

  (func $getNameStart (param $offset i32) (result i32)
    local.get $offset
    i32.load8_u
    i32.const 8
    i32.shl
    local.get $offset
    i32.const 1
    i32.add
    i32.load8_u
    i32.add
  )
  ;;
  ;; Add a student to the roster
  ;; Already added students with the same name overwrite previous ones
  ;;
  ;; @param {i32} $nameOffset - offset of the student's name in linear memory
  ;; @param {i32} $nameLength - length of the student's name in linear memory
  ;; @param {i32} $grade - grade of the student
  ;;
  (func (export "add") (param $nameOffset i32) (param $nameLength i32) (param $grade i32)
    (local $studentCount i32)
    (local $needsInsert i32)
    (local $newFirstChar i32)
    (local $ix i32)
    (local $newOffset i32)
    (local $prior i32)
    (local $priorFirstChar i32)
    (local $priorGrade i32)

    local.get $nameOffset
    call $getNameStart
    local.set $newFirstChar

    ;; need to copy student because input - where nameOffset points - may be overwritten between
    ;; successive calls to the function
    global.get $studentStore
    local.tee $newOffset
    local.get $nameLength
    i32.store8 ;; we store strings with one byte prefix - their length - then the string
    local.get $newOffset
    i32.const 1
    i32.add
    local.get $nameOffset
    local.get $nameLength
    memory.copy
    local.get $newOffset
    local.get $nameLength
    i32.add
    i32.const 1
    i32.add
    global.set $studentStore

    global.get $gradeStore ;; grade 'stuct' starts here: one byte number (N) of students, then N times 1 byte student's grade and 2 bytes pointer to student in the storage, students sorted by grade and then alphabetically by first letter (enough for the exercise, normally would have to check all letters)
    i32.load8_u
    local.set $studentCount

    ;; try to find the place to insert the new student such that they remain sorted
    ;; if we can't find it, append to the end

    block $block
      loop $loop
        local.get $ix
        i32.const 3
        i32.mul
        global.get $gradeStore
        i32.add
        i32.const 1
        i32.add
        local.set $prior

        local.get $ix
        local.get $studentCount
        i32.ge_u
        br_if $block

        local.get $prior
        i32.load8_u
        local.set $priorGrade
        local.get $prior
        i32.const 1
        i32.add
        i32.load16_u ;; load student "pointer"
        i32.const 1
        i32.add ;; skip string length
        call $getNameStart
        local.tee $priorFirstChar
        local.get $newFirstChar
        i32.eq
        if
          ;; same student, replace grade
          local.get $prior
          local.get $grade
          i32.store8
          return
        end

        local.get $grade
        local.get $priorGrade
        i32.le_u
        if
          local.get $newFirstChar
          local.get $priorFirstChar
          i32.lt_u
          if
            i32.const 1
            local.set $needsInsert
            br $block
          end
        end


        local.get $ix
        i32.const 1
        i32.add
        local.set $ix
        br $loop
      end
    end

    local.get $needsInsert
    i32.const 1
    i32.eq
    if ;; need to insert
      ;; shift existing students right, maintain sort order
      local.get $prior
      i32.const 3
      i32.add
      local.get $prior
      local.get $studentCount
      local.get $ix
      i32.sub
      i32.const 3
      i32.mul
      memory.copy
    end
    local.get $prior
    local.get $grade
    i32.store8

    local.get $prior
    i32.const 1
    i32.add
    local.get $newOffset
    i32.store16

    global.get $gradeStore
    local.get $studentCount
    i32.const 1
    i32.add
    i32.store8
  )

  ;;
  ;; Generate the roster for all grades
  ;;
  ;; @returns {(i32,i32)} - offset and length of the roster in linear memory
  ;;
  (func (export "roster") (result i32 i32)
    (local $output i32)
    (local $ix i32)
    (local $gradeOffset i32)
    (local $gradeLen i32)

    global.get $rosterOutput
    local.set $output

    i32.const 1
    local.set $ix

    block $block
      loop $loop
        local.get $ix
        i32.const 12
        i32.gt_u
        br_if $block

        local.get $ix
        call $studentsOfGrade
        local.set $gradeLen
        local.set $gradeOffset

        local.get $gradeLen
        i32.eqz
        if
        else
          local.get $output
          local.get $gradeOffset
          local.get $gradeLen
          memory.copy
          local.get $output
          local.get $gradeLen
          i32.add
          local.set $output
        end

        local.get $ix
        i32.const 1
        i32.add
        local.set $ix

        br $loop
      end
    end

    global.get $rosterOutput
    local.get $output
    global.get $rosterOutput
    i32.sub
  )

  ;;
  ;; Generate a list of students for a grade
  ;;
  ;; @param {i32} $grade
  ;;
  ;; @returns {(i32,i32)} - offset and length of the list of students for the grade in linear memory
  ;;
  (func $studentsOfGrade (export "grade") (param $grade i32) (result i32 i32)
    (local $output i32)
    (local $studentCount i32)
    (local $ix i32)
    (local $student i32)
    (local $studentPtr i32)
    (local $studentLen i32)

    global.get $gradeStore
    i32.load8_u
    local.set $studentCount

    global.get $gradeOutput
    local.set $output

    block $block
      loop $loop
        local.get $ix
        local.get $studentCount
        i32.ge_u
        br_if $block

        local.get $ix
        i32.const 3
        i32.mul
        global.get $gradeStore
        i32.add
        i32.const 1
        i32.add
        local.tee $student
        i32.load8_u
        local.get $grade
        i32.eq
        if
          local.get $student
          i32.const 1
          i32.add
          i32.load16_u
          local.tee $studentPtr
          i32.load8_u
          local.set $studentLen

          local.get $output
          local.get $studentPtr
          i32.const 1
          i32.add
          local.get $studentLen
          memory.copy
          local.get $output
          local.get $studentLen
          i32.add
          i32.const 10
          i32.store8

          local.get $output
          local.get $studentLen
          i32.add
          i32.const 1
          i32.add
          local.set $output
        end

        local.get $ix
        i32.const 1
        i32.add
        local.set $ix
        br $loop
      end
    end

    global.get $gradeOutput
    local.get $output
    global.get $gradeOutput
    i32.sub
  )
)
