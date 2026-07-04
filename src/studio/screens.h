#pragma once
#include <ftxui/dom/elements.hpp>
#include "studio/state.h"

namespace ldp3::studio {

// Render the active screen's main-area content: the Projects list, or the open project's detail (actions +
// dependencies + console).
ftxui::Element renderContent(const AppState& state);

// Render the new-project modal (name + environment), to be overlaid on the dimmed screen.
ftxui::Element renderNewProjectModal(const AppState& state);

}  // namespace ldp3::studio
