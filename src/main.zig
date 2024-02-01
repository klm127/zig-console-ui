const std = @import("std");
const VT = @import("virtual-terminal/sequences.zig");
const WC = @import("./windows-console-mode/winconsole.zig");

pub fn main() !void {
    // // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // const cons = WC.Manager{};
    // try cons.SaveStdoutMode();
    // try cons.RestoreStdout();
    // cons.SetStdoutMode(WC.StdoutOptions{
    //     .virtual_terminal = true,
    // });

    var cons = WC.Manager{};
    try cons.SaveStdoutMode();
    try cons.SetStdoutMode(.{
        .virtual_terminal = true,
    });
    std.debug.print(VT.Format.BG.Red ++ "Hi!\n" ++ VT.Format.BG.Default, .{});

    const sout = std.io.getStdOut();
    const writer = sout.writer();
    _ = writer; // autofix
    try cons.RestoreStdout();
}
