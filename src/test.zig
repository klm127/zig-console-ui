test {
    const builtin = @import("builtin");
    if (builtin.os.tag == .windows) {
        const win = @import("windows-console-mode/module.zig");
        var consManager = win.Manager{};
        try consManager.SaveStdoutMode();
        try consManager.SetStdoutMode(.{
            .virtual_terminal = true,
        });
        defer consManager.RestoreStdout();
    }
    _ = @import("draw/module.zig");
    _ = @import("virtual-terminal/module.zig");
}
