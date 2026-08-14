#!/usr/bin/env bash
# Compile a Polaron program to a native Linux x86-64 executable. Polaron's codegen is
# portable -- the same IR targets Linux by triple -- and the runtime is single-source over POSIX, so a
# Linux clang/gcc links a real ELF. Works on any glibc- or musl-based distro (Ubuntu, Gentoo, Arch,
# Alpine, ...): the runtime uses only kernel + libc APIs, nothing distro-specific.
#
# Slice-1 cross flow (from WSL, polc is still the Windows build reached over /mnt/c):
#   scripts/build-linux.sh path/to/prog.pol [-o out] [--polc /mnt/c/.../polc.exe]
# Native flow (once polc is built for Linux): pass --polc to the Linux binary.
set -euo pipefail

src=""; out=""; polc="${POLC:-polc}"; cc="${CC:-clang}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
while [ $# -gt 0 ]; do
  case "$1" in
    -o) out="$2"; shift 2 ;;
    --polc) polc="$2"; shift 2 ;;
    --cc) cc="$2"; shift 2 ;;
    *) src="$1"; shift ;;
  esac
done
[ -n "$src" ] || { echo "usage: build-linux.sh <prog.pol> [-o out] [--polc <path>] [--cc clang|gcc]"; exit 2; }
[ -z "$out" ] && out="${src%.pol}"

ll="$(mktemp --suffix=.ll)"
trap 'rm -f "$ll"' EXIT

# 1) Polaron -> LLVM IR targeting Linux. The Windows polc.exe runs fine under WSL interop.
"$polc" "$src" --target=x86_64-unknown-linux-gnu -O2 -o "$ll"

# 2) IR + the single-source runtime -> ELF. -lpthread for the Thread/async runtime; -ldl for
#    dl_iterate_phdr (reimport); -lstdc++ for the Itanium EH runtime (__cxa_*, personality, typeinfo)
#    a program's exceptions lower to. The static libc bits are the platform's own -- nothing to bundle.
"$cc" -O2 -w "$ll" "$root/runtime/polaron_rt.cpp" -o "$out" -lpthread -ldl -lm -lstdc++

echo "wrote $out"
