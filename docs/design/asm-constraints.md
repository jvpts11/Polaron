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

## 6. Still to design

| | |
|---|---|
| 6.1 | register **pairs and classes** beyond a single name — `edx:eax` for a 64-bit result on a 32-bit target is the common one, and a single string does not express it |
| 6.2 | architectures other than x86_64. `registerFamily()` is an x86 table today; the same clause has to mean something on aarch64, and the arch is already declared on the block |
| 6.3 | whether `"memory"` and `"immediate"` are the right two class words, or whether more of C's classes are worth having. AP-18 needed neither — only specific registers |

## 7. What this adds to the language

**No new keyword.** A label position inside two clauses that already exist, and a table the checker
already has.
