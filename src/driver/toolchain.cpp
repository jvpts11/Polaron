#include "driver/toolchain.h"
#include "ldp3_config.h"
#include <cstdlib>
#include <windows.h>

namespace ldp3::driver {
namespace fs = std::filesystem;

namespace {
std::string envOr(const char* name, const std::string& fallback) {
    const char* v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}
}  // namespace

fs::path exeDir() {
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    return fs::path(std::string(buf, n)).parent_path();
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
    Toolchain t;
    t.ldp3c = envOr("LDP3C", (dir / "ldp3c.exe").string());
    t.runtimeLib = envOr("LDP3_RUNTIME", (dir / "ldp3_rt.lib").string());
    // A bundled install ships clang + lld-link + a lib/ directory beside the driver. Prefer them so the
    // toolchain is self-contained; fall back to a system clang otherwise.
    std::error_code ec;
    const fs::path bundledClang = dir / "clang.exe";
    const fs::path bundledLld = dir / "lld-link.exe";
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
