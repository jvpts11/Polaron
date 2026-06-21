#include "semantic/analyzer.h"

#include "semantic/comptime.h"

#include <algorithm>
#include <functional>
#include <string>
#include <unordered_set>
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

// Tuple types are spelled "(T0,T1,...)" (spec 22.5).
bool isTupleType(const std::string& t) {
    return t.size() >= 2 && t.front() == '(' && t.back() == ')';
}
// Splits the components of a tuple type, honoring nested parentheses (a
// component may itself be a tuple) so commas inside nested tuples don't split.
std::vector<std::string> tupleElems(const std::string& t) {
    std::vector<std::string> out;
    if (!isTupleType(t)) return out;
    int depth = 0;
    std::string cur;
    for (std::size_t i = 1; i + 1 < t.size(); ++i) {
        const char c = t[i];
        if (c == '(') ++depth;
        if (c == ')') --depth;
        if (c == ',' && depth == 0) {
            out.push_back(cur);
            cur.clear();
        } else {
            cur += c;
        }
    }
    if (!cur.empty()) out.push_back(cur);
    return out;
}
}  // namespace

// Compile-time constant evaluators (spec 28); defined further below, but declared
// here so const registration (above their definitions) can call them.
static bool evalConstInt(const ast::Expr& e, long long& out,
                         const std::unordered_map<std::string, long long>* consts,
                         const std::unordered_map<std::string, const ast::MethodDecl*>* methods);
static bool evalConstDouble(const ast::Expr& e, double& out,
                            const std::unordered_map<std::string, double>* dconsts,
                            const std::unordered_map<std::string, long long>* iconsts,
                            const std::unordered_map<std::string, const ast::MethodDecl*>* methods);

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

bool SemanticAnalyzer::isSubtype(const std::string& sub, const std::string& super, int depth) const {
    if (sub == super) return true;
    // Guard against a cyclic type graph (e.g. `catalog A extends B; B extends A`):
    // bound the recursion so a malformed program errors instead of overflowing.
    if (depth > 256) return false;
    if (sub == "null" && isRefType(super)) return true;  // null binds to any pointer/reference
    // int and float both widen to a float type (no implicit narrowing).
    if (isFloatType(super) && isNumeric(sub)) return true;
    // Integers widen to a wider integer (no implicit narrowing).
    if (isIntName(sub) && isIntName(super)) return intBits(sub) <= intBits(super);
    // Pointer/reference compatibility follows the pointee (T*, T& and T mix
    // freely for now; the strict value-vs-reference rules land with deep copy).
    if (isRefType(sub) || isRefType(super))
        return isSubtype(baseType(sub), baseType(super), depth + 1);
    // An enum is a subtype of every catalog it extends (spec 12.4), transitively
    // through catalog->catalog extends.
    if (auto ecit = enumCatalogs_.find(sub); ecit != enumCatalogs_.end()) {
        for (const std::string& cat : ecit->second) {
            if (cat == super || isSubtype(cat, super, depth + 1)) return true;
        }
    }
    // A catalog is a subtype of every catalog it extends.
    if (auto ccit = catalogs_.find(sub); ccit != catalogs_.end()) {
        for (const std::string& cat : ccit->second.extendsCatalogs) {
            if (cat == super || isSubtype(cat, super, depth + 1)) return true;
        }
    }
    const ClassInfo* c = lookupClass(sub);
    if (c == nullptr) return false;
    if (!c->superclass.empty() && isSubtype(c->superclass, super, depth + 1)) return true;
    for (const std::string& iface : c->interfaces) {
        if (isSubtype(iface, super, depth + 1)) return true;
    }
    return false;
}

