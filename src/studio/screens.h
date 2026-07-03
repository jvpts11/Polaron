#pragma once
#include <ftxui/dom/elements.hpp>
#include "studio/state.h"

namespace ldp3::studio {

// The Projects screen: the discovered-project list (with the selected row highlighted) beside a detail pane
// for the selected project.
ftxui::Element renderProjects(const AppState& state);

}  // namespace ldp3::studio
