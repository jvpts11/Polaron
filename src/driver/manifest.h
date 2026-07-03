#pragma once
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace ldp3::driver {

// A single declared dependency: a package name and the version (a Git tag, or empty for the default branch).
struct Dependency {
    std::string name;
    std::string version;
};

// A resolved project manifest. Fields not present in the file keep their defaults.
struct Manifest {
    std::string name;
    std::string version = "0.0.0";
    std::string languageVersion;
    std::string entry;
    std::string outputDir = "build-output/";
    std::string target = "x86_64-windows";
    std::string environment;             // optional shared environment ([build] environment = "...")
    bool freestanding = false;
    std::vector<Dependency> dependencies;  // from [dependencies]
    bool hasDependencies = false;          // convenience: !dependencies.empty()
};

// Parse the supported TOML subset ([program]/[build]/[dependencies]) from text.
Manifest parseManifestText(const std::string& text);

// Walk up from `start` (inclusive) looking for a .toml whose first non-blank line is [ldp3_project].
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start);

// Synthesize a manifest for a single loose file (name = stem, entry = the file).
Manifest ephemeralManifest(const std::filesystem::path& file);

// Add or update a `name = "version"` entry under [dependencies], creating the section if needed.
// Only that section is touched; every other line is preserved. Returns false on I/O failure.
bool addDependency(const std::filesystem::path& manifestPath, const std::string& name,
                   const std::string& version);

// Remove a dependency line under [dependencies]. Absent entry is a no-op (still returns true).
bool removeDependency(const std::filesystem::path& manifestPath, const std::string& name);

}  // namespace ldp3::driver
