#include "semantic/analyzer.h"
#include "semantic/semutil.h"   // the pure helpers this file used to carry at its top
#include "semantic/analyzer_private.h"  // what analyzer_typeof.cpp / analyzer_stmt.cpp share with it

#include "semantic/asmcheck.h"
#include "semantic/comptime.h"

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <functional>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

namespace polaron {

// The pure helpers (did-you-mean, type-name questions, small AST walks) now live in semutil.{h,cpp}.
// Pulled in unqualified so every call site below reads exactly as it did, and at namespace scope
// rather than inside the anonymous namespace they used to fill -- the lookup rules make the two
// equivalent, and only one of them says so.
using namespace semutil;   // NOLINT(google-build-using-namespace): a deliberate re-export

// The compile-time constant evaluators (spec 28) are declared in analyzer_private.h and defined
// further below. They stopped being `static` when `analyzeStatement` moved to its own file: internal
// linkage means no symbol, so a second translation unit could not call them at all.

void SemanticAnalyzer::error(std::string message, SourceLocation loc) {
    // ASKING A QUESTION MUST NOT PRODUCE A COMPLAINT. The region binder needs the type of a receiver
    // to know whose field it is looking at, and `typeOf` reports as it goes -- so computing a
    // lifetime over `Date.now()` reported `Date` as an undeclared variable, from inside an analysis
    // that was only trying to read. The whole standard library failed to compile the first time this
    // ran, on names nobody had touched.
    if (quiet_ > 0) {
        return;
    }
    // A body copied out of a `freestanding` transformer is checked against the bare-metal subset even
    // in a hosted program, so without this the reader gets "not available in freestanding mode" about
    // a program that is nothing of the sort. The test is on the phrase every one of those messages
    // shares by construction, and it is deliberately narrow: only they need explaining, and an
    // ordinary type error in the same body would be made worse by the sentence, not better.
    if (!freestandingFrom_.empty() && message.find("freestanding mode") != std::string::npos) {
        message += " -- and this body came from `freestanding transformer " + freestandingFrom_ +
                   "`, which promises its bodies obey that subset. The restriction applies here even "
                   "though this program is hosted, so the transformer's author hears it instead of "
                   "whoever applies it in a kernel.";
    }
    // No explicit code at the call-site: infer one from the message so the diagnostic is still rich (the
    // mapping is the one table in diag/catalog.cpp). An unmatched message stays a clean one-liner.
    const diag::Code code = diag::classify(message);
    errors_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::warn(std::string message, SourceLocation loc) {
    const diag::Code code = diag::classify(message);
    warnings_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::error(diag::Code code, std::string message, SourceLocation loc) {
    if (quiet_ > 0) {
        return;   // see the note on the other `error`: a lifetime query must not report
    }
    errors_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::warn(diag::Code code, std::string message, SourceLocation loc) {
    if (allowed(code)) {
        return;   // this declaration said, with a reason, that it disagrees
    }
    warnings_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::pushAllows(const std::vector<ast::AnnotationUse>& outer,
                                  const std::vector<ast::AnnotationUse>& inner) {
    std::vector<AllowEntry> frame;
    auto take = [&frame](const std::vector<ast::AnnotationUse>& uses) {
        for (const ast::AnnotationUse& use : uses) {
            if (use.name != "Allow") {
                continue;
            }
            for (const ast::AnnotationArg& arg : use.args) {
                if (arg.name != "code") {
                    continue;
                }
                if (const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(arg.value.get())) {
                    frame.push_back(AllowEntry{lit->value, use.loc, false});
                }
            }
        }
    };
    take(outer);   // the class's, so one written there covers everything inside it
    take(inner);
    allowStack_.push_back(std::move(frame));
}

void SemanticAnalyzer::popAllows() {
    if (allowStack_.empty()) {
        return;
    }
    // AN `[Allow]` THAT NEVER SUPPRESSED ANYTHING IS A CLAIM THAT HAS STOPPED BEING TRUE. The code
    // it excused was rewritten, or the rule was narrowed, and what is left is a note saying this
    // shape is here deliberately, about a shape that is not here at all. That is worse than no note:
    // the next reader trusts it. Reported at the annotation, which is the line to delete.
    for (const AllowEntry& e : allowStack_.back()) {
        if (!e.used) {
            warnings_.push_back(SemaError{"this [Allow] never suppressed anything: nothing here "
                                          "reports " + e.code,
                                          e.loc, diag::Code::AllowNeverUsed});
        }
    }
    allowStack_.pop_back();
}

bool SemanticAnalyzer::allowed(diag::Code code) {
    const std::string want = diag::codeString(code);
    if (want.empty()) {
        return false;
    }
    bool hit = false;
    for (std::vector<AllowEntry>& frame : allowStack_) {
        for (AllowEntry& e : frame) {
            if (e.code == want) {
                e.used = true;   // marked in every frame that names it, so neither reads as stale
                hit = true;
            }
        }
    }
    return hit;
}

// A statement that can exit or branch out of straight-line flow (so it could break a comefrom loop).
static bool stmtCanExit(const ast::Stmt* st) {
    return dynamic_cast<const ast::ReturnStmt*>(st) != nullptr ||
           dynamic_cast<const ast::BreakStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ContinueStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ThrowStmt*>(st) != nullptr ||
           dynamic_cast<const ast::GotoStmt*>(st) != nullptr ||
           dynamic_cast<const ast::IfStmt*>(st) != nullptr ||
           dynamic_cast<const ast::WhileStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ForStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ForeachStmt*>(st) != nullptr ||
           dynamic_cast<const ast::DoWhileStmt*>(st) != nullptr ||
           dynamic_cast<const ast::SwitchStmt*>(st) != nullptr ||
           dynamic_cast<const ast::MatchStmt*>(st) != nullptr ||
           dynamic_cast<const ast::TryStmt*>(st) != nullptr;
}

// Best-effort warning for an obvious infinite loop via comefrom (spec 7.10 rule 7): a `comefrom X`
// preceded in the SAME block by `label X` with nothing that can exit between them branches back
// forever. (The retry pattern -- label at one level, comefrom inside a try/catch -- spans blocks
// and is not flagged.) Recurses into nested blocks to catch loops contained within them.
void SemanticAnalyzer::detectComefromLoops(const ast::Block& block) {
    for (std::size_t i = 0; i < block.statements.size(); ++i) {
        const ast::Stmt* st = block.statements[i].get();
        if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(st)) {
            for (std::size_t j = i; j-- > 0;) {
                const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(block.statements[j].get());
                if (lm == nullptr || lm->name != cf->name) {
                    continue;
                }
                bool clear = true;
                for (std::size_t k = j + 1; k < i && clear; ++k) {
                    if (stmtCanExit(block.statements[k].get())) {
                        clear = false;
                    }
                }
                if (clear) {
                    warn("comefrom '" + cf->name +
                             "' loops back with no exit between its label and itself: infinite loop "
                             "(spec 7.10)",
                         cf->loc);
                }
                break;
            }
        }
        auto rec = [&](const ast::Block& b) { detectComefromLoops(b); };
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(st)) {
            rec(iff->thenBlock);
            if (iff->elseBlock) {
                rec(*iff->elseBlock);
            }
        } else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) {
            rec(w->body);
        } else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) {
            rec(d->body);
        } else if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) {
            rec(f->body);
        } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) {
            rec(fe->body);
        } else if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
            for (auto& c : sw->cases) {
                rec(c.body);
            }
            if (sw->defaultBody) {
                rec(*sw->defaultBody);
            }
        } else if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
            for (auto& c : ms->cases) {
                rec(c.body);
            }
            if (ms->defaultBody) {
                rec(*ms->defaultBody);
            }
        } else if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
            rec(tr->body);
            for (auto& c : tr->catches) {
                rec(c.body);
            }
            if (tr->finallyBlock) {
                rec(*tr->finallyBlock);
            }
        } else if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) {
            rec(df->body);
        } else if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) {
            rec(us->body);
        }
    }
}

const ClassInfo* SemanticAnalyzer::lookupClass(const std::string& name) const {
    // THE COMMON PATH IS UNCHANGED, and that is the design rather than an optimisation. Counted on
    // this tree: no two types in the standard library share a name, so a written name is unique in
    // almost every program -- one hash of a short key, exactly as before.
    //
    // The guard in front of it is an empty-set test, which costs nothing when nothing collides: the
    // set is populated only by a program that declares a name the library also declares, or the same
    // name in two of its own namespaces.
    if (!sharedNames_.empty() && sharedNames_.count(name) > 0) {
        noteClassRef(name);
        return lookupShared(name);
    }
    auto it = classes_.find(name);
    if (it != classes_.end()) {
        noteClassRef(name);
    }
    return it == classes_.end() ? nullptr : &it->second;
}

// WHICH CLASS MENTIONS WHICH, recorded where the analyzer ALREADY resolves a name.
//
// Codegen emits a body for every method of every class -- including the three hundred in the standard
// library -- and LLVM's GlobalDCE then deletes what nothing reaches: measured on hello_world, 323
// classes are emitted and two functions survive. To emit only what is reachable, codegen needs to
// know what reaches what, and the honest way to get that is the way the interrupt call graph already
// does it: record it WHILE THE ORDINARY WALK HAPPENS.
//
// A hand-written visitor over seventy AST node types has one failure mode -- a node nobody remembered
// -- and here it is not silent but it is late: a missing edge is a symbol that is not there, found at
// link time. Recording at the funnel every name resolution passes through means anything the compiler
// can typecheck, this can follow.
void SemanticAnalyzer::noteClassRef(const std::string& name) const {
    if (owningClassForRefs_.empty() || name == owningClassForRefs_) {
        return;
    }
    classRefs_[owningClassForRefs_].insert(name);
}

// WHICH ONE IS MEANT HERE. This is what replaces the renaming pass: instead of rewriting the program
// to invent a difference between two `Color`s, the question is answered at the place that asks it,
// which is the only place that knows -- the namespace doing the asking, and then its imports, which
// is what `import` already means.
const ClassInfo* SemanticAnalyzer::lookupShared(const std::string& name) const {
    auto shared = typesByWritten_.find(name);
    if (shared == typesByWritten_.end()) {
        auto it = classes_.find(name);
        return it == classes_.end() ? nullptr : &it->second;
    }
    auto entryFor = [this](const TypeEntry& e) -> const ClassInfo* {
        if (auto c = classes_.find(e.canonical); c != classes_.end()) {
            return &c->second;
        }
        // The first declaration of a shared name keeps the bare key, so it is found there.
        if (auto c = classes_.find(e.written); c != classes_.end()) {
            return &c->second;
        }
        return nullptr;
    };
    // Your own namespace wins -- the rule the shadowing warning has always stated and that the
    // renaming pass implemented by rewriting. Same answer, no rewriting.
    for (std::uint32_t id : shared->second) {
        if (types_[id].ns == currentNamespace_) {
            if (const ClassInfo* c = entryFor(types_[id])) {
                return c;
            }
        }
    }
    // THE STANDARD LIBRARY MEANS ITS OWN TYPES, and this is asked BEFORE any import is consulted.
    // It is one body of code that imports nothing, so an unqualified name inside it can only be
    // System's -- and the import rule below, reading the author's imports, once answered otherwise:
    // a program that declared and imported its own `Paths` redirected the LIBRARY's `Paths` to it.
    // The root of that was an import context the prelude should never have had, and is fixed where
    // it is built; stating the rule here as well is what makes it not depend on that staying fixed.
    if (currentBundle_ == "System") {
        // ...but "its own" has to be exactly one of them. Two System types answering to one name is
        // the same over-supply as anywhere else, and taking the first was picking in silence inside
        // the one body of code that cannot write an import to say which it meant. It happened: a
        // `Digest` added under Net.Tls captured `Digest.fnv1a` from Collections, and the failure
        // surfaced as an unknown static method on a class that has it -- which sends the reader to
        // the wrong file. Ambiguous here means unresolved here, and the caller names both paths.
        const ClassInfo* onlyOne = nullptr;
        for (std::uint32_t id : shared->second) {
            if (types_[id].bundle != "System") {
                continue;
            }
            if (const ClassInfo* c = entryFor(types_[id])) {
                if (onlyOne != nullptr && onlyOne != c) {
                    return nullptr;
                }
                onlyOne = c;
            }
        }
        if (onlyOne != nullptr) {
            return onlyOne;
        }
    }
    // AN IMPORT THAT NAMES THE PATH SETTLES IT. Checked before anything else that could guess,
    // because writing `import System.Units.Angle;` is the author saying which one, and no preference
    // of ours should outrank that.
    for (std::uint32_t id : shared->second) {
        if (currentImportPaths_.count(types_[id].canonical) > 0) {
            if (const ClassInfo* c = entryFor(types_[id])) {
                return c;
            }
        }
    }
    // Then a bundle of your own before the standard library's, because the stdlib needs an explicit
    // import to be visible at all and so cannot be what a bare name in your own code means.
    for (std::uint32_t id : shared->second) {
        if (types_[id].bundle != "System" && types_[id].bundle == currentBundle_) {
            if (const ClassInfo* c = entryFor(types_[id])) {
                return c;
            }
        }
    }
    // (The standard-library rule that used to sit here is above, ahead of the import check -- see the
    // note there. Without it the prelude's own `Scanner` lost its fields the moment a user declared
    // one, reported as `no such field 'src'` against a class the author had not touched. The
    // renaming pass carries the same exception, for the same reason, and the two must agree.)
    // WHAT CANNOT BE PROVEN IS NOT GUESSED.
    //
    // Neither yours nor imported: two types answer to this name and nothing here says which. Picking
    // one is the failure mode the whole exercise is about -- a program that compiles against a type
    // its author did not mean, and behaves oddly somewhere else entirely. It stays unresolved, and the
    // caller reports it with both paths so the fix is to write one of them down.
    if (shared->second.size() > 1) {
        return nullptr;
    }
    for (std::uint32_t id : shared->second) {
        if (const ClassInfo* c = entryFor(types_[id])) {
            return c;
        }
    }
    return nullptr;
}

// The paths a name could have meant, for the message that says so. Empty when the name is not shared,
// which is every ordinary name.
std::string SemanticAnalyzer::sharedPathsFor(const std::string& name) const {
    auto shared = typesByWritten_.find(name);
    if (shared == typesByWritten_.end() || shared->second.size() < 2) {
        return "";
    }
    std::string out;
    for (std::uint32_t id : shared->second) {
        if (!out.empty()) {
            out += " or ";
        }
        out += "'" + types_[id].canonical + "'";
    }
    return out;
}

const FieldInfo* SemanticAnalyzer::findField(const std::string& className,
                                             const std::string& field) const {
    // Try the exact name first: a generic instance can have a trailing '*' that belongs to a type
    // argument (e.g. HashMap$int$Node* is HashMap<int,Node*>), which baseType would wrongly strip.
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) {
        c = lookupClass(baseType(className));  // else see through outer T* / T&
    }
    while (c != nullptr) {
        auto it = c->fields.find(field);
        if (it != c->fields.end()) {
            return &it->second;
        }
        if (c->superclass.empty()) {
            break;
        }
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

// Every name usable as a bare identifier at the current point: the locals in every open scope, the
// namespace-level constants, and -- inside an enum's own methods -- that enum's constants. This is the
// candidate set for "did you mean?" on an undeclared-variable error, so it must mirror what the lookup at
// the error site actually accepts.
std::vector<std::string> SemanticAnalyzer::namesInScope() const {
    std::vector<std::string> out;
    for (const auto& scope : scopes_) {
        for (const auto& [name, var] : scope) {
            out.push_back(name);
        }
    }
    for (const auto& [name, type] : constTypes_) {
        out.push_back(name);
    }
    if (auto it = enums_.find(currentClass_); it != enums_.end()) {
        for (const std::string& c : it->second) {
            out.push_back(c);
        }
    }
    return out;
}

// Every field name of a class, including inherited ones -- the candidate set for "did you mean?" on a
// no-such-field error.
std::vector<std::string> SemanticAnalyzer::fieldNames(const std::string& className) const {
    std::vector<std::string> out;
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) {
        c = lookupClass(baseType(className));
    }
    while (c != nullptr) {
        for (const auto& [name, info] : c->fields) {
            out.push_back(name);
        }
        if (c->superclass.empty()) {
            break;
        }
        c = lookupClass(c->superclass);
    }
    return out;
}

// spec 32.8: is `expr` a class's dispatch table (`Dog.methods`)? Returns the class name, or "".
std::string SemanticAnalyzer::dispatchTableClass(const ast::Expr& expr) const {
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr);
    if (mem == nullptr || mem->member != "methods") {
        return "";
    }
    const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
    if (id == nullptr || lookupClass(id->name) == nullptr) {
        return "";
    }
    return id->name;
}

// spec 32.8: `Dog.methods.replace("bark", <function value>)`. The replacement must be a function whose
// first parameter is the receiver, then the method's own parameters, returning what the method returns
// -- exactly the shape of the slot it takes over. Type safety is not lost: the signature is checked here,
// at compile time, and the replacement is installed in the class's vtable, so every instance (existing
// and future) picks it up.
std::string SemanticAnalyzer::checkMethodPatch(const std::string& className,
                                               const ast::CallExpr& call) {
    if (call.args.size() != 2) {
        error("'" + className + ".methods.replace' takes the method name and its replacement", call.loc);
        return "void";
    }
    const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(call.args[0].get());
    if (lit == nullptr) {
        error("the method to replace must be a string literal, so it can be checked at compile time",
              call.args[0]->loc);
        return "void";
    }
    const MethodInfo* m = findMethod(className, lit->value);
    if (m == nullptr) {
        error("no method '" + lit->value + "' on class '" + className + "' to replace", call.loc);
        return "void";
    }
    if (m->isStatic) {
        error("cannot replace the static method '" + className + "." + lit->value +
                  "'; only instance methods are dispatched through the table",
              call.loc);
        return "void";
    }
    std::string want = "function<" + m->returnType + "," + className;
    for (const std::string& pt : m->paramTypes) {
        want += "," + pt;
    }
    want += ">";
    const std::string got = typeOf(*call.args[1]);
    if (!got.empty() && got != want) {
        error("the replacement for '" + className + "." + lit->value + "' must have type '" + want +
                  "' (the receiver, then the method's parameters); got '" + got + "'",
              call.args[1]->loc);
    }
    patchedClasses_.insert(className);
    return "void";
}

const MethodInfo* SemanticAnalyzer::findMethod(const std::string& className,
                                               const std::string& method,
                                               bool objectFallback) const {
    // Exact name first (a generic instance's trailing '*' may belong to a type argument, e.g.
    // HashMap$int$Node*); only then strip an outer pointer/reference marker.
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) {
        c = lookupClass(baseType(className));  // see through T* / T&
    }
    while (c != nullptr) {
        auto it = c->methods.find(method);
        if (it != c->methods.end()) {
            return &it->second;
        }
        for (const std::string& iface : c->interfaces) {
            const MethodInfo* m = findMethod(iface, method);
            if (m != nullptr) {
                return m;
            }
        }
        if (c->superclass.empty()) {
            break;
        }
        c = lookupClass(c->superclass);
    }
    // Every object is-a Object at runtime, so Object's universal methods (equals/hashCode/equalsKey/...)
    // resolve on any receiver -- including one whose static type is an interface, which has no superclass
    // chain to Object. Fall back to Object for anything the hierarchy walk did not find; a type's own
    // member always wins because it is checked first. This lets ArrayList<Iface>/HashMap<Iface,V> work.
    // Gated: only call resolution wants this, not the override/hiding check (else a record's generated
    // equals/hashCode would look like it overrides an interface method).
    if (objectFallback && className != "Object" && baseType(className) != "Object") {
        if (const ClassInfo* obj = lookupClass("Object")) {
            auto it = obj->methods.find(method);
            if (it != obj->methods.end()) {
                return &it->second;
            }
        }
    }
    return nullptr;
}

// The enums that implement `catalog` (directly or through a catalog it extends), spec 12.4.
std::vector<std::string> SemanticAnalyzer::catalogImplementers(const std::string& catalog) const {
    std::vector<std::string> out;
    for (const auto& [name, _] : enums_) {
        if (isSubtype(name, catalog)) {
            out.push_back(name);
        }
    }
    return out;
}

// The tail on a type-mismatch message when the two sides are `address` and a plain integer. Without
// it the reader is told `address` and `long` are different types, which is true and unhelpful: both
// are 64-bit integers, the rule that separates them is new, and the whole point is that crossing
// between them should be a thing you decided rather than a thing that happened.
std::string SemanticAnalyzer::addressHint(const std::string& from, const std::string& to) const {
    if (!isIntName(from) || !isIntName(to)) {
        return "";
    }
    // The whole family, not only the 64-bit one: `half address`, `short address` and `byte address`
    // are addresses that are narrower, never numbers that happen to hold one.
    if (isAddressName(from) == isAddressName(to)) {
        return "";
    }
    if (isAddressName(to)) {
        return ". An address is not an integer that happens to be that wide -- making one out of "
               "a number is how a program reads memory nobody gave it. Write 'cast<" + to +
               ">(...)' if that is what you mean";
    }
    return ". An address is not an integer that happens to be that wide -- storing one in a "
           "number loses the fact that it points at something. Write 'cast<" + to +
           ">(...)' if that is what you mean";
}

// A BOXED SUM CASE DOES NOT FLOW INTO THE VALUE FORM.
//
// `Option<T>` and `Result<T,E>` have two representations (spec 21): written plain they are a
// { tag, payload } VALUE, built by `Some(x)`; written with a `*` they are the boxed class, built by
// `new Some<T>(x) on heap`. `Some` extends `Option`, so the CLASS relation says yes while the
// representations disagree, and the compiler used to take the class's word for it:
// `Option<int> v = new Some<int>(7) on heap;` stored a POINTER into a variant slot, and `match` then
// read the tag out of that pointer's low four bytes. Measured: it answered 0 for a Some(7). No
// error, no crash, wrong answer. Returning one the same way produced IR that failed the module
// verifier -- the compiler admitting it could not do what it had just accepted.
//
// NOT INSIDE isSubtype, which was tried and is wrong twice over: `match` asks the membership
// question (`case Some(int n)` on an `Option<int>` subject) and would start refusing every arm, and
// the boxed target `Option<int>*` strips its own star before recursing, so the guard fired on the
// form it exists to allow. Subtyping and representation are different questions; this is the second.
// It belongs where a value CONVERTS -- assignment, initialisation, return, argument -- and each of
// those sites pairs it with sumFormHint so the refusal and its explanation share one predicate.
bool SemanticAnalyzer::isBoxedSumMismatch(const std::string& sub, const std::string& super) {
    return isValueSumForm(super) && isSumCaseClass(sub);
}

// `Option$T` / `Result$T$E` written plain -- the value form. A `*` or `&` makes it the boxed class
// instead, and a `nullable` wrapper is not this shape at all.
bool SemanticAnalyzer::isValueSumForm(const std::string& t) {
    if (t.find('*') != std::string::npos || t.find('&') != std::string::npos) {
        return false;
    }
    return t.rfind("Option$", 0) == 0 || t.rfind("Result$", 0) == 0;
}

// One of the four case classes of those two sums, as an object rather than a value.
bool SemanticAnalyzer::isSumCaseClass(const std::string& t) {
    if (t.find('*') != std::string::npos || t.find('&') != std::string::npos) {
        return false;
    }
    return t.rfind("Some$", 0) == 0 || t.rfind("None$", 0) == 0 || t.rfind("Ok$", 0) == 0 ||
           t.rfind("Err$", 0) == 0;
}

// The sentence that turns "cannot assign" into an instruction, appended by the sites that report a
// failed conversion. Empty unless this is the value/boxed mix-up above -- which is worth naming,
// because both spellings are legal Polaron and only the target says which one is meant.
std::string SemanticAnalyzer::sumFormHint(const std::string& sub, const std::string& super) {
    if (!isBoxedSumMismatch(sub, super)) {
        return "";
    }
    const std::string ctor = sub.substr(0, sub.find('$'));
    return " ('" + super.substr(0, super.find('$')) +
           "' plain is the value form: build it with '" + ctor +
           "(...)' and no 'new'. To keep the boxed object, declare the target as '" +
           super.substr(0, super.find('$')) + "<...>*')";
}

bool SemanticAnalyzer::isSubtype(const std::string& sub, const std::string& super, int depth) const {
    if (sub == super) {
        return true;
    }
    // Guard against a cyclic type graph (e.g. `catalog A extends B; B extends A`):
    // bound the recursion so a malformed program errors instead of overflowing.
    if (depth > 256) {
        return false;
    }
    // null binds ONLY to a `nullable T` target -- never to a non-nullable type, whatever its kind
    // (spec 3.7 -- the core null-safety rule: non-null by default; `nullable` opts a type into null).
    if (sub == "null") {
        return isNullableType(super);
    }
    // Nullability (spec 3.7): a `nullable T` value may not flow into a non-nullable target (you must
    // check it first); a non-null value flows freely into a `nullable T`. Compare the underlying T.
    if (isNullableType(sub) || isNullableType(super)) {
        if (isNullableType(sub) && !isNullableType(super)) {
            return false;
        }
        auto strip = [](const std::string& s) {
            return ast::stripNullable(s);
        };
        return isSubtype(strip(sub), strip(super), depth + 1);
    }
    // String (immutable) and string (mutable) share a representation; they interconvert freely until
    // the immutability discipline is enforced (spec 4).
    if ((sub == "String" || sub == "string") && (super == "String" || super == "string")) {
        return true;
    }
    // Every value is an Object (spec 3.4): a primitive becomes one by boxing, a class by inheritance
    // (every class now extends Object, handled by the hierarchy walk below).
    if (super == "Object" && (isNumeric(sub) || sub == "boolean" || sub == "char")) {
        return true;
    }
    // An interface (and any class) is an Object too. Interfaces have no superclass chain to Object, so
    // the hierarchy walk below never reaches it; accept any known class/interface type directly.
    if (super == "Object" && lookupClass(baseType(sub)) != nullptr) {
        return true;
    }
    // int and float both widen to a float type (no implicit narrowing).
    if (isFloatType(super) && isNumeric(sub)) {
        return true;
    }
    // Integers widen to a wider integer (no implicit narrowing).
    if (isIntName(sub) && isIntName(super)) {
        // ...but `address` is not an integer that happens to be 64 bits wide, it is a machine
        // address, and it sits in isIntName only so the arithmetic on it works. Left as a plain
        // widening, `address a = someLong;` silently turned a number into a pointer and
        // `long n = someAddress;` silently turned a pointer into a number -- the exact conversion a
        // language with no exploitable UB has to make somebody write down.
        //
        // Freestanding is exempt, and not as a concession: on bare metal, turning an integer into an
        // address IS the work (spec 36), the memory-mapped register at 0xB8000 is a number until you
        // say otherwise, and there is no allocator to have given you the address instead. Measured
        // before landing: the whole hosted world is TWELVE sites -- five across 380 samples and seven
        // in agents-exe -- against 210 in the pico kernel, which is what that split looks like.
        if (!freestanding_ && isAddressName(sub) != isAddressName(super)) {
            return false;
        }
        // Within the family, an address still only widens: `byte address` -> `address` is fine and
        // the reverse is a cast, exactly as for the numbers. The narrow forms are DOMAIN types (a
        // real-mode offset, a zero page, a physical address stored narrow in a hardware structure),
        // so a program that mixes two of them is saying something and should be made to say it.
        return intBits(sub) <= intBits(super);
    }
    // Pointer/reference compatibility follows the pointee (T*, T& and T mix
    // freely for now; the strict value-vs-reference rules land with deep copy).
    //
    // ... but try the names AS WRITTEN first. A monomorphized generic can end in a '*' that belongs to
    // its last TYPE ARGUMENT rather than to the outer type -- `ArrayListIterator$Node*` is
    // `ArrayListIterator<Node*>`, a value -- so stripping it produces a type that does not exist and the
    // hierarchy walk below finds nothing. findField already had to learn this; the same trap is here.
    if (isRefType(sub) || isRefType(super)) {
        if (lookupClass(sub) == nullptr || lookupClass(super) == nullptr) {
            return isSubtype(baseType(sub), baseType(super), depth + 1);
        }
    }
    // An enum is a subtype of every catalog it extends (spec 12.4), transitively
    // through catalog->catalog extends.
    if (auto ecit = enumCatalogs_.find(sub); ecit != enumCatalogs_.end()) {
        for (const std::string& cat : ecit->second) {
            if (cat == super || isSubtype(cat, super, depth + 1)) {
                return true;
            }
        }
    }
    // A catalog is a subtype of every catalog it extends.
    if (auto ccit = catalogs_.find(sub); ccit != catalogs_.end()) {
        for (const std::string& cat : ccit->second.extendsCatalogs) {
            if (cat == super || isSubtype(cat, super, depth + 1)) {
                return true;
            }
        }
    }
    // Generic variance (spec 15.3): two instantiations of the same generic relate per
    // the declared variance of each type parameter (covariant `out`, contravariant
    // `in`, invariant otherwise). Instantiations are mangled "Base$arg[$arg...]".
    if (const auto subD = sub.find('$'), supD = super.find('$');
        subD != std::string::npos && supD != std::string::npos &&
        sub.compare(0, subD, super, 0, supD) == 0) {
        if (auto vit = genericVariance_.find(sub.substr(0, subD)); vit != genericVariance_.end()) {
            auto split = [](const std::string& s) {
                std::vector<std::string> out;
                std::size_t i = 0;
                while (i < s.size()) {
                    std::size_t j = s.find('$', i);
                    if (j == std::string::npos) {
                        j = s.size();
                    }
                    out.push_back(s.substr(i, j - i));
                    i = j + 1;
                }
                return out;
            };
            const std::vector<std::string> subArgs = split(sub.substr(subD + 1));
            const std::vector<std::string> supArgs = split(super.substr(supD + 1));
            if (subArgs.size() == supArgs.size() && subArgs.size() == vit->second.size()) {
                bool ok = true;
                for (std::size_t i = 0; i < subArgs.size() && ok; ++i) {
                    if (subArgs[i] == supArgs[i]) {
                        continue;
                    }
                    const std::string& var = vit->second[i];
                    if (var == "out") {
                        ok = isSubtype(subArgs[i], supArgs[i], depth + 1);
                    } else if (var == "in") {
                        ok = isSubtype(supArgs[i], subArgs[i], depth + 1);
                    } else {
                        ok = false;  // invariant: arguments must be identical
                    }
                }
                if (ok) {
                    return true;
                }
            }
        }
    }
    const ClassInfo* c = lookupClass(sub);
    if (c == nullptr) {
        return false;
    }
    // A monomorphized instantiation keeps its superclass and interfaces under their BASE names
    // (`Option`, `Iterator`), while `super` here is a mangled instantiation (`Option$Node`). For the
    // pass-through case -- `C<T> extends B<T>` / `implements I<T>`, which is what the stdlib's Option,
    // Some/None and the iterators all are -- the instantiation's own argument suffix is the parent's
    // too, so retry with it. This can only ever ACCEPT a relation, never reject one, so a wrong guess
    // costs a missed error rather than a false one.
    const std::size_t argsAt = sub.find('$');
    const std::string suffix = (argsAt == std::string::npos) ? std::string() : sub.substr(argsAt);
    auto relates = [&](const std::string& parent) {
        if (isSubtype(parent, super, depth + 1)) {
            return true;
        }
        return !suffix.empty() && parent.find('$') == std::string::npos &&
               isSubtype(parent + suffix, super, depth + 1);
    };
    if (!c->superclass.empty() && relates(c->superclass)) {
        return true;
    }
    for (const std::string& iface : c->interfaces) {
        if (relates(iface)) {
            return true;
        }
    }
    return false;
}

