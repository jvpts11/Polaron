#pragma once
#include <filesystem>
#include <string>

namespace polaron::driver {

// Install a dependency: resolve `spec` (name|url[@version]) to a URL via `sourcesToml`, clone it into
// `packagesDir/<name>/`, compile it to <name>.polb/.polh with `polc`, and record it in `manifestPath`.
// Returns 0 on success; on failure the clone is rolled back so the project is left unchanged.
int plug(const std::filesystem::path& manifestPath, const std::filesystem::path& packagesDir,
         const std::filesystem::path& sourcesToml, const std::string& spec, const std::string& polc);

// Remove a dependency's directory from `packagesDir` and its entry from `manifestPath`. Idempotent.
int unplug(const std::filesystem::path& manifestPath, const std::filesystem::path& packagesDir,
           const std::string& name);

// Install every dependency listed in `manifestPath` (and, transitively, theirs) into `packagesDir`,
// skipping ones already present. Used by `polaron plug` with no arguments.
int plugAll(const std::filesystem::path& manifestPath, const std::filesystem::path& packagesDir,
            const std::filesystem::path& sourcesToml, const std::string& polc);

}  // namespace polaron::driver
