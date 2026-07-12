# Stage a self-contained LDP3 toolchain bundle for the .msi. The goal (golden rule) is that the installed
# toolchain compiles .ldp3 -> .exe on a bare Windows 10/11 x64 machine with no Visual Studio / Windows SDK:
# ship the LDP3 binaries, a slim clang + lld-link, the CRT/Windows import libs and the runtime lib. Because
# the produced exes link the static CRT, they depend only on kernel32 + ws2_32, present on every Windows.
#
#   ./pack-bundle.ps1                 # stages dist/stage from a Release build
#
# Layout produced (matches how the driver finds its toolchain -- siblings of ldp3.exe, plus lib/):
#   dist/stage/core/   ldp3.exe ldp3c.exe ldp3-lsp.exe clang.exe lld-link.exe *.dll ldp3_rt.lib  + lib/*.lib
#   dist/stage/tui/    ldp3-studio.exe            (the optional TUI feature)
#   dist/stage/vscode/ <the VS Code extension>   (installed on demand)
param(
    [string]$Config = "Release",
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\.."),
    [string]$LlvmBin  = "C:\Program Files\LLVM\bin"
)
$ErrorActionPreference = "Stop"
function Need($p, $what) { if (-not (Test-Path $p)) { throw "$what not found: $p" } ; return $p }

$bin  = Join-Path $RepoRoot "build\bin\$Config"
$stage = Join-Path $RepoRoot "installer\dist\stage"
$core = Join-Path $stage "core"; $tui = Join-Path $stage "tui"; $vscode = Join-Path $stage "vscode"
Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
foreach ($d in @($core, (Join-Path $core "lib"), $tui, $vscode)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# 1) LDP3 binaries + their sibling DLLs (zstd etc.), then the compiler split from the TUI.
foreach ($e in "ldp3.exe","ldp3c.exe","ldp3-lsp.exe") { Copy-Item (Need "$bin\$e" "binary") $core }
Copy-Item (Need "$bin\ldp3-studio.exe" "TUI binary") $tui
Get-ChildItem "$bin\*.dll" -ErrorAction SilentlyContinue | ForEach-Object { Copy-Item $_.FullName $core }

# 2) The runtime, compiled with the STATIC CRT so it matches the bundled libcmt (the CMake build uses the
#    dynamic CRT, which would drag in MSVCRT.lib -- not shipped). Built here with the bundled clang.
& "$LlvmBin\clang.exe" --target=x86_64-pc-windows-msvc -O2 -fms-runtime-lib=static `
    -c (Join-Path $RepoRoot "runtime\ldp3_rt.cpp") -o (Join-Path $core "ldp3_rt.lib")
if ($LASTEXITCODE -ne 0) { throw "compiling the runtime failed" }

# 3) The LLVM tools clang + lld-link (slim, standalone).
Copy-Item (Need "$LlvmBin\clang.exe" "clang") $core
Copy-Item (Need "$LlvmBin\lld-link.exe" "lld-link") $core

# 4) The VC++ runtime DLLs the release binaries need (present in System32 when VS is installed; a bare
#    machine has ucrtbase.dll but not these, so we ship them -- they are redistributable).
foreach ($dll in "vcruntime140.dll","vcruntime140_1.dll","msvcp140.dll") {
    $src = "$env:WINDIR\System32\$dll"
    if (Test-Path $src) { Copy-Item $src $core } else { Write-Warning "missing redist DLL: $dll" }
}

# 5) The CRT + Windows import libs (link-time). Locate the newest MSVC + Windows SDK on this machine.
$msvc = Get-ChildItem "C:\Program Files*\Microsoft Visual Studio\*\*\VC\Tools\MSVC\*\lib\x64" -Directory -ErrorAction SilentlyContinue | Sort-Object FullName | Select-Object -Last 1
$sdkRoot = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\Lib\*" -Directory -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -Last 1
if (-not $msvc -or -not $sdkRoot) { throw "could not locate MSVC/Windows SDK libs to bundle" }
$lib = Join-Path $core "lib"
foreach ($f in "libcmt.lib","libvcruntime.lib","oldnames.lib","legacy_stdio_definitions.lib","legacy_stdio_wide_specifiers.lib") { Copy-Item (Join-Path $msvc.FullName $f) $lib }
Copy-Item (Join-Path $sdkRoot.FullName "ucrt\x64\libucrt.lib") $lib
foreach ($f in "kernel32.lib","ws2_32.lib","uuid.lib") { Copy-Item (Join-Path $sdkRoot.FullName "um\x64\$f") $lib }

# 6) The VS Code extension: build a .vsix (the reliable install path -- a hand-copied folder is not
#    detected by modern VS Code) and stage it, plus the minimal extension files as a last-resort fallback
#    for machines without the `code` CLI. Requires Node/npm on the build machine.
$extSrc = Join-Path $RepoRoot "editors\vscode"
Push-Location $extSrc
try {
    if (-not (Test-Path (Join-Path $extSrc "out\extension.js"))) { & npm run build; if ($LASTEXITCODE -ne 0) { throw "extension build failed" } }
    & npx --yes @vscode/vsce package --no-dependencies -o (Join-Path $vscode "ldp3-0.1.0.vsix")
    if ($LASTEXITCODE -ne 0) { throw "vsce package failed (is Node/npm installed?)" }
} finally { Pop-Location }
foreach ($item in "package.json","out","media","syntaxes","language-configuration.json") {
    Copy-Item (Join-Path $extSrc $item) $vscode -Recurse -Force
}

Write-Host ("staged bundle: core={0:N0} MB, tui + vscode included" -f ((Get-ChildItem $core -Recurse | Measure-Object Length -Sum).Sum / 1MB))
Write-Host "-> $stage"
