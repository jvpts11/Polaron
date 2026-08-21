// The `--test` runner, shared by both backends. See testrunner.h for why it lives here.
//
// Moved out of `CodeGenerator::Impl` as it stood, so a `git blame` on any line still lands on the
// change that wrote it rather than on the move. What changed in the move is only what had to: the
// four things it used to read off `Impl` are now the callbacks in `Backend`, and `errors`,
// `program` and `classKey` are parameters instead of members.

#include "codegen/testrunner.h"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>

#include <exception>
#include <string>

#include "codegen/cgutil.h"
#include "codegen/target.h"   // createGlobalStringPtr: which spelling this LLVM has

namespace polaron {
namespace testrunner {
namespace {

// The eight-byte length header every managed array carries, ahead of its elements.
constexpr unsigned kArrayHeaderBytes = 8;

// The string value of one annotation argument, e.g. the "m" of [Cases(source: "m")].
std::string stringArg(const ast::AnnotationUse& use, const std::string& name) {
    for (const ast::AnnotationArg& a : use.args) {
        if (a.name != name) {
            continue;
        }
        if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(a.value.get())) {
            return s->value;
        }
    }
    return "";
}

// The integer value of one annotation argument, e.g. the 500 of [MaxTime(ms: 500)].
long long intArg(const ast::AnnotationUse& use, const std::string& name, long long fallback) {
    for (const ast::AnnotationArg& a : use.args) {
        if (a.name != name) {
            continue;
        }
        if (const auto* i = dynamic_cast<const ast::IntLiteralExpr*>(a.value.get())) {
            try {
                return std::stoll(i->text, nullptr, 0);
            } catch (const std::exception&) {
                return fallback;
            }
        }
    }
    return fallback;
}

// Resolves [Cases(source: "m")] against the test's parameter list. A parametrized test takes
// exactly one parameter and runs once per element of the array `m` returns; anything else is
// rejected here rather than producing a test that quietly never runs. Returns false to drop the
// test entirely.
bool resolveCases(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                  const ast::AnnotationUse* cases, Case& tc, std::vector<CodegenError>& errors) {
    if (cases == nullptr) {
        if (m.params.empty()) {
            return true;
        }
        errors.push_back(CodegenError{
            "[Test] method '" + tc.sym + "' takes parameters, so it needs a "
            "'[Cases(source: \"...\")]' naming the static method that supplies its rows",
            m.loc});
        return false;
    }
    if (m.params.size() != 1) {
        errors.push_back(CodegenError{
            "'[Cases]' test '" + tc.sym + "' must take exactly one parameter (it is called once "
            "per row); group several values into a record and take that",
            m.loc});
        return false;
    }
    const std::string source = stringArg(*cases, "source");
    if (source.empty()) {
        errors.push_back(CodegenError{
            "'[Cases]' on '" + tc.sym + "' needs a source: [Cases(source: \"methodName\")]",
            cases->loc});
        return false;
    }
    const std::string want = cgutil::typeRefName(m.params.front().type);
    const ast::MethodDecl* src = nullptr;
    for (const ast::MemberPtr& member : cls.members) {
        const auto* cand = dynamic_cast<const ast::MethodDecl*>(member.get());
        if (cand != nullptr && cand->name == source) { src = cand; break; }
    }
    if (src == nullptr) {
        errors.push_back(CodegenError{"'[Cases]' source '" + source + "' is not a method of class '" +
                                          cls.name + "'",
                                      cases->loc});
        return false;
    }
    const std::string got = cgutil::typeRefName(src->returnType);
    if (!src->isStatic || got != want + "[]") {
        errors.push_back(CodegenError{
            "'[Cases]' source '" + cls.name + "." + source + "' must be a public static method "
            "returning '" + want + "[]' to match the parameter of '" + tc.sym + "' (it returns '" +
                got + "')",
            src->loc});
        return false;
    }
    tc.casesSym = cls.name + "." + source;
    tc.paramType = want;
    return true;
}

// [Benchmark]: a timed loop, not a verdict. Kept out of the test list entirely so a benchmark can
// never turn a suite red, and run only under --bench so it never slows an ordinary run.
void addBenchmark(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                  const ast::AnnotationUse& use, bool alsoTest, Plan& plan,
                  std::vector<CodegenError>& errors) {
    const std::string sym = cls.name + "." + m.name;
    if (alsoTest) {
        errors.push_back(CodegenError{"'[Benchmark]' and '[Test]' cannot mark the same method '" +
                                          sym + "': a benchmark measures, a test judges",
                                      m.loc});
        return;
    }
    if (!m.isStatic || cgutil::typeRefName(m.returnType) != "void" || !m.params.empty()) {
        errors.push_back(CodegenError{"'[Benchmark]' method '" + sym +
                                          "' must be a public static method taking no arguments "
                                          "and returning void",
                                      m.loc});
        return;
    }
    Bench bc;
    bc.sym = sym;
    bc.display = sym;
    bc.iterations = intArg(use, "iterations", 1000);
    bc.warmup = intArg(use, "warmup", 100);
    if (bc.iterations < 1) {
        errors.push_back(CodegenError{"'[Benchmark(iterations: ...)]' on '" + sym +
                                          "' needs at least 1 iteration",
                                      use.loc});
        return;
    }
    plan.benches.push_back(std::move(bc));
}

void addHook(const ast::ClassDecl& cls, const ast::MethodDecl& m, const std::string& kind,
             const std::function<std::string(const std::string&)>& classKey, Plan& plan,
             std::vector<CodegenError>& errors) {
    if (!m.isStatic || cgutil::typeRefName(m.returnType) != "void") {
        errors.push_back(CodegenError{"'[" + kind + "]' method '" + cls.name + "." + m.name +
                                          "' must be a public static method returning void",
                                      m.loc});
        return;
    }
    Hooks& h = plan.hooks[cls.name];
    std::string& slot = kind == "BeforeAll" ? h.beforeAll
                      : kind == "AfterAll"  ? h.afterAll
                      : kind == "Setup"     ? h.setup
                                            : h.teardown;
    if (!slot.empty()) {
        errors.push_back(CodegenError{"class '" + cls.name + "' already has a '[" + kind +
                                          "]' method ('" + slot + "'); there may be only one, "
                                          "because two would have no defined order",
                                      m.loc});
        return;
    }
    slot = classKey(cls.name) + "." + m.name;  // the emitted symbol; see the note on tc.sym
}

// `if (cond) { body(); }` -- the shape the runner is made of, and the builder is left after it.
void ifThen(llvm::LLVMContext& context, llvm::IRBuilder<>& builder, llvm::Function* fn,
            llvm::Value* cond, const std::function<void()>& body) {
    llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "then", fn);
    llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "cont", fn);
    builder.CreateCondBr(cond, thenBB, contBB);
    builder.SetInsertPoint(thenBB);
    body();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
}

