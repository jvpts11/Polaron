#include <doctest/doctest.h>

#include <string>

#include "pir/text.h"
#include "pir/verify.h"

using namespace polaron::pir;

// Stage 0's acceptance criterion, and it is deliberately the only thing tested here at this stage:
//
//   THE TEXT FORM ROUND-TRIPS. `print(parse(print(m)))` must equal `print(m)`, exactly.
//
// That one property is worth more than a pile of getter tests, because it fails whenever the printer
// and the parser disagree about anything at all -- a field that is printed and not read, an opcode
// spelled two ways, a type that interns differently on the way back. It is the same shape as the
// differential testing Stage 2 will use against the old codegen: two paths, one answer required.
namespace {

// A module exercising the shapes that are easy to get wrong: block arguments, a forward branch, a
// total switch, a region with an escape annotation, a guard, a fact, and an extern declaration.
Module buildSample() {
    Module m;
    m.triple = "x86_64-unknown-none-elf";
    m.bundle = "Sample";

    const Type* i32 = m.types.intType(32);
    const Type* ptr = m.types.ptrType();
    const Type* rgn = m.types.regionType();

    Global g;
    g.name = "count";
    g.type = i32;
    g.linkage = Linkage::Internal;
    g.storage = Storage::Persistent;
    g.zeroInit = true;
    m.globals.push_back(g);

    Field p0;
    p0.type = ptr;
    Function* fn = m.addFunction("Window.width", m.types.fnType(i32, {p0}));
    fn->linkage = Linkage::Public;
    fn->conv = Conv::Polaron;
    fn->unwind = Unwind::Never;
    fn->affinity = Affinity::Hot;
    fn->pure = true;

    Contract c;
    c.kind = Contract::Kind::Requires;
    c.text = "this.w >= 0";
    fn->contracts.push_back(c);

    const BlockId entry = fn->addBlock("entry");
    const BlockId narrow = fn->addBlock("narrow");
    const BlockId wide = fn->addBlock("wide");

    // ^entry(%0 : ptr):
    const ValueId self = fn->addValue(ptr, ValueOrigin::BlockParam, entry, 0, "this");
    fn->block(entry)->params.push_back(self);

    {
        Block* b = fn->block(entry);

        Inst guard;
        guard.op = Op::GuardNull;
        guard.operands.push_back(self);
        guard.loc.line = 12;
        guard.loc.col = 5;
        b->insts.push_back(guard);

        const ValueId w = fn->addValue(i32, ValueOrigin::Instruction, entry, 1, "w");
        Inst load;
        load.op = Op::Load;
        load.result = w;
        load.type = i32;
        load.operands.push_back(self);
        b->insts.push_back(load);

        const ValueId r = fn->addValue(rgn, ValueOrigin::Instruction, entry, 2, "r");
        Inst mk;
        mk.op = Op::RegionCreate;
        mk.result = r;
        mk.type = rgn;
        mk.imm = 4096;
        mk.extra.push_back("pool");
        b->insts.push_back(mk);

        const ValueId obj = fn->addValue(ptr, ValueOrigin::Instruction, entry, 3, "obj");
        Inst alloc;
        alloc.op = Op::RegionAlloc;
        alloc.result = obj;
        alloc.type = ptr;
        alloc.operands.push_back(r);
        alloc.extra.push_back("escapes");
        b->insts.push_back(alloc);

        Inst fact;
        fact.op = Op::FactRequires;
        fact.operands.push_back(w);
        b->insts.push_back(fact);

        // A FORWARD BRANCH with arguments: the parser must resolve ^wide before it has read it.
        Inst br;
        br.op = Op::BrCond;
        br.operands.push_back(w);
        Edge toNarrow;
        toNarrow.target = narrow;
        toNarrow.args.push_back(w);
        Edge toWide;
        toWide.target = wide;
        toWide.args.push_back(w);
        br.edges.push_back(toNarrow);
        br.edges.push_back(toWide);
        b->insts.push_back(br);
    }

    for (BlockId id : {narrow, wide}) {
        Block* b = fn->block(id);
        const ValueId arg = fn->addValue(i32, ValueOrigin::BlockParam, id, 0, "x");
        b->params.push_back(arg);
        Inst ret;
        ret.op = Op::Ret;
        ret.operands.push_back(arg);
        b->insts.push_back(ret);
    }

    // An extern declaration: a signature and nothing else.
    Function* ext = m.addFunction("LibC.puts", m.types.fnType(i32, {p0}));
    ext->linkage = Linkage::External;
    ext->conv = Conv::Cdecl;
    ext->symbol = "puts";
    ext->library = "c";

    return m;
}

}  // namespace

