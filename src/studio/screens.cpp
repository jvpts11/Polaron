#include "studio/screens.h"

#include <cstddef>
#include <string>
#include <utility>

#include "studio/theme.h"

using namespace ftxui;

namespace ldp3::studio {
namespace {

// A small colored label (environment badge / status). No background -- the TUI blends with the terminal.
Element chip(const std::string& s, Color fg) {
    return text(" " + s) | color(fg);
}

Element projectRow(const ldp3::driver::DiscoveredProject& p, bool sel) {
    const ldp3::driver::Manifest& m = p.manifest;
    const bool hasEnv = !m.environment.empty();
    Element name = text((sel ? " ▸ " : "   ") + m.name);
    name = sel ? (name | color(theme::amber) | bold) : (name | color(theme::ink));
    Element row = hbox({
        name,
        filler(),
        chip(hasEnv ? m.environment : "local", hasEnv ? theme::violet : theme::faint),
        text("  v" + m.version + " ") | color(theme::muted),
    });
    return row;
}

Element kv(const std::string& k, Element v) {
    return hbox({text(" " + k) | color(theme::faint) | size(WIDTH, EQUAL, 15), std::move(v)});
}

Element detailFacts(const ldp3::driver::DiscoveredProject& p) {
    const ldp3::driver::Manifest& m = p.manifest;
    const std::string lang = m.languageVersion.empty() ? "—" : m.languageVersion;
    return vbox({
        text(" " + m.name) | color(theme::amber) | bold,
        text(" " + p.dir.string()) | color(theme::faint),
        separator() | color(theme::line),
        kv("entry", text(m.entry) | color(theme::ink)),
        kv("version", text(m.version + "  · lang " + lang) | color(theme::ink)),
        m.environment.empty() ? kv("environment", text("—") | color(theme::muted))
                              : kv("environment", text(m.environment) | color(theme::violet)),
        kv("deps", text(std::to_string(m.dependencies.size())) | color(theme::ink)),
        kv("target", text(m.target) | color(theme::muted)),
        filler(),
    });
}

Element renderProjects(const AppState& s) {
    Elements rows;
    if (s.projects.empty()) {
        rows.push_back(text("  No LDP3 projects in this folder.") | color(theme::muted));
        rows.push_back(text("  Press s to scan the computer.") | color(theme::faint));
    }
    for (int i = 0; i < static_cast<int>(s.projects.size()); ++i)
        rows.push_back(projectRow(s.projects[static_cast<std::size_t>(i)], i == s.selectedProject));

    Element headerRight = s.scanning
                              ? text("⟳ scanning… " + std::to_string(s.scanFound) + " ") | color(theme::teal)
                              : text("/ search ") | color(theme::faint);
    Element list = vbox({
                       hbox({text(" ALL PROJECTS") | color(theme::faint), filler(), std::move(headerRight)}),
                       separator() | color(theme::line),
                       vbox(std::move(rows)) | flex,
                   }) |
                   borderStyled(ROUNDED, theme::amber);

    Element right = s.selected() ? detailFacts(*s.selected()) : Element{filler()};
    Element detail = vbox({
                         hbox({text(" DETAIL") | color(theme::faint), filler()}),
                         separator() | color(theme::line),
                         std::move(right) | flex,
                     }) |
                     borderStyled(ROUNDED, theme::line);

    return hbox({list | flex, std::move(detail) | size(WIDTH, EQUAL, 42)});
}

// Colour a console line by what it reports.
Element consoleLine(const std::string& l) {
    if (l.rfind(" PASS", 0) == 0) return text(l) | color(theme::green);
    if (l.rfind(" FAIL", 0) == 0) return text(l) | color(theme::red);
    if (l.find("passed,") != std::string::npos) return text(l) | color(theme::amber);
    if (l.find("error") != std::string::npos || l.find("failed") != std::string::npos)
        return text(l) | color(theme::red);
    if (l.find("wrote ") != std::string::npos || l.find("built ") != std::string::npos)
        return text(l) | color(theme::teal);
    return text(l) | color(theme::muted);
}

Element renderProjectDetail(const AppState& s) {
    const ldp3::driver::DiscoveredProject* p = s.selected();
    if (p == nullptr) return text("  No project selected.") | color(theme::muted);
    const ldp3::driver::Manifest& m = p->manifest;

    // Actions + dependencies + facts, left column.
    Elements acts;
    const auto& list = projectActions();
    for (int i = 0; i < static_cast<int>(list.size()); ++i) {
        const bool sel = i == s.selectedAction;
        Element a = text((sel ? " ▸ " : "   ") + list[static_cast<std::size_t>(i)].first);
        a = sel ? (a | color(theme::amber) | bold) : (a | color(theme::muted));
        acts.push_back(std::move(a));
    }
    Elements deps;
    if (m.dependencies.empty()) {
        deps.push_back(text("  none") | color(theme::faint));
    } else {
        for (const ldp3::driver::Dependency& d : m.dependencies)
            deps.push_back(hbox({text("  " + d.name) | color(theme::ink), filler(),
                                 text(d.version + " ") | color(theme::muted)}));
    }
    Element left = vbox({
                       hbox({text(" ACTIONS") | color(theme::faint), filler()}),
                       separator() | color(theme::line),
                       vbox(std::move(acts)),
                       text(""),
                       hbox({text(" DEPENDENCIES") | color(theme::faint), filler()}),
                       separator() | color(theme::line),
                       vbox(std::move(deps)),
                       filler(),
                       kv("entry", text(m.entry) | color(theme::muted)),
                   }) |
                   borderStyled(ROUNDED, theme::line) | size(WIDTH, EQUAL, 30);

    // Console, right column.
    Elements clines;
    std::string status;
    Color statusColor = theme::faint;
    switch (s.console.status) {
        case Console::Status::Idle:
            clines.push_back(text("  Select an action and press Enter.") | color(theme::faint));
            break;
        case Console::Status::Running:
            clines.push_back(text("  ▸ " + s.console.title + " — running…") | color(theme::teal));
            status = "● running";
            statusColor = theme::teal;
            break;
        case Console::Status::Done:
            for (const std::string& l : s.console.lines) clines.push_back(consoleLine(" " + l));
            status = s.console.exitCode == 0 ? "● ok" : "● failed";
            statusColor = s.console.exitCode == 0 ? theme::green : theme::red;
            break;
    }
    Element title = s.console.title.empty() ? text("") : text(" · " + s.console.title) | color(theme::muted);
    Element console = vbox({
                          hbox({text(" CONSOLE") | color(theme::faint), std::move(title), filler(),
                                text(status + " ") | color(statusColor)}),
                          separator() | color(theme::line),
                          vbox(std::move(clines)) | flex,
                      }) |
                      borderStyled(ROUNDED, theme::amber) | flex;

    return hbox({std::move(left), std::move(console)});
}

Element renderEnvironments(const AppState& s) {
    Elements rows;
    if (s.environments.empty()) rows.push_back(text("  No environments yet.") | color(theme::muted));
    for (int i = 0; i < static_cast<int>(s.environments.size()); ++i) {
        const Environment& e = s.environments[static_cast<std::size_t>(i)];
        const bool sel = i == s.selectedEnv;
        const std::string meta =
            std::to_string(e.libs.size()) + " libs · " + std::to_string(e.usedBy.size()) + " projects";
        Element nm = text((sel ? " ▸ " : "   ") + e.name);
        nm = sel ? (nm | color(theme::amber) | bold) : (nm | color(theme::violet));
        Element row = hbox({nm, filler(), text(meta + " ") | color(theme::faint)});
        rows.push_back(std::move(row));
    }
    rows.push_back(text("  ＋ new environment…") | color(theme::teal));
    Element list = vbox({
                       hbox({text(" ENVIRONMENTS") | color(theme::faint), filler(),
                             text("n new ") | color(theme::faint)}),
                       separator() | color(theme::line),
                       vbox(std::move(rows)) | flex,
                   }) |
                   borderStyled(ROUNDED, theme::amber);

    Elements right;
    if (s.selectedEnv >= 0 && s.selectedEnv < static_cast<int>(s.environments.size())) {
        const Environment& e = s.environments[static_cast<std::size_t>(s.selectedEnv)];
        right.push_back(text(" " + e.name) | color(theme::violet) | bold);
        right.push_back(separator() | color(theme::line));
        right.push_back(hbox({text(" LIBRARIES") | color(theme::faint), filler(),
                              text(std::to_string(e.libs.size()) + " ") | color(theme::faint)}));
        if (e.libs.empty()) right.push_back(text("  none") | color(theme::faint));
        for (const ldp3::driver::Dependency& d : e.libs)
            right.push_back(hbox({text("  " + d.name) | color(theme::ink), filler(),
                                  text(d.version + " ") | color(theme::muted)}));
        right.push_back(text(""));
        right.push_back(hbox({text(" USED BY") | color(theme::faint), filler()}));
        if (e.usedBy.empty()) right.push_back(text("  no projects") | color(theme::faint));
        for (const std::string& u : e.usedBy) right.push_back(text("  ◈ " + u) | color(theme::ink));
    }
    right.push_back(filler());
    Element detail = vbox(std::move(right)) | borderStyled(ROUNDED, theme::line) | size(WIDTH, EQUAL, 44);

    return hbox({list | flex, std::move(detail)});
}

}  // namespace

Element renderNewProjectModal(const AppState& s) {
    const NewProject& np = s.newProject;
    auto modalField = [](const std::string& label, Element value, bool focused) {
        Element marker = text(focused ? " ▸ " : "   ") | color(focused ? theme::amber : theme::faint);
        return vbox({text(" " + label) | color(theme::faint), hbox({marker, std::move(value)})});
    };

    Element nameVal = text(np.name + (np.field == 0 ? "_" : "")) |
                      color(np.field == 0 ? theme::ink : theme::muted);

    const bool hasEnv = np.envChoice > 0 && np.envChoice - 1 < static_cast<int>(s.environments.size());
    const std::string envName = hasEnv ? s.environments[static_cast<std::size_t>(np.envChoice - 1)].name : "none";
    Element envVal = hbox({text("‹ ") | color(theme::faint),
                           text(envName) | color(hasEnv ? theme::violet : theme::muted),
                           text(" ›") | color(theme::faint)});

    Elements body = {
        text(" ＋ New LDP3 project") | color(theme::amber) | bold,
        separator() | color(theme::line),
        modalField("NAME", std::move(nameVal), np.field == 0),
        text(""),
        modalField("ENVIRONMENT", std::move(envVal), np.field == 1),
    };
    if (!np.error.empty()) {
        body.push_back(text(""));
        body.push_back(text(" " + np.error) | color(theme::red));
    }
    body.push_back(separator() | color(theme::line));
    body.push_back(hbox({text(" tab") | color(theme::amber), text(" next   ") | color(theme::muted),
                         text("⏎") | color(theme::amber), text(" create   ") | color(theme::muted),
                         text("esc") | color(theme::amber), text(" cancel") | color(theme::muted)}));
    return vbox(std::move(body)) | borderStyled(ROUNDED, theme::amber) | size(WIDTH, EQUAL, 48);
}

Element renderContent(const AppState& state) {
    switch (state.screen) {
        case Screen::ProjectDetail:
            return renderProjectDetail(state);
        case Screen::Environments:
            return renderEnvironments(state);
        default:
            return renderProjects(state);
    }
}

}  // namespace ldp3::studio
