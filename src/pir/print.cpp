#include "pir/text.h"

#include <iomanip>
#include <sstream>

namespace polaron::pir {

namespace {

std::string quote(const std::string& s) {
    std::string out = "\"";
    for (char c : s) {
        // A NEWLINE INSIDE A TOKEN, IN A LINE-ORIENTED FORMAT.
        //
        // `fact.requires` carries the contract's own text, and a rendered condition is several lines
        // of tree. Printed raw inside the quotes, one token then spanned twenty lines -- and the
        // instruction reader's whole notion of an operand list is *what is left on THIS line*. Every
        // line after the first read as the start of a new instruction, and the parse failed on a
        // word out of the middle of somebody's `requires` clause: `unknown opcode 'offset'`.
        //
        // Escaping is the fix rather than teaching the reader about multi-line tokens, because a
        // format whose lines are its structure should have no token that crosses one. The reader
        // already unescapes; it just had nothing to unescape.
        if (c == '\n') {
            out += "\\n";
            continue;
        }
        if (c == '\r') {
            out += "\\r";
            continue;
        }
        if (c == '\t') {
            out += "\\t";
            continue;
        }
        if (c == '"' || c == '\\') {
            out += '\\';
        }
        out += c;
    }
    return out + "\"";
}

// A NAME, QUOTED WHEN IT HAS TO BE -- and the PRINTER decides that, not the reader.
//
// This is the fix for a round trip that was a claim. `parse(print(m))` is Stage 0's whole acceptance
// criterion (polaron-ir.md §1.6), and it held only for modules with no generics in them: the
// monomorphiser mangles `ArrayList<String>` to `ArrayList$String`, a pointer element keeps its star
// in `ArrayList$Certificate*`, a destructor is `~Some$String`. The reader's idea of a name character
// was a list somebody wrote once, and every mangling character added since was a chance to break the
// round trip with nothing to notice, because no real module was ever read back.
//
// The rule is inverted here so it cannot drift again. The printer knows exactly which characters the
// reader takes bare and quotes anything else, so a new mangling character costs nothing: it comes
// out quoted, and quoted tokens are something the reader has understood all along.
bool isBareNameChar(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' ||
           c == '.' || c == '-' || c == '<' || c == '>';
}

std::string name(const std::string& s) {
    if (s.empty()) {
        return quote(s);
    }
    for (char c : s) {
        if (!isBareNameChar(c)) {
            return quote(s);
        }
    }
    return s;
}

// A value's spelling. The NAME is decoration and the id is the identity, so the id is always printed
// -- `%3` round-trips, `%w` alone would not once two blocks both call something `w`.
std::string val(const Function& fn, ValueId v) {
    if (v == kNoValue) {
        return "%none";
    }
    const ValueDef* d = fn.value(v);
    if (d != nullptr && !d->name.empty()) {
        return "%" + std::to_string(v) + ":" + d->name;
    }
    return "%" + std::to_string(v);
}

class Printer {
public:
    explicit Printer(const Module& m) : m_(m) {}

    std::string run() {
        out_ << "module " << quote(m_.triple);
        if (!m_.bundle.empty()) {
            out_ << " bundle " << quote(m_.bundle);
        }
        if (!m_.dataLayout.empty()) {
            out_ << " layout " << quote(m_.dataLayout);
        }
        out_ << " {\n";

        // THE NAMED STRUCTS COME FIRST, AND UNTIL NOW THEY DID NOT COME AT ALL.
        //
        // A nominal struct is spelled `%Mixer` at every use, so a module that never declares it
        // tells a reader the name and nothing else -- and `gep ptr @level of %Mixer imm 1` is an
        // index into fields the reader has no way to know about. Parsing such a module produced the
        // right instructions over EMPTY structs, and the first `gep` past field zero walked off the
        // end of a type with nothing in it: an access violation, with no diagnostic, in a parser
        // whose acceptance criterion is that this cannot happen.
        //
        // It stayed invisible because nothing ever read a real module back. The grammar in `text.h`
        // has had `type %Point = {i32, i32}` in it from the start, the reader has had a branch for
        // `type` from the start -- one that SKIPS it, on the reasoning that *the types are rebuilt
        // from their uses* -- and the printer never emitted one, so the reasoning was never tested
        // against a use that cannot rebuild anything.
        //
        // First, because a use may precede a definition inside a function and the reader should not
        // need a second pass to resolve it.
        for (const auto& [structName, type] : m_.types.namedStructs()) {
            if (type == nullptr || type->fields.empty()) {
                continue;   // an opaque forward reference: the name is all there is to say
            }
            out_ << "  type %" << name(structName) << " = {";
            for (std::size_t i = 0; i < type->fields.size(); ++i) {
                if (i != 0) {
                    out_ << ", ";
                }
                printFieldShape(type->fields[i]);
            }
            out_ << "}\n";
        }
        if (!m_.types.namedStructs().empty()) {
            out_ << "\n";
        }

        for (const Global& g : m_.globals) {
            printGlobal(g);
        }
        if (!m_.globals.empty()) {
            out_ << "\n";
        }
        for (const Hook& h : m_.init) {
            out_ << "  init @" << name(h.fnKey) << " for " << name(h.classKey) << " order "
                 << h.order << "\n";
        }
        for (const Hook& h : m_.fini) {
            out_ << "  fini @" << name(h.fnKey) << " for " << name(h.classKey) << " order "
                 << h.order << "\n";
        }
        if (!m_.init.empty() || !m_.fini.empty()) {
            out_ << "\n";
        }
        for (const std::unique_ptr<Function>& f : m_.functions) {
            printFunction(*f);
            out_ << "\n";
        }
        out_ << "}\n";
        return out_.str();
    }

private:
    // ONE FIELD, WITH EVERY PROPERTY THAT DECIDES WHERE ITS BYTES GO.
    //
    // The type alone is not the field. `weak` is what lets the region binder form a forest rather
    // than a graph; a bit width makes it share a storage unit with its neighbours; and an
    // `alignOverride` is a boundary a layout's resolver asked for, which is the difference between
    // two counters on one cache line and two counters on two. A round trip that dropped any of them
    // would give back a module that measures differently from the one that was printed -- which is
    // the same class of silence as not printing the struct at all, one level down.
    void printFieldShape(const Field& f) {
        out_ << TypeTable::spell(f.type);
        if (f.weak) {
            out_ << " weak";
        }
        if (f.bitWidth != 0) {
            out_ << " bits " << f.bitWidth;
        }
        if (f.alignOverride != 0) {
            out_ << " align " << f.alignOverride;
        }
    }

