#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

// Create dir/ (if needed) with ldp3.toml, src/main.ldp3 and .gitignore for a project called `name`.
int scaffold(const std::filesystem::path& dir, const std::string& name);

}  // namespace ldp3::driver
