#include "asmcheck.h"

#include <algorithm>
#include <cctype>
#include <map>
#include <set>

namespace polaron::semantic {
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
            for (const char* n : names) {
                t[n] = fam;
            }
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
        for (int i = 0; i <= 15; i++) {
            t["xmm" + std::to_string(i)] = "xmm" + std::to_string(i);
        }
        for (const char* s : {"cs", "ds", "es", "fs", "gs", "ss"}) {
            t[s] = s;
        }
        for (const char* c : {"cr0", "cr2", "cr3", "cr4", "cr8"}) {
            t[c] = c;
        }
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
        // THE HARDWARE RANDOM GENERATOR. `rdrand` reads the on-die generator and `rdseed` its
        // seeding source, and both report success in the CARRY FLAG rather than by returning a
        // value -- which is why they are reached for from a block that also runs `setc`, already in
        // this table eight lines up. Present on every x86 part made since about 2012, and the only
        // real entropy source a kernel on this architecture has: without them `getrandom` has
        // nothing honest to answer with, and a modern libc calls it before `main`.
        "rdrand", "rdseed",
        "in", "out", "inb", "inw", "inl", "outb", "outw", "outl",
        "insb", "insw", "insl", "outsb", "outsw", "outsl",
        // strings
        "movsb", "movsw", "movsl", "movsq", "stosb", "stosw", "stosl", "stosq",
        "lodsb", "lodsw", "lodsl", "lodsq", "scasb", "scasw", "scasl", "scasq",
        "cmpsb", "cmpsw", "cmpsl", "cmpsq", "rep", "repe", "repne", "repz", "repnz",
        // COUNT-REGISTER LOOPS, absent from everything a compiler emits and present in every boot
        // sector ever written. `loop` is two bytes and needs no comparison: scanning the four
        // entries of a partition table is `mov cx, 4` and `loop`, in a sector whose code has to end
        // before the table starts at byte 446. Horizon's MBR is what asked for them.
        //
        // The whole family, because reaching for one and finding its siblings missing is the same
        // interruption twice over: the `e`/`ne` forms are the same instruction with the zero flag
        // tested as well, and `jcxz`/`jecxz`/`jrcxz` are the guard a `loop` needs when the count may
        // be zero -- `loop` decrements FIRST, so a count of zero wraps to 65535 and walks the
        // segment.
        "loop", "loope", "loopne", "loopz", "loopnz", "jcxz", "jecxz", "jrcxz",
        // SSE, enough to recognise rather than to validate
        "movaps", "movups", "movdqa", "movdqu", "movd", "movss", "movsd",
        "xorps", "xorpd", "por", "pxor", "paddd", "psubd", "fxsave", "fxrstor",
        "ldmxcsr", "stmxcsr",
    };
    return m;
}

std::string lower(std::string s) {
    for (char& c : s) {
        c = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
    }
    return s;
}

bool isRegName(const std::string& s) { return registerFamily().count(lower(s)) != 0; }
std::string familyOf(const std::string& s) {
    auto it = registerFamily().find(lower(s));
    return it == registerFamily().end() ? std::string() : it->second;
}

// ---------------------------------------------------------------------------------------------------
// AArch64 registers, and which 64-bit register each name is part of.
//
// The same table for a second architecture, and it exists for the same reason: writing `w3` destroys
// `x3`, so a name is not what has to be compared. What it is FOR here is narrower than the x86 one --
// the body checker still only reads x86 mnemonics -- and it is enough for the question §6.2 asks:
// **is this name a register on the architecture this block declared.**
//
// That question is not pedantry. The failure it catches is a PORT: a block copied from the x86 side
// with the arch word changed gets every mnemonic checked against ARM and, with no table here, its
// constraints checked against nothing -- so `out ("rdi": n)` in an `asm("aarch64")` block would
// reach LLVM asking for a register the target does not have.
//
// `xzr`/`wzr` are one family: the zero register is not two registers. `sp` has no `w` half worth
// naming here. `v0`-`v31` are the SIMD registers, whose `b`/`h`/`s`/`d`/`q` views are the same
// physical register under five widths, which is exactly what a family is.
const std::map<std::string, std::string>& registerFamilyArm64() {
    static const std::map<std::string, std::string> m = [] {
        std::map<std::string, std::string> t;
        for (int i = 0; i <= 30; i++) {
            const std::string x = "x" + std::to_string(i);
            t[x] = x;
            t["w" + std::to_string(i)] = x;
        }
        t["sp"] = "sp";
        t["xzr"] = "xzr";
        t["wzr"] = "xzr";
        for (int i = 0; i <= 31; i++) {
            const std::string v = "v" + std::to_string(i);
            t[v] = v;
            for (const char* w : {"b", "h", "s", "d", "q"}) {
                t[w + std::to_string(i)] = v;
            }
        }
        return t;
    }();
    return m;
}

