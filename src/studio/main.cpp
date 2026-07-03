// ldp3-studio: the TUI project/environment manager for the LDP3 toolchain.
//
// Slices 1-2 -- the app shell (top bar, navigation rail, keybar) around the Projects screen: on launch it
// discovers the LDP3 projects under the current directory and lists them, navigable with the arrow keys or
// j/k; the detail pane follows the selection. `--selftest` renders one frame of a fixed demo state to stdout
// (for a non-interactive smoke test); otherwise it runs the interactive FTXUI loop and quits on q.

#include <ftxui/component/component.hpp>
#include <ftxui/component/event.hpp>
#include <ftxui/component/screen_interactive.hpp>
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>

#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>

#include "driver/discovery.h"
#include "studio/screens.h"
#include "studio/state.h"
#include "studio/theme.h"

using namespace ftxui;
namespace theme = ldp3::studio::theme;
using ldp3::studio::AppState;

namespace {

Element topBar(const AppState& s) {
    const std::string count = std::to_string(s.projects.size()) + " projetos";
    return hbox({
               text(" ▲ ldp3 studio ") | color(theme::amber) | bold,
               text(" Projetos") | color(theme::muted),
               filler(),
               text(count + " ") | color(theme::faint),
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

Element keyBar() {
    auto key = [](const std::string& k, const std::string& label) {
        return hbox({text(" " + k + " ") | color(theme::amber) | bold, text(label + "  ") | color(theme::muted)});
    };
    return hbox({
               key("↑↓", "navegar"),
               key("⏎", "abrir"),
               key("n", "novo projeto"),
               key("s", "escanear"),
               key("e", "environments"),
               key("q", "sair"),
           }) |
           bgcolor(theme::panel);
}

Element renderShell(const AppState& s) {
    return vbox({
               topBar(s),
               hbox({rail(), ldp3::studio::renderProjects(s) | flex}) | flex,
               keyBar(),
           }) |
           bgcolor(theme::ground) | color(theme::ink);
}

// A fixed, deterministic state so `--selftest` renders a stable frame regardless of the working directory.
AppState demoState() {
    using ldp3::driver::DiscoveredProject;
    using ldp3::driver::Manifest;
    auto mk = [](const std::string& name, const std::string& dir, const std::string& env,
                 const std::string& ver) {
        Manifest m;
        m.name = name;
        m.version = ver;
        m.environment = env;
        m.entry = "src/main.ldp3";
        m.languageVersion = "1.0";
        m.target = "x86_64-windows";
        return DiscoveredProject{dir, m};
    };
    AppState s;
    s.projects = {
        mk("cipher_kit", "~/code/systems/cipher_kit", "", "0.3.2"),
        mk("http_server", "~/code/web/http_server", "web", "1.2.0"),
        mk("shapes", "~/code/demos/shapes", "", "0.1.0"),
        mk("tic_tac_toe", "~/code/games/tic_tac_toe", "gamedev", "0.2.0"),
    };
    return s;
}

}  // namespace

int main(int argc, char** argv) {
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "--selftest") {
            const AppState s = demoState();
            Screen screen = Screen::Create(Dimension::Fixed(96), Dimension::Fixed(26));
            Render(screen, renderShell(s));
            std::cout << screen.ToString();
            return 0;
        }
    }

    AppState state;
    std::error_code ec;
    state.projects = ldp3::driver::discoverProjects(std::filesystem::current_path(ec));

    ScreenInteractive screen = ScreenInteractive::Fullscreen();
    Component root = Renderer([&] { return renderShell(state); });
    root |= CatchEvent([&](const Event& e) {
        const int last = static_cast<int>(state.projects.size()) - 1;
        if (e == Event::ArrowUp || e == Event::Character('k')) {
            state.selectedProject = std::max(0, state.selectedProject - 1);
            return true;
        }
        if (e == Event::ArrowDown || e == Event::Character('j')) {
            state.selectedProject = std::min(std::max(0, last), state.selectedProject + 1);
            return true;
        }
        if (e == Event::Character('q') || e == Event::Escape) {
            screen.Exit();
            return true;
        }
        return false;
    });
    screen.Loop(root);
    return 0;
}
