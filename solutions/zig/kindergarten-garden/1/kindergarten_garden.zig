pub const Plant = enum {
    clover,
    grass,
    radishes,
    violets,
};

fn charToPlant(c: u8) Plant {
    return switch (c) {
        'C' => Plant.clover,
        'G' => Plant.grass,
        'R' => Plant.radishes,
        'V' => Plant.violets,
        else => unreachable,
    };
}

pub fn plants(diagram: []const u8, student: []const u8) [4]Plant {
    const student_index: usize = student[0] - 'A';
    const column_index: usize = student_index * 2;
    const row2_start = (diagram.len - 1) / 2 + 1;
    var result: [4]Plant = undefined;
    result[0] = charToPlant(diagram[column_index]);
    result[1] = charToPlant(diagram[column_index + 1]);
    result[2] = charToPlant(diagram[row2_start + column_index]);
    result[3] = charToPlant(diagram[row2_start + column_index + 1]);
    return result;
}
