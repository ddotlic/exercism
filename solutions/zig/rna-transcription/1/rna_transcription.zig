const std = @import("std");
const mem = std.mem;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    var rna = try allocator.alloc(u8, dna.len);

    for (0..dna.len) |i| {
        rna[i] = switch (dna[i]) {
            'A' => 'U',
            'T' => 'A',
            'C' => 'G',
            'G' => 'C',
            else => unreachable,
        };
    }
    return rna;
}
