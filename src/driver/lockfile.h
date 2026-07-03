#pragma once
#include <filesystem>
#include <map>
#include <string>

namespace ldp3::driver {

// A pinned install: a package name mapped to its exact resolved source ("url@exact-tag", or just "url"
// for a default-branch checkout). Ordered by name for stable output.
using LockMap = std::map<std::string, std::string>;

// Read ldp3.lock's [locked] section. Empty if the file is absent or has no entries.
LockMap readLock(const std::filesystem::path& path);

// Write ldp3.lock with the given pinned installs. Returns false on I/O failure.
bool writeLock(const std::filesystem::path& path, const LockMap& locked);

}  // namespace ldp3::driver
