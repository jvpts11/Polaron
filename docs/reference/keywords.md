# LDP3 — Referência Completa de Keywords

Referência de todas as palavras reservadas da LDP3. Uma entrada por keyword, com o que
faz, a sintaxe (snippet curto) e o *status* (hard / soft-contextual / freestanding / reservada
mas não implementada).

**Fontes de verdade desta referência:**

- `docs/LDP3_specification.md` — a spec (fonte de verdade da linguagem).
- `docs/LDP3_keywords.md` — catálogo de apoio (tem exemplos legados que contradizem a spec;
  onde divergem, **vale a spec**).
- `src/lexer/lexer.cpp` + `src/lexer/token.h` — o conjunto de keywords que o compilador
  realmente reconhece (hard keywords). É a autoridade sobre o que está *reservado hoje*.
- `src/parser/parser.cpp` + `src/semantic/analyzer.cpp` — soft/contextual keywords e nomes de
  tipo resolvidos fora do lexer.

## Como ler o status de cada entrada

| Status | Significado |
|--------|-------------|
| **hard** | Reservada no lexer (`keywordKind`); nunca pode ser identificador. |
| **soft / contextual** | Tokenizada como `Identifier`; só vira keyword em um contexto específico do parser. Pode ser usada como identificador em outros lugares. |
| **tipo (semântico)** | Não é keyword do lexer; é um nome de tipo reconhecido pela análise semântica. |
| **freestanding-only** | Reconhecida, mas o uso é restrito/liberado apenas no modo freestanding. |
| **removida em freestanding** | Hard keyword no modo completo, proibida no modo freestanding. |
| **reservada (spec) — não implementada** | Aparece na spec / catálogo, mas o compilador atual **não** a reconhece. Documentada aqui para completude; não use como se funcionasse. |
| **migrada pra stdlib** | Já foi keyword no design antigo; hoje é tipo/método de biblioteca, não palavra reservada. |

> **Divergências spec × implementação assinaladas nesta referência (a spec vence no design;
> a implementação manda no que compila hoje):**
> - Constante nomeada de compile-time: o compilador usa **`fixed T NOME = expr;`**, não `const`.
>   `const` aparece na spec/catálogo mas **não é reservada** no lexer.
> - `switch`/`case`: a spec usa `case V { ... }` (chaves). O catálogo legado usa `case V:`
>   (dois-pontos) — segue a spec.
> - `operator`: a spec usa `operator + (...)`. O catálogo legado usa `operator method +(...)`
>   — segue a spec.
> - `cdecl`/`stdcall`/`fastcall`/`byCatalog`/`expecting`/`onFailure`: a spec 39 as chama
>   "contextuais", mas o lexer as reserva como **hard keywords**.
> - `yield`: hoje é o valor de um *arm* de expressão-`match` (spec 16.2), não `Generator` como
>   no catálogo legado.

---

## Índice

