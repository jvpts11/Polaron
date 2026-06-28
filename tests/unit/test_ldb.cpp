#include <doctest/doctest.h>

#include "bundle/ldb.h"

using namespace ldp3;

TEST_CASE("ldb container round-trips its fields") {
    LdbBundle b;
    b.name = "audio";
    b.version = "1.2.0";
    b.flags = LdbBundle::kFreestanding;
    b.ldh = "public class Mixer { public method mix(int a, int b) returns int; }";
    b.code = std::string{'\x00', '\x01', 'B', 'C', '\xC0', '\xDE'};  // bitcode-like bytes (incl. NUL)
    b.fingerprint = ldbFingerprint(b.ldh);
    b.deps.push_back(LdbDep{"codec", ">=2.0.0", ldbFingerprint("codec-api")});
    b.capabilities = {"audio.output", "files.read"};
    b.vtableSlots = {"mix", "reset"};

    const std::string bytes = writeLdb(b);
    LdbBundle r;
    REQUIRE(readLdb(bytes, r));
    CHECK(r.name == b.name);
    CHECK(r.version == b.version);
    CHECK(r.flags == b.flags);
    CHECK(r.fingerprint == b.fingerprint);
    CHECK(r.ldh == b.ldh);
    CHECK(r.code == b.code);
    REQUIRE(r.deps.size() == 1);
    CHECK(r.deps[0].name == "codec");
    CHECK(r.deps[0].versionConstraint == ">=2.0.0");
    CHECK(r.deps[0].fingerprint == b.deps[0].fingerprint);
    REQUIRE(r.capabilities.size() == 2);
    CHECK(r.capabilities[0] == "audio.output");
    CHECK(r.capabilities[1] == "files.read");
    REQUIRE(r.vtableSlots.size() == 2);
    CHECK(r.vtableSlots[0] == "mix");
    CHECK(r.vtableSlots[1] == "reset");
}

TEST_CASE("ldb fingerprint is stable and content-sensitive") {
    CHECK(ldbFingerprint("public class A {}") == ldbFingerprint("public class A {}"));
    CHECK(ldbFingerprint("public class A {}") != ldbFingerprint("public class B {}"));
}

TEST_CASE("ldb fingerprint matches the SHA-256 known-answer vector") {
    // SHA-256("abc") = ba7816bf 8f01cfea 414140de 5dae2223 b00361a3 96177a9c b410ff61 f20015ad.
    const std::array<std::uint8_t, 32> expected = {
        0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea, 0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
        0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c, 0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad};
    CHECK(ldbFingerprint("abc") == expected);
}

TEST_CASE("readLdb rejects a non-ldb buffer") {
    LdbBundle r;
    CHECK_FALSE(readLdb("not an ldb file", r));
    CHECK_FALSE(readLdb("", r));
}