TEST_CASE("pir text form round-trips exactly") {
    const Module original = buildSample();
    const std::string first = print(original);

    Module again;
    std::string error;
    REQUIRE_MESSAGE(parse(first, &again, &error), error);

    const std::string second = print(again);
    CHECK(first == second);
}

TEST_CASE("pir verify accepts a well-formed module") {
    const Module m = buildSample();
    const std::vector<VerifyError> errors = verify(m);
    CHECK_MESSAGE(errors.empty(), renderVerifyErrors(errors));
}

TEST_CASE("pir verify rule 2: a block must end in a terminator") {
    Module m = buildSample();
    Function* fn = m.find("Window.width");
    REQUIRE(fn != nullptr);
    fn->block(0)->insts.pop_back();   // remove the br.cond

    const std::vector<VerifyError> errors = verify(m);
    bool sawRule2 = false;
    for (const VerifyError& e : errors) {
        if (e.rule == 2) {
            sawRule2 = true;
        }
    }
    CHECK(sawRule2);
}

TEST_CASE("pir verify rule 3: a branch must supply the block's parameters") {
    Module m = buildSample();
    Function* fn = m.find("Window.width");
    REQUIRE(fn != nullptr);
    Block* entry = fn->block(0);
    entry->insts.back().edges[0].args.clear();   // ^narrow declares one parameter

    const std::vector<VerifyError> errors = verify(m);
    bool sawRule3 = false;
    for (const VerifyError& e : errors) {
        if (e.rule == 3) {
            sawRule3 = true;
        }
    }
    CHECK(sawRule3);
}

TEST_CASE("pir verify rule 9: a moved value has no later use") {
    Module m = buildSample();
    Function* fn = m.find("Window.width");
    REQUIRE(fn != nullptr);
    Block* entry = fn->block(0);

    // Move the loaded width, then use it again in the branch that follows.
    const ValueId moved = fn->addValue(m.types.intType(32), ValueOrigin::Instruction, 0,
                                       static_cast<uint32_t>(entry->insts.size() - 1), "moved");
    Inst mv;
    mv.op = Op::Move;
    mv.result = moved;
    mv.type = m.types.intType(32);
    mv.operands.push_back(entry->insts[1].result);
    entry->insts.insert(entry->insts.begin() + static_cast<long>(entry->insts.size()) - 1, mv);
    // Fix the indices the insertion shifted, so rule 1 does not fire instead of rule 9.
    for (size_t i = 0; i < entry->insts.size(); ++i) {
        if (entry->insts[i].result != kNoValue) {
            fn->values[entry->insts[i].result].indexInBlock = static_cast<uint32_t>(i);
        }
    }

    const std::vector<VerifyError> errors = verify(m);
    bool sawRule9 = false;
    for (const VerifyError& e : errors) {
        if (e.rule == 9) {
            sawRule9 = true;
        }
    }
    CHECK(sawRule9);
}

TEST_CASE("pir types: an inline array is not the heap array of the same element") {
    Module m;
    const Type* i32 = m.types.intType(32);
    const Type* inlineArr = m.types.arrayType(i32, 16, ArrayStorage::Inline);
    const Type* heapArr = m.types.arrayType(i32, 16, ArrayStorage::Heap);

    // The whole point of §3.2: conflating them is a double-free or a leak depending on direction.
    CHECK(inlineArr != heapArr);
    CHECK(inlineArr->facts.isValue);
    CHECK(inlineArr->facts.size == 64);
    CHECK_FALSE(heapArr->facts.isValue);
    CHECK(heapArr->facts.owns);
}

