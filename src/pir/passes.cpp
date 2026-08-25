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
                                      in.op == Op::ExtendU;
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

    Module& m_;
    PassReport r_;
};

}  // namespace

PassReport runPasses(Module* module) {
    if (module == nullptr) {
        return {};
    }
    return Passes(*module).run();
}

std::string renderPassReport(const PassReport& r) {
    return "pir passes: guards-removed=" + std::to_string(r.guardsRemoved) +
           " immutable-slots=" + std::to_string(r.slotsMadeImmutable) +
           " dead-removed=" + std::to_string(r.deadRemoved) +
           " facts=" + std::to_string(r.factsPropagated) +
           " contract-facts=" + std::to_string(r.contractFacts) + "\n";
}

}  // namespace polaron::pir
