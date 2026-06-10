#include "semantic/analyzer.h"

#include <string>
#include <utility>
#include <vector>

namespace ldp3 {

namespace {
// Array types are spelled with a trailing "[]" in the analyzer (e.g. "int[]").
bool isArrayType(const std::string& t) {
    return t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0;
}
std::string elementOf(const std::string& t) {
    return isArrayType(t) ? t.substr(0, t.size() - 2) : t;
}
}  // namespace

void SemanticAnalyzer::error(std::string message, SourceLocation loc) {
    errors_.push_back(SemaError{std::move(message), loc});
}

const ClassInfo* SemanticAnalyzer::lookupClass(const std::string& name) const {
    auto it = classes_.find(name);
    return it == classes_.end() ? nullptr : &it->second;
}

const FieldInfo* SemanticAnalyzer::findField(const std::string& className,
                                             const std::string& field) const {
    const ClassInfo* c = lookupClass(className);
    while (c != nullptr) {
        auto it = c->fields.find(field);
        if (it != c->fields.end()) return &it->second;
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

const MethodInfo* SemanticAnalyzer::findMethod(const std::string& className,
                                               const std::string& method) const {
    const ClassInfo* c = lookupClass(className);
    while (c != nullptr) {
        auto it = c->methods.find(method);
        if (it != c->methods.end()) return &it->second;
        for (const std::string& iface : c->interfaces) {
            const MethodInfo* m = findMethod(iface, method);
            if (m != nullptr) return m;
        }
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

bool SemanticAnalyzer::isSubtype(const std::string& sub, const std::string& super) const {
    if (sub == super) return true;
    const ClassInfo* c = lookupClass(sub);
    if (c == nullptr) return false;
    if (!c->superclass.empty() && isSubtype(c->superclass, super)) return true;
    for (const std::string& iface : c->interfaces) {
        if (isSubtype(iface, super)) return true;
    }
    return false;
}

void SemanticAnalyzer::validateHierarchy() {
    for (const auto& [name, info] : classes_) {
        if (!info.superclass.empty()) {
            const ClassInfo* sup = lookupClass(info.superclass);
            if (sup == nullptr) {
                error("class '" + name + "' extends unknown type '" + info.superclass + "'", {});
            } else if (sup->isInterface) {
                error("class '" + name + "' extends interface '" + info.superclass +
                          "' (use 'implements')",
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
            if (c == nullptr) break;
            cur = c->superclass;
        }
    }
}

void SemanticAnalyzer::pushScope() { scopes_.emplace_back(); }

void SemanticAnalyzer::popScope() {
    if (!scopes_.empty()) scopes_.pop_back();
}

const LocalVar* SemanticAnalyzer::lookupLocal(const std::string& name) const {
    for (auto it = scopes_.rbegin(); it != scopes_.rend(); ++it) {
        auto found = it->find(name);
        if (found != it->end()) return &found->second;
    }
    return nullptr;
}

void SemanticAnalyzer::declareLocal(const std::string& name, LocalVar info) {
    scopes_.back()[name] = std::move(info);
}

bool SemanticAnalyzer::isValidMainSignature(const ast::MethodDecl& method) const {
    if (method.visibility != "public") return false;
    if (!method.isStatic) return false;
    if (method.params.size() != 1) return false;
    const ast::Param& p = method.params.front();
    if (p.type.name != "string" || !p.type.isArray) return false;
    if (method.returnType.isArray) return false;
    return method.returnType.name == "void" || method.returnType.name == "int";
}

// ---- Pass 1: collect every class's fields, methods and constructor. ----
void SemanticAnalyzer::registerClasses(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                if (classes_.count(cls.name) > 0) {
                    error("redeclaration of class '" + cls.name + "'", cls.loc);
                    continue;
                }
                ClassInfo info;
                info.name = cls.name;
                info.superclass = cls.superclass;
                info.interfaces = cls.interfaces;
                info.isAbstract = cls.isAbstract;
                info.isInterface = cls.isInterface;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        info.fields[f->name] =
                            FieldInfo{f->type.name + (f->type.isArray ? "[]" : ""), f->isMutable};
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        info.methods[m->name] =
                            MethodInfo{m->returnType.name, m->isStatic, m->isAbstract};
                    } else if (dynamic_cast<const ast::ConstructorDecl*>(member.get()) != nullptr) {
                        info.hasConstructor = true;
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) != nullptr) {
                        info.hasDestructor = true;
                    }
                }
                classes_[cls.name] = std::move(info);
            }
        }
    }
}

// ---- Pass 2: locate the single entry point (spec section 2.9). ----
void SemanticAnalyzer::findEntryPoint(const ast::Program& program) {
    std::vector<EntryPoint> candidates;
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.visibility != "public") continue;
        for (const ast::Namespace& ns : bundle.namespaces) {
            if (ns.visibility != "public") continue;
            for (const ast::ClassDecl& cls : ns.classes) {
                if (cls.visibility != "public" || cls.name != "Main") continue;
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* method = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (method == nullptr || method->name != "main") continue;
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
void SemanticAnalyzer::analyzeFieldInits(const ast::ClassDecl& cls) {
    scopes_.clear();
    currentClass_ = cls.name;
    pushScope();
    for (const ast::MemberPtr& member : cls.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
        if (f == nullptr || !f->init) continue;
        const std::string initType = typeOf(*f->init);
        if (!initType.empty() && initType != f->type.name) {
            error("cannot initialize field '" + f->name + "' of type '" + f->type.name +
                      "' with a value of type '" + initType + "'",
                  f->loc);
        }
    }
    popScope();
}

void SemanticAnalyzer::analyzeBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                analyzeFieldInits(cls);
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        analyzeMethodBody(m->body, m->params,
                                          m->isStatic ? std::string() : cls.name);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        analyzeMethodBody(c->body, c->params, cls.name);
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        analyzeMethodBody(d->body, {}, cls.name);
                    }
                }
            }
        }
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program) {
    registerClasses(program);
    validateHierarchy();
    findEntryPoint(program);
    analyzeBodies(program);
    return errors_.empty();
}

