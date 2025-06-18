const std = @import("std");
// Take a look at the tests, you might have to change the function arguments

pub fn binarySearch(comptime T: type, target: T, items: []const T) ?usize {
    if (items.len == 0) {
        return null;
    }
    var l: usize = 0;
    var r: usize = items.len - 1;
    while (l <= r) {
        const m = l + (r - l) / 2;
        if (items[m] < target) {
            l = m + 1;
        } else if (items[m] > target) {
            if (m == 0) {
                return null;
            }
            r = m - 1;
        } else {
            return m;
        }
    }
    return null;
}
