(module
  (memory 1)

  (global (export "mercury") i32 (i32.const 0))
  (global (export "venus") i32 (i32.const 1))
  (global (export "earth") i32 (i32.const 2))
  (global (export "mars") i32 (i32.const 3))
  (global (export "jupiter") i32 (i32.const 4))
  (global (export "saturn") i32 (i32.const 5))
  (global (export "uranus") i32 (i32.const 6))
  (global (export "neptune") i32 (i32.const 7))

  ;; orbital periods 0.2408467, 0.61519726, 1.0, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132
  (data (i32.const 0) "\84\a0\76\3e\91\7d\1d\3f\00\00\80\3f\92\be\f0\3f\45\cd\3d\41\7a\94\eb\41\a0\08\a8\42\94\ca\24\43")

  ;;
  ;; calculates the age in planetary years based on planet and number of seconds
  ;;
  ;; @param {i32} $planet - 0-7, see exported planets
  ;; @param {i32} $seconds - number of seconds
  ;;
  ;; @result {f64} age in years on the planet
  ;;
  (func (export "age") (param $planet i32) (param $seconds i32) (result f64)
    local.get $seconds
    f64.convert_i32_u
    f64.const 31_557_600.0 ;; year in seconds
    f64.div
    local.get $planet
    i32.const 4
    i32.mul
    f32.load
    f64.promote_f32
    f64.div
    ;; now round to two decimals
    f64.const 100
    f64.mul
    f64.nearest
    f64.const 100
    f64.div
  )
)
