const std = @import("std");
const mem = std.mem;

pub fn rotate(allocator: mem.Allocator, text: []const u8, shiftKey: u5) mem.Allocator.Error![]u8 {
    // Allocate memory for the output string
    const output = try allocator.alloc(u8, text.len);
    var offset: usize = 0;
    for (0..text.len) |ix| {
        const ch = text[ix];
        const result = if (std.ascii.isLower(ch))
            ((ch - 'a' + shiftKey) % 26) + 'a'
        else if (std.ascii.isUpper(ch))
            ((ch - 'A' + shiftKey) % 26) + 'A'
        else
            ch;
        output[offset] = result;
        offset += 1;
    }

    return output[0..offset];
}