void SemanticAnalyzer::analyzeMethodBody(const ast::Block& body,
                                         const std::vector<ast::Param>& params,
                                         const std::string& thisClass) {
    scopes_.clear();
    currentClass_ = thisClass;
    pushScope();
    for (const ast::Param& p : params) {
        // params immutable by default
        declareLocal(p.name, LocalVar{p.type.name + (p.type.isArray ? "[]" : ""), false});
    }
    for (const auto& stmt : body.statements) {
        analyzeStatement(*stmt);
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

void SemanticAnalyzer::checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                                         SourceLocation loc) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error("assignment to undeclared variable '" + id->name + "'", loc);
            return;
        }
        if (!var->isMutable) {
            error("cannot assign to immutable variable '" + id->name + "' (declare it 'mutable')",
                  loc);
        }
        if (!valueType.empty() && !isSubtype(valueType, var->type)) {
            error("cannot assign a value of type '" + valueType + "' to variable '" + id->name +
                      "' of type '" + var->type + "'",
                  loc);
        }
        return;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return;
        const FieldInfo* f = findField(objType, mem->member);
        if (f == nullptr) {
            error("class '" + objType + "' has no field '" + mem->member + "'", loc);
            return;
        }
        if (!f->isMutable) {
            error("cannot assign to immutable field '" + mem->member + "' (declare it 'mutable')",
                  loc);
        }
        if (!valueType.empty() && !isSubtype(valueType, f->type)) {
            error("cannot assign a value of type '" + valueType + "' to field '" + mem->member +
                      "' of type '" + f->type + "'",
                  loc);
        }
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&target)) {
        const std::string at = typeOf(*ix->array);
        typeOf(*ix->index);
        if (!at.empty() && !isArrayType(at)) {
            error("cannot index a value of non-array type '" + at + "'", loc);
            return;
        }
        const std::string et = elementOf(at);
        if (!valueType.empty() && !et.empty() && valueType != et) {
            error("cannot assign a value of type '" + valueType +
                      "' to an array element of type '" + et + "'",
                  loc);
        }
        return;
    }
    error("invalid assignment target", loc);
}

