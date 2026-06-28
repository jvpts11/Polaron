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
}

TEST_CASE("ldb fingerprint is stable and content-sensitive") {
    CHECK(ldbFingerprint("public class A {}") == ldbFingerprint("public class A {}"));
    CHECK(ldbFingerprint("public class A {}") != ldbFingerprint("public class B {}"));
}

TEST_CASE("readLdb rejects a non-ldb buffer") {
    LdbBundle r;
    CHECK_FALSE(readLdb("not an ldb file", r));
    CHECK_FALSE(readLdb("", r));
}
