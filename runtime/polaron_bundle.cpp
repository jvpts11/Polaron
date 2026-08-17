// Dynamic .polb loader (spec 2.4-2.5). Linked into programs that load a bundle dynamically. It reuses
// the in-tree .polb container reader, so the bundle format lives in one place (no C re-implementation).
//
// On first use it reads the .polb, checks the ABI fingerprint against what the program compiled
// against, AOT-compiles the bundle's bitcode to a DLL with clang (cached by fingerprint), loads it and
// resolves symbols. A missing bundle or a fingerprint mismatch is reported so the generated thunk can
// raise the corresponding Polaron exception.

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <sstream>
#include <string>

#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#include <sys/stat.h>
#include <unistd.h>
#endif

#include "bundle/polb.h"

// Platform naming for the AOT-compiled bundle image and the dynamic-loader API. Windows produces a .dll
// loaded with LoadLibrary/GetProcAddress; POSIX produces a .so loaded with dlopen/dlsym. The clang command
// differs only in the platform link needs (legacy_stdio on Windows; nothing extra on POSIX -- the bundle's
// undefined runtime symbols resolve from the host program at load time, which needs the program linked
// with -rdynamic).
#ifdef _WIN32
#define POLARON_BUNDLE_EXT ".dll"
#define POLARON_BUNDLE_LINK " -llegacy_stdio_definitions"
#else
#define POLARON_BUNDLE_EXT ".so"
#define POLARON_BUNDLE_LINK " -fPIC"  // the bundle bitcode must be PIC to link into a .so
#endif

