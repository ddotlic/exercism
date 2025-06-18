pub fn isPangram(str: []const u8) bool {
    var occurences: u26 = 0;
    const one: u26 = 1;
    const pangram: u26 = 0b11_11111111_11111111_11111111;
    for (0..str.len) |i| {
        const letter = str[i];
        if (letter < 65 or (letter > 90 and letter < 97) or letter > 122) continue;
        const delta: u8 = if (letter > 90) 97 else 65;
        const ix: u5 = @intCast(letter - delta);
        occurences = occurences | (one << ix);
    }
    return occurences == pangram;
}
