#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include "lexer/token.h"
#include "pir/type.h"

// The PIR module: globals, functions, blocks, values, instructions.
//
// See docs/design/polaron-ir.md §2 and §4-§7. Two shapes decide everything below:
//
//   SSA WITH BLOCK ARGUMENTS, NOT PHI NODES. A block declares parameters and every branch to it
//   passes one value per parameter, positionally. A phi keeps an ordering agreement between its
//   operand list and the block's predecessor list -- two lists that must agree, which is the shape
//   this project keeps removing from its own code. There is nothing here to fall out of step.
//
//   ONE FLAT `Inst`, NOT A CLASS HIERARCHY. Every instruction is an opcode, a result, operands, and
//   a few optional extras. That is what makes the printer, the parser and the verifier each a single
//   switch instead of a visitor -- and the text form round-tripping exactly is the property every
//   stage is tested against.
namespace polaron::pir {

using ValueId = uint32_t;
using BlockId = uint32_t;

inline constexpr ValueId kNoValue = 0xFFFFFFFFu;
inline constexpr BlockId kNoBlock = 0xFFFFFFFFu;

// ---- the instruction set (§7) ----
//
// Grouped by what they mean, not by how they lower. The overflow rule is part of the OPCODE, which is
// the whole point: today the analyzer decides it and the codegen emits guard code, so the fact is
// invisible by the time anything could use it.
enum class Op : uint16_t {
    // 7.1 constants
    ConstInt, ConstFloat, ConstBool, ConstNull, ConstAddr, ConstStr, ConstFn, Undef,

    // 7.2 arithmetic -- the suffix IS the overflow rule
    AddWrap, AddChecked, AddSaturate,
    SubWrap, SubChecked, SubSaturate,
    MulWrap, MulChecked, MulSaturate,
    ShlWrap, ShlChecked, ShlSaturate,
    DivChecked, DivTrap, RemChecked, RemTrap,
    NegWrap, NegChecked, NegSaturate,
    And, Or, Xor, Not, ShrL, ShrA,
    FAdd, FSub, FMul, FDiv, FRem, FNeg,

    // 7.3 comparison and conversion
    CmpEq, CmpNe, CmpLtS, CmpLeS, CmpGtS, CmpGeS, CmpLtU, CmpLeU, CmpGtU, CmpGeU,
    CmpLtF, CmpLeF, CmpGtF, CmpGeF,
    Trunc, ExtendS, ExtendU, FpTrunc, FpExtend, FpToIntSaturate, FpToIntWrap, IntToFp,
    // THE SAME BITS, READ AS ANOTHER TYPE -- no conversion and no rounding, which is exactly what
    // separates it from every other row here. `Bits.doubleToLong` is the language's spelling of it
    // and nothing else in this table could express it.
    Bitcast,
    // HOW BIG A TYPE IS, as a value. The type table records a size for everything whose layout it
    // decides, but not for a struct -- padding is the data layout's business, and the data layout
    // lives in the backend. `sizeof` names the type and lets the backend answer.
    SizeOf,
    PtrToAddr, AddrToPtr, AddrNarrow, AddrWiden,

    // 7.4 memory
    Alloca, Load, Store, Gep, MemCopy, MemSet, MemMove,

    // 7.5 aggregates
    Extract, Insert,

    // LANES. `vec.build` makes a vector from N scalars -- and from ONE, repeated, which is how a
    // scalar broadcasts across `v * 2.0`; `vec.extract` reads lane i and `vec.insert` writes it.
    // Element-wise arithmetic needs no opcode of its own: `fadd` over two values whose type is a
    // vector IS the element-wise add, and that is the second thing a vector KIND buys.
    VecBuild, VecExtract, VecInsert,

    // A CHOICE THAT IS NOT A BRANCH. `cond ? a : b` where both arms are already computed is one
    // instruction, not two blocks and a join, and that matters twice over: `Color.GREEN.name()`
    // lowers to a chain of these that folds to a single string once the ordinal is known, and §11
    // can fold one whose condition it knows without touching the CFG at all. Three operands: the
    // condition, then the value for true and the value for false.
    Select,

