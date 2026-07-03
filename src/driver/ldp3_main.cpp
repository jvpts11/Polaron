// The `ldp3` toolchain driver: a lightweight front-end that dispatches subcommands and orchestrates
// the low-level compiler (ldp3c) and linker (clang). Carries no LLVM itself.
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "driver/build.h"
#include "driver/manifest.h"
#include "driver/scaffold.h"

namespace {
constexpr const char* kVersion = "ldp3 0.1.0-dev";

int printHelp() {
    std::printf(
        "ldp3 - the LDP3 toolchain\n\n"
        "usage:\n"
        "  ldp3 run [file.ldp3] [-- args...]   build and run (current project, or a bare file)\n"
        "  ldp3 build                          build the current project to build-output/\n"
        "  ldp3 compile <file.ldp3>            compile one file to an .exe (no run)\n"
        "  ldp3 new <name>                     scaffold a new project\n"
        "  ldp3 init                           scaffold in the current directory\n"
        "  ldp3 clean                          remove build-output/\n"
        "  ldp3 --version                      print the version\n"
        "  ldp3 --help                         print this help\n");
    return 0;
}
}  // namespace

int main(int argc, char** argv) {
    std::vector<std::string> args(argv + 1, argv + argc);
    if (args.empty()) return printHelp();
    const std::string& cmd = args[0];

    if (cmd == "--version" || cmd == "-v") {
        std::printf("%s\n", kVersion);
        return 0;
    }
    if (cmd == "--help" || cmd == "-h") return printHelp();

    if (cmd == "new") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'new' requires a project name\n"); return 2; }
        return ldp3::driver::scaffold(std::filesystem::path(args[1]), args[1]);
    }
    if (cmd == "init") {
        const std::filesystem::path cwd = std::filesystem::current_path();
        return ldp3::driver::scaffold(cwd, cwd.filename().string());
    }
    if (cmd == "compile") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'compile' requires a file\n"); return 2; }
        const std::filesystem::path file(args[1]);
        ldp3::driver::Manifest m = ldp3::driver::ephemeralManifest(file);
        m.outputDir = "build-output/";
        ldp3::driver::BuildOptions opts;
        for (std::size_t i = 2; i < args.size(); ++i) opts.passthrough.push_back(args[i]);
        return ldp3::driver::buildProgram(m, std::filesystem::current_path(), opts);
    }
    if (cmd == "build") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr,
                "ldp3: no ldp3.toml found in this directory or any parent; "
                "run 'ldp3 init' or 'ldp3 run <file>'\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "ldp3: manifest has no [program] entry\n"); return 1; }
        ldp3::driver::BuildOptions opts;
        return ldp3::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }

    std::fprintf(stderr, "ldp3: unknown command '%s'\n", cmd.c_str());
    printHelp();
    return 2;
}
