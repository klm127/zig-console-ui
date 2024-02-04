const _MenuBox = @import("Menubox.zig");

/// Representing a console coordinate
pub const Coord = @import("Coord.zig").Coord;

/// Enums that can retrieve VT color strings.
pub const Color = @import("Color.zig").Color;

/// A (possibly) colorful, bordered menu that can have an item selected.
pub const MenuBox = struct {
    /// Create a new MenuBox with the specified parameters
    pub const Create = _MenuBox.CreateMenuBox;
};

test "draw" {
    _ = @import("std").testing.refAllDecls(@This());
    _ = @import("MenuBox.zig");
}
