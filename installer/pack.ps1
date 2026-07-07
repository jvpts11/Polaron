# Packages the built LDP3 toolchain into dist/ldp3-toolchain/ and a versioned zip. Both toolchain
# front-ends ship together: ldp3 (the classic gcc/cargo-style CLI) and ldp3-studio (the FTXUI TUI
# project manager), plus the ldp3c compiler, the ldp3-lsp language server, and the ldp3_rt runtime lib.
# Run after building: cmake --build build --config Release --target ldp3 ldp3c ldp3-studio ldp3-lsp
param(
    [string]$Config = "Release",
    [string]$Version = "0.1.0",
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path
)
$ErrorActionPreference = "Stop"

$binDir = Join-Path $RepoRoot "build\bin\$Config"
$outDir = Join-Path $RepoRoot "dist\ldp3-toolchain"
$files  = @("ldp3.exe", "ldp3c.exe", "ldp3-studio.exe", "ldp3-lsp.exe", "ldp3_rt.lib")

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

$zip = Join-Path $RepoRoot "dist\ldp3-toolchain-$Version.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path "$outDir\*" -DestinationPath $zip
Write-Host "packed $zip"
Write-Host "(unzip it and run install.ps1, or build the GUI installer with ISCC ldp3.iss)"
