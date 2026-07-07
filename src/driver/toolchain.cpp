#include "driver/toolchain.h"
#include "ldp3_config.h"
#include <cstdlib>
#ifdef _WIN32
#include <windows.h>
#else
#include <climits>
#include <unistd.h>
#endif

namespace ldp3::driver {
namespace fs = std::filesystem;

namespace {
std::string envOr(const char* name, const std::string& fallback) {
    const char* v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}

// Platform-specific tool file names. On Windows the sibling tools carry ".exe" and the runtime is an
// MSVC-style import lib; on POSIX they are extensionless and the runtime is a Unix static archive.
#ifdef _WIN32
constexpr const char* kRuntimeLib = "ldp3_rt.lib";
#else
constexpr const char* kRuntimeLib = "libldp3_rt.a";
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

fs::path ldp3HomeDir() {
    if (const char* over = std::getenv("LDP3_HOME"); over && *over) return fs::path(over);
    const char* home = std::getenv("USERPROFILE");
    if (!home || !*home) home = std::getenv("HOME");
    const fs::path base = (home && *home) ? fs::path(home) : fs::current_path();
    return base / ".ldp3";
}

Toolchain locateToolchain() {
    const fs::path dir = exeDir();
    const std::string sfx = exeSuffix();
    Toolchain t;
    t.ldp3c = envOr("LDP3C", (dir / ("ldp3c" + sfx)).string());
    t.runtimeLib = envOr("LDP3_RUNTIME", (dir / kRuntimeLib).string());
    // A bundled install ships clang + lld-link + a lib/ directory beside the driver. Prefer them so the
    // toolchain is self-contained; fall back to a system clang otherwise. (Self-contained bundling is a
    // Windows feature today; on POSIX the sibling lld-link is absent, so the system toolchain is used.)
    std::error_code ec;
    const fs::path bundledClang = dir / ("clang" + sfx);
    const fs::path bundledLld = dir / ("lld-link" + sfx);
    const fs::path bundledLib = dir / "lib";
    t.clang = envOr("LDP3_CLANG",
                    fs::exists(bundledClang, ec) ? bundledClang.string() : LDP3_DEFAULT_CLANG);
    if (fs::is_directory(bundledLib, ec) && fs::exists(bundledLld, ec)) {
        t.libDir = bundledLib.string();
        t.lldLink = bundledLld.string();
    }
    return t;
}

}  // namespace ldp3::driver
