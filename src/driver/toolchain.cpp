#include "driver/toolchain.h"
#include "polaron_config.h"
#include <cstdlib>
#ifdef _WIN32
#include <windows.h>
#else
#include <climits>
#include <unistd.h>
#endif

namespace polaron::driver {
namespace fs = std::filesystem;

namespace {
std::string envOr(const char* name, const std::string& fallback) {
    const char* v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}

// Platform-specific tool file names. On Windows the sibling tools carry ".exe" and the runtime is an
// MSVC-style import lib; on POSIX they are extensionless and the runtime is a Unix static archive.
#ifdef _WIN32
constexpr const char* kRuntimeLib = "polaron_rt.lib";
#else
constexpr const char* kRuntimeLib = "libpolaron_rt.a";
#endif
}  // namespace

std::string exeSuffix() {
#ifdef _WIN32
    return ".exe";
#else
    return "";
#endif
}

fs::path exeDir() {
#ifdef _WIN32
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    return fs::path(std::string(buf, n)).parent_path();
#else
    char buf[PATH_MAX];
    const ssize_t n = ::readlink("/proc/self/exe", buf, sizeof(buf));
    if (n <= 0) return fs::current_path();
    return fs::path(std::string(buf, static_cast<size_t>(n))).parent_path();
#endif
}

fs::path polaronHomeDir() {
    if (const char* over = std::getenv("POLARON_HOME"); over && *over) {
        return fs::path(over);
    }
    const char* home = std::getenv("USERPROFILE");
    if (!home || !*home) {
        home = std::getenv("HOME");
    }
    const fs::path base = (home && *home) ? fs::path(home) : fs::current_path();
    return base / ".pol";
}

Toolchain locateToolchain() {
    const fs::path dir = exeDir();
    const std::string sfx = exeSuffix();
    Toolchain t;
    t.polc = envOr("POLC", (dir / ("polc" + sfx)).string());
    t.runtimeLib = envOr("POLARON_RUNTIME", (dir / kRuntimeLib).string());
    // A bundled install ships clang + lld-link + a lib/ directory beside the driver. Prefer them so the
    // toolchain is self-contained; fall back to a system clang otherwise. (Self-contained bundling is a
    // Windows feature today; on POSIX the sibling lld-link is absent, so the system toolchain is used.)
    std::error_code ec;
    const fs::path bundledClang = dir / ("clang" + sfx);
    const fs::path bundledLld = dir / ("lld-link" + sfx);
    const fs::path bundledLib = dir / "lib";
    t.clang = envOr("POLARON_CLANG",
                    fs::exists(bundledClang, ec) ? bundledClang.string() : POLARON_DEFAULT_CLANG);
    if (fs::is_directory(bundledLib, ec) && fs::exists(bundledLld, ec)) {
        t.libDir = bundledLib.string();
        t.lldLink = bundledLld.string();
    }
    // ELF linker for freestanding: ld.lld sits beside clang (the kernel build uses it the same way).
    t.ldLld = envOr("POLARON_LD_LLD", (fs::path(t.clang).parent_path() / ("ld.lld" + sfx)).string());
    // ...and wasm-ld beside it, for a target whose object files ld.lld does not recognise at all.
    t.wasmLd = envOr("POLARON_WASM_LD", (fs::path(t.clang).parent_path() / ("wasm-ld" + sfx)).string());
    // Image-format tools. llvm-objcopy ships beside clang and turns the linked ELF into a flat binary;
    // xorriso is only needed for a bootable .iso and is looked up on PATH (left empty when absent, so
    // the driver can report exactly what is missing rather than failing obscurely).
    t.objcopy = envOr("POLARON_OBJCOPY", (fs::path(t.clang).parent_path() / ("llvm-objcopy" + sfx)).string());
    t.xorriso = envOr("POLARON_XORRISO", "xorriso" + sfx);
    return t;
}

}  // namespace polaron::driver
