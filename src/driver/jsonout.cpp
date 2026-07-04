#include "driver/jsonout.h"

#include <algorithm>
#include <cstdio>
#include <fstream>
#include <sstream>
#include <vector>

#include "driver/discovery.h"
#include "driver/environs.h"
#include "driver/manifest.h"

namespace ldp3::driver {
namespace {

std::string jstr(const std::string& s) {
    std::string o = "\"";
    for (char c : s) {
        switch (c) {
            case '"': o += "\\\""; break;
            case '\\': o += "\\\\"; break;
            case '\n': o += "\\n"; break;
            case '\r': o += "\\r"; break;
            case '\t': o += "\\t"; break;
            default:
                if (static_cast<unsigned char>(c) < 0x20) {
                    char buf[8];
                    std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
                    o += buf;
                } else {
                    o += c;
                }
        }
    }
    o += "\"";
    return o;
}

std::string jarr(const std::vector<std::string>& items) {
    std::string o = "[";
    for (std::size_t i = 0; i < items.size(); ++i) {
        if (i != 0) o += ",";
        o += items[i];
    }
    o += "]";
    return o;
}

std::string depsJson(const std::vector<Dependency>& deps) {
    std::vector<std::string> out;
    for (const Dependency& d : deps)
        out.push_back("{\"name\":" + jstr(d.name) + ",\"version\":" + jstr(d.version) + "}");
    return jarr(out);
}

struct Env {
    std::string name;
    std::vector<Dependency> libs;
    std::vector<std::string> usedBy;
};

struct Lib {
    std::string name;
    std::vector<std::string> versions;
    std::vector<std::string> usedByProjects;
    std::vector<std::string> usedByEnvs;
};

}  // namespace

std::string studioJson(const std::filesystem::path& root) {
    const std::vector<DiscoveredProject> projects = discoverProjects(root);

    std::vector<Env> envs;
    for (const std::string& name : listEnvironments()) {
        Env e;
        e.name = name;
        std::ifstream f(environmentManifest(name));
        if (f) {
            std::stringstream ss;
            ss << f.rdbuf();
            e.libs = parseManifestText(ss.str()).dependencies;
        }
        for (const DiscoveredProject& p : projects)
            if (p.manifest.environment == name) e.usedBy.push_back(p.manifest.name);
        envs.push_back(std::move(e));
    }

    std::vector<Lib> libs;
    auto getLib = [&libs](const std::string& n) -> Lib& {
        for (Lib& l : libs)
            if (l.name == n) return l;
        libs.push_back(Lib{n, {}, {}, {}});
        return libs.back();
    };
    auto addVersion = [](Lib& l, const std::string& v) {
        if (std::find(l.versions.begin(), l.versions.end(), v) == l.versions.end()) l.versions.push_back(v);
    };
    for (const DiscoveredProject& p : projects)
        for (const Dependency& d : p.manifest.dependencies) {
            Lib& l = getLib(d.name);
            addVersion(l, d.version);
            l.usedByProjects.push_back(p.manifest.name);
        }
    for (const Env& e : envs)
        for (const Dependency& d : e.libs) {
            Lib& l = getLib(d.name);
            addVersion(l, d.version);
            l.usedByEnvs.push_back(e.name);
        }
    std::sort(libs.begin(), libs.end(), [](const Lib& a, const Lib& b) { return a.name < b.name; });

    std::vector<std::string> projJson;
    for (const DiscoveredProject& p : projects) {
        const Manifest& m = p.manifest;
        projJson.push_back("{\"name\":" + jstr(m.name) + ",\"dir\":" + jstr(p.dir.string()) +
                           ",\"version\":" + jstr(m.version) + ",\"entry\":" + jstr(m.entry) +
                           ",\"environment\":" + jstr(m.environment) +
                           ",\"deps\":" + std::to_string(m.dependencies.size()) +
                           ",\"target\":" + jstr(m.target) + "}");
    }

    std::vector<std::string> envJson;
    for (const Env& e : envs) {
        std::vector<std::string> used;
        for (const std::string& u : e.usedBy) used.push_back(jstr(u));
        envJson.push_back("{\"name\":" + jstr(e.name) + ",\"libs\":" + depsJson(e.libs) +
                          ",\"usedBy\":" + jarr(used) + "}");
    }

    std::vector<std::string> libJson;
    for (const Lib& l : libs) {
        std::vector<std::string> vers;
        for (const std::string& v : l.versions) vers.push_back(jstr(v));
        std::vector<std::string> byP;
        for (const std::string& u : l.usedByProjects) byP.push_back(jstr(u));
        std::vector<std::string> byE;
        for (const std::string& u : l.usedByEnvs) byE.push_back(jstr(u));
        libJson.push_back("{\"name\":" + jstr(l.name) + ",\"versions\":" + jarr(vers) +
                          ",\"usedByProjects\":" + jarr(byP) + ",\"usedByEnvs\":" + jarr(byE) + "}");
    }

    return "{\"projects\":" + jarr(projJson) + ",\"environments\":" + jarr(envJson) +
           ",\"libraries\":" + jarr(libJson) + "}\n";
}

}  // namespace ldp3::driver