// Whether a type says of itself that it is safe to reach from several threads at once -- that is,
// whether it implements System.Concurrency.Shared, directly or through what it extends.
//
// This is the ONLY way a program written in this language can hand its own type to a thread, and
// that is deliberate: the data-race rule below knows three stdlib types by name, and without this a
// worker pool, a lock-free queue or any other concurrent structure could be written in the standard
// library and nowhere else. The promise is not weakened by moving it here -- it is written down, in
// the type, where a reader and a reviewer can find it.
bool SemanticAnalyzer::declaresShared(const std::string& name) const {
    std::string cur = baseType(name);
    const int limit = static_cast<int>(classes_.size()) + 1;
    for (int steps = 0; !cur.empty() && steps <= limit; ++steps) {
        const ClassInfo* c = lookupClass(cur);
        if (c == nullptr) return false;
        for (const std::string& iface : c->interfaces) {
            if (baseType(iface) == "Shared") return true;
            if (declaresShared(iface)) return true;   // an interface may extend Shared
        }
        cur = c->superclass;
    }
    return false;
}

bool SemanticAnalyzer::isPolymorphic(const std::string& name) const {
    const ClassInfo* c = lookupClass(name);
    if (c == nullptr) {
        return false;
    }
    if (c->isAbstract || c->isInterface || !c->superclass.empty() || !c->interfaces.empty()) {
        return true;
    }
    for (const auto& [n, info] : classes_) {
        (void)n;
        if (info.superclass == name) {
            return true;
        }
        for (const std::string& i : info.interfaces) {
            if (i == name) {
                return true;
            }
        }
    }
    return false;
}

void SemanticAnalyzer::validateHierarchy() {
    // The permitted variants of every sealed type. Match exhaustiveness assumes a
    // closed world, so these are effectively final: a subclass of a variant would
    // have a distinct vtable and escape the exact-vtable arm checks (UB on no match).
    std::unordered_set<std::string> sealedVariants;
    for (const auto& [name, info] : classes_) {
        (void)name;
        if (info.isSealed) {
            for (const std::string& p : info.permits) {
                sealedVariants.insert(p);
            }
        }
    }
    for (const auto& [name, info] : classes_) {
        // This walk is over the class MAP, so it has to carry each class's own home with it: every
        // `lookupClass` below resolves a name written INSIDE this class, and the answer depends on
        // where that class is (see ClassInfo::ns). Restored after the loop by the caller's own
        // setting; kept accurate per iteration because two adjacent entries in the map need not be
        // in the same namespace, or even the same bundle.
        struct Where {
            SemanticAnalyzer& a;
            std::string ns, bundle;
            ~Where() { a.currentNamespace_ = ns; a.currentBundle_ = bundle; }
        } where{*this, currentNamespace_, currentBundle_};
        currentNamespace_ = info.ns;
        currentBundle_ = info.bundle;
        if (!info.superclass.empty()) {
            const ClassInfo* sup = lookupClass(info.superclass);
            const std::string supBare =
                baseType(info.superclass).substr(0, baseType(info.superclass).find('$'));
            if (sealedVariants.count(supBare) > 0) {
                error("class '" + name + "' cannot extend '" + info.superclass +
                          "', a sealed variant (sum-type variants are final)",
                      {});
            }
            if (sup == nullptr) {
                // AND IF IT IS AMBIGUOUS, SAY SO RATHER THAN "UNKNOWN". A name that resolves to two
                // types in different namespaces is not missing -- it is over-supplied, and telling
                // the author it is unknown sends them looking for a declaration that is right there,
                // twice. The message names both paths, because writing one of them down is the fix.
                if (const std::string paths = sharedPathsFor(info.superclass); !paths.empty()) {
                    error("class '" + name + "' extends '" + info.superclass +
                              "', and that name means two different types here: " + paths +
                              ". Write the one you meant with its namespace, or import it",
                          {});
                } else {
                    error("class '" + name + "' extends unknown type '" + info.superclass + "'", {});
                }
            } else if (sup->isInterface) {
                error("class '" + name + "' extends interface '" + info.superclass +
                          "' (use 'implements')",
                      {});
            } else if (sup->isStruct) {
                error("class '" + name + "' extends struct '" + info.superclass +
                          "' (structs have no inheritance)",
                      {});
            } else if (sup->isFinal) {
                error("class '" + name + "' cannot extend final class '" + info.superclass + "'",
                      {});
            } else if (sup->isRegionClass && !info.isRegionClass) {
                // EVERYTHING BENEATH A REGION CLASS MUST BE ONE. An abstract region class declares a
                // region shared by its whole family; a plain class inheriting from it would allocate
                // its instances somewhere else, and the guarantee the feature exists for -- that there
                // IS nowhere else -- would be gone without a word. Every consequence rests on it:
                // unimport's O(1) "is any alive?", walking every instance of a type, and the 32-bit
                // pointer that totality would one day allow.
                error("'" + name + "' extends the region class '" + info.superclass +
                          "', so it has to be a `region class` too -- an instance of it would otherwise "
                          "be allocated outside the family's region, and a region class is worth having "
                          "precisely because there is nowhere else its instances can be",
                      {});
            } else if (sup->isSealed &&
                       std::find(sup->permits.begin(), sup->permits.end(),
                                 name.substr(0, name.find('$'))) == sup->permits.end()) {
                // ^ permits hold bare names (Ok, Err); a monomorphized subclass is Ok$int$int.
                error("class '" + name + "' cannot extend sealed '" + info.superclass +
                          "' (not in its permits list)",
                      {});
            }
        }
        for (const std::string& iface : info.interfaces) {
            const ClassInfo* i = lookupClass(iface);
            if (i == nullptr) {
                error("'" + name + "' implements unknown type '" + iface + "'", {});
            } else if (!i->isInterface) {
                error("'" + name + "' implements '" + iface + "', which is not an interface", {});
            }
        }
        // Inheritance cycle detection via the superclass chain.
        std::string cur = info.superclass;
        const int limit = static_cast<int>(classes_.size()) + 1;
        for (int steps = 0; !cur.empty() && steps <= limit; ++steps) {
            if (cur == name) {
                error("inheritance cycle involving class '" + name + "'", {});
                break;
            }
            const ClassInfo* c = lookupClass(cur);
            if (c == nullptr) {
                break;
            }
            cur = c->superclass;
        }
    }
}

void SemanticAnalyzer::collectMethodNamesInto(const std::string& className,
                                              std::vector<std::string>& out) const {
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) {
        return;
    }
    for (const auto& [mname, mi] : c->methods) {
        (void)mi;
        if (std::find(out.begin(), out.end(), mname) == out.end()) {
            out.push_back(mname);
        }
    }
    if (!c->superclass.empty()) {
        collectMethodNamesInto(c->superclass, out);
    }
    for (const std::string& iface : c->interfaces) {
        collectMethodNamesInto(iface, out);
    }
}

void SemanticAnalyzer::validateOverrides(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                const ClassInfo* ci = lookupClass(cls.name);
                if (ci == nullptr) {
                    continue;
                }

                // Does any superclass / interface declare `method`?
                auto inheritedHas = [&](const std::string& method) {
                    if (!ci->superclass.empty() && findMethod(ci->superclass, method) != nullptr) {
                        return true;
                    }
                    for (const std::string& iface : ci->interfaces) {
                        if (findMethod(iface, method) != nullptr) {
                            return true;
                        }
                    }
                    return false;
                };

                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isStatic) {
                        continue;
                    }
                    const bool inherited = inheritedHas(m->name);
                    if (m->isOverride && !inherited) {
                        error("method '" + m->name +
                                  "' is marked 'override' but does not override anything",
                              m->loc);
                    }
                    if (!m->isOverride && !m->isAbstract && inherited) {
                        error("method '" + m->name +
                                  "' overrides an inherited method; mark it 'override'",
                              m->loc);
                    }
                    // A `final` inherited method may not be overridden.
                    if (inherited) {
                        const MethodInfo* base = nullptr;
                        if (!ci->superclass.empty()) {
                            base = findMethod(ci->superclass, m->name);
                        }
                        for (const std::string& iface : ci->interfaces) {
                            if (base == nullptr) {
                                base = findMethod(iface, m->name);
                            }
                        }
                        if (base != nullptr && base->isFinal) {
                            error("method '" + m->name + "' cannot override final method '" +
                                      m->name + "'",
                                  m->loc);
                        }
                    }
                }

                // A concrete class must implement every abstract method it inherits.
                if (!ci->isAbstract && !ci->isInterface) {
                    std::vector<std::string> names;
                    collectMethodNamesInto(cls.name, names);
                    for (const std::string& mname : names) {
                        const MethodInfo* mi = findMethod(cls.name, mname);
                        if (mi != nullptr && mi->isAbstract) {
                            error("class '" + cls.name + "' must implement abstract method '" +
                                      mname + "'",
                                  cls.loc);
                        }
                    }
                }
            }
        }
    }
}

void SemanticAnalyzer::pushScope() { scopes_.emplace_back(); }

void SemanticAnalyzer::popScope() {
    if (!scopes_.empty()) {
        scopes_.pop_back();
    }
}

// ---- the flow machine ----
// Four facts, one set of operations. Each of them answers "what does the compiler KNOW here", which is a
// different question from "what does the declaration say", and all four need the same handling at a
// branch, a loop and a scope boundary. Keeping them together is what stops them drifting apart.

FlowFacts SemanticAnalyzer::snapshotFlow() const {
    FlowFacts f;
    f.init = init_;
    f.nonNull = nonNull_;
    f.moved = moved_;
    f.deleted = deleted_;
    f.freed = freed_;
    f.invalidated = invalidatedAt_;
    f.borrows = borrowsFrom_;
    return f;
}

void SemanticAnalyzer::restoreFlow(const FlowFacts& f) {
    init_ = f.init;
    nonNull_ = f.nonNull;
    moved_ = f.moved;
    deleted_ = f.deleted;
    freed_ = f.freed;
    invalidatedAt_ = f.invalidated;
    borrowsFrom_ = f.borrows;
}

void SemanticAnalyzer::joinFlow(const FlowFacts& a, const FlowFacts& b) {
    // Initialization: Init only where BOTH arms initialized it. Where exactly one did, the result is
    // Maybe -- deliberately distinguished from Uninit, because "you set it in the `then` and forgot the
    // `else`" deserves to be told as that, not as "never initialized".
    init_.clear();
    for (const auto& [name, sa] : a.init) {
        const auto ib = b.init.find(name);
        const FlowFacts::Init sb = ib == b.init.end() ? FlowFacts::Init::Init : ib->second;
        init_[name] = (sa == sb) ? sa
                    : (sa == FlowFacts::Init::Uninit && sb == FlowFacts::Init::Uninit)
                          ? FlowFacts::Init::Uninit
                          : FlowFacts::Init::Maybe;
    }
    for (const auto& [name, sb] : b.init) {
        if (a.init.find(name) == a.init.end() && sb != FlowFacts::Init::Init) {
            init_[name] = FlowFacts::Init::Maybe;
        }
    }

    // A PROOF must hold on both paths to survive; an OBLIGATION (moved, deleted) that holds on either
    // must survive. The asymmetry is the point: be pessimistic about what you know, pessimistic about
    // what you owe. Optimism in either direction is how a flow analysis starts lying.
    nonNull_.clear();
    for (const std::string& n : a.nonNull) {
        if (b.nonNull.count(n) > 0) {
            nonNull_.insert(n);
        }
    }
    moved_ = a.moved;
    moved_.insert(b.moved.begin(), b.moved.end());
    deleted_ = a.deleted;
    deleted_.insert(b.deleted.begin(), b.deleted.end());
    freed_ = a.freed;
    freed_.insert(b.freed.begin(), b.freed.end());
    // Emptied on either path is emptied here: an obligation, like the three above it.
    invalidatedAt_ = a.invalidated;
    invalidatedAt_.insert(b.invalidated.begin(), b.invalidated.end());
    // Where a borrow CAME FROM is knowledge, not an obligation, so it survives only where both paths
    // agree -- and disagreeing means one path rebound the name, which is the case that must not
    // silently keep the old source.
    borrowsFrom_.clear();
    for (const auto& [name, from] : a.borrows) {
        if (auto it = b.borrows.find(name); it != b.borrows.end() && it->second == from) {
            borrowsFrom_.emplace(name, from);
        }
    }
}

void SemanticAnalyzer::invalidateAcrossBackEdge(const FlowFacts& before) {
    // The body may run again with whatever the previous iteration left behind, so a proof the body did
    // not already have at the top cannot be trusted at the top. Initialization is the opposite: it only
    // ever moves forward, so what the body initialized stays initialized.
    std::unordered_set<std::string> kept;
    for (const std::string& n : nonNull_) {
        if (before.nonNull.count(n) > 0) {
            kept.insert(n);
        }
    }
    nonNull_ = std::move(kept);
}

FlowFacts::Init SemanticAnalyzer::initStateOf(const std::string& name) const {
    const auto it = init_.find(name);
    return it == init_.end() ? FlowFacts::Init::Init : it->second;
}

void SemanticAnalyzer::markInitialized(const std::string& name) {
    if (init_.find(name) != init_.end()) {
        init_[name] = FlowFacts::Init::Init;
    }
}

// True when every path through this block leaves it -- return, throw, break or continue. Such a block
// contributes nothing to the state after the branch it belongs to, which is exactly why a guard clause
// (`if (p == null) { return; }`) can narrow the code that follows it.
bool SemanticAnalyzer::blockAlwaysExits(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::ReturnStmt*>(s) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::ThrowStmt*>(s) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::BreakStmt*>(s) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::ContinueStmt*>(s) != nullptr) {
            return true;
        }
        // A nested if counts only when BOTH of its arms exit -- otherwise a path falls through it.
        if (const auto* nested = dynamic_cast<const ast::IfStmt*>(s)) {
            if (nested->elseBlock != nullptr && blockAlwaysExits(nested->thenBlock) &&
                blockAlwaysExits(*nested->elseBlock)) {
                return true;
            }
        }
    }
    return false;
}

// True when every path through this block RETURNS (or throws) -- deliberately not `blockAlwaysExits`,
// which answers a different question. That one counts `break` and `continue` as leaving, which is right
// for narrowing (the rest of that block is unreachable) and wrong here: a `break` carries on inside the
// method and still has to reach a `return`.
//
// Conservative by construction. A shape it does not recognise answers false, which costs a missed
// diagnostic; answering true where a path really does fall through would let the original bug back in,
// and answering false where the code is fine would break a build that was correct.
bool SemanticAnalyzer::alwaysReturns(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::ReturnStmt*>(s) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::ThrowStmt*>(s) != nullptr) {
            return true;
        }
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(s)) {
            if (iff->elseBlock != nullptr && alwaysReturns(iff->thenBlock) &&
                alwaysReturns(*iff->elseBlock)) {
                return true;
            }
        }
        // `while (true)` with no way out is a method that ends by never ending -- the shape a dispatch
        // loop, a scheduler and a kernel's idle path all have.
        if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
            if (const auto* c = dynamic_cast<const ast::BoolLiteralExpr*>(w->cond.get());
                c != nullptr && c->value && !blockHasBreak(w->body)) {
                return true;
            }
        }
        // try/catch: the value has to come out of the body AND out of every catch, or out of a finally
        // that returns regardless.
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
            if (tr->finallyBlock != nullptr && alwaysReturns(*tr->finallyBlock)) {
                return true;
            }
            bool all = alwaysReturns(tr->body);
            for (const auto& c : tr->catches) {
                all = all && alwaysReturns(c.body);
            }
            if (all) {
                return true;
            }
        }
        // switch/match: only when there is a default, since without one a subject that matches nothing
        // falls straight through.
        if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
            if (sw->defaultBody != nullptr) {
                bool all = alwaysReturns(*sw->defaultBody);
                for (const auto& c : sw->cases) {
                    all = all && alwaysReturns(c.body);
                }
                if (all) {
                    return true;
                }
            }
        }
        if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
            bool all = ms->defaultBody != nullptr ? alwaysReturns(*ms->defaultBody) : true;
            for (const auto& c : ms->cases) {
                all = all && alwaysReturns(c.body);
            }
            if (all && !ms->cases.empty()) {
                return true;  // a match over a sealed type is exhaustive
            }
        }
    }
    return false;
}

// Whether a block contains a `break` that would leave a loop -- used only to tell a `while (true)` that
// never ends from one that does. Nested loops own their own breaks, so those do not count.
bool SemanticAnalyzer::blockHasBreak(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::BreakStmt*>(s) != nullptr) {
            return true;
        }
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(s)) {
            if (blockHasBreak(iff->thenBlock)) {
                return true;
            }
            if (iff->elseBlock != nullptr && blockHasBreak(*iff->elseBlock)) {
                return true;
            }
        }
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
            if (blockHasBreak(tr->body)) {
                return true;
            }
            for (const auto& c : tr->catches) {
                if (blockHasBreak(c.body)) {
                    return true;
                }
            }
            if (tr->finallyBlock != nullptr && blockHasBreak(*tr->finallyBlock)) {
                return true;
            }
        }
    }
    return false;
}

// Read a null test and report what it PROVES, and for which arm. Only the shapes whose meaning is
// unambiguous are recognised -- `x != null` and `x == null` against a plain name. Anything cleverer
// (`a != null && b != null`, a call that returns a nullable) proves nothing here, which costs a cast at
// the call site and keeps the analysis honest. Being incomplete is safe; being wrong is not.
void SemanticAnalyzer::proofFromCondition(const ast::Expr& cond, std::string& provenThen,
                                          std::string& provenElse) {
    const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&cond);
    if (bin == nullptr) {
        return;
    }
    if (bin->op == "&&") {
        // `a != null && ...`: whatever the left side proves holds for the whole `then` arm, because the
        // right side only runs when the left was true. The `else` arm learns nothing.
        std::string lThen, lElse, rThen, rElse;
        proofFromCondition(*bin->lhs, lThen, lElse);
        proofFromCondition(*bin->rhs, rThen, rElse);
        provenThen = !lThen.empty() ? lThen : rThen;
        return;
    }
    if (bin->op != "==" && bin->op != "!=") {
        return;
    }
    const auto* lid = dynamic_cast<const ast::IdentifierExpr*>(bin->lhs.get());
    const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(bin->rhs.get());
    const bool lNull = dynamic_cast<const ast::NullLiteralExpr*>(bin->lhs.get()) != nullptr;
    const bool rNull = dynamic_cast<const ast::NullLiteralExpr*>(bin->rhs.get()) != nullptr;
    std::string name;
    if (lid != nullptr && rNull) {
        name = lid->name;
    } else if (rid != nullptr && lNull) {
        name = rid->name;
    }
    if (name.empty()) {
        return;
    }
    // `x != null` proves it in the `then`; `x == null` proves it in the `else`.
    if (bin->op == "!=") {
        provenThen = name;
    } else {
        provenElse = name;
    }
}

void SemanticAnalyzer::killProofsFor(const std::string& name) {
    nonNull_.erase(name);
    // A write to `obj` says nothing about `obj.field` any more either.
    const std::string prefix = name + ".";
    for (auto it = nonNull_.begin(); it != nonNull_.end();) {
        it = (it->rfind(prefix, 0) == 0) ? nonNull_.erase(it) : std::next(it);
    }
}

const LocalVar* SemanticAnalyzer::lookupLocal(const std::string& name) const {
    for (auto it = scopes_.rbegin(); it != scopes_.rend(); ++it) {
        auto found = it->find(name);
        if (found != it->end()) {
            return &found->second;
        }
    }
    return nullptr;
}

void SemanticAnalyzer::declareLocal(const std::string& name, LocalVar info) {
    scopes_.back()[name] = std::move(info);
}

bool SemanticAnalyzer::isValidMainSignature(const ast::MethodDecl& method) const {
    if (method.visibility != "public") {
        return false;
    }
    if (!method.isStatic) {
        return false;
    }
    if (method.params.size() != 1) {
        return false;
    }
    const ast::Param& p = method.params.front();
    if (p.type.name != "string" || !p.type.isArray) {
        return false;
    }
    if (method.returnType.isArray) {
        return false;
    }
    return method.returnType.name == "void" || method.returnType.name == "int";
}

// ---- Pass 1: collect every class's fields, methods and constructor. ----
void SemanticAnalyzer::registerClasses(const ast::Program& program) {
    // Value types first: a field can name a struct/record declared further down, and `keyFieldKind` has
    // to tell "a nested value" from "a reference to another object" to answer at all.
    valueTypeNames_.clear();
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& n : b.namespaces) {
            for (const ast::ClassDecl& c : n.classes) {
                if ((c.isStruct || c.isRecord) && !c.isUnion) {
                    valueTypeNames_.insert(c.name);
                }
            }
        }
    }
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                // A REDECLARATION IS THE SAME NAME IN THE SAME NAMESPACE, and this asked only about
                // the name. That was the same question while a name could exist once, and stopped
                // being it when two namespaces could each hold a `Scanner`: `Main.App.Scanner` beside
                // `System.Text.Scanner` is not a redeclaration, it is the thing the whole type-identity
                // work exists to allow, and the language's own rule ("yours wins") already said so in
                // a warning while this said the opposite in an error.
                const bool sameNamespaceClash =
                    classes_.count(cls.name) > 0 && typeNamespace_.count(cls.name) > 0 &&
                    typeNamespace_[cls.name] == ns.name && typeBundle_.count(cls.name) > 0 &&
                    typeBundle_[cls.name] == bundle.name;
                if (auto prev = classes_.find(cls.name);
                    prev != classes_.end() && sameNamespaceClash) {
                    // Point at whichever of the two the AUTHOR wrote. A user type colliding with a
                    // stdlib one used to be reported wherever the displaced type was USED, which for
                    // a stdlib type is inside the prelude -- so declaring `class File` produced four
                    // errors at `<prelude>:197` telling the standard library to import your class.
                    const bool mine = !bundle.isPrelude;
                    const SourceLocation at = mine ? cls.loc : prev->second.declLoc;
                    const std::string other =
                        (mine == prev->second.fromPrelude) ? "the standard library" : "your program";
                    error("'" + cls.name + "' is already declared by " + other +
                              " -- a type name is unique across the whole program, so this one takes "
                              "the other over and everything that used it breaks somewhere else. "
                              "Rename this type",
                          at);
                    continue;
                }
                // Freestanding has no standard library, so there is nothing for a shadowed builtin
                // to break: the program simply loses its own access to a builtin it could not have
                // called anyway (spec 36 rejects the hosted ones outright). The pico kernel declares
                // `class Process`, which is exactly the right name for a kernel's process, and
                // forbidding it would be a rule with no reason behind it.
                if (!bundle.isPrelude && !freestanding_ && builtinTypes_.count(cls.name) > 0) {
                    // The compiler answers for this name itself; there is no class to redeclare, so
                    // nothing above catches it and the name is simply taken over.
                    error("'" + cls.name +
                              "' is a type the compiler provides (spec 34), so it cannot also be a "
                              "class here -- declaring it takes the name over for the whole program, "
                              "including the standard library's own uses of it. Rename this type",
                          cls.loc);
                    continue;
                }
                ClassInfo info;
                info.name = cls.name;
                info.declLoc = cls.loc;
                info.fromPrelude = bundle.isPrelude;
                info.superclass = cls.superclass;
                info.interfaces = cls.interfaces;
                info.isAbstract = cls.isAbstract;
                info.isFinal = cls.isFinal;
                info.isInterface = cls.isInterface;
                info.isStruct = cls.isStruct;
                info.isSealed = cls.isSealed;
                info.isRegionClass = cls.isRegionClass;
                info.permits = cls.permits;
                info.isMovable = cls.isMovable;
                info.isUnique = cls.isUnique;
                info.isPartitionable = cls.isPartitionable;
                // `unique` + `partitionable` is contradictory (spec 19.9): unique keeps a
                // single live reference to the whole object; partitionable hands out
                // independent references to its parts.
                if (cls.isUnique && cls.isPartitionable) {
                    error("'unique' and 'partitionable' are contradictory: 'unique' guarantees a "
                          "single live reference to the whole object, 'partitionable' allows moving "
                          "its fields separately (spec 19.9)",
                          cls.loc);
                }
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        // A name is unique within a class, and a silent duplicate here is worse
                        // than the method case: the layout gets a slot per declaration while every
                        // `this.name` resolves to the last one, so the earlier slot is storage that
                        // is never written and never read. If its type is owned, the destructor is
                        // handed uninitialised memory to free.
                        if (info.fields.count(f->name)) {
                            error("field '" + f->name + "' is already declared in class '" +
                                      cls.name +
                                      "' -- each field name must be unique, and a second declaration "
                                      "silently takes over every use of the name while leaving the "
                                      "first one as dead storage. Remove one of them",
                                  f->loc);
                        }
                        // A movable/unique field is reassignable (it is moved out and reassigned).
                        info.fields[f->name] =
                            FieldInfo{typeRefStr(f->type), f->isMutable || f->isMovable || f->isUnique,
                                      f->isStatic, f->isMovable, f->isUnique, f->bitWidth,
                                      f->isVolatile};
                        // Set after the aggregate rather than inside it: the brace list is positional
                        // and already long enough that a reader cannot check it at a glance.
                        info.fields[f->name].visibility = f->visibility;
                        info.fields[f->name].owner = cls.name;
                        info.fields[f->name].isWeak = f->isWeak;
                        // `atomic<T>` is one `lock`-prefixed instruction when T fits in a word, and
                        // a call to `__atomic_load`/`__atomic_store` when it does not. Bare metal
                        // there is nothing to link those against, so the declaration compiles and
                        // the KERNEL fails at link time naming a symbol the author never wrote.
                        // Refuse it here, where the type is written.
                        //
                        // Only a type we can SEE is wide is refused -- a class, a struct, a record.
                        // An unresolved name is left alone on purpose: inside a generic template
                        // `atomic<T>` mangles with the parameter's name still in it, and rejecting
                        // that would reject every correct instantiation along with the wrong one.
                        if (freestanding_) {
                            const std::string ft = baseType(typeRefStr(f->type));
                            if (ft.rfind("atomic$", 0) == 0) {
                                const std::string arg = ft.substr(7);
                                if (classes_.count(arg) > 0 || arg == "Decimal") {
                                    error("`atomic<" + arg + ">` is wider than a machine word, so it "
                                          "lowers to `__atomic_*` library calls -- and freestanding "
                                          "has no library to link them against. The failure would "
                                          "surface as an unresolved symbol in the kernel, naming "
                                          "nothing the author wrote. Make the field a word-sized "
                                          "`atomic` (an int, a flag, an index) and guard the rest "
                                          "with it.",
                                          f->loc);
                                }
                            }
                        }
                        checkBitField(cls, *f,
                                      [this](const std::string& m, const SourceLocation& l) {
                                          error(m, l);
                                      });
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        // Polaron has no method overloading -- a name is unique within a class. A silent
                        // duplicate (last-wins in this map) makes codegen emit two same-named functions;
                        // LLVM renames the second to `.1`, and -g then emits a duplicate DISubprogram
                        // (invalid DWARF). A property get/set pair legitimately shares a name, so only two
                        // plain methods collide.
                        if (auto prev = info.methods.find(m->name);
                            prev != info.methods.end() && !prev->second.isProperty && !m->isProperty) {
                            // An interrupt is nameless in the source, so "each method name must be
                            // unique" would explain a rule the author never invoked. The real rule
                            // is the one the namelessness expresses: one device, one handler.
                            if (m->isInterrupt && prev->second.isInterrupt) {
                                error("class '" + cls.name + "' already declares an interrupt -- one "
                                      "device, one handler. A second handler means a second object; "
                                      "if these are two vectors of one device, dispatch on the trap.",
                                      m->loc);
                            } else {
                                error("method '" + m->name + "' is already declared in class '" +
                                          cls.name +
                                          "' -- Polaron has no method overloading, so each method name "
                                          "must be unique",
                                      m->loc);
                            }
                        }
                        MethodInfo mi{typeRefStr(m->returnType), m->isStatic,
                                      m->isAbstract, m->isProperty,
                                      m->params.size(), m->isFinal, m->isAsync};
                        for (const ast::Param& p : m->params) {
                            mi.paramTypes.push_back(typeRefStr(p.type));
                        }
                        for (const ast::Param& p : m->params) {
                            mi.comptimeParams.push_back(p.isComptime);
                        }
                        for (const ast::Param& p : m->params) {
                            mi.paramNames.push_back(p.name);
                        }
                        for (const ast::Param& p : m->params) {
                            mi.namedOnlyParams.push_back(p.requiresNamed);
                        }
                        for (const ast::Param& p : m->params) {
                            mi.moveParams.push_back(p.type.isMove);
                        }
                        mi.returnIsMove = m->returnType.isMove;
                        mi.isVariadic = m->isVariadic;
                        mi.isExtern = m->isExtern;
                        mi.isDeprecated = m->isDeprecated;
                        mi.isInterrupt = m->isInterrupt;
                        mi.visibility = m->visibility;
                        mi.owner = cls.name;
                        info.methods[m->name] = std::move(mi);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        // One constructor per class, for the same reason there is one method per
                        // name: Polaron has no overloading. A second one was accepted in silence and
                        // its parameters were APPENDED to the first's, so `P(int)` next to
                        // `P(int, int)` produced a three-parameter phantom and `new P(1)` was
                        // rejected with "expects 3 arguments" -- a message with no relation to the
                        // mistake, pointing at the call instead of the declaration. Codegen then
                        // emitted only the first, so even a program that satisfied the phantom ran
                        // the wrong body.
                        if (info.hasConstructor) {
                            error("class '" + cls.name +
                                      "' already has a constructor -- Polaron has no overloading, so a "
                                      "class has exactly one. Give the alternatives distinct names "
                                      "as static factory methods, or take one constructor with the "
                                      "widest parameter list",
                                  c->loc);
                        }
                        info.hasConstructor = true;
                        info.ctorVisibility = c->visibility;
                        if (!c->params.empty()) {
                            info.ctorHasParams = true;
                        }
                        for (const ast::Param& p : c->params) {
                            info.ctorParamTypes.push_back(typeRefStr(p.type));
                        }
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) != nullptr) {
                        info.hasDestructor = true;
                    }
                }
                // A class can want two incompatible orders at once, and until now it got one of them in
                // silence. A PARTIAL constructor (spec 18.9) takes an omitted parameter's value FROM the
                // persistent block, so the block must be attached BEFORE the constructor runs. An
                // identity key is made of the class's value fields, which the constructor is what fills
                // in -- so it can only be known AFTER. Both are legitimate; they cannot both be honoured.
                //
                // The partial constructor wins, because it is the one that would otherwise break. Say so,
                // rather than letting a class that looks keyed quietly not be.
                if (!bundle.isPrelude) {
                    std::vector<std::string> persistNames;
                    bool hasKeyField = false, partialCapable = false;
                    for (const ast::MemberPtr& m : cls.members) {
                        if (const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get());
                            f != nullptr && !f->isStatic) {
                            if (f->isPersistent) {
                                persistNames.push_back(f->name);
                            } else if (ast::keyFieldKind(f->type, valueTypeNames_) !=
                                       ast::KeyFieldKind::None) {
                                hasKeyField = true;
                            }
                        }
                    }
                    if (!persistNames.empty() && hasKeyField) {
                        for (const ast::MemberPtr& m : cls.members) {
                            if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
                                for (const ast::Param& p : c->params) {
                                    if (std::find(persistNames.begin(), persistNames.end(), p.name) !=
                                        persistNames.end()) {
                                        partialCapable = true;
                                    }
                                }
                                break;
                            }
                        }
                    }
                    if (partialCapable) {
                        warn("'" + cls.name + "' has value fields that would key its persistents by "
                             "identity, but its constructor takes a parameter named after a persistent "
                             "field -- a partial constructor (spec 18.9), which reads that value out of "
                             "the block before it runs. The block cannot be chosen before the identity "
                             "exists, so this class keeps the per-binding form. Rename the parameter if "
                             "you wanted the persistents keyed by identity instead",
                             cls.loc);
                    }
                }
                const std::uint32_t id = internType(cls.name, bundle.name, ns.name, cls.loc);
                info.ns = ns.name;
                info.bundle = bundle.name;
                // A SECOND TYPE OF THE SAME NAME NO LONGER ERASES THE FIRST.
                //
                // `classes_[cls.name] = info` is one slot, so the second declaration overwrote the
                // first outright -- which never showed, because a pass upstream renamed them apart
                // before the analyzer ever saw both. Take that pass away and this line loses a type
                // in silence.
                //
                // The bare name keeps the FIRST declaration, so every existing lookup is unchanged
                // and costs exactly what it did. The rest go under their canonical name, where
                // `lookupClass` finds them by asking which namespace is asking.
                if (classes_.count(cls.name) == 0) {
                    classes_[cls.name] = std::move(info);
                    typeNamespace_[cls.name] = ns.name;
                    typeBundle_[cls.name] = bundle.name;
                } else {
                    classes_[types_[id].canonical] = std::move(info);
                    typeNamespace_[types_[id].canonical] = ns.name;
                    typeBundle_[types_[id].canonical] = bundle.name;
                }
            }
        }
    }
}