llvm::Value* arrayData(llvm::IRBuilder<>& builder, llvm::Value* block) {
    return builder.CreateConstGEP1_64(builder.getInt8Ty(), block, kArrayHeaderBytes, "arr.data");
}

void emitBenchmarks(llvm::LLVMContext& context, llvm::Module& module, llvm::IRBuilder<>& builder,
                    llvm::Function* mainFn, const Plan& plan, const Backend& back) {
    if (plan.benches.empty()) {
        return;
    }
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* ptr = builder.getPtrTy();
    llvm::FunctionCallee shouldFn = module.getOrInsertFunction(
        "__polaron_bench_should_run", llvm::FunctionType::get(i32, {ptr}, false));
    llvm::FunctionCallee recordFn = module.getOrInsertFunction(
        "__polaron_bench_record",
        llvm::FunctionType::get(builder.getVoidTy(), {ptr, i64, i64}, false));
    llvm::FunctionCallee nowFn =
        module.getOrInsertFunction("__polaron_now_ns", llvm::FunctionType::get(i64, {}, false));

    for (const Bench& b : plan.benches) {
        llvm::Function* target = back.function(b.sym);
        if (target == nullptr) {
            continue;
        }
        llvm::Value* nameStr = createGlobalStringPtr(builder, b.display, ".bench.name");
        llvm::Value* sel = builder.CreateICmpNE(builder.CreateCall(shouldFn, {nameStr}),
                                                builder.getInt32(0), "bsel");
        ifThen(context, builder, mainFn, sel, [&] {
            auto loop = [&](long long count, const char* tag) {
                if (count <= 0) {
                    return;
                }
                llvm::Value* iv = builder.CreateAlloca(i64, nullptr, tag);
                builder.CreateStore(builder.getInt64(0), iv);
                llvm::BasicBlock* c = llvm::BasicBlock::Create(context, "b.cond", mainFn);
                llvm::BasicBlock* bd = llvm::BasicBlock::Create(context, "b.body", mainFn);
                llvm::BasicBlock* d = llvm::BasicBlock::Create(context, "b.done", mainFn);
                builder.CreateBr(c);
                builder.SetInsertPoint(c);
                llvm::Value* i0 = builder.CreateLoad(i64, iv);
                builder.CreateCondBr(builder.CreateICmpULT(i0, builder.getInt64(count)), bd, d);
                builder.SetInsertPoint(bd);
                builder.CreateCall(target, {});
                builder.CreateStore(builder.CreateAdd(builder.CreateLoad(i64, iv),
                                                      builder.getInt64(1)),
                                    iv);
                builder.CreateBr(c);
                builder.SetInsertPoint(d);
            };
            loop(b.warmup, "warm");  // untimed: let the caches and the branch predictor settle
            llvm::Value* t0 = builder.CreateCall(nowFn, {}, "b0");
            loop(b.iterations, "iter");
            llvm::Value* total =
                builder.CreateSub(builder.CreateCall(nowFn, {}, "b1"), t0, "bns");
            builder.CreateCall(recordFn, {nameStr, total, builder.getInt64(b.iterations)});
        });
    }
}