bool SemanticAnalyzer::isPolymorphic(const std::string& name) const {
    const ClassInfo* c = lookupClass(name);
    if (c == nullptr) return false;
    if (c->isAbstract || c->isInterface || !c->superclass.empty() || !c->interfaces.empty())
        return true;
    for (const auto& [n, info] : classes_) {
        (void)n;
        if (info.superclass == name) return true;
        for (const std::string& i : info.interfaces)
            if (i == name) return true;
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
        if (info.isSealed)
            for (const std::string& p : info.permits) sealedVariants.insert(p);
    }
    for (const auto& [name, info] : classes_) {
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
                error("class '" + name + "' extends unknown type '" + info.superclass + "'", {});
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
                    // A `final` inherited method may not be overridden.
                    if (inherited) {
                        const MethodInfo* base = nullptr;
                        if (!ci->superclass.empty()) base = findMethod(ci->superclass, m->name);
                        for (const std::string& iface : ci->interfaces)
                            if (base == nullptr) base = findMethod(iface, m->name);
                        if (base != nullptr && base->isFinal)
                            error("method '" + m->name + "' cannot override final method '" +
                                      m->name + "'",
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
                info.isFinal = cls.isFinal;
                info.isInterface = cls.isInterface;
                info.isStruct = cls.isStruct;
                info.isSealed = cls.isSealed;
                info.permits = cls.permits;
                info.isMovable = cls.isMovable;
                info.isUnique = cls.isUnique;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        info.fields[f->name] = FieldInfo{typeRefStr(f->type), f->isMutable,
                                                         f->isStatic};
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        info.methods[m->name] = MethodInfo{typeRefStr(m->returnType), m->isStatic,
                                                           m->isAbstract, m->isProperty,
                                                           m->params.size(), m->isFinal};
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
                if (enums_.count(en.name) > 0 || catalogs_.count(en.name) > 0 ||
                    (!en.isJavaStyle && classes_.count(en.name) > 0)) {
                    error("redeclaration of type '" + en.name + "'", en.loc);
                    continue;
                }
                // Reject duplicate constant names (own constants and byCatalog values share
                // one ordinal space; a repeat would create a hidden, unreachable constant).
                for (std::size_t i = 0; i < en.constants.size(); ++i)
                    for (std::size_t j = i + 1; j < en.constants.size(); ++j)
                        if (en.constants[i] == en.constants[j])
                            error("duplicate enum constant '" + en.constants[i] + "' in enum '" +
                                      en.name + "'",
                                  en.loc);
                enums_[en.name] = en.constants;
                if (!en.extendsCatalogs.empty()) enumCatalogs_[en.name] = en.extendsCatalogs;
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
            }
        }
    }
}

