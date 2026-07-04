#include <doctest/doctest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>

#include "driver/jsonout.h"

using namespace ldp3::driver;
namespace fs = std::filesystem;

TEST_CASE("studioJson emits projects, environments and libraries") {
    const fs::path root = fs::temp_directory_path() / "ldp3_json_test";
    fs::remove_all(root);
    fs::create_directories(root / "app");
    std::ofstream(root / "app" / "ldp3.toml")
        << "[ldp3_project]\n[program]\nname = \"app\"\nentry = \"src/main.ldp3\"\n";

    // Isolate environments to an empty home so the output is deterministic.
    const fs::path home = root / "home";
    fs::create_directories(home);
    _putenv_s("LDP3_HOME", home.string().c_str());

    const std::string json = studioJson(root);
    CHECK(json.find("\"projects\":[") != std::string::npos);
    CHECK(json.find("\"environments\":[]") != std::string::npos);
    CHECK(json.find("\"libraries\":[]") != std::string::npos);
    CHECK(json.find("\"name\":\"app\"") != std::string::npos);
    CHECK(json.find("\"entry\":\"src/main.ldp3\"") != std::string::npos);

    _putenv_s("LDP3_HOME", "");
    fs::remove_all(root);
}
