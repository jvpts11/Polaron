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
    bool isMovable = false;  // spec 19.9: field can be moved separately (partitionable class)
    bool isUnique = false;
};
struct MethodInfo {
    std::string returnType;
    bool isStatic = false;
    bool isAbstract = false;
    bool isProperty = false;  // computed get-only property: read as obj.name (no parens)
    std::size_t paramCount = 0;  // declared parameter count (for arg-count checking)
    bool isFinal = false;     // `final` method -- cannot be overridden
    bool isAsync = false;     // spec 20.2: the call site yields a Task<returnType>
    bool isVariadic = false;  // spec 26: an extern C function with a trailing `...` (arg count is open)
    std::vector<std::string> paramTypes;  // declared parameter types (for methodref's function type)
    std::vector<bool> comptimeParams;     // spec 32.4: which params are `comptime` (arg must be const)
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
    bool ctorHasParams = false;        // a constructor with at least one parameter was declared
    std::vector<std::string> ctorParamTypes;  // declared constructor parameter types
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
    std::string ownerClass;  // the class/struct that owns this suffix; "" for namespace-level (legacy)
};

// Type constraints attached to a region by accepts/rejects (spec 17.3).
struct RegionConstraints {
    std::vector<std::string> accepts;  // empty = accepts anything
    std::vector<std::string> rejects;
};

// A custom annotation type (spec 14.3): its fields and which of them are required (no default).
struct AnnotationInfo {
    std::vector<std::pair<std::string, std::string>> fields;  // (name, type), in declaration order
    std::unordered_set<std::string> required;                  // field names without a default
    bool isCompileTimeProcessor = false;
};

// Semantic analysis. Release 0.1 / M4 scope: builds a catalog of classes, finds
// the entry point, and type-checks the body of every method and constructor,
// resolving locals, `this`, fields, methods and `new`.
class SemanticAnalyzer {
public:
    // Analyzes a program. In library mode (compiling a bundle to a .ldb) a missing `main` is allowed:
    // a library has no entry point.
    bool analyze(const ast::Program& program, bool libraryMode = false, bool testMode = false);

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<SemaError>& errors() const { return errors_; }
    const std::vector<SemaError>& warnings() const { return warnings_; }  // non-fatal diagnostics
    const EntryPoint& entryPoint() const { return entry_; }

private:
    void error(std::string message, SourceLocation loc);
    void warn(std::string message, SourceLocation loc);  // records a non-fatal diagnostic
    // Best-effort detection of an obvious infinite loop via comefrom (spec 7.10 rule 7).
    void detectComefromLoops(const ast::Block& block);
    bool isValidMainSignature(const ast::MethodDecl& method) const;

