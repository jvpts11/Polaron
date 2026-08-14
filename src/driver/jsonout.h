#pragma once
#include <filesystem>
#include <string>

namespace polaron::driver {

// Produce a JSON object describing the Polaron workspace under `root`: the discovered projects, the shared
// environments (with their libraries and users), and the aggregated library inventory. Consumed by the
// VS Code extension's tree views via `polaron json`.
std::string studioJson(const std::filesystem::path& root);

}  // namespace polaron::driver
