/// Writes a reversed copy of `s` to `buffer`.
pub fn reverse(buffer: []u8, s: []const u8) []u8 {
    const len = s.len;
    for (0..len) |i| {
        buffer[i] = s[len - 1 - i];
    }
    return buffer[0..len];
}
