const Lines = [_][]const u8{ "+ green bottle* hanging on the wall,\n", "And if one green bottle should accidentally fall,\n", "There'll be / green bottle% hanging on the wall.\n" };

const QuantityLower = [_][]const u8{
    "no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
};

const QuantityUpper = [_][]const u8{
    "No", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
};

fn copy(buffer: []u8, offset: usize, str: []const u8) usize {
    const len = str.len;
    @memcpy(buffer[offset .. offset + len], str);
    return offset + len;
}

fn putChar(buffer: []u8, offset: usize, ch: u8) usize {
    buffer[offset] = ch;
    return offset + 1;
}

fn oneLine(buffer: []u8, offset: usize, str: []const u8, count: usize) usize {
    var end = offset;
    for (0..str.len) |i| {
        const ch = str[i];
        switch (ch) {
            '+' => end = copy(buffer, end, QuantityUpper[count]),
            '-' => end = copy(buffer, end, QuantityLower[count]),
            '/' => end = copy(buffer, end, QuantityLower[count - 1]),
            '*' => {
                if (count != 1) end = putChar(buffer, end, 's');
            },
            '%' => {
                if (count != 2) end = putChar(buffer, end, 's');
            },
            else => end = putChar(buffer, end, ch),
        }
    }
    return end;
}

pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) []const u8 {
    var offset: usize = 0;

    for (0..take_down) |value| {
        const bottle_count = start_bottles - value;

        offset = oneLine(buffer, offset, Lines[0], bottle_count);
        offset = oneLine(buffer, offset, Lines[0], bottle_count);
        offset = oneLine(buffer, offset, Lines[1], bottle_count);
        offset = oneLine(buffer, offset, Lines[2], bottle_count);

        if (value != take_down - 1) {
            buffer[offset] = '\n';
            offset += 1;
        }
    }

    return buffer[0 .. offset - 1];
}
