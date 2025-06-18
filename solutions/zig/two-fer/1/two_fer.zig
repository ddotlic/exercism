const std = @import("std");

pub fn twoFer(buffer: []u8, name: ?[]const u8) anyerror![]u8 {
    if (name) |n| {
        return try std.fmt.bufPrint(buffer, "One for {s}, one for me.", .{n});
    } else {
        return try std.fmt.bufPrint(buffer, "One for you, one for me.", .{});
    }
}
