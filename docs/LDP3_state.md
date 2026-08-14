# LDP3 — Estado da Linguagem (v0.9 → rumo à v1.0)

> Instantâneo do estado atual do compilador da LDP3. Atualizado em 2026-06-30.
> **Versão atual: 0.9.** As features de **linguagem** (fases F0–F9) estão essencialmente completas;
> falta a última etapa — **stdlib rica (F10) + toolchain unificada** — para fechar a **v1.0**.
>
> Fonte de verdade da linguagem: `docs/LDP3_specification.md`. Manual de operação + progresso detalhado:
> `CLAUDE.md`. Plano de stdlib: `docs/superpowers/specs/2026-06-29-stdlib-expansion-research.md`.

---

## Visão geral

- **O que é:** linguagem de sistemas, **OOP-obrigatória**, memória manual (sem GC), compilada para
  **nativo** via LLVM. Criada por João Victor Pereira Tavares.
- **Implementação:** C++20; backend LLVM 17+ (IR direto, opaque pointers).
- **Alvo atual:** Windows x86_64 (MSVC). Bare-metal `x86_64-unknown-none` já compila (freestanding).
- **Pipeline:** `.ldp3` → Lexer → Parser → Semantic → Codegen (LLVM IR) → `clang` → `.exe`.
- **Qualidade:** **320 testes** verdes (CTest e2e + doctest unitários). Cada feature tem sample + teste
  que compila e roda nativo.
- **Princípios firmados:** sem UB explorável (saturar/trap/checar); OOP-obrigatória (sem função/método
  livre fora de classe); sem cerimônia no caso comum, "canhão quando precisa"; correção antes de
  performance.

---

## ✅ Linguagem — completo (F0–F9)

### Núcleo OOP (F0–F3)
- Classes: campos, `constructor`/`destructor` (RAII), métodos de instância e `static`, `this`, `super`.
- Herança (`extends`), interfaces (`implements`), `abstract`, `override`, **vtables + dispatch virtual**.
- `enum` (simples e Java-style com campos/métodos).
- Tipos: todos os primitivos (`int8..int64`, `uint8..uint64`, unsigned real, `float32/64`, `boolean`,
  `char`, `void`) + aliases; arrays dinâmicos (`T[]`); ponteiros `T*` e referências `T&`.
- Memória manual: `new ... on stack`/`on heap`, `new T[n]()`, `delete`, **cópia profunda** na atribuição.
- Controle de fluxo completo: `if`/`else`, `while`, `do`-`while`, `for`, `foreach`+ranges, `switch`,
  `break`/`continue` (com label).
- I/O e interpolação de string (`$"..."`).

### Tipos ricos (F4)
- **Generics** monomorfizados (`Box<T>`), com constraints e variância; **generic methods** (`map<R>`).
- `record`, `struct` (+ bit fields), `union`, `sealed ... permits`.
- **`match`** exaustivo (dispatch por tipo dinâmico + desestruturação; statement e expression-form `->`).
- `catalog`, **operator overloading**, **properties** (auto + computed; `get`/`set`/`init`).
- Múltiplos arquivos por programa; visibilidade de namespace (imports controlam acesso cross-namespace).
- **Decimal** (primitivo i128 ponto-fixo, sufixo `m`).

### Memória & ownership (F5)
- **Regions** type-safe (§17): `region`/`itself.allocate`/`new in region`/`release`, `accepts`/`rejects`,
  sufixos de unidade (`64 kilobytes`), prelude `System.Memory.Units`/`ByteSize`.
- **Ownership:** `move`/`movable`/`unique`/`partitionable` + flow analysis.
- Prefixos universais (`cascade`/`eternal`/`lazy`/`comptime`/`volatile`/`final`).
- `defer`/`using`; literal suffixes; contracts.

### Erros & comptime (F6)
- Exceptions via landing pads LLVM (`try`/`catch`/`finally`/`throws`).
- **`Result<T,E>`/`Option<T>`** como sum types selados no prelude (`Ok`/`Err`/`Some`/`None` + `try?`).
- Comptime evaluation, `static_assert`.

### Runtime gerenciado (F7)
- **Persistents** + reattach (in-process); **unimport/reimport** (recarrega do `.exe` no disco).
- **Reflection** (`reflect.typeOf`, métodos/campos/anotações, `Field.get`/`set`, `annotations()`).
- Lifecycle hooks; tétrade do caos (`goto`/`comefrom`/`abstainfrom`/`reinstate`).

### Concorrência (F8)
- `Thread`, `Mutex`/`synchronized`, **`async`/`await`** (state machine real + worker pool),
  `atomic<T>` (lock-free), **`Channel<T>`** (send/receive + `Channel.select`).

