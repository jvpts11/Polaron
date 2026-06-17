#include "parser/ast.h"

namespace ldp3::ast {

namespace {

void line(std::string& out, int indent, const std::string& text) {
    out.append(static_cast<std::size_t>(indent) * 2, ' ');
    out += text;
    out += '\n';
}

std::string typeText(const TypeRef& t) {
    return t.name + (t.isArray ? "[]" : "") + (t.isPointer ? "*" : "") + (t.isRef ? "&" : "");
}

}  // namespace

void IdentifierExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Identifier '" + name + "'");
}

void IntLiteralExpr::dump(std::string& out, int indent) const {
    line(out, indent, "IntLiteral " + text);
}

void FloatLiteralExpr::dump(std::string& out, int indent) const {
    line(out, indent, "FloatLiteral " + text);
}

void StringLiteralExpr::dump(std::string& out, int indent) const {
    line(out, indent, "StringLiteral \"" + value + "\"");
}

void CharLiteralExpr::dump(std::string& out, int indent) const {
    line(out, indent, "CharLiteral '" + value + "'");
}

void BoolLiteralExpr::dump(std::string& out, int indent) const {
    line(out, indent, std::string("BoolLiteral ") + (value ? "true" : "false"));
}

void MemberExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Member '." + member + "'");
    object->dump(out, indent + 1);
}

void CallExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Call");
    line(out, indent + 1, "callee:");
    callee->dump(out, indent + 2);
    line(out, indent + 1, "args:");
    for (const auto& a : args) a->dump(out, indent + 2);
}

void BinaryExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Binary '" + op + "'");
    lhs->dump(out, indent + 1);
    rhs->dump(out, indent + 1);
}

void UnaryExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Unary '" + op + "'");
    operand->dump(out, indent + 1);
}

void NewExpr::dump(std::string& out, int indent) const {
    std::string head = "New '" + className + "' on " + location;
    if (!region.empty()) head += " in region " + region;
    line(out, indent, head);
    for (const auto& a : args) a->dump(out, indent + 1);
}

void MoveExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Move");
    operand->dump(out, indent + 1);
}

void RegionInitExpr::dump(std::string& out, int indent) const {
    std::string head = "RegionInit";
    for (const auto& a : accepts) head += " accepts " + a;
    for (const auto& r : rejects) head += " rejects " + r;
    line(out, indent, head);
    if (size) size->dump(out, indent + 1);
}

void CastExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Cast<" + targetType + ">");
    operand->dump(out, indent + 1);
}

void SuperExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Super");
}

void NewArrayExpr::dump(std::string& out, int indent) const {
    line(out, indent, "NewArray '" + elementType + "[]' on " + location);
    line(out, indent + 1, "size:");
    size->dump(out, indent + 2);
}

void IndexExpr::dump(std::string& out, int indent) const {
    line(out, indent, "Index");
    line(out, indent + 1, "array:");
    array->dump(out, indent + 2);
    line(out, indent + 1, "index:");
    index->dump(out, indent + 2);
}

void InterpStringExpr::dump(std::string& out, int indent) const {
    line(out, indent, "InterpString");
    for (std::size_t i = 0; i < exprs.size(); ++i) {
        line(out, indent + 1, "lit \"" + literals[i] + "\"");
        exprs[i]->dump(out, indent + 1);
    }
    if (!literals.empty()) line(out, indent + 1, "lit \"" + literals.back() + "\"");
}

void ExprStmt::dump(std::string& out, int indent) const {
    line(out, indent, "ExprStmt");
    expr->dump(out, indent + 1);
}

void ReturnStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Return");
    if (value) value->dump(out, indent + 1);
}

void DeleteStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Delete");
    target->dump(out, indent + 1);
}

void ReleaseStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Release region " + region);
}

void MatchStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Match");
    subject->dump(out, indent + 1);
    for (const auto& c : cases) {
        std::string head = "case " + c.typeName + "(";
        for (std::size_t i = 0; i < c.bindings.size(); ++i)
            head += (i ? ", " : "") + c.bindings[i].type.name + " " + c.bindings[i].name;
        line(out, indent + 1, head + ")");
        c.body.dump(out, indent + 2);
    }
    if (defaultBody) {
        line(out, indent + 1, "default");
        defaultBody->dump(out, indent + 2);
    }
}

void MatchExpr::dump(std::string& out, int indent) const {
    line(out, indent, "MatchExpr");
    subject->dump(out, indent + 1);
    for (const auto& c : cases) {
        std::string head = "case " + c.typeName + "(";
        for (std::size_t i = 0; i < c.bindings.size(); ++i)
            head += (i ? ", " : "") + c.bindings[i].type.name + " " + c.bindings[i].name;
        line(out, indent + 1, head + ") ->");
        if (c.result) c.result->dump(out, indent + 2);
    }
    if (defaultResult) {
        line(out, indent + 1, "default ->");
        defaultResult->dump(out, indent + 2);
    }
}

void StaticAssertStmt::dump(std::string& out, int indent) const {
    line(out, indent, "StaticAssert \"" + message + "\"");
    condition->dump(out, indent + 1);
}

void BreakStmt::dump(std::string& out, int indent) const { line(out, indent, "Break"); }
void ContinueStmt::dump(std::string& out, int indent) const { line(out, indent, "Continue"); }

void SwitchStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Switch");
    subject->dump(out, indent + 1);
    for (const auto& c : cases) {
        line(out, indent + 1, "case");
        c.value->dump(out, indent + 2);
        c.body.dump(out, indent + 2);
    }
    if (defaultBody) {
        line(out, indent + 1, "default");
        defaultBody->dump(out, indent + 2);
    }
}

void ForeachStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Foreach " + elemType.name + " " + varName);
    iterable->dump(out, indent + 1);
    body.dump(out, indent + 1);
}

void DeferStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Defer");
    body.dump(out, indent + 1);
}

void UsingStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Using '" + varName + "'");
    decl->dump(out, indent + 1);
    body.dump(out, indent + 1);
}

void VarDeclStmt::dump(std::string& out, int indent) const {
    std::string head = "VarDecl '" + name + "'";
    if (isMutable) head += " mutable";
    head += isVar ? " var" : (" : " + typeText(type));
    line(out, indent, head);
    init->dump(out, indent + 1);
}

void AssignStmt::dump(std::string& out, int indent) const {
    line(out, indent, "Assign");
    line(out, indent + 1, "target:");
    target->dump(out, indent + 2);
    line(out, indent + 1, "value:");
    value->dump(out, indent + 2);
}

void IncDecStmt::dump(std::string& out, int indent) const {
    line(out, indent, std::string("IncDec ") + (isIncrement ? "'++'" : "'--'"));
    target->dump(out, indent + 1);
}

void Block::dump(std::string& out, int indent) const {
    line(out, indent, "Block");
    for (const auto& s : statements) s->dump(out, indent + 1);
}

void IfStmt::dump(std::string& out, int indent) const {
    line(out, indent, "If");
    line(out, indent + 1, "cond:");
    cond->dump(out, indent + 2);
    line(out, indent + 1, "then:");
    thenBlock.dump(out, indent + 2);
    if (elseBlock) {
        line(out, indent + 1, "else:");
        elseBlock->dump(out, indent + 2);
    }
}

void WhileStmt::dump(std::string& out, int indent) const {
    line(out, indent, "While");
    line(out, indent + 1, "cond:");
    cond->dump(out, indent + 2);
    line(out, indent + 1, "body:");
    body.dump(out, indent + 2);
}

void ForStmt::dump(std::string& out, int indent) const {
    line(out, indent, "For");
    if (init) {
        line(out, indent + 1, "init:");
        init->dump(out, indent + 2);
    }
    line(out, indent + 1, "cond:");
    cond->dump(out, indent + 2);
    if (update) {
        line(out, indent + 1, "update:");
        update->dump(out, indent + 2);
    }
    line(out, indent + 1, "body:");
    body.dump(out, indent + 2);
}

