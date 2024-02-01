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

    try cons.RestoreStdout();
}