- [1. Organização e estrutura](#1-organização-e-estrutura)
- [2. Membros de tipo](#2-membros-de-tipo)
- [3. Visibilidade e modificadores](#3-visibilidade-e-modificadores)
- [4. Herança e polimorfismo](#4-herança-e-polimorfismo)
- [5. Tipos e operações de tipo](#5-tipos-e-operações-de-tipo)
- [6. Memória, ownership e recursos](#6-memória-ownership-e-recursos)
- [7. Prefixos universais](#7-prefixos-universais)
- [8. Controle de fluxo](#8-controle-de-fluxo)
- [9. Ranges e iteração](#9-ranges-e-iteração)
- [10. Exceções e contracts](#10-exceções-e-contracts)
- [11. Concorrência](#11-concorrência)
- [12. FFI / interop](#12-ffi--interop)
- [13. Compile-time, módulos e imports](#13-compile-time-módulos-e-imports)
- [14. Runtime gerenciado (persistents, unimport, hooks, tétrade do caos)](#14-runtime-gerenciado)
- [15. Tipos primitivos e literais](#15-tipos-primitivos-e-literais)
- [16. Soft / contextual keywords](#16-soft--contextual-keywords)
- [17. Reservadas na spec mas não implementadas](#17-reservadas-na-spec-mas-não-implementadas)
- [18. Identifiers reservados pela stdlib](#18-identifiers-reservados-pela-stdlib)
- [19. Modo freestanding — resumo](#19-modo-freestanding--resumo)
- [20. Contagens](#20-contagens)

---

## 1. Organização e estrutura

#### `program`
**hard.** Unidade organizacional mais externa; nomeia o programa. Uma declaração por arquivo raiz.
```ldp3
program HelloWorld;
```

#### `bundle`
**hard.** Unidade de compilação independente dentro de um programa; contém namespaces. Pode ser
declarado `freestanding`.
```ldp3
public bundle main { /* namespaces... */ }
public bundle kernel freestanding { /* ... */ }
```

#### `namespace`
**hard.** Organização lógica dentro de um bundle; contém classes, interfaces, enums etc. Controla
visibilidade cross-namespace (acesso exige `import`).
```ldp3
public namespace game.entities { public class Player { } }
```

#### `class`
**hard.** Declara uma classe — a unidade fundamental de OOP em LDP3.
```ldp3
public class Dog { private string name; }
```

#### `interface`
**hard.** Declara uma interface (contrato). Pode ter métodos default.
```ldp3
public interface Drawable { method draw() returns void; }
```

#### `struct`
**hard.** Tipo composto value-type; suporta bit fields (`campo : N`).
```ldp3
public struct PacketHeader {
    public mutable uint8 version : 4;
    public mutable uint8 kind : 4;
}
```

#### `record`
**hard.** Tipo imutável estilo DTO; gera construtor/igualdade a partir dos parâmetros posicionais.
```ldp3
public record Point(int x, int y);
```

#### `union`
**hard.** União estilo C — os campos compartilham o mesmo storage (interpretação alternativa da
mesma memória).
```ldp3
public union FloatBits { public float32 asFloat; public uint32 asBits; }
```

#### `enum`
**hard.** Enumeração. Forma simples (constantes ordinais) e forma Java-style (campos, construtor,
métodos). Pode implementar `catalog`.
```ldp3
public enum Color { RED, GREEN, BLUE }
```

#### `catalog`
**hard.** Interface para enums: exige que o enum implementador forneça métodos **e** valores
específicos (estes via bloco `byCatalog`).
```ldp3
public catalog Severity { INFO  int weight(); }
```

#### `byCatalog`
**hard** (a spec 39 a lista como contextual; o lexer a reserva). No corpo de um enum que
implementa um catalog, lista os valores requeridos que o enum satisfaz.
```ldp3
public enum LogLevel extends Severity {
    INFO, WARN, ERROR
    byCatalog { INFO }
    public override method weight() returns int { return 1; }
}
```

---

## 2. Membros de tipo

#### `method`
**hard.** Declara um método. A palavra é obrigatória. Não há overloading — nome único por método.
```ldp3
public method bark() returns void { }
```

#### `constructor`
**hard.** Método especial de criação; mesmo nome da classe.
```ldp3
public constructor Dog(string name) { this.name = name; }
```

#### `destructor`
**hard.** Método especial de destruição; sintaxe `~ClassName()`. Roda via RAII no fim do escopo
(stack) ou em `delete` (heap).
```ldp3
public destructor ~Connection() { this.close(); }
```

#### `operator`
**hard.** Declara operator overload. Sintaxe da spec: `operator <op> (...)` (sem `method`).
```ldp3
public operator + (Vec3 other) returns Vec3 { /* ... */ }
```

#### `returns`
**hard.** Introduz o tipo de retorno de um método/construtor.
```ldp3
public method area() returns int { return this.w * this.h; }
```

#### `return`
**hard.** Retorna de um método, com ou sem valor.
```ldp3
return 42;
return;
```

---

## 3. Visibilidade e modificadores

#### `public`
**hard.** Acessível de qualquer lugar.
```ldp3
public class Api { }
```

#### `private`
**hard.** Acessível só dentro da classe declarante.
```ldp3
private int secret;
```

#### `protected`
**hard.** Acessível pela classe e suas subclasses.
```ldp3
protected method helper() returns void { }
```

#### `internal`
**hard.** Acessível apenas dentro do mesmo bundle.
```ldp3
internal class Helper { }
```

#### `static`
**hard.** Pertence à classe, não à instância. Chamada via `ClassName.membro`.
```ldp3
public static method create() returns Instance { }
```

#### `abstract`
**hard.** Classe que não instancia diretamente; método sem corpo que subclasse concreta deve
sobrescrever.
```ldp3
public abstract class Animal { public abstract method sound() returns void; }
```

#### `final`
**hard.** Também é [prefixo universal](#7-prefixos-universais). Método que não pode ser
sobrescrito, classe que não pode ser estendida, import que não pode ser removida.
```ldp3
public final method criticalOp() returns void { }
```

#### `override`
**hard.** Obrigatório ao sobrescrever um método herdado (classe ou interface).
```ldp3
public override method sound() returns void { }
```

#### `mutable`
**hard.** Permite reatribuição/mutação. Tudo é imutável por default; `mutable` só onde há
reatribuição da variável/campo.
```ldp3
mutable int counter = 0;
```

#### `nullable`
**hard.** Marca que um tipo pode ser `null`. É declaração-só: a checagem é feita na atribuição, sem
narrowing por fluxo; deref de um `null` é trap determinístico (spec 3.7).
```ldp3
nullable Dog maybe = null;
```

#### `sealed`
**hard.** Restringe as subclasses às listadas em `permits`; habilita `match` exaustivo sem
`default`.
```ldp3
public sealed class Shape permits Circle, Square { }
```

#### `permits`
**hard.** Lista as subclasses permitidas de uma classe `sealed`.
```ldp3
public sealed class Shape permits Circle, Square, Triangle { }
```

---

## 4. Herança e polimorfismo

#### `extends`
**hard.** Herança de classe (ou de catalog por enum).
```ldp3
public class Puppy extends Dog { }
```

#### `implements`
**hard.** Implementação de interface (ou catalog).
```ldp3
public class FileLogger implements Logger { }
```

#### `this`
**hard.** Referência à instância atual. `this.` é obrigatório para acessar membros da própria
classe.
```ldp3
public method setName(string n) returns void { this.name = n; }
```

#### `super`
**hard.** Referência à superclasse: `super(args)` no construtor e `super.metodo()` para chamar a
versão da base.
```ldp3
public constructor Puppy(string n) { super(n); }
```

---

## 5. Tipos e operações de tipo

#### `var`
**hard.** Inferência de tipo — permitida **só** em variáveis locais.
```ldp3
var counter = 0;      // int
var dog = new Dog();  // Dog
```

#### `is`
**hard.** Type check dinâmico; retorna boolean.
```ldp3
if (obj is Dog) { /* ... */ }
```

#### `as`
**hard.** Cast/downcast por referência entre tipos compatíveis (checado em runtime).
```ldp3
Dog d = animal as Dog;
```

#### `cast`
**hard.** Cast explícito com tipo entre `< >`, inclusive conversões numéricas (saturantes, sem UB).
```ldp3
int x = cast<int>(floatValue);
uint u = cast<uint>(255);
```

#### `null`
**hard.** Literal de ausência de valor; válido apenas para tipos `nullable`.
```ldp3
nullable Dog d = null;
```

#### `typealias`
**hard.** Alias de tipo (sem identidade nova).
```ldp3
typealias UserList = ArrayList<User>;
```

#### `newtype`
**hard.** Wrapper com identidade de tipo própria (distinto do subjacente).
```ldp3
newtype UserId = int;   // UserId != OrderId, mesmo ambos sendo int
```

---

## 6. Memória, ownership e recursos

#### `new`
**hard.** Aloca uma instância; a localização é opcional (`on stack`/`on heap`/`in region`), com
default sensato.
```ldp3
Dog a = new Dog("Rex") on stack;
Dog* b = new Dog("Big") on heap;
Car c = new Car() in region garage;
```

#### `delete`
**hard.** Libera memória alocada com `new`, rodando o destrutor antes.
```ldp3
delete rex;
```

#### `on`
**hard.** Especifica local de alocação: `on stack` ou `on heap`.
```ldp3
Dog rex = new Dog() on heap;
```

#### `in`
**hard.** Duplo uso: alvo de region no `new` (`in region X`) e iteração em `for (x in coll)`. Na
spec também marca variância contravariante `<in T>`.
```ldp3
Dog* rex = new Dog() in region pets;
for (Item x in collection) { }
```

#### `region`
**hard.** Tipo nativo: porção nomeada de memória com regras de aceitação de tipos. Aloca via
`itself.allocate(...)`; libera com `release`.
```ldp3
region pets = itself.allocate(64 kilobytes).accepts({Dog, Cat});
```

#### `of`
**hard.** Desambiguação de region na declaração de um ponteiro/variável.
```ldp3
Car* tesla of region parking = /* ... */;
```

#### `accepts`
**hard.** Lista os tipos que uma region aceita (forma `.accepts({...})`).
```ldp3
region r = itself.allocate(1 megabytes).accepts({Particle});
```

#### `rejects`
**hard.** Lista os tipos que uma region rejeita.
```ldp3
region r = itself.allocate(1 megabytes).rejects({Wild});
```

#### `itself`
**hard.** Pronome de auto-referência no *initializer* de uma declaração — refere-se à própria
variável/campo sendo declarado. Válido só em initializer de local ou de campo. Disponível em
freestanding (compile-time).
```ldp3
region small = itself.allocate(8 kilobytes).accepts({Particle});
```

#### `release`
**hard.** Libera um persistent ou uma region. **Removida em freestanding.**
```ldp3
release region pets;
release persistent car.chassi;
```

#### `move`
**hard.** Transfere ownership entre variáveis, regions ou disciplinas; invalida a origem. Opera em
vários eixos (`into`/`to region`/`from region`/`as`/qualificadores de persistents). Disponível em
freestanding.
```ldp3
Connection c2 = move c1;
move c from region staging to region production;
Connection c3 = move c1 into region prod;
```

#### `movable`
**hard.** Disciplina de classe: exige `move` explícito para transferir ownership; atribuição sem
`move` é erro. Disponível em freestanding.
```ldp3
public movable class Connection { }
```

#### `unique`
**hard.** Disciplina de classe: no máximo uma referência viva por vez; atribuição é *move*
implícito. Disponível em freestanding.
```ldp3
public unique class FileHandle { }
```

#### `partitionable`
**hard.** Modificador de classe que permite mover campos individuais (opt-in). `unique
partitionable` é proibido. Disponível em freestanding.
```ldp3
public partitionable class GameState { public movable Socket socket; }
```

#### `persistent`
**hard.** Campo que sobrevive ao destrutor do objeto-pai; reataca automaticamente por identidade
(escopo + nome + region). Modelo in-process. **Removida em freestanding.**
```ldp3
public class Car { public persistent Chassi chassi; }
```

#### `transient`
**hard.** Campo não-serializável (não persiste em snapshots/serialização). Contraditório com
`persistent`.
```ldp3
public transient string sessionToken;
```

#### `eternal`
**hard.** Também [prefixo universal](#7-prefixos-universais). Recurso vive por toda a execução do
programa, sem cleanup explícito.
```ldp3
public eternal static ArrayList<Player> players = new ArrayList<Player>();
```

#### `defer`
**hard.** Adia um bloco para o fim do escopo atual (ordem LIFO); roda também no unwind de exceção.
```ldp3
public method process() returns void {
    File* f = open("data.txt");
    defer { close(f); }
}
```

#### `using`
**hard.** Variável bound em `synchronized`; contexto em `expecting`. **Removida em freestanding.**
```ldp3
synchronized(resource) using Resource& res { res.update(); }
```

#### `external`
**hard.** Modificador de campo: marca uma associação **não-possuída** — `cascade` não segue esse
campo (spec 37.1). Não confundir com `extern` (FFI).
```ldp3
public external Node* parent;   // referência, não ownership
```

---

## 7. Prefixos universais

Seis keywords com semântica consistente em qualquer contexto compatível; combináveis quando fizer
sentido. Estão nesta seção por serem prefixos, mas cada uma também aparece na sua categoria de
origem.

#### `cascade`
**hard.** Propaga uma operação recursivamente pelas dependências/campos possuídos do alvo (delete,
clone, unimport, print, move…). Aceita parâmetros (`cascade(depth: 3) ...`).
```ldp3
cascade delete player;      // player + tudo owned
cascade clone source into dest;
```

#### `eternal`
**hard.** Vida igual à do programa. Ver seção 6.
```ldp3
public eternal region globalCache = itself.allocate(64 megabytes);
```

#### `lazy`
**hard.** Adia a execução/inicialização até o primeiro acesso (thread-safe implícito).
**Removida em freestanding.**
```ldp3
lazy Dog rex = new Dog("Rex");
```

#### `comptime`
**hard.** Executa em tempo de compilação; zero overhead em runtime. Ver seção 13.
```ldp3
comptime int FIB10 = fibonacci(10);
```

#### `volatile`
**hard.** Não otimizável pelo compilador; leituras/escritas sempre reais.
```ldp3
public volatile int hardwareRegister = 0;
```

#### `final`
**hard.** Não modificável/sobrescrevível/removível. Ver seção 3.
```ldp3
final import Dog;   // não pode ser unimportada
```

> **Ordem composicional canônica** (declarações):
> `[visibilidade] [movable|unique] [partitionable] [eternal] [lazy] [final] [comptime]
> [volatile] [cascade] [static] [mutable] [persistent|transient] [in region X] <tipo> <nome>`.
> Combinações contraditórias (`mutable final`, `persistent transient`, `comptime volatile`,
> `unique partitionable`, …) são rejeitadas.

---

## 8. Controle de fluxo

> Todo bloco exige `{ }`, mesmo de uma linha. Atribuição não é expressão (`if (x = 5)` é erro).

#### `if` / `else`
**hard.** Condicional com chaves obrigatórias; `else if` encadeia.
```ldp3
if (x > 0) { pos(); } else { nonPos(); }
```

#### `while`
**hard.** Loop com teste no topo.
```ldp3
while (cond) { work(); }
```

#### `do`
**hard.** Loop do-while: executa ao menos uma vez, testa no fim.
```ldp3
do { r = read(); } while (r != 0);
```

#### `for`
**hard.** For clássico e for-in (ranges / coleções). Ver `in`, `index`, `step`.
```ldp3
for (mutable int i = 0; i < 9; i++) { }
for (mutable int i in 0..10) { }
```

#### `switch`
**hard.** Switch com fall-through. **Chaves obrigatórias em cada `case`** (spec 7.3).
```ldp3
switch (x) {
    case 1 { handleOne(); break; }
    case 2 { handleTwo(); break; }
    default { handleOther(); }
}
```

#### `case`
**hard.** Cláusula de `switch` ou de `match`. Em `match`, pode desestruturar posicionalmente.
```ldp3
case Circle(double r) { return 3 * r * r; }
```

#### `default`
**hard.** Cláusula default de `switch`/`match`.
```ldp3
default { handleUnknown(); }
```

#### `break`
**hard.** Sai do loop/switch atual (suporta label).
```ldp3
if (done) { break; }
```

#### `continue`
**hard.** Próxima iteração do loop (suporta label).
```ldp3
if (skip) { continue; }
```

#### `match`
**hard.** Pattern matching por tipo dinâmico, exaustivo (statement e forma de expressão com `->`).
Sealed sem `default` exige cobrir todos os `permits`.
```ldp3
int a = match(shape) {
    case Circle c -> c.area();
    case Square s -> s.side * s.side;
};
```

#### `yield`
**hard.** Valor de um *arm* de bloco em uma expressão-`match` (spec 16.2).
```ldp3
int v = match(x) { case A a { yield a.n; } default { yield 0; } };
```

#### `goto`
**hard.** Salto para um `label` (intra-método; também goto-address em freestanding). Parte da
"tétrade do caos".
```ldp3
if (error) { goto cleanup; }
label cleanup;
```

#### `label`
**hard.** Marca um statement como alvo de `goto`/`comefrom`/`abstainfrom` (`label nome;`).
```ldp3
label processing;
```

#### `comefrom`
**hard.** Interceptação inversa do `goto`: declara no destino que, ao alcançar o label, o fluxo
desvia. Escopo intra-classe. **Removida em freestanding.**
```ldp3
comefrom inicio;
```

#### `abstainfrom`
**hard.** Desativa um label e o bloco que ele introduz (reference-counted; `reinstate` reativa).
Escopo intra-classe. **Removida em freestanding.**
```ldp3
abstainfrom handleInterrupt.processing;
```

#### `reinstate`
**hard.** Reativa um label previamente desativado com `abstainfrom`. **Removida em freestanding.**
```ldp3
reinstate handleInterrupt.processing;
```

---

## 9. Ranges e iteração

#### `step`
**hard.** Passo customizado em um range (`a..b step n`).
```ldp3
for (mutable int i in 0..100 step 2) { }
```

#### `index`
**hard.** Expõe o índice em um for-in.
```ldp3
for (Item x in coll index i) { Console.println($"{i}: {x}"); }
```

> Operadores de range (não são keywords): `..` (exclusivo) e `..=` (inclusivo).

---

## 10. Exceções e contracts

#### `try`
**hard.** Bloco protegido. **Removida em freestanding.**
```ldp3
try { doWork(); } catch (IOException e) { handle(e); }
```

#### `catch`
**hard.** Captura uma exceção. **Removida em freestanding.**
```ldp3
catch (IOException e) { handle(e); }
```

#### `finally`
**hard.** Bloco sempre executado (com ou sem exceção). **Removida em freestanding.**
```ldp3
try { work(); } finally { cleanup(); }
```

#### `throw`
**hard.** Lança uma exceção. **Removida em freestanding.**
```ldp3
throw new InvalidArgument("out of range");
```

#### `throws`
**hard.** Declara as exceções que um método pode lançar. **Removida em freestanding.**
```ldp3
public method open(string p) returns File* throws IOException { }
```

#### `requires`
**hard.** Precondition (contract), validada na entrada do método.
```ldp3
public method withdraw(int a) returns void requires(a > 0) { }
```

#### `ensures`
**hard.** Postcondition, validada na saída. Aceita `old(...)` para o valor anterior (soft keyword).
```ldp3
ensures(this.balance == old(this.balance) - a)
```

#### `invariant`
**hard.** Invariante de classe, checada antes/depois de cada método público.
```ldp3
invariant(this.count >= 0);
```

#### `static_assert`
**hard.** Assertion validada em compile-time.
```ldp3
static_assert(sizeof(int) == 4, "int must be 32-bit");
```

---

## 11. Concorrência

> `Thread`, `Mutex`, `Channel<T>`, `Task<T>`, `atomic<T>` e `Channel.select` são **tipos/métodos da
> stdlib**, não keywords.

#### `async`
**hard.** Marca método assíncrono; roda em pool de workers, pode usar `await`. **Removida em
freestanding.**
```ldp3
public async method fetch() returns Task<Data> { }
```

#### `await`
**hard.** Suspende o método async até a tarefa awaited completar. **Removida em freestanding.**
```ldp3
Data d = await fetch();
```

#### `synchronized`
**hard.** Seção crítica com mutex implícito; a variável travada é bound via `using`.
```ldp3
synchronized(shared) using Shared& s { s.update(); }
```

---

## 12. FFI / interop

#### `extern`
**hard.** Declara uma função externa (FFI); pode especificar calling convention e biblioteca.
```ldp3
extern cdecl method printf(char* fmt, ...) returns int from "libc";
```

#### `cdecl`
**hard** (spec 39 chama contextual; lexer reserva). Calling convention C em `extern`.
```ldp3
extern cdecl method f() returns void;
```

#### `stdcall`
**hard.** Calling convention Windows stdcall em `extern`.
```ldp3
extern stdcall method g() returns void;
```

#### `fastcall`
**hard.** Calling convention fastcall em `extern`.
```ldp3
extern fastcall method h() returns void;
```

#### `freestanding`
**hard.** Marca um `program`/`bundle` como freestanding (bare-metal): proíbe async, exceptions,
unimport, reflection, Console etc. (spec 36).
```ldp3
public bundle kernel freestanding { }
```

---

## 13. Compile-time, módulos e imports

#### `comptime`
**hard.** Executa em compile-time (método/valor/`if`). Ver também [prefixos](#7-prefixos-universais).
```ldp3
comptime method fib(int n) returns int { /* ... */ }
comptime int f10 = fib(10);
```

#### `literal`
**hard.** Declara uma função como sufixo de literal numérico. Deve ser `comptime`, com exatamente um
parâmetro numérico. Disponível em freestanding.
```ldp3
public comptime literal kilobytes(int x) returns ByteSize { return new ByteSize(x * 1024); }
ByteSize cache = 64 kilobytes;
```

#### `fixed`
**hard.** Declara uma **constante nomeada de compile-time** (`fixed T NOME = expr;`), a nível de
namespace ou como membro estático de classe/struct. *(A spec/catálogo chamam isso de `const`; o
compilador usa `fixed`.)*
```ldp3
public fixed int MAX_SIZE = 1024;
```

#### `import`
**hard.** Carrega um símbolo (classe, namespace, bundle) na memória do programa. A stdlib exige
import explícito.
```ldp3
import Dog;
import System.IO.Console;
import Greeter from bundle ui;
```

#### `annotation`
**hard.** Declara uma annotation customizada (metadata para classes/métodos/campos).
```ldp3
public annotation Deprecated(string reason, string since) { }
```

---

## 14. Runtime gerenciado

Persistents, descarga de código, autenticação de imports e hooks de ciclo de vida. A maioria é
**removida em freestanding**.

#### `unimport`
**hard.** Remove um símbolo da memória em runtime (descarrega o código). **Removida em freestanding.**
```ldp3
unimport Dog;
unimport namespace audio.mixers;
```

#### `reimport`
**hard.** Recarrega, em runtime, um símbolo previamente `unimport`ado (opção C: recarrega do `.exe`
em disco). **Removida em freestanding.**
```ldp3
reimport Dog expecting proof { return Dog.fingerprint(); } onFailure { panic(); };
```

#### `expecting`
**hard** (spec 39 chama contextual). Bloco de validação de autenticidade em import/unimport.
**Removida em freestanding.**
```ldp3
var proof = unimport Dog expecting { return Dog.fingerprint(); };
```

#### `onFailure`
**hard.** Bloco obrigatório disparado quando a validação `expecting` de um import/reimport falha.
**Removida em freestanding.**
```ldp3
import Dog expecting proof { return Dog.fingerprint(); } onFailure { System.exit(1); };
```

#### `methodref`
**hard.** Referência ligada a um método (bound method reference), spec 22.3.
```ldp3
var ref = methodref obj.method;
```

#### `lambda`
**hard.** Função anônima com captura explícita.
```ldp3
items.forEach(lambda(Item x) returns void { process(x); });
```

#### `function`
**hard, reservada.** Reservada pelo lexer para tipos de função/referência; usada em posições de tipo
de função na monomorfização. Sem forma de declaração de função livre (LDP3 é OOP-obrigatória).
```ldp3
// reservada — sem função livre; toda função é método
```

---

## 15. Tipos primitivos e literais

LDP3 tem dois conjuntos de nomes de tipo inteiro/float. No **modo normal** usam-se os nomes
"largos"; os nomes **bit-counted** (`int8`…`float64`) são reservados no lexer mas **só compilam em
modo freestanding** (em modo normal, o analyzer erra e sugere o nome normal correspondente).

#### Nomes normais (hard keywords)

| Keyword | Tipo |
|---------|------|
| `byte` | inteiro 8 bits sem sinal (alias de uint8) |
| `short` | inteiro 16 bits com sinal (alias de int16) |
| `int` | inteiro 32 bits com sinal (default) |
| `long` | inteiro 64 bits com sinal (alias de int64) |
| `float` | ponto flutuante 32 bits |
| `double` | ponto flutuante 64 bits |
| `boolean` | `true` / `false` |
| `char` | caractere |
| `void` | ausência de tipo de retorno |
| `string` | string mutável |
| `String` | string imutável (classe) |

```ldp3
int n = 42;
double d = 3.14;
char c = 'X';
boolean ok = true;
mutable string buf = "hi";
```

#### Nomes normais resolvidos pela semântica (não são keywords do lexer)

`ubyte`, `ushort`, `uint`, `ulong` (unsigned 8/16/32/64) e `smallfloat` (16), `quadruple` (128) são
**nomes de tipo** reconhecidos pela análise semântica, não palavras reservadas do lexer.
```ldp3
uint crc = cast<uint>(4294967295);
ulong state = cast<ulong>(1);
```

#### Nomes bit-counted (hard keywords, **freestanding-only**)

`int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `float32`, `float64`.
Em modo normal, usá-los é erro (o compilador sugere `byte`/`short`/`int`/`long`/`ubyte`/…/`float`/
`double`).
```ldp3
// só em bundle freestanding:
uint8 version = 4;
float32 x = 1.0;
```

#### Literais booleanos

#### `true`
**hard.** Literal booleano verdadeiro.
```ldp3
boolean b = true;
```

#### `false`
**hard.** Literal booleano falso.
```ldp3
boolean b = false;
```

> Outros literais (não são keywords): inteiros em várias bases, `float` (`1.5`), `Decimal` (sufixo
> `m`, ex. `1.50m`), `char` (`'x'`), string (`"..."`), interpolação (`$"x = {expr}"`).

---

## 16. Soft / contextual keywords

Tokenizadas como `Identifier`; só viram keyword no contexto indicado. Fora dele, podem ser usadas
como identificadores comuns.

| Palavra | Contexto | Uso |
|---------|----------|-----|
| `get` | corpo de property | `public int age { get; }` |
| `set` | corpo de property | `public int age { get; set; }` |
| `init` | corpo de property | `public string key { get; init; }` |
| `from` | `import`/`move` | `import Dog from bundle pets;` / `move c from region a to region b` |
| `to` | `move` (e `bidirectional` na spec) | `move c to region prod` |
| `into` | `move` | `move c1 into region prod` |
| `out` | posição de type param genérico | `interface Producer<out T> { }` (variância covariante) |
| `old` | dentro de `ensures(...)` | `ensures(this.n == old(this.n) + 1)` |
| `carrying` | qualificador de `move` | `move c1 carrying persistents` (default) |
| `leaving` | qualificador de `move` | `move c1 leaving persistents` |
| `releasing` | qualificador de `move` | `move c1 releasing persistents` |
| `onClassLoad` | corpo de classe (hook) | `onClassLoad { init(); }` |
| `onFirstInstance` | corpo de classe (hook) | `onFirstInstance { setup(); }` |
| `onLastInstanceDestroyed` | corpo de classe (hook) | `onLastInstanceDestroyed { teardown(); }` (removida em freestanding) |
| `onClassUnload` | corpo de classe (hook) | `onClassUnload { cleanup(); }` (removida em freestanding) |
| `asm` | `asm("arch") { ... }` | bloco de assembly inline; fora disso é identificador comum |

> `carrying`/`leaving`/`releasing` são **removidas em freestanding** (dependem de persistents).
> Nomes de tipo contextuais (`ubyte`/`ushort`/`uint`/`ulong`/`smallfloat`/`quadruple`/`address`)
> estão na [seção 15](#15-tipos-primitivos-e-literais) e [19](#19-modo-freestanding--resumo).

---

## 17. Reservadas na spec mas não implementadas

Estas palavras aparecem em `docs/LDP3_keywords.md` e/ou na spec, mas o compilador atual **não** as
reconhece (não estão no lexer nem são tratadas no parser/semantic). Documentadas para completude —
não funcionam hoje.

| Palavra | Intenção documentada | Situação |
|---------|----------------------|----------|
| `const` | constante de compile-time | **Substituída por `fixed`** na implementação; `const` não é reservada. |
| `module` | unidade organizacional futura | Reservada só na spec; não implementada. |
| `package` | sistema de packages futuro | Reservada só na spec; não implementada. |
| `library` | sistema de bibliotecas futuro | Reservada só na spec; não implementada. |
| `partial` | classe dividida em vários arquivos | Documentada; não reconhecida pelo compilador. |
| `delegate` | tipo de referência a método | Não implementada — use `methodref`/`lambda`. |
| `affinity` / `hot` / `cold` | hint de layout (cache locality) | Documentadas; não reconhecidas. |
| `bidirectional` / `to` (par de conversão) | tipo com conversão bidirecional | Não implementada. |
| `within` | timeout em `defer within ...` | Documentada na spec; não reconhecida. |
| `force` | modificador de `unimport` | Contextual na spec; não reconhecida. |
| `timeout` | modificador de `unimport` | Como keyword de unimport, não reconhecida (existe só como método de `Channel.select`). |
| `deprecated` | marca deprecated | Documentada; não reconhecida (use `annotation`). |
| `serializable` | marca serializável | Documentada; não reconhecida. |
| `version` | versionamento de bundle | Reservada só na spec; não implementada. |
| `checked` / `saturating` / `wrapping` / `unchecked` | modos de aritmética | `checked(expr)` existe como **builtin**, não keyword; os demais viraram métodos de stdlib. |

> **Migradas pra stdlib** (não são keywords em nenhum modo): `thread`, `channel`, `select`,
> `snapshot`, `restore`, `reverse`, `reversible`, `forward`, `backward`, `witness`, `assert`,
> `tests`, `saturating`, `wrapping`, `unchecked`, `allocate`, `at`, `kilobytes`, `megabytes`.

---

## 18. Identifiers reservados pela stdlib

Não são keywords técnicas, mas a stdlib os reserva; não use como identificadores.

- **`System`** — I/O e sistema: `System.IO.Console.println(...)`, `System.exit(code)`,
  `System.Memory.Units` (sufixos de tamanho).
- **`Console`** — atalho de I/O: `Console.println(x)`, `Console.print(x)`, `Console.printf(...)`
  (exige `import System.IO.Console`).
- **`Memory`** — operações de baixo nível (freestanding): `Memory.read<T>(addr)`,
  `Memory.write<T>(addr, v)`, `Memory.alloc/free/zero/copy`.

---

## 19. Modo freestanding — resumo

O modo freestanding (spec 36) remove keywords que dependem de runtime gerenciado e libera nomes de
tipo bit-counted.

**Removidas (hard keywords proibidas em freestanding):**
```
async  await  catch  delegate  finally  lazy  persistent  release
throw  throws  try  unimport  reimport  using  within
expecting  onFailure  comefrom  abstainfrom  reinstate
onClassUnload  onLastInstanceDestroyed
```
E os qualificadores contextuais de persistents: `carrying`, `leaving`, `releasing`.

**Mantidas e essenciais:** disciplinas de ownership (`move`, `movable`, `unique`, `partitionable`,
`into`), `itself`, `literal`, `region`/`accepts`/`rejects`, `extern`/`cdecl`/`stdcall`/`fastcall`,
`goto`/`label`, bit fields, e — **exclusivos do freestanding** — os nomes bit-counted
(`int8`…`float64`) e o tipo `address` (endereço de memória cru; casts int↔ponteiro).

---

## 20. Contagens

Números segundo o catálogo/spec (design). A implementação atual reserva um subconjunto ligeiramente
diferente (ver seção 17 para as divergências).

| Categoria | Quantidade (spec) |
|-----------|-------------------|
| Keywords principais | 133 |
| Contextual keywords | 13 |
| Tipos primitivos (também keywords) | 20 |
| Modo freestanding | 112–115 keywords |

> **Nota de precisão:** este documento prioriza o que o compilador **reconhece hoje** (lexer +
> parser + semantic) e assinala explicitamente cada divergência com a spec/catálogo. Quando o
> objetivo for o design canônico da linguagem, a spec (`docs/LDP3_specification.md`) é a fonte de
> verdade.

---

*Gerado a partir de `docs/LDP3_specification.md`, `docs/LDP3_keywords.md`, `src/lexer/`,
`src/parser/` e `src/semantic/`.*
