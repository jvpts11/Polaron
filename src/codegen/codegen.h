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
    CodeGenerator(const EntryPoint& entry, std::string_view moduleName);
    ~CodeGenerator();
    CodeGenerator(const CodeGenerator&) = delete;
    CodeGenerator& operator=(const CodeGenerator&) = delete;

    // Builds the module. Returns true on success (no errors, module verified).
    bool generate();

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<CodegenError>& errors() const { return errors_; }

    // The textual LLVM IR (.ll); valid after a successful generate().
    std::string toIR() const;

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
    std::vector<CodegenError> errors_;
};

}  // namespace ldp3
