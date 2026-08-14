#pragma once

#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "diag/diagnostic.h"
#include "lexer/token.h"
#include "parser/ast.h"

namespace polaron {

// A semantic diagnostic with location.
struct SemaError {
    std::string message;
    SourceLocation loc;
    diag::Code code = diag::Code::None;  // the rich-diagnostic code, or None for an un-migrated one-liner
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
    // Bound to a `new ... on heap`. Note this is NOT the same question as "is the type a pointer":
    // `Car c = new Car() on heap;` has type `Car` and owns heap memory, while `Result<int,int> v = ...`
    // has a class type and owns none. Only the first makes `delete` actually free something -- which is
    // what decides whether reading the name afterwards is a use-after-free or a documented no-op.
    bool isHeapObject = false;
    // Declared without an initializer (`int x;`). Its FIRST assignment initializes it, so that write is
    // allowed even on a non-mutable binding: the value is still written exactly once, which is what
    // "immutable" actually promises. Every later write is an ordinary assignment and needs `mutable`.
    bool deferredInit = false;
};

// What the compiler knows about a variable AT A POINT IN THE PROGRAM, as opposed to what its declaration
// says. This is the state the guide has always described (05-memory-and-ownership.md:640) and the
// implementation never had -- it took the shortcut of forbidding uninitialized variables in the PARSER,
// so the state could not arise and nothing had to track it.
//
// One machine for all four facts, because they are the same question asked about different properties and
// every one of them needs the same three operations: save/restore across a scope, join at a branch merge,
// and invalidate on a loop back-edge. Written separately they would be three subtly different traversals
// that disagree at the edges.
struct FlowFacts {
    // Definite assignment. `T x;` starts Uninit and reading it there is an error. Assigned on only one
    // side of an `if`, it joins to Maybe -- still an error to read, but a different message, because
    // "initialized in one branch" is a different mistake from "never initialized".
    enum class Init { Uninit, Maybe, Init };
    std::unordered_map<std::string, Init> init;
    // Names PROVEN non-null here by a check the compiler could verify. A proof lives only as long as
    // nothing can falsify it: assigning to the name kills it, and so does a loop back-edge.
    std::unordered_set<std::string> nonNull;
    // Ownership, kept here rather than in flat sets so it saves, restores and joins with everything else.
    std::unordered_set<std::string> moved;
    std::unordered_set<std::string> deleted;
    // Deleted AND actually freed. `deleted` exists for the spec-18.2 redeclaration rule and
    // includes no-op deletes; only this one means reading the name reads freed memory.
    std::unordered_set<std::string> freed;
};

// Class members collected in pass 1, for name resolution / type checking.
struct FieldInfo {
    std::string type;
    bool isMutable = false;
    bool isStatic = false;
    bool isMovable = false;  // spec 19.9: field can be moved separately (partitionable class)
    bool isUnique = false;
    int bitWidth = 0;  // spec 11.1: declared bit-field width, 0 for an ordinary field. A field with one
                       // shares a storage unit with its neighbours and therefore HAS NO ADDRESS.
    // spec 37.5. Read by the interrupt check: `volatile` is one of the two ways to say "something
    // that can preempt me also touches this", and a handler may only reach state said to be shared.
    bool isVolatile = false;
    // THE WORD THE AUTHOR WROTE, and where they wrote it. Both were missing, which is why `private`
    // was enforced nowhere: the check was not merely absent, the information never reached the table
    // the analyzer consults. It is parsed, carried in the AST, written into the `.polh` and printed
    // in the generated documentation -- and stopped here.
    //
    // `owner` is the class that DECLARED the member, which is not the class the access was written
    // against: `protected` is answered by walking up from the accessing class to the declaring one,
    // and an inherited private member is private to where it was written, not to where it was found.
    std::string visibility;
    std::string owner;
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
    std::vector<std::string> paramNames;  // spec 22.4: for matching named arguments at the call site
    std::vector<bool> namedOnlyParams;    // spec 22.4: `requires named` -- must be passed by name
    // spec 19.6: `move T` on a parameter or return type. Carried as its own flag because
    // canonicalType() flattens a TypeRef to a string and drops it -- which is why this annotation
    // parsed and then meant nothing for as long as it existed.
    std::vector<bool> moveParams;
    bool returnIsMove = false;
    bool isDeprecated = false;            // spec 14.2: each call site gets a warning
    // `public interrupt(Trap t) returns void { }` -- entered by the hardware, never called. Read at
    // two places only: the call site, which must refuse it, and `obj.interrupt`, which is how it is
    // installed and yields an `address` rather than anything callable.
    bool isInterrupt = false;
    // See FieldInfo: the word the author wrote, and the class that declared it. Absent from this
    // struct for as long as it existed, which is the whole of why `private` denied nobody.
    std::string visibility;
    std::string owner;
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
    // `region class` (docs/design/region-classes.md): every instance comes from one region owned by
    // the type. Carried here because INHERITANCE has to be checked against it -- a plain class beneath
    // a region class would put its instances outside the region, and totality is the whole feature.
    bool isRegionClass = false;
    bool isMovable = false;  // move discipline
    bool isUnique = false;   // single-live-reference discipline
    bool isPartitionable = false;  // fields movable separately (spec 19.9)
    bool hasConstructor = false;
    bool hasDestructor = false;
    bool ctorHasParams = false;        // a constructor with at least one parameter was declared
    std::vector<std::string> ctorParamTypes;  // declared constructor parameter types
    // The word on the constructor. A `private constructor` is how a type says "not by `new`" -- the
    // singleton, the factory, the type built only through its own static maker -- and it meant nothing
    // for the same reason every other member's visibility did: it never left the AST.
    std::string ctorVisibility;
    std::vector<std::string> permits;  // sealed permits list
    // Where this type was declared. Kept so a SECOND declaration of the same simple name can be
    // reported against the one the author wrote, rather than wherever the displaced type happened to
    // be used -- which, when the displaced one is a stdlib type, is somewhere inside the prelude.
    SourceLocation declLoc;
    bool fromPrelude = false;
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
    // Analyzes a program. In library mode (compiling a bundle to a .polb) a missing `main` is allowed:
    // a library has no entry point.
    bool analyze(const ast::Program& program, bool libraryMode = false, bool testMode = false);

