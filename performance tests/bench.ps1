# Measure a Polaron benchmark against itself under different backend pipelines.
#
# The point is to separate two questions that a single number cannot answer:
#   1. Is the gap in OUR IR (then a better -O level barely moves it), or
#   2. is it in the pipeline we hand clang (then it moves a lot).
# Answer 1 means fix the compiler; answer 2 means fix the link line. Guessing between them
# is what wastes a day.
#
# Usage:  .\bench.ps1 -Names matrixmul,fibonacci        (default: all)
#         .\bench.ps1 -Arms "O2,O3"                     (which pipelines)
#         .\bench.ps1 -Runs 5
param(
    [string[]]$Names = @(),
    [string[]]$Arms  = @("O2", "O3", "O3native"),
    [int]$Runs = 3,
    [switch]$KeepIr
)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Same trap pico's build.ps1 documents: under "Stop", ANY line a child process writes to stderr
# becomes a terminating error here -- so a compiler WARNING kills the run before the exit code can
# be read. The exit code is the gate; let it be the gate.
$ErrorActionPreference = "Continue"

$root  = Split-Path -Parent $PSScriptRoot
$polc = Join-Path $root "build-local\bin\Release\polc.exe"
if (-not (Test-Path $polc)) { throw "polc not built: $polc" }
$clang = "C:\Program Files\LLVM\bin\clang.exe"
if (-not (Test-Path $clang)) { throw "clang not found: $clang" }
$rt = Join-Path $root "runtime\polaron_rt.cpp"

# The flags each arm adds on top of the common line. `-ffp-contract=off` stays everywhere: it is
# what keeps the checksums comparable across compilers, and a benchmark whose answer changes is
# not a benchmark.
$armFlags = @{
    "O2"       = @("-O2")
    "O3"       = @("-O3")
    "O3native" = @("-O3", "-march=native")
}

if ($Names.Count -eq 0) {
    $Names = Get-ChildItem -Filter *.pol | ForEach-Object { $_.BaseName } | Sort-Object
}

$out = Join-Path $PSScriptRoot "_bench"
New-Item -ItemType Directory -Force $out | Out-Null

$results = @()
foreach ($name in $Names) {
    $src = Join-Path $PSScriptRoot "$name.pol"
    if (-not (Test-Path $src)) { Write-Host "skip $name (no source)" -ForegroundColor DarkGray; continue }

    # Compile time is half the goal, so it is measured here rather than eyeballed: the same
    # front end runs for every arm, so it is timed once.
    $ll = Join-Path $out "$name.ll"
    $sw = [Diagnostics.Stopwatch]::StartNew()
    & $polc $src -o $ll 2>&1 | Out-Null
    $sw.Stop()
    if ($LASTEXITCODE -ne 0) { Write-Host "FAILED to compile $name" -ForegroundColor Red; continue }
    $frontendMs = $sw.ElapsedMilliseconds

    $row = [ordered]@{ Name = $name; FrontendMs = $frontendMs }
    foreach ($arm in $Arms) {
        $exe = Join-Path $out "$name.$arm.exe"
        $flags = $armFlags[$arm]
        $sw = [Diagnostics.Stopwatch]::StartNew()
        & $clang @flags "-ffp-contract=off" $ll $rt -o $exe -llegacy_stdio_definitions -Wno-override-module 2>&1 | Out-Null
        $sw.Stop()
        if ($LASTEXITCODE -ne 0) { $row["$arm"] = "LINKFAIL"; continue }
        $row["${arm}_buildMs"] = $sw.ElapsedMilliseconds

        # Best of N: the minimum is the honest figure for a CPU-bound kernel -- the mean measures
        # the machine's other work, not the code's.
        $best = [double]::MaxValue
        $checksum = ""
        for ($i = 0; $i -lt $Runs; $i++) {
            $sw2 = [Diagnostics.Stopwatch]::StartNew()
            $o = & $exe 2>&1
            $sw2.Stop()
            if ($sw2.Elapsed.TotalMilliseconds -lt $best) { $best = $sw2.Elapsed.TotalMilliseconds }
            $checksum = ($o | Select-Object -First 1)
        }
        $row["$arm"] = [math]::Round($best, 1)
        $row["${arm}_out"] = $checksum
    }
    $results += [pscustomobject]$row
}

$results | Format-Table -AutoSize
if (-not $KeepIr) { } # IR is kept in _bench for inspection either way
