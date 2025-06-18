const std = @import("std");

pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    std.debug.assert(n != 0);

    var i: u64 = 1;
    var sum: u64 = 0;
    while (i <= n / 2) {
        if (n % i == 0) {
            sum += i;
        }
        i += 1;
    }
    return if (sum == n)
        Classification.perfect
    else if (sum > n)
        Classification.abundant
    else
        Classification.deficient;
}