    // Enable the region binder (--region-binder): static, zero-runtime temporal-safety checks that reject
    // storing a reference to a shorter-lived object into a longer-lived location (the dangling store).
    void setRegionBinder(bool on) { regionBinder_ = on; }

    bool hasErrors() const { return !errors_.empty(); }
    // Classes whose dispatch table is patched at runtime (spec 32.8). Codegen must give them a vtable
    // and never devirtualize their calls, or a replacement would not be seen at the call sites.
    const std::set<std::string>& patchedClasses() const { return patchedClasses_; }
    const std::vector<SemaError>& errors() const { return errors_; }
    const std::vector<SemaError>& warnings() const { return warnings_; }  // non-fatal diagnostics
    const EntryPoint& entryPoint() const { return entry_; }

private:
    void error(std::string message, SourceLocation loc);
    void warn(std::string message, SourceLocation loc);  // records a non-fatal diagnostic
    // Rich variants: attach a diagnostic code so the driver can print why / how-to-fix / how-to-prevent
    // from the catalog. The message is still the specific one-line title (it names the actual thing).
    void error(diag::Code code, std::string message, SourceLocation loc);
    void warn(diag::Code code, std::string message, SourceLocation loc);
    // Best-effort detection of an obvious infinite loop via comefrom (spec 7.10 rule 7).
    void detectComefromLoops(const ast::Block& block);
    bool isValidMainSignature(const ast::MethodDecl& method) const;

