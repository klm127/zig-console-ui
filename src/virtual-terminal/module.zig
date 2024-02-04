/// Names for some characters
pub const Chars = @import("chars.zig");
/// Virtual Terminal Escape Sequences
pub const Sequences = @import("sequences.zig");

test "virtual-terminal" {
    _ = @import("std").testing.refAllDecls(@This());
}
