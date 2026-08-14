#include <doctest/doctest.h>
#include <filesystem>
#include <fstream>
#include <sstream>
#include "driver/manifest.h"

using namespace polaron::driver;

namespace {
std::filesystem::path writeTemp(const std::string& content) {
    const auto p = std::filesystem::temp_directory_path() / "polaron_test_manifest.toml";
    std::ofstream f(p, std::ios::binary);
    f << content;
    return p;
}
Manifest reparse(const std::filesystem::path& p) {
    std::ifstream in(p);
    std::stringstream ss;
    ss << in.rdbuf();
    return parseManifestText(ss.str());
}
}  // namespace

TEST_CASE("parseManifestText reads program fields") {
    const std::string toml =
        "[polaron_project]\n"
        "[program]\n"
        "name = \"demo\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.pol\"\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "demo");
    CHECK(m.version == "0.1.0");
    CHECK(m.entry == "src/main.pol");
    CHECK(m.outputDir == "build-output/");
    CHECK(m.target == "x86_64-windows");
    CHECK(m.freestanding == false);
    CHECK(m.hasDependencies == false);
}

TEST_CASE("parseManifestText ignores comments and detects dependencies") {
    const std::string toml =
        "[polaron_project]\n"
        "[program]\n"
        "name = \"x\"  # trailing comment\n"
        "entry = \"main.pol\"\n"
        "[dependencies]\n"
        "audio = \"1.0.0\"\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "x");
    CHECK(m.entry == "main.pol");
    CHECK(m.hasDependencies == true);
}

TEST_CASE("parseManifestText reads native_libs as a comma-separated list") {
    const std::string toml =
        "[polaron_project]\n"
        "[program]\n"
        "name = \"gl\"\n"
        "entry = \"src/main.pol\"\n"
        "[build]\n"
        "native_libs = \"opengl32, user32 , gdi32\"\n";  // spaces around entries are trimmed
    Manifest m = parseManifestText(toml);
    REQUIRE(m.nativeLibs.size() == 3);
    CHECK(m.nativeLibs[0] == "opengl32");
    CHECK(m.nativeLibs[1] == "user32");
    CHECK(m.nativeLibs[2] == "gdi32");
}

TEST_CASE("parseManifestText leaves native_libs empty when absent") {
    Manifest m = parseManifestText("[polaron_project]\n[program]\nentry = \"m.pol\"\n");
    CHECK(m.nativeLibs.empty());
}

TEST_CASE("parseManifestText reads [libraries] in both spellings") {
    const std::string toml =
        "[polaron_project]\n"
        "[program]\n"
        "entry = \"src/main.pol\"\n"
        "[libraries]\n"
        "SDL2 = { windows = \"SDL2\", linux = \"SDL2-2.0\" }  # per platform\n"
        "Zlib = \"z\"\n"
        "[libraries.Curl]\n"
        "windows = \"libcurl\"\n"
        "linux = \"curl\"\n";
    Manifest m = parseManifestText(toml);
    REQUIRE(m.foreignLibraries.size() == 3);
    CHECK(m.foreignLibraries["SDL2"]["linux"] == "SDL2-2.0");
    CHECK(m.foreignLibraries["Zlib"]["*"] == "z");
    CHECK(m.foreignLibraries["Curl"]["windows"] == "libcurl");
}

