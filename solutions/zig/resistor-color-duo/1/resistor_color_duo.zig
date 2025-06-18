pub const ColorBand = enum {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

const Colors = [_]ColorBand{
    .black, .brown, .red,    .orange, .yellow,
    .green, .blue,  .violet, .grey,   .white,
};

pub fn colorCode(colors: [2]ColorBand) usize {
    const ten: usize = 10;
    return ten * @intFromEnum(colors[0]) + @intFromEnum(colors[1]);
}
