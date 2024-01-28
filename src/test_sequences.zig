test "sequences" {
    const std = @import("std");
    const vt = @import("virtual-terminal/sequences.zig");
    const wc = @import("windows-console-mode/winconsole.zig");

    var cons = wc.Manager{};
    try cons.SaveStdoutMode();
    const outOpts = wc.StdoutOptions{
        .virtual_terminal = true,
    };
    try cons.SetStdoutMode(&outOpts);

    std.debug.print("{s}", .{
        vt.Formatting.BackgroundBlue ++ "\nHello\n" ++ vt.Formatting.Default,
    });

    try cons.RestoreStdout();
}
