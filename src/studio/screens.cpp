#include "studio/screens.h"

#include <cstddef>
#include <string>
#include <utility>

#include "studio/theme.h"

using namespace ftxui;

namespace ldp3::studio {
namespace {

// A small colored chip (environment badge / status).
Element chip(const std::string& s, Color fg) {
    return text(" " + s + " ") | color(fg) | bgcolor(theme::sel);
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
        text(" v" + m.version + " ") | color(theme::muted),
    });
    return sel ? (row | bgcolor(theme::sel)) : row;
}

Element kv(const std::string& k, Element v) {
    return hbox({text(" " + k) | color(theme::faint) | size(WIDTH, EQUAL, 15), std::move(v)});
}

Element detailPane(const ldp3::driver::DiscoveredProject& p) {
    const ldp3::driver::Manifest& m = p.manifest;
    const std::string lang = m.languageVersion.empty() ? "—" : m.languageVersion;
    return vbox({
        text(" " + m.name) | color(theme::amber) | bold,
        text(" " + p.dir.string()) | color(theme::faint),
        separator() | color(theme::line),
        kv("entry", text(m.entry) | color(theme::ink)),
        kv("versão", text(m.version + "  · lang " + lang) | color(theme::ink)),
        m.environment.empty() ? kv("environment", text("—") | color(theme::muted))
                              : kv("environment", text(m.environment) | color(theme::violet)),
        kv("deps", text(std::to_string(m.dependencies.size())) | color(theme::ink)),
        kv("target", text(m.target) | color(theme::muted)),
        filler(),
    });
}

}  // namespace

Element renderProjects(const AppState& s) {
    Elements rows;
    if (s.projects.empty()) {
        rows.push_back(text("  Nenhum projeto LDP3 nesta pasta.") | color(theme::muted));
        rows.push_back(text("  Pressione s para escanear o computador.") | color(theme::faint));
    }
    for (int i = 0; i < static_cast<int>(s.projects.size()); ++i)
        rows.push_back(projectRow(s.projects[static_cast<std::size_t>(i)], i == s.selectedProject));

    Element list = vbox({
                       hbox({text(" TODOS OS PROJETOS") | color(theme::faint), filler(),
                             text("/ buscar ") | color(theme::faint)}),
                       separator() | color(theme::line),
                       vbox(std::move(rows)) | flex,
                   }) |
                   borderStyled(ROUNDED, theme::amber);

    Element right = s.selected() ? detailPane(*s.selected()) : Element{filler()};
    Element detail = vbox({
                         hbox({text(" DETALHE") | color(theme::faint), filler()}),
                         separator() | color(theme::line),
                         std::move(right) | flex,
                     }) |
                     borderStyled(ROUNDED, theme::line);

    return hbox({list | flex, std::move(detail) | size(WIDTH, EQUAL, 42)});
}

}  // namespace ldp3::studio
