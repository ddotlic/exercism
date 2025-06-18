const std = @import("std");

fn isOnlySpacesAndDigits(str: []const u8) bool {
    for (str) |c| {
        if (c != ' ' and !std.ascii.isDigit(c)) {
            return false;
        }
    }
    return true;
}

fn stripCharInPlace(str: []u8, ch: u8) usize {
    var dest: usize = 0;
    for (str) |c| {
        if (c != ch) {
            str[dest] = c;
            dest += 1;
        }
    }
    return dest;
}

pub fn isValid(s: []const u8) bool {
    if (!isOnlySpacesAndDigits(s)) return false;
    var buffer = [_]u8{0} ** 1024;
    var copy = buffer[0..s.len];
    @memcpy(copy, s);
    const newLen = stripCharInPlace(copy, ' ');
    const stripped = copy[0..newLen];
    if (stripped.len < 2) return false;
    var sum: usize = 0;
    var iy: usize = 1;
    const last = stripped.len - 1;
    for (0..stripped.len) |i| {
        const digit = stripped[last - i] - 48;
        if (iy % 2 == 0) {
            const dbl = digit * 2;
            sum += if (dbl > 9) dbl - 9 else dbl;
        } else sum += digit;
        iy += 1;
    }
    return sum % 10 == 0;
}
