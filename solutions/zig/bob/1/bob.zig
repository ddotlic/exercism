const std = @import("std");

const Fine = "Fine. Be that way!";
const Sure = "Sure.";
const Whatever = "Whatever.";
const Whoa = "Whoa, chill out!";
const Calm = "Calm down, I know what I'm doing!";

pub fn response(s: []const u8) []const u8 {
    const whitespace = " \t\n\r";
    const trimmed = std.mem.trim(u8, s, whitespace);
    if (trimmed.len == 0) {
        return Fine;
    }
    var letters: usize = 0;
    var upper: usize = 0;
    for (trimmed) |c| {
        if (std.ascii.isAlphabetic(c)) {
            letters += 1;
            if (std.ascii.isUpper(c)) {
                upper += 1;
            }
        }
    }
    const screaming = letters == upper and letters > 0;
    if (std.mem.endsWith(u8, trimmed, "?")) {
        return if (screaming) Calm else Sure;
    }
    if (screaming) return Whoa;
    return Whatever;
}
