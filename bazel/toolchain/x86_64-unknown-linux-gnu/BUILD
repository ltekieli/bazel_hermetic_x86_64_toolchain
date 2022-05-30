package(default_visibility = ["//visibility:public"])

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

filegroup(name = "empty")

filegroup(
    name = "wrappers",
    srcs = glob([
        "wrappers/**",
    ]),
)

filegroup(
    name = "all_files",
    srcs = [
        ":wrappers",
        "@x86_64-unknown-linux-gnu//:toolchain",
    ],
)

cc_toolchain_config(name = "x86_64_toolchain_config")

cc_toolchain(
    name = "x86_64_toolchain",
    all_files = ":all_files",
    ar_files = ":all_files",
    compiler_files = ":all_files",
    dwp_files = ":empty",
    dynamic_runtime_lib = "@x86_64-unknown-linux-gnu//:dynamic_runtime",
    linker_files = ":all_files",
    objcopy_files = ":empty",
    static_runtime_lib = ":empty",
    strip_files = ":all_files",
    toolchain_config = ":x86_64_toolchain_config",
    toolchain_identifier = "x86_64-toolchain",
)

toolchain(
    name = "x86_64_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":x86_64_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
