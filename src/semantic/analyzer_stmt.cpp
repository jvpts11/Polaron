#include "semantic/analyzer.h"
#include "semantic/semutil.h"
#include "semantic/analyzer_private.h"  // the helpers this file shares with analyzer.cpp

#include "semantic/asmcheck.h"
#include "semantic/comptime.h"

#include <algorithm>
#include <functional>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

namespace polaron {

using namespace semutil;   // NOLINT(google-build-using-namespace): as in analyzer.cpp

void SemanticAnalyzer::analyzeStatement(const ast::Stmt& stmt) {
    if (const auto* sa = dynamic_cast<const ast::DemandStmt*>(&stmt)) {
        // A DEMAND IS NOT CODE THAT RUNS -- it is a check the BUILD performs, and it has to fire
        // whether or not anything calls the method holding it. `sizeof_budget_bad.pol` is exactly
        // that case, and says so: "in a method of the type, and nothing calls it. It must fail the
        // build anyway... an assertion that cannot fire is worse than no assertion, because it reads
        // as protection."
        //
        // A size-bearing condition is settled by the code generator (only it knows the target's
        // layout), so the class holding one must be emitted even when nothing reaches it. Recorded
        // here, where the analyzer already has the demand in its hand.
        if (!owningClassForRefs_.empty()) {
            demandOwners_.insert(owningClassForRefs_);
        }
        long long v;
        if (!evalConstInt(*sa->condition, v, &constInts_, &comptimeMethods_, &constDoubles_,
                          &enums_)) {
            // A condition over `sizeof` needs the target's real layout, which only the codegen has
            // (spec 28.2, issue #7). Deferring it there is what lets a struct carry a byte budget;
            // folding a size from a layout guessed here would assert something the program does not
            // actually have. Every other non-constant condition is still rejected at once.
            if (!comptime::mentionsSizeof(*sa->condition)) {
                error("a demand is settled while the program is built, so its condition has to be "
                      "known then -- this one is not constant", sa->loc);
            }
        } else if (v == 0) {
            error("demand not met: " + sa->message, sa->loc);
        }
        return;
    }
    if (dynamic_cast<const ast::BreakStmt*>(&stmt) != nullptr ||
        dynamic_cast<const ast::ContinueStmt*>(&stmt) != nullptr) {
        return;  // loop-context validation (break/continue only inside a loop) is a later refinement
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(&stmt)) {
        // A range `0..10` (spec 7.5) iterates integers; otherwise the iterable is an array.
        if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(fe->iterable.get())) {
            const std::string st = typeOf(*rng->start);
            typeOf(*rng->end);
            if (rng->step) {
                typeOf(*rng->step);
            }
            const std::string et = fe->isVar ? (st.empty() ? "int" : st) : typeRefStr(fe->elemType);
            pushScope();
            if (!fe->indexName.empty()) {
                declareLocal(fe->indexName, LocalVar{"int", false});
            }
            declareLocal(fe->varName, LocalVar{et, false});
            analyzeBlock(fe->body);
            popScope();
            return;
        }
        const std::string it = typeOf(*fe->iterable);
        // A collection is iterable too (spec 34): a generic/monomorphized class snapshot via toArray().
        const bool isColl =
            !it.empty() && !isArrayType(it) &&
            (it.find('<') != std::string::npos || it.find('$') != std::string::npos);
        const bool isRange = baseType(it) == "Range";  // a first-class Range value (spec 7.5), over int
        // Iterable / Iterator (spec 9.2): any class that declares hasNext()+next() (it IS an iterator) or
        // iterator() (it HAS one) can be foreach-ed lazily, no snapshot. Interfaces qualify too.
        const MethodInfo* hasNextM = findMethod(baseType(it), "hasNext", /*objectFallback=*/false);
        const MethodInfo* nextM = findMethod(baseType(it), "next", /*objectFallback=*/false);
        const MethodInfo* iterM = findMethod(baseType(it), "iterator", /*objectFallback=*/false);
        const bool isIterable =
            (hasNextM != nullptr && nextM != nullptr) || iterM != nullptr;
        if (!it.empty() && !isArrayType(it) && !isColl && !isRange && !isIterable) {
            error("foreach requires an array, a collection, a range or an Iterable, got '" + it + "'",
                  fe->loc);
        }
        std::string et;
        if (!fe->isVar) {
            et = typeRefStr(fe->elemType);
        } else if (isRange) {
            et = "int";
        } else if (isIterable && !isColl) {  // var x: the element type is what next() returns
            if (nextM != nullptr) {
                et = nextM->returnType;
            } else if (iterM != nullptr) {
                const MethodInfo* n2 = findMethod(baseType(iterM->returnType), "next", false);
                et = n2 != nullptr ? n2->returnType : "";
            }
        } else if (isColl) {  // var x: take the single type argument (ArrayList<int> -> int)
            const std::size_t lt = it.find('<');
            const std::string args = lt != std::string::npos
                                         ? it.substr(lt + 1, it.size() - lt - 2)
                                         : it.substr(it.find('$') + 1);
            et = args.find(',') == std::string::npos && args.find('$') == std::string::npos ? args : "";
        } else {
            et = elementOf(it);
        }
        pushScope();
        if (!fe->indexName.empty()) {
            declareLocal(fe->indexName, LocalVar{"int", false});
        }
        declareLocal(fe->varName, LocalVar{et, false});
        analyzeBlock(fe->body);
        popScope();
        return;
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(&stmt)) {
        typeOf(*sw->subject);
        for (const ast::SwitchCase& c : sw->cases) {
            typeOf(*c.value);
            analyzeBlock(c.body);
        }
        if (sw->defaultBody) {
            analyzeBlock(*sw->defaultBody);
        } else {
            error("a 'switch' must have a 'default' case (spec 7.3)", sw->loc);
        }
        return;
    }
    if (const auto* td = dynamic_cast<const ast::TupleDeclStmt*>(&stmt)) {
        const std::string initType = typeOf(*td->init);
        if (!initType.empty() && !isTupleType(initType)) {
            error("cannot destructure a non-tuple value of type '" + initType + "'", td->loc);
        }
        const std::vector<std::string> comps = tupleElems(initType);
        if (!initType.empty() && comps.size() != td->bindings.size()) {
            error("tuple destructuring expects " + std::to_string(comps.size()) +
                      " bindings but found " + std::to_string(td->bindings.size()),
                  td->loc);
        }
        for (std::size_t i = 0; i < td->bindings.size(); ++i) {
            const std::string bt = typeRefStr(td->bindings[i].type);
            checkTypeAccessible(bt, td->loc);
            if (i < comps.size() && !comps[i].empty() && !isSubtype(comps[i], bt)) {
                error("cannot bind tuple component " + std::to_string(i) + " of type '" +
                          comps[i] + "' to '" + bt + "'",
                      td->loc);
            }
            if (lookupLocal(td->bindings[i].name) != nullptr) {
                error("redeclaration or shadowing of variable '" + td->bindings[i].name + "'",
                      td->loc);
            } else {
                declareLocal(td->bindings[i].name, LocalVar{bt, false});
            }
        }
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
        // A region may be declared empty (`region r;`, spec 17.2 form 3) and allocated later; its
        // init is then null. Every other declaration carries an initializer (the parser enforces it).
        const std::string initType = vd->init ? typeOf(*vd->init) : std::string();
        const std::string declType = vd->isVar ? initType : typeRefStr(vd->type);
        if (!vd->isVar) {
            checkTypeAccessible(declType, vd->loc);
        }
        // spec 32.2: a snapshot is a captured state, not a variable. Checked on the WRITTEN type name,
        // because `RegionSnapshot` canonicalizes to `address` and afterwards the two cannot be told
        // apart -- which is the price of spelling it as an alias, paid here rather than hidden.
        // A LOCAL THAT SHADOWS A FIELD. The assignment cases are already refused twice over -- a
        // parameter is immutable, and the field-initialisation check then reports the field as never
        // set -- but a shadowed READ is silent: `mutable int width = 5; return width;` answers 5 while
        // the field says 77. It bit twice during a `this.`-removal sweep and was caught only by an
        // accident of type; a shadow of the SAME type goes through and changes what the program
        // computes. A warning, not an error, because shadowing is legal and sometimes meant.
        if (!currentClass_.empty()) {
            if (auto ci = classes_.find(currentClass_);
                ci != classes_.end() && ci->second.fields.count(vd->name) > 0) {
                warn("local '" + vd->name + "' shadows the field of the same name. Reads of '" +
                         vd->name + "' in this scope see the local; write `this." + vd->name +
                         "` for the field.",
                     vd->loc);
            }
        }
        if (vd->isMutable && vd->type.name == "RegionSnapshot") {
            error("a snapshot is constant: '" + vd->name +
                      "' cannot be 'mutable'. It names a state that was captured; re-capturing is "
                      "`snapshot region <name> into " + vd->name + ";` (spec 32.2).",
                  vd->loc);
        }
        // spec 32.2: a snapshot's home has to be a region whose slots carry a header, because that is
        // what tells a later `snapshot ... into k` how much room k has. A plain (bump) region has no
        // per-slot header at all -- that absence is exactly what makes its allocation cost what a
        // hand-written arena costs -- so a snapshot placed in one used to be an access violation.
        // The runtime traps it; the flavor is right here on the declaration, so this is the place.
        if (const auto* sn = dynamic_cast<const ast::SnapshotExpr*>(vd->init.get())) {
            const std::string hf =
                regionFlavor_.count(sn->home) ? regionFlavor_[sn->home] : std::string();
            if (hf != "pool" && hf != "fixedslot" && hf != "stack") {
                error("a snapshot cannot live in region '" + sn->home +
                          "': a plain (bump) region has no per-slot header, and a snapshot needs one "
                          "so that re-capturing into it can tell how much room it has. Declare the "
                          "home as `pool`, `fixedslot` or `stack` (spec 32.2).",
                      sn->loc);
            }
        }
        // `comptime T x = ...` (spec 37.4): the value is computed during compilation and embedded, so
        // the initializer HAS to fold. This was parsed, recorded on the declaration and then read by
        // nobody -- `comptime int a = Main.fib(10)` emitted a real `call @Main.fib(i32 10)` and stored
        // the result, which is the one thing the prefix promises will not happen. Checked here, where a
        // `fixed` initializer is already checked the same way, so both answer the same question alike.
        if (vd->isComptime && vd->init != nullptr) {
            bool folds = false;
            if (isFloatType(declType)) {
                double d;
                folds = evalConstDouble(*vd->init, d, &constDoubles_, &constInts_, &comptimeMethods_);
            } else {
                long long v;
                folds = evalConstInt(*vd->init, v, &constInts_, &comptimeMethods_, &constDoubles_);
            }
            if (!folds) {
                error("'comptime " + declType + " " + vd->name +
                          "' must have an initializer the compiler can evaluate -- a literal, a `fixed` "
                          "constant, or a call to a `comptime` method. Without one there is nothing to "
                          "embed, and the value would be computed at run time like any other (spec 37.4).",
                      vd->loc);
            }
        }
        // Region flavor / growth modifiers (spec 17, flavors expansion): a flavor word only qualifies a
        // region (Polaron-1719), and a region has exactly one flavor (Polaron-1710). The parser space-joins two
        // flavor words into regionFlavor so both names surface here.
        if (!vd->regionFlavor.empty() || vd->regionGrowable) {
            if (declType != "region") {
                const std::string w = !vd->regionFlavor.empty()
                                          ? vd->regionFlavor.substr(0, vd->regionFlavor.find(' '))
                                          : std::string("growable");
                error("'" + w + "' only qualifies a region (spec 17), not a '" + declType +
                          "' declaration",
                      vd->loc);
            } else {
                const std::size_t sp = vd->regionFlavor.find(' ');
                if (sp != std::string::npos) {
                    const std::string a = vd->regionFlavor.substr(0, sp);
                    const std::string b = vd->regionFlavor.substr(sp + 1);
                    error("a region has exactly one flavor, but region '" + vd->name +
                              "' was given two ('" + a + "' and '" + b + "')",
                          vd->loc);
                } else {
                    regionFlavor_[vd->name] = vd->regionFlavor;  // record for extract/delete checks
                    // fixedslot/ring hold one element type, so they need `.accepts({T})` of exactly one
                    // type (Polaron-1711): a single-size pool / a fixed-purpose circular buffer.
                    if (vd->regionFlavor == "fixedslot" || vd->regionFlavor == "ring") {
                        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                        if (ri == nullptr || ri->accepts.size() != 1) {
                            error("a " + vd->regionFlavor +
                                      " region needs its single element type: add .accepts({T}) with "
                                      "exactly one type (spec 17)",
                                  vd->loc);
                        }
                    }
                }
            }
            // `growable` contradictions (Polaron-1712): a ring is bounded by definition; a mapped
            // (at-address) region cannot grow; and a stack region is deliberately not growable -- its
            // discipline is mark/rollback within a fixed arena, so growth is expressed by sizing the
            // arena for its depth or by using a growable pool. This is by design, not a gap.
            if (vd->regionGrowable && declType == "region") {
                const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                if (vd->regionFlavor == "ring") {
                    error("growable does not apply to a ring region (a ring is bounded by "
                          "definition) (spec 17)",
                          vd->loc);
                } else if (ri != nullptr && ri->atAddress != nullptr) {
                    error("growable does not apply to a mapped (at address) region -- foreign "
                          "memory cannot grow (spec 17)",
                          vd->loc);
                } else if (vd->regionFlavor == "stack") {
                    error("growable does not compose with a stack region: size the stack region for its "
                          "depth, or use a growable pool (spec 17)",
                          vd->loc);
                }
            }
        }
        if (!vd->isVar && !initType.empty() &&
            (!isSubtype(initType, declType) || isBoxedSumMismatch(initType, declType)) &&
            !intLiteralFits(*vd->init, declType)) {
            error("cannot initialize variable '" + vd->name + "' of type '" + declType +
                      "' with a value of type '" + initType + "'" + addressHint(initType, declType) +
                      sumFormHint(initType, declType),
                  vd->loc);
        }
        if (lookupLocal(vd->name) != nullptr && deleted_.count(vd->name) == 0) {
            error("redeclaration or shadowing of variable '" + vd->name + "'", vd->loc);
        } else {
            deleted_.erase(vd->name);  // reborn after delete: persistents reattach (spec 18.2)
            freed_.erase(vd->name);
            // A class value bound to a `new ... on stack` (the default for objects) is a
            // stack object: RAII frees it, and it is not throwable (its carrier would
            // dangle after unwind).
            bool stackObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                stackObj = nw->location != "heap" && !declType.empty() &&
                           lookupClass(baseType(declType)) != nullptr && !isRefType(declType) &&
                           !isArrayType(declType);
            }
            // A declaration with no initializer enters the *uninitialized* state. `region r;` keeps its
            // old behaviour (it is allocated by a later `r = itself.allocate(...)`, which the region
            // rules already police), so it is not tracked here.
            const bool deferred = vd->init == nullptr && declType != "region";
            bool heapObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                heapObj = nw->location == "heap";
            }
            declareLocal(vd->name, LocalVar{declType.empty() ? std::string("int") : declType,
                                            vd->isMutable, stackObj, heapObj, deferred});
            if (deferred) {
                init_[vd->name] = FlowFacts::Init::Uninit;
            } else {
                init_.erase(vd->name);
                // Redeclaring a name (a fresh scope) must not inherit the old one's proof.
                killProofsFor(vd->name);
                // An initializer that is itself non-null proves the variable non-null right away --
                // this is what makes `nullable T* p = &thing;` usable without a redundant check.
                //
                // Uses the type computed ABOVE rather than calling typeOf again: typeOf has side effects
                // (it records moves and reports errors), so re-typing the initializer made `Handle b =
                // move a;` report `a` as used-after-move -- against the very move that statement was.
                if (!initType.empty() && initType != "null" && !isNullableType(initType)) {
                    nonNull_.insert(vd->name);
                }
            }
        }
        // Remember a region's accepts/rejects constraints, keyed by variable.
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
            regionConstraints_[vd->name] = RegionConstraints{ri->accepts, ri->rejects};
        }
        // Remember which region a `checkpoint m = mark of region R;` came from (spec 17, Polaron-1714).
        if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(vd->init.get())) {
            checkpointRegion_[vd->name] = mk->region;
        }
        // Remember a local that points into a region (`T* p = new X in region R;`) so extracting the
        // OWNER of a field holding such a value can be rejected (spec 17, Polaron-1718).
        regionOf_.erase(vd->name);
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
            nw != nullptr && !nw->region.empty()) {
            regionOf_[vd->name] = nw->region;
        }
        // region-binder: a `new X` that lands in this ACTIVATION's frame names an object that dies at method
        // return. Track the local so storing a reference to it into a longer-lived location can be rejected
        // (§3). Two exclusions, and both are about where the object actually lives, not where the pointer to
        // it does:
        //
        //   `new X in region R` -- region-owned; it outlives the method and the region rules govern it.
        //   `new X() on heap`   -- heap-owned; the POINTER dies at return, the OBJECT lives until `delete`.
        //
        // The second one was missing, and it is why this analysis had to stay switched off: `Node* n = new
        // Node(v) on heap; this.top = n;` -- the first two lines of every linked structure ever written --
        // was reported as a dangling store. Storing a heap object into a longer-lived field is not an
        // escape, it is the ownership transfer the whole idiom is made of. A heap object that IS deleted in
        // this method and then stored is a use-after-free, which the flow machine already catches by name.
        //
        // Aliasing propagates the tag (`var y = x` / `var y = move x`): an alias to (or the new owner of) an
        // activation-owned object is itself activation-scoped, so the escape check can't be dodged through it.
        if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(vd->init.get())) {
            lambdaLocals_[vd->name] = lam;   // `function<void> work = lambda[...]` -> track for the §14 check
        } else {
            lambdaLocals_.erase(vd->name);
        }
        activationOwned_.erase(vd->name);
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
            nw != nullptr && nw->region.empty() && nw->location != "heap") {
            activationOwned_.insert(vd->name);
        } else if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(vd->init.get());
                   aid != nullptr && activationOwned_.count(aid->name) > 0) {
            activationOwned_.insert(vd->name);
        } else if (const auto* amv = dynamic_cast<const ast::MoveExpr*>(vd->init.get())) {
            if (const auto* mid = dynamic_cast<const ast::IdentifierExpr*>(amv->operand.get());
                mid != nullptr && activationOwned_.count(mid->name) > 0) {
                activationOwned_.insert(vd->name);
            }
        }
        if (vd->init) {
            checkOwnershipAssign(declType, *vd->init, vd->loc, "this declaration");
        }
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        // spec 17 Polaron-1718: track a local / `obj.field` (re)assigned a region-allocated object, so
        // extracting/deleting the owner of a same-region field can be flagged. Any other assignment to
        // the path clears it.
        {
            std::string path;
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
                path = id->name;
            } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                    path = oid->name + "." + mem->member;
                }
            }
            if (!path.empty()) {
                regionOf_.erase(path);
                if (const auto* nw = dynamic_cast<const ast::NewExpr*>(assign->value.get());
                    nw != nullptr && !nw->region.empty()) {
                    regionOf_[path] = nw->region;
                }
                // A region assigned to a FIELD keeps its accepts/rejects, exactly as a local does --
                // and they are kept at CLASS scope, because that is where the region lives. The
                // per-method map is cleared between methods, which is right for a local (it cannot
                // outlive its declaring method) and would erase this before the first method that
                // allocates into it ever ran. A region is typed always; one that accepted anything
                // because of where it happened to be stored was not a region.
                if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(assign->value.get())) {
                    regionConstraints_[path] = RegionConstraints{ri->accepts, ri->rejects};
                    if (path.rfind("this.", 0) == 0 && !currentClass_.empty()) {
                        fieldRegionConstraints_[currentClass_ + "." + path.substr(5)] =
                            RegionConstraints{ri->accepts, ri->rejects};
                    }
                }
            }
        }
        // atomic<T> assignment (spec 20.6): `counter = counter +/- n` (a lock-free atomicrmw,
        // from `+=`/`-=`) or `counter = v` (atomic store). The atomic<T> <-> T mixing is allowed
        // here rather than through the usual numeric checks (which reject atomic + int). Detect via
        // the local's type (not typeOf, which would read-type the target and error on moved vars).
        bool atomicTarget = false;
        if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
            if (const LocalVar* v = lookupLocal(tid->name);
                v != nullptr && baseType(v->type).rfind("atomic$", 0) == 0) {
                atomicTarget = true;
            }
        }
        if (atomicTarget) {
            if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(assign->value.get())) {
                typeOf(*bin->lhs);
                typeOf(*bin->rhs);
            } else {
                typeOf(*assign->value);
            }
            return;
        }
        // region-binder ESCAPE CHECK (§3): storing a plain reference to an activation-owned object (a
        // `new`-here local, or an alias/move of one) into a field of something that OUTLIVES this method
        // would dangle at return. The target outlives the activation when its base object is not itself
        // activation-owned -- `this`, a parameter, a static, or an alias to an outer object. Storing into a
        // fellow activation-owned object (same lifetime) is fine. `x = move y` (a MoveExpr, not a bare
        // identifier) transfers ownership and is always allowed.
        if (regionBinder_) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    oid != nullptr && activationOwned_.count(oid->name) == 0) {  // target outlives the method
                    if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(assign->value.get());
                        rid != nullptr && activationOwned_.count(rid->name) > 0 &&
                        // only a POINTER/REFERENCE field aliases the object; a value field deep-copies it and
                        // cannot dangle. Gate on the field being T*/T& (isRefType).
                        isRefType(fieldTypeOf(*mem))) {
                        const std::string tgt = oid->name == "this" ? "this" : ("'" + oid->name + "'");
                        error("region-binder: storing a reference to the method-local object '" + rid->name +
                                  "' into " + tgt + "'s field '" + mem->member + "', which outlives it, "
                                  "would dangle when '" + rid->name + "' is freed; transfer ownership with "
                                  "'move' (= move " + rid->name + ")",
                              assign->loc);
                    }
                }
            }
        }
        const std::string vt = typeOf(*assign->value);
        checkAssignTarget(*assign->target, vt, assign->loc, assign->value.get());
        // A CONSTANT THAT DOES NOT FIT A BIT FIELD STORES A DIFFERENT VALUE, and says so.
        //
        // A WARNING AND NOT AN ERROR, deliberately. Truncation on store is spec 11.1 -- "a value
        // that overflows N bits is truncated on store" -- and `bit_fields.pol` tests it on purpose
        // with `f.a = 20` into four bits. That is a decided semantics and this is not the place to
        // overturn it; what it is not is a reason to stay SILENT when the value is a literal, which
        // the compiler can read at the declaration with nothing to run.
        //
        // What it catches, and did on the day it was written: the fauna layout budgets a beast at
        // twenty bytes with `int species : 5` and `int state : 3`, and writes beside them that the
        // field "holds eight values and the tick needs exactly eight". True about the count and
        // wrong about the range -- a signed 3-bit field stops at 3, and a signed 5-bit one at 15
        // against eighteen species. Four states and two species would have been stored as something
        // else, in silence, in a document whose every other number had been measured.
        //
        // A computed value is a different question: it needs a check at the store, and refusing to
        // answer the half that is free is not made better by the half that is not.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
            // NOT THROUGH A CLASS NAME. `Test.criterion = ""` is a static field, and asking
            // `typeOf` for the type of `Test` reports it as an undeclared VARIABLE -- which is how
            // the first version of this check broke the standard library's own prelude for every
            // program that compiled. A bit field cannot be static anyway (`checkBitField` says so:
            // a static field has storage of its own, which is the opposite of sharing a unit), so
            // there is nothing here to check and nothing is lost by not asking.
            const auto* base = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
            const bool throughClassName = base != nullptr && classes_.count(base->name) > 0;
            const std::string owner = throughClassName ? std::string() : baseType(typeOf(*mem->object));
            const FieldInfo* fi = owner.empty() ? nullptr : findField(owner, mem->member);
            if (fi != nullptr && fi->bitWidth > 0 && fi->bitWidth < 64) {
                long long v = 0;
                if (readIntLiteral(*assign->value, v)) {
                    const std::string ft = baseType(fi->type);
                    const bool uns = !ft.empty() && ft[0] == 'u';
                    const long long lo = uns ? 0 : -(1LL << (fi->bitWidth - 1));
                    const long long hi = uns ? (1LL << fi->bitWidth) - 1
                                             : (1LL << (fi->bitWidth - 1)) - 1;
                    if (v < lo || v > hi) {
                        const long long kept =
                            uns ? (v & ((1LL << fi->bitWidth) - 1))
                                : ((v & ((1LL << fi->bitWidth) - 1)) ^ (1LL << (fi->bitWidth - 1))) -
                                      (1LL << (fi->bitWidth - 1));
                        const std::string fix =
                            (!uns && v > hi)
                                ? ". A SIGNED field spends one of its " +
                                  std::to_string(fi->bitWidth) + " bits on the sign, so it stops at " +
                                  std::to_string(hi) + " -- if these are counts or ordinals, declare "
                                  "it unsigned"
                                : ". Widen the field, or store a value in range";
                        // AN ERROR AND NOT A WARNING, and the line is drawn between what the
                        // compiler can read and what it cannot. `b.state = 6` into three signed
                        // bits is a mistake it can see with nothing to run, and there is no reading
                        // of it under which the author wanted -2. Truncation stays for counts and
                        // sums -- spec 11.1, and `bit_fields.pol` tests that half through variables.
                        //
                        // Raised from a warning because of what the warning found: the fauna layout
                        // of a real game budgeted `int state : 3` for eight states and
                        // `int species : 5` for eighteen, in a document whose every other number
                        // had been measured. A warning in a build of ten thousand lines is a thing
                        // nobody reads.
                        error("the value " + std::to_string(v) + " does not fit '" + mem->member +
                                  "', a " + std::to_string(fi->bitWidth) + "-bit '" + ft +
                                  "' field holding " + std::to_string(lo) + " to " +
                                  std::to_string(hi) + ". It would truncate to " +
                                  std::to_string(kept) + fix,
                              assign->loc);
                    }
                }
            }
        }
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
            moved_.erase(id->name);  // reassignment reactivates the variable
            activationOwned_.erase(id->name);  // reassigned: no longer the tracked activation-owned object
            extracted_.erase(id->name);  // ... including after an `x = extract x from region R;`
            const LocalVar* var = lookupLocal(id->name);
            if (var != nullptr) {
                checkOwnershipAssign(var->type, *assign->value, assign->loc, "this assignment");
            }
        } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
            // A FIELD is an assignment target too. The ownership rules lived only on the two
            // narrowest paths -- a local's declaration and a local's reassignment -- so `movable`
            // meant "you must write move" for a variable and nothing at all for a field, which is
            // the place ownership actually matters, since a field is what outlives the method.
            const std::string ft = fieldTypeOf(*mem);
            if (!ft.empty()) {
                checkOwnershipAssign(ft, *assign->value, assign->loc,
                                     "field '" + mem->member + "'");
            }
            // `this.f = ...` inside a constructor discharges the obligation to give `f` a value. Only
            // through `this`: assigning some OTHER object's field of the same name says nothing about
            // ours, and matching on the name alone would silently accept a constructor that initialises
            // its argument instead of itself.
            // Walk down to the ROOT of the chain: `this.cap.x = x` initialises `cap`, field by field,
            // and is the ordinary way to fill a value-struct field. Marking only on a direct
            // `this.<name>` would report `cap` as unset in a constructor that plainly sets it -- and a
            // check that rejects correct code gets switched off rather than obeyed.
            if (inConstructor_) {
                const ast::MemberExpr* root = mem;
                while (const auto* outer = dynamic_cast<const ast::MemberExpr*>(root->object.get())) {
                    root = outer;
                }
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(root->object.get());
                    oid != nullptr && oid->name == "this") {
                    markInitialized("this." + root->member);
                }
            }
        }
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        checkIncDecTarget(*incdec->target, incdec->isIncrement, incdec->loc);
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(&stmt)) {
        const std::string ct = typeOf(*ifs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'if' condition must be boolean, got '" + ct + "'", ifs->loc);
        }
        if (ifs->isComptime) {
            long long v;
            if (!evalConstInt(*ifs->cond, v, &constInts_, &comptimeMethods_, &constDoubles_, &enums_)) {
                error("'comptime if' requires a compile-time constant condition", ifs->loc);
            }
        }
        // The branch is where the flow machine earns itself. Each arm is analyzed from the SAME entry
        // state, and what survives afterwards is the join of the two -- so a proof made in one arm cannot
        // leak into code the other arm reaches.
        const FlowFacts entry = snapshotFlow();

        // A condition that PROVES something holds for the arm that ran because of it. `p != null` proves
        // it in the `then`; `p == null` proves it in the `else`, which is what makes the guard-clause
        // shape (`if (p == null) { return; }`) work: the proof lands on the continuation.
        std::string provenThen, provenElse;
        proofFromCondition(*ifs->cond, provenThen, provenElse);

        if (!provenThen.empty()) {
            nonNull_.insert(provenThen);
        }
        const std::string savedLazy = lazyInitField_;
        lazyInitField_ = lazyInitGuardField(*ifs->cond);
        analyzeBlock(ifs->thenBlock);
        lazyInitField_ = savedLazy;
        const FlowFacts afterThen = snapshotFlow();
        const bool thenExits = blockAlwaysExits(ifs->thenBlock);

        restoreFlow(entry);
        if (!provenElse.empty()) {
            nonNull_.insert(provenElse);
        }
        if (ifs->elseBlock) {
            analyzeBlock(*ifs->elseBlock);
        }
        const FlowFacts afterElse = snapshotFlow();
        const bool elseExits = ifs->elseBlock != nullptr && blockAlwaysExits(*ifs->elseBlock);

        // An arm that always exits (return/throw/break/continue) never reaches the code after the `if`,
        // so it contributes NOTHING to the join. That is both what makes a guard clause narrow the rest
        // of the method and what removes the ownership false positive the analysis doc calls out: a
        // branch that moved a value and then returned cannot have moved it for the code below.
        if (thenExits && elseExits) {
            restoreFlow(afterThen);
        } else if (thenExits) {
            restoreFlow(afterElse);
        } else if (elseExits) {
            restoreFlow(afterThen);
        } else {
            joinFlow(afterThen, afterElse);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(&stmt)) {
        const std::string subjType = typeOf(*ms->subject);
        const std::string subjBaseM = baseType(subjType);
        const auto subjDollarM = subjBaseM.find('$');
        // AN ENUM SUBJECT: the cases name CONSTANTS, not types.
        //
        // `match` began as dispatch over a sealed hierarchy, so every arm was looked up as a class
        // and `case Caught` was reported as an unknown TYPE -- on the form the specifications write
        // wherever the point is that every outcome is named and counted. A constant is a value and
        // not a shape: nothing is bound out of it, and its exhaustiveness question is answered from
        // the enum's own list rather than from a `permits` clause on a base class.
        if (auto en = enums_.find(subjBaseM); en != enums_.end()) {
            const std::vector<std::string>& constants = en->second;
            for (const ast::MatchCase& c : ms->cases) {
                if (std::find(constants.begin(), constants.end(), c.typeName) == constants.end()) {
                    error("'" + c.typeName + "' is not a constant of enum '" + subjBaseM + "'",
                          c.loc);
                }
                if (!c.bindings.empty()) {
                    error("'case " + c.typeName + "' cannot bind anything: an enum constant is a "
                          "value, not a shape with fields to take apart",
                          c.loc);
                }
                pushScope();
                for (const auto& st : c.body.statements) {
                    analyzeStatement(*st);
                }
                popScope();
            }
            if (ms->defaultBody) {
                analyzeBlock(*ms->defaultBody);
            }
            if (sealedEnums_.count(subjBaseM) > 0) {
                // Every constant, or say which is missing. This is the whole of what `sealed` buys
                // on an enum: the constant added next year is reported at each match that forgot
                // it, instead of disappearing into a `default`.
                std::string missing;
                for (const std::string& k : constants) {
                    bool covered = false;
                    for (const ast::MatchCase& c : ms->cases) {
                        if (c.typeName == k) {
                            covered = true;
                        }
                    }
                    if (!covered) {
                        missing += (missing.empty() ? "" : ", ") + k;
                    }
                }
                if (!missing.empty() && !ms->defaultBody) {
                    error("match on sealed enum '" + subjBaseM + "' is not exhaustive: missing " +
                              missing,
                          ms->loc);
                }
            } else if (!ms->defaultBody) {
                error("match on enum '" + subjBaseM + "' requires a 'default' case, or declare the "
                      "enum `sealed` so every constant must be covered and a new one cannot be "
                      "forgotten here",
                      ms->loc);
            }
            return;
        }
        for (const ast::MatchCase& c : ms->cases) {
            // A bare case name (Ok) on a monomorphized sealed subject (Result$int$int) may name the
            // matching instantiation (Ok$int$int) -- but a non-generic concrete subclass of a generic
            // base (class Leaf extends Base<int>) is just `Leaf`, not `Leaf$int`. Prefer the suffixed
            // instantiation when it exists, else fall back to the bare name.
            std::string caseType = c.typeName;
            if (subjDollarM != std::string::npos) {
                const std::string suffixed = c.typeName + subjBaseM.substr(subjDollarM);
                if (lookupClass(suffixed) != nullptr) {
                    caseType = suffixed;
                }
            }
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBaseM)) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce locals (the case type's fields) in the case body.
            pushScope();
            for (const ast::Param& b : c.bindings) {
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            }
            for (const auto& st : c.body.statements) {
                analyzeStatement(*st);
            }
            popScope();
        }
        if (ms->defaultBody) {
            analyzeBlock(*ms->defaultBody);
        }
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit and
        // needs no default; a non-sealed subject requires a default.
        const ClassInfo* sc = lookupClass(baseType(subjType));
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : ms->cases) {
                    if (c.typeName == p) {
                        covered = true;
                    }
                }
                if (!covered && !ms->defaultBody) {
                    error("match on sealed '" + baseType(subjType) +
                              "' is not exhaustive: missing case '" + p + "'",
                          ms->loc);
                }
            }
        } else if (!ms->defaultBody) {
            error("match requires a 'default' case (the subject is not sealed)", ms->loc);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&stmt)) {
        const std::string ct = typeOf(*ws->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'while' condition must be boolean, got '" + ct + "'", ws->loc);
        }
        // The body may not run at all, and it may run again -- so a proof it establishes survives
        // neither. What it INITIALIZES is different: a second pass cannot un-assign a variable, but a
        // zero-pass loop means we cannot claim it was assigned either, so the entry state stands.
        const FlowFacts entry = snapshotFlow();
        std::string provenBody, unused;
        proofFromCondition(*ws->cond, provenBody, unused);
        if (!provenBody.empty()) {
            nonNull_.insert(provenBody);
        }
        analyzeBlock(ws->body);
        invalidateAcrossBackEdge(entry);
        restoreFlow(entry);
        return;
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&stmt)) {
        // A do-while body always runs once, so what it initializes really is initialized afterwards.
        const FlowFacts entry = snapshotFlow();
        analyzeBlock(dw->body);
        invalidateAcrossBackEdge(entry);
        const std::string ct = typeOf(*dw->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'do-while' condition must be boolean, got '" + ct + "'", dw->loc);
        }
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&stmt)) {
        pushScope();
        if (fs->init) {
            analyzeStatement(*fs->init);
        }
        const std::string ct = typeOf(*fs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'for' condition must be boolean, got '" + ct + "'", fs->loc);
        }
        if (fs->update) {
            analyzeStatement(*fs->update);
        }
        // Same as `while`: zero iterations is possible, so nothing the body establishes escapes it.
        const FlowFacts entry = snapshotFlow();
        analyzeBlock(fs->body);
        invalidateAcrossBackEdge(entry);
        restoreFlow(entry);
        popScope();
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
        // Polaron-1720: `extract` transfers ownership to its result, so a bare `extract ...;` statement leaks
        // the object it just relocated. Its result must be bound to a variable or field.
        if (dynamic_cast<const ast::ExtractExpr*>(es->expr.get()) != nullptr) {
            error("an extract result must be bound to a variable or field (spec 17): "
                  "write `T* out = extract ...;`, or use `delete X from region R;` to just destroy it",
                  es->expr->loc);
        }
        typeOf(*es->expr);
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
        if (rs->value) {
            const std::string vt = typeOf(*rs->value);
            // Null safety (spec 3.7): a null/nullable value may not be returned where the declared
            // return type is non-nullable.
            if (!vt.empty() && !currentReturnType_.empty() && !isNullableType(currentReturnType_) &&
                (vt == "null" || isNullableType(vt))) {
                error("cannot return " + std::string(vt == "null" ? "null" : "a nullable value") +
                          " from a method declared 'returns " + currentReturnType_ +
                          "': that type is non-nullable" +
                          (vt == "null"
                               ? std::string(". Return a real value, or declare it 'returns nullable " +
                                             currentReturnType_ + "' if the caller must handle absence")
                               : std::string(". A direct null test on a NAME narrows it -- after "
                                             "`if (x == null) { return ...; }` a plain `return x;` "
                                             "compiles with no cast. This value's test was not a shape "
                                             "the compiler reads (a field, a call result, a cleverer "
                                             "condition), so state the check with 'cast<" +
                                             currentReturnType_ + ">(...)', which is verified at runtime")),
                      rs->loc);
            } else if (!vt.empty() && !currentReturnType_.empty() && vt != "null" &&
                       currentReturnType_ != "void" &&
                       (!isSubtype(vt, currentReturnType_) ||
                        isBoxedSumMismatch(vt, currentReturnType_)) &&
                       !intLiteralFits(*rs->value, currentReturnType_)) {
                // TYPE of the returned value (Polaron-0303). Only nullability was checked here, so
                // `return someDog;` from a method `returns Cat` produced valid IR and reinterpreted the
                // object -- vtable pointer included -- because every class is an opaque `ptr` at the LLVM
                // level. A language that verifies `cast<T>` at runtime had its guard facing the wrong way.
                //
                // The same pair of conditions the assignment check uses, deliberately: `isSubtype` for the
                // relation and `intLiteralFits` so an untyped literal still adapts to the declared type
                // (`return 0;` from a method returning `byte` stays legal, exactly as `byte b = 0;` is).
                error("cannot return a value of type '" + vt + "' from a method returning '" +
                          currentReturnType_ + "'" + sumFormHint(vt, currentReturnType_),
                      rs->loc);
            }
            // region-binder ESCAPE BY RETURN (§8). The gap this analysis was named for and did not
            // close: `Point* make() { Point p = new Point() on stack; return &p; }` compiled clean in
            // every configuration, INCLUDING with the binder switched on. Chapter 5 promises the
            // opposite in as many words, so this was the most explicit unkept promise in the language.
            //
            // The rule is the same one the field-store check uses, pointed at the return slot: an
            // object that lives in this activation's frame cannot leave through a pointer or a
            // reference, because the frame goes away the instant the caller has it. A heap object is
            // not caught -- its pointer dies here, its storage does not -- which is exactly the
            // factory idiom and has to keep working.
            // A return is the fourth destination: the value lands in the caller. Same rules.
            if (!currentReturnType_.empty() && currentReturnType_ != "void") {
                checkOwnershipAssign(currentReturnType_, *rs->value, rs->loc, "this return");
            }
            // spec 19.6: `returns move T` hands ownership out, and the return says so.
            if (currentReturnIsMove_ &&
                dynamic_cast<const ast::MoveExpr*>(rs->value.get()) == nullptr) {
                error("this method is declared 'returns move " + currentReturnType_ +
                          "', so it gives up ownership: write 'return move ...'",
                      rs->loc);
            }
            if (regionBinder_ && isRefType(currentReturnType_)) {
                if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get());
                    rid != nullptr && activationOwned_.count(rid->name) > 0) {
                    error("region-binder: returning '" + rid->name +
                              "', which names an object living in this method's own frame; the frame "
                              "is gone by the time the caller reads it. Allocate it with 'on heap' so "
                              "it outlives the call, or return it by value so the caller gets a copy",
                          rs->loc);
                }
            }
        }
        return;
    }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(&stmt)) {
        if (ys->value == nullptr) {
            return;
        }
        const std::string vt = typeOf(*ys->value);  // `yield expr;` (spec 16.2 / 22.6)
        // In a generator (spec 22.6) the yielded value is an element of the Iterator<T> it produces.
        if (!currentGenElem_.empty() && !vt.empty() && !isSubtype(vt, currentGenElem_)) {
            error("cannot yield a '" + vt + "' from a generator producing 'Iterator<" +
                      currentGenElem_ + ">'",
                  ys->loc);
        }
        return;
    }
    if (const auto* asmS = dynamic_cast<const ast::AsmStmt*>(&stmt)) {
        // Inline assembly (spec issue 1). Its operands are ordinary expressions and must resolve -- so a
        // typo in `in (v)` is a compile error, not a mystery at assembly time. An `out (...)` operand is
        // written by the asm, so it must be an assignable lvalue.
        for (const ast::ExprPtr& i : asmS->inputs) {
            typeOf(*i);
        }
        for (const ast::ExprPtr& o : asmS->outputs) {
            checkAssignTarget(*o, typeOf(*o), o->loc, nullptr);
        }
        // And now the BODY.
        //
        // Until this, the body went to the assembler unread -- which made `asm` the one construct in
        // Polaron where arbitrary code could live, and the only place a mistake was neither caught nor
        // catchable. The block already names its architecture and dialect; that information was being
        // collected and then thrown away. See asmcheck.h for what is checked and, as importantly, what
        // is deliberately not.
        semantic::AsmDeclared decl;
        decl.arch = asmS->arch;
        decl.dialect = asmS->dialect;
        decl.outputCount = static_cast<int>(asmS->outputs.size());
        decl.inputCount = static_cast<int>(asmS->inputs.size());
        decl.clobbers = asmS->clobbers;
        decl.inNakedFunction = inNakedFn_;
        const semantic::AsmReport report = semantic::checkAsm(asmS->body, decl);
        for (const semantic::AsmFinding& f : report.findings) {
            const std::string where = " (asm line " + std::to_string(f.line) + ")";
            if (f.severity == semantic::AsmFinding::Severity::Error) {
                error(f.message + where, asmS->loc);
            } else {
                warn(f.message + where, asmS->loc);
            }
        }
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
        noteUnsafeForInterrupt("free memory", del->loc);
        auto checkTarget = [&](const ast::Expr& target) {
            const std::string t = typeOf(target);
            // `delete p` where p is a class, or a pointer/reference to one (see through T*/T&). Try the
            // full type too, not only baseType: a generic instantiated with a pointer type argument mangles
            // to a name that ends in '*' (e.g. `ArrayList$Node*` for ArrayList<Node*>), which baseType would
            // wrongly strip -- but the class is registered under the full name, so `delete` must accept it.
            if (!t.empty() && lookupClass(baseType(t)) == nullptr && lookupClass(t) == nullptr &&
                !isArrayType(t)) {
                error("'delete' expects a heap object or array; got a value of type '" + t + "'",
                      del->loc);
            }
            // A deleted variable may be redeclared with the same name, reattaching its persistents
            // (spec 18.2). Record it so the redeclaration is allowed -- and so a later READ of it is
            // caught as a use-after-free.
            //
            // ... but only where the delete actually FREES something. `delete v` on a value-form type
            // (a `Result<int,int>` held by value rather than `Result<int,int>*`) owns no heap and is a
            // documented no-op, so the variable stays perfectly readable and flagging it would be wrong.
            // The line is exactly whether the name denotes a reference to a heap object.
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
                deleted_.insert(id->name);   // spec 18.2: the name may be redeclared either way
                const LocalVar* lv = lookupLocal(id->name);
                if (isRefType(t) || isArrayType(t) || (lv != nullptr && lv->isHeapObject)) {
                    freed_.insert(id->name);
                }
            }
        };
        checkTarget(*del->target);
        for (const auto& mt : del->moreTargets) {
            checkTarget(*mt);
        }
        // `delete X from region R` on a ring region is rejected -- a ring auto-evicts (Polaron-1715).
        if (!del->fromRegion.empty() && (regionFlavor_.count(del->fromRegion) ? regionFlavor_[del->fromRegion]
                                                                              : std::string()) == "ring") {
            error("a ring region auto-evicts; individual delete is not allowed on '" + del->fromRegion +
                      "' (spec 17)",
                  del->loc);
        }
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
        if (rel->isPersistent) {
            // `release [persistent|eternal] obj.field;` -- record that this persistent
            // field is released somewhere, satisfying the obligation (spec 18.15).
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(rel->target.get())) {
                // `release C.field all;` names the CLASS, not an object -- there is no instance whose
                // identity is meant, because the point is every identity. Resolve the receiver as a type
                // name; typing it as an expression would report `C` as an undeclared variable.
                if (rel->allKeys) {
                    std::string cls;
                    if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                        cls = rid->name;
                    }
                    if (cls.empty() || lookupClass(cls) == nullptr) {
                        error("'release ... all' names a class and one of its persistent fields "
                              "(`release Session.hits all;`); '" +
                                  (cls.empty() ? std::string("this receiver") : "'" + cls + "'") +
                                  " is not a class in scope",
                              rel->loc);
                        return;
                    }
                    if (const std::string owner = persistentFieldOwner(cls, mem->member); !owner.empty()) {
                        releasedPersistents_.insert(owner + "." + mem->member);
                    } else {
                        error("'" + mem->member + "' is not a persistent field of '" + cls + "'",
                              rel->loc);
                    }
                    return;
                }
                const std::string ot = baseType(typeOf(*mem->object));
                if (const std::string owner = persistentFieldOwner(ot, mem->member); !owner.empty()) {
                    releasedPersistents_.insert(owner + "." + mem->member);
                } else if (!ot.empty()) {
                    error("'" + mem->member + "' is not a persistent field of '" + ot + "'",
                          rel->loc);
                }
            } else if (rel->target != nullptr) {
                typeOf(*rel->target);  // still type-check the operand
                error("'release persistent' expects a persistent field access (obj.field)",
                      rel->loc);
            }
            return;
        }
        // A `this.field` region is validated at codegen (via the field); only a plain local name is
        // resolved here (spec 17: region as a field).
        if (rel->region.find('.') == std::string::npos) {
            // `release region AstNode` -- the arena of a REGION CLASS, which is owned by the type and
            // so is named by the type (docs/design/region-classes.md). This is the case explicit
            // release exists for: a phase arena is worth having because it dies at the end of the
            // phase, and "released at program exit" would not solve that.
            //
            // A PURE region class is refused here, and the refusal is the design rather than a gap:
            // it is sealed and owns an arena of exactly one shape, so releasing it is releasing every
            // instance of one type -- which `delete` already expresses one object at a time. The
            // family root is the shape that has no other spelling.
            if (const ClassInfo* rc = lookupClass(rel->region); rc != nullptr) {
                if (!rc->isRegionClass) {
                    error("'" + rel->region +
                              "' is a class, and only a `region class` owns a region that can be "
                              "released. An ordinary class's objects are released one at a time, "
                              "with `delete`",
                          rel->loc);
                } else if (!rc->isAbstract) {
                    error("'" + rel->region +
                              "' is a pure `region class`, whose region holds instances of it and "
                              "nothing else -- releasing it is releasing every instance, which "
                              "`delete` already says one object at a time. Explicit release is for "
                              "the family arena: name the `abstract region class` at the root of "
                              "the family",
                          rel->loc);
                }
                return;
            }
            const LocalVar* r = lookupLocal(rel->region);
            if (r == nullptr) {
                error("unknown region '" + rel->region + "'", rel->loc);
            } else if (r->type != "region") {
                error("'" + rel->region + "' is not a region", rel->loc);
            }
        }
        return;
    }
    if (const auto* rb = dynamic_cast<const ast::RollbackStmt*>(&stmt)) {
        // `rollback region R to m` needs a stack region (Polaron-1713) and a checkpoint captured from that
        // same region (Polaron-1714). A `this.field` region is validated at codegen.
        if (rb->region.find('.') == std::string::npos) {
            const LocalVar* r = lookupLocal(rb->region);
            if (r == nullptr) {
                error("unknown region '" + rb->region + "'", rb->loc);
            } else if (r->type != "region") {
                error("'" + rb->region + "' is not a region", rb->loc);
            } else if ((regionFlavor_.count(rb->region) ? regionFlavor_[rb->region] : std::string()) !=
                       "stack") {
                error("mark/rollback need a `stack region`, but '" + rb->region + "' is not one (spec 17)",
                      rb->loc);
            }
        }
        const std::string ct = rb->checkpoint ? typeOf(*rb->checkpoint) : std::string();
        if (!ct.empty() && ct != "checkpoint") {
            error("`rollback ... to` expects a checkpoint (from `mark of region`), not a '" + ct + "'",
                  rb->loc);
        }
        // If the checkpoint is a plain variable, it must have been marked from THIS region (Polaron-1714).
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(rb->checkpoint.get())) {
            auto cr = checkpointRegion_.find(id->name);
            if (cr != checkpointRegion_.end() && cr->second != rb->region) {
                error("this checkpoint belongs to region '" + cr->second +
                          "', not '" + rb->region + "'; roll back the region it came from",
                      rb->loc);
            }
        }
        return;
    }
    if (const auto* um = dynamic_cast<const ast::UnimportStmt*>(&stmt)) {
        // UNIMPORT WORKS BARE METAL; REIMPORT DOES NOT, and the asymmetry is not a policy -- it is
        // where each half gets its bytes from.
        //
        // Unimport needs `__polaron_unload_fn` and the allocator, both ours, plus a guard that now
        // panics instead of throwing. Reimport reads the ORIGINAL BYTES BACK OFF DISK --
        // GetModuleFileNameW on Windows, /proc/self/exe on Linux -- and a kernel has neither: it is
        // the image, and nothing has kept a copy of its own .text.
        //
        // This is what lets a kernel rip a driver's code out of RAM without rebooting, which is the
        // use the feature was measured against.
        // NEITHER HALF IS BARRED IN FREESTANDING, and the reasoning that briefly barred `reimport`
        // was wrong: it concluded from the HOSTED mechanism (which reads the original bytes back out
        // of the executable on disk, and a kernel is the image) instead of from the CONTRACT.
        //
        // The contract is two symbols the program provides -- `__polaron_unload_fn` and
        // `__polaron_reload_fn` -- exactly as it provides `__polaron_panic`. What "unload" and "reload"
        // mean is the kernel's to decide, and a kernel has better options than the hosted one: clear
        // the present bit instead of overwriting, and the bytes are still in the frame, so putting
        // them back is setting the bit again. No disk, no copy, and the `.text` is never written.
        //
        // Barring one and allowing the other was also simply inconsistent: `unimport` needs a
        // provided symbol too.
        // Namespace / bundle granularity (spec 30.1) is accepted as-is; the codegen expands it to the
        // contained types. An individual target must be a known class, interface or enum.
        if (um->granularity == 0) {
            const std::string bt = baseType(um->target);
            if (lookupClass(bt) == nullptr && enums_.count(bt) == 0) {
                error("cannot " + std::string(um->isReimport ? "reimport" : "unimport") + " '" +
                          um->target + "': not a known type",
                      um->loc);
            } else if (!um->isReimport && finalImports_.count(bt) > 0) {
                error("cannot unimport '" + um->target +
                          "': it was brought in by 'final import' (spec 37.6)",
                      um->loc);
            }
        }
        return;
    }
    if (const auto* rv = dynamic_cast<const ast::ReimportValidateStmt*>(&stmt)) {
        if (freestanding_) {
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", rv->loc);
        }
        if (lookupClass(baseType(rv->target)) == nullptr) {
            error("cannot reimport '" + rv->target + "': not a known class", rv->loc);
        }
        const std::string expectedType = rv->expected ? typeOf(*rv->expected) : "";
        const std::string producedType = analyzeExpectingBlock(rv->expecting.get());
        // The two validation values must be the same type so they can be compared bit-for-bit.
        if (!expectedType.empty() && !producedType.empty() &&
            baseType(expectedType) != baseType(producedType)) {
            error("reimport validation type mismatch: the matching unimport produced '" +
                      expectedType + "' but this expecting block returns '" + producedType + "'",
                  rv->loc);
        }
        if (rv->onFailure) {
            analyzeBlock(*rv->onFailure);
        }
        return;
    }
    if (const auto* cm = dynamic_cast<const ast::CascadeMoveStmt*>(&stmt)) {
        const std::string t = typeOf(*cm->target);  // type-check the moved object
        if (!t.empty() && lookupClass(baseType(t)) == nullptr) {
            error("'cascade move' expects a class object, got '" + t + "'", cm->loc);
        }
        for (const std::string& rn : {cm->fromRegion, cm->toRegion}) {
            const LocalVar* rv = lookupLocal(rn);
            if (rv == nullptr) {
                error("unknown region '" + rn + "'", cm->loc);
            } else if (rv->type != "region") {
                error("'" + rn + "' is not a region", cm->loc);
            }
        }
        return;
    }
    if (const auto* cs = dynamic_cast<const ast::CascadeStmt*>(&stmt)) {
        // `cascade unimport X` (spec 37.1): same rules as plain unimport, applied to X and its
        // subtypes/monomorphizations (the expansion happens in codegen).
        if (cs->op == ast::CascadeOpKind::Unimport) {
            if (freestanding_) {
                error("unimport is not available in freestanding mode (spec 36.3)", cs->loc);
            }
            if (lookupClass(baseType(cs->typeName)) == nullptr) {
                error("cannot unimport '" + cs->typeName + "': not a known class", cs->loc);
            } else if (finalImports_.count(baseType(cs->typeName)) > 0) {
                error("cannot unimport '" + cs->typeName +
                          "': it was brought in by 'final import' (spec 37.6)",
                      cs->loc);
            }
            return;
        }
        // `cascade release persistent X` (spec 37.1): satisfy the release obligation for every
        // persistent reachable from X's owned graph (spec 18.15). Runtime release is a no-op today,
        // matching plain `release persistent`.
        if (cs->op == ast::CascadeOpKind::Release) {
            const std::string t = cs->target != nullptr ? baseType(typeOf(*cs->target)) : "";
            if (!t.empty() && lookupClass(t) == nullptr) {
                error("'cascade release' expects a class object, got '" + t + "'", cs->loc);
            } else if (!t.empty()) {
                std::unordered_set<std::string> seen;
                markCascadeReleased(t, seen);
            }
            return;
        }
        // `cascade println(X)` / `cascade validate(X)` (spec 37.1). The operand must be a class
        // object; an operation supports cascade only if its per-node form exists (rule 4):
        // println needs a describe() on the type, validate uses the type's invariants.
        if (cs->target != nullptr) {
            const std::string t = typeOf(*cs->target);
            const std::string cn = baseType(t);
            if (!t.empty() && lookupClass(cn) == nullptr) {
                error("'cascade' expects a class object, got '" + t + "'", cs->loc);
            } else if (cs->op == ast::CascadeOpKind::Println && !cn.empty() &&
                       findMethod(cn, "describe") == nullptr) {
                error("'cascade println' requires a 'describe()' method on '" + cn +
                          "' (spec 37.1 rule 4)",
                      cs->loc);
            }
        }
        if (cs->dest != nullptr) {
            typeOf(*cs->dest);  // type-check `cascade clone X into <dest>`
        }
        return;
    }
    if (const auto* def = dynamic_cast<const ast::DeferStmt*>(&stmt)) {
        if (def->within != nullptr) {  // spec 32.10: the cleanup's time budget
            const std::string t = baseType(typeOf(*def->within));
            if (t != "Duration" && !isIntName(t) && !t.empty()) {
                error("'defer within' expects a Duration or a millisecond count, got '" + t + "'",
                      def->within->loc);
            }
        }
        analyzeBlock(def->body);
        return;
    }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(&stmt)) {
        pushScope();
        analyzeStatement(*us->decl);
        analyzeBlock(us->body);
        popScope();
        return;
    }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&stmt)) {
        // The lock this would take may be the one the interrupted code is already holding, and an
        // interrupt cannot wait for it to be released -- the holder cannot run until the handler
        // returns. That is a deadlock with no other party to blame.
        noteUnsafeForInterrupt("take a lock", sy->loc);
        const std::string mt = baseType(typeOf(*sy->mutex));  // expect a Mutex<...> instance
        if (!mt.empty() && mt.rfind("Mutex", 0) != 0) {
            error("synchronized requires a Mutex value, got '" + mt + "'", sy->loc);
        }
        if (!sy->bindType.isRef) {
            error("synchronized binding must be a reference (e.g. T& name)", sy->loc);
        }
        // Awaiting while holding the lock would suspend the task with the mutex held -- a deadlock
        // risk (spec 22). Reject it; release the lock before awaiting (or await outside the block).
        if (blockHasAwait(sy->body)) {
            error("cannot 'await' while holding a mutex in a 'synchronized' block (spec 22); "
                  "await outside the locked region", sy->loc);
        }
        pushScope();
        // Bind name to a mutable reference to the Mutex's protected value.
        declareLocal(sy->bindName, LocalVar{sy->bindType.name, true});
        analyzeBlock(sy->body);
        popScope();
        return;
    }
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(&stmt)) {
        if (freestanding_) {
            error("exceptions are not available in freestanding mode; use Result/Option (spec 36.3)",
                  th->loc);
        }
        const std::string t = typeOf(*th->value);
        if (!t.empty()) {
            const std::string bt = baseType(t);
            if (lookupClass(bt) == nullptr) {
                error("'throw' expects an object value; got '" + t + "'", th->loc);
            }
            // Any polymorphic object can be thrown/caught (not only Exception subtypes). Since every
            // class is now an Object, this is always satisfied -- the meaningful guard is "is a class".
            // The carrier must outlive unwinding: a stack object's pointer would dangle.
            bool stackThrow = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(th->value.get())) {
                stackThrow = nw->location != "heap";
            } else if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(th->value.get())) {
                if (const LocalVar* v = lookupLocal(id->name)) {
                    stackThrow = v->isStackObject;
                }
            }
            if (stackThrow) {
                error("a thrown object must be heap-allocated; use 'new ... on heap'", th->loc);
            }
            // Checked exceptions (spec 21.1): a throw that is neither caught by an enclosing try nor
            // listed in the method's `throws` clause escapes undeclared -- warn.
            if (lookupClass(bt) != nullptr) {
                bool covered = false;
                for (auto frame = catchStack_.rbegin(); !covered && frame != catchStack_.rend(); ++frame) {
                    for (const std::string& ct : *frame) {
                        if (bt == ct || isSubtype(bt, ct)) { covered = true; break; }
                    }
                }
                if (!covered) {
                    for (const std::string& dt : currentThrows_) {
                        if (bt == dt || isSubtype(bt, dt)) { covered = true; break; }
                    }
                }
                if (!covered) {
                    // The simple name, not the namespace-mangled one -- through the shared projection,
                    // which also says the full path when the simple name identifies two types.
                    const std::string disp = typeAsWritten(bt);
                    warn("exception '" + disp + "' is neither caught nor declared in the method's "
                         "'throws' clause", th->loc);
                }
            }
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(&stmt)) {
        if (freestanding_) {
            error("exceptions are not available in freestanding mode; use Result/Option (spec 36.3)",
                  tr->loc);
        }
        // A throw inside the try body is covered if one of these catch types matches it (spec 21.1).
        std::vector<std::string> caught;
        for (const ast::CatchClause& cc : tr->catches) {
            caught.push_back(baseType(typeRefStr(cc.type)));
        }
        catchStack_.push_back(std::move(caught));
        // A catch runs BECAUSE the try failed, and it can fail anywhere -- at the first statement or the
        // last. So a catch body must be analyzed from the state at try ENTRY, not from the state the try
        // body left behind: the try's work may not have happened at all. Analyzing them in sequence made
        // the stdlib's own `try { delete ch; } catch { delete ch; }` look like a use-after-free, which is
        // correct code and was the first thing the new check reported.
        const FlowFacts beforeTry = snapshotFlow();
        analyzeBlock(tr->body);
        const FlowFacts afterTry = snapshotFlow();
        catchStack_.pop_back();
        for (const ast::CatchClause& cc : tr->catches) {
            restoreFlow(beforeTry);
            const std::string ct = baseType(typeRefStr(cc.type));
            checkTypeAccessible(typeRefStr(cc.type), cc.loc);
            if (lookupClass(ct) == nullptr) {
                error("catch type '" + ct + "' is not a class", cc.loc);
            }
            // A catch type must be a class; every class is polymorphic (an Object) so it can be
            // matched by dynamic type.
            pushScope();
            declareLocal(cc.name, LocalVar{typeRefStr(cc.type), false});
            for (const auto& st : cc.body.statements) {
                analyzeStatement(*st);
            }
            popScope();
        }
        // After the whole statement, only what the try body established can be relied on -- a catch that
        // fell through contributes its own state, but the conservative and correct thing for `finally`
        // and the code below is the try's outcome, since that is the path that did not throw.
        restoreFlow(afterTry);
        if (tr->finallyBlock) {
            analyzeBlock(*tr->finallyBlock);
        }
        return;
    }
    // `label`/`comefrom` (spec 7.10) are accepted but not analyzed beyond this (out of
    // current type-checking scope); handled explicitly so they are not silently ignored.
    // Chaos tetrad (spec 7.9-7.11), intra-method only: goto/comefrom/abstainfrom/reinstate must
    // target a `label name;` declared in the same method, and a label may have at most one comefrom.
    if (dynamic_cast<const ast::LabelMarkStmt*>(&stmt) != nullptr) {
        return;  // a declaration
    }
    if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(&stmt)) {
        if (methodLabels_.count(cf->name) == 0) {
            error("comefrom references unknown label '" + cf->name + "' in this method (spec 7.10)",
                  cf->loc);
        } else if (!comefromTargets_.insert(cf->name).second) {
            error("label '" + cf->name +
                      "' already has a comefrom; at most one comefrom per label (spec 7.10)",
                  cf->loc);
        }
        return;
    }
    if (const auto* g = dynamic_cast<const ast::GotoStmt*>(&stmt)) {  // spec 7.9
        if (g->address != nullptr) {
            typeOf(*g->address);  // raw-address FFI jump (unchecked): just type-check the operand
        } else if (methodLabels_.count(g->name) == 0 && externReturns_.count(g->name) == 0) {
            error("goto references unknown label or extern function '" + g->name +
                      "' in this method (spec 7.9)",
                  g->loc);
        }
        return;
    }
    if (const auto* ab = dynamic_cast<const ast::AbstainfromStmt*>(&stmt)) {  // spec 7.11
        if (methodLabels_.count(ab->name) == 0) {
            error(std::string(ab->isReinstate ? "reinstate" : "abstainfrom") +
                      " references unknown label '" + ab->name + "' in this method (spec 7.11)",
                  ab->loc);
        }
        return;
    }
}

}  // namespace polaron
