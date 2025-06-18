const std = @import("std");

fn hasValidCharaters(str: []const u8) bool {
    for (0..str.len) |ix| {
        const c = str[ix];
        const valid = c == '-' or std.ascii.isDigit(c) or (ix == (str.len - 1) and c == 'X');
        if (!valid) return false;
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

pub fn isValidIsbn10(s: []const u8) bool {
    if (!hasValidCharaters(s)) return false;
    var buffer = [_]u8{0} ** 1024;
    var copy = buffer[0..s.len];
    @memcpy(copy, s);
    const newLen = stripCharInPlace(copy, '-');
    const stripped = copy[0..newLen];
    if (stripped.len != 10) return false;
    var sum: usize = 0;
    var iy: usize = 11;
    const last = stripped.len - 1;
    for (0..stripped.len) |i| {
        iy -= 1;
        const digit = if (i == last and stripped[i] == 'X') 10 else (stripped[i] - 48);
        sum += digit * iy;
    }
    return sum % 11 == 0;
}
