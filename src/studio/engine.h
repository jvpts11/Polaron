#pragma once
#include <filesystem>
#include <string>
#include <vector>

namespace ldp3::studio {

// The result of running a captured toolchain action.
struct ActionResult {
    int exitCode = -1;
    std::vector<std::string> lines;  // stdout+stderr, split into lines
};

// The ldp3 CLI executable -- a sibling of ldp3-studio.
std::filesystem::path ldp3Cli();

// Run `ldp3 <verb>` in projectDir, capturing stdout and stderr. Blocking: call it off the UI thread.
ActionResult runCaptured(const std::string& verb, const std::filesystem::path& projectDir);

}  // namespace ldp3::studio
