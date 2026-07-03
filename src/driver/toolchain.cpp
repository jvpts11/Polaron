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

Toolchain locateToolchain() {
    const fs::path dir = exeDir();
    Toolchain t;
    t.ldp3c = envOr("LDP3C", (dir / "ldp3c.exe").string());
    t.runtimeLib = envOr("LDP3_RUNTIME", (dir / "ldp3_rt.lib").string());
    t.clang = envOr("LDP3_CLANG", LDP3_DEFAULT_CLANG);  // may be a bare "clang" resolved via PATH
    return t;
}

}  // namespace ldp3::driver
