// THE STRUCTURAL ADVICE THAT IS ABOUT A DECLARATION rather than about a statement.
//
// Every rule here has the same shape: a structure the compiler can see without guessing, a feature
// of the language that says the same thing shorter and checks more, and a gain that follows from
// the swap. Nothing infers intent. Where a shape is decidable but the reason for it is not, the rule
// still reports and `[Allow(code:, why:)]` is how the reason gets written down.
//
// The statement-level rules live beside the statements they read, in analyzer_stmt.cpp. The split is
// by what the rule LOOKS AT, not by what it is called, so a rule is always next to the thing it
// needs to understand.

#include "semantic/analyzer.h"
#include "semantic/semutil.h"

#include <algorithm>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace polaron {

using namespace semutil;   // NOLINT(google-build-using-namespace): as in analyzer.cpp

namespace {

// The Hungarian prefixes, and the type each one claims. A prefix that agrees with the resolved type
// is the whole test: `bFlag` on a boolean is the notation; `bytes` on an int is a word.
struct Hungarian {
    const char* prefix;
    const char* meaning;
};
constexpr Hungarian kHungarian[] = {
    {"b", "boolean"}, {"p", "a pointer"}, {"n", "an integer"},  {"dw", "an integer"},
    {"i", "an integer"}, {"str", "a string"}, {"sz", "a string"}, {"lst", "a collection"},
};

// `bFlag` -> prefix "b"; `bytes` -> nothing, because the character after the prefix must be an
// upper-case letter. That is what separates the notation from a word that starts the same way.
const Hungarian* hungarianPrefixOf(const std::string& name) {
    const Hungarian* best = nullptr;
    for (const Hungarian& h : kHungarian) {
        const std::size_t n = std::char_traits<char>::length(h.prefix);
        if (name.size() <= n || name.compare(0, n, h.prefix) != 0) {
            continue;
        }
        if (std::isupper(static_cast<unsigned char>(name[n])) == 0) {
            continue;
        }
        if (best == nullptr || n > std::char_traits<char>::length(best->prefix)) {
            best = &h;   // longest wins: `dwCount` is `dw`, not `d`
        }
    }
    return best;
}

bool typeAgreesWith(const std::string& type, const std::string& meaning) {
    const std::string base = baseType(type);
    if (meaning == "boolean") {
        return base == "boolean";
    }
    if (meaning == "a pointer") {
        return type.find('*') != std::string::npos;
    }
    if (meaning == "an integer") {
        return isIntName(base);
    }
    if (meaning == "a string") {
        return base == "String" || base == "string";
    }
    if (meaning == "a collection") {
        return type.find("[]") != std::string::npos || base.rfind("ArrayList", 0) == 0 ||
               base.rfind("HashMap", 0) == 0 || base.rfind("HashSet", 0) == 0;
    }
    return false;
}

// The longest prefix shared by every name in the group, cut at the last upper-case boundary so
// `MAX_SPEED`/`MAX_LOAD` share `MAX_` rather than `MAX_`+a stray letter.
std::string commonPrefix(const std::vector<std::string>& names) {
    if (names.size() < 2) {
        return {};
    }
    std::string p = names.front();
    for (const std::string& n : names) {
        std::size_t i = 0;
        while (i < p.size() && i < n.size() && p[i] == n[i]) {
            ++i;
        }
        p.resize(i);
    }
    const std::size_t cut = p.find_last_of('_');
    return cut == std::string::npos ? std::string() : p.substr(0, cut + 1);
}

}  // namespace

// AN APPROXIMATE LAYOUT, COMPUTED HERE RATHER THAN ASKED OF THE BACKEND.
//
// Three rules need to know how big a thing is and how it is aligned. The real answer lives in the
// code generator, which is the wrong place for advice to reach into -- and it does not need the real
// answer: it needs to know whether the declared order wastes a noticeable fraction, and whether a
// parameter is big. Both are decided by the same arithmetic every ABI on this target uses, so the
// numbers here are the machine's for every case these rules act on, and where they are not, they are
// wrong in the direction of saying nothing.
struct Extent {
    long long size = 0;
    long long align = 1;
};

namespace {

Extent primitiveExtent(const std::string& t) {
    if (t == "boolean" || t == "byte" || t == "int8" || t == "uint8") { return {1, 1}; }
    if (t == "short" || t == "int16" || t == "uint16") { return {2, 2}; }
    if (t == "int" || t == "int32" || t == "uint32" || t == "float" || t == "char") { return {4, 4}; }
    if (t == "long" || t == "int64" || t == "uint64" || t == "double") { return {8, 8}; }
    if (t == "vec2") { return {8, 8}; }
    if (t == "vec3" || t == "vec4") { return {16, 16}; }
    return {};
}

long long roundUp(long long n, long long to) {
    return to <= 1 ? n : ((n + to - 1) / to) * to;
}

}  // namespace

// The extent of a named type, resolving classes through `byName` up to a small depth: a cycle can
// only happen through a pointer, which stops the walk anyway.
static Extent extentOf(const std::string& type,
                       const std::unordered_map<std::string, const ast::ClassDecl*>& byName,
                       int depth);

static Extent aggregateExtent(const ast::ClassDecl& c,
                              const std::unordered_map<std::string, const ast::ClassDecl*>& byName,
                              int depth, bool widestFirst) {
    std::vector<Extent> parts;
    for (const ast::MemberPtr& mp : c.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get());
        if (f == nullptr || f->isStatic) {
            continue;
        }
        const Extent e = extentOf(typeRefStr(f->type), byName, depth + 1);
        if (e.size == 0) {
            return {};   // something unmeasurable: say nothing rather than guess
        }
        parts.push_back(e);
    }
    if (parts.empty()) {
        return {};
    }
    if (widestFirst) {
        std::sort(parts.begin(), parts.end(),
                  [](const Extent& a, const Extent& b) { return a.align > b.align; });
    }
    long long at = 0;
    long long worst = 1;
    for (const Extent& e : parts) {
        at = roundUp(at, e.align) + e.size;
        worst = std::max(worst, e.align);
    }
    return {roundUp(at, worst), worst};
}

