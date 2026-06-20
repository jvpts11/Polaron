#include <doctest/doctest.h>

#include "lexer/lexer.h"
#include "parser/parser.h"

using namespace ldp3;

namespace {
const char* kHello =
    "program HelloWorld;\n"
    "public bundle main {\n"
    "  public namespace app {\n"
    "    public class Main {\n"
    "      public static method main(string[] args) returns void {\n"
    "        System.IO.printf(\"x\", 1);\n"
    "      }\n"
    "    }\n"
    "  }\n"
    "}\n";
}  // namespace

TEST_CASE("parser builds the program hierarchy") {
    Lexer lexer(kHello, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());
    CHECK(prog.name == "HelloWorld");
    REQUIRE(prog.bundles.size() == 1);
    CHECK(prog.bundles[0].name == "main");
    CHECK(prog.bundles[0].visibility == "public");
    REQUIRE(prog.bundles[0].namespaces.size() == 1);
    CHECK(prog.bundles[0].namespaces[0].name == "app");
    REQUIRE(prog.bundles[0].namespaces[0].classes.size() == 1);
    CHECK(prog.bundles[0].namespaces[0].classes[0].name == "Main");
}

TEST_CASE("parser parses a member-access call expression") {
    Lexer lexer(kHello, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());

    const ast::ClassDecl& cls = prog.bundles.at(0).namespaces.at(0).classes.at(0);
    REQUIRE(cls.members.size() == 1);
    const auto* method = dynamic_cast<const ast::MethodDecl*>(cls.members[0].get());
    REQUIRE(method != nullptr);
    REQUIRE(method->body.statements.size() == 1);
    const auto* stmt = dynamic_cast<const ast::ExprStmt*>(method->body.statements[0].get());
    REQUIRE(stmt != nullptr);
    const auto* call = dynamic_cast<const ast::CallExpr*>(stmt->expr.get());
    REQUIRE(call != nullptr);
    CHECK(call->args.size() == 2);
}

TEST_CASE("parser reports a missing semicolon with a location") {
    Lexer lexer("program P", "test");  // missing ';'
    Parser parser(lexer.tokenize(), "test");
    parser.parse();
    REQUIRE(parser.hasErrors());
    CHECK(parser.errors()[0].loc.line == 1);
}

TEST_CASE("parser reports a missing closing brace") {
    Lexer lexer("program P;\npublic bundle b {", "test");
    Parser parser(lexer.tokenize(), "test");
    parser.parse();
    CHECK(parser.hasErrors());
}

TEST_CASE("parser respects arithmetic precedence") {
    const char* src =
        "program P; public bundle b { public namespace n { public class Main {\n"
        "  public static method main(string[] args) returns void { int x = 1 + 2 * 3; }\n"
        "} } }";
    Lexer lexer(src, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());

    const ast::ClassDecl& cls = prog.bundles.at(0).namespaces.at(0).classes.at(0);
    const auto* method = dynamic_cast<const ast::MethodDecl*>(cls.members.at(0).get());
    REQUIRE(method != nullptr);
    REQUIRE(method->body.statements.size() == 1);
    const auto* decl = dynamic_cast<const ast::VarDeclStmt*>(method->body.statements[0].get());
    REQUIRE(decl != nullptr);
    const auto* add = dynamic_cast<const ast::BinaryExpr*>(decl->init.get());
    REQUIRE(add != nullptr);
    CHECK(add->op == "+");
    // The multiplication binds tighter, so it must be the right operand of '+'.
    const auto* mul = dynamic_cast<const ast::BinaryExpr*>(add->rhs.get());
    REQUIRE(mul != nullptr);
    CHECK(mul->op == "*");
}

