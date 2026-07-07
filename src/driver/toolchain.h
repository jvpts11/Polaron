#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

struct Toolchain {
    std::string ldp3c;       // low-level compiler (sibling of this exe, or $LDP3C)
    std::string clang;       // compiler/linker driver ($LDP3_CLANG, PATH, or compile-time default)
    std::string runtimeLib;  // ldp3_rt.lib (sibling of this exe, or $LDP3_RUNTIME)
    // Self-contained bundle (a full install): a sibling lib/ directory holding the CRT + Windows import
    // libs and lld-link. When present, linking goes through lld-link against these libs so no system
    // Visual Studio / Windows SDK is required -- LDP3 works on a bare Windows 10/11 x64 machine.
    std::string libDir;      // bundled CRT/import libs directory, or "" (use the system toolchain)
    std::string lldLink;     // bundled lld-link.exe, or ""
};

// Directory containing the running ldp3 executable.
std::filesystem::path exeDir();

// The ~/.ldp3 directory (global config: sources.toml, environments/). Not created here.
std::filesystem::path ldp3HomeDir();

// Resolve the tools the driver needs.
Toolchain locateToolchain();

}  // namespace ldp3::driver