// Registers each catalog's value/method contract so enums can implement it and
// catalog types participate in subtyping (spec 12.3).
void SemanticAnalyzer::registerCatalogs(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::CatalogDecl& cat : ns.catalogs) {
                if (catalogs_.count(cat.name) > 0 || classes_.count(cat.name) > 0 ||
                    enums_.count(cat.name) > 0) {
                    error("redeclaration of type '" + cat.name + "'", cat.loc);
                    continue;
                }
                // Reject duplicate required-value names in the catalog itself.
                for (std::size_t i = 0; i < cat.requiredValues.size(); ++i)
                    for (std::size_t j = i + 1; j < cat.requiredValues.size(); ++j)
                        if (cat.requiredValues[i] == cat.requiredValues[j])
                            error("duplicate catalog value '" + cat.requiredValues[i] +
                                      "' in catalog '" + cat.name + "'",
                                  cat.loc);
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
            if (!visited.insert(cur).second) continue;
            if (auto it = catalogs_.find(cur); it != catalogs_.end())
                for (const auto& p : it->second.extendsCatalogs) stack.push_back(p);
        }
        if (cyclic) error("catalog cycle involving '" + name + "'", {});
    }
    // Collects a catalog's required values and methods transitively through its
    // `extends` parents (deduped); the visited set bounds it against any cycle.
    std::function<void(const std::string&, std::unordered_set<std::string>&,
                       std::vector<std::string>&, std::vector<std::string>&)>
        collect = [&](const std::string& catName, std::unordered_set<std::string>& seen,
                      std::vector<std::string>& vals, std::vector<std::string>& meths) {
            if (!seen.insert(catName).second) return;
            auto cit = catalogs_.find(catName);
            if (cit == catalogs_.end()) return;
            for (const auto& v : cit->second.requiredValues)
                if (std::find(vals.begin(), vals.end(), v) == vals.end()) vals.push_back(v);
            for (const auto& m : cit->second.methodNames)
                if (std::find(meths.begin(), meths.end(), m) == meths.end()) meths.push_back(m);
            for (const auto& parent : cit->second.extendsCatalogs)
                collect(parent, seen, vals, meths);
        };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
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
                for (const std::string& req : requiredMethods) {
                    const ast::MethodDecl* impl = nullptr;
                    for (const ast::MemberPtr& member : en.members) {
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
                if (!cls.invariants.empty()) {
                    std::vector<const ast::Expr*> invs;
                    for (const auto& e : cls.invariants) invs.push_back(e.get());
                    analyzeMethodBody(ast::Block{}, {}, cls.name, false, invs);
                }
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
            // Catalog-implementing enums keep their method impls on the enum (they are
            // not desugared to a class); type-check those bodies too. `this` has the
            // enum type; an instance method receives the enum value (an ordinal).
            for (const ast::EnumDecl& en : ns.enums) {
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) continue;
                    for (const ast::Param& p : m->params)
                        checkTypeAccessible(typeRefStr(p.type), p.loc);
                    checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    std::vector<const ast::Expr*> contracts;
                    for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                    for (const auto& e : m->ensuresClauses) contracts.push_back(e.get());
                    analyzeMethodBody(m->body, m->params,
                                      m->isStatic ? std::string() : en.name, false, contracts);
                }
            }
        }
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program) {
    registerClasses(program);
    registerCatalogs(program);  // before enums: registerEnums records enum->catalog edges
    registerEnums(program);
    registerLiterals(program);
    registerConsts(program);
    registerComptimeMethods(program);
    registerPersistentFields(program);
    processImports(program);
    evaluateConsts(program);
    validateHierarchy();
    // If the hierarchy itself is broken (cycle, missing super), stop: walking it
    // recursively below could otherwise loop forever.
    if (!errors_.empty()) return false;
    validateOverrides(program);
    validateCatalogs(program);
    findEntryPoint(program);
    analyzeBodies(program);
    analyzeLiteralBodies(program);
    checkPersistentReleases();  // spec 18.15: after all bodies, so releases are collected
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

// Pass 1 for namespace-level consts (spec 28.1): record each name's type so that
// references resolve. Only primitive numeric / boolean / char consts are supported
// for now (no sizeof, no comptime functions -- those are later tiers).
void SemanticAnalyzer::registerConsts(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ConstDecl& c : ns.consts) {
                const std::string type = typeRefStr(c.type);
                if (!isNumeric(type) && type != "boolean" && type != "char") {
                    error("a 'const' must have a numeric, boolean, or char type, got '" + type + "'",
                          c.loc);
                    continue;
                }
                if (constTypes_.count(c.name) > 0) {
                    error("const '" + c.name + "' is already defined", c.loc);
                    continue;
                }
                constTypes_[c.name] = type;
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
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m != nullptr && m->isComptime && !m->isAbstract)
                        comptimeMethods_.emplace(m->name, m);
                }
            }
        }
    }
}

// Indexes persistent fields (spec 18.15). Non-eternal ones must be released
// somewhere in the program; eternal ones are exempt.
void SemanticAnalyzer::registerPersistentFields(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles)
        for (const ast::Namespace& ns : bundle.namespaces)
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& member : cls.members)
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                        f != nullptr && f->isPersistent)
                        persistentFields_.push_back({cls.name, f->name, f->isEternal, f->loc});
}

// The class in `cls`'s hierarchy that declares persistent field `field`, or "".
std::string SemanticAnalyzer::persistentFieldOwner(const std::string& cls,
                                                   const std::string& field) const {
    std::string cur = cls;
    for (int depth = 0; !cur.empty() && depth < 256; ++depth) {
        for (const PersistentFieldInfo& pf : persistentFields_)
            if (pf.cls == cur && pf.name == field) return cur;
        auto it = classes_.find(cur);
        if (it == classes_.end()) break;
        cur = it->second.superclass;
    }
    return "";
}

// Enforces the release obligation (spec 18.15): a non-eternal persistent field
// with no `release persistent` anywhere in the program is a compile error.
void SemanticAnalyzer::checkPersistentReleases() {
    for (const PersistentFieldInfo& pf : persistentFields_) {
        if (pf.isEternal) continue;
        if (releasedPersistents_.count(pf.cls + "." + pf.name) > 0) continue;
        error("persistent '" + pf.cls + "." + pf.name +
                  "' has no 'release persistent' anywhere in the program; non-eternal "
                  "persistents require explicit release (or mark the field 'eternal persistent')",
              pf.loc);
    }
}

