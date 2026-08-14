#pragma once
#include <filesystem>
#include <map>
#include <optional>
#include <string>
#include <vector>

namespace polaron::driver {

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
    bool isLibrary = false;              // [library] instead of [program]: build emits a .polb bundle
    bool singleFile = false;             // loose file (ephemeral): compile only the entry, not its siblings
    std::vector<Dependency> dependencies;  // from [dependencies]
    bool hasDependencies = false;          // convenience: !dependencies.empty()
    // Native system libraries to link, from [build] native_libs = "opengl32, user32, ...". These are the
    // libraries an FFI (`extern`) program calls into -- e.g. opengl32/user32/gdi32 for a GL program.
    //
    // SUPERSEDED by [libraries] below, and kept only so existing manifests keep building. A name here
    // has no connection to any declaration: it says "link this", never "this is where `class Sdl`
    // comes from", so a class could name a library the build did not link and nothing noticed until
    // the linker did.
    std::vector<std::string> nativeLibs;
    // [libraries] -- the per-platform file behind each logical library name, i.e. behind the NAME a
    // class is declared with (`public class Sdl library SDL2 { ... }`).
    //
    // The split is the point. The name in the source is OURS: an identifier, chosen by us, the same on
    // every platform, so it can be checked against the declaration that uses it. The file is THEIRS:
    // `SDL2.lib` on Windows, `libSDL2-2.0.so.0` on Linux -- unspellable as an identifier, different per
    // platform, and therefore belonging in the build's manifest rather than in the source.
    //
    //   [libraries]
    //   SDL2 = { windows = "SDL2", linux = "SDL2-2.0", macos = "SDL2" }
    //   Zlib = "z"                              # one name, every platform
    //
    // Outer key = the logical name; inner key = "windows" | "linux" | "macos", or "*" for the bare
    // form. An inner value that is EMPTY means "needs no link flag at all" -- which is how `C` is
    // answered by default, the C runtime being linked on every platform already.
    std::map<std::string, std::map<std::string, std::string>> foreignLibraries;
    // [freestanding] bare-metal build (spec 36). Presence of the section implies freestanding = true.
    // The driver then drives the whole pipeline (polc --target -> clang -c -> ld.lld -T script) with no
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
    // [freestanding] panic_uart = "0x09000000" -- the byte-wide transmit register of a UART the board
    // already has mapped at reset, used by the default `__polaron_panic` to say what broke.
    //
    // Needed only where the architecture offers no console a compiler may assume. x86 does (COM1 at
    // port 0x3F8, which needs no mapping and works before anything is initialised); AArch64 does not,
    // because a UART's address there is a fact about the BOARD. Empty means the default panic halts
    // without printing, which is the honest behaviour -- a guessed address is a store into live memory.
    std::string panicUart;
};

// Parse the supported TOML subset ([program]/[build]/[dependencies]) from text.
Manifest parseManifestText(const std::string& text);

// Resolve one logical library name (`class Sdl library SDL2`) to what the linker should be given on
// `platform` ("windows" | "linux" | "macos").
//
// Returns nothing when the library needs no flag: either the manifest maps it to the empty string, or
// it is `C`, which every platform links already. An UNMAPPED name resolves to itself, so a library
// whose file happens to be spelled like its logical name (`z`, `opengl32`) needs no entry at all --
// the manifest is for the cases where the two differ, not a registry of everything.
std::optional<std::string> resolveForeignLibrary(const Manifest& m, const std::string& logical,
                                                 const std::string& platform);

// The platform key `resolveForeignLibrary` wants, read off a target triple ("x86_64-pc-windows-msvc"
// -> "windows"). Unrecognized triples answer "linux", the ELF default.
std::string platformOfTriple(const std::string& triple);

// Walk up from `start` (inclusive) looking for a .toml whose first non-blank line is [polaron_project].
// The two-argument form also reports, via `sawToml`, the first .toml that was found WITHOUT that header,
// so callers can tell "no manifest anywhere" from "there is a .toml but it isn't a Polaron manifest".
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

}  // namespace polaron::driver
