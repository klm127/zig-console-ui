const win = @cImport({
    @cInclude("windows.h");
});

// see: https://learn.microsoft.com/en-us/windows/console/setconsolemode
const stdoutModeOptions = struct {
    // whether control sequences (like backspace) as processed; should be enabled if using vts
    processed_output: ?bool,
    // causes auto scrolling and moving to next and wrap
    wrap_eol: ?bool,
    // whether Console Virtual Terminal Sequences can be used
    virtual_terminal: ?bool,
    disable_auto_return: ?bool,
    lvb_grid_worldwide: ?bool,
};
