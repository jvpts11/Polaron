#include "semantic/analyzer.h"

#include <algorithm>
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
// Pointer/reference types end with '*' or '&' (e.g. "Dog*", "Dog&").
bool isRefType(const std::string& t) {
    return !t.empty() && (t.back() == '*' || t.back() == '&');
}
std::string baseType(const std::string& t) {
    return isRefType(t) ? t.substr(0, t.size() - 1) : t;
}
std::string typeRefStr(const ast::TypeRef& t) {
    return ast::mangleGeneric(t.name, t.typeArgs) + (t.isArray ? "[]" : "") +
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "");
}
bool isFloatType(const std::string& t) {
    return t == "float" || t == "float32" || t == "double" || t == "float64";
}
bool isIntName(const std::string& t) {
    return t == "int" || t == "int8" || t == "int16" || t == "int32" || t == "int64" ||
           t == "uint8" || t == "uint16" || t == "uint32" || t == "uint64" || t == "short" ||
           t == "long" || t == "byte";
}
unsigned intBits(const std::string& t) {
    if (t == "int8" || t == "uint8" || t == "byte") return 8;
    if (t == "int16" || t == "uint16" || t == "short") return 16;
    if (t == "int64" || t == "uint64" || t == "long") return 64;
    return 32;
}
bool isNumeric(const std::string& t) { return isIntName(t) || isFloatType(t); }
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
    const ClassInfo* c = lookupClass(baseType(className));  // see through T* / T&
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
    const ClassInfo* c = lookupClass(baseType(className));  // see through T* / T&
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
    // int and float both widen to a float type (no implicit narrowing).
    if (isFloatType(super) && isNumeric(sub)) return true;
    // Integers widen to a wider integer (no implicit narrowing).
    if (isIntName(sub) && isIntName(super)) return intBits(sub) <= intBits(super);
    // Pointer/reference compatibility follows the pointee (T*, T& and T mix
    // freely for now; the strict value-vs-reference rules land with deep copy).
    if (isRefType(sub) || isRefType(super)) return isSubtype(baseType(sub), baseType(super));
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
            } else if (sup->isStruct) {
                error("class '" + name + "' extends struct '" + info.superclass +
                          "' (structs have no inheritance)",
                      {});
            } else if (sup->isSealed &&
                       std::find(sup->permits.begin(), sup->permits.end(), name) ==
                           sup->permits.end()) {
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
            if (c == nullptr) break;
            cur = c->superclass;
        }
    }
}

void SemanticAnalyzer::collectMethodNamesInto(const std::string& className,
                                              std::vector<std::string>& out) const {
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) return;
    for (const auto& [mname, mi] : c->methods) {
        (void)mi;
        if (std::find(out.begin(), out.end(), mname) == out.end()) out.push_back(mname);
    }
    if (!c->superclass.empty()) collectMethodNamesInto(c->superclass, out);
    for (const std::string& iface : c->interfaces) collectMethodNamesInto(iface, out);
}

void SemanticAnalyzer::validateOverrides(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                const ClassInfo* ci = lookupClass(cls.name);
                if (ci == nullptr) continue;

                // Does any superclass / interface declare `method`?
                auto inheritedHas = [&](const std::string& method) {
                    if (!ci->superclass.empty() && findMethod(ci->superclass, method) != nullptr) {
                        return true;
                    }
                    for (const std::string& iface : ci->interfaces) {
                        if (findMethod(iface, method) != nullptr) return true;
                    }
                    return false;
                };

                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isStatic) continue;
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
                info.isStruct = cls.isStruct;
                info.isSealed = cls.isSealed;
                info.permits = cls.permits;
                info.isMovable = cls.isMovable;
                info.isUnique = cls.isUnique;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        info.fields[f->name] = FieldInfo{typeRefStr(f->type), f->isMutable};
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        info.methods[m->name] = MethodInfo{typeRefStr(m->returnType), m->isStatic,
                                                           m->isAbstract, m->isProperty};
                    } else if (dynamic_cast<const ast::ConstructorDecl*>(member.get()) != nullptr) {
                        info.hasConstructor = true;
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) != nullptr) {
                        info.hasDestructor = true;
                    }
                }
                classes_[cls.name] = std::move(info);
                typeNamespace_[cls.name] = ns.name;
            }
        }
    }
}