namespace {

std::string tempDir() {
#ifdef _WIN32
    const char* t = std::getenv("TEMP");
    if (t == nullptr) {
        t = std::getenv("TMP");
    }
    return t != nullptr ? std::string(t) : std::string(".");
#else
    const char* t = std::getenv("TMPDIR");
    return t != nullptr ? std::string(t) : std::string("/tmp");
#endif
}

// On Windows, the import library the host executable's own link produced. The bundle DLL links against
// it so its `__polaron_malloc`/`__polaron_free`/`__polaron_check_live` resolve to the HOST's -- one heap, one
// liveness registry. Without it the bundle would need its own copy of the allocator, which means an
// object allocated on one side and freed on the other corrupts both heaps and the double-free trap only
// ever sees half the program.
//
// The linker writes `<app>.lib` beside `<app>.exe` automatically once the runtime's symbols are
// dllexport'd, so the path is derivable and needs no build-system cooperation. POSIX needs none of this:
// the host is linked -rdynamic and the .so resolves back against it.
std::string hostImportLib() {
#ifdef _WIN32
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    if (n == 0 || n >= MAX_PATH) {
        return {};
    }
    std::string p(buf, n);
    const std::size_t dot = p.find_last_of('.');
    const std::size_t sep = p.find_last_of("\\/");
    if (dot == std::string::npos || (sep != std::string::npos && dot < sep)) {
        return {};
    }
    return p.substr(0, dot) + ".lib";
#else
    return {};
#endif
}

// WHAT THE COMPILED IMAGE DEPENDS ON BESIDES THE BUNDLE: the host it is linked against.
//
// The image is cached in the temp directory and reused, and it used to be named after the bundle alone
// -- its name and its ABI fingerprint. But the bundle is only half of what went into it: on Windows the
// image links against the HOST's import library so that both sides share one allocator, and on POSIX its
// undefined runtime symbols resolve back against the host at load time. An image built for one host and
// handed to another is a different artifact wearing the same name.
//
// Which is not a hypothetical. The same three test programs, rebuilt after their directory was renamed,
// found images from three days earlier sitting in the temp directory, reused them, and failed to load
// them -- and, because a cached file is never rebuilt, they would have gone on failing until somebody
// thought to empty %TEMP%. "It worked yesterday and nothing I changed can explain it" is the whole cost
// of a cache key that does not name everything the cached thing was made from.
//
// So the host goes in the key: where it is, how big it is, and when it was written -- enough to tell a
// different program from this one, and a rebuilt program from the one that was here before.
std::uint64_t hashOf(const std::string& s, std::uint64_t seed = 1469598103934665603ULL) {
    std::uint64_t h = seed;  // FNV-1a, which is plenty for telling two build outputs apart
    for (const unsigned char c : s) {
        h ^= c;
        h *= 1099511628211ULL;
    }
    return h;
}

std::string hostTag() {
    std::string ident;
#ifdef _WIN32
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    if (n != 0 && n < MAX_PATH) {
        ident.assign(buf, n);
        WIN32_FILE_ATTRIBUTE_DATA fa{};
        if (GetFileAttributesExA(ident.c_str(), GetFileExInfoStandard, &fa) != 0) {
            ident += ':' + std::to_string((static_cast<std::uint64_t>(fa.nFileSizeHigh) << 32) |
                                          fa.nFileSizeLow);
            ident += ':' + std::to_string((static_cast<std::uint64_t>(fa.ftLastWriteTime.dwHighDateTime)
                                           << 32) |
                                          fa.ftLastWriteTime.dwLowDateTime);
        }
    }
#else
    char buf[4096];
    const ssize_t n = ::readlink("/proc/self/exe", buf, sizeof(buf) - 1);
    if (n > 0) {
        ident.assign(buf, static_cast<std::size_t>(n));
        struct stat st {};
        if (::stat(ident.c_str(), &st) == 0) {
            ident += ':' + std::to_string(static_cast<std::uint64_t>(st.st_size));
            ident += ':' + std::to_string(static_cast<std::uint64_t>(st.st_mtime));
        }
    }
#endif
    if (ident.empty()) {
        return "nohost";  // an unidentifiable host is one cache slot, shared: no worse than before
    }
    char out[17];
    std::snprintf(out, sizeof(out), "%016llx", static_cast<unsigned long long>(hashOf(ident)));
    return std::string(out);
}

// Deletes a file, ignoring whether it was there.
void removeFile(const std::string& path) {
#ifdef _WIN32
    DeleteFileA(path.c_str());
#else
    ::unlink(path.c_str());
#endif
}

// Whether a file exists at `path`.
bool fileExists(const std::string& path) {
#ifdef _WIN32
    return GetFileAttributesA(path.c_str()) != INVALID_FILE_ATTRIBUTES;
#else
    return ::access(path.c_str(), F_OK) == 0;
#endif
}

// Loads a shared library, returning an opaque handle or null.
void* loadLibrary(const std::string& path) {
#ifdef _WIN32
    return reinterpret_cast<void*>(LoadLibraryA(path.c_str()));
#else
    return ::dlopen(path.c_str(), RTLD_NOW | RTLD_GLOBAL);
#endif
}

// Resolves an exported symbol in a loaded library. Null if absent.
void* librarySymbol(void* handle, const char* name) {
#ifdef _WIN32
    return reinterpret_cast<void*>(GetProcAddress(reinterpret_cast<HMODULE>(handle), name));
#else
    return ::dlsym(handle, name);
#endif
}

std::string hex8(const std::array<std::uint8_t, 32>& fp) {
    char buf[17];
    for (int i = 0; i < 8; ++i) {
        std::snprintf(buf + i * 2, 3, "%02x", fp[i]);
    }
    buf[16] = '\0';
    return std::string(buf);
}

}  // namespace

