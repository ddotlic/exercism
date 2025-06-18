const std = @import("std");
const mem = std.mem;

fn modPow(base: u128, exp: u128, m: u128) u128 {
    var result: u128 = 1;
    var b = base % m;
    var e = exp;
    while (e != 0) : (e >>= 1) {
        if ((e & 1) != 0) result = (result * b) % m;
        b = (b * b) % m;
    }
    return result;
}

fn isProbablePrimeFermat(n: u64) bool {
    if (n < 2) return false;
    return modPow(2, n - 1, n) == 1;
}

pub fn factors(allocator: mem.Allocator, value: u64) mem.Allocator.Error![]u64 {
    var list = std.ArrayList(u64).init(allocator);
    defer list.deinit();
    if (!isProbablePrimeFermat(value)) {
        var left: u64 = value;
        var divisor: u64 = 2;
        while (left > 1 and divisor <= value) {
            if (left % divisor == 0) {
                try list.append(divisor);
                left /= divisor;
            } else divisor += 1;
        }
    }
    if (list.items.len == 0 and value > 1) try list.append(value);
    return try list.toOwnedSlice();
}
