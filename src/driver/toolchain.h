#pragma once
#include <filesystem>
#include <string>

namespace polaron::driver {

struct Toolchain {
    std::string polc;       // low-level compiler (sibling of this exe, or $POLC)
    std::string clang;       // compiler/linker driver ($POLARON_CLANG, PATH, or compile-time default)
    std::string runtimeLib;  // polaron_rt.lib (sibling of this exe, or $POLARON_RUNTIME)
    // THE SAME RUNTIME FOR A 32-BIT MACHINE, and a separate field because a linker will not mix the
    // two: an i686 program linked against the x86-64 `polaron_rt.lib` fails with every runtime symbol
    // undefined, which reads as a broken install rather than as the wrong architecture.
    //
    // Empty when this install carries none (building it needs clang and llvm-lib). The driver refuses
    // an i686 target then, and names the missing piece at the moment somebody asks for it.
    std::string runtimeLib32;  // polaron_rt32.lib, or ""
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
    // The PE/COFF linker, for `image = "efi"`. A UEFI application is a PE32+ executable -- the
    // firmware runs the same loader Windows does -- so ld.lld cannot produce one, and the linker
    // script the ELF path generates means nothing to it.
    //
    // A SEPARATE FIELD FROM `lldLink`, which names the same executable. `lldLink` is set only when a
    // self-contained install is found beside the driver, and the hosted link path reads it as "there
    // is a bundle here, link against its CRT". Filling it in for an EFI build would turn that on.
    // Same tool, two questions, two fields.
    std::string coffLd;      // lld-link (sibling of clang, or $POLARON_LLD_LINK) -- EFI images
    std::string objcopy;     // llvm-objcopy (sibling of clang, or $POLARON_OBJCOPY) -- flat/binary images
    std::string xorriso;     // xorriso (PATH or $POLARON_XORRISO) -- bootable .iso images; may be ""
    // WHERE VISUAL STUDIO'S C TOOLCHAIN IS, because clang cannot always find it and does not say so.
    //
    // Measured 2026-08-27, clang 22.1.8 against Visual Studio 18: clang finds the Windows SDK and
    // does NOT find VS, then passes the library paths it would have built from it anyway --
    // `-libpath:lib\amd64` and `-libpath:atlmfc\lib\amd64`, RELATIVE, with the root it never found
    // simply absent. The link then fails with
    //
    //     lld-link: error: could not open 'msvcprt.lib': no such file or directory
    //
    // which reads like a broken toolchain and is a failed lookup. It works inside a `vcvars64` shell
    // only because that sets LIB, and a search path from the environment covers for the missing root
    // by accident.
    //
    // Filled in by `findVcTools()` and handed to clang as `-vctoolsdir=`. Empty on non-Windows, and
    // empty on a Windows machine with no Visual Studio -- where a bundled install (`libDir`) is the
    // supported configuration and this is not wanted.
    std::string vcToolsDir;
};

// Directory containing the running polaron executable.
std::filesystem::path exeDir();

// Platform executable suffix: ".exe" on Windows, "" elsewhere. Used to name sibling tools portably.
std::string exeSuffix();

// The ~/.pol directory (global config: sources.toml, environments/). Not created here.
std::filesystem::path polaronHomeDir();

// Resolve the tools the driver needs.
Toolchain locateToolchain();

// Visual Studio's C toolchain directory (`.../VC/Tools/MSVC/<version>`), or "" when there is none --
// which is every non-Windows machine, and a Windows machine with no Visual Studio. See the note on
// `Toolchain::vcToolsDir` for why the driver has to find this rather than leaving it to clang.
//
// Exposed rather than kept private so `polaron --version` and a future `polaron doctor` can report
// what was found: "clang cannot see your Visual Studio" is a sentence a person can act on, and it is
// the one this whole lookup exists to stop them having to work out for themselves.
std::string findVcTools();

}  // namespace polaron::driver
