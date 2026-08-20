#!/usr/bin/env bash
# Build a self-contained Linux x86-64 distribution tarball for Polaron.
#
# Mirrors the self-contained Windows .msi: the tarball carries the Polaron tools (polaron, polc,
# polaron-studio, polaron-lsp), the prebuilt runtime, AND a bundled clang + lld -- so the golden rule
# holds on Linux too: a fresh x64 machine can compile and run Polaron with nothing pre-installed but
# its own libc (always present) and the usual libc dev files needed to link (present on any machine
# that compiles anything).
#
# The bundled clang is taken from --llvm-dir. Point it at a system LLVM (e.g. /usr/lib/llvm-21, glibc,
# covers Ubuntu/Gentoo/Arch) or, for the widest cross-distro reach (older glibc / musl), at an extracted
# official LLVM release. Either way the layout and wrapper are identical, so swapping is a one-arg change.
#
#   installer/package-linux.sh [--build-dir DIR] [--llvm-dir DIR] [--version V] [--out DIR]
#
# The build directory must be configured with -DPOLARON_DEFAULT_CLANG=clang, so the shipped driver
# looks for the `clang` beside itself rather than for the absolute path of the machine that built it.
set -euo pipefail

BUILD_DIR="${BUILD_DIR:-$HOME/polaron-build-dist}"
LLVM_DIR="${LLVM_DIR:-/usr/lib/llvm-21}"
VERSION="${VERSION:-1.0.153}"
OUT="${OUT:-/tmp}"
while [ $# -gt 0 ]; do
  case "$1" in
    --build-dir) BUILD_DIR="$2"; shift 2 ;;
    --llvm-dir)  LLVM_DIR="$2"; shift 2 ;;
    --version)   VERSION="$2"; shift 2 ;;
    --out)       OUT="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

name="polaron-${VERSION}-linux-x64"
stage="$(mktemp -d)/${name}"
trap 'rm -rf "$(dirname "$stage")"' EXIT
mkdir -p "$stage/bin" "$stage/lib"

echo "==> staging Polaron tools from $BUILD_DIR"
for t in polaron polc polaron-studio polaron-lsp; do
  cp "$BUILD_DIR/bin/$t" "$stage/bin/$t"
done
cp "$BUILD_DIR/bin/libpolaron_rt.a" "$stage/bin/libpolaron_rt.a"   # sibling of polaron, where the driver looks

echo "==> bundling clang + lld from $LLVM_DIR"
# The real clang binary (a versioned name like clang-21) and lld.
clang_bin="$(ls "$LLVM_DIR"/bin/clang-* 2>/dev/null | grep -E 'clang-[0-9]+$' | head -1)"
[ -n "$clang_bin" ] || clang_bin="$LLVM_DIR/bin/clang"
cp "$clang_bin" "$stage/bin/clang.real"
[ -f "$LLVM_DIR/bin/ld.lld" ] && cp "$LLVM_DIR/bin/ld.lld" "$stage/bin/ld.lld" || true

# The LLVM shared libraries clang links against (libLLVM.so, libclang-cpp.so, ...).
mkdir -p "$stage/lib/clang-libs"
cp -P "$LLVM_DIR"/lib/libLLVM.so* "$stage/lib/clang-libs/" 2>/dev/null || true
cp -P "$LLVM_DIR"/lib/libclang-cpp.so* "$stage/lib/clang-libs/" 2>/dev/null || true

# clang's resource directory (builtin headers + compiler-rt), found relative to the real binary as
# ../lib/clang/<ver>. Copy the whole thing so the layout matches.
res_src="$(ls -d "$LLVM_DIR"/lib/clang/* 2>/dev/null | head -1)"
if [ -n "$res_src" ]; then
  mkdir -p "$stage/lib/clang"
  cp -r "$res_src" "$stage/lib/clang/"
fi

# A thin wrapper so the driver's plain "clang" resolves to the bundled binary with its libraries on the
# search path. The driver finds this as a sibling of polaron (see locateToolchain).
cat > "$stage/bin/clang" <<'WRAP'
#!/bin/sh
here="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
LD_LIBRARY_PATH="$here/../lib/clang-libs:${LD_LIBRARY_PATH:-}" exec "$here/clang.real" "$@"
WRAP
chmod +x "$stage/bin/clang"

echo "==> writing install.sh"
cat > "$stage/install.sh" <<'INSTALL'
#!/usr/bin/env bash
# Install Polaron into a prefix and put its tools on PATH. Re-runnable.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-$HOME/.local/share/polaron}"
BINDIR="${BINDIR:-$HOME/.local/bin}"

echo "installing Polaron -> $PREFIX"
mkdir -p "$PREFIX" "$BINDIR"
cp -r "$here/bin" "$here/lib" "$PREFIX/"

# Symlink the user-facing tools. /proc/self/exe resolves the symlink, so the driver still finds its
# siblings (clang, libpolaron_rt.a) in the real bin directory.
for t in polaron polc polaron-studio polaron-lsp; do
  ln -sf "$PREFIX/bin/$t" "$BINDIR/$t"
done

case ":$PATH:" in
  *":$BINDIR:"*) : ;;
  *) profile="$HOME/.profile"
     echo "export PATH=\"$BINDIR:\$PATH\"" >> "$profile"
     echo "added $BINDIR to PATH in $profile (open a new shell, or: export PATH=\"$BINDIR:\$PATH\")" ;;
esac
echo "done. try: polaron --version"
INSTALL
chmod +x "$stage/install.sh"

cat > "$stage/README.txt" <<EOF
Polaron ${VERSION} — Linux x86-64 (self-contained)

Run ./install.sh to install into ~/.local (no root needed), then open a new shell.
  polaron new hello && cd hello && polaron run

Bundled: the Polaron toolchain, its runtime, and a clang/lld linker -- nothing else to install.
Compiling links against the system C library (present on every Linux); a bare machine still
needs the usual libc dev files to link, like any C toolchain.
EOF

echo "==> creating tarball"
tar_out="$OUT/${name}.tar.gz"
tar -C "$(dirname "$stage")" -czf "$tar_out" "$name"
echo "wrote $tar_out ($(du -h "$tar_out" | cut -f1))"