void SemanticAnalyzer::registerEnums(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::EnumDecl& en : ns.enums) {
                // A java-style enum is desugared into a class of the same name, so
                // its matching class entry is expected; only flag other clashes.
                if (enums_.count(en.name) > 0 || (!en.isJavaStyle && classes_.count(en.name) > 0)) {
                    error("redeclaration of type '" + en.name + "'", en.loc);
                    continue;
                }
                enums_[en.name] = en.constants;
                typeNamespace_[en.name] = ns.name;
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
        const std::string ft = typeRefStr(f->type);
        if (!initType.empty() && !isSubtype(initType, ft)) {
            error("cannot initialize field '" + f->name + "' of type '" + ft +
                      "' with a value of type '" + initType + "'",
                  f->loc);
        }
    }
    popScope();
}

void SemanticAnalyzer::analyzeBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        // Imports are per-bundle; collect the imported symbol names.
        currentImports_.clear();
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                // Member signature types must also be visible from this namespace.
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        for (const ast::Param& p : m->params)
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                        checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        checkTypeAccessible(typeRefStr(f->type), f->loc);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        for (const ast::Param& p : c->params)
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                    }
                }
                analyzeFieldInits(cls);
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        if (m->isAbstract) continue;  // no body to analyze
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                        for (const auto& e : m->ensuresClauses) contracts.push_back(e.get());
                        analyzeMethodBody(m->body, m->params,
                                          m->isStatic ? std::string() : cls.name, false, contracts);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : c->requiresClauses) contracts.push_back(e.get());
                        for (const auto& e : c->ensuresClauses) contracts.push_back(e.get());
                        analyzeMethodBody(c->body, c->params, cls.name, /*inConstructor=*/true,
                                          contracts);
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        analyzeMethodBody(d->body, {}, cls.name, false);
                    }
                }
            }
        }
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program) {
    registerClasses(program);
    registerEnums(program);
    registerLiterals(program);
    processImports(program);
    validateHierarchy();
    // If the hierarchy itself is broken (cycle, missing super), stop: walking it
    // recursively below could otherwise loop forever.
    if (!errors_.empty()) return false;
    validateOverrides(program);
    findEntryPoint(program);
    analyzeBodies(program);
    analyzeLiteralBodies(program);
    return errors_.empty();
}

// Registers each namespace-level `comptime literal` suffix function and checks
// its shape (spec 17.10): must be comptime, exactly one numeric parameter, and a
// known return type. The body is type-checked later, in analyzeLiteralBodies.
void SemanticAnalyzer::registerLiterals(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::LiteralDecl& lit : ns.literals) {
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
                if (literals_.count(lit.name) > 0) {
                    error("literal suffix '" + lit.name + "' is already defined", lit.loc);
                }
                literals_[lit.name] = LiteralInfo{paramType, returnType, lit.isComptime, lit.loc};
                typeNamespace_[lit.name] = ns.name;  // for import-prefix validation
            }
        }
    }
}

// Resolves each `import a.b.c;`: the last component is the symbol. Importing a
// literal suffix enables its `N suffix` syntax (spec 17.10 rule 5). Importing a
// type is accepted (names are global in 0.2); an unknown symbol is an error.
void SemanticAnalyzer::processImports(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::ImportDecl& imp : bundle.imports) {
            if (imp.path.empty()) continue;
            const std::string& symbol = imp.path.back();
            std::string full;
            for (std::size_t i = 0; i < imp.path.size(); ++i) full += (i > 0 ? "." : "") + imp.path[i];
            // The prefix (everything before the symbol) must be the symbol's real namespace.
            std::string prefix;
            for (std::size_t i = 0; i + 1 < imp.path.size(); ++i)
                prefix += (i > 0 ? "." : "") + imp.path[i];
            auto nsIt = typeNamespace_.find(symbol);
            if (nsIt == typeNamespace_.end()) {
                error("import of unknown symbol '" + full + "'", imp.loc);
            } else if (!prefix.empty() && prefix != nsIt->second) {
                error("'" + symbol + "' is in namespace '" + nsIt->second + "', not '" + prefix + "'",
                      imp.loc);
            } else {
                importedSuffixes_.insert(symbol);  // harmless for non-literals
            }
        }
    }
}