    void registerClasses(const ast::Program& program);
    void registerEnums(const ast::Program& program);
    void registerNewtypes(const ast::Program& program);
    void registerAnnotations(const ast::Program& program);
    void validateAnnotations(const ast::Program& program);
    // spec 32.11: the test declarations are well formed. Here rather than in the --test codegen so a
    // malformed test is caught by `polaron build` and by the editor's `polaron check`, not only on the day
    // someone runs the suite -- a test that silently does not run is the one failure mode a test
    // framework must never have.
    void validateTestDeclarations(const ast::Program& program);
    void collectFixtureOwners(const ast::Program& program);
    void validateTestCases(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                           const ast::AnnotationUse* cases, const std::string& sym);
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
    // `postconditions` are checked with `result` in scope, typed `postResultType` (spec 29): a
    // postcondition on a value-returning method has to be able to say something about the value.
    // Empty for a void method, a constructor or an invariant -- there `result` is not in scope, and
    // using it is an undeclared name like any other. They are separate from `contracts` (the
    // preconditions and invariants) precisely so `requires` does NOT see it: a precondition runs on
    // entry, when there is no result yet.
    void analyzeMethodBody(const ast::Block& body, const std::vector<ast::Param>& params,
                           const std::string& thisClass, bool inConstructor,
                           const std::vector<const ast::Expr*>& contracts = {},
                           const std::vector<const ast::Expr*>& postconditions = {},
                           const std::string& postResultType = "");
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
    // Enforces move discipline wherever a class value is bound from `rhs`: a declaration, an
    // assignment to a variable OR a field, a call argument, a return. `what` names the destination
    // so the fix reads right at each of them.
    void checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                              SourceLocation loc, const std::string& what);
    // The advice tail for an address/integer mismatch; empty when that is not the mismatch.
    std::string addressHint(const std::string& from, const std::string& to) const;
    // True if `className` owns a `unique` field, directly, through a superclass, or through a value
    // sub-object -- such an object may not be value-copied (spec 19.2).
    bool classHasUniqueField(const std::string& className);
    // Checks a type against a region's accepts/rejects constraints (spec 17.3).
    void checkRegionAccepts(const std::string& region, const std::string& type, SourceLocation loc);
    // A type from another namespace must be imported (or be a primitive / a
    // monomorphized generic). Errors otherwise (namespace visibility).
    void checkTypeAccessible(const std::string& typeName, SourceLocation loc);
    // MEMBER visibility, the half that was never checked. TYPE visibility has been enforced since the
    // import model landed, which is exactly what made this hole easy to miss: the word works at one
    // level and not the other, so `private` read as meaningful everywhere it was written.
    //
    // `kind` is the noun for the message ("method", "field"); `visibility` and `owner` come off the
    // member's own record. Silent for a member that is reachable.
    void checkMemberAccessible(const std::string& kind, const std::string& member,
                               const std::string& visibility, const std::string& owner,
                               SourceLocation loc);
    // Whether `sub` is `base` or inherits from it -- the question `protected` asks.
    bool inheritsFrom(const std::string& sub, const std::string& base) const;
    // cast<Wide>(narrow arithmetic): the bits are gone before the cast runs. See the definition.
    void checkWideningLostBits(const ast::CastExpr& cst, const std::string& src,
                               const std::string& dst);
    void checkBitCounted(const std::string& typeName, SourceLocation loc);
    // Why a standard-library name cannot exist bare metal, or "" when it can. The list is deliberately
    // short: only what reaches for a host OPERATING SYSTEM is on it. See the definition.
    static std::string hostedOnlyReason(const std::string& symbol);
    void checkIncDecTarget(const ast::Expr& target, bool isIncrement, SourceLocation loc);
    std::string typeOf(const ast::Expr& expr);  // "" on error
    // Type-check call/constructor arguments against declared parameter types (spec 6.4, 3.7):
    // per-argument subtype compatibility and null-safety. `desc` names the callee for messages.
    // `moveParams` is spec 19.6's `move T` per parameter, when the callee is known. Optional because
    // a constructor and a methodref reach here without a MethodInfo to read it from.
    void checkCallArgs(const std::vector<ast::ExprPtr>& args,
                       const std::vector<std::string>& paramTypes, const std::string& desc,
                       const std::vector<bool>* moveParams = nullptr);
    // spec 32.4: the argument to a `comptime` parameter must be a compile-time constant.
    bool isConstArg(const ast::Expr& e);
    void checkComptimeArgs(const std::vector<ast::ExprPtr>& args,
                           const std::vector<bool>& comptimeParams, const std::string& desc);
    // spec 22.4: reorder a call's named arguments into parameter order (and enforce `requires named`).
    void bindNamedArgs(ast::CallExpr* call, const std::vector<std::string>& paramNames,
                       const std::vector<bool>& namedOnly, const std::string& desc);
    std::string flattenCallee(const ast::Expr& expr) const;
    const ClassInfo* lookupClass(const std::string& name) const;
    // Candidate names for a "did you mean?" suggestion on a name error. namesInScope: everything usable
    // as a bare identifier right here (locals, namespace constants, the current enum's constants).
    // fieldNames: every field of a class, walking its superclasses.
    std::vector<std::string> namesInScope() const;
    std::vector<std::string> fieldNames(const std::string& className) const;
    void validateHierarchy();
    void validateOverrides(const ast::Program& program);
    void collectMethodNamesInto(const std::string& className, std::vector<std::string>& out) const;
    // Resolve a member by walking the class, its superclasses and interfaces.
    const FieldInfo* findField(const std::string& className, const std::string& field) const;
    const MethodInfo* findMethod(const std::string& className, const std::string& method,
                                 bool objectFallback = false) const;
    // spec 32.8 mutable dispatch tables. dispatchTableClass returns the class name when `expr` is a
    // `<Class>.methods` reference (else ""); checkMethodPatch validates a `.replace(name, fn)` on it and
    // records the class, which codegen needs (a patched class always dispatches through its vtable).
    void warnClassPointerArith(const std::string& ptrType, SourceLocation loc);  // spec 27
    std::string dispatchTableClass(const ast::Expr& expr) const;
    std::string checkMethodPatch(const std::string& className, const ast::CallExpr& call);
    std::vector<std::string> catalogImplementers(const std::string& catalog) const;  // enums of (spec 12.4)
    // True if `sub` is `super` or transitively extends/implements it. `depth`
    // bounds the recursion so a malformed (cyclic) type graph can't overflow.
    bool isSubtype(const std::string& sub, const std::string& super, int depth = 0) const;
    // True if the class participates in a hierarchy (abstract/interface, has a super/
    // interface, or is extended/implemented elsewhere) -- so it carries a vtable and
    // can be matched by dynamic type in a catch.
    bool isPolymorphic(const std::string& name) const;
    // Whether a type declares itself safe to reach from several threads at once (implements
    // System.Concurrency.Shared) -- the one way a program's own type may cross a thread boundary.
    bool declaresShared(const std::string& name) const;

