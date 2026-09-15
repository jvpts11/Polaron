# `asm` operand constraints — choosing the register

> **Status.** Designed, not implemented. **No new keyword.** The mechanism is built; it has exactly
> one constraint and no way to pick another.

---

## 1. The objection, and where it wins

**AP-18** — *assembly must be integrated, not shelled out to a separate file.*

**Falls on its main point.** Three `asm` blocks inside three methods all inlined into `kmain`, with
`0x3F8` propagated into the operand — no boundary to see across. And `asm("x86_64")` is **checked**:
ARM mnemonics in an x86 block are a compile error, which a C compiler cannot do because to it the
block is a string.

**C wins one detail, and this is it:**

> C is **13 bytes tighter** across the three blocks, because its *constraint language* lets the
> allocator place operands where Polaron's block must move them itself — four setup instructions
> where C's `"a"(value)` needs two. The pattern repeats per block.

## 2. The mechanism exists. There is one constraint

`src/parser/ast.h`:

```cpp
std::vector<ExprPtr> outputs;       // lvalues the asm writes  -> "=r" constraints
std::vector<ExprPtr> inputs;        // values the asm reads    -> "r"  constraints
std::vector<std::string> clobbers;  // registers the asm destroys -> "~{reg}"
```

Every output is `"=r"`, every input is `"r"` — *any general-purpose register*. The clause grammar is
there, the wiring to LLVM is there, the clobber list already names registers. **What is missing is
the choice.**

That is why the block has to move things itself. `in $0, dx` needs the port in `dx` and the result in
`al`; with `r` the allocator puts them anywhere and the body pays a `mov` at each end.

## 3. The design

An operand may name where it must be, using the shape the language already has for a named argument:

```polaron
asm("x86_64") { in $0, dx } out ("ax": value) in ("dx": port) clobber ("rax");
```

Unconstrained operands keep working exactly as today — no constraint means any register, which is
what every existing block already gets.

### 3.1 The vocabulary is the architecture's own, not a letter code

| what you write | what it means |
|---|---|
| `"dx"`, `"ax"`, `"rax"`, `"al"` | that register. Validated against `registerFamily()` for the block's declared architecture |
| `"memory"` | the operand lives in memory rather than a register |
| `"immediate"` | a compile-time constant, folded into the instruction |
| *nothing* | any register — today's behaviour, and the default |

**This is where it is better than C's rather than a copy of it.** C's constraints are a private
letter code — `a` is ax, `b` is bx, `c` is cx, `d` is dx, `S` is si, `D` is di — which has to be
memorised and which does not resemble the register you wrote two characters away in the block itself:

```c
asm volatile ("in %1, %%dx" : "=a"(v) : "d"(port));   /* "a" and %%dx are the same idea, twice */
```

```polaron
asm("x86_64") { in $0, dx } out ("ax": v) in ("dx": port);
```

The constraint and the body name the same register with the same word, because it is the same
register.

## 4. What it costs to build — and it is small

`src/semantic/asmcheck.cpp` already holds what this needs: `registerFamily()`, `isRegName()`, and
`familyOf()`, which the clobber check already uses to work out what a block declares it may destroy.

| | |
|---|---|
| parser | accept a `"name":` label before an operand in `out (...)` / `in (...)` |
| AST | one constraint string per operand, empty for today's behaviour |
| analyser | validate the name against `registerFamily()` **and against the block's declared architecture** — the table is already there |
| back end | emit `={ax}` / `{dx}` instead of `=r` / `r`. LLVM takes explicit-register constraints in exactly that form |

## 5. The check that arrives with it

Because the constraint and the body now name registers in **one namespace**, the checker that already
refuses an ARM mnemonic in an x86 block gets two more things it can refuse:

- a constraint naming a register that does not exist on the declared architecture — the same class of
  error as the mnemonic, caught the same way;
- a constraint and a `clobber` naming the same register, which is a real bug and reads as a typo.

## 6. Decided (Wave 4.5)

