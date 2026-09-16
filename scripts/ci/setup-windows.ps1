# The LLVM this project's Windows CI builds against, fetched and verified.
#
# PINNED BY HASH, not by tag. A release asset can be replaced, and "the build broke and nobody
# changed anything" is what that looks like from in here. The hash is checked BEFORE anything is
# extracted, so a replaced or truncated download fails at this step instead of three steps later as
# a compile error nobody can explain.
#
#   scripts\ci\setup-windows.ps1
#   scripts\ci\setup-windows.ps1 -Version 21.1.8 -Into C:\llvm
#
# Measured 2026-09-16: 942,572,476 bytes, sha256 749d22f5...1a47, downloaded in 51 s.
param(
    [string]$Version = "21.1.8",
    # The hash BELONGS TO THE VERSION on the line above. They are together so that changing one
    # without the other is visible in the diff, and the guard below refuses the pair when it is not.
    [string]$Sha256  = "749d22f565fcd5718dbed06512572d0e5353b502c03fe1f7f17ee8b8aca21a47",
    [string]$Into    = $(if ($env:RUNNER_TEMP) { Join-Path $env:RUNNER_TEMP "llvm" } else { Join-Path $env:TEMP "llvm" })
)
$ErrorActionPreference = "Stop"

$knownVersion = "21.1.8"
$knownSha256  = "749d22f565fcd5718dbed06512572d0e5353b502c03fe1f7f17ee8b8aca21a47"
if ($Version -ne $knownVersion -and $Sha256 -eq $knownSha256) {
    throw "asked for LLVM $Version with the hash recorded for $knownVersion. Download the new asset, hash it, and pass -Sha256 -- a version and a hash that can drift apart eventually do."
}

$asset   = "clang+llvm-$Version-x86_64-pc-windows-msvc.tar.xz"
$url     = "https://github.com/llvm/llvm-project/releases/download/llvmorg-$Version/$asset"
$scratch = $(if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { $env:TEMP })
$archive = Join-Path $scratch $asset

if (-not (Test-Path $archive)) {
    Write-Host "downloading $asset"
    # The progress bar costs minutes on a 900 MB download in a non-interactive host, because
    # Invoke-WebRequest repaints it per chunk.
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $url -OutFile $archive
}

$got = (Get-FileHash $archive -Algorithm SHA256).Hash
if ($got -ne $Sha256.ToUpperInvariant() -and $got -ne $Sha256) {
    Remove-Item $archive -Force   # a wrong archive left on disk is a wrong archive the next run reuses
    throw "SHA256 mismatch for ${asset}: expected $Sha256, got $got"
}
Write-Host "sha256 ok: $got"

New-Item -ItemType Directory -Force -Path $Into | Out-Null
# `--strip-components=1`: the archive holds one top-level `clang+llvm-.../` directory, and the paths
# below expect bin/ and lib/ directly under $Into.
tar -xf $archive -C $Into --strip-components=1
if ($LASTEXITCODE -ne 0) { throw "extracting $asset failed (exit $LASTEXITCODE)" }

$cmakeDir = Join-Path $Into "lib\cmake\llvm"
if (-not (Test-Path $cmakeDir)) { throw "no LLVMConfig.cmake under $cmakeDir -- did the archive layout change?" }

# `find_package(LLVM CONFIG)` wants the directory holding LLVMConfig.cmake. Written to GITHUB_ENV so
# later steps see it; printed as well, so running this by hand tells you what to export.
Write-Host "LLVM_DIR=$cmakeDir"
if ($env:GITHUB_ENV)  { "LLVM_DIR=$cmakeDir" | Add-Content $env:GITHUB_ENV }
if ($env:GITHUB_PATH) { (Join-Path $Into "bin") | Add-Content $env:GITHUB_PATH }
& (Join-Path $Into "bin\clang.exe") --version | Select-Object -First 1
