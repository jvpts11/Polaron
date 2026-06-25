#pragma once

#include <map>
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
    bool isStackObject = false;  // bound to a `new ... on stack` class value (RAII; not throwable)
};

// Class members collected in pass 1, for name resolution / type checking.
struct FieldInfo {
    std::string type;
    bool isMutable = false;
    bool isStatic = false;
};
struct MethodInfo {
    std::string returnType;
    bool isStatic = false;
    bool isAbstract = false;
    bool isProperty = false;  // computed get-only property: read as obj.name (no parens)
    std::size_t paramCount = 0;  // declared parameter count (for arg-count checking)
    bool isFinal = false;     // `final` method -- cannot be overridden
    bool isAsync = false;     // spec 20.2: the call site yields a Task<returnType>
};
struct ClassInfo {
    std::string name;
    std::unordered_map<std::string, FieldInfo> fields;
    std::unordered_map<std::string, MethodInfo> methods;
    std::string superclass;               // "" when none
    std::vector<std::string> interfaces;
    bool isAbstract = false;
    bool isFinal = false;    // `final class` -- cannot be extended
    bool isInterface = false;
    bool isStruct = false;   // value type, no inheritance
    bool isSealed = false;   // only `permits` types may extend it
    bool isMovable = false;  // move discipline
    bool isUnique = false;   // single-live-reference discipline
    bool isPartitionable = false;  // fields movable separately (spec 19.9)
    bool hasConstructor = false;
    bool hasDestructor = false;
    std::vector<std::string> permits;  // sealed permits list
};

// A catalog (spec 12.3): an interface for enums. Records the values an
// implementing enum must provide, the names of methods it must implement, and
// any catalogs this one extends (catalogs can extend catalogs).
struct CatalogInfo {
    std::vector<std::string> requiredValues;
    std::vector<std::string> methodNames;
    std::vector<std::string> extendsCatalogs;
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
    void registerCatalogs(const ast::Program& program);
    void validateCatalogs(const ast::Program& program);
    void registerLiterals(const ast::Program& program);
    void registerConsts(const ast::Program& program);   // pass 1: const name -> type
    void registerComptimeMethods(const ast::Program& program);  // index `comptime` methods
    void evaluateConsts(const ast::Program& program);    // pass 2: fold + validate
    void registerPersistentFields(const ast::Program& program);  // spec 18.15
    void checkPersistentReleases();                              // spec 18.15 obligation
    // The class in `cls`'s hierarchy that declares persistent field `field` (or "").
    std::string persistentFieldOwner(const std::string& cls, const std::string& field) const;
    void processImports(const ast::Program& program);
    void findEntryPoint(const ast::Program& program);
    void analyzeBodies(const ast::Program& program);
    void analyzeLiteralBodies(const ast::Program& program);
    void analyzeFieldInits(const ast::ClassDecl& cls);
    void analyzeMethodBody(const ast::Block& body, const std::vector<ast::Param>& params,
                           const std::string& thisClass, bool inConstructor,
                           const std::vector<const ast::Expr*>& contracts = {});
    void analyzeBlock(const ast::Block& block);
    void analyzeStatement(const ast::Stmt& stmt);
    void checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                           SourceLocation loc);
    // Enforces move discipline when a class value is bound from `rhs`.
    void checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                              SourceLocation loc);
    // Checks a type against a region's accepts/rejects constraints (spec 17.3).
    void checkRegionAccepts(const std::string& region, const std::string& type, SourceLocation loc);
    // A type from another namespace must be imported (or be a primitive / a
    // monomorphized generic). Errors otherwise (namespace visibility).
    void checkTypeAccessible(const std::string& typeName, SourceLocation loc);
    void checkBitCounted(const std::string& typeName, SourceLocation loc);
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
    // True if `sub` is `super` or transitively extends/implements it. `depth`
    // bounds the recursion so a malformed (cyclic) type graph can't overflow.
    bool isSubtype(const std::string& sub, const std::string& super, int depth = 0) const;
    // True if the class participates in a hierarchy (abstract/interface, has a super/
    // interface, or is extended/implemented elsewhere) -- so it carries a vtable and
    // can be matched by dynamic type in a catch.
    bool isPolymorphic(const std::string& name) const;

    // Lexical scopes (innermost last); shadowing is forbidden.
    void pushScope();
    void popScope();
    const LocalVar* lookupLocal(const std::string& name) const;
    void declareLocal(const std::string& name, LocalVar info);

    std::vector<SemaError> errors_;
    EntryPoint entry_;
    std::unordered_map<std::string, ClassInfo> classes_;
    std::unordered_map<std::string, std::vector<std::string>> enums_;  // name -> constants
    std::unordered_map<std::string, CatalogInfo> catalogs_;            // name -> catalog contract
    std::unordered_map<std::string, std::vector<std::string>> enumCatalogs_;  // enum -> catalogs it extends
    // enum -> (method name -> info): methods declared on a catalog-implementing enum.
    std::unordered_map<std::string, std::unordered_map<std::string, MethodInfo>> enumMethods_;
    // enum -> (method name -> declared parameter count), for arg-count checking.
    std::unordered_map<std::string, std::unordered_map<std::string, std::size_t>> enumMethodParams_;
    std::unordered_map<std::string, LiteralInfo> literals_;  // suffix name -> info
    // Namespace-level compile-time constants (spec 28.1).
    std::unordered_map<std::string, std::string> constTypes_;     // const name -> type
    std::unordered_map<std::string, long long> constInts_;        // int/bool/char value
    std::unordered_map<std::string, double> constDoubles_;        // float/double value
    // `comptime` methods (spec 28.3), by name, for compile-time call evaluation.
    std::unordered_map<std::string, const ast::MethodDecl*> comptimeMethods_;
    std::unordered_set<std::string> importedSuffixes_;  // literal suffixes in scope via import
    std::unordered_map<std::string, std::string> typeNamespace_;  // type name -> its namespace
    std::unordered_map<std::string, std::string> externReturns_;    // extern fn name -> return type
    std::unordered_map<std::string, std::size_t> externParamCount_;  // extern fn name -> param count
    std::map<std::string, std::vector<std::string>> genericVariance_;  // generic -> per-param variance (spec 15.3)
    std::unordered_set<std::string> qualifiedTypes_;  // namespace-disambiguated names: import-exempt
    std::string currentNamespace_;  // namespace being analyzed (visibility checks)
    bool freestanding_ = false;     // spec 36: no managed-runtime features in this program
    std::unordered_set<std::string> currentImports_;  // imported symbol names (current bundle)
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    bool inConstructor_ = false;  // immutable fields may be initialized here
    std::unordered_set<std::string> moved_;  // variables in the "moved" state
    std::unordered_map<std::string, RegionConstraints> regionConstraints_;  // region var -> accepts/rejects
    // Persistent fields (spec 18.15): each must be released somewhere unless eternal.
    struct PersistentFieldInfo {
        std::string cls;
        std::string name;
        bool isEternal = false;
        SourceLocation loc;
    };
    std::vector<PersistentFieldInfo> persistentFields_;
    std::unordered_set<std::string> releasedPersistents_;  // "Class.field" released anywhere
    std::vector<std::unordered_map<std::string, LocalVar>> scopes_;
};

}  // namespace ldp3
