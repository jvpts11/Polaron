# Estado de implementação da LDP3

**Atualizado em:** 2026-07-14
**Plataforma:** Windows x86_64 (+ Linux x86-64) · C++20 · LLVM 17+ (IR direto, opaque pointers) · CMake.

> ⚠️ As seções abaixo desta introdução são de 2026-06-25 e estão **parcialmente desatualizadas**:
> a toolchain `ldp3` unificada, o LSP, o Decimal, o split/replace de String e a interpolação como
> tipo já existem. Trate-as como histórico; a lista imediatamente abaixo é a atual.

## Novo em 2026-07-14 (features de linguagem da spec, antes não implementadas)

- **Named arguments + `requires named`** (spec 22.4) — `configure(volume: 5, repeat: false)`, em qualquer
  ordem; um parâmetro `requires named` não pode ser passado posicionalmente. A sema reordena os argumentos
  para a ordem declarada, então o codegen só vê posicionais. Sample: `named_args.ldp3`.
- **Constraints em métodos genéricos** (spec 15.2) — `method totalArea<T implements Shape>(...)`; validado
  em cada instanciação, como já era para classes. Sample: `generic_method_constraints.ldp3`.
- **`foreach` sobre `Iterable`/`Iterator` do usuário** (spec 9.2) — iteração **preguiçosa** via
  `hasNext()`/`next()` (sem snapshot via `toArray`), com dispatch virtual quando o sujeito é uma interface;
  um iterador infinito funciona com `break`. Sample: `foreach_iterable.ldp3`.
- **Format specifier na interpolação** (spec 4.1) — `$"pi = {pi:0.00}"` (casas decimais) e `{n:5}` (largura).
  Sample: `interp_format.ldp3`.
- **Anotação built-in `@Name`** (spec 14.1) — `@Test` passa a valer, equivalente a `[Test]`.
- **`deprecated`** (spec 14.2) — método marcado gera *warning* em cada call site (o programa compila e roda).
- **`partial` class** (spec 8.3) — a mesma classe declarada em várias partes (inclusive em arquivos
  diferentes) é fundida numa só antes de generics/semântica. Sample: `partial_class.ldp3`.
- **Bidirectional properties** (spec 32.6) — `bidirectional double fahrenheit { celsius to fahrenheit: ...;
  fahrenheit to celsius: ...; }`: ler converte a partir do campo, atribuir converte para o campo. Desaçucarado
  no maquinário de properties (getter + `nome$set`). Sample: `bidirectional_property.ldp3`.
- **`defer within <orçamento>`** (spec 32.10) — `defer within Duration.ofMillis(100) { s.close(); }` (ou um
  contador cru de milissegundos). O orçamento é avaliado *onde o defer é escrito*; estourá-lo **alerta** no
  stderr em vez de lançar — a saída de escopo pode já ser um unwind, e um cleanup atrasado ainda precisa
  terminar. Sample: `defer_within.ldp3`.
- **Generators (`yield`)** (spec 22.6) — um método que dá `yield` produz um `Iterator<T>` **preguiçoso**:
  o corpo roda até o próximo `yield`, suspende ali e retoma no ponto exato na chamada seguinte. Sequência
  infinita funciona (o consumidor para com `break`); vale em método estático e de instância (o estado captura
  o `this`). Lowering: o corpo vira uma máquina de estados em heap (a mesma do `async`) exposta como quatro
  funções cruas (`$start`/`$resume`/`$current`/`$free`), embrulhadas por uma classe sintetizada que implementa
  `Iterator<T>` — então um generator é um iterador comum (funciona em `foreach`, atrás da interface, e é
  liberado pelo laço que o possui). Sample: `generator.ldp3`.

- **Affinity hints** (spec 32.9) — `public affinity hot { ... }` / `affinity cold { ... }`: os campos *hot* são
  empacotados no começo do objeto e os *cold* no fim, independentemente da ordem em que os blocos foram
  escritos (uma subclasse continua começando exatamente com o layout da base). Data-oriented design como
  feature de linguagem. Sample: `affinity.ldp3`.
- **Mutable dispatch tables** (spec 32.8) — `Dog.methods.replace("bark", lambda(Dog d) returns void { ... })`:
  a substituição assume o slot da vtable da classe, então **toda** instância (as já vivas e as futuras) passa
  a usá-la — AOP de verdade, mocking sem framework, hot patching localizado. Type-safe: a assinatura exigida
  é `function<Retorno, Receptor, Params...>`, checada em tempo de compilação. A lambda pode capturar (a closure
  é instalada num global que o *thunk* do slot lê). Sample: `dispatch_table.ldp3`.

