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
#include <atomic>
#include <cctype>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <system_error>
#include <thread>

#include "driver/discovery.h"
#include "driver/environs.h"
#include "driver/manifest.h"
#include "driver/process.h"
#include "driver/toolchain.h"
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
    const bool libOn = s.screen == studio::Screen::Libraries;
    const bool toolOn = s.screen == studio::Screen::Toolchain;
    return vbox({
               text(" MANAGE") | color(theme::faint),
               navItem("◈", "Projects", !envOn && !libOn && !toolOn),
               navItem("❏", "Environments", envOn),
               navItem("⬡", "Libraries", libOn),
               text(""),
               text(" SYSTEM") | color(theme::faint),
               navItem("⚙", "Toolchain", toolOn),
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
        return hbox({key("↑↓", "action"), key("⏎", "run action"), key("p", "plug lib"), key("esc", "back"),
                     key("q", "quit")});
    }
    if (s.screen == studio::Screen::Environments) {
        return hbox({key("↑↓", "navigate"), key("n", "new env"), key("esc", "back"), key("q", "quit")});
    }
    if (s.screen == studio::Screen::Libraries || s.screen == studio::Screen::Toolchain) {
        return hbox({key("↑↓", "navigate"), key("esc", "back"), key("q", "quit")});
    }
    return hbox({
        key("↑↓", "navigate"),
        key("⏎", "open"),
        key("n", "new"),
        key("s", "scan"),
        key("e", "env"),
        key("l", "libs"),
        key("t", "toolchain"),
        key("q", "quit"),
    });
}