void MethodDecl::dump(std::string& out, int indent) const {
    std::string head = "Method '" + name + "'";
    if (!visibility.empty()) head += " " + visibility;
    if (isStatic) head += " static";
    if (isAbstract) head += " abstract";
    if (isOverride) head += " override";
    if (isFinal) head += " final";
    head += " returns " + typeText(returnType);
    line(out, indent, head);
    for (const auto& p : params) {
        line(out, indent + 1, "Param '" + p.name + "': " + typeText(p.type));
    }
    if (!isAbstract) body.dump(out, indent + 1);
}

void FieldDecl::dump(std::string& out, int indent) const {
    std::string head = "Field '" + name + "' : " + typeText(type);
    if (!visibility.empty()) head += " " + visibility;
    if (isStatic) head += " static";
    if (isMutable) head += " mutable";
    line(out, indent, head);
    if (init) init->dump(out, indent + 1);
}

void ConstructorDecl::dump(std::string& out, int indent) const {
    std::string head = "Constructor";
    if (!visibility.empty()) head += " " + visibility;
    line(out, indent, head);
    for (const auto& p : params) {
        line(out, indent + 1, "Param '" + p.name + "': " + typeText(p.type));
    }
    body.dump(out, indent + 1);
}

void DestructorDecl::dump(std::string& out, int indent) const {
    std::string head = "Destructor";
    if (!visibility.empty()) head += " " + visibility;
    line(out, indent, head);
    body.dump(out, indent + 1);
}

void ClassDecl::dump(std::string& out, int indent) const {
    std::string head = (isInterface ? "Interface '"
                        : isRecord  ? "Record '"
                        : isUnion   ? "Union '"
                        : isStruct  ? "Struct '"
                                    : "Class '") +
                       name + "'";
    if (!visibility.empty()) head += " " + visibility;
    if (isAbstract && !isInterface) head += " abstract";
    if (isMovable) head += " movable";
    if (isUnique) head += " unique";
    if (!superclass.empty()) head += " extends " + superclass;
    for (const auto& i : interfaces) head += " implements " + i;
    line(out, indent, head);
    for (const auto& m : members) m->dump(out, indent + 1);
}

void EnumDecl::dump(std::string& out, int indent) const {
    std::string head = "Enum '" + name + "'";
    if (!visibility.empty()) head += " " + visibility;
    if (isJavaStyle) head += " java-style";
    line(out, indent, head);
    for (const auto& c : constants) line(out, indent + 1, "Constant '" + c + "'");
    for (const auto& m : members) m->dump(out, indent + 1);
}

void LiteralDecl::dump(std::string& out, int indent) const {
    std::string head = "Literal '" + name + "'";
    if (!visibility.empty()) head += " " + visibility;
    if (isComptime) head += " comptime";
    head += " (" + param.type.name + " " + param.name + ") returns " + returnType.name;
    line(out, indent, head);
}

void Namespace::dump(std::string& out, int indent) const {
    std::string head = "Namespace '" + name + "'";
    if (!visibility.empty()) head += " " + visibility;
    line(out, indent, head);
    for (const auto& e : enums) e.dump(out, indent + 1);
    for (const auto& l : literals) l.dump(out, indent + 1);
    for (const auto& c : classes) c.dump(out, indent + 1);
}

void Bundle::dump(std::string& out, int indent) const {
    std::string head = "Bundle '" + name + "'";
    if (!visibility.empty()) head += " " + visibility;
    line(out, indent, head);
    for (const auto& n : namespaces) n.dump(out, indent + 1);
}

void Program::dump(std::string& out, int indent) const {
    line(out, indent, "Program '" + name + "'");
    for (const auto& b : bundles) b.dump(out, indent + 1);
}

}  // namespace ldp3::ast
