// polc's own middle end: the transforms clang's default pipeline omits, plus the pipeline itself.
// See `optimize.h`.
//
// This used to live inside the AST-to-LLVM back end, in `codegen.cpp`, with only its declaration in
// the shared header -- the same arrangement `target.cpp` records, and for the same reason: it was
// written where it was first needed rather than where it belongs. Which back end builds a module has
// never had anything to do with how that module is optimised.

#include "codegen/optimize.h"

#include <llvm/IR/Constants.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/PassManager.h>
#include <llvm/IR/ReplaceConstant.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/ADT/STLExtras.h>

#include <vector>

namespace polaron {

namespace {

// Polaron middle-end pass: bounded recursive self-inlining (spec: close the gap to GCC on recursion).
// clang's inliner refuses to inline a function into itself, so naive recursion (e.g. fib) pays a
// call on every node. GCC inlines a few levels; we inline deeper, under an instruction budget, so
// each call does several recursion levels of work inline before recursing. Measured ~8x on fib(40)
// vs clang's naive code, beating GCC. Correctness is unconditional (inlining always preserves
// semantics); the budget bounds code growth.
struct RecursiveInlinePass : llvm::PassInfoMixin<RecursiveInlinePass> {
    static unsigned instCount(const llvm::Function& f) {
        unsigned n = 0;
        for (const llvm::BasicBlock& bb : f) {
            n += static_cast<unsigned>(bb.size());
        }
        return n;
    }

