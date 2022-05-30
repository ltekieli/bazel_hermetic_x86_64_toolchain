package(default_visibility = ["//visibility:public"])

filegroup(
  name = "toolchain",
  srcs = glob([
    "**",
  ]),
)

filegroup(
  name = "dynamic_runtime",
  srcs = [
    "x86_64-unknown-linux-gnu/sysroot/lib/libc.so.6",
    "x86_64-unknown-linux-gnu/sysroot/lib/libm.so.6",
  ] +
  glob([
    "x86_64-unknown-linux-gnu/sysroot/lib/libgcc_s*.so*",
    "x86_64-unknown-linux-gnu/sysroot/lib/libstdc++*.so*",
  ]),
)
