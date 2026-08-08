#pragma once

#include <array>
#include <cstdint>
#include <memory>
#include <set>
#include <string>
#include <functional>
#include <string_view>
#include <vector>

#include "lexer/token.h"
#include "semantic/analyzer.h"

namespace ldp3 {

struct CodegenError {
    std::string message;
    SourceLocation loc;
};

// Emits LLVM IR for the Release 0.1 walking-skeleton subset: the entry point
// lowered to `i32 @main()`, with System.IO.printf calls lowered to libc
// printf. The LLVM types stay behind a PIMPL so this header is LLVM-free.
class CodeGenerator {
public:
    CodeGenerator(const ast::Program& program, const EntryPoint& entry,
                  std::string_view moduleName);
    ~CodeGenerator();
    CodeGenerator(const CodeGenerator&) = delete;
    CodeGenerator& operator=(const CodeGenerator&) = delete;

    // Sets the LLVM target triple (e.g. "x86_64-unknown-none" for freestanding/bare metal).
    // Call before generate(). Default: none (the host applies its triple).
    void setTargetTriple(const std::string& triple);

    // Library mode: compiling a bundle to a .ldb. No entry point is required and no `main` wrapper is
    // emitted. Call before generate().
    void setLibrary(bool library);

    // How to fetch line `line` of file `file` from the sources compiled this run, or "" when it is
    // not available (the embedded prelude has no file on disk). Used to quote the offending clause
    // in a contract violation, so the message names the rule instead of only its kind. Optional:
    // without it the message keeps the location and drops the quote.
    void setSourceLookup(std::function<std::string(std::string_view, int)> lookup);

    // Test mode (`ldp3c --test`): the entry point is a synthetic runner that calls every [Test] method and
    // reports pass/fail, instead of the program's own `main`. Call before generate().
    void setTestMode(bool test);

    // Debug info (`ldp3c -g`): emit DWARF debug metadata (line tables, functions, local variables) so the
    // compiled program is debuggable by a native debugger (lldb / the Forge debugger). Call before
    // generate(). Best paired with -O0 so variables and line stepping survive.
    void setDebugInfo(bool debug);

    // `ldp3c --verify-stack`: emit, in every method, its own proof that the stack pointer it returns on
    // is the one it was called on. Read once after the prologue, read again before each return, and
    // reported to `__ldp3_stack_mismatch(name)` when they differ.
    //
    // Not a safety net -- an INSTRUMENT, and it exists because of a fault hand-placed probes could not
    // locate: a stack slot came back holding a return address, about one boot in twenty, if and only if
    // an interrupt landed inside the call being made at that moment. Every probe added to find it moved
    // it. Only the compiler knows what the stack pointer is supposed to be at each point, so only the
    // compiler can check it, and doing so is mechanical rather than analysis. Call before generate().
    void setVerifyStack(bool verify);

    // Classes whose dispatch table is patched at runtime (spec 32.8), as found by the analyzer. Such a
    // class always gets a vtable, its calls are never devirtualized, and its vtable is writable -- without
    // which a replacement would be installed where nothing ever reads it. Call before generate().
    void setPatchedClasses(const std::set<std::string>& classes);

    // Seeds the global vtable slot numbering from depended-on bundles (their vtableSlotNames), so a
    // virtual call on an imported object hits the slot its baked-in vtable uses. Call before generate().
    void seedVtableSlots(const std::vector<std::string>& slotNames);

    // Registers a dynamically-loaded bundle (--use-dynamic): its AST name, the .ldb path to load at
    // runtime, and the ABI fingerprint to verify. Its functions become runtime-resolving thunks.
    void addDynamicBundle(const std::string& bundleName, const std::string& ldbPath,
                          const std::array<std::uint8_t, 32>& fingerprint);

    // The global vtable slot layout after generate(): slotNames[i] is the method at slot i. Stored in
    // the .ldb so consumers can seed from it.
    const std::vector<std::string>& vtableSlotNames() const;

    // Builds the module. Returns true on success (no errors, module verified).
    bool generate();

    // Runs ldp3c's own optimization pipeline on the module (level 1-3; 0 is a no-op). This is the
    // LDP3 middle-end: an LLVM PassBuilder per-module pipeline plus the custom passes clang's
    // default pipeline omits. Call after generate(); clang still does backend codegen and linking.
    void optimize(int level);

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<CodegenError>& errors() const { return errors_; }

    // The textual LLVM IR (.ll); valid after a successful generate().
    std::string toIR() const;

    // The compiled module as LLVM bitcode -- the .ldb "CODE" section. Bitcode keeps cross-bundle
    // optimization possible (static LTO / dynamic JIT). Valid after a successful generate().
    std::string toBitcode() const;

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
    std::vector<CodegenError> errors_;
};

}  // namespace ldp3
