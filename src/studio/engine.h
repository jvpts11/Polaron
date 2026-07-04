#pragma once
#include <filesystem>
#include <string>
#include <vector>

#include "driver/discovery.h"
#include "studio/state.h"

namespace ldp3::studio {

// The result of running a captured toolchain action.
struct ActionResult {
    int exitCode = -1;
    std::vector<std::string> lines;  // stdout+stderr, split into lines
};

// Load the shared environments (their libraries, and which of `projects` use each).
std::vector<Environment> loadEnvironments(const std::vector<ldp3::driver::DiscoveredProject>& projects);

// Create a new app project `name` under parentDir (scaffold), optionally assigning it to environment `env`.
// Returns true on success.
bool createProject(const std::string& name, const std::filesystem::path& parentDir, const std::string& env);

// Aggregate the libraries referenced across `projects` and `environments` into a sorted inventory: each
// library with its distinct versions and where it is used.
std::vector<Library> loadLibraries(const std::vector<ldp3::driver::DiscoveredProject>& projects,
                                   const std::vector<Environment>& environments);

// Resolve the toolchain (tool paths, directories, default target) for the Toolchain screen.
ToolchainInfo loadToolchainInfo();

// The ldp3 CLI executable -- a sibling of ldp3-studio.
std::filesystem::path ldp3Cli();

// Run `ldp3 <args...>` in projectDir, capturing stdout and stderr. Blocking: call it off the UI thread.
ActionResult runCaptured(const std::vector<std::string>& args, const std::filesystem::path& projectDir);

// Convenience: run a single verb.
ActionResult runCaptured(const std::string& verb, const std::filesystem::path& projectDir);

}  // namespace ldp3::studio