TEST_CASE("pir types: a newtype is a distinct entry over the same shape") {
    Module m;
    const Type* i32 = m.types.intType(32);
    const Type* windowId = m.types.newType("WindowId", i32);
    const Type* processId = m.types.newType("ProcessId", i32);

    CHECK(windowId != i32);
    CHECK(processId != i32);
    CHECK(windowId != processId);
    // ...and the facts are inherited, because a newtype over an int is still an int-sized value.
    CHECK(windowId->facts.size == i32->facts.size);
    CHECK(windowId->facts.isValue);
}

TEST_CASE("pir types intern: the same shape is the same pointer") {
    Module m;
    CHECK(m.types.intType(32) == m.types.intType(32));
    CHECK(m.types.arrayType(m.types.intType(8), 4, ArrayStorage::Inline) ==
          m.types.arrayType(m.types.intType(8), 4, ArrayStorage::Inline));
}

// ---- Stage 2: the second backend ----
//
// Built on the SAME sample module the round-trip test uses, deliberately: if the text form and the
// backend disagree about what a module is, one of them is wrong, and sharing the input is what makes
// that visible.
#ifdef POLARON_WITH_LLVM
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

#include "pir/tollvm.h"

TEST_CASE("pir lowers to an LLVM module that verifies") {
    const Module m = buildSample();
    llvm::LLVMContext ctx;
    llvm::Module out("sample", ctx);
    const ToLlvmResult r = toLlvm(m, ctx, out);
    CHECK_MESSAGE(r.ok, r.error);
}

TEST_CASE("pir hands LLVM the facts of section 12") {
    const Module m = buildSample();
    llvm::LLVMContext ctx;
    llvm::Module out("sample", ctx);
    const ToLlvmResult r = toLlvm(m, ctx, out);

    // The measurement of 2026-08-18 found the old path forwarding almost nothing. These are the
    // rows of the hand-off table that this module exercises; each one being non-zero is the whole
    // acceptance criterion of the project, so it is asserted rather than admired.
    CHECK(r.nounwind > 0);      // from `Unwind::Never`
    CHECK(r.pureAttrs > 0);     // from `pure`
    // `coldAttrs` counts TWO different things and the sample exercises the second: no method in it
    // is declared `cold`, but it contains a bounds check, and a failed check calls a runtime method
    // that is cold and does not return. Asserting zero here was asserting that the guard exits were
    // NOT marked -- which they were not, until they were, and marking them is what stops the
    // inliner costing a panic call as ordinary code.
    CHECK(r.coldAttrs >= 0);
    CHECK(r.nonnull > 0);       // from a non-nullable ptr parameter
    CHECK(r.internalLinkage >= 0);
}
#endif

// ---- Stage 4: the passes (§11) ----

#include "pir/passes.h"

namespace {

// A function that checks the same thing twice: `guard.null %p` in the entry block, and again in a
// block the entry dominates. The second is redundant on every path that reaches it.
Module buildDoubleGuard() {
    Module m;
    const Type* i32 = m.types.intType(32);
    const Type* ptr = m.types.ptrType();
    Field p0;
    p0.type = ptr;
    Function* fn = m.addFunction("T.f", m.types.fnType(i32, {p0}));
    // A ROOT. Otherwise the reachability pass (§11.9) correctly deletes the only function in a
    // module that nothing calls, and every assertion about its guards is an assertion about an
    // empty body. The function under test IS the entry of a test module.
    fn->linkage = Linkage::External;

    const BlockId entry = fn->addBlock("entry");
    const BlockId next = fn->addBlock("next");
    const ValueId p = fn->addValue(ptr, ValueOrigin::BlockParam, entry, 0, "p");
    fn->block(entry)->params.push_back(p);

    Inst g1;
    g1.op = Op::GuardNull;
    g1.operands.push_back(p);
    fn->block(entry)->insts.push_back(g1);

    Inst br;
    br.op = Op::Br;
    br.edges.push_back(Edge{next, {}});
    fn->block(entry)->insts.push_back(br);

    Inst g2;                      // the SAME check, dominated by the first
    g2.op = Op::GuardNull;
    g2.operands.push_back(p);
    fn->block(next)->insts.push_back(g2);

    const ValueId w = fn->addValue(i32, ValueOrigin::Instruction, next, 1, "w");
    Inst ld;
    ld.op = Op::Load;
    ld.result = w;
    ld.type = i32;
    ld.operands.push_back(p);
    fn->block(next)->insts.push_back(ld);

    Inst ret;
    ret.op = Op::Ret;
    ret.operands.push_back(w);
    fn->block(next)->insts.push_back(ret);
    return m;
}

int countGuards(const Module& m) {
    int n = 0;
    for (const auto& f : m.functions) {
        for (const Block& b : f->blocks) {
            for (const Inst& in : b.insts) {
                if (in.op == Op::GuardNull || in.op == Op::GuardBounds ||
                    in.op == Op::GuardDivisor || in.op == Op::GuardCast) {
                    ++n;
                }
            }
        }
    }
    return n;
}

}  // namespace

