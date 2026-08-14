#pragma once
#include <string>
#include <utility>
#include <vector>
#include "driver/discovery.h"

namespace polaron::studio {

// Which screen the main area is showing.
enum class Screen { Projects, ProjectDetail, Environments, Libraries, Toolchain };

// The resolved toolchain: tool paths, directories and the default build target.
struct ToolchainInfo {
    std::string version;
    std::string polc;
    std::string clang;
    std::string runtime;
    std::string home;
    std::string environments;
    std::string target;
};

// A shared environment: its libraries and the projects that use it.
struct Environment {
    std::string name;
    std::vector<polaron::driver::Dependency> libs;
    std::vector<std::string> usedBy;
};

// A library seen on the machine: the distinct versions referenced and where (projects and environments).
struct Library {
    std::string name;
    std::vector<std::string> versions;
    std::vector<std::string> usedByProjects;
    std::vector<std::string> usedByEnvs;
};

// The new-project modal's state.
struct NewProject {
    bool open = false;
    std::string name;
    int field = 0;      // 0 = name, 1 = environment
    int envChoice = 0;  // 0 = none; otherwise environments[envChoice - 1]
    std::string error;  // shown when creation fails
};

// The new-environment modal's state (name only).
struct NewEnv {
    bool open = false;
    std::string name;
    std::string error;
};

// The plug-library modal's state (a source/name to plug into the open project).
struct NewPlug {
    bool open = false;
    std::string spec;
    std::string error;
};

// The console pane's state: the output of the last action run on the open project.
struct Console {
    std::string title;                 // e.g. "polaron test"
    std::vector<std::string> lines;    // captured output
    enum class Status { Idle, Running, Done } status = Status::Idle;
    int exitCode = 0;
};

// The whole TUI's shared state. Screens read it and the app loop mutates it (only ever on the UI thread).
struct AppState {
    std::vector<polaron::driver::DiscoveredProject> projects;
    int selectedProject = 0;
    Screen screen = Screen::Projects;
    int selectedAction = 0;  // index into the project-detail action list
    Console console;
    std::vector<Environment> environments;
    int selectedEnv = 0;
    std::vector<Library> libraries;
    int selectedLib = 0;
    ToolchainInfo toolchain;
    NewProject newProject;
    NewEnv newEnv;
    NewPlug newPlug;
    bool scanning = false;   // a background computer-wide scan is running
    int scanFound = 0;       // projects known so far while scanning

    const polaron::driver::DiscoveredProject* selected() const {
        if (projects.empty()) {
            return nullptr;
        }
        return &projects[static_cast<std::size_t>(selectedProject)];
    }
};

// The actions offered on the project-detail screen, as {label, polaron verb}. `run` is interactive; the rest
// stream their output into the console.
inline const std::vector<std::pair<std::string, std::string>>& projectActions() {
    static const std::vector<std::pair<std::string, std::string>> a = {
        {"Run", "run"}, {"Build", "build"}, {"Test", "test"}, {"Doc", "doc"}, {"Fmt", "fmt"}};
    return a;
}

}  // namespace polaron::studio
