const std = @import("std");

const ESC = [1]u8{0x1b};
const ESC2 = [2]u8{ 0x1b, '[' };

/// Viewport scrolling
pub const Viewport = struct {
    /// Scroll text up by N
    pub fn Up(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}S",
            .{n},
        );
    }
    /// Scroll text down by N
    pub fn Down(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}T",
            .{n},
        );
    }
};

/// Cursor shape
pub const Shape = struct {
    pub const Default = ESC2 ++ "0SPq";
    pub const BlinkBlock = ESC2 ++ "1SPq";
    pub const SteadyBlock = ESC2 ++ "2SPq";
    pub const BlinkUnderline = ESC2 ++ "3SPq";
    pub const SteadyUnderline = ESC2 ++ "4SPq";
    pub const BlinkBar = ESC2 ++ "5SPq";
    pub const SteadyBar = ESC2 ++ "6SPq";
};

/// Cursor visibility
pub const Visibility = struct {
    /// Start cursor blinking
    pub const BlinkEnable = ESC2 ++ "?12h";
    /// Stop cursor blinking
    pub const BlinkDisable = ESC2 ++ "?12l";
    /// Show cursor
    pub const Show = ESC2 ++ "?25h";
    /// Hide cursor
    pub const Hide = ESC2 ++ "?25l";
};

/// Cursor Positioning
pub const Pos = struct {
    /// Reverse Index – Performs the reverse operation of \n, moves cursor up one line, maintains horizontal position, scrolls buffer if necessary. If there are scroll margins set, RI inside the margins will scroll only the contents of the margins, and leave the viewport unchanged. (See Scrolling Margins)
    pub const ReverseIndex = ESC ++ "M";
    /// Save Cursor Position in Memory
    pub const SavePos = ESC ++ "7";
    /// Restore Cursor Position in memory.
    pub const RestorePos = ESC ++ "8";
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn Up(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}A",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn Down(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}B",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn Right(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}C",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn Left(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}D",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn NextLine(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}E",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9
    pub fn PrevLine(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}F",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9; moves cursor to the <n>th position horizontally in the current line
    pub fn HorizontalAbsolute(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}G",
            .{n},
        );
    }
    /// Expects a buffer of at least size 4 for movements of 0-9; moves cursor to the <n>th position vertical in the current col
    pub fn VerticalAbsolute(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}f",
            .{n},
        );
    }
    /// Save cursor, ansi.sys emulation
    pub const SavePosAnsi = ESC2 ++ "s";
    /// Restore cursor, ansi.sys emulation
    pub const RestorePosAnsi = ESC2 ++ "u";
};

pub const Modify = struct {
    /// Insert <n> spaces at current cursor
    pub fn InsertSpace(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}@",
            .{n},
        );
    }
    /// Delete <n> characters, shifting in from right
    pub fn Delete(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}P",
            .{n},
        );
    }
    /// Erase <n> spaces at current cursor (overwrite with space)
    pub fn Erase(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}X",
            .{n},
        );
    }
    /// Erase <n> lines into buffer at cursor position; line cursor is currently on is one of those shifted downwards
    pub fn InsertLine(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}L",
            .{n},
        );
    }
    /// Delete <n> lines, including the one the cursor is on
    pub fn DeleteLine(n: i32, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(
            buf,
            ESC2 ++ "{d}M",
            .{n},
        );
    }
};

