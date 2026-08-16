#include "driver/environs.h"
#include "driver/manifest.h"
#include "driver/toolchain.h"
#include <algorithm>
#include <cstdio>
#include <fstream>
#include <system_error>

namespace polaron::driver {
namespace fs = std::filesystem;

fs::path environmentsDir() { return polaronHomeDir() / "environments"; }

std::vector<std::string> listEnvironments() {
    std::vector<std::string> names;
    std::error_code ec;
    const fs::path dir = environmentsDir();
    if (!fs::exists(dir, ec)) {
        return names;
    }
    for (const fs::directory_entry& e : fs::directory_iterator(dir, ec)) {
        if (e.is_directory(ec)) {
            names.push_back(e.path().filename().string());
        }
    }
    std::sort(names.begin(), names.end());
    return names;
}
fs::path environmentPackagesDir(const std::string& name) {
    return environmentsDir() / name / kLibrariesDir;
}
fs::path environmentManifest(const std::string& name) { return environmentsDir() / name / "polaron.toml"; }

int envNew(const std::string& name) {
    const fs::path dir = environmentsDir() / name;
    if (fs::exists(dir)) {
        std::fprintf(stderr, "polaron: environment '%s' already exists\n", name.c_str());
        return 1;
    }
    std::error_code ec;
    fs::create_directories(dir / kLibrariesDir, ec);
    if (ec) {
        std::fprintf(stderr, "polaron: cannot create environment '%s': %s\n", name.c_str(), ec.message().c_str());
        return 1;
    }
    std::ofstream mf(environmentManifest(name), std::ios::binary);
    mf << "[polaron_project]\n[program]\nname = \"" << name << "\"\nversion = \"0.0.0\"\n\n[dependencies]\n";
    std::printf("created environment '%s'\n", name.c_str());
    return 0;
}

int envList() {
    const fs::path dir = environmentsDir();
    std::error_code ec;
    bool any = false;
    for (const auto& e : fs::directory_iterator(dir, ec)) {
        if (e.is_directory()) {
            std::printf("%s\n", e.path().filename().string().c_str());
            any = true;
        }
    }
    if (!any) {
        std::printf("(no environments)\n");
    }
    return 0;
}

int envRemove(const std::string& name) {
    const fs::path dir = environmentsDir() / name;
    std::error_code ec;
    const bool existed = fs::exists(dir);
    fs::remove_all(dir, ec);
    if (existed) {
        std::printf("removed environment '%s'\n", name.c_str());
    } else {
        std::printf("environment '%s' does not exist\n", name.c_str());
    }
    return 0;
}

}  // namespace polaron::driver