// Pass 2: fold each const initializer (in declaration order, so a const may refer
// to earlier ones) and validate it is a compile-time constant of the right kind.
void SemanticAnalyzer::evaluateConsts(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ConstDecl& c : ns.consts) {
                if (constTypes_.count(c.name) == 0) continue;  // rejected in pass 1
                const std::string type = constTypes_[c.name];
                if (c.init == nullptr) {
                    error("const '" + c.name + "' must have an initializer", c.loc);
                    continue;
                }
                if (isFloatType(type)) {
                    double d;
                    if (!evalConstDouble(*c.init, d, &constDoubles_, &constInts_, &comptimeMethods_))
                        error("const '" + c.name + "' initializer must be a compile-time constant",
                              c.loc);
                    else
                        constDoubles_[c.name] = d;
                } else {
                    long long v;
                    if (!evalConstInt(*c.init, v, &constInts_, &comptimeMethods_))
                        error("const '" + c.name + "' initializer must be a compile-time constant",
                              c.loc);
                    else
                        constInts_[c.name] = v;
                }
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
                if (!valueType.empty() && !isSubtype(valueType, f->type)) {
                    error("cannot assign a value of type '" + valueType + "' to static field '" +
                              mem->member + "' of type '" + f->type + "'",
                          loc);
                }
                return;
            }
        }
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
        if (findMethod(baseType(at), "operator[]=")) return;  // operator[]= overload (spec 6.5)
        if (!at.empty() && !isArrayType(at)) {
            error("cannot index a value of non-array type '" + at + "'", loc);
            return;
        }
        const std::string et = elementOf(at);
        if (!valueType.empty() && !et.empty() && !isSubtype(valueType, et)) {
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

// Evaluates a constant integer/boolean/char expression at compile time (spec 28),
// delegating to the shared comptime evaluator so consts and `comptime` method calls
// resolve uniformly. `consts`/`methods` are optional resolution tables.
static bool evalConstInt(const ast::Expr& e, long long& out,
                         const std::unordered_map<std::string, long long>* consts = nullptr,
                         const std::unordered_map<std::string, const ast::MethodDecl*>* methods =
                             nullptr) {
    comptime::Context ctx;
    ctx.consts = consts;
    ctx.methods = methods;
    return comptime::evalInt(e, out, ctx);
}

// Evaluates a constant floating-point expression at compile time. Integer consts
// and literals promote to double. Returns false if it is not a compile-time
// numeric constant.
static bool evalConstDouble(const ast::Expr& e, double& out,
                            const std::unordered_map<std::string, double>* dconsts,
                            const std::unordered_map<std::string, long long>* iconsts,
                            const std::unordered_map<std::string, const ast::MethodDecl*>* methods =
                                nullptr) {
    if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&e)) {
        std::string s;
        for (char ch : f->text)
            if (ch != '_' && ch != 'f' && ch != 'F') s += ch;
        try { out = std::stod(s); return true; } catch (...) { return false; }
    }
    long long iv;
    if (evalConstInt(e, iv, iconsts, methods)) { out = static_cast<double>(iv); return true; }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e)) {
        if (dconsts == nullptr) return false;
        auto it = dconsts->find(id->name);
        if (it == dconsts->end()) return false;
        out = it->second;
        return true;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        double v;
        if (u->op == "-" && evalConstDouble(*u->operand, v, dconsts, iconsts)) { out = -v; return true; }
        return false;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        double l, r;
        if (!evalConstDouble(*bin->lhs, l, dconsts, iconsts) ||
            !evalConstDouble(*bin->rhs, r, dconsts, iconsts))
            return false;
        const std::string& op = bin->op;
        if (op == "+") out = l + r;
        else if (op == "-") out = l - r;
        else if (op == "*") out = l * r;
        else if (op == "/") { if (r == 0.0) return false; out = l / r; }
        else return false;
        return true;
    }
    return false;
}