/// Text formatting, such as colors
pub const Format = struct {
    /// Background Color
    pub const BG = struct {
        ///Applies non-bold/bright black to background
        pub const Black = ESC2 ++ "40" ++ "m";
        ///Applies non-bold/bright red to background
        pub const Red = ESC2 ++ "41" ++ "m";
        ///Applies non-bold/bright green to background
        pub const Green = ESC2 ++ "42" ++ "m";
        ///Applies non-bold/bright yellow to background
        pub const Yellow = ESC2 ++ "43" ++ "m";
        ///Applies non-bold/bright blue to background
        pub const Blue = ESC2 ++ "44" ++ "m";
        ///Applies non-bold/bright magenta to background
        pub const Magenta = ESC2 ++ "45" ++ "m";
        ///Applies non-bold/bright cyan to background
        pub const Cyan = ESC2 ++ "46" ++ "m";
        ///Applies non-bold/bright white to background
        pub const White = ESC2 ++ "47" ++ "m";
        ///Applies only the background portion of the defaults
        pub const Default = ESC2 ++ "49" ++ "m";
        ///Applies bold/bright black to background
        pub const BrightBlack = ESC2 ++ "100" ++ "m";
        ///Applies bold/bright red to background
        pub const BrightRed = ESC2 ++ "101" ++ "m";
        ///Applies bold/bright green to background
        pub const BrightGreen = ESC2 ++ "102" ++ "m";
        ///Applies bold/bright yellow to background
        pub const BrightYellow = ESC2 ++ "103" ++ "m";
        ///Applies bold/bright blue to background
        pub const BrightBlue = ESC2 ++ "104" ++ "m";
        ///Applies bold/bright magenta to background
        pub const BrightMagenta = ESC2 ++ "105" ++ "m";
        ///Applies bold/bright cyan to background
        pub const BrightCyan = ESC2 ++ "106" ++ "m";
        ///Applies bold/bright white to background
        pub const BrightWhite = ESC2 ++ "107" ++ "m";
        ///Set BG to specified RGB
        pub fn RGB(r: u8, g: u8, b: u8, buf: []u8) ![]u8 {
            return try std.fmt.bufPrint(
                buf,
                ESC2 ++ "48;2;{d};{d};{d}m",
                .{ r, g, b },
            );
        }
        ///Set background color to <s> index in 88 or 256 color table
        pub fn Indexed(n: u8, buf: []u8) ![]u8 {
            return try std.fmt.bufPrint(
                buf,
                ESC2 ++ "48;5;{d}m",
                .{n},
            );
        }
    };
    /// Foreground Color
    pub const FG = struct {
        ///Applies non-bold/bright black to foreground
        pub const Black = ESC2 ++ "30" ++ "m";
        ///Applies non-bold/bright red to foreground
        pub const Red = ESC2 ++ "31" ++ "m";
        ///Applies non-bold/bright green to foreground
        pub const Green = ESC2 ++ "32" ++ "m";
        ///Applies non-bold/bright yellow to foreground
        pub const Yellow = ESC2 ++ "33" ++ "m";
        ///Applies non-bold/bright blue to foreground
        pub const Blue = ESC2 ++ "34" ++ "m";
        ///Applies non-bold/bright magenta to foreground
        pub const Magenta = ESC2 ++ "35" ++ "m";
        ///Applies non-bold/bright cyan to foreground
        pub const Cyan = ESC2 ++ "36" ++ "m";
        ///Applies non-bold/bright white to foreground
        pub const White = ESC2 ++ "37" ++ "m";
        ///Applies only the foreground portion of the defaults
        pub const Default = ESC2 ++ "39" ++ "m";
        ///Applies bold/bright black to foreground
        pub const BrightBlack = ESC2 ++ "90" ++ "m";
        ///Applies bold/bright red to foreground
        pub const BrightRed = ESC2 ++ "91" ++ "m";
        ///Applies bold/bright green to foreground
        pub const BrightGreen = ESC2 ++ "92" ++ "m";
        ///Applies bold/bright yellow to foreground
        pub const BrightYellow = ESC2 ++ "93" ++ "m";
        ///Applies bold/bright blue to foreground
        pub const BrightBlue = ESC2 ++ "94" ++ "m";
        ///Applies bold/bright magenta to foreground
        pub const BrightMagenta = ESC2 ++ "95" ++ "m";
        ///Applies bold/bright cyan to foreground
        pub const BrightCyan = ESC2 ++ "96" ++ "m";
        ///Applies bold/bright white to foreground
        pub const BrightWhite = ESC2 ++ "97" ++ "m";
        ///Set FG to specified RGB
        pub fn RGB(r: u8, g: u8, b: u8, buf: []u8) ![]u8 {
            return try std.fmt.bufPrint(
                buf,
                ESC2 ++ "38;2;{d};{d};{d}m",
                .{ r, g, b },
            );
        }
        ///Set foreground color to <s> index in 88 or 256 color table
        pub fn Indexed(n: u8, buf: []u8) ![]u8 {
            return try std.fmt.bufPrint(
                buf,
                ESC2 ++ "38;5;{d}m",
                .{n},
            );
        }
    };
    ///Restore defaults
    pub const Default = ESC2 ++ "0" ++ "m";
    ///Bold
    pub const Bold = ESC2 ++ "1" ++ "m";
    ///No Bold
    pub const NoBold = ESC2 ++ "22" ++ "m";
    ///Adds underline
    pub const Underline = ESC2 ++ "4" ++ "m";
    ///Removes underline
    pub const NoUnderline = ESC2 ++ "24" ++ "m";
    ///Swaps foreground and background colors
    pub const Negative = ESC2 ++ "7" ++ "m";
    ///Returns foreground/background to normal
    pub const Positive = ESC2 ++ "27" ++ "m";
};

///*Nix style applications often utilize an alternate screen buffer, so that they can modify the entire contents of the buffer, without affecting the application that started them. The alternate buffer is exactly the dimensions of the window, without any scrollback region. For an example of this behavior, consider when vim is launched from bash. Vim uses the entirety of the screen to edit the file, then returning to bash leaves the original buffer unchanged.
pub const Buffer = struct {
    /// Switches to a new alternate screen buffer.
    pub const UseAlternate = ESC ++ "?1049h";
    /// Switches to the main buffer.
    pub const UseMain = ESC ++ "?1049l";
};
