#include "pir/passes.h"

#include <algorithm>
#include <cstdlib>
#include <string>
#include <unordered_map>
#include <unordered_set>

namespace polaron::pir {

namespace {

// Predecessors, from the real edges plus the chaos tetrad's explicit ones. Shared by every pass
// that needs the CFG, because two walks that build the same graph slightly differently is exactly
// the class of bug this project keeps removing.
std::vector<std::vector<BlockId>> predecessorsOf(const Function& fn) {
    const size_t n = fn.blocks.size();
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
    return preds;
}

// Iterative dominators. The functions here are a method's worth of blocks, so the simple fixed
// point is the right one: a faster algorithm is a second thing to get wrong for no measurable gain.
std::vector<std::vector<char>> dominatorsOf(const Function& fn) {
    const size_t n = fn.blocks.size();
    const std::vector<std::vector<BlockId>> preds = predecessorsOf(fn);
    std::vector<std::vector<char>> dom(n, std::vector<char>(n, 1));
    if (n == 0) {
        return dom;
    }
    const BlockId entry = fn.blocks.front().id;
    for (size_t i = 0; i < n; ++i) {
        dom[entry][i] = (i == entry) ? 1 : 0;
    }
    bool changed = true;
    while (changed) {
        changed = false;
        for (size_t b = 0; b < n; ++b) {
            if (b == entry) {
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
    return dom;
}

// WHAT A GUARD IS ABOUT, said so that two of them can be recognised as the same one.
//
// Keyed on raw value ids this pass removed NOTHING -- measured, across the whole corpus:
// `guards-removed=0`. And it could not have removed anything, because the thing it is looking for
// never has the same ids twice:
//
//     ^loop:  %3 = load %i        %4 = load len(%a)    %5 = cmp.s.lt %3, %4
//             br.cond %5 -> ^body
//     ^body:  %7 = load %i        guard.bounds %7, %a        <- %7 is not %3
//
// `%3` and `%7` are the same VALUE -- the same slot, with no store between the test and the use --
// and two different value ids. So the fact the branch proved and the guard that wants it were
// spelled differently and never met.
//
// The name below is the slot a value was last loaded from rather than the load itself, which is the
// smallest thing that makes those two agree. Its soundness is the caller's: `eliminateGuards` drops
// a fact the moment anything stores to the slot it names.
//
// ONE TABLE, BUILT BEFORE ANYTHING IS TOUCHED.
//
// Read from the blocks on demand, this answered a load with `no operands` -- because the removal
// loop below MOVES each instruction into the kept list as it goes, so every entry it has already
// passed is an empty shell. A pass that reads the container it is rebuilding gets whatever is left
// of it, which is exactly as wrong as it sounds and looks like nothing at all: the key came out
// spelled with raw ids, matched nothing, and the whole optimisation silently did not happen.
std::vector<ValueId> originsOf(const Function& fn) {
    std::vector<ValueId> origin(fn.values.size());
    for (ValueId v = 0; v < origin.size(); ++v) {
        origin[v] = v;
    }
    // One sweep is enough for a load, and the second and third pick up a load reached through width
    // conversions -- `trunc`/`sext` between the header's sixty-four bits and an index's thirty-two.
    for (int round = 0; round < 3; ++round) {
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.result == kNoValue || in.result >= origin.size() || in.operands.empty()) {
                    continue;
                }
                if (in.op == Op::Load) {
                    origin[in.result] = in.operands[0];   // the SLOT: stable across reloads
                } else if (in.op == Op::Trunc || in.op == Op::ExtendS || in.op == Op::ExtendU) {
                    origin[in.result] = origin[in.operands[0]];   // a width change is not a value
                }
            }
        }
    }
    return origin;
}

std::string guardKey(const std::vector<ValueId>& origin, const Inst& in) {
    std::string k = spell(in.op);
    for (ValueId v : in.operands) {
        k += '|' + std::to_string(v < origin.size() ? origin[v] : v);
    }
    return k;
}

ValueId originOf(const std::vector<ValueId>& origin, ValueId v) {
    return v < origin.size() ? origin[v] : v;
}

bool isGuard(Op op) {
    return op == Op::GuardBounds || op == Op::GuardNull || op == Op::GuardDivisor ||
           op == Op::GuardCast;
}

bool isFact(Op op) {
    return op == Op::FactRequires || op == Op::FactEnsures || op == Op::FactInvariant ||
           op == Op::FactRange;
}

// WHERE EACH VALUE COMES FROM, once, for the whole method. The rule below has to walk backwards
// from a condition to the comparison that produced it and from there to a length read, and doing
// that by scanning the enclosing block finds only what happens to have been written in the same
// block -- which for a `requires` at the top of a method and an index deep inside a loop is never.
std::vector<const Inst*> definitionsOf(const Function& fn) {
    std::vector<const Inst*> def(fn.values.size(), nullptr);
    for (const Block& b : fn.blocks) {
        for (const Inst& in : b.insts) {
            if (in.result != kNoValue && in.result < def.size()) {
                def[in.result] = &in;
            }
        }
    }
    return def;
}

// WHAT A TRUE CONDITION PROVES, as the same keys the guards are spelled with.
//
// This exists in one place because it has two callers that had no business being different:
//
//   - a `br.cond` whose true edge leads to the block being examined, and
//   - a `guard.contract` that DID NOT TRAP, which is the same statement about every instruction
//     after it.
//
// The second is the "contracts that pay for themselves" result, and it was not happening at all:
// `requires index < this.count` was checked, the answer was thrown away, and the `a[index]` two
// lines below still paid for a bounds check the method had just proved. A contract is the cheapest
// fact a program can offer an optimiser -- the programmer wrote it down and the compiler already
// emitted the branch -- and until now this pass read only the branch.
std::unordered_set<std::string> provenBy(const std::vector<const Inst*>& def,
                                         const std::vector<ValueId>& origin, ValueId cond) {
    std::unordered_set<std::string> out;
    const Inst* c = cond < def.size() ? def[cond] : nullptr;
    if (c == nullptr || c->operands.size() != 2) {
        return out;
    }
    // `i < n` and `n > i` are the same sentence, and both get written. Which side is the index is
    // decided by which side reads a length, not by the direction of the operator.
    ValueId index = kNoValue;
    ValueId bound = kNoValue;
    if (c->op == Op::CmpLtS || c->op == Op::CmpLtU) {
        index = c->operands[0];
        bound = c->operands[1];
    } else if (c->op == Op::CmpGtS || c->op == Op::CmpGtU) {
        index = c->operands[1];
        bound = c->operands[0];
    } else {
        return out;
    }
    // Through any width conversion. The header holds sixty-four bits and an index thirty-two, and
    // following the `trunc` is not a nicety: leaving it out silently stopped every bounds check
    // from being eliminated, and nothing failed -- the code just got slower.
    for (int hop = 0; hop < 4; ++hop) {
        const Inst* d = bound < def.size() ? def[bound] : nullptr;
        if (d == nullptr || d->operands.empty() ||
            (d->op != Op::Trunc && d->op != Op::ExtendS && d->op != Op::ExtendU)) {
            break;
        }
        bound = d->operands[0];
    }
    const Inst* len = bound < def.size() ? def[bound] : nullptr;
    if (len == nullptr || len->op != Op::Load || len->operands.empty()) {
        return out;
    }
    const Inst* gep = len->operands[0] < def.size() ? def[len->operands[0]] : nullptr;
    if (gep == nullptr || gep->op != Op::Gep || gep->text != "length" || gep->operands.empty()) {
        return out;
    }
    // NAMED THE WAY THE GUARD WILL BE. The index is the SLOT it was loaded from, not this
    // particular load of it, or the fact and the guard are two spellings that never meet.
    out.insert("guard.bounds|" + std::to_string(originOf(origin, index)) + "|" +
               std::to_string(originOf(origin, gep->operands[0])));
    return out;
}

// WHICH §11 PASSES TO RUN, as a name list, so a misbehaving program can be bisected against the
// pipeline instead of against a rebuild.
//
// `POLARON_PIR_PASSES=fold,guards` runs those two and no others; an empty value runs none. Unset --
// which is every ordinary build -- runs all of them. This is the same kind of switch as
// `POLARON_PIR_OPT` and exists for the same reason: when a 66 000-line kernel boots one way and
// hangs the other, the first question is WHICH transformation changed it, and answering that by
// editing this file and rebuilding costs twenty minutes per guess.
bool passEnabled(const char* name) {
    const char* list = std::getenv("POLARON_PIR_PASSES");
    if (list == nullptr) {
        return true;
    }
    const std::string want(name);
    const std::string have(list);
    for (size_t at = 0; at <= have.size();) {
        const size_t end = have.find(',', at);
        const size_t stop = end == std::string::npos ? have.size() : end;
        if (have.compare(at, stop - at, want) == 0) {
            return true;
        }
        if (end == std::string::npos) {
            break;
        }
        at = end + 1;
    }
    return false;
}

class Passes {
public:
    explicit Passes(Module& m) : m_(m) {}

