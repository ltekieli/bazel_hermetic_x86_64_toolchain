# Sandbox for creating a hermetic x86_64 GCC toolchain for bazel

## How to use
Using standard toolchain discovered by bazel:
```
bazel build //...
bazel test //...
```

Using hermetic configuration:
```
bazel build --config=hermetic //...
bazel test --config=hermetic //...
```

## Notes

Currently the test library and executable are linked correctly to shared objects from the toolchain.
However, the dynamic linker is still wrong. This might work on some distributions, depending on the
version of the dynamic linker used.

cc_test binary:
```
$ ldd bazel-bin/hello_test
	linux-vdso.so.1 (0x00007ffd53ff6000)
	liblib1_Sliblib1.so => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib_unknown/liblib1_Sliblib1.so (0x00007f0c347e3000)
	liblib2_Sliblib2.so => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib_unknown/liblib2_Sliblib2.so (0x00007f0c347de000)
	libc.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libc.so.6 (0x00007f0c345e3000)
	libm.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libm.so.6 (0x00007f0c34506000)
	libgcc_s.so.1 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libgcc_s.so.1 (0x00007f0c344ef000)
	libstdc++.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libstdc++.so.6 (0x00007f0c34344000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f0c347ef000)
```

cc_binary with linkstatic=False
```
$ ldd bazel-bin/hello
	linux-vdso.so.1 (0x00007ffece12f000)
	liblib1_Sliblib1.so => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib_unknown/liblib1_Sliblib1.so (0x00007ff681c63000)
	liblib2_Sliblib2.so => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib_unknown/liblib2_Sliblib2.so (0x00007ff681c5e000)
	libc.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libc.so.6 (0x00007ff681a63000)
	libm.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libm.so.6 (0x00007ff681986000)
	libgcc_s.so.1 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libgcc_s.so.1 (0x00007ff68196f000)
	libstdc++.so.6 => /home/tekieli/workspace/bazel_hermetic_x86_64_toolchain/bazel-bin/_solib__bazel_Stoolchain_Sx86_U64-unknown-linux-gnu_Cx86_U64_Utoolchain/libstdc++.so.6 (0x00007ff6817c4000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007ff681c6f000)
```

cc_binary without linkstatic=False is wrong:
```
$ ldd bazel-bin/hello
	linux-vdso.so.1 (0x00007ffc0cf3b000)
	libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0x00007f17ae400000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007f17ae000000)
	libm.so.6 => /usr/lib/libm.so.6 (0x00007f17ae65c000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f17ae76f000)
	libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x00007f17ae63c000)
```
