# Compile an .ldp3 file to a native .exe (ldp3c -> .ll -> clang) and run it.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts\run.ps1 examples\hello.ldp3
#
# Requires the compiler to be built first:
#   cmake --build build --config Debug
param([Parameter(Mandatory = $true)][string]$File)
$ErrorActionPreference = 'Stop'

$root  = Split-Path -Parent $PSScriptRoot
$ldp3c = Join-Path $root 'build\bin\Debug\ldp3c.exe'
$ll    = Join-Path $env:TEMP 'ldp3_run.ll'
$exe   = Join-Path $env:TEMP 'ldp3_run.exe'

$clang = (Get-Command clang -ErrorAction SilentlyContinue).Source
if (-not $clang) { $clang = 'C:\Program Files\LLVM\bin\clang.exe' }

if (-not (Test-Path $ldp3c)) {
    throw "ldp3c not built. Run: cmake --build build --config Debug"
}

& $ldp3c $File -o $ll
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
# legacy_stdio_definitions.lib provides real printf/scanf symbols (the UCRT
# headers define them inline, so the bare symbols are otherwise unresolved).
& $clang -Wno-override-module $ll -o $exe -llegacy_stdio_definitions
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "--- output ---"
& $exe
$code = $LASTEXITCODE
Write-Host "--- exit code: $code ---"
exit $code
