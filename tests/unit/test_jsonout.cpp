#include <doctest/doctest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>

#include "driver/jsonout.h"

using namespace ldp3::driver;
namespace fs = std::filesystem;

namespace {
// Set (or, with an empty value, clear) an environment variable, portably.
void setEnv(const char* name, const char* value) {
#ifdef _WIN32
    _putenv_s(name, value);
#else
    if (value != nullptr && *value != '\0')
        setenv(name, value, 1);
    else
        unsetenv(name);
#endif
}
}  // namespace

TEST_CASE("studioJson emits projects, environments and libraries") {
    const fs::path root = fs::temp_directory_path() / "ldp3_json_test";
    fs::remove_all(root);
    fs::create_directories(root / "app");
    std::ofstream(root / "app" / "ldp3.toml")
        << "[ldp3_project]\n[program]\nname = \"app\"\nentry = \"src/main.ldp3\"\n";

    // Isolate environments to an empty home so the output is deterministic.
    const fs::path home = root / "home";
    fs::create_directories(home);
    setEnv("LDP3_HOME", home.string().c_str());

    const std::string json = studioJson(root);
    CHECK(json.find("\"projects\":[") != std::string::npos);
    CHECK(json.find("\"environments\":[]") != std::string::npos);
    CHECK(json.find("\"libraries\":[]") != std::string::npos);
    CHECK(json.find("\"name\":\"app\"") != std::string::npos);
    CHECK(json.find("\"entry\":\"src/main.ldp3\"") != std::string::npos);

    setEnv("LDP3_HOME", "");
    fs::remove_all(root);
}
