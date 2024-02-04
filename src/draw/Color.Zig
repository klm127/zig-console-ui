const vt = @import("../virtual-terminal/module.zig").Sequences;

const _bgLookup: [17][*:0]const u8 = [_][*:0]const u8{
    vt.Format.BG.Black,
    vt.Format.BG.Red,
    vt.Format.BG.Green,
    vt.Format.BG.Yellow,
    vt.Format.BG.Blue,
    vt.Format.BG.Magenta,
    vt.Format.BG.Cyan,
    vt.Format.BG.White,
    vt.Format.BG.Default,
    vt.Format.BG.BrightBlack,
    vt.Format.BG.BrightRed,
    vt.Format.BG.BrightGreen,
    vt.Format.BG.BrightYellow,
    vt.Format.BG.BrightBlue,
    vt.Format.BG.BrightMagenta,
    vt.Format.BG.BrightCyan,
    vt.Format.BG.BrightWhite,
};

const _fgLookup: [17][*:0]const u8 = [_][*:0]const u8{
    vt.Format.FG.Black,
    vt.Format.FG.Red,
    vt.Format.FG.Green,
    vt.Format.FG.Yellow,
    vt.Format.FG.Blue,
    vt.Format.FG.Magenta,
    vt.Format.FG.Cyan,
    vt.Format.FG.White,
    vt.Format.FG.Default,
    vt.Format.FG.BrightBlack,
    vt.Format.FG.BrightRed,
    vt.Format.FG.BrightGreen,
    vt.Format.FG.BrightYellow,
    vt.Format.FG.BrightBlue,
    vt.Format.FG.BrightMagenta,
    vt.Format.FG.BrightCyan,
    vt.Format.FG.BrightWhite,
};

pub const Color = enum(u8) {
    Black = 0,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    Default,
    BrightBlack,
    BrightRed,
    BrightGreen,
    BrightYellow,
    BrightBlue,
    BrightMagenta,
    BrightCyan,
    BrightWhite,
    pub fn BG(self: Color) [*:0]const u8 {
        return _bgLookup[@intFromEnum(self)];
    }
    pub fn FG(self: Color) [*:0]const u8 {
        return _fgLookup[@intFromEnum(self)];
    }

    pub fn Clear(self: Color) [*:0]const u8 {
        _ = self; // autofix
        return vt.Format.Default;
    }
};

test {
    const std = @import("std");
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
