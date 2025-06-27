(module
  (memory (export "mem") 1)

  (data (i32.const 64) "Aimee") ;; for testing, remove me
  (global $studentStore (mut i32) (i32.const 800))
  (global $gradeStore i32 (i32.const 150))
  (global $gradeSize i32 (i32.const 50))
  (global $gradeOutput i32 (i32.const 1000))
  (global $rosterOutput i32 (i32.const 1200))

  ;;
  ;; Add a student to the roster
  ;; Already added students with the same name overwrite previous ones
  ;;
  ;; @param {i32} $nameOffset - offset of the student's name in linear memory
  ;; @param {i32} $nameLength - length of the student's name in linear memory
  ;; @param {i32} $grade - grade of the student
  ;;
  (func (export "add") (param $nameOffset i32) (param $nameLength i32) (param $grade i32)
    (local $gradeBase i32)
    (local $studentCount i32)
    (local $needsInsert i32)
    (local $newFirstChar i32)
    (local $ix i32)
    (local $newOffset i32)

    local.get $nameOffset
    i32.load8_u
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

    global.get $gradeStore
    global.get $gradeSize
    local.get $grade
    i32.mul
    i32.add
    local.tee $gradeBase ;; grade 'stuct' starts here: one byte number (N) of students, then N times 2 bytes pointers to students in the storage, students sorted alphabetically by first letter (enough for the exercise, normally would have to check all letters)
    i32.load8_u
    local.set $studentCount

    ;; try to find the place to insert the new student such that they remain sorted
    ;; if we can't find it, append to the end

    block $block
      loop $loop
        local.get $ix
        local.get $studentCount
        i32.ge_u
        br_if $block

        local.get $ix
        i32.const 1
        i32.add
        local.set $ix
        br $loop
      end
    end

    local.get $needsInsert
    i32.eqz
    if ;; just append
      local.get $gradeBase
      i32.const 1
      i32.add
      local.get $studentCount
      i32.const 1
      i32.shl
      i32.add
      local.get $newOffset
      i32.store16
    else ;; need to insert
      ;; TODO: finish this
    end

    local.get $gradeBase
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
    (local $gradeBase i32)
    (local $studentCount i32)
    (local $ix i32)
    (local $studentPtr i32)
    (local $studentLen i32)

    global.get $gradeStore
    global.get $gradeSize
    local.get $grade
    i32.mul
    i32.add
    local.tee $gradeBase
    i32.load8_u
    local.set $studentCount

    global.get $gradeOutput
    local.set $output

    local.get $gradeBase
    i32.const 1
    i32.add
    local.set $gradeBase

    block $block
      loop $loop
        local.get $ix
        local.get $studentCount
        i32.ge_u
        br_if $block

        local.get $ix
        i32.const 1
        i32.shl
        local.get $gradeBase
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
