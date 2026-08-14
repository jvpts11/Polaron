#include <doctest/doctest.h>
#include <filesystem>
#include <fstream>
#include "driver/sources.h"

using namespace polaron::driver;

namespace {
std::filesystem::path noSources() {
    return std::filesystem::temp_directory_path() / "polaron_no_such_sources.toml";
}
std::filesystem::path writeSources(const std::string& content) {
    const auto p = std::filesystem::temp_directory_path() / "polaron_test_sources.toml";
    std::ofstream f(p, std::ios::binary);
    f << content;
    return p;
}
}  // namespace

TEST_CASE("resolveSource passes through full URLs and local paths") {
    auto url = resolveSource("https://github.com/u/lib", noSources());
    REQUIRE(url.has_value());
    CHECK(url.value() == "https://github.com/u/lib");

    auto drive = resolveSource("C:/local/repo", noSources());
    REQUIRE(drive.has_value());
    CHECK(drive.value() == "C:/local/repo");

    auto rel = resolveSource("./rel/repo", noSources());
    REQUIRE(rel.has_value());
    CHECK(rel.value() == "./rel/repo");
}

TEST_CASE("resolveSource adds https:// to a schemeless host path") {
    auto r = resolveSource("github.com/u/lib", noSources());
    REQUIRE(r.has_value());
    CHECK(r.value() == "https://github.com/u/lib");
}

TEST_CASE("resolveSource looks a bare name up in sources.toml") {
    const auto p = writeSources("[sources]\naudio = \"https://example.com/audio.git\"\n");
    auto found = resolveSource("audio", p);
    REQUIRE(found.has_value());
    CHECK(found.value() == "https://example.com/audio.git");
    CHECK_FALSE(resolveSource("missing", p).has_value());
    std::filesystem::remove(p);
}
