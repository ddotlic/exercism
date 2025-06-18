pub fn isIsogram(str: []const u8) bool {
    var occurences: u26 = 0;
    const one: u26 = 1;
    for (0..str.len) |i| {
        const letter = str[i];
        if (letter < 65 or (letter > 90 and letter < 97) or letter > 122 or letter == 32 or letter == 45) continue;
        const delta: u8 = if (letter > 90) 97 else 65;
        const ix: u5 = @intCast(letter - delta);
        const bitToSet: u26 = (one << ix);
        if ((occurences & bitToSet) != 0) return false;
        occurences |= bitToSet;
    }
    return true;
}
