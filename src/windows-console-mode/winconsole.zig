const manager = @import("manager.zig").Manager;
const inOpts = @import("stdin.options.zig").ModeOptions;
const outOpts = @import("stdout.options.zig").ModeOptions;

pub const Manager = manager;
pub const StdinOptions = inOpts;
pub const StdoutOptions = outOpts;