static Extent extentOf(const std::string& type,
                       const std::unordered_map<std::string, const ast::ClassDecl*>& byName,
                       int depth) {
    const std::string base = baseType(type);
    if (type.find('*') != std::string::npos || isRefType(type) || isArrayType(type) ||
        isAddressName(base)) {
        return {8, 8};   // a pointer, whatever it points at
    }
    if (const Extent p = primitiveExtent(base); p.size != 0) {
        return p;
    }
    if (depth > 4) {
        return {};
    }
    auto it = byName.find(base);
    if (it == byName.end()) {
        return {};
    }
    // A class is reached by pointer; a struct or record is stored inline.
    if (!it->second->isStruct && !it->second->isRecord) {
        return {8, 8};
    }
    return aggregateExtent(*it->second, byName, depth, false);
}

// WHAT THE WHOLE PROGRAM DOES, gathered once.
//
// Several rules are about the difference between what a declaration promises and what anything
// actually does with it -- a field nobody reads, a public one only its own class writes, a
// `movable` never moved. Each would otherwise walk every body itself, so they share one pass.
//
// Approximate BY NAME, and deliberately in the safe direction: two classes with a field of the same
// name are treated as one, which makes a rule report LESS than it could and never more. Silence
// where a rule could have spoken is a missed opportunity; noise where it should not have is how a
// whole catalogue gets turned off.
struct ProgramUse {
    std::unordered_set<std::string> membersRead;      // any `x.name` that is not an assignment target
    std::unordered_set<std::string> membersWritten;   // any `x.name =`
    std::unordered_map<std::string, std::unordered_set<std::string>> writersOf;  // field -> classes
    std::unordered_set<std::string> methodsCalled;
    std::unordered_map<std::string, std::unordered_set<std::string>> typeSeenIn;  // type -> bundles
    std::unordered_set<std::string> movedTypes;       // declared types of things a `move` names
};

namespace {

void indexExpr(const ast::Expr* e, const std::string& bundle, ProgramUse& use,
               const std::unordered_map<std::string, std::string>& localTypes);

void indexMemberTarget(const ast::Expr* target, const std::string& cls, ProgramUse& use) {
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(target)) {
        use.membersWritten.insert(mem->member);
        use.writersOf[mem->member].insert(cls);
    }
}

void indexExpr(const ast::Expr* e, const std::string& bundle, ProgramUse& use,
               const std::unordered_map<std::string, std::string>& localTypes) {
    if (e == nullptr) {
        return;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(e)) {
        use.membersRead.insert(mem->member);
        indexExpr(mem->object.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(e)) {
        // Calls made BY THE PRELUDE do not count: it arrives with every program, so counting them
        // meant `receive` was always called somewhere and the channel-with-no-reader rule could
        // never fire on anybody's code. What a rule asks about is what the author wrote.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            mem != nullptr && bundle != "System") {
            use.methodsCalled.insert(mem->member);
        }
        indexExpr(call->callee.get(), bundle, use, localTypes);
        for (const ast::ExprPtr& a : call->args) {
            indexExpr(a.get(), bundle, use, localTypes);
        }
        return;
    }
    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(e)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mv->operand.get())) {
            if (auto it = localTypes.find(id->name); it != localTypes.end()) {
                use.movedTypes.insert(baseType(it->second));
            }
        }
        indexExpr(mv->operand.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* ne = dynamic_cast<const ast::NewExpr*>(e)) {
        use.typeSeenIn[ne->className].insert(bundle);
        for (const ast::ExprPtr& a : ne->args) {
            indexExpr(a.get(), bundle, use, localTypes);
        }
        return;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(e)) {
        indexExpr(bin->lhs.get(), bundle, use, localTypes);
        indexExpr(bin->rhs.get(), bundle, use, localTypes);
    } else if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(e)) {
        indexExpr(un->operand.get(), bundle, use, localTypes);
    } else if (const auto* cast = dynamic_cast<const ast::CastExpr*>(e)) {
        indexExpr(cast->operand.get(), bundle, use, localTypes);
    } else if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        indexExpr(ix->array.get(), bundle, use, localTypes);
        indexExpr(ix->index.get(), bundle, use, localTypes);
    } else if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(e)) {
        indexExpr(aw->operand.get(), bundle, use, localTypes);
    }
}

void indexBlock(const ast::Block& blk, const std::string& bundle, const std::string& cls,
                ProgramUse& use, std::unordered_map<std::string, std::string>& localTypes);

