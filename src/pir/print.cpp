#include "pir/text.h"

#include <sstream>

namespace polaron::pir {

namespace {

std::string quote(const std::string& s) {
    std::string out = "\"";
    for (char c : s) {
        if (c == '"' || c == '\\') {
            out += '\\';
        }
        out += c;
    }
    return out + "\"";
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

        for (const Global& g : m_.globals) {
            printGlobal(g);
        }
        if (!m_.globals.empty()) {
            out_ << "\n";
        }
        for (const Hook& h : m_.init) {
            out_ << "  init @" << h.fnKey << " for " << h.classKey << " order " << h.order << "\n";
        }
        for (const Hook& h : m_.fini) {
            out_ << "  fini @" << h.fnKey << " for " << h.classKey << " order " << h.order << "\n";
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
    void printGlobal(const Global& g) {
        out_ << "  global @" << g.name << " : " << TypeTable::spell(g.type) << " = ";
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
        out_ << "  fn @" << fn.key << "(";
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
            out_ << " @" << in.text;
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
            out_ << " fimm " << in.fimm;
        }
        for (const std::string& e : in.extra) {
            out_ << " [" << e << "]";
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
            if (in.op == Op::Switch && i > 0 && i - 1 < in.cases.size()) {
                out_ << " case " << in.cases[i - 1];
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