    // 7.6 regions
    RegionCreate, RegionAlloc, RegionRelease, RegionAccepts, RegionMark, RegionRestore,
    RegionExtract, RegionDepth, RegionValidate, RegionClone,

    // 7.7 ownership
    Move, CopyDeep, Drop, DropCascade, Forget,

    // 7.8 calls and dispatch
    Call, CallIndirect, CallUnwind, VtableLoad, IfaceLoad, ClosureMake, ClosureCall,

    // 7.9 control (terminators)
    Br, BrCond, Switch, Ret, Unreachable,

    // 7.10 unwinding
    //
    // `Raise` STARTS one, which §7.10 described how to catch and how to continue but never how to
    // begin. The lowering filled the hole by calling an invented `__polaron_throw`, and nothing in
    // the module could see that the name belonged to no one -- verifier rule 15 is satisfied by a
    // declaration, and a declaration is exactly what an invented external is. It surfaced at link
    // time, on every program containing the word `throw`.
    Landing, Resume, CleanupEnd, Raise,

    // 7.11 facts and guards
    GuardBounds, GuardNull, GuardDivisor, GuardCast,
    // A CONTRACT, CHECKED. `fact.requires` is what the optimiser reads; this is what stops the
    // program. Separate opcodes because §11.3 may delete the guard once it can prove the fact and
    // must never delete the fact itself.
    GuardContract,
    FactRequires, FactEnsures, FactInvariant, FactRange,

    // 7.12 variants
    VariantMake, VariantTag, VariantPayload,

    // 7.13 concurrency
    Suspend, LockAcquire, LockRelease, AtomicLoad, AtomicStore, AtomicRmw, AtomicCmpXchg, Fence,

    // 7.14 inline assembly
    Asm,

    // 7.15 region-class self allocation
    ItselfAlloc,

