(module

  (func $isTriangle (param f32 f32 f32) (result i32)
    local.get 0
    f32.const 0
    f32.gt
    local.get 1
    f32.const 0
    f32.gt
    local.get 2
    f32.const 0
    f32.gt
    i32.and
    i32.and
    i32.eqz
    if
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    f32.add
    local.get 2
    f32.ge
    local.get 0
    local.get 2
    f32.add
    local.get 1
    f32.ge
    local.get 1
    local.get 2
    f32.add
    local.get 0
    f32.ge
    i32.and
    i32.and
    i32.eqz
    if
      i32.const 0
      return
    end
    i32.const 1
  )

  (func $countSame (param f32 f32 f32) (result i32)
    (local $result i32)
    local.get 0
    local.get 1
    f32.eq
    local.get $result
    i32.add
    local.set $result
    local.get 0
    local.get 2
    f32.eq
    local.get $result
    i32.add
    local.set $result
    local.get 1
    local.get 2
    f32.eq
    local.get $result
    i32.add
  )

  ;;
  ;; Is the triangle equilateral?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if equalateral, 0 otherwise
  ;;
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $isTriangle
    i32.eqz
    if
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    local.get 2
    call $countSame
    i32.const 3
    i32.eq
  )

  ;;
  ;; Is the triangle isosceles?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if isosceles, 0 otherwise
  ;;
  (func (export "isIsosceles") (param f32 f32 f32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $isTriangle
    i32.eqz
    if
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    local.get 2
    call $countSame
    i32.const 1
    i32.ge_u
  )

  ;;
  ;; Is the triangle scalene?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if scalene, 0 otherwise
  ;;
  (func (export "isScalene") (param f32 f32 f32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $isTriangle
    i32.eqz
    if
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    local.get 2
    call $countSame
    i32.eqz
  )
)
