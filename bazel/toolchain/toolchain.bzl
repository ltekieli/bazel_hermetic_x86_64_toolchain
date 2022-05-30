def register_all_toolchains():
    native.register_toolchains(
        "//bazel/toolchain/x86_64-unknown-linux-gnu:x86_64_linux_toolchain",
    )
