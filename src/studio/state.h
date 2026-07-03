#pragma once
#include <vector>
#include "driver/discovery.h"

namespace ldp3::studio {

// Which section the navigation rail has active.
enum class Section { Projects, Environments, Libraries, Toolchain };

// The whole TUI's shared state. Screens read it and the app loop mutates it.
struct AppState {
    std::vector<ldp3::driver::DiscoveredProject> projects;
    int selectedProject = 0;
    Section section = Section::Projects;

    const ldp3::driver::DiscoveredProject* selected() const {
        if (projects.empty()) return nullptr;
        return &projects[static_cast<std::size_t>(selectedProject)];
    }
};

}  // namespace ldp3::studio