void indexStmt(const ast::Stmt& st, const std::string& bundle, const std::string& cls,
               ProgramUse& use, std::unordered_map<std::string, std::string>& localTypes) {
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&st)) {
        if (!vd->isVar) {
            const std::string t = typeRefStr(vd->type);
            localTypes[vd->name] = t;
            use.typeSeenIn[baseType(t)].insert(bundle);
        }
        indexExpr(vd->init.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(&st)) {
        indexMemberTarget(as->target.get(), cls, use);
        // The OBJECT of an assignment target is still read (`a.b.c = 1` reads `a.b`), but the field
        // being written is not: that is the whole distinction these two sets exist for.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(as->target.get())) {
            indexExpr(mem->object.get(), bundle, use, localTypes);
        } else {
            indexExpr(as->target.get(), bundle, use, localTypes);
        }
        indexExpr(as->value.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&st)) {
        indexExpr(es->expr.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&st)) {
        indexExpr(rs->value.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* iff = dynamic_cast<const ast::IfStmt*>(&st)) {
        indexExpr(iff->cond.get(), bundle, use, localTypes);
        indexBlock(iff->thenBlock, bundle, cls, use, localTypes);
        if (iff->elseBlock) {
            indexBlock(*iff->elseBlock, bundle, cls, use, localTypes);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&st)) {
        indexExpr(ws->cond.get(), bundle, use, localTypes);
        indexBlock(ws->body, bundle, cls, use, localTypes);
        return;
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&st)) {
        indexBlock(dw->body, bundle, cls, use, localTypes);
        indexExpr(dw->cond.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&st)) {
        if (fs->init) {
            indexStmt(*fs->init, bundle, cls, use, localTypes);
        }
        indexExpr(fs->cond.get(), bundle, use, localTypes);
        if (fs->update) {
            indexStmt(*fs->update, bundle, cls, use, localTypes);
        }
        indexBlock(fs->body, bundle, cls, use, localTypes);
        return;
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(&st)) {
        indexExpr(fe->iterable.get(), bundle, use, localTypes);
        indexBlock(fe->body, bundle, cls, use, localTypes);
        return;
    }
    if (const auto* ts = dynamic_cast<const ast::TryStmt*>(&st)) {
        indexBlock(ts->body, bundle, cls, use, localTypes);
        for (const ast::CatchClause& cc : ts->catches) {
            indexBlock(cc.body, bundle, cls, use, localTypes);
        }
        if (ts->finallyBlock) {
            indexBlock(*ts->finallyBlock, bundle, cls, use, localTypes);
        }
        return;
    }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&st)) {
        indexExpr(sy->mutex.get(), bundle, use, localTypes);
        indexBlock(sy->body, bundle, cls, use, localTypes);
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&st)) {
        indexExpr(del->target.get(), bundle, use, localTypes);
        return;
    }
    if (const auto* inc = dynamic_cast<const ast::IncDecStmt*>(&st)) {
        indexMemberTarget(inc->target.get(), cls, use);
        indexExpr(inc->target.get(), bundle, use, localTypes);
    }
}

void indexBlock(const ast::Block& blk, const std::string& bundle, const std::string& cls,
                ProgramUse& use, std::unordered_map<std::string, std::string>& localTypes) {
    for (const ast::StmtPtr& st : blk.statements) {
        if (st) {
            indexStmt(*st, bundle, cls, use, localTypes);
        }
    }
}

}  // namespace

