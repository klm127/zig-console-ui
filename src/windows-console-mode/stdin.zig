const win = @cImport({
    @cInclude("windows.h");
});

const std = @import("std");

// see: https://learn.microsoft.com/en-us/windows/console/setconsolemode
// Wraps the flags that set Stdin's console mode. Can produce a DWORD with apply method that masks the mode settings appropriately over the given parameter word. If a setting is "null", the word will not be changed, otherwise the appropriate bit will be set to 1 or 0.
const stdinModeOptions = struct {
    echo: ?bool = null,
    insert: ?bool = null,
    // whether readConsole returns only at carriage return; if false, returns for every character pressed
    line_input: ?bool = null,
    // whether to generate mouseEvents
    mouse_input: ?bool = null,
    // if true, ctrl+c and other control keys are not placed in the input buffer
    processed_input: ?bool = null,
    // allow user to select and edit text with mouse
    quick_edit_mode: ?bool = null,
    // whether resize events reported in console input buffer
    window_input: ?bool = null,
    // whether user input is converted to Console Virtual Terminal Sequences
    virtual_terminal_input: ?bool = null,

    fn applyStep(check: ?bool, mask: win.DWORD, mask_to_0: *win.DWORD, mask_to_1: *win.DWORD) void {
        if (check != null) {
            if (check == true) {
                mask_to_1.* = mask_to_1.* | mask;
            } else {
                mask_to_0.* = mask_to_0.* | mask;
            }
        }
    }

    // Takes an DWORD and applies each of the masks appropriately
    pub fn apply(self: *stdinModeOptions, original_mode: win.DWORD) win.DWORD {
        var mask_to_0: win.DWORD = 0;
        var mask_to_1: win.DWORD = 0;

        applyStep(self.echo, win.ENABLE_ECHO_INPUT, &mask_to_0, &mask_to_1);
        applyStep(self.insert, win.ENABLE_INSERT_MODE, &mask_to_0, &mask_to_1);
        applyStep(self.line_input, win.ENABLE_LINE_INPUT, &mask_to_0, &mask_to_1);
        applyStep(self.mouse_input, win.ENABLE_MOUSE_INPUT, &mask_to_0, &mask_to_1);
        applyStep(self.processed_input, win.ENABLE_PROCESSED_INPUT, &mask_to_0, &mask_to_1);
        applyStep(self.quick_edit_mode, win.ENABLE_QUICK_EDIT_MODE, &mask_to_0, &mask_to_1);
        applyStep(self.window_input, win.ENABLE_WINDOW_INPUT, &mask_to_0, &mask_to_1);
        applyStep(self.virtual_terminal_input, win.ENABLE_VIRTUAL_TERMINAL_INPUT, &mask_to_0, &mask_to_1);

        var new_word = ~mask_to_0 & original_mode;
        new_word = new_word | mask_to_1;
        return new_word;
    }
};

const expect = std.testing.expect;

test "StdinModeOptions" {
    const helpers = struct {
        fn checkOneFlag(opts: *stdinModeOptions, flag: win.DWORD) !void {
            const result = opts.apply(0);
            try expect((result & flag) == flag);
        }
        fn checkOneFlagOff(opts: *stdinModeOptions, flag: win.DWORD) !void {
            const result = opts.apply(~@as(win.DWORD, 0));
            try expect(result & flag == 0);
        }
    };

    var tcase1 = stdinModeOptions{ .echo = true, .insert = true, .line_input = true, .mouse_input = true, .processed_input = false, .quick_edit_mode = false, .window_input = false, .virtual_terminal_input = false };
    try helpers.checkOneFlag(&tcase1, win.ENABLE_ECHO_INPUT);
    try helpers.checkOneFlag(&tcase1, win.ENABLE_INSERT_MODE);
    try helpers.checkOneFlag(&tcase1, win.ENABLE_LINE_INPUT);
    try helpers.checkOneFlag(&tcase1, win.ENABLE_MOUSE_INPUT);
    try helpers.checkOneFlagOff(&tcase1, win.ENABLE_PROCESSED_INPUT);
    try helpers.checkOneFlagOff(&tcase1, win.ENABLE_QUICK_EDIT_MODE);
    try helpers.checkOneFlagOff(&tcase1, win.ENABLE_WINDOW_INPUT);
    try helpers.checkOneFlagOff(&tcase1, win.ENABLE_VIRTUAL_TERMINAL_INPUT);

    var tcase2 = stdinModeOptions{ .echo = false, .insert = false, .line_input = false, .mouse_input = false, .processed_input = true, .quick_edit_mode = true, .window_input = true, .virtual_terminal_input = true };
    try helpers.checkOneFlagOff(&tcase2, win.ENABLE_ECHO_INPUT);
    try helpers.checkOneFlagOff(&tcase2, win.ENABLE_INSERT_MODE);
    try helpers.checkOneFlagOff(&tcase2, win.ENABLE_LINE_INPUT);
    try helpers.checkOneFlagOff(&tcase2, win.ENABLE_MOUSE_INPUT);
    try helpers.checkOneFlag(&tcase2, win.ENABLE_PROCESSED_INPUT);
    try helpers.checkOneFlag(&tcase2, win.ENABLE_QUICK_EDIT_MODE);
    try helpers.checkOneFlag(&tcase2, win.ENABLE_WINDOW_INPUT);
    try helpers.checkOneFlag(&tcase2, win.ENABLE_VIRTUAL_TERMINAL_INPUT);
}
