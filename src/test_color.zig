const Color = @import("./draw/Color.zig").Color;
const std = @import("std");

test "ColorWork" {
    const blue = Color.Blue;
    const default = Color.Default;
    const red = Color.BrightRed;
    std.debug.print("\n{s}Blue!{s} then {s}Red!{s}\n", .{
        blue.BG(),
        default.BG(),
        red.FG(),
        red.Clear(),
    });
}
