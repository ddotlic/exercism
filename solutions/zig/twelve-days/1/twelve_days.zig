const mem = @import("std").mem;

const Intro = [_][]const u8{ "On the ", "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth", " day of Christmas " };

const Verses = [_][]const u8{ "my true love gave to me: ", "a Partridge in a Pear Tree", "two Turtle Doves", "three French Hens", "four Calling Birds", "five Gold Rings", "six Geese-a-Laying", "seven Swans-a-Swimming", "eight Maids-a-Milking", "nine Ladies Dancing", "ten Lords-a-Leaping", "eleven Pipers Piping", "twelve Drummers Drumming" };

const Prefix = [_][]const u8{ "", ", ", ", and " };

fn one_verse(buffer: []u8, offset: usize, str: []const u8, pre: usize) usize {
    const prefix = Prefix[pre];
    if (prefix.len > 0) {
        const preEnd = offset + prefix.len;
        @memcpy(buffer[offset..preEnd], prefix);
    }
    const start = offset + prefix.len;
    const end = start + str.len;
    @memcpy(buffer[start..end], str);
    return end;
}

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) []const u8 {
    var offset: usize = 0;

    for (start_verse..end_verse + 1) |value| {
        offset = one_verse(buffer, offset, Intro[0], 0);
        offset = one_verse(buffer, offset, Intro[value], 0);
        offset = one_verse(buffer, offset, Intro[13], 0);
        offset = one_verse(buffer, offset, Verses[0], 0);

        var index = value;
        while (index > 0) {
            const pre: usize = if (value == index) 0 else if (index == 1) 2 else 1;
            offset = one_verse(buffer, offset, Verses[index], pre);
            index -= 1;
        }

        buffer[offset] = '.';
        offset += 1;

        if (value != end_verse) {
            buffer[offset] = '\n';
            offset += 1;
        }
    }

    return buffer[0..offset];
}
