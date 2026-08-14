# Installs the Polaron toolchain for the current user (no admin needed): copies the binaries to a per-user
# programs directory and puts it on the user PATH. Polaron links final executables with clang, so this
# checks for LLVM/clang and points you at it if it is missing (the toolchain does not bundle clang).
#   install.ps1                 install to %LOCALAPPDATA%\Programs\polaron and update PATH
#   install.ps1 -Prefix D:\polaron install elsewhere
#   install.ps1 -NoPath         install but leave PATH untouched
param(
    [string]$Prefix = (Join-Path $env:LOCALAPPDATA "Programs\polaron"),
    [switch]$NoPath
)
$ErrorActionPreference = "Stop"

$src   = $PSScriptRoot   # the unpacked bundle holds this script next to the binaries
$files = @("polaron.exe", "polc.exe", "polaron-studio.exe", "polaron-lsp.exe", "polaron_rt.lib")

New-Item -ItemType Directory -Path $Prefix -Force | Out-Null
foreach ($f in $files) {
    $p = Join-Path $src $f
    if (-not (Test-Path $p)) { Write-Error "missing $f next to install.ps1 -- run pack.ps1 first" }
    Copy-Item $p $Prefix -Force
}
if (Test-Path (Join-Path $src "VERSION.txt")) { Copy-Item (Join-Path $src "VERSION.txt") $Prefix -Force }
Write-Host "installed the toolchain to $Prefix"

if (-not $NoPath) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($null -eq $userPath) { $userPath = "" }
    if (($userPath -split ';') -notcontains $Prefix) {
        [Environment]::SetEnvironmentVariable("Path", ($userPath.TrimEnd(';') + ";" + $Prefix), "User")
        Write-Host "added $Prefix to your user PATH (open a new terminal to pick it up)"
    } else {
        Write-Host "$Prefix already on PATH"
    }
}

$clang = Get-Command clang -ErrorAction SilentlyContinue
if (-not $clang -and -not $env:POLARON_CLANG) {
    Write-Warning ("clang was not found. Polaron links with clang; install LLVM from " +
        "https://github.com/llvm/llvm-project/releases or set POLARON_CLANG to your clang.exe.")
} else {
    $where = if ($clang) { $clang.Source } else { $env:POLARON_CLANG }
    Write-Host "found clang: $where"
}
Write-Host ""
Write-Host "done. In a new terminal try:  polaron --version   polaron new hello   polaron-studio"
