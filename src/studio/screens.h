#pragma once
#include <ftxui/dom/elements.hpp>
#include "studio/state.h"

namespace polaron::studio {

// Render the active screen's main-area content: the Projects list, or the open project's detail (actions +
// dependencies + console).
ftxui::Element renderContent(const AppState& state);

// Render the new-project modal (name + environment), shown centered on an empty screen.
ftxui::Element renderNewProjectModal(const AppState& state);

// Render the new-environment modal (name only), shown centered on an empty screen.
ftxui::Element renderNewEnvModal(const AppState& state);

// Render the plug-library modal (a source to plug into the open project), centered on an empty screen.
ftxui::Element renderPlugModal(const AppState& state);

}  // namespace polaron::studio
