#include <doctest/doctest.h>
// A module does not hand its importer the standard library. `import polaron.driver.semver` brings the
// DECLARATIONS, and comparing the std::string it returns needs <string> here -- that is the leak the
// header model had and this one does not.
//
// `<vector>` for the same reason, and it took the first Linux build to notice: MSVC had it transitively
// through <doctest.h>, libstdc++ does not, and "it compiled on my compiler" is exactly the gap a second
// toolchain exists to close.
#include <string>
#include <vector>

import polaron.driver.semver;

using namespace polaron::driver;

namespace {
SemVer sv(const char* s) { return *parseSemVer(s); }
}  // namespace

TEST_CASE("parseSemVer handles v-prefix and partials") {
    auto v = parseSemVer("v2.5.7");
    REQUIRE(v.has_value());
    CHECK(v->major == 2);
    CHECK(v->minor == 5);
    CHECK(v->patch == 7);
    CHECK(parseSemVer("3")->major == 3);         // partial fills the rest with 0
    CHECK_FALSE(parseSemVer("main").has_value()); // not a version
}

TEST_CASE("satisfies covers exact, caret, tilde and minimum") {
    CHECK(satisfies(sv("1.2.3"), "1.2.3"));
    CHECK_FALSE(satisfies(sv("1.2.4"), "1.2.3"));

    CHECK(satisfies(sv("1.9.0"), "^1.2.3"));
    CHECK_FALSE(satisfies(sv("2.0.0"), "^1.2.3"));
    CHECK_FALSE(satisfies(sv("1.2.2"), "^1.2.3"));

    CHECK(satisfies(sv("0.2.9"), "^0.2.3"));   // caret on 0.x narrows to the minor
    CHECK_FALSE(satisfies(sv("0.3.0"), "^0.2.3"));

    CHECK(satisfies(sv("1.5.9"), "~1.5.2"));
    CHECK_FALSE(satisfies(sv("1.6.0"), "~1.5.2"));

    CHECK(satisfies(sv("5.1.0"), ">=2.0.0"));
    CHECK_FALSE(satisfies(sv("1.9.9"), ">=2.0.0"));
}

TEST_CASE("highestMatching picks the greatest satisfying tag") {
    const std::vector<std::string> tags = {"v1.0.0", "v1.2.0", "v1.3.5", "v2.0.0", "not-a-version"};
    auto r = highestMatching(tags, "^1.0.0");
    REQUIRE(r.has_value());
    CHECK(r.value() == "v1.3.5");
    CHECK(highestMatching(tags, ">=2.0.0").value() == "v2.0.0");
    CHECK_FALSE(highestMatching(tags, "^9.0.0").has_value());
}

TEST_CASE("isVersionConstraint distinguishes versions from branch names") {
    CHECK(isVersionConstraint("1.2.3"));
    CHECK(isVersionConstraint("^1.0.0"));
    CHECK(isVersionConstraint(">=2.0.0"));
    CHECK(isVersionConstraint("v1.0.0"));
    CHECK_FALSE(isVersionConstraint("main"));
    CHECK_FALSE(isVersionConstraint(""));
}
