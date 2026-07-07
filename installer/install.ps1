# Installs the LDP3 toolchain for the current user (no admin needed): copies the binaries to a per-user
# programs directory and puts it on the user PATH. LDP3 links final executables with clang, so this
# checks for LLVM/clang and points you at it if it is missing (the toolchain does not bundle clang).
#   install.ps1                 install to %LOCALAPPDATA%\Programs\ldp3 and update PATH
#   install.ps1 -Prefix D:\ldp3 install elsewhere
#   install.ps1 -NoPath         install but leave PATH untouched
param(
    [string]$Prefix = (Join-Path $env:LOCALAPPDATA "Programs\ldp3"),
    [switch]$NoPath
)
$ErrorActionPreference = "Stop"

$src   = $PSScriptRoot   # the unpacked bundle holds this script next to the binaries
$files = @("ldp3.exe", "ldp3c.exe", "ldp3-studio.exe", "ldp3-lsp.exe", "ldp3_rt.lib")

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
if (-not $clang -and -not $env:LDP3_CLANG) {
    Write-Warning ("clang was not found. LDP3 links with clang; install LLVM from " +
        "https://github.com/llvm/llvm-project/releases or set LDP3_CLANG to your clang.exe.")
} else {
    $where = if ($clang) { $clang.Source } else { $env:LDP3_CLANG }
    Write-Host "found clang: $where"
}
Write-Host ""
Write-Host "done. In a new terminal try:  ldp3 --version   ldp3 new hello   ldp3-studio"