// The prelude methods the runner calls directly. Kept beside the calls that use them so the two
// cannot drift: a name added to `emit` and forgotten here is a link error in a test build only.
const char* const kPreludeUses[] = {"Test.reset", "Test.failures", "Test.wasSkipped",
                                    "Test.skipReason"};

}  // namespace

std::vector<std::string> rootsOf(const Plan& plan) {
    std::vector<std::string> roots;
    for (const Case& t : plan.tests) {
        roots.push_back(t.sym);
        if (!t.casesSym.empty()) {
            roots.push_back(t.casesSym);
        }
    }
    for (const Bench& b : plan.benches) {
        roots.push_back(b.sym);
    }
    for (const auto& [cls, hooks] : plan.hooks) {
        (void)cls;
        for (const std::string& h : {hooks.beforeAll, hooks.afterAll, hooks.setup, hooks.teardown}) {
            if (!h.empty()) {
                roots.push_back(h);
            }
        }
    }
    for (const char* p : kPreludeUses) {
        roots.emplace_back(p);
    }
    return roots;
}

Plan collect(const ast::Program& program,
             const std::function<std::string(const std::string&)>& classKey,
             std::vector<CodegenError>& errors) {
    Plan plan;
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) {
                        continue;
                    }
                    bool isTest = false;
                    const ast::AnnotationUse* ignore = nullptr;
                    const ast::AnnotationUse* cases = nullptr;
                    const ast::AnnotationUse* repeat = nullptr;
                    const ast::AnnotationUse* maxTime = nullptr;
                    const ast::AnnotationUse* bench = nullptr;
                    const ast::AnnotationUse* xfail = nullptr;
                    std::string tags;
                    const char* hook = nullptr;  // the lifecycle annotation this method carries
                    for (const ast::AnnotationUse& a : m->annotations) {
                        if (a.name == "Test") {
                            isTest = true;
                        } else if (a.name == "Ignore") {
                            ignore = &a;
                        } else if (a.name == "Cases") {
                            cases = &a;
                        } else if (a.name == "Repeat") {
                            repeat = &a;
                        } else if (a.name == "MaxTime") {
                            maxTime = &a;
                        } else if (a.name == "Benchmark") {
                            bench = &a;
                        } else if (a.name == "ExpectedToFail") {
                            xfail = &a;
                        } else if (a.name == "Tag") {
                            if (!tags.empty()) {
                                tags += ",";
                            }
                            tags += stringArg(a, "name");
                        } else if (a.name == "BeforeAll" || a.name == "AfterAll" || a.name == "Setup" ||
                                   a.name == "Teardown") {
                            hook = a.name.c_str();
                        }
                    }
                    if (bench != nullptr) {
                        addBenchmark(cls, *m, *bench, isTest, plan, errors);
                        continue;
                    }
                    if (hook != nullptr) {
                        addHook(cls, *m, hook, classKey, plan, errors);
                        if (!isTest) {
                            continue;
                        }
                        errors.push_back(CodegenError{
                            std::string("'[") + hook + "]' and '[Test]' cannot mark the same method '" +
                                cls.name + "." + m->name + "': a hook runs around the tests, so it " +
                                "cannot be one of them",
                            m->loc});
                        continue;
                    }
                    if (!isTest) {
                        if (ignore != nullptr) {
                            errors.push_back(CodegenError{
                                "'[Ignore]' on '" + cls.name + "." + m->name +
                                    "' has no effect: it only applies to a '[Test]' method",
                                m->loc});
                        }
                        continue;
                    }
                    const std::string trt = cgutil::typeRefName(m->returnType);
                    if (!m->isStatic || (trt != "boolean" && trt != "void")) {
                        errors.push_back(CodegenError{
                            "[Test] method '" + cls.name + "." + m->name +
                                "' must be a public static method returning boolean (the test's own "
                                "verdict) or void (the verdict comes from its Test.assert* calls)",
                            m->loc});
                        continue;
                    }
                    Case tc;
                    // THE SYMBOL BY KEY, THE DISPLAY BY NAME. The runner calls the function, so the
                    // symbol has to be the one that was emitted -- which for a class whose name the
                    // standard library also uses carries its path. Composed from the bare name, the
                    // lookup silently found nothing and the class's tests VANISHED from the run: a
                    // suite that reports "8 passed" when it holds eleven tests is worse than one
                    // that fails. What a reader sees stays `Report.the_assertion_surface`, because
                    // the path is the compiler's business and the test's name is the author's.
                    tc.sym = classKey(cls.name) + "." + m->name;
                    tc.display = cls.name + "." + m->name;  // what --filter matches and the report prints
                    tc.cls = cls.name;
                    tc.isVoid = trt == "void";  // spec 32.11: verdict is "no assertion failed"
                    tc.tags = tags;
                    if (ignore != nullptr) {
                        tc.ignored = true;
                        tc.ignoreReason = stringArg(*ignore, "reason");
                    }
                    tc.expectedToFail = xfail != nullptr;
                    if (repeat != nullptr) {
                        tc.repeat = static_cast<int>(intArg(*repeat, "times", 1));
                        if (tc.repeat < 1) {
                            errors.push_back(CodegenError{
                                "'[Repeat(times: ...)]' on '" + tc.sym + "' needs a count of at "
                                "least 1", repeat->loc});
                            tc.repeat = 1;
                        }
                    }
                    if (maxTime != nullptr) {
                        tc.maxTimeNs = intArg(*maxTime, "ms", 0) * 1000000LL;
                    }
                    if (!resolveCases(cls, *m, cases, tc, errors)) {
                        continue;
                    }
                    plan.tests.push_back(std::move(tc));
                }
            }
        }
    }
    return plan;
}

