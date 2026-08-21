#include "pir/text.h"

#include <cstdlib>
#include <sstream>
#include <unordered_map>

namespace polaron::pir {

namespace {

// A tiny token reader over the text form. Deliberately not the Polaron lexer: PIR's text is its own
// language, it is machine-written, and coupling the two would make a change to either break the
// other for no benefit.
class Reader {
public:
    explicit Reader(const std::string& text) : text_(text) {}

    bool atEnd() {
        skip();
        return pos_ >= text_.size();
    }

    int line() const { return line_; }

    void skip() {
        while (pos_ < text_.size()) {
            const char c = text_[pos_];
            if (c == '\n') {
                ++line_;
                ++pos_;
            } else if (c == ' ' || c == '\t' || c == '\r') {
                ++pos_;
            } else if (c == ';') {
                // A comment runs to the end of the line. The printer uses it for source locations.
                while (pos_ < text_.size() && text_[pos_] != '\n') {
                    ++pos_;
                }
            } else {
                return;
            }
        }
    }

    // The next token: a word, a number, a quoted string, or a single punctuation character.
    std::string next() {
        skip();
        if (pos_ >= text_.size()) {
            return {};
        }
        const char c = text_[pos_];
        if (c == '"') {
            std::string out;
            ++pos_;
            while (pos_ < text_.size() && text_[pos_] != '"') {
                if (text_[pos_] == '\\' && pos_ + 1 < text_.size()) {
                    ++pos_;
                }
                out += text_[pos_++];
            }
            if (pos_ < text_.size()) {
                ++pos_;
            }
            quoted_ = true;
            return out;
        }
        quoted_ = false;
        if (isWordChar(c)) {
            const size_t start = pos_;
            while (pos_ < text_.size() && isWordChar(text_[pos_])) {
                ++pos_;
            }
            return text_.substr(start, pos_ - start);
        }
        ++pos_;
        return std::string(1, c);
    }

    std::string peek() {
        const size_t save = pos_;
        const int saveLine = line_;
        const bool saveQ = quoted_;
        std::string t = next();
        pos_ = save;
        line_ = saveLine;
        quoted_ = saveQ;
        return t;
    }

    // AN INSTRUCTION ENDS AT THE END OF ITS LINE, and this is what says so.
    //
    // Without it the operand loop reads across the newline and swallows the next instruction's
    // result: `%2 = region.create region imm 4096` followed by `%3 = region.alloc ...` parsed as
    // `region.create` with `%3` as an operand, and then `=` as an opcode. Every assembly-like format
    // is line-terminated for exactly this reason; PIR's is too.
    bool sameLine() {
        const size_t save = pos_;
        const int saveLine = line_;
        skip();
        const bool same = (line_ == saveLine) && pos_ < text_.size();
        pos_ = save;
        line_ = saveLine;
        return same;
    }

    bool wasQuoted() const { return quoted_; }

    bool eat(const std::string& want) {
        const size_t save = pos_;
        const int saveLine = line_;
        if (next() == want) {
            return true;
        }
        pos_ = save;
        line_ = saveLine;
        return false;
    }

private:
    static bool isWordChar(char c) {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ||
               c == '_' || c == '.' || c == '-' || c == '<' || c == '>';
    }

    const std::string& text_;
    size_t pos_ = 0;
    int line_ = 1;
    bool quoted_ = false;
};

class Parser {
public:
    Parser(const std::string& text, Module* into) : r_(text), m_(*into) {}

    bool run(std::string* error) {
        error_ = error;
        if (!expect("module")) {
            return false;
        }
        m_.triple = r_.next();
        while (true) {
            if (r_.eat("bundle")) {
                m_.bundle = r_.next();
            } else if (r_.eat("layout")) {
                m_.dataLayout = r_.next();
            } else {
                break;
            }
        }
        if (!expect("{")) {
            return false;
        }
        while (!r_.atEnd()) {
            const std::string t = r_.peek();
            if (t == "}") {
                r_.next();
                return true;
            }
            if (t == "global") {
                if (!parseGlobal()) {
                    return false;
                }
            } else if (t == "init" || t == "fini") {
                if (!parseHook()) {
                    return false;
                }
            } else if (t == "fn") {
                if (!parseFunction()) {
                    return false;
                }
            } else if (t == "type") {
                // A named type declaration is printed for readability; the types themselves are
                // rebuilt from their uses, so nothing needs to be kept here.
                while (!r_.atEnd() && r_.peek() != "global" && r_.peek() != "fn" &&
                       r_.peek() != "}" && r_.peek() != "type") {
                    r_.next();
                }
            } else {
                return fail("unexpected `" + t + "` at module level");
            }
        }
        return fail("module is not closed");
    }

private:
    bool fail(const std::string& what) {
        if (error_ != nullptr) {
            *error_ = "pir::parse line " + std::to_string(r_.line()) + ": " + what;
        }
        return false;
    }