void SemanticAnalyzer::registerNewtypes(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            // A TRANSFORMER MUST BE IMPORTABLE, or it can only be applied in the file that declares
            // it. It is not a type -- it is never instantiated and never names a value -- but
            // `applies TRoster` in another file is exactly the ordinary thing to do with one, and
            // the import validator answers from this registry. Without it the whole feature was
            // single-file, which is the opposite of "a transformer is the coupling between two
            // types": the two types are rarely in the same file, and neither is the coupling.
            for (const ast::ClassDecl& t : ns.transformers) {
                typeNamespace_[t.name] = ns.name;
                typeBundle_[t.name] = bundle.name;
            }
            for (const ast::TypeAliasDecl& a : ns.typeAliases) {
                if (!a.isNewtype) {
                    continue;  // `typealias` is resolved before sema; only newtypes survive
                }
                if (newtypes_.count(a.name) > 0 || classes_.count(a.name) > 0 ||
                    enums_.count(a.name) > 0) {
                    error("redeclaration of type '" + a.name + "'", a.loc);
                    continue;
                }
                const std::string under = typeRefStr(a.target);
                checkBitCounted(under, a.target.loc);  // newtype over int64 etc. is freestanding-only
                newtypes_[a.name] = under;
                // A NEWTYPE IS A TYPE, SO IT CAN BE IMPORTED. Without this the import validator --
                // which answers from `typeNamespace_` -- reported `import Agents.Sim.BeastId;` as an
                // unknown symbol, so a newtype could only be used in the file that declared it. That
                // is the opposite of what it is for: the whole point is to carry a distinct type
                // ACROSS a seam, and every seam in a real program crosses a file.
                typeNamespace_[a.name] = ns.name;
                typeBundle_[a.name] = bundle.name;
            }
        }
    }
}

void SemanticAnalyzer::registerAnnotations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::AnnotationDecl& a : ns.annotationDecls) {
                // An annotation and a CLASS may share a name: they are used in different positions and
                // never confused (`@Test` marks a method; `Test.assertEqual(...)` calls a static method).
                // The stdlib relies on it -- spec 32.11 calls both of them System.Test.Test. A clash with
                // an enum/newtype/another annotation is still a redeclaration.
                if (annotations_.count(a.name) > 0 || enums_.count(a.name) > 0 ||
                    newtypes_.count(a.name) > 0) {
                    error("redeclaration of type '" + a.name + "'", a.loc);
                    continue;
                }
                // AN ANNOTATION IS A DECLARED TYPE, so it has to be importable like one.
                //
                // It was in no registry the import validator reads, so `import System.Validate
                // .NotEmpty;` failed with "import of unknown symbol" -- which meant an annotation
                // could only ever be used in the file that declared it. Every library annotation in
                // existence is therefore unusable by anybody, which is not a property anyone would
                // have chosen; it simply never came up, because the annotations that shipped were
                // the compiler's own (`[Test]`, `[Serializable]`) and those resolve without one.
                // Its OWN registry, not `typeNamespace_`: an annotation and a class may share a name
                // by design (see just above), so writing it into the type map would answer the
                // question "where does the class `Range` live" with the annotation's namespace and
                // break the class's import instead.
                annotationNamespace_[a.name] = ns.name;
                annotationBundle_[a.name] = bundle.name;
                AnnotationInfo info;
                info.isCompileTimeProcessor = a.isCompileTimeProcessor;
                std::unordered_set<std::string> seen;
                for (const ast::AnnotationField& f : a.fields) {
                    if (!seen.insert(f.name).second) {
                        error("duplicate field '" + f.name + "' in annotation '" + a.name + "'",
                              f.loc);
                        continue;
                    }
                    info.fields.emplace_back(f.name, typeRefStr(f.type));
                    if (f.defaultValue == nullptr) {
                        info.required.insert(f.name);
                    }
                }
                annotations_[a.name] = std::move(info);
            }
        }
    }
}

// Validates one declaration's applied annotations against the declared annotation types (spec 14.3):
// the annotation must exist, every named argument must be a real field, with no duplicates, and
// every required field (one without a default) must be supplied.
void SemanticAnalyzer::checkAnnotationUses(const std::vector<ast::AnnotationUse>& uses) {
    for (const ast::AnnotationUse& use : uses) {
        if (use.name == "CompileTimeProcessor") {  // built-in (spec 14.4): a marker, takes no args
            if (!use.args.empty()) {
                error("'[CompileTimeProcessor]' takes no arguments", use.loc);
            }
            continue;
        }
        // Compiler attributes (spec 36.4): `[[no_bounds_check]]` -- a named, explicit opt-out of the
        // runtime bounds check on a hot path. Not a user annotation, so it needs no declaration.
        if (use.name == "no_bounds_check") {
            if (!use.args.empty()) {
                error("'[[no_bounds_check]]' takes no arguments", use.loc);
            }
            continue;
        }
        auto it = annotations_.find(use.name);
        if (it == annotations_.end()) {
            error("unknown annotation '" + use.name + "'", use.loc);
            continue;
        }
        const AnnotationInfo& info = it->second;
        std::unordered_set<std::string> provided;
        for (const ast::AnnotationArg& arg : use.args) {
            const bool isField = std::any_of(info.fields.begin(), info.fields.end(),
                                             [&](const auto& f) { return f.first == arg.name; });
            if (!isField) {
                error(diag::Code::AnnotationMisuse,
                      "annotation '" + use.name + "' has no field '" + arg.name + "'", arg.loc);
                continue;
            }
            if (!provided.insert(arg.name).second) {
                error(diag::Code::AnnotationMisuse,
                      "duplicate argument '" + arg.name + "' for annotation '" + use.name + "'",
                      arg.loc);
            }
        }
        for (const std::string& req : info.required) {
            if (provided.count(req) == 0) {
                error(diag::Code::AnnotationMisuse,
                      "annotation '" + use.name + "' requires a value for field '" + req + "'",
                      use.loc);
            }
        }
    }
}

void SemanticAnalyzer::validateAnnotations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& c : ns.classes) {
                checkAnnotationUses(c.annotations);
                for (const ast::MemberPtr& m : c.members) {
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                        checkAnnotationUses(md->annotations);
                    } else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
                        checkAnnotationUses(fd->annotations);
                    }
                }
            }
        }
    }
}

namespace {
// The string value of an annotation argument, e.g. the "..." of [Cases(source: "...")].
std::string annotationText(const ast::AnnotationUse& use, const std::string& field) {
    for (const ast::AnnotationArg& a : use.args) {
        if (a.name == field) {
            if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(a.value.get())) {
                return s->value;
            }
        }
    }
    return "";
}
long long annotationNumber(const ast::AnnotationUse& use, const std::string& field,
                           long long fallback) {
    for (const ast::AnnotationArg& a : use.args) {
        if (a.name == field) {
            if (const auto* i = dynamic_cast<const ast::IntLiteralExpr*>(a.value.get())) {
                try {
                    return std::stoll(i->text, nullptr, 0);
                } catch (const std::exception&) {
                    return fallback;
                }
            }
        }
    }
    return fallback;
}
}  // namespace

// spec 32.11: every test declaration is well formed. This runs on EVERY compile, not only under
// --test, because a `[Test]` that cannot be called is a broken declaration whichever way you build --
// and finding out at build time (or in the editor, through `polaron check`) beats finding out on the day
// someone runs the suite and quietly gets one test fewer than they wrote.
// Which classes own a fixture. Runs before the bodies, because the warning about reading somebody
// else's fixture is raised where the call is checked.
void SemanticAnalyzer::collectFixtureOwners(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) {
                        continue;
                    }
                    // `cdecl` pointed at a symbol that is plainly NOT C.
                    //
                    // LODGED IN THE WRONG PASS, and said here rather than hidden: this is
                    // `collectFixtureOwners`, whose name describes test fixtures and not the FFI. It
                    // is the walk that reaches every method declaration, which is why the check works
                    // here -- and a check whose home is "wherever the loop already was" is how a pass
                    // stops meaning what it is called. It belongs in a declaration-checking pass of
                    // its own.
                    //
                    // The FFI axis names the LANGUAGE on the other side, and the compiler cannot in
                    // general know what a symbol was written in -- but it can know when the evidence
                    // is in the name. A MANGLED symbol carries a signature: `_ZN3Foo3barEv` is
                    // Itanium, `?bar@Foo@@QEAAXXZ` is MSVC, and neither is producible by a C
                    // compiler. So `cdecl` over one is a declaration that disagrees with the thing it
                    // names -- and the way that goes wrong (an argument in the wrong place, a `this`
                    // that is not there) is not a link error but a crash somewhere else entirely.
                    //
                    // A WARNING and not an error, deliberately: pasting a mangled symbol by hand is
                    // exactly how a C++ binding works without a mangler of our own, so this may be
                    // only the wrong word on a declaration that otherwise does the right thing.
                    if (m->isExtern && m->externConvention == "cdecl" && !m->externSymbol.empty()) {
                        const std::string& sym = m->externSymbol;
                        const bool itanium = sym.rfind("_Z", 0) == 0;
                        const bool msvc = sym[0] == '?';
                        if (itanium || msvc) {
                            warn("'" + m->name + "' is declared `cdecl` -- C -- but the symbol it binds, '" +
                                     sym + "', is " + (itanium ? "an Itanium" : "an MSVC") +
                                     " MANGLED name, which a C compiler cannot produce. If the other "
                                     "side is C++, say `cppdecl`: the difference is not the symbol but "
                                     "how aggregates travel and whether a receiver is passed",
                                 m->loc);
                        }
                    }
                    for (const ast::AnnotationUse& a : m->annotations) {
                        if (a.name == "BeforeAll" || a.name == "AfterAll") {
                            fixtureOwners_.insert(cls.name);
                        }
                    }
                }
            }
        }
    }
}

void SemanticAnalyzer::validateTestDeclarations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                std::map<std::string, std::string> hookOwner;  // hook kind -> the method holding it
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) {
                        continue;
                    }
                    const std::string sym = cls.name + "." + m->name;

                    bool isTest = false;
                    const ast::AnnotationUse* ignore = nullptr;
                    const ast::AnnotationUse* cases = nullptr;
                    const ast::AnnotationUse* repeat = nullptr;
                    const ast::AnnotationUse* bench = nullptr;
                    std::string hook;
                    for (const ast::AnnotationUse& a : m->annotations) {
                        if (a.name == "Test") {
                            isTest = true;
                        } else if (a.name == "Ignore") {
                            ignore = &a;
                        } else if (a.name == "Cases") {
                            cases = &a;
                        } else if (a.name == "Repeat") {
                            repeat = &a;
                        } else if (a.name == "Benchmark") {
                            bench = &a;
                        } else if (a.name == "BeforeAll" || a.name == "AfterAll" || a.name == "Setup" ||
                                   a.name == "Teardown") {
                            hook = a.name;
                        }
                    }

                    if (!hook.empty()) {
                        if (isTest) {
                            error("'[" + hook + "]' and '[Test]' cannot mark the same method '" + sym +
                                      "': a hook runs around the tests, so it cannot be one of them",
                                  m->loc);
                            continue;
                        }
                        if (!m->isStatic || typeRefStr(m->returnType) != "void") {
                            error("'[" + hook + "]' method '" + sym +
                                      "' must be a public static method returning void",
                                  m->loc);
                            continue;
                        }
                        auto [it, fresh] = hookOwner.emplace(hook, sym);
                        if (!fresh) {
                            error("class '" + cls.name + "' already has a '[" + hook + "]' method ('" +
                                      it->second + "'); there may be only one, because two would have "
                                      "no defined order",
                                  m->loc);
                        }
                        continue;
                    }

                    if (bench != nullptr) {
                        if (isTest) {
                            error("'[Benchmark]' and '[Test]' cannot mark the same method '" + sym +
                                      "': a benchmark measures, a test judges",
                                  m->loc);
                            continue;
                        }
                        if (!m->isStatic || typeRefStr(m->returnType) != "void" || !m->params.empty()) {
                            error("'[Benchmark]' method '" + sym +
                                      "' must be a public static method taking no arguments and "
                                      "returning void",
                                  m->loc);
                        } else if (annotationNumber(*bench, "iterations", 1000) < 1) {
                            error("'[Benchmark(iterations: ...)]' on '" + sym +
                                      "' needs at least 1 iteration",
                                  bench->loc);
                        }
                        continue;
                    }

                    if (!isTest) {
                        if (ignore != nullptr) {
                            error("'[Ignore]' on '" + sym +
                                      "' has no effect: it only applies to a '[Test]' method",
                                  m->loc);
                        }
                        if (cases != nullptr) {
                            error("'[Cases]' on '" + sym +
                                      "' has no effect: it only applies to a '[Test]' method",
                                  m->loc);
                        }
                        continue;
                    }

                    const std::string ret = typeRefStr(m->returnType);
                    if (!m->isStatic || (ret != "boolean" && ret != "void")) {
                        error("[Test] method '" + sym +
                                  "' must be a public static method returning boolean (the test's own "
                                  "verdict) or void (the verdict comes from its Test.assert* calls)",
                              m->loc);
                        continue;
                    }
                    if (repeat != nullptr && annotationNumber(*repeat, "times", 1) < 1) {
                        error("'[Repeat(times: ...)]' on '" + sym + "' needs a count of at least 1",
                              repeat->loc);
                    }
                    validateTestCases(cls, *m, cases, sym);
                }
            }
        }
    }
}

// The [Cases] half of the check above: a parametrized test takes exactly one parameter, and its
// source must be a static method of the same class returning an array of that parameter's type.
void SemanticAnalyzer::validateTestCases(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                                         const ast::AnnotationUse* cases, const std::string& sym) {
    if (cases == nullptr) {
        if (!m.params.empty()) {
            error("[Test] method '" + sym +
                      "' takes parameters, so it needs a '[Cases(source: \"...\")]' naming the static "
                      "method that supplies its rows",
                  m.loc);
        }
        return;
    }
    if (m.params.size() != 1) {
        error("'[Cases]' test '" + sym +
                  "' must take exactly one parameter (it is called once per row); group several "
                  "values into a record and take that",
              m.loc);
        return;
    }
    const std::string source = annotationText(*cases, "source");
    if (source.empty()) {
        error("'[Cases]' on '" + sym + "' needs a source: [Cases(source: \"methodName\")]", cases->loc);
        return;
    }
    const std::string want = typeRefStr(m.params.front().type);
    const ast::MethodDecl* src = nullptr;
    for (const ast::MemberPtr& member : cls.members) {
        const auto* cand = dynamic_cast<const ast::MethodDecl*>(member.get());
        if (cand != nullptr && cand->name == source) { src = cand; break; }
    }
    if (src == nullptr) {
        error("'[Cases]' source '" + source + "' is not a method of class '" + cls.name + "'",
              cases->loc);
        return;
    }
    const std::string got = typeRefStr(src->returnType);
    if (!src->isStatic || got != want + "[]") {
        error("'[Cases]' source '" + cls.name + "." + source +
                  "' must be a public static method returning '" + want + "[]' to match the parameter "
                  "of '" + sym + "' (it returns '" + got + "')",
              src->loc);
    }
}

void SemanticAnalyzer::registerEnums(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ExternDecl& ex : ns.externs) {  // external C functions (spec 26)
                // A namespace-level extern is a free declaration outside a class; an extern must be a
                // static class member (`public extern <conv> static method ...`). Still registered so
                // its uses resolve and do not cascade.
                error("an 'extern' declaration must be a static class member; declare it inside a "
                      "class",
                      ex.loc);
                externReturns_[ex.name] = typeRefStr(ex.returnType);
                externParamCount_[ex.name] = ex.params.size();
            }
            // A class extern method is reachable by its bare C symbol for `goto` (spec 7.9).
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
                        md != nullptr && md->isExtern) {
                        externReturns_[md->name] = typeRefStr(md->returnType);
                        externParamCount_[md->name] = md->params.size();
                    }
                }
            }
            for (const ast::EnumDecl& en : ns.enums) {
                // A java-style enum is desugared into a class of the same name, so
                // its matching class entry is expected; only flag other clashes.
                //
                // AND IT IS A CLASH ONLY IN THE SAME NAMESPACE. The check asked whether the NAME was
                // taken, which was the same question while every name was unique -- and stopped being
                // it the moment two namespaces could each hold a `Color`. Declaring one beside the
                // standard library's is not a redeclaration; it is the case the whole type-identity
                // work exists to allow.
                const bool clashHere =
                    (enums_.count(en.name) > 0 && typeNamespace_.count(en.name) > 0 &&
                     typeNamespace_[en.name] == ns.name) ||
                    (catalogs_.count(en.name) > 0 && typeNamespace_.count(en.name) > 0 &&
                     typeNamespace_[en.name] == ns.name) ||
                    (!en.isJavaStyle && classes_.count(en.name) > 0 &&
                     typeNamespace_.count(en.name) > 0 && typeNamespace_[en.name] == ns.name);
                if (clashHere) {
                    error("redeclaration of type '" + en.name + "'", en.loc);
                    continue;
                }
                // Reject duplicate constant names (own constants and byCatalog values share
                // one ordinal space; a repeat would create a hidden, unreachable constant).
                for (std::size_t i = 0; i < en.constants.size(); ++i) {
                    for (std::size_t j = i + 1; j < en.constants.size(); ++j) {
                        if (en.constants[i] == en.constants[j]) {
                            error("duplicate enum constant '" + en.constants[i] + "' in enum '" +
                                      en.name + "'",
                                  en.loc);
                        }
                    }
                }
                enums_[en.name] = en.constants;
                internType(en.name, bundle.name, ns.name, en.loc);
                if (en.isSealed) {
                    sealedEnums_.insert(en.name);
                }
                if (en.isJavaStyle) {
                    javaEnums_.insert(en.name);
                }
                if (!en.extendsCatalogs.empty()) {
                    enumCatalogs_[en.name] = en.extendsCatalogs;
                }
                // Methods declared on the enum (e.g. catalog method impls) -- recorded so
                // `value.method()` resolves and the bodies get type-checked.
                for (const ast::MemberPtr& member : en.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        enumMethods_[en.name][m->name] =
                            MethodInfo{typeRefStr(m->returnType), m->isStatic, m->isAbstract,
                                       m->isProperty};
                        enumMethodParams_[en.name][m->name] = m->params.size();
                    }
                }
                typeNamespace_[en.name] = ns.name;
                typeBundle_[en.name] = bundle.name;
            }
            // A TRANSFORMER IS IMPORTABLE, though it is never a type.
            //
            // It is resolved by simple name in the expansion pass, which runs long before any import
            // is looked at, so `applies` would work with no import at all -- and that is exactly why
            // it has to be registered here. Polaron's rule is that a name from another bundle is
            // written down where it enters, and a declaration that quietly opted out of it would be
            // the only one in the language that did. Registered as a name, not as a type: nothing
            // adds it to `classes_`, so no variable can be declared of it.
            for (const ast::ClassDecl& t : ns.transformers) {
                typeNamespace_[t.name] = ns.name;
                typeBundle_[t.name] = bundle.name;
            }
        }
    }
}

// Registers each catalog's value/method contract so enums can implement it and
// catalog types participate in subtyping (spec 12.3).
void SemanticAnalyzer::registerCatalogs(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::CatalogDecl& cat : ns.catalogs) {
                if (catalogs_.count(cat.name) > 0 || classes_.count(cat.name) > 0 ||
                    enums_.count(cat.name) > 0) {
                    error("redeclaration of type '" + cat.name + "'", cat.loc);
                    continue;
                }
                // Reject duplicate required-value names in the catalog itself.
                for (std::size_t i = 0; i < cat.requiredValues.size(); ++i) {
                    for (std::size_t j = i + 1; j < cat.requiredValues.size(); ++j) {
                        if (cat.requiredValues[i] == cat.requiredValues[j]) {
                            error("duplicate catalog value '" + cat.requiredValues[i] +
                                      "' in catalog '" + cat.name + "'",
                                  cat.loc);
                        }
                    }
                }
                CatalogInfo info;
                info.requiredValues = cat.requiredValues;
                info.extendsCatalogs = cat.extendsCatalogs;
                for (const ast::MemberPtr& member : cat.methods) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        info.methodNames.push_back(m->name);
                    }
                }
                catalogs_[cat.name] = std::move(info);
                typeNamespace_[cat.name] = ns.name;
                typeBundle_[cat.name] = bundle.name;
                internType(cat.name, bundle.name, ns.name, cat.loc);
            }
        }
    }
}

// Validates that every enum implementing a catalog satisfies its contract: the
// catalog exists, the `byCatalog` block covers exactly the required values, and
// every required method is implemented (spec 12.4). Also checks catalog->catalog
// extends targets exist.
void SemanticAnalyzer::validateCatalogs(const ast::Program& program) {
    // Catalog `extends` targets must be catalogs.
    for (const auto& [name, info] : catalogs_) {
        for (const std::string& parent : info.extendsCatalogs) {
            if (catalogs_.count(parent) == 0) {
                error("catalog '" + name + "' extends unknown catalog '" + parent + "'", {});
            }
        }
    }
    // A catalog `extends` cycle makes the contract ill-defined (and would make the
    // transitive walk below loop). Detect and report it (cf. class cycle detection).
    for (const auto& [name, info] : catalogs_) {
        std::unordered_set<std::string> visited;
        std::vector<std::string> stack(info.extendsCatalogs.begin(), info.extendsCatalogs.end());
        bool cyclic = false;
        while (!stack.empty()) {
            const std::string cur = stack.back();
            stack.pop_back();
            if (cur == name) { cyclic = true; break; }
            if (!visited.insert(cur).second) {
                continue;
            }
            if (auto it = catalogs_.find(cur); it != catalogs_.end()) {
                for (const auto& p : it->second.extendsCatalogs) {
                    stack.push_back(p);
                }
            }
        }
        if (cyclic) {
            error("catalog cycle involving '" + name + "'", {});
        }
    }
    // Collects a catalog's required values and methods transitively through its
    // `extends` parents (deduped); the visited set bounds it against any cycle.
    std::function<void(const std::string&, std::unordered_set<std::string>&, std::vector<std::string>&,
                       std::vector<std::string>&)>
        collect = [&](const std::string& catName, std::unordered_set<std::string>& seen,
                      std::vector<std::string>& vals, std::vector<std::string>& meths) {
            if (!seen.insert(catName).second) {
                return;
            }
            auto cit = catalogs_.find(catName);
            if (cit == catalogs_.end()) {
                return;
            }
            for (const auto& v : cit->second.requiredValues) {
                if (std::find(vals.begin(), vals.end(), v) == vals.end()) {
                    vals.push_back(v);
                }
            }
            for (const auto& m : cit->second.methodNames) {
                if (std::find(meths.begin(), meths.end(), m) == meths.end()) {
                    meths.push_back(m);
                }
            }
            for (const auto& parent : cit->second.extendsCatalogs) {
                collect(parent, seen, vals, meths);
            }
        };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::EnumDecl& en : ns.enums) {
                if (en.extendsCatalogs.empty()) {
                    if (!en.byCatalogValues.empty()) {
                        error("enum '" + en.name +
                                  "' has a 'byCatalog' block but does not extend any catalog",
                              en.loc);
                    }
                    continue;
                }
                // Gather the transitive contract (values + methods) of every catalog the
                // enum extends, including grandparents reached via catalog->catalog extends.
                std::vector<std::string> requiredValues;
                std::vector<std::string> requiredMethods;
                std::unordered_set<std::string> seen;
                for (const std::string& catName : en.extendsCatalogs) {
                    if (catalogs_.count(catName) == 0) {
                        error("enum '" + en.name + "' extends unknown catalog '" + catName + "'",
                              en.loc);
                        continue;
                    }
                    collect(catName, seen, requiredValues, requiredMethods);
                }
                // byCatalog must cover exactly the required values: none missing, none extra.
                for (const std::string& req : requiredValues) {
                    if (std::find(en.byCatalogValues.begin(), en.byCatalogValues.end(), req) ==
                        en.byCatalogValues.end()) {
                        error("enum '" + en.name +
                                  "' must provide catalog value '" + req + "' in its 'byCatalog' block",
                              en.loc);
                    }
                }
                for (const std::string& provided : en.byCatalogValues) {
                    if (std::find(requiredValues.begin(), requiredValues.end(), provided) ==
                        requiredValues.end()) {
                        error("enum '" + en.name + "' lists '" + provided +
                                  "' in 'byCatalog', but no extended catalog requires it",
                              en.loc);
                    }
                }
                // Every required method must be implemented as a (non-static) instance
                // method of the enum -- a catalog method receives the enum value as `this`.
                // A java-style enum was desugared in the parser: its methods live on the
                // twin class of the same name in this namespace, so look there.
                const std::vector<ast::MemberPtr>* implMembers = &en.members;
                if (en.isJavaStyle) {
                    for (const ast::ClassDecl& cls : ns.classes) {
                        if (cls.name == en.name) {
                            implMembers = &cls.members;
                            break;
                        }
                    }
                }
                for (const std::string& req : requiredMethods) {
                    const ast::MethodDecl* impl = nullptr;
                    for (const ast::MemberPtr& member : *implMembers) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m != nullptr && m->name == req) { impl = m; break; }
                    }
                    if (impl == nullptr) {
                        error("enum '" + en.name + "' must implement catalog method '" + req + "'",
                              en.loc);
                    } else if (impl->isStatic) {
                        error("enum '" + en.name + "' implements catalog method '" + req +
                                  "' as static; catalog methods are instance methods",
                              impl->loc);
                    }
                }
            }
        }
    }
}

// ---- Pass 2: locate the single entry point (spec section 2.9). ----
void SemanticAnalyzer::findEntryPoint(const ast::Program& program) {
    std::vector<EntryPoint> candidates;
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.visibility != "public") {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            if (ns.visibility != "public") {
                continue;
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                // THE ENTRY POINT IS FOUND BY THE NAME THE AUTHOR WROTE. Qualification renames a
                // class to `Ns__Main`, and comparing against the bare "Main" then finds nothing --
                // reported as "this program has no entry point" to somebody looking straight at one.
                const std::string writtenName = typeAsWritten(cls.name);
                if (cls.visibility != "public" || writtenName != "Main") {
                    continue;
                }
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* method = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (method == nullptr || method->name != "main") {
                        continue;
                    }
                    if (isValidMainSignature(*method)) {
                        EntryPoint ep;
                        ep.method = method;
                        ep.qualifiedName =
                            bundle.name + "." + ns.name + "." + cls.name + "." + method->name;
                        candidates.push_back(std::move(ep));
                    }
                }
            }
        }
    }
    if (candidates.empty()) {
        if (libraryMode_ || testMode_) {
            return;  // a library (.polb) or a --test run needs no entry point
        }
        error("program '" + program.name +
                  "' has no entry point. Provide a public bundle with a public namespace "
                  "containing 'public class Main' with 'public static method "
                  "main(string[] args) returns void' (or int).",
              program.loc);
        return;
    }
    if (candidates.size() > 1) {
        error("program '" + program.name + "' has " + std::to_string(candidates.size()) +
                  " entry points; exactly one 'public static method main' is allowed.",
              program.loc);
        return;
    }
    entry_ = std::move(candidates.front());
}

// ---- Pass 3: type-check the body of every method and constructor. ----
// DEFINITE RELEASE -- the other half of definite assignment.
//
// A constructor must assign every field; nothing said anything about giving one back. A `region`
// field is memory the object OWNS, and when the object dies the region does not go with it unless
// somebody says so -- so a class with a region field and no `release region` in its destructor leaks
// the whole region, silently, on every instance. That is not hypothetical: it is the bug the pico
// kernel carried, and what fixes it is one line the compiler never asked for.
//
// This checks the two mistakes that actually happen -- no destructor at all, and a destructor that
// forgets a field. It does NOT yet check "released on only some paths": that needs a `Released` fact
// alongside `Init` in FlowFacts, which is where it should go when someone wants the early-return case
// too. Stated rather than implied, so nobody reads more assurance into it than it gives.
static void collectReleasedRegions(const ast::Stmt* s, std::set<std::string>& out);

static void collectReleasedInBlock(const ast::Block* b, std::set<std::string>& out) {
    if (b == nullptr) {
        return;
    }
    for (const ast::StmtPtr& st : b->statements) {
        collectReleasedRegions(st.get(), out);
    }
}

static void collectReleasedRegions(const ast::Stmt* s, std::set<std::string>& out) {
    if (s == nullptr) {
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(s)) {
        if (!rel->region.empty()) {
            // `release region this.store` and `release region store` name the same field.
            const std::size_t dot = rel->region.rfind('.');
            out.insert(dot == std::string::npos ? rel->region : rel->region.substr(dot + 1));
        }
        return;
    }
    // Anything with a body: a release inside an `if` still counts for "did you remember it at all".
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        collectReleasedInBlock(&ifs->thenBlock, out);
        if (ifs->elseBlock) {
            collectReleasedInBlock(ifs->elseBlock.get(), out);
        }
        return;
    }
    if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(s)) {
        collectReleasedInBlock(&wh->body, out);
        return;
    }
}

