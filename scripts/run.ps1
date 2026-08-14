# Compile an .pol file to a native .exe (polc -> .ll -> clang) and run it.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts\run.ps1 examples\hello.pol
#
# Requires the compiler to be built first:
#   cmake --build build --config Debug
param([Parameter(Mandatory = $true)][string]$File)
$ErrorActionPreference = 'Stop'

$root  = Split-Path -Parent $PSScriptRoot
$polc = Join-Path $root 'build\bin\Debug\polc.exe'
$ll    = Join-Path $env:TEMP 'polaron_run.ll'
$exe   = Join-Path $env:TEMP 'polaron_run.exe'

$clang = (Get-Command clang -ErrorAction SilentlyContinue).Source
if (-not $clang) { $clang = 'C:\Program Files\LLVM\bin\clang.exe' }

if (-not (Test-Path $polc)) {
    throw "polc not built. Run: cmake --build build --config Debug"
}

& $polc $File -o $ll
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
