# Configure, build and run the suite on Windows -- the same three commands CI runs and a developer
# runs.
#
#   scripts\ci\build-and-test.ps1 [build-dir]
#
# EXPECTS THE MSVC DEVELOPER ENVIRONMENT TO BE ACTIVE. Every test that links fails without it, with
# `lld-link: error: could not open 'legacy_stdio_definitions.lib'` and `'libcpmt.lib'` -- which reads
# exactly like a compiler regression and is not one. The tell is the asymmetry: tests that only read
# IR pass while every linking test fails. In CI the workflow enters that environment in its own step;
# by hand it is `vcvars64.bat`.
param([string]$BuildDir = "build")
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

# A SHORT BUILD DIRECTORY MATTERS HERE. The unit tests pull doctest in at configure time with a git
# clone, and one path inside doctest is long enough that a deep build directory overflows Windows'
# 260-character limit: `fatal: cannot create directory at
# 'examples/combining_the_same_tests_built_differently_in_multiple_shared_objects/test_output':
# Filename too long`. CI checks out to `D:\a\Polaron\Polaron`, which is short.
cmake -G Ninja -S $root -B $BuildDir `
    -DCMAKE_BUILD_TYPE=Release `
    -DPOLARON_WITH_LLVM=ON `
    -DLLVM_DIR="$env:LLVM_DIR"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

cmake --build $BuildDir -j $env:NUMBER_OF_PROCESSORS
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# How many tests this machine registered -- see the note in build-and-test.sh for why this is
# reported and not assumed.
# Both numbers -- see the note in build-and-test.sh for why the total alone misleads.
$registered = (ctest --test-dir $BuildDir -N | Select-String -Pattern '^\s+Test\s+#').Count
$gated = (ctest --test-dir $BuildDir -N -LE network | Select-String -Pattern '^\s+Test\s+#').Count
Write-Host "registered tests: $registered ($gated here, $($registered - $gated) labelled network)"
if ($env:GITHUB_STEP_SUMMARY) {
    "- **Windows x64**: $registered registered, $gated gating, $($registered - $gated) network" |
        Add-Content $env:GITHUB_STEP_SUMMARY
}

ctest --test-dir $BuildDir --output-on-failure -LE network -j $env:NUMBER_OF_PROCESSORS
exit $LASTEXITCODE