// WHAT A CLASS'S REGION FIELDS ACCEPT, READ BEFORE ANY METHOD IS ANALYZED.
//
// A region field is given its constraints where it is assigned -- `this.pen = itself.allocate(...)
// .accepts({Dog})`, in the constructor -- and constructors are analyzed AFTER the methods. So every
// method body was checked against a field region that had no constraints yet, and
// `checkRegionAccepts` took the "declares neither accepts nor rejects, so it takes anything" path:
// a `Pool<Dog>` accepted a `Cat` without a word. The whole promise of a typed arena -- the compiler
// refuses the wrong type at the point it is written -- was off by an ordering.
//
// So the constraints are collected in their own pass over the constructors first. Statement kinds
// with bodies are walked too, because an `accepts` written inside an `if` still types the region.
static void collectRegionFieldConstraints(
    const ast::Stmt* s, const std::string& cls,
    std::unordered_map<std::string, RegionConstraints>& out);

static void collectRegionFieldsInBlock(
    const ast::Block* b, const std::string& cls,
    std::unordered_map<std::string, RegionConstraints>& out) {
    if (b == nullptr) {
        return;
    }
    for (const ast::StmtPtr& st : b->statements) {
        collectRegionFieldConstraints(st.get(), cls, out);
    }
}

static void collectRegionFieldConstraints(
    const ast::Stmt* s, const std::string& cls,
    std::unordered_map<std::string, RegionConstraints>& out) {
    if (s == nullptr) {
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(as->value.get());
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(as->target.get());
        if (ri != nullptr && mem != nullptr) {
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                oid != nullptr && oid->name == "this") {
                out[cls + "." + mem->member] =
                    RegionConstraints{ri->accepts, ri->rejects};
            }
        }
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        collectRegionFieldsInBlock(&ifs->thenBlock, cls, out);
        if (ifs->elseBlock) {
            collectRegionFieldsInBlock(ifs->elseBlock.get(), cls, out);
        }
        return;
    }
    if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(s)) {
        collectRegionFieldsInBlock(&wh->body, cls, out);
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) {
        collectRegionFieldsInBlock(&fs->body, cls, out);
        return;
    }
}

// The body of a method of the class being analyzed, or null if there is no such method here (it may
// be inherited, or the call may be `super(...)` -- both of which the caller treats conservatively).
const ast::Block* SemanticAnalyzer::methodBodyInCurrentClass(const std::string& name) const {
    if (currentClassDecl_ == nullptr) {
        return nullptr;
    }
    for (const ast::MemberPtr& m : currentClassDecl_->members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
            md != nullptr && md->name == name && !md->isAbstract) {
            return &md->body;
        }
    }
    return nullptr;
}

// Which fields a helper actually assigns -- `this.f = ...` and, since `this.` is optional, a bare
// `f = ...` naming a field. Follows further helper calls with a visited set, because the common shape
// is a constructor calling one `init()` which calls `reset()`.
void SemanticAnalyzer::collectFieldsAssigned(const ast::Block* body, std::set<std::string>& assigned,
                                             std::set<std::string>& visited) const {
    if (body == nullptr || currentClassDecl_ == nullptr) {
        return;
    }
    const ClassInfo* ci = nullptr;
    if (auto it = classes_.find(currentClassDecl_->name); it != classes_.end()) {
        ci = &it->second;
    }
    std::function<void(const ast::Stmt*)> walkStmt;
    std::function<void(const ast::Block*)> walkBlock = [&](const ast::Block* b) {
        if (b == nullptr) {
            return;
        }
        for (const ast::StmtPtr& s : b->statements) {
            walkStmt(s.get());
        }
    };
    std::function<void(const ast::Expr*)> walkExpr = [&](const ast::Expr* e) {
        const auto* call = dynamic_cast<const ast::CallExpr*>(e);
        if (call == nullptr) {
            return;
        }
        std::string callee;
        if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(cm->object.get());
                oid != nullptr && oid->name == "this") {
                callee = cm->member;
            }
        } else if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            callee = cid->name;
        }
        if (callee.empty() || visited.count(callee) > 0) {
            return;
        }
        if (const ast::Block* nested = methodBodyInCurrentClass(callee); nested != nullptr) {
            visited.insert(callee);
            walkBlock(nested);
        }
    };
    walkStmt = [&](const ast::Stmt* s) {
        if (s == nullptr) {
            return;
        }
        if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(as->target.get())) {
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    oid != nullptr && oid->name == "this") {
                    assigned.insert(mem->member);
                }
            } else if (const auto* id =
                           dynamic_cast<const ast::IdentifierExpr*>(as->target.get())) {
                if (ci != nullptr && ci->fields.count(id->name) > 0) {
                    assigned.insert(id->name);
                }
            }
            return;
        }
        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) {
            walkExpr(es->expr.get());
            return;
        }
        if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
            walkBlock(&ifs->thenBlock);
            if (ifs->elseBlock) {
                walkBlock(ifs->elseBlock.get());
            }
            return;
        }
        if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(s)) {
            walkBlock(&wh->body);
            return;
        }
    };
    walkBlock(body);
}

void SemanticAnalyzer::analyzeFieldInits(const ast::ClassDecl& cls) {
    scopes_.clear();
    currentClass_ = cls.name;
    pushScope();
    {
        std::vector<std::pair<std::string, SourceLocation>> owned;  // region fields, in declaration order
        const ast::DestructorDecl* dtor = nullptr;
        for (const ast::MemberPtr& m : cls.members) {
            if (const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get())) {
                // `eternal` is the way out, and this is the first thing in the language that ever
                // FORCED anyone to reach for it. A kernel singleton -- the VGA, the framebuffer, the
                // device registry -- is never destroyed, so its region is never given back and that is
                // correct rather than a leak. `eternal region store` says so in the declaration, where
                // a reader sees it, instead of in a comment or in nobody's head. A prefix goes unused
                // when nothing asks the question; this asks it.
                if (typeRefStr(f->type) == "region" && !f->isStatic && !f->isEternal) {
                    owned.push_back({f->name, f->loc});
                }
            } else if (const auto* d = dynamic_cast<const ast::DestructorDecl*>(m.get())) {
                dtor = d;
            }
        }
        if (!owned.empty()) {
            std::set<std::string> released;
            if (dtor != nullptr) {
                collectReleasedInBlock(&dtor->body, released);
            }
            for (const auto& [fname, floc] : owned) {
                if (released.count(fname) > 0) {
                    continue;
                }
                // NAMED AS THE AUTHOR WROTE IT. `Kennel$Dog` is a generic INSTANCE the compiler
                // made, and telling somebody to add `~Kennel$Dog()` asks for a destructor they
                // cannot write -- the fix belongs on the template, `Kennel`. A message about code
                // has to name the code that exists in the file.
                const std::string shown = cls.name.substr(0, cls.name.find('$'));
                error(dtor == nullptr
                          ? "class '" + shown + "' owns the region field '" + fname +
                                "' and has no destructor, so the region is never given back -- every "
                                "instance leaks all of it. Add `public destructor ~" + shown +
                                "() returns void { release region this." + fname + "; }`"
                          : "the destructor of '" + shown + "' does not release the region field '" +
                                fname + "'. A region is memory this object owns; nothing gives it back "
                                "on its own. Add `release region this." + fname + ";`",
                      floc);
            }
        }
    }
    for (const ast::MemberPtr& member : cls.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
        if (f == nullptr) {
            continue;
        }
        // `transient` marks derived/scratch state, excluded from the object's canonical value (reset,
        // not copied, on a value copy; and not captured by serialization). `persistent` is the exact
        // opposite -- state that outlives the instance -- so the pair is a contradiction (spec).
        if (f->isTransient && f->isPersistent) {
            error("field '" + f->name + "' cannot be both 'transient' and 'persistent'", f->loc);
        }
        // `eternal` means ONE thing in this compiler: suppress the automatic teardown. An eternal
        // region never enters the scope's region list, and an eternal persistent never requires an
        // explicit release. A plain field has no teardown to suppress -- measured, the IR is
        // byte-identical with and without it -- so the word was being accepted and doing nothing.
        if (f->isEternal && !f->isPersistent && typeRefStr(f->type) != "region") {
            error("'eternal' has nothing to do on field '" + f->name +
                      "': it suppresses automatic teardown, and only a `region` or a `persistent` "
                      "field has any. Drop it, or say which of the two this is (spec 37.2).",
                  f->loc);
        }
        // spec 18.7 promises `in region X` places a field's storage in that region. It does not: the
        // emitted IR is byte-identical with and without it. A warning rather than an error because the
        // spec documents the syntax and code in this repository writes it -- but it says so, because
        // a placement clause that silently places nothing is a promise the compiler is not keeping.
        if (!f->inRegion.empty()) {
            warn("'in region " + f->inRegion + "' on field '" + f->name +
                     "' has no effect yet: the field keeps its ordinary storage (spec 18.7).",
                 f->loc);
        }
        // spec 32.2: a snapshot is a captured state, not a variable. Checked on the WRITTEN type name,
        // because `RegionSnapshot` canonicalizes to `address` and the two are indistinguishable after.
        if (f->isMutable && f->type.name == "RegionSnapshot") {
            error("a snapshot is constant: '" + f->name +
                      "' cannot be 'mutable'. It names a state that was captured; re-capturing is "
                      "`snapshot region <name> into " + f->name + ";` (spec 32.2).",
                  f->loc);
        }
        // `comptime T f = ...` (spec 37.4): the INITIALIZER is evaluated during compilation, so it has
        // to fold. This is not `fixed`, which is a class-level constant with no storage and no
        // `mutable` -- a comptime field is an ordinary field whose starting value costs nothing to
        // produce, which is what makes it worth having on a per-instance, mutable field.
        //
        // The guarantee is the point: a static field with a foldable initializer was ALREADY folded by
        // emitStaticFields, but by luck. `comptime` turns that into a promise the compiler keeps or
        // refuses, which is the difference between an optimization and a declaration.
        if (f->isComptime) {
            if (f->init == nullptr) {
                error("'comptime' needs an initializer to evaluate: field '" + f->name + "' has none.",
                      f->loc);
            } else {
                const std::string ft = typeRefStr(f->type);
                bool folds = false;
                if (isFloatType(ft)) {
                    double d;
                    folds = evalConstDouble(*f->init, d, &constDoubles_, &constInts_, &comptimeMethods_);
                } else {
                    long long v;
                    folds = evalConstInt(*f->init, v, &constInts_, &comptimeMethods_, &constDoubles_);
                }
                if (!folds) {
                    error("'comptime " + ft + " " + f->name +
                              "' must have an initializer the compiler can evaluate -- a literal, a "
                              "`fixed` constant, or a call to a `comptime` method (spec 37.4).",
                          f->loc);
                }
            }
        }
        // A `weak T*` observes an object by identity and auto-nulls when it dies, so its target must be a
        // heap/stack object with identity -- i.e. a pointer to a class. Reject `weak int`, `weak T` (not a
        // pointer) and `weak int*` (no identity, no weak-list head): the intrusive auto-null has nowhere to
        // hook. This keeps `weak` a precise tool rather than a footgun on a nonsensical target.
        if (f->isWeak) {
            if (!f->type.isPointer) {
                error("'weak' requires a pointer: write 'weak " + typeRefStr(f->type) + "* " + f->name +
                          "'. A weak reference observes an object by identity, so it must be a pointer.",
                      f->loc);
            } else if (classes_.count(baseType(typeRefStr(f->type))) == 0) {
                error("'weak " + typeRefStr(f->type) + "' has no valid target: a weak reference must point "
                      "at a class instance (an object with identity), not a primitive or non-class type.",
                      f->loc);
            }
        }
        if (!f->init) {
            continue;
        }
        const std::string initType = typeOf(*f->init);
        const std::string ft = typeRefStr(f->type);
        if (!initType.empty() && !isSubtype(initType, ft) && !intLiteralFits(*f->init, ft)) {
            error("cannot initialize field '" + f->name + "' of type '" + ft +
                      "' with a value of type '" + initType + "'",
                  f->loc);
        }
    }
    popScope();
}

// region-binder (§8): walk a method body collecting which value-parameters get stored into the receiver.
// `alias` maps a local (or parameter) name to a parameter index it aliases; `this.field = <param/alias>`
// (or an index-store into a `this` field) marks that parameter escaped. Handles the block-bearing control
// flow; a store buried in `switch`/`try` is not yet scanned (a v1 soundness gap, tracked).
// The declared type of `recv.field` -- resolves `this.field` (via the enclosing class) and `local.field`
// (via the local's type). Returns "" when it can't resolve (a computed receiver, etc.).
std::string SemanticAnalyzer::fieldTypeOf(const ast::MemberExpr& mem) {
    std::string cls;
    if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem.object.get())) {
        if (oid->name == "this") {
            cls = enclosingClass_;
        } else if (const LocalVar* v = lookupLocal(oid->name)) {
            cls = baseType(v->type);
        }
    }
    if (cls.empty()) {
        return "";
    }
    const FieldInfo* fi = findField(baseType(cls), mem.member);
    return fi != nullptr ? fi->type : "";
}

void SemanticAnalyzer::scanEscapes(const ast::Block& body, std::unordered_map<std::string, int>& alias,
                                   std::vector<bool>& esc) {
    for (const auto& stmt : body.statements) {
        scanStmt(stmt.get(), alias, esc);
    }
}

