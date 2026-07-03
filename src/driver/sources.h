#pragma once
#include <filesystem>
#include <optional>
#include <string>

namespace ldp3::driver {

// Turn a `plug` argument into something `git clone` accepts:
//   - a full URL with a scheme (https://..., git@...) is returned as-is;
//   - a local path (starts with '.', '/', '\\', or a drive letter) is returned as-is;
//   - a schemeless host path (github.com/user/lib) gets an https:// prefix;
//   - a bare name is looked up in the [sources] table of `sourcesToml` (name = "url").
// Returns nullopt for a bare name with no mapping.
std::optional<std::string> resolveSource(const std::string& spec, const std::filesystem::path& sourcesToml);

}  // namespace ldp3::driver
