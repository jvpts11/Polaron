#!/usr/bin/env bash
# Everything the suite needs on a Linux machine -- run by CI and by hand, identically.
#
# THE TOOLS ARE NOT OPTIONAL EXTRAS: THEY DECIDE HOW BIG THE SUITE IS. Seven tests exist only where
# their tool exists -- four need `wasm-ld`, one a browser, two a `qemu-system-*` -- so a machine
# without them runs a SMALLER suite and still reports success. Measured on 2026-09-16: this project's
# Windows machine registered 1384 tests and a WSL Ubuntu registered 1377, and the entire difference
# was missing tools plus one genuinely host-gated test (`driver_i686_hosted_runs`, which links against
# Visual Studio's 32-bit libraries and cannot exist here).
#
#   scripts/ci/setup-linux.sh          # LLVM 21
#   LLVM_VERSION=22 scripts/ci/setup-linux.sh
set -euo pipefail

LLVM_VERSION="${LLVM_VERSION:-21}"
SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

$SUDO apt-get update
# `qemu-system-arm` is the package that carries `qemu-system-aarch64`; `qemu-user` carries the
# per-architecture user-mode binaries the cross tests look for.
$SUDO apt-get install -y --no-install-recommends \
    build-essential ninja-build cmake git python3 \
    qemu-system-x86 qemu-system-arm qemu-user \
    g++-aarch64-linux-gnu

# LLVM: the distribution's own packages when it already ships the version we want, apt.llvm.org
# otherwise. Ubuntu 24.04 (the CI runner) stops well below 21 and takes the second path; a 26.04
# desktop takes the first and installs nothing extra.
if ! apt-cache show "llvm-${LLVM_VERSION}-dev" >/dev/null 2>&1; then
    wget -qO /tmp/llvm.sh https://apt.llvm.org/llvm.sh
    chmod +x /tmp/llvm.sh
    $SUDO /tmp/llvm.sh "${LLVM_VERSION}"
fi
$SUDO apt-get install -y --no-install-recommends \
    "llvm-${LLVM_VERSION}-dev" "clang-${LLVM_VERSION}" "lld-${LLVM_VERSION}"

# THE SUITE LOOKS FOR UNSUFFIXED NAMES, because that is what a person has on their machine:
# `find_program(POLARON_WASM_LD wasm-ld ...)`, never `wasm-ld-21`. A versioned install answers to them
# through alternatives, and without this the four wasm tests simply do not exist -- which looks like a
# green suite, not like a missing one.
# `ld.lld` AND `lld-link` ARE ON THIS LIST FOR A REASON THAT COST FOUR TESTS. The driver does not
# search the PATH for a linker: it builds the path as `dirname(clang)/ld.lld` (see
# `src/driver/toolchain.cpp`). With `clang` reached through `/usr/bin/clang`, that is `/usr/bin/ld.lld`
# -- and the lld package installs only the versioned name, so every bare-metal link died with
# `freestanding link failed (ld.lld)` and exit 127: `port_aarch64_boots`, `port_i686_boots`,
# `port_freestanding_heap_class_links` and `port_uefi_application_builds` (which links PE, hence
# `lld-link`). The wasm tests passed throughout, because `wasm-ld` was the one name that had an
# alternative.
for tool in clang clang++ lld ld.lld lld-link wasm-ld llvm-nm llvm-objdump llvm-objcopy llvm-lib; do
    if [ -x "/usr/lib/llvm-${LLVM_VERSION}/bin/${tool}" ]; then
        $SUDO update-alternatives --install "/usr/bin/${tool}" "${tool}" \
            "/usr/lib/llvm-${LLVM_VERSION}/bin/${tool}" 100
    fi
done

# ...AND THE SCRIPT SAYS WHETHER IT WORKED, rather than leaving it to a test count nobody reads. A
# missing tool here is a smaller suite later, so this is the place to fail.
missing=0
# The linkers are checked HERE too, and were not: this list said `ok` on a machine where every
# bare-metal link was about to fail, which is the one thing a verification step exists to prevent.
for tool in cmake ninja clang clang++ lld ld.lld lld-link wasm-ld llvm-nm llvm-objcopy python3 \
            qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf '  ok      %-22s %s\n' "$tool" "$(command -v "$tool")"
    else
        printf '  MISSING %s\n' "$tool"
        missing=$((missing + 1))
    fi
done
if [ "$missing" -ne 0 ]; then
    echo "setup-linux: $missing tool(s) missing; the suite would be smaller than it looks"
    exit 1
fi
clang --version | head -1