// Process one statement for the escape summary, recursing into EVERY block-bearing statement so a store
// buried in switch/try/match/using/etc. is never missed (soundness). (Stores buried inside a block-bearing
// EXPRESSION -- spec 30.18 -- are the one residual, tracked.)
void SemanticAnalyzer::scanStmt(const ast::Stmt* s, std::unordered_map<std::string, int>& alias,
                                std::vector<bool>& esc) {
    if (s == nullptr) {
        return;
    }
    auto paramOf = [&](const ast::Expr* e) -> int {  // the param index an expression aliases, or -1
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
            auto it = alias.find(id->name);
            return it == alias.end() ? -1 : it->second;
        }
        // DERIVED FROM a parameter, not equal to it: `Row* borrowed = table.at(i);` is a value that
        // belongs to `table` and dies when `table`'s rows do. Reading only bare identifiers, the
        // chain broke at exactly the line real code writes, and a result built out of those rows
        // looked like it borrowed nothing.
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(e)) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                    auto it = alias.find(rid->name);
                    if (it != alias.end()) {
                        return it->second;
                    }
                }
            }
        }
        return -1;
    };
    // The lifetime "slot" a field-store target belongs to: -1 = `this` (receiver), j = parameter j (or an
    // alias of one), -2 = neither (a local -> same lifetime as us, no escape). We record the store regardless
    // of the field's type; whether it actually ALIASES (a value copies, a pointer/generic-ref aliases) is
    // decided at the CALL SITE from the concrete argument's type -- this is what makes it work through
    // generics (a `T[]` field is not a ref in the template but is when T = Node*).
    auto storeSlot = [&](const ast::Expr* target) -> int {
        const ast::Expr* t = target;
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(t)) {
            t = ix->array.get();
        }
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(t);
        if (mem == nullptr) {
            return -2;
        }
        const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        if (oid == nullptr) {
            return -2;
        }
        // `this.field`, and `MyClass.field` -- which is the same store when the field is STATIC. A
        // static method has no `this` to write through, so the only way it can keep something is by
        // naming its own class, and reading only `this.` meant a static method recorded nothing at
        // all. Static storage is the longest-lived a program has, so a borrow kept there is the one
        // most likely to be wrong.
        if (oid->name == "this" || baseType(oid->name) == escapeScanClass_) {
            return -1;
        }
        auto ta = alias.find(oid->name);              // is the target object a parameter (or its alias)?
        return (ta != alias.end() && escapeScanParams_ != nullptr &&
                ta->second < static_cast<int>(escapeScanParams_->size())) ? ta->second : -2;
    };
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        int p = vd->init ? paramOf(vd->init.get()) : -1;   // `var y = param/alias` -> y aliases it
        if (p >= 0) {
            alias[vd->name] = p;
        } else {
            alias.erase(vd->name);
        }
        // A container built HERE, so a later `x.add(param)` is known to be filling something fresh
        // and the class is known without a symbol table this pass does not have.
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
            nw != nullptr && nw->location == "heap" && nw->region.empty()) {
            freshLocalClass_[vd->name] = nw->className;
        }
    } else if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) {
        // ...and handing it back is where the fact leaves the method.
        if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get())) {
            if (auto bit = borrowLocals_.find(rid->name); bit != borrowLocals_.end()) {
                if (returnsBorrowOfParam_.emplace(escapeScanKey_, bit->second).second) {
                    escapeSummaryChanged_ = true;
                }
            }
        }
    } else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        int slot = storeSlot(as->target.get());
        if (slot != -2) {
            int p = paramOf(as->value.get());   // storing parameter p into slot's ref field
            if (p >= 0 && p < static_cast<int>(esc.size())) {
                if (slot == -1) {
                    esc[p] = true;  // escapes into the receiver
                    // ...AND INTO WHICH FIELD, which is what decides whether this is a borrow or a
                    // handover. A store into a field the class FREES is ownership: `list.add(item)`
                    // is the most ordinary line in the language and must not be a diagnostic. Without
                    // the name, the region rule at a call site could only say "it is kept", and
                    // warned on every collection insertion in the standard library -- 808 of 925
                    // tests, which is not a measurement, it is noise.
                    // Through an index, because that is how a collection actually stores:
                    // `this.data[this.count] = item`. Reading only `this.field = param` missed every
                    // container in the language, so `list.add(x)` had no field name and could not be
                    // recognised as the handover it is.
                    const ast::Expr* t = as->target.get();
                    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(t)) {
                        t = ix->array.get();
                    }
                    const bool intoElement =
                        dynamic_cast<const ast::IndexExpr*>(as->target.get()) != nullptr;
                    if (const auto* tmem = dynamic_cast<const ast::MemberExpr*>(t)) {
                        // EVERY field it lands in, not the last one seen. An append writes the
                        // argument twice -- into the chain the object owns and into the tail pointer
                        // that makes the next append O(1) -- and recording only the second read the
                        // handover as a borrow, because the tail is a borrow. One of the two is the
                        // owner and that is the one the question is about, so keep them all and let
                        // the call site ask whether ANY of them owns.
                        //
                        // A `*` in front means it landed AMONG a field's elements rather than in the
                        // field, and the two ask different questions of the class: a container may
                        // own its storage and borrow everything in it. `this.data[i] = item` is an
                        // element; `this.filter = f` is a field.
                        const std::string landing =
                            (intoElement ? "*" : "") + tmem->member;
                        // A COPY IS NOT A KEEP. `this.seenRev = shared.revision()` reads an int out of
                        // the parameter and stores the NUMBER: nothing of the parameter is reachable
                        // through that field afterwards, and it cannot dangle. Recorded anyway, it went
                        // into the landing list beside the real reference and broke both of the call
                        // site's exemptions -- the field it named neither owns anything nor is weak, so
                        // an ordinary `attachDocument(shared)` was refused because of an integer.
                        bool landingAliases = true;
                        if (!intoElement) {
                            if (const auto* tobj =
                                    dynamic_cast<const ast::IdentifierExpr*>(tmem->object.get());
                                tobj != nullptr && tobj->name == "this") {
                                const std::string owner =
                                    escapeScanKey_.substr(0, escapeScanKey_.rfind('.'));
                                if (const ClassInfo* ci = lookupClass(baseType(owner)); ci != nullptr) {
                                    auto fld = ci->fields.find(tmem->member);
                                    if (fld != ci->fields.end()) {
                                        landingAliases = isRefType(fld->second.type);
                                    }
                                }
                            }
                        }
                        if (landingAliases) {
                            std::string& seen = escapeScanFieldFor_[p];
                            if (seen.empty()) {
                                seen = landing;
                            } else if (("," + seen + ",").find("," + landing + ",") ==
                                       std::string::npos) {
                                seen += "," + landing;
                            }
                        }
                    }
                } else if (p < static_cast<int>(escapeScanParamTargets_.size()) &&
                           std::find(escapeScanParamTargets_[p].begin(), escapeScanParamTargets_[p].end(),
                                     slot) == escapeScanParamTargets_[p].end()) {
                    escapeScanParamTargets_[p].push_back(slot);          // escapes into parameter `slot`
                }
            }
        }
        if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(as->target.get())) {
            int p = paramOf(as->value.get());              // reassigning a local: retag or clear
            if (p >= 0) {
                alias[tid->name] = p;
            } else {
                alias.erase(tid->name);
            }
        }
    } else if (const auto* is = dynamic_cast<const ast::IfStmt*>(s)) {
        scanEscapes(is->thenBlock, alias, esc);
        if (is->elseBlock) {
            scanEscapes(*is->elseBlock, alias, esc);
        }
    } else if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) {
        scanEscapes(ws->body, alias, esc);
    } else if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(s)) {
        scanEscapes(dw->body, alias, esc);
    } else if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) {
        scanStmt(fs->init.get(), alias, esc); scanStmt(fs->update.get(), alias, esc);
        scanEscapes(fs->body, alias, esc);
    } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
        scanEscapes(fe->body, alias, esc);
    } else if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
        for (const auto& c : ms->cases) {
            scanEscapes(c.body, alias, esc);
        }
        if (ms->defaultBody) {
            scanEscapes(*ms->defaultBody, alias, esc);
        }
    } else if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
        for (const auto& c : sw->cases) {
            scanEscapes(c.body, alias, esc);
        }
        if (sw->defaultBody) {
            scanEscapes(*sw->defaultBody, alias, esc);
        }
    } else if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
        scanEscapes(ts->body, alias, esc);
        for (const auto& c : ts->catches) {
            scanEscapes(c.body, alias, esc);
        }
        if (ts->finallyBlock) {
            scanEscapes(*ts->finallyBlock, alias, esc);
        }
    } else if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) {
        scanEscapes(df->body, alias, esc);
    } else if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) {
        scanStmt(us->decl.get(), alias, esc); scanEscapes(us->body, alias, esc);
    } else if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) {
        scanEscapes(sy->body, alias, esc);
    } else if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(s)) {
        scanStmt(lb->stmt.get(), alias, esc);
    } else if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) {
        // TRANSITIVE escape (fixpoint): `this.M(param)` or `this.field.M(param)` where callee M stores that
        // argument into ITS receiver -- which is part of OUR `this` -- makes the argument escape US too.
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get())) {
            if (const auto* callee = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                std::string calleeClass;
                if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(callee->object.get())) {
                    if (rid->name == "this") {
                        calleeClass = escapeScanClass_;  // this.M(...)
                    }
                } else if (const auto* rmem = dynamic_cast<const ast::MemberExpr*>(callee->object.get())) {
                    if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(rmem->object.get());
                        oid != nullptr && oid->name == "this") {  // this.field.M(...)
                        if (const FieldInfo* fi = findField(escapeScanClass_, rmem->member)) {
                            calleeClass = baseType(fi->type);
                        }
                    }
                }
                // A FRESH COLLECTION THAT GATHERS BORROWS FROM A PARAMETER carries that parameter's
                // lifetime out with it, and the caller has to be told. `scan(table)` fills a new
                // result with rows read out of `table` and returns it: nothing inside the method is
                // wrong -- the result is fresh, the rows are the table's -- and the whole bug lives
                // at the caller, where the table is emptied and the result is read afterwards.
                //
                // So the fact travels: this method hands back something borrowed from parameter p.
                if (const auto* rid =
                        dynamic_cast<const ast::IdentifierExpr*>(callee->object.get());
                    rid != nullptr && freshLocalClass_.count(rid->name) > 0) {
                    const std::string holderClass = baseType(freshLocalClass_[rid->name]);
                    auto kit = escapesToReceiver_.find(holderClass + "." + callee->member);
                    if (kit != escapesToReceiver_.end()) {
                        for (std::size_t k = 0; k < call->args.size() && k < kit->second.size();
                             ++k) {
                            if (!kit->second[k]) {
                                continue;
                            }
                            const int from = paramOf(call->args[k].get());
                            if (from >= 0) {
                                borrowLocals_[rid->name] = from;
                            }
                        }
                    }
                }
                if (!calleeClass.empty()) {
                    // WHICH FIELD, not just THAT it escapes. `put` hands the node to `add` and `add`
                    // is what stores it; propagating only the bit left `put` knowing the argument is
                    // kept and unable to say by what, so the handover exemption had nothing to ask
                    // about and every wrapper method warned.
                    //
                    // Through `this.M(x)` the callee's fields ARE our fields, so they carry over as
                    // they are. Through `this.items.M(x)` they are the inner object's fields, and the
                    // one that answers for us is `items` itself: we own the value exactly when we
                    // free `items` and `items` keeps it. That composes, which is what makes a
                    // one-line `add` wrapper -- the commonest method in any library -- come out right.
                    const bool sameObject =
                        dynamic_cast<const ast::IdentifierExpr*>(callee->object.get()) != nullptr;
                    const std::string throughField =
                        sameObject
                            ? std::string()
                            : "*" + dynamic_cast<const ast::MemberExpr*>(callee->object.get())->member;
                    auto sit = escapesToReceiver_.find(calleeClass + "." + callee->member);
                    if (sit != escapesToReceiver_.end()) {
                        for (std::size_t k = 0; k < call->args.size() && k < sit->second.size(); ++k) {
                            if (sit->second[k]) {
                                if (const auto* aid =
                                        dynamic_cast<const ast::IdentifierExpr*>(call->args[k].get())) {
                                    auto it = alias.find(aid->name);
                                    if (it != alias.end() && it->second < static_cast<int>(esc.size())) {
                                        if (!esc[it->second]) {
                                            esc[it->second] = true;
                                            escapeSummaryChanged_ = true;  // a summary grew -> another round
                                        }
                                        std::string landing = throughField;
                                        if (sameObject) {
                                            auto fit = escapesToReceiverField_.find(
                                                calleeClass + "." + callee->member + "#" +
                                                std::to_string(k));
                                            if (fit != escapesToReceiverField_.end()) {
                                                landing = fit->second;
                                            }
                                        }
                                        // NOT a fixpoint signal. `escapeScanFieldFor_` is cleared
                                        // for every method, so it "grows" on every round by
                                        // construction -- setting the changed flag here meant the
                                        // fixpoint never converged and always ran to its guard,
                                        // which is where most of a compile went.
                                        if (!landing.empty()) {
                                            std::string& seen = escapeScanFieldFor_[it->second];
                                            if (seen.empty()) {
                                                seen = landing;
                                            } else if (("," + seen + ",").find("," + landing + ",") ==
                                                       std::string::npos) {
                                                seen += "," + landing;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

void SemanticAnalyzer::computeEscapeSummaries(const ast::Program& program) {
    // Iterate to a fixpoint: a transitive store (`this.list.add(param)`) can only be seen once the callee's
    // own summary is known, so re-scan until no summary grows. Monotone (bits only turn on) -> it converges.
    // IMPORTED bundles (user libraries via .polb) carry no bodies -- their escape summary rode along in the
    // .polh `escapes(...)` clause, parsed onto each MethodDecl. Load it so their container methods are checked.
    for (const ast::Bundle& bundle : program.bundles) {
        if (!bundle.isImported) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        std::string key = baseType(cls.name) + "." + m->name;
                        std::vector<bool> rec(m->params.size(), false);
                        // NOT `par(n, {})`: with a vector element type, `{}` matches both the
                        // (count, value) and the (count, allocator) constructors and libstdc++ calls
                        // the ambiguity -- MSVC picks one and says nothing. The sized constructor
                        // value-initializes every element anyway, which is what was meant.
                        std::vector<std::vector<int>> par(m->params.size());
                        for (const auto& [i, slot] : m->escapeSummary) {
                            if (i >= 0 && i < static_cast<int>(m->params.size())) {
                                if (slot == -1) {
                                    rec[i] = true;
                                } else {
                                    par[i].push_back(slot);
                                }
                            }
                        }
                        escapesToReceiver_[key] = std::move(rec);
                        escapesToParam_[key] = std::move(par);
                    }
                }
            }
        }
    }
    int guard = 0;
    do {
        escapeSummaryChanged_ = false;
        for (const ast::Bundle& bundle : program.bundles) {
            if (bundle.isImported) {
                continue;
            }
            for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
                for (const ast::ClassDecl& cls : ns.classes) {
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            if (m->isAbstract || m->isExtern) {
                                continue;  // no Polaron body to scan
                            }
                            escapeScanClass_ = baseType(cls.name);
                            escapeScanParams_ = &m->params;
                            escapeScanParamTargets_.assign(m->params.size(), {});
                            escapeScanFieldFor_.clear();
                            borrowLocals_.clear();
                            std::unordered_map<std::string, int> alias;   // param/alias name -> param index
                            for (std::size_t i = 0; i < m->params.size(); ++i) {
                                alias[m->params[i].name] = static_cast<int>(i);
                            }
                            std::string key = escapeScanClass_ + "." + m->name;
                            escapeScanKey_ = key;
                            std::vector<bool> esc = escapesToReceiver_.count(key) > 0
                                                        ? escapesToReceiver_[key]  // keep bits from prior round
                                                        : std::vector<bool>(m->params.size(), false);
                            scanEscapes(m->body, alias, esc);
                            escapesToReceiver_[key] = esc;
                            // A VIRTUAL CALL MAY RUN ANY OVERRIDE, so the summary read at a call site
                            // has to be the union over all of them. Read from the static type alone,
                            // an override that keeps what the base does not is an escape nobody
                            // sees -- and inheritance is the one place this analysis genuinely has
                            // to do more work than it would without it. Computable because the
                            // hierarchy is closed at compile time; `unimport`/`reimport` is where
                            // that stops being true, and is its own question.
                            //
                            // AND OVER INTERFACES, which was the half that was missing. A call
                            // reads the summary of the STATIC type, and an interface method has no
                            // body -- so a call through `Drawable d; d.keep(x)` found nothing and
                            // checked nothing, however plainly the implementing class kept the
                            // argument. Under a default of "refuse what cannot be proven" that is
                            // not a gap in coverage, it is a hole in the guarantee: the one way to
                            // call a method without being seen was to call it through an interface,
                            // which is how a program organised around interfaces calls everything.
                            // A WORKLIST WITH A SEEN SET, and the set is not an optimisation. An
                            // interface graph is a DAG with diamonds -- two supertypes reaching one
                            // third -- so a walk that only appends visits that third once per path,
                            // and the count multiplies with depth. Run for every method of every
                            // class on every round of a fixpoint, the first version of this took the
                            // suite from two minutes to not finishing.
                            std::vector<std::string> uphill;
                            std::unordered_set<std::string> seenUp;
                            auto climb = [&](const std::string& name) {
                                if (!name.empty() && seenUp.insert(baseType(name)).second) {
                                    uphill.push_back(name);
                                }
                            };
                            climb(cls.superclass);
                            for (const std::string& iface : cls.interfaces) {
                                climb(iface);
                            }
                            for (std::size_t at = 0; at < uphill.size(); ++at) {
                                if (const ClassInfo* ci = lookupClass(uphill[at])) {
                                    climb(ci->superclass);
                                    for (const std::string& iface : ci->interfaces) {
                                        climb(iface);
                                    }
                                }
                            }
                            for (const std::string& up : uphill) {
                                const std::string upKey = baseType(up) + "." + m->name;
                                auto& base = escapesToReceiver_[upKey];
                                if (base.size() < esc.size()) {
                                    base.resize(esc.size(), false);
                                }
                                for (std::size_t i = 0; i < esc.size(); ++i) {
                                    if (esc[i] && !base[i]) {
                                        base[i] = true;
                                        escapeSummaryChanged_ = true;   // the fixpoint must see it
                                    }
                                }
                            }
                            for (const auto& [param, field] : escapeScanFieldFor_) {
                                // HERE is where a real growth shows, because this map survives the
                                // round. A wrapper learns its landing field only once the method it
                                // delegates to has one, so the fixpoint does need to see it -- but
                                // only when the stored answer actually changed.
                                std::string& kept = escapesToReceiverField_[key + "#" +
                                                                            std::to_string(param)];
                                if (kept != field) {
                                    kept = field;
                                    escapeSummaryChanged_ = true;
                                }
                                // The field travels with the bit. Without it a virtual call knew the
                                // argument was kept and not where, so the handover exemption had
                                // nothing to ask and every `add` through a base type warned.
                                for (const std::string& up : uphill) {
                                    std::string& there = escapesToReceiverField_[
                                        baseType(up) + "." + m->name + "#" + std::to_string(param)];
                                    if (there.empty()) {
                                        there = field;
                                    } else if (("," + there + ",").find("," + field + ",") ==
                                               std::string::npos) {
                                        there += "," + field;
                                    }
                                }
                            }
                            escapesToParam_[key] = escapeScanParamTargets_;  // param -> param slots it escapes to
                            // write the summary back onto the AST so the .polh emitter can serialize it for
                            // downstream compilation units (an `escapes(i>slot, ...)` clause).
                            std::vector<std::pair<int, int>> sum;
                            for (std::size_t i = 0; i < esc.size(); ++i) {
                                if (esc[i]) {
                                    sum.emplace_back(static_cast<int>(i), -1);
                                }
                            }
                            for (std::size_t i = 0; i < escapeScanParamTargets_.size(); ++i) {
                                for (int slot : escapeScanParamTargets_[i]) {
                                    sum.emplace_back(static_cast<int>(i), slot);
                                }
                            }
                            const_cast<ast::MethodDecl*>(m)->escapeSummary = std::move(sum);
                        }
                        // A CONSTRUCTOR IS WHERE MOST OBJECTS ARE HANDED SOMETHING, and it had no
                        // summary at all. `Parser(ArrayList<Token*> tokens) { this.tokens = tokens; }`
                        // is the ordinary way one object is given another, and with nothing recorded
                        // the only signal was a complaint inside the constructor -- at a place that
                        // cannot answer it. Whether those tokens outlive the parser is knowable
                        // exactly where both are named, which is the `new`.
                        //
                        // No union over overrides here: a constructor is not virtual, and the class
                        // written at the `new` is the class that runs.
                        if (const auto* ct = dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            escapeScanClass_ = baseType(cls.name);
                            escapeScanParams_ = &ct->params;
                            escapeScanParamTargets_.assign(ct->params.size(), {});
                            escapeScanFieldFor_.clear();
                            borrowLocals_.clear();
                            std::unordered_map<std::string, int> alias;
                            for (std::size_t i = 0; i < ct->params.size(); ++i) {
                                alias[ct->params[i].name] = static_cast<int>(i);
                            }
                            const std::string key = escapeScanClass_ + ".<new>";
                            escapeScanKey_ = key;
                            std::vector<bool> esc =
                                escapesToReceiver_.count(key) > 0
                                    ? escapesToReceiver_[key]
                                    : std::vector<bool>(ct->params.size(), false);
                            scanEscapes(ct->body, alias, esc);
                            escapesToReceiver_[key] = esc;
                            for (const auto& [param, field] : escapeScanFieldFor_) {
                                std::string& kept =
                                    escapesToReceiverField_[key + "#" + std::to_string(param)];
                                if (kept != field) {
                                    kept = field;
                                    escapeSummaryChanged_ = true;
                                }
                            }
                            escapesToParam_[key] = escapeScanParamTargets_;
                        }
                    }
                }
            }
        }
    } while (escapeSummaryChanged_ && ++guard < 50);   // 50 = a very high safety bound; real depth is tiny
}

void SemanticAnalyzer::analyzeBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported) {
            continue;  // bodies live in the .polb; only its public API is visible
        }
        // The freestanding restrictions (spec 36.3) are about what the PROGRAM may use. The stdlib
        // itself is written in full Polaron -- System.Ipc throws, for one -- and the parts a freestanding
        // program cannot reach are stripped as dead code anyway. Checking the prelude's own bodies
        // against them would outlaw the stdlib for having features the program simply never calls.
        const bool wasFreestanding = freestanding_;
        if (bundle.isPrelude) {
            freestanding_ = false;
        }
        // Imports are written before `program` (file level, spec 2.7); the in-bundle form is still
        // accepted during migration. Collect the imported symbol names from both.
        currentBundle_ = bundle.name;  // for the stdlib-cohesion visibility check
        currentImports_.clear();
        currentImportPaths_.clear();
        // THE STANDARD LIBRARY DOES NOT INHERIT YOUR IMPORTS. `program.imports` is the WHOLE
        // program's, and applying it while walking the prelude handed the library the author's
        // choices: a program declaring `Own.World.Paths` and importing it made `Paths` inside the
        // STANDARD LIBRARY mean the author's class, because "an import that names the path settles
        // it" fired on an import the prelude never wrote. It surfaced as `class 'Paths' has no
        // method 'dirname'` pointing into <prelude>, at a line the author had never seen -- and it
        // took a stdlib class calling another stdlib class by a shadowable name to find it. The
        // library is one body of code that imports nothing: every name in it is its own.
        const bool inheritsImports = !bundle.isPrelude;
        for (const ast::ImportDecl& imp : program.imports) {
            if (inheritsImports && !imp.path.empty()) {
                currentImports_.insert(imp.path.back());
                // AND THE WHOLE PATH, because the last segment is not the answer when two types
                // answer to it. `import System.Units.Angle;` beside a `System.Math.Angle` says
                // exactly which one is meant, and keeping only "Angle" threw that away -- resolution
                // then saw both as imported and picked the first.
                if (imp.path.size() >= 3) {
                    std::string full;
                    for (const std::string& seg : imp.path) {
                        full += (full.empty() ? "" : ".") + seg;
                    }
                    currentImportPaths_.insert(full);
                }
            }
        }
        for (const ast::ImportDecl& imp : bundle.imports) {
            if (!imp.path.empty()) {
                currentImports_.insert(imp.path.back());
                // AND THE WHOLE PATH, because the last segment is not the answer when two types
                // answer to it. `import System.Units.Angle;` beside a `System.Math.Angle` says
                // exactly which one is meant, and keeping only "Angle" threw that away -- resolution
                // then saw both as imported and picked the first.
                if (imp.path.size() >= 3) {
                    std::string full;
                    for (const std::string& seg : imp.path) {
                        full += (full.empty() ? "" : ".") + seg;
                    }
                    currentImportPaths_.insert(full);
                }
            }
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            currentNamespace_ = ns.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                currentClass_ = cls.name;  // keep accurate for checkTypeAccessible's mono exemption
                currentClassDecl_ = &cls;  // so a delegating call can be followed into its own body
                enclosingClass_ = cls.name;  // active from here so field inits resolve unqualified calls too
                owningClassForRefs_ = cls.name;  // what this class's code drags in (see noteClassRef)
                // Member signature types must also be visible from this namespace -- except for
                // monomorphized generic instances (name contains '$'), whose members reference the
                // type arguments by simple name; those were already checked at the template and the
                // instantiation site, and the generated class is not bound to the arg's namespace.
                const bool isMono = cls.name.find('$') != std::string::npos;
                for (const ast::MemberPtr& member : cls.members) {
                    if (isMono) {
                        break;
                    }
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        // A monomorphized METHOD (`of$Player`) has the caller's types in its
                        // signature by construction -- that is what the instantiation IS -- and the
                        // class holding it may be the standard library's. Checked where it was
                        // written; see the matching exemption in checkTypeAccessible.
                        if (m->name.find('$') != std::string::npos) {
                            continue;
                        }
                        for (const ast::Param& p : m->params) {
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                        }
                        checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        checkTypeAccessible(typeRefStr(f->type), f->loc);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        for (const ast::Param& p : c->params) {
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                        }
                    }
                }
                // What this class's region fields accept, BEFORE any method body is checked against
                // them: the constraints are written in the constructor, and constructors are
                // analyzed after the methods. See collectRegionFieldConstraints.
                //
                // Only for a class that HAS a region field, which is a handful in any program and
                // none at all in most. The walk is cheap per class and there are three hundred of
                // them in the standard library alone, and a pass that runs over everything to serve
                // a rare declaration is how a compiler gets slower one feature at a time.
                bool ownsRegion = false;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        if (typeRefStr(f->type) == "region") {
                            ownsRegion = true;
                        }
                    }
                }
                if (ownsRegion) {
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            collectRegionFieldsInBlock(&c->body, cls.name, fieldRegionConstraints_);
                        }
                    }
                }
                analyzeFieldInits(cls);
                if (!cls.invariants.empty()) {
                    std::vector<const ast::Expr*> invs;
                    for (const auto& e : cls.invariants) {
                        invs.push_back(e.get());
                    }
                    analyzeMethodBody(ast::Block{}, {}, cls.name, false, invs);
                }
                enclosingClass_ = cls.name;  // kept across static methods (currentClass_ is cleared there)
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        if (m->isAbstract || m->isExtern) {
                            continue;  // no Polaron body to analyze
                        }
                        if (m->isAsync && freestanding_) {
                            error("async methods are not available in freestanding mode (spec 36.3)",
                                  m->loc);
                        }
                        // The trap parameter is WORLD-SHAPED, and it has to be, because it names
                        // what the outside world actually handed over on the way in. Bare metal
                        // that is the frame the CPU pushed, which is an object with fields. Hosted
                        // it is a code -- SIGINT, a console control type -- and no frame exists to
                        // point at. The parameterless form is the intersection, so a handler that
                        // does not care where it came from compiles for both worlds unchanged.
                        if (m->isInterrupt && !m->params.empty()) {
                            const std::string pt = baseType(typeRefStr(m->params[0].type));
                            const bool isClass = classes_.count(pt) > 0;
                            if (freestanding_ && !isClass) {
                                error("a freestanding interrupt receives the frame the CPU pushed, "
                                      "so its parameter must be a class with the fields of that "
                                      "frame -- not '" + pt + "'. Declare a `Trap` type, or take no "
                                      "parameter at all.",
                                      m->params[0].loc);
                            }
                            if (!freestanding_ && isClass) {
                                error("a hosted interrupt is entered with a CODE -- a signal number, "
                                      "a console control type -- not a CPU frame, so its parameter "
                                      "cannot be the class '" + pt + "'. Declare an integer, or take "
                                      "no parameter at all.",
                                      m->params[0].loc);
                            }
                        }
                        // A value Result/Option rides the Task's 64-bit result slot boxed (codegen copies
                        // the { tag, payload } struct to the heap on completion and unboxes it on await),
                        // so both the value and boxed forms of an async Result/Option are allowed.
                        // A [Test] and the [Setup]/[Teardown] that bracket it all run inside their own
                        // class's fixture window, so they are the methods the fixture-ownership warning
                        // applies to.
                        inTestMethod_ = false;
                        for (const ast::AnnotationUse& a : m->annotations) {
                            if (a.name == "Test" || a.name == "Setup" || a.name == "Teardown") {
                                inTestMethod_ = true;
                            }
                        }
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : m->requiresClauses) {
                            contracts.push_back(e.get());
                        }
                        // Postconditions go separately: they are checked with `result` in scope, and
                        // preconditions must not see it.
                        std::vector<const ast::Expr*> posts;
                        for (const auto& e : m->ensuresClauses) {
                            posts.push_back(e.get());
                        }
                        currentReturnType_ = typeRefStr(m->returnType);  // for the return null check
                        currentReturnIsMove_ = m->returnType.isMove;
                        currentGenElem_ = m->genElem;  // spec 22.6: the type each `yield` must produce
                        currentThrows_.clear();
                        for (const auto& t : m->throwsTypes) {
                            currentThrows_.push_back(baseType(typeRefStr(t)));
                        }
                        const std::string retT = typeRefStr(m->returnType);
                        // `naked` changes what an asm body is ALLOWED to do, so the asm checker has to
                        // know. In an ordinary method the block sits inside compiler-generated code and
                        // every register it destroys must be declared, or the allocator's live values
                        // are corrupted. A naked method has no such code -- the body IS the method --
                        // so the same write is not a lie, and reporting it would reject every boot stub
                        // ever written.
                        inNakedFn_ = m->isNaked;
                        // Names this body's row in the call graph the interrupt check walks later.
                        // Set around the body only, so a field initializer or a contract analyzed
                        // outside one does not get attributed to whichever method ran last.
                        currentMethodKey_ = cls.name + "." + m->name;
                        methodFacts_[currentMethodKey_];  // exists even when it does nothing
                        // Both levels: `class Box<T> { method map<R>(...) }` has T and R in scope
                        // inside `map`, and a check meeting either must wait for the instantiation.
                        currentTypeParams_.clear();
                        currentTypeParams_.insert(cls.typeParams.begin(), cls.typeParams.end());
                        currentTypeParams_.insert(m->typeParams.begin(), m->typeParams.end());
                        // A BODY THAT CAME OUT OF A `freestanding` TRANSFORMER obeys the bare-metal
                        // subset even here, in a program that is hosted. That is the whole of what
                        // the modifier buys: without it, a transformer whose body interpolates a
                        // string or throws compiles perfectly for its author and fails three layers
                        // down, in somebody else's kernel, on a line its reader never wrote.
                        //
                        // Done by turning the REAL gate on for this body rather than by a second
                        // hand-written list of what bare metal cannot have. Everything it already
                        // refuses -- interpolation, exceptions, await, unimport, `Test`, `Console` --
                        // applies unchanged, and anything added to it later applies too.
                        const bool savedFreestanding = freestanding_;
                        const std::string savedFsFrom = freestandingFrom_;
                        if (!m->freestandingFrom.empty()) {
                            freestanding_ = true;
                            freestandingFrom_ = m->freestandingFrom;
                        }
                        if (m->isInterrupt) {
                            interruptRoots_.emplace_back(cls.name, m->loc);
                            if (!m->params.empty()) {
                                interruptTrapParam_ = m->params[0].name;
                            }
                        }
                        // A BOUND TARGET OWES WHAT A CONSTRUCTOR OWES. `procedure into<Fahrenheit f>`
                        // hands the body raw storage, so the body is that object's construction and
                        // carries the same obligation: every field assigned before it ends. Seeded
                        // here, discharged by assignments to `f.<field>`, and reported below --
                        // deliberately the same dataflow, because two ways of proving one thing is
                        // how one of them ends up weaker.
                        boundTargetName_ = m->boundTarget;
                        pendingBoundFields_.clear();
                        if (!m->boundTarget.empty()) {
                            if (const ast::ClassDecl* tc = classDeclOf(m->boundTargetType)) {
                                for (const ast::MemberPtr& tm : tc->members) {
                                    const auto* fd = dynamic_cast<const ast::FieldDecl*>(tm.get());
                                    if (fd == nullptr || fd->isStatic || fd->init != nullptr) {
                                        continue;   // a field with a value at its declaration is set
                                    }
                                    pendingBoundFields_.push_back({fd->name, m->boundTargetLoc});
                                }
                            }
                        }
                        const auto boundFields = pendingBoundFields_;
                        // The advice frame for this body: the class's `[Allow]`s come with the
                        // method's, so one written on the class covers everything inside it.
                        pushAllows(cls.annotations, m->annotations);
                        analyzeMethodBody(m->body, m->params,
                                          m->isStatic ? std::string() : cls.name, false, contracts,
                                          posts, retT == "void" ? std::string() : retT);
                        // The structural advice, after the body -- so a lint that reads a type asks
                        // a table the body has already filled in.
                        warnMutableNeverMutated(*m);
                        warnSwallowedCatch(m->body);
                        warnAsyncNeverAwaits(*m);
                        warnIfChainOnOneSubject(m->body);
                        warnRepeatedMagicNumber(*m);
                        warnThrowCaughtHere(m->body);
                        warnHeapWithLexicalLifetime(m->body);
                        warnRepeatedCleanup(*m);
                        warnThrowInLoop(m->body);
                        warnBooleanOutParameter(*m);
                        warnValidationThatIsAContract(*m);
                        warnAllocFreeInLoop(m->body);
                        warnArrayGrownByHand(*m);
                        popAllows();
                        for (const auto& [fname, floc] : boundFields) {
                            const FlowFacts::Init st = initStateOf(m->boundTarget + "." + fname);
                            if (st == FlowFacts::Init::Init) {
                                continue;
                            }
                            error(std::string(st == FlowFacts::Init::Uninit
                                                  ? "`procedure " + m->name + "` binds '" +
                                                        m->boundTargetType + " " + m->boundTarget +
                                                        "' and never assigns its field '" + fname + "'"
                                                  : "`procedure " + m->name + "` binds '" +
                                                        m->boundTargetType + " " + m->boundTarget +
                                                        "' and assigns its field '" + fname +
                                                        "' on only some paths") +
                                      ". A bound target is storage with no constructor of its own run "
                                      "over it, so an unassigned field does not start empty -- it "
                                      "starts as whatever was last there. Assign it, or give it a "
                                      "value at its declaration in '" + m->boundTargetType + "'",
                                  floc);
                        }
                        boundTargetName_.clear();
                        currentMethodKey_.clear();
                        freestanding_ = savedFreestanding;
                        freestandingFrom_ = savedFsFrom;
                        interruptTrapParam_.clear();
                        inNakedFn_ = false;
                        // A non-void method that can reach its end without returning. Polaron-0501 was
                        // written in the catalog and had NO producer, so `returns int { if (n > 0) {
                        // return 7; } }` compiled clean and handed the caller a 0 -- a wrong answer, in
                        // the most ordinary shape there is. `blockAlwaysExits` is the same walker the
                        // flow machine uses to decide that a guard clause narrows, so the two agree
                        // about what "this path is over" means.
                        //
                        // Abstract/extern/async bodies are skipped: there is nothing to fall off.
                        // A generator (`yield`) ends by running out of values, not by returning one.
                        // An EMPTY body is also skipped, and not only for tidiness: every test that
                        // renames a class (the stdlib-name and namespace-collision ones) reaches this
                        // point with prelude `extern` declarations whose `isExtern` did not survive the
                        // rewrite, so the flag alone is not enough to tell "no body" from "a body that
                        // falls through". A declaration with nothing in it never had a path to check.
                        if (!m->isAbstract && !m->isExtern && !m->isAsync && m->genElem.empty() &&
                            !m->body.statements.empty() && !typeRefStr(m->returnType).empty() &&
                            typeRefStr(m->returnType) != "void" && !alwaysReturns(m->body)) {
                            error("method '" + m->name + "' returns '" + typeRefStr(m->returnType) +
                                      "', but a path reaches the end of its body without returning a "
                                      "value. Falling off the end leaves the caller holding whatever "
                                      "happened to be there -- add a `return` on that path, usually the "
                                      "final `else` or the code after the last `if`",
                                  m->loc);
                        }
                        currentGenElem_.clear();
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : c->requiresClauses) {
                            contracts.push_back(e.get());
                        }
                        for (const auto& e : c->ensuresClauses) {
                            contracts.push_back(e.get());
                        }
                        currentReturnType_ = "void";
                        currentReturnIsMove_ = false;
                        currentThrows_.clear();
                        // WHICH FIELDS THIS CONSTRUCTOR OWES A VALUE. Computed from the declarations
                        // rather than from `ClassInfo`, because the exclusions live in the AST: an
                        // initializer at the declaration, `lazy`, `static`, `persistent`.
                        pendingCtorFields_.clear();
                        // A SYNTHESIZED class is not the programmer's to fix. The state class a
                        // `generator` method compiles into is written by this compiler, and an error
                        // pointing into it names a line nobody typed. Synthesized nodes carry an empty
                        // location, which is the same signal used elsewhere in this file.
                        // ...and neither is a MONOMORPHIZED one. By the time a generic reaches here it
                        // has been copied per type argument -- `FilterStream$int` -- and the copy has
                        // lost what the original said: a `T cached` guarded by a `hasCached` flag is
                        // now an `int cached` with no visible reason it may be left alone, and there is
                        // no default the constructor could write for a `T` anyway.
                        //
                        // STATED LIMITATION rather than a hidden one: the right place to check a
                        // generic is its TEMPLATE, once, before substitution, and this analysis does not
                        // run there. So a generic class's constructor is not checked at all today. The
                        // `$` in the name is what monomorphization and synthesis both leave behind.
                        const bool synthesized =
                            cls.loc.file.empty() || cls.name.find('$') != std::string::npos;
                        for (const ast::MemberPtr& fm : cls.members) {
                            if (synthesized) {
                                break;
                            }
                            const auto* fd = dynamic_cast<const ast::FieldDecl*>(fm.get());
                            if (fd == nullptr) {
                                continue;
                            }
                            // A field with a value at its declaration already has one.
                            if (fd->init) {
                                continue;
                            }
                            // A static field is not per-object, so a constructor is not where it gets
                            // its value.
                            if (fd->isStatic) {
                                continue;
                            }
                            // `lazy` MEANS uninitialised until first read -- that is the feature, and
                            // reporting it would make the keyword unusable.
                            if (fd->isLazy) {
                                continue;
                            }
                            // A persistent field is read out of its block, which the runtime fills from
                            // the previous incarnation; assigning it in the constructor is how INITIAL
                            // values are expressed, not a requirement (spec 18.9).
                            if (fd->isPersistent) {
                                continue;
                            }
                            // A field whose TYPE has a defined empty value is not uninitialised when it
                            // is left alone -- it is that value, and the type says so. `nullable T*`
                            // starts null and `weak T*` starts as an empty slot, both established by
                            // codegen rather than by the constructor. Requiring `this.next = null;`
                            // would be ceremony that says exactly what the declaration already said.
                            //
                            // A plain `T*` is NOT excluded, and that is the line: a non-nullable pointer
                            // left unassigned is a dangling pointer the type system has promised is
                            // valid, which is worse than either.
                            if (fd->isWeak) {
                                continue;
                            }
                            if (isNullableType(typeRefStr(fd->type))) {
                                continue;
                            }
                            // ANY pointer field. `nullable T*` is the explicit spelling, but a plain
                            // `T*` field null-defaults too, and the linked-list idiom -- a `next` the
                            // constructor deliberately leaves empty -- is written that way throughout
                            // the standard library and the tests. Demanding `this.next = null;` would be
                            // ceremony restating the declaration, and rejecting existing correct code is
                            // how a new check gets switched off rather than obeyed.
                            if (!typeRefStr(fd->type).empty() && typeRefStr(fd->type).back() == '*') {
                                continue;
                            }
                            // A field whose type is one of the class's TYPE PARAMETERS has no default
                            // the constructor could write: there is no value of `T` to be had without
                            // one being supplied. The prelude's `FilterStream<T>` is the shape --
                            // a `T cached` guarded by a `hasCached` flag, correct and unassignable.
                            // Seeing that it is guarded needs reasoning this analysis does not do, so
                            // the type parameter is where the line goes.
                            bool isTypeParam = false;
                            for (const std::string& tp : cls.typeParams) {
                                if (typeRefStr(fd->type) == tp) {
                                    isTypeParam = true;
                                }
                            }
                            if (isTypeParam) {
                                continue;
                            }
                            // A `region` field is brought into being by `itself.allocate(...)`, which is
                            // an assignment like any other -- so regions are NOT excluded.
                            pendingCtorFields_.push_back({fd->name, fd->loc});
                        }
                        analyzeMethodBody(c->body, c->params, cls.name, /*inConstructor=*/true,
                                          contracts);
                        // ...and what it left unset. The two messages are the two different mistakes,
                        // exactly as for locals: never assigned, versus assigned on only some paths.
                        //
                        // Why this matters MORE for a field than for a local, which is the reason it was
                        // worth extending the analysis across the object boundary: an uninitialised
                        // local reads stack garbage, which is usually absurd and fails loudly. An
                        // uninitialised field reads THE PREVIOUS OBJECT'S VALUE, because the heap block
                        // is reused -- so the wrong value is plausible and stable. A socket in the pico
                        // kernel inherited a dead socket's port number this way: everything downstream
                        // worked perfectly with the wrong number, the datagram went out and the answer
                        // came back, and it was discarded one layer above.
                        for (const auto& [fname, floc] : pendingCtorFields_) {
                            const FlowFacts::Init st = initStateOf("this." + fname);
                            if (st == FlowFacts::Init::Init) {
                                continue;
                            }
                            error(st == FlowFacts::Init::Uninit
                                      ? "constructor of '" + cls.name + "' never assigns field '" +
                                            fname + "'. A new object's storage is whatever was last "
                                            "there -- for a heap object, the previous object's values -- "
                                            "so the field does not start empty, it starts WRONG. Assign "
                                            "it here, or give it a value at its declaration"
                                      : "constructor of '" + cls.name + "' assigns field '" + fname +
                                            "' on only some paths. The others leave it holding whatever "
                                            "was in that memory before, which for a reused heap block is "
                                            "the previous object's value. Assign it on every path, or "
                                            "give it a default at its declaration",
                                  floc);
                        }
                        pendingCtorFields_.clear();
                        // A base whose constructor takes arguments has to be given them. Without a
                        // `super(...)` codegen called it with `this` alone, so the arity was wrong and
                        // the LLVM verifier caught it -- "Incorrect number of arguments passed to called
                        // function", a message that names nothing the programmer wrote and points at no
                        // line of theirs. Reject it here, where the omission actually is.
                        if (!cls.superclass.empty()) {
                            if (const ClassInfo* sup = lookupClass(cls.superclass);
                                sup != nullptr && !sup->ctorParamTypes.empty()) {
                                bool hasSuper = false;
                                if (!c->body.statements.empty()) {
                                    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(
                                            c->body.statements.front().get())) {
                                        if (const auto* call =
                                                dynamic_cast<const ast::CallExpr*>(es->expr.get())) {
                                            if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) !=
                                                nullptr) {
                                                hasSuper = true;
                                            }
                                        }
                                    }
                                }
                                if (!hasSuper) {
                                    error("'" + cls.name + "' extends '" + cls.superclass +
                                              "', whose constructor takes " +
                                              std::to_string(sup->ctorParamTypes.size()) +
                                              " argument(s), so this constructor has to begin with "
                                              "`super(...)` to supply them. Without it the base is left "
                                              "unbuilt and its fields hold whatever was there",
                                          c->loc);
                                }
                            }
                        }
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        currentReturnType_ = "void";
                        currentReturnIsMove_ = false;
                        currentThrows_.clear();
                        analyzeMethodBody(d->body, {}, cls.name, false);
                    }
                }
            }
            // Catalog-implementing enums keep their method impls on the enum (they are
            // not desugared to a class); type-check those bodies too. `this` has the
            // enum type; an instance method receives the enum value (an ordinal).
            for (const ast::EnumDecl& en : ns.enums) {
                enclosingClass_ = en.name;
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) {
                        continue;
                    }
                    for (const ast::Param& p : m->params) {
                        checkTypeAccessible(typeRefStr(p.type), p.loc);
                    }
                    checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    std::vector<const ast::Expr*> contracts;
                    for (const auto& e : m->requiresClauses) {
                        contracts.push_back(e.get());
                    }
                    for (const auto& e : m->ensuresClauses) {
                        contracts.push_back(e.get());
                    }
                    // Same leak as the literal suffixes below: an enum's method bodies are analyzed here
                    // rather than in the class member loop, so `currentReturnType_` still held whatever
                    // the last CLASS method left in it. A method on an enum returns a type like any other.
                    currentReturnType_ = typeRefStr(m->returnType);
                    currentReturnIsMove_ = m->returnType.isMove;
                    currentThrows_.clear();
                    // An enum can apply a transformer, so its bodies need a row in the facts table
                    // like everyone else's -- without a key, `facts()` returns null and the totality
                    // check has nothing to read about a conversion written here.
                    currentMethodKey_ = en.name + "." + m->name;
                    methodFacts_[currentMethodKey_];
                    analyzeMethodBody(m->body, m->params,
                                      m->isStatic ? std::string() : en.name, false, contracts);
                    currentMethodKey_.clear();
                }
            }
        }
        freestanding_ = wasFreestanding;
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program, bool libraryMode, bool testMode) {
    libraryMode_ = libraryMode;
    testMode_ = testMode;
    // Freestanding mode (spec 36): the whole program, or any bundle, may opt out of the managed
    // runtime; here we treat the program as freestanding if it or any bundle declares it.
    freestanding_ = program.isFreestanding;
    for (const ast::Bundle& b : program.bundles) {
        if (b.isFreestanding) {
            freestanding_ = true;
        }
        bundleNames_.insert(b.name);  // every declared/imported bundle: the import path's first segment
        for (const ast::Namespace& ns : b.namespaces) {
            currentNamespace_ = ns.name;
            currentBundle_ = b.name;
            namespaceBundle_[ns.name] = b.name;  // namespace -> owning bundle (stdlib-cohesion check)
            for (const ast::ClassDecl& c : ns.classes) {
                declsByName_[c.name] = &c;
            }
        }
    }
    // Virtual builtin types (no prelude class, e.g. to avoid clashing with a user class named Math) live
    // in the System bundle (spec 34). Registering their (bundle, namespace) lets the strict full-path
    // import validate, e.g. `import System.Math.Math;` -> bundle System, namespace Math, type Math.
    // `shadowable`: a builtin the standard library itself never calls, so a user class may take the
    // name and lose nothing but its own access to the builtin. Math is the one, and deliberately so
    // -- it exists as a virtual type rather than a prelude class precisely so that a program with its
    // own Math compiles, which is a common enough name to be worth the exemption. Every other builtin
    // IS used by the stdlib, so shadowing one breaks code the author never wrote.
    auto builtin = [&](const std::string& type, const std::string& ns, bool shadowable = false) {
        typeNamespace_[type] = ns;
        typeBundle_[type] = "System";
        if (!shadowable) {
            builtinTypes_.insert(type);
        }
    };
    // The one list lives in ast.h, because the monomorphizer needs the same answer -- see
    // ast::builtinStaticClasses(). Two copies of it already cost a day: expansion had its own, so a
    // generic `read<T>` anywhere rewrote every `Raw.read<int>` into a builtin that does not exist.
    //
    // spec 17.8: the low-level memory API is a NAMESPACE of classes that each do one thing --
    // System.Memory.Allocator and System.Memory.Raw. It used to be one class `Memory` hung straight
    // off the bundle with no namespace, the only builtin shaped that way.
    for (const ast::BuiltinStaticClass& b : ast::builtinStaticClasses()) {
        builtin(b.name, b.ns, b.shadowable);
    }
    // reflect (spec 31) is a builtin namespace, not a prelude class; register it so `import reflect;`
    // (a bare, bundle-less import) resolves. Reflection use is gated on this import at reflect.typeOf.
    typeNamespace_["reflect"] = "reflect";
    // Naming convention (spec 2.6): bundle and namespace names are PascalCase. A lowercase initial (on
    // any dotted segment) is a warning, not an error -- it nudges the convention without breaking code.
    auto lowerInitial = [](const std::string& name) {
        bool atStart = true;
        for (char c : name) {
            if (atStart) {
                if (c >= 'a' && c <= 'z') {
                    return true;  // a segment starts lowercase
                }
                atStart = false;
            }
            if (c == '.') {
                atStart = true;
            }
        }
        return false;
    };
    for (const ast::Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported) {
            continue;  // warn on the user's own source only
        }
        if (!b.name.empty() && lowerInitial(b.name)) {
            warn("bundle '" + b.name +
                     "' should start with a capital letter (bundle names are conventionally PascalCase)",
                 b.nameLoc);
        }
        for (const ast::Namespace& ns : b.namespaces) {
            currentNamespace_ = ns.name;
            currentBundle_ = b.name;
            if (!ns.name.empty() && lowerInitial(ns.name)) {
                warn("namespace '" + ns.name +
                         "' should start with a capital letter (namespace names are conventionally "
                         "PascalCase)",
                     ns.nameLoc);
            }
        }
    }
    // Generic templates (stdlib collections and user generics alike) are erased by monomorphization,
    // which rewrites each use to an instance (ArrayList$int) in the user's namespace. The base name ->
    // namespace map captured before monomorphization pins each generic to its real home, so a stdlib
    // collection requires an import while a user generic in the current namespace does not. Enforcement
    // strips the $arg suffix and checks the base name (see checkTypeAccessible).
    genericHomes_ = program.genericNamespaces;
    for (const auto& [base, homes] : program.genericNamespaces) {
        if (!homes.empty()) {
            typeNamespace_[base] = homes.front();  // for messages; visibility uses genericHomes_
        }
    }
    genericVariance_ = program.genericVariance;  // variance of generic type params (spec 15.3)
    qualifiedTypes_.insert(program.qualifiedTypes.begin(), program.qualifiedTypes.end());
    registerClasses(program);
    registerCatalogs(program);  // before enums: registerEnums records enum->catalog edges
    registerEnums(program);
    registerNewtypes(program);
    registerAnnotations(program);
    registerLiterals(program);
    registerConsts(program);
    registerComptimeMethods(program);
    registerPersistentFields(program);
    processImports(program);
    evaluateConsts(program);
    validateHierarchy();
    // If the hierarchy itself is broken (cycle, missing super), stop: walking it
    // recursively below could otherwise loop forever.
    if (!errors_.empty()) {
        return false;
    }
    validateOverrides(program);
    validateCatalogs(program);
    findEntryPoint(program);
    // §8: compute the interprocedural escape summary before checking. Also run it when emitting a library
    // (even without --region-binder) so the summary is serialized into the .polh for downstream consumers.
    if (regionBinder_ || libraryMode_) {
        // WHO OWNS WHAT, before anything asks where a value lives. Read off the destructors, which
        // is where the author already wrote it -- and without it every `T*` field is ambiguous
        // between ownership and a borrow, which is why the analysis could only ever see the frame.
        const bool timeThem = std::getenv("POLARON_TIME_REGIONS") != nullptr;
        const auto t0 = std::chrono::steady_clock::now();
        computeOwnership(program);
        const auto t1 = std::chrono::steady_clock::now();
        computeEscapeSummaries(program);
        const auto t2 = std::chrono::steady_clock::now();
        if (timeThem) {
            std::fprintf(stderr, "ownership %lld ms, escapes %lld ms\n",
                         static_cast<long long>(
                             std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count()),
                         static_cast<long long>(
                             std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count()));
        }
    }
    collectFixtureOwners(program);  // spec 32.11: known before the bodies that reach into them
    analyzeBodies(program);
    analyzeLiteralBodies(program);
    validateAnnotations(program);  // spec 14.3: applied [Name(...)] match a declared annotation
    adviseOnDeclarations(program);  // the structural advice a class's own text gives away
    validateTestDeclarations(program);  // spec 32.11: [Test]/[Cases]/hooks are well formed
    checkPersistentReleases();  // spec 18.15: after all bodies, so releases are collected
    checkInterruptReach();      // after all bodies, so the call graph is whole
    checkByValueMutations();    // ...and for the same reason: which methods change their object
    checkProcedureTotality(program);
    return errors_.empty();
}

