fn AddCeil(a: u8, b: u8) u8 {
    const check: i16 = @as(i16, a) + @as(i16, b);
    if (check > 255) {
        return 255;
    }
    return a + b;
}
fn SubCeil(a: u8, b: u8) u8 {
    const check: i16 = @as(i16, a) - @as(i16, b);
    if (check < 0) {
        return 0;
    }
    return a - b;
}

/// Whenever a coordinate value would be less than 0, it is instead 0, and whenever it would be greater than 255, it is instead 255.
pub const Coord = struct {
    x: u8 = 0,
    y: u8 = 0,
    pub fn To(self: *Coord, x: u8, y: u8) void {
        self.x = x;
        self.y = y;
    }
    /// Move coord left
    pub fn Left(self: *Coord, n: u8) void {
        self.x = SubCeil(self.x, n);
    }

    /// Move coord right
    pub fn Right(self: *Coord, n: u8) void {
        self.x = AddCeil(self.x, n);
    }

    /// Move coord down
    pub fn Down(self: *Coord, n: u8) void {
        self.y = AddCeil(self.y, n);
    }

    /// Move coord up
    pub fn Up(self: *Coord, n: u8) void {
        self.y = SubCeil(self.y, n);
    }

    /// Add another coordinates x and y
    pub fn Add(self: *Coord, other: Coord) void {
        self.x = AddCeil(self.x, other.x);
        self.y = AddCeil(self.y, other.y);
    }

    /// Subtract another coordinate's x and y
    pub fn Sub(self: *Coord, other: Coord) void {
        self.x = SubCeil(self.x, other.x);
        self.y = SubCeil(self.y, other.y);
    }
};

test {
    const std = @import("std");
    const expect = std.testing.expect;
    var c = Coord{ .x = 0, .y = 0 };
    c.Left(5);
    c.Up(5);
    try expect(c.x == 0);
    try expect(c.y == 0);
    c.Right(5);
    c.Down(3);
    try expect(c.x == 5);
    try expect(c.y == 3);
    c.Left(2);
    c.Up(1);
    try expect(c.x == 3);
    try expect(c.y == 2);
    const c3 = Coord{ .x = 255, .y = 255 };
    c.Sub(c3);
    try expect(c.x == 0);
    try expect(c.y == 0);
    c.Add(.{ .x = 1, .y = 1 });
    try expect(c.x == 1);
    try expect(c.y == 1);
    c.Add(c3);
    try expect(c.x == 255);
    try expect(c.y == 255);
    c.To(10, 11);
    try expect(c.x == 10);
    try expect(c.y == 11);
}
