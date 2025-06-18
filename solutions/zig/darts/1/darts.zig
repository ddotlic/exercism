const std = @import("std");

pub const Coordinate = struct {
    x: f32,
    y: f32,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        return Coordinate{ .x = x_coord, .y = y_coord };
    }
    pub fn score(self: Coordinate) usize {
        const radius = std.math.sqrt(self.x * self.x + self.y * self.y);
        return if (radius <= 1) 10 else if (radius <= 5) 5 else if (radius <= 10) 1 else 0;
    }
};
