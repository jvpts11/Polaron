# LDP3 toolchain installer

Two ways to package and install the LDP3 toolchain for Windows. Both ship the same set of binaries --
the classic `ldp3` CLI, the `ldp3-studio` TUI, the `ldp3c` compiler, the `ldp3-lsp` language server, and
the `ldp3_rt` runtime library. Neither bundles clang: LDP3 links final executables with an existing LLVM
`clang`, found on `PATH` or via the `LDP3_CLANG` environment variable.

Build the toolchain in Release first:

```
cmake --build build --config Release --target ldp3 ldp3c ldp3-studio ldp3-lsp
```

## 1. Script + zip (no extra tools)

```
powershell -File installer\pack.ps1 -Config Release -Version 0.1.0
```

This writes `dist\ldp3-toolchain-<version>.zip` (and an unzipped `dist\ldp3-toolchain\`). The recipient
unzips it and runs, from inside the folder:

```
powershell -ExecutionPolicy Bypass -File install.ps1
```

`install.ps1` copies the binaries to `%LOCALAPPDATA%\Programs\ldp3` (no admin needed), adds that directory
to the user `PATH`, and warns if clang is missing. `-Prefix <dir>` installs elsewhere; `-NoPath` skips the
PATH change. `uninstall.ps1` reverses it.

## 2. GUI installer (Inno Setup)

Install the free Inno Setup compiler from <https://jrsoftware.org/isdl.php>, then:

```
ISCC installer\ldp3.iss
```

This produces `dist\ldp3-toolchain-setup.exe`, a standard Windows wizard that installs to Program Files,
creates a Start-menu entry for LDP3 Studio, and optionally adds LDP3 to the user PATH.

## After installing

```
ldp3 --version
ldp3 new hello        # scaffold a project
cd hello && ldp3 run  # build and run it
ldp3-studio           # the TUI project manager
```
