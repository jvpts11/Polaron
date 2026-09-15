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
                    // `\n`, `\r`, `\t` are the three the printer produces, because a token that
                    // spans a line would break the reader's *what is left on THIS line* rule -- see
                    // the note in `print.cpp`'s `quote`. Anything else after a backslash is that
                    // character itself, which is how `"` and `\` travel.
                    ++pos_;
                    const char esc = text_[pos_++];
                    out += esc == 'n' ? '\n' : esc == 'r' ? '\r' : esc == 't' ? '\t' : esc;
                    continue;
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

    // ONE TOKEN FURTHER, and there is exactly one question that needs it.
    //
    // `%` is two things in this grammar: a VALUE (`%3`) and a NOMINAL TYPE (`%ByteSize`). The sigil
    // never arrives glued to what follows it -- it is not a word character -- so the only thing that
    // tells them apart is whether the next token is a number, and asking that requires seeing past
    // the sigil without consuming it.
    //
    // A grammar where one character means two things is a grammar that needs lookahead somewhere.
    // Better here, in one method with the reason written on it, than as a special case at each of
    // the places a type may begin.
    std::string peekAfter() {
        const size_t save = pos_;
        const int saveLine = line_;
        const bool saveQ = quoted_;
        next();
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

    // WHERE THE READER IS, AND HOW TO PUT IT BACK. One caller: the pre-scan that collects a
    // function's block labels before its instructions are read (see `parseBlocks`). Exposed rather
    // than hidden behind a lambda because a rewind is a real thing this grammar needs once, and a
    // named pair of methods says so where a closure would not.
    struct Mark {
        size_t pos;
        int line;
        bool quoted;
    };
    Mark mark() const { return Mark{pos_, line_, quoted_}; }
    void rewind(const Mark& m) {
        pos_ = m.pos;
        line_ = m.line;
        quoted_ = m.quoted;
    }

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
        // `$` IS A NAME CHARACTER, and leaving it out is what made the round trip a claim.
        //
        // The monomorphiser mangles `ArrayList<String>` to `ArrayList$String`, so a dollar appears
        // in the name of nearly every global and function a real program has. The printer emits
        // those names; this reader stopped dead at the dollar. `parse(print(m))` is Stage 0's whole
        // acceptance criterion (polaron-ir.md §1.6), and it held only for modules with no generics
        // in them -- which is no module anybody compiles, since the standard library instantiates
        // `Option<String>` before a program has said anything at all.
        //
        // IT SURFACED FROM THE `.polb` CARRYING PIR: a bundle wrote seven megabytes of module text
        // and the consumer could not read line 60 of it. That is the argument for a section having
        // a reader -- a format nobody reads back is a format that is correct by assumption.
        // A TYPE NAME COMES THROUGH `TypeTable::spell`, WHICH DOES NOT QUOTE. `%Some$Certificate*`
        // is one name: the monomorphiser's `$`, and a star because the element is a pointer. The
        // reader is the tolerant half of the pair -- the printer quotes what it writes after `@`,
        // and the mangling characters below are what a `%`-spelled type can contain and must be
        // read back bare. `~` for a destructor's key belongs to the same family.
        // `+` IS PART OF A NUMBER, not an operator: a float at round-trip precision comes out as
        // `2.1474836470000000e+09`, and stopping at the plus reads the exponent as an instruction.
        // PIR has no infix arithmetic in its text form -- `add.wrap` is a word -- so nothing else
        // wants the character.
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ||
               c == '_' || c == '.' || c == '-' || c == '<' || c == '>' || c == '$' || c == '*' ||
               c == '~' || c == '+';
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
                // A NAMED TYPE IS BUILT, NOT SKIPPED.
                //
                // What stood here read the declaration and threw it away, on the reasoning that
                // *the types are rebuilt from their uses*. That is true of a structural type and
                // false of a nominal one, which is the only kind this line ever sees: `gep ptr
                // @level of %Mixer imm 1` names the struct and gives an INDEX into fields it does
                // not describe. Rebuilding from that yields `%Mixer` with nothing in it, and the
                // index then reads past the end of a type with no fields.
                //
                // The reasoning was never tested because the printer emitted no `type` lines at all,
                // so this branch had never run on anything.
                if (!parseTypeDecl()) {
                    return false;
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
    // A NOMINAL TYPE BY NAME -- LOOKED UP, NOT MINTED.
    //
    // `type %Mixer = {i32, i32}` appears once, at the top; every later `of %Mixer` is a REFERENCE to
    // it. Interning a fresh `%Mixer` with no fields at each reference does not overwrite the real
    // entry -- `structType` guards against that -- but it does hand back a DIFFERENT type with the
    // same name and nothing in it. The `gep` that follows then indexes field 1 of a struct with zero
    // fields, and the process dies with no diagnostic at all.
    //
    // Two things made it hard to see. The function it crashed in parses perfectly on its own, since
    // in isolation there is no full `%Mixer` to disagree with -- so the smallest reproducer is two
    // declarations, not one. And nothing had ever read a real module back, so the reference path was
    // exercised only by hand-written fixtures where the name was never declared either.
    //
    // A name that is genuinely not yet declared still gets the placeholder, which is the forward
    // reference `structType`'s own comment is about.
    const Type* nominal(const std::string& name) {
        if (const Type* known = m_.types.structNamed(name); known != nullptr) {
            return known;
        }
        return m_.types.structType(name, {}, true);
    }

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
        // `fn(ptr, i32) -> ptr` -- A FUNCTION TYPE, which `spell` has always printed and this has
        // never read. `call.indirect ptr of fn(ptr) -> ptr` names the shape of what it is calling
        // through, and without a case here `fn` fell through to the nominal branch and became a
        // struct called "fn", leaving `(ptr) -> ptr` to be read as instructions.
        if (t == "fn") {
            r_.eat("(");
            std::vector<Field> params;
            while (!r_.atEnd() && r_.peek() != ")") {
                Field f;
                f.type = parseType();
                params.push_back(f);
                if (!r_.eat(",")) {
                    break;
                }
            }
            r_.eat(")");
            // `-` and `>` are both word characters, so `->` may arrive as one token or as two --
            // the same accommodation `parseFunction` makes, and for the same reason.
            if (!r_.eat("->")) {
                r_.eat("-");
                r_.eat(">");
            }
            return m_.types.fnType(parseType(), std::move(params));
        }
        if (t.rfind("slice<", 0) == 0) {
            // `slice<i32>` arrives as one word because `<` and `>` are word characters.
            const std::string inner = t.substr(6, t.size() - 7);
            Reader sub(inner);
            Parser p(inner, &m_);
            return m_.types.sliceType(p.parseType());
        }
        // A NOMINAL TYPE, `%Mixer`, IN THE TWO SHAPES THE READER CAN HAND IT OVER IN.
        //
        // `%` is not a word character, so whether the sigil arrives glued to the name depends on
        // what the name starts with -- and for a lone `%` the branch below used to take
        // `t.substr(1)`, which is the EMPTY STRING. It returned an anonymous struct, consumed
        // nothing, and left `Mixer` sitting where an opcode was expected: `unknown opcode 'Mixer'`,
        // reported at a `gep` that is perfectly well formed.
        //
        // The comment under it already knew -- *a nominal name arrives bare when it followed a `%`
        // the reader split off* -- and the case above it swallowed the name before that line could
        // run. Two branches for one shape, in the wrong order, and the one that fired was the one
        // that could not work.
        return nominal(t == "%" ? r_.next() : (!t.empty() && t[0] == '%' ? t.substr(1) : t));
    }

    // `type %Mixer = {i32, ptr weak, i8 bits 4, i32 align 64}` -- the declaration the printer now
    // emits, read back into the table so a `gep` into it has fields to index.
    bool parseTypeDecl() {
        r_.next();   // type
        r_.eat("%");
        const std::string structName = r_.next();
        if (!expect("=") || !expect("{")) {
            return false;
        }
        std::vector<Field> fields;
        while (!r_.atEnd() && r_.peek() != "}") {
            Field f;
            f.type = parseType();
            // The three properties that decide where the bytes go, each optional and each read by
            // name so the order they were written in cannot matter.
            while (true) {
                if (r_.eat("weak")) {
                    f.weak = true;
                } else if (r_.eat("bits")) {
                    f.bitWidth = static_cast<uint32_t>(std::atoi(r_.next().c_str()));
                } else if (r_.eat("align")) {
                    f.alignOverride = static_cast<uint32_t>(std::atoi(r_.next().c_str()));
                } else {
                    break;
                }
            }
            fields.push_back(f);
            if (!r_.eat(",")) {
                break;
            }
        }
        if (!expect("}")) {
            return false;
        }
        m_.types.structType(structName, std::move(fields), true);
        return true;
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
        // A BLOCK LABEL IS A FUNCTION'S OWN, and this map was the module's.
        //
        // `^entry` names block 0 of whatever function it is written in, and every function has one.
        // Carried across, the second function's `^entry` resolved to the FIRST function's block id
        // -- harmless while both were block 0, and an index into another function's block vector as
        // soon as the two differ. The failure is an access violation with nothing to read, in the
        // second of two functions that each parse perfectly on their own, which is why the smallest
        // reproducer for it is two declarations rather than one.
        //
        // Never seen because nothing had ever parsed a module with two functions in it: the printer
        // emitted no type declarations, so no real module could be read back at all, and the
        // fixtures that could were single-function by hand.
        blocks_.clear();
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
        // FIRST THE LABELS, IN THE ORDER THEY ARE DECLARED -- and that order is the whole point.
        //
        // `blockFor` creates a block the first time a label is SEEN, and a `br -> ^forstep11` is
        // seen before `^forstep11:` is reached. So the blocks came out in mention order, which is
        // not declaration order, and the module printed back had its blocks shuffled: it parsed, it
        // was a valid module, and it was a DIFFERENT one. A round trip that only checks *did it
        // parse* would call that a pass.
        //
        // Block order is not decoration. The backend lays them out in this order, so a fall-through
        // edge that was free becomes a jump, and the text form would be quietly rewriting programs
        // it was asked only to carry.
        //
        // The pre-scan tracks brace depth because an inline struct type -- `{i32, ptr}` -- puts a
        // closing brace inside the body, and stopping at the first one would collect the labels of
        // only the first few blocks.
        {
            const Reader::Mark start = r_.mark();
            int depth = 0;
            // THE LINE OF THE TOKEN BEFORE THIS ONE, kept by hand rather than asked of `sameLine()`.
            //
            // `atEnd()` skips whitespace and DOES NOT PUT THE LINE COUNTER BACK -- it is a query
            // with a side effect. So by the time the loop condition has run, the reader is already
            // standing on the next token, and a `sameLine()` asked afterwards compares that token's
            // line with itself and answers *yes* every time. Every block header looked mid-line, no
            // label was collected, and the pre-scan silently did nothing at all: the reprint came
            // back in mention order exactly as before, which is a fix that reads correct and is not
            // running.
            int previousLine = r_.line();
            while (!r_.atEnd()) {
                // A DECLARATION STARTS A LINE; A BRANCH DOES NOT. `^forstep11(...)` on its own line
                // is where the block is declared, and `br -> ^forstep11()` in the middle of one is a
                // reference to it -- the same three characters, and only the position tells them
                // apart. Collecting both put the blocks back in MENTION order again, which is the
                // very thing this pre-scan exists to stop.
                const bool startsLine = r_.line() != previousLine;
                previousLine = r_.line();
                const std::string t = r_.peek();
                if (t == "}" && depth == 0) {
                    break;
                }
                r_.next();
                if (t == "{") {
                    ++depth;
                } else if (t == "}") {
                    --depth;
                } else if (t == "^" && startsLine && !r_.atEnd()) {
                    blockFor(fn, r_.next());
                    previousLine = r_.line();
                }
            }
            r_.rewind(start);
        }
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
                    //
                    // WHICH ONE THIS IS, DECIDED BY STRUCTURE AND NOT BY APPEARANCE. What stood here
                    // asked *does this word look like a type* -- and a parameter may be NAMED `ptr`,
                    // which is a perfectly ordinary thing to call a pointer. `%1:ptr : ptr` then had
                    // its name read as its type and left the real one behind: *expected `)`, found
                    // `:`*, in a method that is not wrong, 109 583 lines into a module.
                    //
                    // The two forms differ in how many colons they have, and that is a fact about
                    // the text rather than a guess about the word: a name is followed by a second
                    // `:`, a type by whatever ends the parameter.
                    if (r_.peekAfter() == ":") {
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
        // `%Mixer` IS A TYPE WHERE A TYPE IS EXPECTED, and `%3` is a value -- the same sigil, told
        // apart by whether a digit follows it. Without this, `alloca %ByteSize @ByteSize` read its
        // type as absent, took `%ByteSize` for an operand and tried `@` as the next opcode; and
        // accepting a bare `%` instead would have made `store %0:this, %2:this` read `%0` as a type
        // named `0`. Both spellings are one character apart and neither can be guessed.
        // ...AND `[` MEANS TWO THINGS TOO. It opens an array type (`[16 x i32 inline]`) and it opens
        // an EXTRA (`guard.null [dereference]`), and the extras are read further down this same
        // method. Read as a type, `[dereference]` gave an extent of zero and then ate whatever was
        // next looking for the `x` -- so a guard turned into a type nobody wrote and the rest of the
        // line became instructions. An array type always has a COUNT first; an extra never does.
        const std::string ahead = r_.peekAfter();
        const bool aheadIsNumber =
            !ahead.empty() && isdigit(static_cast<unsigned char>(ahead[0]));
        if (r_.sameLine() &&
            ((isTypeWord(r_.peek()) && (r_.peek() != "[" || aheadIsNumber)) ||
             (r_.peek() == "%" && !ahead.empty() && !aheadIsNumber))) {
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
            if (r_.eat("case")) {
                e.caseValue = std::atoll(r_.next().c_str());
            }
            in.edges.push_back(std::move(e));
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
