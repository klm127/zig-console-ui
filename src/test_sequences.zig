const std = @import("std");
const vt = @import("virtual-terminal/sequences.zig");
const wc = @import("windows-console-mode/winconsole.zig");

test "sequences" {
    var cons = wc.Manager{};
    try cons.SaveStdoutMode();
    const outOpts = wc.StdoutOptions{
        .virtual_terminal = true,
    };
    try cons.SetStdoutMode(outOpts);

    std.debug.print("{s}{s}", .{ vt.Pos.To(60, 10), "WHATS UP!" });

    std.debug.print("{s}", .{vt.Format.BG.Blue ++ "\nHello\n" ++ vt.Format.Default});

    std.debug.print("\n\t{s}R{s}G{s}B{s}\n", .{
        vt.Format.BG.RGB(200, 10, 10),
        vt.Format.BG.Default ++ vt.Format.FG.RGB(5, 255, 50),
        vt.Format.FG.Default ++ vt.Format.BG.RGB(100, 100, 255),
        vt.Format.Default,
    });

    try cons.RestoreStdout();
}