    // Lexical scopes (innermost last); shadowing is forbidden.
    void pushScope();
    void popScope();
    const LocalVar* lookupLocal(const std::string& name) const;
    void declareLocal(const std::string& name, LocalVar info);

    // ---- flow-sensitive facts (see FlowFacts) ----
    FlowFacts snapshotFlow() const;
    void restoreFlow(const FlowFacts& f);
    // Merge two branch outcomes into the state after the branch. A fact survives only if it holds on
    // BOTH paths -- that is what makes the analysis sound rather than optimistic: a proof established in
    // the `then` arm says nothing about the program that took the `else`.
    void joinFlow(const FlowFacts& a, const FlowFacts& b);
    // A loop body may run again, so any proof its own body can falsify must not survive to the top. The
    // cheap and correct answer is to drop what the body could have changed, which is what this does.
    void invalidateAcrossBackEdge(const FlowFacts& before);
    FlowFacts::Init initStateOf(const std::string& name) const;
    void markInitialized(const std::string& name);
    // Called on every write to `name`: a stored proof of non-nullness is only about the value that WAS
    // there. This is the invalidation João asked for -- the reason a narrowing cannot derail a program.
    void killProofsFor(const std::string& name);
    // Every path out of this block leaves it (return/throw/break/continue), so it contributes nothing to
    // the state after the branch -- which is what makes a guard clause narrow the code below it.
    static bool blockAlwaysExits(const ast::Block& b);
    // What a null test proves, and for which arm. Only unambiguous shapes are recognised; being
    // incomplete costs a cast, being wrong would cost the guarantee.
    void proofFromCondition(const ast::Expr& cond, std::string& provenThen, std::string& provenElse);

