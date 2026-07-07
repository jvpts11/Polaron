# Removes a per-user LDP3 toolchain install: deletes the program directory and takes it off the PATH.
param([string]$Prefix = (Join-Path $env:LOCALAPPDATA "Programs\ldp3"))
$ErrorActionPreference = "Stop"

if (Test-Path $Prefix) {
    Remove-Item $Prefix -Recurse -Force
    Write-Host "removed $Prefix"
} else {
    Write-Host "$Prefix not found (nothing to remove)"
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath) {
    $new = ($userPath -split ';' | Where-Object { $_ -and ($_ -ne $Prefix) }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $new, "User")
    Write-Host "removed $Prefix from your user PATH"
}
