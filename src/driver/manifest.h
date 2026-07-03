#pragma once
#include <filesystem>
#include <optional>
#include <string>

namespace ldp3::driver {

// A resolved project manifest. Fields not present in the file keep their defaults.
struct Manifest {
    std::string name;
    std::string version = "0.0.0";
    std::string languageVersion;
    std::string entry;
    std::string outputDir = "build-output/";
    std::string target = "x86_64-windows";
    bool freestanding = false;
    bool hasDependencies = false;  // true if [dependencies] has any non-blank entry
};

// Parse the supported TOML subset ([program]/[build]/[dependencies]) from text.
Manifest parseManifestText(const std::string& text);

// Walk up from `start` (inclusive) looking for a .toml whose first non-blank line is [ldp3_project].
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start);

// Synthesize a manifest for a single loose file (name = stem, entry = the file).
Manifest ephemeralManifest(const std::filesystem::path& file);

}  // namespace ldp3::driver