void SemanticAnalyzer::checkIncDecTarget(const ast::Expr& target, SourceLocation loc) {
    std::string type;
    bool mutableTarget = false;
    bool resolved = false;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error("modification of undeclared variable '" + id->name + "'", loc);
            return;
        }
        type = var->type;
        mutableTarget = var->isMutable;
        resolved = true;
    } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return;
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
    if (!mutableTarget) error("cannot modify an immutable target (declare it 'mutable')", loc);
    if (type != "int") error("'++'/'--' requires an int target", loc);
}

void SemanticAnalyzer::analyzeStatement(const ast::Stmt& stmt) {
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
        const std::string initType = typeOf(*vd->init);
        const std::string declType =
            vd->isVar ? initType : (vd->type.name + (vd->type.isArray ? "[]" : ""));
        if (!vd->isVar && !initType.empty() && !isSubtype(initType, declType)) {
            error("cannot initialize variable '" + vd->name + "' of type '" + declType +
                      "' with a value of type '" + initType + "'",
                  vd->loc);
        }
        if (lookupLocal(vd->name) != nullptr) {
            error("redeclaration or shadowing of variable '" + vd->name + "'", vd->loc);
        } else {
            declareLocal(vd->name, LocalVar{declType.empty() ? std::string("int") : declType,
                                            vd->isMutable});
        }
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        const std::string vt = typeOf(*assign->value);
        checkAssignTarget(*assign->target, vt, assign->loc);
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        checkIncDecTarget(*incdec->target, incdec->loc);
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(&stmt)) {
        const std::string ct = typeOf(*ifs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'if' condition must be boolean, got '" + ct + "'", ifs->loc);
        }
        analyzeBlock(ifs->thenBlock);
        if (ifs->elseBlock) analyzeBlock(*ifs->elseBlock);
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&stmt)) {
        const std::string ct = typeOf(*ws->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'while' condition must be boolean, got '" + ct + "'", ws->loc);
        }
        analyzeBlock(ws->body);
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&stmt)) {
        pushScope();
        if (fs->init) analyzeStatement(*fs->init);
        const std::string ct = typeOf(*fs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'for' condition must be boolean, got '" + ct + "'", fs->loc);
        }
        if (fs->update) analyzeStatement(*fs->update);
        analyzeBlock(fs->body);
        popScope();
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
        typeOf(*es->expr);
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
        if (rs->value) typeOf(*rs->value);
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
        const std::string t = typeOf(*del->target);
        if (!t.empty() && lookupClass(t) == nullptr && !isArrayType(t)) {
            error("'delete' expects a heap object or array; got a value of type '" + t + "'",
                  del->loc);
        }
        return;
    }
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&expr) != nullptr) return "int";
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
    if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "string";
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";

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
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return "";
        }
        return var->type;
    }

    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (un->op == "!") {
            if (!t.empty() && t != "boolean") error("unary '!' requires a boolean operand", un->loc);
            return "boolean";
        }
        if (!t.empty() && t != "int") error("unary '" + un->op + "' requires an int operand", un->loc);
        return "int";
    }

    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        const std::string& op = bin->op;
        if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
            if ((!lt.empty() && lt != "int") || (!rt.empty() && rt != "int")) {
                error("operator '" + op + "' requires int operands", bin->loc);
            }
            return "int";
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            if ((!lt.empty() && lt != "int") || (!rt.empty() && rt != "int")) {
                error("operator '" + op + "' requires int operands", bin->loc);
            }
            return "boolean";
        }
        if (op == "==" || op == "!=") {
            if (!lt.empty() && !rt.empty() && lt != rt) {
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
        if (lookupClass(nw->className) == nullptr) {
            error("unknown class '" + nw->className + "'", nw->loc);
            return "";
        }
        if (nw->location != "stack" && nw->location != "heap") {
            error("'new' location must be 'stack' or 'heap', got '" + nw->location + "'", nw->loc);
        }
        for (const auto& arg : nw->args) typeOf(*arg);
        return nw->className;
    }

    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
        const std::string st = typeOf(*na->size);
        if (!st.empty() && st != "int") error("array size must be an int", na->loc);
        return na->elementType + "[]";
    }

    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        const std::string at = typeOf(*ix->array);
        const std::string it = typeOf(*ix->index);
        if (!it.empty() && it != "int") error("array index must be an int", ix->loc);
        if (at.empty()) return "";
        if (!isArrayType(at)) {
            error("cannot index a value of non-array type '" + at + "'", ix->loc);
            return "";
        }
        return elementOf(at);
    }

    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(&expr)) {
        for (const auto& e : is->exprs) {
            const std::string t = typeOf(*e);
            if (!t.empty() && t != "int" && t != "char" && t != "boolean") {
                error("string interpolation can only print int, char or boolean values, "
                      "got '" + t + "'",
                      e->loc);
            }
        }
        return "string";
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        const std::string name = flattenCallee(*call->callee);
        if (name == "System.IO.readInt") {
            if (!call->args.empty()) error("System.IO.readInt takes no arguments", call->loc);
            return "int";
        }
        if (name == "System.IO.printf" || name == "System.IO.println") {
            const bool isPrintln = (name == "System.IO.println");
            if (call->args.empty()) {
                // println() with no arguments prints just a newline; printf needs a format.
                if (!isPrintln) error("System.IO.printf requires a format string", call->loc);
            } else {
                const ast::Expr* first = call->args.front().get();
                const bool ok = dynamic_cast<const ast::StringLiteralExpr*>(first) != nullptr ||
                                dynamic_cast<const ast::InterpStringExpr*>(first) != nullptr;
                if (!ok) {
                    error(std::string("the first argument to System.IO.") +
                              (isPrintln ? "println" : "printf") +
                              " must be a string literal or interpolated string "
                              "(e.g. println($\"x = {value}\"))",
                          first->loc);
                }
            }
            for (const auto& arg : call->args) typeOf(*arg);
            return "void";
        }
        // Otherwise the callee should be a method: obj.method(...) or, when the
        // receiver names a class, a static call ClassName.method(...).
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(objId->name)) {
                        auto mit = sc->methods.find(mem->member);
                        if (mit == sc->methods.end()) {
                            error("class '" + objId->name + "' has no method '" + mem->member + "'",
                                  call->loc);
                            return "";
                        }
                        if (!mit->second.isStatic) {
                            error("method '" + mem->member + "' is not static; call it on an instance",
                                  call->loc);
                            return "";
                        }
                        for (const auto& arg : call->args) typeOf(*arg);
                        return mit->second.returnType;
                    }
                }
            }
            const std::string objType = typeOf(*mem->object);
            if (objType.empty()) return "";
            if (isArrayType(objType)) {
                if (mem->member == "length" && call->args.empty()) return "int";
                error("arrays only support .length(); '" + mem->member + "' is not a method",
                      call->loc);
                return "";
            }
            const MethodInfo* m = findMethod(objType, mem->member);
            if (m == nullptr) {
                error("class '" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            for (const auto& arg : call->args) typeOf(*arg);
            return m->returnType;
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call->loc);
        return "";
    }

    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return "";
        if (const FieldInfo* f = findField(objType, mem->member)) return f->type;
        error("class '" + objType + "' has no field '" + mem->member + "'", mem->loc);
        return "";
    }

    error("unsupported expression", expr.loc);
    return "";
}

std::string SemanticAnalyzer::flattenCallee(const ast::Expr& expr) const {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) return id->name;
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string base = flattenCallee(*mem->object);
        if (base.empty()) return "";
        return base + "." + mem->member;
    }
    return "";
}

}  // namespace ldp3
