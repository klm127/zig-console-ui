const std = @import("std");

const virt = @import("../virtual-terminal/module.zig");
const vt = virt.Sequences;
const char = virt.Chars;
const Coord = @import("Coord.zig").Coord;

const MenuboxError = error{ TooManyItems, MenuOutOfBounds };

const Menubox = struct {
    Position: Coord,
    Dimensions: Coord,
    content: []u8,
    selected: ?u8 = null,
    len: u8 = 0,
    borderBg: [*:0]const u8 = vt.Format.BG.Default,
    borderFg: [*:0]const u8 = vt.Format.FG.Default,
    innerBg: [*:0]const u8 = vt.Format.BG.Default,
    innerFg: [*:0]const u8 = vt.Format.FG.Default,
    selectedBg: [*:0]const u8 = vt.Format.BG.BrightBlue,
    selectedFg: [*:0]const u8 = vt.Format.FG.Black,

    fn _printTopBorder(self: *Menubox, writer: std.fs.File.Writer) !void {
        try writer.print("{s}{s}", .{ self.borderBg, self.borderFg });
        try writer.writeByte(char.Border.Thick.NW);
        try writer.writeByteNTimes(char.Border.Thick.Horizontal, self.Dimensions.x);
        try writer.writeByte(char.Border.Thick.NE);
        try writer.print("{s}", .{vt.Format.Default});
    }

    fn _printBottomBorder(self: *Menubox, writer: std.fs.File.Writer) !void {
        try writer.print("{s}{s}", .{ self.borderBg, self.borderFg });
        try writer.writeByte(char.Border.Thick.SW);
        try writer.writeByteNTimes(char.Border.Thick.Horizontal, self.Dimensions.x);
        try writer.writeByte(char.Border.Thick.SE);
        try writer.print("{s}", .{vt.Format.Default});
    }

    fn _printRow(self: *Menubox, writer: std.fs.File.Writer, row: usize) !void {
        try writer.print("{s}{s}", .{ self.borderBg, self.borderFg });
        try writer.writeByte(char.Border.Thick.Vertical);
        if (self.selected != null and row == self.selected.?) {
            try writer.print("{s}{s}", .{ self.selectedBg, self.selectedFg });
        } else {
            try writer.print("{s}{s}", .{ self.innerBg, self.innerFg });
        }
        const start_at = row * self.Dimensions.x;
        const end_at = start_at + self.Dimensions.x;
        for (start_at..end_at) |i| {
            try writer.writeByte(self.content[i]);
        }
        try writer.print("{s}{s}", .{ self.borderBg, self.borderFg });
        try writer.writeByte(char.Border.Thick.Vertical);
        try writer.print("{s}", .{vt.Format.Default});
    }

    /// Draws the menu box.
    pub fn Print(self: *Menubox, writer: std.fs.File.Writer) !void {
        try writer.print("{s}", .{
            vt.Pos.To(self.Position.x, self.Position.y),
        });
        try self._printTopBorder(writer);
        try writer.writeByte('\n');

        for (0..self.Dimensions.y) |y| {
            try writer.print("{s}", .{vt.Pos.HorizontalAbsolute(self.Position.x)});
            try self._printRow(writer, y);
            try writer.writeByte('\n');
        }
        try writer.print("{s}", .{vt.Pos.HorizontalAbsolute(self.Position.x)});
        try self._printBottomBorder(writer);
    }

    /// Print whitespace over the Menubox area..
    pub fn Erase(self: *Menubox, writer: std.fs.File.Writer) !void {
        try writer.print("{s}", .{vt.Pos.To(self.Position.x, self.Position.y)});
        for (0..self.Dimensions.y + 2) |_| {
            try writer.print("{s}", .{vt.Pos.HorizontalAbsolute(self.Position.x)});
            for (0..self.Dimensions.x + 2) |_| {
                try writer.writeByte(' ');
            }
            try writer.writeByte('\n');
        }
    }

    /// Appends text to the content of the menu box. Each item of text is associated with a single row, which is where it will print, and what will be indicated as selected. It will return an error of the Menubox isn't tall enough for additional items. Strings that are too long will simply be truncated.
    pub fn Append(self: *Menubox, text: [*:0]const u8) !void {
        if (self.len == self.Dimensions.y) return MenuboxError.TooManyItems;
        var i = self.Dimensions.x * self.len;
        const end_i = i + self.Dimensions.x;
        var c = text[0];
        var text_i: u8 = 0;
        while ((i < end_i) and !(c == 0)) {
            self.content[i] = text[text_i];
            text_i += 1;
            c = text[text_i];
            i += 1;
        }
        self.len += 1;
    }

    /// Set the selected index. Index cannot be greater than the number of entries.
    pub fn SetSelected(self: *Menubox, index: u8) !void {
        if (index >= self.len) {
            return MenuboxError.MenuOutOfBounds;
        }
        self.selected = index;
    }

    /// Unselect any selected.
    pub fn Unselect(self: *Menubox) void {
        self.selected = null;
    }

    /// Select the next item; wrap around to the first.
    pub fn SelectNext(self: *Menubox) void {
        if (self.selected != null) {
            var new_selection = self.selected.? + 1;
            if (new_selection >= self.len) {
                new_selection = 0;
            }
            self.selected = new_selection;
        }
    }

    /// Select the previous item; wrap around to the first.
    pub fn SelectPrevious(self: *Menubox) void {
        if (self.selected != null) {
            var new_selection = self.len - 1;
            if (self.selected.? != 0) {
                new_selection = self.selected.? - 1;
                self.selected = new_selection;
            }
        }
    }

    pub fn SetColors(self: *Menubox, borderFg: [*:0]const u8, borderBg: [*:0]const u8) void {
        self.borderBg = borderBg;
        self.borderFg = borderFg;
    }
};

const MenuboxCreationOptions = struct {
    X: u8 = 0,
    Y: u8 = 0,
    BorderBackground: [*:0]const u8 = vt.Format.BG.Default,
    BorderForeground: [*:0]const u8 = vt.Format.FG.Default,
};

pub fn CreateMenuBox(allocator: std.mem.Allocator, h: u8, w: u8) !Menubox {
    const tot_len = h * w;
    const content = try allocator.alloc(u8, tot_len);
    for (0..tot_len) |i| {
        content[i] = ' ';
    }
    return Menubox{
        .Position = Coord{},
        .Dimensions = Coord{
            .y = h,
            .x = w,
        },
        .content = content,
    };
}

test {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const stdout_file = std.io.getStdOut();
    const writer = stdout_file.writer();

    var mb = try CreateMenuBox(allocator, 10, 20);
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
    try mb.Print(writer);
    try writer.print("\n", .{});
}