    std::vector<SemaError> errors_;
    std::vector<SemaError> warnings_;
    EntryPoint entry_;
    std::unordered_map<std::string, ClassInfo> classes_;
    // The class being analyzed, so a delegating call inside a constructor can be followed into the
    // callee's own body and discharge only the fields it really assigns.
    const ast::ClassDecl* currentClassDecl_ = nullptr;
    const ast::Block* methodBodyInCurrentClass(const std::string& name) const;
    void collectFieldsAssigned(const ast::Block* body, std::set<std::string>& assigned,
                               std::set<std::string>& visited) const;
    std::unordered_map<std::string, std::vector<std::string>> enums_;  // name -> constants
    // The enums declared `sealed` (spec 12/16). An enum's constants are a closed list either way;
    // sealing it says a `match` must COVER them, so a constant added later is reported at every
    // match that forgot it rather than swallowed by a `default`.
    std::set<std::string> sealedEnums_;
    std::unordered_set<std::string> javaEnums_;  // enums with fields/methods (spec 12.2), orderable by ordinal
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
    std::unordered_map<std::string, std::string> typeBundle_;     // type name -> its bundle (import validation)
    std::unordered_map<std::string, std::string> namespaceBundle_;  // namespace name -> its bundle
    std::unordered_set<std::string> bundleNames_;                 // every declared/imported bundle name
    std::unordered_map<std::string, std::string> externReturns_;    // extern fn name -> return type
    std::unordered_map<std::string, std::size_t> externParamCount_;  // extern fn name -> param count
    std::map<std::string, std::vector<std::string>> genericVariance_;  // generic -> per-param variance (spec 15.3)
    std::unordered_set<std::string> qualifiedTypes_;  // namespace-disambiguated names: import-exempt
    std::string currentNamespace_;  // namespace being analyzed (visibility checks)
    std::string currentBundle_;     // bundle being analyzed (stdlib-cohesion visibility)
    bool freestanding_ = false;     // spec 36: no managed-runtime features in this program
    bool regionBinder_ = false;     // --region-binder: static escape checks (Rust-level temporal safety)
    bool libraryMode_ = false;      // compiling a bundle to a .polb: a missing `main` is allowed
    bool testMode_ = false;         // `polc --test`: a missing `main` is allowed (runner is synthetic)
    std::unordered_set<std::string> currentImports_;  // imported symbol names (current bundle)
    // spec 32.11: the classes that declare a [BeforeAll]/[AfterAll] fixture, and whether the method
    // being analyzed is a [Test] (or one of the per-test hooks around it). A test that reaches into
    // ANOTHER class's fixture reads state whose lifetime it does not control -- see the warning at the
    // static-call site.
    std::unordered_set<std::string> fixtureOwners_;
    std::unordered_set<std::string> fixtureWarned_;  // "Reader.method|Owner", warned once each
    bool inTestMethod_ = false;
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    std::string enclosingClass_;  // class the current method belongs to, set even for static methods
                                  // (unlike currentClass_) -- used to point unqualified calls at their owner