void emit(llvm::LLVMContext& context, llvm::Module& module, llvm::IRBuilder<>& builder,
          const Plan& plan, const Backend& back) {
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* ptr = builder.getPtrTy();
    llvm::Type* v = builder.getVoidTy();

    llvm::FunctionType* mainTy = llvm::FunctionType::get(i32, {i32, ptr}, false);
    llvm::Function* mainFn =
        llvm::Function::Create(mainTy, llvm::Function::ExternalLinkage, "main", module);
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", mainFn));

    llvm::FunctionCallee beginFn = module.getOrInsertFunction(
        "__polaron_test_begin", llvm::FunctionType::get(v, {i32, ptr}, false));
    llvm::FunctionCallee shouldFn = module.getOrInsertFunction(
        "__polaron_test_should_run", llvm::FunctionType::get(i32, {ptr, ptr}, false));
    llvm::FunctionCallee startFn = module.getOrInsertFunction(
        "__polaron_test_start", llvm::FunctionType::get(v, {ptr, i32}, false));
    llvm::FunctionCallee recordFn = module.getOrInsertFunction(
        "__polaron_test_record", llvm::FunctionType::get(v, {ptr, i32, i64, ptr, i64}, false));
    llvm::FunctionCallee summaryFn =
        module.getOrInsertFunction("__polaron_test_summary", llvm::FunctionType::get(i32, {}, false));
    llvm::FunctionCallee nowFn =
        module.getOrInsertFunction("__polaron_now_ns", llvm::FunctionType::get(i64, {}, false));
    llvm::FunctionCallee cstrFn = module.getOrInsertFunction(
        "__polaron_str_cstr", llvm::FunctionType::get(ptr, {ptr}, false));
    llvm::FunctionCallee caseNameFn = module.getOrInsertFunction(
        "__polaron_test_case_name", llvm::FunctionType::get(ptr, {ptr, i64}, false));
    llvm::FunctionCallee repeatFailedFn = module.getOrInsertFunction(
        "__polaron_test_repeat_failed", llvm::FunctionType::get(v, {i64}, false));
    llvm::FunctionCallee abortedFn =
        module.getOrInsertFunction("__polaron_test_aborted", llvm::FunctionType::get(i32, {}, false));

    auto argIt = mainFn->arg_begin();
    llvm::Value* argc = &*argIt++;
    llvm::Value* argv = &*argIt;
    builder.CreateCall(beginFn, {argc, argv});
    // The program's classes load before its tests run, exactly as in main. Each backend supplies
    // its own: the trusted path walks the AST, and PIR already has an ordered init hook list.
    if (back.emitClassLoadHooks) {
        back.emitClassLoadHooks();
    }

    // A ZERO OF THE VALUE'S OWN TYPE, because the two backends do not agree on what a `boolean`
    // is at the ABI: the AST-to-LLVM path returns one as an i32, and PIR returns an i1. Written
    // as a literal `getInt32(0)`, the comparison against `Test.wasSkipped()` came out of the PIR
    // build as `icmp ne i1 %skipped, i32 0` and the module would not even parse. Asking the value
    // what its own zero looks like is right under both, and stays right if a third ever differs.
    auto isNonZero = [&](llvm::Value* x, const char* name) {
        return builder.CreateICmpNE(x, llvm::Constant::getNullValue(x->getType()), name);
    };
    auto isZero = [&](llvm::Value* x, const char* name) {
        return builder.CreateICmpEQ(x, llvm::Constant::getNullValue(x->getType()), name);
    };

    llvm::Function* resetFn = back.function(kPreludeUses[0]);
    llvm::Function* failuresFn = back.function(kPreludeUses[1]);
    llvm::Function* skippedFn = back.function(kPreludeUses[2]);
    llvm::Function* reasonFn = back.function(kPreludeUses[3]);
    auto callHook = [&](const std::string& sym) {
        if (sym.empty()) {
            return;
        }
        if (llvm::Function* h = back.function(sym); h != nullptr) {
            builder.CreateCall(h, {});
        }
    };

    std::vector<std::string> classOrder;
    std::map<std::string, std::vector<const Case*>> byClass;
    for (const Case& t : plan.tests) {
        if (byClass.find(t.cls) == byClass.end()) {
            classOrder.push_back(t.cls);
        }
        byClass[t.cls].push_back(&t);
    }
    static const Hooks kNoHooks;

    for (const std::string& cls : classOrder) {
        const auto hookIt = plan.hooks.find(cls);
        const Hooks& hooks = hookIt == plan.hooks.end() ? kNoHooks : hookIt->second;
        const std::vector<const Case*>& cases = byClass[cls];

        // Ask the selection question for every test FIRST, then reuse the answers: the class's
        // expensive [BeforeAll] fixture must not be built when --filter selected none of them.
        std::vector<llvm::Value*> selected;
        llvm::Value* anySelected = builder.getInt1(false);
        for (const Case* t : cases) {
            llvm::Value* nameStr = createGlobalStringPtr(builder, t->display, ".test.name");
            llvm::Value* tagStr = createGlobalStringPtr(builder, t->tags, ".test.tags");
            llvm::Value* s = isNonZero(builder.CreateCall(shouldFn, {nameStr, tagStr}), "sel");
            selected.push_back(s);
            anySelected = builder.CreateOr(anySelected, s, "any");
        }
        ifThen(context, builder, mainFn, anySelected, [&] { callHook(hooks.beforeAll); });

        // Runs one test (or one row of a [Cases] test) under `caseName`, and reports it.
        auto runOne = [&](const Case& t, llvm::Value* caseName, llvm::Value* arg) {
            llvm::Function* target = back.function(t.sym);
            if (target == nullptr) {
                return;
            }
            // Name the test to the runtime BEFORE running it, so the first failing assertion can
            // print the "FAIL <name>" header itself and its details read underneath.
            builder.CreateCall(startFn,
                               {caseName, builder.getInt32(t.expectedToFail ? 1 : 0)});
            llvm::Value* started = builder.CreateCall(nowFn, {}, "t0");
            // [Repeat(times: N)] runs the whole thing N times and reports ONE verdict: a test
            // that fails 3 times in 100 is a flaky test, and 100 report lines would bury that.
            llvm::Value* failCount = builder.CreateAlloca(i32, nullptr, "failcount");
            builder.CreateStore(builder.getInt32(0), failCount);
            for (int rep = 0; rep < t.repeat; ++rep) {
                // Reset before EVERY run (not just the void ones): the failure count, the
                // Test.checking label and the skip flag must never bleed into the next.
                if (resetFn != nullptr) {
                    builder.CreateCall(resetFn, {});
                }
                callHook(hooks.setup);
                llvm::Value* failed = nullptr;
                llvm::SmallVector<llvm::Value*, 1> callArgs;
                if (arg != nullptr && target->arg_size() >= 1) {
                    callArgs.push_back(back.coerce(arg, target->getArg(0)->getType()));
                }
                if (t.isVoid) {
                    // spec 32.11: a void test passes when none of its Test.assert* calls failed.
                    builder.CreateCall(target, callArgs);
                    llvm::Value* f = failuresFn != nullptr
                                         ? builder.CreateCall(failuresFn, {}, "fails")
                                         : llvm::cast<llvm::Value>(builder.getInt32(0));
                    failed = isNonZero(f, "failed");
                } else {
                    llvm::Value* r = builder.CreateCall(target, callArgs, "verdict");
                    failed = isZero(r, "failed");
                }
                // [Teardown] runs before the clock stops: releasing the fixture is part of the
                // test's cost, and a teardown that hangs should show up as a slow test.
                callHook(hooks.teardown);
                if (t.repeat > 1) {
                    const int iteration = rep + 1;
                    ifThen(context, builder, mainFn, failed, [&] {
                        builder.CreateCall(repeatFailedFn, {builder.getInt64(iteration)});
                    });
                }
                builder.CreateStore(
                    builder.CreateAdd(builder.CreateLoad(i32, failCount),
                                      builder.CreateZExt(failed, i32)),
                    failCount);
            }
            llvm::Value* anyFailed = isNonZero(builder.CreateLoad(i32, failCount), "anyfailed");
            llvm::Value* elapsed =
                builder.CreateSub(builder.CreateCall(nowFn, {}, "t1"), started, "ns");
            // Test.skip(why) at runtime outranks the pass/fail verdict: the test never reached
            // the point of having one.
            llvm::Value* skipped =
                skippedFn != nullptr
                    ? isNonZero(builder.CreateCall(skippedFn, {}, "skipped"), "wasskipped")
                    : llvm::cast<llvm::Value>(builder.getInt1(false));
            llvm::Value* why =
                reasonFn != nullptr
                    ? builder.CreateCall(cstrFn, {builder.CreateCall(reasonFn, {}, "why")})
                    : llvm::cast<llvm::Value>(createGlobalStringPtr(builder, "", ".test.why"));
            // [ExpectedToFail] inverts the verdict: failing is the expected outcome (3), and
            // passing is itself a failure (4) -- the bug got fixed and the annotation is a lie.
            llvm::Value* pass = t.expectedToFail ? builder.getInt32(4) : builder.getInt32(0);
            llvm::Value* fail = t.expectedToFail ? builder.getInt32(3) : builder.getInt32(1);
            llvm::Value* verdict = builder.CreateSelect(
                skipped, builder.getInt32(2), builder.CreateSelect(anyFailed, fail, pass),
                "verdict");
            builder.CreateCall(recordFn,
                               {caseName, verdict, elapsed, why, builder.getInt64(t.maxTimeNs)});
        };

        for (std::size_t i = 0; i < cases.size(); ++i) {
            const Case& t = *cases[i];
            // --fail-fast is asked HERE, not in the selection above: selection is decided for the
            // whole class before anything runs, so at that point nothing has failed yet.
            llvm::Value* live = builder.CreateAnd(
                selected[i],
                builder.CreateICmpEQ(builder.CreateCall(abortedFn, {}, "aborted"),
                                     builder.getInt32(0)),
                "live");
            ifThen(context, builder, mainFn, live, [&] {
                llvm::Value* nameStr = createGlobalStringPtr(builder, t.display, ".test.name");
                if (t.ignored) {
                    // [Ignore]: never run, reported as a skip carrying its reason, so a
                    // known-broken case stays visible instead of quietly disappearing.
                    builder.CreateCall(
                        recordFn,
                        {nameStr, builder.getInt32(2), builder.getInt64(0),
                         createGlobalStringPtr(builder, t.ignoreReason, ".test.why"),
                         builder.getInt64(0)});
                    return;
                }
                if (t.casesSym.empty()) {
                    runOne(t, nameStr, nullptr);
                    return;
                }
                // [Cases]: call the source once, then run the body over every row, each reported
                // as its own result under "Class.method[i]".
                llvm::Function* src = back.function(t.casesSym);
                if (src == nullptr) {
                    return;
                }
                llvm::Value* block = builder.CreateCall(src, {}, "rows");
                llvm::Value* len = builder.CreateLoad(i64, block, "rows.len");
                llvm::Type* storageTy = back.storageType(t.paramType);
                llvm::Value* iv = builder.CreateAlloca(i64, nullptr, "row");
                builder.CreateStore(builder.getInt64(0), iv);
                llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "rows.cond", mainFn);
                llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "rows.body", mainFn);
                llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "rows.done", mainFn);
                builder.CreateBr(condBB);
                builder.SetInsertPoint(condBB);
                llvm::Value* i0 = builder.CreateLoad(i64, iv, "i");
                builder.CreateCondBr(builder.CreateICmpULT(i0, len), bodyBB, doneBB);
                builder.SetInsertPoint(bodyBB);
                llvm::Value* i1 = builder.CreateLoad(i64, iv, "i");
                llvm::Value* elemPtr =
                    builder.CreateGEP(storageTy, arrayData(builder, block), i1, "row.elem");
                llvm::Value* value = builder.CreateLoad(storageTy, elemPtr, "row.val");
                if (t.paramType == "boolean") {  // 1-byte storage, i32 value
                    value = builder.CreateZExt(value, i32);
                }
                llvm::Value* caseName = builder.CreateCall(caseNameFn, {nameStr, i1}, "casename");
                runOne(t, caseName, value);
                builder.CreateStore(builder.CreateAdd(i1, builder.getInt64(1)), iv);
                builder.CreateBr(condBB);
                builder.SetInsertPoint(doneBB);
            });
        }
        ifThen(context, builder, mainFn, anySelected, [&] { callHook(hooks.afterAll); });
    }
    emitBenchmarks(context, module, builder, mainFn, plan, back);
    builder.CreateRet(builder.CreateCall(summaryFn, {}, "rc"));
}

}  // namespace testrunner
}  // namespace polaron
