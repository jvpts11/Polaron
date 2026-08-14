# Time the C references in c-reference\ with the same clang that links the Polaron benchmarks.
#
# This is the experiment that separates "our IR is worse" from "clang is not gcc": same backend,
# same flags, same algorithm. If C and Polaron land together, the compiler is not what costs us.
#
# MUST run inside vcvars64 -- without it clang links nothing and every timing is of a missing
# executable, which reads as an impossibly fast benchmark rather than as an error.
param([string[]]$Names = @("matrixmul","fibonacci"), [string[]]$Opts = @("-O2","-O3"), [int]$Runs = 3)
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

$clang = "C:\Program Files\LLVM\bin\clang.exe"
$dir   = Join-Path $PSScriptRoot "c-reference"
$out   = Join-Path $PSScriptRoot "_bench"
New-Item -ItemType Directory -Force $out | Out-Null

foreach ($n in $Names) {
    $src = Join-Path $dir "$n.c"
    if (-not (Test-Path $src)) { Write-Host "skip $n (no C reference)" -ForegroundColor DarkGray; continue }
    foreach ($o in $Opts) {
        $exe = Join-Path $out "$n.c$($o.Replace('-','_')).exe"
        & $clang $o "-ffp-contract=off" $src -o $exe 2>&1 | Out-Null
        if (-not (Test-Path $exe)) { Write-Host ("{0,-12} C {1,-4}  LINK FAILED (vcvars?)" -f $n,$o) -ForegroundColor Red; continue }
        $best = [double]::MaxValue; $line = ""
        for ($i = 0; $i -lt $Runs; $i++) {
            $sw = [Diagnostics.Stopwatch]::StartNew(); $line = & $exe; $sw.Stop()
            if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
        }
        "{0,-12} C {1,-4} {2,7:N1} ms   {3}" -f $n, $o, $best, $line
    }
}
