#include <doctest/doctest.h>

#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "driver/discovery.h"

using namespace ldp3::driver;
namespace fs = std::filesystem;

namespace {
void writeManifest(const fs::path& dir, const std::string& name) {
    fs::create_directories(dir);
    std::ofstream(dir / "ldp3.toml")
        << "[ldp3_project]\n[program]\nname = \"" << name << "\"\nlanguage_version = \"1.0\"\n"
        << "entry = \"src/main.ldp3\"\n";
}
}  // namespace

TEST_CASE("discoverProjects finds ldp3.toml and skips packages/ and build-output/") {
    const fs::path root = fs::temp_directory_path() / "ldp3_discovery_test";
    fs::remove_all(root);
    writeManifest(root / "alpha", "alpha");
    writeManifest(root / "sub" / "beta", "beta");
    writeManifest(root / "gamma", "gamma");
    writeManifest(root / "gamma" / "packages" / "dep", "dep");    // under packages/: excluded
    writeManifest(root / "delta", "delta");
    writeManifest(root / "delta" / "build-output" / "x", "gen");  // under build-output/: excluded

    const std::vector<DiscoveredProject> found = discoverProjects(root);
    std::vector<std::string> names;
    for (const DiscoveredProject& p : found) names.push_back(p.manifest.name);

    CHECK(names == std::vector<std::string>{"alpha", "beta", "delta", "gamma"});  // sorted, deps excluded
    CHECK(found.front().dir == root / "alpha");
    CHECK(found.front().manifest.entry == "src/main.ldp3");

    fs::remove_all(root);
}
