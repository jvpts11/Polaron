#pragma once

#include <string>
#include <unordered_map>
#include <vector>

#include "lexer/token.h"
#include "parser/ast.h"

namespace ldp3 {

// A semantic diagnostic with location.
struct SemaError {
    std::string message;
    SourceLocation loc;
};

// The validated program entry point: the chain bundle -> namespace ->
// public class Main -> public static method main(string[]) returns void/int.
struct EntryPoint {
    const ast::MethodDecl* method = nullptr;
    std::string qualifiedName;  // e.g. "main.app.Main.main"
};

// Semantic analysis. Release 0.1 / walking-skeleton scope: validate that the
// program has exactly one well-formed entry point. Symbol tables, scope
// resolution and full type checking arrive from M2 onward.
class SemanticAnalyzer {
public:
    // Returns true when analysis found no errors. On success, entryPoint() is
    // populated.
    bool analyze(const ast::Program& program);

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<SemaError>& errors() const { return errors_; }
    const EntryPoint& entryPoint() const { return entry_; }

private:
    void error(std::string message, SourceLocation loc);
    bool isValidMainSignature(const ast::MethodDecl& method) const;

    // M2: walk the entry-point body resolving variables and checking types.
    void analyzeMethodBody(const ast::MethodDecl& method);
    void analyzeStatement(const ast::Stmt& stmt);
    std::string typeOf(const ast::Expr& expr);  // "" on error
    std::string flattenCallee(const ast::Expr& expr) const;

    std::vector<SemaError> errors_;
    EntryPoint entry_;
    std::unordered_map<std::string, std::string> locals_;  // name -> type (single scope)
};

}  // namespace ldp3
