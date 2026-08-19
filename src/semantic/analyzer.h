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
    // A PARAMETER received BY VALUE whose type is a class -- so the callee holds a deep copy, and
    // anything it changes is changed in the copy. Recorded because that is invisible at the call
    // site and silent at run time: see the by-value mutation check.
    bool isByValueClassParam = false;
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
    // WHICH OBJECTS HAVE BEEN EMPTIED, and which locals hold borrows into which object. These belong
    // here for the same reason everything else does: kept in flat sets they survived a branch that
    // could not reach the code after it. `if (...) { people.clear(); return; }` then reading the
    // result was reported as use-after-invalidation on a path where the clear never runs -- the
    // checker complaining about correct code, which is worse than the bug it was added to catch.
    std::unordered_set<std::string> invalidated;
    std::unordered_map<std::string, std::string> borrows;
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
    // spec 19: `weak T*` -- a non-owning slot that is NULLED when the object it points at dies. The
    // region binder reads it: a reference that cannot outlive its target has nothing to prove, so a
    // store into one is not an escape and needs no ordering between the two objects.
    bool isWeak = false;
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
    // spec 26: declared `extern` -- there is no Polaron body, so no escape summary can exist and
    // nothing can be said about what it does with a pointer it is handed. The region binder has to
    // know, because "no summary" was reading as "keeps nothing".
    bool isExtern = false;
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
    // WHERE THIS TYPE LIVES, so a pass that walks `classes_` can say so.
    //
    // Resolution of a shared name asks "which namespace is asking" (see lookupShared), and a pass
    // iterating the class map rather than the namespace tree has no answer -- it inherits whichever
    // namespace the previous loop happened to leave behind. That is how `implements Shape` in a
    // user's own namespace resolved to a standard-library `Shape` and reported it "is not an
    // interface": the check was right, it was just looking at the wrong type.
    std::string ns;
    std::string bundle;
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
    // WHICH CLASS MENTIONS WHICH -- handed to codegen so it can emit only the bodies a program can
    // reach, instead of emitting all of them and letting GlobalDCE delete the rest. Collected during
    // the ordinary walk; see noteClassRef.
    const std::map<std::string, std::set<std::string>>& classReferences() const { return classRefs_; }
    // Classes whose code must be generated whatever else is pruned, because it carries a build-time
    // assertion the code generator has to settle.
    const std::set<std::string>& demandOwners() const { return demandOwners_; }

