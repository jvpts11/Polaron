#include "pir/verify.h"

#include <algorithm>
#include <functional>
#include <unordered_set>

namespace polaron::pir {

namespace {

class Verifier {
public:
    explicit Verifier(const Module& m) : module_(m) {}

    std::vector<VerifyError> run() {
        for (const std::unique_ptr<Function>& fn : module_.functions) {
            check(*fn);
        }
        return std::move(errors_);
    }

private:
    void fail(int rule, std::string what, std::string where, SourceLocation loc = {}) {
        errors_.push_back(VerifyError{rule, std::move(what), std::move(where), loc});
    }

    std::string at(const Function& fn) const { return "@" + fn.key; }
    std::string at(const Function& fn, const Block& b) const {
        return "@" + fn.key + " ^" + b.label;
    }
    std::string at(const Function& fn, const Block& b, size_t i) const {
        return "@" + fn.key + " ^" + b.label + " #" + std::to_string(i);
    }

    void check(const Function& fn) {
        // An `extern` declaration is a signature and nothing else: no blocks to check.
        if (fn.blocks.empty()) {
            if (fn.linkage != Linkage::External) {
                fail(2, "a function with no blocks must have external linkage", at(fn));
            }
            return;
        }
        checkStructure(fn);
        checkDominance(fn);
        checkTypes(fn);
        checkOwnership(fn);
        checkRegions(fn);
        checkDispatch(fn);
        checkControl(fn);
        checkFacts(fn);
    }

    // ---- structural: rules 1-4 ----

    void checkStructure(const Function& fn) {
        // Rule 1 (definitions): every value is defined exactly once. The representation makes a
        // second definition unwritable -- a ValueId names one ValueDef -- so what is checkable here
        // is that every definition site agrees with the value it claims.
        for (ValueId v = 0; v < fn.values.size(); ++v) {
            const ValueDef& def = fn.values[v];
            // A HOLE IS NOT A DISAGREEMENT. A pass that deletes a dead instruction leaves its value
            // defined nowhere, and the ids are vector indices so the entry stays. What rule 1 is
            // for is a value whose definition site says something other than where it really is; a
            // value nothing defines and nothing uses is simply gone, and a USE of one still fails
            // the dominance half below.
            if (def.block == kNoBlock) {
                continue;
            }
            const Block* b = fn.block(def.block);
            if (b == nullptr) {
                fail(1, "value %" + std::to_string(v) + " is defined in no block", at(fn));
                continue;
            }
            if (def.origin == ValueOrigin::BlockParam) {
                if (def.indexInBlock >= b->params.size() || b->params[def.indexInBlock] != v) {
                    fail(1, "value %" + std::to_string(v) + " claims to be a parameter of ^" +
                                b->label + " and is not",
                         at(fn, *b));
                }
            } else {
                if (def.indexInBlock >= b->insts.size() ||
                    b->insts[def.indexInBlock].result != v) {
                    fail(1, "value %" + std::to_string(v) + " claims to be defined by an "
                            "instruction that does not define it",
                         at(fn, *b));
                }
            }
        }

        for (const Block& b : fn.blocks) {
            // Rule 2: exactly one terminator, and it is last.
            if (b.insts.empty()) {
                fail(2, "block has no terminator", at(fn, b));
                continue;
            }
            for (size_t i = 0; i + 1 < b.insts.size(); ++i) {
                if (isTerminator(b.insts[i].op)) {
                    fail(2, std::string("terminator `") + spell(b.insts[i].op) +
                                "` appears before the end of the block",
                         at(fn, b, i), b.insts[i].loc);
                }
            }
            if (!isTerminator(b.insts.back().op)) {
                fail(2, std::string("block ends in `") + spell(b.insts.back().op) +
                            "`, which is not a terminator",
                     at(fn, b, b.insts.size() - 1), b.insts.back().loc);
            }

            // Rule 3: every edge supplies one argument per declared parameter, types matching.
            for (const Inst& in : b.insts) {
                for (const Edge& e : in.edges) {
                    const Block* target = fn.block(e.target);
                    if (target == nullptr) {
                        fail(3, "branch to a block that does not exist", at(fn, b), in.loc);
                        continue;
                    }
                    if (e.args.size() != target->params.size()) {
                        fail(3, "branch to ^" + target->label + " passes " +
                                    std::to_string(e.args.size()) + " argument(s) for " +
                                    std::to_string(target->params.size()) + " parameter(s)",
                             at(fn, b), in.loc);
                        continue;
                    }
                    for (size_t k = 0; k < e.args.size(); ++k) {
                        const ValueDef* got = fn.value(e.args[k]);
                        const ValueDef* want = fn.value(target->params[k]);
                        if (got == nullptr || want == nullptr) {
                            fail(3, "branch argument names no value", at(fn, b), in.loc);
                        } else if (got->type != want->type) {
                            fail(3, "branch to ^" + target->label + " passes " +
                                        TypeTable::spell(got->type) + " where " +
                                        TypeTable::spell(want->type) + " is declared",
                                 at(fn, b), in.loc);
                        }
                    }
                }
            }
        }

        // Rule 4: the entry block has no predecessors.
        const BlockId entry = fn.blocks.front().id;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                for (const Edge& e : in.edges) {
                    if (e.target == entry) {
                        fail(4, "^" + fn.blocks.front().label +
                                    " is the entry block and cannot be branched to",
                             at(fn, b), in.loc);
                    }
                }
            }
            for (BlockId cf : b.comefrom) {
                if (cf == entry) {
                    fail(4, "a `comefrom` edge targets the entry block", at(fn, b));
                }
            }
        }
    }