// spec 32.13, TOTALITY. Partiality is DEDUCED, never annotated:
//
//   a procedure whose SOURCE is a CLOSED kind may be total, and is checked;
//   a procedure whose source is an OPEN type is fallible by construction.
//
// The source of a per-target `procedure into<X>()` is the type it is written on -- you are
// converting FROM it. `class`/`record` is closed over its FIELDS, so a conversion that never reads
// one of them is either wrong or that field does not belong in the conversion, and both are worth
// being told. `Errno -> int` is total because the constants are a finite list you own; `int ->
// Errno` is not, and no annotation says so -- there is no list to cover and the compiler knows it.
//
// This is constructor definite assignment generalised: the same dataflow, over a different list --
// and the list is what the KIND is closed over:
//
//   class / record -> every FIELD          (a class is closed over its fields)
//   enum           -> every CONSTANT       (a finite list you own; `Errno -> int` is the flagship)
//   union          -> nothing to cover     (see below -- and this row is not an omission)
//
// A `union` looks like it should take the record rule and must not. Its fields SHARE one storage and
// nothing tags which of them is live, so a conversion that read every field would be reading bytes
// that mean something else -- the rule would demand a bug. The honest reading is that a union's
// source is OPEN, like an `int`: there is no list to cover, so it is fallible by construction and
// exempt for the same reason a static per-target procedure is. Before this was written down the
// field rule ran over unions too, and demanded exactly that wrong thing.
void SemanticAnalyzer::checkProcedureTotality(const ast::Program& program) {
    for (const ast::Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported) {
            continue;
        }
        for (const ast::Namespace& ns : b.namespaces) {
            currentNamespace_ = ns.name;
            currentBundle_ = b.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                // A value aggregate or a plain class is closed over its fields. An interface has
                // none, and an abstract class's are somebody else's problem. A union is closed over
                // nothing readable -- see above.
                if (cls.isInterface || cls.isAbstract || cls.isUnion) {
                    continue;
                }
                for (const ast::MemberPtr& m : cls.members) {
                    const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
                    if (md == nullptr || !md->isEachFamily || md->isAbstract) {
                        continue;
                    }
                    // A COMPOSED conversion reads no field, and demanding that it should would be
                    // asking it to do the work again. `collective` produced it by chaining
                    // conversions that were each checked total where they were written, so its
                    // totality is inherited rather than unverified.
                    if (!md->composedVia.empty()) {
                        continue;
                    }
                    // A STATIC per-target procedure converts *to* this type, not *from* it: its
                    // source is the parameter, which is why it exists at all -- one end of a
                    // relation is often a type you do not own, and `int` applies nothing. That
                    // source is OPEN, so the procedure is fallible by construction and there is no
                    // list to cover. `Errno -> int` is total; `int -> Errno` is not, and nothing
                    // had to be annotated to say so.
                    if (md->isStatic) {
                        continue;
                    }
                    auto fit = methodFacts_.find(cls.name + "." + md->name);
                    if (fit == methodFacts_.end()) {
                        continue;
                    }
                    std::vector<std::string> missed;
                    for (const ast::MemberPtr& fm : cls.members) {
                        const auto* fd = dynamic_cast<const ast::FieldDecl*>(fm.get());
                        if (fd == nullptr || fd->isStatic || fd->isTransient) {
                            continue;
                        }
                        if (fit->second.ownFieldsTouched.count(fd->name) == 0) {
                            missed.push_back(fd->name);
                        }
                    }
                    if (missed.empty()) {
                        continue;
                    }
                    std::string list;
                    for (std::size_t i = 0; i < missed.size(); ++i) {
                        list += (i != 0 ? ", " : "") + missed[i];
                    }
                    const std::string target =
                        md->name.substr(md->name.find('$') == std::string::npos
                                            ? md->name.size()
                                            : md->name.find('$') + 1);
                    error("`procedure " + md->name.substr(0, md->name.find('$')) + "<" + target +
                              ">` converts FROM '" + cls.name + "', which is closed over its fields, "
                              "so the conversion must be total -- and it never reads: " + list +
                              ". Read them, or say why they are not part of this conversion by "
                              "marking them `transient`.",
                          md->loc);
                }
            }
            // THE ENUM ROW. An enum is closed over its CONSTANTS, so a conversion written on one
            // must account for every constant it could be handed. `match` exhaustiveness already
            // covers the natural way to write this, but it was never the same guarantee: an
            // `if`/`else` chain over constants was checked by nothing at all, and the one it forgot
            // fell through to whatever the last branch returned.
            for (const ast::EnumDecl& en : ns.enums) {
                for (const ast::MemberPtr& m : en.members) {
                    const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
                    if (md == nullptr || !md->isEachFamily || md->isAbstract || md->isStatic ||
                        !md->composedVia.empty()) {
                        continue;   // static converts TO this enum: an open source, see above
                    }
                    auto fit = methodFacts_.find(en.name + "." + md->name);
                    if (fit == methodFacts_.end()) {
                        continue;
                    }
                    std::vector<std::string> missed;
                    for (const std::string& k : en.constants) {
                        if (fit->second.ownConstantsTouched.count(en.name + "." + k) == 0) {
                            missed.push_back(k);
                        }
                    }
                    if (missed.empty()) {
                        continue;
                    }
                    std::string list;
                    for (std::size_t i = 0; i < missed.size(); ++i) {
                        list += (i != 0 ? ", " : "") + missed[i];
                    }
                    const std::string target =
                        md->name.substr(md->name.find('$') == std::string::npos
                                            ? md->name.size()
                                            : md->name.find('$') + 1);
                    error("`procedure " + md->name.substr(0, md->name.find('$')) + "<" + target +
                              ">` converts FROM enum '" + en.name + "', which is closed over its "
                              "constants, so the conversion must be total -- and it never names: " +
                              list + ". A constant added next year has to become an error here, not "
                              "a value that falls through to the last branch.",
                          md->loc);
                }
            }
        }
    }
}

// The row for the body being analyzed, or null when we are not inside one (a field initializer, a
// class invariant, a contract on a declaration). Anything recorded outside a method belongs to no
// method, and attributing it to whichever ran last would be worse than not recording it.
SemanticAnalyzer::MethodFacts* SemanticAnalyzer::facts() {
    if (currentMethodKey_.empty()) {
        return nullptr;
    }
    auto it = methodFacts_.find(currentMethodKey_);
    return it == methodFacts_.end() ? nullptr : &it->second;
}

void SemanticAnalyzer::noteUnsafeForInterrupt(const std::string& what, SourceLocation loc) {
    if (MethodFacts* f = facts()) {
        f->unsafeOps.emplace_back(what, loc);
    }
}

// Rule 3, recorded per access. An interrupt and the code it preempts share memory, and the question
// "what may both of them touch?" already has an answer in Polaron: `volatile` for device memory,
// `atomic<T>` for counters and flags. So the rule requires ONE OF THOSE and invents no marker of its
// own -- the same argument `identity` settled: what makes two of these the same already has a name.
//
// Only MUTABLE fields qualify, and that is what makes the rule livable rather than theoretical.
// Everything in Polaron is immutable by default, so a handler reading `this.port` or `this.buffer` --
// a base address fixed at construction -- is untouched by this. What it catches is exactly the
// state a handler and a main loop both write: a ring buffer's head, a tick counter, a ready flag.
// THE RECEIVER DECIDES WHETHER THE STATE IS SHARED AT ALL, and getting that wrong is what a first
// version of this check did: it flagged `e.code` on an `Entry` the handler had just created two
// lines above, which is private to the handler by construction and cannot be seen by anything it
// preempted. A rule that fires on code that cannot possibly be wrong teaches people to reach for the
// escape hatch, and then it protects nothing.
//
// So: `this.field` and `Class.staticField` only. Those two ARE shared by construction -- the object
// outlives the entry (something else holds it, or the handler could not have been bound to it) and a
// static outlives everything. A field of a LOCAL is the case that needs real escape analysis to
// answer, and this does not have it.
//
// STATED LIMITATION, not a hidden one: a shared object passed in as a PARAMETER and written through
// that parameter is not caught. In practice the call graph closes most of that gap on its own -- a
// method called on the shared object checks its own `this` -- but a method handed someone else's
// object and writing its fields directly is a hole, and it is better written down than discovered.
// CHANGING A COPY THE CALLER WILL NEVER SEE.
//
// Assignment and argument passing are a deep COPY here (spec: to share, take `T*` or `T&`). So a
// method that receives an object by value and then changes it changes the callee's copy, and the
// caller's object is untouched. Nothing fails: the program runs, and the answer is wrong.
//
// Measured on this tree before it was written -- three of them in one night, all in the standard
// library, all of them mine, and all silent: a report that came back empty, a `render()` that
// returned "", a table that came out with no rows. Each cost an hour of bisecting output that looked
// like a logic bug and was not.
//
// The rule: a method CHANGES its object if it writes one of its own fields, or calls a method on
// `this` that does -- a fixpoint over the call graph the analyzer already records. Then any call to
// such a method on a by-value parameter is reported.
//
// A WARNING and not an error, deliberately. There is one honest use of the shape -- calling a
// mutating method on a copy on purpose, to leave the caller's object alone -- and it is rare enough
// to be worth a line of noise, while the mistake is common enough to be worth catching. The fix is
// one character, and the message says which.
// `this.f == null` (either way round) -> "f". The one shape whose write is not a change: see
// `lazyInitField_`. Deliberately syntactic and narrow -- a general "is this write dominated by a
// test of the same field" is a dataflow question, and the idiom it would buy over this is one
// nobody writes.
std::string SemanticAnalyzer::lazyInitGuardField(const ast::Expr& cond) {
    const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&cond);
    if (bin == nullptr || bin->op != "==") {
        return "";
    }
    const ast::Expr* fieldSide = nullptr;
    if (dynamic_cast<const ast::NullLiteralExpr*>(bin->rhs.get()) != nullptr) {
        fieldSide = bin->lhs.get();
    } else if (dynamic_cast<const ast::NullLiteralExpr*>(bin->lhs.get()) != nullptr) {
        fieldSide = bin->rhs.get();
    }
    if (fieldSide == nullptr) {
        return "";
    }
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(fieldSide);
    if (mem == nullptr) {
        return "";
    }
    const auto* obj = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
    return (obj != nullptr && obj->name == "this") ? mem->member : "";
}

void SemanticAnalyzer::checkByValueMutations() {
    if (byValueCalls_.empty()) {
        return;
    }
    // Which methods change their own object. Seeded with the ones that write a field directly, then
    // closed over the call graph: a method that calls a changing method on `this` changes it too.
    std::set<std::string> changes;
    for (const auto& [key, facts] : methodFacts_) {
        if (!facts.ownFieldsWritten.empty()) {
            changes.insert(key);
        }
    }
    bool grew = true;
    while (grew) {
        grew = false;
        for (const auto& [key, facts] : methodFacts_) {
            if (changes.count(key) > 0) {
                continue;
            }
            // Only calls made ON `this`. A call on some other object -- including a fresh one of the
            // same class, which is what a copy-builder does -- changes THAT object, and says nothing
            // about whether this method changes its own.
            for (const std::string& callee : facts.selfCallees) {
                if (changes.count(callee) > 0) {
                    changes.insert(key);
                    grew = true;
                    break;
                }
            }
        }
    }
    // ONCE PER PARAMETER, not once per call. A method that changes a copy usually does it several
    // times in a row, and three lines saying the same thing about the same parameter reads as three
    // problems. The first call is where a reader looks anyway.
    std::set<std::string> reported;
    for (const ByValueCall& c : byValueCalls_) {
        if (changes.count(c.callee) == 0) {
            continue;
        }
        if (!reported.insert(c.caller + "#" + c.param).second) {
            continue;
        }
        const std::string method = c.callee.substr(c.callee.rfind('.') + 1);
        warn("'" + method + "' changes the object it is called on, and '" + c.param +
                 "' is a parameter taken BY VALUE -- so it changes a copy, and the caller's object "
                 "is left as it was. Nothing will fail; the answer will just be wrong. Declare the "
                 "parameter as a pointer (`" + baseType(lookupLocalType(c.caller, c.param)) +
                 "* " + c.param + "`) to change the caller's object, or ignore this if changing the "
                 "copy is what you meant",
             c.loc);
    }
}

// The declared type of a parameter, for the message above. Empty when it cannot be recovered, which
// only costs the message its precision.
std::string SemanticAnalyzer::lookupLocalType(const std::string& methodKey,
                                              const std::string& param) const {
    auto it = paramTypes_.find(methodKey + "#" + param);
    return it == paramTypes_.end() ? std::string("T") : it->second;
}

void SemanticAnalyzer::noteFieldForInterrupt(const std::string& owner, const std::string& field,
                                             const FieldInfo& info, const ast::Expr* receiver,
                                             SourceLocation loc) {
    MethodFacts* f = facts();
    // Totality reads this: which of the source type's own fields the body actually touched.
    if (f != nullptr && !info.isStatic) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(receiver);
            id != nullptr && id->name == "this") {
            f->ownFieldsTouched.insert(field);
        }
    }
    if (f == nullptr || !info.isMutable || info.isVolatile) {
        return;
    }
    if (baseType(info.type).rfind("atomic", 0) == 0) {
        return;  // atomic<T> says it outright
    }
    if (!info.isStatic) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(receiver);
        if (id == nullptr || id->name != "this") {
            return;
        }
    }
    f->unsharedState.emplace_back(owner + "." + field, loc);
}

// Walks out from every `interrupt` over the recorded call graph and reports what it finds, with the
// PATH that reached it. The path is the point: "Ring.push allocates on the heap" is a fact about
// Ring, and a fact about Ring is not a bug. "Keyboard's interrupt reaches it, via push" is the bug,
// and it is the sentence that says which of the two to change.
void SemanticAnalyzer::checkInterruptReach() {
    for (const auto& [cls, loc] : interruptRoots_) {
        const std::string root = cls + ".interrupt";
        // BFS, keeping for each method the chain that first reached it -- the first chain found is
        // the shortest, which is the one worth printing.
        std::map<std::string, std::vector<std::string>> pathTo{{root, {}}};
        std::vector<std::string> queue{root};
        std::set<std::string> seen{root};
        std::set<std::string> reportedState;  // one diagnostic per field, however many times reached
        for (std::size_t i = 0; i < queue.size(); ++i) {
            const std::string here = queue[i];
            auto it = methodFacts_.find(here);
            if (it == methodFacts_.end()) {
                continue;  // extern, abstract, or not ours to see
            }
            const std::vector<std::string>& path = pathTo[here];
            // How the reader gets from the declaration to the line: " (reached via push, refill)".
            std::string via;
            if (!path.empty()) {
                via = " (reached via ";
                for (std::size_t j = 0; j < path.size(); ++j) {
                    if (j != 0) {
                        via += ", ";
                    }
                    via += path[j];
                }
                via += ")";
            }
            for (const auto& [what, where] : it->second.unsafeOps) {
                error("an interrupt must not " + what + via +
                          ". The code this handler interrupted may be standing inside the very "
                          "machinery this reaches -- the allocator, or the lock -- so it can be "
                          "entered while that machinery is half-way through its own work. C states "
                          "this rule in prose and checks none of it.",
                      where);
            }
            for (const auto& [name, where] : it->second.unsharedState) {
                if (!reportedState.insert(name).second) {
                    continue;
                }
                error("'" + name + "' is mutable state an interrupt reaches" + via +
                          ", so the handler and the code it preempts both touch it. Say so: "
                          "`volatile` when hardware is on the other end, `atomic<T>` for a counter "
                          "or a flag. Both are one instruction on x86-64 and neither needs a "
                          "runtime.",
                      where);
            }
            for (const std::string& callee : it->second.callees) {
                if (!seen.insert(callee).second) {
                    continue;
                }
                std::vector<std::string> next = path;
                next.push_back(callee.substr(callee.find('.') + 1));
                pathTo[callee] = std::move(next);
                queue.push_back(callee);
            }
        }
    }
}

// Registers each namespace-level `comptime literal` suffix function and checks
// its shape (spec 17.10): must be comptime, exactly one numeric parameter, and a
// known return type. The body is type-checked later, in analyzeLiteralBodies.
void SemanticAnalyzer::registerLiterals(const ast::Program& program) {
    auto reg = [&](const ast::LiteralDecl& lit, const std::string& owner, const std::string& nsName) {
        const std::string paramType = typeRefStr(lit.param.type);
        const std::string returnType = typeRefStr(lit.returnType);
        if (!lit.isComptime) {
            error("literal suffix '" + lit.name + "' must be 'comptime literal'", lit.loc);
        }
        if (!isNumeric(paramType)) {
            error("literal suffix '" + lit.name +
                      "' must take a numeric parameter (int or float family)",
                  lit.loc);
        }
        // Overloading by parameter type (spec 17.10 rule 6): seconds(int) and seconds(double)
        // may coexist; only a same-name, same-parameter-type redefinition is an error.
        for (const LiteralInfo& ov : literals_[lit.name]) {
            if (ov.paramType == paramType) {
                error("literal suffix '" + lit.name + "(" + paramType + ")' is already defined",
                      lit.loc);
            }
        }
        literals_[lit.name].push_back(
            LiteralInfo{paramType, returnType, lit.isComptime, lit.loc, owner});
        typeNamespace_[lit.name] = nsName;  // for import-prefix validation
        if (!owner.empty()) {
            classSuffixes_[owner].push_back(lit.name);  // import owner -> suffixes
        }
    };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            // A namespace-level literal suffix is a free declaration outside a class; a suffix must
            // be a member of the class/struct it produces (spec 17.10). Still registered so its uses
            // resolve and do not cascade.
            for (const ast::LiteralDecl& lit : ns.literals) {
                error("a 'comptime literal' suffix must be a member of a class or struct (declare it "
                      "inside the type it returns)",
                      lit.loc);
                reg(lit, "", ns.name);
            }
            // A literal suffix declared inside a class/struct is owned by that type (spec 17.10).
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get())) {
                        reg(*lit, cls.name, ns.name);
                    }
                }
            }
        }
    }
}

// Pass 1 for namespace-level consts (spec 28.1): record each name's type so that
// references resolve. Only primitive numeric / boolean / char consts are supported
// for now (no sizeof, no comptime functions -- those are later tiers).
void SemanticAnalyzer::registerConsts(const ast::Program& program) {
    auto reg = [&](const ast::ConstDecl& c, const std::string& owner) {
        const std::string type = typeRefStr(c.type);
        if (!isNumeric(type) && type != "boolean" && type != "char") {
            error("a 'fixed' must have a numeric, boolean, or char type, got '" + type + "'", c.loc);
            return;
        }
        const std::string key = owner.empty() ? c.name : owner + "." + c.name;
        if (constTypes_.count(key) > 0) {
            error("fixed '" + key + "' is already defined", c.loc);
            return;
        }
        constTypes_[key] = type;
    };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            // A namespace-level const is a free declaration outside a class; Polaron is OOP-mandatory,
            // so a const must be a static class/struct member (spec 28.1). Still registered so its
            // references resolve and do not cascade into spurious errors.
            for (const ast::ConstDecl& c : ns.consts) {
                error("a 'fixed' must be a static class or struct member; declare it inside a class",
                      c.loc);
                reg(c, "");
            }
            // A const declared inside a class/struct is a static member, keyed Owner.NAME.
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* c = dynamic_cast<const ast::ConstDecl*>(m.get())) {
                        reg(*c, cls.name);
                    }
                }
            }
        }
    }
}

// Indexes every `comptime` method by its (simple) name so the shared evaluator can
// resolve compile-time calls (spec 28.3). A comptime method is also an ordinary
// method, callable at runtime; the flag only enables compile-time folding.
void SemanticAnalyzer::registerComptimeMethods(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m != nullptr && m->isComptime && !m->isAbstract) {
                        comptimeMethods_.emplace(m->name, m);
                    }
                }
            }
        }
    }
}

// Indexes persistent fields (spec 18.15). Non-eternal ones must be released
// somewhere in the program; eternal ones are exempt.
void SemanticAnalyzer::registerPersistentFields(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                        f != nullptr && f->isPersistent) {
                        persistentFields_.push_back({cls.name, f->name, f->isEternal, f->loc});
                    }
                }
            }
        }
    }
}

// The class in `cls`'s hierarchy that declares persistent field `field`, or "".
std::string SemanticAnalyzer::persistentFieldOwner(const std::string& cls,
                                                   const std::string& field) const {
    std::string cur = cls;
    for (int depth = 0; !cur.empty() && depth < 256; ++depth) {
        for (const PersistentFieldInfo& pf : persistentFields_) {
            if (pf.cls == cur && pf.name == field) {
                return cur;
            }
        }
        auto it = classes_.find(cur);
        if (it == classes_.end()) {
            break;
        }
        cur = it->second.superclass;
    }
    return "";
}

void SemanticAnalyzer::markCascadeReleased(const std::string& typeName,
                                           std::unordered_set<std::string>& seen) {
    const std::string base = baseType(typeName);
    if (base.empty() || !seen.insert(base).second) {
        return;
    }
    for (std::string cur = base; !cur.empty();) {
        auto it = classes_.find(cur);
        if (it == classes_.end()) {
            break;
        }
        for (const PersistentFieldInfo& pf : persistentFields_) {
            if (pf.cls == cur) {
                releasedPersistents_.insert(cur + "." + pf.name);
            }
        }
        for (const auto& [fname, fi] : it->second.fields) {  // recurse into owned class fields
            if (fi.type.find('&') != std::string::npos || isArrayType(fi.type)) {
                continue;
            }
            if (classes_.find(baseType(fi.type)) != classes_.end()) {
                markCascadeReleased(fi.type, seen);
            }
        }
        cur = it->second.superclass;
    }
}

// Enforces the release obligation (spec 18.15): a non-eternal persistent field
// with no `release persistent` anywhere in the program is a compile error.
void SemanticAnalyzer::checkPersistentReleases() {
    for (const PersistentFieldInfo& pf : persistentFields_) {
        if (pf.isEternal) {
            continue;
        }
        if (releasedPersistents_.count(pf.cls + "." + pf.name) > 0) {
            continue;
        }
        error("persistent '" + pf.cls + "." + pf.name +
                  "' has no 'release persistent' anywhere in the program; non-eternal "
                  "persistents require explicit release (or mark the field 'eternal persistent')",
              pf.loc);
    }
}

// Pass 2: fold every const initializer and validate it is a compile-time constant of the right kind.
//
// TO A FIXED POINT, AND NOT IN DECLARATION ORDER. A constant defined in terms of another one is the
// ordinary way to say "this is the same number as that" -- `fixed int HIGH_CUT = Contour.HIGHLAND;`
// -- and folding in declaration order made that legal only when the other constant happened to be
// declared earlier, in a file the compiler happened to read first. The diagnostic was worse than the
// limit: it said the initializer "must be a compile-time constant" about something that plainly was
// one, so the reader went looking for the wrong thing (ledger RL-9, found while relayouting a
// world's contour table).
//
// So: sweep, and sweep again while anything new resolved. Order stops mattering, across classes and
// across files. Only what is still unresolved when nothing more can move is reported -- which is a
// genuine non-constant, or a ring of constants defined in terms of each other, and the message says
// both are possible because from here they look the same.
void SemanticAnalyzer::evaluateConsts(const ast::Program& program) {
    // CONSTANTS FOLD TO A FIXED POINT, NOT IN DECLARATION ORDER.
    //
    // A single sweep resolved a `fixed` only when everything it names had already been folded --
    // which made a perfectly ordinary constant legal or illegal depending on which file the
    // compiler happened to read first, and blamed the initializer for not being constant when it
    // plainly was. So the declarations go on a worklist and the sweep repeats while anything moved;
    // what is left when nothing moves is a genuine ring, and it is reported as one.
    struct Pending {
        const ast::ConstDecl* decl;
        std::string owner;
    };
    std::vector<Pending> waiting;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            for (const ast::ConstDecl& c : ns.consts) {
                waiting.push_back({&c, ""});
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* c = dynamic_cast<const ast::ConstDecl*>(m.get())) {
                        waiting.push_back({c, cls.name});
                    }
                }
            }
        }
    }
    // Answers whether it resolved. Silent while sweeping; the last call reports.
    auto fold = [&](const Pending& p, bool report) -> bool {
        const ast::ConstDecl& c = *p.decl;
        const std::string key = p.owner.empty() ? c.name : p.owner + "." + c.name;
        if (constTypes_.count(key) == 0) return true;  // rejected in pass 1: nothing to wait for
        if (c.init == nullptr) {
            if (report) error("fixed '" + key + "' must have an initializer", c.loc);
            return true;  // never going to resolve, and the reason is not order
        }
        const std::string type = constTypes_[key];
        if (isFloatType(type)) {
            double d;
            if (evalConstDouble(*c.init, d, &constDoubles_, &constInts_, &comptimeMethods_,
                                &enums_)) {
                constDoubles_[key] = d;
                return true;
            }
        } else {
            long long v;
            if (evalConstInt(*c.init, v, &constInts_, &comptimeMethods_, &constDoubles_, &enums_)) {
                constInts_[key] = v;
                return true;
            }
        }
        if (report)
            error("fixed '" + key + "' initializer must be a compile-time constant. If it names "
                  "another `fixed`, check that one is not defined in terms of this one -- a ring of "
                  "constants has no value to start from",
                  c.loc);
        return false;
    };
    bool moved = true;
    while (moved) {
        moved = false;
        for (auto it = waiting.begin(); it != waiting.end();) {
            if (fold(*it, /*report=*/false)) {
                it = waiting.erase(it);
                moved = true;
            } else {
                ++it;
            }
        }
    }
    for (const Pending& p : waiting) fold(p, /*report=*/true);
}

