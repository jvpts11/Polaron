#pragma once

#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "lexer/token.h"
#include "parser/ast.h"

namespace ldp3 {

// A semantic diagnostic with location.
struct SemaError {
    std::string message;
    SourceLocation loc;
};

// The validated program entry point.
struct EntryPoint {
    const ast::MethodDecl* method = nullptr;
    std::string qualifiedName;  // e.g. "main.app.Main.main"
};

// A local variable (or parameter) in the current method scope.
struct LocalVar {
    std::string type;
    bool isMutable = false;
};

// Class members collected in pass 1, for name resolution / type checking.
struct FieldInfo {
    std::string type;
    bool isMutable = false;
};
struct MethodInfo {
    std::string returnType;
    bool isStatic = false;
    bool isAbstract = false;
};
struct ClassInfo {
    std::string name;
    std::unordered_map<std::string, FieldInfo> fields;
    std::unordered_map<std::string, MethodInfo> methods;
    std::string superclass;               // "" when none
    std::vector<std::string> interfaces;
    bool isAbstract = false;
    bool isInterface = false;
    bool isStruct = false;   // value type, no inheritance
    bool isMovable = false;  // move discipline
    bool isUnique = false;   // single-live-reference discipline
    bool hasConstructor = false;
    bool hasDestructor = false;
};

// A namespace-level `comptime literal` suffix function (spec 17.10).
struct LiteralInfo {
    std::string paramType;
    std::string returnType;
    bool isComptime = false;
    SourceLocation loc;
};

// Type constraints attached to a region by accepts/rejects (spec 17.3).
struct RegionConstraints {
    std::vector<std::string> accepts;  // empty = accepts anything
    std::vector<std::string> rejects;
};

// Semantic analysis. Release 0.1 / M4 scope: builds a catalog of classes, finds
// the entry point, and type-checks the body of every method and constructor,
// resolving locals, `this`, fields, methods and `new`.
class SemanticAnalyzer {
public:
    bool analyze(const ast::Program& program);

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<SemaError>& errors() const { return errors_; }
    const EntryPoint& entryPoint() const { return entry_; }

private:
    void error(std::string message, SourceLocation loc);
    bool isValidMainSignature(const ast::MethodDecl& method) const;

    void registerClasses(const ast::Program& program);
    void registerEnums(const ast::Program& program);
    void registerLiterals(const ast::Program& program);
    void processImports(const ast::Program& program);
    void findEntryPoint(const ast::Program& program);
    void analyzeBodies(const ast::Program& program);
    void analyzeLiteralBodies(const ast::Program& program);
    void analyzeFieldInits(const ast::ClassDecl& cls);
    void analyzeMethodBody(const ast::Block& body, const std::vector<ast::Param>& params,
                           const std::string& thisClass, bool inConstructor);
    void analyzeBlock(const ast::Block& block);
    void analyzeStatement(const ast::Stmt& stmt);
    void checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                           SourceLocation loc);
    // Enforces move discipline when a class value is bound from `rhs`.
    void checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                              SourceLocation loc);
    // Checks a type against a region's accepts/rejects constraints (spec 17.3).
    void checkRegionAccepts(const std::string& region, const std::string& type, SourceLocation loc);
    void checkIncDecTarget(const ast::Expr& target, SourceLocation loc);
    std::string typeOf(const ast::Expr& expr);  // "" on error
    std::string flattenCallee(const ast::Expr& expr) const;
    const ClassInfo* lookupClass(const std::string& name) const;
    void validateHierarchy();
    void validateOverrides(const ast::Program& program);
    void collectMethodNamesInto(const std::string& className, std::vector<std::string>& out) const;
    // Resolve a member by walking the class, its superclasses and interfaces.
    const FieldInfo* findField(const std::string& className, const std::string& field) const;
    const MethodInfo* findMethod(const std::string& className, const std::string& method) const;
    // True if `sub` is `super` or transitively extends/implements it.
    bool isSubtype(const std::string& sub, const std::string& super) const;

    // Lexical scopes (innermost last); shadowing is forbidden.
    void pushScope();
    void popScope();
    const LocalVar* lookupLocal(const std::string& name) const;
    void declareLocal(const std::string& name, LocalVar info);

    std::vector<SemaError> errors_;
    EntryPoint entry_;
    std::unordered_map<std::string, ClassInfo> classes_;
    std::unordered_map<std::string, std::vector<std::string>> enums_;  // name -> constants
    std::unordered_map<std::string, LiteralInfo> literals_;  // suffix name -> info
    std::unordered_set<std::string> importedSuffixes_;  // literal suffixes in scope via import
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    bool inConstructor_ = false;  // immutable fields may be initialized here
    std::unordered_set<std::string> moved_;  // variables in the "moved" state
    std::unordered_map<std::string, RegionConstraints> regionConstraints_;  // region var -> accepts/rejects
    std::vector<std::unordered_map<std::string, LocalVar>> scopes_;
};

}  // namespace ldp3
