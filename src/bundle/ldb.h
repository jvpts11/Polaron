#pragma once

// The .ldb bundle container (spec 2.4, issue #12): a compiled LDP3 bundle plus its public-API
// header, ABI fingerprint, dependencies and required capabilities, in one self-describing binary.
// See docs/superpowers/specs/2026-06-28-ldb-bundle-format-design.md.

#include <array>
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace ldp3 {

// A dependency on another bundle (spec 2.5): the expected name, a version constraint, and the ABI
// fingerprint the consumer compiled against (validated when the dependency is linked/loaded).
struct LdbDep {
    std::string name;
    std::string versionConstraint;        // e.g. ">=1.2.0"; empty = any
    std::array<std::uint8_t, 32> fingerprint{};
};

// An in-memory .ldb bundle. Serialized by writeLdb / parsed by readLdb.
struct LdbBundle {
    std::string name;                      // bundle name, e.g. "audio"
    std::string version;                   // semver, e.g. "1.2.0"
    std::uint16_t flags = 0;               // bit0: freestanding
    std::array<std::uint8_t, 32> fingerprint{};  // SHA-256 of the canonical public API
    std::string ldh;                       // public API as LDP3 declaration text (the .ldh)
    std::string code;                      // compiled code (LLVM bitcode)
    std::vector<LdbDep> deps;              // required bundles
    std::vector<std::string> capabilities; // required capabilities
    // The bundle's global vtable slot layout: vtableSlots[i] is the virtual method name at slot i.
    // A consumer seeds its own slot numbering from this so cross-bundle virtual dispatch hits the
    // same slots the bundle's baked-in vtables use (spec 2.5 ABI).
    std::vector<std::string> vtableSlots;

    static constexpr std::uint16_t kFreestanding = 1u << 0;
};

// SHA-256 of the public-API text -- the bundle's ABI fingerprint (spec 2.5).
std::array<std::uint8_t, 32> ldbFingerprint(std::string_view publicApi);

// Serializes a bundle to the .ldb byte layout.
std::string writeLdb(const LdbBundle& bundle);

// Parses a .ldb byte buffer. Returns false (and leaves `out` partially filled) on a bad/short file.
bool readLdb(std::string_view bytes, LdbBundle& out);

}  // namespace ldp3
