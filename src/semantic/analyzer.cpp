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
    return true;
}

}  // namespace ldp3
