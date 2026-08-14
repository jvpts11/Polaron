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

    // Build (or reuse) a shared library from the bundle's bitcode, keyed by fingerprint so an unchanged
    // bundle is compiled only once.
    const std::string dll = tempDir() + "/polaron_" + b.name + "_" + hex8(b.fingerprint) + POLARON_BUNDLE_EXT;
    if (!fileExists(dll)) {
        const std::string bc = dll + ".bc";
        std::ofstream out(bc, std::ios::binary);
        out.write(b.code.data(), static_cast<std::streamsize>(b.code.size()));
        out.close();
        // -O1 dead-strips the weak prelude functions the bundle does not use, so the image only keeps
        // what it references (e.g. Object) and stays self-contained.
        // Link against the host's import library so the bundle's allocations come from the host's heap
        // (see hostImportLib). Absent -- an older host, or one linked without exporting -- the command is
        // unchanged and the failure is the same undefined-symbol error as before, not a silent second
        // heap: better to fail at load than to corrupt at free.
        std::string hostLib;
        if (const std::string lib = hostImportLib(); !lib.empty() && fileExists(lib)) {
            hostLib = " \"" + lib + "\"";
        }
        const std::string cmd = "clang -shared -O1 -Wno-override-module \"" + bc + "\" -o \"" + dll +
                                "\"" + hostLib + POLARON_BUNDLE_LINK;
        if (std::system(cmd.c_str()) != 0) {
            return fail(POLARON_BUNDLE_MISSING, "could not be compiled");
        }
    }
    void* h = loadLibrary(dll);
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
