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

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    // spec 32.2: `snapshot region W in region B` yields a handle to a block the caller placed and
    // owns -- which is what an `address` is. `RegionSnapshot` is the spelling; see ast.h.
    if (dynamic_cast<const ast::SnapshotExpr*>(&expr) != nullptr) {
        return "address";
    }
    if (const auto* il = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
        // A literal WRITTEN with more than 32 bits of digits is 64-bit, whatever signed value it
        // happens to equal -- so `int m = 0xFFFFFFFFFFFFF000;` is the error it should be instead of a
        // silent truncation. Codegen agrees (see intLiteralNeeds64).
        return polaron::ast::intLiteralNeeds64(il->text) ? "long" : "int";
    }
    if (const auto* fl = dynamic_cast<const ast::FloatLiteralExpr*>(&expr)) {
        return fl->isDecimal ? "Decimal" : "double";
    }
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) {
        return "char";
    }
    if (const auto* sl = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
        return sl->isBytes ? "byte*" : "String";   // b"..." is the raw bytes
    }
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) {
        return "boolean";
    }
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) {
        return "null";
    }
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        std::string s = "function<" + typeRefStr(lam->returnType);
        for (const auto& p : lam->params) {
            s += "," + typeRefStr(p.type);
        }
        // ...and CHECK THE BODY. It used to build this signature and return, so a lambda body was a
        // blind spot the size of every callback in the language: Thread bodies, collection
        // predicates, FFI trampolines. Anything at all could be written in one -- a call to a method
        // that does not exist, a return of the wrong type, a name never declared -- and the front
        // end would hand it to codegen, which assumes a valid AST.
        //
        // Analyzed HERE rather than deferred, because a lambda captures the enclosing locals and
        // this is the only moment they are in scope. The lambda's own return type replaces the
        // enclosing method's for the duration so `return` inside it is checked against the right
        // thing, and every flow fact that names a local is saved and restored -- a lambda body is a
        // separate flow of control, and letting its `delete x` mark the enclosing method's `x` as
        // freed would be the same cross-contamination that once failed 51 tests on one variable name.
        if (!analyzingLambda_) {
            analyzingLambda_ = true;
            const std::string savedReturn = currentReturnType_;
            const bool savedReturnMove = currentReturnIsMove_;
            auto savedMoved = moved_, savedFreed = freed_, savedDeleted = deleted_;
            auto savedNonNull = nonNull_, savedActivation = activationOwned_;
            auto savedInit = init_;
            currentReturnType_ = typeRefStr(lam->returnType);
            currentReturnIsMove_ = false;
            // The parameter types `itself(...)` is checked against -- the lambda has no name to look
            // its own signature up by, so the signature has to be carried here while its body runs.
            auto savedLambdaParams = currentLambdaParams_;
            currentLambdaParams_.clear();
            for (const ast::Param& p : lam->params) {
                currentLambdaParams_.push_back(typeRefStr(p.type));
            }
            pushScope();
            for (const ast::Param& p : lam->params) {
                declareLocal(p.name, LocalVar{typeRefStr(p.type), false});
            }
            for (const auto& st : lam->body.statements) {
                analyzeStatement(*st);
            }
            popScope();
            currentLambdaParams_ = std::move(savedLambdaParams);
            currentReturnType_ = savedReturn;
            currentReturnIsMove_ = savedReturnMove;
            moved_ = std::move(savedMoved);
            freed_ = std::move(savedFreed);
            deleted_ = std::move(savedDeleted);
            nonNull_ = std::move(savedNonNull);
            activationOwned_ = std::move(savedActivation);
            init_ = std::move(savedInit);
            analyzingLambda_ = false;
        }
        return s + ">";
    }
    if (const auto* old = dynamic_cast<const ast::OldExpr*>(&expr)) {
        // old(e) in an ensures clause (spec 29): the entry-time value of e, so it has e's type.
        return typeOf(*old->inner);
    }
    if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(&expr)) {
        // methodref obj.method (spec 22.3): its type is the method's function<Ret, Params...>.
        const std::string objType = typeOf(*mr->object);
        const std::string cls = baseType(objType);
        const MethodInfo* m = findMethod(cls, mr->method);
        if (m == nullptr) {
            error("no method '" + mr->method + "' on type '" + cls + "' for methodref", mr->loc);
            return "function<void>";
        }
        if (m->isStatic) {
            error("methodref cannot bind a static method; reference it by name instead", mr->loc);
            return "function<void>";
        }
        std::string s = "function<" + m->returnType;
        for (const std::string& pt : m->paramTypes) {
            s += "," + pt;
        }
        return s + ">";
    }

    if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
        // A tuple literal's type is "(c0,c1,...)" of its components' types.
        std::string s = "(";
        for (std::size_t i = 0; i < tup->elements.size(); ++i) {
            const std::string et = typeOf(*tup->elements[i]);
            if (et.empty()) {
                return "";
            }
            s += (i ? "," : "") + et;
        }
        return s + ")";
    }

    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            if (currentClass_.empty()) {
                error("'this' is not available in a static context", id->loc);
                return "";
            }
            return currentClass_;
        }
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            // A namespace-level compile-time constant (spec 28.1).
            if (auto cit = constTypes_.find(id->name); cit != constTypes_.end()) {
                return cit->second;
            }
            // A bare enum constant inside one of that enum's own methods (spec 12.2/12.4):
            // `return v8;` resolves to the enum value without the `Enum.` prefix.
            if (auto eit = enums_.find(currentClass_);
                eit != enums_.end() &&
                std::find(eit->second.begin(), eit->second.end(), id->name) != eit->second.end()) {
                return currentClass_;
            }
            error(diag::Code::UndeclaredVariable,
                  "use of undeclared variable '" + id->name + "'" + didYouMean(id->name, namesInScope()),
                  id->loc);
            return "";
        }
        if (auto ex = extracted_.find(id->name); ex != extracted_.end()) {
            error("variable '" + id->name + "' was extracted from its region (line " +
                      std::to_string(ex->second) + ") and cannot be used again; use the value extract "
                      "returned",
                  id->loc);
        } else if (moved_.count(id->name) > 0) {
            error("use of variable '" + id->name +
                      "' after it was moved (reassign it before using)",
                  id->loc);
        } else if (freed_.count(id->name) > 0) {
            // USE AFTER FREE, caught at compile time. The machinery was already here -- `deleted_` was
            // populated by every `delete` and read only to permit redeclaring the name -- so the trap the
            // guide promises (05:768) was one condition away the whole time.
            error("use of variable '" + id->name +
                      "' after it was deleted: the object it named is gone, and reading the variable "
                      "reads freed memory. Redeclare the name with a new object if you meant to reuse "
                      "it (spec 18.2), or move the `delete` after this use",
                  id->loc);
        } else if (const FlowFacts::Init st = initStateOf(id->name); st != FlowFacts::Init::Init) {
            // Definite assignment. The two states get different messages because they are different
            // mistakes: never assigned at all, versus assigned on only one path through a branch.
            error(st == FlowFacts::Init::Uninit
                      ? "variable '" + id->name +
                            "' is used before it is initialized. It was declared without a value, which "
                            "leaves it in the uninitialized state -- not null, not zero, no value at "
                            "all -- so assign to it before reading it"
                      : "variable '" + id->name +
                            "' may be used before it is initialized: some paths to this point assign it "
                            "and others do not. Assign it on every path (an `else` branch, or a default "
                            "before the branch) so it holds a value however control got here",
                  id->loc);
        }
        // NARROWING. A name proven non-null here reports the non-nullable type, so every consumer --
        // argument passing, `return`, field assignment -- sees the proof without any of them knowing the
        // proof exists. The proof is only ever recorded where nothing can falsify it (see killProofsFor
        // and invalidateAcrossBackEdge), so this cannot claim more than the compiler actually knows.
        if (!suppressNarrowing_ && isNullableType(var->type) && nonNull_.count(id->name) > 0) {
            return ast::stripNullable(var->type);
        }
        return var->type;
    }

    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
        if (freestanding_) {
            error("async/await is not available in freestanding mode (spec 36.3)", aw->loc);
        }
        // Suspending means "resume me later, on the scheduler". There is no later for a handler:
        // the machine is inside the interrupt until it returns.
        noteUnsafeForInterrupt("suspend", aw->loc);
        // await ch.receive() (spec 20.7): a channel receive already blocks for the value, so `await`
        // is a passthrough and yields the element type.
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(aw->operand.get())) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                if (mem->member == "receive" && call->args.empty() &&
                    baseType(typeOf(*mem->object)).rfind("Channel$", 0) == 0) {
                    return typeOf(*aw->operand);
                }
            }
        }
        // await Task<T> -> T (spec 20.2).
        const std::string t = baseType(typeOf(*aw->operand));
        if (!t.empty() && t.rfind("Task$", 0) != 0) {
            error("'await' expects a Task value, got '" + t + "'", aw->loc);
            return "";
        }
        return t.empty() ? std::string() : t.substr(5);  // strip "Task$"
    }
    if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(&expr)) {
        if (freestanding_) {
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", ue->loc);
        }
        if (lookupClass(baseType(ue->target)) == nullptr) {
            error("cannot unimport '" + ue->target + "': not a known class", ue->loc);
        } else if (finalImports_.count(baseType(ue->target)) > 0) {
            error("cannot unimport '" + ue->target +
                      "': it was brought in by 'final import' (spec 37.6)",
                  ue->loc);
        }
        return analyzeExpectingBlock(ue->expecting.get());  // value type = expecting block's return
    }
    if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(&expr)) {
        typeOf(*rng->start);  // a range over int (spec 7.5)
        typeOf(*rng->end);
        if (rng->step) {
            typeOf(*rng->step);
        }
        return "Range";  // a first-class Range value; foreach over a literal range is handled separately
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (un->op == "&") {
            // A packed bit field HAS NO ADDRESS (spec 11.1). It occupies a range of bits inside a unit
            // it shares with its neighbours, and the smallest thing a pointer can name is a byte. The
            // only address that could be handed back is the unit's, which would let a write through it
            // destroy every field packed beside this one -- silently, and nowhere near the `&`.
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(un->operand.get())) {
                const std::string owner = baseType(typeOf(*mem->object));
                if (const FieldInfo* fi = findField(owner, mem->member); fi != nullptr && fi->bitWidth > 0) {
                    error("cannot take the address of '" + mem->member + "': it is a " +
                          std::to_string(fi->bitWidth) + "-bit field packed into a storage unit it "
                          "shares with the fields declared next to it, so it has no address of its "
                          "own. Copy it into a local and take the address of that",
                          un->loc);
                }
            }
            return t.empty() ? std::string() : t + "*";  // address-of: T -> T*
        }
        if (un->op == "*") {  // pointer dereference: T* -> T (peel one '*')
            if (!t.empty() && t.back() != '*') {
                error("cannot dereference '" + t + "': it is not a pointer", un->loc);
            }
            return (t.empty() || t.back() != '*') ? std::string() : t.substr(0, t.size() - 1);
        }
        // Unary operator overload (spec 6.5): a class operand whose class defines a no-arg
        // operator<op> dispatches to it (paramCount 0 distinguishes it from the binary form).
        if (const MethodInfo* opm = findMethod(baseType(t), "operator" + un->op);
            opm != nullptr && opm->paramCount == 0) {
            return opm->returnType;
        }
        if (un->op == "!") {
            if (!t.empty() && t != "boolean") {
                error("unary '!' requires a boolean operand", un->loc);
            }
            return "boolean";
        }
        if (un->op == "~") {  // bitwise not: integers only
            if (!t.empty() && (!isNumeric(t) || isFloatType(t))) {
                error("unary '~' requires an integer operand", un->loc);
            }
            return t.empty() ? std::string("int") : t;
        }
        // unary '-' / '+': any numeric operand, keeping its type (width and int/float).
        if (!t.empty() && !isNumeric(t)) {
            error("unary '" + un->op + "' requires a numeric operand", un->loc);
        }
        return t.empty() ? std::string("int") : t;
    }

    if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
        const std::string subjType = typeOf(*me->subject);
        const std::string subjBase = baseType(subjType);
        std::string resultType;
        const auto subjDollarM = subjBase.find('$');
        // AN ENUM SUBJECT, exactly as the statement form takes one. The cases name CONSTANTS rather
        // than types, so the type lookup below would call every one of them an unknown type -- which
        // it did, and which made the two forms of `match` disagree about what they can match on for
        // no reason anybody chose. An enum whose whole point is that every case is named is the
        // first thing you want to write a total match-EXPRESSION over: one arm per constant, each
        // yielding a value, no `default` to hide the constant added next year.
        if (auto en = enums_.find(subjBase); en != enums_.end()) {
            const std::vector<std::string>& constants = en->second;
            for (const ast::MatchCase& c : me->cases) {
                if (std::find(constants.begin(), constants.end(), c.typeName) == constants.end()) {
                    error("'" + c.typeName + "' is not a constant of enum '" + subjBase + "'",
                          c.loc);
                }
                if (!c.bindings.empty()) {
                    error("'case " + c.typeName + "' cannot bind anything: an enum constant is a "
                          "value, not a shape with fields to take apart",
                          c.loc);
                }
                pushScope();
                const std::string at = c.result ? typeOf(*c.result) : analyzeYieldBlock(c.body);
                popScope();
                if (resultType.empty()) {
                    resultType = at;
                }
            }
            if (me->defaultResult) {
                const std::string dt = typeOf(*me->defaultResult);
                if (resultType.empty()) {
                    resultType = dt;
                }
            } else if (me->defaultBody) {
                const std::string dt = analyzeYieldBlock(*me->defaultBody);
                if (resultType.empty()) {
                    resultType = dt;
                }
            }
            const bool hasDefault = me->defaultResult != nullptr || me->defaultBody != nullptr;
            if (sealedEnums_.count(subjBase) > 0) {
                std::string missing;
                for (const std::string& k : constants) {
                    bool covered = false;
                    for (const ast::MatchCase& c : me->cases) {
                        if (c.typeName == k) {
                            covered = true;
                        }
                    }
                    if (!covered) {
                        missing += (missing.empty() ? "" : ", ") + k;
                    }
                }
                if (!missing.empty() && !hasDefault) {
                    error("match on sealed enum '" + subjBase + "' is not exhaustive: missing " +
                              missing,
                          me->loc);
                }
            } else if (!hasDefault) {
                error("match on enum '" + subjBase + "' requires a 'default' arm, or declare the "
                      "enum `sealed` so every constant must be covered and a new one cannot be "
                      "forgotten here",
                      me->loc);
            }
            me->resultType = resultType;
            return resultType;
        }
        for (const ast::MatchCase& c : me->cases) {
            // Map a bare case name to the subject's instantiation (Ok -> Ok$int$int) when that exists;
            // fall back to the bare name for a non-generic concrete subclass (Leaf extends Base<int>).
            std::string caseType = c.typeName;
            if (subjDollarM != std::string::npos) {
                const std::string suffixed = c.typeName + subjBase.substr(subjDollarM);
                if (lookupClass(suffixed) != nullptr) {
                    caseType = suffixed;
                }
            }
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBase)) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce the case type's fields as locals in the arm body.
            pushScope();
            for (const ast::Param& b : c.bindings) {
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            }
            const std::string at = c.result ? typeOf(*c.result) : analyzeYieldBlock(c.body);
            popScope();
            if (resultType.empty()) {
                resultType = at;
            }
        }
        if (me->defaultResult) {
            const std::string dt = typeOf(*me->defaultResult);
            if (resultType.empty()) {
                resultType = dt;
            }
        } else if (me->defaultBody) {
            const std::string dt = analyzeYieldBlock(*me->defaultBody);
            if (resultType.empty()) {
                resultType = dt;
            }
        }
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit with no
        // default; otherwise a default arm is required so the expression always yields.
        const ClassInfo* sc = lookupClass(subjBase);
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : me->cases) {
                    if (c.typeName == p) {
                        covered = true;
                    }
                }
                if (!covered && !me->defaultResult && !me->defaultBody) {
                    error("match on sealed '" + subjBase +
                              "' is not exhaustive: missing case '" + p + "'",
                          me->loc);
                }
            }
        } else if (!me->defaultResult && !me->defaultBody) {
            error("match expression requires a 'default' arm (the subject is not sealed)",
                  me->loc);
        }
        me->resultType = resultType;
        return resultType;
    }

    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
        const std::string t = typeOf(*mv->operand);
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mv->operand.get())) {
            moved_.insert(id->name);  // the source variable becomes invalid
        } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(mv->operand.get())) {
            // Partial field move (spec 19.9): only a movable/unique field of a partitionable class.
            const std::string oc = baseType(typeOf(*mem->object));
            const ClassInfo* ci = lookupClass(oc);
            const FieldInfo* fi = ci != nullptr ? findField(oc, mem->member) : nullptr;
            if (ci != nullptr && fi != nullptr) {
                if (!ci->isPartitionable) {
                    error("cannot move field '" + mem->member + "' of non-partitionable class '" +
                              oc + "'; mark the class 'partitionable' (spec 19.9)",
                          mv->loc);
                } else if (!fi->isMovable && !fi->isUnique) {
                    error("cannot move field '" + mem->member +
                              "': only a 'movable' or 'unique' field can be moved separately (spec 19.9)",
                          mv->loc);
                } else if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                    moved_.insert(oid->name + "." + mem->member);  // track the field as moved
                }
            }
        }
        return mv->castType.empty() ? t : mv->castType;  // `move x as T` reinterprets to T (spec 19.3)
    }
    if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr)) {
        // `extract X from region R` (spec 17): the region must exist; the object type is the result type
        // (an owning pointer to the relocated object). The source variable is spent afterwards (like move).
        const std::string t = typeOf(*ex->target);  // also checks the target's first (valid) use
        if (ex->region.find('.') == std::string::npos) {  // a `this.field` region is validated at codegen
            const LocalVar* r = lookupLocal(ex->region);
            if (const ClassInfo* rc = lookupClass(ex->region);
                r == nullptr && rc != nullptr && rc->isRegionClass) {
                // Naming a region class here is the reasonable guess -- `release region Node` names
                // one -- so it gets the real reason rather than "unknown region". Extraction relocates
                // an object out of a region it would otherwise die with; a region class's arena is the
                // only place its instances may be, so there is nowhere to relocate TO. This is the
                // same refusal as `on heap`, and for the same reason.
                error("'" + ex->region +
                          "' is a `region class`: its arena is the only place its instances may be, "
                          "so there is nowhere to extract one to. Extraction is for an owned region, "
                          "which dies while the object outlives it",
                      ex->loc);
            } else if (r == nullptr) {
                error("unknown region '" + ex->region + "' in extract", ex->loc);
            } else if (r->type != "region") {
                error("'" + ex->region + "' is not a region", ex->loc);
            }
        }
        // Polaron-1717: mark the source spent so a later read is rejected with the extract-specific message.
        // Only a plain variable can be flow-tracked; an element/field target is nulled at run time instead.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(ex->target.get())) {
            // Polaron-1718: if a field of the object being extracted was allocated in the SAME region, moving
            // just the object leaves that field behind -- a dangling pointer after release. Reject it.
            const std::string prefix = id->name + ".";
            for (const auto& [path, rgn] : regionOf_) {
                if (rgn == ex->region && path.rfind(prefix, 0) == 0) {
                    error("cannot extract '" + id->name + "': its field '" + path.substr(prefix.size()) +
                              "' lives in the same region '" + ex->region +
                              "' -- extract the graph (cascade move) or allocate the field elsewhere",
                          ex->loc);
                    break;
                }
            }
            extracted_[id->name] = ex->loc.line;
            moved_.insert(id->name);
            regionOf_.erase(id->name);  // the object left the region; its recorded fields are stale
        }
        return t;
    }
    if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(&expr)) {
        // `mark of region R` yields a `checkpoint`; mark/rollback need a `stack region` (Polaron-1713).
        // A `this.field` region is validated at codegen (spec 17: region as a field).
        if (mk->region.find('.') == std::string::npos) {
            const LocalVar* r = lookupLocal(mk->region);
            if (r == nullptr) {
                error("unknown region '" + mk->region + "' in mark", mk->loc);
            } else if (r->type != "region") {
                error("'" + mk->region + "' is not a region", mk->loc);
            } else if ((regionFlavor_.count(mk->region) ? regionFlavor_[mk->region] : std::string()) !=
                       "stack") {
                error("mark/rollback need a `stack region`, but '" + mk->region + "' is not one (spec 17)",
                      mk->loc);
            }
        }
        return "checkpoint";
    }
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        // try? Result<T,E>/Option<T> yields T (the first type arg of the operand's instantiation).
        const std::string ot = baseType(typeOf(*tx->operand));
        // try? early-returns the Err/None to the ENCLOSING method, so that method must itself return a
        // Result/Option (spec 21.2). Otherwise codegen would emit a type-mismatched `return`. Take the
        // bare type name (before generic args and any pointer marker), e.g. "Result$int$int*" -> "Result".
        const std::string rtm = baseType(currentReturnType_);
        auto family = [](const std::string& mangled) {
            const auto d = mangled.find('$');
            return d == std::string::npos ? mangled : mangled.substr(0, d);
        };
        // The error payload of a `Result$T$E`, read off the monomorphized `Err$T$E`'s own `error` field
        // rather than by splitting the mangled string -- `Result<Map<int,int>, E>` mangles to
        // `Result$Map$int$int$E` and no amount of `$`-counting recovers E from that. Codegen decodes the
        // payload the same way (through the variant class, not the string), so the two phases agree by
        // construction. An unresolvable name yields "" and the check stands down: incomplete is safe.
        auto errPayload = [&](const std::string& mangled) -> std::string {
            const auto d = mangled.find('$');
            if (d == std::string::npos) {
                return {};
            }
            const ClassInfo* ec = lookupClass("Err" + mangled.substr(d));
            if (ec == nullptr) {
                return {};
            }
            const auto f = ec->fields.find("error");
            return f == ec->fields.end() ? std::string() : f->second.type;
        };
        const std::string rb = family(rtm);
        const std::string ob = family(ot);
        if (!currentReturnType_.empty() && rb != "Result" && rb != "Option") {
            error("'try?' can only be used inside a method that returns Result or Option, but this "
                  "method returns '" + currentReturnType_ + "' (spec 21.2)",
                  tx->loc);
        } else if (!currentReturnType_.empty() && (ob == "Result" || ob == "Option") && ob != rb) {
            // Propagation forwards the operand UNCHANGED -- codegen emits `CreateRet(val)` on the very
            // value it tested. A None cannot stand in for an Err (it carries no payload) and an Err
            // cannot stand in for a None (it carries one), so the two families may not be crossed.
            error("'try?' propagates the failure of an operand of type '" + ob +
                      "', but this method returns '" + rb +
                      "': the failure value is forwarded unchanged, so the two must be the same family "
                      "(spec 21.2). Match the method's return type to the operand, or convert "
                      "explicitly -- " +
                      std::string(ob == "Option"
                                      ? "a None carries no error value to put in an Err"
                                      : "an Err carries an error value that a None would discard"),
                  tx->loc);
        } else if (ob == "Result" && rb == "Result") {
            // The E half. Same reason: the Err travels out byte-for-byte, and at the LLVM level every
            // value-form Result is ONE StructType and every boxed one an opaque `ptr` -- so a mismatched
            // error type is not caught downstream by anything. It reaches the binary and is reinterpreted.
            const std::string oe = errPayload(ot);
            const std::string re = errPayload(rtm);
            if (!oe.empty() && !re.empty() && !isSubtype(oe, re)) {
                error("'try?' propagates a 'Result' whose error type is '" + oe +
                          "', but this method returns a 'Result' whose error type is '" + re +
                          "'. The failure value is forwarded unchanged (spec 21.2), so '" + oe +
                          "' would be reinterpreted as '" + re +
                          "'. Convert the error before propagating -- match on the operand and return an "
                          "`Err(...)` built with the '" + re + "' this method declares -- or declare it "
                          "'returns Result<..., " + oe + ">' and let the error travel as it is",
                      tx->loc);
            }
        }
        const auto p = ot.find('$');
        if (p == std::string::npos) {
            return "";
        }
        const std::string rest = ot.substr(p + 1);
        const auto q = rest.find('$');
        return q == std::string::npos ? rest : rest.substr(0, q);
    }

    if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
        if (ri->size) {
            typeOf(*ri->size);
        }
        if (ri->atAddress) {  // itself.at(addr, size): the address must be numeric/address
            const std::string at = typeOf(*ri->atAddress);
            if (!at.empty() && !isNumeric(at)) {
                error("region address must be a number or address, got '" + at + "'", ri->loc);
            }
        }
        // Constrained types must exist (dotted family names like Animal.X are a
        // later refinement and are skipped here).
        for (const auto& list : {ri->accepts, ri->rejects}) {
            for (const std::string& t : list) {
                // A generic constraint type (Box<?>, ArrayList<int>) names a template, not a plain
                // class; skip the plain-class existence check for those (spec 17.3, best-effort filter).
                if (t.find('<') == std::string::npos && t.find('.') == std::string::npos &&
                    lookupClass(t) == nullptr) {
                    error("region accepts/rejects references unknown type '" + t + "'", ri->loc);
                }
            }
        }
        // atMultiple ranges (spec 17.4): each range address must be numeric; its accepts/rejects types
        // must exist.
        for (const auto& r : ri->ranges) {
            const std::string at = typeOf(*r.address);
            if (!at.empty() && !isNumeric(at)) {
                error("region range address must be a number or address, got '" + at + "'", ri->loc);
            }
            for (const auto& list : {r.accepts, r.rejects}) {
                for (const std::string& t : list) {
                    if (t.find('<') == std::string::npos && t.find('.') == std::string::npos &&
                        lookupClass(t) == nullptr) {
                        error("region range accepts/rejects references unknown type '" + t + "'", ri->loc);
                    }
                }
            }
        }
        return "region";
    }

    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        const std::string srcRaw = typeOf(*cst->operand);
        const std::string& dst = cst->targetType;
        checkBitCounted(dst, cst->loc);  // reject cast<int64> etc. outside freestanding mode
        checkWideningLostBits(*cst, srcRaw, dst);  // cast<address>(f << 12): the bits are already gone  // cast<address>(f << 12): the bits are already gone
        // A `newtype` casts to/from its underlying type (spec 24): classify both by the underlying
        // so cast<OrderId>(long) and cast<long>(orderId) are accepted while staying distinct types.
        auto under = [&](const std::string& t) {
            auto it = newtypes_.find(baseType(t));
            return it != newtypes_.end() ? it->second : t;
        };
        const std::string src = under(srcRaw);
        // THE REFERENCE TYPES THAT ARE NOT IN `classes_`. String, string and the reflection tokens
        // are pointer-shaped values the compiler knows by name rather than by declaration, so
        // `lookupClass` says no to all of them. As a cast SOURCE that was already handled -- the
        // list below has said `Type`/`Method` for a long time -- but as a cast DESTINATION it was
        // not, and the asymmetry meant `cast<String>(f.get(obj))` was refused while
        // `cast<int>(f.get(obj))` worked. Reflection hands every field back as an Object; refusing
        // to name it back as a String is refusing to read half the fields there are.
        auto builtinRef = [](const std::string& t) {
            return t == "String" || t == "string" || t == "Object" || t == "Type" ||
                   t == "Method" || t == "Field" || t == "Annotation";
        };
        const bool dstRef = builtinRef(dst) || lookupClass(baseType(dst)) != nullptr;
        const bool srcRef = src.empty() || builtinRef(src) ||
                            lookupClass(baseType(src)) != nullptr || isRefType(src) ||
                            src.rfind("funcptr<", 0) == 0;  // a bare C fn pointer reinterprets like a ptr
        const bool dstFuncptr = dst.rfind("funcptr<", 0) == 0;  // a bare C function pointer (dynamic FFI)
        const bool dstPtr = isRefType(dst) || dstRef || dstFuncptr;  // pointer/ref target (T*, T&, class)
        // `char` is an integer for casting purposes; Decimal converts to/from the numeric family too
        // (scaled fixed-point, spec 34).
        auto numLike = [](const std::string& t) {
            return isNumeric(t) || t == "char" || t == "Decimal";
        };
        const std::string dstU = under(dst);  // a newtype's underlying decides how the cast lowers
        if (numLike(dstU)) {
            // numeric <- numeric/char, a pointer/address reinterpreted as an integer (spec 17.8), or
            // an int-style enum reinterpreted as its ordinal (spec 12.1).
            const bool srcIntEnum = enums_.count(baseType(src)) > 0;
            if (!src.empty() && !numLike(src) && !srcRef && !srcIntEnum) {
                error("cannot cast '" + srcRaw + "' to '" + dst + "'", cst->loc);
            }
        } else if (dstPtr) {
            // Reference downcast (spec 31), or int/address -> an explicit pointer T* (spec 17.8).
            // Casting a number to a bare class (not a pointer) stays an error.
            const bool intToPtr = (isRefType(dst) || dstFuncptr) && isNumeric(src);
            if (!src.empty() && !srcRef && !intToPtr) {
                error("cannot cast '" + src + "' to '" + dst + "'", cst->loc);
            }
        } else if (enums_.count(baseType(dst)) > 0) {
            // NUMBER -> int-style enum, the reverse of the ordinal reinterpret just above.
            //
            // It was missing, and the asymmetry was the tell: `cast<int>(someEnum)` has always been
            // allowed, so an enum could be taken apart and never put back together. That is a real
            // hole for any program that reads an enumerated field out of something -- a device
            // register, a wire format, a file header -- because such a field always arrives as a
            // number.
            //
            // CHECKED, not a reinterpret (see codegen). An unchecked version would let a program
            // manufacture an enum value outside the declared set, which is a hole in the type system
            // rather than a convenience -- and this language does not convert integers silently
            // anywhere else either.
            if (!src.empty() && !numLike(src) && enums_.count(baseType(src)) == 0) {
                error("cannot cast '" + srcRaw + "' to enum '" + dst + "'", cst->loc);
            }
        } else {
            error("cast<" + dst + "> is not supported here", cst->loc);
        }
        if (cst->op == 1) {
            return "boolean";  // `x is T` -> boolean test
        }
        if (cst->op == 2) {
            return ast::makeNullable(dst);  // `x as? T` -> the value or null
        }
        return dst;                                // cast<T> / `x as T` (checked)
    }

    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        const std::string ct = typeOf(*tern->cond);
        if (!ct.empty() && ct != "boolean") {
            error("ternary condition must be boolean, got '" + ct + "'", tern->loc);
        }
        // The result type comes from BOTH arms. Reading it off `then` alone made the other arm truncate:
        // `long r = c ? 7 : big;` took `int` from the literal, and codegen -- which had the same omission,
        // so the two agreed -- emitted `trunc i64 %big to i32`. The assignment to `long` then looked like
        // an ordinary widening and nothing reported anything.
        const std::string tt = typeOf(*tern->thenExpr);
        const std::string et = typeOf(*tern->elseExpr);
        if (tt.empty() || et.empty() || tt == et) {
            return tt.empty() ? et : tt;
        }
        if (tt == "null" || et == "null" || isNullableType(tt) || isNullableType(et)) {
            const std::string bt = ast::stripNullable(tt), be = ast::stripNullable(et);
            if (bt == "null") {
                return ast::makeNullable(be);
            }
            if (be == "null") {
                return ast::makeNullable(bt);
            }
            return ast::makeNullable(bt);
        }
        if (isIntName(tt) && isIntName(et)) {
            // Width widens silently; SIGNEDNESS must agree, the same rule the arithmetic operators use --
            // a literal that fits the other arm adapts, exactly as it does at an assignment or a return.
            const bool tLit = intLiteralFits(*tern->thenExpr, et);
            const bool eLit = intLiteralFits(*tern->elseExpr, tt);
            if (!tLit && !eLit && ast::isUnsignedIntName(tt) != ast::isUnsignedIntName(et)) {
                error("the two arms of this '?:' are '" + tt + "' and '" + et +
                          "', which differ in signedness. Widening happens on its own, but mixing signed "
                          "and unsigned does not: the same bits mean different numbers. Convert one arm "
                          "explicitly -- `cast<" + tt + ">(...)` on the else-arm, or `cast<" + et +
                          ">(...)` on the then-arm -- so the result's meaning is written down",
                      tern->loc);
            }
            if (tLit) {
                return et;
            }
            if (eLit) {
                return tt;
            }
            return intBits(tt) >= intBits(et) ? tt : et;   // the wider arm, so neither is truncated
        }
        if (isNumeric(tt) && isNumeric(et)) {
            if (tt == "double" || et == "double") {
                return "double";
            }
            if (tt == "float" || et == "float") {
                return "float";
            }
            return tt;
        }
        // Classes and everything else: one arm has to be usable as the other, or the result has no type.
        if (isSubtype(et, tt)) {
            return tt;
        }
        if (isSubtype(tt, et)) {
            return et;
        }
        error("the two arms of this '?:' have unrelated types '" + tt + "' and '" + et +
                  "', so the expression has no single type. Both arms must produce the same type, or one "
                  "that the other can stand in for -- give them a common supertype, or convert one arm",
              tern->loc);
        return tt;
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {  // a ?? b (spec 3.7)
        const std::string lt = typeOf(*nc->lhs);
        const std::string rt = typeOf(*nc->rhs);
        const std::string base = ast::stripNullable(lt);
        // The fallback's base must be compatible with the left's base.
        if (!base.empty() && !rt.empty()) {
            const std::string rbase = ast::stripNullable(rt);
            if (rbase != "null" && !isSubtype(rbase, base) && !isSubtype(base, rbase)) {
                error("'??' fallback of type '" + rt + "' is incompatible with '" + lt + "'", nc->loc);
            }
        }
        // Result is the left's non-null base, but stays nullable if the fallback can be null.
        return isNullableType(rt) ? ast::makeNullable(base) : base;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        // A NULL TEST must see the operand un-narrowed. Testing a value the compiler has already proven
        // non-null is redundant, not wrong -- and the declaration still says `nullable`, so the
        // comparison is exactly what the author wrote. Narrowing it first turned `nullable int b = 5;
        // ... b != null` into "operator '!=' requires operands of the same type", because the narrowed
        // `int` is neither a pointer nor nullable and no longer looks comparable to null.
        const bool nullTest =
            (bin->op == "==" || bin->op == "!=") &&
            (dynamic_cast<const ast::NullLiteralExpr*>(bin->lhs.get()) != nullptr ||
             dynamic_cast<const ast::NullLiteralExpr*>(bin->rhs.get()) != nullptr);
        const bool savedSuppress = suppressNarrowing_;
        suppressNarrowing_ = suppressNarrowing_ || nullTest;
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        suppressNarrowing_ = savedSuppress;
        const std::string& op = bin->op;
        // Operator overloading: a OP b where a's class defines `operator OP` (spec 6.5).
        if (const MethodInfo* om = findMethod(baseType(lt), "operator" + op)) {
            // The right operand is the operator's PARAMETER and was never checked against it -- so
            // `money + other` called `operator+(Money)` with an unrelated class and read its fields
            // through Money's layout. Type confusion, in an expression that reads like arithmetic.
            // A call spelled `a.plus(b)` had this check all along; the symbol form skipped it.
            if (!om->paramTypes.empty() && !rt.empty()) {
                const std::string& pt = om->paramTypes.front();
                // Report the name as WRITTEN. A type declared in two namespaces is rewritten to
                // `Ns__Type` internally, and telling someone their operand does not match `A__Money`
                // names a class they never wrote. Through the one shared projection now: this used to
                // be a hand-rolled `rfind("__")` here and another copy elsewhere, applied where
                // somebody remembered -- and it also says the FULL PATH when the bare name genuinely
                // identifies two types, which is exactly when the reader needs it.
                auto asWritten = [this](const std::string& s) { return typeAsWritten(s); };
                if (!pt.empty() && !isSubtype(rt, pt) && !intLiteralFits(*bin->rhs, pt)) {
                    error("the right operand of '" + op + "' is '" + asWritten(rt) + "', but '" +
                              asWritten(baseType(lt)) + "' declares `operator" + op + "(" + asWritten(pt) +
                              ")`. An operator is an ordinary method reached through a symbol, so its "
                              "operand has to match its parameter -- otherwise the value is read "
                              "through the wrong type's layout. Convert it, or declare an "
                              "`operator" + op + "(" + asWritten(rt) + ")` if this combination is meant",
                          bin->loc);
                }
            }
            return om->returnType;
        }
        // SIMD vectors: element-wise + - * / ; a scalar operand broadcasts.
        if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
            if (op != "+" && op != "-" && op != "*" && op != "/") {
                error("operator '" + op + "' is not defined on vectors", bin->loc);
            }
            return "vec" + std::to_string(vw);
        }
        // Pointer arithmetic (spec 27): `p + n` / `p - n` step by whole elements and stay a pointer;
        // `q - p` is the number of elements between them. Allowed on every pointee type, but stepping a
        // pointer TO A CLASS is warned about: it usually points at one object, not an array of them.
        if ((op == "+" || op == "-") && isRefType(lt) && !isRefType(rt) && !rt.empty()) {
            if (!isIntName(rt)) {
                error("a pointer can only be offset by an integer, got '" + rt + "' (spec 27)", bin->loc);
            }
            warnClassPointerArith(lt, bin->loc);
            return lt;
        }
        if (op == "-" && isRefType(lt) && isRefType(rt)) {
            if (baseType(lt) != baseType(rt)) {
                error("cannot subtract pointers to different types ('" + lt + "' and '" + rt + "')",
                      bin->loc);
            }
            warnClassPointerArith(lt, bin->loc);
            return "long";
        }
        // String concatenation (spec 4): String/string + String/string -> String.
        auto isStr = [](const std::string& t) { return t == "String" || t == "string"; };
        if (op == "+" && isStr(lt) && isStr(rt)) {
            return "String";
        }
        // Decimal fixed-point (spec 34): arithmetic yields a Decimal, comparison a boolean. A mixed
        // Decimal/other operand needs an explicit cast.
        if (lt == "Decimal" && rt == "Decimal") {
            if (op == "+" || op == "-" || op == "*" || op == "/") {
                return "Decimal";
            }
            if (op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=") {
                return "boolean";
            }
        }
        // `char` is an integer (i32) for arithmetic/comparison/bitwise (e.g. c - '0', c >= '0').
        auto numOk = [](const std::string& t) { return isNumeric(t) || t == "char"; };
        // SIGNEDNESS must agree (spec 3.6). Width does not: a narrower integer widens silently because
        // that conversion preserves the value. Signedness is different -- there is no common type that
        // represents every value of a 64-bit unsigned AND every value of a signed one, so the compiler
        // would have to pick a side and be wrong about the other. It did: `address(1) < int(-1)` answered
        // TRUE, because -1 sign-extends and then the comparison is unsigned.
        //
        // Deliberately NOT a rule about type names: `address` and `ulong` are one type under two
        // spellings, and demanding a cast between two identically-sized types would be noise. Measured
        // across the kernel, the stdlib and every sample: 380 mixed-type sites, and this rejects none of
        // them -- it costs nothing today and closes the one case that gives wrong answers.
        auto signednessOk = [&](const std::string& a, const std::string& b) {
            if (!isIntName(a) || !isIntName(b)) {
                return true;  // not the integer path
            }
            if (ast::isUnsignedIntName(a) == ast::isUnsignedIntName(b)) {
                return true;
            }
            // Mixed: fine when the SIGNED side is strictly wider, because it then represents every value
            // of the unsigned one (`uint` + `long`). Equal width cannot: half of each is unrepresentable.
            const std::string& u = ast::isUnsignedIntName(a) ? a : b;
            const std::string& s = ast::isUnsignedIntName(a) ? b : a;
            return intBits(s) > intBits(u);
        };
        auto checkSignedness = [&]() {
            // An untyped literal expression adapts to its context, exactly as it does in an assignment
            // (`byte b = 0;`), so it never forces a cast.
            if (ast::isLiteralOnlyExpr(*bin->lhs) || ast::isLiteralOnlyExpr(*bin->rhs)) {
                return;
            }
            if (signednessOk(lt, rt)) {
                return;
            }
            error("cannot mix signed and unsigned operands ('" + lt + "' " + op + " '" + rt +
                      "'): there is no common type that represents both, so convert one explicitly "
                      "with cast<T>(...)",
                  bin->loc);
        };
        if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
            if ((!lt.empty() && !numOk(lt)) || (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            if (op == "%" && (isFloatType(lt) || isFloatType(rt))) {
                error("operator '%' requires int operands", bin->loc);
            }
            if (isFloatType(lt) || isFloatType(rt)) {  // f32 only if neither side is f64
                const bool f64 = lt == "double" || lt == "float64" || rt == "double" || rt == "float64";
                return f64 ? "double" : "float";
            }
            checkSignedness();
            return intBits(lt) >= intBits(rt) ? lt : rt;  // wider integer wins
        }
        if (op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>") {
            if (isFloatType(lt) || isFloatType(rt) || (!lt.empty() && !numOk(lt)) ||
                (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires integer operands", bin->loc);
            }
            // A shift's right operand is a COUNT, not a value in the same domain -- `addr >> 12` shifts
            // by twelve, and twelve is not an address. Only `& | ^` pair two values.
            if (op != "<<" && op != ">>") {
                checkSignedness();
            }
            return intBits(lt) >= intBits(rt) ? lt : rt;
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            // Java-style enums order by ordinal (spec 12.2), like Java's compareTo: allow ordering when
            // both sides are the same such enum.
            const bool sameJavaEnum = baseType(lt) == baseType(rt) && javaEnums_.count(baseType(lt)) > 0;
            if (!sameJavaEnum &&
                ((!lt.empty() && !numOk(lt)) || (!rt.empty() && !numOk(rt)))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            // Ordering is where mixing signedness produced a WRONG ANSWER rather than a surprising one:
            // `address(1) < int(-1)` was true, because -1 sign-extends and the comparison is unsigned.
            if (!sameJavaEnum) {
                checkSignedness();
            }
            return "boolean";
        }
        if (op == "==" || op == "!=") {
            // Same hazard as ordering: the operands widen to one type first, so a negative signed value
            // and a large unsigned one can come out equal.
            checkSignedness();
            const bool nullPtr =
                (lt == "null" && (isRefType(rt) || isNullableType(rt))) ||
                (rt == "null" && (isRefType(lt) || isNullableType(lt)));
            // Numeric (and char) operands compare after widening to a common type, so differing
            // integer/float widths are fine (e.g. a long compared with an int literal).
            const bool bothNumeric = numOk(lt) && numOk(rt);
            if (!lt.empty() && !rt.empty() && lt != rt && !nullPtr && !bothNumeric) {
                error("operator '" + op + "' requires operands of the same type", bin->loc);
            }
            return "boolean";
        }
        if (op == "&&" || op == "||") {
            if ((!lt.empty() && lt != "boolean") || (!rt.empty() && rt != "boolean")) {
                error("operator '" + op + "' requires boolean operands", bin->loc);
            }
            return "boolean";
        }
        error("unsupported binary operator '" + op + "'", bin->loc);
        return "";
    }

    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
        // `on stack` is fine -- it moves the stack pointer and nothing else. `on heap` enters the
        // allocator, which is precisely the machinery the interrupted code may be standing inside.
        if (nw->location == "heap") {
            noteUnsafeForInterrupt("allocate on the heap", nw->loc);
        }
        // region-binder DATA-RACE (§14): a closure handed to a Thread may only capture state that is safe to
        // share across threads -- atomic<T>/Mutex<T>/Channel<T>, or a copied value. Capturing a plain mutable
        // reference (byref, or byvalue a pointer) shares mutable state between two threads -> a data race.
        if (regionBinder_ && nw->className == "Thread" && !nw->args.empty()) {
            const ast::LambdaExpr* lam = dynamic_cast<const ast::LambdaExpr*>(nw->args[0].get());
            if (lam == nullptr) {
                if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(nw->args[0].get())) {
                    auto it = lambdaLocals_.find(aid->name);
                    if (it != lambdaLocals_.end()) {
                        lam = it->second;
                    }
                }
            }
            if (lam != nullptr) {
                for (const ast::Capture& cap : lam->captures) {
                    const LocalVar* lv = lookupLocal(cap.name);
                    if (lv == nullptr) {
                        continue;
                    }
                    const std::string b = baseType(lv->type);
                    // ...OR THE TYPE SAYS ITS OWN THREADS MAY SHARE IT (`implements Shared`).
                    //
                    // The three below are the shapes the language provides; `Shared` is the escape
                    // hatch for the one a worker pool is actually made of -- a value everybody reads
                    // and nobody writes, or one whose writes are already atomic. Without it, the only
                    // way to write a crew was to stop the checker seeing the crew, which is the
                    // choice this refuses to make anybody take. It is a SENTENCE somebody has to
                    // write on the type, so it cannot be arrived at by accident.
                    const bool safe = b.rfind("atomic", 0) == 0 || b.rfind("Mutex", 0) == 0 ||
                                      b.rfind("Channel", 0) == 0 || declaresShared(b);
                    const bool shares = cap.byRef || isRefType(lv->type);  // shares the var / the pointee
                    if (shares && !safe) {
                        error("region-binder: thread closure captures shared mutable '" + cap.name +
                                  "' (type '" + lv->type + "') -- a data race; share it via atomic<T> / "
                                  "Mutex<T> / Channel<T>, or capture an immutable copy (byvalue a value)",
                              nw->loc);
                    }
                }
            }
        }
        // Value Result/Option (spec 21, value form): Ok/Err/Some/None with location "value" is a value, not
        // a heap object. Type it as the sealed base (Result$T$E / Option$T, no star) and check the payload
        // against T (Ok/Some) or E (Err); None carries no payload. No class is allocated.
        if (nw->location == "value") {
            const bool isResult = nw->className == "Ok" || nw->className == "Err";
            const bool okSide = nw->className == "Ok" || nw->className == "Some";
            const std::string payloadType =
                okSide ? (nw->typeArgs.empty() ? std::string() : nw->typeArgs[0])
                       : (isResult && nw->typeArgs.size() > 1 ? nw->typeArgs[1] : std::string());
            if (!nw->args.empty()) {
                const std::string at = typeOf(*nw->args[0]);
                if (!payloadType.empty() && !at.empty() && !isSubtype(at, payloadType) &&
                    !intLiteralFits(*nw->args[0], payloadType)) {
                    error("cannot build '" + nw->className + "' with a value of type '" + at +
                              "' (expected '" + payloadType + "')",
                          nw->loc);
                }
            }
            return ast::mangleGeneric(isResult ? "Result" : "Option", nw->typeArgs);
        }
        const std::string cn = ast::mangleGeneric(nw->className, nw->typeArgs);  // Box<int> -> Box$int
        checkTypeAccessible(cn, nw->loc);
        const ClassInfo* ci = lookupClass(cn);
        if (ci == nullptr) {
            error("unknown class '" + cn + "'", nw->loc);
            return "";
        }
        if (ci->isInterface || ci->isAbstract) {
            error("cannot instantiate " +
                      std::string(ci->isInterface ? "interface" : "abstract class") + " '" + cn + "'",
                  nw->loc);
        }
        if (nw->location != "stack" && nw->location != "heap") {
            error("'new' location must be 'stack' or 'heap', got '" + nw->location + "'", nw->loc);
        }
        if (!nw->region.empty()) {
            const auto dot = nw->region.find('.');
            if (dot != std::string::npos) {
                // `new X in region this.field` (spec 17: region as a field), or `Class.field` for a
                // STATIC one.
                //
                // THE QUALIFIER IS READ. This used to take the name after the dot and look it up in
                // the current class whatever stood before it, so `Other.arena` silently resolved to
                // your own field of that name -- and `Arena.shared`, a static region field that parses
                // perfectly, was reported as `unknown region field` because a static is in neither the
                // instance-field table nor the locals. Declarable and unusable, which is the worst of
                // the three possible states.
                const std::string qualifier = nw->region.substr(0, dot);
                const std::string fieldName = nw->region.substr(dot + 1);
                const std::string owner = (qualifier == "this") ? currentClass_ : qualifier;
                const FieldInfo* f = owner.empty() ? nullptr : findField(owner, fieldName);
                if (f == nullptr) {
                    if (qualifier != "this" && lookupClass(qualifier) == nullptr) {
                        error("unknown region '" + nw->region + "': '" + qualifier +
                                  "' is not a class in scope, and a dotted region names either "
                                  "`this.<field>` or `<Class>.<static field>`",
                              nw->loc);
                    } else {
                        error("unknown region field '" + nw->region + "'", nw->loc);
                    }
                } else if (f->type != "region") {
                    error("'" + nw->region + "' is not a region", nw->loc);
                } else if (qualifier != "this" && !f->isStatic) {
                    // Naming another class's INSTANCE field has no receiver to read it from.
                    error("'" + nw->region + "' is an instance field of '" + qualifier +
                              "', so there is no object here to take it from. Use `this." + fieldName +
                              "` inside '" + qualifier + "', or declare the region `static` to share "
                              "one arena under the class's name",
                          nw->loc);
                }
            } else {
                const LocalVar* r = lookupLocal(nw->region);
                if (r == nullptr) {
                    error("unknown region '" + nw->region + "'", nw->loc);
                } else if (r->type != "region") {
                    error("'" + nw->region + "' is not a region", nw->loc);
                } else {
                    checkRegionAccepts(nw->region, cn, nw->loc);
                }
            }
        }
        // A `private constructor` is how a type says "not by `new`" -- the singleton, the factory, the
        // type reachable only through its own static maker. Checked here because `new` is the only
        // place a constructor is named by a caller; the class's own static maker passes, since it is
        // inside the owner.
        checkMemberAccessible("constructor", cn, ci->ctorVisibility, cn, nw->loc);
        // Full construction: arguments align 1:1 with parameters, so type-check them. Fewer
        // arguments is a partial constructor (spec 18.9) -- omitted params come from persistent
        // fields and the alignment is not 1:1, so only the too-many case is an error there.
        if (nw->args.size() == ci->ctorParamTypes.size()) {
            checkCallArgs(nw->args, ci->ctorParamTypes, "constructor '" + cn + "'");
        } else {
            for (const auto& arg : nw->args) {
                typeOf(*arg);
            }
            if (nw->args.size() > ci->ctorParamTypes.size()) {
                error("constructor '" + cn + "' expects at most " +
                          std::to_string(ci->ctorParamTypes.size()) + " argument(s) but got " +
                          std::to_string(nw->args.size()),
                      nw->loc);
            } else {
                // Fewer arguments is a partial constructor (spec 18.9), valid only when the class has
                // persistent fields to supply the omitted parameters; otherwise it is a missing
                // argument (calling the constructor with too few would be undefined).
                bool hasPersist = false;
                for (std::string c = baseType(cn); !c.empty() && !hasPersist;) {
                    for (const PersistentFieldInfo& pf : persistentFields_) {
                        if (pf.cls == c) { hasPersist = true; break; }
                    }
                    const ClassInfo* ic = lookupClass(c);
                    c = ic != nullptr ? ic->superclass : std::string();
                }
                if (!hasPersist) {
                    error("constructor '" + cn + "' expects " +
                              std::to_string(ci->ctorParamTypes.size()) + " argument(s) but got " +
                              std::to_string(nw->args.size()),
                          nw->loc);
                }
            }
        }
        return cn;
    }

    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
        const std::string st = typeOf(*na->size);
        if (!st.empty() && st != "int") {
            error("array size must be an int", na->loc);
        }
        // `new T[n]() in region R` is checked against the region's accepts/rejects exactly as an object
        // is. A region is TYPED -- that is what separates it from a hand-rolled arena, which takes bytes
        // and forgets what they were -- so an array entering one has to answer the same question its
        // element type would. Checked on the ELEMENT: `accepts({byte})` admits `byte[]`, because what
        // the region is being asked to hold is bytes.
        if (!na->region.empty()) {
            checkRegionAccepts(na->region, na->elementType, na->loc);
        }
        return na->elementType + "[]";
    }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {  // `[a, b, c]` (spec 25)
        if (al->elements.empty()) {
            error("empty array literal '[]' has no inferable element type; use 'new T[0]()'",
                  al->loc);
            return "";
        }
        const std::string elem = typeOf(*al->elements[0]);
        for (std::size_t i = 1; i < al->elements.size(); ++i) {
            const std::string et = typeOf(*al->elements[i]);
            if (!et.empty() && !elem.empty() && !isSubtype(et, elem) && !isSubtype(elem, et)) {
                error("array literal element " + std::to_string(i + 1) + " has type '" + et +
                          "', incompatible with '" + elem + "'",
                      al->elements[i]->loc);
            }
        }
        return elem + "[]";
    }

    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        const std::string at = typeOf(*ix->array);
        const std::string it = typeOf(*ix->index);
        // operator[] overload (spec 6.5): `obj[i]` where obj's class defines operator[].
        if (const MethodInfo* om = findMethod(baseType(at), "operator[]")) {
            return om->returnType;
        }
        if (vecWidth(at) > 0 || at == "mat4") {  // SIMD vector/matrix: v[i] / m[i] -> float
            if (!it.empty() && it != "int") {
                error("vector index must be an int", ix->loc);
            }
            return "float";
        }
        if (!it.empty() && !isIntName(it)) {
            error("index must be an integer", ix->loc);
        }
        if (at.empty()) {
            return "";
        }
        if (isRefType(at)) {
            return baseType(at);  // p[i] on a raw pointer T* -> T (spec 17.8)
        }
        if (!isArrayType(at)) {
            error("cannot index a value of non-array type '" + at + "'", ix->loc);
            return "";
        }
        return elementOf(at);
    }

    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(&expr)) {
        // Interpolation builds a String, so it carries the managed runtime with it -- a stored `$"..."`
        // emitted snprintf + __polaron_malloc + __polaron_str_copy/free, none of which exist bare metal. The
        // guide notes it can be lowered without an allocation "when the result is only consumed, not
        // stored", but in freestanding every consumer of a String (Console, the collections) is already
        // gated, so there is no consumed form left to permit.
        if (freestanding_ && std::string(is->loc.file) != "<prelude>") {
            error("string interpolation is not available in freestanding mode (spec 36.3): `$\"...\"` "
                  "builds a managed String, which needs snprintf and the String runtime. Format into a "
                  "byte buffer yourself, or emit the pieces one at a time",
                  is->loc);
        }
        for (const auto& e : is->exprs) {
            const std::string t = typeOf(*e);
            const bool printable = t.empty() || isIntName(t) || isFloatType(t) || t == "char" ||
                                   t == "boolean" || t == "String" || t == "string" ||
                                   t == "Decimal" || enums_.count(t) > 0 || catalogs_.count(t) > 0;
            if (!printable) {
                error("string interpolation can only print numeric, char, boolean, String, Decimal or "
                      "enum values, got '" + t + "'",
                      e->loc);
            }
        }
        return "string";
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        // A CONSTRUCTOR THAT DELEGATES cannot be judged by the field-initialisation check below: a
        // `this.setUp()` or a `super(...)` assigns fields in a body this analysis does not follow, so
        // every field would be reported as unset. That is not a stricter check, it is a wrong one, and
        // it would reject a pattern the standard library itself uses.
        //
        // IT USED TO DISCHARGE EVERY PENDING FIELD, and that was too much in two ways.
        //
        // It was decided BY A PREFIX: only a `MemberExpr` whose object is `this` counted, so
        // `this.setUp()` discharged and a bare `setUp()` did not. Since `this.` became optional
        // (spec 8.2) that meant whether the check ran at all depended on how somebody typed the call.
        //
        // And it hid real defects -- a field read before any write, in a class whose constructor
        // happened to call a helper. Both showed up the moment a `this.` came off an unrelated call.
        //
        // So: find the callee in this class and discharge only the fields it ACTUALLY assigns,
        // following private helpers transitively with a visited set. When the callee cannot be found
        // -- `super(...)`, an inherited or external method -- fall back to discharging everything,
        // which is the old behaviour and the only safe answer when the body is not in reach.
        if (inConstructor_ && !pendingCtorFields_.empty()) {
            bool delegates = dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr;
            std::string calleeName;
            if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(cm->object.get());
                    oid != nullptr && oid->name == "this") {
                    delegates = true;
                    calleeName = cm->member;
                }
            } else if (const auto* cid =
                           dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
                // A BARE call to a method of this class is the same delegation written without the
                // prefix, and must be treated the same or the check depends on spelling.
                if (methodBodyInCurrentClass(cid->name) != nullptr) {
                    delegates = true;
                    calleeName = cid->name;
                }
            }
            if (delegates) {
                const ast::Block* body =
                    calleeName.empty() ? nullptr : methodBodyInCurrentClass(calleeName);
                if (body == nullptr) {
                    for (const auto& [fname, floc] : pendingCtorFields_) {
                        markInitialized("this." + fname);
                    }
                } else {
                    std::set<std::string> assigned;
                    std::set<std::string> visited{calleeName};
                    collectFieldsAssigned(body, assigned, visited);
                    for (const auto& [fname, floc] : pendingCtorFields_) {
                        if (assigned.count(fname) > 0) {
                            markInitialized("this." + fname);
                        }
                    }
                }
            }
        }
        // `itself(...)` inside a lambda: the lambda calling itself. Handled before every other call
        // shape because there `itself` resolves to no class, no local and no method -- the enclosing
        // lambda has no name of its own to look up. Everywhere else the pronoun has already been
        // resolved to the entity being declared, so reaching here means there was no such entity.
        if (const auto* iid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get());
            iid != nullptr && iid->name == "itself") {
            if (!analyzingLambda_) {
                error("'itself' names the entity being declared, and there is none to name here. "
                      "Inside a lambda body it is the lambda, which is how an anonymous function "
                      "recurses; in a declaration or an assignment it is what is being declared or "
                      "assigned to. In a method, call the method by its name",
                      call->loc);
                return "";
            }
            // Arity first: checkCallArgs only type-checks the arguments that line up with a parameter,
            // so a wrong COUNT would slip through it and reach codegen, which builds the call from the
            // function's own arity and would silently drop or invent an argument.
            if (call->args.size() != currentLambdaParams_.size()) {
                error("this lambda takes " + std::to_string(currentLambdaParams_.size()) +
                          " argument(s), but 'itself' is called here with " +
                          std::to_string(call->args.size()),
                      call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                return currentReturnType_;
            }
            checkCallArgs(call->args, currentLambdaParams_, "this lambda (called through 'itself')");
            return currentReturnType_;   // set to the lambda's return type for the body's duration
        }
        // spec 32.8: `Dog.methods.replace("bark", <function value>)` -- a mutable dispatch table. The
        // replacement takes over the class's vtable slot, so every Dog (already alive or not yet born)
        // gets the new behaviour: genuine AOP, mocking without a framework, localized hot patching.
        if (const auto* rp = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            rp != nullptr && rp->member == "replace") {
            if (const std::string cls = dispatchTableClass(*rp->object); !cls.empty()) {
                return checkMethodPatch(cls, *call);
            }
        }
        // mat4.identity(): the identity-matrix factory.
        if (const auto* mc = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* mo = dynamic_cast<const ast::IdentifierExpr*>(mc->object.get());
                mo != nullptr && mo->name == "mat4" && mc->member == "identity" && call->args.empty()) {
                return "mat4";
            }
        }
        // SIMD vector construction: vec4(x,y,z,w) etc. -- N numeric args -> vecN.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (cid->name == "mat4") {  // mat4(m0..m15) construction
                if (call->args.size() != 16) {
                    error("mat4 takes 16 components", call->loc);
                }
                for (const auto& arg : call->args) {
                    const std::string at = typeOf(*arg);
                    if (!at.empty() && !isNumeric(at)) {
                        error("mat4 components must be numeric, got '" + at + "'", arg->loc);
                    }
                }
                return "mat4";
            }
            if (int w = vecWidth(cid->name); w > 0) {
                if (static_cast<int>(call->args.size()) != w) {
                    error(cid->name + " takes " + std::to_string(w) + " components", call->loc);
                }
                for (const auto& arg : call->args) {
                    const std::string at = typeOf(*arg);
                    if (!at.empty() && !isNumeric(at)) {
                        error(cid->name + " components must be numeric, got '" + at + "'", arg->loc);
                    }
                }
                return cid->name;
            }
        }
        // Calling a funcptr<Ret, Params...> value (a bare C function pointer) -> Ret.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (const LocalVar* fv = lookupLocal(cid->name);
                fv != nullptr && fv->type.rfind("funcptr<", 0) == 0) {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                const std::string inner = ast::funcptrBody(fv->type.substr(8, fv->type.size() - 9));  // [unknown-abi]
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    } else if (inner[i] == ',' && depth == 0) {
                        return inner.substr(0, i);
                    }
                }
                return inner;
            }
        }
        // Calling a function value: callee is a local of type function<Ret, Params...> -> Ret.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (const LocalVar* fv = lookupLocal(cid->name);
                fv != nullptr && fv->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                const std::string inner = fv->type.substr(9, fv->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    } else if (inner[i] == ',' && depth == 0) {
                        return inner.substr(0, i);  // the Ret
                    }
                }
                return inner;  // no params -> the whole inner is the return type
            }
        }
        // super(args): explicitly call the base constructor to pass arguments.
        if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
            if (!inConstructor_) {
                error("'super(...)' is only valid inside a constructor", call->loc);
            } else {
                const ClassInfo* ci = lookupClass(currentClass_);
                if (ci == nullptr || ci->superclass.empty()) {
                    error("'super(...)' requires a superclass, but '" + currentClass_ +
                              "' has none",
                          call->loc);
                }
            }
            for (const auto& arg : call->args) {
                typeOf(*arg);
            }
            return "void";
        }
        const std::string name = flattenCallee(*call->callee);
        // The test framework, reached as a static call (`Test.assertEqual(...)`), which never goes
        // through checkTypeAccessible -- so gating the TYPE was not enough to stop it. It reports
        // through printf and builds Strings; a freestanding program that used it compiled clean and
        // failed at link. Same rule as Console: user code only, since the prelude names it freely.
        if (freestanding_ && std::string(call->loc.file) != "<prelude>" &&
            (name.rfind("Test.", 0) == 0 || name.rfind("System.Test.Test.", 0) == 0)) {
            error("the test framework is not available in freestanding mode (spec 36.3): 'Test' reports "
                  "through printf and builds Strings, neither of which exists bare metal. Test a "
                  "freestanding program from outside -- boot it and assert on what it emits",
                  call->loc);
        }
        // embed("path") (spec 36): the file's bytes, materialized into the image at compile time.
        if (name == "embed" && call->args.size() == 1) {
            if (dynamic_cast<const ast::StringLiteralExpr*>(call->args[0].get()) == nullptr) {
                error("embed(...) needs a literal path known at compile time", call->loc);
            }
            return "byte[]";
        }
        if (name == "checked" && call->args.size() == 1) {  // checked(expr): overflow-trapping, same type
            return typeOf(*call->args[0]);
        }
        // `T.sizeof()` (spec issue #7): the type answers about itself. The companion spelling,
        // `Memory.sizeof(x)`, lives with the rest of the Memory API below and is the only one that
        // takes an expression.
        if (const auto* sm = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            sm != nullptr && sm->member == "sizeof" && call->args.empty() &&
            lookupClass(baseType(flattenCallee(*sm->object))) != nullptr) {
            return "int";
        }
        // Namespace-level literal suffix function called by name: kilobytes(64).
        if (auto lit = literals_.find(name); lit != literals_.end() && !lit->second.empty()) {
            // The bare call form `name(arg)` is gone (spec 17.10): a suffix is used as the `N name`
            // sugar (which needs the suffix imported) or qualified by its owner as `Type.name(N)`.
            if (!call->fromSuffix) {
                error("call a literal suffix as 'N " + name + "' (imported) or '<Type>." + name +
                          "(N)'; the bare '" + name + "(N)' form is not allowed",
                      call->loc);
            } else if (importedSuffixes_.count(name) == 0) {
                error("literal suffix '" + name +
                          "' is not in scope; import it to use the 'N " + name + "' form",
                      call->loc);
            }
            const std::vector<LiteralInfo>& ovs = lit->second;
            if (call->args.size() != 1) {
                error("literal suffix '" + name + "' takes exactly one argument", call->loc);
                return ovs[0].returnType;
            }
            // A literal suffix may only be applied to a compile-time constant (spec 17.10): this is
            // what keeps `comptime literal` from becoming a runtime free function. Both `N suffix`
            // and the explicit `name(arg)` form require a literal/const argument.
            if (!isCompileTimeConstant(*call->args[0])) {
                error("literal suffix '" + name +
                          "' applies only to a compile-time constant; calling it with a runtime "
                          "value is not allowed (a literal suffix is not a free function)",
                      call->loc);
            }
            // Overload resolution by the literal's type (spec 17.10 rule 6): an exact parameter-type
            // match wins; otherwise the first overload is used and the argument is coerced.
            const std::string at = typeOf(*call->args[0]);
            const LiteralInfo* chosen = &ovs[0];
            for (const LiteralInfo& ov : ovs) {
                if (ov.paramType == at) { chosen = &ov; break; }
            }
            return chosen->returnType;
        }
        // Low-level thread builtins used by the System.Concurrency.Thread prelude class.
        if (name == "System.Concurrency.__threadStart") {
            if (call->args.size() != 1) {
                error("__threadStart takes one function<void>", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "long";  // the OS thread handle
        }
        // Low-level Mutex lock builtins (used by the System.Concurrency.Mutex prelude class).
        if (name == "System.Concurrency.__lockCreate") {
            if (!call->args.empty()) {
                error("__lockCreate takes no arguments", call->loc);
            }
            return "long";  // an opaque lock handle
        }
        if (name == "System.Concurrency.__chanNew") {  // used by the Channel prelude class
            if (call->args.size() != 1) {
                error("__chanNew takes one capacity", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "long";  // an opaque channel handle
        }
        if (name == "System.Concurrency.__lockAcquire" ||
            name == "System.Concurrency.__lockRelease") {
            if (call->args.size() != 1) {
                error("lock op takes one handle", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "void";
        }
        if (name == "System.Concurrency.__threadJoin") {
            if (call->args.size() != 1) {
                error("__threadJoin takes one handle", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "void";
        }
        if (name == "System.Concurrency.__threadYield") {
            if (!call->args.empty()) {
                error("__threadYield takes nothing", call->loc);
            }
            return "void";
        }
        if (name == "System.OS.__machineThreads") {
            if (!call->args.empty()) {
                error("__machineThreads takes nothing", call->loc);
            }
            return "int";
        }
        // Console I/O (spec 4): System.IO.Console.{printf,println,print,readInt}. The pre-F10
        // names (System.IO.printf/println/readInt, bare Console.*) are kept as aliases until the
        // samples are migrated. Requires `import System.IO.Console;`.
        {
            const bool isRead = name == "System.IO.Console.read";
            const bool isPrintf = name == "System.IO.Console.printf";
            const bool isPrintln = name == "System.IO.Console.println";
            const bool isPrint = name == "System.IO.Console.print";
            if (isRead || isPrintf || isPrintln || isPrint) {
                // The prelude's own library classes (e.g. Logger) may reference Console; their mere
                // presence must not break a freestanding program that never uses them (unused prelude code
                // is dead-stripped). Only flag Console used directly in user code.
                if (freestanding_ && std::string(call->loc.file) != "<prelude>") {
                    error("Console (managed stdlib) is not available in freestanding mode; use FFI "
                          "for I/O (spec 36.3)",
                          call->loc);
                }
                checkTypeAccessible("Console", call->loc);  // require the import
                if (isRead) {
                    if (!call->args.empty()) {
                        error("Console.read takes no arguments", call->loc);
                    }
                    return "String";  // read() returns a line; parse it (e.g. toInt) for other types
                }
                if (isPrintf && call->args.empty()) {
                    error("printf requires a format string", call->loc);
                }
                // The first argument must be a string literal/interpolation (a format), or -- for
                // println/print -- a String value. printf requires the format form specifically.
                if (!call->args.empty()) {
                    const ast::Expr* f = call->args.front().get();
                    const bool fmt = dynamic_cast<const ast::StringLiteralExpr*>(f) != nullptr ||
                                     dynamic_cast<const ast::InterpStringExpr*>(f) != nullptr;
                    if (!fmt) {
                        const std::string at = typeOf(*f);
                        if (isPrintf) {
                            error("the first argument to printf must be a string literal or "
                                  "interpolated string", f->loc);
                        } else if (!at.empty() && at != "String" && at != "string") {
                            error("println/print expects a string literal, interpolation, or "
                                  "String value, got '" + at + "'", f->loc);
                        }
                    }
                }
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                return "void";
            }
        }
        // External C function (spec 26): a bare call `name(args)` to an `extern` declaration.
        if (auto ext = externReturns_.find(name); ext != externReturns_.end()) {
            for (const auto& arg : call->args) {
                typeOf(*arg);
            }
            return ext->second;
        }
        // Math (spec 34.6): static functions on double, lowered to LLVM intrinsics.
        if (name.rfind("Math.", 0) == 0) {
            const std::string fn = name.substr(5);
            const bool unary = fn == "sqrt" || fn == "abs" || fn == "floor" || fn == "ceil" ||
                               fn == "round" || fn == "trunc" || fn == "sin" || fn == "cos" ||
                               fn == "exp" || fn == "log" || fn == "tan" || fn == "asin" ||
                               fn == "acos" || fn == "atan" || fn == "sinh" || fn == "cosh" ||
                               fn == "tanh" || fn == "cbrt" || fn == "log2" || fn == "log10";
            const bool binary = fn == "pow" || fn == "min" || fn == "max" || fn == "atan2" ||
                                fn == "hypot";
            const bool ternary = fn == "clamp" || fn == "lerp";
            if (unary || binary || ternary) {
                checkTypeAccessible("Math", call->loc);  // require `import System.Math.Math;`
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                const std::size_t want = unary ? 1u : (binary ? 2u : 3u);
                if (call->args.size() != want) {
                    error("Math." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                }
                return "double";
            }
        }
        // Memory API (spec 17.8): a NAMESPACE of stdlib classes -- System.Memory.Allocator (alloc/
        // free/copy) and System.Memory.Raw (read/write/readString/writeString/addressOf/sizeof).
        // Reached fully qualified (always allowed) or, after `import System.Memory.Allocator;` /
        // `import System.Memory.Raw;`, by the short Allocator.X / Raw.X. The short form requires the
        // import, enforced through checkTypeAccessible exactly like System.Math.Math (System.* code
        // stays exempt, and so does freestanding, whose systems core this is).
        std::string memName = name;
        if (memName.rfind("System.Memory.", 0) == 0) {
            memName = memName.substr(14);   // -> "Allocator.alloc" / "Raw.read"
        } else if ((memName.rfind("Allocator.", 0) == 0 || memName.rfind("Raw.", 0) == 0) &&
                   !freestanding_) {
            checkTypeAccessible(memName.substr(0, memName.find('.')), call->loc);
        }
        // `Raw.sizeof(T)` (spec issue #7): the byte size of a type, or of an expression's type. A size
        // is a question about how a value is laid out in memory, so it is asked of the class that
        // reads and writes memory rather than by a bare word the language would have to reserve.
        // Folded to a constant in the code generator, which is what lets a `static_assert` hold a
        // struct to a byte budget.
        //
        // The argument may NAME A TYPE, which has no value to type-check -- but when it names no type
        // it is a VALUE, and a value must be checked like one. Skipping both is how a size of a
        // nonexistent name used to compile to a guessed 4 instead of saying the name means nothing.
        // The test is deliberately permissive: the code generator holds the real layout and decides,
        // so anything arguable passes here and only a bare name matching nothing is checked as a value.
        if (memName == "Raw.sizeof") {
            if (call->args.size() != 1) {
                error("Raw.sizeof takes one type or expression", call->loc);
                return "int";
            }
            const std::string spelled = comptime::typeNameSpelled(*call->args[0]);
            const std::string bare = baseType(spelled);
            const bool looksLikeAType =
                !spelled.empty() &&
                (spelled.find('<') != std::string::npos || spelled.find('.') != std::string::npos ||
                 isNumeric(bare) || bare == "boolean" || bare == "char" || bare == "void" ||
                 bare == "String" || bare == "string" || bare == "Object" || bare == "Decimal" ||
                 bare == "vec2" || bare == "vec3" || bare == "vec4" || bare == "mat4" ||
                 enums_.count(bare) > 0 || catalogs_.count(bare) > 0 || newtypes_.count(bare) > 0 ||
                 classes_.count(bare) > 0 || lookupClass(bare) != nullptr);
            if (!looksLikeAType) {
                typeOf(*call->args[0]);
            }
            return "int";
        }
        if (memName == "Allocator.alloc") {
            if (call->args.size() != 1) {
                error("Allocator.alloc takes a byte count", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "address";
        }
        if (memName == "Allocator.free") {
            if (call->args.size() != 1) {
                error("Allocator.free takes an address", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "void";
        }
        if (memName == "Raw.getMemory") {
            if (call->args.size() != 1) {
                error("Raw.getMemory takes one argument", call->loc);
            } else {
                typeOf(*call->args.front());
            }
            return "address";
        }
        if (memName == "Raw.read") {
            if (call->typeArgs.size() != 1) {
                error("Raw.read<T> needs a type argument", call->loc);
            } else {
                checkBitCounted(call->typeArgs[0], call->loc);  // int8/int16/... are freestanding-only
            }
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return call->typeArgs.empty() ? "" : call->typeArgs[0];
        }
        if (memName == "Raw.write") {
            if (!call->typeArgs.empty()) {
                checkBitCounted(call->typeArgs[0], call->loc);  // bit-counted: freestanding-only
            }
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return "void";
        }
        // Raw.writeString(address, String): bulk-copy a String's bytes to a raw buffer (StringBuilder).
        if (memName == "Raw.writeString") {
            if (call->args.size() != 2) {
                error("Raw.writeString takes (address, String)", call->loc);
            }
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return "void";
        }
        // Allocator.copy(dst, src, n): raw memcpy of n bytes between two addresses (StringBuilder growth).
        if (memName == "Allocator.copy") {
            if (call->args.size() != 3) {
                error("Allocator.copy takes (dst, src, n)", call->loc);
            }
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return "void";
        }
        if (name == "Bits.doubleToLong" || name == "Bits.longToDouble") {
            checkTypeAccessible("Bits", call->loc);
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return name == "Bits.doubleToLong" ? "long" : "double";
        }
        // Ipc (spec 2.8): cross-program transport builtins. The program NAME is the address.
        if (name.rfind("Ipc.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "listen" || fn == "accept" || fn == "connect" || fn == "send" || fn == "recv" ||
                fn == "close") {
                checkTypeAccessible("Ipc", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                if (fn == "recv") {
                    return "String";  // (conn) -> one whole frame ("" when the peer left)
                }
                if (fn == "close") {
                    return "void";  // (handle)
                }
                return "long";  // listen(name)/accept(srv)/connect(name) -> handle (-1); send -> bytes
            }
        }
        // Net (spec 34): TCP client builtins. Require `import System.Net.Net;` (used by Socket).
        if (name.rfind("Net.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "connect" || fn == "send" || fn == "recv" || fn == "close" ||
                fn == "listen" || fn == "accept" ||
                fn == "udpOpen" || fn == "udpSend" || fn == "udpRecv" ||
                fn == "udpPeerHost" || fn == "udpPeerPort" || fn == "udpClose") {
                checkTypeAccessible("Net", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                if (fn == "connect") {
                    return "long";  // (host, port) -> socket handle (or -1)
                }
                if (fn == "send") {
                    return "long";  // (sock, data) -> bytes sent
                }
                if (fn == "recv") {
                    return "String";  // (sock, max) -> received bytes
                }
                if (fn == "listen") {
                    return "long";  // (port) -> listening socket (or -1)
                }
                if (fn == "accept") {
                    return "long";  // (server) -> connection socket (or -1)
                }
                if (fn == "udpOpen") {
                    return "long";  // (port) -> UDP socket (port 0 = ephemeral)
                }
                if (fn == "udpSend") {
                    return "long";  // (sock, host, port, data) -> bytes sent
                }
                if (fn == "udpRecv") {
                    return "String";  // (sock, max) -> datagram payload
                }
                if (fn == "udpPeerHost") {
                    return "String";  // () -> last datagram's sender IP
                }
                if (fn == "udpPeerPort") {
                    return "int";  // () -> last datagram's sender port
                }
                return "void";                          // close(sock) / udpClose(sock)
            }
        }
        // Process (spec 34): Process.run(cmd) runs a shell command, returning a ProcessResult with its
        // captured stdout and exit code. Require `import System.OS.Process;`.
        if (name.rfind("Process.", 0) == 0) {
            const std::string fn = name.substr(8);
            if (fn == "run") {
                checkTypeAccessible("Process", call->loc);
                if (call->args.size() != 1) {
                    error("Process.run takes a command string", call->loc);
                } else {
                    typeOf(*call->args[0]);
                }
                return "ProcessResult";
            }
        }
        // Env (spec 34): environment variables. Env.get(name) -> String (empty if unset); Env.set(name,
        // value) -> boolean. Require `import System.OS.Env;`.
        if (name.rfind("Env.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "get" || fn == "set") {
                checkTypeAccessible("Env", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                const std::size_t want = (fn == "set") ? 2u : 1u;
                if (call->args.size() != want) {
                    error("Env." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                }
                return fn == "get" ? "String" : "boolean";
            }
            // executablePath() -> the running program's own full path (spec 34). Lets a program
            // resolve files relative to its executable rather than the current directory.
            if (fn == "executablePath") {
                checkTypeAccessible("Env", call->loc);
                if (!call->args.empty()) {
                    error("Env.executablePath takes no arguments", call->loc);
                }
                return "String";
            }
        }
        // Persistent subprocess (debugger/LSP): low-level builtins behind the System.OS.Subprocess class.
        // spawn(cmd) -> handle (0 = failed); writeStr(h, data) -> bytes written; readChunk(h) -> available
        // bytes ("" on EOF); isAlive(h)/closeStdin(h)/kill(h). Internal; the Subprocess class is the API.
        if (name.rfind("Subproc.", 0) == 0) {
            const std::string fn = name.substr(8);
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            // spawnCombined: same, but the child's stderr shares its stdout pipe (a compiler's diagnostics).
            // spawnVisible: the child gets its own console window instead of being windowless.
            if (fn == "spawn" || fn == "spawnCombined" || fn == "spawnVisible") {
                return "long";
            }
            if (fn == "writeStr") {
                return "int";
            }
            if (fn == "readChunk") {
                return "String";
            }
            if (fn == "isAlive" || fn == "canRead") {
                return "boolean";
            }
            if (fn == "closeStdin" || fn == "kill") {
                return "void";
            }
        }
        // Pseudo-console (the Pty terminal): spawn(cmd,cols,rows) -> handle; writeStr(h,data) -> bytes;
        // readChunk(h) -> output; isAlive/canRead(h) -> boolean; resize(h,cols,rows)/close(h) -> void.
        if (name.rfind("Conpty.", 0) == 0) {
            const std::string fn = name.substr(7);
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            if (fn == "spawn") {
                return "long";
            }
            if (fn == "writeStr") {
                return "int";
            }
            if (fn == "readChunk") {
                return "String";
            }
            if (fn == "isAlive" || fn == "canRead") {
                return "boolean";
            }
            if (fn == "resize" || fn == "close") {
                return "void";
            }
        }
        // File I/O (spec 34.4): static methods lowering to runtime stdio. Require `import System.IO.File;`.
        if (name.rfind("File.", 0) == 0) {
            const std::string fn = name.substr(5);
            if (fn == "readAll" || fn == "writeAll" || fn == "appendAll" || fn == "exists" ||
                fn == "remove") {
                checkTypeAccessible("File", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                const std::size_t want = (fn == "writeAll" || fn == "appendAll") ? 2u : 1u;
                if (call->args.size() != want) {
                    error("File." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                }
                return fn == "readAll" ? "String" : "boolean";
            }
            // OPEN FILES (spec 34.4). Everything else here reads or writes a WHOLE file, which was the
            // only shape the language had: the first line of a log cost the whole log. The handle is an
            // opaque `long` -- the runtime's FILE* as an integer -- for the same reason the subprocess
            // handle is one: an integer that is only ever handed back cannot be dereferenced by
            // accident, and the language has no type for a foreign pointer it should be keeping.
            if (fn == "open" || fn == "readInto" || fn == "writeFrom" || fn == "seek" ||
                fn == "tell" || fn == "flush" || fn == "close" || fn == "atEnd") {
                checkTypeAccessible("File", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                std::size_t want = 1u;
                if (fn == "open" || fn == "readInto" || fn == "writeFrom") { want = 3u; }
                if (fn == "seek") { want = 3u; }
                if (fn == "open") { want = 2u; }
                if (call->args.size() != want) {
                    error("File." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                }
                if (fn == "open" || fn == "readInto" || fn == "writeFrom" || fn == "tell") {
                    return "long";   // the handle; bytes moved; the position
                }
                return "boolean";    // seek / flush / close / atEnd
            }
            // Directory / filesystem metadata (spec 34.4): list, mkdir, rmdir, rename, size, isDir,
            // mtime.
            if (fn == "list" || fn == "mkdir" || fn == "rmdir" || fn == "rename" || fn == "size" ||
                fn == "isDir" || fn == "mtime") {
                checkTypeAccessible("File", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                const std::size_t want = (fn == "rename") ? 2u : 1u;
                if (call->args.size() != want) {
                    error("File." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                }
                if (fn == "list") {
                    return "String";  // newline-separated entries
                }
                if (fn == "size" || fn == "mtime") {
                    return "long";  // byte count / epoch seconds (-1 if missing)
                }
                return "boolean";                          // mkdir / rmdir / rename / isDir
            }
        }
        // Time (spec 34): clock + sleep builtins. Require `import System.Time.Time;`.
        if (name.rfind("Time.", 0) == 0) {
            const std::string fn = name.substr(5);
            if (fn == "millis" || fn == "nanos" || fn == "unixMillis" || fn == "sleep") {
                checkTypeAccessible("Time", call->loc);
                for (const auto& a : call->args) {
                    typeOf(*a);
                }
                if (fn == "sleep") {
                    if (call->args.size() != 1) {
                        error("Time.sleep takes a millisecond count", call->loc);
                    }
                    return "void";
                }
                if (!call->args.empty()) {
                    error("Time." + fn + " takes no arguments", call->loc);
                }
                return "long";
            }
        }
        // Memory.readString(address, len): build a String from a raw byte buffer (StringBuilder).
        if (memName == "Raw.readString") {
            if (call->args.size() != 2) {
                error("Raw.readString takes (address, length)", call->loc);
            }
            for (const auto& a : call->args) {
                typeOf(*a);
            }
            return "String";
        }
        // Channel.select() (spec 20.4): starts a fluent select builder over multiple channels.
        if (name == "Channel.select") {
            if (!call->args.empty()) {
                error("Channel.select takes no arguments", call->loc);
            }
            return "Select";
        }
        // reflect.typeOf<T>() (spec 31): the Type token for class T. It is the only entry to
        // reflection, so requiring its import here gates the whole reflect.* surface.
        if (name == "reflect.typeOf") {
            if (currentImports_.count("reflect") == 0) {
                error("reflection requires 'import reflect;'", call->loc);
            }
            // REFLECTION WORKS BARE METAL, measured: `reflect.typeOf<T>()` and the Type/Method
            // tokens it hands back need `__polaron_malloc` and `memcpy` beyond an empty program, and
            // nothing else -- no libc, no unwinder. The allocator is the kernel's own through the
            // `heap class` bridge, and every kernel has memcpy.
            //
            // The gate was inherited from spec 36.3's list rather than from a measurement, and the
            // list was written when reflection was assumed to need a managed runtime. `Method
            // .firstByte()` is in fact how `unimport` is TESTED -- reading back the int3 -- which is
            // exactly a bare-metal question.
            if (call->typeArgs.size() != 1) {
                error("reflect.typeOf expects one type argument, e.g. reflect.typeOf<Dog>()",
                      call->loc);
                return "Type";
            }
            const std::string t = ast::mangleGeneric(call->typeArgs[0], {});
            // REFLECTION INSIDE A GENERIC is what makes an automatic serializer possible: the body
            // is written once over `T` and the instantiation supplies the class. On the template
            // pass `T` is a type parameter and not a class, and saying so would refuse the very
            // shape reflection exists to serve -- so the check waits for the copy where T is real,
            // which every instantiation gets. See currentTypeParams_.
            if (currentTypeParams_.count(t) == 0 && lookupClass(t) == nullptr) {
                error("reflect.typeOf<T>: '" + t + "' is not a class", call->loc);
            }
            return "Type";
        }
        // Fully-qualified static call to a stdlib/user class: `bundle.namespace...Class.staticMethod(...)`.
        // Only the `Console`/`File` builtins are recognized by their full path; other classes must be
        // called by the short name `Class.method` after importing (BUG3). Rather than the misleading
        // "use of undeclared variable 'System'", point the user at the short form. Fires only when the
        // receiver is a dotted path whose head is NOT a local and whose last segment is a known class
        // with a static method by this name.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            mem != nullptr && dynamic_cast<const ast::MemberExpr*>(mem->object.get()) != nullptr) {
            const std::string flat = flattenCallee(*mem->object);
            const std::size_t dot = flat.rfind('.');
            if (dot != std::string::npos && !flat.empty()) {
                const std::string cls = flat.substr(dot + 1);
                const std::string head = flat.substr(0, flat.find('.'));
                if (head != "this" && lookupLocal(head) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(cls)) {
                        if (auto mit = sc->methods.find(mem->member);
                            mit != sc->methods.end() && mit->second.isStatic) {
                            error("call '" + cls + "." + mem->member + "' by its short name after "
                                  "importing it (e.g. `import " + flat + ";` then `" + cls + "." +
                                  mem->member + "(...)`); the fully-qualified path is only resolved for "
                                  "the Console/File builtins",
                                  call->loc);
                            for (const auto& arg : call->args) {
                                typeOf(*arg);
                            }
                            return mit->second.returnType;
                        }
                    }
                    // AND WHEN THE SHORT NAME IS AMBIGUOUS, the advice above is impossible to take.
                    // Two namespaces declaring `Widget` are renamed apart (`Alpha__Widget`), so
                    // `lookupClass("Widget")` finds nothing and the fall-through reported "use of
                    // undeclared variable 'Alpha'" -- which says the opposite of the truth: the name
                    // exists twice, not zero times, and no import can disambiguate it.
                    //
                    // What DOES work is the qualified name in a type position; only a static call
                    // through it does not, because `Alpha.Widget` in an expression is three AST
                    // nodes rather than one name and the qualifying substitution never matches it.
                    // Say exactly that, rather than sending the reader to an import that cannot help.
                    std::string qualifiedHead = flat.substr(0, dot);
                    for (char& ch : qualifiedHead) {
                        if (ch == '.') {
                            ch = '_';
                        }
                    }
                    if (classes_.count(qualifiedHead + "__" + cls) > 0) {
                        error("'" + cls + "' is declared in more than one namespace, so the short "
                              "name cannot be imported. '" + flat + "' names it in a TYPE position "
                              "(`" + flat + " v = new " + flat + "()`), but a static call through a "
                              "qualified path is not resolved yet -- reach '" + mem->member +
                              "' through an instance, or give one of the two types a distinct name",
                              call->loc);
                        return "";
                    }
                }
            }
        }
        // Otherwise the callee should be a method: obj.method(...) or, when the
        // receiver names a class, a static call ClassName.method(...).
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(objId->name)) {
                        // spec 32.11: [BeforeAll]/[AfterAll] bracket the tests of the class that
                        // DECLARES them and nothing else, so a test reaching into another class's
                        // fixture reads state that class may already have torn down. The failure is a
                        // read of freed memory in a suite whose output showed nothing but passes.
                        if (inTestMethod_ && objId->name != enclosingClass_ &&
                            fixtureOwners_.count(objId->name) > 0) {
                            const std::string key = enclosingClass_ + "." + mem->member + "|" + objId->name;
                            if (fixtureWarned_.insert(key).second) {
                                warn("this test reads '" + objId->name +
                                         "', which owns a [BeforeAll]/[AfterAll] fixture, from class '" +
                                         enclosingClass_ +
                                         "'. Those hooks bracket only their own class's tests, so '" +
                                         objId->name +
                                         "' may already have torn the fixture down by the time this "
                                         "runs. Move the test into '" +
                                         objId->name + "', or give this class its own fixture",
                                     call->loc);
                            }
                        }
                        // Qualified literal suffix: Type.kib(64) (spec 17.10). A literal suffix is not
                        // in the method table, so resolve it before the method lookup.
                        if (auto lit = literals_.find(mem->member); lit != literals_.end()) {
                            const LiteralInfo* chosen = nullptr;
                            const std::string at = call->args.size() == 1 ? typeOf(*call->args[0]) : "";
                            for (const LiteralInfo& ov : lit->second) {
                                if (ov.ownerClass == objId->name) {
                                    if (chosen == nullptr || ov.paramType == at) {
                                        chosen = &ov;
                                    }
                                    if (ov.paramType == at) {
                                        break;
                                    }
                                }
                            }
                            if (chosen != nullptr) {
                                if (call->args.size() != 1) {
                                    error("literal suffix '" + mem->member +
                                              "' takes exactly one argument", call->loc);
                                } else if (!isCompileTimeConstant(*call->args[0])) {
                                    error("literal suffix '" + objId->name + "." + mem->member +
                                              "' applies only to a compile-time constant", call->loc);
                                }
                                return chosen->returnType;
                            }
                        }
                        auto mit = sc->methods.find(mem->member);
                        if (mit == sc->methods.end()) {
                            // A java-style enum desugars to a class of the same name; its auto-generated
                            // built-ins (values/count/random/parse, spec 12.5) are NOT class methods, so
                            // fall through to the enum built-in resolver below instead of erroring.
                            if (enums_.count(objId->name) > 0) {
                                goto enumBuiltin;
                            }
                            error("class '" + objId->name + "' has no method '" + mem->member + "'",
                                  call->loc);
                            return "";
                        }
                        checkMemberAccessible("static method", mem->member, mit->second.visibility,
                                              mit->second.owner, call->loc);
                        if (!mit->second.isStatic) {
                            error("method '" + mem->member + "' is not static; call it on an instance",
                                  call->loc);
                            return "";
                        }
                        // `Class.method(...)` -- the other edge into the call graph. A driver reaches
                        // most of what it reaches this way (`Serial.puts`, `Frames.alloc`), so
                        // leaving static calls out would let a handler allocate one hop away.
                        if (MethodFacts* mf = facts()) {
                            mf->callees.insert(objId->name + "." + mem->member);
                        }
                        if (mit->second.isVariadic) {
                            // A variadic extern (spec 26): the fixed params are checked, extra args are
                            // the `...` and pass through.
                            for (const auto& a : call->args) {
                                typeOf(*a);
                            }
                        } else {
                            if (mit->second.isDeprecated) {
                                warn("'" + mem->member + "' is deprecated (spec 14.2)", call->loc);
                            }
                            bindNamedArgs(const_cast<ast::CallExpr*>(call), mit->second.paramNames,
                                          mit->second.namedOnlyParams, "method '" + mem->member + "'");
                            checkCallArgs(call->args, mit->second.paramTypes, "'" + mem->member + "'", &mit->second.moveParams);
                            checkComptimeArgs(call->args, mit->second.comptimeParams,
                                              "'" + mem->member + "'");
                            if (call->args.size() != mit->second.paramCount) {
                                error("method '" + mem->member + "' expects " +
                                          std::to_string(mit->second.paramCount) + " argument(s) but got " +
                                          std::to_string(call->args.size()),
                                      call->loc);
                            }
                        }
                        // An async static method yields a Task<returnType> (spec 20.2).
                        if (mit->second.isAsync) {
                            return ast::mangleGeneric("Task", {mit->second.returnType});
                        }
                        return mit->second.returnType;
                    }
                }
            }
        enumBuiltin:;
            // Enum built-ins: EnumName.count() / EnumName.values() (spec 12.5). Reached directly, or via
            // fall-through from the class branch for a java-style enum (desugared to a same-named class).
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (lookupLocal(oid->name) == nullptr && enums_.count(oid->name) > 0) {
                    if (mem->member == "count" && call->args.empty()) {
                        return "int";
                    }
                    if (mem->member == "values" && call->args.empty()) {
                        return oid->name + "[]";
                    }
                    if (mem->member == "random" && call->args.empty()) {
                        return oid->name;
                    }
                    if (mem->member == "parse" && call->args.size() == 1) {  // -> Option<Enum>
                        typeOf(*call->args[0]);
                        return "Option$" + oid->name;
                    }
                    // A STATIC method the enum declares itself. Spec 12.2 gives enums methods and
                    // nothing restricts them to instance methods; codegen has always emitted these
                    // correctly (a static one simply gets no `this` parameter), but resolution never
                    // looked past the built-ins -- so declaring one compiled and CALLING it did not.
                    // That is the worst shape a gap can have: a declaration the language accepts and
                    // then gives you no way to reach.
                    //
                    // It bites hardest where an enum meets hardware. A register field arrives as an
                    // integer and something has to turn it into a value; that is a factory, and a
                    // factory is static by nature.
                    if (auto emit = enumMethods_.find(oid->name); emit != enumMethods_.end()) {
                        auto mit = emit->second.find(mem->member);
                        if (mit != emit->second.end() && mit->second.isStatic) {
                            for (const auto& arg : call->args) {
                                typeOf(*arg);
                            }
                            const std::size_t want = enumMethodParams_[oid->name][mem->member];
                            if (call->args.size() != want) {
                                error("method '" + mem->member + "' expects " + std::to_string(want) +
                                          " argument(s) but got " + std::to_string(call->args.size()),
                                      call->loc);
                            }
                            return mit->second.returnType;
                        }
                        // Declared, but on an instance. Saying which beats "has no built-in", which
                        // sends the reader hunting for a spelling mistake that is not there.
                        if (mit != emit->second.end()) {
                            error("method '" + mem->member + "' on enum '" + oid->name +
                                      "' is an instance method -- call it on a value of the enum, "
                                      "not on the type itself",
                                  call->loc);
                            return mit->second.returnType;
                        }
                    }
                    error("enum '" + oid->name + "' has no built-in or static method '" +
                              mem->member + "'",
                          call->loc);
                    return "";
                }
            }
            std::string objType = typeOf(*mem->object);
            if (objType.empty()) {
                return "";
            }
            // Null safety (spec 3.7): `nullable` only constrains assignment -- a nullable value may
            // be dereferenced directly (no flow-check required); if it is null at runtime the deref
            // traps. So resolve the member against the underlying type.
            if (isNullableType(objType)) {
                objType = baseType(objType);
            }
            // Enum (catalog) instance method: m.pick() where m is an enum value.
            if (auto emit = enumMethods_.find(baseType(objType)); emit != enumMethods_.end()) {
                auto mit = emit->second.find(mem->member);
                if (mit != emit->second.end()) {
                    for (const auto& arg : call->args) {
                        typeOf(*arg);
                    }
                    const std::size_t want = enumMethodParams_[baseType(objType)][mem->member];
                    if (call->args.size() != want) {
                        error("method '" + mem->member + "' expects " + std::to_string(want) +
                                  " argument(s) but got " + std::to_string(call->args.size()),
                              call->loc);
                    }
                    return mit->second.returnType;
                }
            }
            // Enum value built-in (spec 12.5): `v.name()` -- the declared identifier as a String,
            // on ordinal and java-style enums alike. It is the fourth of the generated quartet
            // (values/count/random/parse read names in; name reads them back out). A `name`
            // method the enum declares itself wins: ordinal enums returned above, java-style
            // ones resolve through their twin class below, so only probe the builtin when no
            // user method exists.
            if (enums_.count(baseType(objType)) > 0 && mem->member == "name" &&
                call->args.empty()) {
                const bool userOwns =
                    javaEnums_.count(baseType(objType)) > 0 &&
                    findMethod(baseType(objType), "name") != nullptr;
                if (!userOwns) {
                    return "String";
                }
            }
            if (int vw = vecWidth(objType); vw > 0) {  // SIMD vector methods (GLSL-style)
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "dot" && call->args.size() == 1) {
                    return "float";
                }
                if (mem->member == "length" && call->args.empty()) {
                    return "float";  // magnitude
                }
                if (mem->member == "normalize" && call->args.empty()) {
                    return objType;  // vecN
                }
                if (mem->member == "cross" && call->args.size() == 1 && vw == 3) {
                    return "vec3";
                }
                error("vec" + std::to_string(vw) + " has dot/length/normalize" +
                          (vw == 3 ? std::string("/cross") : std::string("")) + "; '" +
                          mem->member + "' is not one",
                      call->loc);
                return "";
            }
            if (objType == "mat4") {  // SIMD matrix methods
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "multiply" && call->args.size() == 1) {
                    return "mat4";
                }
                if (mem->member == "transform" && call->args.size() == 1) {
                    return "vec4";
                }
                error("mat4 has multiply/transform; '" + mem->member + "' is not one", call->loc);
                return "";
            }
            if (isArrayType(objType)) {
                if (mem->member == "length" && call->args.empty()) {
                    return "int";  // read length
                }
                if (mem->member == "length" && call->args.size() == 1) {  // resize (spec 25)
                    const std::string st = typeOf(*call->args[0]);
                    if (!st.empty() && st != "int") {
                        error("array length must be an int", call->loc);
                    }
                    return "void";
                }
                error("arrays support .length() to read and .length(n) to resize; '" + mem->member +
                          "' is not a method",
                      call->loc);
                return "";
            }
            if (objType == "String" || objType == "string") {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "length" && call->args.empty()) {
                    return "int";
                }
                if (mem->member == "isEmpty" && call->args.empty()) {
                    return "boolean";
                }
                if (mem->member == "charAt" && call->args.size() == 1) {
                    return "char";
                }
                if (mem->member == "toInt" && call->args.empty()) {
                    return "int";  // parse (spec 4)
                }
                if (mem->member == "toDouble" && call->args.empty()) {
                    return "double";  // parse (spec 4)
                }
                if (mem->member == "equals" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "concat" && call->args.size() == 1) {
                    return "String";
                }
                // append mutates the receiver, so it is only on the mutable `string` (spec 4).
                if (mem->member == "append" && call->args.size() == 1) {
                    if (objType != "string") {
                        error("'append' mutates the string; it is not available on the immutable "
                              "String (use + to build a new String)",
                              mem->loc);
                    }
                    return "string";
                }
                if (mem->member == "substring" && call->args.size() == 2) {
                    return "String";
                }
                // Search / predicates (spec 34.5).
                if (mem->member == "indexOf" && call->args.size() == 1) {
                    return "int";
                }
                if (mem->member == "contains" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "startsWith" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "endsWith" && call->args.size() == 1) {
                    return "boolean";
                }
                // Transforms (spec 34.5): new owned Strings.
                if (mem->member == "toUpper" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "toLower" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "trim" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "repeat" && call->args.size() == 1) {
                    return "String";
                }
                if (mem->member == "toString" && call->args.empty()) {
                    return "String";  // identity
                }
                // String satisfies Hashable<String>/Comparable<String> (collections, spec 34).
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "compareTo" && call->args.size() == 1) {
                    return "int";
                }
                error("String has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Decimal" && mem->member == "toString" && call->args.empty()) {
                return "String";  // formats the i128 fixed-point value (codegen emitDecimalToString)
            }
            // Floating-point types render themselves as text, the same way int does. Without this a
            // `record` with a float field cannot even be declared: its synthesized toString() calls
            // toString() on every field. (Only toString -- floats are deliberately NOT hashable or
            // comparable keys, since float equality is not an identity anyone should key a map on.)
            if (isFloatType(objType) && mem->member == "toString" && call->args.empty()) {
                return "String";
            }
            // And a boolean, for exactly the same reason and with exactly the same limit: a `record`
            // with a boolean field could not be DECLARED, because its synthesized toString() calls
            // toString() on every field and there was no such method -- so the error landed on the
            // record declaration, naming a call the author never wrote. "true"/"false", which is the
            // answer every language that has this gives. (toString only: a bare boolean is not a
            // useful map key, so it stays out of the Hashable/Comparable builtins.)
            if (objType == "boolean" && mem->member == "toString" && call->args.empty()) {
                return "String";
            }
            // Integer types satisfy Hashable<T>/Comparable<T> via builtins, so they can be used as
            // map/set keys without boxing (collections, spec 34).
            if (isIntName(objType)) {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                if (mem->member == "toString" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "compareTo" && call->args.size() == 1) {
                    return "int";
                }
                // Overflow-mode arithmetic (spec 3.6): wrapping/saturating/unchecked, same int type.
                static const std::set<std::string> kOverflowMethods = {
                    "wrappingAdd",   "wrappingSub",   "wrappingMul",   "wrappingDiv",
                    "saturatingAdd", "saturatingSub", "saturatingMul",
                    "uncheckedAdd",  "uncheckedSub",  "uncheckedMul",  "uncheckedDiv"};
                if (kOverflowMethods.count(mem->member) > 0 && call->args.size() == 1) {
                    return objType;
                }
                error("'" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Channel.select builder (spec 20.4): .receive(ch, lambda) / .timeout(ms, lambda) chain
            // fluently (each returns the builder) and .run() executes it.
            if (objType == "Select") {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "receive" && call->args.size() == 2) {
                    return "Select";
                }
                if (mem->member == "timeout" && call->args.size() == 2) {
                    return "Select";
                }
                if (mem->member == "run" && call->args.empty()) {
                    return "void";
                }
                error("Select has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Channel<T> blocking operations (spec 20.3).
            if (baseType(objType).rfind("Channel$", 0) == 0) {
                const std::string elem = baseType(objType).substr(8);
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "send" && call->args.size() == 1) {
                    return "void";
                }
                if (mem->member == "receive" && call->args.empty()) {
                    return elem;
                }
                error("Channel has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // atomic<T> lock-free operations (spec 20.6).
            if (baseType(objType).rfind("atomic$", 0) == 0) {
                const std::string elem = baseType(objType).substr(7);
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "get" && call->args.empty()) {
                    return elem;
                }
                if (mem->member == "set" && call->args.size() == 1) {
                    return "void";
                }
                if (mem->member == "add" && call->args.size() == 1) {
                    return elem;
                }
                if (mem->member == "increment" && call->args.empty()) {
                    return elem;
                }
                if (mem->member == "compareAndSet" && call->args.size() == 2) {
                    return "boolean";
                }
                error("atomic has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Type") {  // reflection (spec 31)
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "name" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "methodCount" && call->args.empty()) {
                    return "int";
                }
                if (mem->member == "fieldCount" && call->args.empty()) {
                    return "int";
                }
                if ((mem->member == "methodName" || mem->member == "fieldName") && call->args.size() == 1) {
                    return "String";
                }
                if (mem->member == "method" && call->args.size() == 1) {
                    return "Method";
                }
                if (mem->member == "instantiate") {
                    return "Object";  // construct an instance
                }
                if (mem->member == "methods" && call->args.empty()) {
                    return "ArrayList$Method";
                }
                if (mem->member == "fields" && call->args.empty()) {
                    return "ArrayList$Field";
                }
                if (mem->member == "annotations" && call->args.empty()) {
                    return "ArrayList$Annotation";
                }
                // Hashable by identity, like the other tokens: a program that wires objects together
                // keeps its types in a collection, and a type token is a global constant, so
                // identity is equality for it.
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";
                }
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                error("Type has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Method") {  // reflection (spec 31)
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "name" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "firstByte" && call->args.empty()) {
                    return "int";
                }
                if (mem->member == "invoke") {
                    return "Object";  // invoke(receiver [, args]) -> boxed result
                }
                if (mem->member == "annotations" && call->args.empty()) {
                    return "ArrayList$Annotation";  // the method's own applied annotations (spec 31)
                }
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";  // identity
                }
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                error("Method has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Field") {  // reflection (spec 31)
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "name" && call->args.empty()) {
                    return "String";
                }
                // WHAT THE FIELD IS DECLARED AS. `get` hands back an Object, and without this there
                // was no way to learn whether that Object is an int, a String or another object --
                // so nothing generic could be written over a type's shape, which is what reflection
                // is for. It is the one piece auto-serialization was missing.
                if (mem->member == "typeName" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "get" && call->args.size() == 1) {
                    return "Object";  // boxed value
                }
                // The annotations written ON the field, which is where a rule about a field goes.
                if (mem->member == "annotations" && call->args.empty()) {
                    return "ArrayList$Annotation";
                }
                if (mem->member == "set" && call->args.size() == 2) {
                    return "void";  // (obj, Object)
                }
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";  // identity
                }
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                error("Field has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Annotation") {  // reflection (spec 14.3, 31)
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (mem->member == "name" && call->args.empty()) {
                    return "String";
                }
                // WHAT THE ANNOTATION WAS GIVEN, as written: `min=1,max=10`. Without it an
                // annotation is a marker and nothing more -- `[Range(min: 1)]` and `[Range(min: 99)]`
                // read identically -- so no rule that carries a VALUE could be written declaratively.
                if (mem->member == "args" && call->args.empty()) {
                    return "String";
                }
                if (mem->member == "equalsKey" && call->args.size() == 1) {
                    return "boolean";  // identity
                }
                if (mem->member == "hash" && call->args.empty()) {
                    return "long";
                }
                error("Annotation has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // A field of funcptr<...> type (a bare C function pointer): obj.f(args) calls it -> Ret.
            if (const FieldInfo* fpf = findField(objType, mem->member);
                fpf != nullptr && fpf->type.rfind("funcptr<", 0) == 0) {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                const std::string inner = ast::funcptrBody(fpf->type.substr(8, fpf->type.size() - 9));  // [unknown-abi]
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    } else if (inner[i] == ',' && depth == 0) {
                        return inner.substr(0, i);
                    }
                }
                return inner;
            }
            // A field of function<...> type is a function value: obj.f(args) calls it.
            if (const FieldInfo* fld = findField(objType, mem->member);
                fld != nullptr && fld->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                const std::string inner = fld->type.substr(9, fld->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    } else if (inner[i] == ',' && depth == 0) {
                        return inner.substr(0, i);
                    }
                }
                return inner;
            }
            // Calling a catalog method through a catalog-TYPED receiver (spec 12.4). A catalog value
            // carries a runtime type tag (enum id + ordinal), so dispatch works for any number of
            // implementers: every implementer must define the method and agree on its return type,
            // which becomes the call's type.
            if (catalogs_.count(baseType(objType)) > 0) {
                std::vector<std::string> impls = catalogImplementers(baseType(objType));
                for (const auto& arg : call->args) {
                    typeOf(*arg);
                }
                if (impls.empty()) {
                    error("cannot call method '" + mem->member + "' through catalog '" +
                              baseType(objType) + "': no enum implements it",
                          call->loc);
                    return "";
                }
                std::string retType;
                bool ok = true;
                for (const std::string& impl : impls) {
                    // An ordinal implementer keeps its methods on the enum; a java-style one was
                    // desugared, so its methods live on the twin class of the same name.
                    std::string rt;
                    auto emit = enumMethods_.find(impl);
                    if (emit != enumMethods_.end() &&
                        emit->second.find(mem->member) != emit->second.end()) {
                        rt = emit->second.at(mem->member).returnType;
                    } else if (const MethodInfo* cm = findMethod(impl, mem->member); cm != nullptr) {
                        rt = cm->returnType;
                    } else {
                        error("enum '" + impl + "' implementing catalog '" + baseType(objType) +
                                  "' has no method '" + mem->member + "'",
                              call->loc);
                        ok = false;
                        break;
                    }
                    if (retType.empty()) {
                        retType = rt;
                    } else if (rt != retType) {
                        error("implementers of catalog '" + baseType(objType) + "' disagree on the "
                                  "return type of '" + mem->member + "' (" + retType + " vs " + rt +
                                  "); they must match for catalog dispatch",
                              call->loc);
                        ok = false;
                        break;
                    }
                }
                return ok ? retType : std::string();
            }
            const MethodInfo* m = findMethod(objType, mem->member, /*objectFallback=*/true);
            if (m == nullptr) {
                error("class '" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            checkMemberAccessible("method", mem->member, m->visibility, m->owner, call->loc);
            if (m->isInterrupt) {
                error("an interrupt cannot be called -- it is ENTERED, by something outside the "
                      "program, at a moment the program did not choose. Calling it would be "
                      "simulating an interrupt, which is a different thing wearing the same name. "
                      "To install it, write `" + mem->member + "` without '()': that yields the "
                      "entry point bound to this object.",
                      call->loc);
                return "";
            }
            // One edge of the call graph the interrupt check walks, recorded where the analyzer has
            // just done the hard part: `objType` is the RESOLVED receiver type, so a field, a
            // local, a parameter and a static receiver all arrive here already answered.
            if (MethodFacts* mf = facts()) {
                mf->callees.insert(objType + "." + mem->member);
            }
            // Named arguments (spec 22.4): rewrite into parameter order before anything checks the args.
            if (m->isDeprecated) {
                warn("'" + mem->member + "' is deprecated (spec 14.2)", call->loc);
            }
            bindNamedArgs(const_cast<ast::CallExpr*>(call), m->paramNames, m->namedOnlyParams,
                          "method '" + mem->member + "'");
            checkCallArgs(call->args, m->paramTypes, "'" + mem->member + "'", &m->moveParams);
            // region-binder INTERPROCEDURAL escape check (§8): if the callee stores parameter i into its
            // receiver (per the escape summary) and we pass an activation-owned object there, it dangles
            // once this method returns -- unless the receiver is itself activation-local (same lifetime).
            if (regionBinder_) {
                // an argument aliases (rather than copies) only when its own type is a pointer/reference --
                // this reads the CONCRETE type, so a generic `add(T)` with T = Node* is caught.
                auto argAliases = [&](const ast::IdentifierExpr* aid) -> bool {
                    const LocalVar* lv = lookupLocal(aid->name);
                    return lv != nullptr && isRefType(lv->type);
                };
                auto sit = escapesToReceiver_.find(baseType(objType) + "." + mem->member);
                if (sit != escapesToReceiver_.end()) {
                    const auto* recvId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    const bool recvOutlives = recvId == nullptr || activationOwned_.count(recvId->name) == 0;
                    if (recvOutlives) {
                        for (std::size_t i = 0; i < call->args.size() && i < sit->second.size(); ++i) {
                            if (sit->second[i]) {
                                if (const auto* aid =
                                        dynamic_cast<const ast::IdentifierExpr*>(call->args[i].get());
                                    aid != nullptr && activationOwned_.count(aid->name) > 0 &&
                                    argAliases(aid)) {  // only a pointer/reference argument actually aliases
                                    error("region-binder: '" + mem->member + "' stores argument '" + aid->name +
                                              "' into a receiver that outlives this method, so the method-local "
                                              "object would dangle at return; pass ownership with 'move' (move " +
                                              aid->name + ")",
                                          call->args[i]->loc);
                                }
                            }
                        }
                    }
                }
                // escapes-into-parameter (§8): the callee stores argument i into argument j's field. If i is
                // activation-owned and j outlives it (j is not itself activation-local), i dangles inside j.
                auto pit = escapesToParam_.find(baseType(objType) + "." + mem->member);
                if (pit != escapesToParam_.end()) {
                    for (std::size_t i = 0; i < call->args.size() && i < pit->second.size(); ++i) {
                        if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(call->args[i].get());
                            aid != nullptr && activationOwned_.count(aid->name) > 0 && argAliases(aid)) {
                            for (int j : pit->second[i]) {
                                if (j < 0 || j >= static_cast<int>(call->args.size())) {
                                    continue;
                                }
                                const auto* jid =
                                    dynamic_cast<const ast::IdentifierExpr*>(call->args[j].get());
                                if (jid == nullptr ||
                                    activationOwned_.count(jid->name) == 0) {  // j outlives i
                                    error("region-binder: '" + mem->member + "' stores argument '" +
                                              aid->name + "' into argument " + std::to_string(j + 1) +
                                              ", which outlives it, so the method-local object would dangle; "
                                              "pass ownership with 'move' (move " +
                                              aid->name + ")",
                                          call->args[i]->loc);
                                }
                            }
                        }
                    }
                }
            }
            checkComptimeArgs(call->args, m->comptimeParams, "'" + mem->member + "'");
            if (!m->isProperty && call->args.size() != m->paramCount) {
                error("method '" + mem->member + "' expects " + std::to_string(m->paramCount) +
                          " argument(s) but got " + std::to_string(call->args.size()),
                      call->loc);
            }
            // An async method call yields a Task<returnType> (spec 20.2), not the bare value.
            if (m->isAsync) {
                return ast::mangleGeneric("Task", {m->returnType});
            }
            // Safe navigation obj?.method() (spec 3.7): result is nullable; requires a
            // reference-typed return.
            if (mem->safe) {
                const std::string rb = baseType(m->returnType);
                if (!isRefType(m->returnType) && !isArrayType(m->returnType) &&
                    classes_.count(rb) == 0 && rb != "String") {
                    error("safe navigation '?.' requires a reference-typed result; '" + mem->member +
                              "' returns '" + m->returnType + "'",
                          call->loc);
                    return m->returnType;
                }
                return ast::makeNullable(m->returnType);
            }
            return m->returnType;
        }
        // A bare, unqualified call. Polaron has no free functions, so this names a method of the enclosing
        // class written without its receiver. The `this.`/`ClassName.` qualifier is optional: locals and
        // lambdas were already resolved above, so `name` here is not a local -- resolve it as `this.name`
        // (an instance method, in an instance context) or `EnclosingClass.name` (a static method), exactly
        // as if the receiver had been written. Only when the method is an instance method reached from a
        // static context -- or when no such method exists anywhere -- do we error, naming the cause and fix.
        if (!name.empty() && name.find('.') == std::string::npos) {
            if (!enclosingClass_.empty()) {
                if (const MethodInfo* m = findMethod(enclosingClass_, name, /*objectFallback=*/false)) {
                    // An instance-method call needs a receiver; `this` exists only in an instance context
                    // (currentClass_ is cleared inside a static method).
                    if (m->isStatic || !currentClass_.empty()) {
                        // Inside the class that declares it, `interrupt()` reads as an ordinary
                        // implicit-`this` call. It is the same mistake as the qualified one, and
                        // the likelier of the two -- a handler tail-calling itself to "re-run".
                        if (m->isInterrupt) {
                            error("an interrupt cannot be called -- it is ENTERED, not called. Move "
                                  "the work into a method and call that from both places.",
                                  call->loc);
                            return "";
                        }
                        if (MethodFacts* mf = facts()) {
                            mf->callees.insert(enclosingClass_ + "." + name);  // implicit `this`
                        }
                        if (m->isDeprecated) {
                            warn("'" + name + "' is deprecated (spec 14.2)", call->loc);
                        }
                        bindNamedArgs(const_cast<ast::CallExpr*>(call), m->paramNames, m->namedOnlyParams,
                                      "method '" + name + "'");
                        checkCallArgs(call->args, m->paramTypes, "'" + name + "'", &m->moveParams);
                        checkComptimeArgs(call->args, m->comptimeParams, "'" + name + "'");
                        if (!m->isProperty && call->args.size() != m->paramCount) {
                            error("method '" + name + "' expects " + std::to_string(m->paramCount) +
                                      " argument(s) but got " + std::to_string(call->args.size()),
                                  call->loc);
                        }
                        // An async method call yields a Task<returnType> (spec 20.2), not the bare value.
                        if (m->isAsync) {
                            return ast::mangleGeneric("Task", {m->returnType});
                        }
                        return m->returnType;
                    }
                    // Instance method reached from a static method: there is no `this` to call it on.
                    error("unknown call '" + name + "': '" + name + "' is an instance method of '" +
                              enclosingClass_ +
                              "'; it needs an object -- call it on an instance, or mark it 'static' to "
                              "call it from a static method",
                          call->loc);
                    return m->returnType;
                }
            }
            // Not a method of the enclosing class. Name a same-named method elsewhere (there are no free
            // functions, so a bare call can only ever be a member) to point at the likely fix.
            auto describe = [&](const std::string& owner, const MethodInfo* m) {
                if (m->isStatic) {
                    return "unknown call '" + name + "': Polaron has no free functions -- '" + name +
                           "' is a static method of '" + owner + "'; call it qualified as '" + owner +
                           "." + name + "(...)'";
                }
                return "unknown call '" + name + "': Polaron has no free functions -- '" + name +
                       "' is an instance method of '" + owner +
                       "'; call it on an object ('obj." + name + "(...)')";
            };
            for (const auto& [cn, ci] : classes_) {
                if (cn.find('$') != std::string::npos) {
                    continue;  // skip monomorphized instances
                }
                if (const MethodInfo* m = findMethod(cn, name, /*objectFallback=*/false)) {
                    error(describe(cn, m), call->loc);
                    return "";
                }
            }
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call->loc);
        return "";
    }

    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        // SIMD vector lane: v.x / v.y / v.z / v.w -> float. Skip when the receiver is a bare
        // type name (e.g. EnumName.a is a constant, not a vector lane), so we don't type-probe it.
        if (int lane = vecLane(mem->member); lane >= 0) {
            const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
            const bool typeNameRecv = oid != nullptr && oid->name != "this" &&
                                      lookupLocal(oid->name) == nullptr;
            if (!typeNameRecv) {
                if (int w = vecWidth(typeOf(*mem->object)); w > 0) {
                    if (lane >= w) {
                        error("vector has no component '" + mem->member + "'", mem->loc);
                    }
                    return "float";
                }
            }
        }
        // Enum constant access: EnumName.CONSTANT (when the receiver names an enum,
        // not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                auto eit = enums_.find(objId->name);
                if (eit != enums_.end() &&
                    std::find(eit->second.begin(), eit->second.end(), mem->member) !=
                        eit->second.end()) {
                    // TOTALITY reads this: a per-target procedure written on an enum converts FROM
                    // it, and an enum is closed over its CONSTANTS the way a class is over its
                    // fields. Qualified by the enum's own name so a body that mentions some other
                    // enum's constants cannot be mistaken for covering its own.
                    if (MethodFacts* f = facts()) {
                        f->ownConstantsTouched.insert(objId->name + "." + mem->member);
                    }
                    return objId->name;
                }
                // NOT A CONSTANT -- AND AN ENUM HAS SOMEWHERE ELSE FOR IT TO BE. An enum may
                // declare a `static fixed` of its own, and a java-style one keeps its fields,
                // constructor and methods on a twin class of the same name, which is where such a
                // static lands. This returned early and called every one of them a missing
                // constant, so an enum could carry a named threshold and no expression could ever
                // read it back. Falls through to the static-member path below, which knows the
                // twin class; only if THAT has nothing is it an error.
                if (eit != enums_.end() &&
                    constTypes_.count(objId->name + "." + mem->member) == 0 &&
                    (lookupClass(objId->name) == nullptr ||
                     findField(objId->name, mem->member) == nullptr)) {
                    error("enum '" + objId->name + "' has no constant '" + mem->member +
                              "' and no static of that name",
                          mem->loc);
                    return objId->name;
                }
                // Static field access: ClassName.field (when the receiver names a class).
                if (const ClassInfo* sc = lookupClass(objId->name)) {
                    // A class-level const, read as Type.NAME (spec 28.1, OOP form).
                    if (auto ct = constTypes_.find(objId->name + "." + mem->member);
                        ct != constTypes_.end()) {
                        return ct->second;
                    }
                    const FieldInfo* f = findField(objId->name, mem->member);
                    if (f == nullptr) {
                        error("class '" + objId->name + "' has no static field '" + mem->member + "'",
                              mem->loc);
                        return "";
                    }
                    checkMemberAccessible("static field", mem->member, f->visibility, f->owner,
                                          mem->loc);
                    if (!f->isStatic) {
                        error("field '" + mem->member +
                                  "' is not static; access it on an instance",
                              mem->loc);
                        return "";
                    }
                    return f->type;
                }
            }
        }
        std::string objType = typeOf(*mem->object);
        if (objType.empty()) {
            return "";
        }
        // Null safety (spec 3.7): `nullable` only constrains assignment -- a field may be read
        // through a nullable receiver directly (it traps at runtime if null). Resolve against the
        // underlying type.
        if (isNullableType(objType)) {
            objType = baseType(objType);
        }
        std::string memType;
        if (const FieldInfo* f = findField(objType, mem->member)) {
            memType = f->type;
            checkMemberAccessible("field", mem->member, f->visibility, f->owner, mem->loc);
            noteFieldForInterrupt(objType, mem->member, *f, mem->object.get(), mem->loc);  // rule 3, read
            // Partial move (spec 19.9): a field moved out of its parent is inaccessible until reassign.
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                oid != nullptr && moved_.count(oid->name + "." + mem->member) > 0) {
                error("use of field '" + mem->member +
                          "' after it was moved out (reassign it before using) (spec 19.9)",
                      mem->loc);
            }
        } else if (const MethodInfo* pm = findMethod(objType, mem->member);
                   pm != nullptr && pm->isProperty) {
            memType = pm->returnType;  // computed get-only property read as obj.name (no parens)
        } else if (const MethodInfo* im = findMethod(objType, "interrupt");
                   mem->member == "interrupt" && im != nullptr && im->isInterrupt) {
            // `keyboard.interrupt` -- the installable handle. It BINDS this object to the handler
            // and yields the entry point the hardware jumps to, which is an `address` and
            // deliberately not a callable: that is what stops "an interrupt cannot be called" from
            // leaking back out through the reference that installs it.
            memType = "address";
        } else {
            error(diag::Code::NoSuchField,
                  "class '" + objType + "' has no field '" + mem->member + "'" +
                      didYouMean(mem->member, fieldNames(objType)),
                  mem->loc);
            return "";
        }
        if (!mem->safe) {
            return memType;
        }
        // Safe navigation obj?.field (spec 3.7): yields null when obj is null, so the result is
        // nullable; the member must be reference-typed (a primitive cannot carry null).
        const std::string mb = baseType(memType);
        if (!isRefType(memType) && !isArrayType(memType) && classes_.count(mb) == 0 &&
            mb != "String") {
            error("safe navigation '?.' requires a reference-typed member; '" + mem->member +
                      "' is '" + memType + "'",
                  mem->loc);
            return memType;
        }
        return ast::makeNullable(memType);
    }

    if (dynamic_cast<const ast::SuperExpr*>(&expr) != nullptr) {
        error("'super' can only be used as 'super(...)' in a constructor", expr.loc);
        return "";
    }

    error("unsupported expression", expr.loc);
    return "";
}

}  // namespace polaron
