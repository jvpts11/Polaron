#include "parser/monomorphize.h"

#include <algorithm>  // std::find; MSVC hands it over through another header, libstdc++ does not
#include <cstdio>
#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

#include "diag/diagnostic.h"
#include "diag/render.h"

namespace polaron {

namespace {
// Emit a monomorphization diagnostic richly: infer its code from the message and render the why / fix /
// prevent through the shared renderer (no source snippet here -- this pass runs after the source is gone).
void monoError(const SourceLocation& loc, const std::string& message) {
    std::fputs(diag::render("error", std::string(loc.file), loc.line, loc.col, message,
                            diag::classify(message), "", diag::conciseMode())
                   .c_str(),
               stderr);
}

// The same, said as a warning. This pass had no way to say anything short of stopping the build, and
// the one thing it most needed to say -- "the name you just declared is also the standard library's"
// -- is not an error: your type wins, which is the intended rule. It is simply something you have to
// know, because from that point an unqualified use of the name means yours everywhere in the bundle.
void monoWarn(const SourceLocation& loc, const std::string& message) {
    std::fputs(diag::render("warning", std::string(loc.file), loc.line, loc.col, message,
                            diag::classify(message), "", diag::conciseMode())
                   .c_str(),
               stderr);
}
}  // namespace
namespace {

using Subst = std::map<std::string, std::string>;            // type param -> concrete type
using InstMap = std::map<std::string, std::pair<std::string, std::vector<std::string>>>;  // mangled -> (base, args)

// `typealias` targets (spec 24), resolved transparently everywhere a type appears. Keyed by the
// alias name -> its target TypeRef. `newtype`s are NOT here -- they are distinct nominal types and
// must survive to the analyzer. Populated by resolveTypeAliases and consulted by substType, so the
// rest of the pipeline only ever sees concrete types.
std::map<std::string, ast::TypeRef> g_aliases;

// A GENERIC CLASS REFERRING TO ITSELF BY NAME, in expression position.
//
// `resolveImplicitThis` runs BEFORE monomorphization, so a bare static field inside `Box<T>` is
// already rewritten to `Box.made` by the time the template is cloned -- with the TEMPLATE's name.
// After expansion the class is `Box$int` and `Box` names nothing, so the error was "use of
// undeclared variable 'Box'" on a line that does not mention `Box`. The visible effect was that a
// generic class could not have a static field at all.
//
// It cannot be fixed by putting the name in the ordinary substitution map: that map is applied to
// TYPES as well, so `ArrayList` inside `ArrayList<T>` became `ArrayList$long$long` and the prelude
// stopped compiling. The name is only rewritten where it is an EXPRESSION -- a receiver -- which is
// the one position where it means "the class I am in" rather than "this type".
//
// Set for the duration of one instantiation's clone, and empty otherwise.
std::string g_selfTemplate;
std::string g_selfConcrete;
std::set<std::string> g_enumNames;  // enum names in the program (for EnumName.parse() force-mono)
// The field a structural body is being unrolled FOR, set for the duration of one copy. Empty
// otherwise, which is what keeps the ordinary clone -- the one that monomorphizes generics -- from
// looking at a `.name` that belongs to somebody's real object.
std::string g_fieldVar;
std::string g_fieldName;
std::string g_fieldType;

// Resolve a bare type-name string (a typeArg, superclass, interface, or cast target) through the
// alias map, returning the canonical form of its target (or the name unchanged if not an alias).
std::string resolveAliasName(const std::string& name) {
    auto it = g_aliases.find(name);
    return it == g_aliases.end() ? name : ast::canonicalType(it->second);
}

// Substitutes type parameters in a TypeRef (T -> int). Generic args are
// substituted in place; typeRefStr/typeRefName mangle them later. Also expands any
// `typealias` in the base name or type arguments (transparent rewrite, spec 24).
// Substitute type params inside one (possibly nested-mangled) type-argument string. A simple arg ("T") is
// looked up whole; a nested generic arg ("Handler$T", from ArrayList<Handler<T>>) has each '$'-separated
// segment substituted so the inner T becomes concrete ("Handler$int") instead of missing the lookup.
std::string substArg(const std::string& arg, const Subst& s) {
    std::string a = resolveAliasName(arg);
    // A POINTER OR REFERENCE TYPE ARGUMENT: `ArrayList<T*>` substitutes to `ArrayList<Node*>`, not to
    // `ArrayList<T*>` unchanged. The map is keyed by the bare parameter name, so the marker has to
    // come off and go back on -- without this, a generic container of POINTERS kept its template's
    // `T*` after instantiation, and the class was reported as taking a `T*` where a `Node*` was
    // handed in: a container of pointers to its own element type was unwritable.
    if (!a.empty() && (a.back() == '*' || a.back() == '&')) {
        const char mark = a.back();
        const std::string inner = substArg(a.substr(0, a.size() - 1), s);
        return inner + mark;
    }
    if (a.find('$') == std::string::npos) {
        auto it = s.find(a);
        return it != s.end() ? it->second : a;
    }
    std::string rebuilt;
    std::size_t start = 0;
    while (true) {
        const std::size_t d = a.find('$', start);
        std::string seg = a.substr(start, d == std::string::npos ? std::string::npos : d - start);
        seg = resolveAliasName(seg);
        if (auto si = s.find(seg); si != s.end()) {
            seg = si->second;
        }
        rebuilt += seg;
        if (d == std::string::npos) {
            break;
        }
        rebuilt += "$";
        start = d + 1;
    }
    return rebuilt;
}

/* THE ARITHMETIC A STAMPED EXTENT IS ALLOWED (A.3). `4*4` folds to 16; `R*C` with R unbound does
   not fold, and returns 0 so the caller leaves the expression alone and tries again after the next
   substitution. Multiplication binds tighter than addition, which is the only precedence three
   operators need. Anything the parser did not already narrow to names, integers and `* + -` cannot
   reach here. */
long long foldExtent(const std::string& text) {
    long long total = 0;
    long long term = 1;
    long long sign = 1;
    bool haveTerm = false;
    std::string word;
    auto value = [&](bool& ok) -> long long {
        ok = !word.empty() &&
             word.find_first_not_of("0123456789") == std::string::npos;
        const long long n = ok ? std::strtoll(word.c_str(), nullptr, 10) : 0;
        word.clear();
        return n;
    };
    for (std::size_t i = 0; i <= text.size(); ++i) {
        const char ch = i < text.size() ? text[i] : '\0';
        if (ch != '*' && ch != '+' && ch != '-' && ch != '\0') {
            word += ch;
            continue;
        }
        bool ok = false;
        const long long n = value(ok);
        if (!ok) {
            return 0;   // a name is still a name: not foldable yet
        }
        term *= n;
        haveTerm = true;
        if (ch == '*') {
            continue;
        }
        total += sign * term;
        term = 1;
        sign = (ch == '-') ? -1 : 1;
    }
    return haveTerm ? total : 0;
}

ast::TypeRef substType(const ast::TypeRef& t, const Subst& s) {
    ast::TypeRef r = t;
    if (auto ai = g_aliases.find(r.name); ai != g_aliases.end()) {
        const ast::TypeRef& tgt = ai->second;  // expand the alias into the target's structure
        r.name = tgt.name;
        r.typeArgs.insert(r.typeArgs.begin(), tgt.typeArgs.begin(), tgt.typeArgs.end());
        r.isArray = r.isArray || tgt.isArray;
        r.arrayDims += tgt.arrayDims;  // e.g. `Matrix[]` where `Matrix = int[][]` -> 3 dims
        r.isPointer = r.isPointer || tgt.isPointer;
        r.isRef = r.isRef || tgt.isRef;
        r.isNullable = r.isNullable || tgt.isNullable;
    }
    // A tuple type carries its spelling in `name`, e.g. "(T,int)"; substitute each component so a
    // generic method returning (T, T) instantiates to (int, int) (spec 15.1).
    if (r.name.size() >= 2 && r.name.front() == '(' && r.name.back() == ')') {
        const std::string inner = r.name.substr(1, r.name.size() - 2);
        std::string rebuilt = "(";
        std::size_t start = 0;
        bool first = true;
        while (start <= inner.size()) {
            const std::size_t comma = inner.find(',', start);
            std::string comp =
                inner.substr(start, comma == std::string::npos ? std::string::npos : comma - start);
            const std::size_t b = comp.find_first_not_of(" \t");
            const std::size_t e = comp.find_last_not_of(" \t");
            comp = (b == std::string::npos) ? std::string() : comp.substr(b, e - b + 1);
            if (auto ci = s.find(comp); ci != s.end()) {
                comp = ci->second;
            }
            rebuilt += (first ? "" : ",") + comp;
            first = false;
            if (comma == std::string::npos) {
                break;
            }
            start = comma + 1;
        }
        r.name = rebuilt + ")";
        return r;
    }
    // A function type carries its spelling in `name`, e.g. "function<void,T>"; substitute each type
    // argument so a generic method/field taking a `function<void, T>` instantiates to
    // `function<void, int>` (spec 15.1). Splits on top-level commas and recurses for nested generics.
    if (r.name.rfind("function<", 0) == 0 && r.name.back() == '>') {
        const std::string inner = r.name.substr(9, r.name.size() - 10);
        std::string rebuilt = "function<";
        int depth = 0;
        std::size_t start = 0;
        bool first = true;
        for (std::size_t i = 0; i <= inner.size(); ++i) {
            if (i < inner.size() && inner[i] == '<') {
                ++depth;
            } else if (i < inner.size() && inner[i] == '>') {
                --depth;
            }
            if (i == inner.size() || (inner[i] == ',' && depth == 0)) {
                std::string comp = inner.substr(start, i - start);
                const std::size_t b = comp.find_first_not_of(" \t");
                const std::size_t e = comp.find_last_not_of(" \t");
                comp = (b == std::string::npos) ? std::string() : comp.substr(b, e - b + 1);
                ast::TypeRef ct;
                ct.name = comp;
                rebuilt += (first ? "" : ",") + substType(ct, s).name;  // recurse (nested + params)
                first = false;
                start = i + 1;
            }
        }
        r.name = rebuilt + ">";
        return r;
    }
    auto it = s.find(r.name);
    if (it != s.end()) {
        r.name = it->second;
    }
    for (std::string& a : r.typeArgs) {
        a = substArg(a, s);  // handles nested mangled args (Handler$T)
    }
    /* ...AND AN EXTENT THAT WAS STILL AN EXPRESSION (A.3). `T[R * C]` is the point of const
       generics: an array whose length is part of the type, so the value carries no header, needs no
       allocation and can live inside another type. The names in it bind here, with everything else,
       and the result is folded to the number the rest of the compiler already knows how to read. */
    if (!r.arrayExtentExpr.empty()) {
        std::string bound;
        std::string word;
        auto flush = [&]() {
            if (word.empty()) {
                return;
            }
            auto sub = s.find(word);
            bound += sub != s.end() ? sub->second : word;
            word.clear();
        };
        for (const char ch : r.arrayExtentExpr) {
            if (ch == '*' || ch == '+' || ch == '-') {
                flush();
                bound += ch;
            } else {
                word += ch;
            }
        }
        flush();
        r.arrayExtentExpr = bound;
        if (const long long folded = foldExtent(bound); folded > 0) {
            r.arrayExtent = static_cast<int>(folded);
            r.arrayExtentExpr.clear();
        }
    }
    return r;
}

// A receiver written as a path of plain names, flattened: `text.Reader` for the two-node chain, and
// `Main.text.Reader` for the three. Empty when anything in the chain is not a bare name -- an index,
// a call, `this` -- because then it is a VALUE being navigated and not a type being named.
std::string dottedPath(const ast::Expr* e) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(e)) {
        const std::string head = dottedPath(mem->object.get());
        return head.empty() ? std::string() : head + "." + mem->member;
    }
    return std::string();
}

// ---- Deep clone of the AST with type substitution ----
ast::ExprPtr cloneExpr(const ast::Expr* e, const Subst& s);
ast::StmtPtr cloneStmt(const ast::Stmt* st, const Subst& s);

ast::Block cloneBlock(const ast::Block& b, const Subst& s) {
    ast::Block r;
    r.loc = b.loc;
    for (const auto& st : b.statements) {
        r.statements.push_back(cloneStmt(st.get(), s));
    }
    return r;
}

