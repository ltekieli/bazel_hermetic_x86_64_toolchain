load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

URL_TOOLCHAIN = "https://github.com/ltekieli/devboards-toolchains/releases/download/v2022.05.01/"

def toolchains():
    if "x86_64-unknown-linux-gnu" not in native.existing_rules():
        http_archive(
            name = "x86_64-unknown-linux-gnu",
            build_file = Label("//third_party/toolchains:x86_64-unknown-linux-gnu.BUILD"),
            url = URL_TOOLCHAIN + "x86_64-unknown-linux-gnu.tar.gz",
            sha256 = "a91b87056de0edf1e36a6a3d63b5491148e22e2a7e31042057e49b17adc883bb",
        )
