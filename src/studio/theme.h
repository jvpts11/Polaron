#pragma once
#include <ftxui/screen/color.hpp>

// The approved LDP3 Studio palette (see docs/superpowers/specs/2026-07-04-ldp3-studio-tui-design.md).
// Single dark theme by deliberate choice -- it is a terminal.
namespace ldp3::studio::theme {

using ftxui::Color;

inline const Color ground = Color::RGB(0x0d, 0x14, 0x17);  // page ground
inline const Color panel = Color::RGB(0x10, 0x1c, 0x1f);   // panels / bars
inline const Color sel = Color::RGB(0x17, 0x28, 0x2b);     // selected row background
inline const Color line = Color::RGB(0x23, 0x38, 0x3c);    // borders
inline const Color ink = Color::RGB(0xe4, 0xec, 0xe9);     // primary text
inline const Color muted = Color::RGB(0x86, 0xa0, 0x9b);   // secondary text
inline const Color faint = Color::RGB(0x58, 0x72, 0x6e);   // labels / hints
inline const Color amber = Color::RGB(0xea, 0xb4, 0x64);   // brand / selection
inline const Color teal = Color::RGB(0x58, 0xc8, 0xbf);    // secondary accent
inline const Color green = Color::RGB(0x93, 0xc9, 0x7e);   // pass
inline const Color red = Color::RGB(0xe5, 0x7f, 0x70);     // fail
inline const Color violet = Color::RGB(0xb7, 0x9a, 0xe0);  // environment

}  // namespace ldp3::studio::theme
