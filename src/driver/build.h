#pragma once
#include <filesystem>
#include <string>
#include <vector>
#include "driver/manifest.h"

namespace polaron::driver {

// Apply the target-specific fixups a build applies to an assembly file, in place. Today: the m68k
// rewrite of `(symbol,%pc)` to `symbol`, because LLVM's M68k backend addresses every global with a
// 16-bit PC-relative displacement and a program with a runtime behind it does not fit in 32 KB.
// Exposed so the build and any harness that drives clang itself share one implementation of it.
bool fixTargetAssembly(const std::filesystem::path& asmFile);

struct BuildOptions {
    bool run = false;                       // execute the exe after building
    bool debug = false;                     // -g -O0 build for a debugger (DWARF, no optimization)
    // Type-check only: run the front end over the project and print its diagnostics, emitting nothing.
    // This is what an editor asks for while you type, so it must see exactly what a build would see --
    // every source file, every dependency header -- and it must be quick, which is why it stops before
    // codegen. A path dependency that is already built is reused rather than rebuilt.
    bool checkOnly = false;
    // `--overlay <real>=<temp>` pairs: a file whose content lives in a scratch copy because the editor has
    // not saved it yet. Diagnostics still name the real file (see polc's --overlay).
    std::vector<std::string> overlays;
    std::vector<std::string> runArgs;       // args passed to the program (run only)
    std::vector<std::string> passthrough;   // extra flags forwarded to polc (--target, -O, ...)
    // `--static`: link the C library IN rather than against it.
    //
    // Which distributions a binary runs on is a question about symbol versions and nothing else. Built
    // on this machine a Polaron program records references up to `GLIBC_2.34`, and an older glibc
    // refuses to start it with "version `GLIBC_2.34' not found" -- a message about the loader, not
    // about the program. 2.34 is 2021, which leaves out every long-term distribution released before
    // it. A static binary carries no such reference and runs wherever the kernel is compatible.
    //
    // Off by default: it costs size, and it gives up `dlopen`, which is how a dynamically loaded
    // `.polb` is resolved -- so a static link and `--use-dynamic` are mutually exclusive.
    bool staticLink = false;
};

// Compile the manifest's entry to IR (polc) then link to an .exe (clang) under the output dir.
// If opts.run, execute it and return its exit code. Returns non-zero on any build failure.
int buildProgram(const Manifest& m, const std::filesystem::path& projectDir, const BuildOptions& opts);

// Every .pol that belongs to a project whose entry is `entry`: the entry first (it fixes the program
// name), then every other .pol under its directory, sorted.
//
// Exposed because `polaron plug` compiles a downloaded dependency itself, and compiled only the entry --
// so a library of more than one file built fine where it lived and failed the moment somebody installed
// it, on a name declared in a sibling file. A project's sources are one question with one answer.
std::vector<std::filesystem::path> collectSources(const std::filesystem::path& entry);

}  // namespace polaron::driver
