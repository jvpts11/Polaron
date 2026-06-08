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
    locals_.clear();
    for (const auto& stmt : method.body.statements) {
        analyzeStatement(*stmt);
    }
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
        if (locals_.count(vd->name) > 0) {
            error("redeclaration of variable '" + vd->name + "'", vd->loc);
        } else {
            locals_[vd->name] = declType.empty() ? std::string("int") : declType;
        }
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
        auto it = locals_.find(id->name);
        if (it == locals_.end()) {
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return "";
        }
        return it->second;
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (!t.empty() && t != "int") {
            error("unary '" + un->op + "' requires an int operand", un->loc);
        }
        return "int";
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        if ((!lt.empty() && lt != "int") || (!rt.empty() && rt != "int")) {
            error("operator '" + bin->op + "' requires int operands", bin->loc);
        }
        return "int";
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
