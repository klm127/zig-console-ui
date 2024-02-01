const draw = @import("draw/square.zig");
const vt = @import("virtual-terminal/sequences.zig");
const std = @import("std");

test "drawSquare" {
    const stdout = std.io.getStdOut();
    const writer = stdout.writer();

    const col = @as(*const []u8, @alignCast(@ptrCast(vt.Format.BG.Blue)));

    draw.BgSquare(5, 5, 5, 5, col, writer);
}