- **Aritmética de ponteiro** (spec 27) — `p + n` / `p - n` / `p++` / `p--` andam de **elemento em elemento**;
  `q - p` é a distância em elementos. Ponteiro pra classe é permitido **com warning** (como a spec pede).
  Junto veio o fix de um buraco real de memória: `&` só funcionava para objeto de classe — em `int`,
  elemento de array ou campo ele **carregava o valor** e devolvia como ponteiro (`int* p = &xs[0]` dava lixo).
  Sample: `pointer_arith.ldp3`.
- **`[[no_bounds_check]]`** (spec 36.4) e **`wrappingDiv`/`uncheckedDiv`** (spec 3.6) — as duas válvulas de
  escape *nomeadas*: a primeira derruba o bounds check daquele método (hot path); as segundas fazem a única
  divisão que estoura (`INT_MIN / -1`) dar wrap em vez de trap (divisor **zero** continua em pânico — isso não
  é overflow). Sample: `hot_path.ldp3`.
- **Constraint genérico com type-args** (spec 15.2) — `<T implements Comparable<T>>` agora exige Comparable
  **DE T** (antes só o nome-base "Comparable" era checado: um `Cat implements Comparable<Dog>` passava).
  Samples: `generic_bound_args.ldp3` (+ o rejeitado).
- **API `Test` da stdlib** (spec 32.11) — `Test.assertEqual/assertTrue/assertFalse/assertWithin/
  assertEqualString/assertEqualLong/assertThrows<E>`. Um `@Test` agora pode retornar **void**: o veredito vem
  das assertions (o runner zera o contador em volta de cada teste). A forma `returns boolean` continua valendo.
  Sample: `inline_tests.ldp3`.

**Testes:** suíte CTest completa (samples e2e + doctest), verde — **521 testes**.

> Documento panorâmico do que **está** e do que **não está** implementado no compilador LDP3.
> A fonte de verdade da *linguagem* continua sendo `docs/LDP3_specification.md`; este arquivo
> descreve o *compilador* (`ldp3c`). Para a divisão em fases/releases, ver `CLAUDE.md`.

---

## Como compilar um programa LDP3

```
build\Debug\ldp3c.exe programa.ldp3 -o out.ll
clang -O2 -Wno-override-module out.ll runtime\ldp3_rt.c -o out.exe -llegacy_stdio_definitions
out.exe
```

Pipeline: `Lexer → Parser → qualifyNamespaces → monomorphize → Semantic → Codegen (LLVM IR) → clang → .exe`.

---

## ✅ Implementado

### Núcleo OOP (Release 0.1 — fases F0–F3, fechada)
- **Classes:** campos, `constructor`, `destructor` (RAII — chamada automática no fim do escopo),
  métodos de instância e `static`, `this`, `super` (implícito e com args).
- **Herança/polimorfismo:** `extends`, `implements` (interfaces), `abstract` (classe e método),
  `override` (validado), **vtables + dispatch virtual**, subtyping/upcast, `final` (método).
- **enum:** simples (int-style) e Java-style (campos/construtor/métodos).
- **Visibilidade:** `public`/`private`/`protected`/`internal`, `mutable`, imutável por default.
- **Memória manual:** `new ... on stack`/`on heap`, `new T[n]()`, `delete`; localização opcional no `new`.
- **I/O 0.1:** `System.IO.Console.{printf,println,print,read}`.
- North-stars rodando: `tests/samples/tic_tac_toe.ldp3` e `shapes.ldp3`.

### Tipos
- **Primitivos:** `int8..int64`, `uint8..uint64` (unsigned real), `float`/`float32`, `double`/`float64`
  (f32 ≠ f64), `boolean`, `char`, `void`, `address` (i64, freestanding).
- **Arrays dinâmicos** `T[]` (`a[i]`, `a.length()`, `delete`).
- **Ponteiros** `T*` e **referências** `T&`.
- **`var`** (inferência, só em locais).
- **vec2/vec3/vec4** (SIMD, estilo GLSL — fatia 1).
- **String:** usável (literais, `length/charAt/isEmpty/equals/concat/substring`, interpolação
  `$"...{expr}..."` como argumento de printf). *Parcial* — ver pendências.

### Tipos ricos (F4 — em progresso, grande parte feita)
- **record**, **struct** (campos compartilham layout C em `union`), **union**.
- **Generics monomorfizados** (`Box<T>`), com **constraints** (`T extends Base`), **variance**
  (`in`/`out`), **métodos genéricos**, e **genéricos auto-referenciais** (`Node<T> { Node<T>* next; }`).