TEST_CASE("parser parses throw, try/catch/finally and a throws clause") {
    const char* src =
        "program P; public bundle b { public namespace n {\n"
        "  public class MyError { public constructor MyError() {} }\n"
        "  public class Main {\n"
        "    public static method risky(int x) throws(MyError) returns void {\n"
        "      if (x > 0) { throw new MyError(); }\n"
        "    }\n"
        "    public static method main(string[] args) returns void {\n"
        "      try { Main.risky(1); } catch (MyError e) { } finally { }\n"
        "    }\n"
        "  }\n"
        "} }";
    Lexer lexer(src, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());

    const auto& classes = prog.bundles.at(0).namespaces.at(0).classes;
    REQUIRE(classes.size() == 2);
    const ast::ClassDecl& mainCls = classes.at(1);
    // risky: declares throws(MyError) and throws inside an if.
    const auto* risky = dynamic_cast<const ast::MethodDecl*>(mainCls.members.at(0).get());
    REQUIRE(risky != nullptr);
    REQUIRE(risky->throwsTypes.size() == 1);
    const auto* ifStmt = dynamic_cast<const ast::IfStmt*>(risky->body.statements.at(0).get());
    REQUIRE(ifStmt != nullptr);
    const auto* thr =
        dynamic_cast<const ast::ThrowStmt*>(ifStmt->thenBlock.statements.at(0).get());
    REQUIRE(thr != nullptr);
    CHECK(thr->value != nullptr);
    // main: a try with one catch and a finally.
    const auto* mainM = dynamic_cast<const ast::MethodDecl*>(mainCls.members.at(1).get());
    REQUIRE(mainM != nullptr);
    const auto* tryStmt = dynamic_cast<const ast::TryStmt*>(mainM->body.statements.at(0).get());
    REQUIRE(tryStmt != nullptr);
    REQUIRE(tryStmt->catches.size() == 1);
    CHECK(tryStmt->catches.at(0).name == "e");
    CHECK(tryStmt->finallyBlock != nullptr);
}

TEST_CASE("parser parses a catalog and an enum implementing it (spec 12.3/12.4)") {
    const char* src =
        "program P; public bundle b { public namespace n {\n"
        "  public catalog TipoMotor {\n"
        "    combustao, h2, eletrico\n"
        "    method pick() returns int;\n"
        "  }\n"
        "  public enum Motor extends TipoMotor {\n"
        "    v8, v12, doisPistoes\n"
        "    byCatalog { combustao, h2, eletrico }\n"
        "    public method pick() returns int { return 1; }\n"
        "  }\n"
        "  public class Main { public static method main(string[] args) returns void { } }\n"
        "} }";
    Lexer lexer(src, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());

    const auto& ns = prog.bundles.at(0).namespaces.at(0);
    // The catalog: declares 3 required values and one required method signature.
    REQUIRE(ns.catalogs.size() == 1);
    const ast::CatalogDecl& cat = ns.catalogs.at(0);
    CHECK(cat.name == "TipoMotor");
    CHECK(cat.requiredValues.size() == 3);
    CHECK(cat.requiredValues.at(0) == "combustao");
    REQUIRE(cat.methods.size() == 1);
    const auto* pickSig = dynamic_cast<const ast::MethodDecl*>(cat.methods.at(0).get());
    REQUIRE(pickSig != nullptr);
    CHECK(pickSig->name == "pick");
    CHECK(pickSig->isAbstract);  // catalog methods are abstract signatures

    // The enum: NOT desugared to a class (kept as an enum), extends the catalog,
    // own constants first then byCatalog ones appended (ordinals continue).
    REQUIRE(ns.enums.size() == 1);
    const ast::EnumDecl& en = ns.enums.at(0);
    CHECK(en.name == "Motor");
    CHECK_FALSE(en.isJavaStyle);
    REQUIRE(en.extendsCatalogs.size() == 1);
    CHECK(en.extendsCatalogs.at(0) == "TipoMotor");
    REQUIRE(en.constants.size() == 6);
    CHECK(en.constants.at(0) == "v8");
    CHECK(en.constants.at(3) == "combustao");
    CHECK(en.constants.at(5) == "eletrico");
    CHECK(en.byCatalogValues.size() == 3);
    CHECK(en.constantArgs.size() == 6);  // kept parallel to constants
    REQUIRE(en.members.size() == 1);     // the catalog method impl stays on the enum
}
