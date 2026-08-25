#pragma once

#include <string>

#include "pir/module.h"

namespace llvm {
class LLVMContext;
class Module;
}  // namespace llvm

// Stage 2: PIR -> LLVM IR.
//
// See docs/design/polaron-ir.md §14. The second backend, behind a switch, whose oracle is
// DIFFERENTIAL TESTING against the direct AST->LLVM path -- the same method the reachability work
// used against `GlobalDCE`.
//
// ---- and this is where §12 stops being a promise ----
//
// The measurement of 2026-08-18 found that in 18 827 lines of codegen the compiler forwards to LLVM
// exactly one `llvm.assume`, four `NoAlias` return attributes, one `onlyReadsMemory`, and three
// attributes on the `this` parameter. The keywords carry the facts, the analyzer checks them, and
// they die at the lowering boundary.
//
// This file is that boundary, rewritten. Every fact PIR holds and LLVM has a construct for is
// emitted here: `noalias` from `isUnique` and from a moved pointer, `readonly` from the absence of
// `mutable`, `nonnull` from a non-`nullable` type, `align` and `dereferenceable` from the type
// table's five facts, `nounwind` from `Unwind::Never`, `readnone`/`speculatable`/`willreturn` from
// `pure`, `cold` from `Affinity::Cold`, internal linkage from `private`/`internal`, and
// `llvm.sadd.with.overflow` from an arithmetic opcode that says `checked`.
namespace polaron::pir {

struct ToLlvmResult {
    bool ok = false;
    std::string error;
    // What was actually handed over, counted. The §12 table is the project's acceptance criterion,
    // so the counts are reported rather than assumed -- "we emit noalias now" is a claim, and a
    // number beside it is evidence.
    int noalias = 0;
    int readonlyParams = 0;
    int nonnull = 0;
    int alignAttrs = 0;
    int dereferenceable = 0;
    int nounwind = 0;
    int pureAttrs = 0;
    int coldAttrs = 0;
    int internalLinkage = 0;
    int checkedArith = 0;
    int assumes = 0;
    int aliasTags = 0;   // loads and stores carrying `!tbaa`
    int speculated = 0;  // vtable calls given an inline cache
    int mergedDefinitions = 0;  // `--lib` bodies published as ODR, for the consumer's own copy
};

ToLlvmResult toLlvm(const Module& pir, llvm::LLVMContext& context, llvm::Module& into);

std::string renderHandoff(const ToLlvmResult& r);

}  // namespace polaron::pir
