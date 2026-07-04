// ldp3-studio: the TUI project/environment manager for the LDP3 toolchain.
//
// Slices 1-3 -- the app shell (top bar, navigation rail, keybar) around two screens: the Projects list
// (discovered under the current directory, navigable with the arrows or j/k) and, on Enter, a project's
// detail. The detail screen offers Build/Test/Doc/Fmt -- run on a background thread with their output
// streamed into a console pane -- and Run, which suspends the TUI, runs the program inline, and resumes.
// `--selftest[-detail]` renders one frame of a fixed demo state to stdout for non-interactive smoke tests.

#include <ftxui/component/component.hpp>
#include <ftxui/component/event.hpp>
#include <ftxui/component/screen_interactive.hpp>
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>

#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>
#include <system_error>
#include <thread>

#include "driver/discovery.h"
#include "driver/process.h"
#include "studio/engine.h"
#include "studio/screens.h"
#include "studio/state.h"
#include "studio/theme.h"

using namespace ftxui;
namespace theme = ldp3::studio::theme;
namespace studio = ldp3::studio;
using ldp3::studio::AppState;
using ldp3::studio::Console;
// Note: the studio's own Screen enum is referred to as studio::Screen -- ftxui::Screen is a different type.

namespace {

Element topBar(const AppState& s) {
    Element crumb;
    if (s.screen == studio::Screen::ProjectDetail && s.selected() != nullptr) {
        crumb = hbox({text(" Projects › ") | color(theme::faint),
                      text(s.selected()->manifest.name) | color(theme::ink)});
    } else {
        crumb = text(" Projects") | color(theme::muted);
    }
    const std::string count = std::to_string(s.projects.size()) + " projects";
    return hbox({
               text(" ▲ ldp3 studio ") | color(theme::amber) | bold,
               crumb,
               filler(),
               text(count + " ") | color(theme::faint),
           });
}

Element navItem(const std::string& icon, const std::string& label, bool on) {
    Element e = hbox({text(" " + icon + "  "), text(label), filler()});
    if (on) return e | color(theme::amber) | bold;
    return e | color(theme::muted);
}

Element rail(const AppState& s) {
    const bool envOn = s.screen == studio::Screen::Environments;
    return vbox({
               text(" MANAGE") | color(theme::faint),
               navItem("◈", "Projects", !envOn),
               navItem("❏", "Environments", envOn),
               navItem("⬡", "Libraries", false),
               text(""),
               text(" SYSTEM") | color(theme::faint),
               navItem("⚙", "Toolchain", false),
               filler(),
               text(" ldp3c 0.1.0") | color(theme::faint),
           }) |
           size(WIDTH, EQUAL, 22);
}

Element keyBar(const AppState& s) {
    auto key = [](const std::string& k, const std::string& label) {
        return hbox({text(" " + k + " ") | color(theme::amber) | bold, text(label + "  ") | color(theme::muted)});
    };
    if (s.screen == studio::Screen::ProjectDetail) {
        return hbox({key("↑↓", "action"), key("⏎", "run action"), key("esc", "back"), key("q", "quit")});
    }
    if (s.screen == studio::Screen::Environments) {
        return hbox({key("↑↓", "navigate"), key("n", "new env"), key("esc", "back"), key("q", "quit")});
    }
    return hbox({
        key("↑↓", "navigate"),
        key("⏎", "open"),
        key("n", "new project"),
        key("s", "scan"),
        key("e", "environments"),
        key("q", "quit"),
    });
}

Element renderShell(const AppState& s) {
    return vbox({
               topBar(s),
               hbox({rail(s), ldp3::studio::renderContent(s) | flex}) | flex,
               keyBar(s),
           }) |
           color(theme::ink);  // default text colour; no background so we blend with the terminal
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

int selftest(const std::string& mode) {
    AppState s = demoState();
    if (mode == "detail") {
        s.screen = studio::Screen::ProjectDetail;
        s.selectedProject = 3;  // tic_tac_toe
        s.console.title = "ldp3 test";
        s.console.status = Console::Status::Done;
        s.console.exitCode = 0;
        s.console.lines = {"PASS board_places_mark", "PASS detects_row_win", "PASS full_board_is_draw",
                           "tests: 7 passed, 0 failed"};
    } else if (mode == "env") {
        s.screen = studio::Screen::Environments;
        ldp3::studio::Environment gamedev;
        gamedev.name = "gamedev";
        gamedev.libs = {{"vec_simd", "2.1.0"}, {"json", "1.4.0"}, {"raylib_ldp3", "^5.0.0"}};
        gamedev.usedBy = {"tic_tac_toe", "raytracer"};
        ldp3::studio::Environment web;
        web.name = "web";
        web.libs = {{"http", "1.0.0"}};
        web.usedBy = {"http_server"};
        s.environments = {gamedev, web};
    }
    ftxui::Screen screen = ftxui::Screen::Create(Dimension::Fixed(96), Dimension::Fixed(26));
    Render(screen, renderShell(s));
    std::cout << screen.ToString();
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        if (arg == "--selftest") return selftest("projects");
        if (arg == "--selftest-detail") return selftest("detail");
        if (arg == "--selftest-env") return selftest("env");
    }

    AppState state;
    std::error_code ec;
    state.projects = ldp3::driver::discoverProjects(std::filesystem::current_path(ec));

    ScreenInteractive screen = ScreenInteractive::Fullscreen();
    std::thread worker;

    // Run the given verb on the selected project. `run` is interactive (suspend the TUI); the others stream
    // their captured output into the console on a background thread.
    auto runVerb = [&](const std::string& verb) {
        const ldp3::driver::DiscoveredProject* p = state.selected();
        if (p == nullptr) return;
        const std::filesystem::path dir = p->dir;
        if (verb == "run") {
            screen.WithRestoredIO([dir] {
                std::error_code e;
                const std::filesystem::path prev = std::filesystem::current_path(e);
                std::filesystem::current_path(dir, e);
                ldp3::driver::runProcess(ldp3::studio::ldp3Cli().string(), {"run"});
                std::cout << "\n[Enter] back to ldp3 studio ";
                std::string dummy;
                std::getline(std::cin, dummy);
                std::filesystem::current_path(prev, e);
            })();
            return;
        }
        if (state.console.status == Console::Status::Running) return;
        if (worker.joinable()) worker.join();  // the previous action has finished
        state.console.title = "ldp3 " + verb;
        state.console.lines.clear();
        state.console.status = Console::Status::Running;
        worker = std::thread([&screen, &state, verb, dir] {
            const ldp3::studio::ActionResult r = ldp3::studio::runCaptured(verb, dir);
            screen.Post([&state, r] {
                state.console.lines = r.lines;
                state.console.exitCode = r.exitCode;
                state.console.status = Console::Status::Done;
            });
        });
    };

    Component root = Renderer([&] { return renderShell(state); });
    root |= CatchEvent([&](const Event& e) {
        if (e == Event::Character('q')) {
            screen.Exit();
            return true;
        }
        if (e == Event::Character('e')) {  // jump to the Environments screen from anywhere
            state.environments = ldp3::studio::loadEnvironments(state.projects);
            state.screen = studio::Screen::Environments;
            state.selectedEnv = 0;
            return true;
        }
        if (state.screen == studio::Screen::Projects) {
            const int last = static_cast<int>(state.projects.size()) - 1;
            if (e == Event::ArrowUp || e == Event::Character('k')) {
                state.selectedProject = std::max(0, state.selectedProject - 1);
                return true;
            }
            if (e == Event::ArrowDown || e == Event::Character('j')) {
                state.selectedProject = std::min(std::max(0, last), state.selectedProject + 1);
                return true;
            }
            if (e == Event::Return && state.selected() != nullptr) {
                state.screen = studio::Screen::ProjectDetail;
                state.selectedAction = 0;
                state.console = Console{};
                return true;
            }
            return false;
        }
        if (state.screen == studio::Screen::Environments) {
            const int last = static_cast<int>(state.environments.size()) - 1;
            if (e == Event::ArrowUp || e == Event::Character('k')) {
                state.selectedEnv = std::max(0, state.selectedEnv - 1);
                return true;
            }
            if (e == Event::ArrowDown || e == Event::Character('j')) {
                state.selectedEnv = std::min(std::max(0, last), state.selectedEnv + 1);
                return true;
            }
            if (e == Event::Escape) {
                state.screen = studio::Screen::Projects;
                return true;
            }
            return false;
        }
        // Project detail.
        const int lastAction = static_cast<int>(ldp3::studio::projectActions().size()) - 1;
        if (e == Event::ArrowUp || e == Event::Character('k')) {
            state.selectedAction = std::max(0, state.selectedAction - 1);
            return true;
        }
        if (e == Event::ArrowDown || e == Event::Character('j')) {
            state.selectedAction = std::min(lastAction, state.selectedAction + 1);
            return true;
        }
        if (e == Event::Return) {
            runVerb(ldp3::studio::projectActions()[static_cast<std::size_t>(state.selectedAction)].second);
            return true;
        }
        if (e == Event::Escape) {
            state.screen = studio::Screen::Projects;
            return true;
        }
        return false;
    });

    screen.Loop(root);
    if (worker.joinable()) worker.join();
    return 0;
}
