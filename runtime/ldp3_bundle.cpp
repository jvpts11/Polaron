// Dynamic .ldb loader (spec 2.4-2.5). Linked into programs that load a bundle dynamically. It reuses
// the in-tree .ldb container reader, so the bundle format lives in one place (no C re-implementation).
//
// On first use it reads the .ldb, checks the ABI fingerprint against what the program compiled
// against, AOT-compiles the bundle's bitcode to a DLL with clang (cached by fingerprint), loads it and
// resolves symbols. A missing bundle or a fingerprint mismatch is reported so the generated thunk can
// raise the corresponding LDP3 exception.

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

#include "bundle/ldb.h"

// Platform naming for the AOT-compiled bundle image and the dynamic-loader API. Windows produces a .dll
// loaded with LoadLibrary/GetProcAddress; POSIX produces a .so loaded with dlopen/dlsym. The clang command
// differs only in the platform link needs (legacy_stdio on Windows; nothing extra on POSIX -- the bundle's
// undefined runtime symbols resolve from the host program at load time, which needs the program linked
// with -rdynamic).
#ifdef _WIN32
#define LDP3_BUNDLE_EXT ".dll"
#define LDP3_BUNDLE_LINK " -llegacy_stdio_definitions"
#else
#define LDP3_BUNDLE_EXT ".so"
#define LDP3_BUNDLE_LINK " -fPIC"  // the bundle bitcode must be PIC to link into a .so
#endif

namespace {

std::string tempDir() {
#ifdef _WIN32
    const char* t = std::getenv("TEMP");
    if (t == nullptr) t = std::getenv("TMP");
    return t != nullptr ? std::string(t) : std::string(".");
#else
    const char* t = std::getenv("TMPDIR");
    return t != nullptr ? std::string(t) : std::string("/tmp");
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
    for (int i = 0; i < 8; ++i) std::snprintf(buf + i * 2, 3, "%02x", fp[i]);
    buf[16] = '\0';
    return std::string(buf);
}

}  // namespace

extern "C" {

// Result codes a generated thunk inspects before calling: a null handle plus the reason.
enum Ldp3BundleStatus { LDP3_BUNDLE_OK = 0, LDP3_BUNDLE_MISSING = 1, LDP3_BUNDLE_ABI = 2 };

// Loads a .ldb dynamically and returns its module handle, or null on failure. `status` (if non-null)
// receives why: the bundle file is missing/invalid (MISSING) or its fingerprint does not match what
// the program expected (ABI).
void* ldp3_bundle_load(const char* ldbPath, const unsigned char* expectedFp, int* status) {
    auto fail = [&](int s, const char* why) -> void* {
        if (status != nullptr) *status = s;
        std::fprintf(stderr, "ldp3: bundle '%s' %s\n", ldbPath, why);
        return nullptr;
    };
    std::ifstream in(ldbPath, std::ios::binary);
    if (!in) return fail(LDP3_BUNDLE_MISSING, "not loaded (file missing)");
    std::ostringstream ss;
    ss << in.rdbuf();
    const std::string bytes = ss.str();

    ldp3::LdbBundle b;
    if (!ldp3::readLdb(bytes, b)) return fail(LDP3_BUNDLE_MISSING, "not loaded (not a valid .ldb)");
    if (std::memcmp(b.fingerprint.data(), expectedFp, 32) != 0)
        return fail(LDP3_BUNDLE_ABI, "ABI fingerprint mismatch");

    // Build (or reuse) a shared library from the bundle's bitcode, keyed by fingerprint so an unchanged
    // bundle is compiled only once.
    const std::string dll = tempDir() + "/ldp3_" + b.name + "_" + hex8(b.fingerprint) + LDP3_BUNDLE_EXT;
    if (!fileExists(dll)) {
        const std::string bc = dll + ".bc";
        std::ofstream out(bc, std::ios::binary);
        out.write(b.code.data(), static_cast<std::streamsize>(b.code.size()));
        out.close();
        // -O1 dead-strips the weak prelude functions the bundle does not use, so the image only keeps
        // what it references (e.g. Object) and stays self-contained.
        const std::string cmd = "clang -shared -O1 -Wno-override-module \"" + bc + "\" -o \"" + dll +
                                "\"" LDP3_BUNDLE_LINK;
        if (std::system(cmd.c_str()) != 0) return fail(LDP3_BUNDLE_MISSING, "could not be compiled");
    }
    void* h = loadLibrary(dll);
    if (h == nullptr) return fail(LDP3_BUNDLE_MISSING, "could not be loaded");
    if (status != nullptr) *status = LDP3_BUNDLE_OK;
    return h;
}

// Resolves an exported symbol in a loaded bundle. Null if absent.
void* ldp3_bundle_sym(void* handle, const char* name) {
    if (handle == nullptr) return nullptr;
    return librarySymbol(handle, name);
}

// Aborts when a dynamic bundle call cannot be resolved (the bundle is missing, its ABI does not match,
// or the symbol is absent). The specific reason was already printed by ldp3_bundle_load. Until the
// runtime can raise a catchable BundleNotLoadedException, this is a hard stop.
void ldp3_bundle_fail(const char* name) {
    std::fprintf(stderr, "ldp3: cannot resolve '%s' from a dynamic bundle\n", name);
    std::exit(70);
}

}  // extern "C"