    PassReport run() {
        const bool fold = passEnabled("fold");
        const bool guards = passEnabled("guards");
        const bool immutable = passEnabled("immutable");
        const bool dead = passEnabled("dead");
        const bool purity = passEnabled("purity");
        // BEFORE `dead`, AND THAT ORDER IS THE POINT. Devirtualising leaves the `vtable.load` with
        // nothing using it; the dead-code pass is what removes it, so running the two the other way
        // round removes the dispatch from the call and leaves the table lookup standing beside it --
        // the load still emitted, still a dependent chain, and the win reduced to the indirect
        // branch alone.
        if (passEnabled("devirt")) {
            devirtualise();
        }
        // §11.5, also module-wide, because its parameter summary is: a constructor in one function
        // decides whether an allocation in another stays in its frame.
        if (passEnabled("escape")) {
            analyseEscapes();
        }
        for (const std::unique_ptr<Function>& f : m_.functions) {
            if (f->blocks.empty()) {
                continue;
            }
            if (fold) { foldConstants(*f); }
            if (guards) { eliminateGuards(*f); }
            if (immutable) { propagateImmutability(*f); }
            if (dead) { removeDead(*f); }
            if (purity) { decidePurity(*f); }
        }
        if (passEnabled("reach")) {
            reachability();
        }
        return r_;
    }

    // ---- §11.2: constant folding ----
    //
    // `add.checked` of two constants is a constant, and the overflow rule is part of the opcode --
    // which is the whole point of putting it there. A fold that had to reconstruct whether the
    // language checks, wraps or saturates could not be written; here it reads it off the opcode.
    //
    // It runs FIRST because everything after it is better with fewer unknowns: a guard on a constant
    // index, a branch on a constant condition, a loop bound the eliminator can compare against.
    void foldConstants(Function& fn) {
        std::unordered_map<ValueId, int64_t> known;
        for (Block& b : fn.blocks) {
            for (Inst& in : b.insts) {
                if (in.op == Op::ConstInt || in.op == Op::ConstBool) {
                    // A CONSTANT WIDER THAN `imm` IS NOT KNOWN HERE. A `Decimal` literal is a
                    // hundred and twenty-eight bits and travels as digits in `text`; its `imm` is
                    // zero, and recording that folded `0.00m - 2.75m` to zero -- the right shape of
                    // arithmetic over the wrong number. This fold works in sixty-four bits; a
                    // constant that does not fit is one it must decline to know.
                    if (in.type != nullptr && in.type->bits > 64) {
                        continue;
                    }
                    known[in.result] = in.imm;
                    continue;
                }
                if (in.operands.size() != 2 || in.result == kNoValue ||
                    (in.type != nullptr && in.type->bits > 64)) {
                    continue;
                }
                auto l = known.find(in.operands[0]);
                auto r = known.find(in.operands[1]);
                if (l == known.end() || r == known.end()) {
                    continue;
                }
                const int64_t a = l->second;
                const int64_t c = r->second;
                bool folded = true;
                int64_t v = 0;
                switch (in.op) {
                    case Op::AddChecked: case Op::AddWrap: v = a + c; break;
                    case Op::SubChecked: case Op::SubWrap: v = a - c; break;
                    case Op::MulChecked: case Op::MulWrap: v = a * c; break;
                    case Op::DivChecked: case Op::DivTrap:
                        if (c == 0) { folded = false; } else { v = a / c; }
                        break;
                    case Op::RemChecked: case Op::RemTrap:
                        if (c == 0) { folded = false; } else { v = a % c; }
                        break;
                    case Op::And: v = a & c; break;
                    case Op::Or:  v = a | c; break;
                    case Op::Xor: v = a ^ c; break;
                    case Op::CmpEq:  v = a == c; break;
                    case Op::CmpNe:  v = a != c; break;
                    case Op::CmpLtS: v = a < c;  break;
                    case Op::CmpLeS: v = a <= c; break;
                    case Op::CmpGtS: v = a > c;  break;
                    case Op::CmpGeS: v = a >= c; break;
                    default: folded = false; break;
                }
                if (!folded) {
                    continue;
                }
                in.op = (in.type != nullptr && in.type->kind == TypeKind::Bool) ? Op::ConstBool
                                                                               : Op::ConstInt;
                in.imm = v;
                in.operands.clear();
                known[in.result] = v;
                ++r_.factsPropagated;
            }
        }
    }

