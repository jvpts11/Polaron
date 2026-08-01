#pragma once
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace ldp3::driver {

// A single declared dependency. Either a registry package (name + version, a Git tag) or a local
// path dependency (`name = { path = "../lib" }`) — a sibling library project built from source.
struct Dependency {
    std::string name;
    std::string version;
    std::string path;   // local path dependency, relative to the manifest; when set, version is ignored
};

// A resolved project manifest. Fields not present in the file keep their defaults.
struct Manifest {
    std::string name;
    std::string version = "0.0.0";
    std::string languageVersion;
    std::string entry;
    std::string outputDir = "build-output/";
    std::string target = "x86_64-windows";
    std::string sysroot;                 // cross-compile sysroot ([build] sysroot = "..."); empty = host
    std::string environment;             // optional shared environment ([build] environment = "...")
    bool freestanding = false;
    // [build] subsystem = "windows": link a GUI program (no console window). Default "" = console, so a
    // normal program keeps its stdout/stderr console. A GUI app (draws its own window) opts in.
    std::string subsystem;
    bool isLibrary = false;              // [library] instead of [program]: build emits a .ldb bundle
    bool singleFile = false;             // loose file (ephemeral): compile only the entry, not its siblings
    std::vector<Dependency> dependencies;  // from [dependencies]
    bool hasDependencies = false;          // convenience: !dependencies.empty()
    // Native system libraries to link, from [build] native_libs = "opengl32, user32, ...". These are the
    // libraries an FFI (`extern`) program calls into -- e.g. opengl32/user32/gdi32 for a GL program.
    std::vector<std::string> nativeLibs;
    // [freestanding] bare-metal build (spec 36). Presence of the section implies freestanding = true.
    // The driver then drives the whole pipeline (ldp3c --target -> clang -c -> ld.lld -T script) with no
    // hosted runtime/CRT -- see buildProgram's freestanding branch.
    bool hasFreestandingSection = false;  // a real [freestanding] section (vs legacy [build] freestanding=true)
    std::string fsTarget = "x86_64-unknown-none-elf";  // [freestanding] target = "..." (bare-metal triple)
    std::string linkerScript;                          // [freestanding] linker_script = "kernel.ld" (override)
    std::vector<std::string> bootSources;              // [freestanding] boot = "boot.s, ..." (asm linked in)
    // With no explicit `linker_script` the driver GENERATES one from these two. A bare-metal image's
    // layout is boilerplate -- entry symbol, load address, then the standard text/rodata/data/bss order --
    // so it should no more be hand-written than the memcpy/memset stubs the driver already generates.
    std::string loadAddress = "1M";     // [freestanding] load_address = "0x100000" | "1M" (default 1 MiB)
    // [freestanding] image = "elf" (default) | "bin" | "iso". The linked ELF is always produced; `bin`
    // additionally flattens it (llvm-objcopy -O binary) for a BIOS/UEFI/embedded payload, and `iso`
    // wraps it in a bootable El Torito CD image (GRUB + xorriso).
    std::string imageFormat = "elf";
    std::string bootProtocol;           // [freestanding] boot_protocol = "pvh" -> emit .note.Xen first
};

// Parse the supported TOML subset ([program]/[build]/[dependencies]) from text.
Manifest parseManifestText(const std::string& text);

// Walk up from `start` (inclusive) looking for a .toml whose first non-blank line is [ldp3_project].
// The two-argument form also reports, via `sawToml`, the first .toml that was found WITHOUT that header,
// so callers can tell "no manifest anywhere" from "there is a .toml but it isn't an LDP3 manifest".
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start,
                                                  std::filesystem::path* sawToml);
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start);

// Synthesize a manifest for a single loose file (name = stem, entry = the file).
Manifest ephemeralManifest(const std::filesystem::path& file);

// Add or update a `name = "version"` entry under [dependencies], creating the section if needed.
// Only that section is touched; every other line is preserved. Returns false on I/O failure.
bool addDependency(const std::filesystem::path& manifestPath, const std::string& name,
                   const std::string& version);

// Remove a dependency line under [dependencies]. Absent entry is a no-op (still returns true).
bool removeDependency(const std::filesystem::path& manifestPath, const std::string& name);

}  // namespace ldp3::driver
