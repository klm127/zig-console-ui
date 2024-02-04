// STDOut Options (ConsoleMode) wrapper struct

const win = @cImport({
    @cInclude("windows.h");
});

const std = @import("std");

/// [Microsoft Docs] https://learn.microsoft.com/en-us/windows/console/setconsolemode
/// Wraps the flags that set Stdouts's console mode on windows. Returns a DWORD with apply method that masks the mode settings over the given parameter. If a setting is "null", the word will not be changed, otherwise the appropriate bit will be set to 1 or 0, and the new word will be returned.
pub const ModeOptions = struct {
    // whether control sequences (like backspace) as processed; should be enabled if using vts
    processed_output: ?bool = null,
    // causes auto scrolling and moving to next and wrap
    wrap_eol: ?bool = null,
    // whether Console Virtual Terminal Sequences can be used
    virtual_terminal: ?bool = null,
    disable_auto_return: ?bool = null,
    lvb_grid_worldwide: ?bool = null,

    fn applyStep(check: ?bool, mask: win.DWORD, mask_to_0: *win.DWORD, mask_to_1: *win.DWORD) void {
        if (check != null) {
            if (check == true) {
                mask_to_1.* = mask_to_1.* | mask;
            } else {
                mask_to_0.* = mask_to_0.* | mask;
            }
        }
    }

    /// Takes an DWORD, generally the existing mode, applies each of its members as the correct bitmask, and returns that DWORD
    pub fn apply(self: *const ModeOptions, original_mode: win.DWORD) win.DWORD {
        var mask_to_0: win.DWORD = 0;
        var mask_to_1: win.DWORD = 0;

        applyStep(self.processed_output, win.ENABLE_PROCESSED_OUTPUT, &mask_to_0, &mask_to_1);
        applyStep(self.wrap_eol, win.ENABLE_WRAP_AT_EOL_OUTPUT, &mask_to_0, &mask_to_1);
        applyStep(self.virtual_terminal, win.ENABLE_VIRTUAL_TERMINAL_PROCESSING, &mask_to_0, &mask_to_1);
        applyStep(self.disable_auto_return, win.DISABLE_NEWLINE_AUTO_RETURN, &mask_to_0, &mask_to_1);
        applyStep(self.lvb_grid_worldwide, win.ENABLE_LVB_GRID_WORLDWIDE, &mask_to_0, &mask_to_1);
        const new_word = ~mask_to_0 & original_mode;
        return new_word | mask_to_1;
    }
};

const expect = std.testing.expect;

test {
    const helpers = struct {
        fn checkOneFlag(opts: *ModeOptions, flag: win.DWORD) !void {
            const result = opts.apply(0);
            try expect((result & flag) == flag);
        }
        fn checkOneFlagOff(opts: *ModeOptions, flag: win.DWORD) !void {
            const result = opts.apply(~@as(win.DWORD, 0));
            try expect(result & flag == 0);
        }
    };

    var tcase1 = ModeOptions{ .processed_output = true, .wrap_eol = true, .virtual_terminal = true, .disable_auto_return = false, .lvb_grid_worldwide = false };
    try helpers.checkOneFlag(&tcase1, win.ENABLE_PROCESSED_OUTPUT);
    try helpers.checkOneFlag(&tcase1, win.ENABLE_WRAP_AT_EOL_OUTPUT);
    try helpers.checkOneFlag(&tcase1, win.ENABLE_VIRTUAL_TERMINAL_PROCESSING);
    try helpers.checkOneFlagOff(&tcase1, win.DISABLE_NEWLINE_AUTO_RETURN);
    try helpers.checkOneFlagOff(&tcase1, win.ENABLE_LVB_GRID_WORLDWIDE);
}