    // ---- §12: `pure` ----
    //
    // A function that writes nothing and calls nothing impure is `readnone`, `speculatable` and
    // `willreturn` -- which lets LLVM hoist it out of a loop, common-subexpression two calls to it,
    // and delete one whose result is unused. Three of the strongest things the optimiser can do,
    // and all of them need this one fact.
    //
    // Decided here rather than declared by the programmer: the compiler can see it, and a fact the
    // compiler can see is a fact the programmer should not have to promise. Conservative -- an
    // unresolved call makes a function impure -- because claiming purity wrongly is miscompilation,
    // while missing it costs only the optimisation.
    void decidePurity(Function& fn) {
        if (fn.pure) {
            return;
        }
        bool reads = false;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                // A LOAD IS NOT NOTHING. It does not stop the function being pure -- reading a
                // field is what a getter does -- but it is the whole difference between `readonly`
                // and `readnone`, and only the second entitles the optimiser to move the call
                // ACROSS a store. Read as `readnone`, `return this.screen;` was hoisted above the
                // store that filled the field, and pico's console dispatched through a vtable
                // pointer it had read out of the BIOS interrupt table.
                if (in.op == Op::Load || in.op == Op::AtomicLoad) {
                    reads = true;
                }
                switch (in.op) {
                    case Op::Store: case Op::MemCopy: case Op::MemSet: case Op::MemMove:
                    case Op::AtomicStore: case Op::AtomicRmw: case Op::AtomicCmpXchg:
                    case Op::RegionCreate: case Op::RegionAlloc: case Op::RegionRelease:
                    case Op::RegionRestore: case Op::RegionExtract: case Op::ItselfAlloc:
                    case Op::Drop: case Op::DropCascade: case Op::Forget:
                    case Op::CallIndirect: case Op::CallUnwind: case Op::ClosureCall:
                    case Op::Asm: case Op::LockAcquire: case Op::LockRelease: case Op::Fence:
                    case Op::Suspend: case Op::Alloca: case Op::LazyGet:
                        return;
                    case Op::Call: {
                        const Function* callee = m_.find(in.text);
                        if (callee == nullptr || !callee->pure) {
                            return;
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        fn.pure = true;
        fn.readsMemory = reads;
        ++r_.factsPropagated;
    }

    // ---- §11.9: reachability ----
    //
    // A FUNCTION NOTHING CAN REACH IS NOT PART OF THE PROGRAM. Without this the module carries the
    // whole prelude, and the first program built through PIR failed to link on
    // `System.Concurrency.__chanNew` -- a channel constructor, in a program that has no channels,
    // dragged in because every prelude class was emitted whether or not anything called it.
    //
    // The roots are what the outside world can enter through: the entry point, anything with
    // external or public linkage, the lifecycle hooks, and every function `unimport` may cut back in
    // (§6's `Cut`) -- that last one is why a plain "delete what nothing calls" is wrong here.
    //
    // What is unreachable becomes a DECLARATION rather than being erased: a `vtable.load` or a call
    // this pass could not see still needs the name to resolve, and the linker drops an unused
    // declaration for free. Erasing outright is how a reachability pass turns a missing edge into an
    // undefined symbol at link time.
    void reachability() {
        std::unordered_map<std::string, Function*> byKey;
        for (const std::unique_ptr<Function>& f : m_.functions) {
            byKey[f->key] = f.get();
        }

        std::vector<Function*> work;
        std::unordered_set<std::string> live;
        auto root = [&](Function* f) {
            if (f != nullptr && live.insert(f->key).second) {
                work.push_back(f);
            }
        };
        for (const std::unique_ptr<Function>& f : m_.functions) {
            const bool isEntry = f->key.size() > 5 &&
                                 f->key.compare(f->key.size() - 5, 5, ".main") == 0;
            // `public` IS NOT A ROOT IN A PROGRAM. Visibility says who may call a method, not that
            // anybody does -- and almost every prelude method is public, so treating it as a root
            // kept 2 251 definitions in a program that loops three times. A library build is the
            // other case and is not this one: there the exported surface IS the entry, and the
            // driver knows which build it is.
            //
            // `External` stays a root because it has no body to remove, `cut` because `unimport`
            // may call it later (§6), and an interrupt because the hardware enters it.
            // ...AND A FUNCTION THE MACHINE ENTERS, WHICH NOTHING IN THE PROGRAM CALLS.
            //
            // A `naked` method is one: pico's `_start` is `unknown sysv naked`, the firmware jumps
            // to it, and no call to it exists anywhere in the kernel. Stripped, the image lost its
            // entry point AND the sections that body carries inside its `asm` -- the PVH note QEMU
            // reads to find the entry, the multiboot2 header, the page tables. QEMU refused the
            // image outright: "Error loading uncompressed kernel without PVH ELF Note". A foreign
            // convention says the same thing more generally: the caller is not in this module.
            const bool machineEnters = f->conv == Conv::Naked || f->conv == Conv::Unknown;
            // ...AND A RUNTIME ENTRY POINT, WHICH NOTHING IN PIR CALLS BECAUSE THE CALL DOES NOT
            // EXIST YET.
            //
            // `__polaron_malloc` is not called by any instruction in this module. A heap `new` is an
            // `alloca` with a flag, and the CALL to the allocator is synthesised by the backend --
            // after this pass has run. So the walk looked for a caller, found none, and turned the
            // one allocator in a freestanding kernel into a declaration. The module then carried 336
            // calls to `@__polaron_malloc` and no body for it.
            //
            // What that produced was not a link error. pico brought up every driver, the network
            // stack and the whole desktop, painted a window and its title, and then took a #GP while
            // DELIVERING THE TIMER INTERRUPT -- because by then something had written over the IDT.
            // Every object the desktop allocated came from an allocator that was not there.
            //
            // Two rules, because there are two ways to be one of these.
            //
            // A FOREIGN SYMBOL IS A BOUNDARY. A method that carries one is reached by a name from
            // outside this module -- that is what giving it a symbol MEANS -- so no edge in this
            // graph can ever reach it and the walk will always conclude it is dead. It is the same
            // set `internalizeProgram` keeps published, for the same reason, and the trusted path's
            // `stripDeadCode` roots it too. `__polaron_malloc` is exactly this: the bridge a
            // `heap class` provides, whose whole purpose is to be called by generated code.
            //
            // And the PREFIX, for the helpers with no symbol of their own: `__polaron_free` and
            // `__polaron_check_live` were going the same way, and the next helper the backend learns
            // to call would have gone too. Rooting them costs nothing in a hosted program, where
            // they are external declarations with no body to keep.
            const bool isRuntime = !f->symbol.empty() || f->key.compare(0, 10, "__polaron_") == 0;
            // ...AND WHAT AN ENTRY THAT DOES NOT EXIST YET WILL CALL. Under `--test` the entry is
            // the synthetic runner, built after this pass has run; until then a `[Test]` method and
            // its `[BeforeAll]` fixture are reachable from nothing at all, and this concludes --
            // correctly, on what it can see -- that they are dead. See `Module::extraRoots`.
            const bool namedRoot = std::find(m_.extraRoots.begin(), m_.extraRoots.end(), f->key) !=
                                   m_.extraRoots.end();
            // ...AND IN A LIBRARY, THE EXPORTED SURFACE IS THE ENTRY.
            //
            // The paragraph above says `public` is not a root in a PROGRAM, and names this as the
            // other case. It was named and not written, which stayed invisible for as long as the
            // `.polb` carried the other back end's module: with PIR's, `bundle_calc` failed at link
            // on `undefined symbol: Calc.square` -- a method whose whole reason to exist is that
            // somebody outside this compilation calls it, stripped because nobody inside does.
            const bool exported = m_.library && f->linkage == Linkage::Public;
            if (isEntry || f->linkage == Linkage::External || f->cut ||
                f->kind == FnKind::Interrupt || machineEnters || isRuntime || namedRoot ||
                exported) {
                root(f.get());
            }
        }
        for (const Hook& h : m_.init) {
            root(byKey.count(h.fnKey) != 0 ? byKey[h.fnKey] : nullptr);
        }
        for (const Hook& h : m_.fini) {
            root(byKey.count(h.fnKey) != 0 ? byKey[h.fnKey] : nullptr);
        }

        while (!work.empty()) {
            Function* f = work.back();
            work.pop_back();
            for (const Block& b : f->blocks) {
                for (const Inst& in : b.insts) {
                    if (in.text.empty()) {
                        continue;
                    }
                    // `call.unwind` NAMES A CALLEE TOO. Left out of this list, every method called
                    // from inside a `try` looked unreachable and its body was turned back into a
                    // declaration -- the link then failed with `Main.risky` undefined, on a program
                    // whose only unusual feature was a `try` around the call.
                    if (in.op == Op::Call || in.op == Op::CallUnwind || in.op == Op::ConstFn ||
                        in.op == Op::ClosureMake) {
                        root(byKey.count(in.text) != 0 ? byKey[in.text] : nullptr);
                    }
                    // A `drop` CALLS A DESTRUCTOR, and it names the class rather than the method --
                    // so a walk that only follows `call` removed the one body a `delete` needs.
                    // `delete_multi` failed to link on `Res.~Res`, a destructor twelve lines above
                    // the `delete` that wanted it.
                    if (in.op == Op::Drop || in.op == Op::DropCascade) {
                        const std::string dtor = in.text + ".~" + in.text;
                        root(byKey.count(dtor) != 0 ? byKey[dtor] : nullptr);
                    }
                    // A GUARD THAT THROWS BUILDS AN OBJECT, so the class it names is instantiated
                    // by that guard even though no `call` in the module says so -- the constructor
                    // call is emitted by the backend, on the cold path. Without this the body was
                    // removed and the link failed on `DivideByZeroException.DivideByZeroException`
                    // in a program whose only mention of it is a `catch` clause.
                    if ((in.op == Op::GuardDivisor || in.op == Op::GuardNull ||
                         in.op == Op::AddChecked || in.op == Op::SubChecked ||
                         in.op == Op::MulChecked) &&
                        !in.text.empty()) {
                        const std::string ctor = in.text + "." + in.text;
                        root(byKey.count(ctor) != 0 ? byKey[ctor] : nullptr);
                    }
                    // A VTABLE IS LIVE WHEN THE CLASS IS INSTANTIATED, and not before. The table is
                    // data the linker keeps, so every slot in it must name a body that still
                    // exists -- but rooting every table outright drags in the whole prelude
                    // transitively and the program then fails to link on builtins nobody called
                    // (`File.readAll`, `ZoneOffset.__polaron_local_utc_offset_seconds`).
                    //
                    // The precise trigger is the reference itself: only a constructor that runs
                    // takes the address of its class's table, so seeing that reference is exactly
                    // "an instance of this class can exist". Design note at the head of the spec:
                    // "vtables not gated by reachability -> undefined symbol".
                    if (in.op == Op::ConstFn && byKey.count(in.text) == 0) {
                        for (const Global& g : m_.globals) {
                            if (g.name != in.text) {
                                continue;
                            }
                            for (const std::string& slot : g.initFns) {
                                if (!slot.empty()) {
                                    root(byKey.count(slot) != 0 ? byKey[slot] : nullptr);
                                }
                            }
                        }
                    }
                    // ...AND A `new` KEEPS THE CLASS'S TABLE. The reference above is emitted by the
                    // constructor, which is enough for a class whose constructor is reached through
                    // an ordinary call -- but a synthesized one is reached the same way and the
                    // allocation site names the class too. Rooting from the allocation as well
                    // closes the case where the constructor is inlined away before this runs.
                    if (in.op == Op::Alloca && !in.text.empty()) {
                        const std::string table = in.text + ".vtable";
                        for (const Global& g : m_.globals) {
                            if (g.name != table) {
                                continue;
                            }
                            for (const std::string& slot : g.initFns) {
                                if (!slot.empty()) {
                                    root(byKey.count(slot) != 0 ? byKey[slot] : nullptr);
                                }
                            }
                        }
                    }
                    // A virtual call can land on any override, so the CLASS named by a
                    // `vtable.load` keeps every method of that class. Conservative on purpose: a
                    // reachability pass that is too clever removes something a dispatch can reach.
                    if (in.op == Op::VtableLoad || in.op == Op::IfaceLoad) {
                        const std::string prefix = in.text + ".";
                        for (const std::unique_ptr<Function>& g : m_.functions) {
                            if (g->key.compare(0, prefix.size(), prefix) == 0) {
                                root(g.get());
                            }
                        }
                    }
                }
            }
        }

        for (const std::unique_ptr<Function>& f : m_.functions) {
            if (f->blocks.empty() || live.count(f->key) != 0) {
                continue;
            }
            f->blocks.clear();
            f->values.clear();
            f->linkage = Linkage::External;   // a declaration; the linker drops an unused one
            ++r_.deadRemoved;
        }

        // ...AND THE TABLES ARE PRUNED TO MATCH. A dead function becomes a declaration, and a
        // declaration has no address to put in a slot -- so a vtable still naming it is a
        // relocation to a symbol nothing defines, which is the failure this whole gate exists to
        // prevent. An emptied slot is a null pointer: nothing can dispatch to it, which is correct
        // for a method of a class no live code can construct.
        for (Global& g : m_.globals) {
            for (std::string& slot : g.initFns) {
                if (!slot.empty() && live.count(slot) == 0) {
                    slot.clear();
                }
            }
        }
    }

private:
    // ---- §11.3: guard elimination ----
    //
    // THE PASS THAT PAYS FOR THE PROJECT. A guard is deleted when an identical one already
    // dominates it: the check has been made, on the same values, on every path that reaches here.
    //
    // This is the whole argument for naming guards as instructions. As an open-coded branch, "the
    // same check twice" is two diamonds in the CFG that LICM cannot merge and the vectoriser will
    // not look past. As a node with a key, it is a set lookup.
    void eliminateGuards(Function& fn) {
        const std::vector<ValueId> origin = originsOf(fn);   // before anything is moved out of a block
        const std::vector<const Inst*> def = definitionsOf(fn);
        const std::vector<std::vector<char>> dom = dominatorsOf(fn);
        const std::vector<std::vector<BlockId>> preds = predecessorsOf(fn);
        const size_t n = fn.blocks.size();

        // What each block establishes, and what holds on entry to it. A guard holds on entry when
        // it was established by every block that dominates this one.
        //
        // A contract that did not trap is keyed by its CONDITION, because the removal loop below
        // needs the same answer a second time and an instruction is not a stable name for itself:
        // the loop moves each one into the kept list as it goes, so a pointer taken here is a
        // pointer to something that has been emptied by the time it is read.
        std::vector<std::unordered_set<std::string>> established(n);
        std::unordered_map<ValueId, std::unordered_set<std::string>> contractProves;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (isGuard(in.op)) {
                    established[b.id].insert(guardKey(origin, in));
                }
                // A CONTRACT IS A GUARD THAT WAS ALREADY CHECKED. `requires this.n >= 0` at the top
                // of a method makes every bounds check on `this.n` inside it redundant -- which is
                // the "contracts that pay for themselves" result, and it only works because the
                // fact and the guard live in the same representation.
                if (isFact(in.op)) {
                    for (ValueId v : in.operands) {
                        established[b.id].insert("guard.null|" + std::to_string(v));
                        established[b.id].insert("guard.divisor|" + std::to_string(v));
                    }
                }
                // THE CHECKED CONTRACT, which is the one that carries a condition. `fact.*` above
                // is a marker the lowering emits with no operands at all; `guard.contract` is the
                // branch the programmer's `requires` actually became, and past it the clause is
                // true for the rest of the method.
                if (in.op == Op::GuardContract && !in.operands.empty()) {
                    std::unordered_set<std::string> k = provenBy(def, origin, in.operands[0]);
                    if (!k.empty()) {
                        established[b.id].insert(k.begin(), k.end());
                        contractProves[in.operands[0]] = std::move(k);
                    }
                }
            }
        }

        // ---- WHAT A BRANCH PROVED ----
        //
        // This is the pass the whole project rests on, and the plain "the same guard already ran"
        // rule is only half of it. The other half is that a CONDITION a branch tested is true in the
        // block it branches to:
        //
        //     ^loop:  %i = load ...;  %n = load length(%a);  %c = cmp.s.lt %i, %n
        //             br.cond %c -> ^body -> ^done
        //     ^body:  guard.bounds %i, %a          <- already proved, on every path that gets here
        //
        // As an open-coded branch that is invisible: LICM will not hoist a check it cannot recognise
        // and the vectoriser will not enter a loop containing one. As a `guard.bounds` node against
        // a `cmp` node, it is a lookup -- and a `foreach` over an array loses its bounds check
        // entirely.
        //
        // The fact is attached to the TRUE successor only, and only when that successor has this
        // block as its single predecessor: reaching it another way means the condition was not
        // necessarily tested.
        std::vector<std::unordered_set<std::string>> proven(n);
        for (const Block& b : fn.blocks) {
            if (b.insts.empty()) {
                continue;
            }
            const Inst& term = b.insts.back();
            if (term.op != Op::BrCond || term.edges.size() != 2 || term.operands.empty()) {
                continue;
            }
            const BlockId whenTrue = term.edges[0].target;
            if (whenTrue >= n || preds[whenTrue].size() != 1) {
                continue;
            }
            const std::unordered_set<std::string> k = provenBy(def, origin, term.operands[0]);
            proven[whenTrue].insert(k.begin(), k.end());
        }

        for (Block& b : fn.blocks) {
            std::unordered_set<std::string> holds;
            for (size_t d = 0; d < n; ++d) {
                if (d != b.id && dom[b.id][d] != 0) {
                    holds.insert(established[d].begin(), established[d].end());
                    holds.insert(proven[d].begin(), proven[d].end());
                }
            }
            holds.insert(proven[b.id].begin(), proven[b.id].end());
            std::vector<Inst> kept;
            kept.reserve(b.insts.size());
            for (Inst& in : b.insts) {
                // A FACT ABOUT A SLOT DIES WHEN SOMETHING WRITES THE SLOT. That is what buys the
                // right to name a value by where it was loaded from: `i < a.length` is proved about
                // `i`, and it stops being proved the moment `i = i + 1` runs. The name of the slot
                // appears in the key, so dropping every key that mentions it is the whole rule.
                //
                // Conservative in the two places it matters: a call may write through any address
                // it was given, so a fact about anything that is not a frame slot is dropped at one;
                // and a store through a computed address drops everything, because "which slot" is
                // not a question this pass can answer about a `gep` of a `gep`.
                if (in.op == Op::Store && in.operands.size() > 1) {
                    const std::string written = "|" + std::to_string(originOf(origin, in.operands[1]));
                    for (auto it = holds.begin(); it != holds.end();) {
                        it = it->find(written) != std::string::npos ? holds.erase(it) : std::next(it);
                    }
                } else if (in.op == Op::Call || in.op == Op::CallIndirect ||
                           in.op == Op::CallUnwind || in.op == Op::ClosureCall ||
                           in.op == Op::MemCopy || in.op == Op::MemSet || in.op == Op::MemMove ||
                           in.op == Op::Asm) {
                    holds.clear();
                }
                if (isGuard(in.op)) {
                    const std::string k = guardKey(origin, in);
                    if (holds.count(k) != 0) {
                        ++r_.guardsRemoved;
                        continue;   // already checked on every path that reaches here
                    }
                    holds.insert(k);
                }
                // Past a contract that did not trap, its clause is true. Added HERE rather than up
                // front so it holds for what follows it and not for what precedes it -- a
                // `requires` in the middle of a method says nothing about the lines above it.
                if (in.op == Op::GuardContract && !in.operands.empty()) {
                    auto it = contractProves.find(in.operands[0]);
                    if (it != contractProves.end()) {
                        holds.insert(it->second.begin(), it->second.end());
                        r_.contractFacts += static_cast<int>(it->second.size());
                    }
                }
                kept.push_back(std::move(in));
            }
            b.insts = std::move(kept);
            reindex(fn, b);
        }
    }

    // ---- §11.4: immutability propagation ----
    //
    // A slot never stored to after its initialisation is not a variable, it is a value. Recording
    // that is what lets §12 put `!invariant.load` on the load and `readonly` on the parameter, so
    // the load hoists out of a loop and survives across a call.
    //
    // Counted rather than rewritten here: the rewrite belongs to the backend, which knows what an
    // `alloca` costs on its target. What this pass owns is the FACT.
    void propagateImmutability(Function& fn) {
        std::unordered_map<ValueId, int> stores;
        std::unordered_set<ValueId> slots;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.op == Op::Alloca) {
                    slots.insert(in.result);
                }
                if (in.op == Op::Store && in.operands.size() >= 2) {
                    ++stores[in.operands[1]];
                }
            }
        }
        for (ValueId slot : slots) {
            if (stores[slot] <= 1) {
                ++r_.slotsMadeImmutable;
            }
        }
    }

