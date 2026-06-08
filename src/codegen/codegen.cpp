#include "codegen/codegen.h"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/raw_ostream.h>

#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <utility>

#include "parser/ast.h"

namespace ldp3 {

namespace {

// Resolves escape sequences in a raw string/char body into real bytes.
std::string resolveEscapes(const std::string& raw) {
    std::string out;
    for (std::size_t i = 0; i < raw.size(); ++i) {
        if (raw[i] == '\\' && i + 1 < raw.size()) {
            switch (raw[++i]) {
                case 'n': out += '\n'; break;
                case 't': out += '\t'; break;
                case 'r': out += '\r'; break;
                case '0': out += '\0'; break;
                case '\\': out += '\\'; break;
                case '\'': out += '\''; break;
                case '"': out += '"'; break;
                default: out += raw[i]; break;
            }
        } else {
            out += raw[i];
        }
    }
    return out;
}

// Parses an integer-literal lexeme (decimal/hex/binary, '_' separators,
// optional L suffix) into a value.
std::int64_t parseIntLiteral(const std::string& lexeme) {
    std::string s;
    for (char c : lexeme) {
        if (c == '_' || c == 'L' || c == 'l') continue;
        s += c;
    }
    int base = 10;
    std::size_t start = 0;
    if (s.size() >= 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
        base = 16;
        start = 2;
    } else if (s.size() >= 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B')) {
        base = 2;
        start = 2;
    }
    try {
        return static_cast<std::int64_t>(std::stoll(s.substr(start), nullptr, base));
    } catch (...) {
        return 0;
    }
}

}  // namespace

struct CodeGenerator::Impl {
    const EntryPoint& entry;
    std::vector<CodegenError>& errors;
    llvm::LLVMContext context;
    llvm::Module module;
    llvm::IRBuilder<> builder;
    std::unordered_map<std::string, llvm::Value*> locals;

    Impl(const EntryPoint& e, std::string_view name, std::vector<CodegenError>& errs)
        : entry(e), errors(errs), module(std::string(name), context), builder(context) {}

    void error(std::string message, SourceLocation loc) {
        errors.push_back(CodegenError{std::move(message), loc});
    }

