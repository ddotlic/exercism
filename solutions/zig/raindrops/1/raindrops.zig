const std = @import("std");

const Pling = "Pling";
const Plang = "Plang";
const Plong = "Plong";
const Empty = "";

pub fn convert(buffer: []u8, n: u32) []const u8 {
  
    const first = if (n % 3 == 0) Pling else Empty;
    const second = if (n % 5 == 0) Plang else Empty;
    const third = if (n % 7 == 0) Plong else Empty;


    if(first.len == 0 and second.len == 0 and third.len == 0) {
        return std.fmt.bufPrint(buffer, "{d}", .{n}) catch unreachable;
    }

    return std.fmt.bufPrint(buffer, "{s}{s}{s}", .{first, second, third}) catch unreachable;
}
