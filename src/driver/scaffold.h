#pragma once
#include <filesystem>
#include <string>

namespace polaron::driver {

// Create dir/ (if needed) with polaron.toml, src/main.pol and .gitignore for a project called `name`.
int scaffold(const std::filesystem::path& dir, const std::string& name);

}  // namespace polaron::driver
