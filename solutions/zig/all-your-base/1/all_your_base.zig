const std = @import("std");
const mem = std.mem;

pub const ConversionError = error{
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit,
};

const LocalBufferLength = 128;
/// Converts `digits` from `input_base` to `output_base`, returning a slice of digits.
/// Caller owns the returned memory.
pub fn convert(
    allocator: mem.Allocator,
    digits: []const u32,
    input_base: u32,
    output_base: u32,
) (mem.Allocator.Error || ConversionError)![]u32 {
    if (input_base < 2) return ConversionError.InvalidInputBase;
    if (output_base < 2) return ConversionError.InvalidOutputBase;

    var pow: u32 = 0;
    var number: u32 = 0;
    for (0..digits.len) |i| {
        const digit = digits[digits.len - 1 - i];
        if (digit >= input_base) return ConversionError.InvalidDigit;
        const mul = std.math.powi(u32, input_base, pow) catch unreachable;
        number += digit * mul;
        pow += 1;
    }

    var output = [_]u32{0} ** LocalBufferLength;
    const end: usize = output.len - 1;
    var start: usize = end;

    if (number == 0) {
        start -= 1;
    } else {
        while (number > 0) {
            start -= 1;
            output[start] = number % output_base;
            number /= output_base;
        }
    }

    const result = try allocator.alloc(u32, end - start);
    @memcpy(result, output[start..end]);
    return result;
}
