const std = @import("std");
const builtin = @import("builtin");
const filestream = std.fs.openFileAbsolute;
const stdoutFile = std.io.getStdOut();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    // .riscv32 - don't work:
    // https://github.com/ziglang/zig/blob/c955379504d4866f9c474c50317b2a0da18ee631/lib/std/os/linux.zig#L35-L44
    const arch = switch (builtin.cpu.arch) {
        .x86_64 => "x86_64",
        .aarch64 => "ARM64",
        .riscv64 => "RISC-V",
        .mipsel, .mips => "MIPS",
        else => @compileError("Unsupported CPU Architecture"),
    };
    try stdout.print("\nLet's have a look at your shiny {s} system! :)\n\n", .{arch});

    // Read HW linux info

    if (builtin.os.tag != .linux) {
        @compileError("Unsupported another OS");
    }

    const cpuinfo = try filestream("/proc/cpuinfo", .{});
    defer cpuinfo.close();
    try stdout.print("cpuinfo:\n", .{});
    try stdoutFile.writeFileAll(cpuinfo, .{});

    var buf: [84]u8 = undefined;
    const meminfo = try filestream("/proc/meminfo", .{});
    defer meminfo.close();
    _ = try meminfo.readAll(&buf);
    try stdout.print("meminfo:\n{s}\n", .{buf});

    var cmdbuf: [93]u8 = undefined;
    const cmdline = try filestream("/proc/cmdline", .{});
    defer cmdline.close();

    _ = try cmdline.readAll(&cmdbuf);
    try stdout.print("cmdline:\n{s}\n", .{cmdbuf});

    // detect leak memory on (debug or ReleaseSafe)
    var safeAlloc = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = safeAlloc.allocator();

    const uname = try std.ChildProcess.exec(.{ .allocator = allocator, .argv = &[_][]const u8{ "uname", "-a" } });
    try stdout.print("kernel:\n{s}", .{uname.stdout});
}