void SemanticAnalyzer::adviseOnClass(const ast::ClassDecl& c) {
    // A class-shaped rule reads only the declaration, so all of them share one walk over the members
    // rather than each opening the list again.
    std::vector<const ast::MethodDecl*> methods;
    std::vector<const ast::FieldDecl*> fields;
    std::vector<const ast::ConstDecl*> constants;
    const ast::DestructorDecl* dtor = nullptr;
    for (const ast::MemberPtr& m : c.members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
            methods.push_back(md);
        } else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            fields.push_back(fd);
        } else if (const auto* cd = dynamic_cast<const ast::ConstDecl*>(m.get())) {
            constants.push_back(cd);
        } else if (const auto* dd = dynamic_cast<const ast::DestructorDecl*>(m.get())) {
            dtor = dd;
        }
    }
    pushAllows(c.annotations, {});

    // ---- a pointer field the destructor frees by hand is `unique` (catalogue 8) ----
    //
    // Writing `delete this.f` in a destructor is a claim: this object owns what `f` points at, and
    // nothing else will free it. The claim is true or the program double-frees, and today nothing
    // but discipline keeps it true -- a second field pointed at the same object, a copy handed out,
    // and the destructor runs twice on one allocation.
    if (dtor != nullptr) {
        std::unordered_set<std::string> freed;
        for (const ast::StmtPtr& st : dtor->body.statements) {
            const auto* del = dynamic_cast<const ast::DeleteStmt*>(st.get());
            if (del == nullptr) {
                continue;
            }
            // `this` is an ordinary identifier in this AST, not a node of its own.
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(del->target.get());
                mem != nullptr) {
                const auto* obj = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                if (obj != nullptr && obj->name == "this") {
                    freed.insert(mem->member);
                }
            }
        }
        for (const ast::FieldDecl* f : fields) {
            const std::string t = typeRefStr(f->type);
            if (freed.count(f->name) == 0 || f->isUnique || f->isWeak || isArrayType(t)) {
                continue;
            }
            if (t.find('*') == std::string::npos) {
                continue;   // only a pointer field carries an ownership question
            }
            warn(diag::Code::OwnershipByDiscipline,
                 "'" + c.name + "." + f->name + "' is freed by the destructor, which is a claim "
                 "about ownership the declaration does not make",
                 f->loc);
        }
    }

    // ---- the same condition guarding the start of several methods is an invariant (cat. 52) ----
    //
    // A condition checked at the top of method after method is a property of the OBJECT that each
    // method is re-establishing on its own. Written as an `invariant` it is checked at every entry
    // and every exit -- including the ones nobody remembered to guard -- and it is handed to the
    // optimiser as a fact rather than tested again.
    {
        std::unordered_map<std::string, int> guards;
        std::unordered_map<std::string, SourceLocation> firstGuard;
        for (const ast::MethodDecl* m : methods) {
            if (m->isStatic || m->body.statements.empty()) {
                continue;
            }
            const auto* iff = dynamic_cast<const ast::IfStmt*>(m->body.statements[0].get());
            if (iff == nullptr || iff->cond == nullptr) {
                continue;
            }
            // The condition has to MENTION `this`, or it is about the arguments rather than the
            // object, and an invariant is the wrong word for it.
            std::string text;
            iff->cond->dump(text, 0);
            if (text.find("this") == std::string::npos) {
                continue;
            }
            if (++guards[text] == 1) {
                firstGuard[text] = iff->loc;
            }
        }
        for (const auto& [text, count] : guards) {
            if (count >= 3) {
                warn(diag::Code::GuardThatIsAnInvariant,
                     std::to_string(count) +
                         " methods here open by checking the same thing about this object",
                     firstGuard[text]);
            }
        }
    }

    // ---- a bag of static methods is a transformer that has not been written (catalogue 19) ----
    //
    // Every member static, three or more of them, and no state: that is not an object, it is a
    // namespace with a class around it. A transformer says the same thing and says it better --
    // its procedures are expanded into the type that applies them, so they reach `itself` instead
    // of taking the subject as an argument, and they cost no call.
    if (!c.isInterface && !c.isAbstract && fields.empty() && methods.size() >= 3 &&
        std::all_of(methods.begin(), methods.end(),
                    [](const ast::MethodDecl* m) { return m->isStatic; })) {
        warn(diag::Code::StaticsWithoutState,
             "'" + c.name + "' is " + std::to_string(methods.size()) +
                 " static methods and no state, which is a namespace rather than a class",
             c.loc);
    }

    // ---- data with no behaviour is a record (catalogue 11) ----
    //
    // Public fields, no methods, no invariant: the class is a row. A `record` says that, and the
    // compiler then writes the equality, the hash and the copy that would otherwise be forgotten
    // or written three different ways.
    if (!c.isRecord && !c.isStruct && !c.isInterface && !c.isAbstract && !c.isUnion &&
        c.invariants.empty() && methods.empty() && fields.size() >= 2 &&
        std::all_of(fields.begin(), fields.end(), [](const ast::FieldDecl* f) {
            return f->visibility == "public" && !f->isStatic;
        })) {
        warn(diag::Code::DataWithoutBehaviour,
             "'" + c.name + "' is " + std::to_string(fields.size()) +
                 " public fields with no methods and no invariant",
             c.loc);
    }

    // ---- constants with a shared prefix are an enum (catalogue 12) ----
    //
    // Three or more `fixed int` constants whose names share a prefix are a set somebody is keeping
    // by hand: nothing stops two of them being equal, nothing makes a `match` over them complete,
    // and nothing stops an int that is none of them being passed where one is expected.
    {
        std::vector<std::string> names;
        SourceLocation first{};
        for (const ast::ConstDecl* k : constants) {
            if (!isIntName(baseType(typeRefStr(k->type)))) {
                continue;
            }
            if (names.empty()) {
                first = k->loc;
            }
            names.push_back(k->name);
        }
        if (names.size() >= 3) {
            if (const std::string p = commonPrefix(names); !p.empty()) {
                warn(diag::Code::ConstantsThatAreAnEnum,
                     std::to_string(names.size()) + " constants here share the prefix '" + p +
                         "', which is a set being kept by hand",
                     first);
            }
        }
    }

    // ---- a static method whose first parameter is its own class (catalogue 2) ----
    //
    // `Board.place(Board* b, int at)` is an instance method with the receiver written out. `this`
    // is not shorter typing: it is a receiver the alias analysis understands, it dispatches, and it
    // cannot be handed the wrong object of the right type.
    for (const ast::MethodDecl* m : methods) {
        if (!m->isStatic || m->params.empty()) {
            continue;
        }
        if (baseType(typeRefStr(m->params[0].type)) == c.name) {
            warn(diag::Code::StaticTakesItsOwnClass,
                 "'" + c.name + "." + m->name + "' is static and takes a '" + c.name +
                     "' as its first parameter, which is what a receiver is",
                 m->loc);
        }
    }

    // ---- a tag beside the fields it chooses between (catalogue 13) ----
    //
    // An enum field plus a crowd of others is almost always "which of these is meaningful". Nothing
    // says which go with which value, so every reader has to reconstruct the pairing from the code
    // that branches on the tag -- and every instance carries all of them, including the ones this
    // one's tag says are meaningless.
    {
        const ast::FieldDecl* tag = nullptr;
        int others = 0;
        for (const ast::FieldDecl* f : fields) {
            if (f->isStatic) {
                continue;
            }
            if (tag == nullptr && enums_.count(baseType(typeRefStr(f->type))) > 0) {
                tag = f;
            } else {
                ++others;
            }
        }
        if (tag != nullptr && others >= 4 && !c.isUnion) {
            warn(diag::Code::TagWithExclusiveFields,
                 "'" + c.name + "." + tag->name + "' is an enum beside " + std::to_string(others) +
                     " other fields, and nothing says which of them it chooses between",
                 tag->loc);
        }
    }

    // ---- a raw address kept in a field (catalogue 63) ----
    //
    // A field outlives the call that produced the value; a local does not. The binder proves
    // lifetimes on this side of a foreign boundary and nothing at all on the other, so a bare
    // address in a field is a lifetime with no proof behind it.
    for (const ast::FieldDecl* f : fields) {
        if (isAddressName(baseType(typeRefStr(f->type)))) {
            warn(diag::Code::ForeignAddressStored,
                 "'" + c.name + "." + f->name +
                     "' keeps a raw address, which outlives the call that produced it",
                 f->loc);
        }
    }

    // ---- a lock over one primitive is an atomic (catalogue 53) ----
    for (const ast::FieldDecl* f : fields) {
        const std::string t = baseType(typeRefStr(f->type));
        if (t.rfind("Mutex", 0) != 0) {
            continue;
        }
        const std::size_t lt = t.find('$');
        const std::string inner = lt == std::string::npos ? std::string() : t.substr(lt + 1);
        if (isIntName(inner) || inner == "boolean") {
            warn(diag::Code::MutexOverOnePrimitive,
                 "'" + c.name + "." + f->name + "' locks a single '" + inner + "'", f->loc);
        }
    }

    // ---- a `lazy` field the constructor reads (catalogue 58) ----
    //
    // `lazy` buys one thing: the cost is not paid unless somebody asks. Asking in the constructor
    // means everybody asks, always -- so what is left is the initialised-yet check, on every read,
    // for a value that was already there.
    for (const ast::MemberPtr& mp : c.members) {
        const auto* ctor = dynamic_cast<const ast::ConstructorDecl*>(mp.get());
        if (ctor == nullptr) {
            continue;
        }
        // Asked through the index rather than by searching the dumped text: `dump` writes
        // `Member '.table'` on its own line with the object underneath, so `this.table` never
        // appears as a contiguous string and the text search silently found nothing, ever.
        ProgramUse inCtor;
        std::unordered_map<std::string, std::string> ctorLocals;
        indexBlock(ctor->body, currentBundle_, c.name, inCtor, ctorLocals);
        for (const ast::FieldDecl* f : fields) {
            if (f->isLazy && inCtor.membersRead.count(f->name) > 0) {
                warn(diag::Code::LazyAlwaysNeeded,
                     "'" + c.name + "." + f->name +
                         "' is lazy and the constructor reads it, so it is never deferred",
                     f->loc);
            }
        }
    }

    // ---- two parameters of one primitive, in a row (catalogue 15) ----
    //
    // `place(int x, int y)` is fine because the pair is the concept. `move(int from, int to)` is not:
    // the two are different things wearing one type, and the compiler will accept them in either
    // order for as long as the program exists. Three or more of one primitive is where the odds stop
    // being on the author's side.
    for (const ast::MethodDecl* m : methods) {
        std::unordered_map<std::string, int> byType;
        for (const ast::Param& p : m->params) {
            const std::string t = typeRefStr(p.type);
            if (isIntName(baseType(t)) || baseType(t) == "boolean") {
                ++byType[baseType(t)];
            }
        }
        for (const auto& [t, n] : byType) {
            if (n >= 3) {
                warn(diag::Code::PrimitiveObsession,
                     "'" + m->name + "' takes " + std::to_string(n) + " parameters of type '" + t +
                         "', which the compiler will accept in any order",
                     m->loc);
            }
        }
    }

    // ---- parallel static arrays are a table with no type (catalogue 16) ----
    //
    // Three or more static arrays in one class, read by the same index, are one row spread sideways.
    // Nothing keeps them the same length, nothing keeps a row complete, and a row added to one and
    // forgotten in the others reads as a zero -- which is a value, so nothing complains.
    {
        int columns = 0;
        SourceLocation first{};
        for (const ast::FieldDecl* f : fields) {
            if (f->isStatic && isArrayType(typeRefStr(f->type))) {
                if (columns == 0) {
                    first = f->loc;
                }
                ++columns;
            }
        }
        if (columns >= 3) {
            warn(diag::Code::ParallelArrayTable,
                 std::to_string(columns) +
                     " static arrays here are one row read sideways, and nothing keeps them in step",
                 first);
        }
    }

    // ---- `toX`/`fromX` pairs are a transformer (catalogue 20) ----
    //
    // A pair of hand-written conversions is a relation between two types kept in two places. A
    // `transformer` declares the relation once; the compiler expands it into both sides, checks with
    // `entrusts` that the assembly is complete field by field, and -- with `collective` -- completes
    // the graph so N types cost N edges rather than N squared.
    {
        std::unordered_set<std::string> tos;
        std::unordered_set<std::string> froms;
        for (const ast::MethodDecl* m : methods) {
            if (m->name.rfind("to", 0) == 0 && m->name.size() > 2 &&
                std::isupper(static_cast<unsigned char>(m->name[2])) != 0) {
                tos.insert(m->name.substr(2));
            } else if (m->name.rfind("from", 0) == 0 && m->name.size() > 4 &&
                       std::isupper(static_cast<unsigned char>(m->name[4])) != 0) {
                froms.insert(m->name.substr(4));
            }
        }
        for (const std::string& other : tos) {
            if (froms.count(other) > 0) {
                warn(diag::Code::HandWrittenConversionPair,
                     "'" + c.name + "' converts to and from '" + other +
                         "' by hand, which is a relation kept in two places",
                     c.loc);
            }
        }
    }

    // ---- Hungarian notation (catalogue 1) ----
    //
    // A prefix that agrees with the resolved type is a type written twice: once where the compiler
    // checks it and once where nothing does. The second copy is the one that survives a change of
    // type, and then it is a lie in the name.
    auto checkName = [&](const std::string& name, const std::string& type, SourceLocation loc) {
        const Hungarian* h = hungarianPrefixOf(name);
        if (h != nullptr && typeAgreesWith(type, h->meaning)) {
            warn(diag::Code::HungarianNotation,
                 "'" + name + "' spells " + std::string(h->meaning) + " in its prefix, which is what "
                 "its type already says",
                 loc);
        }
    };
    for (const ast::FieldDecl* f : fields) {
        checkName(f->name, typeRefStr(f->type), f->loc);
    }
    for (const ast::MethodDecl* m : methods) {
        for (const ast::Param& p : m->params) {
            checkName(p.name, typeRefStr(p.type), p.loc);
        }
    }

    popAllows();
}

