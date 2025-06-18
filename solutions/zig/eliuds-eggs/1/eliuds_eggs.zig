pub fn eggCount(number: usize) usize {
    const bits = @bitSizeOf(usize);
    var mask: usize = 1;
    var eggs: usize = 0;
    for (0..bits) |_| {
        eggs += if (number & mask != 0) 1 else 0;
        mask <<= 1;
    }
    return eggs;
}
