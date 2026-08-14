# Polaron against the bar that actually matters: GCC.
#
# The rule this measures against: Polaron must be FASTER than perfect hand-written C/C++, or at worst
# EQUAL to it. GCC is the reference because it produces the fastest C/C++/Fortran code, so beating
# clang proves nothing -- an earlier session measured clang-vs-clang parity and learned nothing.
# Fortran is here as the ceiling: gfortran on a numeric kernel is the best the competition gets.
#
# MUST run inside vcvars64: without it clang links nothing and a missing .exe times as ~1ms, which
# reads as an impossibly fast benchmark rather than as the error it is.
#
# ALIGNMENT WARNING, measured here on 2026-08-12: the same fib code moved 9% (181ms -> 198ms) purely
# from where the linker placed the function. Anything under ~10% on a call-heavy kernel is inside
# that noise and is NOT evidence about code quality. Use -Align to pin every arm to the same
# alignment when the question is "is our CODE worse"; leave it off when the question is "what does a
# user actually get".
param(
    [string[]]$Names = @(),
    [int]$Runs = 5,
    [int]$Align = 0,           # 0 = compiler default; 32 pins layout so arms are comparable
    [switch]$Native,           # -march=native on EVERY arm, ours and theirs alike
    [switch]$SkipPolaron
)
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

$root   = Split-Path -Parent $PSScriptRoot
$polc = Join-Path $root "build-local\bin\Release\polc.exe"
$rt     = Join-Path $root "runtime\polaron_rt.cpp"
$clang  = "C:\Program Files\LLVM\bin\clang.exe"
$gccBin = "C:\Users\Utilizador\AppData\Local\Microsoft\WinGet\Packages\BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe\mingw64\bin"
$gcc    = Join-Path $gccBin "gcc.exe"
$gpp    = Join-Path $gccBin "g++.exe"
$gfort  = Join-Path $gccBin "gfortran.exe"

$cdir = Join-Path $PSScriptRoot "c-reference"
$out  = Join-Path $PSScriptRoot "_bench"
New-Item -ItemType Directory -Force $out | Out-Null

# -ffp-contract=off everywhere: FMA contraction changes FP results, and a benchmark whose checksum
# moves between arms is comparing two different computations.
$common = @("-ffp-contract=off")
if ($Align -gt 0) { $common += "-falign-functions=$Align" }
# -Native goes on EVERY arm, ours and GCC's alike -- otherwise it is not a comparison, it is a
# handicap. It matters more than it sounds: the default target is generic x86-64, i.e. SSE2 and a
# 2003 machine model, and LLVM turns out to gain far more from being told the real CPU than GCC does.
if ($Native) { $common += "-march=native" }

# A PROGRAM THAT DID NOT RUN IS NOT A FAST PROGRAM.
#
# This used to time the process and keep the number whatever happened. Three C++ references were
# exiting with 0xC0000139 (STATUS_ENTRYPOINT_NOT_FOUND) before reaching `main` -- printing nothing and
# dying in 4 ms -- and the table published them as 3.9 ms references that we scored 0.10 against. The
# compile-failure case was already handled, with the comment further down saying exactly why; the
# RUN-failure case was not, and it is the same defect one step later.
#
# So the exit code and the output are both part of the measurement now: a non-zero exit, or no output
# at all, means there is no number here.
function Time-Exe([string]$exe, [int]$runs) {
    if (-not (Test-Path $exe)) { return @{ Ms = $null; Out = "MISSING" } }
    # THE OUTPUT IS COLLECTED WHOLE, then the first line taken. Piping into `Select-Object -First 1`
    # stops the pipeline as soon as it has its line, which TERMINATES the process -- so every arm came
    # back with exit -1 the moment this function started looking at exit codes, and every reference
    # looked broken. The early-exit optimisation and the exit code cannot both be had.
    $best = [double]::MaxValue; $line = ""; $code = 0
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $all = & $exe 2>&1
        $sw.Stop()
        $code = $LASTEXITCODE
        $line = if ($null -ne $all) { ([string[]]@($all))[0] } else { "" }
        if ($code -ne 0) { break }
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
    }
    if ($code -ne 0) {
        return @{ Ms = $null; Out = ("FAILED(exit 0x{0:X8})" -f $code) }
    }
    if ([string]::IsNullOrWhiteSpace([string]$line)) {
        return @{ Ms = $null; Out = "FAILED(no output)" }
    }
    return @{ Ms = [math]::Round($best, 1); Out = $line }
}

if ($Names.Count -eq 0) {
    $Names = Get-ChildItem -Filter *.pol | ForEach-Object { $_.BaseName } | Sort-Object
}

