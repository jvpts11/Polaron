#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

struct Toolchain {
    std::string ldp3c;       // low-level compiler (sibling of this exe, or $LDP3C)
    std::string clang;       // linker driver ($LDP3_CLANG, PATH, or compile-time default)
    std::string runtimeLib;  // ldp3_rt.lib (sibling of this exe, or $LDP3_RUNTIME)
};

// Directory containing the running ldp3 executable.
std::filesystem::path exeDir();

// Resolve the tools the driver needs.
Toolchain locateToolchain();

}  // namespace ldp3::driver