- **operator overloading**, **properties** (auto + computed get-only).
- **sealed ... permits** + **exaustividade de `match`**.
- **catalogs**.
- **match** (statement + forma-expressão `->`): dispatch por tipo dinâmico + desestruturação posicional.
- Múltiplos arquivos por programa; visibilidade de namespace via `import` (valida acesso cross-namespace).

### Memória e ownership (F5 — feito)
- **Atribuição é cópia profunda** (modelo de valor); `T*`/`T&` para compartilhar.
- **Ownership:** `move`/`movable`/`unique`/`partitionable` + flow analysis.
- **Regions** (§17): `region`, `itself.allocate`, `new in region`, `release`, `accepts`/`rejects`,
  prelude `System.Memory.Units`/`ByteSize`, sufixos (`64 kilobytes`).
- **`defer`/`using`**.
- Prefixos universais e sufixos de literal (parte de F5).

### Controle de fluxo
- `if`/`else` (+`else if`), `while`, `do`-`while`, `for`, `foreach` + ranges (`..`, `..=`, `step`),
  `switch` (com chaves, spec 7.3), `break`/`continue` (com label).
- Operadores: aritméticos, comparação, lógicos com **short-circuit**, bitwise, compostos,
  `++/--`, ternário, `cast<T>` (incl. int↔ponteiro, char↔inteiro, saturante float→int).

### Erros & comptime (F6 — feito)
- **Exceptions:** `try`/`catch`/`finally`/`throws` via landing pads LLVM (WinEH).
- **Result/Option** + açúcar `Ok/Err/Some/None` + propagação `try?`.
- **comptime evaluation** (ex.: fib/factorial em tempo de compilação), `static_assert`.
- **contracts** `requires`/`ensures`/`invariant` + `old(expr)` no ensures (checagem em runtime).

### Runtime gerenciado (F7 — completo)
- **persistents + reattach** (in-process, pela tripla no mesmo run).
- **unimport/reimport** (opção C — `reimport` recarrega o código original do `.exe` em disco).
- **reflection** (`Type`/`Method`/`Field`, `reflect.typeOf`).
- **lifecycle hooks** (`onFirstInstance`/`onLastInstanceDestroyed`/`onClassUnload`).

### Concorrência (F8 — completo)
- **Thread**, **Mutex** + statement **`synchronized`**.
- **async/await** (state machine real via coroutine lowering + worker pool; awaits em loops/ifs).
- **atomic<T>** (métodos + operadores, lock-free).
- **Channel<T>** (send/receive) + **`Channel.select`** fluente (com timeout).

### Freestanding (F9 — lado-compilador fechado)
- `address` + casts int↔ponteiro + indexação de ponteiro cru + **Memory API** (alloc/free/read/write/getMemory).
- **region `at address`** (memória mapeada).
- **FFI `extern`** (`cdecl`/`stdcall`/`fastcall`).
- declaração `program/bundle freestanding` + **enforcement** (proíbe async/exceptions/unimport/reflection/Console).
- `--target=<triple>` → `.ll` bare-metal (compila para objeto `x86_64-unknown-none`).
- **Segurança sem UB:** cast saturante, divisão/bounds checados, panic determinístico.

### Stdlib (F10 — núcleo praticamente completo)
- **I/O Console:** `System.IO.Console.{printf,println,print,read}` (import obrigatório).
- **Math** (`System.Math.Math`): `sqrt/abs/floor/ceil/round/trunc/sin/cos/exp/log/log2/log10` +
  `pow/min/max` (intrínsecos LLVM) + `tan/asin/acos/atan/sinh/cosh/tanh/cbrt/atan2/hypot` (libm) +
  `clamp/lerp`, em `double`. **Random** (xorshift64): `nextInt/nextIntMax/nextRange/nextDouble/nextBool`.
- **Coleções** (`System.Collections`) — **9 completas:** `ArrayList`, `Stack`, `Queue`, `Deque`,
  `LinkedList`, `HashMap`, `HashSet`, `TreeMap`, `TreeSet`.
  - Chaves via interfaces **`Hashable<T>`** / **`Comparable<T>`**; primitivos (int family, String)
    as satisfazem via builtins do compilador (`.hash()/.equalsKey()/.compareTo()`), sem boxing.
  - HashMap/HashSet = open addressing; TreeMap/TreeSet = BST (nós ponteiro self-ref).
  - **Iteração:** `toArray()` (todas) + `keyArray()/valueArray()` (maps); tree* saem ordenados.
  - **Elementos tipo-classe** funcionam (ArrayList<Classe>, HashMap<K,Objeto>); não só primitivos.