void SemanticAnalyzer::adviseOnDeclarations(const ast::Program& program) {
    const std::string savedNs = currentNamespace_;
    const std::string savedBundle = currentBundle_;

    // THE TWO RULES THAT NEED THE WHOLE PROGRAM, so the subtype map is built once, first. Both are
    // about a set of subtypes the compiler can already see and the declaration has not admitted to.
    std::unordered_map<std::string, std::vector<const ast::ClassDecl*>> children;
    std::vector<const ast::ClassDecl*> all;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                all.push_back(&c);
                if (!c.superclass.empty()) {
                    children[baseType(c.superclass)].push_back(&c);
                }
            }
        }
    }
    // What anything actually DOES with these declarations, gathered in one pass.
    ProgramUse use;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                std::unordered_map<std::string, std::string> locals;
                for (const ast::MemberPtr& mp : c.members) {
                    if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
                        use.typeSeenIn[baseType(typeRefStr(fd->type))].insert(bundle.name);
                    } else if (const auto* md = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                        use.typeSeenIn[baseType(typeRefStr(md->returnType))].insert(bundle.name);
                        for (const ast::Param& p : md->params) {
                            const std::string t = typeRefStr(p.type);
                            use.typeSeenIn[baseType(t)].insert(bundle.name);
                            locals[p.name] = t;
                        }
                        indexBlock(md->body, bundle.name, c.name, use, locals);
                    } else if (const auto* cd = dynamic_cast<const ast::ConstructorDecl*>(mp.get())) {
                        for (const ast::Param& p : cd->params) {
                            locals[p.name] = typeRefStr(p.type);
                        }
                        indexBlock(cd->body, bundle.name, c.name, use, locals);
                    } else if (const auto* dd = dynamic_cast<const ast::DestructorDecl*>(mp.get())) {
                        indexBlock(dd->body, bundle.name, c.name, use, locals);
                    }
                }
            }
        }
    }

    // ---- what nothing does with a declaration ----
    // DISTINCT NAMES, not entries: a program of two hundred files declaring `public bundle Agents`
    // has two hundred `Bundle` nodes and one bundle. Counting entries made a single-bundle program
    // look like two hundred, which fired the public-with-no-outside-use rule on every public type
    // in the game -- ninety-nine of them.
    std::unordered_set<std::string> authored;
    for (const ast::Bundle& b : program.bundles) {
        if (b.name != "System") {
            authored.insert(b.name);
        }
    }
    const std::size_t authoredBundles = authored.size();
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                pushAllows(c.annotations, {});

                // A `movable` or `partitionable` that nothing ever moves or partitions (cat. 36/37).
                // The discipline costs every assignment an explicit `move` and every reader the
                // question of where the transfer happens; when there is no transfer, that is paid
                // for nothing and the word says something untrue about the type.
                if ((c.isMovable || c.isPartitionable) && use.movedTypes.count(c.name) == 0) {
                    warn(diag::Code::DisciplineNeverExercised,
                         "'" + c.name + "' is declared " +
                             std::string(c.isMovable ? "movable" : "partitionable") +
                             " and nothing in this program ever moves one",
                         c.loc);
                }

                // A public type nobody outside its bundle mentions (catalogue 32).
                //
                // Only where there IS an outside. In a program of one bundle every public type
                // trivially qualifies, and a rule that fires on everything says nothing -- which is
                // how a whole catalogue gets switched off. Monomorphized instances are skipped for
                // the same reason: `Chain$AgentId` is the compiler's name, not anybody's decision.
                //
                // `System` does not count towards "more than one bundle": the prelude arrives with
                // every program, so counting it made every single-bundle program look like two and
                // fired this on all ninety-nine of the game's public types.
                if (c.visibility == "public" && !c.isInterface && authoredBundles > 1 &&
                    c.name.find('$') == std::string::npos) {
                    auto seen = use.typeSeenIn.find(c.name);
                    const bool onlyHere = seen == use.typeSeenIn.end() ||
                                          (seen->second.size() == 1 &&
                                           seen->second.count(bundle.name) > 0);
                    if (onlyHere && bundle.name != "System") {
                        warn(diag::Code::PublicWithNoOutsideUse,
                             "'" + c.name + "' is public and nothing outside bundle '" +
                                 bundle.name + "' mentions it",
                             c.loc);
                    }
                }

                // An interface used as a label rather than as a type (catalogue 18). Nothing holds
                // one, so no call through it is ever polymorphic: it costs a vtable and an indirect
                // call to express a naming convention.
                if (c.isInterface && use.typeSeenIn.count(c.name) == 0) {
                    warn(diag::Code::InterfaceNeverPolymorphic,
                         "nothing in this program holds a '" + c.name +
                             "', so no call through it is ever polymorphic",
                         c.loc);
                }

                for (const ast::MemberPtr& mp : c.members) {
                    const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get());
                    if (f == nullptr || f->isStatic) {
                        continue;
                    }
                    // A channel nothing ever takes from (catalogue 57). Every send either blocks
                    // forever once the buffer fills or is thrown away, and the work that produced
                    // the value was done for nobody.
                    if (baseType(typeRefStr(f->type)).rfind("Channel", 0) == 0 &&
                        use.methodsCalled.count("receive") == 0) {
                        warn(diag::Code::ChannelNeverConsumed,
                             "'" + c.name + "." + f->name +
                                 "' is a channel and nothing in this program ever receives from one",
                             f->loc);
                    }
                    // A field nothing reads (catalogue 64). It is written, carried in every
                    // instance, copied by every copy, and never asked about.
                    if (use.membersRead.count(f->name) == 0) {
                        warn(diag::Code::FieldNeverRead,
                             "nothing reads '" + c.name + "." + f->name + "'", f->loc);
                        continue;
                    }
                    // A public field only its own class writes (catalogue 31). Visibility is not
                    // only style here: what is reachable from outside is what the escape analysis
                    // has to assume can change, so the narrower declaration is the stronger fact.
                    if (f->visibility == "public") {
                        auto writers = use.writersOf.find(f->name);
                        if (writers != use.writersOf.end() && writers->second.size() == 1 &&
                            writers->second.count(c.name) > 0) {
                            warn(diag::Code::PublicWrittenOnlyInside,
                                 "'" + c.name + "." + f->name +
                                     "' is public and only '" + c.name + "' ever writes it",
                                 f->loc);
                        }
                    }
                }
                popAllows();
            }
        }
    }

    // ---- what the declared field order costs, and what a big value costs to pass ----
    std::unordered_map<std::string, const ast::ClassDecl*> byName;
    for (const ast::ClassDecl* c : all) {
        byName[c->name] = c;
    }
    for (const ast::ClassDecl* c : all) {
        if (!c->isStruct && !c->isRecord) {
            continue;   // only an inline aggregate has a layout the author's order decides
        }
        pushAllows(c->annotations, {});
        // Padding the declared order costs (catalogue 27). A `layout` authorises the compiler to
        // order the fields widest-first; without one, the order written is the order used, and the
        // holes between differently-sized fields are carried in every instance.
        const Extent asWritten = aggregateExtent(*c, byName, 0, false);
        const Extent packed = aggregateExtent(*c, byName, 0, true);
        if (asWritten.size > 0 && packed.size > 0 && c->layouts.empty() &&
            asWritten.size >= packed.size + std::max<long long>(2, packed.size / 8)) {
            warn(diag::Code::PaddingFromFieldOrder,
                 "'" + c->name + "' is " + std::to_string(asWritten.size) +
                     " bytes as written and " + std::to_string(packed.size) + " widest-first",
                 c->loc);
        }
        popAllows();
    }
    for (const ast::ClassDecl* c : all) {
        pushAllows(c->annotations, {});
        for (const ast::MemberPtr& mp : c->members) {
            const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get());
            if (m == nullptr) {
                continue;
            }
            // The members the COMPILER writes for a value aggregate are not the author's decision,
            // so advice about their signatures is advice nobody can act on. A struct gets these
            // three for free, and the by-value rule fired on all of them before this line.
            if (m->name == "equalsKey" || m->name == "hashCode" || m->name == "compareTo" ||
                m->name == "toString" || m->name == "equals") {
                continue;
            }
            for (const ast::Param& p : m->params) {
                const std::string t = typeRefStr(p.type);
                if (t.find('*') != std::string::npos || isRefType(t) || isArrayType(t)) {
                    continue;
                }
                auto it = byName.find(baseType(t));
                if (it == byName.end() || (!it->second->isStruct && !it->second->isRecord)) {
                    continue;
                }
                // A big value copied at every call (catalogue 34). The threshold is a cache line:
                // below it the copy is one or two moves, above it the call is doing memcpy work
                // nobody asked for, per call, per argument.
                if (const Extent e = extentOf(t, byName, 0); e.size >= 64) {
                    warn(diag::Code::LargeValueByValue,
                         "'" + m->name + "' takes '" + p.name + "' by value, and a '" +
                             baseType(t) + "' is about " + std::to_string(e.size) + " bytes",
                         p.loc);
                }
            }
        }
        popAllows();
    }

    // ---- an override whose body is the base's body, word for word (catalogue 59) ----
    //
    // The catalogue writes this as "an override that only calls super", and that shape cannot be
    // written here: `super` is legal only as `super(...)` in a constructor. What CAN be written --
    // and is what the rule is really about -- is an override that repeats what it overrides. The
    // dumped body is structural, so comparing two of them answers exactly that question.
    for (const ast::ClassDecl* c : all) {
        if (c->superclass.empty()) {
            continue;
        }
        auto base = byName.find(baseType(c->superclass));
        if (base == byName.end()) {
            continue;
        }
        pushAllows(c->annotations, {});
        for (const ast::MemberPtr& mp : c->members) {
            const auto* over = dynamic_cast<const ast::MethodDecl*>(mp.get());
            if (over == nullptr || !over->isOverride || over->body.statements.empty()) {
                continue;
            }
            for (const ast::MemberPtr& bp : base->second->members) {
                const auto* orig = dynamic_cast<const ast::MethodDecl*>(bp.get());
                if (orig == nullptr || orig->name != over->name) {
                    continue;
                }
                std::string a;
                std::string b;
                for (const ast::StmtPtr& st : over->body.statements) { st->dump(a, 0); }
                for (const ast::StmtPtr& st : orig->body.statements) { st->dump(b, 0); }
                if (!a.empty() && a == b) {
                    warn(diag::Code::OverrideRepeatsTheBase,
                         "'" + c->name + "." + over->name +
                             "' overrides '" + base->second->name + "." + orig->name +
                             "' with the same body",
                         over->loc);
                }
                break;
            }
        }
        popAllows();
    }

    // ---- the same guard before every call to one method (catalogue 26) ----
    //
    // A condition checked at each call site is a precondition living everywhere except where it can
    // be enforced. The call site that forgets it is the one nobody writes down, and the method it
    // calls has no way to notice.
    {
        struct GuardSite {
            std::string callee;
            std::string shape;
            SourceLocation loc;
        };
        std::vector<GuardSite> sites;
        std::function<void(const ast::Block&)> scan = [&](const ast::Block& blk) {
            // BOTH SHAPES A GUARDED CALL TAKES: `if (bad) { return; } foo(x);` where the call
            // follows the guard, and `if (ok) { foo(x); }` where it is inside it. The second is the
            // commoner of the two and the first version of this rule could not see it at all.
            auto note = [&](const ast::IfStmt* guard, const ast::Stmt* callStmt) {
                const auto* es = dynamic_cast<const ast::ExprStmt*>(callStmt);
                const auto* call =
                    es != nullptr ? dynamic_cast<const ast::CallExpr*>(es->expr.get()) : nullptr;
                const auto* mem =
                    call != nullptr ? dynamic_cast<const ast::MemberExpr*>(call->callee.get())
                                    : nullptr;
                if (mem == nullptr || guard->cond == nullptr) {
                    return;
                }
                std::string shape;
                guard->cond->dump(shape, 0);
                sites.push_back(GuardSite{mem->member, shape, guard->loc});
            };
            for (std::size_t i = 0; i < blk.statements.size(); ++i) {
                const auto* guard = dynamic_cast<const ast::IfStmt*>(blk.statements[i].get());
                if (guard == nullptr) {
                    continue;
                }
                if (guard->thenBlock.statements.size() == 1) {
                    note(guard, guard->thenBlock.statements[0].get());
                }
                if (i + 1 < blk.statements.size()) {
                    note(guard, blk.statements[i + 1].get());
                }
            }
            for (const ast::StmtPtr& st : blk.statements) {
                if (const auto* iff = dynamic_cast<const ast::IfStmt*>(st.get())) {
                    scan(iff->thenBlock);
                    if (iff->elseBlock) {
                        scan(*iff->elseBlock);
                    }
                }
            }
        };
        for (const ast::ClassDecl* c : all) {
            for (const ast::MemberPtr& mp : c->members) {
                if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                    scan(m->body);
                }
            }
        }
        std::unordered_map<std::string, int> seen;
        std::unordered_map<std::string, SourceLocation> first;
        std::unordered_map<std::string, std::string> callee;
        for (const GuardSite& s : sites) {
            const std::string key = s.callee + "\n" + s.shape;
            if (++seen[key] == 1) {
                first[key] = s.loc;
                callee[key] = s.callee;
            }
        }
        for (const auto& [key, n] : seen) {
            if (n >= 2) {
                warn(diag::Code::SameGuardAtEveryCallSite,
                     std::to_string(n) + " call sites of '" + callee[key] +
                         "' check the same thing before calling it",
                     first[key]);
            }
        }
    }

    // ---- an argument the callee keeps, that the caller never looks at again (catalogue 42) ----
    //
    // The catalogue writes this about a `keep` argument, and `keep` is not a word in this language.
    // What it describes exists anyway, and the compiler already computes it: a method's escape
    // summary says which parameters it stores. When the caller hands one over and never reads the
    // variable again, the copy it is still holding is a lifetime extended for nobody.
    {
        std::unordered_map<std::string, std::unordered_set<int>> keeps;
        for (const ast::ClassDecl* c : all) {
            for (const ast::MemberPtr& mp : c->members) {
                const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get());
                if (m == nullptr) {
                    continue;
                }
                for (const auto& [param, slot] : m->escapeSummary) {
                    if (slot == -1 && param >= 0) {
                        keeps[m->name].insert(param);
                    }
                }
            }
        }
        if (!keeps.empty()) {
            for (const ast::ClassDecl* c : all) {
                pushAllows(c->annotations, {});
                for (const ast::MemberPtr& mp : c->members) {
                    const auto* caller = dynamic_cast<const ast::MethodDecl*>(mp.get());
                    if (caller == nullptr) {
                        continue;
                    }
                    for (std::size_t i = 0; i < caller->body.statements.size(); ++i) {
                        const auto* es =
                            dynamic_cast<const ast::ExprStmt*>(caller->body.statements[i].get());
                        const auto* call =
                            es != nullptr ? dynamic_cast<const ast::CallExpr*>(es->expr.get())
                                          : nullptr;
                        const auto* mem =
                            call != nullptr
                                ? dynamic_cast<const ast::MemberExpr*>(call->callee.get())
                                : nullptr;
                        if (mem == nullptr || keeps.count(mem->member) == 0) {
                            continue;
                        }
                        for (int idx : keeps[mem->member]) {
                            if (idx >= static_cast<int>(call->args.size())) {
                                continue;
                            }
                            const auto* id = dynamic_cast<const ast::IdentifierExpr*>(
                                call->args[static_cast<std::size_t>(idx)].get());
                            if (id == nullptr) {
                                continue;
                            }
                            bool readAgain = false;
                            for (std::size_t j = i + 1; j < caller->body.statements.size(); ++j) {
                                std::string text;
                                caller->body.statements[j]->dump(text, 0);
                                if (text.find("'" + id->name + "'") != std::string::npos) {
                                    readAgain = true;
                                    break;
                                }
                            }
                            if (!readAgain) {
                                warn(diag::Code::KeptArgumentNeverReused,
                                     "'" + mem->member + "' keeps '" + id->name +
                                         "', and nothing here reads it again",
                                     es->loc);
                            }
                        }
                    }
                }
                popAllows();
            }
        }
    }

    // ---- a pointer back to the owner is a cycle (catalogue 9) ----
    //
    // A owns a B and the B points back at the A. Neither side says which is the owner, so a cascade
    // walks it twice, a reference count never reaches zero, and the destructor order is whichever
    // one happens to be destroyed first.
    for (const ast::ClassDecl* a : all) {
        for (const ast::MemberPtr& mp : a->members) {
            const auto* fa = dynamic_cast<const ast::FieldDecl*>(mp.get());
            if (fa == nullptr || fa->isWeak) {
                continue;
            }
            const std::string bName = baseType(typeRefStr(fa->type));
            if (typeRefStr(fa->type).find('*') == std::string::npos || bName == a->name) {
                continue;
            }
            const auto* b = std::find_if(all.begin(), all.end(), [&](const ast::ClassDecl* x) {
                                return x->name == bName;
                            }) != all.end()
                                ? *std::find_if(all.begin(), all.end(),
                                                [&](const ast::ClassDecl* x) { return x->name == bName; })
                                : nullptr;
            if (b == nullptr) {
                continue;
            }
            for (const ast::MemberPtr& mq : b->members) {
                const auto* fb = dynamic_cast<const ast::FieldDecl*>(mq.get());
                if (fb == nullptr || fb->isWeak) {
                    continue;
                }
                if (baseType(typeRefStr(fb->type)) == a->name &&
                    typeRefStr(fb->type).find('*') != std::string::npos) {
                    pushAllows(a->annotations, {});
                    warn(diag::Code::OwnershipCycle,
                         "'" + a->name + "." + fa->name + "' and '" + b->name + "." + fb->name +
                             "' point at each other, and neither says which one owns the other",
                         fa->loc);
                    popAllows();
                    break;
                }
            }
        }
    }

    for (const ast::ClassDecl* c : all) {
        auto kids = children.find(c->name);
        if (kids == children.end() || kids->second.empty()) {
            continue;
        }
        pushAllows(c->annotations, {});
        // ---- a closed hierarchy that has not said so (catalogue 21) ----
        //
        // Every subtype is right here, in this program, and the base does not say so. Saying it with
        // `sealed ... permits` is what lets a `match` be checked for completeness and lets a call
        // through the base be resolved rather than dispatched -- and it turns the arrival of a
        // subtype nobody planned for into a compile error rather than a surprise at run time.
        if (!c->isSealed && !c->isFinal && !c->isInterface) {
            std::string names;
            for (const ast::ClassDecl* k : kids->second) {
                names += (names.empty() ? "" : ", ") + k->name;
            }
            warn(diag::Code::HierarchyNotSealed,
                 "'" + c->name + "' is extended only by " + names +
                     ", and every one of them is in this program",
                 c->loc);
        }
        // ---- an abstract class with exactly one subtype (catalogue 60) ----
        //
        // Two types describing one thing. The base cannot be instantiated and the subtype is the
        // only way to get one, so the split buys no polymorphism -- it costs a vtable, an indirect
        // call the compiler cannot see through, and a reader two files to hold at once.
        if (c->isAbstract && kids->second.size() == 1) {
            warn(diag::Code::AbstractWithOneSubtype,
                 "'" + c->name + "' is abstract and '" + kids->second.front()->name +
                     "' is its only subtype",
                 c->loc);
        }
        popAllows();
    }

    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& c : ns.classes) {
                adviseOnClass(c);
            }
        }
    }
    currentNamespace_ = savedNs;
    currentBundle_ = savedBundle;
}

}  // namespace polaron
