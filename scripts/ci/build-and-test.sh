#!/usr/bin/env bash
# Configure, build and run the suite -- the same three commands CI runs and a developer runs.
#
#   scripts/ci/build-and-test.sh [build-dir]
#
# `setup-linux.sh` comes first: the tools it installs decide how many tests exist at all, and this
# script reports that number rather than assuming it.
set -euo pipefail

BUILD="${1:-build}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LLVM_VERSION="${LLVM_VERSION:-21}"
JOBS="$(nproc)"

cmake -G Ninja -S "$ROOT" -B "$BUILD" \
    -DCMAKE_BUILD_TYPE=Release \
    -DPOLARON_WITH_LLVM=ON \
    -DLLVM_DIR="${LLVM_DIR:-/usr/lib/llvm-${LLVM_VERSION}/lib/cmake/llvm}"
cmake --build "$BUILD" -j "$JOBS"

# HOW MANY TESTS THIS MACHINE REGISTERED, reported rather than assumed.
#
# Seven tests exist only when a tool does, so a suite that silently shrank -- a package that failed
# to install, a name that stopped resolving through update-alternatives -- reports success today and
# hands the defect to whoever hits it months later. Measured on 2026-09-16: 1377 before the tools
# were installed, 1384 after, on the same commit.
# BOTH NUMBERS, because they differ and the difference is the point: the labelled tests are not run
# by this step. Reporting only the total reads like three tests went missing; reporting only the
# gated count hides a suite that shrank.
registered="$(ctest --test-dir "$BUILD" -N | grep -cE '^ +Test +#')"
gated="$(ctest --test-dir "$BUILD" -N -LE network | grep -cE '^ +Test +#')"
echo "registered tests: $registered ($gated here, $((registered - gated)) labelled network)"
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    echo "- **$(uname -s) $(uname -m)**: $registered registered, $gated gating, $((registered - gated)) network" \
        >> "$GITHUB_STEP_SUMMARY"
fi

# The suite proper. `-LE network` leaves out the three tests that leave the machine; CI runs those in
# a separate step that does not gate, because their result depends on a third party being up.
ctest --test-dir "$BUILD" --output-on-failure -LE network -j "$JOBS"
