#pragma once
#include <string>
#include <utility>
#include <vector>
#include "driver/discovery.h"

namespace ldp3::studio {

// Which screen the main area is showing.
enum class Screen { Projects, ProjectDetail, Environments };

// A shared environment: its libraries and the projects that use it.
struct Environment {
    std::string name;
    std::vector<ldp3::driver::Dependency> libs;
    std::vector<std::string> usedBy;
};

// The console pane's state: the output of the last action run on the open project.
struct Console {
    std::string title;                 // e.g. "ldp3 test"
    std::vector<std::string> lines;    // captured output
    enum class Status { Idle, Running, Done } status = Status::Idle;
    int exitCode = 0;
};

// The whole TUI's shared state. Screens read it and the app loop mutates it (only ever on the UI thread).
struct AppState {
    std::vector<ldp3::driver::DiscoveredProject> projects;
    int selectedProject = 0;
    Screen screen = Screen::Projects;
    int selectedAction = 0;  // index into the project-detail action list
    Console console;
    std::vector<Environment> environments;
    int selectedEnv = 0;

    const ldp3::driver::DiscoveredProject* selected() const {
        if (projects.empty()) return nullptr;
        return &projects[static_cast<std::size_t>(selectedProject)];
    }
};

// The actions offered on the project-detail screen, as {label, ldp3 verb}. `run` is interactive; the rest
// stream their output into the console.
inline const std::vector<std::pair<std::string, std::string>>& projectActions() {
    static const std::vector<std::pair<std::string, std::string>> a = {
        {"Run", "run"}, {"Build", "build"}, {"Test", "test"}, {"Doc", "doc"}, {"Fmt", "fmt"}};
    return a;
}

}  // namespace ldp3::studio
