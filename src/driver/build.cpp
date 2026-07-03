#include "driver/build.h"
#include "driver/process.h"
#include "driver/toolchain.h"
#include <cstdio>

namespace ldp3::driver {
namespace fs = std::filesystem;

int buildProgram(const Manifest& m, const fs::path& projectDir, const BuildOptions& opts) {
    if (m.hasDependencies) {
        std::fprintf(stderr, "ldp3: dependencies are not supported yet (coming in a later release)\n");
        return 1;
    }
    const Toolchain tc = locateToolchain();

    const fs::path entry = projectDir / m.entry;
    if (!fs::is_regular_file(entry)) {
        std::fprintf(stderr, "ldp3: entry file not found: %s\n", entry.string().c_str());
        return 1;
    }

    const fs::path outDir = projectDir / m.outputDir;
    std::error_code ec;
    fs::create_directories(outDir, ec);
    const fs::path ll = outDir / (m.name + ".ll");
    const fs::path exe = outDir / (m.name + ".exe");

    // 1) Compile: ldp3c <entry> -o <ll> [passthrough]
    std::vector<std::string> compileArgs = {entry.string(), "-o", ll.string()};
    for (const auto& p : opts.passthrough) compileArgs.push_back(p);
    if (int rc = runProcess(tc.ldp3c, compileArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: compilation failed\n");
        return rc == -1 ? 1 : rc;
    }

    // 2) Link: clang <ll> <runtimeLib> -llegacy_stdio_definitions -lws2_32 -o <exe>
    std::vector<std::string> linkArgs = {
        "-Wno-override-module", ll.string(), tc.runtimeLib,
        "-llegacy_stdio_definitions", "-lws2_32", "-o", exe.string()};
    if (int rc = runProcess(tc.clang, linkArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: link failed\n");
        return rc == -1 ? 1 : rc;
    }
    std::printf("wrote %s\n", exe.string().c_str());

    // 3) Optionally run.
    if (opts.run) return runProcess(exe.string(), opts.runArgs);
    return 0;
}

}  // namespace ldp3::driver
