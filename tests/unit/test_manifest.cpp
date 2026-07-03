#include <doctest/doctest.h>
#include "driver/manifest.h"

using namespace ldp3::driver;

TEST_CASE("parseManifestText reads program fields") {
    const std::string toml =
        "[ldp3_project]\n"
        "[program]\n"
        "name = \"demo\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.ldp3\"\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "demo");
    CHECK(m.version == "0.1.0");
    CHECK(m.entry == "src/main.ldp3");
    CHECK(m.outputDir == "build-output/");
    CHECK(m.target == "x86_64-windows");
    CHECK(m.freestanding == false);
    CHECK(m.hasDependencies == false);
}

TEST_CASE("parseManifestText ignores comments and detects dependencies") {
    const std::string toml =
        "[ldp3_project]\n"
        "[program]\n"
        "name = \"x\"  # trailing comment\n"
        "entry = \"main.ldp3\"\n"
        "[dependencies]\n"
        "audio = \"1.0.0\"\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "x");
    CHECK(m.entry == "main.ldp3");
    CHECK(m.hasDependencies == true);
}

TEST_CASE("ephemeralManifest uses the file stem and its path") {
    Manifest m = ephemeralManifest("samples/hello_world.ldp3");
    CHECK(m.name == "hello_world");
    CHECK(m.entry == "samples/hello_world.ldp3");
    CHECK(m.version == "0.0.0");
    CHECK(m.hasDependencies == false);
}
