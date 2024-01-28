const win = @cImport({
    @cInclude("windows.h");
});

const stdinOptions = @import("./stdin.options.zig").ModeOptions;
const stdoutOptions = @import("./stdout.options.zig").ModeOptions;

const std = @import("std");

const ManagerErrors = error{ NoSavedMode, NoConsoleMode, InvalidHandle, CouldntSetMode, WrongOptionsType };

/// Performs windows calls to set the console mode. SaveStdinMode / SaveStdOutMode must be called first to store the original mode so that it can be restored before the program is done. (Otherwise the console will be stuck with your settings)
pub const Manager = struct {
    saved_stdin: ?win.DWORD = null,
    saved_stdout: ?win.DWORD = null,
    last_stdin: ?win.DWORD = null,
    last_stdout: ?win.DWORD = null,

    /// Save the current mode of Stdin
    pub fn SaveStdinMode(self: *Manager) !void {
        const in_handle: win.HANDLE = win.GetStdHandle(win.STD_INPUT_HANDLE);
        if (in_handle == win.INVALID_HANDLE_VALUE) {
            return ManagerErrors.InvalidHandle;
        }
        var found: win.DWORD = undefined;
        const success = win.GetConsoleMode(in_handle, &found);
        if (success == 0) return ManagerErrors.NoConsoleMode;
        self.saved_stdin = found;
    }
    /// Save the current mode of Stdout
    pub fn SaveStdoutMode(self: *Manager) !void {
        const in_handle: win.HANDLE = win.GetStdHandle(win.STD_OUTPUT_HANDLE);
        if (in_handle == win.INVALID_HANDLE_VALUE) {
            return ManagerErrors.InvalidHandle;
        }
        var found: win.DWORD = undefined;
        const success = win.GetConsoleMode(in_handle, &found);
        if (success == 0) return ManagerErrors.NoConsoleMode;
        self.saved_stdout = found;
    }

    /// Restore Stdin from save
    pub fn RestoreStdin(self: *Manager) !void {
        if (self.saved_stdin == null) {
            return ManagerErrors.NoSavedMode;
        }
        try self._SetStdinMode(self.saved_stdin.?);
    }

    /// Restore Stdout from save
    pub fn RestoreStdout(self: *Manager) !void {
        if (self.saved_stdout == null) {
            return ManagerErrors.NoSavedMode;
        }
        try self._SetStdoutMode(self.saved_stdout.?);
    }

    /// private, internal for directly setting Stdin mode
    fn _SetStdinMode(self: *Manager, to: win.DWORD) !void {
        const in_handle = win.GetStdHandle(win.STD_INPUT_HANDLE);
        if (in_handle == win.INVALID_HANDLE_VALUE) {
            return ManagerErrors.InvalidHandle;
        }
        const result = win.SetConsoleMode(in_handle, to);
        if (result == 0) {
            return ManagerErrors.CouldntSetMode;
        }
        self.last_stdin = to;
    }

    /// private, internal, for directly setting Stdout mode
    fn _SetStdoutMode(self: *Manager, to: win.DWORD) !void {
        const in_handle = win.GetStdHandle(win.STD_OUTPUT_HANDLE);
        if (in_handle == win.INVALID_HANDLE_VALUE) {
            return ManagerErrors.InvalidHandle;
        }
        const result = win.SetConsoleMode(in_handle, to);
        if (result == 0) {
            return ManagerErrors.CouldntSetMode;
        }
        self.last_stdout = to;
    }

    /// Set Stdin mode from an options object
    pub fn SetStdinMode(self: *Manager, to: stdinOptions) !void {
        if (self.saved_stdin == null) {
            return ManagerErrors.NoSavedMode;
        }
        const new_mode = to.apply(self.saved_stdin.?);
        try self._SetStdinMode(new_mode);
    }

    /// Set Stdout mode from an options object
    pub fn SetStdoutMode(self: *Manager, to: stdoutOptions) !void {
        if (self.saved_stdin == null) {
            return ManagerErrors.NoSavedMode;
        }
        const new_mode = to.apply(self.saved_stdout.?);
        try self._SetStdinMode(new_mode);
    }
};

test {
    var m = Manager{};

    try m.SaveStdinMode();
    try m.RestoreStdin();
    try m.SaveStdoutMode();
    try m.RestoreStdout();
}