### Sistemas / freestanding (F9)
- `address` + casts int↔ponteiro + indexação de ponteiro cru; API `Memory` (alloc/free/read/write).
- region `at address` (memória mapeada); FFI `extern cdecl/stdcall/fastcall`.
- `program/bundle freestanding` + enforcement; `--target=<triple>` → `.ll` bare-metal.
- Bundles separados **`.ldb`/`.ldh`** com fingerprint; carga estática e dinâmica; SIMD `vec2/3/4`.

---

## 🔄 Stdlib (F10) — em progresso

> Decisão do João: engordar muito a stdlib com features modernas *puras* (filtrando muletas de paradigma)
> ANTES da toolchain. Tudo abaixo é **LDP3 puro** sobre os builtins (sem dívida de runtime nova).

### Pronto
- **String** (imutável) + **string** (mutável): length/charAt/substring/indexOf/contains/startsWith/
  endsWith/toUpper/toLower/trim/repeat/concat/equals/compareTo/hash/toInt.
- **Coleções:** ArrayList, Stack, Queue, Deque, LinkedList, HashMap, HashSet, TreeMap, TreeSet,
  PriorityQueue, **Bitset**; `Iterator<T>`/`Iterable<T>`; **`Slice<T>`**.
- **Funcional** (na ArrayList): `forEach`/`filter`/`map<R>`/`reduce<R>`/`any`/`all`/`count`/`find`/`min`/
  `max`/`sortedBy` (find/min/max → `Option<T>`).
- **Texto:** **`Strings`** (split/join/replace/padLeft/padRight/format/count/reverse/capitalize),
  **`Regex`** (search backtracking: `. * + ? ^ $ [ ]`), **`Utf8`** (codepoints reais), **`Scanner`**
  (nextWord/nextInt/nextLine), `StringBuilder`.
- **I/O:** `Console`, `File` (readAll/writeAll/appendAll/exists/remove), **`Files`** (readLines/writeLines/
  appendLine), **`Paths`** (join/basename/dirname/extension).
- **Outros:** `Math`, `Time`/`Duration`/`Instant`, `Net`/`Socket`, `Json`, `Random`, reflection tokens.

### Falta (F10)
- **Coleções (onda 2/3):** LinkedHashMap (ordem de inserção), navegáveis no TreeMap (firstKey/lastKey/
  floor/ceiling), EnumMap/EnumSet, Counter/MultiSet, comparator toolkit, ring buffer, grafos, spatial
  (quadtree/kd-tree), trie, coleções imutáveis.
- **Flagships LDP3** (#28): colony×persistents, containers em region, ECS, serialização por reflection,
  KV store embutido sobre persistents.
- **Math/científico** (#29): autodiff, cálculo (derivadas/integrais/ODE), álgebra linear, FFT, estatística.
- **Concorrência+rede+crypto+compressão** (#30); **app layer** (#31): logging, CLI, test framework,
  date/calendar, parser combinators, eventos/delegates, reativo.
- **Process/subprocess** (único item de I/O que falta — precisa builtin de runtime).

---

## 🎯 O que falta para a v1.0

1. **Terminar a stdlib** (ondas restantes #27–#31 acima).
2. **Toolchain `ldp3` unificada** (#17): `run`/`build`/`plug`/`fmt`/`doc`/`test`, em duas versões
   (gerenciador com TUI + clássica sem TUI). LSP.
3. **Resíduos de linguagem** (#24): persistents-em-array reattach por índice; FFI struct por valor > 8 bytes
   (ABI Win64); `move` em formas de expressão com region/persistents.
4. **Segurança no-UB** (#32): o compilador deve **errar** ao retornar objeto alocado on-stack
   (use-after-return), como já faz com referência a local.
5. **Pós-stdlib:** caçar bugs em toda a linguagem (#18), otimização agressiva do middle-end (#19).
6. **Portabilidade:** alvo **ARM/aarch64** (#20) e **Linux** (#21); kernel bootável (`_start`/linker/QEMU).

---

## Notas de maturidade

- Os dois north-stars da 0.1 (`tic_tac_toe`, `shapes`) e os exemplos de identidade plena (regions +
  ownership + catalogs) rodam nativo.
- Benchmarks: LDP3 = C = C++ no mesmo backend (sem overhead inerente); com o middle-end próprio,
  ganha/empata o gcc em toda a suíte (matmul/fib).
- A linguagem está **funcional e estável**; a 1.0 é sobre **alcance de biblioteca e ergonomia de
  toolchain**, não sobre features de linguagem faltando.
