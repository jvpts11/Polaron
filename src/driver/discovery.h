#pragma once
#include <filesystem>
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
// used by the TUI's launch scan and background scan; a future `ldp3 --json` mode can expose it too.
std::vector<DiscoveredProject> discoverProjects(const std::filesystem::path& root);

}  // namespace ldp3::driver
