#pragma once

#include <memory>
#include <string>
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

    // Seeds the global vtable slot numbering from depended-on bundles (their vtableSlotNames), so a
    // virtual call on an imported object hits the slot its baked-in vtable uses. Call before generate().
    void seedVtableSlots(const std::vector<std::string>& slotNames);

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
