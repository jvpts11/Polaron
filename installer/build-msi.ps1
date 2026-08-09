# Build the LDP3 .msi end to end: stage the self-contained bundle, then compile the WiX package.
# Prereqs: a Release build of the LDP3 binaries (cmake --build build --config Release), LLVM on PATH or
# in C:\Program Files\LLVM, and the WiX tool (dotnet tool install --global wix; adds ~\.dotnet\tools to PATH).
#
#   ./build-msi.ps1                       # -> installer/dist/LDP3-1.0.4.msi
param(
    [string]$Config = "Release",
    [string]$Version = "1.0.28"
)
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
# WiX resolves the .wxs's relative paths (../branding/icon.ico, install-vscode.cmd) against the CWD,
# not the .wxs location -- so this script must run from installer/, regardless of the caller's CWD.
Set-Location $here

Write-Host "== staging bundle =="
& "$here\pack-bundle.ps1" -Config $Config

# Locate wix (a dotnet global tool) if it is not already on PATH.
$wix = (Get-Command wix -ErrorAction SilentlyContinue).Source
if (-not $wix) { $wix = Join-Path $env:USERPROFILE ".dotnet\tools\wix.exe" }
if (-not (Test-Path $wix)) { throw "wix not found; run: dotnet tool install --global wix" }

# The WixUI extension provides the feature-selection wizard.
& $wix extension add -g WixToolset.UI.wixext 2>&1 | Out-Null

$out = Join-Path $here "dist\LDP3-$Version.msi"
Write-Host "== building $out =="
& $wix build "$here\ldp3.wxs" -ext WixToolset.UI.wixext -arch x64 -o $out
if ($LASTEXITCODE -ne 0) { throw "wix build failed" }
Write-Host "OK -> $out"
