#include "codegen/codegen_impl.h"   // `CodeGenerator::Impl`, which this file is the facade over

namespace polaron {

CodeGenerator::CodeGenerator(const ast::Program& program, const EntryPoint& entry,
                             std::string_view moduleName)
    : impl_(std::make_unique<Impl>(program, entry, moduleName, errors_)) {}

CodeGenerator::~CodeGenerator() = default;

void CodeGenerator::setTargetTriple(const std::string& triple) {
#if LLVM_VERSION_MAJOR >= 21
    impl_->module.setTargetTriple(llvm::Triple(triple));
#else
    impl_->module.setTargetTriple(triple);
#endif
    // Set the target data layout so ABI type alignments are correct. Without it, a layout-less module
    // aligns i64 to 4, and every array/field load emits `load i64 ... align 4` -- which blocks LLVM's
    // SIMD vectorizer on hot reduction loops.
    //
    // EVERY STRING BELOW WAS READ OUT OF CLANG, not written from memory: `clang --target=T -S
    // -emit-llvm` on an empty file prints the layout that target actually uses. A hand-written layout
    // that is subtly wrong does not fail -- it silently misaligns, and the cost shows up as a
    // vectorizer that stopped firing on one architecture and nowhere else.
    //
    // A target not listed here keeps the layout clang applies downstream: correct, just not visible to
    // our own passes, which is the difference between "works" and "works as fast". Its POINTER WIDTH is
    // a separate question and is taken from the triple rather than from the layout -- see `sizeTy`,
    // where reading it from an absent layout silently produced 64-bit `memcpy` lengths on five 32-bit
    // architectures.
    //
    // ...but only when the triple names an architecture LLVM KNOWS. `sh4-unknown-linux-gnu` parses to
    // `UnknownArch`: LLVM cannot say how wide its pointers are, so neither can this compiler, and
    // every width-dependent decision below would be a guess wearing a target's name. A guess is what
    // the whole `address` rule exists to refuse, so this refuses too -- with the list, at the moment
    // the target is chosen, rather than with wrong code much later.
    if (llvm::Triple(triple).getArch() == llvm::Triple::UnknownArch) {
        impl_->error("'" + triple + "' names an architecture LLVM does not know, so its pointer width "
                     "cannot be established -- and every size this compiler emits would be a guess. "
                     "Use a target LLVM recognises (x86_64, aarch64, arm, i686, riscv32/64, wasm32, "
                     "powerpc, mips, m68k, ...)",
                     SourceLocation{});
        return;
    }
    const bool windows =
        triple.find("windows") != std::string::npos || triple.find("msvc") != std::string::npos;
    if (triple.find("x86_64") != std::string::npos || triple.find("amd64") != std::string::npos) {
        impl_->module.setDataLayout(
            windows ? "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
                    : "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128");
    } else if (triple.find("aarch64") != std::string::npos || triple.find("arm64") != std::string::npos) {
        impl_->module.setDataLayout(
            windows
                ? "e-m:w-p270:32:32-p271:32:32-p272:64:64-p:64:64-i32:32-i64:64-i128:128-n32:64-S128-Fn32"
                : "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32");
    } else if (triple.rfind("armv", 0) == 0 || triple.find("-arm-") != std::string::npos) {
        impl_->module.setDataLayout("e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64");
    } else if (triple.find("i686") != std::string::npos || triple.find("i386") != std::string::npos) {
        impl_->module.setDataLayout(
            windows ? "e-m:x-p:32:32-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32-a:0:32-S32"
                    : "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128");
    } else if (triple.find("wasm32") != std::string::npos) {
        impl_->module.setDataLayout("e-m:e-p:32:32-p10:8:8-p20:8:8-i64:64-i128:128-n32:64-S128-ni:1:10:20");
    } else if (triple.find("riscv64") != std::string::npos) {
        impl_->module.setDataLayout("e-m:e-p:64:64-i64:64-i128:128-n32:64-S128");
    }
}

void CodeGenerator::setLibrary(bool library) { impl_->libraryMode = library; }
void CodeGenerator::setSourceLookup(std::function<std::string(std::string_view, int)> lookup) {
    impl_->sourceLookup = std::move(lookup);
}
void CodeGenerator::setTestMode(bool test) { impl_->testMode = test; }
void CodeGenerator::setDebugInfo(bool debug) { impl_->debugInfo = debug; }
void CodeGenerator::setVerifyStack(bool verify) { impl_->verifyStack = verify; }

void CodeGenerator::setPatchedClasses(const std::set<std::string>& classes) {
    impl_->patchedClasses_ = classes;
}

void CodeGenerator::seedVtableSlots(const std::vector<std::string>& slotNames) {
    impl_->seededSlots = slotNames;
}

void CodeGenerator::addDynamicBundle(const std::string& bundleName, const std::string& polbPath,
                                     const std::array<std::uint8_t, 32>& fingerprint) {
    impl_->dynamicBundles[bundleName] = {polbPath, fingerprint};
}

const std::vector<std::string>& CodeGenerator::vtableSlotNames() const {
    return impl_->methodSlotNames;
}

bool CodeGenerator::generate() {
    if (impl_->entry.method == nullptr && !impl_->libraryMode && !impl_->testMode) {
        errors_.push_back(CodegenError{"no entry point to generate", {}});
        return false;
    }
    if (impl_->debugInfo) {
        impl_->initDebugInfo();  // -g: set up the DIBuilder before any function is emitted
    }
    // POLARON_PHASE_TIMES=1: per-step codegen timing, same switch the front end uses.
    const bool cgTimes = std::getenv("POLARON_PHASE_TIMES") != nullptr;
    auto cgClock = std::chrono::steady_clock::now();
    auto cg = [&](const char* name) {
        if (!cgTimes) {
            return;
        }
        const auto now = std::chrono::steady_clock::now();
        std::fprintf(stderr, "[codegen] %-22s %lld ms\n", name,
                     (long long)std::chrono::duration_cast<std::chrono::milliseconds>(
                         now - cgClock).count());
        cgClock = now;
    };
    impl_->declareClasses();
    cg("declareClasses");
    // AFTER declareClasses, because a test's SYMBOL is its class's key and the keys are decided
    // there. Collected before it, `clsKey` answered with the bare name for every class -- correct
    // for all but one, and for that one the runner looked up a symbol that did not exist and
    // silently ran no test: the suite reported "8 passed" while holding eleven.
    if (impl_->testMode) {
        impl_->collectTests();
        cg("collectTests");
    }
    impl_->collectAbstainedLabels();
    cg("collectAbstainedLabels");
    // AFTER collectAbstainedLabels, which is what fills `unimportableClasses` -- and that ordering
    // is the whole point. An unimportable class needs a destructor whether it wrote one or not,
    // because that is the only place its live-instance count can come down: `dtorImpl` returns ""
    // for a class with none, so no death site calls anything and the count only ever climbs.
    //
    // Done inside declareClasses first, where the set is still EMPTY, so the flag was never set:
    // `delete` reached nothing, the count stayed at 1, and the next `unimport` refused a class that
    // had nothing alive. The symptom was an uncaught throw and an abort with no output.
    impl_->markUnimportableDestructors();
    cg("markUnimportableDestructors");
    impl_->collectFieldRegionKinds();
    cg("collectFieldRegionKinds");
    impl_->emitNamespaceConsts();
    cg("emitNamespaceConsts");
    impl_->emitStaticFields();
    cg("emitStaticFields");
    impl_->declareFunctions();
    cg("declareFunctions");
    // The address table anchors every function, so only emit it when the program actually uses
    // unimport/reimport (spec 30); otherwise it would defeat dead-code elimination below.
    // unimportableClasses was filled by collectAbstainedLabels() above.
    if (!impl_->unimportableClasses.empty()) {
        impl_->declareCodeTable();    // handles now; the addresses only exist after the bodies do
    }
    impl_->emitVtables();
    cg("emitVtables");
    impl_->emitFunctions();
    cg("emitFunctions");
    if (impl_->testMode) {
        impl_->emitTestRunner();  // synthetic @entry that runs the [Test] methods
    }
    impl_->emitDynamicThunks();  // runtime-resolving thunks for --use-dynamic bundles
    impl_->emitSpecializations();  // deferred lambda-specialized method copies (inlinable direct calls)
    cg("emitSpecializations");
    if (impl_->libraryMode) {
        impl_->exportBundleSymbols();  // make the .polb's functions DLL-loadable
    }
    impl_->emitHeapBridge();     // `heap class X` -> the __polaron_malloc/free/check_live the codegen calls
    // ...and the String helpers on top of it, which is why this comes second: they are written in
    // terms of that allocator. Freestanding only -- hosted links the runtime's own.
    impl_->emitStringBridge();
    cg("emitStringBridge");
    cg("emitHeapBridge");
    impl_->finalizeDebugInfo();  // -g: resolve all debug metadata before verification
    if (!errors_.empty()) {
        return false;
    }
    impl_->attachTBAA();     // type-based alias metadata: lets LLVM hoist field loads across opaque calls
    cg("attachTBAA");
    impl_->stripDeadCode();  // drop unreferenced prelude/user code from executables
    cg("stripDeadCode");
    // AFTER the strip, and that ordering is the whole design. The table names an address per piece
    // of emitted code, so filling it earlier ANCHORS every one of them: a program that merely
    // mentions `unimport` was dragging in the whole prelude -- printf, the TCP stack, conpty --
    // measured, in a kernel whose source is a driver class and a `main`.
    //
    // Filled here it lists exactly what SURVIVED, which is also exactly the set whose addresses can
    // ever bound one another at run time. Dead code cannot be a neighbour.
    impl_->fillCodeTable();
    cg("fillCodeTable");
    impl_->applyBareMetalAttrs();  // no OS in the triple -> no red zone; see the method for why here

    // BEFORE LLVM's verifier, and answering a question it cannot.
    //
    // `verifyModule` checks a call against its declaration. When both are wrong together -- a `memcpy`
    // declared with a 64-bit length and called with one, on a 32-bit target -- it is satisfied, and the
    // program traps on somebody else's machine instead. This checks the DECLARATIONS against the
    // target, which is the fact neither side carries.
    if (!impl_->auditLibcSignatures()) {
        return false;
    }

    std::string verifyMsg;
    llvm::raw_string_ostream os(verifyMsg);
    if (llvm::verifyModule(impl_->module, &os)) {
        // NAME THE FUNCTION. `verifyModule` prints the offending instruction and nothing about where
        // it lives, so a report reads `sext double to i32` with no way to tell which of a thousand
        // emitted functions produced it -- and the compiler's own author is then reduced to bisecting
        // the input program. `verifyFunction` per function costs one extra pass on a path that is
        // already failing, and turns an hour of bisection into a name.
        std::string where;
        std::string bodies;
        for (llvm::Function& f : impl_->module) {
            if (f.isDeclaration()) {
                continue;
            }
            if (llvm::verifyFunction(f)) {
                if (!where.empty()) {
                    where += ", ";
                }
                where += f.getName().str();
                // AND SHOW IT. A verifier message names an instruction in a module that was never
                // written out, because the write happens after this check -- so the one artifact that
                // would explain the failure is the one thing the failure prevents. Printing the
                // offending function is bounded (only functions that already failed) and is the
                // difference between reading the bug and guessing at it.
                if (std::getenv("POLARON_SHOW_BAD_IR") != nullptr) {
                    llvm::raw_string_ostream fos(bodies);
                    f.print(fos);
                }
            }
        }
        if (!where.empty()) {
            verifyMsg = "in " + where + ": " + verifyMsg;
        }
        if (!bodies.empty()) {
            verifyMsg += "\n" + bodies;
        }
        errors_.push_back(CodegenError{"module verification failed: " + verifyMsg, {}});
        return false;
    }
    return true;
}

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

}  // namespace

void CodeGenerator::optimize(int level) {
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
    mpm.run(impl_->module, mam);
}

std::string CodeGenerator::toIR() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    impl_->module.print(os, nullptr);
    return out;
}

std::string CodeGenerator::toBitcode() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    llvm::WriteBitcodeToFile(impl_->module, os);
    os.flush();
    return out;
}

}  // namespace polaron
