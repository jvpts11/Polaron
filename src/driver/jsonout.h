#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

// Produce a JSON object describing the LDP3 workspace under `root`: the discovered projects, the shared
// environments (with their libraries and users), and the aggregated library inventory. Consumed by the
// VS Code extension's tree views via `ldp3 json`.
std::string studioJson(const std::filesystem::path& root);

}  // namespace ldp3::driver
