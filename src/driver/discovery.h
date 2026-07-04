#pragma once
#include <filesystem>
#include <functional>
#include <vector>
#include "driver/manifest.h"

namespace ldp3::driver {

// A project found on disk: its directory (the one holding ldp3.toml) and the parsed manifest.
struct DiscoveredProject {
    std::filesystem::path dir;
    Manifest manifest;
};

// Walk `root` recursively for ldp3.toml files -- skipping packages/, build-output/, .git and node_modules --
// parse each, and return the projects sorted by name. Unreadable manifests are skipped. This is the engine
// used by the TUI's launch scan; a future `ldp3 --json` mode can expose it too.
std::vector<DiscoveredProject> discoverProjects(const std::filesystem::path& root);

// The same walk, but reporting each project through `onFound` as it is discovered (unsorted), and checking
// `shouldStop` periodically to abort early. Used by the TUI's background computer-wide scan, which streams
// results into the list as they arrive.
void discoverProjectsStreaming(const std::filesystem::path& root,
                               const std::function<void(DiscoveredProject)>& onFound,
                               const std::function<bool()>& shouldStop);

}  // namespace ldp3::driver