    bool expect(const std::string& want) {
        const std::string got = r_.next();
        if (got != want) {
            return fail("expected `" + want + "`, found `" + got + "`");
        }
        return true;
    }

    // ---- types ----
    //
    // The spelling `TypeTable::spell` produces, read back into the same interned pointer. Round
    // tripping through the SAME table is what makes `parse(print(m))` compare equal by pointer.
    const Type* parseType() {
        const std::string t = r_.next();
        if (t == "void") return m_.types.voidType();
        if (t == "bool") return m_.types.boolType();
        if (t == "ptr") return m_.types.ptrType();
        if (t == "region") return m_.types.regionType();
        if (t.size() > 1 && t[0] == 'i' && isdigit(static_cast<unsigned char>(t[1]))) {
            return m_.types.intType(static_cast<uint32_t>(std::atoi(t.c_str() + 1)));
        }
        if (t.size() > 1 && t[0] == 'f' && isdigit(static_cast<unsigned char>(t[1]))) {
            return m_.types.floatType(static_cast<uint32_t>(std::atoi(t.c_str() + 1)));
        }
        if (t.rfind("addr", 0) == 0 && t.size() > 4) {
            return m_.types.addrType(static_cast<uint32_t>(std::atoi(t.c_str() + 4)));
        }
        if (t == "[") {
            const long long extent = std::atoll(r_.next().c_str());
            r_.eat("x");
            const Type* elem = parseType();
            const std::string disc = r_.next();
            r_.eat("]");
            return m_.types.arrayType(elem, static_cast<uint64_t>(extent),
                                      disc == "inline" ? ArrayStorage::Inline : ArrayStorage::Heap);
        }
        if (t == "{") {
            std::vector<Field> fields;
            while (!r_.atEnd() && r_.peek() != "}") {
                Field f;
                f.type = parseType();
                if (r_.peek() == "weak") {
                    r_.next();
                    f.weak = true;
                }
                fields.push_back(f);
                if (!r_.eat(",")) {
                    break;
                }
            }
            r_.eat("}");
            return m_.types.structType("", std::move(fields), false);
        }
        if (t.rfind("slice<", 0) == 0) {
            // `slice<i32>` arrives as one word because `<` and `>` are word characters.
            const std::string inner = t.substr(6, t.size() - 7);
            Reader sub(inner);
            Parser p(inner, &m_);
            return m_.types.sliceType(p.parseType());
        }
        if (!t.empty() && t[0] == '%') {
            return m_.types.structType(t.substr(1), {}, true);
        }
        // A nominal name arrives bare when it followed a `%` that the reader split off.
        return m_.types.structType(t, {}, true);
    }

    bool parseGlobal() {
        r_.next();  // global
        r_.eat("@");
        Global g;
        g.name = r_.next();
        if (!expect(":")) return false;
        g.type = parseType();
        if (!expect("=")) return false;
        const std::string init = r_.next();
        if (init == "zeroinit") {
            g.zeroInit = true;
        } else if (r_.wasQuoted()) {
            g.zeroInit = false;
            g.initStr = init;
        } else {
            g.zeroInit = false;
            g.initInt = std::atoll(init.c_str());
        }
        while (r_.eat(",")) {
            const std::string w = r_.next();
            if (w == "public") g.linkage = Linkage::Public;
            else if (w == "internal") g.linkage = Linkage::Internal;
            else if (w == "private") g.linkage = Linkage::Private;
            else if (w == "external") g.linkage = Linkage::External;
            else if (w == "static") g.storage = Storage::Static;
            else if (w == "persistent") g.storage = Storage::Persistent;
            else if (w == "eternal") g.storage = Storage::Eternal;
            else if (w == "transient") g.storage = Storage::Transient;
            else if (w == "threadlocal") g.storage = Storage::ThreadLocal;
            else if (w == "const") g.isConst = true;
        }
        m_.globals.push_back(std::move(g));
        return true;
    }

