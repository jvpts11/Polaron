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
    [string]$LlvmBin  = "",
    # A Python 3.11 embeddable (a dir containing python311.dll, or the -embed-amd64.zip). If empty, it is
    # downloaded and cached under installer\.cache. Needed because liblldb.dll (the debugger) imports python311.dll.
    [string]$PythonEmbed = ""
)
$ErrorActionPreference = "Stop"
# Prefer the LLVM that clang/lld-link resolve to on PATH, falling back to the default install, so the
# bundle can be staged on any machine with LLVM available -- not only one with it in Program Files.
if (-not $LlvmBin) {
    $c = (Get-Command clang -ErrorAction SilentlyContinue).Source
    if ($c) { $LlvmBin = Split-Path $c -Parent } else { $LlvmBin = "C:\Program Files\LLVM\bin" }
}
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

# 3b) The native debugger: lldb-dap + liblldb, plus a self-contained Python 3.11 (liblldb.dll imports
#     python311.dll). Staged into core/ so it lands on PATH -- Forge's findLldbDap resolves `lldb-dap`
#     there -- with python311.dll/.zip/._pth beside it, so lldb's embedded Python finds its stdlib with
#     no environment set (verified end to end). This adds ~120 MB (liblldb.dll alone is ~108 MB).
Copy-Item (Need "$LlvmBin\lldb-dap.exe" "lldb-dap") $core
Copy-Item (Need "$LlvmBin\liblldb.dll" "liblldb") $core
$pyVer = "3.11.9"
$pyDir = ""
if ($PythonEmbed -and (Test-Path $PythonEmbed -PathType Container) -and (Test-Path (Join-Path $PythonEmbed "python311.dll"))) {
    $pyDir = $PythonEmbed
} else {
    $cache = Join-Path $RepoRoot "installer\.cache"
    New-Item -ItemType Directory -Force $cache | Out-Null
    $pyDir = Join-Path $cache "python-embed"
    if (-not (Test-Path (Join-Path $pyDir "python311.dll"))) {
        $zip = ""
        if ($PythonEmbed -and (Test-Path $PythonEmbed -PathType Leaf)) {
            $zip = $PythonEmbed
        } else {
            $zip = Join-Path $cache "python-$pyVer-embed-amd64.zip"
            if (-not (Test-Path $zip)) {
                Write-Host "downloading the Python $pyVer embeddable (for the bundled debugger)..."
                $eap2 = $ErrorActionPreference; $pp = $ProgressPreference
                $ErrorActionPreference = "Continue"; $ProgressPreference = "SilentlyContinue"
                Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$pyVer/python-$pyVer-embed-amd64.zip" -OutFile $zip
                $ErrorActionPreference = $eap2; $ProgressPreference = $pp
                if (-not (Test-Path $zip)) { throw "could not obtain the Python embeddable; pass -PythonEmbed <zip-or-dir>" }
            }
        }
        Expand-Archive -Path $zip -DestinationPath $pyDir -Force
    }
}
foreach ($f in "python311.dll","python311.zip","python311._pth") { Copy-Item (Need (Join-Path $pyDir $f) "python embeddable file") $core }

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
    # npm/npx write progress to stderr; under ErrorActionPreference=Stop PowerShell would treat that as a
    # terminating error even when the tool exits 0. Drop to Continue around them and gate on $LASTEXITCODE.
    $eap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    if (-not (Test-Path (Join-Path $extSrc "out\extension.js"))) { & npm.cmd run build; if ($LASTEXITCODE -ne 0) { $ErrorActionPreference = $eap; throw "extension build failed" } }
    # Quote the scoped package: a bare @vscode/vsce would be mangled by PowerShell's @ splat operator.
    & npx.cmd --yes '@vscode/vsce' package --no-dependencies -o (Join-Path $vscode "ldp3-0.1.0.vsix")
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $eap
    if ($rc -ne 0) { throw "vsce package failed (is Node/npm installed?)" }
} finally { Pop-Location }
foreach ($item in "package.json","out","media","syntaxes","language-configuration.json") {
    Copy-Item (Join-Path $extSrc $item) $vscode -Recurse -Force
}

Write-Host ("staged bundle: core={0:N0} MB, tui + vscode included" -f ((Get-ChildItem $core -Recurse | Measure-Object Length -Sum).Sum / 1MB))
Write-Host "-> $stage"