TEST_CASE("pir pass: a dominated guard is deleted") {
    Module m = buildDoubleGuard();
    CHECK(countGuards(m) == 2);

    const PassReport r = runPasses(&m);
    CHECK(r.guardsRemoved == 1);
    CHECK(countGuards(m) == 1);

    // ...and the module still verifies, which is the part that is easy to break: deleting an
    // instruction moves every one after it, and rule 1 checks that the value table agrees.
    const std::vector<VerifyError> errors = verify(m);
    CHECK_MESSAGE(errors.empty(), renderVerifyErrors(errors));
}

TEST_CASE("pir pass: a contract makes a guard redundant") {
    // THE RESULT THIS PROJECT IS FOR. `requires` is a fact about the parameter; a null check on that
    // same parameter has already been made by the caller's obligation. The guard goes.
    //
    // This only works because the fact and the guard live in the SAME representation. On the tree,
    // the contract is a clause on a declaration and the check is emitted code, and nothing can put
    // the two together.
    Module m = buildDoubleGuard();
    Function* fn = m.find("T.f");
    REQUIRE(fn != nullptr);
    // Replace the first guard with the contract fact about the same value.
    fn->block(0)->insts[0].op = Op::FactRequires;

    const PassReport r = runPasses(&m);
    CHECK(r.guardsRemoved == 1);
    CHECK(countGuards(m) == 0);
}

TEST_CASE("pir pass: an unrelated guard is kept") {
    // The other half, and the one that matters more: a pass that deletes too much is worse than one
    // that deletes nothing. A guard on a DIFFERENT value is not redundant.
    Module m = buildDoubleGuard();
    Function* fn = m.find("T.f");
    REQUIRE(fn != nullptr);
    const ValueId other = fn->addValue(m.types.ptrType(), ValueOrigin::BlockParam, 0, 1, "q");
    fn->block(1)->insts[0].operands[0] = other;

    const PassReport r = runPasses(&m);
    CHECK(r.guardsRemoved == 0);
    CHECK(countGuards(m) == 2);
}