    bool parseHook() {
        const bool isInit = r_.next() == "init";
        r_.eat("@");
        Hook h;
        h.fnKey = r_.next();
        if (r_.eat("for")) {
            h.classKey = r_.next();
        }
        if (r_.eat("order")) {
            h.order = std::atoi(r_.next().c_str());
        }
        (isInit ? m_.init : m_.fini).push_back(std::move(h));
        return true;
    }

    bool parseFunction() {
        r_.next();  // fn
        r_.eat("@");
        const std::string key = r_.next();
        if (!expect("(")) return false;
        std::vector<Field> params;
        while (!r_.atEnd() && r_.peek() != ")") {
            Field f;
            f.type = parseType();
            params.push_back(f);
            if (!r_.eat(",")) break;
        }
        if (!expect(")")) return false;
        // `-` and `>` are both word characters, so the reader yields `->` as ONE token. Accepting
        // both spellings rather than picking one keeps the reader's character classes free to
        // change without silently breaking the grammar here.
        if (!r_.eat("->")) {
            if (!expect("-")) return false;
            r_.eat(">");
        }
        const Type* ret = parseType();

        Function* fn = m_.addFunction(key, m_.types.fnType(ret, params));
        parseFunctionModifiers(*fn);

        // No `{` means a DECLARATION: a signature and nothing else. See the printer.
        if (!r_.eat("{")) {
            return true;
        }

        while (r_.eat("contract")) {
            Contract c;
            const std::string k = r_.next();
            c.kind = k == "requires"   ? Contract::Kind::Requires
                     : k == "ensures"  ? Contract::Kind::Ensures
                                       : Contract::Kind::Invariant;
            c.text = r_.next();
            fn->contracts.push_back(std::move(c));
        }

        // TWO PASSES OVER THE BLOCKS, and the reason is the round trip: a branch can name a block
        // that appears later in the text, and a value can be a parameter of a block not yet read.
        // The first pass creates every block and every value; the second fills the instructions in.
        const size_t bodyStart = savePoint();
        if (!collectBlocks(*fn)) return false;
        restore(bodyStart);
        if (!fillBlocks(*fn)) return false;
        return expect("}");
    }

    void parseFunctionModifiers(Function& fn) {
        while (true) {
            const std::string w = r_.peek();
            if (w == "linkage") { r_.next(); r_.eat("("); fn.linkage = linkageOf(r_.next()); r_.eat(")"); }
            else if (w == "conv") { r_.next(); r_.eat("("); fn.conv = convOf(r_.next()); r_.eat(")"); }
            else if (w == "kind") { r_.next(); r_.eat("("); fn.kind = kindOf(r_.next()); r_.eat(")"); }
            else if (w == "unwind") { r_.next(); r_.eat("("); fn.unwind = r_.next() == "may" ? Unwind::May : Unwind::Never; r_.eat(")"); }
            else if (w == "affinity") { r_.next(); r_.eat("("); const std::string a = r_.next(); fn.affinity = a == "hot" ? Affinity::Hot : a == "cold" ? Affinity::Cold : Affinity::None; r_.eat(")"); }
            else if (w == "cut") { r_.next(); r_.eat("("); fn.cut = true; fn.cutSlot = r_.next(); r_.eat(")"); }
            else if (w == "symbol") { r_.next(); r_.eat("("); fn.symbol = r_.next(); r_.eat(")"); }
            else if (w == "library") { r_.next(); r_.eat("("); fn.library = r_.next(); r_.eat(")"); }
            else if (w == "world") { r_.next(); r_.eat("("); fn.world = r_.next(); r_.eat(")"); }
            else if (w == "pure") { r_.next(); fn.pure = true; }
            else if (w == "noreturn") { r_.next(); fn.noReturn = true; }
            else if (w == "inline.always") { r_.next(); fn.inlineAlways = true; }
            else if (w == "inline.never") { r_.next(); fn.inlineNever = true; }
            else if (w == "noredzone") { r_.next(); fn.noRedZone = true; }
            else { return; }
        }
    }