    llvm::FunctionCallee printf() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, /*isVarArg=*/true);
        return module.getOrInsertFunction("printf", ty);
    }

    // Flattens a callee like System.IO.printf into a dotted string, or "" if it
    // is not a plain identifier/member chain.
    std::string flattenCallee(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            return id->name;
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
            const std::string base = flattenCallee(*mem->object);
            if (base.empty()) return "";
            return base + "." + mem->member;
        }
        return "";
    }

    llvm::Value* emitExpr(const ast::Expr& expr) {
        if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
            return builder.CreateGlobalStringPtr(resolveEscapes(s->value), ".str");
        }
        if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
            return builder.getInt32(static_cast<std::uint32_t>(parseIntLiteral(n->text)));
        }
        if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&expr)) {
            const std::string bytes = resolveEscapes(c->value);
            const unsigned char value = bytes.empty() ? 0 : static_cast<unsigned char>(bytes[0]);
            return builder.getInt32(value);  // promoted for printf varargs
        }
        if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&expr)) {
            return builder.getInt32(b->value ? 1 : 0);
        }
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            auto it = locals.find(id->name);
            if (it == locals.end()) {
                error("use of undeclared variable '" + id->name + "'", id->loc);
                return nullptr;
            }
            return builder.CreateLoad(builder.getInt32Ty(), it->second, id->name);
        }
        if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
            llvm::Value* v = emitExpr(*un->operand);
            if (v == nullptr) return nullptr;
            if (un->op == "-") return builder.CreateNeg(v);
            if (un->op == "!") {
                llvm::Value* isZero = builder.CreateICmpEQ(v, builder.getInt32(0));
                return builder.CreateZExt(isZero, builder.getInt32Ty());
            }
            error("unsupported unary operator '" + un->op + "'", un->loc);
            return nullptr;
        }
        if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
            llvm::Value* l = emitExpr(*bin->lhs);
            llvm::Value* r = emitExpr(*bin->rhs);
            if (l == nullptr || r == nullptr) return nullptr;
            const std::string& op = bin->op;
            if (op == "+") return builder.CreateAdd(l, r);
            if (op == "-") return builder.CreateSub(l, r);
            if (op == "*") return builder.CreateMul(l, r);
            if (op == "/") return builder.CreateSDiv(l, r);
            if (op == "%") return builder.CreateSRem(l, r);

            // Comparisons yield i1; widen to i32 since booleans are i32 0/1.
            llvm::Value* cmp = nullptr;
            if (op == "==") cmp = builder.CreateICmpEQ(l, r);
            else if (op == "!=") cmp = builder.CreateICmpNE(l, r);
            else if (op == "<") cmp = builder.CreateICmpSLT(l, r);
            else if (op == ">") cmp = builder.CreateICmpSGT(l, r);
            else if (op == "<=") cmp = builder.CreateICmpSLE(l, r);
            else if (op == ">=") cmp = builder.CreateICmpSGE(l, r);
            if (cmp != nullptr) return builder.CreateZExt(cmp, builder.getInt32Ty());

            // Logical &&/|| (no short-circuit yet; operands are booleans 0/1).
            if (op == "&&" || op == "||") {
                llvm::Value* lb = builder.CreateICmpNE(l, builder.getInt32(0));
                llvm::Value* rb = builder.CreateICmpNE(r, builder.getInt32(0));
                llvm::Value* res =
                    (op == "&&") ? builder.CreateAnd(lb, rb) : builder.CreateOr(lb, rb);
                return builder.CreateZExt(res, builder.getInt32Ty());
            }
            error("unsupported binary operator '" + op + "'", bin->loc);
            return nullptr;
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            return emitCall(*call);
        }
        error("unsupported expression in codegen (0.1 walking skeleton)", expr.loc);
        return nullptr;
    }

    llvm::Value* emitCall(const ast::CallExpr& call) {
        const std::string name = flattenCallee(*call.callee);
        if (name == "System.IO.printf") {
            std::vector<llvm::Value*> args;
            for (const auto& arg : call.args) {
                llvm::Value* v = emitExpr(*arg);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
            return builder.CreateCall(printf(), args);
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) +
                  "' (0.1 only supports System.IO.printf)",
              call.loc);
        return nullptr;
    }

    void emitStatement(const ast::Stmt& stmt) {
        if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(&stmt)) {
            emitIf(*ifs);
            return;
        }
        if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&stmt)) {
            emitWhile(*ws);
            return;
        }
        if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&stmt)) {
            emitFor(*fs);
            return;
        }
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
            llvm::Value* initV = emitExpr(*vd->init);
            if (initV == nullptr) return;
            llvm::Value* slot = createEntryAlloca(vd->name);
            builder.CreateStore(initV, slot);
            locals[vd->name] = slot;
            return;
        }
        if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
            auto it = locals.find(assign->target);
            if (it == locals.end()) {
                error("assignment to undeclared variable '" + assign->target + "'", assign->loc);
                return;
            }
            llvm::Value* v = emitExpr(*assign->value);
            if (v == nullptr) return;
            builder.CreateStore(v, it->second);
            return;
        }
        if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
            auto it = locals.find(incdec->target);
            if (it == locals.end()) {
                error("modification of undeclared variable '" + incdec->target + "'", incdec->loc);
                return;
            }
            llvm::Value* cur = builder.CreateLoad(builder.getInt32Ty(), it->second, incdec->target);
            llvm::Value* one = builder.getInt32(1);
            llvm::Value* res =
                incdec->isIncrement ? builder.CreateAdd(cur, one) : builder.CreateSub(cur, one);
            builder.CreateStore(res, it->second);
            return;
        }
        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
            emitExpr(*es->expr);
            return;
        }
        if (dynamic_cast<const ast::ReturnStmt*>(&stmt) != nullptr) {
            // `return;` in a void main maps to `ret i32 0`, emitted below.
            return;
        }
        error("unsupported statement in codegen (0.1 walking skeleton)", stmt.loc);
    }

    // Allocas live at the top of the entry block so they are not re-run inside
    // loops (the function frame reserves them once).
    llvm::Value* createEntryAlloca(const std::string& name) {
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock& entryBB = fn->getEntryBlock();
        llvm::IRBuilder<> tmp(&entryBB, entryBB.begin());
        return tmp.CreateAlloca(builder.getInt32Ty(), nullptr, name);
    }

    void emitBlock(const ast::Block& block) {
        for (const auto& stmt : block.statements) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) break;  // unreachable
            emitStatement(*stmt);
        }
    }

    void emitIf(const ast::IfStmt& s) {
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        llvm::Value* condBool = builder.CreateICmpNE(condV, builder.getInt32(0));
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "if.then", fn);
        llvm::BasicBlock* elseBB =
            s.elseBlock ? llvm::BasicBlock::Create(context, "if.else", fn) : nullptr;
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "if.end", fn);
        builder.CreateCondBr(condBool, thenBB, elseBB != nullptr ? elseBB : endBB);

        builder.SetInsertPoint(thenBB);
        emitBlock(s.thenBlock);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);

        if (elseBB != nullptr) {
            builder.SetInsertPoint(elseBB);
            emitBlock(*s.elseBlock);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
        }

        builder.SetInsertPoint(endBB);
    }

    void emitWhile(const ast::WhileStmt& s) {
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "while.cond", fn);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "while.body", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "while.end", fn);
        builder.CreateBr(condBB);

        builder.SetInsertPoint(condBB);
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        builder.CreateCondBr(builder.CreateICmpNE(condV, builder.getInt32(0)), bodyBB, endBB);

        builder.SetInsertPoint(bodyBB);
        emitBlock(s.body);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(condBB);

        builder.SetInsertPoint(endBB);
    }

    void emitFor(const ast::ForStmt& s) {
        if (s.init) emitStatement(*s.init);
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "for.cond", fn);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "for.body", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "for.end", fn);
        builder.CreateBr(condBB);

        builder.SetInsertPoint(condBB);
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        builder.CreateCondBr(builder.CreateICmpNE(condV, builder.getInt32(0)), bodyBB, endBB);

        builder.SetInsertPoint(bodyBB);
        emitBlock(s.body);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            if (s.update) emitStatement(*s.update);
            builder.CreateBr(condBB);
        }

        builder.SetInsertPoint(endBB);
    }

    void emitMain() {
        llvm::FunctionType* mainTy = llvm::FunctionType::get(builder.getInt32Ty(), false);
        llvm::Function* mainFn =
            llvm::Function::Create(mainTy, llvm::Function::ExternalLinkage, "main", module);
        llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "entry", mainFn);
        builder.SetInsertPoint(block);

        emitBlock(entry.method->body);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateRet(builder.getInt32(0));
        }
    }
};

CodeGenerator::CodeGenerator(const EntryPoint& entry, std::string_view moduleName)
    : impl_(std::make_unique<Impl>(entry, moduleName, errors_)) {}

CodeGenerator::~CodeGenerator() = default;

bool CodeGenerator::generate() {
    if (impl_->entry.method == nullptr) {
        errors_.push_back(CodegenError{"no entry point to generate", {}});
        return false;
    }
    impl_->emitMain();
    if (!errors_.empty()) return false;

    std::string verifyMsg;
    llvm::raw_string_ostream os(verifyMsg);
    if (llvm::verifyModule(impl_->module, &os)) {
        errors_.push_back(CodegenError{"module verification failed: " + verifyMsg, {}});
        return false;
    }
    return true;
}

std::string CodeGenerator::toIR() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    impl_->module.print(os, nullptr);
    return out;
}

}  // namespace ldp3
