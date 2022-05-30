load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
    "with_feature_set",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

all_compile_actions = [
    ACTION_NAMES.assemble,
    ACTION_NAMES.c_compile,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.lto_backend,
    ACTION_NAMES.preprocess_assemble,
]

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "ar",
            path = "wrappers/x86_64-unknown-linux-gnu-ar",
        ),
        tool_path(
            name = "cpp",
            path = "wrappers/x86_64-unknown-linux-gnu-cpp",
        ),
        tool_path(
            name = "gcc",
            path = "wrappers/x86_64-unknown-linux-gnu-gcc",
        ),
        tool_path(
            name = "gcov",
            path = "wrappers/x86_64-unknown-linux-gnu-gcov",
        ),
        tool_path(
            name = "ld",
            path = "wrappers/x86_64-unknown-linux-gnu-ld",
        ),
        tool_path(
            name = "nm",
            path = "wrappers/x86_64-unknown-linux-gnu-nm",
        ),
        tool_path(
            name = "objdump",
            path = "wrappers/x86_64-unknown-linux-gnu-objdump",
        ),
        tool_path(
            name = "strip",
            path = "wrappers/x86_64-unknown-linux-gnu-strip",
        ),
    ]

    default_compiler_flags = feature(
        name = "default_compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-fPIC",
                            "--sysroot=external/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sysroot",
                            "-no-canonical-prefixes",
                            "-fno-canonical-system-headers",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "--sysroot=external/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sysroot",
                            "-lstdc++",
                        ],
                    ),
                ]),
            ),
            flag_set(
                actions = [
                    ACTION_NAMES.cpp_link_dynamic_library,
                    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
                    ACTION_NAMES.lto_index_for_dynamic_library,
                    ACTION_NAMES.lto_index_for_nodeps_dynamic_library,
                ],
                flag_groups = [
                    flag_group(
                        flags = [
                            "-fPIC",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = [
                    ACTION_NAMES.cpp_link_executable,
                    ACTION_NAMES.lto_index_for_executable,
                ],
                flag_groups = [
                    flag_group(
                        flags = [
                            "-pie",
                        ],
                    ),
                ],
            ),
        ],
    )

    # This feature is used when shared objects are used, eg. with cc_test.
    # The shared libs will be linked into the directory of the executable.
    # The 'runtime_library_search_directories' variable represents the path
    # that is linked for a particular dependency.
    runtime_library_search_directories_flags = feature(
        name = "runtime_library_search_directories",
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        iterate_over = "runtime_library_search_directories",
                        flag_groups = [
                            flag_group(
                                flags = [
                                    "-Wl,--rpath=$ORIGIN/%{runtime_library_search_directories}",
                                ],
                            ),
                        ],
                        expand_if_available = "runtime_library_search_directories",
                    ),
                ],
            ),
        ],
    )

    # Enables creation and usage of shared objects.
    supports_dynamic_linker_flags = feature(
        name = "supports_dynamic_linker",
        enabled = True,
    )

    # Enables the posibility to choose between a static or dynamic runtime.
    # The 'dynamic_runtime_lib' and 'static_runtime_lib' needs to point to
    # a file/filegroup with respective libraries. The shared libraries from
    # 'dynamic_runtime_lib' will be symlinked to the executable directory
    # and added to the 'runtime_library_search_directories'.
    static_link_cpp_runtimes_feature = feature(
        name = "static_link_cpp_runtimes",
        enabled = True,
    )

    features = [
        default_compiler_flags,
        default_linker_flags,
        runtime_library_search_directories_flags,
        supports_dynamic_linker_flags,
        static_link_cpp_runtimes_feature,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        toolchain_identifier = "x86_64-toolchain",
        host_system_name = "local",
        target_system_name = "unknown",
        target_cpu = "unknown",
        target_libc = "unknown",
        compiler = "unknown",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
