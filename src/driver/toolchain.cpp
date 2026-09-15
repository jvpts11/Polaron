#include "driver/toolchain.h"
#include "polaron_config.h"
#include <cstdlib>
#ifdef _WIN32
#include <windows.h>
#else
#include <climits>
#include <unistd.h>
#endif

namespace polaron::driver {
namespace fs = std::filesystem;

namespace {
std::string envOr(const char* name, const std::string& fallback) {
    const char* v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}

// Platform-specific tool file names. On Windows the sibling tools carry ".exe" and the runtime is an
// MSVC-style import lib; on POSIX they are extensionless and the runtime is a Unix static archive.
#ifdef _WIN32
constexpr const char* kRuntimeLib = "polaron_rt.lib";
#else
constexpr const char* kRuntimeLib = "libpolaron_rt.a";
#endif

#ifdef _WIN32
// The newest `VC/Tools/MSVC/<version>` under a Visual Studio installation, or "" if there is none.
//
// Newest by NAME, descending, which is right here because the directories are dotted version numbers
// with padded components: `14.51.36231` sorts after `14.44.35207` as a string. Comparing them as
// versions would be more correct and would need a parser for a value that has never needed one.
std::string newestMsvcUnder(const fs::path& vsRoot) {
    std::error_code ec;
    const fs::path tools = vsRoot / "VC" / "Tools" / "MSVC";
    if (!fs::is_directory(tools, ec)) {
        return {};
    }
    std::string best;
    for (const auto& entry : fs::directory_iterator(tools, ec)) {
        if (!entry.is_directory(ec)) {
            continue;
        }
        // A toolset counts only if it actually carries the x64 libraries. A half-installed or
        // ARM-only component would otherwise be chosen and produce the same missing-library failure
        // this whole lookup exists to end -- one directory further along.
        if (!fs::exists(entry.path() / "lib" / "x64" / "msvcprt.lib", ec)) {
            continue;
        }
        if (const std::string name = entry.path().filename().string(); name > best) {
            best = name;
        }
    }
    return best.empty() ? std::string{} : (tools / best).string();
}

// Ask `vswhere` where Visual Studio is. It ships with every VS since 2017, at a path Microsoft
// documents as fixed for exactly this purpose -- so this is a lookup, not a guess.
std::string vsRootFromVswhere() {
    const char* pf86 = std::getenv("ProgramFiles(x86)");
    if (!pf86 || !*pf86) {
        return {};
    }
    const fs::path vswhere = fs::path(pf86) / "Microsoft Visual Studio" / "Installer" / "vswhere.exe";
    std::error_code ec;
    if (!fs::exists(vswhere, ec)) {
        return {};
    }
    // `-products *` so a Build Tools install counts: a machine carrying only the C++ build tools and
    // no IDE is a perfectly good machine to compile on, and vswhere's default filter leaves it out.
    const std::string cmd = "\"\"" + vswhere.string() +
                            "\" -latest -products * -property installationPath\" 2>nul";
    std::unique_ptr<FILE, int (*)(FILE*)> pipe(_popen(cmd.c_str(), "r"), &_pclose);
    if (!pipe) {
        return {};
    }
    std::string out;
    char buf[512];
    while (std::fgets(buf, sizeof(buf), pipe.get()) != nullptr) {
        out += buf;
    }
    while (!out.empty() && (out.back() == '\n' || out.back() == '\r' || out.back() == ' ')) {
        out.pop_back();
    }
    return out;
}
#endif
}  // namespace

std::string findVcTools() {
#ifndef _WIN32
    return {};
#else
    // 1. TOLD, and that always wins: a machine with several toolsets, a CI pinning one, or somebody
    //    working around whatever this lookup gets wrong next.
    if (const char* over = std::getenv("POLARON_VCTOOLS"); over != nullptr && *over != '\0') {
        return over;
    }
    // 2. ALREADY IN THE ENVIRONMENT. `vcvars64` sets `VCToolsInstallDir`, so a build started from a
    //    developer prompt uses exactly the toolset that prompt chose -- which is what somebody who
    //    opened that prompt meant, and it is not this code's place to second-guess them.
    if (const char* fromVcvars = std::getenv("VCToolsInstallDir");
        fromVcvars != nullptr && *fromVcvars != '\0') {
        std::string dir = fromVcvars;
        while (!dir.empty() && (dir.back() == '\\' || dir.back() == '/')) {
            dir.pop_back();   // vcvars leaves a trailing separator; clang wants the directory
        }
        std::error_code ec;
        if (fs::is_directory(dir, ec)) {
            return dir;
        }
    }
    // 3. ASK VSWHERE -- the supported way, and the one that works from an ordinary shell.
    if (const std::string root = vsRootFromVswhere(); !root.empty()) {
        if (std::string tools = newestMsvcUnder(root); !tools.empty()) {
            return tools;
        }
    }
    // 4. LOOK. vswhere is absent on a machine whose Visual Studio predates 2017, and present but
    //    unhelpful when an install is broken. The layout under Program Files has been stable for a
    //    decade, and walking two levels of it costs nothing on the failure path -- which is the only
    //    path that reaches here.
    for (const char* var : {"ProgramFiles", "ProgramFiles(x86)"}) {
        const char* pf = std::getenv(var);
        if (pf == nullptr || *pf == '\0') {
            continue;
        }
        std::error_code ec;
        const fs::path vsDir = fs::path(pf) / "Microsoft Visual Studio";
        if (!fs::is_directory(vsDir, ec)) {
            continue;
        }
        std::string best;
        for (const auto& year : fs::directory_iterator(vsDir, ec)) {              // 2019, 2022, 18
            if (!year.is_directory(ec)) {
                continue;
            }
            for (const auto& edition : fs::directory_iterator(year.path(), ec)) {  // Community, ...
                if (!edition.is_directory(ec)) {
                    continue;
                }
                if (std::string tools = newestMsvcUnder(edition.path()); tools > best) {
                    best = std::move(tools);
                }
            }
        }
        if (!best.empty()) {
            return best;
        }
    }
    return {};
#endif
}

std::string exeSuffix() {
#ifdef _WIN32
    return ".exe";
#else
    return "";
#endif
}

fs::path exeDir() {
#ifdef _WIN32
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    return fs::path(std::string(buf, n)).parent_path();
#else
    char buf[PATH_MAX];
    const ssize_t n = ::readlink("/proc/self/exe", buf, sizeof(buf));
    if (n <= 0) return fs::current_path();
    return fs::path(std::string(buf, static_cast<size_t>(n))).parent_path();
#endif
}

fs::path polaronHomeDir() {
    if (const char* over = std::getenv("POLARON_HOME"); over && *over) {
        return fs::path(over);
    }
    const char* home = std::getenv("USERPROFILE");
    if (!home || !*home) {
        home = std::getenv("HOME");
    }
    const fs::path base = (home && *home) ? fs::path(home) : fs::current_path();
    return base / ".pol";
}

Toolchain locateToolchain() {
    const fs::path dir = exeDir();
    const std::string sfx = exeSuffix();
    Toolchain t;
    t.polc = envOr("POLC", (dir / ("polc" + sfx)).string());
    t.runtimeLib = envOr("POLARON_RUNTIME", (dir / kRuntimeLib).string());
    // ...AND ITS 32-BIT TWIN, when this install carries one. LOOKED UP rather than assumed: an
    // install that predates it, or a machine that had no `llvm-lib` when it was built, leaves the
    // field empty, and the i686 link path then refuses with a sentence instead of handing the linker
    // a library of the wrong machine and letting it report every runtime symbol as undefined.
    {
        std::error_code rc;
        const fs::path rt32 = dir / "polaron_rt32.lib";
        if (const char* over = std::getenv("POLARON_RUNTIME32"); over != nullptr && *over != '\0') {
            t.runtimeLib32 = over;
        } else if (fs::exists(rt32, rc)) {
            t.runtimeLib32 = rt32.string();
        }
    }
    // A bundled install ships clang + lld-link + a lib/ directory beside the driver. Prefer them so the
    // toolchain is self-contained; fall back to a system clang otherwise. (Self-contained bundling is a
    // Windows feature today; on POSIX the sibling lld-link is absent, so the system toolchain is used.)
    std::error_code ec;
    const fs::path bundledClang = dir / ("clang" + sfx);
    const fs::path bundledLld = dir / ("lld-link" + sfx);
    const fs::path bundledLib = dir / "lib";
    t.clang = envOr("POLARON_CLANG",
                    fs::exists(bundledClang, ec) ? bundledClang.string() : POLARON_DEFAULT_CLANG);
    if (fs::is_directory(bundledLib, ec) && fs::exists(bundledLld, ec)) {
        t.libDir = bundledLib.string();
        t.lldLink = bundledLld.string();
    }
    // ELF linker for freestanding: ld.lld sits beside clang (the kernel build uses it the same way).
    t.ldLld = envOr("POLARON_LD_LLD", (fs::path(t.clang).parent_path() / ("ld.lld" + sfx)).string());
    // ...and wasm-ld beside it, for a target whose object files ld.lld does not recognise at all.
    t.wasmLd = envOr("POLARON_WASM_LD", (fs::path(t.clang).parent_path() / ("wasm-ld" + sfx)).string());
    // ...and lld-link beside it too, for `image = "efi"`. Beside clang and NOT `t.lldLink` above:
    // that one is the bundled install's copy and its emptiness is how the hosted path decides whether
    // there is a bundle to link against. See the note on `Toolchain::coffLd`.
    t.coffLd = envOr("POLARON_LLD_LINK", (fs::path(t.clang).parent_path() / ("lld-link" + sfx)).string());
    // Image-format tools. llvm-objcopy ships beside clang and turns the linked ELF into a flat binary;
    // xorriso is only needed for a bootable .iso and is looked up on PATH (left empty when absent, so
    // the driver can report exactly what is missing rather than failing obscurely).
    t.objcopy = envOr("POLARON_OBJCOPY", (fs::path(t.clang).parent_path() / ("llvm-objcopy" + sfx)).string());
    t.xorriso = envOr("POLARON_XORRISO", "xorriso" + sfx);
    // Only when there is no bundle to link against: a self-contained install carries its own CRT and
    // import libs, so pointing clang at a system Visual Studio there would be answering a question
    // nobody asked -- and would make a build depend on something the bundle exists to remove.
    if (t.libDir.empty()) {
        t.vcToolsDir = findVcTools();
    }
    return t;
}

}  // namespace polaron::driver