- **StringBuilder** (`System.Text`): buffer crescente sobre a Memory API (append amortizado O(1)).
- **Métodos de String:** length/charAt/isEmpty/equals/concat/substring + **indexOf/contains/
  startsWith/endsWith/toUpper/toLower/trim/repeat/toString** + hash/equalsKey/compareTo.
- **File I/O** (`System.IO.File`): `readAll`/`writeAll`/`appendAll`/`exists`/`remove`.
- **Time** (`System.Time`): builtin `Time.{millis,nanos,unixMillis,sleep}` + classes **`Duration`**
  (ofMillis/ofSeconds/ofMinutes, plus/minus) e **`Instant`** (now/ofEpochMillis/isBefore/isAfter/since).
- **JSON** (`System.Json`): árvore de valores **`Json`** (serialize com escaping + parser
  recursive-descent; round-trips). Nós via ponteiros filho/irmão.
- **BigInteger** (`System.Math`): precisão arbitrária (dígitos decimais em int[]); add/multiply/
  compareTo/toString (multiply de 18 dígitos correto).
- **Networking** (`System.Net.Socket`): cliente TCP sobre winsock (connect/send/receive/close).
- **Builtins de primitivo:** `int.hash()/equalsKey()/compareTo()/toString()`,
  `String.*`; `Memory.readString(addr,len)`. **char** é inteiro em operadores aritméticos/comparação.

---

## ❌ Não implementado / pendente

### Stdlib F10 (o que ainda falta)
- **toolchain `ldp3` unificada** — *propositalmente deixada por último (UX forte; decidir/planejar com
  calma com o João).* Duas versões: **com TUI** (gerenciador de projetos + environments) e **sem TUI**
  (clássico estilo `clang`/`gcc`). Inclui manifesto `.toml`, `plug` (deps via Git), `run/build/fmt/doc/test`.
- **HttpClient/URL** (só o `Socket` TCP cru existe); **Serialização binária** (JSON feito).
- **Decimal** (BigInteger feito); **Calendar/LocalDate/LocalTime** (Instant/Duration feitos).
- **Math:** mais Random (gaussiano, seed-from-time); `BigInteger` subtração/divisão.
- **String:** formatação/interpolação como tipo (`String s = $"..."`), split, replace.
- **LSP** (language server).

### ✅ Coleções de objetos — RESOLVIDO (2026-06-25)
- `ArrayList<Classe>`, `HashMap<K,Objeto>`, etc. agora funcionam (antes segfaultavam). Duas causas:
  (1) `byteSizeOf` retornava 4 bytes para elementos de array tipo-classe em vez de 8 (ponteiro);
  (2) atribuir um valor-classe a um **elemento de array** (`data[i] = item`) fazia `memcpy` para o
  objeto existente — null num array fresco → crash; agora armazena o ponteiro de uma cópia fresca
  (como nos campos). Testado com ArrayList de classe auto-contida + HashMap de valores objeto.

### Gráficos (decisão: NÃO vão no core)
- **LDP3-OpenGL** e **LDP3-Vulkan** como bibliotecas baixáveis via `plug` (FFI pronto + helpers de
  janela/contexto). A serem feitas **depois** da stdlib core + toolchain. (OpenGL = legado;
  Vulkan = tendência; ambas oferecidas.)

### Features de linguagem
- **✅ nullable (spec 3.7) — FEITO:** `nullable T` (tipos são não-null por padrão); atribuir null a um
  tipo não-null é erro; `nullable T` não flui pra não-null sem checagem; acesso a membro de nullable
  exige `if (x != null)` (flow narrowing no then; e no else de `if (x == null)`). Compile-time;
  runtime é o mesmo ponteiro.
- **✅ funções de primeira classe (spec 22) — FEITO:** tipo `function<Ret, Params...>`; valores
  `lambda(params) returns T { ... }`; capturas explícitas `lambda[captures: byvalue x, byref y](...)`
  (byvalue copia, byref compartilha e propaga mutação); funções passadas como parâmetro e retornadas
  (closures escapam para o heap); `methodref obj.method` (referência de método ligada, com **dispatch
  virtual** quando o receptor estático é polimórfico). Sample `tests/samples/lambdas.ldp3`.