    // ---- §11.5: escape analysis ----
    //
    // *"An object allocated `on heap` that provably does not escape becomes `on stack`."*
    //
    // The whole transformation is two words: the lowering marks an allocation `[heap]` and the
    // matching `drop` the same way, and the backend reads that one note to choose between
    // `__polaron_malloc` and a frame slot, between `__polaron_free` and nothing. So this pass does
    // not rewrite any code -- it removes a note from two instructions, and a malloc/free pair, a
    // pointer chase and a header stop existing. The destructor still runs, because it is not part
    // of the note.
    //
    // WHAT MAKES IT HARD IS NOT THE REWRITE, IT IS THE WORD "PROVABLY", and a plain use-walk finds
    // an escape immediately in code that has none. Two things stand between an allocation and its
    // uses in every program:
    //
    //   %6 = alloca %Point [heap]            <- the allocation
    //   call @Point.Point %6, %2, %5         <- ...handed to the constructor, which is a CALL
    //   store %6, %7:p                       <- ...and put in a local, which is a STORE
    //   %9 = load ptr %7:p                   <- every later use comes back through the local
    //
    // A pass that calls a store an escape and a call an escape fires on nothing at all, and looks
    // exactly like a pass that works. So both are answered rather than assumed:
    //
    //   - THE LOCAL. A frame slot whose own address never leaves the function is not memory the
    //     program can reach any other way, so a pointer stored into it has not gone anywhere.
    //     Loads from that slot are the same pointer, and the walk follows them.
    //   - THE CALL. `does parameter i of this method escape` is a summary computed once for the
    //     whole module, by fixpoint, starting from EVERY parameter escaping and only ever proving
    //     otherwise. A constructor that writes its arguments into `this` does not leak `this`: the
    //     value STORED is the argument, and `this` is only the address. That is the common case and
    //     it is what makes the pass fire; recursion never proves and stays on the heap.
    void analyseEscapes() {
        summariseParameters();
        for (const std::unique_ptr<Function>& f : m_.functions) {
            if (!f->blocks.empty()) {
                giveTheFrameWhatDoesNotOutliveIt(*f);
            }
        }
        // ...AND THE SUMMARY IS LEFT ON THE MODULE, because §11.7 holds it against the region
        // binder's own answer. An analysis that is only ever consumed by the pass that computed it
        // has nobody to disagree with.
        m_.paramStaysInside = safeParams_;
    }

