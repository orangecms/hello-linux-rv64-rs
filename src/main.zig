const std = @import("std");
const builtin = @import("builtin");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const arch = switch (builtin.cpu.arch) {
        .x86_64 => "x86_64",
        .aarch64 => "ARM64",
        .riscv64 => "RISC-V", // .riscv32 - don't work (need all features in baseline)
        .mipsel => "MIPS32 Little Endian",
        else => @compileError("Unsupported CPU Architecture"),
    };
    try stdout.print("\nLet's have a look at your shiny {s} system! :)\n\n", .{arch});

    // Read HW linux info

    if (builtin.os.tag != .linux) {
        @compileError("Unsupported another OS");
    }

    var buf: [100]u8 = undefined;
    const cpuinfo = try std.fs.openFileAbsolute("/proc/cpuinfo", .{});
    defer cpuinfo.close();
    _ = try cpuinfo.readAll(&buf);
    try stdout.print("cpuinfo:\n{s}\n", .{buf});

    try stdout.print("\n\n", .{});

    var mbuf: [84]u8 = undefined;
    const meminfo = try std.fs.openFileAbsolute("/proc/meminfo", .{});
    defer meminfo.close();
    _ = try meminfo.readAll(&mbuf);
    try stdout.print("meminfo:\n{s}\n", .{mbuf});

    var cmdbuf: [93]u8 = undefined;
    const cmdline = try std.fs.openFileAbsolute("/proc/cmdline", .{});
    defer cmdline.close();
    _ = try cmdline.readAll(&cmdbuf);
    try stdout.print("cmdline:\n{s}\n", .{cmdbuf});
}
