(module
  ;;
  ;; Return the square root of the given number.
  ;;
  ;; @param {i32} radicand
  ;;
  ;; @returns {i32} square root of radicand
  ;;
  (func (export "squareRoot") (param $radicand i32) (result i32)
    (local $x i32)
    (local $c i32)
    (local $d i32)
    (local $cd i32)

    local.get $radicand
    local.set $x
    i32.const 1
    i32.const 30
    i32.shl
    local.set $d
    
    block $block 
      loop $loop
        local.get $d
        local.get $radicand
        i32.gt_u
        if
          local.get $d
          i32.const 2
          i32.shr_u
          local.set $d
        else
          br $block
        end
        br $loop
      end
    end

    block $block2
      loop $loop2
        local.get $d
        i32.eqz
        if
          br $block2
        end
        local.get $c
        local.get $d
        i32.add
        local.set $cd
        local.get $x
        local.get $cd
        i32.ge_u
        if
          local.get $x
          local.get $cd
          i32.sub
          local.set $x
          local.get $c
          i32.const 1
          i32.shr_u
          local.get $d
          i32.add
          local.set $c
        else
          local.get $c
          i32.const 1
          i32.shr_u
          local.set $c
        end
        local.get $d
        i32.const 2
        i32.shr_u
        local.set $d

        br $loop2
      end
    end

    local.get $c
  )
)


(;

from Wikipedia: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Binary_numeral_system_(base_2)

int isqrt(int n) {
    //assert(("sqrt input should be non-negative", n > 0));

    // X_(n+1)
    int x = n;

    // c_n
    int c = 0;

    // d_n which starts at the highest power of four <= n
    int d = 1 << 30; // The second-to-top bit is set.
                         // Same as ((unsigned) INT32_MAX + 1) / 2.
    while (d > n) {
        d >>= 2;
    }

    // for dₙ … d₀
    while (d != 0) {
        if (x >= c + d) {      // if X_(m+1) ≥ Y_m then a_m = 2^m
            x -= c + d;        // X_m = X_(m+1) - Y_m
            c = (c >> 1) + d;  // c_(m-1) = c_m/2 + d_m (a_m is 2^m)
        }
        else {
            c >>= 1;           // c_(m-1) = c_m/2      (aₘ is 0)
        }
        d >>= 2;               // d_(m-1) = d_m/4
    }
    return c;                  // c_(-1)
}
;)