    llvm::PreservedAnalyses run(llvm::Module& m, llvm::ModuleAnalysisManager&) {
        bool changed = false;
        for (llvm::Function& f : m) {
            if (f.isDeclaration() || f.isVarArg()) {
                continue;
            }
            if (f.hasPersonalityFn()) {
                continue;  // skip exception-handling functions (landing pads)
            }
            if (f.hasFnAttribute(llvm::Attribute::NoInline)) {
                continue;
            }
            const unsigned base = instCount(f);
            if (base > 80) {
                continue;  // only small functions: deep inlining of a big body explodes
            }
            // Is it self-recursive? (a direct call to itself somewhere.)
            bool selfRec = false;
            for (llvm::BasicBlock& bb : f) {
                for (llvm::Instruction& i : bb) {
                    if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i)) {
                        if (cb->getCalledFunction() == &f) {
                            selfRec = true;
                        }
                    }
                }
            }
            if (!selfRec) {
                continue;
            }
            // Skip NESTED self-recursion (e.g. ackermann's ack(m-1, ack(m,n-1)), where a self-call is an
            // argument to another self-call). Its recursive calls take distinct, non-overlapping arguments,
            // so deep inlining only bloats the body without the CSE collapse that makes fib fast -- and the
            // bloat actually makes clang optimize it worse than the small original. Leave those to clang.
            bool nested = false;
            for (llvm::BasicBlock& bb : f) {
                for (llvm::Instruction& i : bb) {
                    if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i)) {
                        if (cb->getCalledFunction() == &f) {
                            for (llvm::Value* arg : cb->args()) {
                                if (auto* ac = llvm::dyn_cast<llvm::CallBase>(arg)) {
                                    if (ac->getCalledFunction() == &f) {
                                        nested = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (nested) {
                continue;
            }
            // Inline self-calls round by round; a fixed instruction budget bounds total growth and
            // caps the effective depth (deeper for tinier bodies). Innermost self-calls stay as real
            // recursion.
            const unsigned budget = base <= 25 ? 700u : 1500u;
            for (int round = 0; round < 16; ++round) {
                std::vector<llvm::CallBase*> sites;
                for (llvm::BasicBlock& bb : f) {
                    for (llvm::Instruction& i : bb) {
                        if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i)) {
                            if (cb->getCalledFunction() == &f) {
                                sites.push_back(cb);
                            }
                        }
                    }
                }
                if (sites.empty()) {
                    break;
                }
                bool didAny = false;
                for (llvm::CallBase* cb : sites) {
                    if (instCount(f) >= budget) {
                        break;
                    }
                    llvm::InlineFunctionInfo ifi;
                    if (llvm::InlineFunction(*cb, ifi).isSuccess()) {
                        didAny = true;
                        changed = true;
                    }
                }
                if (!didAny || instCount(f) >= budget) {
                    break;
                }
            }
        }
        return changed ? llvm::PreservedAnalyses::none() : llvm::PreservedAnalyses::all();
    }
};

// A CONSTANT EXPRESSION THE TEXTUAL FORM NO LONGER HAS.
//
// `polc` hands its module to clang as TEXT, and the two are not the same language any more: LLVM
// keeps removing constant-expression opcodes from the parser while the in-memory form still builds
// them. The vectoriser's runtime overlap check is one -- given a constant address it folds the whole
// comparison, and the module prints `br i1 icmp ult (i64 sub (...), i64 4), ...`, which clang then
// refuses with "icmp constexprs are no longer supported". Legal IR, unparseable text.
//
// So the ones the writer can no longer spell are materialised as instructions before printing. Only
// those: a `getelementptr` constant expression is still text, and expanding every constexpr would
// undo the folding the pipeline just did.
void materialiseUnprintableConstants(llvm::Module& module) {
    auto unspellable = [](const llvm::ConstantExpr* ce) {
        return ce->getOpcode() == llvm::Instruction::ICmp ||
               ce->getOpcode() == llvm::Instruction::FCmp;
    };
    // Rewritten in place, one use at a time: `getAsInstruction` gives the same operation as a real
    // instruction, placed immediately before whoever reads it. Its own operands stay constant --
    // the `sub` and the `ptrtoint` under this `icmp` are still spellable, and expanding them too
    // would be undoing the folding for nothing.
    for (llvm::Function& f : module) {
        for (llvm::BasicBlock& bb : f) {
            for (llvm::Instruction& in : llvm::make_early_inc_range(bb)) {
                for (unsigned at = 0; at < in.getNumOperands(); ++at) {
                    auto* ce = llvm::dyn_cast<llvm::ConstantExpr>(in.getOperand(at));
                    if (ce == nullptr || !unspellable(ce)) {
                        continue;
                    }
                    // A PHI READS ITS OPERAND IN THE PREDECESSOR, not here, so the instruction has
                    // to go at the end of that block or it would not dominate its own use.
                    llvm::Instruction* materialised = ce->getAsInstruction();
                    if (auto* phi = llvm::dyn_cast<llvm::PHINode>(&in)) {
                        materialised->insertBefore(phi->getIncomingBlock(at)->getTerminator());
                    } else {
                        materialised->insertBefore(&in);
                    }
                    in.setOperand(at, materialised);
                }
            }
        }
    }
}

}  // namespace

void optimizeModule(llvm::Module& module, int level) {
    if (level <= 0) {
        return;  // O0: leave the IR as generated
    }
    llvm::OptimizationLevel ol = level >= 3   ? llvm::OptimizationLevel::O3
                                 : level == 2 ? llvm::OptimizationLevel::O2
                                              : llvm::OptimizationLevel::O1;
    // The four analysis managers the new pass manager needs, cross-registered.
    llvm::LoopAnalysisManager lam;
    llvm::FunctionAnalysisManager fam;
    llvm::CGSCCAnalysisManager cgam;
    llvm::ModuleAnalysisManager mam;
    llvm::PassBuilder pb;
    // Our middle-end passes run before the default pipeline, which then cleans up and optimizes the
    // result. This is where the transforms clang's default pipeline omits (recursive inlining now;
    // loop interchange next) live.
    pb.registerPipelineStartEPCallback(
        [](llvm::ModulePassManager& mpm, llvm::OptimizationLevel) {
            mpm.addPass(RecursiveInlinePass());
        });
    pb.registerModuleAnalyses(mam);
    pb.registerCGSCCAnalyses(cgam);
    pb.registerFunctionAnalyses(fam);
    pb.registerLoopAnalyses(lam);
    pb.crossRegisterProxies(lam, fam, cgam, mam);
    llvm::ModulePassManager mpm = pb.buildPerModuleDefaultPipeline(ol);
    mpm.run(module, mam);
    materialiseUnprintableConstants(module);
}

}  // namespace polaron