    // WHICH PARAMETERS A METHOD DOES NOT LET OUT. Pessimistic to begin with -- every parameter of
    // every method escapes -- and each round proves what it can from what is known so far. Facts
    // only ever accumulate, so it converges, and a cycle in the call graph simply never proves,
    // which is the safe direction to be undecided in.
    void summariseParameters() {
        if (!safeParams_.empty()) {
            return;
        }
        for (const std::unique_ptr<Function>& f : m_.functions) {
            safeParams_[f->key].assign(f->params.size(), false);
        }
        bool again = true;
        while (again) {
            again = false;
            for (const std::unique_ptr<Function>& f : m_.functions) {
                // A METHOD WITH NO BODY TELLS US NOTHING. An `extern`, a foreign symbol, a bundle's
                // declaration: its code is somewhere this compilation cannot read, so every one of
                // its parameters stays escaping. That is the same boundary §11.8 refuses to cross
                // and for the same reason -- what is not here cannot be reasoned about.
                if (f->blocks.empty() || f->blocks.front().params.empty()) {
                    continue;
                }
                std::vector<bool>& safe = safeParams_[f->key];
                const Block& entry = f->blocks.front();
                for (size_t i = 0; i < safe.size() && i < entry.params.size(); ++i) {
                    if (!safe[i] && !escapes(*f, entry.params[i]) &&
                        !freesIt(*f, entry.params[i])) {
                        safe[i] = true;
                        again = true;
                    }
                }
            }
        }
    }

    // The rewrite: every `[heap]` allocation that stays inside the frame stops being one, and the
    // `drop` that would have freed it stops freeing it. Both notes go, or neither -- a stack address
    // handed to `__polaron_free` corrupts the heap, and that is the failure this pass is one line
    // away from at every moment.
    void giveTheFrameWhatDoesNotOutliveIt(Function& fn) {
        if (watchesTheAllocator(fn)) {
            return;
        }
        std::vector<ValueId> keeps;
        for (Block& b : fn.blocks) {
            for (Inst& in : b.insts) {
                if (in.op != Op::Alloca || in.result == kNoValue || !isHeap(in)) {
                    continue;
                }
                if (!fitsInAFrame(in) || escapes(fn, in.result)) {
                    continue;
                }
                // ...AND IF IT IS IN A LOOP, §11.6 RATHER THAN §11.5, which is a different proof.
                // A frame slot is ONE address reused every iteration, so two objects from two
                // iterations that are both still live would become one object. `diesInItsIteration`
                // is what rules that out, and until it does the allocation stays on the heap.
                const bool round = inALoop(fn, in.result);
                if (round && !diesInItsIteration(fn, b, in.result)) {
                    continue;
                }
                dropHeapNote(in);
                keeps.push_back(in.result);
                if (round) {
                    ++r_.allocationsHoisted;
                } else {
                    ++r_.heapToStack;
                }
            }
        }
        if (keeps.empty()) {
            return;
        }
        // AND THE `drop`s FOR THEM. Reached through the same walk that proved the allocation stays,
        // because a `delete p` reads `p` out of the local and the value it frees is a LOAD, not the
        // allocation -- so matching them by value id alone frees a slot the pass just moved.
        for (ValueId kept : keeps) {
            std::unordered_set<ValueId> same;
            reaching(fn, kept, &same);
            for (Block& b : fn.blocks) {
                for (Inst& in : b.insts) {
                    if ((in.op == Op::Drop || in.op == Op::DropCascade) && !in.operands.empty() &&
                        same.count(in.operands[0]) != 0) {
                        dropHeapNote(in);
                    }
                }
            }
        }
    }

    // A FRAME IS NOT A HEAP, and the two differ in the one way that matters here: nobody grows a
    // frame. An object whose size this compilation does not know, or knows to be large, stays where
    // the author put it -- a megabyte moved onto the stack is not a faster program, it is a crash
    // in a thread with a small one, and it would arrive nowhere near this file.
    //
    // ...AND NOTHING INSIDE A LOOP, which is a correctness rule and not a policy. A frame slot is
    // ONE address reused every iteration; two objects from two iterations that are both still live
    // would become the same object. The allocation that survives its iteration is §11.6's subject,
    // and it is a different question with a different answer.
    bool fitsInAFrame(const Inst& in) const {
        // AN `alloca` CARRIES ITS SHAPE IN `type`, not in `aggregate`. Both fields exist and both
        // hold a `const Type*`; a `drop` uses `aggregate` for the object whose String fields it has
        // to release, and an allocation uses `type` for the thing being made. Reading the wrong one
        // is not an error anywhere -- it is a null, so `bytes` was 0, so this said no to every
        // allocation in the program and the pass reported `heap-to-stack=0`. Which is exactly what
        // a pass that works looks like when the program has nothing for it to do.
        const uint64_t bytes = in.type != nullptr ? in.type->facts.size : 0;
        return bytes != 0 && bytes <= kFrameBudget;
    }