### 6.1 A register pair is written the way the architecture writes it: `"edx:eax"`

**Decided.** The constraint is a colon-joined list of register names, **high part first**, in the
order the architecture's own documentation prints them. `mul` on a 32-bit target puts its 64-bit
result in `edx:eax`; that is how the manual writes it and how a person says it out loud, so it is how
it is written here.

**Why not C's way.** C spells this pair `"A"` — one letter meaning *this specific pair on this
specific target* — and there is no `"B"` for another pair because the letters ran out. §3.1's whole
argument is that a private alphabet is the wrong vocabulary; it is not improved by extending it.

**What the checker does with it**, each a rule it can already almost express:

- Split on `:` and require **every part to be a register of the block's architecture** — the same
  `registerFamily()` lookup a single name already gets, run per part.
- Require the parts to be **distinct families**. `"eax:ax"` names one register twice: a typo that
  would silently produce an operand half of which overwrites the other half.
- Require the operand's **width to equal the sum of the parts'**. A pair exists because the value
  does not fit in one register; a 32-bit value in `edx:eax` means the author meant something else.
- **Clobber the whole family of every part.** `registerFamily()` exists precisely because writing
  `eax` destroys `rax`; a pair destroys two families. Getting that wrong is the failure the table
  was built to prevent, arriving through the one syntax that names two registers at once.

Two is not a special case of one — it is a **list**, and nothing in the rule stops at two.
`edx:ecx:ebx:eax` is a legal spelling of a 128-bit operand if a target ever wants one, and the
checker needs no new code for it.

### 6.2 The table is per-architecture, and an unknown name names the architecture

**Decided.** `registerFamily()` gains a parameter: the architecture **already declared on the
block** — `asm("x86_64")`, `asm("aarch64")`. No fallback, no union table. A name unknown to that
architecture is an error saying *which* architecture it was looked up in.

**The phrasing matters more than the table.** What this prevents is not a typo, it is a **port**.
`asm("aarch64") { ... } in ("rdi": port)` is a block somebody copied from the x86 side and changed
the arch word on: every mnemonic is now checked against ARM and the *constraint* is not, so the one
line still saying x86 is the one line nothing looks at. An error reading *`rdi` is not a register on
aarch64* is the entire diagnosis. A union table would accept it and hand LLVM a constraint for a
register the target does not have.

This is a lookup gaining a parameter rather than a design, because **the block already declares the
architecture** and the mnemonic checker already reads it (§1 counts that as the thing C cannot do).
The constraint clause has simply not been reading the word beside it.

The x86-64 table stays as it is. `aarch64` is `x0`–`x30` with their `w` halves as the same families,
`sp`, `xzr`/`wzr`, and `v0`–`v31` — the aliasing rule is the same rule, writing `w3` destroys `x3`,
which is why a family table exists rather than a set of names.

### 6.3 `"memory"` and `"immediate"` are the two, and the list grows only on demand

**Decided.** No further class words until a real block cannot be written without one.

C has around twenty and most answer a question §3.1 removed. `"a"`, `"b"`, `"c"`, `"d"`, `"S"`, `"D"`
are *specific registers behind letters* — this design writes `"ax"`, `"bx"`, `"cx"`. `"q"`, `"Q"`,
`"R"`, `"l"` are subsets of the register file expressed as classes because there was no way to say
"one of these": an artefact of the alphabet, not a need. What is genuinely left is the two here — an
operand that must be **in memory** rather than a register, and one that must be **a constant folded
into the instruction**. Neither is a register at all, which is why neither can be spelled as one.

**AP-18 needed neither**; three real blocks driving a serial port wanted only specific registers.
That is the evidence for stopping here, and it is weak evidence from one program — which is exactly
why the rule is *add on demand* and not *this is the complete set*. A class word added because a
block needed it arrives with the block that needed it. One added in advance arrives with a guess
about what somebody will want, and stays whether they wanted it or not.

## 7. What this adds to the language

**No new keyword.** A label position inside two clauses that already exist, and a table the checker
already has.