    void registerClasses(const ast::Program& program);
    void registerEnums(const ast::Program& program);
    void registerNewtypes(const ast::Program& program);
    void registerAnnotations(const ast::Program& program);
    void validateAnnotations(const ast::Program& program);
    void checkAnnotationUses(const std::vector<ast::AnnotationUse>& uses);
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
    // `cascade release persistent X` (spec 37.1): mark every persistent field reachable from type
    // `typeName` (through its hierarchy and owned class fields) as released, satisfying spec 18.15.
    void markCascadeReleased(const std::string& typeName, std::unordered_set<std::string>& seen);
    // Collects the names of `label name;` markers in a method body (recursing into nested blocks,
    // but not into lambda bodies, which have their own scope) for chaos-tetrad validation (7.9-7.11).
    void collectMethodLabels(const ast::Block& block);
    void processImports(const ast::Program& program);
    void findEntryPoint(const ast::Program& program);
    void analyzeBodies(const ast::Program& program);
    void analyzeLiteralBodies(const ast::Program& program);
    void analyzeFieldInits(const ast::ClassDecl& cls);
    void analyzeMethodBody(const ast::Block& body, const std::vector<ast::Param>& params,
                           const std::string& thisClass, bool inConstructor,
                           const std::vector<const ast::Expr*>& contracts = {});
    void analyzeBlock(const ast::Block& block);
    // Analyzes an `expecting { ... }` block (spec 30.18) in its own scope and returns the type its
    // `return` produces (the validation value's type). The block's return is its own value, so the
    // enclosing method's return type does not apply.
    std::string analyzeExpectingBlock(const ast::Block* block);
    std::string analyzeYieldBlock(const ast::Block& body);  // match-expr block arm (spec 16.2)
    bool isCompileTimeConstant(const ast::Expr& e) const;   // a literal/const expression (spec 17.10)
    void analyzeStatement(const ast::Stmt& stmt);
    void checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                           SourceLocation loc, const ast::Expr* valueExpr = nullptr);
    // Enforces move discipline when a class value is bound from `rhs`.
    void checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                              SourceLocation loc);
    // Checks a type against a region's accepts/rejects constraints (spec 17.3).
    void checkRegionAccepts(const std::string& region, const std::string& type, SourceLocation loc);
    // A type from another namespace must be imported (or be a primitive / a
    // monomorphized generic). Errors otherwise (namespace visibility).
    void checkTypeAccessible(const std::string& typeName, SourceLocation loc);
    void checkBitCounted(const std::string& typeName, SourceLocation loc);
    void checkIncDecTarget(const ast::Expr& target, bool isIncrement, SourceLocation loc);
    std::string typeOf(const ast::Expr& expr);  // "" on error
    // Type-check call/constructor arguments against declared parameter types (spec 6.4, 3.7):
    // per-argument subtype compatibility and null-safety. `desc` names the callee for messages.
    void checkCallArgs(const std::vector<ast::ExprPtr>& args,
                       const std::vector<std::string>& paramTypes, const std::string& desc);
    // spec 32.4: the argument to a `comptime` parameter must be a compile-time constant.
    bool isConstArg(const ast::Expr& e);
    void checkComptimeArgs(const std::vector<ast::ExprPtr>& args,
                           const std::vector<bool>& comptimeParams, const std::string& desc);
    std::string flattenCallee(const ast::Expr& expr) const;
    const ClassInfo* lookupClass(const std::string& name) const;
    void validateHierarchy();
    void validateOverrides(const ast::Program& program);
    void collectMethodNamesInto(const std::string& className, std::vector<std::string>& out) const;
    // Resolve a member by walking the class, its superclasses and interfaces.
    const FieldInfo* findField(const std::string& className, const std::string& field) const;
    const MethodInfo* findMethod(const std::string& className, const std::string& method,
                                 bool objectFallback = false) const;
    std::vector<std::string> catalogImplementers(const std::string& catalog) const;  // enums of (spec 12.4)
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
    std::vector<SemaError> warnings_;
    EntryPoint entry_;
    std::unordered_map<std::string, ClassInfo> classes_;
    std::unordered_map<std::string, std::vector<std::string>> enums_;  // name -> constants
    // `newtype Name = Underlying;` (spec 24): a distinct nominal type. Maps the newtype name to its
    // underlying type. Distinct for type-checking (no implicit conversion either way), but shares
    // the underlying's representation (codegen) and casts freely to/from it.
    std::unordered_map<std::string, std::string> newtypes_;
    // Custom annotation types (spec 14.3): name -> its fields/required set.
    std::unordered_map<std::string, AnnotationInfo> annotations_;
    // Symbols brought in by `final import` (spec 37.6): they cannot be unimported.
    std::unordered_set<std::string> finalImports_;
    // Chaos tetrad (spec 7.9-7.11): the labels declared in the method being analyzed, and the
    // labels already targeted by a `comefrom` (only one comefrom per label is allowed).
    std::unordered_set<std::string> methodLabels_;
    std::unordered_set<std::string> comefromTargets_;
    std::unordered_map<std::string, CatalogInfo> catalogs_;            // name -> catalog contract
    std::unordered_map<std::string, std::vector<std::string>> enumCatalogs_;  // enum -> catalogs it extends
    // enum -> (method name -> info): methods declared on a catalog-implementing enum.
    std::unordered_map<std::string, std::unordered_map<std::string, MethodInfo>> enumMethods_;
    // enum -> (method name -> declared parameter count), for arg-count checking.
    std::unordered_map<std::string, std::unordered_map<std::string, std::size_t>> enumMethodParams_;
    std::unordered_map<std::string, std::vector<LiteralInfo>> literals_;  // suffix name -> overloads
    // Namespace-level compile-time constants (spec 28.1).
    std::unordered_map<std::string, std::string> constTypes_;     // const name -> type
    std::unordered_map<std::string, long long> constInts_;        // int/bool/char value
    std::unordered_map<std::string, double> constDoubles_;        // float/double value
    // `comptime` methods (spec 28.3), by name, for compile-time call evaluation.
    std::unordered_map<std::string, const ast::MethodDecl*> comptimeMethods_;
    std::unordered_set<std::string> importedSuffixes_;  // literal suffixes in scope via import
    std::unordered_map<std::string, std::vector<std::string>> classSuffixes_;  // class -> its suffix names
    std::unordered_map<std::string, std::string> typeNamespace_;  // type name -> its namespace
    std::unordered_map<std::string, std::string> externReturns_;    // extern fn name -> return type
    std::unordered_map<std::string, std::size_t> externParamCount_;  // extern fn name -> param count
    std::map<std::string, std::vector<std::string>> genericVariance_;  // generic -> per-param variance (spec 15.3)
    std::unordered_set<std::string> qualifiedTypes_;  // namespace-disambiguated names: import-exempt
    std::string currentNamespace_;  // namespace being analyzed (visibility checks)
    bool freestanding_ = false;     // spec 36: no managed-runtime features in this program
    bool libraryMode_ = false;      // compiling a bundle to a .ldb: a missing `main` is allowed
    bool testMode_ = false;         // `ldp3c --test`: a missing `main` is allowed (runner is synthetic)
    std::unordered_set<std::string> currentImports_;  // imported symbol names (current bundle)
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    std::unordered_set<std::string> deleted_;  // locals deleted in this scope (spec 18.2 reattach)
    std::vector<std::string> currentThrows_;  // base names in the method's `throws` clause (spec 21.1)
    std::vector<std::vector<std::string>> catchStack_;  // enclosing try's caught types (base names)
    std::string currentReturnType_;  // declared return type of the method being analyzed (null-safety)
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
