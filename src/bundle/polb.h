#pragma once

// The .polb bundle container (spec 2.4, issue #12): a compiled Polaron bundle plus its public-API
// header, ABI fingerprint, dependencies and required capabilities, in one self-describing binary.
// See docs/superpowers/specs/2026-06-28-polb-bundle-format-design.md.

#include <array>
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace polaron {

// A dependency on another bundle (spec 2.5): the expected name, a version constraint, and the ABI
// fingerprint the consumer compiled against (validated when the dependency is linked/loaded).
struct PolbDep {
    std::string name;
    std::string versionConstraint;        // e.g. ">=1.2.0"; empty = any
    std::array<std::uint8_t, 32> fingerprint{};
};

// HOW AN OBJECT IS LAID OUT, as a number.
//
// The fingerprint verifies the INTERFACE -- it is a hash of the .polh text -- and that is not the same
// thing as verifying the layout. Two compilers can agree on every declaration in a header and still
// disagree about where a field sits, and when they do, nothing on either side notices: the consumer
// reads and writes a consistent wrong offset. (That is not hypothetical; it is exactly what private
// fields did before they were reserved in the header.)
//
// So the layout rules carry their own revision, checked on load, independent of the compiler's release
// number -- because two releases with identical layout rules should still be able to link, and one
// release that changes them must not.
//
// BUMP THIS when any of the following changes: field ordering; the vtable pointer's presence or
// position; how a `weak` field, a bit-field run, an array header, a String or a region slot is laid
// out; the size or alignment the header reserves for a private field; or the receiver's position in a
// method's signature.
//
//   1  the layout described in docs/design/abi.md, with private fields reserved in the .polh
inline constexpr std::uint16_t kAbiRevision = 1;

// An in-memory .polb bundle. Serialized by writePolb / parsed by readPolb.
struct PolbBundle {
    std::string name;                      // bundle name, e.g. "audio"
    std::string version;                   // semver, e.g. "1.2.0"
    std::uint16_t flags = 0;               // bit0: freestanding
    std::uint16_t abiRevision = kAbiRevision;  // the layout rules this bundle's code was built to
    std::string producer;                  // what built it, e.g. "polc 1.0.37" -- for the message, not the check
    std::array<std::uint8_t, 32> fingerprint{};  // SHA-256 of the canonical public API
    std::string polh;                       // public API as Polaron declaration text (the .polh)
    std::string code;                      // compiled code (LLVM bitcode)
    std::vector<PolbDep> deps;              // required bundles
    std::vector<std::string> capabilities; // required capabilities
    // The bundle's global vtable slot layout: vtableSlots[i] is the virtual method name at slot i.
    // A consumer seeds its own slot numbering from this so cross-bundle virtual dispatch hits the
    // same slots the bundle's baked-in vtables use (spec 2.5 ABI).
    std::vector<std::string> vtableSlots;

    static constexpr std::uint16_t kFreestanding = 1u << 0;
};

// SHA-256 of the public-API text -- the bundle's ABI fingerprint (spec 2.5).
std::array<std::uint8_t, 32> polbFingerprint(std::string_view publicApi);

// Serializes a bundle to the .polb byte layout.
std::string writePolb(const PolbBundle& bundle);

// Parses a .polb byte buffer. Returns false (and leaves `out` partially filled) on a bad/short file.
bool readPolb(std::string_view bytes, PolbBundle& out);

}  // namespace polaron
