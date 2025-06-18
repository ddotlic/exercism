const points = [_]u4{ 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10 };
//                    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q,  R, S, T, U, V, W, X, Y, Z

pub fn score(s: []const u8) u32 {
    var sum: u32 = 0;
    for (0..s.len) |i| {
        const letter = s[i];
        const delta: u8 = if (letter > 90) 97 else 65;
        const ix = letter - delta;
        sum += points[ix];
    }
    return sum;
}
