#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

// The directory holding named environments (~/.ldp3/environments, or under $LDP3_HOME).
std::filesystem::path environmentsDir();

// The packages/ directory of a named environment.
std::filesystem::path environmentPackagesDir(const std::string& name);

// The manifest recording a named environment's dependencies.
std::filesystem::path environmentManifest(const std::string& name);

// `ldp3 env new <name>`: create the environment (its directory, packages/, and an empty manifest).
int envNew(const std::string& name);

// `ldp3 env list`: print the names of all environments.
int envList();

// `ldp3 env remove <name>`: delete an environment. Idempotent.
int envRemove(const std::string& name);

}  // namespace ldp3::driver
