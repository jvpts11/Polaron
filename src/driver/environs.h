#pragma once
#include <filesystem>
#include <string>
#include <vector>

namespace polaron::driver {

// The directory holding named environments (~/.pol/environments, or under $POLARON_HOME).
std::filesystem::path environmentsDir();

// The names of all environments, sorted. Reusable by the TUI and the CLI's `env list`.
std::vector<std::string> listEnvironments();

// The libraries/ directory of a named environment: where its shared installs live.
std::filesystem::path environmentPackagesDir(const std::string& name);

// The manifest recording a named environment's dependencies.
std::filesystem::path environmentManifest(const std::string& name);

// `polaron env new <name>`: create the environment (its directory, libraries/, and an empty manifest).
int envNew(const std::string& name);

// `polaron env list`: print the names of all environments.
int envList();

// `polaron env remove <name>`: delete an environment. Idempotent.
int envRemove(const std::string& name);

}  // namespace polaron::driver
