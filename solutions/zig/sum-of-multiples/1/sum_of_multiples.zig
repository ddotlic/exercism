const std = @import("std");
const mem = std.mem;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    var set = std.AutoHashMap(u64, void).init(allocator);
    defer set.deinit();
    for (0..factors.len) |i| {
        const factor = factors[i];
        if (factor == 0) continue;
        var current: u32 = 1;
        var candidate = factor;
        while (candidate < limit) {
            try set.put(candidate, {});
            current += 1;
            candidate = factor * current;
        }
    }

    var it = set.keyIterator();
    var result: u64 = 0;
    while (it.next()) |k| {
        result += k.*;
    }
    return result;
}