void SemanticAnalyzer::analyzeStatement(const ast::Stmt& stmt) {
    if (const auto* sa = dynamic_cast<const ast::StaticAssertStmt*>(&stmt)) {
        long long v;
        if (!evalConstInt(*sa->condition, v, &constInts_, &comptimeMethods_))
            error("static_assert requires a constant expression", sa->loc);
        else if (v == 0)
            error("static assertion failed: " + sa->message, sa->loc);
        return;
    }
    if (dynamic_cast<const ast::BreakStmt*>(&stmt) != nullptr ||
        dynamic_cast<const ast::ContinueStmt*>(&stmt) != nullptr) {
        return;  // loop-context validation (break/continue only inside a loop) is a later refinement
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(&stmt)) {
        const std::string it = typeOf(*fe->iterable);
        if (!it.empty() && !isArrayType(it))
            error("foreach requires an array, got '" + it + "'", fe->loc);
        const std::string et = fe->isVar ? elementOf(it) : typeRefStr(fe->elemType);
        pushScope();
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
        if (sw->defaultBody) analyzeBlock(*sw->defaultBody);
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
            // A class value bound to a `new ... on stack` (the default for objects) is a
            // stack object: RAII frees it, and it is not throwable (its carrier would
            // dangle after unwind).
            bool stackObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get()))
                stackObj = nw->location != "heap" && !declType.empty() &&
                           lookupClass(baseType(declType)) != nullptr && !isRefType(declType) &&
                           !isArrayType(declType);
            declareLocal(vd->name, LocalVar{declType.empty() ? std::string("int") : declType,
                                            vd->isMutable, stackObj});
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
        const std::string subjBaseM = baseType(subjType);
        const auto subjDollarM = subjBaseM.find('$');
        for (const ast::MatchCase& c : ms->cases) {
            // A bare case name (Ok) on a monomorphized sealed subject (Result$int$int) names the
            // matching instantiation (Ok$int$int). Exhaustiveness below stays bare (permits are bare).
            const std::string caseType = subjDollarM == std::string::npos
                                             ? c.typeName
                                             : c.typeName + subjBaseM.substr(subjDollarM);
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBaseM)) {
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
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&stmt)) {
        analyzeBlock(dw->body);
        const std::string ct = typeOf(*dw->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'do-while' condition must be boolean, got '" + ct + "'", dw->loc);
        }
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
        if (rel->isPersistent) {
            // `release [persistent|eternal] obj.field;` -- record that this persistent
            // field is released somewhere, satisfying the obligation (spec 18.15).
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(rel->target.get())) {
                const std::string ot = baseType(typeOf(*mem->object));
                if (const std::string owner = persistentFieldOwner(ot, mem->member); !owner.empty())
                    releasedPersistents_.insert(owner + "." + mem->member);
                else if (!ot.empty())
                    error("'" + mem->member + "' is not a persistent field of '" + ot + "'",
                          rel->loc);
            } else if (rel->target != nullptr) {
                typeOf(*rel->target);  // still type-check the operand
                error("'release persistent' expects a persistent field access (obj.field)",
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
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(&stmt)) {
        const std::string t = typeOf(*th->value);
        if (!t.empty()) {
            const std::string bt = baseType(t);
            if (lookupClass(bt) == nullptr) {
                error("'throw' expects an object value; got '" + t + "'", th->loc);
            } else if (!isPolymorphic(bt)) {
                // A non-polymorphic class has no vtable, so a catch can't match it by
                // dynamic type (it would become a catch-all). Require a hierarchy.
                error("thrown type '" + bt +
                          "' must participate in a class hierarchy (extend a base or implement an "
                          "interface) so it can be matched by 'catch'",
                      th->loc);
            }
            // The carrier must outlive unwinding: a stack object's pointer would dangle.
            bool stackThrow = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(th->value.get()))
                stackThrow = nw->location != "heap";
            else if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(th->value.get()))
                if (const LocalVar* v = lookupLocal(id->name)) stackThrow = v->isStackObject;
            if (stackThrow) {
                error("a thrown object must be heap-allocated; use 'new ... on heap'", th->loc);
            }
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(&stmt)) {
        analyzeBlock(tr->body);
        for (const ast::CatchClause& cc : tr->catches) {
            const std::string ct = baseType(typeRefStr(cc.type));
            checkTypeAccessible(typeRefStr(cc.type), cc.loc);
            if (lookupClass(ct) == nullptr) {
                error("catch type '" + ct + "' is not a class", cc.loc);
            } else if (!isPolymorphic(ct)) {
                error("catch type '" + ct +
                          "' must participate in a class hierarchy (a standalone class cannot be "
                          "matched by dynamic type)",
                      cc.loc);
            }
            pushScope();
            declareLocal(cc.name, LocalVar{typeRefStr(cc.type), false});
            for (const auto& st : cc.body.statements) analyzeStatement(*st);
            popScope();
        }
        if (tr->finallyBlock) analyzeBlock(*tr->finallyBlock);
        return;
    }
    // `label`/`comefrom` (spec 7.10) are accepted but not analyzed beyond this (out of
    // current type-checking scope); handled explicitly so they are not silently ignored.
    if (dynamic_cast<const ast::LabelMarkStmt*>(&stmt) != nullptr) return;
    if (dynamic_cast<const ast::ComefromStmt*>(&stmt) != nullptr) return;
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&expr) != nullptr) return "int";
    if (dynamic_cast<const ast::FloatLiteralExpr*>(&expr) != nullptr) return "double";
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
    if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "string";
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) return "null";
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        std::string s = "function<" + typeRefStr(lam->returnType);
        for (const auto& p : lam->params) s += "," + typeRefStr(p.type);
        return s + ">";
    }

    if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
        // A tuple literal's type is "(c0,c1,...)" of its components' types.
        std::string s = "(";
        for (std::size_t i = 0; i < tup->elements.size(); ++i) {
            const std::string et = typeOf(*tup->elements[i]);
            if (et.empty()) return "";
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
            if (auto cit = constTypes_.find(id->name); cit != constTypes_.end())
                return cit->second;
            // A bare enum constant inside one of that enum's own methods (spec 12.2/12.4):
            // `return v8;` resolves to the enum value without the `Enum.` prefix.
            if (auto eit = enums_.find(currentClass_);
                eit != enums_.end() &&
                std::find(eit->second.begin(), eit->second.end(), id->name) != eit->second.end()) {
                return currentClass_;
            }
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
        const auto subjDollarM = subjBase.find('$');
        for (const ast::MatchCase& c : me->cases) {
            // Map a bare case name to the subject's instantiation (Ok -> Ok$int$int).
            const std::string caseType = subjDollarM == std::string::npos
                                             ? c.typeName
                                             : c.typeName + subjBase.substr(subjDollarM);
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBase)) {
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
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        // try? Result<T,E>/Option<T> yields T (the first type arg of the operand's instantiation).
        const std::string ot = baseType(typeOf(*tx->operand));
        const auto p = ot.find('$');
        if (p == std::string::npos) return "";
        const std::string rest = ot.substr(p + 1);
        const auto q = rest.find('$');
        return q == std::string::npos ? rest : rest.substr(0, q);
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

    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        const std::string ct = typeOf(*tern->cond);
        if (!ct.empty() && ct != "boolean")
            error("ternary condition must be boolean, got '" + ct + "'", tern->loc);
        const std::string tt = typeOf(*tern->thenExpr);
        typeOf(*tern->elseExpr);
        return tt;
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
        if (op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>") {
            if (isFloatType(lt) || isFloatType(rt) || (!lt.empty() && !isNumeric(lt)) ||
                (!rt.empty() && !isNumeric(rt))) {
                error("operator '" + op + "' requires integer operands", bin->loc);
            }
            return intBits(lt) >= intBits(rt) ? lt : rt;
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            if ((!lt.empty() && !isNumeric(lt)) || (!rt.empty() && !isNumeric(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            return "boolean";
        }
        if (op == "==" || op == "!=") {
            const bool nullPtr =
                (lt == "null" && isRefType(rt)) || (rt == "null" && isRefType(lt));
            if (!lt.empty() && !rt.empty() && lt != rt && !nullPtr) {
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
        // operator[] overload (spec 6.5): `obj[i]` where obj's class defines operator[].
        if (const MethodInfo* om = findMethod(baseType(at), "operator[]")) {
            return om->returnType;
        }
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
                                   t == "boolean" || enums_.count(t) > 0 || catalogs_.count(t) > 0;
            if (!printable) {
                error("string interpolation can only print numeric, char, boolean or enum "
                      "values, got '" + t + "'",
                      e->loc);
            }
        }
        return "string";
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        // Calling a function value: callee is a local of type function<Ret, Params...> -> Ret.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (const LocalVar* fv = lookupLocal(cid->name);
                fv != nullptr && fv->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = fv->type.substr(9, fv->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);  // the Ret
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
        // Low-level thread builtins used by the System.Concurrency.Thread prelude class.
        if (name == "System.Concurrency.__threadStart") {
            if (call->args.size() != 1) error("__threadStart takes one function<void>", call->loc);
            else typeOf(*call->args.front());
            return "int64";  // the OS thread handle
        }
        if (name == "System.Concurrency.__threadJoin") {
            if (call->args.size() != 1) error("__threadJoin takes one handle", call->loc);
            else typeOf(*call->args.front());
            return "void";
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
                        if (call->args.size() != mit->second.paramCount) {
                            error("method '" + mem->member + "' expects " +
                                      std::to_string(mit->second.paramCount) + " argument(s) but got " +
                                      std::to_string(call->args.size()),
                                  call->loc);
                        }
                        return mit->second.returnType;
                    }
                }
            }
            // Enum built-ins: EnumName.count() / EnumName.values() (spec 12.5).
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (lookupLocal(oid->name) == nullptr && enums_.count(oid->name) > 0) {
                    if (mem->member == "count" && call->args.empty()) return "int";
                    if (mem->member == "values" && call->args.empty()) return oid->name + "[]";
                    error("enum '" + oid->name + "' has no built-in '" + mem->member + "'",
                          call->loc);
                    return "";
                }
            }
            const std::string objType = typeOf(*mem->object);
            if (objType.empty()) return "";
            // Enum (catalog) instance method: m.pick() where m is an enum value.
            if (auto emit = enumMethods_.find(baseType(objType)); emit != enumMethods_.end()) {
                auto mit = emit->second.find(mem->member);
                if (mit != emit->second.end()) {
                    for (const auto& arg : call->args) typeOf(*arg);
                    const std::size_t want = enumMethodParams_[baseType(objType)][mem->member];
                    if (call->args.size() != want) {
                        error("method '" + mem->member + "' expects " + std::to_string(want) +
                                  " argument(s) but got " + std::to_string(call->args.size()),
                              call->loc);
                    }
                    return mit->second.returnType;
                }
            }
            if (isArrayType(objType)) {
                if (mem->member == "length" && call->args.empty()) return "int";
                error("arrays only support .length(); '" + mem->member + "' is not a method",
                      call->loc);
                return "";
            }
            // A field of function<...> type is a function value: obj.f(args) calls it.
            if (const FieldInfo* fld = findField(objType, mem->member);
                fld != nullptr && fld->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = fld->type.substr(9, fld->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);
                }
                return inner;
            }
            // Calling a catalog method through a catalog-TYPED receiver would need
            // cross-enum dynamic dispatch, which an i32 ordinal can't carry (no type
            // tag). Give a clear message rather than "class has no method".
            if (catalogs_.count(baseType(objType)) > 0) {
                error("cannot call catalog method '" + mem->member + "' through a catalog-typed "
                          "value of type '" + baseType(objType) +
                          "'; call it on the concrete enum (dispatch through a catalog type is "
                          "not supported)",
                      call->loc);
                return "";
            }
            const MethodInfo* m = findMethod(objType, mem->member);
            if (m == nullptr) {
                error("class '" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            for (const auto& arg : call->args) typeOf(*arg);
            if (!m->isProperty && call->args.size() != m->paramCount) {
                error("method '" + mem->member + "' expects " + std::to_string(m->paramCount) +
                          " argument(s) but got " + std::to_string(call->args.size()),
                      call->loc);
            }
            return m->returnType;
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call->loc);
        return "";
    }

    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        // Enum constant access: EnumName.CONSTANT (when the receiver names an enum,
        // not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                auto eit = enums_.find(objId->name);
                if (eit != enums_.end()) {
                    if (std::find(eit->second.begin(), eit->second.end(), mem->member) ==
                        eit->second.end()) {
                        error("enum '" + objId->name + "' has no constant '" + mem->member + "'",
                              mem->loc);
                    }
                    return objId->name;
                }
                // Static field access: ClassName.field (when the receiver names a class).
                if (const ClassInfo* sc = lookupClass(objId->name)) {
                    const FieldInfo* f = findField(objId->name, mem->member);
                    if (f == nullptr) {
                        error("class '" + objId->name + "' has no static field '" + mem->member + "'",
                              mem->loc);
                        return "";
                    }
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