Element renderShell(const AppState& s) {
    Element base = vbox({
                       topBar(s),
                       hbox({rail(s), ldp3::studio::renderContent(s) | flex}) | flex,
                       keyBar(s),
                   }) |
                   color(theme::ink);  // default text colour; no background so we blend with the terminal
    // With no background to occlude the content behind it, a modal is shown centered on an empty screen
    // rather than overlaid -- so nothing bleeds through its (transparent) cells.
    if (s.newProject.open) return ldp3::studio::renderNewProjectModal(s) | center;
    if (s.newEnv.open) return ldp3::studio::renderNewEnvModal(s) | center;
    if (s.newPlug.open) return ldp3::studio::renderPlugModal(s) | center;
    return base;
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
    } else if (mode == "new") {
        ldp3::studio::Environment gamedev;
        gamedev.name = "gamedev";
        s.environments = {gamedev};
        s.newProject.open = true;
        s.newProject.name = "pool_balls_3d";
        s.newProject.envChoice = 1;
    } else if (mode == "scan") {
        s.scanning = true;
        s.scanFound = 42;
    } else if (mode == "newenv") {
        s.screen = studio::Screen::Environments;
        s.newEnv.open = true;
        s.newEnv.name = "gamedev";
    } else if (mode == "lib") {
        s.screen = studio::Screen::Libraries;
        ldp3::studio::Library vec;
        vec.name = "vec_simd";
        vec.versions = {"2.1.0"};
        vec.usedByProjects = {"tic_tac_toe"};
        vec.usedByEnvs = {"gamedev"};
        ldp3::studio::Library json;
        json.name = "json";
        json.versions = {"1.4.0"};
        json.usedByEnvs = {"gamedev", "web"};
        s.libraries = {json, vec};
    } else if (mode == "tool") {
        s.screen = studio::Screen::Toolchain;
        s.toolchain.version = "ldp3 0.1.0-dev";
        s.toolchain.ldp3c = "C:/tools/ldp3/ldp3c.exe";
        s.toolchain.clang = "C:/Program Files/LLVM/bin/clang.exe";
        s.toolchain.runtime = "C:/tools/ldp3/ldp3_rt.lib";
        s.toolchain.home = "C:/Users/jvpts/.ldp3";
        s.toolchain.environments = "C:/Users/jvpts/.ldp3/environments";
        s.toolchain.target = "x86_64-windows";
    } else if (mode == "plug") {
        s.screen = studio::Screen::ProjectDetail;
        s.selectedProject = 3;  // tic_tac_toe
        s.newPlug.open = true;
        s.newPlug.spec = "github.com/ldp3/json";
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
        if (arg == "--selftest-new") return selftest("new");
        if (arg == "--selftest-scan") return selftest("scan");
        if (arg == "--selftest-newenv") return selftest("newenv");
        if (arg == "--selftest-lib") return selftest("lib");
        if (arg == "--selftest-tool") return selftest("tool");
        if (arg == "--selftest-plug") return selftest("plug");
    }

    AppState state;
    std::error_code ec;
    state.projects = ldp3::driver::discoverProjects(std::filesystem::current_path(ec));

    ScreenInteractive screen = ScreenInteractive::Fullscreen();
    // Hide the terminal cursor: the studio has no text-input caret of its own, so FTXUI would otherwise leave
    // a blinking block in the corner. It stays hidden every frame since nothing requests a focus cursor.
    screen.SetCursor(ftxui::Screen::Cursor{0, 0, ftxui::Screen::Cursor::Hidden});
    std::thread worker;
    std::thread scanThread;
    std::atomic<bool> scanStop{false};

    // Start (or stop) a background computer-wide scan that streams found projects into the list.
    auto toggleScan = [&] {
        if (state.scanning) {  // a second press stops it
            scanStop = true;
            return;
        }
        if (scanThread.joinable()) scanThread.join();
        state.scanning = true;
        state.scanFound = static_cast<int>(state.projects.size());
        scanStop = false;
        const std::filesystem::path root = ldp3::driver::ldp3HomeDir().parent_path();  // the user's home
        scanThread = std::thread([&screen, &state, &scanStop, root] {
            ldp3::driver::discoverProjectsStreaming(
                root,
                [&screen, &state](ldp3::driver::DiscoveredProject p) {
                    screen.Post([&state, p] {
                        for (const ldp3::driver::DiscoveredProject& e : state.projects)
                            if (e.dir == p.dir) return;  // already listed
                        state.projects.push_back(p);
                        state.scanFound = static_cast<int>(state.projects.size());
                    });
                },
                [&scanStop] { return scanStop.load(); });
            screen.Post([&state] { state.scanning = false; });
        });
    };

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

    // Plug a library into the selected project: run `ldp3 plug <spec>` on a background thread, stream it into
    // the console, and reload the project's manifest so the new dependency shows.
    auto runPlug = [&](const std::string& spec) {
        const ldp3::driver::DiscoveredProject* p = state.selected();
        if (p == nullptr || state.console.status == Console::Status::Running) return;
        if (worker.joinable()) worker.join();
        const std::filesystem::path dir = p->dir;
        const int idx = state.selectedProject;
        state.console.title = "ldp3 plug " + spec;
        state.console.lines.clear();
        state.console.status = Console::Status::Running;
        worker = std::thread([&screen, &state, spec, dir, idx] {
            const ldp3::studio::ActionResult r = ldp3::studio::runCaptured({"plug", spec}, dir);
            screen.Post([&state, r, idx] {
                state.console.lines = r.lines;
                state.console.exitCode = r.exitCode;
                state.console.status = Console::Status::Done;
                if (idx >= 0 && idx < static_cast<int>(state.projects.size())) {
                    std::ifstream f(state.projects[static_cast<std::size_t>(idx)].dir / "ldp3.toml");
                    if (f) {
                        std::stringstream ss;
                        ss << f.rdbuf();
                        state.projects[static_cast<std::size_t>(idx)].manifest =
                            ldp3::driver::parseManifestText(ss.str());
                    }
                }
            });
        });
    };

    Component root = Renderer([&] { return renderShell(state); });
    root |= CatchEvent([&](const Event& e) {
        // The new-project modal captures all input while it is open.
        if (state.newProject.open) {
            ldp3::studio::NewProject& np = state.newProject;
            if (e == Event::Escape) {
                np.open = false;
                return true;
            }
            if (e == Event::Tab || e == Event::TabReverse) {
                np.field = (np.field + 1) % 2;
                return true;
            }
            if (e == Event::Return) {
                if (np.name.empty()) {
                    np.error = "Name cannot be empty.";
                    return true;
                }
                std::error_code e2;
                const std::filesystem::path cwd = std::filesystem::current_path(e2);
                const std::string env =
                    np.envChoice > 0 ? state.environments[static_cast<std::size_t>(np.envChoice - 1)].name : "";
                if (!ldp3::studio::createProject(np.name, cwd, env)) {
                    np.error = "Could not create the project.";
                    return true;
                }
                const std::string created = np.name;
                np.open = false;
                state.projects = ldp3::driver::discoverProjects(cwd);
                for (int i = 0; i < static_cast<int>(state.projects.size()); ++i)
                    if (state.projects[static_cast<std::size_t>(i)].manifest.name == created) {
                        state.selectedProject = i;
                        break;
                    }
                return true;
            }
            if (np.field == 0) {  // editing the name
                if (e == Event::Backspace) {
                    if (!np.name.empty()) np.name.pop_back();
                    return true;
                }
                if (e.is_character() && e.character().size() == 1) {
                    const char c = e.character()[0];
                    if (std::isalnum(static_cast<unsigned char>(c)) != 0 || c == '_' || c == '-') np.name += c;
                    return true;
                }
            } else {  // choosing the environment
                const int envCount = static_cast<int>(state.environments.size());
                if (e == Event::ArrowLeft || e == Event::Character('h')) {
                    np.envChoice = std::max(0, np.envChoice - 1);
                    return true;
                }
                if (e == Event::ArrowRight || e == Event::Character('l')) {
                    np.envChoice = std::min(envCount, np.envChoice + 1);
                    return true;
                }
            }
            return true;  // swallow anything else while the modal is open
        }
        if (state.newEnv.open) {
            ldp3::studio::NewEnv& ne = state.newEnv;
            if (e == Event::Escape) {
                ne.open = false;
                return true;
            }
            if (e == Event::Return) {
                if (ne.name.empty()) {
                    ne.error = "Name cannot be empty.";
                    return true;
                }
                if (ldp3::driver::envNew(ne.name) != 0) {
                    ne.error = "Could not create the environment.";
                    return true;
                }
                const std::string created = ne.name;
                ne.open = false;
                state.environments = ldp3::studio::loadEnvironments(state.projects);
                for (int i = 0; i < static_cast<int>(state.environments.size()); ++i)
                    if (state.environments[static_cast<std::size_t>(i)].name == created) {
                        state.selectedEnv = i;
                        break;
                    }
                return true;
            }
            if (e == Event::Backspace) {
                if (!ne.name.empty()) ne.name.pop_back();
                return true;
            }
            if (e.is_character() && e.character().size() == 1) {
                const char c = e.character()[0];
                if (std::isalnum(static_cast<unsigned char>(c)) != 0 || c == '_' || c == '-') ne.name += c;
                return true;
            }
            return true;  // swallow anything else while the modal is open
        }
        if (state.newPlug.open) {
            ldp3::studio::NewPlug& np = state.newPlug;
            if (e == Event::Escape) {
                np.open = false;
                return true;
            }
            if (e == Event::Return) {
                if (np.spec.empty()) {
                    np.error = "Enter a library source.";
                    return true;
                }
                const std::string spec = np.spec;
                np.open = false;
                runPlug(spec);
                return true;
            }
            if (e == Event::Backspace) {
                if (!np.spec.empty()) np.spec.pop_back();
                return true;
            }
            if (e.is_character() && e.character().size() == 1) {
                const char c = e.character()[0];
                // Names, git URLs and url@version specs use these characters.
                if (std::isalnum(static_cast<unsigned char>(c)) != 0 || c == '_' || c == '-' || c == '.' ||
                    c == '/' || c == ':' || c == '@' || c == '~')
                    np.spec += c;
                return true;
            }
            return true;  // swallow anything else while the modal is open
        }
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
        if (e == Event::Character('l')) {  // jump to the Libraries inventory from anywhere
            state.environments = ldp3::studio::loadEnvironments(state.projects);
            state.libraries = ldp3::studio::loadLibraries(state.projects, state.environments);
            state.screen = studio::Screen::Libraries;
            state.selectedLib = 0;
            return true;
        }
        if (e == Event::Character('t')) {  // jump to the Toolchain screen from anywhere
            state.toolchain = ldp3::studio::loadToolchainInfo();
            state.screen = studio::Screen::Toolchain;
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
            if (e == Event::Character('n')) {  // open the new-project modal
                state.newProject = ldp3::studio::NewProject{};
                state.newProject.open = true;
                state.environments = ldp3::studio::loadEnvironments(state.projects);
                return true;
            }
            if (e == Event::Character('s')) {  // start/stop the background computer-wide scan
                toggleScan();
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
            if (e == Event::Character('n')) {  // open the new-environment modal
                state.newEnv = ldp3::studio::NewEnv{};
                state.newEnv.open = true;
                return true;
            }
            if (e == Event::Escape) {
                state.screen = studio::Screen::Projects;
                return true;
            }
            return false;
        }
        if (state.screen == studio::Screen::Libraries) {
            const int last = static_cast<int>(state.libraries.size()) - 1;
            if (e == Event::ArrowUp || e == Event::Character('k')) {
                state.selectedLib = std::max(0, state.selectedLib - 1);
                return true;
            }
            if (e == Event::ArrowDown || e == Event::Character('j')) {
                state.selectedLib = std::min(std::max(0, last), state.selectedLib + 1);
                return true;
            }
            if (e == Event::Escape) {
                state.screen = studio::Screen::Projects;
                return true;
            }
            return false;
        }
        if (state.screen == studio::Screen::Toolchain) {
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
        if (e == Event::Character('p')) {  // plug a library into this project
            state.newPlug = ldp3::studio::NewPlug{};
            state.newPlug.open = true;
            return true;
        }
        if (e == Event::Escape) {
            state.screen = studio::Screen::Projects;
            return true;
        }
        return false;
    });

    screen.Loop(root);
    scanStop = true;  // stop the scan thread if it is still running
    if (worker.joinable()) worker.join();
    if (scanThread.joinable()) scanThread.join();
    return 0;
}
