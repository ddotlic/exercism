const OrbitalPeriods = [_]f64{ 0.2408467, 0.61519726, 1.0, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132 };

const YearInSeconds: f64 = 31_557_600.0;

pub const Planet = enum {
    mercury,
    venus,
    earth,
    mars,
    jupiter,
    saturn,
    uranus,
    neptune,

    pub fn age(self: Planet, seconds: usize) f64 {
        const period = OrbitalPeriods[@intFromEnum(self)];
        const floatSeconds: f64 = @floatFromInt(seconds);
        return floatSeconds / YearInSeconds / period;
    }
};