// Type-checks the body of each literal suffix, with its single parameter in
// scope and treated like a static function (no `this`).
void SemanticAnalyzer::analyzeLiteralBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        currentImports_.clear();
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            for (const ast::LiteralDecl& lit : ns.literals) {
                analyzeMethodBody(lit.body, {lit.param}, /*thisClass=*/"", /*inConstructor=*/false);
            }
        }
    }
}

void SemanticAnalyzer::analyzeMethodBody(const ast::Block& body,
                                         const std::vector<ast::Param>& params,
                                         const std::string& thisClass, bool inConstructor,
                                         const std::vector<const ast::Expr*>& contracts) {
    scopes_.clear();
    moved_.clear();
    regionConstraints_.clear();
    currentClass_ = thisClass;
    inConstructor_ = inConstructor;
    pushScope();
    for (const ast::Param& p : params) {
        declareLocal(p.name, LocalVar{typeRefStr(p.type), false});  // params immutable by default
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
        if (!t.empty() && t != "boolean")
            error("a contract clause must be boolean, got '" + t + "'", clause->loc);
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
        // Immutable fields may still be initialized via `this.field` in a constructor.
        const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        const bool isThisField = objId != nullptr && objId->name == "this";
        if (!f->isMutable && !(inConstructor_ && isThisField)) {
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

void SemanticAnalyzer::checkTypeAccessible(const std::string& typeName, SourceLocation loc) {
    std::string n = baseType(typeName);          // see through T* / T&
    if (isArrayType(n)) n = elementOf(n);         // and through T[]
    if (n.find('$') != std::string::npos) return;  // monomorphized generic -> always visible
    auto it = typeNamespace_.find(n);
    if (it == typeNamespace_.end()) return;        // primitive / unknown (other checks catch it)
    if (it->second == currentNamespace_) return;   // same namespace -> visible
    if (currentImports_.count(n) > 0) return;      // brought in by import
    error("type '" + n + "' is in namespace '" + it->second + "'; import it (import " + it->second +
              "." + n + ";) to use it here",
          loc);
}

void SemanticAnalyzer::checkRegionAccepts(const std::string& region, const std::string& type,
                                          SourceLocation loc) {
    auto rc = regionConstraints_.find(region);
    if (rc == regionConstraints_.end()) return;  // no constraints recorded
    for (const std::string& rej : rc->second.rejects) {
        if (type == rej || isSubtype(type, rej)) {
            error("region '" + region + "' rejects type '" + type + "'", loc);
            return;
        }
    }
    if (!rc->second.accepts.empty()) {
        for (const std::string& acc : rc->second.accepts) {
            if (type == acc || isSubtype(type, acc)) return;  // accepted
        }
        error("region '" + region + "' does not accept type '" + type + "'", loc);
    }
}

void SemanticAnalyzer::checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                                            SourceLocation loc) {
    if (isRefType(targetType)) return;  // pointers/refs share; no move discipline
    const ClassInfo* ci = lookupClass(baseType(targetType));
    if (ci == nullptr) return;  // not a class value
    const bool rhsIsMove = dynamic_cast<const ast::MoveExpr*>(&rhs) != nullptr;
    const auto* rhsId = dynamic_cast<const ast::IdentifierExpr*>(&rhs);
    const bool rhsIsLValue =
        rhsId != nullptr || dynamic_cast<const ast::MemberExpr*>(&rhs) != nullptr;
    if (!rhsIsLValue || rhsIsMove) return;  // a fresh `new`, a `move`, or a temporary is fine
    if (ci->isMovable) {
        error("'" + ci->name + "' is movable; transfer ownership with 'move' (e.g. = move x)",
              loc);
    } else if (ci->isUnique && rhsId != nullptr) {
        moved_.insert(rhsId->name);  // unique: a plain assignment is an implicit move
    }
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
        const std::string declType = vd->isVar ? initType : typeRefStr(vd->type);
        if (!vd->isVar) checkTypeAccessible(declType, vd->loc);
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
        // Remember a region's accepts/rejects constraints, keyed by variable.
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
            regionConstraints_[vd->name] = RegionConstraints{ri->accepts, ri->rejects};
        }
        checkOwnershipAssign(declType, *vd->init, vd->loc);
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        const std::string vt = typeOf(*assign->value);
        checkAssignTarget(*assign->target, vt, assign->loc);
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
            moved_.erase(id->name);  // reassignment reactivates the variable
            const LocalVar* var = lookupLocal(id->name);
            if (var != nullptr) checkOwnershipAssign(var->type, *assign->value, assign->loc);
        }
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
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(&stmt)) {
        const std::string subjType = typeOf(*ms->subject);
        for (const ast::MatchCase& c : ms->cases) {
            const ClassInfo* ci = lookupClass(c.typeName);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(c.typeName, baseType(subjType))) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce locals (the case type's fields) in the case body.
            pushScope();
            for (const ast::Param& b : c.bindings)
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            for (const auto& st : c.body.statements) analyzeStatement(*st);
            popScope();
        }
        if (ms->defaultBody) analyzeBlock(*ms->defaultBody);
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit and
        // needs no default; a non-sealed subject requires a default.
        const ClassInfo* sc = lookupClass(baseType(subjType));
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : ms->cases)
                    if (c.typeName == p) covered = true;
                if (!covered && !ms->defaultBody)
                    error("match on sealed '" + baseType(subjType) +
                              "' is not exhaustive: missing case '" + p + "'",
                          ms->loc);
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
        // `delete p` where p is a class, or a pointer/reference to one (see through T*/T&).
        if (!t.empty() && lookupClass(baseType(t)) == nullptr && !isArrayType(t)) {
            error("'delete' expects a heap object or array; got a value of type '" + t + "'",
                  del->loc);
        }
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
        const LocalVar* r = lookupLocal(rel->region);
        if (r == nullptr) {
            error("unknown region '" + rel->region + "'", rel->loc);
        } else if (r->type != "region") {
            error("'" + rel->region + "' is not a region", rel->loc);
        }
        return;
    }
    if (const auto* def = dynamic_cast<const ast::DeferStmt*>(&stmt)) {
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
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&expr) != nullptr) return "int";
    if (dynamic_cast<const ast::FloatLiteralExpr*>(&expr) != nullptr) return "double";
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
        if (moved_.count(id->name) > 0) {
            error("use of variable '" + id->name +
                      "' after it was moved (reassign it before using)",
                  id->loc);
        }
        return var->type;
    }

    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (un->op == "&") {
            return t.empty() ? std::string() : t + "*";  // address-of: T -> T*
        }
        if (un->op == "!") {
            if (!t.empty() && t != "boolean") error("unary '!' requires a boolean operand", un->loc);
            return "boolean";
        }
        if (!t.empty() && t != "int") error("unary '" + un->op + "' requires an int operand", un->loc);
        return "int";
    }

    if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
        const std::string subjType = typeOf(*me->subject);
        const std::string subjBase = baseType(subjType);
        std::string resultType;
        for (const ast::MatchCase& c : me->cases) {
            const ClassInfo* ci = lookupClass(c.typeName);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(c.typeName, subjBase)) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce the case type's fields as locals in the arm expression.
            pushScope();
            for (const ast::Param& b : c.bindings)
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            const std::string at = c.result ? typeOf(*c.result) : std::string();
            popScope();
            if (resultType.empty()) resultType = at;
        }
        if (me->defaultResult) {
            const std::string dt = typeOf(*me->defaultResult);
            if (resultType.empty()) resultType = dt;
        }
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit with no
        // default; otherwise a default arm is required so the expression always yields.
        const ClassInfo* sc = lookupClass(subjBase);
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : me->cases)
                    if (c.typeName == p) covered = true;
                if (!covered && !me->defaultResult)
                    error("match on sealed '" + subjBase +
                              "' is not exhaustive: missing case '" + p + "'",
                          me->loc);
            }
        } else if (!me->defaultResult) {
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
        }
        return t;
    }

    if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
        if (ri->size) typeOf(*ri->size);
        // Constrained types must exist (dotted family names like Animal.X are a
        // later refinement and are skipped here).
        for (const auto& list : {ri->accepts, ri->rejects}) {
            for (const std::string& t : list) {
                if (t.find('.') == std::string::npos && lookupClass(t) == nullptr) {
                    error("region accepts/rejects references unknown type '" + t + "'", ri->loc);
                }
            }
        }
        return "region";
    }

    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        const std::string src = typeOf(*cst->operand);
        const std::string& dst = cst->targetType;
        // Release 0.1 supports numeric casts only; class casts need runtime
        // type checks and exceptions (a later phase).
        if (!isNumeric(dst)) {
            error("cast<" + dst + "> is not supported yet; 0.1 casts only between numeric types", cst->loc);
        } else if (!src.empty() && !isNumeric(src)) {
            error("cannot cast '" + src + "' to '" + dst + "'; only numeric casts are supported", cst->loc);
        }
        return dst;
    }

    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        const std::string& op = bin->op;
        // Operator overloading: a OP b where a's class defines `operator OP` (spec 6.5).
        if (const MethodInfo* om = findMethod(baseType(lt), "operator" + op)) {
            return om->returnType;
        }
        if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
            if ((!lt.empty() && !isNumeric(lt)) || (!rt.empty() && !isNumeric(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            if (op == "%" && (isFloatType(lt) || isFloatType(rt))) {
                error("operator '%' requires int operands", bin->loc);
            }
            if (isFloatType(lt) || isFloatType(rt)) return "double";
            return intBits(lt) >= intBits(rt) ? lt : rt;  // wider integer wins
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            if ((!lt.empty() && !isNumeric(lt)) || (!rt.empty() && !isNumeric(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
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
            const LocalVar* r = lookupLocal(nw->region);
            if (r == nullptr) {
                error("unknown region '" + nw->region + "'", nw->loc);
            } else if (r->type != "region") {
                error("'" + nw->region + "' is not a region", nw->loc);
            } else {
                checkRegionAccepts(nw->region, cn, nw->loc);
            }
        }
        for (const auto& arg : nw->args) typeOf(*arg);
        return cn;
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
            const bool printable = t.empty() || isIntName(t) || isFloatType(t) || t == "char" ||
                                   t == "boolean" || enums_.count(t) > 0;
            if (!printable) {
                error("string interpolation can only print numeric, char, boolean or enum "
                      "values, got '" + t + "'",
                      e->loc);
            }
        }
        return "string";
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
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
            for (const auto& arg : call->args) typeOf(*arg);
            return "void";
        }
        const std::string name = flattenCallee(*call->callee);
        // Namespace-level literal suffix function called by name: kilobytes(64).
        if (auto lit = literals_.find(name); lit != literals_.end()) {
            // The `N suffix` form (spec 17.10) requires the suffix to be imported;
            // an explicit call name(arg) does not.
            if (call->fromSuffix && importedSuffixes_.count(name) == 0) {
                error("literal suffix '" + name +
                          "' is not in scope; import it to use the 'N " + name + "' form",
                      call->loc);
            }
            if (call->args.size() != 1) {
                error("literal suffix '" + name + "' takes exactly one argument", call->loc);
            } else {
                const std::string at = typeOf(*call->args[0]);
                if (!at.empty() && !isSubtype(at, lit->second.paramType)) {
                    error("literal suffix '" + name + "' expects " + lit->second.paramType +
                              ", got '" + at + "'",
                          call->loc);
                }
            }
            return lit->second.returnType;
        }
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
        // Enum constant access: EnumName.CONSTANT (when the receiver names an enum,
        // not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (lookupLocal(objId->name) == nullptr) {
                auto eit = enums_.find(objId->name);
                if (eit != enums_.end()) {
                    if (std::find(eit->second.begin(), eit->second.end(), mem->member) ==
                        eit->second.end()) {
                        error("enum '" + objId->name + "' has no constant '" + mem->member + "'",
                              mem->loc);
                    }
                    return objId->name;
                }
            }
        }
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return "";
        if (const FieldInfo* f = findField(objType, mem->member)) return f->type;
        // A computed get-only property is read as obj.name (no parens).
        if (const MethodInfo* pm = findMethod(objType, mem->member); pm != nullptr && pm->isProperty)
            return pm->returnType;
        error("class '" + objType + "' has no field '" + mem->member + "'", mem->loc);
        return "";
    }

    if (dynamic_cast<const ast::SuperExpr*>(&expr) != nullptr) {
        error("'super' can only be used as 'super(...)' in a constructor", expr.loc);
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