    // 7.16 lazy
    LazyGet,
};

const char* spell(Op op);
bool opFromName(const std::string& name, Op* out);
bool isTerminator(Op op);
bool producesValue(Op op);

// A branch edge: the block it goes to, and one value per that block's declared parameters.
struct Edge {
    BlockId target = kNoBlock;
    std::vector<ValueId> args;
};

// One instruction. Fields that do not apply to an opcode are left empty; the verifier is what makes
// that safe, because it checks the shape of every opcode it knows.
struct Inst {
    Op op = Op::Undef;
    ValueId result = kNoValue;          // kNoValue when the opcode produces nothing
    const Type* type = nullptr;         // the result's type
    std::vector<ValueId> operands;
    std::vector<Edge> edges;            // terminators; CallUnwind uses [0]=normal, [1]=landing
    std::vector<int64_t> cases;         // Switch case values, parallel to edges[1..]
    int64_t imm = 0;                    // ConstInt, Gep index, field index, atomic ordering, ...
    // THE AGGREGATE A `gep` INDEXES INTO, which is not the same as the type of what comes out (that
    // is `type`, and it is always a pointer). Without it a field access could only be a BYTE offset,
    // and the lowering does not know the byte offsets -- so every field of every class was written
    // at offset zero, aliasing the first one. Naming the aggregate lets the backend ask LLVM where
    // the field is, which is the same layout the trusted path gets and therefore the same ABI.
    const Type* aggregate = nullptr;
    double fimm = 0.0;                  // ConstFloat
    std::string text;                   // @key, symbol, region flavour, asm template, field name
    std::vector<std::string> extra;     // asm constraints and clobbers; region edge annotations
    bool isVolatile = false;
    bool total = false;                 // Switch: the case set is closed and there is no default
    // §7.2's `div.u.checked`: the sign is part of the OPERATION, and for division and remainder it
    // is the only thing the opcode name does not already carry -- the suffix there is the overflow
    // rule. Comparisons and shifts spell their sign in the opcode (`cmp.lt.u`, `shr.l`) and leave
    // this false. Printed as the `.u` in the mnemonic, so a round-trip keeps it.
    bool unsignedOp = false;
    SourceLocation loc;
};

// A basic block. Its parameters ARE the SSA joins -- see the header comment.
struct Block {
    BlockId id = kNoBlock;
    std::string label;
    std::vector<ValueId> params;
    std::vector<Inst> insts;            // the last one is the terminator
    std::vector<BlockId> comefrom;      // the chaos tetrad: explicit inbound edges (§7.9)
    std::vector<BlockId> abstainfrom;   // ...and edges explicitly removed
};

// What defines a value, so the verifier can answer "is this use dominated by its definition" without
// a second index to keep in step.
enum class ValueOrigin : uint8_t { Instruction, BlockParam };

struct ValueDef {
    const Type* type = nullptr;
    ValueOrigin origin = ValueOrigin::Instruction;
    BlockId block = kNoBlock;           // where it is defined
    uint32_t indexInBlock = 0;          // instruction index, or parameter index
    std::string name;                   // printing only; the id is the identity
};

enum class Linkage : uint8_t { Public, Internal, Private, External };

// Spelled exactly as the language spells them, so there is no translation table to keep in step.
enum class Conv : uint8_t {
    Polaron, Cdecl, Stdcall, Fastcall, Cppdecl, Rustdecl, Zigdecl, Syscall, Interrupt, Naked, Unknown
};

enum class FnKind : uint8_t { Method, Constructor, Destructor, Operator, Procedure, Interrupt };
enum class Affinity : uint8_t { None, Hot, Cold };
enum class Unwind : uint8_t { Never, May };

enum class Storage : uint8_t { Static, Persistent, Eternal, Transient, ThreadLocal };

const char* spell(Linkage v);
const char* spell(Conv v);
const char* spell(FnKind v);
const char* spell(Affinity v);
const char* spell(Unwind v);
const char* spell(Storage v);

// ---- §31: A REFLECTIVE TYPE TOKEN, AS DATA ----
//
// What a class knows about itself: its name, its methods with their bodies, its fields with their
// accessors, and the annotations on all of it. Twenty-two machine words, every one of them known at
// compile time -- so the token belongs IN THE IMAGE, not on the heap.
//
// It was built at the call site instead: a `__polaron_malloc` per `typeOf<T>()`, filled word by
// word, and never freed. Two things wrong with that, and only the second is fatal. The first is a
// leak that grows with the loop it is written in. The second is that a program with NO HEAP cannot
// answer "what type is this" at all -- and `reflect_freestanding` is a bare-metal sample whose
// entire subject is that it can.
//
// Held as a tree rather than as finished LLVM because the LOWERING knows what a class contains and
// the BACKEND knows how a String is laid out, and neither should have to learn the other's half.
// That division is the reason a constant version was avoided before: it looked like a second way to
// lay out a String. It is not -- `Kind::Text` says "a String holding these characters" and the
// backend answers with the same global it already builds for a literal.
struct ConstNode {
    enum class Kind : uint8_t {
        Zero,    // a null pointer, or nothing
        Int,     // `number`, as a machine word
        Text,    // a String object holding `text`
        Fn,      // the address of the function keyed `text`, or null when the module has none
        Array,   // a Polaron array: `[i64 length | items...]`
    };
    Kind kind = Kind::Zero;
    std::int64_t number = 0;
    std::string text;
    std::vector<ConstNode> items;
    bool wide = false;   // an Array of machine words rather than of pointers
};

struct ReflectToken {
    std::string cls;                 // the global is `type.<cls>`
    std::vector<ConstNode> slots;    // exactly 22, in the order §31 fixes
};

struct Global {
    std::string name;
    const Type* type = nullptr;
    Linkage linkage = Linkage::Internal;
    // Both sides of a bundle boundary declare this same variable -- see `Function::mergeable`, which
    // this is the storage half of. A prelude class's `static` field is compiled into the library and
    // into its consumer, and `two_bundle_link_runs` died on `duplicate symbol: Signals.INTERRUPT`
    // once the method bodies stopped colliding and left the data behind them visible.
    //
    // Merging is not merely a way to quiet the linker here: it is the RIGHT answer. `Signals.TERMINATE`
    // is ONE variable in the program's mind, and two copies of it -- which is what the trusted path
    // produced, by making every static private -- means a library that writes one and a consumer
    // that reads the other disagree about a value they both call the same name.
    bool mergeable = false;
    Storage storage = Storage::Static;
    bool isConst = false;
    bool zeroInit = true;
    int64_t initInt = 0;
    double initFloat = 0.0;   // `static fixed double RATIO = 1.5;` needs somewhere to keep the 1.5
    std::string initStr;
    // A BLOCK OF BYTES, verbatim -- what `embed("file")` puts in the image (§36). Held as the whole
    // contents rather than as a path because reading the file is a COMPILE-TIME act: the program
    // that carries a font or a guest binary has no filesystem to load it from later, which is the
    // entire reason the word exists. Laid out as every Polaron array is, `[i64 length | bytes...]`,
    // so `.length()` and indexing need no special case anywhere.
    std::vector<uint8_t> initBytes;
    bool hasBytes = false;
    // A TABLE OF FUNCTION KEYS, which is what a vtable is: one entry per dispatch slot, empty
    // where the class provides no implementation. Held as keys rather than as addresses because
    // the address is the backend's business and the key is what verifier rule 15 checks against.
    std::vector<std::string> initFns;
};

// A contract, as a fact rather than as emitted code (§7.11). Consumed by the guard eliminator FIRST
// and lowered to `llvm.assume` LAST -- an assume emitted early is a fact thrown away.
struct Contract {
    enum class Kind : uint8_t { Requires, Ensures, Invariant } kind = Kind::Requires;
    std::string text;      // the source spelling, for diagnostics
    SourceLocation loc;
};

struct Function {
    std::string key;                    // the Polaron name plus its class key; the symbol comes from it
    const Type* signature = nullptr;    // fn(params...) -> ret
    // THE PARAMETER NAMES LIVE HERE, NOT ON THE TYPE.
    //
    // Types are interned by SHAPE, and a name is not shape: `fn(ptr) -> void` interns exactly once,
    // so every function with that signature shared whichever names the first one happened to carry.
    // A hundred and sixty-seven methods lost the name `this` that way, and every `this` in them
    // lowered to an undefined value. The type table is right to ignore names; this is where they go.
    //
    // A PARAMETER, not a name: this was a `vector<std::string>` until the sign had to travel with
    // it, and a second vector indexed by the same integer is the shape that hides a type. Whatever
    // a parameter turns out to carry next -- named-only, an ownership mode -- lands in here rather
    // than in another vector beside it.
    struct Param {
        std::string name;
        // THE TYPE AS WRITTEN, which the interned type cannot answer and two separate questions
        // need. The WIDTH is in `signature`; what is not there is the SIGN (§3.1 puts that on the
        // operation, so `uint` and `int` intern identically) and the CLASS (`String` is a `ptr`,
        // and so is every other object, so a receiver arrives with its identity erased). Both are
        // read off this one word rather than cached as two more fields that could disagree with it.
        std::string typeName;
        // BY VALUE means the callee gets a COPY. `method f(Box b)` mutates its own; `f(Box& b)` and
        // `f(Box* b)` reach the caller's. Every one of them is a pointer in the IR, so the
        // difference is not visible in the signature and has to be recorded -- without it, `b.v =
        // 99` on a by-value parameter wrote through to the caller's object.
        bool byValue = false;
        // HOW MANY STARS THE DECLARATION WROTE. `typeName` drops them -- it is the CLASS's name and
        // has to be, because every table in the lowering is keyed by it -- so a `Node*` parameter
        // arrived indistinguishable from a `Node`. Assignment then DEEP-COPIED it: `this.tail = x`
        // on a `Node* x` stored a fresh copy, `this.tail.next = y` wrote into that copy, and every
        // linked structure built through a method kept exactly one element. A JSON object came out
        // holding its first member and nothing else.
        uint8_t pointerDepth = 0;
    };
    std::vector<Param> params;
    // THE RETURN TYPE AS WRITTEN, for the same reason `Param::typeName` exists and read the same
    // way: the signature says the method hands back a `ptr` and nothing more, so what CLASS comes
    // back -- and whether the author said it may be absent -- is not recoverable from it. The
    // backend needs both to say `nonnull` and `dereferenceable` about the returned pointer, which
    // is what lets a caller stop re-checking an object a method just built for it.
    std::string returnTypeName;
    Linkage linkage = Linkage::Internal;
    // MORE THAN ONE OBJECT MAY DEFINE THIS, AND THE DEFINITIONS ARE THE SAME ONE. Not a visibility
    // -- it is orthogonal to `linkage`, and the functions it applies to are exactly the `public`
    // ones -- but the C++ ODR rule: emit it, and let the linker keep a single copy.
    //
    // It matters only for a `--lib`, and only because of what a Polaron artefact CONTAINS. Every
    // program carries its own prelude, and every use of a generic instantiates it where it is used,
    // so a library and its consumer independently compile byte-identical bodies for
    // `ArrayList$String.add`, `Some$String.isSome`, `String.length`. A program internalizes all of
    // them and the question never arises; a library publishes its methods -- that is what a library
    // IS -- and publishing them strongly made the linker refuse the pair: `two_bundle_link_runs`
    // died on `duplicate symbol: Some$String.isSome` and a dozen more like it.
    //
    // The alternative -- not emitting them in the library and letting the consumer supply them --
    // is wrong in the other direction: a consumer prunes to what IT reaches, and the library's own
    // calls into a generic it instantiated would find nothing.
    bool mergeable = false;
    Conv conv = Conv::Polaron;
    FnKind kind = FnKind::Method;
    Affinity affinity = Affinity::None;
    Unwind unwind = Unwind::Never;
    bool pure = false;
    // ...AND WHETHER IT READS. `pure` above says the function WRITES nothing; that is not the same
    // claim as touching nothing, and `readnone` is the second one. A method whose whole body is
    // `return this.screen;` writes nothing and reads a field, and told it accessed no memory at all
    // the optimiser was free to move the call ABOVE the store that filled the field -- which is how
    // pico's console came to dispatch through a vtable pointer it read out of the BIOS interrupt
    // table. The weaker fact is still worth having: `readonly` hoists out of loops and merges two
    // calls just as well, as long as nothing between them writes.
    bool readsMemory = false;
    bool noReturn = false;
    bool inlineAlways = false;
    bool inlineNever = false;
    bool noRedZone = false;
    bool cut = false;                   // belongs to a unit `unimport` may remove; a DCE root
    std::string cutSlot;                // the reimport slot it goes back into
    std::string symbol;                 // extern: the foreign symbol
    bool variadic = false;              // `printf(fmt, ...)`: the C ABI's trailing arguments
    std::string library;                // extern: the library it binds
    std::string world;                  // Conv::Unknown: the foreign ABI world
    std::vector<Contract> contracts;

