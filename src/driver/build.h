#pragma once
#include <filesystem>
#include <string>
#include <vector>
#include "driver/manifest.h"

namespace ldp3::driver {

struct BuildOptions {
    bool run = false;                       // execute the exe after building
    bool debug = false;                     // -g -O0 build for a debugger (DWARF, no optimization)
    // Type-check only: run the front end over the project and print its diagnostics, emitting nothing.
    // This is what an editor asks for while you type, so it must see exactly what a build would see --
    // every source file, every dependency header -- and it must be quick, which is why it stops before
    // codegen. A path dependency that is already built is reused rather than rebuilt.
    bool checkOnly = false;
    // `--overlay <real>=<temp>` pairs: a file whose content lives in a scratch copy because the editor has
    // not saved it yet. Diagnostics still name the real file (see ldp3c's --overlay).
    std::vector<std::string> overlays;
    std::vector<std::string> runArgs;       // args passed to the program (run only)
    std::vector<std::string> passthrough;   // extra flags forwarded to ldp3c (--target, -O, ...)
};

// Compile the manifest's entry to IR (ldp3c) then link to an .exe (clang) under the output dir.
// If opts.run, execute it and return its exit code. Returns non-zero on any build failure.
int buildProgram(const Manifest& m, const std::filesystem::path& projectDir, const BuildOptions& opts);

}  // namespace ldp3::driver