    // ---- §11.6: allocation hoisting ----
    //
    // *"An allocation inside a loop whose result dies in the iteration moves out."*
    //
    // It is §11.5 with one more thing proved, and it is where the pass is worth the most: an
    // allocation outside a loop costs one call to the allocator, and one INSIDE costs a call per
    // iteration. The frame slot the backend makes lives in the entry block -- "IN THE ENTRY BLOCK,
    // ALWAYS" -- so hoisting is not a code motion at all. Removing the `[heap]` note IS the hoist,
    // and the allocation stops happening more than once.
    //
    // WHAT MUST BE TRUE BEYOND NOT ESCAPING: no two iterations may hold the object at once, because
    // one frame slot is one address and they would be holding the same object. The condition asked
    // for here is deliberately the blunt one -- the `drop` is in the SAME BLOCK, after the
    // allocation. A block has one terminator and it is at the end, so everything between the two
    // runs, and the object is dead before control can come round again. A `delete` in a later block
    // or on one arm of a branch is a stronger analysis for a smaller case; those are refused rather
    // than guessed at, and the refusal is why this is a separate question from §11.5's.
    bool diesInItsIteration(const Function& fn, const Block& b, ValueId made) const {
        std::unordered_set<ValueId> same;
        reaching(fn, made, &same);
        bool afterTheAllocation = false;
        for (const Inst& in : b.insts) {
            if (in.result == made) {
                afterTheAllocation = true;
                continue;
            }
            if (afterTheAllocation && (in.op == Op::Drop || in.op == Op::DropCascade) &&
                !in.operands.empty() && same.count(in.operands[0]) != 0) {
                return true;
            }
        }
        return false;
    }