    // ---- the interrupt reachability check (rules 2 and 3 of docs/design/interrupt.md) ----
    //
    // An interrupt's rules are about what its body REACHES, not about the body itself: the code it
    // interrupted may be standing inside the allocator, or holding the very lock a method three
    // calls down would take. So the check needs a call graph, and the honest way to get one here is
    // to record it WHILE THE ORDINARY WALK HAPPENS rather than to write a second traversal.
    //
    // That choice is not just economy. A hand-written visitor over seventy AST node types has one
    // failure mode -- a node nobody remembered -- and it is silent: the analysis simply does not see
    // that branch and reports nothing. Recording at the points where the analyzer ALREADY resolved a
    // call or a field means anything it can typecheck, this can follow.
    struct MethodFacts {
        std::set<std::string> callees;  // "Class.method", as resolved at the call site
        // Every `this.<field>` this body touched. Read by the TOTALITY check: a per-target
        // procedure whose source is a closed kind must cover it, and for a class or a record the
        // thing to cover is every field. Recorded during the ordinary walk for the same reason the
        // call graph is -- a second traversal to rediscover it would go silently out of date.
        std::set<std::string> ownFieldsTouched;
        // The same question for an ENUM source: which of its own constants the body named. A class
        // is closed over its fields and an enum over its constants, so this is the second row of the
        // totality table and it is the same measurement, over a different list. Recorded where the
        // analyzer already resolves `E.CONSTANT`, so anything it can typecheck, this can follow.
        std::set<std::string> ownConstantsTouched;
        // Rule 2: what the body does that a preempted program cannot survive. `.first` is the
        // phrase for the message ("allocates on the heap"), `.second` points at the act.
        std::vector<std::pair<std::string, SourceLocation>> unsafeOps;
        // Rule 3: mutable state touched that is neither `volatile` nor `atomic<T>`, i.e. shared with
        // no way of saying so. "Class.field" plus where it was touched.
        std::vector<std::pair<std::string, SourceLocation>> unsharedState;
    };
    std::map<std::string, MethodFacts> methodFacts_;   // "Class.method" -> what it did and called
    std::string currentMethodKey_;                     // "Class.method" being analyzed, "" outside one
    // The trap parameter's name while an interrupt body is being analyzed ("" otherwise). Writing
    // through it must be refused -- see the assignment check for the measurement that decided it.
    std::string interruptTrapParam_;
    // The `freestanding` transformer whose body is being analyzed ("" outside one). Set only around
    // a copied procedure's body, so the diagnostic can say why a hosted program is being held to the
    // bare-metal subset.
    std::string freestandingFrom_;
    // Every `interrupt` declared in the program: its class and where to point the diagnostic.
    std::vector<std::pair<std::string, SourceLocation>> interruptRoots_;
    MethodFacts* facts();               // the current method's row, or null outside a method body
    void noteUnsafeForInterrupt(const std::string& what, SourceLocation loc);
    void noteFieldForInterrupt(const std::string& owner, const std::string& field,
                               const FieldInfo& info, const ast::Expr* receiver, SourceLocation loc);
    void checkInterruptReach();         // the BFS, run once after every body has been walked
    // spec 32.13: a per-target `procedure` whose SOURCE is a closed kind is total, and is checked.
    // Constructor definite assignment, generalised -- same dataflow, a different list to cover.
    void checkProcedureTotality(const ast::Program& program);
    std::unordered_set<std::string> deleted_;  // locals deleted in this scope (spec 18.2 reattach)
    std::unordered_set<std::string> freed_;    // ... of those, the ones whose memory is gone
    std::vector<std::string> currentThrows_;  // base names in the method's `throws` clause (spec 21.1)
    std::vector<std::vector<std::string>> catchStack_;  // enclosing try's caught types (base names)
    std::string currentReturnType_;  // declared return type of the method being analyzed (null-safety)
    bool currentReturnIsMove_ = false;  // spec 19.6: `returns move T` -- every return must say `move`
    // Guards the lambda-body check against reentering itself. `typeOf` on a lambda is asked more
    // than once for the same node (the declaration, then each use), and a lambda inside a lambda
    // would otherwise nest the save/restore; one level is all the checking needs.
    bool analyzingLambda_ = false;
    // Every path returns (or throws). Distinct from blockAlwaysExits, which counts break/continue --
    // right for narrowing, wrong for "did this method produce a value".
    bool alwaysReturns(const ast::Block& b);
    bool blockHasBreak(const ast::Block& b);
    // Value types (struct/record) by name, so `ast::keyFieldKind` can tell a nested value field from a
    // class reference. Collected before the class pass, because a field may name a type declared later.
    std::set<std::string> valueTypeNames_;
    // The enclosing lambda's parameter types, while its body is being analyzed. `itself(...)` is checked
    // against these: a lambda has no name, so there is nothing to look its own signature up by.
    std::vector<std::string> currentLambdaParams_;
    // Type names the compiler answers for itself (spec 34) -- File, Time, Net, Memory, Math and the
    // rest. They have no prelude class, so a user class of the same name did not look like a
    // redeclaration to anything: it simply took the name over, and the failure surfaced as the
    // PRELUDE being told to import the user's type.
    std::unordered_set<std::string> builtinTypes_;
    // spec 22.6: inside a generator's parked body, the element type of the Iterator<T> it produces --
    // every `yield` must produce it. Empty in any other method.
    std::string currentGenElem_;
    std::set<std::string> patchedClasses_;  // spec 32.8: classes with a runtime-replaced method
    bool inConstructor_ = false;  // immutable fields may be initialized here
    // True while analysing the body of a `naked` method. Only the inline-assembly checker reads it: a
    // naked body has no compiler-generated code around it, so a register it destroys cannot be
    // corrupting anything the register allocator placed. See asmcheck.h.
    bool inNakedFn_ = false;
    std::unordered_set<std::string> moved_;  // variables in the "moved" state
    // Definite assignment (`T x;` then `x = ...`). Absent from the map means "declared with an
    // initializer", i.e. Init -- only deferred declarations ever enter it.
    std::unordered_map<std::string, FlowFacts::Init> init_;
    // Fields the constructor being analysed owes a value to, with where they were declared (the error
    // points at the FIELD, not at the constructor: the reader needs to see which one, and the
    // declaration is the thing they will edit). Entered into `init_` as `this.<name>` so the existing
    // branch-join machinery handles them without knowing they are fields.
    std::vector<std::pair<std::string, SourceLocation>> pendingCtorFields_;
    // Names proven non-null at this point. See FlowFacts::nonNull.
    std::unordered_set<std::string> nonNull_;
    // Set while typing the operands of a null TEST, so `b != null` sees the declared type rather than
    // the narrowed one -- testing something already proven non-null is redundant, not ill-typed.
    bool suppressNarrowing_ = false;
    std::unordered_set<std::string> activationOwned_;  // locals bound to a no-region `new` (own the object,
                                                       // die at method return) -- region-binder escape check
    std::unordered_map<std::string, const ast::LambdaExpr*> lambdaLocals_;  // local -> the lambda it holds
                                                       // (so `new Thread(work)` can inspect its captures, §14)
    // region-binder escape SUMMARY (interprocedural, §8): "Class.method" -> per value-parameter flag, true
    // when that parameter is stored into the receiver (`this.field = param`, directly or via an alias). A
    // call site can then reject passing an activation-owned argument to such a parameter of a longer-lived
    // receiver. Computed by a pre-pass before the checking pass, so forward calls see it.
    std::unordered_map<std::string, std::vector<bool>> escapesToReceiver_;
    // §8 extended: "Class.method" -> per value-parameter, the set of OTHER parameter indices it is stored
    // into (`paramJ.field = paramI` -> escapesToParam[i] contains j). Checked at the call site against the
    // corresponding argument's lifetime, so `link(longLived, activationLocal)` is rejected.
    std::unordered_map<std::string, std::vector<std::vector<int>>> escapesToParam_;
    std::string escapeScanClass_;   // class of the method currently being scanned (resolves this.field types)
    const std::vector<ast::Param>* escapeScanParams_ = nullptr;  // its parameters (resolve param.field types)
    std::vector<std::vector<int>> escapeScanParamTargets_;  // accumulator: param i -> param slots it escapes to
    bool escapeSummaryChanged_ = false;  // fixpoint flag: a summary grew during the last pass
    void computeEscapeSummaries(const ast::Program& program);
    void scanEscapes(const ast::Block& body, std::unordered_map<std::string, int>& alias,
                     std::vector<bool>& esc);
    void scanStmt(const ast::Stmt* s, std::unordered_map<std::string, int>& alias,
                  std::vector<bool>& esc);
    std::string fieldTypeOf(const ast::MemberExpr& mem);  // the declared type of `recv.field`, or ""
    std::unordered_map<std::string, int> extracted_;  // extracted vars -> line (spec 17: use-after-extract)
    std::unordered_map<std::string, std::string> checkpointRegion_;  // checkpoint var -> region it marked
    // spec 17 Polaron-1718: paths (a local `p`, or a field `obj.f`) known to hold an object allocated
    // `new ... in region R`, so extracting/deleting the OWNER of such a field alone can be rejected.
    std::unordered_map<std::string, std::string> regionOf_;  // path -> region it was allocated in
    std::unordered_map<std::string, RegionConstraints> regionConstraints_;  // region var -> accepts/rejects
    // The same, for a region held as a FIELD, keyed "Class.field". Separate from the map above because
    // that one is cleared per method -- right for a local region, which cannot outlive the method that
    // declares it, and wrong for a field region, which is a property of the CLASS. Without this, a field
    // region's accepts/rejects were recorded in the constructor, wiped before the next method, and every
    // check against them passed by default: a region that was typed on paper and untyped in practice.
    std::unordered_map<std::string, RegionConstraints> fieldRegionConstraints_;
    std::unordered_map<std::string, std::string> regionFlavor_;  // region var -> flavor (spec 17 expansion)
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

}  // namespace polaron
