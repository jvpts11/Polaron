#include "semantic/analyzer.h"

#include <string>
#include <utility>
#include <vector>

namespace ldp3 {

void SemanticAnalyzer::error(std::string message, SourceLocation loc) {
    errors_.push_back(SemaError{std::move(message), loc});
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

bool SemanticAnalyzer::analyze(const ast::Program& program) {
    // Collect every well-formed entry point: a public static main(string[])
    // returning void/int, inside a public class Main, inside a public
    // namespace, inside a public bundle (spec section 2.9).
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
        return false;
    }
    if (candidates.size() > 1) {
        error("program '" + program.name + "' has " + std::to_string(candidates.size()) +
                  " entry points; exactly one 'public static method main' is allowed.",
              program.loc);
        return false;
    }

    entry_ = std::move(candidates.front());
    analyzeMethodBody(*entry_.method);
    return errors_.empty();
}

void SemanticAnalyzer::analyzeMethodBody(const ast::MethodDecl& method) {
    scopes_.clear();
    analyzeBlock(method.body);
}

void SemanticAnalyzer::analyzeBlock(const ast::Block& block) {
    pushScope();
    for (const auto& stmt : block.statements) {
        analyzeStatement(*stmt);
    }
    popScope();
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

void SemanticAnalyzer::analyzeStatement(const ast::Stmt& stmt) {
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
        const std::string initType = typeOf(*vd->init);
        const std::string declType = vd->isVar ? initType : vd->type.name;
        if (!vd->isVar && !initType.empty() && initType != declType) {
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
        const LocalVar* var = lookupLocal(assign->target);
        if (var == nullptr) {
            error("assignment to undeclared variable '" + assign->target + "'", assign->loc);
            return;
        }
        if (!var->isMutable) {
            error("cannot assign to immutable variable '" + assign->target +
                      "' (declare it 'mutable')",
                  assign->loc);
        }
        const std::string vt = typeOf(*assign->value);
        if (!vt.empty() && vt != var->type) {
            error("cannot assign a value of type '" + vt + "' to variable '" + assign->target +
                      "' of type '" + var->type + "'",
                  assign->loc);
        }
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        const LocalVar* var = lookupLocal(incdec->target);
        if (var == nullptr) {
            error("modification of undeclared variable '" + incdec->target + "'", incdec->loc);
            return;
        }
        if (!var->isMutable) {
            error("cannot modify immutable variable '" + incdec->target +
                      "' (declare it 'mutable')",
                  incdec->loc);
        }
        if (var->type != "int") {
            error("'++'/'--' requires an int variable", incdec->loc);
        }
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
        pushScope();  // the for-init variable lives in the loop's own scope
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
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&expr) != nullptr) return "int";
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
    if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "string";
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
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
            if (!t.empty() && t != "boolean") {
                error("unary '!' requires a boolean operand", un->loc);
            }
            return "boolean";
        }
        if (!t.empty() && t != "int") {
            error("unary '" + un->op + "' requires an int operand", un->loc);
        }
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
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        const std::string name = flattenCallee(*call->callee);
        if (name == "System.IO.printf") {
            for (const auto& a : call->args) typeOf(*a);
            return "void";
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) +
                  "' (0.1 only supports System.IO.printf)",
              call->loc);
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