    // A FUNCTION THAT ASKS THE ALLOCATOR WHAT IT IS HOLDING HAS MADE THAT AN OBSERVABLE.
    //
    // `Test.liveBytes()` and `Test.assertNoLeaks` exist so a program can be wrong in the one way no
    // correctness assertion can see -- right answer, growing by a megabyte a second (§32.11). A
    // pass that moves an allocation off the heap changes the number those read, and it changed it:
    //
    //     long before = Test.liveBytes();
    //     Node* leaked = new Node(7) on heap;
    //     long held   = Test.liveBytes();     // held > before, says the test
    //
    // Nothing connects the allocation to the two calls -- no operand, no use, no ordering the graph
    // records -- so no amount of local reasoning about where that object goes will ever notice. The
    // dependency is on the ALLOCATOR'S STATE, which this pass is quietly editing.
    //
    // So the rule is about the function, not the allocation: a body that reads the allocator's
    // accounting has ordered itself against it, and its allocations stay exactly where the author
    // put them. `output-differential-is-blind-to-memory` is the same lesson from the other end --
    // a test that compares only OUTPUT cannot see memory, and here memory IS the output.
    //
    // Worth saying plainly: `Polaron-0B1A` warns about the very line above ("allocated on the heap
    // and deleted in the same block") and its `fix` is what this pass does. The advice and the pass
    // agree; what was missing is that a program measuring the heap is not making that mistake.
    static bool watchesTheAllocator(const Function& fn) {
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.op != Op::Call && in.op != Op::CallUnwind) {
                    continue;
                }
                if (in.text.rfind("__polaron_live", 0) == 0 ||
                    in.text.rfind("__polaron_check_live", 0) == 0 ||
                    in.text.find(".liveBytes") != std::string::npos ||
                    in.text.find(".liveCount") != std::string::npos ||
                    in.text.find(".assertNoLeaks") != std::string::npos) {
                    return true;
                }
            }
        }
        return false;
    }

    static bool isHeap(const Inst& in) {
        return std::find(in.extra.begin(), in.extra.end(), "heap") != in.extra.end();
    }

    static void dropHeapNote(Inst& in) {
        in.extra.erase(std::remove(in.extra.begin(), in.extra.end(), std::string("heap")),
                       in.extra.end());
    }

    // Whether the block defining `v` can reach itself. Computed on the block graph rather than by
    // looking for a back edge, because PIR does not label one and a loop written as two branches
    // into a shared header is the same cycle by another spelling.
    bool inALoop(const Function& fn, ValueId v) const {
        if (v >= fn.values.size() || fn.values[v].block == kNoBlock) {
            return true;   // undecidable: the safe answer
        }
        const BlockId from = fn.values[v].block;
        std::vector<BlockId> work;
        std::unordered_set<BlockId> seen;
        for (const Block& b : fn.blocks) {
            if (b.id != from) {
                continue;
            }
            for (const Inst& in : b.insts) {
                for (const Edge& e : in.edges) {
                    if (seen.insert(e.target).second) {
                        work.push_back(e.target);
                    }
                }
            }
        }
        while (!work.empty()) {
            const BlockId at = work.back();
            work.pop_back();
            if (at == from) {
                return true;
            }
            for (const Block& b : fn.blocks) {
                if (b.id != at) {
                    continue;
                }
                for (const Inst& in : b.insts) {
                    for (const Edge& e : in.edges) {
                        if (seen.insert(e.target).second) {
                            work.push_back(e.target);
                        }
                    }
                }
            }
        }
        return false;
    }

    // Every value that is the pointer `root`, including the ones that came back out of a local it
    // was stored into. Written apart from `escapes` because the rewrite needs the SET (to find the
    // `drop`s) and the decision needs only the answer, and computing the set twice by two routes is
    // how the two come to disagree.
    void reaching(const Function& fn, ValueId root, std::unordered_set<ValueId>* out) const {
        std::unordered_map<ValueId, const Inst*> defs;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.result != kNoValue) {
                    defs.emplace(in.result, &in);
                }
            }
        }
        out->insert(root);
        std::unordered_set<ValueId> slots;
        bool again = true;
        while (again) {
            again = false;
            for (const Block& b : fn.blocks) {
                for (const Inst& in : b.insts) {
                    if (in.op == Op::Store && in.operands.size() >= 2 &&
                        out->count(in.operands[0]) != 0 && isPrivateSlot(fn, defs, in.operands[1])) {
                        again |= slots.insert(in.operands[1]).second;
                    } else if (in.op == Op::Load && in.result != kNoValue && !in.operands.empty() &&
                               slots.count(in.operands[0]) != 0) {
                        again |= out->insert(in.result).second;
                    } else if ((in.op == Op::Gep || in.op == Op::Bitcast) && in.result != kNoValue &&
                               !in.operands.empty() && out->count(in.operands.back()) != 0) {
                        // A `gep` is a pointer INTO the object, and it carries the object's fate:
                        // handing a field's address to something that keeps it keeps the object.
                        again |= out->insert(in.result).second;
                    }
                }
            }
        }
    }

    // A frame slot the function keeps to itself. `store %6, %7:p` puts a pointer somewhere no other
    // part of the program can reach, so it has not gone anywhere -- but only while the SLOT's own
    // address stays here too. The moment it is passed, stored or returned, everything that was ever
    // in it is reachable from outside.
    bool isPrivateSlot(const Function& fn, const std::unordered_map<ValueId, const Inst*>& defs,
                       ValueId slot) const {
        const auto at = defs.find(slot);
        if (at == defs.end() || at->second->op != Op::Alloca || isHeap(*at->second)) {
            return false;
        }
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                for (size_t i = 0; i < in.operands.size(); ++i) {
                    if (in.operands[i] != slot) {
                        continue;
                    }
                    const bool asAnAddress = (in.op == Op::Load && i == 0) ||
                                             (in.op == Op::Store && i == 1);
                    if (!asAnAddress) {
                        return false;
                    }
                }
                for (const Edge& e : in.edges) {
                    for (ValueId v : e.args) {
                        if (v == slot) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    // Does this pointer get out? Answered over the set `reaching` builds, so a use of the value
    // after it has been through a local counts as a use of the allocation.
    // A CALLEE THAT FREES WHAT IT WAS GIVEN. Not an escape -- nothing keeps the pointer, and the
    // escape walk is right to say so -- and the caller must still not put that object in its frame:
    //
    //     public method run() returns void { ...; delete this; return; }
    //     Worker* w = new Worker() on heap;  w.run();
    //
    // `this` does not escape `run`, so the summary called it safe, so `w` did not escape `main`, so
    // this pass gave `w` a frame slot -- and `run` handed a stack address to `__polaron_free`. The
    // heap was corrupted before `main` printed anything. `delete this` is a legitimate thing for a
    // method to do; the note four screens up says a stack address in the allocator "is the failure
    // this pass is one line away from at every moment", and the line was here.
    //
    // Judged for PARAMETERS only. A `drop` of the function's OWN allocation is the end of its life
    // and the reason the promotion is possible at all -- that case is `useIsContained`'s, and it
    // stays. What differs about a parameter is whose object it is.
    bool freesIt(const Function& fn, ValueId root) {
        std::unordered_set<ValueId> same;
        reaching(fn, root, &same);
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if ((in.op == Op::Drop || in.op == Op::DropCascade) && !in.operands.empty() &&
                    same.count(in.operands[0]) != 0) {
                    return true;
                }
            }
        }
        return false;
    }

    bool escapes(const Function& fn, ValueId root) {
        std::unordered_set<ValueId> same;
        reaching(fn, root, &same);
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                for (size_t i = 0; i < in.operands.size(); ++i) {
                    if (same.count(in.operands[i]) == 0) {
                        continue;
                    }
                    if (!useIsContained(fn, in, i, same)) {
                        return true;
                    }
                }
                // A BLOCK ARGUMENT IS A JOIN, and following one means knowing which of the incoming
                // values a parameter holds on the path being asked about. That is a dataflow the
                // rest of this pass does not do, so a pointer that reaches a block parameter is
                // conservatively out. It is a real limit, and it is written here rather than
                // silently producing a smaller number.
                for (const Edge& e : in.edges) {
                    for (ValueId v : e.args) {
                        if (same.count(v) != 0) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    // One use, judged. Everything not named here escapes, which is the right default for a list
    // that grows: an opcode added later is out until somebody decides it is in.
    bool useIsContained(const Function& fn, const Inst& in, size_t i,
                        const std::unordered_set<ValueId>& same) {
        switch (in.op) {
            case Op::Load:
                return i == 0;   // reading THROUGH it, not handing it over
            case Op::Store:
                // Operand 1 is the address written to: that is a use of the object. Operand 0 is
                // the pointer ITSELF being written somewhere, which is contained only if that
                // somewhere is a private frame slot -- `reaching` has already decided which are.
                if (i == 1) {
                    return true;
                }
                return in.operands.size() >= 2 && isPrivateSlotCached(fn, in.operands[1]);
            case Op::Gep:
            case Op::Bitcast:
                return true;   // a derived pointer, already in `same` and judged on its own uses
            case Op::Drop:
            case Op::DropCascade:
                return i == 0;   // the end of its life, which is the point
            case Op::GuardNull:
            case Op::GuardCast:
            case Op::CmpEq:
            case Op::CmpNe:
            case Op::MemSet:
                return true;   // asked about, not kept
            case Op::Call:
            case Op::CallUnwind: {
                // THE SUMMARY, WHICH IS WHERE THE CONSTRUCTOR IS ANSWERED. Without it every
                // allocation escapes into its own constructor and this pass has nothing to do.
                const auto at = safeParams_.find(in.text);
                return at != safeParams_.end() && i < at->second.size() && at->second[i];
            }
            case Op::MemCopy:
            case Op::MemMove:
                // Copying BYTES through a pointer is a use; copying the pointer's bytes INTO
                // somewhere is how an address leaves without any opcode admitting it. Operand 0 is
                // the destination and operand 1 the source, and both are uses of the object.
                return i <= 1 && same.count(in.operands[i]) != 0;
            default:
                return false;
        }
    }

    bool isPrivateSlotCached(const Function& fn, ValueId slot) {
        std::unordered_map<ValueId, const Inst*> defs;
        for (const Block& b : fn.blocks) {
            for (const Inst& in : b.insts) {
                if (in.result != kNoValue) {
                    defs.emplace(in.result, &in);
                }
            }
        }
        return isPrivateSlot(fn, defs, slot);
    }

    // ---- §11.8: devirtualisation ----
    //
    // A `vtable.load` names a slot and the receiver's STATIC class. If every class that value could
    // really be answers that slot with the same body, then the table lookup computes a constant, and
    // the call can name it: `call.indirect` becomes `call`.
    //
    // WHAT IS LEFT FOR THIS PASS, precisely, because the lowering already does most of it.
    // `needsDispatch` walks the whole program asking "does anything under this class override this
    // method", and emits a direct call when nothing does. So the easy shape -- a concrete class with
    // no overriders -- never reaches here at all. What reaches here is the shape that answer cannot
    // see: the receiver's static class does not IMPLEMENT the method, so `implementationOf` is empty
    // and the lowering has to say "only the object knows". That is every abstract base and every
    // interface -- and one implementation under an abstract base is one candidate, not none.
    //
    // Which is exactly the ledger's complaint, reached from four directions: a program written to an
    // interface pays a table lookup per call for a choice with one outcome, and the C it is measured
    // against pays nothing because it never had an interface to write to.
    //
    // WHY THE CANDIDATE SET MAY BE TRUSTED. It is built from `Module::classes`, which the lowering
    // filled from the same AST `needsDispatch` walks -- so this pass sees a class if and only if the
    // lowering saw it, and the two cannot disagree about who exists. The one thing the AST does not
    // settle is a class a consumer has not written yet, and that is what `openWorld` is: `--lib`,
    // public, and neither `final` nor `sealed`. Wave 2 paid for that one already -- `total = 17`
    // where the answer was 57 -- so it is a refusal here and not a judgement call.
    void devirtualise() {
        if (m_.classes.empty()) {
            return;
        }
        buildDescent();
        for (const std::unique_ptr<Function>& f : m_.functions) {
            if (f->blocks.empty()) {
                continue;
            }
            // WHICH LOADS RESOLVE, before anything is rewritten. A `vtable.load` may feed more than
            // one call, and it is left where it stands either way: nothing here deletes it, because
            // `removeDead` already knows how to remove a load nothing uses and a pass that deletes
            // an instruction another one still has a use of is the bug that costs a whole afternoon.
            std::unordered_map<ValueId, std::string> resolved;
            for (const Block& b : f->blocks) {
                for (const Inst& in : b.insts) {
                    if (in.op != Op::VtableLoad || in.result == kNoValue) {
                        continue;
                    }
                    if (std::string only = soleImplementation(in.text, in.imm); !only.empty()) {
                        resolved.emplace(in.result, std::move(only));
                    }
                }
            }
            if (resolved.empty()) {
                continue;
            }
            for (Block& b : f->blocks) {
                for (Inst& in : b.insts) {
                    if (in.op != Op::CallIndirect || in.operands.empty()) {
                        continue;
                    }
                    auto it = resolved.find(in.operands[0]);
                    if (it == resolved.end()) {
                        continue;
                    }
                    // AND THE CALLEE STOPS BEING AN ARGUMENT. `call.indirect` holds the address in
                    // operand zero and the arguments after it; `call` holds the arguments alone and
                    // matches them positionally against the callee's parameters. Rewriting the
                    // opcode and leaving the operands is how the receiver ends up passed as the
                    // first argument and every real argument shifts one place -- which type-checks,
                    // because a `this` pointer and the first parameter are usually both pointers.
                    in.op = Op::Call;
                    in.text = it->second;
                    in.operands.erase(in.operands.begin());
                    ++r_.devirtualised;
                }
            }
        }
    }

    // Every class, to the classes that name it -- `extends` and `implements` both, since a call
    // written against an interface has the INTERFACE as its static class and following `extends`
    // from there reaches nothing at all.
    void buildDescent() {
        if (!descent_.empty()) {
            return;
        }
        for (const auto& [key, shape] : m_.classes) {
            if (!shape.base.empty()) {
                descent_[shape.base].push_back(key);
            }
            for (const std::string& i : shape.interfaces) {
                descent_[i].push_back(key);
            }
        }
    }

    // The one body every candidate under `cls` gives for `slot`, or empty for "more than one, or
    // something I cannot see". EMPTY IS THE ANSWER TO EVERY DOUBT: a dispatch left alone is the
    // program as written, and there is no other safe direction to be wrong in.
    std::string soleImplementation(const std::string& cls, int64_t slot) {
        if (cls.empty() || slot < 0) {
            return {};
        }
        // WHICH METHOD THE SLOT HOLDS, and whether the program may point it somewhere else while it
        // runs. `Dog.methods.replace("bark", ...)` (§32.8) writes a new body into the slot of a live
        // object; a method that is dispatched *because* it is replaceable is the last one to compile
        // into a direct call, since the call would reach the body the replacement exists to displace.
        const auto method = m_.slotMethod.find(slot);
        if (method == m_.slotMethod.end() ||
            m_.replaceableMethods.count(method->second) != 0) {
            return {};
        }
        std::vector<std::string> work{cls};
        std::unordered_set<std::string> seen{cls};
        std::string only;
        while (!work.empty()) {
            const std::string at = std::move(work.back());
            work.pop_back();
            const auto shape = m_.classes.find(at);
            if (shape == m_.classes.end() || shape->second.openWorld) {
                return {};   // a candidate whose shape I do not have, or whose set is not closed
            }
            if (const Global* table = globalNamed(at + ".vtable"); table != nullptr) {
                // A TABLE THAT IS NOT CONSTANT IS NOT A FACT. `buildVtable` marks one mutable when
                // the program rewrites it -- `methods.replace`, or `unimport` poisoning every slot
                // so a call into a class that is gone reports itself rather than jumping into freed
                // code. Both are the vtable being USED as a variable, and reading a variable at
                // compile time is the whole of the mistake. Asked of the global rather than of a
                // second list, because the global is where the decision already lives.
                if (!table->isConst) {
                    return {};
                }
                if (static_cast<size_t>(slot) < table->initFns.size()) {
                    const std::string& key = table->initFns[static_cast<size_t>(slot)];
                    // AN EMPTY SLOT IS NOT A CANDIDATE. It means this class has no body for the
                    // method -- an abstract class, which is never the dynamic type of anything, or
                    // an interface, which is never instantiated at all. Counting those as a second
                    // implementation is what would leave `abstract Shape` + `Circle` looking like
                    // two answers when it has one, and that is the case this pass exists for.
                    if (!key.empty()) {
                        if (only.empty()) {
                            only = key;
                        } else if (only != key) {
                            return {};
                        }
                    }
                }
            }
            for (const std::string& child : descent_[at]) {
                if (seen.insert(child).second) {
                    work.push_back(child);
                }
            }
            // ...AND THE `permits` LIST TOO. A `sealed` class names its subtypes, and a name in that
            // list that nothing else reached is a class this compilation did not lay out -- so the
            // set is not closed HERE even though the declaration closes it, and the loop above will
            // find no shape for it and refuse. That refusal is the point: `permits` is read as a
            // list of candidates to account for, not as permission to stop looking.
            for (const std::string& p : shape->second.permits) {
                if (seen.insert(p).second) {
                    work.push_back(p);
                }
            }
        }
        if (only.empty() || !functionExists(only)) {
            // A `call` NAMING NOTHING EMITS NOTHING. The backend looks the key up and, finding no
            // function, breaks out of the case -- no call, no result, and the value the program was
            // going to use quietly becomes undef. There is no verifier rule for it because the
            // module never gets one; the symptom is a program that runs and gives a wrong answer.
            return {};
        }
        return only;
    }

    const Global* globalNamed(const std::string& name) {
        if (globals_.empty()) {
            for (const Global& g : m_.globals) {
                globals_.emplace(g.name, &g);
            }
        }
        const auto at = globals_.find(name);
        return at != globals_.end() ? at->second : nullptr;
    }

    bool functionExists(const std::string& key) {
        if (functionKeys_.empty()) {
            for (const std::unique_ptr<Function>& f : m_.functions) {
                functionKeys_.insert(f->key);
            }
        }
        return functionKeys_.count(key) != 0;
    }

    // ---- §11.9: dead code ----
    //
    // A value nothing uses, produced by an instruction with no effect, is not code. Facts are
    // deliberately exempt: verifier rule 21 says a `fact.*` has no uses and no side effects, which
    // is what makes it deletable -- but it is deleted by the CONTRACT LOWERING, after the guard
    // eliminator has read it, not here where it would be thrown away before anything used it.
    void removeDead(Function& fn) {
        bool again = true;
        while (again) {
            again = false;
            std::unordered_set<ValueId> used;
            for (const Block& b : fn.blocks) {
                for (const Inst& in : b.insts) {
                    for (ValueId v : in.operands) {
                        used.insert(v);
                    }
                    for (const Edge& e : in.edges) {
                        for (ValueId v : e.args) {
                            used.insert(v);
                        }
                    }
                }
            }
            for (Block& b : fn.blocks) {
                std::vector<Inst> kept;
                kept.reserve(b.insts.size());
                for (Inst& in : b.insts) {
                    const bool pure = in.op == Op::ConstInt || in.op == Op::ConstBool ||
                                      in.op == Op::ConstNull || in.op == Op::Undef ||
                                      in.op == Op::Gep || in.op == Op::Load ||
                                      in.op == Op::AddWrap || in.op == Op::AddChecked ||
                                      in.op == Op::SubWrap || in.op == Op::SubChecked ||
                                      in.op == Op::MulWrap || in.op == Op::MulChecked ||
                                      in.op == Op::And || in.op == Op::Or || in.op == Op::Xor ||
                                      in.op == Op::Not || in.op == Op::CmpEq || in.op == Op::CmpNe ||
                                      in.op == Op::CmpLtS || in.op == Op::CmpLeS ||
                                      in.op == Op::CmpGtS || in.op == Op::CmpGeS ||
                                      in.op == Op::Trunc || in.op == Op::ExtendS ||
                                      in.op == Op::ExtendU ||
                                      // A vtable lookup is two loads and nothing else, so one whose
                                      // result nothing reads is two loads nothing reads. It is on
                                      // this list because §11.8 is what makes that happen: before
                                      // devirtualisation existed, every `vtable.load` fed the call
                                      // beneath it and the case never arose.
                                      in.op == Op::VtableLoad;
                    if (pure && in.result != kNoValue && used.count(in.result) == 0) {
                        // THE VALUE GOES WITH THE INSTRUCTION. Its entry in the table still names a
                        // block and a position, and after the removal that position holds a
                        // different instruction -- which is precisely the disagreement verifier
                        // rule 1 exists to catch, and it caught it. A dead value becomes a hole:
                        // defined nowhere, used nowhere.
                        if (in.result < fn.values.size()) {
                            fn.values[in.result].block = kNoBlock;
                        }
                        ++r_.deadRemoved;
                        again = true;
                        continue;
                    }
                    kept.push_back(std::move(in));
                }
                b.insts = std::move(kept);
                reindex(fn, b);
            }
        }
    }

    // A block's instructions moved, so the value table's idea of where each result is defined has
    // to move with them. Verifier rule 1 checks exactly this agreement, and a pass that edits a
    // block without restoring it produces a module that fails a rule about something it did not
    // touch -- which is a debugging session about the wrong thing.
    static void reindex(Function& fn, const Block& b) {
        for (size_t i = 0; i < b.insts.size(); ++i) {
            const ValueId r = b.insts[i].result;
            if (r != kNoValue && r < fn.values.size()) {
                fn.values[r].indexInBlock = static_cast<uint32_t>(i);
            }
        }
    }

    // How much of a frame one object may take. A policy, and stated as a number rather than left
    // implicit: an object bigger than this stays on the heap because a frame does not grow, and a
    // thread with a small stack would find that out somewhere far from here.
    static constexpr uint64_t kFrameBudget = 4096;

    Module& m_;
    PassReport r_;
    // Built once, on first use, and only by the passes that need them: a module with no classes
    // never pays for the descent relation at all.
    std::unordered_map<std::string, std::vector<std::string>> descent_;
    // §11.5's module-wide summary: per function key, which parameters do NOT escape.
    std::unordered_map<std::string, std::vector<bool>> safeParams_;
    std::unordered_map<std::string, const Global*> globals_;
    std::unordered_set<std::string> functionKeys_;
};

}  // namespace

PassReport runPasses(Module* module) {
    if (module == nullptr) {
        return {};
    }
    const PassReport report = Passes(*module).run();
    // Carried on the module so the §12 hand-off line can name it -- see `Module::devirtualised`.
    module->devirtualised = report.devirtualised;
    return report;
}

std::string renderPassReport(const PassReport& r) {
    return "pir passes: guards-removed=" + std::to_string(r.guardsRemoved) +
           " immutable-slots=" + std::to_string(r.slotsMadeImmutable) +
           " dead-removed=" + std::to_string(r.deadRemoved) +
           " facts=" + std::to_string(r.factsPropagated) +
           " contract-facts=" + std::to_string(r.contractFacts) +
           " devirtualised=" + std::to_string(r.devirtualised) +
           " heap-to-stack=" + std::to_string(r.heapToStack) +
           // Counted apart from the row above it because the two are different proofs and the
           // difference is the whole of §11.6: this one is an allocation that was happening once
           // PER ITERATION, and its saving is multiplied by the trip count.
           " hoisted=" + std::to_string(r.allocationsHoisted) + "\n";
}

}  // namespace polaron::pir