extern "C" {

// Result codes a generated thunk inspects before calling: a null handle plus the reason.
enum PolaronBundleStatus { POLARON_BUNDLE_OK = 0, POLARON_BUNDLE_MISSING = 1, POLARON_BUNDLE_ABI = 2 };

// Loads a .polb dynamically and returns its module handle, or null on failure. `status` (if non-null)
// receives why: the bundle file is missing/invalid (MISSING) or its fingerprint does not match what
// the program expected (ABI).
void* polaron_bundle_load(const char* polbPath, const unsigned char* expectedFp, int* status) {
    auto fail = [&](int s, const char* why) -> void* {
        if (status != nullptr) {
            *status = s;
        }
        std::fprintf(stderr, "polaron: bundle '%s' %s\n", polbPath, why);
        return nullptr;
    };
    std::ifstream in(polbPath, std::ios::binary);
    if (!in) {
        return fail(POLARON_BUNDLE_MISSING, "not loaded (file missing)");
    }
    std::ostringstream ss;
    ss << in.rdbuf();
    const std::string bytes = ss.str();

    polaron::PolbBundle b;
    if (!polaron::readPolb(bytes, b)) {
        return fail(POLARON_BUNDLE_MISSING, "not loaded (not a valid .polb)");
    }
    if (std::memcmp(b.fingerprint.data(), expectedFp, 32) != 0) {
        return fail(POLARON_BUNDLE_ABI, "ABI fingerprint mismatch");
    }

    // Build (or reuse) a shared library from the bundle's bitcode, keyed by the bundle's fingerprint AND
    // the host it will be linked against (see hostTag), so an unchanged pair is compiled only once and a
    // changed one is never mistaken for it.
    const std::string dll = tempDir() + "/polaron_" + b.name + "_" + hex8(b.fingerprint) + "_" +
                            hostTag() + POLARON_BUNDLE_EXT;
    // -O1 dead-strips the weak prelude functions the bundle does not use, so the image only keeps what it
    // references (e.g. Object) and stays self-contained.
    // Link against the host's import library so the bundle's allocations come from the host's heap (see
    // hostImportLib). Absent -- an older host, or one linked without exporting -- the command is
    // unchanged and the failure is the same undefined-symbol error as before, not a silent second heap:
    // better to fail at load than to corrupt at free.
    auto build = [&]() -> bool {
        const std::string bc = dll + ".bc";
        std::ofstream out(bc, std::ios::binary);
        out.write(b.code.data(), static_cast<std::streamsize>(b.code.size()));
        out.close();
        std::string hostLib;
        if (const std::string lib = hostImportLib(); !lib.empty() && fileExists(lib)) {
            hostLib = " \"" + lib + "\"";
        }
        const std::string cmd = "clang -shared -O1 -Wno-override-module \"" + bc + "\" -o \"" + dll +
                                "\"" + hostLib + POLARON_BUNDLE_LINK;
        return std::system(cmd.c_str()) == 0;
    };
    const bool reused = fileExists(dll);
    if (!reused && !build()) {
        return fail(POLARON_BUNDLE_MISSING, "could not be compiled");
    }
    void* h = loadLibrary(dll);
    if (h == nullptr && reused) {
        // A REUSED IMAGE THAT WILL NOT LOAD IS REBUILT ONCE, rather than failing for as long as it sits
        // there. The key above names everything this image is made from, so this should not happen -- but
        // "should not" is what the old key said too, and the failure it produced was permanent and
        // unexplainable from inside the program. A cache is an optimisation; it may never be the reason
        // a correct program cannot run.
        removeFile(dll);
        if (!build()) {
            return fail(POLARON_BUNDLE_MISSING, "could not be compiled");
        }
        h = loadLibrary(dll);
    }
    if (h == nullptr) {
        return fail(POLARON_BUNDLE_MISSING, "could not be loaded");
    }
    if (status != nullptr) {
        *status = POLARON_BUNDLE_OK;
    }
    return h;
}

// Resolves an exported symbol in a loaded bundle. Null if absent.
void* polaron_bundle_sym(void* handle, const char* name) {
    if (handle == nullptr) {
        return nullptr;
    }
    return librarySymbol(handle, name);
}

// Aborts when a dynamic bundle call cannot be resolved (the bundle is missing, its ABI does not match,
// or the symbol is absent). The specific reason was already printed by polaron_bundle_load. Until the
// runtime can raise a catchable BundleNotLoadedException, this is a hard stop.
void polaron_bundle_fail(const char* name) {
    std::fprintf(stderr, "polaron: cannot resolve '%s' from a dynamic bundle\n", name);
    std::exit(70);
}

}  // extern "C"