ast::ExprPtr cloneExpr(const ast::Expr* e, const Subst& s) {
    if (e == nullptr) {
        return nullptr;
    }
    if (const auto* x = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        /* A `fixed int` PARAMETER READ AS A VALUE BECOMES THE NUMBER (A.3).
         *
         * `for (mutable int i = 0; i < R; i++)` inside `Matrix<fixed T, fixed int R, ...>` means
         * `i < 4` in the stamped copy -- and it has to become the literal here, not a name the
         * analyzer would look for as a variable, because there is no variable: the value is part of
         * the type. That is also what makes it worth having, since a bound the optimizer can see is
         * a loop it can unroll and a check it can fold.
         *
         * Told apart from a TYPE substitution by what it maps to: a type name is not all digits. */
        if (auto sub = s.find(x->name);
            sub != s.end() && !sub->second.empty() &&
            sub->second.find_first_not_of("-0123456789") == std::string::npos) {
            auto lit = std::make_unique<ast::IntLiteralExpr>();
            lit->loc = x->loc;
            lit->text = sub->second;
            return lit;
        }
        auto n = std::make_unique<ast::IdentifierExpr>();
        n->loc = x->loc;
        n->name = (!g_selfTemplate.empty() && x->name == g_selfTemplate) ? g_selfConcrete : x->name;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IntLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::IntLiteralExpr>();
        n->loc = x->loc;
        n->text = x->text;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::FloatLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::FloatLiteralExpr>();
        n->loc = x->loc;
        n->text = x->text;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::LambdaExpr*>(e)) {
        auto n = std::make_unique<ast::LambdaExpr>();
        n->loc = x->loc;
        for (const auto& p : x->params) {
            ast::Param np;
            np.type = substType(p.type, s);
            np.name = p.name;
            np.loc = p.loc;
            n->params.push_back(std::move(np));
        }
        n->returnType = substType(x->returnType, s);
        n->body = cloneBlock(x->body, s);
        n->captures = x->captures;  // captures carry no types to substitute -- copy as-is
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::StringLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::StringLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        // `b"..."` AND `"..."` ARE DIFFERENT TYPES, and this dropped the difference: a byte literal
        // came out of the clone as a `String`, which in a freestanding kernel is a type that cannot
        // exist. It showed up as `argument 1 to 'puts' has type 'String' but the parameter type is
        // 'byte*'`, on lines nobody had edited, the moment the program acquired a `typealias` --
        // because the alias pass re-clones every class in the program.
        n->isBytes = x->isBytes;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CharLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::CharLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BoolLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::BoolLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NullLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::NullLiteralExpr>();
        n->loc = x->loc;
        return n;  // was missing -> cloned `null` became nullptr -> typeOf(*nullptr) crash
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) {
        // THE LOOP VARIABLE OF A STRUCTURAL BODY, folded to what it is for this copy. `field.name`
        // and `field.typeName` are named after the reflection API they replace (`Field.name()`,
        // `Field.typeName()`) on purpose: the same words, minus the metadata, the allocation and the
        // dispatch. Done inside the cloner because it already visits every node -- a second visitor
        // would go out of date the first time a node kind is added, quietly and only here.
        if (!g_fieldVar.empty() && (x->member == "name" || x->member == "typeName")) {
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(x->object.get());
                oid != nullptr && oid->name == g_fieldVar) {
                auto lit = std::make_unique<ast::StringLiteralExpr>();
                lit->loc = x->loc;
                lit->value = x->member == "name" ? g_fieldName : g_fieldType;
                return lit;
            }
        }
        auto n = std::make_unique<ast::MemberExpr>();
        n->loc = x->loc;
        n->member = x->member;
        // A bare identifier in RECEIVER position may be a type name -- `Regex.matchClass(...)` is a
        // static call, not a variable read -- so it has to follow a type substitution. A plain
        // identifier anywhere else is left alone on purpose: this same clone is what monomorphizes
        // generics, where the substitution maps T to int and must never touch a variable.
        //
        // Without this, renaming a type broke its own static self-calls. That only happens when the
        // name is ambiguous, so the trigger was a user class sharing a name with a stdlib one: the
        // stdlib's `Regex` became `Text__Regex` and every `Regex.matchHere(...)` inside it stopped
        // resolving, reported as four undeclared-variable errors inside <prelude>.
        if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(x->object.get())) {
            if (auto it = s.find(oid->name); it != s.end()) {
                auto obj = std::make_unique<ast::IdentifierExpr>();
                obj->loc = oid->loc;
                obj->name = it->second;
                n->object = std::move(obj);
                return n;
            }
        }
        // ...AND A RECEIVER THAT IS A PATH, which is how a name declared twice is told apart.
        //
        // Two namespaces may both declare `Reader`; they are renamed apart (`text__Reader`), and the
        // way to say which one is meant is `text.Reader.parse(...)`. That receiver is not one
        // identifier -- it is a CHAIN of them -- so the substitution above, which matches a single
        // name, never saw it. The compiler said so in its own diagnostic ("a static call through a
        // qualified path is not resolved yet") and sent the reader to reach the method through an
        // instance, or to rename one of the two types.
        //
        // Collapsed HERE, at the pass that does the renaming, rather than taught to the two passes
        // downstream: flattened to `text.Reader`, looked up in the same map, and rebuilt as the one
        // identifier `text__Reader`. Everything after this sees the ordinary `Class.method` shape and
        // needs to know nothing about paths at all.
        // ONLY WHEN THE TYPE WAS ACTUALLY RENAMED, which is the whole condition. The same map holds
        // an identity entry for every unambiguous path -- `System.IO.Console` maps to `Console` --
        // and collapsing those threw away a path that something downstream still wants: the
        // Console/File builtins are recognised BY their full path, so `System.IO.Console.printf`
        // became a lookup for a `printf` on an ordinary class, and the prelude stopped compiling.
        // A rename is what this is for, and a rename is when the answer differs from the name.
        if (const std::string path = dottedPath(x->object.get()); !path.empty()) {
            const std::size_t tail = path.rfind('.');
            const std::string simple = tail == std::string::npos ? path : path.substr(tail + 1);
            if (auto it = s.find(path); it != s.end() && it->second != simple) {
                auto obj = std::make_unique<ast::IdentifierExpr>();
                obj->loc = x->object->loc;
                obj->name = it->second;
                n->object = std::move(obj);
                return n;
            }
        }
        n->object = cloneExpr(x->object.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MemberSpliceExpr*>(e)) {
        auto obj = cloneExpr(x->object.get(), s);
        auto nm = cloneExpr(x->name.get(), s);
        // `x.[expr]` becomes the member it names, as soon as the name is a string. That happens on
        // the very clone that substituted `field.name` for a literal just below, so a splice resolves
        // in the same pass that gave it something to resolve to.
        if (const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(nm.get())) {
            auto mem = std::make_unique<ast::MemberExpr>();
            mem->loc = x->loc;
            mem->member = lit->value;
            mem->object = std::move(obj);
            return mem;
        }
        auto n = std::make_unique<ast::MemberSpliceExpr>();
        n->loc = x->loc;
        n->object = std::move(obj);
        n->name = std::move(nm);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MethodRefExpr*>(e)) {
        auto n = std::make_unique<ast::MethodRefExpr>();
        n->loc = x->loc;
        n->method = x->method;
        n->object = cloneExpr(x->object.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::OldExpr*>(e)) {
        auto n = std::make_unique<ast::OldExpr>();
        n->loc = x->loc;
        n->inner = cloneExpr(x->inner.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        auto n = std::make_unique<ast::CallExpr>();
        n->loc = x->loc;
        n->fromSuffix = x->fromSuffix;
        n->callee = cloneExpr(x->callee.get(), s);
        // `sizeof`'s ARGUMENT IS A TYPE, not a value, so it follows a type substitution where a bare
        // identifier otherwise must not -- this same clone monomorphizes generics, where the map takes
        // T to int and touching a variable named T would be a disaster.
        //
        // Without it, `Raw.sizeof(Color)` kept a bare `Color` after the type was renamed for a name
        // collision, and failed with `use of undeclared variable 'Color'` pointing at line 1 -- the
        // expression came out of a string interpolation, whose sub-parsed nodes carry no location, so
        // the one clue was a coordinate that belonged to nothing.
        bool sizeofCall = false;
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(x->callee.get())) {
            sizeofCall = cid->name == "sizeof";
        } else if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(x->callee.get())) {
            sizeofCall = cm->member == "sizeof";   // Raw.sizeof / System.Memory.Raw.sizeof
        }
        for (const auto& a : x->args) {
            if (sizeofCall) {
                if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(a.get())) {
                    if (auto it = s.find(aid->name); it != s.end()) {
                        auto sub = std::make_unique<ast::IdentifierExpr>();
                        sub->loc = aid->loc;
                        sub->name = it->second;
                        n->args.push_back(std::move(sub));
                        continue;
                    }
                }
            }
            n->args.push_back(cloneExpr(a.get(), s));
        }
        for (const std::string& a : x->typeArgs) {  // generic call args may be type params
            auto ai = s.find(a);
            n->typeArgs.push_back(ai != s.end() ? ai->second : a);
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) {
        auto n = std::make_unique<ast::BinaryExpr>();
        n->loc = x->loc;
        n->op = x->op;
        n->lhs = cloneExpr(x->lhs.get(), s);
        n->rhs = cloneExpr(x->rhs.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) {
        auto n = std::make_unique<ast::TernaryExpr>();
        n->loc = x->loc;
        n->cond = cloneExpr(x->cond.get(), s);
        n->thenExpr = cloneExpr(x->thenExpr.get(), s);
        n->elseExpr = cloneExpr(x->elseExpr.get(), s);
        return n;
    }
    // ---- the five this had never been taught ------------------------------------------------
    //
    // Dropped in silence until the warning below was reached, in every generic instantiation and
    // not only in alias expansion: an `await` inside a generic stopped waiting, an array literal
    // became an uninitialised variable, and `??` lost its fallback -- in programs that compiled.
    if (const auto* x = dynamic_cast<const ast::ArrayLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::ArrayLiteralExpr>();
        n->loc = x->loc;
        for (const auto& el : x->elements) {
            n->elements.push_back(cloneExpr(el.get(), s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AwaitExpr*>(e)) {
        auto n = std::make_unique<ast::AwaitExpr>();
        n->loc = x->loc;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NullCoalesceExpr*>(e)) {
        auto n = std::make_unique<ast::NullCoalesceExpr>();
        n->loc = x->loc;
        n->lhs = cloneExpr(x->lhs.get(), s);
        n->rhs = cloneExpr(x->rhs.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SnapshotExpr*>(e)) {
        auto n = std::make_unique<ast::SnapshotExpr>();
        n->loc = x->loc;
        n->region = x->region;
        n->home = x->home;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::UnimportExpr*>(e)) {
        auto n = std::make_unique<ast::UnimportExpr>();
        n->loc = x->loc;
        n->target = x->target;
        n->usingVars = x->usingVars;
        if (x->expecting != nullptr) {
            n->expecting = std::make_unique<ast::Block>(cloneBlock(*x->expecting, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) {
        auto n = std::make_unique<ast::UnaryExpr>();
        n->loc = x->loc;
        n->op = x->op;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) {
        auto n = std::make_unique<ast::NewExpr>();
        n->loc = x->loc;
        n->className = x->className;
        if (auto ai = g_aliases.find(n->className); ai != g_aliases.end()) {
            n->className = ai->second.name;  // `new DogList()` -> `new ArrayList<Dog>()`
            n->typeArgs.insert(n->typeArgs.end(), ai->second.typeArgs.begin(),
                               ai->second.typeArgs.end());
        }
        auto it = s.find(n->className);
        if (it != s.end()) {
            n->className = it->second;
        }
        for (const std::string& a : x->typeArgs) {
            n->typeArgs.push_back(substArg(a, s));
        }
        for (const auto& a : x->args) {
            n->args.push_back(cloneExpr(a.get(), s));
        }
        n->location = x->location;
        // ...and WHERE, when the where is a region. Copying `location` but not `region` made
        // `new T(...) in region R` allocate from the ordinary heap inside every generic type, while
        // the matching `delete ... from region R` (once IT was also preserved -- see cloneStmt for
        // DeleteStmt) correctly went to the region, which then refused a pointer it had never handed
        // out: `region free of a pointer that this region did not allocate`.
        //
        // The two omissions hid each other. With only the delete fixed the allocation was still on
        // the heap; with neither fixed both sides agreed on the wrong answer and the region simply
        // went unused. Together they are why no generic container could put its nodes in a region.
        n->region = x->region;
        // A value Result/Option (spec 21) whose payload substitutes to a pointer/ref (a generic Option<T>
        // instantiated at T=Node*) mangles into a name that collides with the boxed form, so keep it boxed
        // for now -- decided here, once the concrete type args are known. Matches codegen's isValueVariant.
        if (n->location == "value") {
            for (const std::string& a : n->typeArgs) {
                if (a.find('*') != std::string::npos || a.find('&') != std::string::npos ||
                    a.find("Decimal") != std::string::npos || a.find('(') != std::string::npos) {
                    n->location = "heap";
                    break;
                }
            }
        }
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) {
        auto n = std::make_unique<ast::NewArrayExpr>();
        n->loc = x->loc;
        n->elementType = resolveAliasName(x->elementType);
        auto it = s.find(n->elementType);
        if (it != s.end()) {
            n->elementType = it->second;
        }
        n->size = cloneExpr(x->size.get(), s);
        n->location = x->location;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) {
        auto n = std::make_unique<ast::IndexExpr>();
        n->loc = x->loc;
        n->array = cloneExpr(x->array.get(), s);
        n->index = cloneExpr(x->index.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) {
        auto n = std::make_unique<ast::MoveExpr>();
        n->loc = x->loc;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ExtractExpr*>(e)) {
        auto n = std::make_unique<ast::ExtractExpr>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MarkExpr*>(e)) {
        auto n = std::make_unique<ast::MarkExpr>();
        n->loc = x->loc;
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RegionSpaceExpr*>(e)) {
        auto n = std::make_unique<ast::RegionSpaceExpr>();
        n->loc = x->loc;
        n->ask = x->ask;
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) {
        auto n = std::make_unique<ast::TryExpr>();
        n->loc = x->loc;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) {
        auto n = std::make_unique<ast::CastExpr>();
        n->loc = x->loc;
        n->targetType = resolveAliasName(x->targetType);
        auto it = s.find(n->targetType);
        if (it != s.end()) {
            n->targetType = it->second;
        }
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SuperExpr*>(e)) {
        auto n = std::make_unique<ast::SuperExpr>();
        n->loc = x->loc;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) {
        auto n = std::make_unique<ast::RegionInitExpr>();
        n->loc = x->loc;
        n->size = cloneExpr(x->size.get(), s);
        // THE CONSTRAINED TYPES ARE TYPES, so they substitute like every other type in the clone.
        // Copied verbatim, a generic `Arena<T>` whose region `accepts({T})` produced an instance
        // still constrained to `T` -- a type that no longer exists -- and the region rejected the
        // very element the container is for. The whole point of a region-allocated container is that
        // the arena knows what may go in it; a constraint that did not follow the instantiation was
        // the one part that could not work.
        for (const std::string& a : x->accepts) {
            n->accepts.push_back(substArg(a, s));
        }
        for (const std::string& r : x->rejects) {
            n->rejects.push_back(substArg(r, s));
        }
        // WHERE the region lives, which this dropped. `itself.at(addr, size)` is a region over FIXED
        // memory and `itself.atMultiple({...})` is several of them -- losing either turns a region
        // pinned to a hardware address into an ordinary heap allocation, inside any generic type.
        // Nothing reports it; the region simply stops being where it was put. Same family as the two
        // omissions in NewExpr and DeleteStmt above.
        n->atAddress = cloneExpr(x->atAddress.get(), s);
        for (const auto& r : x->ranges) {
            ast::RegionInitExpr::Range nr;
            nr.address = cloneExpr(r.address.get(), s);
            for (const std::string& a : r.accepts) {
                nr.accepts.push_back(substArg(a, s));
            }
            for (const std::string& rj : r.rejects) {
                nr.rejects.push_back(substArg(rj, s));
            }
            n->ranges.push_back(std::move(nr));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) {
        auto n = std::make_unique<ast::InterpStringExpr>();
        n->loc = x->loc;
        n->literals = x->literals;
        n->formats = x->formats;   // spec 4.1 format specifiers travel with the clone
        for (const auto& ex : x->exprs) {
            n->exprs.push_back(cloneExpr(ex.get(), s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TupleExpr*>(e)) {
        auto n = std::make_unique<ast::TupleExpr>();
        n->loc = x->loc;
        for (const auto& ex : x->elements) {
            n->elements.push_back(cloneExpr(ex.get(), s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        auto n = std::make_unique<ast::MatchExpr>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::MatchCase nc;
            nc.loc = c.loc;
            nc.typeName = c.typeName;
            auto it = s.find(nc.typeName);
            if (it != s.end()) {
                nc.typeName = it->second;  // a case type may be a type param
            }
            for (const auto& b : c.bindings) {
                ast::Param p;
                p.loc = b.loc;
                p.type = substType(b.type, s);
                p.name = b.name;
                nc.bindings.push_back(std::move(p));
            }
            nc.result = cloneExpr(c.result.get(), s);
            n->cases.push_back(std::move(nc));
        }
        n->defaultResult = cloneExpr(x->defaultResult.get(), s);
        return n;
    }
    // A RANGE. `for (int i in 0..n)` inside a generic class CRASHED THE COMPILER without this: the
    // clone returned null, the analyzer's foreach saw an iterable that was not a range, fell through
    // to `typeOf(*fe->iterable)` and dereferenced nothing. Eighteen lines reproduced it -- a generic
    // class and `for (int i in 0..3)` -- and the standard library never met it because its own loops
    // are all written in the classic three-part form.
    if (const auto* x = dynamic_cast<const ast::RangeExpr*>(e)) {
        auto n = std::make_unique<ast::RangeExpr>();
        n->loc = x->loc;
        n->start = cloneExpr(x->start.get(), s);
        n->end = cloneExpr(x->end.get(), s);
        n->step = cloneExpr(x->step.get(), s);
        n->inclusive = x->inclusive;
        return n;
    }
    // AND SAY SO RATHER THAN RETURNING NOTHING.
    //
    // "should not happen for well-formed input" was the comment here, and it was wrong in exactly
    // the way such comments are: the input was well-formed and the node was one this function had
    // never been taught. What came back was a null the caller stored and something else dereferenced
    // later -- an access violation with no message, in a phase nobody would look at, from a program
    // that is perfectly legal.
    //
    // This is the second time in two days: `cloneMember` silently dropped `comptime literal` and
    // `fixed`, and the same shape produced a missing standard-library import instead of a crash.
    // A clone that meets a node it does not know is a bug in THIS function, and it should report
    // itself here rather than surface three passes downstream as something else.
    monoWarn(e->loc, "internal: this expression is not preserved when a generic is expanded, so it "
                     "will be missing from the instantiation -- cloneExpr does not handle its kind");
    return nullptr;
}

ast::StmtPtr cloneStmt(const ast::Stmt* st, const Subst& s) {
    if (st == nullptr) {
        return nullptr;
    }
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) {
        auto n = std::make_unique<ast::ExprStmt>();
        n->loc = x->loc;
        n->expr = cloneExpr(x->expr.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DemandStmt*>(st)) {
        auto n = std::make_unique<ast::DemandStmt>();
        n->loc = x->loc;
        n->message = x->message;
        n->condition = cloneExpr(x->condition.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BreakStmt*>(st)) {
        auto n = std::make_unique<ast::BreakStmt>();
        n->loc = st->loc;
        n->label = x->label;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ContinueStmt*>(st)) {
        auto n = std::make_unique<ast::ContinueStmt>();
        n->loc = st->loc;
        n->label = x->label;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) {
        auto n = std::make_unique<ast::LabeledStmt>();
        n->loc = st->loc;
        n->label = x->label;
        n->stmt = cloneStmt(x->stmt.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::LabelMarkStmt*>(st)) {
        auto n = std::make_unique<ast::LabelMarkStmt>();
        n->loc = st->loc;
        n->name = x->name;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ComefromStmt*>(st)) {
        auto n = std::make_unique<ast::ComefromStmt>();
        n->loc = st->loc;
        n->name = x->name;
        return n;
    }
    // THE EIGHT KINDS THIS FUNCTION DID NOT HANDLE, and what they cost.
    //
    // A statement it does not know about is DROPPED from the copy, with a warning nobody reads
    // because the copy is made by passes that run on every program. pico met all of these at once by
    // declaring a single `typealias`: the alias pass re-clones every class in the program, so a
    // kernel that had been building for a year lost its inline assembly, its `cascade delete`s and
    // its chaos tetrad in one build. The visible symptom was polc crashing in `emitFunctions` -- a
    // `naked` method whose `asm` body had been deleted is a function with no body at all.
    //
    // `asm` is the one that matters most: it is how every `naked` entry point in a freestanding
    // program is written, so dropping it turns a syscall stub, an interrupt entry or a `_start` into
    // an empty function, silently, on any program that also happens to use a generic or an alias.
    if (const auto* x = dynamic_cast<const ast::AsmStmt*>(st)) {
        auto n = std::make_unique<ast::AsmStmt>();
        n->loc = x->loc;
        n->arch = x->arch;
        n->dialect = x->dialect;
        n->body = x->body;
        for (const auto& o : x->outputs) { n->outputs.push_back(cloneExpr(o.get(), s)); }
        for (const auto& i : x->inputs) { n->inputs.push_back(cloneExpr(i.get(), s)); }
        n->clobbers = x->clobbers;
        // ...AND WHERE EACH OPERAND MUST BE. A clone that drops these produces a block whose
        // operands go wherever the allocator likes: it assembles, it runs, and `in $0, dx` reads
        // whatever register `$0` happened to land in. Copied rather than rebuilt, because a place
        // is a string about the machine and substitution has nothing to say to it.
        n->outputWhere = x->outputWhere;
        n->inputWhere = x->inputWhere;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::GotoStmt*>(st)) {
        auto n = std::make_unique<ast::GotoStmt>();
        n->loc = x->loc;
        n->name = x->name;
        n->address = cloneExpr(x->address.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AbstainfromStmt*>(st)) {
        auto n = std::make_unique<ast::AbstainfromStmt>();
        n->loc = x->loc;
        n->name = x->name;
        n->isReinstate = x->isReinstate;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CascadeStmt*>(st)) {
        auto n = std::make_unique<ast::CascadeStmt>();
        n->loc = x->loc;
        n->op = x->op;
        n->target = cloneExpr(x->target.get(), s);
        n->dest = cloneExpr(x->dest.get(), s);
        if (auto it = s.find(x->typeName); it != s.end()) { n->typeName = it->second; }
        else { n->typeName = x->typeName; }
        n->params = x->params;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CascadeMoveStmt*>(st)) {
        auto n = std::make_unique<ast::CascadeMoveStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->fromRegion = x->fromRegion;
        n->toRegion = x->toRegion;
        n->leavingPersistents = x->leavingPersistents;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SnapshotIntoStmt*>(st)) {
        auto n = std::make_unique<ast::SnapshotIntoStmt>();
        n->loc = x->loc;
        n->region = x->region;
        n->into = cloneExpr(x->into.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RestoreStmt*>(st)) {
        auto n = std::make_unique<ast::RestoreStmt>();
        n->loc = x->loc;
        n->region = x->region;
        n->snapshot = cloneExpr(x->snapshot.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReimportValidateStmt*>(st)) {
        auto n = std::make_unique<ast::ReimportValidateStmt>();
        n->loc = x->loc;
        if (auto it = s.find(x->target); it != s.end()) { n->target = it->second; }
        else { n->target = x->target; }
        n->expected = cloneExpr(x->expected.get(), s);
        n->usingVars = x->usingVars;
        if (x->expecting) {
            n->expecting = std::make_unique<ast::Block>(cloneBlock(*x->expecting, s));
        }
        if (x->onFailure) {
            n->onFailure = std::make_unique<ast::Block>(cloneBlock(*x->onFailure, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) {
        auto n = std::make_unique<ast::ThrowStmt>();
        n->loc = x->loc;
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) {
        auto n = std::make_unique<ast::TryStmt>();
        n->loc = x->loc;
        n->body = cloneBlock(x->body, s);
        for (const auto& c : x->catches) {
            ast::CatchClause nc;
            nc.loc = c.loc;
            nc.type = substType(c.type, s);
            nc.name = c.name;
            nc.body = cloneBlock(c.body, s);
            n->catches.push_back(std::move(nc));
        }
        if (x->finallyBlock) {
            n->finallyBlock = std::make_unique<ast::Block>(cloneBlock(*x->finallyBlock, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) {
        auto n = std::make_unique<ast::ForeachStmt>();
        n->loc = x->loc;
        n->elemType = substType(x->elemType, s);
        n->isVar = x->isVar;
        n->varName = x->varName;
        n->indexName = x->indexName;
        n->isComptime = x->isComptime;
        n->iterable = cloneExpr(x->iterable.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) {
        auto n = std::make_unique<ast::SwitchStmt>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::SwitchCase nc;
            nc.loc = c.loc;
            nc.value = cloneExpr(c.value.get(), s);
            nc.body = cloneBlock(c.body, s);
            n->cases.push_back(std::move(nc));
        }
        if (x->defaultBody) {
            n->defaultBody = std::make_unique<ast::Block>(cloneBlock(*x->defaultBody, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) {  // was missing -> null deref crash
        auto n = std::make_unique<ast::MatchStmt>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::MatchCase nc;
            nc.loc = c.loc;
            auto it = s.find(c.typeName);
            nc.typeName = it != s.end() ? it->second : c.typeName;
            for (const auto& b : c.bindings) {
                ast::Param p;
                p.type = substType(b.type, s);
                p.name = b.name;
                p.loc = b.loc;
                nc.bindings.push_back(std::move(p));
            }
            nc.body = cloneBlock(c.body, s);
            if (c.result) {
                nc.result = cloneExpr(c.result.get(), s);
            }
            n->cases.push_back(std::move(nc));
        }
        if (x->defaultBody) {
            n->defaultBody = std::make_unique<ast::Block>(cloneBlock(*x->defaultBody, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) {
        auto n = std::make_unique<ast::ReturnStmt>();
        n->loc = x->loc;
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) {
        auto n = std::make_unique<ast::DeleteStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        // EVERYTHING ELSE THE STATEMENT SAID, which this used to drop on the floor.
        //
        // Cloning only the target turned `delete node from region this.nodes` into a plain
        // `delete node` inside every GENERIC type -- silently, because an empty `fromRegion` is not
        // an error anywhere; it simply means "ordinary heap delete". The program then handed a region
        // slot to the allocator and the runtime trapped with `delete of a region object: use
        // delete X from region R`, naming the exact form the source already used.
        //
        // That is why no container in the standard library could hold its nodes in a region: every
        // container is generic. `delete a, b, c` lost its extra targets here as well, which leaks.
        n->fromRegion = x->fromRegion;
        n->fromHeap = x->fromHeap;
        for (const auto& t : x->moreTargets) {
            n->moreTargets.push_back(cloneExpr(t.get(), s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReleaseStmt*>(st)) {
        auto n = std::make_unique<ast::ReleaseStmt>();
        n->loc = x->loc;
        n->region = x->region;
        // ...AND THE OTHER THREE FIELDS, which this dropped. `release persistent obj.field` carries
        // its target in `target` and says so with `isPersistent`; copying only `region` turned it
        // into `release region ""` the moment its class was cloned -- which happens to every generic
        // instance and to every class the disambiguating rename rewrites. It surfaced as
        // `unknown region ''` pointing into the standard library, on a line that names a field.
        //
        // Same failure as the `delete` two cases below, which lost `from region` for the same reason:
        // a clone that copies one field of four, silently. The rule this file already states is that
        // a member the cloner does not know about must not become a null entry -- it holds for a
        // FIELD of a statement just as much as for a statement of a class.
        n->isPersistent = x->isPersistent;
        n->target = cloneExpr(x->target.get(), s);
        n->allKeys = x->allKeys;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RollbackStmt*>(st)) {
        auto n = std::make_unique<ast::RollbackStmt>();
        n->loc = x->loc;
        n->region = x->region;
        n->checkpoint = cloneExpr(x->checkpoint.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) {
        auto n = std::make_unique<ast::VarDeclStmt>();
        n->loc = x->loc;
        n->isMutable = x->isMutable;
        n->isVar = x->isVar;
        n->isPersistent = x->isPersistent;
        n->isEternal = x->isEternal;
        // `volatile`, AND IT IS THE ONE THAT COSTS A KERNEL.
        //
        // A local `volatile int* p = cast<int*>(...)` is how every MMIO register, every device ring
        // and every wait loop in a freestanding program is read. Dropping the word turns those reads
        // into ordinary ones, and at -O2 the optimizer hoists them out of the loop that was waiting
        // for them to change -- so a bring-up spins on a value that was true once and the device
        // never comes ready. pico lost its timer, its APIC routing, its NVMe queue, its USB disk and
        // its second processor in one build, and the only thing that had changed was that the
        // program now declared a `typealias` (which makes the alias pass re-clone every body).
        //
        // `lazy` and `comptime` are the same omission with quieter consequences: an initializer that
        // was meant to run on first access runs here instead, and one that was meant to be folded at
        // compile time survives into the executable.
        n->isVolatile = x->isVolatile;
        n->isLazy = x->isLazy;
        n->isComptime = x->isComptime;
        n->regionFlavor = x->regionFlavor;   // spec 17 flavors: carry the flavor/growth into the clone
        n->regionGrowable = x->regionGrowable;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TupleDeclStmt*>(st)) {
        auto n = std::make_unique<ast::TupleDeclStmt>();
        n->loc = x->loc;
        for (const auto& b : x->bindings) {
            ast::TupleBinding nb;
            nb.type = substType(b.type, s);
            nb.name = b.name;
            n->bindings.push_back(std::move(nb));
        }
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) {
        auto n = std::make_unique<ast::AssignStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) {
        auto n = std::make_unique<ast::IncDecStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->isIncrement = x->isIncrement;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) {
        auto n = std::make_unique<ast::DeferStmt>();
        n->loc = x->loc;
        n->within = cloneExpr(x->within.get(), s);  // spec 32.10: the cleanup's time budget
        n->body = cloneBlock(x->body, s);
        return n;
    }
    // ---- the ten this had never been taught -------------------------------------------------
    //
    // Every one of these was reaching the warning at the bottom and being DROPPED. That is not only
    // the alias pass: this same function instantiates every generic, so a `synchronized` inside a
    // generic class lost its lock, a `yield` lost the thing that makes it a generator, and an
    // `await` (below, in cloneExpr) stopped waiting -- silently, in a program that still compiled.
    //
    // The warning did fire, which is the only reason any of this was findable. It said "cloneStmt
    // does not handle its kind" and nothing else, on stderr, in the middle of a build.
    if (const auto* x = dynamic_cast<const ast::YieldStmt*>(st)) {
        auto n = std::make_unique<ast::YieldStmt>();
        n->loc = x->loc;
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SynchronizedStmt*>(st)) {
        auto n = std::make_unique<ast::SynchronizedStmt>();
        n->loc = x->loc;
        n->mutex = cloneExpr(x->mutex.get(), s);
        n->bindType = substType(x->bindType, s);
        n->bindName = x->bindName;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AsmStmt*>(st)) {
        auto n = std::make_unique<ast::AsmStmt>();
        n->loc = x->loc;
        n->arch = x->arch;
        n->dialect = x->dialect;
        n->body = x->body;      // captured raw: not tokenized, so nothing to substitute inside it
        for (const auto& e : x->outputs) {
            n->outputs.push_back(cloneExpr(e.get(), s));
        }
        for (const auto& e : x->inputs) {
            n->inputs.push_back(cloneExpr(e.get(), s));
        }
        n->clobbers = x->clobbers;
        n->outputWhere = x->outputWhere;   // see the other AsmStmt clone for why these travel
        n->inputWhere = x->inputWhere;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::GotoStmt*>(st)) {
        auto n = std::make_unique<ast::GotoStmt>();
        n->loc = x->loc;
        n->name = x->name;
        n->address = cloneExpr(x->address.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CascadeStmt*>(st)) {
        auto n = std::make_unique<ast::CascadeStmt>();
        n->loc = x->loc;
        n->op = x->op;
        n->target = cloneExpr(x->target.get(), s);
        n->dest = cloneExpr(x->dest.get(), s);
        // A bare type name, substituted the way `cloneClass` does its own: straight through the map.
        if (auto it = s.find(x->typeName); it != s.end()) {
            n->typeName = it->second;
        } else {
            n->typeName = x->typeName;
        }
        n->params = x->params;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CascadeMoveStmt*>(st)) {
        auto n = std::make_unique<ast::CascadeMoveStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->fromRegion = x->fromRegion;
        n->toRegion = x->toRegion;
        n->leavingPersistents = x->leavingPersistents;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AbstainfromStmt*>(st)) {
        auto n = std::make_unique<ast::AbstainfromStmt>();
        n->loc = x->loc;
        n->name = x->name;
        n->isReinstate = x->isReinstate;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RestoreStmt*>(st)) {
        auto n = std::make_unique<ast::RestoreStmt>();
        n->loc = x->loc;
        n->region = x->region;
        n->snapshot = cloneExpr(x->snapshot.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SnapshotIntoStmt*>(st)) {
        auto n = std::make_unique<ast::SnapshotIntoStmt>();
        n->loc = x->loc;
        n->region = x->region;
        n->into = cloneExpr(x->into.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReimportValidateStmt*>(st)) {
        auto n = std::make_unique<ast::ReimportValidateStmt>();
        n->loc = x->loc;
        n->target = x->target;
        n->expected = cloneExpr(x->expected.get(), s);
        n->usingVars = x->usingVars;
        if (x->expecting != nullptr) {
            n->expecting = std::make_unique<ast::Block>(cloneBlock(*x->expecting, s));
        }
        if (x->onFailure != nullptr) {
            n->onFailure = std::make_unique<ast::Block>(cloneBlock(*x->onFailure, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) {
        auto n = std::make_unique<ast::UsingStmt>();
        n->loc = x->loc;
        n->decl = cloneStmt(x->decl.get(), s);
        n->varName = x->varName;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) {
        auto n = std::make_unique<ast::IfStmt>();
        n->loc = x->loc;
        // `comptime` TRAVELS, and dropping it is not a lost optimisation -- it is a different
        // program. A `comptime if` selects which arm EXISTS: the untaken one is not analysed and
        // not emitted, so it may name a register this target does not have. A clone that forgets
        // the word turns it into an ordinary runtime `if`, both arms lower, and the arm written for
        // another architecture reaches the assembler.
        //
        // Found the way the other seven were: `Machine.Port` compiled everywhere until a program
        // containing a `typealias` -- which is what sends a body through this cloner -- reported
        // *"this `asm` block is written for i686, and the target is x86_64"* from inside the
        // standard library. Same hole, eighth instance; see `polc-clone-fidelity`.
        n->isComptime = x->isComptime;
        n->cond = cloneExpr(x->cond.get(), s);
        n->thenBlock = cloneBlock(x->thenBlock, s);
        if (x->elseBlock) {
            n->elseBlock = std::make_unique<ast::Block>(cloneBlock(*x->elseBlock, s));
        }
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) {
        auto n = std::make_unique<ast::WhileStmt>();
        n->loc = x->loc;
        n->cond = cloneExpr(x->cond.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) {
        auto n = std::make_unique<ast::DoWhileStmt>();
        n->loc = x->loc;
        n->body = cloneBlock(x->body, s);
        n->cond = cloneExpr(x->cond.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) {
        auto n = std::make_unique<ast::ForStmt>();
        n->loc = x->loc;
        n->init = cloneStmt(x->init.get(), s);
        n->cond = cloneExpr(x->cond.get(), s);
        n->update = cloneStmt(x->update.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    // `unimport X` / `reimport X` NAMES A TYPE, so it follows a rename like any other reference --
    // and it was not handled here at all, so the statement was DROPPED whenever this clone ran.
    //
    // It ran for the first time on a program that had done nothing unusual: the type collided with a
    // standard-library name, which triggered the renaming pass, which silently removed the one
    // statement the program was written to demonstrate. The compiler warned that it did not know the
    // kind -- which is exactly the right thing to do and is why this was five minutes rather than an
    // afternoon -- but a warning is not a substitute for handling it.
    if (const auto* x = dynamic_cast<const ast::UnimportStmt*>(st)) {
        auto n = std::make_unique<ast::UnimportStmt>();
        n->loc = x->loc;
        n->isReimport = x->isReimport;
        n->granularity = x->granularity;
        if (auto it = s.find(x->target); it != s.end()) {
            n->target = it->second;
        } else {
            n->target = x->target;
        }
        return n;
    }
    // Same rule as `cloneExpr`: a statement kind this has not been taught is a bug here, and it
    // says so instead of returning a null that something downstream will dereference.
    monoWarn(st->loc, "internal: this statement is not preserved when a generic is expanded, so it "
                      "will be missing from the instantiation -- cloneStmt does not handle its kind");
    return nullptr;
}

// Deep-clones applied annotations (spec 14.3), substituting types inside their argument
// expressions, so a class/member keeps its annotations through cloning (generics, namespace
// qualification, alias expansion).
std::vector<ast::AnnotationUse> cloneAnnotations(const std::vector<ast::AnnotationUse>& anns,
                                                 const Subst& s) {
    std::vector<ast::AnnotationUse> out;
    for (const ast::AnnotationUse& a : anns) {
        ast::AnnotationUse u;
        u.loc = a.loc;
        u.name = a.name;
        for (const ast::AnnotationArg& arg : a.args) {
            u.args.push_back({arg.name, cloneExpr(arg.value.get(), s), arg.loc});
        }
        out.push_back(std::move(u));
    }
    return out;
}

// Every branch copies field by field, so anything added to a declaration has to be added here too --
// which is what the note further down is about. `isSynthesized` is set once for all of them at the
// return, because it belongs to `MemberDecl` and not to any one kind.
ast::MemberPtr cloneMemberOfKind(const ast::MemberDecl* m, const Subst& s);

ast::MemberPtr cloneMember(const ast::MemberDecl* m, const Subst& s) {
    ast::MemberPtr out = cloneMemberOfKind(m, s);
    if (out != nullptr) {
        out->isSynthesized = m->isSynthesized;
    }
    return out;
}

ast::MemberPtr cloneMemberOfKind(const ast::MemberDecl* m, const Subst& s) {
    if (const auto* x = dynamic_cast<const ast::MethodDecl*>(m)) {
        auto n = std::make_unique<ast::MethodDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isStatic = x->isStatic;
        n->isAbstract = x->isAbstract;
        n->isOverride = x->isOverride;
        n->isFinal = x->isFinal;
        n->isProperty = x->isProperty;
        n->isComptime = x->isComptime;
        n->isAsync = x->isAsync;
        n->isVolatile = x->isVolatile;
        // EVERYTHING ELSE THE DECLARATION SAID. This clone used to copy eleven flags and stop, so a
        // generic class with an `extern` method lost its externness on instantiation -- the copy came
        // out as an ordinary method with no body. That is the fourth time this file has silently
        // dropped part of a declaration (DeleteStmt's region, NewExpr's region, RegionInitExpr's
        // address); the shape of the bug is always the same, and it is always invisible, because a
        // clone that forgets a field produces something that still compiles.
        n->isDeprecated = x->isDeprecated;
        n->isExtern = x->isExtern;
        n->isVariadic = x->isVariadic;
        n->isNaked = x->isNaked;
        n->isInterrupt = x->isInterrupt;
        n->isEachFamily = x->isEachFamily;
        // `isProcedure` is deliberately NOT copied, and finding out why cost a red suite.
        //
        // This clone is also the copier the transformer machinery uses to inject a `procedure` into the
        // type that applies it -- and in that copy the procedure stops being a socket and becomes an
        // ordinary method of the type. Carrying the flag over made the analyser look for the
        // transformer that declared it, on a type that now simply has the method:
        //     'compareTo' is written as a `procedure`, but no transformer this type applies declares it
        // The omission is the mechanism, not an oversight.
        n->isGeneratorBody = x->isGeneratorBody;
        n->genElem = x->genElem;
        n->genSym = x->genSym;
        n->externConvention = x->externConvention;
        n->externSymbol = x->externSymbol;
        n->propertySetter = x->propertySetter;
        n->name = x->name;
        // A type parameter that is `itself` is not a parameter at all -- it is the applying type,
        // and this copy is being made FOR that type. Substituted like any other type name, so a
        // structural `copy<itself f>` arrives at `Point` already knowing it builds a Point.
        n->typeParams = x->typeParams;
        for (std::string& tp : n->typeParams) {
            if (auto it = s.find(tp); it != s.end()) {
                tp = it->second;
            }
        }
        n->boundTarget = x->boundTarget;
        n->boundTargetLoc = x->boundTargetLoc;
        n->boundTargetMutable = x->boundTargetMutable;
        for (const auto& p : x->params) {
            n->params.push_back({substType(p.type, s), p.name, p.loc});
        }
        n->returnType = substType(x->returnType, s);
        for (const auto& t : x->throwsTypes) {
            n->throwsTypes.push_back(substType(t, s));
        }
        for (const auto& c : x->requiresClauses) {
            n->requiresClauses.push_back(cloneExpr(c.get(), s));
        }
        for (const auto& c : x->ensuresClauses) {
            n->ensuresClauses.push_back(cloneExpr(c.get(), s));
        }
        n->body = cloneBlock(x->body, s);
        n->annotations = cloneAnnotations(x->annotations, s);
        // AND WHAT THE DECLARATION SAID ABOUT ITSELF THAT NOTHING ABOVE ASKED FOR -- the same rule
        // as `cloneClass`: a clone that lists what it keeps forgets whatever is added later.
        //
        // `isProcedure` is the one that showed: `Duration applies TComparer` writes
        // `public procedure compareTo(...)`, the clone came back saying `method`, and the checker
        // told the prelude to write the word it had already written. It could not fire before,
        // because `cloneClass` was dropping `applies` at the same time -- two silences that hid
        // each other, and fixing one revealed the other.
        n->isProcedure = x->isProcedure;
        // ...AND WHETHER THIS BODY IS DATA. `resolveLayouts` runs BEFORE this pass and marks the
        // member a layout's `resolvedBy` names, so that the analyser reads it instead of analysing
        // it. Dropping the mark here does not lose a feature -- it turns the resolver back into
        // ordinary code, and the first thing the analyser then says is *use of undeclared variable
        // 'itself'*, pointing at a line that is not wrong, in a file the author will not think to
        // connect to the `typealias` three files away that made the clone happen at all.
        n->isLayoutResolver = x->isLayoutResolver;
        n->fromTransformer = x->fromTransformer;
        n->boundTargetType = x->boundTargetType;
        n->boundTargetVia = x->boundTargetVia;
        n->composedVia = x->composedVia;
        n->whenSubject = x->whenSubject;
        n->whenTransformer = x->whenTransformer;
        n->whenLoc = x->whenLoc;
        n->law = cloneExpr(x->law.get(), s);   // an expression, so it is cloned rather than shared
        n->escapeSummary = x->escapeSummary;
        // ...AND THE THREE THAT WERE STILL MISSING, which is the fifth time this file has dropped
        // part of a declaration.
        //
        // `surveyed` is the one that showed. It is the whole of what the region binder is told about
        // a call into a foreign function -- "I have read the other side and I answer for this" -- so
        // a clone without it is a method whose own escape hatch was thrown away. What that reads
        // like is not a missing feature: it is the binder REFUSING code that says the thing the
        // binder asked for, on a line that carries the word, and only in programs large enough to
        // make this pass clone anything. The compiler's own bare-metal reporter hit it from inside
        // the compiler; a five-file program did not, and a three-hundred-file one did.
        //
        // The other two are the same shape and were found beside it: `reentrant` is an obligation
        // that must be inherited or the check it exists for stops running on the copy, and `pass`
        // decides whether the body means one element or the array the compiler synthesises over.
        n->isSurveyed = x->isSurveyed;
        n->isReentrant = x->isReentrant;
        n->isPass = x->isPass;
        // ...AND THE SIXTH TIME, which is `command`. Three fields, and dropping them does not lose a
        // modifier -- it loses the MEMBER KIND: the clone comes out as an ordinary method whose body
        // reads a name (`pack`) that only a command has, so the failure is "use of undeclared
        // variable 'pack'" inside the standard library, on a line the reader never wrote, in any
        // program that happens to make this pass clone anything. Which is one that declares a type
        // whose name the library also uses.
        //
        // The parameter types are substituted like every other type here: a command inside a generic
        // carries `T` in its baggage exactly as its parameters do.
        n->isCommand = x->isCommand;
        n->packName = x->packName;
        n->packLoc = x->packLoc;
        n->isReadonly = x->isReadonly;   // a promise the copy has to keep too
        n->isCold = x->isCold;
        n->isMustUse = x->isMustUse;
        for (const ast::Param& p : x->carries) {
            ast::Param q = p;
            q.type = substType(p.type, s);
            n->carries.push_back(std::move(q));
        }
        n->typeParamBounds = x->typeParamBounds;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::FieldDecl*>(m)) {
        auto n = std::make_unique<ast::FieldDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isStatic = x->isStatic;
        n->isMutable = x->isMutable;
        n->isPersistent = x->isPersistent;
        n->isEternal = x->isEternal;
        n->isTransient = x->isTransient;
        n->isVolatile = x->isVolatile;
        n->isLazy = x->isLazy;
        n->isExternal = x->isExternal;
        n->isMovable = x->isMovable;
        n->isUnique = x->isUnique;
        // THE FIVE THAT WERE MISSING, and every one of them changes what the field MEANS.
        //
        // A clone is not made only for generics. `qualifyNamespaces` rewrites EVERY class in a
        // namespace as soon as ONE name in it is ambiguous -- so declaring a class whose name the
        // standard library also uses silently re-made every field in that namespace without these:
        //
        //   `weak T*`   became an OWNING pointer. The whole point of `weak` is that it does not keep
        //               the pointee alive and is nulled when it dies; dropped, two objects own one
        //               thing and the second release is a double free.
        //   `delegate`  stopped forwarding, so a class that satisfied an interface BY delegation no
        //               longer satisfied it -- reported as a missing method it never had.
        //   region flavor / `growable`
        //               turned every pool/stack region back into a plain bump region, and a growable
        //               one into a fixed one that panics when it fills.
        //   `affinity`  lost the field grouping: a layout promise silently withdrawn.
        //
        // None of them fails AT the clone. They fail later, somewhere else, as something else -- which
        // is why a missing line here cost a whole session to find from the far end.
        n->isWeak = x->isWeak;
        n->isDelegate = x->isDelegate;
        n->affinity = x->affinity;
        n->regionFlavor = x->regionFlavor;
        n->regionGrowable = x->regionGrowable;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->bitWidth = x->bitWidth;
        n->propertySetter = x->propertySetter;
        n->init = cloneExpr(x->init.get(), s);
        n->annotations = cloneAnnotations(x->annotations, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ConstructorDecl*>(m)) {
        auto n = std::make_unique<ast::ConstructorDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        for (const auto& p : x->params) {
            n->params.push_back({substType(p.type, s), p.name, p.loc});
        }
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DestructorDecl*>(m)) {
        auto n = std::make_unique<ast::DestructorDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    // THE OTHER TWO KINDS OF MEMBER, and leaving them out DELETED them.
    //
    // A member this function does not recognize returned null, and `cloneClass` pushed that null
    // into the member list -- so a `comptime literal` and a `fixed` did not survive a rewrite. The
    // rewrite is not a rare event: `qualifyNamespaces` re-clones classes as soon as one type name in
    // the program is ambiguous, and an explicit `Bundle.Namespace.Type` reference anywhere is enough
    // on its own.
    //
    // What it cost: declaring a class in two of your own namespaces made
    // `import System.Memory.Units.megabytes` fail as an UNKNOWN SYMBOL -- an import of the standard
    // library, in a file the collision has nothing to do with, reported at a line the author cannot
    // connect to the cause. The suffix survived and only the import broke, which is the worst
    // version: the error names the one thing that was still right.
    if (const auto* x = dynamic_cast<const ast::LiteralDecl*>(m)) {
        auto n = std::make_unique<ast::LiteralDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isComptime = x->isComptime;
        n->name = x->name;
        n->param = {substType(x->param.type, s), x->param.name, x->param.loc};
        n->returnType = substType(x->returnType, s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ConstDecl*>(m)) {
        auto n = std::make_unique<ast::ConstDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    return nullptr;
}

ast::ClassDecl cloneClass(const ast::ClassDecl& d, const Subst& s, const std::string& newName) {
    ast::ClassDecl c;
    c.loc = d.loc;
    c.visibility = d.visibility;
    c.name = newName;  // concrete: no type params
    // WHAT KIND OF DECLARATION THIS IS. All of it, and the list is exhaustive on purpose: this
    // function had eight of the flags and the tree has fourteen, so a clone quietly changed what a
    // type WAS. Two of the six missing ones are silent corruption rather than a missing feature:
    //
    //   * `isUnion` -- a union whose fields overlap one storage became a struct whose fields sit in
    //     sequence. Same members, same names, different memory, no diagnostic anywhere.
    //   * `isLayout` -- a `layout` stopped being one, so `resolveLayouts` left it in the interface
    //     list and every implementer was told "'WmRequest' implements 'WireRecord', which is not an
    //     interface". pico met this by declaring ONE `typealias`, three files away: the alias pass
    //     re-clones every class in the program, so a feature that was working became three errors
    //     about a file nobody had touched.
    //
    // ...and the same for `isRegionClass` (instances silently leave the family's arena), `isHeap`
    // (the program's allocator stops being declared), `isFinal` and `foreignLibrary`. The rule this
    // function needs is the one `cloneMember` learned the hard way: a clone that copies most of a
    // declaration is a rewrite that changes it.
    c.isInterface = d.isInterface;
    // ...and WHICH KIND of interface. `Comparer<int>` that stopped being a command type would start
    // collecting the advice meant for an author who chose a pointer -- `DogTest&`, which no caller
    // can pass -- on every API in the library that takes a command.
    c.isCommandType = d.isCommandType;
    // ...and whether a value of it may be dropped. `Result<int, String>` that stopped being
    // `mustuse` would take the rule off exactly the types it was written for.
    c.isMustUse = d.isMustUse;
    c.isStruct = d.isStruct;
    c.isRecord = d.isRecord;
    c.isUnion = d.isUnion;
    c.isLayout = d.isLayout;
    c.isAbstract = d.isAbstract;
    c.isFinal = d.isFinal;
    c.isSealed = d.isSealed;          // keep sealed + permits so generic-sealed match stays exhaustive
    c.permits = d.permits;
    c.typeParamBounds = d.typeParamBounds;
    c.isMovable = d.isMovable;
    c.isUnique = d.isUnique;
    c.isPartitionable = d.isPartitionable;
    c.isRegionClass = d.isRegionClass;
    c.isHeap = d.isHeap;
    c.foreignLibrary = d.foreignLibrary;
    // The layouts a type is arranged by, once `resolveLayouts` has validated `arranges` and split
    // any still spelled `implements` out of `interfaces`. A clone that ran after that pass --
    // monomorphization does -- would otherwise drop the arrangement, and a generic value type would
    // lose the size it promised.
    c.layouts = d.layouts;
    // ...AND WHAT A LAYOUT CONCEDES, which is the half that decides what gets built. Dropping these
    // would not lose a size, it would silently change one: a cloned `permits reorder` reverts to
    // declaration order, so the original and the instantiation disagree on every offset. Same hole
    // as the paragraph above, at the one place where the two halves of one program are the two that
    // disagree.
    c.permitsReorder = d.permitsReorder;
    c.permitsPadding = d.permitsPadding;
    // The transformer clauses. `applies` is what the author wrote and is printed back by the
    // documentation generator; `appliedClosure` is what a `<T applies TComparer>` constraint is
    // checked against long after the transformers themselves are gone.
    c.applies = d.applies;
    c.appliesLocs = d.appliesLocs;
    c.appliedClosure = d.appliedClosure;
    c.entrusts = d.entrusts;
    c.satisfies = d.satisfies;
    c.satisfiesLocs = d.satisfiesLocs;
    c.superclass = d.superclass;
    for (const auto& a : d.superclassTypeArgs) {  // substitute T in `extends Base<T>`
        auto it = s.find(a);
        c.superclassTypeArgs.push_back(it != s.end() ? it->second : a);
    }
    c.interfaces = d.interfaces;
    for (const auto& argList : d.interfaceTypeArgs) {  // substitute T in `implements Iface<T>`
        std::vector<std::string> sub;
        for (const auto& a : argList) {
            auto it = s.find(a);
            sub.push_back(it != s.end() ? it->second : a);
        }
        c.interfaceTypeArgs.push_back(std::move(sub));
    }
    // A member the cloner does not know about must not become a null entry in the list: that is how
    // a `comptime literal` and a `fixed` were silently deleted by a rewrite. Say so instead -- a
    // seventh kind of member added later is a bug in THIS function, and it should report itself
    // here rather than surface as a name that has gone missing three passes downstream.
    for (const auto& m : d.members) {
        ast::MemberPtr cm = cloneMember(m.get(), s);
        if (cm == nullptr) {
            monoWarn(m->loc, "internal: this member is not preserved when its class is rewritten, "
                             "so it will be missing from '" + newName +
                                 "' -- cloneMember does not handle its kind");
            continue;
        }
        c.members.push_back(std::move(cm));
    }
    // THE CLASS INVARIANTS, which this dropped entirely until 2026-08-14.
    //
    // A generic class lost its contracts the moment it was instantiated: `HashMap<K,V>` declares five
    // invariants, and `HashMap$int$int` -- the class every program actually uses -- had none. Nothing
    // checked them at any exit, so a `count` that went negative or an array that stopped matching
    // `cap` went unreported in exactly the code the clauses were written to protect.
    //
    // Found while looking for why the optimiser was not being told about them; the missing enforcement
    // is the more serious half. It is the same failure as `cloneMember` dropping `isExtern` and nine
    // other fields: a clone that copies eighteen things and forgets the nineteenth, silently.
    //
    // Substituted like everything else here, since an invariant may name the type parameter.
    for (const auto& inv : d.invariants) {
        c.invariants.push_back(cloneExpr(inv.get(), s));
    }
    c.annotations = cloneAnnotations(d.annotations, s);
    // THE LIFECYCLE HOOKS, which this dropped -- the same failure as the invariants above, one
    // paragraph later. A class that was rewritten for any reason (instantiated, or renamed because
    // its name collides with the standard library's) lost its `onClassLoad`, `onFirstInstance`,
    // `onLastInstanceDestroyed` and `onClassUnload` blocks outright: the program printed neither its
    // setup nor its teardown line and reported nothing, because a hook that is not there is
    // indistinguishable from a hook that was never written.
    //
    // Found by a standard-library class named `Pool` making a user's `Pool` get renamed -- which is
    // to say, found by accident, on the day a name happened to collide. Every generic class with a
    // hook had been losing it since generics existed.
    auto cloneHook = [&s](const std::unique_ptr<ast::Block>& b) -> std::unique_ptr<ast::Block> {
        if (!b) {
            return nullptr;
        }
        return std::make_unique<ast::Block>(cloneBlock(*b, s));
    };
    c.onClassLoad = cloneHook(d.onClassLoad);
    c.onFirstInstance = cloneHook(d.onFirstInstance);
    c.onLastInstanceDestroyed = cloneHook(d.onLastInstanceDestroyed);
    c.onClassUnload = cloneHook(d.onClassUnload);
    // ...AND THE FIFTH HOOK, which is the one the paragraph above did not know about.
    //
    // `onArrange` has the same shape as the four -- a block nobody calls -- at a different MOMENT:
    // those run in the built program, this one runs during the build. Dropping it does not lose a
    // line of output, it loses a GUARANTEE: a layout with no `onArrange` asks for nothing, so
    // `fitWithin` stops being checked, `refuse` never speaks, and `resolvedBy` names nobody. The
    // author writes a size budget down and gets one on some builds and not others, depending on
    // whether anything in the program happens to collide with a standard-library name or declare a
    // `typealias` three files away.
    //
    // Found from the other end: a probe type called `Queue` -- which the standard library also
    // declares -- reported `use of undeclared variable 'itself'` inside its own resolver. The
    // resolver was fine. Its layout had been emptied, so nothing knew the method was a resolver.
    c.onArrange = cloneHook(d.onArrange);
    // EVERYTHING ELSE THE DECLARATION SAID ABOUT ITSELF, and it has to be everything.
    //
    // A CLONE THAT FORGETS IS A LANGUAGE THAT FORGETS. This function listed the facts it copied, so
    // a fact added to `ClassDecl` afterwards was dropped by it silently -- and `resolveTypeAliases`
    // runs EVERY class in the program through here the moment a single `typealias` is declared
    // anywhere. So one alias in one file quietly stripped `layout`, `union`, `heap class`,
    // `region class`, `final`, every transformer marker, every `applies`/`entrusts`/`satisfies`
    // clause and the FFI library name, from every class in the program.
    //
    // What it looked like: `'Beast' implements 'ThreeToALine', which is not an interface`. The
    // layout was still declared with the word `layout`; the copy of it that reached the analyser had
    // simply forgotten. Two of the losses -- `typeParams` and `typeParamVariance` -- were already
    // being patched back at the one call site that noticed, which is this bug found once and
    // repaired locally rather than here.
    //
    // The order below is `ClassDecl`'s own. A field added there and not here is the same defect
    // again, and it will show up as a keyword that stops meaning anything in a program that happens
    // to contain an alias.
    c.isLayout = d.isLayout;
    c.permitsReorder = d.permitsReorder;   // what the layout concedes, not merely that it is one
    c.permitsPadding = d.permitsPadding;
    c.isUnion = d.isUnion;
    c.isHeap = d.isHeap;
    c.isRegionClass = d.isRegionClass;
    c.isFinal = d.isFinal;
    c.isPartial = d.isPartial;
    c.isTransformer = d.isTransformer;
    c.isMutualTransformer = d.isMutualTransformer;
    c.isExplicitTransformer = d.isExplicitTransformer;
    c.isCollectiveTransformer = d.isCollectiveTransformer;
    c.isFreestandingTransformer = d.isFreestandingTransformer;
    c.applies = d.applies;
    c.appliesLocs = d.appliesLocs;
    c.entrusts = d.entrusts;
    c.satisfies = d.satisfies;
    c.satisfiesLocs = d.satisfiesLocs;
    c.layouts = d.layouts;
    c.procCalls = d.procCalls;
    c.appliedClosure = d.appliedClosure;
    c.foreignLibrary = d.foreignLibrary;
    c.errorTypes = d.errorTypes;
    c.sourceText = d.sourceText;
    c.nameLoc = d.nameLoc;
    c.declEnd = d.declEnd;
    // NOT `typeParams`/`typeParamVariance`: a clone is normally a CONCRETE instantiation, and
    // carrying the parameters over would leave `Box$int` still claiming to be generic. The one
    // caller that clones a template to keep it generic (`resolveTypeAliases`) restores them itself,
    // and says so.
    return c;
}

// ---- Collect generic instantiations used in the program ----
// A type argument can itself be a nested mangled generic, e.g. ArrayList<Handler<int>> stores the arg as
// "Handler$int". That inner instance (Handler$int) must be generated too, so split "Base$arg1$arg2..." and
// register it when Base is generic, recursing for deeper nesting (spec 15.1).
void collectTypeArgString(const std::string& a0, const std::set<std::string>& generics, InstMap& out) {
    // Strip trailing type decorations (`*`, `&`, `?`, `[]`) first: canonicalType appends them AFTER the
    // mangled generic name, so a type argument like ArrayList<int>* becomes "ArrayList$int*". Those markers
    // decorate the whole instance (a pointer TO ArrayList<int>), not its last type argument. Without this,
    // the split below misreads "ArrayList$int*" as ArrayList<int*> and registers a bogus element-is-pointer
    // instance -- which collides with and corrupts the real ArrayList<int>. The base instance to generate is
    // the same whether it is used by value or via pointer/array, so we collect the undecorated form.
    std::string a = a0;
    bool changed = true;
    while (changed) {
        changed = false;
        if (!a.empty() && (a.back() == '*' || a.back() == '&' || a.back() == '?')) {
            a.pop_back();
            changed = true;
        } else if (a.size() >= 2 && a.compare(a.size() - 2, 2, "[]") == 0) {
            a.erase(a.size() - 2);
            changed = true;
        }
    }
    const std::size_t d = a.find('$');
    if (d == std::string::npos) {
        return;  // a plain type, nothing nested to instantiate
    }
    const std::string base = a.substr(0, d);
    if (generics.count(base) == 0) {
        return;
    }
    std::vector<std::string> args;
    std::size_t start = d + 1;
    while (true) {
        const std::size_t e = a.find('$', start);
        args.push_back(a.substr(start, e == std::string::npos ? std::string::npos : e - start));
        if (e == std::string::npos) {
            break;
        }
        start = e + 1;
    }
    out[a] = {base, args};
    for (const std::string& arg : args) {
        collectTypeArgString(arg, generics, out);
    }
}
void collectType(const ast::TypeRef& t, const std::set<std::string>& generics, InstMap& out) {
    if (!t.typeArgs.empty() && generics.count(t.name) > 0) {
        out[ast::mangleGeneric(t.name, t.typeArgs)] = {t.name, t.typeArgs};
    }
    for (const std::string& a : t.typeArgs) {
        collectTypeArgString(a, generics, out);
    }
}
void collectExpr(const ast::Expr* e, const std::set<std::string>& g, InstMap& out);
void collectStmt(const ast::Stmt* st, const std::set<std::string>& g, InstMap& out);
void collectBlock(const ast::Block& b, const std::set<std::string>& g, InstMap& out) {
    for (const auto& st : b.statements) {
        collectStmt(st.get(), g, out);
    }
}
void collectExpr(const ast::Expr* e, const std::set<std::string>& g, InstMap& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) {
        if (!x->typeArgs.empty() && g.count(x->className) > 0) {
            out[ast::mangleGeneric(x->className, x->typeArgs)] = {x->className, x->typeArgs};
        }
        for (const auto& a : x->args) {
            collectExpr(a.get(), g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) { collectExpr(x->object.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        // Reflection t.methods()/t.fields() return ArrayList<Method>/ArrayList<Field>; force their
        // monomorphization here since the user never names the type (spec 31).
        if (const auto* m = dynamic_cast<const ast::MemberExpr*>(x->callee.get()); m != nullptr &&
            g.count("ArrayList") > 0) {
            if (m->member == "methods") {
                out["ArrayList$Method"] = {"ArrayList", {"Method"}};
            } else if (m->member == "fields") {
                out["ArrayList$Field"] = {"ArrayList", {"Field"}};
            } else if (m->member == "annotations") {
                out["ArrayList$Annotation"] = {"ArrayList", {"Annotation"}};
            }
        }
        // EnumName.parse(s) returns Option<Enum> (spec 12.5); force Some/None/Option for the enum.
        if (const auto* m = dynamic_cast<const ast::MemberExpr*>(x->callee.get());
            m != nullptr && m->member == "parse" && g.count("Option") > 0) {
            if (const auto* eid = dynamic_cast<const ast::IdentifierExpr*>(m->object.get());
                eid != nullptr && g_enumNames.count(eid->name) > 0) {
                out["Option$" + eid->name] = {"Option", {eid->name}};
                out["Some$" + eid->name] = {"Some", {eid->name}};
                out["None$" + eid->name] = {"None", {eid->name}};
            }
        }
        collectExpr(x->callee.get(), g, out);
        for (const auto& a : x->args) {
            collectExpr(a.get(), g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) { collectExpr(x->lhs.get(), g, out); collectExpr(x->rhs.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) { collectExpr(x->cond.get(), g, out); collectExpr(x->thenExpr.get(), g, out); collectExpr(x->elseExpr.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) { collectExpr(x->array.get(), g, out); collectExpr(x->index.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ExtractExpr*>(e)) { collectExpr(x->target.get(), g, out); return; }
    if (dynamic_cast<const ast::MarkExpr*>(e) != nullptr ||
        dynamic_cast<const ast::RegionSpaceExpr*>(e) != nullptr) {
        return;  // no sub-expressions
    }
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) {
        for (const auto& ex : x->exprs) {
            collectExpr(ex.get(), g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::TupleExpr*>(e)) {
        for (const auto& ex : x->elements) {
            collectExpr(ex.get(), g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectExpr(x->size.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) { collectExpr(x->size.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        collectExpr(x->subject.get(), g, out);
        for (const auto& c : x->cases) {
            collectExpr(c.result.get(), g, out);
        }
        collectExpr(x->defaultResult.get(), g, out);
        return;
    }
}
void collectStmt(const ast::Stmt* st, const std::set<std::string>& g, InstMap& out) {
    if (st == nullptr) {
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) { collectExpr(x->expr.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DemandStmt*>(st)) { collectExpr(x->condition.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) { collectStmt(x->stmt.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) { collectType(x->elemType, g, out); collectExpr(x->iterable.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) {
        collectExpr(x->subject.get(), g, out);
        for (const auto& c : x->cases) {
            collectExpr(c.value.get(), g, out);
            collectBlock(c.body, g, out);
        }
        if (x->defaultBody) {
            collectBlock(*x->defaultBody, g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) {
        collectExpr(x->subject.get(), g, out);
        for (const auto& c : x->cases) {
            collectBlock(c.body, g, out);
        }
        if (x->defaultBody) {
            collectBlock(*x->defaultBody, g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) { collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) {
        collectBlock(x->body, g, out);
        for (const auto& c : x->catches) {
            collectType(c.type, g, out);
            collectBlock(c.body, g, out);
        }
        if (x->finallyBlock) {
            collectBlock(*x->finallyBlock, g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) { collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) { collectType(x->type, g, out); collectExpr(x->init.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TupleDeclStmt*>(st)) {
        for (const auto& b : x->bindings) {
            collectType(b.type, g, out);
        }
        collectExpr(x->init.get(), g, out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) { collectExpr(x->target.get(), g, out); collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) { collectExpr(x->within.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) { collectStmt(x->decl.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) {
        collectExpr(x->cond.get(), g, out);
        collectBlock(x->thenBlock, g, out);
        if (x->elseBlock) {
            collectBlock(*x->elseBlock, g, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) { collectExpr(x->cond.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) { collectBlock(x->body, g, out); collectExpr(x->cond.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) { collectStmt(x->init.get(), g, out); collectExpr(x->cond.get(), g, out); collectStmt(x->update.get(), g, out); collectBlock(x->body, g, out); return; }
}
void collectClass(const ast::ClassDecl& c, const std::set<std::string>& g, InstMap& out) {
    for (const auto& m : c.members) {
        if (const auto* x = dynamic_cast<const ast::MethodDecl*>(m.get())) {
            for (const auto& p : x->params) {
                collectType(p.type, g, out);
            }
            collectType(x->returnType, g, out);
            collectBlock(x->body, g, out);
        } else if (const auto* x = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            collectType(x->type, g, out);
            collectExpr(x->init.get(), g, out);
        } else if (const auto* x = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
            for (const auto& p : x->params) {
                collectType(p.type, g, out);
            }
            collectBlock(x->body, g, out);
        } else if (const auto* x = dynamic_cast<const ast::DestructorDecl*>(m.get())) {
            collectBlock(x->body, g, out);
        }
    }
    // A generic interface used in `implements Iface<Args>` is an instantiation too.
    for (std::size_t k = 0; k < c.interfaceTypeArgs.size() && k < c.interfaces.size(); ++k) {
        const auto& args = c.interfaceTypeArgs[k];
        if (!args.empty() && g.count(c.interfaces[k]) > 0) {
            out[ast::mangleGeneric(c.interfaces[k], args)] = {c.interfaces[k], args};
        }
    }
    // A generic superclass in `extends Base<Args>` is an instantiation too (`class X extends Seq<int>`
    // needs Seq$int generated, else the codegen mangles the base to Seq$int and finds it missing).
    if (!c.superclassTypeArgs.empty() && g.count(c.superclass) > 0) {
        out[ast::mangleGeneric(c.superclass, c.superclassTypeArgs)] = {c.superclass, c.superclassTypeArgs};
    }
}

// ---- Generic methods (spec 15) ----
// A generic method `m<T>(...)` is monomorphized like a generic class: one
// concrete method per (name, type-args) call site. Because monomorphize runs
// before sema, a call `obj.m<int>()` can't be resolved to a receiver class by
// type; so every class that declares a generic method named `m` gets a concrete
// `m$int`, and the calls are rewritten to the mangled member. Sema/codegen then
// see ordinary calls.

using MethInst = std::pair<std::string, std::vector<std::string>>;  // (name, args)
using MethInsts = std::set<MethInst>;

// Collects every generic call's (name, type-args) from an expression tree.
// Const: it observes only; the rewrite to the mangled member is a later pass.
void collectMethExpr(const ast::Expr* e, MethInsts& out);
void collectMethStmt(const ast::Stmt* st, MethInsts& out);
void collectMethBlock(const ast::Block& b, MethInsts& out) {
    for (const auto& st : b.statements) {
        collectMethStmt(st.get(), out);
    }
}
void collectMethExpr(const ast::Expr* e, MethInsts& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        if (!x->typeArgs.empty()) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(x->callee.get())) {
                out.insert({mem->member, x->typeArgs});
            }
        }
        collectMethExpr(x->callee.get(), out);
        for (const auto& a : x->args) {
            collectMethExpr(a.get(), out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) { collectMethExpr(x->object.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) { collectMethExpr(x->lhs.get(), out); collectMethExpr(x->rhs.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) { collectMethExpr(x->cond.get(), out); collectMethExpr(x->thenExpr.get(), out); collectMethExpr(x->elseExpr.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) { collectMethExpr(x->array.get(), out); collectMethExpr(x->index.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::ExtractExpr*>(e)) { collectMethExpr(x->target.get(), out); return; }
    if (dynamic_cast<const ast::MarkExpr*>(e) != nullptr ||
        dynamic_cast<const ast::RegionSpaceExpr*>(e) != nullptr) {
        return;  // no sub-expressions
    }
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) {
        for (const auto& a : x->args) {
            collectMethExpr(a.get(), out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectMethExpr(x->size.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) { collectMethExpr(x->size.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) {
        for (const auto& ex : x->exprs) {
            collectMethExpr(ex.get(), out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        collectMethExpr(x->subject.get(), out);
        for (const auto& c : x->cases) {
            collectMethExpr(c.result.get(), out);
        }
        collectMethExpr(x->defaultResult.get(), out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::LambdaExpr*>(e)) { collectMethBlock(x->body, out); return; }
}
void collectMethStmt(const ast::Stmt* st, MethInsts& out) {
    if (st == nullptr) {
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) { collectMethExpr(x->expr.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::DemandStmt*>(st)) { collectMethExpr(x->condition.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) { collectMethStmt(x->stmt.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) { collectMethExpr(x->iterable.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) {
        collectMethExpr(x->subject.get(), out);
        for (const auto& c : x->cases) {
            collectMethExpr(c.value.get(), out);
            collectMethBlock(c.body, out);
        }
        if (x->defaultBody) {
            collectMethBlock(*x->defaultBody, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) {
        collectMethExpr(x->subject.get(), out);
        for (const auto& c : x->cases) {
            collectMethBlock(c.body, out);
        }
        if (x->defaultBody) {
            collectMethBlock(*x->defaultBody, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) { collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) {
        collectMethBlock(x->body, out);
        for (const auto& c : x->catches) {
            collectMethBlock(c.body, out);
        }
        if (x->finallyBlock) {
            collectMethBlock(*x->finallyBlock, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) { collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) { collectMethExpr(x->target.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) { collectMethExpr(x->init.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TupleDeclStmt*>(st)) { collectMethExpr(x->init.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) { collectMethExpr(x->target.get(), out); collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) { collectMethExpr(x->target.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) { collectMethExpr(x->within.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) { collectMethStmt(x->decl.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) {
        collectMethExpr(x->cond.get(), out);
        collectMethBlock(x->thenBlock, out);
        if (x->elseBlock) {
            collectMethBlock(*x->elseBlock, out);
        }
        return;
    }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) { collectMethExpr(x->cond.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) { collectMethBlock(x->body, out); collectMethExpr(x->cond.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) { collectMethStmt(x->init.get(), out); collectMethExpr(x->cond.get(), out); collectMethStmt(x->update.get(), out); collectMethBlock(x->body, out); return; }
}

// Rewrites every generic call `obj.m<args>(...)` to the mangled member
// `obj.m$args(...)` with empty type-args, so sema/codegen see an ordinary call.
void rewriteMethExpr(ast::Expr* e);
void rewriteMethStmt(ast::Stmt* st);
void rewriteMethBlock(ast::Block& b) {
    for (auto& st : b.statements) {
        rewriteMethStmt(st.get());
    }
}
// Names of generic methods actually declared in the program; only calls to these get mangled.
// Without this, a builtin like `Memory.read<int8>(...)` (type args, but not a user generic method)
// would be wrongly rewritten to `Memory.read$int8` and lose its builtin meaning.
static const std::set<std::string>* g_genericMethodNames = nullptr;

// The last segment of a dotted receiver: `Raw` for both `Raw.read<int>` and
// `System.Memory.Raw.read<int>`. Empty when the receiver is not a plain name chain.
std::string receiverClassName(const ast::Expr* obj) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(obj)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(obj)) {
        return mem->member;
    }
    return {};
}

// Is the receiver a BUILTIN static class -- one whose methods are compiler intrinsics rather than
// user code? Their type arguments say what to load or store (`Raw.read<int>`), not which template to
// instantiate, so they must survive this pass untouched.
//
// Matching only the METHOD NAME is not enough, and that was a real defect: the moment any class in
// the program declared a generic `read<T>`, every `Raw.read<int>` in every file was rewritten to
// `Raw.read$int`, which is no builtin at all -- so the receiver stopped resolving and the error came
// out as "use of undeclared variable 'Raw'", pointing at innocent code in another file.
//
// The list is ast::builtinStaticClasses(), shared with the analyzer's registration: a second copy
// here would rot the first time a builtin was added to only one of them, which is the same shape of
// mistake as the one above.
bool isBuiltinStaticReceiver(const ast::Expr* obj) {
    return ast::isBuiltinStaticClassName(receiverClassName(obj));
}

void rewriteMethExpr(ast::Expr* e) {
    if (e == nullptr) {
        return;
    }
    if (auto* x = dynamic_cast<ast::CallExpr*>(e)) {
        if (!x->typeArgs.empty()) {
            if (auto* mem = dynamic_cast<ast::MemberExpr*>(x->callee.get())) {
                if (!isBuiltinStaticReceiver(mem->object.get()) &&
                    (g_genericMethodNames == nullptr ||
                     g_genericMethodNames->count(mem->member) > 0)) {
                    mem->member = ast::mangleGeneric(mem->member, x->typeArgs);
                    x->typeArgs.clear();
                }
            }
        }
        rewriteMethExpr(x->callee.get());
        for (auto& a : x->args) {
            rewriteMethExpr(a.get());
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::MemberExpr*>(e)) { rewriteMethExpr(x->object.get()); return; }
    if (auto* x = dynamic_cast<ast::BinaryExpr*>(e)) { rewriteMethExpr(x->lhs.get()); rewriteMethExpr(x->rhs.get()); return; }
    if (auto* x = dynamic_cast<ast::TernaryExpr*>(e)) { rewriteMethExpr(x->cond.get()); rewriteMethExpr(x->thenExpr.get()); rewriteMethExpr(x->elseExpr.get()); return; }
    if (auto* x = dynamic_cast<ast::UnaryExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::IndexExpr*>(e)) { rewriteMethExpr(x->array.get()); rewriteMethExpr(x->index.get()); return; }
    if (auto* x = dynamic_cast<ast::MoveExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::ExtractExpr*>(e)) { rewriteMethExpr(x->target.get()); return; }
    if (dynamic_cast<ast::MarkExpr*>(e) != nullptr ||
        dynamic_cast<ast::RegionSpaceExpr*>(e) != nullptr) {
        return;  // no sub-expressions
    }
    if (auto* x = dynamic_cast<ast::TryExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::CastExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::NewExpr*>(e)) {
        for (auto& a : x->args) {
            rewriteMethExpr(a.get());
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::NewArrayExpr*>(e)) { rewriteMethExpr(x->size.get()); return; }
    if (auto* x = dynamic_cast<ast::RegionInitExpr*>(e)) { rewriteMethExpr(x->size.get()); return; }
    if (auto* x = dynamic_cast<ast::InterpStringExpr*>(e)) {
        for (auto& ex : x->exprs) {
            rewriteMethExpr(ex.get());
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::MatchExpr*>(e)) {
        rewriteMethExpr(x->subject.get());
        for (auto& c : x->cases) {
            rewriteMethExpr(c.result.get());
        }
        rewriteMethExpr(x->defaultResult.get());
        return;
    }
    if (auto* x = dynamic_cast<ast::LambdaExpr*>(e)) { rewriteMethBlock(x->body); return; }
}
void rewriteMethStmt(ast::Stmt* st) {
    if (st == nullptr) {
        return;
    }
    if (auto* x = dynamic_cast<ast::ExprStmt*>(st)) { rewriteMethExpr(x->expr.get()); return; }
    if (auto* x = dynamic_cast<ast::DemandStmt*>(st)) { rewriteMethExpr(x->condition.get()); return; }
    if (auto* x = dynamic_cast<ast::LabeledStmt*>(st)) { rewriteMethStmt(x->stmt.get()); return; }
    if (auto* x = dynamic_cast<ast::ForeachStmt*>(st)) { rewriteMethExpr(x->iterable.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::SwitchStmt*>(st)) {
        rewriteMethExpr(x->subject.get());
        for (auto& c : x->cases) {
            rewriteMethExpr(c.value.get());
            rewriteMethBlock(c.body);
        }
        if (x->defaultBody) {
            rewriteMethBlock(*x->defaultBody);
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::MatchStmt*>(st)) {
        rewriteMethExpr(x->subject.get());
        for (auto& c : x->cases) {
            rewriteMethBlock(c.body);
        }
        if (x->defaultBody) {
            rewriteMethBlock(*x->defaultBody);
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::ThrowStmt*>(st)) { rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::TryStmt*>(st)) {
        rewriteMethBlock(x->body);
        for (auto& c : x->catches) {
            rewriteMethBlock(c.body);
        }
        if (x->finallyBlock) {
            rewriteMethBlock(*x->finallyBlock);
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::ReturnStmt*>(st)) { rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::DeleteStmt*>(st)) { rewriteMethExpr(x->target.get()); return; }
    if (auto* x = dynamic_cast<ast::VarDeclStmt*>(st)) { rewriteMethExpr(x->init.get()); return; }
    if (auto* x = dynamic_cast<ast::TupleDeclStmt*>(st)) { rewriteMethExpr(x->init.get()); return; }
    if (auto* x = dynamic_cast<ast::AssignStmt*>(st)) { rewriteMethExpr(x->target.get()); rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::IncDecStmt*>(st)) { rewriteMethExpr(x->target.get()); return; }
    if (auto* x = dynamic_cast<ast::DeferStmt*>(st)) { rewriteMethExpr(x->within.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::UsingStmt*>(st)) { rewriteMethStmt(x->decl.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::IfStmt*>(st)) {
        rewriteMethExpr(x->cond.get());
        rewriteMethBlock(x->thenBlock);
        if (x->elseBlock) {
            rewriteMethBlock(*x->elseBlock);
        }
        return;
    }
    if (auto* x = dynamic_cast<ast::WhileStmt*>(st)) { rewriteMethExpr(x->cond.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::DoWhileStmt*>(st)) { rewriteMethBlock(x->body); rewriteMethExpr(x->cond.get()); return; }
    if (auto* x = dynamic_cast<ast::ForStmt*>(st)) { rewriteMethStmt(x->init.get()); rewriteMethExpr(x->cond.get()); rewriteMethStmt(x->update.get()); rewriteMethBlock(x->body); return; }
}

// Expands generic methods program-wide. Materializes one concrete method per
// (name, type-args) call site on every class declaring a matching generic
// template, drops the templates, then rewrites every generic call to the mangled
// member. Cloning substitutes the type params, so a concrete body's own generic
// call `inner<T>` becomes `inner<int>`; a worklist collects those transitively.
bool isSubtypeOf(const std::string& sub, const std::string& base,
                 const std::map<std::string, const ast::ClassDecl*>& idx);
// spec 15.2: a constraint's own type arguments count (see their definitions below).
bool satisfiesBound(const std::string& sub, const std::string& bound,
                    const std::map<std::string, const ast::ClassDecl*>& idx, int depth = 0);
bool satisfiesTypeBound(const std::string& sub, const std::string& bound, bool applies,
                        const std::map<std::string, const ast::ClassDecl*>& idx);
std::string substBound(const std::string& bound, const std::vector<std::string>& typeParams,
                       const std::vector<std::string>& args);
std::string spellBound(const std::string& bound);

bool expandGenericMethods(ast::Program& program) {
    bool ok = true;
    // The class hierarchy, for checking generic-method constraints (spec 15.2).
    std::map<std::string, const ast::ClassDecl*> classIndex;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                classIndex[c.name] = &c;
            }
        }
    }
    // Any generic method templates at all? If not, there is nothing to do.
    bool anyTemplate = false;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        if (!meth->typeParams.empty()) {
                            anyTemplate = true;
                        }
                    }
                }
            }
        }
    }
    if (!anyTemplate) {
        return ok;
    }
    // A GENERIC METHOD CALLING ANOTHER WITH ITS OWN PARAMETER is not an instantiation.
    //
    // `text<T>` calling `of<T>(value)` reads, to the collector below, as a call to `of` with the type
    // argument `T` -- so it materialized a method `of$T` whose substitution maps T to T, i.e. a copy
    // of the template with the template's own parameter still in it and no `typeParams` left to say
    // so. Everything downstream then treats `T` as a type that ought to exist: `reflect.typeOf<T>`
    // reports it is not a class, a `T` parameter does not convert to Object, and the errors point
    // into the standard library at a line whose author did nothing wrong.
    //
    // The generic-CLASS collector has guarded against exactly this since the `Node<T>* next` case
    // (see typeParamNames further down); generic METHODS never got the same guard, and the shape
    // that exposes it -- one generic method delegating to another -- is common enough that the
    // standard library hit it the first time it wrote one.
    //
    // Narrower than the class-level guard on purpose: a name is only ignored if it is a type
    // parameter somewhere AND is not a real class, so a program that legitimately names a class `T`
    // still instantiates over it.
    std::set<std::string> methodTypeParamNames;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (const auto& tp : c.typeParams) {
                    methodTypeParamNames.insert(tp);
                }
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        for (const auto& tp : meth->typeParams) {
                            methodTypeParamNames.insert(tp);
                        }
                    }
                }
            }
        }
    }
    auto isPseudoArg = [&](const std::string& a) {
        return methodTypeParamNames.count(a) > 0 && classIndex.count(a) == 0;
    };

    // 1. Collect (name, args) from every existing method body (templates included).
    MethInsts insts;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        collectMethBlock(meth->body, insts);
                    }
                }
            }
        }
    }

    // 2. Generate concrete methods on each class, to a fixpoint (a generated body
    //    may itself contain a newly-discovered generic call).
    std::set<std::string> done;  // per-class "name$args" already generated; key includes class name
    bool changed = true;
    while (changed) {
        changed = false;
        for (auto& b : program.bundles) {
            for (auto& ns : b.namespaces) {
                for (auto& c : ns.classes) {
                    std::vector<ast::MemberPtr> generated;
                    for (auto& m : c.members) {
                        auto* meth = dynamic_cast<ast::MethodDecl*>(m.get());
                        if (meth == nullptr || meth->typeParams.empty()) {
                            continue;  // template
                        }
                        for (const MethInst& inst : insts) {
                            if (inst.first != meth->name || inst.second.size() != meth->typeParams.size()) {
                                continue;
                            }
                            bool pseudo = false;
                            for (const std::string& a : inst.second) {
                                if (isPseudoArg(a)) {
                                    pseudo = true;
                                }
                            }
                            if (pseudo) {
                                continue;  // a template naming its own parameter; see isPseudoArg
                            }
                            const std::string mangled =
                                ast::mangleGeneric(meth->name, inst.second);
                            const std::string key = c.name + "::" + mangled;
                            if (done.count(key) > 0) {
                                continue;
                            }
                            done.insert(key);
                            // Constraints on a generic METHOD (spec 15.2): every type argument must
                            // satisfy its bound, exactly as for a generic class.
                            for (const auto& pb : meth->typeParamBounds) {
                                std::size_t pi = 0;
                                while (pi < meth->typeParams.size() && meth->typeParams[pi] != pb.param) {
                                    ++pi;
                                }
                                if (pi >= inst.second.size()) {
                                    continue;
                                }
                                const std::string bound =
                                    substBound(pb.bound, meth->typeParams, inst.second);
                                if (!satisfiesTypeBound(inst.second[pi], bound, pb.applies,
                                                        classIndex)) {
                                    monoError(meth->loc,
                                              "type argument '" + inst.second[pi] +
                                                  "' does not satisfy constraint '" + pb.param +
                                                  (pb.applies ? " applies " : " extends ") +
                                                  spellBound(bound) + "' of method '" + meth->name +
                                                  "'");
                                    ok = false;
                                }
                            }
                            Subst s;
                            for (std::size_t i = 0; i < inst.second.size(); ++i) {
                                s[meth->typeParams[i]] = inst.second[i];
                            }
                            ast::MemberPtr cm = cloneMember(meth, s);
                            auto* cmeth = static_cast<ast::MethodDecl*>(cm.get());
                            cmeth->name = mangled;
                            cmeth->typeParams.clear();
                            collectMethBlock(cmeth->body, insts);  // transitive calls
                            generated.push_back(std::move(cm));
                            changed = true;
                        }
                    }
                    for (auto& g : generated) {
                        c.members.push_back(std::move(g));
                    }
                }
            }
        }
    }

    // 3. Drop the templates and rewrite all generic calls to the mangled member. Collect the
    //    declared generic method names first (templates still present) so the rewrite only mangles
    //    those -- not builtins that merely carry type args (e.g. Memory.read<int8>).
    std::set<std::string> genNames;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        if (!meth->typeParams.empty()) {
                            genNames.insert(meth->name);
                        }
                    }
                }
            }
        }
    }
    // A transformer's generic socket -- `procedure into<Other>() returns Other` -- names a FAMILY of
    // procedures indexed by the target type, and the applying type supplies one member per target it
    // can reach (`procedure into<Fahrenheit>`, parsed as `into$Fahrenheit`). The call site is an
    // ordinary generic call, `c.into<Fahrenheit>()`, so it needs the family name registered here or
    // the rewrite below leaves it as `into` and nothing resolves. Transformers are not in
    // `ns.classes`, which is exactly why this second loop is needed and not a duplicate.
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& t : ns.transformers) {
                for (auto& m : t.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        if (!meth->typeParams.empty()) {
                            genNames.insert(meth->name);
                            // ...and the LAW that family carries, which the expansion pass turns
                            // into a `<name>Law$<Target>` member on each applying type. It is called
                            // the same way its family is -- `c.intoLaw<Fahrenheit>()` -- so it needs
                            // registering here for the same reason, and its absence looked exactly
                            // like a method nobody wrote.
                            if (meth->law != nullptr) {
                                genNames.insert(meth->name + "Law");
                            }
                        }
                    }
                }
            }
        }
    }
    g_genericMethodNames = &genNames;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                std::vector<ast::MemberPtr> kept;
                for (auto& m : c.members) {
                    auto* meth = dynamic_cast<ast::MethodDecl*>(m.get());
                    if (meth != nullptr && !meth->typeParams.empty()) {
                        continue;  // template
                    }
                    kept.push_back(std::move(m));
                }
                c.members = std::move(kept);
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        rewriteMethBlock(meth->body);
                    }
                }
            }
        }
    }
    g_genericMethodNames = nullptr;
    return ok;
}

// Subtype check over the class hierarchy (AST-level), for constraint validation.
bool isSubtypeOf(const std::string& sub, const std::string& base,
                 const std::map<std::string, const ast::ClassDecl*>& idx) {
    if (sub == base) {
        return true;
    }
    auto it = idx.find(sub);
    if (it == idx.end()) {
        return false;
    }
    if (!it->second->superclass.empty() && isSubtypeOf(it->second->superclass, base, idx)) {
        return true;
    }
    for (const auto& i : it->second->interfaces) {
        if (isSubtypeOf(i, base, idx)) {
            return true;
        }
    }
    return false;
}

// Does `sub` satisfy the constraint `bound` (spec 15.2), where the bound is in canonical mangled form
// with its type parameters already substituted ("Comparable$Dog")? A bound WITH arguments demands
// exactly those arguments: implementing Comparable<Cat> does not satisfy Comparable<Dog>. A bound
// without arguments is the plain name check.
bool satisfiesBound(const std::string& sub, const std::string& bound,
                    const std::map<std::string, const ast::ClassDecl*>& idx, int depth) {
    const std::size_t sep = bound.find('$');
    if (sep == std::string::npos) {
        return isSubtypeOf(sub, bound, idx);
    }
    if (depth > 16) {
        return false;  // a malformed (cyclic) type graph must not overflow
    }
    const std::string bbase = bound.substr(0, sep);
    std::vector<std::string> bargs;
    for (std::size_t start = sep + 1; start <= bound.size();) {
        const std::size_t next = bound.find('$', start);
        bargs.push_back(
            bound.substr(start, next == std::string::npos ? std::string::npos : next - start));
        if (next == std::string::npos) {
            break;
        }
        start = next + 1;
    }
    auto it = idx.find(sub);
    if (it == idx.end()) {
        return false;
    }
    const ast::ClassDecl& c = *it->second;
    for (std::size_t k = 0; k < c.interfaces.size(); ++k) {
        const std::vector<std::string> iargs =
            k < c.interfaceTypeArgs.size() ? c.interfaceTypeArgs[k] : std::vector<std::string>{};
        if (c.interfaces[k] == bbase && iargs == bargs) {
            return true;
        }
        if (satisfiesBound(c.interfaces[k], bound, idx, depth + 1)) {
            return true;
        }
    }
    if (!c.superclass.empty()) {
        if (c.superclass == bbase && c.superclassTypeArgs == bargs) {
            return true;
        }
        if (satisfiesBound(c.superclass, bound, idx, depth + 1)) {
            return true;
        }
    }
    return false;
}

// A constraint of either kind, against one concrete type argument.
//
// `extends`/`implements` ask about the type GRAPH and answer by walking it. `applies` asks a
// different question and must not be answered by walking anything: a transformer is not a supertype
// and confers no subtyping, so the only truthful test is whether this type NAMED it -- transitively
// through `transformer A applies B`, which is precisely the closure the expansion pass already
// worked out and left behind on the declaration.
//
// NOMINAL, DECIDED 2026-08-16. The structural reading -- *it has the procedures, however it came by
// them* -- was refused for the reason the `each` marker was: a relation satisfied by accident is
// satisfied silently, and a declaration in another file then decides what this one means.
bool satisfiesTypeBound(const std::string& sub, const std::string& bound, bool applies,
                        const std::map<std::string, const ast::ClassDecl*>& idx) {
    if (!applies) {
        return satisfiesBound(sub, bound, idx);
    }
    auto it = idx.find(sub);
    if (it == idx.end()) {
        return false;   // a primitive, or a type nothing declared: it applies nothing
    }
    for (const std::string& t : it->second->appliedClosure) {
        if (t == bound) {
            return true;
        }
    }
    return false;
}

// The constraint with the generic's type parameters substituted: `Comparable$T` with T=Dog becomes
// `Comparable$Dog`. A bound with no arguments passes through unchanged.
std::string substBound(const std::string& bound, const std::vector<std::string>& typeParams,
                       const std::vector<std::string>& args) {
    const std::size_t sep = bound.find('$');
    if (sep == std::string::npos) {
        return bound;
    }
    const std::string base = bound.substr(0, sep);
    std::vector<std::string> parts;
    for (std::size_t start = sep + 1; start <= bound.size();) {
        const std::size_t next = bound.find('$', start);
        parts.push_back(
            bound.substr(start, next == std::string::npos ? std::string::npos : next - start));
        if (next == std::string::npos) {
            break;
        }
        start = next + 1;
    }
    for (std::string& part : parts) {
        for (std::size_t i = 0; i < typeParams.size() && i < args.size(); ++i) {
            if (part == typeParams[i]) {
                part = args[i];
            }
        }
    }
    return ast::mangleGeneric(base, parts);
}

// A mangled bound spelled back for a diagnostic: "Comparable$Dog" -> "Comparable<Dog>".
std::string spellBound(const std::string& bound) {
    const std::size_t sep = bound.find('$');
    if (sep == std::string::npos) {
        return bound;
    }
    std::string out = bound.substr(0, sep) + "<";
    for (std::size_t start = sep + 1, n = 0; start <= bound.size(); ++n) {
        const std::size_t next = bound.find('$', start);
        if (n) {
            out += ", ";
        }
        out += bound.substr(start, next == std::string::npos ? std::string::npos : next - start);
        if (next == std::string::npos) {
            break;
        }
        start = next + 1;
    }
    return out + ">";
}

}  // namespace

// Public deep-clone entry points (no type substitution), for AST-level passes outside this file.
// One copy of a structural body, for one field. The substitution rides the ordinary clone: setting
// three names for the duration is all that separates it from any other deep copy, which is why a
// structural procedure costs nothing at run time for the same reason a generic does not.
ast::Block cloneBlockForField(const ast::Block& b, const std::string& var, const std::string& name,
                              const std::string& typeName) {
    g_fieldVar = var;
    g_fieldName = name;
    g_fieldType = typeName;
    ast::Block out = cloneBlock(b, Subst{});
    g_fieldVar.clear();
    g_fieldName.clear();
    g_fieldType.clear();
    return out;
}

ast::ExprPtr cloneExprDeep(const ast::Expr* e) { return cloneExpr(e, Subst{}); }
ast::StmtPtr cloneStmtDeep(const ast::Stmt* s) { return cloneStmt(s, Subst{}); }

// Expands every `typealias` (spec 24) to its target type, transparently, everywhere a type
// appears -- so the analyzer and codegen only ever see concrete types. `newtype`s are left alone
// (they are distinct nominal types handled by the analyzer). Runs before qualifyNamespaces and
// monomorphize so the substituted targets are qualified and instantiated like any other type.
void resolveTypeAliases(ast::Program& program) {
    g_aliases.clear();
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& a : ns.typeAliases) {
                if (!a.isNewtype) {
                    g_aliases[a.name] = a.target;
                }
            }
        }
    }
    if (g_aliases.empty()) {
        return;
    }

    // Resolve alias chains (typealias A = B; typealias B = int) and aliases nested in type args,
    // up to a bounded number of passes (a cycle just stops changing).
    for (int iter = 0; iter < 16; ++iter) {
        bool changed = false;
        for (auto& [name, tgt] : g_aliases) {
            if (auto it = g_aliases.find(tgt.name); it != g_aliases.end() && it->first != name) {
                const ast::TypeRef inner = it->second;
                const bool arr = tgt.isArray, ptr = tgt.isPointer, ref = tgt.isRef,
                           nul = tgt.isNullable;
                const int dims = tgt.arrayDims;
                tgt = inner;
                tgt.isArray = tgt.isArray || arr;
                tgt.arrayDims += dims;
                tgt.isPointer = tgt.isPointer || ptr;
                tgt.isRef = tgt.isRef || ref;
                tgt.isNullable = tgt.isNullable || nul;
                changed = true;
            }
            for (auto& arg : tgt.typeArgs) {
                const std::string r = resolveAliasName(arg);
                if (r != arg) { arg = r; changed = true; }
            }
        }
        if (!changed) {
            break;
        }
    }

    // Re-clone every class with an empty substitution: cloneClass runs substType over every
    // TypeRef it touches (fields, signatures, bodies), so aliases resolve everywhere for free.
    const Subst empty;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                ast::ClassDecl rewritten = cloneClass(c, empty, c.name);
                rewritten.typeParams = c.typeParams;  // cloneClass drops these; keep generics generic
                rewritten.typeParamVariance = c.typeParamVariance;
                rewritten.typeParamFixed = c.typeParamFixed;          // A.3: and WHEN each binds
                rewritten.typeParamValueType = c.typeParamValueType;  // ...and what kind it is
                // ...AND `isProcedure`, for the same reason and with the same shape.
                //
                // `cloneMember` drops that flag ON PURPOSE: the same copier is what injects a
                // transformer's `procedure` into the type that applies it, and in THAT copy the
                // procedure stops being a socket and becomes an ordinary method (the note there
                // explains what carrying it over broke). But this pass is a REWRITE, not an
                // injection -- what comes out must be what went in with the aliases expanded -- so
                // it has to put the flag back.
                //
                // It went unnoticed because a second bug hid it: `cloneClass` was also dropping
                // `applies`, so a program with a `typealias` in it lost its transformers entirely
                // and nothing was left to complain that the procedures had turned into methods.
                // Fixing that one made this one produce four errors in a file the author had not
                // touched. Matched by name rather than by index: a member kind `cloneMember` does
                // not handle is skipped (with a warning), and an index walk would then silently
                // hand the flag to the wrong method.
                for (std::size_t i = 0, j = 0; i < rewritten.members.size(); ++i) {
                    auto* to = dynamic_cast<ast::MethodDecl*>(rewritten.members[i].get());
                    if (to == nullptr) {
                        continue;
                    }
                    while (j < c.members.size()) {
                        const auto* from = dynamic_cast<const ast::MethodDecl*>(c.members[j].get());
                        ++j;
                        if (from != nullptr && from->name == to->name) {
                            to->isProcedure = from->isProcedure;
                            to->isLayoutResolver = from->isLayoutResolver;   // a body that is data
                            break;
                        }
                    }
                }
                rewritten.superclass = resolveAliasName(c.superclass);
                for (auto& iface : rewritten.interfaces) {
                    iface = resolveAliasName(iface);
                }
                for (auto& a : rewritten.superclassTypeArgs) {
                    a = resolveAliasName(a);
                }
                for (auto& argList : rewritten.interfaceTypeArgs) {
                    for (auto& a : argList) {
                        a = resolveAliasName(a);
                    }
                }
                c = std::move(rewritten);
            }
            for (auto& cst : ns.consts) {
                cst.type = substType(cst.type, empty);
            }
            for (auto& lit : ns.literals) {
                lit.param.type = substType(lit.param.type, empty);
                lit.returnType = substType(lit.returnType, empty);
            }
            for (auto& ex : ns.externs) {
                ex.returnType = substType(ex.returnType, empty);
                for (auto& p : ex.params) {
                    p.type = substType(p.type, empty);
                }
            }
        }
    }
    // IMPORTING A TRANSPARENT ALIAS IS IMPORTING ITS TARGET, and the import has to say so once the
    // alias is gone.
    //
    // Every use of `Bill` has just been rewritten to `Tally$Goods`, so by the time the analyzer runs
    // the name does not exist -- and `import Agents.World.Bill;` was reported as an import of an
    // unknown symbol, about a type declared in the file next to it. The alias is not a second type
    // to make visible; it is another spelling of one, so the import is rewritten to name what it
    // spells. The base name is enough: a generic's arguments are not part of what is imported.
    for (auto& b : program.bundles) {
        for (auto& imp : b.imports) {
            if (imp.path.empty()) {
                continue;
            }
            auto it = g_aliases.find(imp.path.back());
            if (it != g_aliases.end()) {
                imp.path.back() = it->second.name;
            }
        }
    }
    for (auto& imp : program.imports) {
        if (imp.path.empty()) {
            continue;
        }
        auto it = g_aliases.find(imp.path.back());
        if (it != g_aliases.end()) {
            imp.path.back() = it->second.name;
        }
    }
    g_aliases.clear();  // done: later passes must not see alias rewrites
}

// Disambiguates type names that are declared in more than one namespace so that
// `app.Foo` and `lib.Foo` become distinct types (spec: namespaces scope type
// names). Each colliding declaration -- and every reference to it, resolved per
// the referring namespace's own declarations and imports -- is rewritten to a
// unique internal name (e.g. "app__Foo"). When no name collides across
// namespaces (the common case) this is a no-op, so single-namespace programs are
// untouched. Runs before monomorphize, so generic mangling sees unique names too.
void qualifyNamespaces(ast::Program& program) {
    // 1. Index each simple type name to the set of namespaces declaring it.
    std::map<std::string, std::set<std::string>> declNs;
    // Where in the standard library each name is declared. The stdlib does not import itself -- its
    // namespaces refer to each other's types directly -- so without this it is the one body of code
    // in the program that cannot say which `Regex` it means.
    std::map<std::string, std::string> preludeOwner;
    // And the same index kept per bundle, so "does my own program declare this name, and where"
    // can be answered later. It has to be a SNAPSHOT: the rewriting loop below renames declarations
    // as it walks, so by the time it reaches the second namespace of a bundle the first one's class
    // is already called `World__Paths` and looking for `Paths` there finds nothing.
    std::map<std::string, std::map<std::string, std::set<std::string>>> bundleDecl;
    // Which of those names are GENERIC. A generic template is erased by monomorphization, and the
    // instance it produces is named from the BASE name alone -- `Stack<int>` is `Stack$int` whoever
    // declared it. So two templates of one name do not merely collide, they produce the same
    // instance: the monomorphizer indexes templates by name, keeps one, and every `Stack<int>` in the
    // program is built from that one. A user's own `Stack<T>` beside the library's failed as
    // `class 'Stack$int' has no method 'count'`, naming a method that is right there in the file.
    //
    // Nothing downstream can repair that, because by then there is one template and no record that
    // there were two. It is the one case where telling the types apart by path is not enough and the
    // rename is still the mechanism -- so generics are excluded from the exemption below.
    std::set<std::string> genericDecl;
    // The namespaces that live in an IMPORTED bundle. Their types are external symbols, named by the
    // build that produced the .polb -- see the refusal to rename them below.
    std::set<std::string> importedNs;
    for (auto& b : program.bundles) {
        if (!b.isImported) {
            continue;
        }
        for (auto& ns : b.namespaces) {
            importedNs.insert(ns.name);
            importedNs.insert(b.name + "." + ns.name);
        }
    }
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            auto note = [&](const std::string& n) {
                bundleDecl[b.name][n].insert(ns.name);
                declNs[n].insert(ns.name);
                if (b.isPrelude) {
                    preludeOwner[n] = ns.name;
                }
            };
            for (auto& c : ns.classes) {
                note(c.name);
                if (!c.typeParams.empty()) {
                    genericDecl.insert(c.name);
                }
            }
            for (auto& e : ns.enums) {
                note(e.name);
            }
            for (auto& cat : ns.catalogs) {
                note(cat.name);
            }
        }
    }
    // SAY SO WHEN YOU HAVE SHADOWED THE STANDARD LIBRARY.
    //
    // Not an error: your type wins, and that is the intended rule. But it is something you have to be
    // told, because everything downstream changes -- the whole namespace is rewritten, and an
    // unqualified use of that name now means yours rather than the library's, everywhere in the bundle.
    //
    // It was told to nobody. Declaring a class called `Utf8` in a kernel produced twenty-five errors in
    // files that had not been touched (`b"K:"` has type `String`; `class 'Process' has no static field
    // 'KernelStackPages'`) and not one of them named `Utf8`. The cascade had a second cause, since
    // fixed, but even with that gone the shadowing itself deserves one line at the place it happened.
    for (auto& b : program.bundles) {
        if (b.isPrelude || b.isImported) {
            continue;
        }
        for (auto& ns : b.namespaces) {
            auto shadows = [&](const std::string& n, const SourceLocation& where) {
                auto po = preludeOwner.find(n);
                if (po == preludeOwner.end()) {
                    return;
                }
                monoWarn(where, "'" + n + "' is also declared by the standard library, in '" +
                                    po->second + "'. Yours wins: from here an unqualified '" + n +
                                    "' means this one throughout the bundle, and the standard "
                                    "library's is reachable only by its full path. Rename yours if "
                                    "that was not the intention");
            };
            for (auto& c : ns.classes) {
                shadows(c.name, c.nameLoc);
            }
            for (auto& e : ns.enums) {
                shadows(e.name, e.loc);
            }
            for (auto& cat : ns.catalogs) {
                shadows(cat.name, cat.loc);
            }
        }
    }

    // QUALIFICATION IS STILL CONDITIONAL, AND THAT IS THE REMAINING DEBT.
    //
    // Running it on every type -- which is what gives a type real identity, and what would make every
    // one of the 799 tests exercise the rewrite instead of one program in a hundred -- was tried on
    // 2026-08-15 and is written up in docs/design/type-identity.md. It found three more gaps in two
    // iterations, which is exactly the argument for doing it:
    //
    //   - `Object` is attached implicitly, by the compiler, in a namespace that never imported it, so
    //     no substitution map contains it. It is exempt below for the same reason a primitive is.
    //   - The ENTRY POINT was found by comparing against the bare name "Main", so a qualified `Main`
    //     produced "this program has no entry point" to somebody looking straight at one. Fixed.
    //   - A GENERIC INSTANCE is named `Base$Arg` from the base as written, while the template's
    //     declaration is qualified -- so `Option$String` and `Errors__Option$String` are the same
    //     type under two names. That one is not fixed, and it is what stops the switch being flipped.
    //
    // The `Object` exemption stays because it is correct under either scheme.
    // A TYPE THE COMPILER NAMES BY ITSELF CANNOT BE RENAMED.
    //
    // The rule, and it is a rule rather than three exceptions: a substitution map is built from what a
    // namespace declares and what it imports, so it can only contain names somebody WROTE. Where the
    // compiler synthesises a reference -- an implicit `extends Object`, the `Option$T` behind
    // `Some(x)`, the `Result$T$E` behind `Ok(v)` -- the name appears in no source file, reaches no
    // substitution map, and is left pointing at a declaration that has just been renamed away.
    //
    // These are part of the LANGUAGE rather than of a library that happens to ship with it, which is
    // why they are exempt for the same reason a primitive is. Found by turning qualification on for
    // every type (docs/design/type-identity.md): `Object` failed first, then `Option`/`Result` as
    // `Option$String` against `Errors__Option$String` -- the same type under two names.
    // The list is not invented here: `ast::builtinStaticClasses()` already names the classes whose
    // METHODS the compiler recognises and lowers itself (`Bits.doubleToLong`, `File.readAll`,
    // `Raw.sizeof`), and it exists precisely so that the monomorphizer and the analyzer give the same
    // answer -- "Two copies of it already cost a day", says the comment beside it. Renaming one of
    // those classes leaves the builtin dispatch, which matches on the bare name, looking at a class
    // that no longer has that name.
    //
    // Three more join them, found by running qualification over everything: `Object`, which every
    // class extends implicitly; and `Option`/`Result`, whose instance names the compiler synthesises
    // for `Some(x)` and `Ok(v)` -- so `Option$String` met `Errors__Option$String`, the same type
    // under two names. `Channel` and `atomic` are here for the same reason as `Bits`: their methods
    // are builtins matched by the bare class name.
    auto languageIntrinsic = [](const std::string& n) {
        return ast::isBuiltinStaticClassName(n) || n == "Object" || n == "Option" || n == "Result" ||
               n == "Channel" || n == "atomic";
    };
    std::set<std::string> ambiguous;
    for (auto& [name, nss] : declNs) {
        if (languageIntrinsic(name)) {
            continue;
        }
        // STILL CONDITIONAL, AND THE NUMBER IS WHY. Turning this on for every type -- which is what
        // would give a type real identity and make all 799 tests exercise the rewrite instead of one
        // program in a hundred -- was measured on 2026-08-15: **341 of 799 tests fail**, segfaults
        // among them. A single-class `hello_world` compiled clean, which is exactly how a change of
        // this shape flatters itself.
        //
        // That number is the argument against finishing the rewrite and for replacing it: a pass that
        // is 43% incomplete is not one gap away from total. See docs/design/type-identity.md.
        // A NAME SHARED ONLY WITH THE STANDARD LIBRARY IS NOT RENAMED.
        //
        // That is THE collision -- a program declaring `Color`, `Regex`, `File`, `Scanner` -- and
        // rewriting the whole program to invent a difference is what made three separate holes in this
        // pass reachable by ordinary code. It is answered directly now, by the two halves that exist:
        // the analyzer picks by namespace and imports, codegen keeps each class's path.
        //
        // What unblocked it was the standard library importing itself. It never had one `import` line,
        // and an exemption let it through -- which made it the one body of code resolving names by a
        // different rule, and a different rule needs a special case, and a special case is a second
        // answer that has to agree with the first forever.
        //
        // Two of YOUR OWN namespaces sharing a name still comes through here: the qualified `ns.Type`
        // spelling has to keep resolving, and that is a real ambiguity inside one program.
        // A NAME SHARED ONLY WITH THE STANDARD LIBRARY IS NOT RENAMED.
        //
        // That is THE collision -- a program declaring `Color`, `Regex`, `File`, `Scanner` -- and
        // rewriting the whole program to invent a difference between the two is what made three
        // separate holes in this pass reachable by ordinary code. It is answered directly now: the
        // analyzer picks by namespace and imports, codegen keeps each class's path.
        //
        // Two things had to be true first, and neither was. The standard library had to IMPORT
        // ITSELF -- it had not one `import` line, resolving names by an exemption that made it the
        // only code in the program playing by a different rule. And every analyzer pass had to say
        // WHICH NAMESPACE IT IS IN: twenty of them walked namespaces and two recorded it, so
        // `lookupShared` asked "whose namespace is asking" and eighteen had never answered.
        //
        // Two of YOUR OWN namespaces sharing a name still comes through here: the qualified `ns.Type`
        // spelling has to keep resolving, and that is a real ambiguity inside one program.
        if (nss.size() == 2 && genericDecl.count(name) == 0) {
            auto po = preludeOwner.find(name);
            if (po != preludeOwner.end() && nss.count(po->second) > 0) {
                continue;
            }
        }
        if (nss.size() > 1) {
            ambiguous.insert(name);
        }
    }
    // Nothing collides and no explicit `ns.Type` reference was written: leave every
    // name as-is (the common single-namespace case stays a no-op).
    if (ambiguous.empty() && !program.hasQualifiedTypeRef) {
        return;
    }

    auto qualified = [](const std::string& ns, const std::string& simple) {
        std::string s = ns;
        for (char& c : s) {
            if (c == '.') {
                c = '_';
            }
        }
        return s + "__" + simple;
    };

    // Explicit `ns.Type` references resolve to that namespace's concrete type name
    // (its qualified form if the simple name collides, else the simple name itself).
    Subst dotted;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            auto add = [&](const std::string& name) {
                const std::string concrete = ambiguous.count(name) ? qualified(ns.name, name) : name;
                if (ambiguous.count(name)) {
                    program.qualifiedTypes.insert(concrete);  // scoped: import-exempt
                }
                dotted[ns.name + "." + name] = concrete;                        // namespace.Type
                dotted[b.name + "." + ns.name + "." + name] = concrete;         // Bundle.namespace.Type (spec 2.7 full path)
            };
            for (auto& c : ns.classes) {
                add(c.name);
            }
            for (auto& e : ns.enums) {
                add(e.name);
            }
            for (auto& cat : ns.catalogs) {
                add(cat.name);
            }
        }
    }

    for (auto& b : program.bundles) {
        // Imported symbols of this bundle: type name -> the namespace(s) it might come from. An import
        // may name the bundle first (`forge.app.Controller`), so record both the full prefix and the
        // prefix with its leading bundle segment stripped; the lookup below keeps whichever actually
        // declares the type.
        std::map<std::string, std::vector<std::string>> importNs;
        // BOTH LISTS: an import is written before `program` (spec 2.7) and lands in
        // `program.imports`; `b.imports` is the in-bundle form. Reading only the second meant the
        // author's own imports never reached this map -- so a program that imported `shapes.geo
        // .Square` and also declared a `Square` of its own had the reference rewritten to ITS one,
        // and `new Square(5)` failed as "constructor 'other__Square' expects at most 0 arguments"
        // against a class whose name the author never wrote.
        auto takeImport = [&](const ast::ImportDecl& imp) {
            if (imp.path.size() < 2) {
                return;
            }
            std::string nsPrefix;
            for (std::size_t i = 0; i + 1 < imp.path.size(); ++i) {
                nsPrefix += (i ? "." : "") + imp.path[i];
            }
            importNs[imp.path.back()].push_back(nsPrefix);
            if (imp.path.size() >= 3) {
                std::string afterBundle;
                for (std::size_t i = 1; i + 1 < imp.path.size(); ++i) {
                    afterBundle += (afterBundle.empty() ? "" : ".") + imp.path[i];
                }
                importNs[imp.path.back()].push_back(afterBundle);
            }
        };
        for (auto& imp : program.imports) {
            takeImport(imp);
        }
        for (auto& imp : b.imports) {
            takeImport(imp);
        }
        for (auto& ns : b.namespaces) {
            std::set<std::string> ownNames;
            for (auto& c : ns.classes) {
                ownNames.insert(c.name);
            }
            for (auto& e : ns.enums) {
                ownNames.insert(e.name);
            }
            for (auto& cat : ns.catalogs) {
                ownNames.insert(cat.name);
            }
            // For each ambiguous name visible here, map it to its owning namespace's
            // unique name. Own declarations win; otherwise an import decides.
            Subst subst;
            for (const std::string& amb : ambiguous) {
                std::string owner;
                if (ownNames.count(amb) > 0) {
                    owner = ns.name;
                } else if (auto it = importNs.find(amb); it != importNs.end()) {
                    for (const std::string& cand : it->second) {
                        if (declNs[amb].count(cand) > 0) { owner = cand; break; }
                    }
                }
                // A standard-library namespace means the standard library's type. The stdlib is one
                // body of code that never imports itself, so when a user class made a stdlib name
                // ambiguous, every OTHER stdlib namespace using that name resolved to nothing and
                // kept the bare name -- which had just been renamed out from under it. Declaring
                // `class Regex` in your own program produced four errors inside `<prelude>` saying
                // `Regex` was undeclared, and declaring `class File` produced four saying the
                // standard library should import YOUR type.
                // `b.isPrelude`, and NOT "a namespace with a prelude namespace's name". The
                // standard library has a namespace called `App` (CircuitBreaker and friends), and
                // `App` is the single most likely name for a namespace in somebody's own program --
                // so every ambiguous type referenced from a user's `App` was resolved to the
                // STANDARD LIBRARY'S, and the failure surfaced as an error about a mangled class
                // nobody had written. Any of IO, Math, Runtime, Errors, Collections, Concurrency or
                // Ecs would have done the same.
                if (owner.empty() && b.isPrelude) {
                    if (auto po = preludeOwner.find(amb); po != preludeOwner.end()) {
                        owner = po->second;
                    }
                }
                // And the mirror of it, which was missing: OUTSIDE the prelude, a bare name means
                // this program's own type before it means the standard library's. Without this, a
                // class named `Paths` in one namespace was invisible from the next namespace along
                // -- the reference kept the bare name, the declaration had been renamed out from
                // under it, and it landed on `System.IO.Paths`, reported as "class 'IO__Paths' has
                // no method 'one'" against a name the program never wrote. The stdlib requires an
                // explicit import to be visible at all, so it cannot be what an unqualified name
                // in your own bundle resolves to.
                //
                // Only when the bundle declares it in exactly one place: two namespaces of your own
                // declaring the same name is a genuine ambiguity, and that one still needs saying
                // which you meant.
                if (owner.empty() && !b.isPrelude) {
                    auto bd = bundleDecl.find(b.name);
                    if (bd != bundleDecl.end()) {
                        auto where = bd->second.find(amb);
                        if (where != bd->second.end() && where->second.size() == 1) {
                            owner = *where->second.begin();
                        }
                    }
                }
                // A TYPE FROM ANOTHER BUNDLE IS NOT OURS TO RENAME. Its symbols were fixed when the
                // library was compiled, by a build that knew nothing about the names this program
                // declares -- so rewriting `Square` to `geo__Square` here asks the linker for
                // `geo__Square.__new`, and the library exported `Square.__new`. The link fails, on a
                // symbol neither author wrote.
                //
                // Leaving it bare is what makes the two sides agree: the CONSUMER's own colliding
                // type is renamed (it is ours, and nothing outside this compilation names it), and
                // an unqualified use resolves to the imported one -- which is exactly what the
                // import at the top of the file says it should.
                if (!owner.empty() && importedNs.count(owner) > 0) {
                    continue;
                }
                if (!owner.empty()) {
                    subst[amb] = qualified(owner, amb);
                    program.qualifiedTypes.insert(qualified(owner, amb));
                }
            }
            for (const auto& [k, v] : dotted) {
                subst[k] = v;  // explicit ns.Type -> concrete name
            }
            if (subst.empty() || b.isImported) {
                continue;  // an imported bundle's declarations keep the names its own build gave them
            }
            for (auto& c : ns.classes) {
                const std::string newName = subst.count(c.name) ? subst[c.name] : c.name;
                ast::ClassDecl rewritten = cloneClass(c, subst, newName);
                rewritten.typeParams = c.typeParams;  // cloneClass drops these; keep generics generic
                rewritten.typeParamVariance = c.typeParamVariance;
                rewritten.typeParamFixed = c.typeParamFixed;          // A.3: and WHEN each binds
                rewritten.typeParamValueType = c.typeParamValueType;  // ...and what kind it is
                // cloneClass does not run these name fields through the subst:
                if (auto it = subst.find(rewritten.superclass); it != subst.end()) {
                    rewritten.superclass = it->second;
                }
                for (auto& iface : rewritten.interfaces) {
                    if (auto it = subst.find(iface); it != subst.end()) {
                        iface = it->second;
                    }
                }
                for (auto& p : rewritten.permits) {
                    if (auto it = subst.find(p); it != subst.end()) {
                        p = it->second;
                    }
                }
                c = std::move(rewritten);
            }
            for (auto& e : ns.enums) {
                if (subst.count(e.name) > 0) {
                    e.name = subst[e.name];
                }
                for (auto& cat : e.extendsCatalogs) {
                    if (auto it = subst.find(cat); it != subst.end()) {
                        cat = it->second;
                    }
                }
                // AN ENUM'S MEMBERS ARE CODE TOO, and this walked only its NAME.
                //
                // A class goes through `cloneClass`, which substitutes inside every method body. An
                // enum had its name renamed and its bodies left alone -- so a java-style enum whose
                // method says `Color.GREEN` kept a bare `Color` that had just been renamed out from
                // under it, and the program failed with `use of undeclared variable 'Color'` against
                // a name it had plainly declared.
                //
                // Nothing tripped it while no stdlib type shared a name with a user enum, because
                // without a collision no renaming happens at all. Adding `Color` to the standard
                // library made two of this project's own samples fail -- which is the shape this bug
                // has: it is invisible until someone else picks the same word.
                for (auto& m : e.members) {
                    if (ast::MemberPtr cm = cloneMember(m.get(), subst)) {
                        m = std::move(cm);
                    }
                }
                // And the constructor arguments of the constants themselves, which may name a type.
                for (auto& args : e.constantArgs) {
                    for (auto& a : args) {
                        if (a != nullptr) {
                            a = cloneExpr(a.get(), subst);
                        }
                    }
                }
            }
            for (auto& cat : ns.catalogs) {
                if (subst.count(cat.name) > 0) {
                    cat.name = subst[cat.name];
                }
                for (auto& parent : cat.extendsCatalogs) {
                    if (auto it = subst.find(parent); it != subst.end()) {
                        parent = it->second;
                    }
                }
            }
        }
    }
}

// `partial` classes (spec 8.3): several declarations of the same class, in the same namespace, are one
// class. Merge every later part into the first: members are appended, and the inheritance/modifier facts
// of any part apply to the whole (so the parts need not repeat `extends`/`implements`). Merging happens
// before generics/semantics, so nothing downstream ever sees the split.
void mergePartialClasses(ast::Program& program) {
    // ACROSS FILES, which is the case the keyword exists for and the one this did not handle.
    //
    // Every file contributes its OWN `Namespace` object to the bundle, so `Pico.Kernel` written in two
    // files is two entries here with the same name. Merging per namespace OBJECT therefore only ever
    // merged parts already in one file -- the case a reader is least likely to write, since a class
    // split across two declarations in one file could simply be one declaration. Cross-file parts
    // never met, reached semantics as two classes with one name, and were rejected as a redeclaration:
    // the feature was documented as "across files" and worked only within one.
    //
    // The first part is found by (bundle NAME, namespace NAME, class name) over the whole PROGRAM.
    //
    // Keying by the NAMES and not by the objects is the whole fix. A bundle written in twenty files
    // -- which is what a kernel looks like -- is twenty `Bundle` objects here that all call themselves
    // `Pico`, each holding its own `Namespace` object called `Kernel`. Anything that matched parts by
    // walking one object could only ever see one file. Bundles are still distinct BY NAME: two
    // bundles genuinely called different things each keep their own `Config`, which is the type
    // identity rule this must not break.
    //
    // The head is held as a POINTER, and the compaction that removes absorbed parts is deferred to
    // the end, because moving elements out of a `classes` vector while later files still have parts
    // to merge into it would dangle exactly that pointer.
    std::map<std::string, ast::ClassDecl*> firstPart;
    std::vector<std::vector<std::vector<bool>>> dropped(program.bundles.size());
    for (std::size_t bi = 0; bi < program.bundles.size(); ++bi) {
        dropped[bi].resize(program.bundles[bi].namespaces.size());
        for (std::size_t ni = 0; ni < program.bundles[bi].namespaces.size(); ++ni) {
            dropped[bi][ni].assign(program.bundles[bi].namespaces[ni].classes.size(), false);
        }
    }
    for (std::size_t bi = 0; bi < program.bundles.size(); ++bi) {
        auto& b = program.bundles[bi];
        for (std::size_t ni = 0; ni < b.namespaces.size(); ++ni) {
            auto& ns = b.namespaces[ni];
            for (std::size_t i = 0; i < ns.classes.size(); ++i) {
                ast::ClassDecl& c = ns.classes[i];
                const std::string key = b.name + "|" + ns.name + "|" + c.name;
                auto it = firstPart.find(key);
                if (it == firstPart.end()) {
                    firstPart[key] = &c;
                    continue;
                }
                if (!c.isPartial) {
                    continue;  // a genuine duplicate: sema reports it
                }
                ast::ClassDecl& head = *it->second;
                if (!head.isPartial) {
                    continue;
                }
                for (auto& m : c.members) {
                    head.members.push_back(std::move(m));
                }
                if (head.superclass.empty()) {
                    head.superclass = c.superclass;
                }
                for (const auto& i2 : c.interfaces) {
                    head.interfaces.push_back(i2);
                }
                head.isAbstract = head.isAbstract || c.isAbstract;
                head.isSealed = head.isSealed || c.isSealed;
                head.isFinal = head.isFinal || c.isFinal;
                dropped[bi][ni][i] = true;
            }
        }
    }
    // ...and only now, with every part in every file merged, are the absorbed declarations removed.
    for (std::size_t bi = 0; bi < program.bundles.size(); ++bi) {
        auto& b = program.bundles[bi];
        for (std::size_t ni = 0; ni < b.namespaces.size(); ++ni) {
            auto& ns = b.namespaces[ni];
            std::vector<ast::ClassDecl> kept;
            kept.reserve(ns.classes.size());
            for (std::size_t i = 0; i < ns.classes.size(); ++i) {
                if (!dropped[bi][ni][i]) {
                    kept.push_back(std::move(ns.classes[i]));
                }
            }
            ns.classes = std::move(kept);
        }
    }
}

// ---- Generators (spec 22.6) ----
//
// A method whose body `yield`s is a generator: calling it produces an Iterator<T> that runs the body
// lazily, one element per next(). It is lowered here, before generics and semantics, so everything
// downstream (type checking, the lazy `foreach`, vtables) sees ordinary Polaron:
//
//   1. the original method keeps its signature but its body becomes a factory:
//          return new <Cls>$<m>$Gen(<Cls>$<m>$start(this?, args...)) on heap;
//   2. its real body moves into a hidden twin method flagged `isGeneratorBody`, which codegen emits
//      as four raw functions -- $start (allocate the state), $resume (run to the next yield),
//      $current (read the yielded value), $free -- the resume being a yield-suspending state machine
//      built on the same coroutine lowering as async;
//   3. a synthesized class implementing Iterator<T> drives those functions, buffering one element so
//      hasNext() can look ahead without losing it.
//
// The generator's state lives on the heap and is freed by the synthesized class's destructor, so the
// iterator can be deleted like any other object (the lazy `foreach` owns the one it is handed).

// Any `yield` in this statement tree? Expressions are not walked, so the `yield` of a
// match-EXPRESSION arm (spec 16.2, a different construct with the same keyword) never counts.
bool blockYields(const ast::Block& b);
bool stmtYields(const ast::Stmt* st) {
    if (st == nullptr) {
        return false;
    }
    if (dynamic_cast<const ast::YieldStmt*>(st) != nullptr) {
        return true;
    }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) {
        return blockYields(x->thenBlock) || (x->elseBlock && blockYields(*x->elseBlock));
    }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) {
        return stmtYields(x->stmt.get());
    }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::SynchronizedStmt*>(st)) {
        return blockYields(x->body);
    }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (const auto& c : x->cases) {
            if (blockYields(c.body)) {
                return true;
            }
        }
        return x->defaultBody && blockYields(*x->defaultBody);
    }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (const auto& c : x->cases) {
            if (blockYields(c.body)) {
                return true;
            }
        }
        return x->defaultBody && blockYields(*x->defaultBody);
    }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) {
        if (blockYields(x->body)) {
            return true;
        }
        for (const auto& c : x->catches) {
            if (blockYields(c.body)) {
                return true;
            }
        }
        return x->finallyBlock && blockYields(*x->finallyBlock);
    }
    return false;
}
bool blockYields(const ast::Block& b) {
    for (const auto& s : b.statements) {
        if (stmtYields(s.get())) {
            return true;
        }
    }
    return false;
}

ast::TypeRef simpleType(const std::string& name) {
    ast::TypeRef t;
    t.name = name;
    return t;
}
ast::ExprPtr thisExpr() {
    auto e = std::make_unique<ast::IdentifierExpr>();
    e->name = "this";
    return e;
}
ast::ExprPtr fieldExpr(const std::string& name) {  // this.<name>
    auto m = std::make_unique<ast::MemberExpr>();
    m->object = thisExpr();
    m->member = name;
    return m;
}
ast::ExprPtr boolExpr(bool v) {
    auto b = std::make_unique<ast::BoolLiteralExpr>();
    b->value = v;
    return b;
}
ast::ExprPtr callExpr(const std::string& fn, std::vector<ast::ExprPtr> args) {
    auto c = std::make_unique<ast::CallExpr>();
    auto id = std::make_unique<ast::IdentifierExpr>();
    id->name = fn;
    c->callee = std::move(id);
    c->args = std::move(args);
    c->argNames.assign(c->args.size(), "");
    return c;
}
ast::StmtPtr assignStmt(ast::ExprPtr target, ast::ExprPtr value) {
    auto a = std::make_unique<ast::AssignStmt>();
    a->target = std::move(target);
    a->value = std::move(value);
    return a;
}
ast::StmtPtr exprStmt(ast::ExprPtr e) {
    auto s = std::make_unique<ast::ExprStmt>();
    s->expr = std::move(e);
    return s;
}
ast::StmtPtr returnStmt(ast::ExprPtr v) {
    auto r = std::make_unique<ast::ReturnStmt>();
    r->value = std::move(v);
    return r;
}

// An `extern cdecl static` declaration of one of the generator's four raw functions. Codegen defines
// them in this same module; declaring them as extern is what lets synthesized Polaron call them.
ast::MemberPtr externDecl(const std::string& name, std::vector<ast::Param> params,
                          const ast::TypeRef& ret, SourceLocation loc) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = loc;
    m->visibility = "private";
    m->isStatic = true;
    m->isExtern = true;
    m->externConvention = "cdecl";
    m->name = name;
    m->params = std::move(params);
    m->returnType = ret;
    return m;
}

bool synthesizeGenerators(ast::Program& program) {
    bool ok = true;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            std::vector<ast::ClassDecl> newClasses;
            for (auto& cls : ns.classes) {
                std::vector<ast::MemberPtr> extraMembers;
                for (auto& mem : cls.members) {
                    auto* m = dynamic_cast<ast::MethodDecl*>(mem.get());
                    if (m == nullptr || m->isExtern || m->isAbstract) {
                        continue;
                    }
                    if (!blockYields(m->body)) {
                        continue;
                    }

                    if (m->returnType.name != "Iterator" || m->returnType.typeArgs.size() != 1) {
                        monoError(m->loc, "a method that yields is a generator and must return "
                                          "Iterator<T> (spec 22.6); '" + m->name + "' returns '" +
                                              ast::canonicalType(m->returnType) + "'");
                        ok = false;
                        continue;
                    }
                    const std::string elem = m->returnType.typeArgs[0];
                    bool elemIsParam = false;
                    for (const auto& tp : cls.typeParams) {
                        if (tp == elem) {
                            elemIsParam = true;
                        }
                    }
                    for (const auto& tp : m->typeParams) {
                        if (tp == elem) {
                            elemIsParam = true;
                        }
                    }
                    if (elemIsParam) {
                        monoError(m->loc, "generator '" + m->name + "' yields its type parameter '" +
                                              elem + "'; generators in a generic class or method are not "
                                                     "supported yet (spec 22.6)");
                        ok = false;
                        continue;
                    }

                    const std::string sym = cls.name + "$" + m->name;
                    const std::string genCls = sym + "$Gen";
                    const ast::TypeRef elemT = simpleType(elem);
                    const ast::TypeRef longT = simpleType("long");
                    const ast::TypeRef boolT = simpleType("boolean");
                    const ast::TypeRef voidT = simpleType("void");

                    // --- the hidden twin holding the real body (codegen lowers it to $start/$resume/...)
                    auto twin = std::make_unique<ast::MethodDecl>();
                    twin->loc = m->loc;
                    twin->visibility = "private";
                    twin->isStatic = m->isStatic;
                    twin->isGeneratorBody = true;
                    twin->genElem = elem;
                    twin->genSym = sym;
                    twin->name = m->name + "$body";
                    twin->returnType = voidT;
                    for (const auto& p : m->params) {
                        twin->params.push_back({p.type, p.name, p.loc});
                    }
                    twin->body = std::move(m->body);

                    // --- $start(this?, args...) -> long: allocate the state, seed it with the arguments
                    std::vector<ast::Param> startParams;
                    if (!m->isStatic) {
                        startParams.push_back({simpleType(cls.name), "self", m->loc});
                    }
                    for (const auto& p : m->params) {
                        startParams.push_back({p.type, p.name, p.loc});
                    }
                    extraMembers.push_back(externDecl(sym + "$start", startParams, longT, m->loc));

                    // --- the factory body the original method now has
                    std::vector<ast::ExprPtr> startArgs;
                    if (!m->isStatic) {
                        startArgs.push_back(thisExpr());
                    }
                    for (const auto& p : m->params) {
                        auto id = std::make_unique<ast::IdentifierExpr>();
                        id->name = p.name;
                        startArgs.push_back(std::move(id));
                    }
                    auto mk = std::make_unique<ast::NewExpr>();
                    mk->loc = m->loc;
                    mk->className = genCls;
                    mk->location = "heap";
                    mk->args.push_back(callExpr(sym + "$start", std::move(startArgs)));
                    m->body = ast::Block{};
                    m->body.statements.push_back(returnStmt(std::move(mk)));
                    extraMembers.push_back(std::move(twin));

                    // --- the Iterator<T> class driving the state machine
                    ast::ClassDecl g;
                    g.loc = m->loc;
                    g.visibility = "public";
                    g.name = genCls;
                    g.interfaces.push_back("Iterator");
                    g.interfaceTypeArgs.push_back({elem});
                    auto field = [&](const std::string& name, const ast::TypeRef& t) {
                        auto f = std::make_unique<ast::FieldDecl>();
                        f->loc = m->loc;
                        f->visibility = "private";
                        f->isMutable = true;
                        f->type = t;
                        f->name = name;
                        g.members.push_back(std::move(f));
                    };
                    field("st", longT);        // the heap state object, as an opaque handle
                    field("buffered", boolT);  // an element is sitting in `buf`, not yet consumed
                    field("finished", boolT);  // the body ran to completion
                    field("buf", elemT);
                    g.members.push_back(
                        externDecl(sym + "$resume", {{longT, "st", m->loc}}, boolT, m->loc));
                    g.members.push_back(
                        externDecl(sym + "$current", {{longT, "st", m->loc}}, elemT, m->loc));
                    g.members.push_back(
                        externDecl(sym + "$free", {{longT, "st", m->loc}}, voidT, m->loc));

                    auto ctor = std::make_unique<ast::ConstructorDecl>();
                    ctor->loc = m->loc;
                    ctor->visibility = "public";
                    ctor->params.push_back({longT, "st", m->loc});
                    auto stArg = std::make_unique<ast::IdentifierExpr>();
                    stArg->name = "st";
                    ctor->body.statements.push_back(assignStmt(fieldExpr("st"), std::move(stArg)));
                    ctor->body.statements.push_back(assignStmt(fieldExpr("buffered"), boolExpr(false)));
                    ctor->body.statements.push_back(assignStmt(fieldExpr("finished"), boolExpr(false)));
                    g.members.push_back(std::move(ctor));

                    // pump(): run the body to the next yield unless an element is already buffered.
                    auto pump = std::make_unique<ast::MethodDecl>();
                    pump->loc = m->loc;
                    pump->visibility = "private";
                    pump->name = "pump";
                    pump->returnType = voidT;
                    auto guard = [&](const std::string& f) {
                        auto i = std::make_unique<ast::IfStmt>();
                        i->loc = m->loc;
                        i->cond = fieldExpr(f);
                        i->thenBlock.statements.push_back(returnStmt(nullptr));
                        pump->body.statements.push_back(std::move(i));
                    };
                    guard("buffered");
                    guard("finished");
                    auto step = std::make_unique<ast::IfStmt>();
                    step->loc = m->loc;
                    {
                        std::vector<ast::ExprPtr> a;
                        a.push_back(fieldExpr("st"));
                        step->cond = callExpr(sym + "$resume", std::move(a));
                        std::vector<ast::ExprPtr> a2;
                        a2.push_back(fieldExpr("st"));
                        step->thenBlock.statements.push_back(
                            assignStmt(fieldExpr("buf"), callExpr(sym + "$current", std::move(a2))));
                        step->thenBlock.statements.push_back(
                            assignStmt(fieldExpr("buffered"), boolExpr(true)));
                        step->elseBlock = std::make_unique<ast::Block>();
                        step->elseBlock->statements.push_back(
                            assignStmt(fieldExpr("finished"), boolExpr(true)));
                    }
                    pump->body.statements.push_back(std::move(step));
                    g.members.push_back(std::move(pump));

                    auto hasNext = std::make_unique<ast::MethodDecl>();
                    hasNext->loc = m->loc;
                    hasNext->visibility = "public";
                    hasNext->isOverride = true;
                    hasNext->name = "hasNext";
                    hasNext->returnType = boolT;
                    hasNext->body.statements.push_back(exprStmt(callExpr("pump", {})));
                    hasNext->body.statements.push_back(returnStmt(fieldExpr("buffered")));
                    g.members.push_back(std::move(hasNext));

                    auto next = std::make_unique<ast::MethodDecl>();
                    next->loc = m->loc;
                    next->visibility = "public";
                    next->isOverride = true;
                    next->name = "next";
                    next->returnType = elemT;
                    next->body.statements.push_back(exprStmt(callExpr("pump", {})));
                    next->body.statements.push_back(assignStmt(fieldExpr("buffered"), boolExpr(false)));
                    next->body.statements.push_back(returnStmt(fieldExpr("buf")));
                    g.members.push_back(std::move(next));

                    auto dtor = std::make_unique<ast::DestructorDecl>();
                    dtor->loc = m->loc;
                    dtor->visibility = "public";
                    {
                        std::vector<ast::ExprPtr> a;
                        a.push_back(fieldExpr("st"));
                        dtor->body.statements.push_back(exprStmt(callExpr(sym + "$free", std::move(a))));
                    }
                    g.members.push_back(std::move(dtor));

                    newClasses.push_back(std::move(g));
                }
                for (auto& em : extraMembers) {
                    cls.members.push_back(std::move(em));
                }
            }
            for (auto& g : newClasses) {
                ns.classes.push_back(std::move(g));
            }
        }
    }
    return ok;
}

bool monomorphize(ast::Program& program) {
    mergePartialClasses(program);   // spec 8.3: fold the parts of a `partial` class into one
    if (!synthesizeGenerators(program)) {
        return false;  // spec 22.6: `yield` -> a lazy Iterator class
    }
    // Record enum names so EnumName.parse() can force-monomorphize its Option<Enum> result.
    g_enumNames.clear();
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& en : ns.enums) {
                g_enumNames.insert(en.name);
            }
        }
    }
    // Index generic templates by name.
    std::map<std::string, const ast::ClassDecl*> templates;
    // ...AND WHERE EACH ONE LIVED, because an instantiation belongs where its template does.
    // See the placement loop at the end of this function for what went wrong without it. A
    // `Namespace*` survives: the namespaces themselves are never moved, only their `classes`
    // vectors are rebuilt.
    std::map<std::string, ast::Namespace*> templateHome;
    std::set<std::string> generics;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                if (!c.typeParams.empty()) {
                    templates[c.name] = &c;
                    templateHome[c.name] = &ns;
                    generics.insert(c.name);
                    // Record the template's namespace before it is dropped, so the analyzer can enforce
                    // imports on a generic by its base name (a stdlib collection requires an import; a
                    // user generic in the current namespace does not).
                    auto& homes = program.genericNamespaces[c.name];
                    if (std::find(homes.begin(), homes.end(), ns.name) == homes.end()) {
                        homes.push_back(ns.name);
                    }
                    // Record variance (spec 15.3) before the template is dropped, so the
                    // analyzer can apply variance subtyping to the concrete instantiations.
                    if (!c.typeParamVariance.empty()) {
                        program.genericVariance[c.name] = c.typeParamVariance;
                    }
                }
            }
        }
    }
    // Every generic type-parameter name (T, K, V, ...). An "instantiation" whose argument is one
    // of these is bogus: it comes from a template referring to itself with its own parameter (e.g.
    // `Node<T>* next` inside `Node<T>`, or `new Node<T>()` in its own body). Such pseudo-instances
    // must never be generated -- doing so produced a class with an undefined type and crashed.
    std::set<std::string> typeParamNames;
    for (const auto& [tname, tpl] : templates) {
        for (const auto& tp : tpl->typeParams) {
            typeParamNames.insert(tp);
        }
    }
    // Method type parameters too (e.g. R in `map<R>`): a `new Generic<R>` in a generic method's body
    // refers to the method's own parameter, not a concrete instantiation, until the method is
    // instantiated with a real R. Without this, collecting `ArrayList$R` produced a bogus class.
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (const auto& mem : c.members) {
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(mem.get())) {
                        for (const auto& tp : md->typeParams) {
                            typeParamNames.insert(tp);
                        }
                    }
                }
            }
        }
    }

    // No generic classes: still expand any generic methods, then done.
    if (templates.empty()) {
        return expandGenericMethods(program);
    }

    // Index every class by name for constraint subtype checks.
    std::map<std::string, const ast::ClassDecl*> classIndex;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                classIndex[c.name] = &c;
            }
        }
    }
    bool ok = true;

    // Collect instantiations used across the whole program.
    InstMap insts;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                collectClass(c, generics, insts);
            }
        }
    }

    // Generic-method call instantiations (name, type-args) gathered from every call site. A generic
    // method body can instantiate another generic using its OWN type parameter -- `make<R>()` doing
    // `new Pair2<int, R>` -- which is concrete only once R is bound (in expandGenericMethods, run after
    // class generation). We use these to pre-seed those class instantiations in the worklist below, so
    // the classes exist before the expanded method bodies reference them.
    MethInsts methInsts;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (auto& m : c.members) {
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        collectMethBlock(meth->body, methInsts);
                    }
                }
            }
        }
    }

    /* A GENERIC METHOD'S SIGNATURE CAN NAME A GENERIC CLASS IN TERMS OF ITS OWN PARAMETER.
     *
     * `Arrays.equal<T>(T[] a, T[] b, Comparer<T>* compare)` needs `Comparer<int>` to exist, and
     * `Comparer<int>` becomes a concrete name only when T is bound -- which happens in
     * `expandGenericMethods`, long after this pass has finished generating classes. So it is bound
     * HERE, once per instantiation the program actually asks for, and the resulting class
     * instantiations join the worklist like any other.
     *
     * Over EVERY class, not only the generic ones: `Arrays` is not generic and `equal<T>` is, which
     * is the commonest shape of all -- a static helper parameterised over what it works on. The
     * instantiation walk below only reaches classes it GENERATES, so a non-generic class's generic
     * method was never asked this question, and its parameter type came out naming a class the
     * program does not contain. The call `compare(a[i], b[i])` then read as a call to nothing.
     *
     * Invisible until now because a callable parameter used to be spelled `function<int, T, T>`,
     * which is structural: it has no instantiation to miss. */
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                for (auto& m : c.members) {
                    const auto* meth = dynamic_cast<const ast::MethodDecl*>(m.get());
                    if (meth == nullptr || meth->typeParams.empty()) {
                        continue;
                    }
                    for (const MethInst& mi : methInsts) {
                        if (mi.first != meth->name || mi.second.size() != meth->typeParams.size()) {
                            continue;
                        }
                        Subst ms;
                        for (std::size_t i = 0; i < mi.second.size(); ++i) {
                            ms[meth->typeParams[i]] = mi.second[i];
                        }
                        ast::MemberPtr cm = cloneMember(meth, ms);
                        const auto* bound = static_cast<const ast::MethodDecl*>(cm.get());
                        for (const ast::Param& p : bound->params) {
                            collectType(p.type, generics, insts);
                        }
                        collectType(bound->returnType, generics, insts);
                    }
                }
            }
        }
    }

    // Generate a concrete class per instantiation (worklist for transitive ones).
    std::vector<ast::ClassDecl> generated;
    std::set<std::string> done;
    std::vector<std::string> work;
    for (const auto& [m, _] : insts) {
        work.push_back(m);
    }
    while (!work.empty()) {
        const std::string m = work.back();
        work.pop_back();
        if (done.count(m) > 0) {
            continue;
        }
        done.insert(m);
        const auto& [base, args] = insts[m];
        // Skip a template's self-reference with its own type parameter (e.g. Node$T from a
        // `Node<T>* next` field) -- it is not a real instantiation (see typeParamNames). An arg may be a
        // nested mangled generic (e.g. "Handler$T" from a field ArrayList<Handler<T>>); if any of its
        // '$'-separated segments is a type parameter, this is still a template self-reference, not concrete.
        bool selfParam = false;
        for (const auto& a : args) {
            std::size_t start = 0;
            while (true) {
                const std::size_t d = a.find('$', start);
                std::string seg =
                    a.substr(start, d == std::string::npos ? std::string::npos : d - start);
                // ...and through a POINTER or REFERENCE marker: a field `ArrayList<T*>` inside a
                // generic names the segment `T*`, which is the template's own parameter just as
                // `T` is. Without stripping it, the collector materialized `ArrayList$T*` -- an
                // instance over a type that does not exist -- and its `add` was reported as taking
                // a `T*` where the caller had a `Node*`. Any generic container OF POINTERS hit this,
                // which is every arena-backed one.
                if (!seg.empty() && (seg.back() == '*' || seg.back() == '&')) {
                    seg.pop_back();
                }
                if (typeParamNames.count(seg) > 0) {
                    selfParam = true;
                }
                if (d == std::string::npos) {
                    break;
                }
                start = d + 1;
            }
        }
        if (selfParam) {
            continue;
        }
        auto tit = templates.find(base);
        if (tit == templates.end() || tit->second->typeParams.size() != args.size()) {
            continue;
        }
        // Constraints (spec 15.2): each type argument must satisfy its bound.
        for (const auto& pb : tit->second->typeParamBounds) {
            std::size_t pi = 0;
            while (pi < tit->second->typeParams.size() && tit->second->typeParams[pi] != pb.param) {
                ++pi;
            }
            if (pi >= args.size()) {
                continue;
            }
            const std::string bound = substBound(pb.bound, tit->second->typeParams, args);
            if (!satisfiesTypeBound(args[pi], bound, pb.applies, classIndex)) {
                monoError(tit->second->loc,
                          "type argument '" + args[pi] + "' does not satisfy constraint '" + pb.param +
                              (pb.applies ? " applies " : " extends ") + spellBound(bound) + "' in '" + m +
                              "'");
                ok = false;
            }
        }
        Subst s;
        for (std::size_t i = 0; i < args.size(); ++i) {
            s[tit->second->typeParams[i]] = args[i];
        }
        // NOT `s[name] = m`: that map is applied to types too, and `ArrayList` inside
        // `ArrayList<T>` would become `ArrayList$long$long`. The self-reference is rewritten only
        // where it is an expression -- see `g_selfTemplate`.
        g_selfTemplate = tit->second->name;
        g_selfConcrete = m;
        ast::ClassDecl concrete = cloneClass(*tit->second, s, m);
        g_selfTemplate.clear();
        g_selfConcrete.clear();
        // A generic base (`extends Base<T>`) is itself an instantiation to generate.
        if (!concrete.superclassTypeArgs.empty() && generics.count(concrete.superclass) > 0) {
            const std::string sm =
                ast::mangleGeneric(concrete.superclass, concrete.superclassTypeArgs);
            if (insts.find(sm) == insts.end()) {
                insts[sm] = {concrete.superclass, concrete.superclassTypeArgs};
            }
            if (done.count(sm) == 0) {
                work.push_back(sm);
            }
        }
        // A generic sealed base seeds its permitted subclasses with the same args, so the variants
        // (e.g. Ok$int$int / Err$int$int for Result$int$int) exist for match and construction.
        for (const std::string& p : tit->second->permits) {
            if (generics.count(p) == 0) {
                continue;
            }
            const std::string pm = ast::mangleGeneric(p, args);
            if (insts.find(pm) == insts.end()) {
                insts[pm] = {p, args};
            }
            if (done.count(pm) == 0) {
                work.push_back(pm);
            }
        }
        InstMap more;
        collectClass(concrete, generics, more);
        // A generic method on this concrete class may instantiate other generics using its own type
        // parameters (e.g. `make<R>()` doing `new Pair2<int, R>`); bind each with the known method
        // instantiations and collect the resulting concrete class instantiations too.
        for (const auto& mem : concrete.members) {
            const auto* gm = dynamic_cast<const ast::MethodDecl*>(mem.get());
            if (gm == nullptr || gm->typeParams.empty()) {
                continue;
            }
            for (const MethInst& mi : methInsts) {
                if (mi.first != gm->name || mi.second.size() != gm->typeParams.size()) {
                    continue;
                }
                Subst ms;
                for (std::size_t i = 0; i < mi.second.size(); ++i) {
                    ms[gm->typeParams[i]] = mi.second[i];
                }
                ast::MemberPtr cm = cloneMember(gm, ms);
                const auto* bound = static_cast<const ast::MethodDecl*>(cm.get());
                collectBlock(bound->body, generics, more);
                /* ...AND ITS SIGNATURE, which is where the gap was.
                   `map<R>(Mapper<T, R>* transform)` names a generic class in a PARAMETER, and
                   `Mapper<int, int>` becomes a concrete type only once R is bound -- which happens
                   here. Only the body was being collected from, so the instantiation was never
                   generated, and the method came out taking a class the program does not contain:
                   the call `transform(x)` then read as a call to nothing, and the compiler answered
                   with the nearest same-named method it could find, in another class entirely.
                   Invisible while the callable type was `function<...>`, which is structural and
                   needs no instantiation -- so the gap arrived with the first library signature that
                   named a generic type in terms of a method's own parameter. */
                for (const ast::Param& p : bound->params) {
                    collectType(p.type, generics, more);
                }
                collectType(bound->returnType, generics, more);
            }
        }
        for (const auto& [mm, pp] : more) {
            if (insts.find(mm) == insts.end()) {
                insts[mm] = pp;
            }
            if (done.count(mm) == 0) {
                work.push_back(mm);
            }
        }
        generated.push_back(std::move(concrete));
    }

    // Drop the templates; the generated concrete classes take their place.
    ast::Namespace* sink = nullptr;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            std::vector<ast::ClassDecl> kept;
            for (auto& c : ns.classes) {
                if (c.typeParams.empty()) {
                    kept.push_back(std::move(c));
                }
            }
            ns.classes = std::move(kept);
            if (sink == nullptr) {
                sink = &ns;
            }
        }
    }
    // EACH INSTANTIATION GOES HOME -- to the namespace its TEMPLATE was declared in.
    //
    // Every one of them used to go into `sink`, which is *the first namespace of the first bundle*
    // and has nothing to do with any of them. For most of the compiler that was harmless: names are
    // mangled and resolved by key, so which namespace held `ArrayList$String` never came up.
    //
    // IT CAME UP AT `unimport namespace X`, which is the one statement whose meaning is *every type
    // in this namespace*. A program that said `unimport namespace app` got its own two classes and,
    // sitting in the same namespace by accident of this line, every generic instantiation in the
    // program -- `ArrayList$String`, `Option$Certificate*`, forty more, almost all of them the
    // standard library's. And §30 means `unimport` literally: their vtables were poisoned to the
    // trap and their machine code overwritten with `int3`. The next `println` ran into it.
    //
    // The symptom is worth recording because it is why this survived: the process died with **no
    // output at all**, since stdout was a pipe and the buffered lines went with it -- while on a
    // console the same program printed first and appeared to fail somewhere later entirely.
    //
    // And it was HIDDEN, not absent. Every prelude class used to be given an implicit `Object` base
    // whether it needed one or not; removing that (`dynamic`'s last debt) changed which classes have
    // a vtable at all, and this fell out immediately. A bug that only shows when an unrelated
    // pessimisation is removed is one the pessimisation was paying for.
    for (auto& c : generated) {
        const std::size_t at = c.name.find('$');
        ast::Namespace* home = nullptr;
        if (at != std::string::npos) {
            auto it = templateHome.find(c.name.substr(0, at));
            if (it != templateHome.end()) {
                home = it->second;
            }
        }
        if (home == nullptr) {
            home = sink;   // a name no template claims: nowhere better, and nothing depends on it
        }
        if (home != nullptr) {
            home->classes.push_back(std::move(c));
        }
    }
    // Mangle generic superclasses now that every concrete class exists (Derived$int
    // extends Base$int). Applies to generated and plain classes alike.
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                if (!c.superclassTypeArgs.empty()) {
                    c.superclass = ast::mangleGeneric(c.superclass, c.superclassTypeArgs);
                }
                // `implements Iface<Args>` now refers to the concrete instantiation.
                for (std::size_t k = 0; k < c.interfaceTypeArgs.size() && k < c.interfaces.size(); ++k) {
                    if (!c.interfaceTypeArgs[k].empty()) {
                        c.interfaces[k] =
                            ast::mangleGeneric(c.interfaces[k], c.interfaceTypeArgs[k]);
                    }
                }
            }
        }
    }
    // Generic methods live on both plain and monomorphized classes; expand them
    // now that every concrete class (and its cloned bodies) exists.
    if (!expandGenericMethods(program)) {
        ok = false;
    }
    return ok;
}

// -------------------------------------------------------------------------------------------------
// `delegate`: satisfy an interface by FORWARDING to a field.
//
// The word does not mean "function pointer" here -- that is C#'s idiosyncrasy, and Polaron already spells
// callables four ways (`function<>`, `typealias`, `methodref`, `unknown <world> methodptr<>`). It means
// what it means in OOP: this object receives a message and passes it to the component that actually
// knows how to answer it.
//
// Which is composition instead of inheritance -- the thing every design text asks for and almost nobody
// does, because doing it by hand costs N methods whose entire content is `return this.f.m(args);`. So
// people reach for `extends` to get behaviour they only wanted to REUSE, and burn the single inheritance
// slot on it. The stdlib does this in four places its own reference names out loud ("Delegates to the
// source iterator", "delegates to the backing map"), and `LinkedHashMap` is the case that proves the
// point: it forwards to a backing map because it could not have inherited from one -- it already has an
// identity of its own.
//
// This runs BEFORE monomorphize, so a generic class gets its forwarding methods once and the copies come
// out per instantiation like everything else. The synthesized methods are ordinary AST from here on, so
// type checking, `override`, codegen and reflection all see real methods -- an `implements` that is not
// a lie.
// The generic copier, published for `expandTransformers`. Nothing here is generic-specific: it is a
// deep clone that renames types as it goes, and a transformer needs exactly that with one binding.
ast::ExprPtr cloneExprSubst(const ast::Expr* e, const std::map<std::string, std::string>& subst) {
    return cloneExpr(e, subst);
}

ast::MemberPtr cloneMemberSubst(const ast::MemberDecl* m,
                                const std::map<std::string, std::string>& subst) {
    return cloneMember(m, subst);
}

static size_t delegateErrorCount = 0;
static void delegateError(const SourceLocation& loc, const std::string& message) {
    ++delegateErrorCount;
    monoError(loc, message);
}

namespace {

// Walk the whole supertype closure -- superclass chain AND interfaces -- splitting what it declares in
// two: the ABSTRACT methods, which are obligations, and the names that already have a body somewhere,
// which are answered and must not be forwarded over.
//
// Both directions matter and neither alone is enough. Interfaces are the obvious source of obligations,
// but the stdlib's own case arrives the other way: `IteratorStream extends Stream<T>`, and `Stream` is
// an abstract class that implements `Iterator<T>`. Restricting delegation to `implements` would have
// missed the very sites that motivated the keyword.
void collectObligations(const std::string& typeName,
                        const std::map<std::string, ast::ClassDecl*>& index,
                        std::vector<const ast::MethodDecl*>& owed, std::set<std::string>& answered,
                        std::set<std::string>& seenTypes) {
    if (!seenTypes.insert(typeName).second) {
        return;
    }
    auto it = index.find(typeName);
    if (it == index.end()) {
        return;
    }
    const ast::ClassDecl& c = *it->second;
    for (const ast::MemberPtr& m : c.members) {
        const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
        if (md == nullptr || md->isStatic) {
            continue;
        }
        if (md->name == c.name || (!md->name.empty() && md->name[0] == '~')) {
            continue;
        }
        if (md->isAbstract) {
            owed.push_back(md);
        } else {
            answered.insert(md->name);
        }
    }
    if (!c.superclass.empty()) {
        collectObligations(c.superclass, index, owed, answered, seenTypes);
    }
    for (const std::string& i : c.interfaces) {
        collectObligations(i, index, owed, answered, seenTypes);
    }
}

// Can `typeName` answer a message called `name`? An ABSTRACT declaration counts: a delegate typed as an
// interface is the ordinary case, and the object behind it is the one that will answer.
bool typeAnswers(const std::string& typeName, const std::string& name,
                 const std::map<std::string, ast::ClassDecl*>& index, std::set<std::string>& seen) {
    if (!seen.insert(typeName).second) {
        return false;
    }
    auto it = index.find(typeName);
    if (it == index.end()) {
        return false;
    }
    const ast::ClassDecl& c = *it->second;
    for (const ast::MemberPtr& m : c.members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
            if (md->name == name && !md->isStatic) {
                return true;
            }
        }
    }
    if (!c.superclass.empty() && typeAnswers(c.superclass, name, index, seen)) {
        return true;
    }
    for (const std::string& i : c.interfaces) {
        if (typeAnswers(i, name, index, seen)) {
            return true;
        }
    }
    return false;
}

// `return this.<field>.<method>(<params>);` -- or the statement plus a bare `return;` when void.
ast::MemberPtr makeForwarder(const ast::FieldDecl& f, const ast::MethodDecl& owed) {
    auto fwd = std::make_unique<ast::MethodDecl>();
    // The diagnostic location is the DELEGATE FIELD, not the interface. If this method is wrong -- a
    // clash, a type that does not line up -- the line the author can act on is the one that said
    // "forward my interface here", and there is no other line to point at: they never wrote this method.
    fwd->loc = f.loc;
    fwd->visibility = "public";
    fwd->isOverride = true;
    fwd->name = owed.name;
    fwd->params = owed.params;
    fwd->returnType = owed.returnType;
    fwd->throwsTypes = owed.throwsTypes;  // the interface's clause, which the delegate may not widen

    auto self = std::make_unique<ast::IdentifierExpr>();
    self->name = "this";
    self->loc = f.loc;
    auto target = std::make_unique<ast::MemberExpr>();
    target->object = std::move(self);
    target->member = f.name;
    target->loc = f.loc;
    auto callee = std::make_unique<ast::MemberExpr>();
    callee->object = std::move(target);
    callee->member = owed.name;
    callee->loc = f.loc;
    auto call = std::make_unique<ast::CallExpr>();
    call->callee = std::move(callee);
    call->loc = f.loc;
    for (const ast::Param& p : owed.params) {
        auto a = std::make_unique<ast::IdentifierExpr>();
        a->name = p.name;
        a->loc = f.loc;
        call->args.push_back(std::move(a));
        call->argNames.emplace_back();  // positional
    }

    fwd->body.loc = f.loc;
    if (owed.returnType.name == "void" && !owed.returnType.isPointer && !owed.returnType.isArray) {
        auto es = std::make_unique<ast::ExprStmt>();
        es->expr = std::move(call);
        es->loc = f.loc;
        fwd->body.statements.push_back(std::move(es));
        auto rs = std::make_unique<ast::ReturnStmt>();
        rs->loc = f.loc;
        fwd->body.statements.push_back(std::move(rs));
    } else {
        auto rs = std::make_unique<ast::ReturnStmt>();
        rs->value = std::move(call);
        rs->loc = f.loc;
        fwd->body.statements.push_back(std::move(rs));
    }
    return fwd;
}

}  // namespace

// ---- `command`: portable behaviour, expanded into an ordinary class ----
//
// A COMMAND IS AN OBJECT, and this is where it becomes one. `{code, env}` is what every language
// builds by hand for a closure -- a method and a `this` with no type between them -- so a command is
// that pair said honestly: the baggage becomes FIELDS, the signature becomes a METHOD, and the
// language it lowers into is the one it already has.
//
//     public command aboveAge(Dog& d) carries (int minAge) into pack returns boolean {
//         return d.age() >= pack.minAge;
//     }
//
// becomes, in the same namespace:
//
//     public class Kennel$aboveAge {
//         private mutable int minAge;
//         public constructor Kennel$aboveAge(int minAge) { this.minAge = minAge; }
//         public method __command(Dog& d) returns boolean { return d.age() >= this.minAge; }
//     }
//
// and the member itself becomes a static factory on `Kennel`, so `Kennel.aboveAge(21)` builds one.
// Everything downstream -- type checking, the region binder, codegen, reflection -- sees a class and
// a method it already understands, the same bargain `delegate` and `yield` make.
//
// `pack.X` BECOMES `this.X`, and that rewrite is the whole of what `into` buys: inside the body a
// read of carried state is spelled differently from a read of anything else, so the two can never be
// confused by a reader -- and after this pass they are the same thing, which is what makes the name
// free.

namespace {

// One role, as the matcher needs it: what it is called, what it is generic over, and the shape it
// asks for -- every type canonical, so `Dog&` and a renamed-by-`qualifyNamespaces` `Dog` land on the
// same spelling the analyzer and codegen already agree on.
struct CommandRole {
    std::string name;
    std::vector<std::string> typeParams;   // empty for the ordinary, non-generic role
    std::vector<std::string> params;       // canonical, in order
    std::string returns;
};

// The trailing markers of a type name -- `*`, `**`, `&`, `[]` -- with the base in front. A role
// written `T& a` must be answered by `Dog& d` and not by `Dog* d`, so the markers are compared and
// only the base is allowed to be the hole.
std::string typeSuffix(const std::string& t) {
    std::size_t cut = t.size();
    while (cut > 0) {
        const char c = t[cut - 1];
        if (c == '*' || c == '&') {
            --cut;
        } else if (cut >= 2 && t[cut - 1] == ']' && t[cut - 2] == '[') {
            cut -= 2;
        } else {
            break;
        }
    }
    return t.substr(cut);
}

/* DOES THIS COMMAND PLAY THIS ROLE, and if the role is generic, with what?

   For a plain role it is equality: the parameter types in order, then the answer. For a generic one
   -- `command Comparer<T>(T a, T b) returns int;` -- a type param is a HOLE, and what fills it has
   to be the same thing every time it appears: `Comparer<T>` is answered by `(int, int) -> int` and
   by `(Dog*, Dog*) -> int`, and NOT by `(int, Dog*) -> int`, which is what makes the role a
   statement about the command rather than a shape with two independent blanks.

   On success `args` holds what each hole was filled with, in declaration order -- which is exactly
   the `implements Comparer<int>` the generated class needs. */
bool commandFitsRole(const CommandRole& role, const ast::MethodDecl& m,
                     std::vector<std::string>& args) {
    if (role.params.size() != m.params.size()) {
        return false;
    }
    std::map<std::string, std::string> bound;
    auto unify = [&](const std::string& want, const std::string& got) {
        const std::string suffix = typeSuffix(want);
        const std::string base = want.substr(0, want.size() - suffix.size());
        const bool isHole =
            std::find(role.typeParams.begin(), role.typeParams.end(), base) != role.typeParams.end();
        if (!isHole) {
            return want == got;
        }
        if (typeSuffix(got) != suffix || got.size() <= suffix.size()) {
            return false;   // `T&` is not answered by `Dog*`, and a hole is not the empty name
        }
        const std::string fill = got.substr(0, got.size() - suffix.size());
        auto seen = bound.find(base);
        if (seen != bound.end()) {
            return seen->second == fill;   // the same hole, filled twice, must agree
        }
        bound[base] = fill;
        return true;
    };
    for (std::size_t i = 0; i < role.params.size(); ++i) {
        if (!unify(role.params[i], canonicalType(m.params[i].type))) {
            return false;
        }
    }
    if (!unify(role.returns, canonicalType(m.returnType))) {
        return false;
    }
    args.clear();
    for (const std::string& tp : role.typeParams) {
        auto fill = bound.find(tp);
        if (fill == bound.end()) {
            return false;   // a hole the signature never mentions cannot be decided from a call
        }
        args.push_back(fill->second);
    }
    return true;
}

}  // namespace

void expandCommands(ast::Program& program) {
    /* THE ROLES, GATHERED FIRST -- every `command DogTest(Dog& d) returns boolean;` in the program,
       keyed by the shape it asks for.

       Imported bundles are read too, and that is the point rather than an oversight: a library
       declares the role its API takes, and a program in another bundle writes the command that fits.
       Neither names the other. (The generated CLASSES of an imported bundle are skipped below, as
       they always were -- those were expanded by the build that produced the .polb.) */
    std::vector<CommandRole> roles;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                if (!c.isCommandType || c.members.empty()) {
                    continue;
                }
                const auto* sig = dynamic_cast<const ast::MethodDecl*>(c.members.front().get());
                if (sig == nullptr) {
                    continue;
                }
                CommandRole r;
                r.name = c.name;
                r.typeParams = c.typeParams;
                for (const ast::Param& p : sig->params) {
                    r.params.push_back(canonicalType(p.type));
                }
                r.returns = canonicalType(sig->returnType);
                roles.push_back(std::move(r));
            }
        }
    }

    for (auto& b : program.bundles) {
        if (b.isImported) {
            continue;   // its declarations were expanded by the build that produced the .polb
        }
        for (auto& ns : b.namespaces) {
            std::vector<ast::ClassDecl> made;
            for (auto& c : ns.classes) {
                for (ast::MemberPtr& m : c.members) {
                    auto* cmd = dynamic_cast<ast::MethodDecl*>(m.get());
                    if (cmd == nullptr || !cmd->isCommand) {
                        continue;
                    }
                    const std::string cls = c.name + "$" + cmd->name;

                    ast::ClassDecl made1;
                    made1.name = cls;
                    made1.visibility = "public";
                    made1.loc = cmd->loc;

                    // The baggage, as fields -- one per entry, in the order it was written.
                    for (const ast::Param& p : cmd->carries) {
                        auto f = std::make_unique<ast::FieldDecl>();
                        f->loc = cmd->loc;
                        f->visibility = "private";
                        f->isMutable = true;
                        f->type = p.type;
                        f->name = p.name;
                        made1.members.push_back(std::move(f));
                    }
                    // ...and the constructor that fills them, which is what makes the baggage
                    // COPIED at construction rather than referred to: an ordinary assignment, with
                    // the ordinary meaning it has everywhere else in the language.
                    auto ctor = std::make_unique<ast::ConstructorDecl>();
                    ctor->loc = cmd->loc;
                    ctor->visibility = "public";
                    ctor->params = cmd->carries;
                    ctor->body.loc = cmd->loc;
                    for (const ast::Param& p : cmd->carries) {
                        auto self = std::make_unique<ast::IdentifierExpr>();
                        self->name = "this";
                        self->loc = cmd->loc;
                        auto target = std::make_unique<ast::MemberExpr>();
                        target->object = std::move(self);
                        target->member = p.name;
                        target->loc = cmd->loc;
                        auto from = std::make_unique<ast::IdentifierExpr>();
                        from->name = p.name;
                        from->loc = cmd->loc;
                        auto as = std::make_unique<ast::AssignStmt>();
                        as->target = std::move(target);
                        as->value = std::move(from);
                        as->loc = cmd->loc;
                        ctor->body.statements.push_back(std::move(as));
                    }
                    made1.members.push_back(std::move(ctor));

                    // The body, with `pack.x` now reading `this.x`.
                    auto run = std::make_unique<ast::MethodDecl>();
                    run->loc = cmd->loc;
                    run->visibility = "public";
                    run->name = kCommandMethod;
                    run->params = cmd->params;
                    run->returnType = cmd->returnType;
                    run->throwsTypes = cmd->throwsTypes;
                    run->requiresClauses = std::move(cmd->requiresClauses);
                    run->ensuresClauses = std::move(cmd->ensuresClauses);
                    run->isSurveyed = cmd->isSurveyed;
                    run->isReentrant = cmd->isReentrant;
                    /* `pack.x` BECOMES `this.x`, and it is `cloneBlock` that does it rather than a
                       walker written here.

                       The cloner already renames an identifier standing in RECEIVER position -- that
                       is how a renamed type keeps its own static self-calls working -- and `pack` is
                       exactly a receiver. Reusing it means this rewrite cannot fall behind: a second
                       visitor over the tree goes out of date the first time a node kind is added,
                       quietly, and only here. The same argument the field-splice rewrite makes two
                       hundred lines above, for the same reason. */
                    if (cmd->packName.empty()) {
                        run->body = std::move(cmd->body);
                    } else {
                        Subst toThis;
                        toThis[cmd->packName] = "this";
                        run->body = cloneBlock(cmd->body, toThis);
                    }
                    /* AND EVERY ROLE IT FITS, without either side having named the other.
                       "Conformidade estrutural": a command satisfies a command type when the
                       signatures agree, which is the only thing either party can check and the only
                       thing either needs. Written as `implements`, so the analyzer, the vtable
                       layout and the call site all handle it with the machinery interfaces already
                       have -- there is no second dispatch mechanism here, only a second way of
                       arriving at the first one.

                       All of them, not the first: one command may be a `DogTest` and a `Predicate`
                       at once, and refusing the second would make the roles compete for it. */
                    std::vector<std::string> args;
                    for (const CommandRole& role : roles) {
                        if (!commandFitsRole(role, *run, args)) {
                            continue;
                        }
                        made1.interfaces.push_back(role.name);
                        made1.interfaceTypeArgs.push_back(args);
                        // Answering an interface's method is overriding it, and the language says so
                        // out loud at every hand-written implementation. The word is not decoration
                        // here either: without it the analyzer refuses the class it just built.
                        run->isOverride = true;
                    }
                    made1.members.push_back(std::move(run));
                    made.push_back(std::move(made1));

                    // AND THE MEMBER BECOMES A FACTORY, static on the declaring class -- so one is
                    // built by naming it the way everything static is named, `Kennel.aboveAge(21)`,
                    // and the rule that a static method is called through its class covers commands
                    // without a word of its own.
                    auto factory = std::make_unique<ast::MethodDecl>();
                    factory->loc = cmd->loc;
                    factory->visibility = cmd->visibility;
                    factory->isStatic = true;
                    factory->name = cmd->name;
                    factory->params = cmd->carries;
                    factory->returnType.name = cls;
                    factory->returnType.isPointer = true;
                    // ...AND ITS DEPTH, because the two spellings of "is a pointer" are read by
                    // different halves of the compiler: `typeRefStr` asks `isPointer`, and
                    // `canonicalType` counts `pointerDepth`. With only the flag set, the same type
                    // rendered as `Gate$aboveFloor*` in one place and `Gate$aboveFloor` in another,
                    // and an argument check between the two reported "2 levels of pointer too few".
                    factory->returnType.pointerDepth = 1;
                    factory->body.loc = cmd->loc;
                    auto build = std::make_unique<ast::NewExpr>();
                    build->loc = cmd->loc;
                    build->className = cls;
                    build->location = "heap";
                    build->locationWritten = true;
                    for (const ast::Param& p : cmd->carries) {
                        auto a = std::make_unique<ast::IdentifierExpr>();
                        a->name = p.name;
                        a->loc = cmd->loc;
                        build->args.push_back(std::move(a));
                    }
                    auto rs = std::make_unique<ast::ReturnStmt>();
                    rs->value = std::move(build);
                    rs->loc = cmd->loc;
                    factory->body.statements.push_back(std::move(rs));
                    m = std::move(factory);
                }
            }
            /* `methodref cat.speak` -- A RECEIVER BOUND TO A METHOD, which is a command carrying one
               thing. So it becomes one, the same way everything else here does:

                   public class Animal$bound$speak {
                       private mutable Animal* self;
                       public constructor Animal$bound$speak(Animal* self) { this.self = self; }
                       public method __command(int n) returns int { return this.self.speak(n); }
                   }

               The forwarding call inside is an ORDINARY call on an ordinary receiver, which is what
               keeps virtual dispatch: `methodref cat.speak` on an `Animal` holding a `Cat` runs
               `Cat.speak`, because the call in the body is resolved by the object the way every
               other call is. Nothing here has to know about overriding, and nothing can lose it.

               Generated per class that DECLARES a method of a name some `methodref` used -- a list
               the parser wrote down -- rather than per (class, method) pair in the program, which
               for a construct most programs never use would be an explosion. Which of them a given
               reference means is settled later, by the analyzer, where the receiver has a type. */
            for (ast::ClassDecl& c : ns.classes) {
                if (!c.typeParams.empty() || c.isInterface || c.isTransformer || c.isLayout) {
                    continue;   // a generic's binding would need type arguments nobody has yet
                }
                std::vector<ast::ClassDecl> bound;
                for (const ast::MemberPtr& m : c.members) {
                    const auto* target = dynamic_cast<const ast::MethodDecl*>(m.get());
                    if (target == nullptr || target->isStatic || target->isCommand ||
                        target->isProcedure || target->isAbstract ||
                        program.methodRefNames.count(target->name) == 0) {
                        continue;
                    }
                    ast::ClassDecl one;
                    one.name = c.name + "$bound$" + target->name;
                    one.visibility = "public";
                    one.loc = target->loc;

                    auto self = std::make_unique<ast::FieldDecl>();
                    self->loc = target->loc;
                    self->visibility = "private";
                    self->isMutable = true;
                    self->type.name = c.name;
                    self->type.isPointer = true;
                    self->type.pointerDepth = 1;
                    self->name = "self";
                    one.members.push_back(std::move(self));

                    auto ctor = std::make_unique<ast::ConstructorDecl>();
                    ctor->loc = target->loc;
                    ctor->visibility = "public";
                    ast::Param p;
                    p.loc = target->loc;
                    p.name = "self";
                    p.type.name = c.name;
                    p.type.isPointer = true;
                    p.type.pointerDepth = 1;
                    ctor->params.push_back(p);
                    ctor->body.loc = target->loc;
                    {
                        auto here = std::make_unique<ast::IdentifierExpr>();
                        here->name = "this";
                        here->loc = target->loc;
                        auto slot = std::make_unique<ast::MemberExpr>();
                        slot->object = std::move(here);
                        slot->member = "self";
                        slot->loc = target->loc;
                        auto from = std::make_unique<ast::IdentifierExpr>();
                        from->name = "self";
                        from->loc = target->loc;
                        auto as = std::make_unique<ast::AssignStmt>();
                        as->target = std::move(slot);
                        as->value = std::move(from);
                        as->loc = target->loc;
                        ctor->body.statements.push_back(std::move(as));
                    }
                    one.members.push_back(std::move(ctor));

                    auto run = std::make_unique<ast::MethodDecl>();
                    run->loc = target->loc;
                    run->visibility = "public";
                    run->name = kCommandMethod;
                    run->params = target->params;
                    run->returnType = target->returnType;
                    run->throwsTypes = target->throwsTypes;
                    run->body.loc = target->loc;
                    {
                        auto here = std::make_unique<ast::IdentifierExpr>();
                        here->name = "this";
                        here->loc = target->loc;
                        auto slot = std::make_unique<ast::MemberExpr>();
                        slot->object = std::move(here);
                        slot->member = "self";
                        slot->loc = target->loc;
                        auto callee = std::make_unique<ast::MemberExpr>();
                        callee->object = std::move(slot);
                        callee->member = target->name;
                        callee->loc = target->loc;
                        auto forward = std::make_unique<ast::CallExpr>();
                        forward->callee = std::move(callee);
                        forward->loc = target->loc;
                        for (const ast::Param& q : target->params) {
                            auto a = std::make_unique<ast::IdentifierExpr>();
                            a->name = q.name;
                            a->loc = target->loc;
                            forward->args.push_back(std::move(a));
                            forward->argNames.emplace_back();
                        }
                        if (canonicalType(target->returnType) == "void") {
                            auto st = std::make_unique<ast::ExprStmt>();
                            st->expr = std::move(forward);
                            st->loc = target->loc;
                            run->body.statements.push_back(std::move(st));
                            auto rs = std::make_unique<ast::ReturnStmt>();
                            rs->loc = target->loc;
                            run->body.statements.push_back(std::move(rs));
                        } else {
                            auto rs = std::make_unique<ast::ReturnStmt>();
                            rs->value = std::move(forward);
                            rs->loc = target->loc;
                            run->body.statements.push_back(std::move(rs));
                        }
                    }
                    std::vector<std::string> args;
                    for (const CommandRole& role : roles) {
                        if (!commandFitsRole(role, *run, args)) {
                            continue;
                        }
                        one.interfaces.push_back(role.name);
                        one.interfaceTypeArgs.push_back(args);
                        run->isOverride = true;
                    }
                    one.members.push_back(std::move(run));
                    bound.push_back(std::move(one));
                }
                for (ast::ClassDecl& one : bound) {
                    made.push_back(std::move(one));
                }
            }

            for (ast::ClassDecl& c : made) {
                ns.classes.push_back(std::move(c));
            }
        }
    }
}

bool expandDelegates(ast::Program& program) {
    bool ok = true;
    std::map<std::string, ast::ClassDecl*> index;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                index[c.name] = &c;
            }
        }
    }

    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                std::vector<const ast::FieldDecl*> delegates;
                bool classHasPersistent = false;
                std::set<std::string> defined;
                for (const ast::MemberPtr& m : c.members) {
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                        defined.insert(md->name);
                        continue;
                    }
                    const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get());
                    if (f == nullptr) {
                        continue;
                    }
                    if (f->isPersistent) {
                        classHasPersistent = true;
                    }
                    if (f->isDelegate) {
                        delegates.push_back(f);
                    }
                }
                if (delegates.empty()) {
                    continue;
                }

                for (const ast::FieldDecl* f : delegates) {
                    const size_t before = delegateErrorCount;
                    if (f->isStatic) {
                        delegateError(f->loc, "a `delegate` field cannot be static: forwarding a message "
                                              "needs a receiver, and a static field has no object to be "
                                              "the receiver of");
                    }
                    // A delegate that may be absent makes EVERY forwarded method conditionally broken,
                    // and the failure surfaces at the call, far from the field that caused it. Both
                    // spellings of "may be absent" are rejected for the same reason.
                    if (f->type.isNullable) {
                        delegateError(f->loc, "a `delegate` field cannot be `nullable`: every method "
                                              "forwarded to it would break when it is null, and the "
                                              "failure would surface at the call rather than here");
                    }
                    if (f->isWeak) {
                        delegateError(f->loc, "a `delegate` field cannot be `weak`: it is auto-nulled "
                                              "when its target dies, which silently empties every method "
                                              "this class implements through it");
                    }
                    // Persistence, decided with Joao: a persistent object that forwards into something
                    // that does not come back is reattached with its whole interface dead inside, and
                    // nothing at the failure says why. So the delegate travels with it, or it is not a
                    // delegate.
                    if (f->isTransient) {
                        delegateError(f->loc, "a `delegate` field cannot be `transient`: it would be "
                                              "absent after the object is reattached, leaving every "
                                              "method it implements with nothing to forward to");
                    }
                    // `eternal` alone does not discharge this: it means "as long as the program", and a
                    // persistent object is reattached in a LATER one. Only `persistent` crosses runs --
                    // and `eternal persistent` sets both, so the no-release-needed form still passes.
                    if (classHasPersistent && !f->isPersistent) {
                        delegateError(f->loc, "class '" + c.name + "' has a `persistent` field, so its "
                                              "`delegate` must be `persistent` too: the object survives "
                                              "the run and would come back forwarding into something "
                                              "that did not");
                    }
                    if (delegateErrorCount != before) {
                        ok = false;
                    }
                }
                std::vector<const ast::MethodDecl*> owed;
                std::set<std::string> answered;
                std::set<std::string> seenTypes;
                if (!c.superclass.empty()) {
                    collectObligations(c.superclass, index, owed, answered, seenTypes);
                }
                for (const std::string& iface : c.interfaces) {
                    collectObligations(iface, index, owed, answered, seenTypes);
                }
                if (owed.empty()) {
                    delegateError(delegates.front()->loc,
                                  "class '" + c.name + "' declares a `delegate` but owes no method: "
                                  "nothing it inherits is left unanswered, so there is nothing to "
                                  "forward");
                    ok = false;
                    continue;
                }

                std::vector<ast::MemberPtr> synthesized;
                std::set<std::string> done;
                for (const ast::MethodDecl* md : owed) {
                    // A method the class WRITES wins. That is the whole rule: the presence of a body is
                    // the statement of intent, so there is no list of exceptions to keep in sync.
                    if (defined.count(md->name) != 0 || answered.count(md->name) != 0) {
                        continue;
                    }
                    if (!done.insert(md->name).second) {
                        continue;
                    }
                    const ast::FieldDecl* provider = nullptr;
                    bool ambiguous = false;
                    for (const ast::FieldDecl* f : delegates) {
                        std::set<std::string> seen;
                        if (!typeAnswers(f->type.name, md->name, index, seen)) {
                            continue;
                        }
                        if (provider != nullptr) {
                            ambiguous = true;
                        } else {
                            provider = f;
                        }
                    }
                    if (ambiguous) {
                        delegateError(c.loc, "method '" + md->name + "' is answered by more than one "
                                             "`delegate` in class '" + c.name + "'; define it here to "
                                             "say which one wins");
                        ok = false;
                        continue;
                    }
                    if (provider == nullptr) {
                        delegateError(c.loc, "no `delegate` in class '" + c.name + "' answers method '" +
                                             md->name + "'; either define it here or delegate to "
                                             "something that has it");
                        ok = false;
                        continue;
                    }
                    synthesized.push_back(makeForwarder(*provider, *md));
                }
                for (ast::MemberPtr& m : synthesized) {
                    c.members.push_back(std::move(m));
                }
            }
        }
    }
    return ok;
}

}  // namespace polaron
