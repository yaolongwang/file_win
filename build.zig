const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{ .os_tag = .windows, .cpu_arch = .x86_64 },
    });

    const optimize: std.builtin.OptimizeMode = .ReleaseSmall;

    const payload_files = [_][]const u8{
        "payload/file-real.exe",
        "payload/libmagic-1.dll",
        "payload/libsystre-0.dll",
        "payload/libtre-5.dll",
        "payload/magic.mgc",
    };
    const payload_names = [_][]const u8{
        "file-real.exe",
        "libmagic-1.dll",
        "libsystre-0.dll",
        "libtre-5.dll",
        "magic.mgc",
    };

    const Blake3 = std.crypto.hash.Blake3;
    const payload_hash_bytes = 8;

    const io = b.graph.io;
    var hasher = Blake3.init(.{});
    var sizes: [payload_files.len]u64 = undefined;
    // 指纹：按固定顺序拼接 name\0bytes\0。
    for (payload_files, payload_names, 0..) |path, name, i| {
        const data = std.Io.Dir.cwd().readFileAlloc(io, path, b.allocator, .limited(64 * 1024 * 1024)) catch |err| {
            std.debug.panic("read {s}: {s}", .{ path, @errorName(err) });
        };
        hasher.update(name);
        hasher.update(&[_]u8{0});
        hasher.update(data);
        hasher.update(&[_]u8{0});
        sizes[i] = data.len;
    }
    var digest: [payload_hash_bytes]u8 = undefined;
    hasher.final(&digest);
    const hex = std.fmt.bytesToHex(digest, .lower);
    const payload_hash_hex = b.dupe(hex[0..]);

    const opts = b.addOptions();
    opts.addOption([]const u8, "payload_hash_hex", payload_hash_hex);
    opts.addOption(u64, "size_file_real_exe", sizes[0]);
    opts.addOption(u64, "size_libmagic_1_dll", sizes[1]);
    opts.addOption(u64, "size_libsystre_0_dll", sizes[2]);
    opts.addOption(u64, "size_libtre_5_dll", sizes[3]);
    opts.addOption(u64, "size_magic_mgc", sizes[4]);

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addOptions("build_options", opts);
    exe_mod.addAnonymousImport("file_real_exe", .{ .root_source_file = b.path("payload/file-real.exe") });
    exe_mod.addAnonymousImport("libmagic_1_dll", .{ .root_source_file = b.path("payload/libmagic-1.dll") });
    exe_mod.addAnonymousImport("libsystre_0_dll", .{ .root_source_file = b.path("payload/libsystre-0.dll") });
    exe_mod.addAnonymousImport("libtre_5_dll", .{ .root_source_file = b.path("payload/libtre-5.dll") });
    exe_mod.addAnonymousImport("magic_mgc", .{ .root_source_file = b.path("payload/magic.mgc") });

    const exe = b.addExecutable(.{
        .name = "file",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    b.step("run", "Run the wrapped file.exe").dependOn(&run_cmd.step);
}
