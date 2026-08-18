#pragma once

// The semantic analyser's pure helpers: name suggestions, questions about a TYPE NAME, and small AST
// walks. Nothing here holds analyser state.
//
// They lived in the anonymous namespace at the top of analyzer.cpp, ahead of 7 000 lines of
// SemanticAnalyzer. Same shape as codegen's, and moved for the same reason -- see cgutil.h.
//
// KNOWN DUPLICATION, recorded rather than fixed: `isArrayType`, `elementOf`, `isRefType`, `baseType`,
// `isFloatType`, `isIntName`, `intBits`, `isTupleType`, `tupleElems`, `vecWidth` and `vecLane` also
// exist in codegen's cgutil, implemented separately. Unifying them is the right end state and is NOT a
// move: the two copies would have to be compared line by line first, because a predicate that answers
// differently in the analyser and in codegen is a compiler that type-checks one program and emits
// another. That comparison is its own change.

#include <functional>
#include <string>
#include <vector>

#include "lexer/token.h"
#include "parser/ast.h"

namespace polaron {
namespace semutil {

// ---- "Did you mean ...?" ----
int editDistance(const std::string& a, const std::string& b);
std::string closestName(const std::string& typed, const std::vector<std::string>& candidates);
std::string didYouMean(const std::string& typed, const std::vector<std::string>& candidates);

// ---- Questions about a type NAME ----
bool isArrayType(const std::string& t);
// `T[N]` -- the extent stated in the type. Returns N, or 0 when the name is not one. A stated extent
// and a dynamic array are different types and neither answers the other's predicate: `int[]` is
// heap with a length header, `int[16]` is sixteen ints where it is declared.
int fixedExtent(const std::string& t);
bool isFixedArrayType(const std::string& t);
std::string elementOf(const std::string& t);
bool isRefType(const std::string& t);
std::string baseType(const std::string& t);
std::string typeRefStr(const ast::TypeRef& t);
bool isFloatType(const std::string& t);
bool isIntName(const std::string& t);
// `address` and its three narrow forms. They are integers by representation and NOT integers by
// rule -- crossing between them and a number is a `cast` the author wrote. See semutil.cpp.
bool isAddressName(const std::string& t);
bool isBitCountedName(const std::string& t);
unsigned intBits(const std::string& t);
bool isNumeric(const std::string& t);
bool isNullableType(const std::string& t);
std::string normalTypeName(const std::string& t);
bool isTupleType(const std::string& t);
std::vector<std::string> tupleElems(const std::string& t);
int vecWidth(const std::string& t);
int vecLane(const std::string& m);

// ---- Literals and small walks ----
bool readIntLiteral(const ast::Expr& e, long long& out);
bool intLiteralFits(const ast::Expr& init, const std::string& target);
void checkBitField(const ast::ClassDecl& cls, const ast::FieldDecl& f,
                   const std::function<void(const std::string&, const SourceLocation&)>& error);
bool exprHasAwait(const ast::Expr* e);
bool stmtHasAwait(const ast::Stmt* s);
bool blockHasAwait(const ast::Block& b);

}  // namespace semutil
}  // namespace polaron