// THE TABLE FOR ONE ARCHITECTURE, or null when this checker has not learned it. Null is what makes
// an unlearned target accept anything, which is the same bargain `checkAsm` makes for mnemonics and
// for the same reason: refusing correct code for a target nobody taught it is the worse failure.
const std::map<std::string, std::string>* registersOf(const std::string& arch) {
    if (arch == "x86_64" || arch == "x86" || arch == "i686" || arch == "i386") {
        return &registerFamily();
    }
    if (arch == "aarch64" || arch == "arm64") {
        return &registerFamilyArm64();
    }
    return nullptr;
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

// Strip comments: `/* ... */` (which Polaron bodies use), `#` and `;` to end of line.
std::string stripComments(const std::string& body) {
    std::string out;
    out.reserve(body.size());
    bool inBlock = false;
    for (std::size_t i = 0; i < body.size(); i++) {
        if (inBlock) {
            if (i + 1 < body.size() && body[i] == '*' && body[i + 1] == '/') { inBlock = false; i++;
            } else if (body[i] == '\n') {
                out += '\n';  // keep line numbering honest
            }
            continue;
        }
        if (i + 1 < body.size() && body[i] == '/' && body[i + 1] == '*') { inBlock = true; i++; continue; }
        if (body[i] == '#' || body[i] == ';') {
            while (i < body.size() && body[i] != '\n') {
                i++;
            }
            if (i < body.size()) {
                out += '\n';
            }
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
        if (p == std::string::npos) {
            return;
        }
        std::string t = s.substr(p);
        while (!t.empty() && (t.back() == ' ' || t.back() == '\t' || t.back() == '\r')) {
            t.pop_back();
        }
        if (t.empty()) {
            return;
        }
        // A LABEL, which may be followed on the same line by the thing it labels:
        // `stack_bottom: .skip 65536` is one label and one directive, and `isr_\n: push 0` is one label
        // and one instruction. Treating the whole line as a mnemonic reports `stack_bottom:` as an
        // unknown instruction, which is how the first version of this checker greeted a perfectly good
        // boot stub.
        std::size_t colon = t.find(':');
        if (colon != std::string::npos) {
            const std::string head = t.substr(0, colon);
            bool nameLike = !head.empty();
            for (char c : head) {
                if (!(std::isalnum(static_cast<unsigned char>(c)) || c == '_' || c == '.' || c == '\\' ||
                      c == '$')) {
                    nameLike = false;
                }
            }
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
        // A PREFIX IS NOT AN INSTRUCTION. `lock xchg dword ptr [rdx], eax` is one instruction with a
        // prefix on it, and reading the first word as the mnemonic rejected it as "'lock' is not a known
        // x86_64 instruction" -- which is a checker refusing the atomic exchange every spinlock in
        // existence is built from. Stripped rather than added to the mnemonic set, so `lock` in front of
        // a mnemonic that is genuinely wrong is still caught.
        //
        // `lock` only; `rep` and its family stay in the mnemonic set, because they are written alone as
        // often as they are written in front of something (`rep movsb` and `rep stosb` both appear in
        // this project's own string routines) and their operand shape is checked differently.
        for (const char* pfx : {"lock ", "lock\t"}) {
            const std::string p(pfx);
            if (lower(t.substr(0, p.size())) == p) {
                std::size_t after = t.find_first_not_of(" \t", p.size() - 1);
                if (after != std::string::npos) { t = t.substr(after); }
                break;
            }
        }
        // mnemonic, then a comma-separated operand list
        std::size_t sp = t.find_first_of(" \t");
        ln.mnemonic = lower(sp == std::string::npos ? t : t.substr(0, sp));
        if (sp != std::string::npos) {
            std::string rest = t.substr(sp);
            std::string field;
            int depth = 0;
            for (char c : rest) {
                if (c == '[' || c == '(') {
                    depth++;
                }
                if (c == ']' || c == ')') {
                    depth--;
                }
                if (c == ',' && depth == 0) { ln.operands.push_back(field); field.clear(); continue; }
                field += c;
            }
            if (!field.empty()) {
                ln.operands.push_back(field);
            }
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
    if (op.empty()) {
        return {};
    }
    if (op.find('[') != std::string::npos) {
        return {};
    }
    std::string t = op;
    if (!t.empty() && t[0] == '%') {
        t = t.substr(1);  // AT&T sigil
    }
    if (!t.empty() && t[0] == '*') {
        t = t.substr(1);  // indirect call/jmp
    }
    // A bare name only; anything with arithmetic or a suffix is not a plain register operand.
    for (char c : t) {
        if (!std::isalnum(static_cast<unsigned char>(c))) {
            return {};
        }
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
    if (declared.arch != "x86_64") {
        return rep;
    }

    const bool att = declared.dialect == "att";
    const std::vector<Line> lines = splitLines(body);

    // Does the body BUILD an instruction stream rather than being one? And if it defines MACROS, learn
    // their names -- a macro invocation looks exactly like a mnemonic, and reporting `isr_stub` as an
    // unknown instruction is the checker failing to read a construct the assembler understands
    // perfectly.
    bool macroed = false;
    std::set<std::string> localMacros;
    for (const Line& ln : lines) {
        if (!ln.isDirective) {
            continue;
        }
        // `raw` keeps the line's indentation, so the directive name has to be found after trimming --
        // measuring from column zero finds the leading whitespace and every comparison below silently
        // fails, which is how `.macro isr_stub` went unlearned and its own invocations were reported as
        // unknown instructions.
        std::size_t begin = ln.raw.find_first_not_of(" \t\r");
        if (begin == std::string::npos) {
            continue;
        }
        const std::string trimmed = ln.raw.substr(begin);
        const std::size_t sp = trimmed.find_first_of(" \t");
        const std::string d = lower(trimmed.substr(0, sp));
        if (d == ".macro" || d == ".rept" || d == ".irp" || d == ".irpc" || d == ".if" || d == ".altmacro" ||
            d == ".endm" || d == ".endr" || d == ".endif" || d == ".else") {
            macroed = true;
        }
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
        if (!f.empty()) {
            declaredWrites.insert(f);
        }
    }

    const int operandCount = declared.outputCount + declared.inputCount;
    std::vector<std::string> pushed;      // the running push stack, for the symmetry check
    bool pushOrderBroken = false;
    bool stackModelValid = true;          // false once control leaves or rsp is assigned wholesale

    for (const Line& ln : lines) {
        if (ln.isLabel || ln.isDirective || ln.mnemonic.empty()) {
            continue;
        }
        rep.instructions++;

        // `$0`, `$1`, ... must name an operand that exists. In AT&T `$` also introduces an immediate,
        // so only a `$` followed by digits AND nothing else is an operand reference.
        for (const std::string& op : ln.operands) {
            for (std::size_t i = 0; i + 1 < op.size(); i++) {
                if (op[i] != '$' || !std::isdigit(static_cast<unsigned char>(op[i + 1]))) {
                    continue;
                }
                std::size_t j = i + 1;
                int idx = 0;
                while (j < op.size() && std::isdigit(static_cast<unsigned char>(op[j]))) {
                    idx = idx * 10 + (op[j] - '0');
                    j++;
                }
                if (j < op.size() && (std::isalnum(static_cast<unsigned char>(op[j])) || op[j] == '_')) {
                    continue;   // part of a longer token, not an operand reference
                }
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
            if (leaves.count(ln.mnemonic) != 0) {
                stackModelValid = false;
            }
            const bool assignsRsp =
                !ln.operands.empty() && writesFirstOperand(ln.mnemonic) &&
                operandRegister(att ? ln.operands.back() : ln.operands.front()) == "rsp" &&
                ln.mnemonic != "add" && ln.mnemonic != "sub";
            if (assignsRsp) {
                stackModelValid = false;
            }
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
                for (char c : amt) {
                    if (std::isdigit(static_cast<unsigned char>(c))) {
                        digits += c;
                    }
                }
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
                        if (grows) {
                            pushed.push_back(std::string());
                        } else if (!pushed.empty()) {
                            pushed.pop_back();
                        }
                    }
                }
                continue;
            }
            // `pushfq` PUSHES, and the checker did not know it. Reading RFLAGS is `pushfq; pop rax` --
            // the only way to get the interrupt flag into a register -- and the balance tracker saw a
            // `pop` with nothing pushed and refused the block. The operand it pushes has no name (it is
            // the flags register), so it goes on the stack as an anonymous slot: the pair still has to
            // balance, and the pop's register is not checked against it.
            if (ln.mnemonic == "pushf" || ln.mnemonic == "pushfq") {
                pushed.push_back("");
            } else if (ln.mnemonic == "push" || ln.mnemonic == "pushq") {
                if (!ln.operands.empty()) {
                    pushed.push_back(operandRegister(ln.operands.front()));
                }
            } else if (ln.mnemonic == "popf" || ln.mnemonic == "popfq") {
                if (!pushed.empty()) { pushed.pop_back(); }
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

// ---- operand constraints (docs/design/asm-constraints.md §6) ----

namespace {

// Split a place on ':', keeping empty parts. `"eax:"` is then two parts, one of them empty, and gets
// diagnosed -- rather than quietly reading as one register with a stray colon.
std::vector<std::string> placeParts(const std::string& place) {
    std::vector<std::string> parts;
    size_t from = 0;
    for (;;) {
        const size_t colon = place.find(':', from);
        parts.push_back(place.substr(from, colon == std::string::npos ? std::string::npos
                                                                     : colon - from));
        if (colon == std::string::npos) {
            return parts;
        }
        from = colon + 1;
    }
}

}  // namespace

bool asmPlaceIsValid(const std::string& arch, const std::string& place, std::string* why) {
    auto say = [&](std::string m) {
        if (why != nullptr) {
            *why = std::move(m);
        }
        return false;
    };
    // Nothing said, or one of the two class words. Neither is a register, which is exactly why
    // neither can be spelled as one (§6.3).
    if (place.empty() || place == "memory" || place == "immediate") {
        return true;
    }
    // AN ARCHITECTURE THIS CHECKER HAS NOT LEARNED ACCEPTS ANYTHING -- the same bargain `checkAsm`
    // makes for mnemonics, for the same reason: refusing correct code for a target nobody has taught
    // it is the worse failure. Two are taught (§6.2).
    const std::map<std::string, std::string>* table = registersOf(arch);
    if (table == nullptr) {
        return true;
    }
    std::set<std::string> families;
    for (const std::string& one : placeParts(place)) {
        if (one.empty()) {
            return say("'" + place +
                       "' has an empty part. A register pair is written high part first, joined by "
                       "':' -- \"edx:eax\"");
        }
        const auto found = table->find(lower(one));
        if (found == table->end()) {
            return say("'" + one + "' is not a register on " + arch +
                       ". An operand's place is written with the architecture's own register name "
                       "-- \"ax\" on x86_64, \"x0\" on aarch64 -- or one of \"memory\" and "
                       "\"immediate\"");
        }
        // DISTINCT FAMILIES. `"eax:ax"` names one register twice and would produce an operand half
        // of which overwrites the other half. It reads as a typo because it is one.
        if (!families.insert(found->second).second) {
            return say("'" + place + "' names one register twice: '" + one + "' belongs to '" +
                       found->second + "', which another part of this pair already claimed");
        }
    }
    return true;
}

std::vector<std::string> asmPlaceFamilies(const std::string& arch, const std::string& place) {
    std::vector<std::string> out;
    const std::map<std::string, std::string>* table = registersOf(arch);
    if (table == nullptr || place.empty() || place == "memory" || place == "immediate") {
        return out;
    }
    for (const std::string& one : placeParts(place)) {
        if (const auto found = table->find(lower(one)); found != table->end()) {
            out.push_back(found->second);
        }
    }
    return out;
}

}  // namespace polaron::semantic
