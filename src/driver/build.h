#pragma once
#include <filesystem>
#include <string>
#include <vector>
#include "driver/manifest.h"

namespace ldp3::driver {

struct BuildOptions {
    bool run = false;                       // execute the exe after building
    bool debug = false;                     // -g -O0 build for a debugger (DWARF, no optimization)
    std::vector<std::string> runArgs;       // args passed to the program (run only)
    std::vector<std::string> passthrough;   // extra flags forwarded to ldp3c (--target, -O, ...)
};

// Compile the manifest's entry to IR (ldp3c) then link to an .exe (clang) under the output dir.
// If opts.run, execute it and return its exit code. Returns non-zero on any build failure.
int buildProgram(const Manifest& m, const std::filesystem::path& projectDir, const BuildOptions& opts);

}  // namespace ldp3::driver
