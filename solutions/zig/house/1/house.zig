const mem = @import("std").mem;

const Verses = [_][]const u8{ "This is", "the house that Jack built", "the malt that lay in", "the rat that ate", "the cat that killed", "the dog that worried", "the cow with the crumpled horn that tossed", "the maiden all forlorn that milked", "the man all tattered and torn that kissed", "the priest all shaven and shorn that married", "the rooster that crowed in the morn that woke", "the farmer sowing his corn that kept", "the horse and the hound and the horn that belonged to" };

fn one_verse(buffer: []u8, offset: usize, str: []const u8) usize {
    const end = offset + str.len;
    @memcpy(buffer[offset..end], str);
    buffer[end] = ' ';
    return end + 1;
}

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) []const u8 {
    var offset: usize = 0;

    for (start_verse..end_verse + 1) |value| {
        offset = one_verse(buffer, offset, Verses[0]);
        var index = value;
        while (index > 0) {
            offset = one_verse(buffer, offset, Verses[index]);
            index -= 1;
        }
        buffer[offset - 1] = '.';

        if (value != end_verse) {
            buffer[offset] = '\n';
            offset += 1;
        }
    }

    return buffer[0..offset];
}
