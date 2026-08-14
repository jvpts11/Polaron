# Polaron installer

## The .msi (recommended) — self-contained, works on any Windows 10/11 x64

`Polaron-0.1.0.msi` installs a **self-contained** Polaron toolchain: it bundles the compiler, a slim
clang + lld-link, the CRT/Windows import libraries and the runtime, so Polaron compiles `.pol` to a
native `.exe` on a bare Windows 10/11 x64 machine — **no Visual Studio or Windows SDK required**.
(The produced executables link the static CRT, so they depend only on `kernel32.dll` and
`ws2_32.dll`, present on every Windows 10/11.)

The wizard offers three selectable features:
- **Compiler and toolchain** (required) — `polaron`, `polc`, the language server and the self-contained
  clang/lld/CRT.
- **Project manager** (optional) — the `polaron-studio` TUI (`polaron studio`).
- **Install the VS Code extension** (optional) — registers the Polaron extension in this machine's VS Code.

It installs to `%ProgramFiles%\Polaron`, adds that to the system `PATH`, and can be removed from
Add/Remove Programs.

### Building the .msi

```powershell
cmake --build build --config Release                 # produce the Release binaries first
dotnet tool install --global wix --version 5.0.2     # WiX 5 (free; v7 needs the paid OSMF EULA)
installer\build-msi.ps1                              # stage + build -> installer\dist\Polaron-0.1.0.msi
```

`build-msi.ps1` runs `pack-bundle.ps1` (which stages the Polaron binaries, their DLLs, clang + lld-link,
the runtime built against the static CRT, the CRT/Windows import libs, and the VS Code extension) and
then compiles `polaron.wxs`.

### Files

| File | Role |
|------|------|
| `polaron.wxs`          | WiX package: the three features, the PATH entry, the VS Code custom action |
| `pack-bundle.ps1`   | stages the self-contained bundle under `dist\stage` |
| `build-msi.ps1`     | stage + `wix build` -> the `.msi` |
| `install-vscode.cmd`| copies the extension into the user's VS Code (run by the optional feature) |

## The script bundle (alternative) — requires an existing LLVM

`pack.ps1` / `install.ps1` / `uninstall.ps1` and `polaron.iss` (an Inno Setup GUI) install the Polaron
binaries only and rely on a system `clang` for linking. Lighter, but not self-contained — prefer the
`.msi` for the golden-rule guarantee.
