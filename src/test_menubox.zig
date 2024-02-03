const std = @import("std");
const menu = @import("draw/MenuBox.zig");
const vt = @import("virtual-terminal/sequences.zig");

test "?" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const stdout_file = std.io.getStdOut();
    const writer = stdout_file.writer();

    var mb = try menu.CreateMenuBox(allocator, 10, 20);
    mb.SetColors(vt.Format.FG.BrightGreen, vt.Format.BG.Default);
    try mb.Append("hello");
    try mb.Append("hello");
    try mb.Append("hello");
    try mb.Append("hello");
    try mb.Append("this sentence is 20!");
    try mb.Append("this sentence is: 21!");
    try mb.SetSelected(2);
    mb.SelectNext();
    mb.SelectNext();
    mb.SelectPrevious();
    mb.Position.x = 5;
    try mb.Print(writer);
    try mb.Erase(writer);
    try writer.print("\n", .{});
}
