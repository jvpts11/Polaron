#pragma once

// Helpers shared between the analyser's translation units.
//
// `analyzer.cpp` was 8 643 lines, of which `typeOf` and `analyzeStatement` were 4 115 -- so those two
// moved to files of their own. Everything they needed came with them EXCEPT these two, which were
// `static` and therefore had no symbol to link against from another file. Declared here and defined in
// analyzer.cpp, they are shared deliberately rather than by being in the same file by accident.
//
// This header is PRIVATE to src/semantic. It is not part of the analyser's interface -- `analyzer.h`
// is -- and nothing outside these three files should include it.

#include "parser/ast.h"

#include <string>
#include <unordered_map>
#include <vector>

namespace polaron {

// Evaluates a constant integer/boolean/char expression at compile time (spec 28), delegating to the
// shared comptime evaluator so consts and `comptime` method calls resolve uniformly.
// `consts`/`methods` are optional resolution tables.
bool evalConstInt(const ast::Expr& e, long long& out,
                  const std::unordered_map<std::string, long long>* consts = nullptr,
                  const std::unordered_map<std::string, const ast::MethodDecl*>* methods = nullptr,
                  const std::unordered_map<std::string, double>* dconsts = nullptr,
                  const std::unordered_map<std::string, std::vector<std::string>>* enums = nullptr);

// Evaluates a constant floating-point expression at compile time (integers promote), resolving consts
// and `comptime` method calls via the same evaluator.
bool evalConstDouble(const ast::Expr& e, double& out,
                     const std::unordered_map<std::string, double>* dconsts,
                     const std::unordered_map<std::string, long long>* iconsts,
                     const std::unordered_map<std::string, const ast::MethodDecl*>* methods = nullptr,
                     const std::unordered_map<std::string, std::vector<std::string>>* enums = nullptr);

}  // namespace polaron