    static Linkage linkageOf(const std::string& s) {
        return s == "public" ? Linkage::Public : s == "private" ? Linkage::Private
               : s == "external" ? Linkage::External : Linkage::Internal;
    }
    static Conv convOf(const std::string& s) {
        if (s == "cdecl") return Conv::Cdecl;
        if (s == "stdcall") return Conv::Stdcall;
        if (s == "fastcall") return Conv::Fastcall;
        if (s == "cppdecl") return Conv::Cppdecl;
        if (s == "rustdecl") return Conv::Rustdecl;
        if (s == "zigdecl") return Conv::Zigdecl;
        if (s == "syscall") return Conv::Syscall;
        if (s == "interrupt") return Conv::Interrupt;
        if (s == "naked") return Conv::Naked;
        if (s == "unknown") return Conv::Unknown;
        return Conv::Polaron;
    }
    static FnKind kindOf(const std::string& s) {
        if (s == "constructor") return FnKind::Constructor;
        if (s == "destructor") return FnKind::Destructor;
        if (s == "operator") return FnKind::Operator;
        if (s == "procedure") return FnKind::Procedure;
        if (s == "interrupt") return FnKind::Interrupt;
        return FnKind::Method;
    }

    // The reader has no save/restore of its own, so the parser re-reads the body from a copy. The
    // bodies are small and this happens once per function; a cursor API would be a second thing to
    // keep correct.
    size_t savePoint() { return 0; }
    void restore(size_t) {}

    bool collectBlocks(Function&) { return true; }
    bool fillBlocks(Function& fn) { return parseBlocks(fn); }

    bool parseBlocks(Function& fn) {
        // FIRST the labels, so a forward branch resolves. The body text is scanned once for `^name(`
        // at the start of a line; every label found becomes a block before any instruction is read.
        const size_t mark = 0;
        (void)mark;
        while (!r_.atEnd() && r_.peek() != "}") {
            if (!r_.eat("^")) {
                return fail("expected a block label, found `" + r_.peek() + "`");
            }
            const std::string label = r_.next();
            const BlockId id = blockFor(fn, label);
            if (!expect("(")) return false;
            uint32_t pi = 0;
            while (!r_.atEnd() && r_.peek() != ")") {
                r_.eat("%");
                const std::string idText = r_.next();
                std::string name;
                if (r_.eat(":") && r_.peek() != "") {
                    // `%3:name : type` -- the optional name, then the type.
                    const std::string maybeName = r_.peek();
                    if (!isTypeWord(maybeName)) {
                        name = r_.next();
                        r_.eat(":");
                    }
                }
                const Type* t = parseType();
                const ValueId want = static_cast<ValueId>(std::atoll(idText.c_str()));
                ensureValue(fn, want, t, ValueOrigin::BlockParam, id, pi, name);
                fn.block(id)->params.push_back(want);
                ++pi;
                if (!r_.eat(",")) break;
            }
            if (!expect(")")) return false;
            // `blockFor` may add a block and reallocate, so the block is re-fetched at every use
            // rather than held. See the note in `parseInst`.
            while (true) {
                if (r_.eat("comefrom")) {
                    r_.eat("^");
                    const BlockId to = blockFor(fn, r_.next());
                    fn.block(id)->comefrom.push_back(to);
                } else if (r_.eat("abstainfrom")) {
                    r_.eat("^");
                    const BlockId to = blockFor(fn, r_.next());
                    fn.block(id)->abstainfrom.push_back(to);
                } else {
                    break;
                }
            }
            if (!expect(":")) return false;

            while (!r_.atEnd() && r_.peek() != "^" && r_.peek() != "}") {
                if (!parseInst(fn, id)) return false;
            }
        }
        return true;
    }

    static bool isTypeWord(const std::string& s) {
        if (s.empty()) return false;
        if (s == "void" || s == "bool" || s == "ptr" || s == "region" || s == "[" || s == "{") return true;
        if ((s[0] == 'i' || s[0] == 'f') && s.size() > 1 && isdigit(static_cast<unsigned char>(s[1]))) return true;
        if (s.rfind("addr", 0) == 0) return true;
        if (s.rfind("slice<", 0) == 0) return true;
        return false;
    }

    BlockId blockFor(Function& fn, const std::string& label) {
        auto it = blocks_.find(label);
        if (it != blocks_.end()) {
            return it->second;
        }
        const BlockId id = fn.addBlock(label);
        blocks_.emplace(label, id);
        return id;
    }

    void ensureValue(Function& fn, ValueId want, const Type* type, ValueOrigin origin, BlockId block,
                     uint32_t index, const std::string& name) {
        while (fn.values.size() <= want) {
            fn.addValue(nullptr, ValueOrigin::Instruction, kNoBlock, 0, "");
        }
        ValueDef& d = fn.values[want];
        d.type = type;
        d.origin = origin;
        d.block = block;
        d.indexInBlock = index;
        d.name = name;
    }