private:
    void error(std::string message, SourceLocation loc);
    void warn(std::string message, SourceLocation loc);  // records a non-fatal diagnostic
    // Rich variants: attach a diagnostic code so the driver can print why / how-to-fix / how-to-prevent
    // from the catalog. The message is still the specific one-line title (it names the actual thing).
    void error(diag::Code code, std::string message, SourceLocation loc);
    void warn(diag::Code code, std::string message, SourceLocation loc);
    // `[Allow(code:, why:)]` -- the escape valve for structural advice, per declaration.
    //
    // Advice is a rule about a SHAPE, and a shape can be right for a reason the compiler cannot see.
    // Without a way to say so the first honest disagreement makes the whole set noise, and a set
    // people have learned to skip is worse than no set at all. Pushed once per method, carrying the
    // enclosing class's allows with it, so writing one on the class covers everything inside it.
    struct AllowEntry {
        std::string code;      // e.g. "Polaron-0B0B"
        SourceLocation loc;
        bool used = false;
    };
    std::vector<std::vector<AllowEntry>> allowStack_;
    void pushAllows(const std::vector<ast::AnnotationUse>& outer,
                    const std::vector<ast::AnnotationUse>& inner);
    void popAllows();
    bool allowed(diag::Code code);
    // Advice, per loop body: a `String` accumulated by copying itself (Polaron-0B0B).
    void warnStringBuildingInLoop(const ast::Block& body);
    // Advice, per method: shapes the language has a shorter and safer word for.
    void warnMutableNeverMutated(const ast::MethodDecl& m);
    void warnSwallowedCatch(const ast::Block& body);
    void warnAsyncNeverAwaits(const ast::MethodDecl& m);
    // These two take the type their caller already resolved: asking `typeOf` after the body has
    // been analysed asks about names whose scope has been popped, and it REPORTS an undeclared
    // name rather than shrugging at it.
    void warnDefaultOverAClosedSet(const ast::MatchStmt& ms, const std::string& subjectType);
    void warnResultNeverExamined(const ast::ExprStmt& es, const std::string& valueType);
    void warnIfChainOnOneSubject(const ast::Block& body);
    void warnRepeatedMagicNumber(const ast::MethodDecl& m);
    void warnThrowCaughtHere(const ast::Block& body);
    void warnHeapWithLexicalLifetime(const ast::Block& body);
    void warnRepeatedCleanup(const ast::MethodDecl& m);
    void warnThrowInLoop(const ast::Block& body);
    void warnMoveInsteadOfCopy(const ast::MethodDecl& m);
    void warnListWithoutCapacity(const ast::Block& body);
    void warnDeadStoreOfACopy(const ast::Block& body);
    void warnManyOfOneKindInAScope(const ast::Block& body);
    void warnRuntimeCheckOfConstants(const ast::Block& body);
    void warnRegionWithOneAllocation(const ast::Block& body);
    void warnCopyHoistableOutOfLoop(const ast::Block& body);
    void warnLinearSearchInLoop(const ast::Block& body);
    void warnLockAroundSlowWork(const ast::Block& body);
    void warnSequentialIndependentAwaits(const ast::Block& body);
    void warnAllocFreeInLoop(const ast::Block& body);
    void warnArrayGrownByHand(const ast::MethodDecl& m);
    void warnBooleanOutParameter(const ast::MethodDecl& m);
    void warnValidationThatIsAContract(const ast::MethodDecl& m);
    void warnNullCheckOnNonNullable(const ast::Expr& cond);   // called while names are in scope
    // Advice, per declaration (advice.cpp): shapes a class's own text gives away.
    void adviseOnDeclarations(const ast::Program& program);
    void adviseOnClass(const ast::ClassDecl& c);
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
    // Records that the class currently being analyzed mentions `name`; see the note at the definition.
    void noteClassRef(const std::string& name) const;
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
    // Option/Result carry two representations, and only the `*` on the target tells them apart.
    // See the note in isSubtype: mixing them compiled, and answered wrongly.
    static bool isBoxedSumMismatch(const std::string& sub, const std::string& super);
    static bool isValueSumForm(const std::string& t);
    static bool isSumCaseClass(const std::string& t);
    static std::string sumFormHint(const std::string& sub, const std::string& super);
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
    // Every class by name, for the questions that are about SOMEBODY ELSE's declaration. The field
    // table (`classes_`) answers most of them and cannot answer this one: a bound target's
    // completeness needs the fields in declaration order and needs to know which already carry a
    // value, and neither survives into an unordered map of types.
    std::map<std::string, const ast::ClassDecl*> declsByName_;
    const ast::ClassDecl* classDeclOf(const std::string& name) const {
        auto it = declsByName_.find(name);
        return it == declsByName_.end() ? nullptr : it->second;
    }
    // The name a procedure's target is bound to, empty outside one. Assignments to `<name>.field`
    // discharge that field the way `this.field` does inside a constructor.
    std::string boundTargetName_;
    std::vector<std::pair<std::string, SourceLocation>> pendingBoundFields_;
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
    // TYPE IDENTITY (docs/design/type-identity.md), built alongside the maps below -- which key on the
    // BARE name and so hold one answer where there may be two.
    //
    // `typeNamespace_` and `typeBundle_` already know a type's namespace and its bundle: the material
    // for a canonical name has been here all along. What was missing is somewhere to keep it TWICE,
    // which is why two types called `Color` cannot both exist, and why the compiler invents a
    // difference by rewriting them to `Ns__Color` instead of telling them apart.
    //
    // The id is a 32-bit index and the canonical name is stored once, deliberately: a canonical
    // `Bundle.Namespace.Name` averages 21 characters against today's 8.2, and the standard library's
    // small-string buffer holds 15 -- so keying the hot maps by canonical STRINGS would move every
    // type name in the compiler from inline bytes to a heap allocation, inside a compile that is
    // 325 ms of mostly symbol-table work. Measured before the design was chosen, not after.
    struct TypeEntry {
        std::string canonical;   // "System.Spatial.Color"
        std::string written;     // "Color" -- what a diagnostic must say
        std::string bundle;
        std::string ns;
        SourceLocation loc;
    };
    std::vector<TypeEntry> types_;
    std::unordered_map<std::string, std::uint32_t> typeByCanonical_;
    // Every id sharing a written name, so "which `Color` is meant here" is a lookup rather than a scan.
    std::unordered_map<std::string, std::vector<std::uint32_t>> typesByWritten_;
    // Just the names that are declared more than once. Usually EMPTY, which is what keeps the guard
    // in `lookupClass` free: an empty-set test in front of the fast path, so a program with no
    // collisions pays nothing at all for the machinery that resolves them.
    std::unordered_set<std::string> sharedNames_;
    const ClassInfo* lookupShared(const std::string& name) const;
    // The paths a shared name could have meant, as `'A.B.C' or 'D.E.C'`, for the message that has to
    // say so. Empty for a name that is not shared, which is every ordinary name.
    std::string sharedPathsFor(const std::string& name) const;

    // Registers one declared type and returns its id. Two declarations with the same CANONICAL name
    // are a redeclaration; two with the same WRITTEN name in different namespaces are the ordinary
    // case this table exists for, and are not an error.
    std::uint32_t internType(const std::string& written, const std::string& bundleName,
                             const std::string& nsName, SourceLocation loc) {
        // `nsName` IS THE WHOLE PATH, NOT THE LAST SEGMENT. A namespace nests through its dotted form
        // -- `namespace Memory.Units` -- and the parser keeps it whole (`parseDottedName`), so this
        // composes `System.Memory.Units.ByteSize` rather than `System.Units.ByteSize`. Verified
        // against a real nested type rather than assumed: two namespaces ending in the same segment
        // would otherwise produce one canonical name for two types, which is the exact failure this
        // table exists to prevent, arrived at from the other side.
        std::string canonical = bundleName + "." + nsName + "." + written;
        if (auto it = typeByCanonical_.find(canonical); it != typeByCanonical_.end()) {
            return it->second;
        }
        const auto id = static_cast<std::uint32_t>(types_.size());
        types_.push_back(TypeEntry{std::move(canonical), written, bundleName, nsName, loc});
        typeByCanonical_[types_.back().canonical] = id;
        typesByWritten_[written].push_back(id);
        if (typesByWritten_[written].size() > 1) {
            sharedNames_.insert(written);
        }
        return id;
    }
    // How many distinct types share this written name. One is the ordinary case; more than one is
    // what the renaming pass exists to paper over.
    std::size_t writtenNameCount(const std::string& written) const {
        auto it = typesByWritten_.find(written);
        return it == typesByWritten_.end() ? 0 : it->second.size();
    }

    // A TYPE, AS A MESSAGE SHOULD NAME IT.
    //
    // One function, replacing the `s.rfind("__")` that was copied by hand into the two places somebody
    // remembered. That is not a tidying: a mangled name in a diagnostic tells an author about a class
    // they never wrote, and the rule that it must be un-mangled is not enforceable while every message
    // has to remember it for itself.
    //
    // When a name is unambiguous it is the written one, which is what the author sees in their file.
    // When it is NOT -- two `Color`s in one program -- the message says the whole path, because that
    // is precisely the case where "Color" identifies nothing and is the reason the reader is confused
    // in the first place.
    std::string typeAsWritten(const std::string& internal) const {
        std::string bare = internal;
        if (const auto p = bare.rfind("__"); p != std::string::npos) {
            bare = bare.substr(p + 2);       // Ns__Type, while the renaming pass still exists
        }
        auto it = typesByWritten_.find(bare);
        if (it == typesByWritten_.end() || it->second.size() <= 1) {
            return bare;
        }
        // Ambiguous: say which one. Prefer the entry whose mangled form matches what was passed in,
        // so the message names the type actually being talked about rather than the first declared.
        for (std::uint32_t id : it->second) {
            const TypeEntry& e = types_[id];
            if (internal == e.ns + "__" + e.written || internal == e.canonical) {
                return e.canonical;
            }
        }
        return bare;
    }

    // Generic base name -> every namespace declaring one. Generics are not in `types_`: their
    // templates are erased by monomorphization before this analyzer ever runs, so the only record of
    // where `Stack<T>` was written is what the monomorphizer saved on the way past. Same rule as the
    // type table, kept separately because the facts arrive from a different place.
    std::map<std::string, std::vector<std::string>> genericHomes_;
    // Where each declared ANNOTATION lives, kept apart from the type map because an annotation and a
    // class may share a name (they are used in different positions and never confused). Read by the
    // import validator, so a library's annotation can be imported like anything else it declares.
    std::unordered_map<std::string, std::string> annotationNamespace_;
    std::unordered_map<std::string, std::string> annotationBundle_;
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
    // The FULL paths of those imports. The set above keeps only the last segment, which answers
    // nothing when two types share it -- `import System.Units.Angle;` beside a `System.Math.Angle`
    // says precisely which is meant, and resolution needs to be able to read that.
    std::unordered_set<std::string> currentImportPaths_;
    // spec 32.11: the classes that declare a [BeforeAll]/[AfterAll] fixture, and whether the method
    // being analyzed is a [Test] (or one of the per-test hooks around it). A test that reaches into
    // ANOTHER class's fixture reads state whose lifetime it does not control -- see the warning at the
    // static-call site.
    std::unordered_set<std::string> fixtureOwners_;
    std::unordered_set<std::string> fixtureWarned_;  // "Reader.method|Owner", warned once each
    bool inTestMethod_ = false;
    std::string currentClass_;  // class of the method being analyzed ("" if static/none)
    // THE TYPE PARAMETERS IN SCOPE where this body was written -- the class's and the method's own.
    //
    // A generic body is analyzed TWICE: once as the template, with `T` still a name standing for a
    // type, and again per instantiation with `T` replaced. Any check that asks "is this a class?"
    // gets the wrong answer on the first pass, because `T` is not one and never will be. Without
    // this set the only ways out are to skip the check on template bodies (losing it everywhere) or
    // to spell the check's exception at each site (which is how they drift apart).
    //
    // So it is recorded once, where the body's owner is known, and a check that cannot mean anything
    // yet defers to the instantiation -- where the same check runs against the real type.
    std::unordered_set<std::string> currentTypeParams_;
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
        // The ones this body WRITES, which `ownFieldsTouched` does not separate out. A method that
        // writes one of its own fields CHANGES its object, and that is the fact the by-value
        // mutation check is built on: passing an object by value and then changing it changes a copy.
        std::set<std::string> ownFieldsWritten;
        // Callees invoked ON `this`, which `callees` cannot distinguish: it records the resolved
        // receiver TYPE, so `r.ensure()` on a fresh local of the same class looks exactly like
        // `this.ensure()`. That difference is the whole question here -- a method that builds a new
        // object and fills it in changes THAT object and not its own -- and using `callees` for the
        // fixpoint reported `BigInteger.copyMag`, which does precisely that, as a mutator.
        std::set<std::string> selfCallees;
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
    // A method called ON A BY-VALUE PARAMETER: where it happened, which parameter, and what was
    // called. Collected during the walk and judged afterwards, because whether the callee CHANGES
    // its object is a fixpoint over the call graph and is not known at the call site.
    struct ByValueCall {
        std::string caller;    // "Class.method" doing the call
        std::string param;     // the parameter used as the receiver
        std::string callee;    // "Class.method" being called on it
        SourceLocation loc;
    };
    std::vector<ByValueCall> byValueCalls_;
    // "Class.method#param" -> its declared type, so the message can spell the fix.
    std::map<std::string, std::string> paramTypes_;
    std::string lookupLocalType(const std::string& methodKey, const std::string& param) const;
    // Reports every call that changes a copy the caller will never see. Run after the walk.
    void checkByValueMutations();
    // The field a `if (this.f == null)` arm is currently filling in, or empty. A write to THAT field
    // inside THAT arm is lazy initialisation and not a change: the guard is the proof that the field
    // held nothing, so filling it in cannot alter what the object already meant. Without this, every
    // reader of a lazily-built container -- `size()`, `get()`, and so anything calling them -- came
    // out a mutator, and the check reported an honest read as a lost write.
    std::string lazyInitField_;
    static std::string lazyInitGuardField(const ast::Expr& cond);
    // WHICH CLASS MENTIONS WHICH, for reachability-driven emission (see noteClassRef). Mutable
    // because it is filled from `lookupClass`, which is const and is the funnel every name
    // resolution goes through -- recording there is what keeps this complete without a second walk
    // over the AST that would go quietly out of date.
    mutable std::map<std::string, std::set<std::string>> classRefs_;
    // Classes holding a `demand` -- a compile-time assertion, which must be settled whether or not
    // anything calls the method around it. See the note at the demand statement.
    std::set<std::string> demandOwners_;
    // The class whose members are being analyzed, for the above. Distinct from `currentClass_`
    // (cleared inside a static method) and from `enclosingClass_` (which a lambda body inherits):
    // this one answers "whose code is this, for the purpose of what it drags in".
    std::string owningClassForRefs_;
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

    // ---- THE REGION A VALUE LIVES IN (safety model §1.2) --------------------------------------
    //
    // Four kinds, ordered by outlives-or-equal:
    //
    //     Root  ⊒  Object ◇o  ⊒  Region R  ⊒  Activation ◇m
    //
    // and one rule (§3) generates every error: a referring binding may only point at a region that
    // outlives its own. Until now only Activation existed, as a set of NAMES, which is why the
    // analysis could see a local escaping a local and nothing else -- and why a SQL engine handing
    // back rows its table had freed compiled clean and printed another query's data.
    enum class RegionKind {
        Unknown,     // could not be worked out; the default's direction is the open question (§4)
        Root,        // a static, an eternal, a persistent: outlives everything
        Object,      // owned by some object -- `owner` names it
        Region,      // inside an explicit `region R` -- `owner` is R
        Activation,  // this frame
    };
    struct Lifetime {
        RegionKind kind = RegionKind::Unknown;
        std::string owner;   // the object path for Object, the region name for Region
    };
    // Does `a` outlive-or-equal `b`? The order above, plus the one refinement that makes Object
    // usable: two DIFFERENT objects are incomparable, because nothing in the program says which dies
    // first. That incomparability is not a gap -- it is the answer, and it is what makes storing one
    // object's row inside another object an error rather than a shrug.
    bool outlivesOrEqual(const Lifetime& a, const Lifetime& b) const;
    // §10, SUB-REGIONS AND NESTING: when each region was declared. Regions are released last-in-
    // first-out, and one declared inside a block is necessarily born after the block's enclosing
    // region -- so "born earlier" is "dies later", and one number per region orders the whole nest
    // without modelling the nest at all.
    std::unordered_map<std::string, int> regionBirth_;
    int regionBirthCounter_ = 0;
    // The lifetime of a VALUE, computed by the same walk that computes its type -- the structural
    // change the model needed. Lifetime used to be a property of a NAME, so an escape had to be
    // spelled as a bare identifier on both sides to be seen; a temporary, an array element, a field
    // read or a call result were all invisible, and real code is made of those.
    Lifetime lifetimeOf(const ast::Expr& expr);
    // A region's lifetime, which depends on where the region itself is kept: a field region dies
    // with its object, a local one with its scope.
    Lifetime regionLifetime(const std::string& name) const;
    // Which `T*` fields a class OWNS, inferred from its destructor rather than declared.
    //
    // This is the piece that makes Object regions decidable without an annotation on every field.
    // A `T*` field may be ownership (a database's tables) or a borrow (a result set's rows), and the
    // type says nothing -- but the DESTRUCTOR does, because the author already had to write it: a
    // field it frees is owned, a field it leaves alone is somebody else's. The structure is already
    // in the language, which is the model's own first sentence about where regions come from.
    std::unordered_map<std::string, std::unordered_set<std::string>> ownedFields_;  // class -> fields
    // ...and whose CONTENTS it frees, which is a different sentence. `~Table` walks its rows and
    // deletes each one; `~ViewResult` deletes only the list. Both free a field; only one of them owns
    // what is in it, and reading a single set made a view look exactly like an owner.
    std::unordered_map<std::string, std::unordered_set<std::string>> ownedContents_;
    // Methods that free a field's contents: calling one invalidates every borrow into that object.
    std::unordered_set<std::string> invalidators_;
    // Per method: a local -> the object it holds borrows from, and which objects have been emptied.
    std::unordered_map<std::string, std::string> borrowsFrom_;
    std::unordered_set<std::string> invalidatedAt_;
    void noteBorrowFlow(const ast::Stmt& stmt);
    void computeOwnership(const ast::Program& program);
    void computeOwnershipRound(const ast::Program& program);
    bool freshGrew_ = false;   // fixpoint flag: a method joined `returnsFresh_` this round
    void collectFreed(const ast::Block& body, std::unordered_set<std::string>& freed,
                      std::unordered_set<std::string>& contents,
                      const std::string& selfName = "") const;
    // §3 at a call, for BOTH call paths -- static calls resolve elsewhere and were checked nowhere.
    void checkKeptArguments(const std::string& ownerClass, const std::string& methodName,
                            const ast::CallExpr& call, const ast::Expr* receiver,
                            const std::vector<std::string>& paramTypes, bool calleeIsExtern);
    bool ownsField(const std::string& className, const std::string& field) const;
    bool anyFieldOwns(const std::string& className, const std::string& fieldList) const;
    bool allFieldsWeak(const std::string& className, const std::string& fieldList) const;
    // WHICH PARAMETERS A METHOD FREES, keyed "Class.method". A recursive structure frees itself
    // through a helper -- `~TreeMap` calls `freeSubtree(this.root)` and never writes a `delete` --
    // so without this a tree owned nothing and every rotation in it was an unplaceable reference.
    std::unordered_map<std::string, std::set<int>> deletesParam_;
    // The CLASS behind such a parameter, under the name the rest of the compiler uses. A
    // monomorphized helper still declares its template's type, so the declared name is not the one
    // anything looks up; the field it is called with belongs to an instantiated class and is.
    std::unordered_map<std::string, std::unordered_map<int, std::string>> paramClassOf_;
    void computeDeleteSummaries(const ast::Program& program);
    // "Class.method" -> the field a one-line accessor hands back. What makes a CALL result carry its
    // receiver's region: `table.at(i)` is a row the table owns, and without this the commonest way
    // to reach into another object is invisible.
    std::unordered_map<std::string, std::string> accessorField_;
    // "Class.method" for every method whose every `return` is a fresh heap allocation. Its result is
    // owned by nobody yet, so it fits anywhere -- the commonest thing a call result can be, and an
    // Unknown until it was computed.
    std::unordered_set<std::string> returnsFresh_;
    std::string returnedFieldOf(const std::string& className, const std::string& method) const;
    std::string describePath(const ast::Expr& expr) const;
    std::string describeRegion(const Lifetime& life) const;
    std::string regionAdvice(const Lifetime& source, const Lifetime& target) const;
    // Non-zero while a lifetime is being worked out: `error` returns instead of recording. Asking a
    // question must not produce a complaint, and `typeOf` reports as it goes.
    int quiet_ = 0;
    // Regions released on this path (§7). Kept beside `deleted_`/`freed_`, which carry the values
    // that lived in them -- one is for naming the region in a message, the other is what the
    // use-after check already reads.
    std::unordered_set<std::string> releasedRegions_;
    struct Quiet {   // RAII, so an early return inside a lifetime query cannot leave it muted
        SemanticAnalyzer& a;
        explicit Quiet(SemanticAnalyzer& an) : a(an) { ++a.quiet_; }
        ~Quiet() { --a.quiet_; }
    };
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
    // WHICH FIELD the parameter is stored into, per method. What decides at a call site whether the
    // receiver is BORROWING the argument or TAKING it: a field the class frees is a handover, and
    // `list.add(item)` must not be a diagnostic. Keyed "Class.method#paramIndex".
    std::unordered_map<int, std::string> escapeScanFieldFor_;   // accumulator, per method
    std::unordered_map<std::string, std::string> escapesToReceiverField_;
    // VALUES THIS OBJECT WAS JUST GIVEN, keyed "receiverPath\x1fvaluePath". A store into an owned
    // field makes the receiver the owner; a later store of the SAME value into another field of the
    // SAME receiver is then a second name for something it already owns, not a borrow from elsewhere.
    // That is the head-and-tail of every linked structure. Cleared per method: it records what was
    // seen a few statements ago, and claims nothing beyond that.
    std::unordered_set<std::string> alreadyOwnedHere_;
    std::unordered_set<std::string> currentParamNames_;   // this body's parameters, by name
    // A sub-region and the region its block was carved out of: `region frame = itself.allocate(...)
    // in region world;`. The parent must outlive it PHYSICALLY, not only in the lifetime order §10
    // already keeps -- releasing the parent takes the child's storage with it.
    std::unordered_map<std::string, std::string> parentRegion_;
    // A FRESH OBJECT BEING FILLED IN, and what it has picked up so far.
    //
    // `mutable ArrayList<T> out = new ArrayList<T>() on heap;` owns nothing and is owned by nothing:
    // at that moment nothing can outlive it, so a store into it cannot dangle. What it may not do is
    // stay unconstrained -- each borrow put inside LOWERS its lifetime to the shorter of the two, and
    // by the time it is returned or stored the accumulated bound is what gets checked.
    //
    // This is the inference Rust writes as `fn sorted(&'a self) -> Vec<&'a T>`, arrived at by reading
    // the stores instead of by writing the parameter. Without it `sortedBy` -- a fresh list filled
    // from `this` -- was an unprovable borrow, and so was every other method in the language that
    // builds a collection and hands it back.
    mutable std::unordered_map<std::string, Lifetime> acquired_;
    // A LOCAL THAT NAMES SOMETHING ANOTHER OBJECT OWNS -> that object's region. `Stir* pass =
    // wild.stir()` is a borrow of a field `wild` frees, and the region analysis says so at the call;
    // this is where that answer is kept, so the next line can compare `pass` against `wild` instead
    // of against a region invented from the local's own name.
    mutable std::unordered_map<std::string, Lifetime> borrowedRegion_;
    // A METHOD THAT HANDS BACK SOMETHING BORROWED FROM ONE OF ITS PARAMETERS, keyed "Class.method"
    // -> the parameter index. Nothing inside such a method is wrong; the whole question is at the
    // caller, where the source can be emptied while the result is still being read. Without this the
    // fact stopped at the `return` and a view outliving its table was invisible.
    std::unordered_map<std::string, int> returnsBorrowOfParam_;
    std::unordered_map<std::string, int> borrowLocals_;        // accumulator, per method
    std::unordered_map<std::string, std::string> freshLocalClass_;   // locals built by `new ... on heap`
    std::string escapeScanKey_;                                // "Class.method" being scanned
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