    std::vector<ValueDef> values;       // indexed by ValueId
    std::vector<Block> blocks;          // blocks[0] is the entry

    ValueId addValue(const Type* type, ValueOrigin origin, BlockId block, uint32_t index,
                     std::string name);
    BlockId addBlock(std::string label);
    Block* block(BlockId id);
    const Block* block(BlockId id) const;
    const ValueDef* value(ValueId id) const;
};

// A lifecycle hook: `onClassLoad`, `onFirstInstance`, `onLastInstanceDestroyed`, `onClassUnload`.
struct Hook {
    std::string classKey;
    std::string fnKey;
    int order = 0;
};

struct Module {
    std::string triple;
    std::string dataLayout;
    std::string bundle;
    // WHETHER ANYTHING HANDS THIS PROGRAM AN ARGV -- `program X freestanding;`, as written.
    //
    // A SEPARATE QUESTION from whether anything calls `main`, which is the triple's to answer, and
    // the separation is the whole point: a static ELF with no libc is still
    // `x86_64-unknown-linux-gnu`, because the machine really is Linux. The triple therefore says
    // "hosted" and the entry marshalled a command line nobody would pass it -- asking the linker
    // for `__polaron_malloc` and `strlen` to build the array. A program with no C library has
    // neither, and the link failed on two symbols its source never mentions.
    bool freestanding = false;
    // `-g`: EMIT DWARF. A property of the INVOCATION and not of the program, so the driver sets it
    // rather than the lowering reading it off the AST -- the same source builds both ways.
    //
    // Every ingredient was already here: an `Inst` carries the line it came from, an `Alloca`
    // carries the name of the local it is, and a `Function` carries its key. What was missing was
    // anyone asking for them, so `polc -g` through this backend produced a module with no
    // `!DICompileUnit` in it at all -- a debugger opened the binary and had nothing to say about a
    // single line of it, silently, because `-g` was accepted and did nothing.
    bool debugInfo = false;
    // WHETHER THIS IS A `.polb` RATHER THAN A PROGRAM (`--lib`). A library publishes its methods --
    // that is what a library IS -- and a program publishes exactly one symbol: its entry. Left
    // published in a program, every prelude method and every monomorphized generic kept a strong
    // definition, so a consumer that also carries the prelude collided with it: linking Forge, an
    // IDE that plugs in a library built the ordinary way, failed with sixty `duplicate symbol:
    // ArrayList$String.*`. The trusted path answers this by internalizing everything but the entry
    // and the declared foreign boundaries -- see `stripDeadCode`.
    bool library = false;
    // `--test`: SOMEBODY ELSE WRITES `main`. The synthetic runner over the program's `[Test]`
    // methods is that entry, and it is built after this backend has finished -- it can only call
    // functions that already exist. So the backend emits no entry of its own and no init hooks
    // either; the runner emits both, in the order a test run needs them.
    bool testRunnerEntry = false;
    // ...AND THE FUNCTIONS IT WILL CALL, which nothing in the program calls.
    //
    // A `[Test]` method, its `[BeforeAll]` fixture and its `[Cases]` source are reachable only from
    // an entry that does not exist yet, so the reachability pass concludes -- correctly, on what it
    // can see -- that they are dead and strips them. The runner then references a symbol nobody
    // defined: `undefined symbol: Census.buildWorld`, at link, from a program whose tests all
    // compiled. Named here before the passes run, they are roots like any other.
    std::vector<std::string> extraRoots;
    TypeTable types;
    // WHAT THE BACKEND NEEDS TO KNOW ABOUT A CLASS THAT ITS SHAPE NO LONGER SAYS.
    //
    // One entry per class the lowering laid out, and one MAP rather than a set per question: a
    // second `std::unordered_set<std::string>` beside this one would be this struct with its name
    // left off, and the two would drift the first time a class was added to one and not the other.
    //
    // `overlapping` is a `union`. Two reads of one at the same offset and different types are the
    // SAME memory -- that is the whole point of writing one -- and it is exactly the case
    // type-based alias analysis gets wrong: told an i32 and an f32 never alias, it will reorder the
    // write of `asFloat` past the read of `asInt`. It cannot be recovered from the shape, because a
    // union's PIR shape keeps only its widest field and nothing in it still says the others were
    // ever there.
    //
    // Membership alone answers a second question: whether an LLVM struct is a CLASS. The other
    // backend names every one of them `class.<Name>`, several tests assert on that spelling, and
    // two paths that spell one class two ways are two paths that disagree about their own output.
    struct ClassShape {
        bool overlapping = false;
    };
    std::unordered_map<std::string, ClassShape> classes;
    std::vector<Global> globals;
    // The reflective type tokens this program asks for, one per class named in a `typeOf<T>()`.
    // See `ConstNode`: the backend turns each into a `private constant` in the image.
    std::vector<ReflectToken> reflectTokens;
    std::vector<std::unique_ptr<Function>> functions;
    std::vector<Hook> init;
    std::vector<Hook> fini;

    Function* addFunction(std::string key, const Type* signature);
    Function* find(const std::string& key);
    const Function* find(const std::string& key) const;
};

}  // namespace polaron::pir