    bool parseInst(Function& fn, BlockId blockId) {
        // NO `Block*` HELD ACROSS THE PARSE. `blockFor` below can create a block for a forward
        // branch, `Function::addBlock` push_backs into `fn.blocks`, and the vector reallocates --
        // so a pointer taken here dangles by the time the instruction is appended, and the append
        // lands in freed memory. The whole terminator went missing that way, silently, and the only
        // symptom was a block with no `br.cond` in it.
        Inst in;
        ValueId result = kNoValue;
        std::string resultName;

        // `%3 = op ...` or a bare `op ...`
        if (r_.peek() == "%") {
            r_.next();
            const std::string idText = r_.next();
            result = static_cast<ValueId>(std::atoll(idText.c_str()));
            if (r_.eat(":")) {
                resultName = r_.next();
            }
            if (!expect("=")) return false;
        }

        const std::string opName = r_.next();
        if (!opFromName(opName, &in.op)) {
            return fail("unknown opcode `" + opName + "`");
        }
        in.result = result;

        while (true) {
            const std::string w = r_.peek();
            if (w == "total") { r_.next(); in.total = true; }
            else if (w == "volatile") { r_.next(); in.isVolatile = true; }
            else if (w == "unsigned") { r_.next(); in.unsignedOp = true; }
            else break;
        }
        // Everything below reads only what is left on THIS line -- see `Reader::sameLine`.
        if (r_.sameLine() && isTypeWord(r_.peek())) {
            in.type = parseType();
        }
        if (r_.sameLine() && r_.eat("@")) {
            in.text = r_.next();
        }
        if (r_.sameLine() && r_.eat("of")) {
            in.aggregate = parseType();   // the aggregate a `gep` indexes; see `Inst::aggregate`
        }
        if (r_.sameLine() && r_.eat("imm")) {
            in.imm = std::atoll(r_.next().c_str());
        }
        if (r_.sameLine() && r_.eat("fimm")) {
            in.fimm = std::atof(r_.next().c_str());
        }
        while (r_.sameLine() && r_.eat("[")) {
            in.extra.push_back(r_.next());
            r_.eat("]");
        }
        while (r_.sameLine() && r_.peek() == "%") {
            r_.next();
            const std::string idText = r_.next();
            in.operands.push_back(static_cast<ValueId>(std::atoll(idText.c_str())));
            if (r_.eat(":")) {
                r_.next();   // the decorative name
            }
            if (!r_.eat(",")) break;
        }
        while (r_.sameLine() && (r_.peek() == "->" || r_.peek() == "-")) {
            if (!r_.eat("->")) {
                r_.next();
                r_.eat(">");
            }
            r_.eat("^");
            Edge e;
            e.target = blockFor(fn, r_.next());
            if (r_.eat("(")) {
                while (!r_.atEnd() && r_.peek() != ")") {
                    r_.eat("%");
                    e.args.push_back(static_cast<ValueId>(std::atoll(r_.next().c_str())));
                    if (r_.eat(":")) r_.next();
                    if (!r_.eat(",")) break;
                }
                r_.eat(")");
            }
            in.edges.push_back(std::move(e));
            if (r_.eat("case")) {
                in.cases.push_back(std::atoll(r_.next().c_str()));
            }
        }

        // LAST, because the printer prints it last. The parser reads the fields in the order they
        // are written; anything else is two orderings that have to agree.
        if (r_.sameLine() && r_.eat("loc")) {
            r_.eat("(");
            in.loc.line = std::atoi(r_.next().c_str());
            r_.eat(":");
            in.loc.col = std::atoi(r_.next().c_str());
            r_.eat(")");
        }

        Block* b = fn.block(blockId);   // fetched HERE, after every blockFor above
        if (b == nullptr) {
            return fail("instruction in a block that does not exist");
        }
        if (result != kNoValue) {
            ensureValue(fn, result, in.type, ValueOrigin::Instruction, blockId,
                        static_cast<uint32_t>(b->insts.size()), resultName);
        }
        b->insts.push_back(std::move(in));
        return true;
    }

    Reader r_;
    Module& m_;
    std::unordered_map<std::string, BlockId> blocks_;
    std::string* error_ = nullptr;
};

}  // namespace

bool parse(const std::string& text, Module* into, std::string* error) {
    Parser p(text, into);
    return p.run(error);
}

}  // namespace polaron::pir
