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

}  // namespace cgutil
}  // namespace polaron