$rows = @()
$refErrors = @()   # references that FAILED TO BUILD, kept apart from those that do not exist
foreach ($name in $Names) {
    $row = [ordered]@{ Bench = $name }
    $checks = @{}

    if (-not $SkipPolaron) {
        $src = Join-Path $PSScriptRoot "$name.pol"
        if (Test-Path $src) {
            $ll = Join-Path $out "$name.ll"
            # -O2 is NOT decoration: polc's own middle end (loop interchange, bounds-check hoisting)
            # is OFF at the default -O0, and `polaron build` always passes -O2. Measuring raw `polc`
            # without it measures a compiler nobody uses -- and understated matmul by 12x (349ms vs
            # 29ms) in every number this folder's README has published since June.
            $sw = [Diagnostics.Stopwatch]::StartNew()
            & $polc "-O2" $src -o $ll 2>&1 | Out-Null
            $sw.Stop()
            $row["frontMs"] = $sw.ElapsedMilliseconds
            foreach ($o in @("-O2","-O3")) {
                $exe = Join-Path $out "$name.polaron$($o.Replace('-','_')).exe"
                & $clang $o @common $ll $rt -o $exe -llegacy_stdio_definitions -Wno-override-module 2>&1 | Out-Null
                $r = Time-Exe $exe $Runs
                $row["Polaron$o"] = $r.Ms; $checks["Polaron$o"] = $r.Out
            }
        }
    }

    foreach ($lang in @(@("c","c",$gcc), @("cpp","cpp",$gpp), @("f90","f90",$gfort))) {
        $ext = $lang[0]; $tag = $lang[1]; $comp = $lang[2]
        $src = Join-Path $cdir "$name.$ext"
        if (-not (Test-Path $src)) { continue }
        foreach ($o in @("-O2","-O3")) {
            $exe = Join-Path $out "$name.$tag$($o.Replace('-','_')).exe"
            # A REFERENCE THAT FAILS TO COMPILE IS NOT AN ABSENT REFERENCE. This used to be
            # `2>&1 | Out-Null`, so a broken reference produced no exe, timed as MISSING, and printed
            # "(no reference)" -- indistinguishable from a benchmark that never had one. `mapkeys`,
            # written specifically to remove the sequential-key bias from the map numbers, silently
            # compared against nothing for that reason (a missing third-party header), while the
            # BIASED benchmark kept publishing a ratio. An instrument that hides its own breakage is
            # worse than no instrument.
            $err = & $comp $o @common $src -o $exe 2>&1
            if ($LASTEXITCODE -ne 0) {
                $row["$tag$o"] = $null
                $script:refErrors += [pscustomobject]@{
                    Bench = $name; Ref = "$name.$ext"; Opt = $o
                    Why   = (($err | Select-Object -First 2) -join " ")
                }
                continue
            }
            $r = Time-Exe $exe $Runs
            $row["$tag$o"] = $r.Ms; $checks["$tag$o"] = $r.Out
            if ($null -eq $r.Ms) {
                $script:refErrors += [pscustomobject]@{
                    Bench = $name; Ref = "$name.$ext"; Opt = $o; Why = "built, but " + $r.Out
                }
            }
        }
    }

    # A benchmark only means something if every arm computed the same answer.
    #
    # A FAILED ARM IS A DISAGREEMENT, not something to skip. The filter used to drop empty output, so
    # a reference that printed nothing because it never started was excluded from the comparison and
    # the row reported "yes" -- agreement with a program that did not run.
    $distinct = $checks.Values | Where-Object { $_ -ne "MISSING" } |
                ForEach-Object { if ([string]::IsNullOrWhiteSpace([string]$_)) { "FAILED(no output)" } else { $_ } } |
                Select-Object -Unique
    $row["agree"] = if ($distinct.Count -le 1) { "yes" } else { "NO: " + ($distinct -join " | ") }
    $rows += [pscustomobject]$row
}

# Normalized summary with FIXED columns. Format-Table takes its columns from the first object, so a
# run mixing C references (`c-O2`) and C++ ones (`cpp-O2`) silently dropped whole columns -- the
# numbers were measured and then not shown, which is worse than not measuring them.
$summary = foreach ($r in $rows) {
    $ours = @($r.PSObject.Properties | Where-Object { $_.Name -like "Polaron-O*" } | ForEach-Object { $_.Value }) |
            Where-Object { $_ -ne $null } | Measure-Object -Minimum
    $ref  = @($r.PSObject.Properties | Where-Object { $_.Name -match '^(c|cpp|f90)-O' } | ForEach-Object { $_.Value }) |
            Where-Object { $_ -ne $null } | Measure-Object -Minimum
    $o = if ($ours.Count) { $ours.Minimum } else { $null }
    $b = if ($ref.Count)  { $ref.Minimum }  else { $null }
    [pscustomobject]@{
        Bench   = $r.Bench
        Polaron   = $o
        Ref     = $b
        Ratio   = if ($o -and $b) { [math]::Round($b / $o, 2) } else { $null }   # >1 = we are faster
        Verdict = if (-not $b) {
                      if ($refErrors | Where-Object { $_.Bench -eq $r.Bench }) { "REF NAO COMPILA" }
                      else { "(sem referencia)" }
                  } elseif ($o -le $b) { "OK" } else { "ATRAS" }
        Agree   = $r.agree
    }
}
$summary | Format-Table -AutoSize

# A reference that did not build is reported LOUDLY and with its reason. Silence here once let the
# benchmark written to remove a known bias compare against nothing, while the biased one kept
# publishing a ratio -- see the note at the compile site.
if ($refErrors.Count -gt 0) {
    Write-Host ""
    Write-Host "REFERENCES THAT FAILED TO BUILD (these rows have no comparison, and it is not because"
    Write-Host "no reference exists):"
    foreach ($e in $refErrors) {
        Write-Host ("  {0,-16} {1,-18} {2}" -f $e.Bench, "$($e.Ref) $($e.Opt)", $e.Why)
    }
}
