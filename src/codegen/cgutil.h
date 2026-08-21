#pragma once

// Codegen's pure helpers: the ones that answer questions about a TYPE NAME or walk an AST, and touch
// no LLVM at all.
//
// They lived at the top of codegen.cpp, in the anonymous namespace above a 19 000-line `Impl`. Moving
// them out is not tidying: it is the only part of that file that CAN move as it stands, because
// everything below is one class and a class cannot be split across translation units without first
// being declared in a header. 543 lines that never mention `llvm::` were being recompiled with the
// whole backend behind them.
//
// Nothing here knows what a Value or a Module is. That is the property that makes the file a unit, and
// it is worth keeping: a helper that starts needing the IRBuilder belongs on the other side of the
// line, not here with an include added to let it in.

#include <cstdint>
#include <set>
#include <string>
#include <vector>

#include "parser/ast.h"

namespace polaron {
namespace cgutil {

// ---- Free-variable collection, for a lambda's auto-capture ----
// Every identifier the expression/statement reads, so the lambda knows what to carry.
void collectRefs(const ast::Expr* e, std::set<std::string>& out);
void collectRefs(const ast::Stmt* s, std::set<std::string>& out);
void collectRefs(const ast::Block& b, std::set<std::string>& out);

// Which of a class's `region` fields are its own and which point at memory it does not own.
// (Copied from the definition, not reconstructed from the call sites -- writing this struct from
//  memory is exactly how the first attempt at this split failed to compile.)
struct FieldRegionKinds {
    std::set<std::string> owned;     // assigned itself.allocate(...) somewhere
    std::set<std::string> external;  // assigned itself.at(...)/atMultiple(...) somewhere -- vetoes `owned`
};
void scanFieldRegions(const ast::Stmt* s, const std::string& cls, FieldRegionKinds& out);
void scanFieldRegions(const ast::Block& b, const std::string& cls, FieldRegionKinds& out);

// ---- Escape analysis for a returned local ----
//
// `Vec v = new Vec(a, b); return v;` hands the caller a pointer into a frame that is about to end.
// The DIRECT form (`return new Vec(...)`) is caught where the return is emitted; this is the
// indirect one -- built into a local and returned by name, which is how a builder method reads --
// and it has to be known BEFORE the declaration is lowered.
//
// Two walks over the same body: gather the identifiers returned anywhere, then rewrite the `new`
// bound to each of them from `stack` to `heap`. Over-promotion is always safe; a returned object is
// the caller's to own either way.
//
// Here rather than inside one backend because it is an AST walk with no LLVM in it -- the property
// this file exists to hold -- and because BOTH backends need the same answer. While only one of
// them ran it, the other returned zeros at -O2 and the right numbers at -O0, which is the signature
// of reading a frame nobody had reused yet.
void collectReturnedNames(const ast::Stmt* st, std::set<std::string>& out);
void promoteEscapingNews(const ast::Stmt* st, const std::set<std::string>& returned);

// ---- `old(...)` in an `ensures` clause ----
//
// Every `old(e)` an exit check will ask for, so a method's entry can snapshot each one before the
// body has a chance to change it. The ORDER is the traversal's and both backends depend on it: one
// slot is allocated per node in the order this returns them, and a slot allocated for a different
// node than the one that reads it is a check comparing two unrelated values.
//
// Shared for the reason everything else in this file is shared. The PIR path had no equivalent at
// all, so `ensures this.count == old(this.count) + 1` lowered to nothing -- thirty-three of them in
// the standard library's collections alone, every one a promise the second backend did not check.
void collectOld(const ast::Expr* e, std::vector<const ast::OldExpr*>& out);

// ---- Literals ----
// A string literal's escape sequences resolved to the bytes they denote.
std::string resolveEscapes(const std::string& raw);
// An integer literal's value, in any base the lexer accepts, with digit separators removed.
std::int64_t parseIntLiteral(const std::string& lexeme);
// Decimal is a fixed-point i128 holding value times 10^-DECIMAL_SCALE (spec 34). 10^18 keeps the
// fraction inside an i64, which is what makes formatting cheap.
constexpr int DECIMAL_SCALE = 18;
// A decimal literal as its scaled integer text.
std::string decimalScaledString(const std::string& text);

// ---- Questions about a type NAME ----
// These traffic in Polaron's canonical type strings ("int", "Box$int", "int[]", "Node*"), which is why
// they need no LLVM: the answer is in the name.
bool isArrayType(const std::string& t);
int fixedExtent(const std::string& t);            // "int[16]" -> 16; 0 when the extent is not stated
bool isFixedArrayType(const std::string& t);
std::string elementOf(const std::string& t);      // "int[]" -> "int"; "int[16]" -> "int"
bool isFloatType(const std::string& t);
bool isF32(const std::string& t);
unsigned floatBits(const std::string& t);
unsigned intBits(const std::string& t);
bool isUnsigned(const std::string& t);
bool isIntName(const std::string& t);
bool isRefType(const std::string& t);
bool isTupleType(const std::string& t);
std::vector<std::string> tupleElems(const std::string& t);
bool isValueVariant(const std::string& t);
std::string baseType(const std::string& t);       // strips pointer/array/ref markers
unsigned byteSizeOf(const std::string& t);
int vecWidth(const std::string& t);               // vec2/vec3/vec4 -> 2/3/4, else 0
int vecLane(const std::string& m);                // ".x"/".y"/".z"/".w" -> 0..3, else -1
bool isIntOverflowMethod(const std::string& m);
std::string typeRefName(const ast::TypeRef& t);

// ---- Which invariants a method's exits actually have to re-check ----
//
// A METHOD THAT WRITES NOTHING THE INVARIANT MENTIONS CANNOT HAVE BROKEN IT.
//
// Every exit of every method re-checks every invariant of the class. On a `HashMap` that is five
// checks on the way out of `get`, `slotFor`, `size`, `isEmpty` -- methods that assign no field at
// all. The invariant held at ENTRY, and a method that changed none of its fields leaves it holding.
// A call is not a hole: the callee checks the invariant at its own exit. What must not be skipped is
// a method that assigns one of the fields itself -- `put`, `grow`, `remove` -- and those keep every
// check.
//
// It lives HERE, in the shared helpers, because the rule is the LANGUAGE's and not one backend's.
// It was written in the trusted path only, and the cost of that showed the first time the two were
// compared on a benchmark: `HashMap$int$int.get` came out of the PIR path carrying TEN invariant
// checks the other path does not emit, the method grew too big to inline, and `coll_map` ran 1.25x
// slower for no other reason. Same shape as every other divergence found this session -- a rule
// written in one place is a rule the other place violates silently.
//
// The two walkers are exposed as well as the question, so a caller filtering several invariants over
// one body can collect the fields once.
// Whether a method carries `[Name]`. Both backends ask, so the spelling is decided once.
bool hasAnnotation(const ast::MethodDecl& m, const std::string& name);

// Whether an expression calls anything. A clause emitted where the CALLER stands makes any call in
// it happen there, for real, once per call site -- so a promise is only free if it has none.
bool mentionsCall(const ast::Expr* e);

// Whether an expression names `old(...)`. See the definition: at a call site there is no "before".
bool mentionsOld(const ast::Expr* e);

void collectThisFields(const ast::Expr* e, std::set<std::string>& out);
bool blockAssignsThisField(const ast::Block& b, const std::set<std::string>& fields);
bool invariantCanBreakIn(const ast::Expr* invariant, const ast::Block& body);

}  // namespace cgutil
}  // namespace polaron