// Resolves each import against the spec 2.7 model: an intra-program import names the FULL path,
// bundle first, then the namespace, then the symbol (`import Forge.App.Controller;`). The last
// component is the symbol; the first must be a real bundle. Importing a literal suffix enables its
// `N suffix` syntax (spec 17.10 rule 5). An unknown symbol, an unknown bundle, or a namespace that
// does not match the symbol's real home is an error.
void SemanticAnalyzer::processImports(const ast::Program& program) {
    auto validate = [&](const ast::ImportDecl& imp) {
        if (imp.path.empty()) {
            return;
        }
        const std::string& symbol = imp.path.back();
        std::string full;
        for (std::size_t i = 0; i < imp.path.size(); ++i) {
            full += (i > 0 ? "." : "") + imp.path[i];
        }
        // Bring the symbol's literal suffixes into scope regardless of the path check below, so a
        // path mistake reports once and does not cascade into "unknown suffix/type" noise. (Type
        // visibility itself is gated by currentImports_, populated from the path's last segment.)
        auto bringIntoScope = [&]() {
            importedSuffixes_.insert(symbol);  // harmless for non-literals
            if (auto cs = classSuffixes_.find(symbol); cs != classSuffixes_.end()) {
                for (const std::string& s : cs->second) {
                    importedSuffixes_.insert(s);
                }
            }
            if (imp.isFinal) {
                finalImports_.insert(symbol);  // spec 37.6: not unimportable
            }
        };
        // Cross-program (spec 2.7/2.8): reached over IPC, the path rooted at the program name
        // (`import from program GameEngine GameEngine.audio.mixers.Foo;`). Its types are synthesized as
        // IPC proxies, so validate leniently -- just require the symbol to exist locally as a proxy.
        // WHAT BARE METAL CANNOT HAVE, REFUSED AT THE IMPORT.
        //
        // The restriction was never "the standard library needs a runtime" -- most of it does not. A
        // collection compiles freestanding today and links against the program's own `heap class`;
        // `Buffer`, `Math`, `Raw` and the unit literals need nothing at all. What genuinely cannot work
        // is the part that is a call into a HOST OPERATING SYSTEM: there is no stdio to print through,
        // no filesystem, no sockets, no process to spawn, no OS thread to create.
        //
        // Reported HERE, at the import, rather than at the first use. The import is where the
        // programmer said they wanted it, it is one line instead of thirty, and it is the difference
        // between "you cannot have this" and "this one call happens to be unavailable" -- which reads
        // like an oversight and invites working around it.
        if (freestanding_ && std::string(imp.loc.file) != "<prelude>") {
            const std::string why = SemanticAnalyzer::hostedOnlyReason(symbol);
            if (!why.empty()) {
                error("'" + symbol + "' is not available in freestanding mode (spec 36.3): " + why,
                      imp.loc);
                bringIntoScope();   // keep going: one honest error beats a cascade of unknown names
                return;
            }
        }
        if (!imp.programName.empty()) {
            if (typeNamespace_.find(symbol) == typeNamespace_.end()) {
                error("import of unknown symbol '" + full + "' from program '" + imp.programName + "'",
                      imp.loc);
            }
            bringIntoScope();
            return;
        }
        // AN ANNOTATION IS IMPORTED LIKE ANY OTHER DECLARATION, and it is checked first because a
        // class of the same name may also exist -- the two are allowed to coexist, so the path the
        // author wrote is what says which one they mean. `import System.Validate.Range;` names the
        // annotation even though `System.Collections.Range` is a class.
        if (auto aIt = annotationNamespace_.find(symbol); aIt != annotationNamespace_.end()) {
            std::string annNs;
            for (std::size_t i = 1; i + 1 < imp.path.size(); ++i) {
                annNs += (annNs.empty() ? "" : ".") + imp.path[i];
            }
            const std::string annBundle =
                annotationBundle_.count(symbol) ? annotationBundle_[symbol] : std::string();
            if (annNs == aIt->second && (annBundle.empty() || imp.path.front() == annBundle)) {
                bringIntoScope();
                return;
            }
            // Falls through when the path does not name the annotation: it may still name a class of
            // the same name, which the ordinary lookup below answers.
        }
        auto nsIt = typeNamespace_.find(symbol);
        if (nsIt == typeNamespace_.end()) {
            // A type name declared in MORE THAN ONE namespace is renamed to `<ns>__<Type>` by the
            // namespace-disambiguation pass (monomorphize.cpp), so the bare name is no longer in the
            // registry -- and this validator would report the import of a perfectly good type as an
            // unknown symbol. Retry with the disambiguated name built from this import's own
            // namespace path: if that exists, the import names a real type and is well-formed.
            std::string disambiguated;
            for (std::size_t i = 1; i + 1 < imp.path.size(); ++i) {
                disambiguated += (disambiguated.empty() ? "" : "_") + imp.path[i];
            }
            if (!disambiguated.empty()) {
                disambiguated += "__" + symbol;
                if (typeNamespace_.count(disambiguated) > 0) {
                    importedSuffixes_.insert(disambiguated);
                    if (imp.isFinal) {
                        finalImports_.insert(disambiguated);
                    }
                    bringIntoScope();
                    return;
                }
            }
            error("import of unknown symbol '" + full + "'", imp.loc);
            bringIntoScope();
            return;
        }
        // A bare, bundle-less builtin import (`import reflect;`): a single segment, nothing to qualify.
        if (imp.path.size() == 1) {
            bringIntoScope();
            return;
        }
        // Full path (spec 2.7): Bundle.Namespace[.Sub].Type. The first segment must name a real bundle;
        // everything between it and the type must be the type's real namespace.
        const std::string& bundleSeg = imp.path.front();
        std::string nsPath;  // path[1 .. size-2]
        for (std::size_t i = 1; i + 1 < imp.path.size(); ++i) {
            nsPath += (nsPath.empty() ? "" : ".") + imp.path[i];
        }
        // WHICH `Scanner` IS BEING IMPORTED. `typeNamespace_`/`typeBundle_` hold one answer per bare
        // name, so when two types share one, the import of the OTHER was judged against this one's
        // namespace and refused: `'Color' is imported as 'Main.App.Color'; the path
        // 'System.Spatial.Color' does not match its bundle/namespace` -- a path that is exactly right.
        //
        // The type table holds every one of them, so an import that names a real path is checked
        // against THAT path rather than against whichever declaration happened to take the bare key.
        std::string realNs = nsIt->second;
        std::string realBundle = typeBundle_.count(symbol) ? typeBundle_[symbol] : std::string();
        if (writtenNameCount(symbol) > 1) {
            const std::string full = bundleSeg + (nsPath.empty() ? "" : "." + nsPath) + "." + symbol;
            if (auto exact = typeByCanonical_.find(full); exact != typeByCanonical_.end()) {
                realNs = types_[exact->second].ns;
                realBundle = types_[exact->second].bundle;
            }
        }
        // AND THE SAME FOR A GENERIC, whose template is gone before this runs. A program declaring
        // its own `Stack<T>` beside the library's made `import System.Collections.Stack;` -- written
        // by the library, about its own type -- fail against the USER's namespace, because the one
        // slot per name held whichever was recorded last. Any declaration whose namespace the path
        // names is the one being imported.
        if (auto gh = genericHomes_.find(symbol); gh != genericHomes_.end()) {
            for (const std::string& home : gh->second) {
                if (home == nsPath) {
                    realNs = home;
                    if (auto nb = namespaceBundle_.find(home); nb != namespaceBundle_.end()) {
                        realBundle = nb->second;
                    }
                    break;
                }
            }
        }
        const std::string want =
            (realBundle.empty() ? std::string("<bundle>") : realBundle) + "." + realNs + "." + symbol;
        // The first segment is valid if it names a declared/imported bundle, or the symbol's own
        // registered bundle -- the latter covers a virtual builtin (System.Memory) whose bundle exists
        // even when the prelude that declares it is not part of this compilation.
        const bool bundleOk =
            bundleNames_.count(bundleSeg) > 0 || (!realBundle.empty() && bundleSeg == realBundle);
        if (bundleOk && nsPath == realNs) {
            bringIntoScope();  // well-formed full path
        } else if (!bundleOk && (nsPath == realNs || full == realNs + "." + symbol)) {
            // Resolves by namespace but names no real bundle first: the pre-2.7 short form. Point at
            // the full path the type now requires.
            error("import '" + symbol + "' by its full path: 'import " + want +
                      ";' -- imports now name the bundle first, then the namespace (spec 2.7)",
                  imp.loc);
            bringIntoScope();
        } else {
            error("'" + symbol + "' is imported as '" + want + "'; the path '" + full +
                      "' does not match its bundle/namespace (spec 2.7)",
                  imp.loc);
            bringIntoScope();
        }
    };
    for (const ast::ImportDecl& imp : program.imports) {
        validate(imp);  // file-level (spec 2.7)
    }
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::ImportDecl& imp : bundle.imports) {
            validate(imp);
        }
    }
}

// Type-checks the body of each literal suffix, with its single parameter in
// scope and treated like a static function (no `this`).
void SemanticAnalyzer::analyzeLiteralBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        currentBundle_ = bundle.name;  // for the stdlib-cohesion visibility check
        currentImports_.clear();
        currentImportPaths_.clear();
        const bool inheritsImports = !bundle.isPrelude;   // see the note in the walk above
        for (const ast::ImportDecl& imp : program.imports) {
            if (inheritsImports && !imp.path.empty()) {
                currentImports_.insert(imp.path.back());
                // AND THE WHOLE PATH, because the last segment is not the answer when two types
                // answer to it. `import System.Units.Angle;` beside a `System.Math.Angle` says
                // exactly which one is meant, and keeping only "Angle" threw that away -- resolution
                // then saw both as imported and picked the first.
                if (imp.path.size() >= 3) {
                    std::string full;
                    for (const std::string& seg : imp.path) {
                        full += (full.empty() ? "" : ".") + seg;
                    }
                    currentImportPaths_.insert(full);
                }
            }
        }
        for (const ast::ImportDecl& imp : bundle.imports) {
            if (!imp.path.empty()) {
                currentImports_.insert(imp.path.back());
                // AND THE WHOLE PATH, because the last segment is not the answer when two types
                // answer to it. `import System.Units.Angle;` beside a `System.Math.Angle` says
                // exactly which one is meant, and keeping only "Angle" threw that away -- resolution
                // then saw both as imported and picked the first.
                if (imp.path.size() >= 3) {
                    std::string full;
                    for (const std::string& seg : imp.path) {
                        full += (full.empty() ? "" : ".") + seg;
                    }
                    currentImportPaths_.insert(full);
                }
            }
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;   // see the note on lookupShared: every pass must say where it is
            currentBundle_ = bundle.name;
            currentNamespace_ = ns.name;
            // A LiteralDecl is its own AST node, not a MethodDecl, so the member loop above never set
            // `currentReturnType_` for one -- its body was analyzed carrying whatever the LAST method
            // analyzed had left there. Harmless while only nullability was checked (both sides
            // non-nullable), and a wave of false "cannot return X from a method returning boolean" the
            // moment the return TYPE was checked. A literal suffix returns a type like anything else.
            for (const ast::LiteralDecl& lit : ns.literals) {
                currentReturnType_ = typeRefStr(lit.returnType);
                currentReturnIsMove_ = false;
                currentThrows_.clear();
                analyzeMethodBody(lit.body, {lit.param}, /*thisClass=*/"", /*inConstructor=*/false);
            }
            // Class/struct-owned literal suffix bodies (spec 17.10): static, so no `this`.
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get())) {
                        currentReturnType_ = typeRefStr(lit->returnType);
                        currentThrows_.clear();
                        analyzeMethodBody(lit->body, {lit->param}, /*thisClass=*/"",
                                          /*inConstructor=*/false);
                    }
                }
            }
            currentReturnType_.clear();
        }
    }
}

// Recursively collects `label name;` markers from a statement (into nested control-flow blocks,
// but not into lambda bodies -- expressions are not traversed here). Used for tetrad validation.
static void collectLabelsInStmt(const ast::Stmt* st, std::unordered_set<std::string>& out) {
    if (st == nullptr) {
        return;
    }
    if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(st)) { out.insert(lm->name); return; }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            collectLabelsInStmt(s.get(), out);
        }
    };
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) {
        blk(i->thenBlock);
        if (i->elseBlock) {
            blk(*i->elseBlock);
        }
        return;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) { blk(w->body); return; }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) { blk(d->body); return; }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) { blk(f->body); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) { blk(fe->body); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (auto& c : sw->cases) {
            blk(c.body);
        }
        if (sw->defaultBody) {
            blk(*sw->defaultBody);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (auto& c : ms->cases) {
            blk(c.body);
        }
        if (ms->defaultBody) {
            blk(*ms->defaultBody);
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
        blk(tr->body);
        for (auto& c : tr->catches) {
            blk(c.body);
        }
        if (tr->finallyBlock) {
            blk(*tr->finallyBlock);
        }
        return;
    }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) { blk(df->body); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) { blk(us->body); return; }
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { collectLabelsInStmt(lb->stmt.get(), out); return; }
}

void SemanticAnalyzer::collectMethodLabels(const ast::Block& block) {
    for (const auto& s : block.statements) {
        collectLabelsInStmt(s.get(), methodLabels_);
    }
}

void SemanticAnalyzer::analyzeMethodBody(const ast::Block& body,
                                         const std::vector<ast::Param>& params,
                                         const std::string& thisClass, bool inConstructor,
                                         const std::vector<const ast::Expr*>& contracts,
                                         const std::vector<const ast::Expr*>& postconditions,
                                         const std::string& postResultType) {
    scopes_.clear();
    moved_.clear();
    // The flow facts describe THIS method's locals and mean nothing in the next one. Leaving them behind
    // made a `delete b` in one stdlib method report every later method's `b` as a use-after-free -- 51
    // tests failing on the same variable name, from a file none of them mentions.
    freed_.clear();
    init_.clear();
    nonNull_.clear();
    suppressNarrowing_ = false;
    activationOwned_.clear();
    lambdaLocals_.clear();
    extracted_.clear();
    checkpointRegion_.clear();
    regionOf_.clear();
    deleted_.clear();
    alreadyOwnedHere_.clear();
    acquired_.clear();
    borrowedRegion_.clear();
    borrowsFrom_.clear();
    invalidatedAt_.clear();
    parentRegion_.clear();
    // WHOSE VALUES THE CALLER CAN SEE. A store into `this` of something the caller handed us is a
    // question only the caller can answer, and answering it here reported the wrong line -- so the
    // check needs to know which names came from outside.
    currentParamNames_.clear();
    for (const ast::Param& p : params) {
        currentParamNames_.insert(p.name);
    }
    catchStack_.clear();
    regionConstraints_.clear();
    regionFlavor_.clear();
    methodLabels_.clear();
    comefromTargets_.clear();
    collectMethodLabels(body);  // chaos tetrad targets are validated against these (spec 7.9-7.11)
    detectComefromLoops(body);  // best-effort infinite-loop warning (spec 7.10 rule 7)
    currentClass_ = thisClass;
    inConstructor_ = inConstructor;
    pushScope();
    for (const ast::Param& p : params) {
        LocalVar lv{typeRefStr(p.type), false};  // params immutable by default
        // A class-typed parameter with no `*` or `&` arrives as a deep COPY, and everything the body
        // changes about it is changed in that copy. Marked here so the by-value mutation check can
        // ask; a pointer, a reference, a primitive and a String (immutable) are all excluded.
        const std::string pt = lv.type;
        if (!pt.empty() && pt.back() != '*' && pt.back() != '&' && !isArrayType(pt) &&
            pt != "String" && pt != "string" && lookupClass(baseType(pt)) != nullptr) {
            lv.isByValueClassParam = true;
            if (!currentMethodKey_.empty()) {
                paramTypes_[currentMethodKey_ + "#" + p.name] = pt;
            }
        }
        declareLocal(p.name, lv);
    }
    // DEFINITE ASSIGNMENT FOR FIELDS. Seeded here so the flow machinery that already exists for locals
    // does the work: `init_` is keyed by opaque strings, and the join at a branch merge operates on the
    // map without caring what the keys mean -- so a field entered as `this.name` gets Uninit/Maybe/Init
    // exactly as a local does, including the "assigned on only one path" case that is the hard one.
    //
    // Only in a constructor, and only for fields that have nowhere else to get a value from. See
    // `fieldNeedsInit` for what is excluded and why.
    if (inConstructor) {
        for (const auto& [fname, floc] : pendingCtorFields_) {
            init_["this." + fname] = FlowFacts::Init::Uninit;
        }
    }
    // ...and the same for a bound target, through the same map and the same join. `f.degrees` is a
    // key like any other, so the hard case comes free: assigned on only one branch reports as Maybe,
    // which is a different message and a different mistake.
    if (!boundTargetName_.empty()) {
        for (const auto& [fname, floc] : pendingBoundFields_) {
            init_[boundTargetName_ + "." + fname] = FlowFacts::Init::Uninit;
        }
    }
    for (std::size_t i = 0; i < body.statements.size(); ++i) {
        // `super(...)` is only legal as the very first statement of a constructor.
        if (inConstructor && i != 0) {
            const auto* es = dynamic_cast<const ast::ExprStmt*>(body.statements[i].get());
            const auto* call = es ? dynamic_cast<const ast::CallExpr*>(es->expr.get()) : nullptr;
            if (call != nullptr &&
                dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
                error("'super(...)' must be the first statement of the constructor",
                      body.statements[i]->loc);
            }
        }
        analyzeStatement(*body.statements[i]);
    }
    // Contract clauses (spec 29) are boolean expressions over params/this/fields.
    for (const ast::Expr* clause : contracts) {
        const std::string t = typeOf(*clause);
        if (!t.empty() && t != "boolean") {
            error("a contract clause must be boolean, got '" + t + "'", clause->loc);
        }
    }
    // Postconditions, with `result` in scope. In their own scope so the binding cannot leak into the
    // body or into a sibling method, and AFTER the preconditions so a `requires` naming `result` is
    // still the undeclared-name error it should be -- on entry there is no result to talk about.
    if (!postconditions.empty()) {
        pushScope();
        if (!postResultType.empty()) {
            declareLocal("result", LocalVar{postResultType, false});
        }
        for (const ast::Expr* clause : postconditions) {
            const std::string t = typeOf(*clause);
            if (!t.empty() && t != "boolean") {
                error("a contract clause must be boolean, got '" + t + "'", clause->loc);
            }
        }
        popScope();
    }
    popScope();
}

void SemanticAnalyzer::analyzeBlock(const ast::Block& block) {
    pushScope();
    for (const auto& stmt : block.statements) {
        analyzeStatement(*stmt);
    }
    popScope();
}

bool SemanticAnalyzer::isCompileTimeConstant(const ast::Expr& e) const {
    // A literal suffix applies to a compile-time-known value (spec 17.10): a numeric/char/boolean
    // literal, a namespace `const`, or arithmetic/casts over those. This is what stops a
    // `comptime literal` from being abused as a runtime free function -- it can only transform
    // constants, never run on a runtime argument.
    if (dynamic_cast<const ast::IntLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (dynamic_cast<const ast::FloatLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (dynamic_cast<const ast::CharLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e)) {
        return constTypes_.count(id->name) > 0;  // a folded namespace const
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        return isCompileTimeConstant(*u->operand);
    }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(&e)) {
        return isCompileTimeConstant(*c->operand);
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        return isCompileTimeConstant(*b->lhs) && isCompileTimeConstant(*b->rhs);
    }
    return false;
}

std::string SemanticAnalyzer::analyzeYieldBlock(const ast::Block& body) {
    // Analyzes a match-expression block arm (spec 16.2) in its own scope (the case bindings are
    // already declared by the caller) and returns the type `yield` produces.
    pushScope();
    std::string yieldType;
    for (const auto& stmt : body.statements) {
        analyzeStatement(*stmt);
        if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(stmt.get());
            ys != nullptr && ys->value != nullptr) {
            yieldType = typeOf(*ys->value);
        }
    }
    popScope();
    return yieldType;
}

std::string SemanticAnalyzer::analyzeExpectingBlock(const ast::Block* block) {
    if (block == nullptr) {
        return "";
    }
    const std::string savedRet = currentReturnType_;
    currentReturnType_.clear();  // the block's return is its own value, not the method's
    pushScope();
    std::string valueType;
    for (const auto& stmt : block->statements) {
        analyzeStatement(*stmt);
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(stmt.get());
            rs != nullptr && rs->value != nullptr) {
            valueType = typeOf(*rs->value);
        }
    }
    popScope();
    currentReturnType_ = savedRet;
    return valueType;
}

void SemanticAnalyzer::checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                                         SourceLocation loc, const ast::Expr* valueExpr) {
    // A compile-time integer literal coerces to a narrower target type when it fits (spec).
    auto fits = [&](const std::string& targetType) {
        return valueExpr != nullptr && intLiteralFits(*valueExpr, targetType);
    };
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error(diag::Code::UndeclaredVariable,
                  "assignment to undeclared variable '" + id->name + "'" +
                      didYouMean(id->name, namesInScope()),
                  loc);
            return;
        }
        // A region handle may be (re)bound to bind an empty `region r;` to its allocation (spec 17.2
        // form 3), so region locals are assignable without an explicit `mutable`.
        //
        // DEFERRED INITIALIZATION: the first write to a variable declared without a value is not a
        // reassignment, it is the initialization -- the value is still written exactly once, which is
        // what immutability actually promises. So it is allowed without `mutable`, and the SECOND write
        // is the one that needs it. This is what lets a value be chosen in a branch without making the
        // binding mutable for the rest of its life, which is how `mutable` stays meaningful.
        const bool initializingNow =
            var->deferredInit && initStateOf(id->name) != FlowFacts::Init::Init;
        if (!var->isMutable && var->type != "region" && !initializingNow) {
            error(var->deferredInit
                      ? "cannot assign to '" + id->name +
                            "' again: it was declared without a value and has already been initialized, "
                            "which used up its single write. Declare it 'mutable' if it really needs to "
                            "change"
                      : "cannot assign to immutable variable '" + id->name + "' (declare it 'mutable')",
                  loc);
        }
        markInitialized(id->name);
        // Whatever was proven about the OLD value says nothing about the new one.
        killProofsFor(id->name);
        if (!valueType.empty() && valueType != "null" && !isNullableType(valueType)) {
            nonNull_.insert(id->name);
        }
        if (!valueType.empty() &&
            (!isSubtype(valueType, var->type) || isBoxedSumMismatch(valueType, var->type)) &&
            !fits(var->type)) {
            error("cannot assign a value of type '" + valueType + "' to variable '" + id->name +
                      "' of type '" + var->type + "'" + sumFormHint(valueType, var->type),
                  loc);
        }
        return;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        // Static field target: ClassName.field (receiver names a class, not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (objId->name != "this" && lookupLocal(objId->name) == nullptr &&
                lookupClass(objId->name) != nullptr) {
                const FieldInfo* f = findField(objId->name, mem->member);
                if (f == nullptr || !f->isStatic) {
                    error("class '" + objId->name + "' has no static field '" + mem->member + "'",
                          loc);
                    return;
                }
                if (!f->isMutable) {
                    error("cannot assign to immutable static field '" + mem->member +
                              "' (declare it 'mutable')",
                          loc);
                }
                if (!valueType.empty() &&
                    (!isSubtype(valueType, f->type) || isBoxedSumMismatch(valueType, f->type)) &&
                    !fits(f->type)) {
                    error("cannot assign a value of type '" + valueType + "' to static field '" +
                              mem->member + "' of type '" + f->type + "'" +
                              sumFormHint(valueType, f->type),
                          loc);
                }
                return;
            }
        }
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) {
            return;
        }
        if (vecWidth(objType) > 0 && vecLane(mem->member) >= 0) {  // SIMD lane write: v.x = f
            if (const auto* bid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (const LocalVar* lv = lookupLocal(bid->name); lv != nullptr && !lv->isMutable) {
                    error("cannot modify a lane of immutable vector '" + bid->name +
                              "' (declare it 'mutable')",
                          loc);
                }
            }
            if (!valueType.empty() && !isNumeric(valueType)) {
                error("a vector lane takes a numeric value, not '" + valueType + "'", loc);
            }
            return;
        }
        const FieldInfo* f = findField(objType, mem->member);
        if (f != nullptr) {
            noteFieldForInterrupt(objType, mem->member, *f, mem->object.get(), loc);  // rule 3, write
            // ...and separately, that this body CHANGES its own object -- which `ownFieldsTouched`
            // cannot say, since it does not tell a read from a write. It is the fact the by-value
            // mutation check is built on.
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                oid != nullptr && oid->name == "this" && !f->isStatic &&
                mem->member != lazyInitField_) {
                if (MethodFacts* mf = facts()) {
                    mf->ownFieldsWritten.insert(mem->member);
                }
            }
        }
        // THE TRAP IS READ-ONLY, and this is measured rather than conservative. `x86_intrcc` takes
        // the frame as a `byval` parameter, which promises the callee a PRIVATE COPY -- so LLVM is
        // entitled to treat writes through it as writes to that copy, and it does. At -O2 a plain
        // store is deleted outright; a `volatile` one survives but lands in a scratch buffer the
        // epilogue discards (`subq $16,%rsp` ... `addq $16,%rsp`), never touching the frame `iretq`
        // pops. A scheduler written this way compiles, runs, and never schedules.
        //
        // So the language refuses it instead of letting it look like it works. Preemption -- the
        // one case that needs a writable frame -- stays out of reach of this calling convention,
        // which is what the design note predicted and this now proves.
        if (!interruptTrapParam_.empty()) {
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                tid != nullptr && tid->name == interruptTrapParam_) {
                error("the trap an interrupt receives is READ-ONLY. It arrives as a `byval` "
                      "parameter, which promises a private copy, so the optimizer deletes a write "
                      "to it (or lands it in scratch the epilogue throws away) and `iretq` still "
                      "returns exactly where it came from -- measured, at -O2. Resuming somewhere "
                      "else is not expressible through this calling convention: read the frame "
                      "here, and switch on the way out.",
                      loc);
            }
        }
        if (f == nullptr) {
            // A computed property with a custom setter (spec 8.4): `obj.prop = v` routes to prop$set.
            if (findMethod(objType, mem->member + "$set") != nullptr) {
                if (const MethodInfo* getter = findMethod(objType, mem->member);
                    getter != nullptr && !valueType.empty() &&
                    (!isSubtype(valueType, getter->returnType) ||
                     isBoxedSumMismatch(valueType, getter->returnType))) {
                    error("cannot assign a value of type '" + valueType + "' to property '" +
                              mem->member + "'" + sumFormHint(valueType, getter->returnType),
                          loc);
                }
                return;
            }
            error(diag::Code::NoSuchField,
                  "class '" + objType + "' has no field '" + mem->member + "'" +
                      didYouMean(mem->member, fieldNames(objType)),
                  loc);
            return;
        }
        // Immutable fields may still be initialized via `this.field` in a constructor.
        const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        const bool isThisField = objId != nullptr && objId->name == "this";
        if (!f->isMutable && !(inConstructor_ && isThisField)) {
            error("cannot assign to immutable field '" + mem->member + "' (declare it 'mutable')",
                  loc);
        }
        if (!valueType.empty() &&
            (!isSubtype(valueType, f->type) || isBoxedSumMismatch(valueType, f->type)) &&
            !fits(f->type)) {
            // Say WHY, not just that. A null (or nullable) value reaching a non-nullable field is the
            // commonest version of this error and the one whose remedy the generic wording gets wrong:
            // you cannot cast null into a non-nullable type, you declare the field `nullable`.
            if ((valueType == "null" || isNullableType(valueType)) && !isNullableType(f->type)) {
                error("cannot assign " + std::string(valueType == "null" ? "null" : "a nullable value") +
                          " to field '" + mem->member + "': its type '" + f->type +
                          "' is non-nullable, and every type in Polaron is non-null unless it says "
                          "otherwise. Declare the field 'nullable " + f->type +
                          "' if it can legitimately be absent",
                      loc);
            } else {
                error("cannot assign a value of type '" + valueType + "' to field '" + mem->member +
                          "' of type '" + f->type + "'" + sumFormHint(valueType, f->type),
                      loc);
            }
        }
        // Reassigning a partially-moved field reactivates it (spec 19.9).
        if (objId != nullptr) {
            moved_.erase(objId->name + "." + mem->member);
        }
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&target)) {
        const std::string at = typeOf(*ix->array);
        typeOf(*ix->index);
        if (vecWidth(at) > 0) {  // SIMD lane write: v[i] = f
            if (const auto* bid = dynamic_cast<const ast::IdentifierExpr*>(ix->array.get())) {
                if (const LocalVar* lv = lookupLocal(bid->name); lv != nullptr && !lv->isMutable) {
                    error("cannot modify a lane of immutable vector '" + bid->name +
                              "' (declare it 'mutable')",
                          loc);
                }
            }
            if (!valueType.empty() && !isNumeric(valueType)) {
                error("a vector lane takes a numeric value, not '" + valueType + "'", loc);
            }
            return;
        }
        if (findMethod(baseType(at), "operator[]=")) {
            return;  // operator[]= overload (spec 6.5)
        }
        if (!at.empty() && !isArrayType(at) && !isFixedArrayType(at) && !isRefType(at)) {
            error("cannot index a value of non-array type '" + at + "'", loc);
            return;
        }
        const std::string et = isRefType(at) ? baseType(at) : elementOf(at);  // p[i] = v on a T*
        if (!valueType.empty() && !et.empty() &&
            (!isSubtype(valueType, et) || isBoxedSumMismatch(valueType, et))) {
            error("cannot assign a value of type '" + valueType +
                      "' to an array element of type '" + et + "'" + sumFormHint(valueType, et),
                  loc);
        }
        return;
    }
    // `*p = value`: dereference-assign through a pointer. The value must fit the pointee type (the
    // operand's type with one '*' peeled).
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&target); un != nullptr && un->op == "*") {
        const std::string pt = typeOf(*un->operand);
        if (!pt.empty() && pt.back() != '*') {
            error("cannot dereference '" + pt + "': it is not a pointer", loc);
            return;
        }
        const std::string pointee =
            (pt.empty() || pt.back() != '*') ? std::string() : pt.substr(0, pt.size() - 1);
        if (!valueType.empty() && !pointee.empty() &&
            (!isSubtype(valueType, pointee) || isBoxedSumMismatch(valueType, pointee)) &&
            !fits(pointee)) {
            error("cannot assign a value of type '" + valueType + "' through a '" + pt +
                      "' pointer to '" + pointee + "'" + sumFormHint(valueType, pointee),
                  loc);
        }
        return;
    }
    error("invalid assignment target", loc);
}

// Bit-counted type names (int8..int64, uint8..uint64, float32/64) exist only in freestanding mode
// (spec 3.1); in normal mode the named types (byte/short/int/long, float/double, ...) are required.
// Widening the RESULT of a narrow computation is almost always a bug, and a silent one: in
// `cast<address>(f << 12)` the shift already happened in 32 bits, so the high bits are gone before the
// cast runs -- the cast only documents the loss. The fix is always to widen the OPERAND first
// (`cast<address>(f) << 12`), which is one character of difference and a completely different result.
//
// This is the compile-time half of Polaron's no-implicit-conversion rule. Refusing implicit narrowing stops
// a value being silently truncated on the way IN; this stops a value being silently truncated on the way
// UP. Both exist because the compiler is not allowed to assume which width the author meant -- and in a
// kernel the wrong answer is a page mapped somewhere else, discovered much later and somewhere unrelated.
//
// Only the operators that can carry bits past the narrow width are flagged (`<<`, `*`, `+`, `-`); `&`,
// `|`, `>>` and comparisons cannot produce a value the narrow type could not already hold.
void SemanticAnalyzer::checkWideningLostBits(const ast::CastExpr& cst, const std::string& src,
                                             const std::string& dst) {
    if (!isIntName(src) || !isIntName(dst)) {
        return;
    }
    if (intBits(dst) <= intBits(src)) {
        return;  // not a widening cast
    }
    const auto* bin = dynamic_cast<const ast::BinaryExpr*>(cst.operand.get());
    if (bin == nullptr) {
        return;
    }
    const std::string& op = bin->op;
    if (op != "<<") {
        return;
    }
    // `<<` ONLY, and that scope was measured rather than guessed. A left shift pushes bits straight out
    // of the top, so widening afterwards is essentially always the wrong order -- there is no common
    // correct code shaped like `cast<long>(x << k)`. `*`, `+` and `-` overflow only when the values are
    // large, and `cast<long>(i * n)` over loop indices is a correct idiom that appears throughout real
    // code (it fired on matmul and recursion tests here). Flagging those would make this noise, and a
    // diagnostic people learn to ignore protects nothing.
    error("widening the result of a narrow '" + op + "': `" + src + "` arithmetic is evaluated in " +
              std::to_string(intBits(src)) + " bits, so bits are lost BEFORE this cast to '" + dst +
              "'. Widen the operand instead: cast<" + dst + ">(x) " + op + " y",
          cst.loc);
}

