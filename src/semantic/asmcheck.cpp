#include "asmcheck.h"

#include <algorithm>
#include <cctype>
#include <map>
#include <set>

namespace ldp3::semantic {
namespace {

// ---------------------------------------------------------------------------------------------------
// x86-64 registers, and which 64-bit register each name is part of.
//
// The aliasing is the whole point of this table. Writing `eax` destroys `rax`; writing `al` destroys the
// low byte of it. A clobber list that says "rax" therefore covers a body that writes `eax`, and a body
// that writes `eax` while declaring nothing is lying about `rax`. Comparing names as strings would get
// both of those wrong.
const std::map<std::string, std::string>& registerFamily() {
    static const std::map<std::string, std::string> m = [] {
        std::map<std::string, std::string> t;
        auto add = [&t](const char* fam, std::initializer_list<const char*> names) {
            for (const char* n : names) t[n] = fam;
        };
        add("rax", {"rax", "eax", "ax", "al", "ah"});
        add("rbx", {"rbx", "ebx", "bx", "bl", "bh"});
        add("rcx", {"rcx", "ecx", "cx", "cl", "ch"});
        add("rdx", {"rdx", "edx", "dx", "dl", "dh"});
        add("rsi", {"rsi", "esi", "si", "sil"});
        add("rdi", {"rdi", "edi", "di", "dil"});
        add("rbp", {"rbp", "ebp", "bp", "bpl"});
        add("rsp", {"rsp", "esp", "sp", "spl"});
        for (int i = 8; i <= 15; i++) {
            const std::string r = "r" + std::to_string(i);
            t[r] = r;
            t[r + "d"] = r;
            t[r + "w"] = r;
            t[r + "b"] = r;
        }
        for (int i = 0; i <= 15; i++) t["xmm" + std::to_string(i)] = "xmm" + std::to_string(i);
        for (const char* s : {"cs", "ds", "es", "fs", "gs", "ss"}) t[s] = s;
        for (const char* c : {"cr0", "cr2", "cr3", "cr4", "cr8"}) t[c] = c;
        return t;
    }();
    return m;
}

// The instructions this checker knows. Deliberately generous: an unknown mnemonic is an ERROR, so a
// missing entry rejects correct code, which is the one failure mode worse than not checking at all.
// Anything genuinely absent is a one-line fix here, and the error names the mnemonic so it is obvious.
const std::set<std::string>& knownMnemonics() {
    static const std::set<std::string> m = {
        // moves and arithmetic
        "mov", "movb", "movw", "movl", "movq", "movabs", "movzx", "movsx", "movsxd",
        "movzbl", "movzwl", "movslq", "lea", "xchg", "cmpxchg", "xadd",
        "add", "adc", "sub", "sbb", "inc", "dec", "neg", "imul", "mul", "idiv", "div",
        "and", "or", "xor", "not", "shl", "shr", "sal", "sar", "rol", "ror", "rcl", "rcr",
        "bt", "bts", "btr", "btc", "bsf", "bsr", "popcnt", "test", "cmp",
        "cbw", "cwde", "cdqe", "cwd", "cdq", "cqo", "cltq", "cqto",
        // control flow
        "jmp", "ljmp", "call", "lcall", "ret", "retq", "lret", "lretq", "leave",
        "iret", "iretq", "retf", "retfq", "syscall", "sysret", "sysretq",
        "int", "int3", "into", "ud2", "hlt", "nop", "pause",
        "je", "jne", "jz", "jnz", "ja", "jae", "jb", "jbe", "jg", "jge", "jl", "jle",
        "jc", "jnc", "jo", "jno", "js", "jns", "jp", "jnp", "jecxz", "jrcxz",
        "sete", "setne", "setz", "setnz", "seta", "setae", "setb", "setbe",
        "setg", "setge", "setl", "setle", "setc", "setnc", "sets", "setns",
        "cmove", "cmovne", "cmovz", "cmovnz", "cmova", "cmovae", "cmovb", "cmovbe",
        "cmovg", "cmovge", "cmovl", "cmovle", "cmovs", "cmovns",
        // stack
        "push", "pop", "pushq", "popq", "pushf", "popf", "pushfq", "popfq",
        // flags and system
        "cld", "std", "cli", "sti", "clc", "stc", "cmc",
        "lgdt", "sgdt", "lidt", "sidt", "ltr", "str", "lldt", "sldt",
        "swapgs", "rdmsr", "wrmsr", "rdtsc", "rdtscp", "cpuid", "invlpg", "wbinvd",
        "in", "out", "inb", "inw", "inl", "outb", "outw", "outl",
        "insb", "insw", "insl", "outsb", "outsw", "outsl",
        // strings
        "movsb", "movsw", "movsl", "movsq", "stosb", "stosw", "stosl", "stosq",
        "lodsb", "lodsw", "lodsl", "lodsq", "scasb", "scasw", "scasl", "scasq",
        "cmpsb", "cmpsw", "cmpsl", "cmpsq", "rep", "repe", "repne", "repz", "repnz",
        // SSE, enough to recognise rather than to validate
        "movaps", "movups", "movdqa", "movdqu", "movd", "movss", "movsd",
        "xorps", "xorpd", "por", "pxor", "paddd", "psubd", "fxsave", "fxrstor",
        "ldmxcsr", "stmxcsr",
    };
    return m;
}

std::string lower(std::string s) {
    for (char& c : s) c = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
    return s;
}

bool isRegName(const std::string& s) { return registerFamily().count(lower(s)) != 0; }
std::string familyOf(const std::string& s) {
    auto it = registerFamily().find(lower(s));
    return it == registerFamily().end() ? std::string() : it->second;
}

// One line of the body, split into what the checks need.
struct Line {
    int number = 0;
    std::string mnemonic;             // empty for a label, directive or blank line
    std::vector<std::string> operands;
    bool isDirective = false;
    bool isLabel = false;
    std::string raw;
};

// Strip comments: `/* ... */` (which LDP3 bodies use), `#` and `;` to end of line.
std::string stripComments(const std::string& body) {
    std::string out;
    out.reserve(body.size());
    bool inBlock = false;
    for (std::size_t i = 0; i < body.size(); i++) {
        if (inBlock) {
            if (i + 1 < body.size() && body[i] == '*' && body[i + 1] == '/') { inBlock = false; i++; }
            else if (body[i] == '\n') out += '\n';   // keep line numbering honest
            continue;
        }
        if (i + 1 < body.size() && body[i] == '/' && body[i + 1] == '*') { inBlock = true; i++; continue; }
        if (body[i] == '#' || body[i] == ';') {
            while (i < body.size() && body[i] != '\n') i++;
            if (i < body.size()) out += '\n';
            continue;
        }
        out += body[i];
    }
    return out;
}

std::vector<Line> splitLines(const std::string& body) {
    std::vector<Line> lines;
    const std::string text = stripComments(body);
    std::string cur;
    int n = 1;
    auto flush = [&](const std::string& s, int num) {
        Line ln;
        ln.number = num;
        ln.raw = s;
        std::size_t p = s.find_first_not_of(" \t\r");
        if (p == std::string::npos) return;
        std::string t = s.substr(p);
        while (!t.empty() && (t.back() == ' ' || t.back() == '\t' || t.back() == '\r')) t.pop_back();
        if (t.empty()) return;
        // A LABEL, which may be followed on the same line by the thing it labels:
        // `stack_bottom: .skip 65536` is one label and one directive, and `isr_\n: push 0` is one label
        // and one instruction. Treating the whole line as a mnemonic reports `stack_bottom:` as an
        // unknown instruction, which is how the first version of this checker greeted a perfectly good
        // boot stub.
        std::size_t colon = t.find(':');
        if (colon != std::string::npos) {
            const std::string head = t.substr(0, colon);
            bool nameLike = !head.empty();
            for (char c : head)
                if (!(std::isalnum(static_cast<unsigned char>(c)) || c == '_' || c == '.' || c == '\\' ||
                      c == '$'))
                    nameLike = false;
            if (nameLike) {
                ln.isLabel = true;
                std::size_t after = t.find_first_not_of(" \t", colon + 1);
                if (after == std::string::npos) { lines.push_back(ln); return; }
                t = t.substr(after);          // carry on with whatever follows the label
                ln.isLabel = false;
            }
        }
        if (t[0] == '.') {
            ln.isDirective = true;
            lines.push_back(ln);
            return;
        }
        // mnemonic, then a comma-separated operand list
        std::size_t sp = t.find_first_of(" \t");
        ln.mnemonic = lower(sp == std::string::npos ? t : t.substr(0, sp));
        if (sp != std::string::npos) {
            std::string rest = t.substr(sp);
            std::string field;
            int depth = 0;
            for (char c : rest) {
                if (c == '[' || c == '(') depth++;
                if (c == ']' || c == ')') depth--;
                if (c == ',' && depth == 0) { ln.operands.push_back(field); field.clear(); continue; }
                field += c;
            }
            if (!field.empty()) ln.operands.push_back(field);
            for (std::string& o : ln.operands) {
                std::size_t a = o.find_first_not_of(" \t");
                if (a == std::string::npos) { o.clear(); continue; }
                std::size_t b = o.find_last_not_of(" \t");
                o = o.substr(a, b - a + 1);
            }
        }
        lines.push_back(ln);
    };
    for (char c : text) {
        if (c == '\n') { flush(cur, n); cur.clear(); n++; continue; }
        cur += c;
    }
    flush(cur, n);
    return lines;
}

// The bare register named by an operand, or empty when the operand is a memory reference, an
// immediate, a label or a `$n` placeholder. A memory operand is NOT a register write -- `mov [rax], 1`
// writes memory and leaves rax alone -- so brackets disqualify it, and that distinction is the
// difference between a useful check and a noisy one.
std::string operandRegister(const std::string& op) {
    if (op.empty()) return {};
    if (op.find('[') != std::string::npos) return {};
    std::string t = op;
    if (!t.empty() && t[0] == '%') t = t.substr(1);       // AT&T sigil
    if (!t.empty() && t[0] == '*') t = t.substr(1);       // indirect call/jmp
    // A bare name only; anything with arithmetic or a suffix is not a plain register operand.
    for (char c : t) {
        if (!std::isalnum(static_cast<unsigned char>(c))) return {};
    }
    return isRegName(t) ? familyOf(t) : std::string();
}

// Which operand does this instruction WRITE? Intel puts the destination first, AT&T last -- and that
// inversion is exactly why the dialect has to be known rather than guessed.
bool writesFirstOperand(const std::string& m) {
    static const std::set<std::string> readOnly = {
        "cmp", "test", "push", "pushq", "jmp", "call", "ret", "retq",
        "bt", "int", "out", "outb", "outw", "outl",
    };
    return readOnly.count(m) == 0;
}

}  // namespace

AsmReport checkAsm(const std::string& body, const AsmDeclared& declared) {
    AsmReport rep;
    // An architecture this checker has not learned is reported on by nobody rather than reported on
    // wrongly. Adding one means adding its tables, not weakening these checks.
    if (declared.arch != "x86_64") return rep;

    const bool att = declared.dialect == "att";
    const std::vector<Line> lines = splitLines(body);

    // Does the body BUILD an instruction stream rather than being one? And if it defines MACROS, learn
    // their names -- a macro invocation looks exactly like a mnemonic, and reporting `isr_stub` as an
    // unknown instruction is the checker failing to read a construct the assembler understands
    // perfectly.
    bool macroed = false;
    std::set<std::string> localMacros;
    for (const Line& ln : lines) {
        if (!ln.isDirective) continue;
        // `raw` keeps the line's indentation, so the directive name has to be found after trimming --
        // measuring from column zero finds the leading whitespace and every comparison below silently
        // fails, which is how `.macro isr_stub` went unlearned and its own invocations were reported as
        // unknown instructions.
        std::size_t begin = ln.raw.find_first_not_of(" \t\r");
        if (begin == std::string::npos) continue;
        const std::string trimmed = ln.raw.substr(begin);
        const std::size_t sp = trimmed.find_first_of(" \t");
        const std::string d = lower(trimmed.substr(0, sp));
        if (d == ".macro" || d == ".rept" || d == ".irp" || d == ".irpc" || d == ".if" ||
            d == ".altmacro" || d == ".endm" || d == ".endr" || d == ".endif" || d == ".else")
            macroed = true;
        if (d == ".macro" && sp != std::string::npos) {
            std::string rest = trimmed.substr(sp);
            const std::size_t a = rest.find_first_not_of(" \t");
            if (a != std::string::npos) {
                rest = rest.substr(a);
                const std::size_t b = rest.find_first_of(" \t");
                localMacros.insert(lower(b == std::string::npos ? rest : rest.substr(0, b)));
            }
        }
    }
    rep.flowChecked = !macroed;

    // What the block says it is allowed to destroy.
    std::set<std::string> declaredWrites;
    for (const std::string& c : declared.clobbers) {
        const std::string f = familyOf(c);
        if (!f.empty()) declaredWrites.insert(f);
    }

    const int operandCount = declared.outputCount + declared.inputCount;
    std::vector<std::string> pushed;      // the running push stack, for the symmetry check
    bool pushOrderBroken = false;
    bool stackModelValid = true;          // false once control leaves or rsp is assigned wholesale

    for (const Line& ln : lines) {
        if (ln.isLabel || ln.isDirective || ln.mnemonic.empty()) continue;
        rep.instructions++;

        // `$0`, `$1`, ... must name an operand that exists. In AT&T `$` also introduces an immediate,
        // so only a `$` followed by digits AND nothing else is an operand reference.
        for (const std::string& op : ln.operands) {
            for (std::size_t i = 0; i + 1 < op.size(); i++) {
                if (op[i] != '$' || !std::isdigit(static_cast<unsigned char>(op[i + 1]))) continue;
                std::size_t j = i + 1;
                int idx = 0;
                while (j < op.size() && std::isdigit(static_cast<unsigned char>(op[j]))) {
                    idx = idx * 10 + (op[j] - '0');
                    j++;
                }
                if (j < op.size() && (std::isalnum(static_cast<unsigned char>(op[j])) || op[j] == '_'))
                    continue;   // part of a longer token, not an operand reference
                if (idx >= operandCount) {
                    rep.findings.push_back(
                        {AsmFinding::Severity::Error,
                         "asm operand $" + std::to_string(idx) + " does not exist: the block declares " +
                             std::to_string(declared.outputCount) + " output(s) and " +
                             std::to_string(declared.inputCount) + " input(s)",
                         ln.number});
                }
            }
        }

        // Dialect. AT&T register sigils inside an Intel block do not fail to assemble on every
        // assembler, and where they do not, the operand ORDER is reversed and the instruction quietly
        // means the opposite. That is the worst possible way for this to be wrong.
        if (!att) {
            for (const std::string& op : ln.operands) {
                if (!op.empty() && op[0] == '%' && isRegName(op.substr(1))) {
                    rep.findings.push_back(
                        {AsmFinding::Severity::Error,
                         "'" + op + "' is AT&T syntax in an Intel-dialect block; Intel writes registers "
                         "without '%' and puts the destination FIRST, so mixing the two silently "
                         "reverses the operands",
                         ln.number});
                    break;
                }
            }
        }

        if (knownMnemonics().count(ln.mnemonic) == 0 && localMacros.count(ln.mnemonic) == 0) {
            rep.findings.push_back(
                {AsmFinding::Severity::Error,
                 "'" + ln.mnemonic + "' is not a known x86_64 instruction",
                 ln.number});
            continue;
        }

        // Registers this instruction destroys, against what the block declared. Outputs are excluded by
        // the caller (it knows which registers the compiler assigned); what is checked here is the
        // explicit ones the body names itself.
        if (!declared.inNakedFunction && !ln.operands.empty() && writesFirstOperand(ln.mnemonic)) {
            const std::string dst = att ? ln.operands.back() : ln.operands.front();
            const std::string fam = operandRegister(dst);
            // Excluded, and each for its own reason:
            //   rsp -- push/pop/call/ret move it by definition, and the stack is checked properly below.
            //   crN -- control registers are not allocatable, so writing one cannot be displacing a
            //          value the compiler put somewhere. `mov cr3, $0` is the entire point of having
            //          inline assembly and demanding a clobber for it would be theatre.
            //   segment registers -- same argument.
            const bool allocatable =
                !fam.empty() && fam != "rsp" && fam.rfind("cr", 0) != 0 &&
                fam != "cs" && fam != "ds" && fam != "es" && fam != "fs" && fam != "gs" && fam != "ss";
            if (allocatable && declaredWrites.count(fam) == 0) {
                rep.findings.push_back(
                    {AsmFinding::Severity::Error,
                     "this block writes '" + fam + "' but does not declare it: add clobber(\"" + fam +
                         "\") or make it an out(...) operand. The register allocator places live values "
                         "using only what the block declares, so an undeclared write corrupts unrelated "
                         "code and the symptom appears nowhere near here",
                     ln.number});
            }
        }

        // Two things end the stack model, and both are ordinary in correct code:
        //
        //   * The block TRANSFERS CONTROL OUT -- ret, iretq, sysretq, an unconditional jmp. Where the
        //     stack pointer stands at that moment is the destination's business, not this block's, and
        //     an `iretq` consumes a five-qword frame the block legitimately pushed for it.
        //   * The block ASSIGNS rsp from something this checker cannot evaluate -- `mov rsp, rdi` in a
        //     context-resume stub replaces the stack wholesale.
        //
        //
        // In both cases the honest response is to stop modelling, not to report on a model known to be
        // wrong. `pico` has one of each and the first version of this check called both of them bugs.
        if (stackModelValid) {
            static const std::set<std::string> leaves = {
                "ret", "retq", "lret", "lretq", "iret", "iretq", "sysret", "sysretq",
                "jmp", "ljmp", "leave", "hlt",
            };
            if (leaves.count(ln.mnemonic) != 0) stackModelValid = false;
            const bool assignsRsp =
                !ln.operands.empty() && writesFirstOperand(ln.mnemonic) &&
                operandRegister(att ? ln.operands.back() : ln.operands.front()) == "rsp" &&
                ln.mnemonic != "add" && ln.mnemonic != "sub";
            if (assignsRsp) stackModelValid = false;
        }

        // The stack discipline. Only meaningful when the text IS the instruction stream.
        if (rep.flowChecked && stackModelValid) {
            // EXPLICIT RSP ARITHMETIC FIRST. `add rsp, 8` and `sub rsp, 24` move the stack as
            // deliberately as a push does, and a checker that ignores them accuses correct code: pico's
            // syscall stub pushes a seventh argument, calls, then drops it with `add rsp, 8`, and the
            // first version of this check reported it as an unbalanced push AND as a save/restore order
            // violation. Both were wrong, and being wrong here is worse than being silent -- a compiler
            // that cries wolf teaches people to reach for the override.
            //
            // A slot pushed this way is anonymous: nothing says which register it holds, so a later pop
            // of it is not an order violation, just an unknown. That is why the model stores names and
            // treats an empty name as "no claim".
            if ((ln.mnemonic == "add" || ln.mnemonic == "sub") && ln.operands.size() == 2 &&
                operandRegister(att ? ln.operands.back() : ln.operands.front()) == "rsp") {
                const std::string amt = att ? ln.operands.front() : ln.operands.back();
                std::string digits;
                for (char c : amt)
                    if (std::isdigit(static_cast<unsigned char>(c))) digits += c;
                if (digits.empty() || digits.size() > 9) {
                    // A stack adjustment this checker cannot evaluate. Everything after it is guesswork,
                    // so it stops guessing and says so rather than reporting on a model it knows is
                    // wrong.
                    rep.flowChecked = false;
                    pushed.clear();
                } else {
                    const std::size_t slots = static_cast<std::size_t>(std::stoul(digits)) / 8;
                    const bool grows = (ln.mnemonic == "sub");
                    for (std::size_t k = 0; k < slots; k++) {
                        if (grows) pushed.push_back(std::string());
                        else if (!pushed.empty()) pushed.pop_back();
                    }
                }
                continue;
            }
            if (ln.mnemonic == "push" || ln.mnemonic == "pushq") {
                if (!ln.operands.empty()) pushed.push_back(operandRegister(ln.operands.front()));
            } else if (ln.mnemonic == "pop" || ln.mnemonic == "popq") {
                if (pushed.empty()) {
                    rep.findings.push_back(
                        {AsmFinding::Severity::Error,
                         "'pop' with nothing pushed in this block: it takes a value the block does not "
                         "own and leaves the stack pointer above where it started",
                         ln.number});
                } else {
                    const std::string want = pushed.back();
                    pushed.pop_back();
                    const std::string got =
                        ln.operands.empty() ? std::string() : operandRegister(ln.operands.front());
                    if (!want.empty() && !got.empty() && want != got && !pushOrderBroken) {
                        pushOrderBroken = true;
                        rep.findings.push_back(
                            {AsmFinding::Severity::Error,
                             "save/restore order: this pops '" + got + "' where the matching push saved '" +
                                 want + "'. A restore sequence must be the exact reverse of its saves, and "
                                 "keeping two hand-written lists in agreement is what this check exists to "
                                 "stop being a human's job",
                             ln.number});
                    }
                }
            }
        }
    }

    // Only when the block FALLS THROUGH to the compiler's epilogue -- which is exactly when leaving the
    // stack pointer moved is a real bug rather than a handover.
    if (rep.flowChecked && stackModelValid && !pushed.empty()) {
        rep.findings.push_back(
            {AsmFinding::Severity::Error,
             "this block pushes " + std::to_string(pushed.size()) +
                 " value(s) it never pops, so it returns with the stack pointer below where it started",
             lines.empty() ? 1 : lines.back().number});
    }
    return rep;
}

}  // namespace ldp3::semantic
