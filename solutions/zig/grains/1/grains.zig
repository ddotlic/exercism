pub const ChessboardError = error{IndexOutOfBounds};

pub fn square(index: usize) ChessboardError!u64 {
    if (index < 1 or index > 64) return ChessboardError.IndexOutOfBounds;
    const one: u64 = 1;
    const shift: u6 = @intCast(index - 1);
    return one << shift;
}

pub fn total() u64 {
    var result: u64 = 0;
    for (1..65) |i| {
        result += square(i) catch unreachable;
    }
    return result;
}
