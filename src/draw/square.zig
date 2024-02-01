const vt = @import("../virtual-terminal/sequences.zig");
const std = @import("std");

pub fn BgSquare(x: u8, y: u8, h: u8, w: u8, colorCode: []const u8, writer: std.fs.File.Writer) !usize {
    var written: usize = 0;
    written += try writer.write(&vt.Pos.To(x, y));
    written += try writer.write(colorCode);
    try writer.writeByteNTimes('#', w);
    written += w;
    try writer.writeByte('\n');
    written += 1;
    var i = h - 1;
    while (i > 0) {
        written += try writer.write(&vt.Pos.HorizontalAbsolute(x));
        try writer.writeByte('#');
        try writer.writeByteNTimes(' ', w - 2);
        try writer.writeByte('#');
        try writer.writeByte('\n');
        written += w + 1;
        i -= 1;
    }
    written += try writer.write(&vt.Pos.HorizontalAbsolute(x));
    try writer.writeByteNTimes('#', w);
    written += w;
    try writer.writeByte('\n');
    written += 1;
    written += try writer.write(vt.Format.Default);
    // var horposbuf: [10]u8 = undefined;
    // const horposbuf_cast = @as(*[]u8, @alignCast(@ptrCast(&horposbuf)));
    // var verposbuf: [10]u8 = undefined;
    // const verposbuf_cast = @as(*[]u8, @alignCast(@ptrCast(&verposbuf)));
    // _ = try vt.Pos.HorizontalAbsolute(y, horposbuf_cast);
    // _ = try vt.Pos.VerticalAbsolute(x, verposbuf_cast);

    // const horline = colorCode ++ ([_]u8{' '} ** w) ++ vt.Format.Default ++ [1]u8{'\n'};
    // const horline_end = horposbuf ++ colorCode ++ [_]u8{' '} ++ vt.Format.Default;
    // const horline_mid = horline_end ++ [_]u8{' '} ** (w - 2) ++ horline_end ++ [1]u8{'\n'};
    // const s = "   ";
    // _ = s; // autofix

    // var alltext = horposbuf ++ verposbuf ++ horline;

    // for (0..(h - 2)) |i| {
    //     _ = i; // autofix
    //     alltext = alltext ++ horline_mid;
    // }

    // alltext = alltext ++ horposbuf ++ horline;

    // try writer.print(
    //     alltext,
    //     .{},
    // );
    return written;
}
