#pragma once
#include <filesystem>
#include <string>

namespace polaron::driver {

struct Toolchain {
    std::string polc;       // low-level compiler (sibling of this exe, or $POLC)
    std::string clang;       // compiler/linker driver ($POLARON_CLANG, PATH, or compile-time default)
    std::string runtimeLib;  // polaron_rt.lib (sibling of this exe, or $POLARON_RUNTIME)
    // Self-contained bundle (a full install): a sibling lib/ directory holding the CRT + Windows import
    // libs and lld-link. When present, linking goes through lld-link against these libs so no system
    // Visual Studio / Windows SDK is required -- Polaron works on a bare Windows 10/11 x64 machine.
    std::string libDir;      // bundled CRT/import libs directory, or "" (use the system toolchain)
    std::string lldLink;     // bundled lld-link.exe, or ""
    std::string ldLld;       // ELF linker ld.lld (sibling of clang, or $POLARON_LD_LLD) -- freestanding link
    // WebAssembly linker. A separate tool rather than a mode of ld.lld: a module has no sections to
    // place and no entry symbol, so the ELF path's linker script is meaningless to it and ld.lld
    // rejects the objects with `unknown file type`.
    std::string wasmLd;      // wasm-ld (sibling of clang, or $POLARON_WASM_LD)
    std::string objcopy;     // llvm-objcopy (sibling of clang, or $POLARON_OBJCOPY) -- flat/binary images
    std::string xorriso;     // xorriso (PATH or $POLARON_XORRISO) -- bootable .iso images; may be ""
};

// Directory containing the running polaron executable.
std::filesystem::path exeDir();

// Platform executable suffix: ".exe" on Windows, "" elsewhere. Used to name sibling tools portably.
std::string exeSuffix();

// The ~/.pol directory (global config: sources.toml, environments/). Not created here.
std::filesystem::path polaronHomeDir();

// Resolve the tools the driver needs.
Toolchain locateToolchain();

}  // namespace polaron::driver