    void printGlobal(const Global& g) {
        out_ << "  global @" << name(g.name) << " : " << TypeTable::spell(g.type) << " = ";
        if (g.zeroInit) {
            out_ << "zeroinit";
        } else if (!g.initStr.empty()) {
            out_ << quote(g.initStr);
        } else {
            out_ << g.initInt;
        }
        out_ << ", " << spell(g.linkage) << ", " << spell(g.storage);
        if (g.isConst) {
            out_ << ", const";
        }
        out_ << "\n";
    }

    void printFunction(const Function& fn) {
        out_ << "  fn @" << name(fn.key) << "(";
        if (fn.signature != nullptr) {
            for (size_t i = 0; i < fn.signature->fields.size(); ++i) {
                if (i != 0) {
                    out_ << ", ";
                }
                out_ << TypeTable::spell(fn.signature->fields[i].type);
            }
        }
        out_ << ") -> "
             << TypeTable::spell(fn.signature != nullptr ? fn.signature->element : nullptr);
        out_ << " linkage(" << spell(fn.linkage) << ") conv(" << spell(fn.conv) << ") kind("
             << spell(fn.kind) << ") unwind(" << spell(fn.unwind) << ")";
        if (fn.affinity != Affinity::None) {
            out_ << " affinity(" << spell(fn.affinity) << ")";
        }
        if (fn.pure) {
            out_ << " pure";
        }
        if (fn.noReturn) {
            out_ << " noreturn";
        }
        if (fn.inlineAlways) {
            out_ << " inline.always";
        }
        if (fn.inlineNever) {
            out_ << " inline.never";
        }
        if (fn.noRedZone) {
            out_ << " noredzone";
        }
        if (fn.cut) {
            out_ << " cut(" << fn.cutSlot << ")";
        }
        if (!fn.symbol.empty()) {
            out_ << " symbol(" << fn.symbol << ")";
        }
        if (!fn.library.empty()) {
            out_ << " library(" << fn.library << ")";
        }
        if (!fn.world.empty()) {
            out_ << " world(" << fn.world << ")";
        }

        // A DECLARATION IS A FUNCTION WITH NO `{`, and nothing else marks it. It used to end in `;`,
        // which the reader treats as the start of a comment -- so the terminator was swallowed and
        // the parser looked for a body that was not there. One character, two meanings: exactly the
        // kind of second meaning this project keeps removing.
        if (fn.blocks.empty()) {
            out_ << "\n";
            return;
        }
        out_ << " {\n";
        for (const Contract& c : fn.contracts) {
            const char* k = c.kind == Contract::Kind::Requires    ? "requires"
                            : c.kind == Contract::Kind::Ensures   ? "ensures"
                                                                  : "invariant";
            out_ << "    contract " << k << " " << quote(c.text) << "\n";
        }
        for (const Block& b : fn.blocks) {
            printBlock(fn, b);
        }
        out_ << "  }\n";
    }