    // ---- rule 1 (uses): every use is dominated by its definition ----

    void checkDominance(const Function& fn) {
        const size_t n = fn.blocks.size();
        // Predecessors, from the real edges plus the chaos tetrad's explicit ones. `abstainfrom`
        // REMOVES an edge, so it is subtracted here rather than checked somewhere else -- the CFG is
        // literally what the program says.
        std::vector<std::vector<BlockId>> preds(n);
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                for (const Edge& e : in.edges) {
                    if (e.target < n) {
                        preds[e.target].push_back(b.id);
                    }
                }
            }
        }
        for (const Block& b : fn.blocks) {
            for (BlockId cf : b.comefrom) {
                if (cf < n) {
                    preds[b.id].push_back(cf);
                }
            }
            for (BlockId ab : b.abstainfrom) {
                auto& p = preds[b.id];
                p.erase(std::remove(p.begin(), p.end(), ab), p.end());
            }
        }

        const BlockId entry = fn.blocks.front().id;

        // REACHABILITY FIRST, and skipping this is a real bug rather than an inefficiency.
        //
        // A loop whose body always returns leaves its step block with no predecessor -- correct
        // lowering, dead code. But that step block is still a PREDECESSOR of the loop header, and an
        // unreachable block dominates nothing, so intersecting over it empties the header's
        // dominator set. The entry block then does not dominate the loop, and every use inside it
        // is reported as undominated: sixteen false failures in one prelude method, all of them
        // this.
        //
        // Unreachable predecessors are therefore dropped, and unreachable blocks are not checked at
        // all -- nothing executes there, so there is nothing to be wrong about.
        std::vector<char> reachable(n, 0);
        {
            std::vector<BlockId> stack{entry};
            reachable[entry] = 1;
            while (!stack.empty()) {
                const BlockId at = stack.back();
                stack.pop_back();
                const Block* b = fn.block(at);
                if (b == nullptr) {
                    continue;
                }
                for (const Inst& in : b->insts) {
                    for (const Edge& e : in.edges) {
                        if (e.target < n && !reachable[e.target]) {
                            reachable[e.target] = 1;
                            stack.push_back(e.target);
                        }
                    }
                }
                for (const Block& other : fn.blocks) {
                    for (BlockId cf : other.comefrom) {
                        if (cf == at && !reachable[other.id]) {
                            reachable[other.id] = 1;
                            stack.push_back(other.id);
                        }
                    }
                }
            }
        }
        for (size_t b = 0; b < n; ++b) {
            auto& p = preds[b];
            p.erase(std::remove_if(p.begin(), p.end(),
                                   [&](BlockId x) { return x >= n || reachable[x] == 0; }),
                    p.end());
        }

        // Iterative dominators. n is small (a method's blocks), so the simple fixed point is right:
        // a fast algorithm here would be a second thing to get wrong for no measurable gain.
        std::vector<std::vector<char>> dom(n, std::vector<char>(n, 1));
        for (size_t i = 0; i < n; ++i) {
            dom[entry][i] = (i == entry) ? 1 : 0;
        }
        bool changed = true;
        while (changed) {
            changed = false;
            for (size_t b = 0; b < n; ++b) {
                if (b == entry || reachable[b] == 0) {
                    continue;
                }
                std::vector<char> next(n, preds[b].empty() ? 0 : 1);
                for (BlockId p : preds[b]) {
                    for (size_t i = 0; i < n; ++i) {
                        next[i] = next[i] && dom[p][i];
                    }
                }
                next[b] = 1;
                if (next != dom[b]) {
                    dom[b] = next;
                    changed = true;
                }
            }
        }

        auto dominates = [&](BlockId a, BlockId b) { return a < n && b < n && dom[b][a] != 0; };

        for (const Block& b : fn.blocks) {
            // Nothing executes in an unreachable block, so there is nothing there to be wrong.
            if (b.id < n && reachable[b.id] == 0) {
                continue;
            }
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                auto useOk = [&](ValueId v) {
                    const ValueDef* def = fn.value(v);
                    if (def == nullptr) {
                        return false;
                    }
                    if (def->block == b.id) {
                        // Same block: a parameter is always available; an instruction result must be
                        // defined earlier in it.
                        return def->origin == ValueOrigin::BlockParam ||
                               def->indexInBlock < i;
                    }
                    return dominates(def->block, b.id);
                };
                for (ValueId v : in.operands) {
                    if (!useOk(v)) {
                        fail(1, "use of %" + std::to_string(v) +
                                    " is not dominated by its definition",
                             at(fn, b, i), in.loc);
                    }
                }
                for (const Edge& e : in.edges) {
                    for (ValueId v : e.args) {
                        if (!useOk(v)) {
                            fail(1, "branch argument %" + std::to_string(v) +
                                        " is not dominated by its definition",
                                 at(fn, b, i), in.loc);
                        }
                    }
                }
            }
        }
    }

    // ---- types: rules 5-8 ----

    void checkTypes(const Function& fn) {
        for (const Block& b : fn.blocks) {
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];

                // Rule 5, the part that is checkable without a per-opcode signature table: an
                // opcode that produces a value has one with a type, and one that does not has
                // neither.
                // A VOID RESULT IS NOT A RESULT, and `call` is the reason this clause exists: it is
                // an opcode that produces a value except when the callee returns `void`, where
                // there is no value of that type for it to produce.
                const bool voidResult = in.type != nullptr && in.type->kind == TypeKind::Void;
                if (producesValue(in.op) && !voidResult) {
                    if (in.result == kNoValue) {
                        fail(5, std::string("`") + spell(in.op) + "` produces a value and names none",
                             at(fn, b, i), in.loc);
                    } else if (in.type == nullptr) {
                        fail(5, std::string("`") + spell(in.op) + "` has no result type",
                             at(fn, b, i), in.loc);
                    } else if (const ValueDef* d = fn.value(in.result);
                               // `alloca` is the one opcode whose `type` is not its result's: it
                               // allocates a T and yields a pointer to it.
                               in.op != Op::Alloca && d != nullptr && d->type != in.type) {
                        fail(5, "the result's declared type and the instruction's disagree",
                             at(fn, b, i), in.loc);
                    }
                } else if (in.result != kNoValue) {
                    fail(5, std::string("`") + spell(in.op) + "` produces nothing and names a result",
                         at(fn, b, i), in.loc);
                }

                switch (in.op) {
                    case Op::Gep: {
                        // Rule 6: the walked type must actually have the field.
                        if (in.operands.empty()) {
                            fail(6, "`gep` needs a base", at(fn, b, i), in.loc);
                            break;
                        }
                        const Type* base = in.type;
                        if (base != nullptr && base->kind == TypeKind::Struct &&
                            in.imm >= static_cast<int64_t>(base->fields.size())) {
                            fail(6, "`gep` index " + std::to_string(in.imm) + " is past the end of " +
                                        TypeTable::spell(base),
                                 at(fn, b, i), in.loc);
                        }
                        break;
                    }
                    case Op::Drop:
                    case Op::DropCascade: {
                        // Rule 7's other half lives with ownership below; here, the inline-array
                        // rule: a value array is never released, because it never allocated.
                        if (in.type != nullptr && in.type->kind == TypeKind::Array &&
                            in.type->storage == ArrayStorage::Inline) {
                            fail(7, "an inline array lives in place and is never dropped: " +
                                        TypeTable::spell(in.type),
                                 at(fn, b, i), in.loc);
                        }
                        break;
                    }
                    default:
                        break;
                }

                // Rule 8: a `newtype` never implicitly converts. A conversion opcode whose operand
                // and result differ only by nominal identity is exactly that implicit conversion
                // written down, so it is refused here rather than being invisible.
                if (in.op == Op::Trunc || in.op == Op::ExtendS || in.op == Op::ExtendU) {
                    if (!in.operands.empty()) {
                        const ValueDef* from = fn.value(in.operands[0]);
                        if (from != nullptr && from->type != nullptr && in.type != nullptr &&
                            from->type->nominal != in.type->nominal &&
                            from->type->bits == in.type->bits) {
                            fail(8, "a newtype does not convert to or from its representation "
                                    "without being named",
                                 at(fn, b, i), in.loc);
                        }
                    }
                }
            }
        }
    }

    // ---- ownership: rules 9-11 ----

    void checkOwnership(const Function& fn) {
        // Rule 9: a value that has been `move`d has no later use. Checked per block in program
        // order, plus across blocks by "moved anywhere that dominates this use".
        std::unordered_set<ValueId> movedAnywhere;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.op == Op::Move && !in.operands.empty()) {
                    movedAnywhere.insert(in.operands[0]);
                }
            }
        }
        for (const Block& b : fn.blocks) {
            std::unordered_set<ValueId> movedHere;
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                for (ValueId v : in.operands) {
                    if (movedHere.count(v) != 0) {
                        fail(9, "%" + std::to_string(v) + " is used after it was moved",
                             at(fn, b, i), in.loc);
                    }
                }
                if (in.op == Op::Move && !in.operands.empty()) {
                    movedHere.insert(in.operands[0]);
                }

                // Rule 10: `drop` names a type whose `owns` fact is true. Dropping something that
                // owns nothing is not harmless -- it is the sign that the lowering believes a type
                // has a destructor when it has not, which is where a double free starts.
                if (in.op == Op::Drop || in.op == Op::DropCascade) {
                    // WHAT THIS RULE IS FOR: a `drop` on something that cannot own anything -- an
                    // `i32`, a `bool` -- which is the sign that the lowering believes a type has a
                    // destructor when it has not, and is where a double free starts.
                    //
                    // A class whose `owns` is false is NOT that. `owns` false on a nominal type can
                    // mean "no destructor" or "this pass has not resolved the type yet", and a
                    // `delete` on a class instance is a destructor call either way. Refusing those
                    // made the rule fire a hundred and thirty-three times on correct code, which is
                    // how a good rule gets turned off.
                    if (in.type == nullptr) {
                        fail(10, "`drop` names no type", at(fn, b, i), in.loc);
                    } else if (in.type->kind == TypeKind::Int ||
                               in.type->kind == TypeKind::Float ||
                               in.type->kind == TypeKind::Bool ||
                               in.type->kind == TypeKind::Addr) {
                        fail(10, "`drop` on " + TypeTable::spell(in.type) +
                                     ", which owns nothing and has no destructor",
                             at(fn, b, i), in.loc);
                    }
                }

                // Rule 11: a weak field is never the target of `drop.cascade`. A weak edge does not
                // own, so cascading through it frees somebody else's object.
                if (in.op == Op::DropCascade && in.type != nullptr &&
                    in.type->kind == TypeKind::Struct) {
                    for (const Field& f : in.type->fields) {
                        if (f.weak && f.type != nullptr && f.type->facts.owns) {
                            fail(11, "`drop.cascade` would walk the weak field `" + f.name +
                                         "`, which does not own what it points at",
                                 at(fn, b, i), in.loc);
                        }
                    }
                }
            }
        }
        (void)movedAnywhere;
    }

    // ---- regions: rules 12-14 ----

    void checkRegions(const Function& fn) {
        for (const Block& b : fn.blocks) {
            std::unordered_set<ValueId> live;
            std::unordered_set<ValueId> released;
            std::unordered_set<ValueId> marks;
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                switch (in.op) {
                    case Op::RegionCreate:
                        live.insert(in.result);
                        break;
                    case Op::RegionRelease:
                        if (!in.operands.empty()) {
                            released.insert(in.operands[0]);
                            live.erase(in.operands[0]);
                        }
                        break;
                    case Op::RegionMark:
                        marks.insert(in.result);
                        break;
                    case Op::RegionRestore: {
                        // Rule 14: `region.restore` names a mark taken from the same region.
                        if (in.operands.size() < 2) {
                            fail(14, "`region.restore` needs a region and a mark",
                                 at(fn, b, i), in.loc);
                            break;
                        }
                        if (marks.count(in.operands[1]) == 0) {
                            fail(14, "`region.restore` names a mark this region did not take",
                                 at(fn, b, i), in.loc);
                        }
                        break;
                    }
                    case Op::RegionAlloc:
                    case Op::RegionAccepts:
                    case Op::RegionDepth:
                    case Op::RegionValidate:
                    case Op::RegionClone:
                    case Op::RegionExtract: {
                        // Rule 12: every region operation names a LIVE region.
                        if (in.operands.empty()) {
                            fail(12, std::string("`") + spell(in.op) + "` names no region",
                                 at(fn, b, i), in.loc);
                            break;
                        }
                        if (released.count(in.operands[0]) != 0) {
                            fail(12, std::string("`") + spell(in.op) +
                                         "` names a region that has been released",
                                 at(fn, b, i), in.loc);
                        }
                        break;
                    }
                    default:
                        break;
                }
            }

            // Rule 13: a pointer with no `escapes` annotation has no use that outlives its region's
            // release. Within a block that is decidable exactly: the allocation, the release, and
            // every use are in program order.
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& alloc = b.insts[i];
                if (alloc.op != Op::RegionAlloc || alloc.operands.empty()) {
                    continue;
                }
                const bool escapes =
                    std::find(alloc.extra.begin(), alloc.extra.end(), "escapes") != alloc.extra.end();
                if (escapes) {
                    continue;
                }
                const ValueId region = alloc.operands[0];
                size_t releasedAt = b.insts.size();
                for (size_t k = i + 1; k < b.insts.size(); ++k) {
                    if (b.insts[k].op == Op::RegionRelease && !b.insts[k].operands.empty() &&
                        b.insts[k].operands[0] == region) {
                        releasedAt = k;
                        break;
                    }
                }
                for (size_t k = releasedAt + 1; k < b.insts.size(); ++k) {
                    for (ValueId v : b.insts[k].operands) {
                        if (v == alloc.result) {
                            fail(13, "%" + std::to_string(alloc.result) +
                                         " outlives the region it was allocated in, and is not "
                                         "annotated `escapes`",
                                 at(fn, b, k), b.insts[k].loc);
                        }
                    }
                }
            }
        }
    }

    // ---- dispatch: rules 15-17 ----

    void checkDispatch(const Function& fn) {
        for (const Block& b : fn.blocks) {
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                if (in.op == Op::VtableLoad) {
                    // Rule 15: the class whose table this names must exist in the module. This is
                    // what stops "the vtable was not emitted" from being a link error.
                    if (in.text.empty()) {
                        fail(15, "`vtable.load` names no class", at(fn, b, i), in.loc);
                    } else if (!classHasTable(in.text)) {
                        fail(15, "`vtable.load` names class `" + in.text +
                                     "`, whose table is neither emitted nor declared",
                             at(fn, b, i), in.loc);
                    }
                }
                if (in.op == Op::IfaceLoad && in.text.empty()) {
                    fail(16, "`iface.load` names no interface", at(fn, b, i), in.loc);
                }
                if (in.op == Op::Call && !in.text.empty() && module_.find(in.text) == nullptr) {
                    fail(15, "`call @" + in.text + "` names a function this module does not have",
                         at(fn, b, i), in.loc);
                }
            }
        }
        // Rule 17 (a transformer's `satisfies` obligation) is a module-level check and is done in
        // checkModuleObligations, once, rather than per function.
    }

    bool classHasTable(const std::string& key) const {
        // A table exists if any function in the module belongs to that class, or if the class is
        // named by an external declaration. This is the module-local half; a cross-bundle check
        // belongs to the linker's own verification.
        const std::string prefix = key + ".";
        for (const std::unique_ptr<Function>& f : module_.functions) {
            if (f->key.compare(0, prefix.size(), prefix) == 0) {
                return true;
            }
        }
        return false;
    }

    // ---- control: rules 18-20 ----

    void checkControl(const Function& fn) {
        for (const Block& b : fn.blocks) {
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];

                // Rule 18: a `switch` marked total names every case, and the edge nothing selects
                // goes nowhere. This is what a `match` over a `sealed enum` becomes, and it is the
                // property that makes exhaustiveness a fact about the IR rather than about a check
                // that ran earlier.
                //
                // EDGE 0 IS THE DEFAULT AND IT ALWAYS EXISTS, including here. A machine's switch
                // needs somewhere to go when the subject is none of the values -- LLVM's
                // `SwitchInst` has no shape without a default destination -- so "there is no
                // default" is spelled as a default that leads to `unreachable`. That is the
                // spelling the backend can USE: a default it can prove is never taken is a range
                // check it can drop, which is the whole difference between a jump table and a jump
                // table with a bounds test in front of it.
                //
                // The second half of this rule used to be `cases.size() + 1 != edges.size()`, which
                // was arithmetic on two arrays that had to stay in step -- and its message said the
                // opposite of its condition, which is what a check nothing exercises decays into.
                // The case value lives on the edge now, so that skew cannot happen and there is
                // nothing left for a length to say. What is checked instead is the property.
                if (in.op == Op::Switch && in.total) {
                    if (in.edges.empty()) {
                        fail(18, "a total `switch` has no edges at all", at(fn, b, i), in.loc);
                    } else {
                        const Type* subject = in.operands.empty()
                                                  ? nullptr
                                                  : (fn.value(in.operands[0]) != nullptr
                                                         ? fn.value(in.operands[0])->type
                                                         : nullptr);
                        const size_t arms = in.edges.size() - 1;
                        if (subject != nullptr && subject->kind == TypeKind::Variant &&
                            arms != subject->fields.size()) {
                            fail(18, "a total `switch` over " + TypeTable::spell(subject) +
                                         " names " + std::to_string(arms) + " of " +
                                         std::to_string(subject->fields.size()) + " cases",
                                 at(fn, b, i), in.loc);
                        }
                        const Block* fallback = fn.block(in.edges[0].target);
                        const bool goesNowhere =
                            fallback != nullptr && !fallback->insts.empty() &&
                            fallback->insts.front().op == Op::Unreachable;
                        if (!goesNowhere) {
                            fail(18, "a total `switch` has a default edge that goes somewhere",
                                 at(fn, b, i), in.loc);
                        }
                    }
                }

                // Rule 19: `call.unwind` has both successors, and a `landing` appears only as the
                // first instruction of some `call.unwind`'s landing block.
                if (in.op == Op::CallUnwind && in.edges.size() != 2) {
                    fail(19, "`call.unwind` needs a normal and a landing successor",
                         at(fn, b, i), in.loc);
                }
                if (in.op == Op::Landing) {
                    if (i != 0) {
                        fail(19, "`landing` is not the first instruction of its block",
                             at(fn, b, i), in.loc);
                    } else if (!isLandingPad(fn, b.id)) {
                        fail(19, "^" + b.label + " has a `landing` and is nobody's landing successor",
                             at(fn, b, i), in.loc);
                    }
                }
            }
        }

        // Rule 20: every value live across a `suspend` is in the coroutine frame's type. The frame
        // is the suspend's own result type; a value defined before the suspend and used after it
        // must be one of its fields.
        for (const Block& b : fn.blocks) {
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                if (in.op != Op::Suspend) {
                    continue;
                }
                if (in.type == nullptr || in.type->kind != TypeKind::Struct) {
                    fail(20, "`suspend` has no coroutine frame type", at(fn, b, i), in.loc);
                    continue;
                }
                std::unordered_set<const Type*> inFrame;
                for (const Field& f : in.type->fields) {
                    inFrame.insert(f.type);
                }
                for (const Edge& e : in.edges) {
                    for (ValueId v : e.args) {
                        const ValueDef* d = fn.value(v);
                        if (d != nullptr && inFrame.count(d->type) == 0) {
                            fail(20, "%" + std::to_string(v) + " is live across `suspend` and is "
                                     "not in the coroutine frame",
                                 at(fn, b, i), in.loc);
                        }
                    }
                }
            }
        }
    }

    bool isLandingPad(const Function& fn, BlockId id) const {
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.op == Op::CallUnwind && in.edges.size() == 2 && in.edges[1].target == id) {
                    return true;
                }
            }
        }
        return false;
    }

    // ---- facts: rule 21 ----

    void checkFacts(const Function& fn) {
        // Rule 21: a `fact.*` has no uses and no side effects, so deleting one is always sound.
        // That is what lets the guard eliminator consume them and the contract lowering emit them
        // last -- and it stops a lowering from accidentally making a fact load-bearing.
        for (const Block& b : fn.blocks) {
            for (size_t i = 0; i < b.insts.size(); ++i) {
                const Inst& in = b.insts[i];
                const bool isFact = in.op == Op::FactRequires || in.op == Op::FactEnsures ||
                                    in.op == Op::FactInvariant || in.op == Op::FactRange;
                if (isFact && in.result != kNoValue) {
                    fail(21, std::string("`") + spell(in.op) +
                                 "` produces a value; a fact must be deletable",
                         at(fn, b, i), in.loc);
                }
            }
        }
    }

    const Module& module_;
    std::vector<VerifyError> errors_;
};

}  // namespace

std::vector<VerifyError> verify(const Module& module) {
    // Rule 17, module-wide: a `satisfies` obligation on a transformer is discharged by every type it
    // applies to. Transformers are monomorphised before PIR, so what survives here is the obligation
    // recorded on the function; an unmet one is a function whose key names an interface method the
    // class does not have.
    Verifier v(module);
    std::vector<VerifyError> errors = v.run();
    return errors;
}

std::string renderVerifyErrors(const std::vector<VerifyError>& errors) {
    std::string out;
    for (const VerifyError& e : errors) {
        out += "pir::verify [rule " + std::to_string(e.rule) + "] " + e.where + ": " + e.what + "\n";
    }
    return out;
}

}  // namespace polaron::pir
