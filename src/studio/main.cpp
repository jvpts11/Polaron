// ldp3-studio: the TUI project/environment manager for the LDP3 toolchain.
//
// Slice 1 -- the app shell: a top bar, a navigation rail, an (empty) main area and a keybar, in the approved
// palette. `--selftest` renders one frame to stdout and exits (for a non-interactive smoke test); otherwise it
// runs the interactive FTXUI loop and quits on 'q'.

#include <ftxui/component/component.hpp>
#include <ftxui/component/event.hpp>
#include <ftxui/component/screen_interactive.hpp>
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>

#include <iostream>
#include <string>

#include "studio/theme.h"

using namespace ftxui;
namespace theme = ldp3::studio::theme;

namespace {

Element topBar() {
    return hbox({
               text(" ▲ ldp3 studio ") | color(theme::amber) | bold,
               text(" Projetos") | color(theme::muted),
               filler(),
               text("14 projetos · 3 environments ") | color(theme::faint),
           }) |
           bgcolor(theme::panel);
}

Element navItem(const std::string& icon, const std::string& label, bool on) {
    Element e = hbox({text(" " + icon + "  "), text(label), filler()});
    if (on) return e | color(theme::ink) | bgcolor(theme::sel) | bold;
    return e | color(theme::muted);
}

Element rail() {
    return vbox({
               text(" GERENCIAR") | color(theme::faint),
               navItem("◈", "Projetos", true),
               navItem("❏", "Environments", false),
               navItem("⬡", "Bibliotecas", false),
               text(""),
               text(" SISTEMA") | color(theme::faint),
               navItem("⚙", "Toolchain", false),
               filler(),
               text(" ldp3c 0.1.0") | color(theme::faint),
           }) |
           size(WIDTH, EQUAL, 22) | bgcolor(theme::panel);
}

Element mainArea() {
    return vbox({
               text(""),
               text("  Bem-vindo ao ldp3 studio") | color(theme::ink) | bold,
               text("  Fatia 1 — o esqueleto está de pé.") | color(theme::muted),
               filler(),
           }) |
           flex | border | color(theme::line);
}

Element keyBar() {
    auto key = [](const std::string& k, const std::string& label) {
        return hbox({text(" " + k + " ") | color(theme::amber) | bold, text(label + "  ") | color(theme::muted)});
    };
    return hbox({
               key("↑↓", "navegar"),
               key("⏎", "abrir"),
               key("n", "novo projeto"),
               key("e", "environments"),
               key("q", "sair"),
           }) |
           bgcolor(theme::panel);
}

Element renderShell() {
    return vbox({
               topBar(),
               hbox({rail(), mainArea() | flex}) | flex,
               keyBar(),
           }) |
           bgcolor(theme::ground) | color(theme::ink);
}

}  // namespace

int main(int argc, char** argv) {
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "--selftest") {  // render one frame and exit, for a smoke test
            Screen screen = Screen::Create(Dimension::Fixed(96), Dimension::Fixed(26));
            Render(screen, renderShell());
            std::cout << screen.ToString();
            return 0;
        }
    }

    ScreenInteractive screen = ScreenInteractive::Fullscreen();
    Component root = Renderer([] { return renderShell(); });
    root |= CatchEvent([&](const Event& e) {
        if (e == Event::Character('q') || e == Event::Escape) {
            screen.Exit();
            return true;
        }
        return false;
    });
    screen.Loop(root);
    return 0;
}