    void printBlock(const Function& fn, const Block& b) {
        out_ << "  ^" << b.label << "(";
        for (size_t i = 0; i < b.params.size(); ++i) {
            if (i != 0) {
                out_ << ", ";
            }
            const ValueDef* d = fn.value(b.params[i]);
            out_ << val(fn, b.params[i]) << " : "
                 << TypeTable::spell(d != nullptr ? d->type : nullptr);
        }
        out_ << ")";
        for (BlockId cf : b.comefrom) {
            out_ << " comefrom ^" << blockName(fn, cf);
        }
        for (BlockId ab : b.abstainfrom) {
            out_ << " abstainfrom ^" << blockName(fn, ab);
        }
        out_ << ":\n";
        for (const Inst& in : b.insts) {
            printInst(fn, in);
        }
    }

    static std::string blockName(const Function& fn, BlockId id) {
        const Block* b = fn.block(id);
        return b != nullptr ? b->label : std::string("<gone>");
    }

    void printInst(const Function& fn, const Inst& in) {
        out_ << "    ";
        if (in.result != kNoValue) {
            out_ << val(fn, in.result) << " = ";
        }
        out_ << spell(in.op);
        if (in.total) {
            out_ << " total";
        }
        if (in.isVolatile) {
            out_ << " volatile";
        }
        // A FLAG, spelled like the flags beside it, rather than a second mnemonic. §7.2 writes the
        // sign into the operation name; for division and remainder the name is already spent on the
        // overflow rule, so it lands here -- and a flag round-trips without doubling the table.
        if (in.unsignedOp) {
            out_ << " unsigned";
        }
        if (in.type != nullptr && in.result != kNoValue) {
            out_ << " " << TypeTable::spell(in.type);
        } else if (in.type != nullptr) {
            out_ << " " << TypeTable::spell(in.type);
        }
        if (!in.text.empty()) {
            out_ << " @" << name(in.text);
        }
        // BEFORE `imm`, because for a field access the two are one fact: this aggregate, that
        // member of it. Printed even when the index is zero -- the first field is a real field, and
        // dropping the annotation there would turn `gep of <T> imm 0` back into a bare byte offset.
        if (in.aggregate != nullptr) {
            out_ << " of " << TypeTable::spell(in.aggregate);
            out_ << " imm " << in.imm;
        } else if (in.imm != 0) {
            out_ << " imm " << in.imm;
        }
        if (in.fimm != 0.0) {
            // SEVENTEEN DIGITS, because six is what a stream gives you and six does not come back.
            //
            // `2147483647.0` printed as `2.14748e+09` and read back as 2147480000 -- a constant in
            // the program silently changed by writing it down. Seventeen significant digits is the
            // round-trip width of an IEEE double: the shortest count for which parse(print(x)) == x
            // for every x. This is the only place a NUMBER crosses the text form, so it is the only
            // place that has to know.
            std::ostringstream f;
            f << std::setprecision(17) << in.fimm;
            out_ << " fimm " << f.str();
        }
        for (const std::string& e : in.extra) {
            // QUOTED, because an extra is PROSE. `guard.contract` carries the clause as the author
            // wrote it -- `[requires offset >= 0]` -- and the reader takes exactly one token after
            // the bracket, so it got `requires` and left `offset >= 0]` to be read as the next
            // instruction. The parse then failed on a word out of the middle of somebody's contract.
            //
            // `name()` quotes only when it has to, so `[requires]` and `[<prelude>]` stay as they
            // read today and the ones with spaces in them stop being three tokens.
            out_ << " [" << name(e) << "]";
        }
        for (size_t i = 0; i < in.operands.size(); ++i) {
            out_ << (i == 0 ? " " : ", ") << val(fn, in.operands[i]);
        }
        for (size_t i = 0; i < in.edges.size(); ++i) {
            out_ << " -> ^" << blockName(fn, in.edges[i].target) << "(";
            for (size_t k = 0; k < in.edges[i].args.size(); ++k) {
                if (k != 0) {
                    out_ << ", ";
                }
                out_ << val(fn, in.edges[i].args[k]);
            }
            out_ << ")";
            // Edge 0 of a `switch` is the default and has no value; every other edge is an arm and
            // carries its own, so there is no length to check before reading it.
            if (in.op == Op::Switch && i > 0) {
                out_ << " case " << in.edges[i].caseValue;
            }
        }
        // A REAL TOKEN, not a comment. `; 12:5` read nicely and did not survive the round trip,
        // because a comment is by definition the part the parser throws away -- so every location
        // came back as 1:1 and the metadata §8 calls load-bearing was quietly lost.
        if (in.loc.line > 1 || in.loc.col > 1) {
            out_ << " loc(" << in.loc.line << ":" << in.loc.col << ")";
        }
        out_ << "\n";
    }

    const Module& m_;
    std::ostringstream out_;
};

}  // namespace

std::string print(const Module& module) {
    return Printer(module).run();
}

}  // namespace polaron::pir