// Which standard-library names a freestanding program cannot have, and WHY -- one sentence each,
// naming what is actually missing underneath.
//
// THE LIST IS SHORT ON PURPOSE, and getting it right is the whole point of having it. It was believed
// for a long time that freestanding meant "no standard library at all"; it does not, and the spec said
// so more strongly than the compiler ever enforced. Everything absent from this list works, or works
// once the program declares a `heap class` -- which is exactly the split C++ makes when it excludes
// <iostream> and <thread> from a freestanding implementation and keeps the rest.
//
// The test for membership is "does this reach for the operating system", not "does this allocate".
// Allocation has an answer bare metal: the program's own heap. A socket does not.
std::string SemanticAnalyzer::hostedOnlyReason(const std::string& symbol) {
    if (symbol == "Console") {
        return "it prints through the managed runtime's stdio, which bare metal does not have. Write "
               "to your own device -- a serial port or a framebuffer -- through FFI or MMIO";
    }
    if (symbol == "File" || symbol == "Paths" || symbol == "Directory") {
        return "it calls the host operating system's filesystem. A freestanding program IS the system: "
               "it must reach its storage through its own block device";
    }
    if (symbol == "Net" || symbol == "Socket" || symbol == "TcpClient" || symbol == "TcpListener") {
        return "it calls the host's socket layer. Bare metal has a network card, not a socket API";
    }
    if (symbol == "Process" || symbol == "Env" || symbol == "Subproc" || symbol == "Conpty") {
        return "there is no operating system underneath to spawn a process or hold an environment";
    }
    if (symbol == "Time") {
        return "it asks the host for the clock. Read your own timer or real-time clock instead";
    }
    if (symbol == "Thread" || symbol == "Task" || symbol == "Channel" || symbol == "Mutex" ||
        symbol == "Semaphore" || symbol == "Latch") {
        return "it creates OS threads and OS locks, and schedules through the managed runtime. A "
               "freestanding program schedules itself";
    }
    // `String` IS AVAILABLE BARE METAL as of 2026-08-12. It lowers to __polaron_str_copy/_free/_index,
    // and those were never libc: the hosted ones are written purely in terms of malloc, free and
    // memcpy, so codegen now GENERATES them from the program's own `heap class` (emitStringBridge),
    // the same way the allocator bridge is generated. Measured: a String program needs not one libc
    // symbol.
    //
    // `StringBuilder` stays out -- it formats, and formatting is where `snprintf` enters, which is
    // the one thing here that genuinely has no bare-metal answer short of writing a formatter.
    if (symbol == "StringBuilder") {
        return "it formats through snprintf, which no bare-metal image has. `String` itself works "
               "here; build text by concatenation, or use `byte*`/`byte[]` and the raw Memory API";
    }
    if (symbol == "Test") {
        return "the test framework reports through printf and builds Strings. Test a freestanding "
               "program from outside: boot it and assert on what it emits";
    }
    return "";
}

void SemanticAnalyzer::checkBitCounted(const std::string& typeName, SourceLocation loc) {
    if (freestanding_) {
        return;
    }
    std::string n = baseType(typeName);
    if (isArrayType(n)) {
        n = elementOf(n);
    }
    if (isBitCountedName(n)) {
        error("type '" + n + "' exists only in freestanding mode; use '" + normalTypeName(n) +
                  "' instead",
              loc);
    }
}

bool SemanticAnalyzer::inheritsFrom(const std::string& sub, const std::string& base) const {
    std::string cur = sub;
    for (int guard = 0; guard < 64 && !cur.empty(); ++guard) {   // a cycle is reported elsewhere
        if (cur == base) {
            return true;
        }
        const ClassInfo* ci = lookupClass(cur);
        if (ci == nullptr) {
            return false;
        }
        cur = ci->superclass;
    }
    return false;
}

void SemanticAnalyzer::checkMemberAccessible(const std::string& kind, const std::string& member,
                                             const std::string& visibility, const std::string& owner,
                                             SourceLocation loc) {
    // An unwritten visibility is not a decision, and refusing on it would turn every member the
    // compiler synthesizes into an error. Only a word the author actually wrote can deny.
    if (visibility.empty() || visibility == "public" || owner.empty()) {
        return;
    }
    // `internal` is "the same program, any bundle" (spec 2.6). Everything compiled together is one
    // program, so within a compilation it denies nobody; the boundary it draws is a `.polb` a
    // consumer links against, and that is enforced where a header is read rather than here.
    if (visibility == "internal") {
        return;
    }
    // A MONOMORPHIZED CLASS IS NOT A SECOND CLASS. `ArrayList$int` and `ArrayList` are the same
    // declaration, and the cloner rewrites the owner to the instantiated name -- so a template's own
    // method reaching its own private field would be read as one class touching another's. Compare on
    // the base name, and the question becomes the one the author wrote.
    auto bare = [](const std::string& n) {
        const std::size_t d = n.find('$');
        return d == std::string::npos ? n : n.substr(0, d);
    };
    const std::string here = bare(enclosingClass_);
    const std::string there = bare(owner);
    if (here == there) {
        return;   // your own member, whatever the word says
    }
    if (visibility == "protected" && !here.empty() && inheritsFrom(here, there)) {
        return;   // the relationship `protected` exists for (guide 6.6)
    }
    const std::string where = here.empty() ? std::string("outside any class") : "'" + here + "'";
    error("'" + member + "' is " + visibility + " to '" + there + "', and this " + kind +
              " is being reached from " + where +
              (visibility == "private"
                   ? ". A private member is the class's own -- give it a public method that does what "
                     "the caller needs, so the class stays in charge of how its state is touched"
                   : ". A protected member is visible to the declaring class and its subclasses only "
                     "(guide 6.6); extend it, or make the member public if it is really part of the "
                     "type's surface"),
          loc);
}

void SemanticAnalyzer::checkTypeAccessible(const std::string& typeName, SourceLocation loc) {
    std::string n = baseType(typeName);          // see through T* / T&
    if (isArrayType(n)) {
        n = elementOf(n);  // and through T[]
    }
    checkBitCounted(typeName, loc);                // bit-counted names are freestanding-only
    // ...and the gate in the other direction, which was missing these two. `String` and the test
    // framework's `Test` resolved fine in a freestanding program and then failed at LINK, on
    // __polaron_str_copy / __polaron_str_free / printf -- symbols the generated freestanding runtime
    // (memcpy/memset/memmove/__polaron_panic, src/driver/build.cpp) does not provide. Compiles clean, dies
    // at link: exactly what this gate exists to prevent, and what guide/11 promises cannot happen
    // ("you cannot accidentally reach for the managed runtime").
    //
    // Only user code is flagged. The prelude's own classes name String constantly, and unused prelude
    // code is dead-stripped, so their mere presence must not break a program that never touches them --
    // the same rule the Console gate follows.
    if (freestanding_ && std::string(loc.file) != "<prelude>") {
        const std::string mn = baseType(typeName);
        // `String` USED TO BE REFUSED HERE, on the grounds that it lowers to
        // __polaron_str_copy/__polaron_str_free "which bare metal has no runtime to provide". The premise
        // was true and the conclusion was not: those are OURS, not libc, and the hosted ones are
        // written purely in terms of malloc, free and memcpy. Codegen now generates them from the
        // program's own `heap class` (emitStringBridge), so bare metal provides them after all.
        if (mn == "Test") {
            error("the test framework is not available in freestanding mode (spec 36.3): `Test` reports "
                  "through printf and builds Strings, neither of which exists bare metal. Test the "
                  "freestanding program from outside -- boot it and assert on what it emits",
                  loc);
        }
    }
    // Inside a compiler-generated monomorphized class, type references were already validated at the
    // template and the instantiation site (and may reach stdlib types like Json from ArrayList<Json>).
    if (currentClass_.find('$') != std::string::npos) {
        return;
    }
    // A monomorphized METHOD is the same case and was missing. `Serializer.of<Player>(p)` writes a
    // copy of `of` named `of$Player` INTO THE LIBRARY'S CLASS, and that copy names `Player` -- a type
    // in the caller's namespace, which the library neither declares nor imports and could not
    // possibly import, since it is a type the library's author never saw. The reference was validated
    // where the author wrote it, at the call site; validating it again where the compiler copied it
    // to asks the standard library to import the user's program.
    if (currentMethodKey_.find('$') != std::string::npos) {
        return;
    }
    // A monomorphized generic (ArrayList$int) is enforced on its generic base name (ArrayList): user
    // code must import the collection. The type-argument part is internal to the instantiation.
    if (const std::size_t d = n.find('$'); d != std::string::npos) {
        n = n.substr(0, d);
    }
    // Ok/Err/Some/None are the value-constructor sugar of Result/Option (spec 21), not types declared
    // by name; they come with the type, so importing Result/Option is enough.
    if (n == "Ok" || n == "Err" || n == "Some" || n == "None") {
        return;
    }
    if (qualifiedTypes_.count(n) > 0) {
        return;  // explicitly namespace-qualified -> visible
    }
    // A NAME MAY BE DECLARED MORE THAN ONCE, AND ONLY ONE OF THEM HAS TO BE REACHABLE.
    //
    // `typeNamespace_` holds one namespace per name, so a program declaring its own `Stack` while the
    // standard library declares `Collections.Stack` kept whichever was written last -- and the check
    // then told an author to import a type they had just declared themselves, three lines up. The
    // fix is not a better tie-break: there is no tie. Both types exist, the question is whether ANY
    // of them is visible from here, and the type table already knows all of them.
    //
    // Costs nothing in the ordinary case: `writtenNameCount` is 1 for every name in a program with no
    // collisions, and the loop below runs once over a one-element vector.
    // A generic, by the same rule, from the record monomorphization left behind (see genericHomes_).
    if (const auto gh = genericHomes_.find(n); gh != genericHomes_.end()) {
        for (const std::string& home : gh->second) {
            if (home == currentNamespace_) {
                return;
            }
        }
        if (currentImports_.count(n) > 0) {
            return;
        }
        if (currentBundle_ == "System") {
            for (const std::string& home : gh->second) {
                auto nb = namespaceBundle_.find(home);
                if (nb != namespaceBundle_.end() && nb->second == "System") {
                    return;
                }
            }
        }
        const std::string b = typeBundle_.count(n) ? typeBundle_[n] : std::string("<bundle>");
        error("type '" + n + "' is in namespace '" + gh->second.front() + "'; import it (import " +
                  b + "." + gh->second.front() + "." + n + ";) to use it here",
              loc);
        return;
    }
    if (const auto shared = typesByWritten_.find(n); shared != typesByWritten_.end()) {
        for (const std::uint32_t id : shared->second) {
            const TypeEntry& e = types_[id];
            if (e.ns == currentNamespace_) {
                return;  // declared right here
            }
            if (currentBundle_ == "System" && e.bundle == "System") {
                return;  // the library is internally cohesive (see below)
            }
        }
        if (currentImports_.count(n) > 0) {
            return;  // brought in by import (incl. stdlib)
        }
        // Not reachable by any of its declarations. Say which ones exist, because with more than one
        // "import it" is not advice until the reader knows which `it`.
        const TypeEntry& first = types_[shared->second.front()];
        error("type '" + n + "' is in namespace '" + first.ns + "'; import it (import " +
                  first.canonical + ";) to use it here" +
                  (shared->second.size() > 1 ? " -- declared as " + sharedPathsFor(n) : ""),
              loc);
        return;
    }
    auto it = typeNamespace_.find(n);
    if (it == typeNamespace_.end()) {
        return;  // primitive / unknown (other checks catch it)
    }
    if (it->second == currentNamespace_) {
        return;  // same namespace -> visible
    }
    if (currentImports_.count(n) > 0) {
        return;  // brought in by import (incl. stdlib)
    }
    // The stdlib is internally cohesive: a type in the System bundle may use any other System-bundle
    // type without an import (e.g. Json's Json uses Text's StringBuilder). Keyed on the bundle now that
    // stdlib namespaces are bare (IO, Text, ...) rather than carrying a System. prefix.
    if (currentBundle_ == "System") {
        // A generic template's own bundle is erased (typeBundle_ missing), but its namespace is shared
        // with real classes, so the namespace->bundle map covers it; a virtual builtin (Memory, Math)
        // has no namespace block, so its typeBundle_ covers it. Either proves System-bundle membership.
        auto nb = namespaceBundle_.find(it->second);
        if (nb != namespaceBundle_.end() && nb->second == "System") {
            return;
        }
        auto tb = typeBundle_.find(n);
        if (tb != typeBundle_.end() && tb->second == "System") {
            return;
        }
    }
    {
    const std::string b = typeBundle_.count(n) ? typeBundle_[n] : std::string("<bundle>");
    error("type '" + n + "' is in namespace '" + it->second + "'; import it (import " + b + "." +
              it->second + "." + n + ";) to use it here",
          loc);
    }
}

void SemanticAnalyzer::checkRegionAccepts(const std::string& region, const std::string& type,
                                          SourceLocation loc) {
    // Where the constraints live depends on where the REGION lives. A local's are in the per-method
    // map; a field's are at class scope, because the per-method map is cleared between methods -- right
    // for a local, which cannot outlive its declaring method, and fatal for a field, whose constraints
    // would be wiped before the first method that allocates into it ever ran.
    const RegionConstraints* rc = nullptr;
    auto local = regionConstraints_.find(region);
    if (local != regionConstraints_.end()) {
        rc = &local->second;
    } else if (region.rfind("this.", 0) == 0 && !currentClass_.empty()) {
        auto fld = fieldRegionConstraints_.find(currentClass_ + "." + region.substr(5));
        if (fld != fieldRegionConstraints_.end()) {
            rc = &fld->second;
        }
    }
    // A region that declares neither accepts nor rejects takes anything, like a plain arena -- with the
    // difference that it still knows what it took.
    if (rc == nullptr) {
        return;
    }

    for (const std::string& rej : rc->rejects) {
        if (type == rej || isSubtype(type, rej)) {
            error("region '" + region + "' rejects type '" + type + "'", loc);
            return;
        }
    }
    if (rc->accepts.empty()) {
        return;  // rejects-only: anything not rejected is in
    }
    for (const std::string& acc : rc->accepts) {
        if (type == acc || isSubtype(type, acc)) {
            return;
        }
    }
    error("region '" + region + "' does not accept type '" + type + "'", loc);
}

// The ONE place the value-ownership rules are decided, for every place a value can land.
//
// It used to be reachable from two: a local's declaration and a local's reassignment. So `movable`
// meant "you must write move" when the destination was a variable, and meant nothing when it was a
// field, an argument, or a return -- which is to say it meant nothing where ownership matters, since
// those three are exactly the ways a value outlives the method it was written in. The argument path
// had grown its own near-copy of the rules that handled `unique` and skipped `movable` outright.
//
// `what` names the destination so the fix reads right at each site; the rules themselves are here
// and only here.
void SemanticAnalyzer::checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                                            SourceLocation loc, const std::string& what) {
    if (isRefType(targetType)) {
        return;  // pointers/refs share; no move discipline
    }
    const ClassInfo* ci = lookupClass(baseType(targetType));
    if (ci == nullptr) {
        return;  // not a class value
    }
    const bool rhsIsMove = dynamic_cast<const ast::MoveExpr*>(&rhs) != nullptr;
    const auto* rhsId = dynamic_cast<const ast::IdentifierExpr*>(&rhs);
    const bool rhsIsLValue =
        rhsId != nullptr || dynamic_cast<const ast::MemberExpr*>(&rhs) != nullptr;
    if (!rhsIsLValue || rhsIsMove) {
        return;  // a fresh `new`, a `move`, or a temporary is fine
    }
    if (ci->isMovable) {
        // Name the source as it is WRITTEN, so the hint can be pasted. `move x` where the source was
        // `this.held` is advice that does not compile.
        std::string name = "the value";
        if (rhsId != nullptr) {
            name = rhsId->name;
        } else if (const auto* rhsMem = dynamic_cast<const ast::MemberExpr*>(&rhs)) {
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(rhsMem->object.get())) {
                name = oid->name + "." + rhsMem->member;
            } else {
                name = rhsMem->member;
            }
        }
        error("'" + ci->name + "' is movable, so it is transferred and never copied: " + what +
                  " needs an explicit 'move' (move " + name + ")",
              loc);
    } else if (ci->isUnique && rhsId != nullptr) {
        moved_.insert(rhsId->name);  // unique: a plain assignment is an implicit move
    } else if (classHasUniqueField(baseType(targetType))) {
        // spec 19.2: a `unique` value may not be duplicated, so an object that owns a unique field
        // cannot be value-copied -- the shallow copy would alias the unique and break its single-owner
        // guarantee (a movable field is deep-copied, but a unique one has no valid copy). Share by
        // pointer/reference instead.
        error("cannot copy '" + ci->name + "' into " + what +
                  ": it owns a 'unique' field, which may not be duplicated (spec 19.2) -- share it "
                  "by pointer ('" + ci->name + "*') or reference",
              loc);
    }
}

bool SemanticAnalyzer::classHasUniqueField(const std::string& className) {
    const ClassInfo* ci = lookupClass(className);
    if (ci == nullptr) {
        return false;
    }
    for (const auto& [fname, fi] : ci->fields) {
        (void)fname;
        if (isRefType(fi.type)) {
            continue;  // a pointer/ref field shares; the owner's copy doesn't dup it
        }
        const std::string ft = baseType(fi.type);
        const ClassInfo* fci = lookupClass(ft);
        // The field is marked `unique`, or its type is a `unique` class -- either way the value cannot
        // be duplicated, so the owning object cannot be value-copied.
        if (fi.isUnique || (fci != nullptr && fci->isUnique)) {
            return true;
        }
        if (fci != nullptr && ft != className && classHasUniqueField(ft)) {
            return true;  // recurse
        }
    }
    if (!ci->superclass.empty()) {
        return classHasUniqueField(baseType(ci->superclass));
    }
    return false;
}

// spec 27: "Pointer arithmetic is allowed on every type, but the compiler emits a warning, because
// advancing a pointer to a class makes no semantic sense and can corrupt memory."
void SemanticAnalyzer::warnClassPointerArith(const std::string& ptrType, SourceLocation loc) {
    if (lookupClass(baseType(ptrType)) == nullptr) {
        return;  // a pointer into an array of primitives
    }
    warn("pointer arithmetic on '" + ptrType +
             "' can corrupt memory: a pointer to a class usually points at ONE object, not at an array "
             "of them (spec 27)",
         loc);
}

void SemanticAnalyzer::checkIncDecTarget(const ast::Expr& target, bool isIncrement, SourceLocation loc) {
    std::string type;
    bool mutableTarget = false;
    bool resolved = false;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error(diag::Code::UndeclaredVariable,
                  "modification of undeclared variable '" + id->name + "'" +
                      didYouMean(id->name, namesInScope()),
                  loc);
            return;
        }
        type = var->type;
        mutableTarget = var->isMutable;
        resolved = true;
    } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) {
            return;
        }
        if (const FieldInfo* f = findField(objType, mem->member)) {
            type = f->type;
            mutableTarget = f->isMutable;
            resolved = true;
        }
        if (!resolved) {
            error("invalid '++'/'--' target", loc);
            return;
        }
    } else {
        error("invalid '++'/'--' target", loc);
        return;
    }
    // atomic<T> ++ / -- is a lock-free atomic update; the cell itself is the mutable container,
    // so the reference need not be `mutable` (spec 20.6).
    if (baseType(type).rfind("atomic$", 0) == 0) {
        return;
    }
    if (!mutableTarget) {
        error("cannot modify an immutable target (declare it 'mutable')", loc);
    }
    // A class with an operator ++/-- overload is a valid target (spec 6.5): `c++` reassigns c to the
    // operator's result.
    if (findMethod(baseType(type), isIncrement ? "operator++" : "operator--") != nullptr) {
        return;
    }
    if (isRefType(type)) {  // spec 27: stepping a pointer is allowed -- one element forward or back
        warnClassPointerArith(type, loc);
        return;
    }
    if (type != "int") {
        error("'++'/'--' requires an int target", loc);
    }
}

// Lets the evaluator answer `EnumName.count()` (spec 12.5) from the declarations this stage already
// holds. An enum is a closed set written out in the source, so its size is a compile-time fact --
// which is what a demand needs to hold one table's offsets to the size of another.
static void setEnumCount(comptime::Context& ctx,
                         const std::unordered_map<std::string, std::vector<std::string>>* enums) {
    if (enums == nullptr) {
        return;
    }
    ctx.enumCount = [enums](const std::string& name, long long& out) {
        auto it = enums->find(name);
        if (it == enums->end()) {
            return false;
        }
        out = static_cast<long long>(it->second.size());
        return true;
    };
}

// Evaluates a constant integer/boolean/char expression at compile time (spec 28),
// delegating to the shared comptime evaluator so consts and `comptime` method calls
// resolve uniformly. `consts`/`methods` are optional resolution tables.
bool evalConstInt(const ast::Expr& e, long long& out,
                  const std::unordered_map<std::string, long long>* consts,
                  const std::unordered_map<std::string, const ast::MethodDecl*>* methods,
                  const std::unordered_map<std::string, double>* dconsts,
                  const std::unordered_map<std::string, std::vector<std::string>>* enums) {
    comptime::Context ctx;
    ctx.consts = consts;
    ctx.dconsts = dconsts;  // so a double const in e.g. a comparison still resolves
    ctx.methods = methods;
    setEnumCount(ctx, enums);
    return comptime::evalInt(e, out, ctx);
}

// Evaluates a constant floating-point expression at compile time (integers promote),
// resolving consts and `comptime` method calls via the shared evaluator.
bool evalConstDouble(const ast::Expr& e, double& out,
                     const std::unordered_map<std::string, double>* dconsts,
                     const std::unordered_map<std::string, long long>* iconsts,
                     const std::unordered_map<std::string, const ast::MethodDecl*>* methods,
                     const std::unordered_map<std::string, std::vector<std::string>>* enums) {
    comptime::Context ctx;
    ctx.consts = iconsts;
    ctx.dconsts = dconsts;
    ctx.methods = methods;
    setEnumCount(ctx, enums);
    return comptime::evalDouble(e, out, ctx);
}

// `SemanticAnalyzer::analyzeStatement` was here: 1 310 lines, one branch per statement kind.
// It now lives in analyzer_stmt.cpp.

void SemanticAnalyzer::checkCallArgs(const std::vector<ast::ExprPtr>& args,
                                    const std::vector<std::string>& paramTypes,
                                    const std::string& desc,
                                    const std::vector<bool>* moveParams) {
    for (std::size_t i = 0; i < args.size(); ++i) {
        const std::string at = typeOf(*args[i]);
        if (i >= paramTypes.size()) {
            continue;
        }
        const std::string& pt = paramTypes[i];
        // spec 19.6: `move T` in the signature demands `move` at the call. The whole argument for
        // the verbosity is that reading the CALL tells you ownership changed hands, without going to
        // look at the declaration -- so a `move` parameter passed plainly defeats the only thing the
        // annotation is for. It parsed and meant nothing until now: `isMove` existed in exactly two
        // places in the compiler, the field and the line the parser wrote it on.
        if (moveParams != nullptr && i < moveParams->size() && (*moveParams)[i] &&
            dynamic_cast<const ast::MoveExpr*>(args[i].get()) == nullptr) {
            const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(args[i].get());
            error("parameter " + std::to_string(i + 1) + " of " + desc +
                      " is declared 'move " + pt +
                      "', so the call has to say so: pass 'move " +
                      (aid != nullptr ? aid->name : std::string("value")) +
                      "'. The name is finished after the call",
                  args[i]->loc);
        }
        if (at.empty() || pt.empty()) {
            continue;
        }
        if (!isNullableType(pt) && (at == "null" || isNullableType(at))) {
            // The part a reader cannot guess: a direct null test on a NAME narrows the type, but a test of a
            // field or of a call result does not -- so someone who "already checked" can still land here,
            // and will otherwise conclude the compiler is broken rather than that it wants the cast.
            error("argument " + std::to_string(i + 1) + " to " + desc + " is " +
                      std::string(at == "null" ? "null" : "'" + at + "', which is nullable") +
                      ", but the parameter type '" + pt + "' is non-nullable" +
                      (at == "null"
                           ? std::string(". Pass a real value, or declare the parameter 'nullable " + pt +
                                         "' if absence is meaningful to it")
                           : std::string(". A direct null test on a NAME narrows it -- after "
                                         "`if (p == null) { return; }` you pass `p` as-is, no cast. This "
                                         "value's test was not a shape the compiler reads (a field, a call "
                                         "result, a cleverer condition), so state the check with 'cast<" +
                                         pt + ">(...)', which is verified at runtime")),
                  args[i]->loc);
        } else if (!isSubtype(at, pt) || isBoxedSumMismatch(at, pt)) {
            error("argument " + std::to_string(i + 1) + " to " + desc + " has type '" + at +
                      "' but the parameter type is '" + pt + "'" + sumFormHint(at, pt),
                  args[i]->loc);
        }
        // spec 19.2: passing an object that owns a `unique` field BY VALUE would copy it and alias the
        // unique, breaking its single-owner guarantee (the same reason a value assignment is rejected --
        // see checkOwnershipAssign). Reject it for a by-value parameter; a fresh temporary or an explicit
        // `move` is fine, and a pointer/reference parameter shares rather than copies.
        // A by-value parameter is a destination like any other, so it goes through the one place the
        // ownership rules live rather than the near-copy that used to be inlined here -- a copy that
        // handled `unique` and skipped `movable` entirely, which is half the feature.
        checkOwnershipAssign(pt, *args[i], args[i]->loc, "the parameter of " + desc);
    }
}

// A compile-time constant argument (spec 32.4): a literal, or a numeric expression the comptime
// evaluator can fold (a const or a `comptime` method call over constants).
bool SemanticAnalyzer::isConstArg(const ast::Expr& e) {
    if (dynamic_cast<const ast::StringLiteralExpr*>(&e) || dynamic_cast<const ast::IntLiteralExpr*>(&e) ||
        dynamic_cast<const ast::CharLiteralExpr*>(&e) || dynamic_cast<const ast::BoolLiteralExpr*>(&e) ||
        dynamic_cast<const ast::FloatLiteralExpr*>(&e)) {
        return true;
    }
    long long i;
    double d;
    return evalConstInt(e, i, &constInts_, &comptimeMethods_, &constDoubles_, &enums_) ||
           evalConstDouble(e, d, &constDoubles_, &constInts_, &comptimeMethods_, &enums_);
}

void SemanticAnalyzer::checkComptimeArgs(const std::vector<ast::ExprPtr>& args,
                                         const std::vector<bool>& comptimeParams,
                                         const std::string& desc) {
    for (std::size_t i = 0; i < args.size() && i < comptimeParams.size(); ++i) {
        if (comptimeParams[i] && !isConstArg(*args[i])) {
            error("argument " + std::to_string(i + 1) + " to " + desc +
                      " must be a compile-time constant ('comptime' parameter, spec 32.4)",
                  args[i]->loc);
        }
    }
}

// Named arguments (spec 22.4). Rewrites `call->args` into declared parameter order, so every later stage
// (type checking, codegen) only ever sees positional arguments, and enforces the rules:
//   - a name must match a parameter, and no parameter may be bound twice;
//   - positional arguments come first (once you name one, the rest must be named);
//   - a `requires named` parameter cannot be passed positionally;
//   - every parameter must end up bound.
// A call with no names and no `requires named` parameter is left untouched (the common path).
void SemanticAnalyzer::bindNamedArgs(ast::CallExpr* call, const std::vector<std::string>& paramNames,
                                     const std::vector<bool>& namedOnly, const std::string& desc) {
    if (call == nullptr || call->argsBound || paramNames.empty()) {
        return;
    }
    const bool anyNamed = std::any_of(call->argNames.begin(), call->argNames.end(),
                                      [](const std::string& n) { return !n.empty(); });
    const bool anyNamedOnly = std::any_of(namedOnly.begin(), namedOnly.end(), [](bool b) { return b; });
    if (!anyNamed && !anyNamedOnly) {
        return;  // ordinary positional call: nothing to do
    }
    if (call->args.size() != call->argNames.size()) {
        return;  // synthesized call: nothing to bind
    }
    if (call->args.size() != paramNames.size()) {
        return;  // arity error is reported elsewhere
    }
    // The analyzer may type a call more than once (overload probing, generic instantiation), so bind exactly
    // once. Validate everything BEFORE moving anything, so a rejected call leaves the AST intact.
    call->argsBound = true;

    std::vector<std::size_t> slotOf(call->args.size(), 0);   // arg i -> parameter slot
    std::vector<bool> filled(paramNames.size(), false);
    bool sawNamed = false;
    for (std::size_t i = 0; i < call->args.size(); ++i) {
        const std::string& n = call->argNames[i];
        if (n.empty()) {
            if (sawNamed) {
                error("positional argument after a named one in a call to " + desc +
                          " (spec 22.4: once an argument is named, the rest must be too)",
                      call->args[i]->loc);
                return;
            }
            if (i < namedOnly.size() && namedOnly[i]) {
                error("parameter '" + paramNames[i] + "' of " + desc +
                          " is 'requires named': pass it as '" + paramNames[i] + ": <value>' (spec 22.4)",
                      call->args[i]->loc);
                return;
            }
            slotOf[i] = i;
            filled[i] = true;
            continue;
        }
        sawNamed = true;
        const auto it = std::find(paramNames.begin(), paramNames.end(), n);
        if (it == paramNames.end()) {
            error(desc + " has no parameter named '" + n + "'", call->args[i]->loc);
            return;
        }
        const std::size_t slot = static_cast<std::size_t>(it - paramNames.begin());
        if (filled[slot]) {
            error("argument '" + n + "' passed twice to " + desc, call->args[i]->loc);
            return;
        }
        slotOf[i] = slot;
        filled[slot] = true;
    }
    for (std::size_t s = 0; s < filled.size(); ++s) {
        if (!filled[s]) {
            error("no argument for parameter '" + paramNames[s] + "' of " + desc, call->loc);
            return;
        }
    }
    if (!anyNamed) {
        return;  // only the `requires named` rule applied; the order is already positional
    }
    std::vector<ast::ExprPtr> bound(paramNames.size());
    for (std::size_t i = 0; i < call->args.size(); ++i) {
        bound[slotOf[i]] = std::move(call->args[i]);
    }
    call->args = std::move(bound);
    call->argNames.assign(call->args.size(), std::string());   // now purely positional
}

// `SemanticAnalyzer::typeOf` was here: 2 805 lines answering "what type is this expression", which is
// a third of this file on its own. It now lives in analyzer_typeof.cpp.

std::string SemanticAnalyzer::flattenCallee(const ast::Expr& expr) const {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string base = flattenCallee(*mem->object);
        if (base.empty()) {
            return "";
        }
        return base + "." + mem->member;
    }
    return "";
}

}  // namespace polaron
