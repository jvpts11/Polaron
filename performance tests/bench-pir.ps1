# The two backends, on the same benchmark, at the same optimisation level.
#
# The question Phase 3 has to answer with a number rather than an argument: does a program built
# through Polaron's own IR run as fast as one built through the path that has been tuned for two
# years? Both arms end in the same LLVM at the same -O2, so a difference between them is a
# difference in what the middle-end was TOLD -- which attributes reached it, which guards survived,
# which loads it was allowed to move. That is exactly the thing being worked on.
#
# BEST-OF-N, not mean: the machine has other work on it and the minimum is the run least disturbed
# by it. And read the alignment warning in bench-all.ps1 before believing anything under ~10% on a
# call-heavy kernel.
#
# Run inside vcvars64 (or with LIB set), or clang links nothing and a missing .exe times as ~1 ms --
# which reads as an impossibly fast benchmark rather than as the failure it is.
param(
    [string[]]$Names = @(),
    [int]$Runs = 5,
    [string]$Opt = "-O2"
)
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot
$root = Split-Path -Parent $PSScriptRoot
$polc = Join-Path $root "build-local\bin\Release\polc.exe"
$rt = Join-Path $root "runtime\polaron_rt.cpp"
$clang = "C:\Program Files\LLVM\bin\clang.exe"
$out = Join-Path $PSScriptRoot "_bench"
if (-not (Test-Path $out)) { New-Item -ItemType Directory $out | Out-Null }

if ($Names.Count -eq 0) {
    $Names = Get-ChildItem -Path $PSScriptRoot -Filter "*.pol" | ForEach-Object { $_.BaseName }
}

function Build($name, $viaPir, $tag) {
    $ll = Join-Path $out "$name.$tag.ll"
    $exe = Join-Path $out "$name.$tag.exe"
    # BOTH ARMS NAME WHAT THEY WANT. PIR is the default backend, so clearing the variable selects it
    # -- and this would then time it against itself and report a flat 1.00x on every benchmark.
    $env:POLARON_VIA_PIR = if ($viaPir) { "1" } else { "0" }
    & $polc $Opt (Join-Path $PSScriptRoot "$name.pol") -o $ll 2>&1 | Out-Null
    Remove-Item env:POLARON_VIA_PIR -ErrorAction SilentlyContinue
    if (-not (Test-Path $ll)) { return $null }
    & $clang $Opt "-ffp-contract=off" $ll $rt -o $exe -llegacy_stdio_definitions -Wno-override-module 2>&1 | Out-Null
    if (-not (Test-Path $exe)) { return $null }
    return $exe
}

function BestOf($exe, $runs) {
    $best = [double]::MaxValue
    $line = ""
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $line = & $exe
        $sw.Stop()
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
    }
    return @{ ms = $best; out = ($line -join "|") }
}

"{0,-18} {1,10} {2,10} {3,9}  {4}" -f "benchmark", "trusted", "pir", "pir/old", "agree"
"-" * 66
$ratios = @()
foreach ($n in $Names) {
    $a = Build $n $false "old"
    $b = Build $n $true "pir"
    if ($null -eq $a -or $null -eq $b) {
        "{0,-18} {1,10}" -f $n, "BUILDFAIL"
        continue
    }
    $ra = BestOf $a $Runs
    $rb = BestOf $b $Runs
    # THE OUTPUTS ARE COMPARED TOO. A backend that is fast because it skipped the work is not fast,
    # and a benchmark is the one place where nobody looks at what was printed.
    $agree = if ($ra.out -eq $rb.out) { "yes" } else { "NO" }
    $ratio = if ($ra.ms -gt 0) { $rb.ms / $ra.ms } else { 0 }
    $ratios += $ratio
    "{0,-18} {1,8:N1}ms {2,8:N1}ms {3,8:N2}x  {4}" -f $n, $ra.ms, $rb.ms, $ratio, $agree
}
if ($ratios.Count -gt 0) {
    $sorted = $ratios | Sort-Object
    $median = $sorted[[int]($sorted.Count / 2)]
    ""
    "median pir/trusted: {0:N2}x over {1} benchmarks" -f $median, $ratios.Count
}
