const std = @import("std");
const mem = std.mem;

const BufferLength = 128;
/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var buffer = [_]u8{0} ** BufferLength;
    var end: usize = 0;
    var counter: usize = 0;
    for (0..s.len) |i| {
        const ch = s[i];
        var skip = false;
        var encoded = ch;
        if (std.ascii.isAlphabetic(ch)) {
            const actual = std.ascii.toLower(ch);
            encoded = 'z' - (actual - 'a');
        } else if (!std.ascii.isDigit(ch)) skip = true;
        if (!skip) {
            counter += 1;
            if (counter > 5) {
                buffer[end] = ' ';
                end += 1;
                counter = 1;
            }
            buffer[end] = encoded;
            end += 1;
        }
    }
    const output = try allocator.alloc(u8, end);
    @memcpy(output, buffer[0..end]);
    return output;
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var buffer = [_]u8{0} ** BufferLength;
    var end: usize = 0;
    for (0..s.len) |i| {
        const ch = s[i];
        if (std.ascii.isLower(ch)) {
            buffer[end] = 'z' - (ch - 'a');
            end += 1;
        } else if (std.ascii.isDigit(ch)) {
            buffer[end] = ch;
            end += 1;
        }
    }
    const output = try allocator.alloc(u8, end);
    @memcpy(output, buffer[0..end]);
    return output;
}