TEST_CASE("resolveForeignLibrary maps a logical name to the platform's file") {
    const std::string toml =
        "[polaron_project]\n"
        "[libraries]\n"
        "SDL2 = { windows = \"SDL2\", linux = \"SDL2-2.0\" }\n"
        "Zlib = \"z\"\n"
        "Gl = { linux = \"GL\" }\n"
        "Builtin = \"\"\n";
    Manifest m = parseManifestText(toml);
    CHECK(resolveForeignLibrary(m, "SDL2", "windows") == std::optional<std::string>("SDL2"));
    CHECK(resolveForeignLibrary(m, "SDL2", "linux") == std::optional<std::string>("SDL2-2.0"));
    CHECK(resolveForeignLibrary(m, "Zlib", "windows") == std::optional<std::string>("z"));
    // Mapped, but not for this platform: answering with the logical name would link something the
    // manifest never sanctioned, so the answer is nothing and the linker gets to name the symbol.
    CHECK_FALSE(resolveForeignLibrary(m, "Gl", "windows").has_value());
    // Mapped to nothing on purpose: "this one needs no flag here".
    CHECK_FALSE(resolveForeignLibrary(m, "Builtin", "linux").has_value());
    // Unmapped resolves to itself -- a library spelled the same everywhere needs no entry at all.
    CHECK(resolveForeignLibrary(m, "opengl32", "windows") == std::optional<std::string>("opengl32"));
    // ... except `C`, which every platform links already and no platform spells the same way.
    CHECK_FALSE(resolveForeignLibrary(m, "C", "windows").has_value());
    CHECK_FALSE(resolveForeignLibrary(m, "C", "linux").has_value());
}

TEST_CASE("platformOfTriple reads the platform off a target triple") {
    CHECK(platformOfTriple("x86_64-pc-windows-msvc") == "windows");
    CHECK(platformOfTriple("x86_64-unknown-linux-gnu") == "linux");
    CHECK(platformOfTriple("aarch64-apple-darwin") == "macos");
    CHECK(platformOfTriple("riscv64-unknown-elf") == "linux");  // ELF default
}

TEST_CASE("ephemeralManifest uses the file stem and its path") {
    Manifest m = ephemeralManifest("samples/hello_world.pol");
    CHECK(m.name == "hello_world");
    CHECK(m.entry == "samples/hello_world.pol");
    CHECK(m.version == "0.0.0");
    CHECK(m.hasDependencies == false);
}

TEST_CASE("parseManifestText reads the environment field and the dependency list") {
    const std::string toml =
        "[program]\nname = \"x\"\nentry = \"m.pol\"\n"
        "[build]\nenvironment = \"gamedev\"\n"
        "[dependencies]\naudio = \"1.2.0\"\nmath = \"2.0.0\"\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.environment == "gamedev");
    REQUIRE(m.dependencies.size() == 2);
    CHECK(m.dependencies[0].name == "audio");
    CHECK(m.dependencies[0].version == "1.2.0");
    CHECK(m.dependencies[1].name == "math");
}

TEST_CASE("addDependency inserts into an existing section and updates in place") {
    const auto p = writeTemp(
        "[polaron_project]\n\n[program]\nname = \"x\"\n\n[dependencies]\n\n[build]\noutput = \"o/\"\n");
    CHECK(addDependency(p, "audio", "1.0.0"));
    Manifest m1 = reparse(p);
    REQUIRE(m1.dependencies.size() == 1);
    CHECK(m1.dependencies[0].name == "audio");
    CHECK(m1.dependencies[0].version == "1.0.0");
    CHECK(m1.outputDir == "o/");  // the [build] section is preserved

    CHECK(addDependency(p, "audio", "2.0.0"));  // same name updates, not duplicates
    Manifest m2 = reparse(p);
    REQUIRE(m2.dependencies.size() == 1);
    CHECK(m2.dependencies[0].version == "2.0.0");
    std::filesystem::remove(p);
}

TEST_CASE("addDependency creates a section when absent and removeDependency drops the entry") {
    const auto p = writeTemp("[program]\nname = \"x\"\n");
    CHECK(addDependency(p, "net", "3.1.0"));
    Manifest m1 = reparse(p);
    REQUIRE(m1.dependencies.size() == 1);
    CHECK(m1.dependencies[0].name == "net");

    CHECK(removeDependency(p, "net"));
    Manifest m2 = reparse(p);
    CHECK(m2.dependencies.empty());
    std::filesystem::remove(p);
}
