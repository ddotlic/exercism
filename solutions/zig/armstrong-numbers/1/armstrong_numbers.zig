const math = @import("std").math;

pub fn isArmstrongNumber(num: u128) bool {
    if (num == 0) return true;

    var current = num;
    var result: u128 = 0;
    const power: u128 = math.log10_int(num) + 1;

    while (current > 0) {
        const digit = current % 10;
        result += math.powi(u128, digit, power) catch unreachable;
        current /= 10;
    }
    return num == result;
}