- **✅ typealias / newtype (spec 24) — FEITO:** `typealias Name = Target;` transparente (expandido pra
  o alvo em todo lugar, antes da sema — suporta primitivo, `function<...>` e genérico `Box<int>`);
  `newtype Name = Target;` cria um tipo nominal distinto sobre a mesma representação (sem conversão
  implícita pro/do underlying — exige `cast`; dois newtypes sobre o mesmo underlying são distintos).
  Sample `tests/samples/type_aliases.ldp3`.
- **✅ annotations customizadas (spec 14.3) — FEITO (compile-time):** declaração
  `public annotation Name { campos (com `default` opcional) }`; aplicação `[Name(arg: val, ...)]` antes
  de classe/método/campo; `[CompileTimeProcessor]` (spec 14.4) reconhecido. O compilador valida cada
  aplicação (annotation existe; args nomeados são campos reais; sem duplicatas; campos obrigatórios
  presentes) e guarda as annotations nas declarações (sobrevivem a generics/qualify/alias). Sample
  `tests/samples/annotations.ldp3`. **Falta** (extensão): leitura via reflection em runtime
  (`t.annotations()`, spec 31) — precisa da metadata de annotation no binário.
- **✅ contracts (spec 29) — FEITO:** `requires` (pré), `ensures` (pós) e `invariant` de classe;
  cláusulas booleanas checadas em runtime (violação imprime `contract violated: <kind>` e sai com
  código 1). `requires` checado na entrada; `ensures`+`invariant` em cada saída. `ensures` suporta
  **`old(expr)`** (valor capturado na entrada do método). Sample `tests/samples/contracts.ldp3`.

### Features de linguagem ainda ausentes/parciais
- **leitura de annotations via reflection em runtime** (`t.annotations()`) — declaração/aplicação/
  validação já existem; falta expor a metadata no token `Type` (spec 31).
- **`goto`/`comefrom`/`abstainfrom`/`reinstate`** — parcialmente na AST, sem suporte pleno.
- Overflow trapping configurável (há checagem determinística, mas não os modos da spec).

### Dívidas técnicas conhecidas
- **Importar genérico por nome-base não resolve** — `ArrayList`/`Stack`/`HashMap` etc. são usados
  **sem** `import` (a exigência de import vale para tipos não-genéricos). É um fix pendente.
- **async:** *temporary spilling* — um valor calculado antes de um `await` na mesma expressão não
  sobrevive à suspensão (workaround: extrair para um local antes do `await`).
- **TreeMap/TreeSet** são BST **não balanceadas** (pior caso O(n)).
- **Generics avançado** (F4): tuplas, nomes totalmente qualificados (`app.Foo` ≠ `lib.Foo`), catalogs
  ponta-a-ponta — pendências menores.
- **Freestanding:** falta o alvo de teste real (kernel bootável + linker script + QEMU).
- **SIMD:** só a fatia 1 (vec2/3/4 básicos); faltam `mat4`, `dot`/`length`, escrita de lanes, etc.
- **Método que retorna classe terminando em `while(true)`** precisa de um `return` explícito após o
  loop (o codegen emite um retorno default com tipo errado no bloco inalcançável). Workaround simples.
- **`Memory.read<int8>` / `new int8[]`** (type-arg bit-counted) não são pegos pelo enforcement de
  "bit-counted só em freestanding" no modo normal (raro; o enforcement cobre campos/params/var/cast).
- Acesso encadeado e alguns casts signed↔unsigned, RAII de região, singleton de enum-Java — pontas soltas menores.

---

## Resumo por release (ver `CLAUDE.md` para detalhes)

| Fase | Conteúdo | Estado |
|------|----------|--------|
| F0–F3 | Núcleo OOP → `.exe` nativo (Release 0.1) | ✅ fechada |
| F4 | Tipos ricos (generics, record/struct/union, match, properties, operadores, sealed) | ✅ em grande parte; pendências menores |
| F5 | Identidade LDP3 (regions, ownership, defer/using, prefixos) | ✅ feito |
| F6 | Erros & comptime (exceptions, Result/Option, comptime, static_assert) | ✅ feito |
| F7 | Runtime gerenciado (persistents, unimport/reimport, reflection, hooks) | ✅ completo |
| F8 | Concorrência (Thread, Mutex, async/await, atomic, Channel/select) | ✅ completo |
| F9 | Freestanding (address, Memory, FFI, --target) | ✅ lado-compilador; falta kernel+QEMU |
| F10 | Stdlib + toolchain + LSP | 🚧 núcleo da stdlib pronto (coleções+iteração inclusive de objetos, Math+extra, String, StringBuilder, File, Time+Duration/Instant, JSON, BigInteger, TCP); falta toolchain (por último), HttpClient/Decimal/LSP; tipos normais vs freestanding feitos |
