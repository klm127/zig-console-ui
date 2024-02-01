const draw = @import("draw/square.zig");
const vt = @import("virtual-terminal/sequences.zig");
const std = @import("std");

test "drawSquare" {
    const stdout = std.io.getStdOut();
    const writer = stdout.writer();

    _ = try draw.BgSquare(5, 5, 5, 5, vt.Format.BG.Blue, writer);
    _ = try draw.BgSquare(30, 2, 6, 20, vt.Format.BG.Green, writer);
}
