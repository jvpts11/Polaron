# A/B one benchmark against Polaron's own middle-end passes.
#
# Answers "did OUR pass cost us this?" in one run instead of a rebuild. Both switchable passes have
# already been measured making a benchmark worse, so this is not a hypothetical need.
# Run inside vcvars64.
param([string]$Name = "primes", [int]$Runs = 5)
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot
$root = Split-Path -Parent $PSScriptRoot
$polc = Join-Path $root "build-local\bin\Release\polc.exe"
$rt = Join-Path $root "runtime\polaron_rt.cpp"
$clang = "C:\Program Files\LLVM\bin\clang.exe"
$out = Join-Path $PSScriptRoot "_bench"

$arms = @(
    @{ tag = "todos os passes";      env = @() },
    @{ tag = "sem hoist-bounds";     env = @("POLARON_NO_HOIST_BOUNDS") },
    @{ tag = "sem interchange";      env = @("POLARON_NO_INTERCHANGE") },
    @{ tag = "sem nenhum";           env = @("POLARON_NO_HOIST_BOUNDS", "POLARON_NO_INTERCHANGE") }
)
foreach ($a in $arms) {
    foreach ($v in @("POLARON_NO_HOIST_BOUNDS","POLARON_NO_INTERCHANGE")) { Remove-Item "env:$v" -ErrorAction SilentlyContinue }
    foreach ($v in $a.env) { Set-Item "env:$v" "1" }
    $ll = Join-Path $out "$Name.abl.ll"
    & $polc "-O2" (Join-Path $PSScriptRoot "$Name.pol") -o $ll 2>&1 | Out-Null
    $exe = Join-Path $out "$Name.abl.exe"
    & $clang "-O2" "-ffp-contract=off" $ll $rt -o $exe -llegacy_stdio_definitions -Wno-override-module 2>&1 | Out-Null
    if (-not (Test-Path $exe)) { "{0,-20} LINKFAIL" -f $a.tag; continue }
    $best = [double]::MaxValue; $line = ""
    for ($i = 0; $i -lt $Runs; $i++) {
        $sw = [Diagnostics.Stopwatch]::StartNew(); $line = & $exe; $sw.Stop()
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
    }
    "{0,-20} {1,7:N1} ms   {2}" -f $a.tag, $best, $line
}
foreach ($v in @("POLARON_NO_HOIST_BOUNDS","POLARON_NO_INTERCHANGE")) { Remove-Item "env:$v" -ErrorAction SilentlyContinue }
