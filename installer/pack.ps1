# Packages the built Polaron toolchain into dist/polaron-toolchain/ and a versioned zip. Both toolchain
# front-ends ship together: polaron (the classic gcc/cargo-style CLI) and polaron-studio (the FTXUI TUI
# project manager), plus the polc compiler, the polaron-lsp language server, and the polaron_rt runtime lib.
# Run after building: cmake --build build --config Release --target polaron polc polaron-studio polaron-lsp
param(
    [string]$Config = "Release",
    [string]$Version = "1.0.0",
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)
$ErrorActionPreference = "Stop"

$binDir = Join-Path $RepoRoot "build\bin\$Config"
$outDir = Join-Path $RepoRoot "dist\polaron-toolchain"
$files  = @("polaron.exe", "polc.exe", "polaron-studio.exe", "polaron-lsp.exe", "polaron_rt.lib")

foreach ($f in $files) {
    if (-not (Test-Path (Join-Path $binDir $f))) {
        Write-Error "missing $f in $binDir -- build the toolchain first (cmake --build build --config $Config)"
    }
}

if (Test-Path $outDir) { Remove-Item $outDir -Recurse -Force }
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
foreach ($f in $files) { Copy-Item (Join-Path $binDir $f) $outDir }
Copy-Item (Join-Path $PSScriptRoot "install.ps1")   $outDir
Copy-Item (Join-Path $PSScriptRoot "uninstall.ps1") $outDir
Set-Content (Join-Path $outDir "VERSION.txt") $Version -Encoding utf8

$zip = Join-Path $RepoRoot "dist\polaron-toolchain-$Version.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path "$outDir\*" -DestinationPath $zip
Write-Host "packed $zip"
Write-Host "(unzip it and run install.ps1, or build the GUI installer with ISCC polaron.iss)"
