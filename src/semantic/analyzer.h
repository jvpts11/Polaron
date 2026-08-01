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

namespace ldp3 {

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
    bool isDeprecated = false;            // spec 14.2: each call site gets a warning
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
    // True if `className` owns a `unique` field, directly, through a superclass, or through a value
    // sub-object -- such an object may not be value-copied (spec 19.2).
    bool classHasUniqueField(const std::string& className);
    // Checks a type against a region's accepts/rejects constraints (spec 17.3).
    void checkRegionAccepts(const std::string& region, const std::string& type, SourceLocation loc);
    // A type from another namespace must be imported (or be a primitive / a
    // monomorphized generic). Errors otherwise (namespace visibility).
    void checkTypeAccessible(const std::string& typeName, SourceLocation loc);
    // cast<Wide>(narrow arithmetic): the bits are gone before the cast runs. See the definition.
    void checkWideningLostBits(const ast::CastExpr& cst, const std::string& src,
                               const std::string& dst);
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
    std::unordered_map<std::string, std::vector<std::string>> enums_;  // name -> constants
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
    bool libraryMode_ = false;      // compiling a bundle to a .ldb: a missing `main` is allowed
    bool testMode_ = false;         // `ldp3c --test`: a missing `main` is allowed (runner is synthetic)
    std::unordered_set<std::string> currentImports_;  // imported symbol names (current bundle)
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    std::string enclosingClass_;  // class the current method belongs to, set even for static methods
                                  // (unlike currentClass_) -- used to point unqualified calls at their owner
    std::unordered_set<std::string> deleted_;  // locals deleted in this scope (spec 18.2 reattach)
    std::unordered_set<std::string> freed_;    // ... of those, the ones whose memory is gone
    std::vector<std::string> currentThrows_;  // base names in the method's `throws` clause (spec 21.1)
    std::vector<std::vector<std::string>> catchStack_;  // enclosing try's caught types (base names)
    std::string currentReturnType_;  // declared return type of the method being analyzed (null-safety)
    // spec 22.6: inside a generator's parked body, the element type of the Iterator<T> it produces --
    // every `yield` must produce it. Empty in any other method.
    std::string currentGenElem_;
    std::set<std::string> patchedClasses_;  // spec 32.8: classes with a runtime-replaced method
    bool inConstructor_ = false;  // immutable fields may be initialized here
    std::unordered_set<std::string> moved_;  // variables in the "moved" state
    // Definite assignment (`T x;` then `x = ...`). Absent from the map means "declared with an
    // initializer", i.e. Init -- only deferred declarations ever enter it.
    std::unordered_map<std::string, FlowFacts::Init> init_;
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
    // spec 17 LDP3-1718: paths (a local `p`, or a field `obj.f`) known to hold an object allocated
    // `new ... in region R`, so extracting/deleting the OWNER of such a field alone can be rejected.
    std::unordered_map<std::string, std::string> regionOf_;  // path -> region it was allocated in
    std::unordered_map<std::string, RegionConstraints> regionConstraints_;  // region var -> accepts/rejects
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

}  // namespace ldp3