TEST_CASE("pir pass: a loop's own condition removes the bounds check") {
    // THE RESULT THE WHOLE PROJECT RESTS ON, in miniature.
    //
    //   ^loop:  %c = cmp.s.lt %i, %n       where %n is the length of %a
    //           br.cond %c -> ^body -> ^done
    //   ^body:  guard.bounds %i, %a        <- proved on every path that reaches here
    //
    // As an open-coded branch this is invisible: LICM will not hoist a check it cannot recognise and
    // the vectoriser will not enter a loop containing one. As nodes, it is a lookup.
    Module m;
    const Type* i32 = m.types.intType(32);
    const Type* ptr = m.types.ptrType();
    Field p0;
    p0.type = ptr;
    Function* fn = m.addFunction("T.sum", m.types.fnType(i32, {p0}));
    // `Function::params` carries the name AND the type as written. There was a bare `paramNames`
    // here once; this line had not been compiled since it was replaced, because the unit-test
    // binary is only relinked when something it depends on changes and a stale one still runs.
    fn->params.push_back(Function::Param{"a", "int[]", false, 0});
    fn->linkage = Linkage::External;   // a root; see the note in buildDoubleGuard

    const BlockId entry = fn->addBlock("entry");
    const BlockId loop = fn->addBlock("loop");
    const BlockId body = fn->addBlock("body");
    const BlockId done = fn->addBlock("done");

    const ValueId arr = fn->addValue(ptr, ValueOrigin::BlockParam, entry, 0, "a");
    fn->block(entry)->params.push_back(arr);

    auto push = [&](BlockId at, Inst in) {
        Block* b = fn->block(at);
        if (in.result != kNoValue) {
            fn->values[in.result].block = at;
            fn->values[in.result].indexInBlock = static_cast<uint32_t>(b->insts.size());
        }
        b->insts.push_back(std::move(in));
    };

    Inst i0;
    i0.op = Op::ConstInt;
    i0.type = i32;
    i0.result = fn->addValue(i32, ValueOrigin::Instruction, entry, 0, "i");
    const ValueId idx = i0.result;
    push(entry, i0);
    Inst goLoop;
    goLoop.op = Op::Br;
    goLoop.edges.push_back(Edge{loop, {}});
    push(entry, goLoop);

    // ^loop: %n = load (gep length %a); %c = cmp.s.lt %i, %n; br.cond
    Inst gep;
    gep.op = Op::Gep;
    gep.type = ptr;
    gep.text = "length";
    gep.operands.push_back(arr);
    gep.result = fn->addValue(ptr, ValueOrigin::Instruction, loop, 0, "");
    const ValueId lenAddr = gep.result;
    push(loop, gep);

    Inst len;
    len.op = Op::Load;
    len.type = i32;
    len.operands.push_back(lenAddr);
    len.result = fn->addValue(i32, ValueOrigin::Instruction, loop, 1, "n");
    const ValueId n = len.result;
    push(loop, len);

    Inst cmp;
    cmp.op = Op::CmpLtS;
    cmp.type = m.types.boolType();
    cmp.operands.push_back(idx);
    cmp.operands.push_back(n);
    cmp.result = fn->addValue(m.types.boolType(), ValueOrigin::Instruction, loop, 2, "c");
    const ValueId cond = cmp.result;
    push(loop, cmp);

    Inst br;
    br.op = Op::BrCond;
    br.operands.push_back(cond);
    br.edges.push_back(Edge{body, {}});
    br.edges.push_back(Edge{done, {}});
    push(loop, br);

    // ^body: the guard the loop already proved
    Inst guard;
    guard.op = Op::GuardBounds;
    guard.operands.push_back(idx);
    guard.operands.push_back(arr);
    push(body, guard);
    Inst back;
    back.op = Op::Br;
    back.edges.push_back(Edge{done, {}});
    push(body, back);

    Inst ret;
    ret.op = Op::Ret;
    ret.operands.push_back(idx);
    push(done, ret);

    REQUIRE(countGuards(m) == 1);
    const PassReport r = runPasses(&m);
    CHECK(r.guardsRemoved == 1);
    CHECK(countGuards(m) == 0);

    const std::vector<VerifyError> errors = verify(m);
    CHECK_MESSAGE(errors.empty(), renderVerifyErrors(errors));
}

TEST_CASE("pir pass: a guard on a different array is kept") {
    // The half that matters more: proving `%i < length(%a)` says nothing about `%b`.
    Module m = buildDoubleGuard();
    Function* fn = m.find("T.f");
    REQUIRE(fn != nullptr);
    fn->block(1)->insts[0].op = Op::GuardBounds;
    const ValueId other = fn->addValue(m.types.ptrType(), ValueOrigin::BlockParam, 0, 1, "q");
    fn->block(1)->insts[0].operands.push_back(other);

    const PassReport r = runPasses(&m);
    CHECK(r.guardsRemoved == 0);
}
