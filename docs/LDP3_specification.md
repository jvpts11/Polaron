# LDP3 — Especificação da Linguagem v1.0

**LDP3** (Linguagem De Programação 3) é uma linguagem de programação de sistemas, orientada a objetos, com gerenciamento manual de memória, compilada para código nativo via LLVM.

**Criador:** João Victor Pereira Tavares
**Status:** Especificação completa, pronta para implementação
**Implementação de referência:** C++ com LLVM, target inicial Windows x86_64
**Versão da spec:** 1.0

---

## Visão geral rápida

LDP3 combina três decisões fundamentais raramente vistas juntas:

1. **OOP obrigatório** como Java/C# — todo código vive em classes dentro de namespaces dentro de bundles dentro de programs. Sem funções soltas.
2. **Gerenciamento manual de memória** como C++ — programador controla alocação, lifetime e liberação explicitamente. Sem garbage collector.
3. **Vocabulário rico de granularidade fina** — features inovadoras que dão controle preciso em eixos onde outras linguagens forçam granularidade grossa.

### Audience alvo

- Desenvolvedores Java/C# frustrados com limitações de GC em domínios performance-críticos
- Desenvolvedores C++ procurando linguagem moderna com manual memory sem o legado tóxico
- Game devs em Unity sofrendo com GC pauses
- Desenvolvedores de game engines, simulações, audio plugins, sistemas embarcados
- Desenvolvedores de kernel e systems programming via modo freestanding

### Não-audience

- Desenvolvedores web típicos (use Go, TypeScript, Python)
- Data science (use Python)
- Scripting rápido (use Python, Ruby)
- Aplicações CRUD enterprise (use Java, C#, Go)

### Features assinatura (únicas ou raras)

- **Persistents** — campos que sobrevivem ao destrutor do objeto, resolvendo granularidade fina de lifetime
- **Regions** — porções nomeadas de memória com type safety (`accepts`/`rejects`)
- **Unimport** — descarregamento dinâmico de classes/namespaces/bundles em runtime
- **Comefrom** — controle de fluxo inverso ao goto com respeito a encapsulamento, primeira linguagem de produção a implementar legitimamente
- **Abstainfrom/Reinstate** — desativação declarativa de blocos de código em runtime, primeira linguagem de produção a implementar legitimamente
- **Bundles** — unidades de compilação independentes com build variants nativos
- **Catalogs** — interfaces para enums que forçam métodos E valores específicos
- **Prefixos universais** — 6 modificadores (cascade, eternal, lazy, comptime, volatile, final) com semântica consistente em qualquer contexto
- **Modo freestanding** — subset para escrever kernels com OOP completo
- **Validação de reimport via challenge-response** — verificação criptográfica de autenticidade sem primitivos crypto built-in
- **Disciplinas de ownership** — `movable`/`unique`/`partitionable` no tipo da classe, com `move` como keyword expressiva integrada com regions e persistents
- **`region` como tipo nativo** — declarações fluidas com `itself.allocate(N kilobytes).accepts({...})`, estado vazio rastreado pelo compilador
- **`literal` suffixes** — sufixos de literal numérico definíveis em stdlib ou usuário (`8 kilobytes`, `500 milliseconds`, `90 degrees`), resolvidos em compile-time com zero overhead
- **`itself` pronome** — auto-referência em initializers de declaração, elimina repetição de nome em chains de construção

### Numbers

- **133 keywords** principais + 13 contextuais
- **3000+ linhas** de especificação
- Compila para nativo via **LLVM**
- Modo freestanding: **115 keywords**, sem runtime managed

---

## 1. Filosofia

A LDP3 é uma linguagem orientada a objetos no estilo Java/C# com gerenciamento manual de memória. A verbosidade é deliberada e tem propósito: eliminar ambiguidade, documentar intenção, e prevenir classes inteiras de bugs.

Princípios:

- **OOP obrigatório.** Toda a lógica de negócio vive dentro de classes, interfaces, records, structs ou enums. Funções top-level não existem; apenas variáveis globais.
- **Verbosidade pela funcionalidade, não pela verbosidade.** Cada elemento explícito tem uma razão de ser (segurança, clareza, controle).
- **Manual memory, sem GC.** O programador controla onde cada coisa vive e quando é liberada. Destrutores são determinísticos.
- **Compile-time agressivo.** Sem promoções implícitas, sem casts implícitos, sem inferência de tipo em campos ou parâmetros.
- **Explícito sempre vence implícito.** `this.` obrigatório, `override` obrigatório, visibilidade obrigatória.
- **Performance é prioridade.** Compila pra nativo via LLVM; pensada como linguagem de propósito geral incluindo jogos.

---

## 2. Estrutura do programa

### 2.1 Hierarquia organizacional

```
program
  └── bundle (unidade de compilação independente)
        └── namespace
              └── tipos (class, interface, record, struct, enum)
```

Cada arquivo declara o program e bundle ao qual pertence no topo. Namespaces podem aparecer em qualquer quantidade no arquivo (em braces). Sintaxe híbrida: declaração com ou sem braces.

**Forma curta (sem braces):**
```ldp3
program GameEngine;
bundle audio;

public namespace mixers {
    public class StereoMixer { /* ... */ }
}

public namespace effects {
    public class Reverb { /* ... */ }
}
```

**Forma longa (com braces):**
```ldp3
program GameEngine {
    public bundle audio {
        public namespace mixers {
            public class StereoMixer { /* ... */ }
        }
    }
}
```

### 2.2 Bundles como unidades de compilação independente

Bundle não é só hierarquia — é **unidade de compilação independente**, distribuída como arquivo binário separado (`.ldb` — LDP3 Bundle). Bundles cumprem dois propósitos centrais:

**1. Build variants.** Diferentes builds do mesmo program incluem conjuntos diferentes de bundles. Permite distribuir versões free/paid, basic/pro, desktop/server, lite/full, sem manutenção de múltiplos source codes.

**2. Compartilhamento cross-program em runtime.** Bundles públicos de um program em execução podem ser acessados por outros programs rodando, via IPC com serialização automática.

### 2.3 Declaração e dependências

Bundle declara dependências explicitamente:

```ldp3
program GameEngine;

public bundle audio version 1.2.0 requires bundle math, bundle io {
    // só pode importar tipos de math e io
}

public bundle ui version 2.0.1 requires bundle audio {
    // pode importar de audio (e transitivamente math, io)
}
```

O compilador valida o grafo de dependências, detecta ciclos, calcula ordem de carregamento. Mudanças incompatíveis na API pública de um bundle exigem version bump (semantic versioning).

### 2.4 Compilação parcial

Programs podem ser compilados sem todos os bundles presentes. Usos de bundle ausente precisam estar embrulhados em `try/catch`:

```ldp3
try {
    AudioEngine engine = new AudioEngine();
    engine.play(soundFile);
} catch (BundleNotLoadedException e) {
    Console.println("Audio não disponível neste build");
}
```

Sem o `try/catch` em torno de código que referencia bundle ausente, o compilador erra: `error: uso de bundle 'audio' não presente neste build; envolva em try/catch ou inclua bundle no build`.

Em runtime, se o bundle não carrega, `BundleNotLoadedException` é lançada no primeiro uso. Se o bundle está presente, o código executa normalmente sem qualquer overhead de runtime.

### 2.5 ABI fingerprint e versionamento

O compilador gera fingerprint da API pública de cada bundle (hash SHA-256 das assinaturas de tipos e métodos públicos). Em runtime, ao carregar bundle, fingerprint é validado contra o esperado pelo program. Mismatch lança `BundleAbiMismatchException`.

Bundle exporta dois artefatos:

- `audio.ldb` — implementação compilada
- `audio.ldh` — header com declarações públicas, usado pra type checking quando bundle não está sendo compilado junto

### 2.6 Modificadores de acesso

Bundles e namespaces aceitam três níveis:

- `public` — acessível por outros programs em runtime via IPC
- `internal` — acessível só dentro do mesmo program, em qualquer bundle
- `private` — acessível só dentro do próprio bundle

A mesma regra vale pra namespaces dentro de um bundle.

### 2.7 Imports

```ldp3
// Import dentro do mesmo bundle:
import mixers.StereoMixer;

// Import entre bundles do mesmo program:
import bundle audio.mixers.StereoMixer;

// Import cross-program (via IPC):
import from program GameEngine bundle audio.mixers.StereoMixer;
```

Wildcard NÃO é permitido em nenhuma forma.

### 2.8 Cross-program access via IPC

Quando program B importa bundle de program A, a comunicação ocorre via IPC com serialização automática:

```ldp3
// Em program B:
import from program GameEngine bundle audio.mixers.StereoMixer;

// Em runtime, B precisa conectar ao A:
ProgramHandle a = Program.connect("GameEngine");
if (a != null) {
    StereoMixer mixer = a.bundle("audio").namespace("mixers").type<StereoMixer>().instantiate();
    mixer.play(soundFile);   // chamada vira IPC serializado
}
```

Acesso cross-program respeita capabilities/resource tokens: program A pode exigir tokens específicos pra permitir B usar seus bundles.

### 2.9 Entry point obrigatório

Todo program executável precisa ter um **entry point** acessível, composto pela seguinte cadeia de declarações públicas:

1. Pelo menos **um bundle `public`**
2. Contendo pelo menos **um namespace `public`**
3. Contendo uma classe `public` chamada `Main`
4. Contendo um método `public static method main(string[] args) returns void` (ou `returns int`)

Exemplo mínimo:

```ldp3
program myApp;

public bundle main {
    public namespace main {
        public class Main {
            public static method main(string[] args) returns void {
                Console.println("Hello, world!");
                return void;
            }
        }
    }
}
```

Regras:

- O compilador erra se nenhuma cadeia válida de entry point é encontrada: `error: program 'myApp' não tem entry point. Crie um bundle público com namespace público contendo 'public class Main' com 'public static method main(...)'`.
- Se o program tem múltiplos métodos `main` em locais diferentes que satisfazem a regra, o compilador erra com ambiguidade. Programador deve indicar o entry point explicitamente via flag de compilação ou tornar todos exceto um não-elegíveis (mudando nome, visibilidade, ou assinatura).
- Bibliotecas (programs sem `main`) compilam normalmente, mas geram apenas artefatos `.ldb` distribuíveis — não geram executável.
- Em **build variants** com compilação parcial, o bundle contendo o entry point é sempre obrigatório no build. Não pode ser deixado de fora.

---

## 3. Tipos primitivos

### 3.1 Inteiros

No **modo normal** os tipos têm nomes "normais" (sem contagem de bits — o programador não precisa
pensar no tamanho exato):

```
byte, short, int, long          // signed:   8, 16, 32, 64 bits
ubyte, ushort, uint, ulong      // unsigned: 8, 16, 32, 64 bits
```

Os nomes com **bit-width explícito** existem **apenas no modo freestanding** (§36), onde o tamanho
da sequência de bits importa de verdade:

```
int8, int16, int32, int64
uint8, uint16, uint32, uint64
```

No modo normal, usar um nome bit-counted é erro de compilação (use o nome normal equivalente:
`byte`=int8, `short`=int16, `int`=int32, `long`=int64, e `ubyte/ushort/uint/ulong` para os unsigned).
`address` é um inteiro do tamanho de um ponteiro (freestanding / baixo nível).

Conversões entre larguras sempre exigem cast explícito (`cast<long>(x)`). Não há promoção numérica implícita.

### 3.2 Ponto flutuante

Modo normal:

```
smallfloat, float, double, quadruple   // 16, 32, 64, 128 bits
```

Os nomes bit-counted `float32`/`float64` existem **apenas no modo freestanding**; no modo normal use
`float` (32 bits) e `double` (64 bits).

### 3.3 Outros primitivos

- `boolean` — `true` ou `false`. Truthy/falsy é permitido em condições.
- `char` — caractere. Aspas simples ou duplas: `'a'` e `"a"` são ambos válidos.
- `void` — ausência de retorno.

### 3.4 Tipos referência built-in

- `String` — classe imutável.
- `string` — tipo de dado mutável.
- `Object` — raiz da hierarquia.

### 3.5 Literais numéricos

```ldp3
int x = 42;
int hex = 0xFF;
int bin = 0b1010;
int milhao = 1_000_000;
long big = 100L;
float pi = 3.14f;
double e = 2.71828;
```

### 3.6 Semântica de overflow

Por padrão, overflow lança exception. Tipos inteiros expõem métodos da stdlib para outros comportamentos:

```ldp3
int a = x.wrappingAdd(y);     // wrap-around C-style
int b = x.saturatingAdd(y);   // satura no MAX/MIN
int c = checked(x + y);       // explicitamente lança (default; keyword mantida)
int d = x.uncheckedAdd(y);    // sem checagem, undefined behavior
```

Todos os tipos inteiros (`int8`-`int64`, `uint8`-`uint64`) têm métodos da stdlib equivalentes: `wrappingAdd`/`wrappingSub`/`wrappingMul`/`wrappingDiv`, `saturatingAdd`/`saturatingSub`/`saturatingMul`, `uncheckedAdd`/`uncheckedSub`/`uncheckedMul`/`uncheckedDiv`.

Apenas `checked` permanece como keyword porque sinaliza retorno ao comportamento default explicitamente em código que tem outras operações não-checked nas proximidades — uso defensivo legítimo.

### 3.7 nullable

Tipos não são nullable por padrão. `nullable T` opta o tipo a poder conter null:

```ldp3
Dog rex = null;            // ERRO de compilação (Dog é não-nullable)
nullable Dog rex = null;   // OK
```

A regra é **só na atribuição**: um `null` (ou um valor `nullable`) não pode fluir pra um alvo não-nullable — variável, campo, parâmetro ou retorno. O programador decide, na declaração, o que pode ser null. Não há análise de fluxo ("checar antes de usar"), narrowing, nem force-unwrap — isso manteria a simplicidade e evita um borrow-checker, que a LDP3 não tem.

```ldp3
nullable Dog rex = maybeDog();
Dog d = rex;               // ERRO: nullable não flui pra não-nullable
nullable Dog r2 = rex;     // OK: nullable -> nullable
```

Um `nullable` permanece nullable (não há conversão pra não-nullable). Como um não-nullable nunca recebe null, derefar um não-nullable é sempre seguro. Derefar um `nullable` é permitido — se o valor for null em runtime, ocorre um **trap determinístico** (sem UB), coerente com o princípio de no-UB da linguagem. Comparar com null (`x == null` / `x != null`) é sempre permitido.

`null` é a keyword pra ausência de valor.

---

## 4. Strings e chars

```ldp3
String imut = "hello";    // classe imutável (S maiúsculo)
string mut = "hello";     // tipo de dado mutável (s minúsculo)
char c1 = 'a';            // aspas simples
char c2 = "a";            // aspas duplas também válidas pra char
```

### 4.1 String interpolation

```ldp3
String msg = $"Hello {name}, você tem {age} anos";
String calc = $"Total: {price * quantity}";
String fmt = $"Pi é {pi:0.00}";
```

Sem o `$` no início, `{}` é literal. O `$` é obrigatório pra ativar interpolação.

---

## 5. Variáveis, escopo e mutabilidade

### 5.1 Imutável por default

```ldp3
int x = 5;             // imutável; reatribuição é erro
mutable int y = 10;    // mutável
y = 20;                // OK
```

### 5.2 Type inference em locais

Inference só é permitida em **variáveis locais** dentro de métodos. Campos, parâmetros, e retornos sempre exigem tipo explícito.

```ldp3
public method process() returns void {
    var dogs = new ArrayList<Dog>() on heap;   // OK em local
    var pair = getPair();                       // OK
}

public class Foo {
    var x = 5;                       // ERRO: campo precisa de tipo
    public method bar(var x) { }     // ERRO: parâmetro precisa de tipo
}
```

### 5.3 Shadowing

Shadowing de variáveis dentro de escopos aninhados é **proibido** pelo compilador.

### 5.4 Variáveis globais

Permitidas no nível de namespace. Funções top-level **não** são permitidas.

```ldp3
public namespace config {
    public mutable int debugLevel = 0;
}
```

---

## 6. Operadores e expressões

### 6.1 Operadores permitidos

Aritméticos: `+ - * / %`
Comparação: `== != < > <= >=`
Lógicos: `&& || !`
Bitwise: `& | ^ ~ << >>`
Atribuição: `=`
Compostos: `+= -= *= /= %= &= |= ^= <<= >>=`
Incremento/decremento: `++ --`
Atribuição encadeada: `a = b = c = 0`
Ternário: `cond ? a : b`

### 6.2 Atribuição não é expressão

```ldp3
if (x = 5) { /* ERRO de compilação */ }
```

A keyword `=` em contexto de condição é erro. Atribuição encadeada é caso especial reconhecido pelo parser.

### 6.3 Casts

Sempre explícitos via `cast<T>(expr)`:
```ldp3
int x = cast<int>(longValue);
Dog d = cast<Dog>(animal);   // exception se animal não é Dog
```

### 6.4 Type checking

```ldp3
if (animal is Dog) {
    Dog d = animal as Dog;     // já validado
    d.bark();
}
nullable Dog d = animal as? Dog;   // null se não for Dog
```

### 6.5 Operator overloading

Qualquer operador pode ser sobrecarregado, inclusive `[]`, `[]=`, atribuição.

```ldp3
public class Vec3 {
    public operator + (Vec3 other) returns Vec3 { /* ... */ }
    public operator * (double scalar) returns Vec3 { /* ... */ }
    public operator == (Vec3 other) returns boolean { /* ... */ }
}

public class Map<K, V> {
    public operator [] (K key) returns V { /* ... */ }
    public operator []= (K key, V value) returns void { /* ... */ }
}
```

### 6.6 Conversion operators

```ldp3
public class Celsius {
    private double temp;

    public operator explicit cast<Fahrenheit>() returns Fahrenheit {
        return new Fahrenheit(this.temp * 9.0 / 5.0 + 32.0);
    }
}

Fahrenheit f = cast<Fahrenheit>(myCelsius);
```

---

## 7. Controle de fluxo

### 7.1 Brackets obrigatórios

Todo bloco — `if`, `else`, `while`, `for`, `do`, `switch`, `match` — exige `{ }`. Um statement por linha; um `;` por linha.

```ldp3
if (x == null) { return; }    // OK
if (x == null) return;        // ERRO de compilação
```

### 7.2 If/else

Condições aceitam truthy/falsy:
```ldp3
if (dog) {  // OK, equivalente a if (dog != null)
    dog.bark();
}
```

### 7.3 Switch (com fall-through)

```ldp3
switch (x) {
    case 1 {
        doThis();
        // fall-through implícito pra próximo case se sem break
    }
    case 2 {
        doThat();
        break;
    }
    default {
        doNothing();
    }
}
```

`default` é **obrigatório**. Brackets em cada `case` são **obrigatórios**.

### 7.4 While e do-while

```ldp3
while (cond) { /* ... */ }
do { /* ... */ } while (cond);
```

### 7.5 For clássico

```ldp3
for (mutable int i = 0; i < 10; i++) { /* ... */ }
```

### 7.6 Foreach

```ldp3
for (Dog d in dogs) { d.bark(); }
for (index i, Dog d in dogs) { /* com índice */ }
```

O tipo iterado precisa implementar `Iterable<T>` (ver seção 9.2).

### 7.7 Ranges

```ldp3
for (int i in 0..100) { }       // 0 inclusive, 100 exclusive
for (int i in 0..=100) { }      // ambos inclusive
for (int i in 0..100 step 2) { }
```

`Range<T>` é tipo first-class:
```ldp3
Range<int> r = 0..100 step 5;
for (int i in r) { }
```

### 7.8 Break e continue

```ldp3
outer: for (int i in 0..10) {
    for (int j in 0..10) {
        if (cond) { break outer; }
        if (other) { continue outer; }
    }
}
```

### 7.9 Goto

`goto` é controle de fluxo direto: salta para label declarado no mesmo método, ou (uso avançado) para um endereço/função em contexto FFI/baixo nível.

> **Escopo intra-method (revisão de design):** a tétrade do caos — `goto`, `comefrom`, `abstainfrom`, `reinstate` — é **intra-method only**. Cada um só referencia labels declarados no **mesmo método**. Cross-method foi removido deliberadamente: action-at-a-distance entre métodos tornaria o fluxo caótico em excesso. A unidade de encapsulamento do controle de fluxo da tétrade é o método, não a classe.

**Escopo:** mesmo método. `goto` salta para um label declarado no mesmo método; não cruza fronteiras de método nem de classe.

**Goto intra-method:**

```ldp3
public method exemplo() returns void {
    label start;
    if (cond) { goto end; }
    // ...
    label end;
    return;
}
```

**Goto para endereços (uso avançado, FFI/baixo nível):**

```ldp3
goto myFunction;     // salta para função externa (treat como ponteiro de função)
goto 0x1000;         // salta para endereço específico (bootloader/kernel/FFI)
```

A forma de endereço é uma transferência de controle crua: o fluxo NÃO retorna (o que segue o `goto` é inalcançável). `myFunction` é uma função `extern`; `0x1000` é um endereço literal. Útil pra saltar pra código carregado (bootloader, entry de kernel).

> **`goto line N` removido:** a forma "salta para a linha N do arquivo" foi removida — ela atravessa fronteiras de método/classe (o action-at-a-distance que a tétrade intra-method elimina), é frágil sob renumeração e é redundante com labels. Use um `label` no ponto-alvo.

**Regras:**

1. **Mesmo método.** `goto` para label não cruza fronteiras de método nem de classe. Tentativa de `goto outroMetodo.label` (ou `goto OutraClasse.metodo.label`) é erro de compilação.

2. **Labels são intra-method.** Apenas labels declarados no mesmo método são alvos válidos de `goto`.

3. **Goto para endereço é unchecked.** Programador é responsável por garantir que o endereço/função é válido. Usado em contexto de FFI ou baixo nível; o controle não retorna.

### 7.10 Comefrom

`comefrom` é controle de fluxo inverso ao `goto`. Onde `goto` declara o salto no ponto de origem, `comefrom` declara a interceptação no ponto de destino. Quando a execução alcança o label referenciado pelo `comefrom`, o fluxo é redirecionado para o ponto onde o `comefrom` está declarado.

LDP3 é a primeira linguagem de produção a implementar `comefrom` como feature legítima, separando-a de seu contexto histórico em INTERCAL. A diferença fundamental: LDP3 trata a feature com seriedade, integra com regras OOP modernas, e impõe disciplina que torna o uso defensável em código de produção.

**Escopo:** mesmo método (intra-method only, ver nota em 7.9). `comefrom` referencia labels declarados no mesmo método; não cruza fronteiras de método nem de classe. Isso elimina action at distance e preserva o método como unidade de encapsulamento do controle de fluxo.

**Formas:**

```ldp3
// Comefrom intra-method
public class Processor {
    public method exemploRetry() returns Data {
        label inicio;
        mutable int tentativas = 0;

        try {
            return chamadaArriscada();
        } catch (Erro e) {
            tentativas++;
            if (tentativas < 3) {
                comefrom inicio;
            }
            throw new MaxTentativas();
        }
    }
}
```

`comefrom` por label: quando execução alcança o label declarado, fluxo é redirecionado para o `comefrom` (declarado no mesmo método). A forma por número de linha (`comefrom line N`) foi removida junto com `goto line N` (mesma fragilidade e action-at-a-distance); use um `label`.

**Use case principal — transaction rollback com manual memory:**

```ldp3
public class BundleConsumer {
    public method usarBundleArriscado() returns void {
        label pontoSeguro;

        try {
            Object* obj = new Object on heap;
            Object* resultado = chamadaArriscadaDoBundle(obj);

            if (resultado == null) {
                throw new BundleError("retornou null");
            }

            processarMais(resultado);
        } catch (BundleError e) {
            log(e);
            comefrom pontoSeguro;
            // execução retoma do início do try block
            // limpeza de memória é responsabilidade do programador
            // (use region wrapping para cleanup automático de allocations)
        }
    }
}
```

Para cleanup automático de memória alocada dentro do escopo, use regions wrapping o try-catch:

```ldp3
public method usarBundleArriscadoComCleanup() returns void {
    label pontoSeguro;
    region<Object> escopoTransacao = new region<Object>();

    try {
        Object* obj = new Object in escopoTransacao;
        // ... operações arriscadas
    } catch (BundleError e) {
        log(e);
        escopoTransacao.clear();  // limpeza explícita da region
        comefrom pontoSeguro;
    }
}
```

I/O e efeitos externos não são revertidos. LDP3 é honesta sobre limites da feature.

**Regras:**

1. **Escopo mesmo método.** `comefrom` só referencia labels declarados no mesmo método. Tentativa de referenciar label em outro método (`comefrom outroMetodo.label`) ou em outra classe é erro de compilação.

2. **Multiple comefroms para mesmo target são erro de compilação.** Apenas um `comefrom` pode referenciar cada label específica. Elimina ambiguidade de ordem.

3. **Forward references permitidas.** `comefrom` pode referenciar label declarado posteriormente.

4. **Lambdas têm escopo separado.** Comefrom dentro de lambda não pode referenciar labels do método enclosing, e vice-versa.

5. **Semântica de disparo:** comefrom dispara **após** o statement labeled executar, antes da próxima instrução. Para linhas, dispara após a linha referenciada completar execução.

6. **State preservation:** variáveis local-scope mantêm valores quando comefrom redireciona (não há reset implícito; cleanup é responsabilidade do programador, tipicamente via regions ou defer).

7. **Detection de loops infinitos:** compiler emite warning quando análise estática detecta ciclos óbvios envolvendo comefrom.

8. **Tooling obrigatório:** IDEs LDP3-compliant devem mostrar visualmente todos os labels que são alvo de comefrom no escopo da classe. LDP3 não é linguagem para plain text editors.

9. **Labels implícitas não são alvo.** Apenas labels declaradas explicitamente pelo programador (`label foo;`) podem ser alvo de comefrom. Labels geradas pelo compiler, runtime ou stdlib não são alvo.

10. **Labels são statement markers.** Sintaxe `label nome;` apenas. Labels não são prefixos de declarações de variáveis ou outros constructs.

**Casos de uso reconhecidos:**

- Retry com state preservation entre tentativas
- Loops com intercepção de iteração condicional
- State machines com restart de transição
- Debug points isolados em debug blocks
- Multi-resource compensation patterns
- Configuration reload sem restart de loop

`comefrom` é feature poderosa restrita ao escopo de método. A combinação de capability ousada com disciplina de design (escopo intra-method, restrições a labels implícitas, tooling obrigatório) torna `comefrom` defensível em LDP3 onde foi sempre joke em outras linguagens.

### 7.11 Abstainfrom e Reinstate

`abstainfrom` desativa temporariamente um label e o código que ele introduz. `reinstate` reativa. Permite controle declarativo sobre quais partes do código estão ativas em runtime sem usar flags booleanas espalhadas.

Como `comefrom`, LDP3 é a primeira linguagem de produção a implementar `abstainfrom` como feature legítima, separada de seu contexto histórico em INTERCAL.

**Escopo:** mesmo método (intra-method only, ver nota em 7.9). `abstainfrom` e `reinstate` só referenciam labels declarados no mesmo método; não cruzam fronteiras de método nem de classe. Mesma regra de escopo que `comefrom` e `goto`.

**Semântica de bloco:**

Quando label é abstained, o código entre essa label e a próxima label (ou fim do método) é pulado durante execução. Reinstate reativa. Como o bloco pulado vai do label até o fim do método, `abstainfrom`/`reinstate` devem ser colocados **antes** do label que controlam (senão ficariam dentro do bloco desativado e não poderiam reativá-lo).

```ldp3
public class HardwareDriver {
    // `enterLowPower`/`exitLowPower` controlam, nas próximas execuções, se o bloco `processing` roda.
    public method handleInterrupt(boolean enterLowPower, boolean exitLowPower) returns void {
        readHardwareState();                            // sempre executa
        if (enterLowPower) { abstainfrom processing; }  // desativa o bloco a partir de agora
        if (exitLowPower)  { reinstate processing; }    // reativa

        label processing;
        processInterrupt();   // pulado enquanto "processing" estiver abstained
        validateState();
    }
}
```

O `abstainfrom`/`reinstate` e o `label` que eles controlam ficam no mesmo método. Para controle por classes externas, a classe expõe métodos públicos que internamente fazem o toggle e o resto da lógica.

**Reference counting para múltiplos sources:**

Múltiplos `abstainfrom` do mesmo label stackam. Label só é reativado quando todos os reinstates correspondentes ocorrem. Implementado via reference counting interno.

```ldp3
public method scenario() returns void {
    abstainfrom processing;  // counter = 1
    abstainfrom processing;  // counter = 2
    reinstate processing;    // counter = 1, ainda abstained
    reinstate processing;    // counter = 0, agora reinstated

    label processing;
    work();                  // roda só quando counter == 0
}
```

Isso evita coordenação manual entre múltiplas razões para desativar o mesmo código.

**Use cases:**

```ldp3
// Feature flag interno: processOrder desativa seu próprio bloco experimental quando um flag manda.
public class OrderProcessor {
    public method processOrder(Order o, boolean experimentOff) returns void {
        if (experimentOff) { abstainfrom experimentalDiscount; }
        label experimentalDiscount;
        applyExperimentalDiscount(o);
        finalize(o);
    }
}
```

O `abstainfrom`/`reinstate` e o label vivem no mesmo método. Classes externas influenciam o comportamento via parâmetros ou estado que o método consulta antes do label.

**Regras:**

1. **Escopo mesmo método.** `abstainfrom` e `reinstate` só funcionam em labels do mesmo método. Tentativa de referenciar label de outro método (`abstainfrom outroMetodo.label`) ou de outra classe é erro de compilação.

2. **Reference counting.** Múltiplos abstainfroms stackam. Label ativo apenas quando counter == 0.

3. **Estado per-execution.** Estado de abstain não persiste entre executions do programa. Programa inicia com tudo reinstated.

4. **Bloco implícito.** Abstainfrom desativa código entre label alvo e próxima label (ou fim do método).

5. **Execuções in-flight continuam.** Se thread está executando código abstained quando abstainfrom é chamado, continua. Apenas próximas execuções pulam o bloco.

6. **Labels implícitas não são alvo.** Apenas labels declaradas explicitamente pelo programador podem ser alvo. Garantia de segurança crítica.

7. **Labels são statement markers.** Sintaxe `label nome;` apenas. Não há keyword `abstainable` separada — qualquer label pode ser alvo de abstainfrom dentro do mesmo método.

8. **Reinstate idempotente.** Reinstate em label já reinstated (counter == 0) é warning, não erro. Sem efeito.

9. **Tooling obrigatório.** IDE deve mostrar visualmente labels que podem ser abstained, e idealmente seu estado em runtime durante debug.

**Restrições de segurança:**

`abstainfrom` é proibido nos seguintes alvos. Tentativa resulta em erro de compilação:

- Labels implícitas (geradas pelo compiler, runtime, ou stdlib)
- Imports e unimports
- Validation de reimport (challenge-response)
- Type system checks (casts, generics, conversions)
- Memory safety primitives (bounds checks gerados pelo compiler)
- Persistents lifecycle (creation, reincarnation, destruction)
- Regions lifecycle (creation, deletion, type acceptance)
- Cascade operations durante propagation
- Constructors e destructors
- Catalog enforcement em enums
- Contract checks (requires, ensures, invariant)

Essas restrições, combinadas com escopo intra-method, eliminam vetores de ataque onde código malicioso poderia desativar mecanismos de segurança ou correctness da linguagem.

**Threading:**

Em contextos concorrentes, `abstainfrom` afeta apenas execuções que **chegam** no label após o abstainfrom ser registrado. Execuções in-flight continuam normalmente. O reference counter é atômico (incremento/decremento com ordenação sequencialmente consistente), que provê o memory barrier necessário.

**Disponível em modo freestanding:**

A tétrade do caso inteira (`goto`, `comefrom`, `abstainfrom`, `reinstate`) está disponível em modo freestanding. Nenhuma delas depende do runtime gerenciado: `goto`/`comefrom` são branches resolvidos em compile-time, e `abstainfrom`/`reinstate` são um `int` global (o reference counter) com load/add/store atômicos — tudo compila para instruções bare-metal, sem alocador, syscall ou lib de runtime. É justamente em sistemas embedded e kernel que `abstainfrom` mais brilha (power management, feature flags, conditional debug instrumentation), então mantê-la em freestanding é coerente com seus casos de uso principais.

**Casos de uso reconhecidos:**

- Power management em sistemas embedded e kernel (interno à classe driver)
- Feature flags e A/B testing em produção (interno à classe que possui a feature)
- Maintenance modes
- Circuit breakers para serviços externos
- Conditional debug instrumentation
- Hot-path optimization (desativar caminhos não usados em runtime)

`abstainfrom` oferece capability declarativa para desativar/reativar código em runtime, restrita ao escopo de método. Diferente de boolean flag + if check que é imperativo, abstainfrom é declarativo e composable via reference counting natural. Classes externas influenciam o comportamento via parâmetros/estado que o método consulta antes do label, preservando encapsulamento.

---

## 8. Classes

### 8.1 Estrutura

```ldp3
public class Dog extends Animal implements Barkable {
    private String name;
    private int age;
    private persistent string skeleton = "DogSkeleton";

    public constructor Dog(String dogName, int dogAge) {
        this.name = dogName;
        this.age = dogAge;
    }

    public override method bark() returns void {
        Console.println(this.name);
    }

    public destructor ~Dog() returns void {
        // libera recursos
    }
}
```

### 8.2 Regras

- Visibilidade explícita sempre. Sem default package-private silencioso.
- `this.` é **obrigatório** em qualquer acesso a membros.
- `override` é **obrigatório** quando sobrescreve método herdado.
- `super()` é **implícito**; pode ser chamado explicitamente se quiser passar parâmetros.
- Nome único por método; **sem overloading** de método.
- Campos podem ser inicializados na declaração ou no constructor.
- `return` é opcional em métodos void; obrigatório em métodos não-void.
- `constructor`, `destructor` são keywords; nome do tipo segue.
- **Atribuição é cópia.** `Thing t2 = t1` cria cópia profunda independente. Pra compartilhar instância, usa ponteiro (`Thing*`) ou referência (`Thing&`) explícitos.

### 8.3 Modificadores de classe

- `abstract` — não pode ser instanciada; pode ter métodos `abstract`.
- `sealed permits A, B, C` — apenas as classes listadas podem estender.
- `final` (em método) — não pode ser sobrescrito.
- `partial` — declaração da classe pode ser dividida entre múltiplos arquivos.

```ldp3
public sealed class Shape permits Circle, Square, Triangle { }
public abstract class Animal { public abstract method speak() returns void; }
public partial class Dog { /* parte 1 */ }
public partial class Dog { /* parte 2, outro arquivo */ }
```

### 8.4 Properties

Estilo C#:
```ldp3
public class Account {
    private int balance {
        get { return this.balance; }
        set {
            if (value < 0) { throw new InvalidValueException(); }
            this.balance = value;
        }
    }

    public init String id { get; init; }   // init-only: setável só no constructor
}
```

### 8.5 Static

```ldp3
public class Counter {
    public static int total = 0;
    public static method increment() returns void {
        Counter.total = Counter.total + 1;
    }
}
```

---

## 9. Interfaces

### 9.1 Estrutura básica

```ldp3
public interface Barkable {
    method bark() returns void;
}

public class Dog implements Barkable {
    public override method bark() returns void { /* ... */ }
}
```

Interfaces podem ter:
- Métodos abstratos (padrão).
- Métodos default (com implementação).
- Constantes.

### 9.2 Iterable / Iterator

Pra suporte a `foreach`:
```ldp3
public interface Iterable<T> {
    method iterator() returns Iterator<T>;
}

public interface Iterator<T> {
    method hasNext() returns boolean;
    method next() returns T;
}
```

---

## 10. Records

```ldp3
public record DogStats(int age, int weight, String breed) {
}

public record Point3D(double x, double y, double z) implements Comparable<Point3D> {
    public method distanceTo(Point3D other) returns double {
        // ...
    }
}
```

Regras:
- Sempre imutáveis. `mutable` é rejeitado.
- Auto-geram `equals`, `hashCode`, `toString` baseado nos parâmetros.
- `final` implicitamente; sem herança.
- Podem implementar interfaces.
- Podem ter métodos e constantes — **não** podem ter campos extras além dos parâmetros do construtor primário.
- **Não** podem ter `persistent`.

---

## 11. Structs

Objetos de valor mutáveis, tamanho fixo conhecido em compile-time.

```ldp3
public struct Vec3 {
    public mutable float x;
    public mutable float y;
    public mutable float z;

    public constructor Vec3(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
```

Comparação com record e class:

| | record | struct | class |
|--|--|--|--|
| Atribuição | cópia | cópia | cópia |
| Mutável | não | sim | sim |
| Herança | proibida | proibida | sim |
| Implementa interface | sim | sim | sim |
| Auto equals/hashCode | sim | não | não |
| Tamanho fixo conhecido | sim | sim | não |
| Bit fields | não | sim | não |
| Pode ter persistent | não | só campos | sim (campos, classes/structs internas) |

**Atribuição em LDP3 é sempre por cópia**, incluindo classes. Para semântica de referência (compartilhar instância entre variáveis), usa ponteiro (`Thing*`) ou referência (`Thing&`) explícitos.

**Passagem de parâmetro segue a mesma regra: por valor.** Um parâmetro de tipo classe (`method f(Thing t)`)
recebe uma **cópia profunda independente**, exatamente como a atribuição — mutar o parâmetro dentro do método
**não** altera o objeto do chamador. Para compartilhar e mutar a instância do chamador (ou para evitar o custo
da cópia, ex.: passar uma coleção grande sem duplicá-la), declara o parâmetro como referência (`Thing&`) ou
ponteiro (`Thing*`). Interfaces e classes abstratas são sempre por referência (o valor é sempre uma subclasse
concreta de tamanho não conhecido estaticamente). String, sendo imutável, é compartilhada livremente.

### 11.1 Bit fields em struct

```ldp3
public struct PacketHeader {
    public mutable uint8 version : 4;
    public mutable uint8 type : 4;
    public mutable uint16 length;
    public mutable uint32 flags : 24;
    public mutable uint8 priority : 8;
}
```

---

## 12. Enums e catalogs

### 12.1 Enum simples (int-style degenerado)

```ldp3
public enum Color {
    RED,
    GREEN,
    BLUE
}
```

### 12.2 Enum Java-style com campos e métodos

```ldp3
public enum Planet {
    EARTH(5.972e24, 6.371e6),
    MARS(6.39e23, 3.389e6);

    private final double mass;
    private final double radius;

    public constructor Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }

    public method surfaceGravity() returns double {
        return G * this.mass / (this.radius * this.radius);
    }
}
```

### 12.3 Catalog — interface pra enums

Catalogs forçam tanto a *shape* (métodos) quanto valores específicos que o enum deve conter.

```ldp3
public catalog TipoMotor {
    combustao,
    h2,
    eletrico

    void getCombustao() returns (TipoMotor a, TipoMotor b, TipoMotor c);
}
```

- O catalog declara valores que o enum implementador tem que conter.
- Declara métodos que o enum implementador tem que implementar.
- Catalogs podem ter implementação default.
- Catalogs podem estender outros catalogs.
- Um enum pode estender múltiplos catalogs.

### 12.4 Implementação de catalog em enum (`byCatalog`)

Quando um enum implementa um catalog, os valores do catalog são fornecidos via bloco `byCatalog`:

```ldp3
public enum Motor extends TipoMotor {
    v8,
    v12,
    doisPistoes

    byCatalog {
        combustao,
        h2,
        eletrico
    }

    TipoMotor getCombustao() returns (TipoMotor a, TipoMotor b, TipoMotor c) {
        return v8, v12, doisPistoes;
        /* sintaxe alternativa equivalente:
        return {
            v8,
            v12,
            doisPistoes
        }
        */
    }
}
```

- O bloco `byCatalog` lista os valores requeridos pelo catalog que o enum satisfaz.
- Métodos requeridos pelo catalog são implementados como métodos normais do enum.

### 12.5 Métodos built-in de enums

Todos os enums têm métodos auto-gerados:

- `EnumType.random()` retorna um valor aleatório do enum.
- `EnumType.values()` retorna `EnumType[]` com todos os valores em ordem de declaração.
- `EnumType.count()` retorna `int` com a quantidade de valores.
- `EnumType.parse(string s)` retorna `Option<EnumType>` baseado no nome.

---

## 13. Unions

Estilo C, útil com manual memory management:

```ldp3
public union Value {
    int32 asInt;
    float32 asFloat;
    int8[4] asBytes;
}
```

Todos os campos compartilham o mesmo espaço de memória.

---

## 14. Annotations

### 14.1 Sintaxe

- **Built-in** da linguagem: `@Name` (com arroba)
- **Definidas pelo usuário**: `[Name]` (com colchetes)

### 14.2 Built-in (keywords)

Conceitos da linguagem são keywords, não annotations:
- `override`, `final`, `abstract`, `sealed`, `partial`
- `transient`, `serializable`
- `static`
- `mutable`
- `persistent`
- `lazy`
- `volatile`
- `deprecated`

### 14.3 Annotations customizadas

```ldp3
public annotation MaxLength {
    int value;
    String errorMessage default "Excedeu o tamanho máximo";
}

[MaxLength(value: 100)]
public class UserName { }
```

Annotations customizadas são acessíveis via reflection.

### 14.4 Annotations em compile-time

```ldp3
[CompileTimeProcessor]
public annotation Derive {
    Class[] traits;
}

[Derive(traits: [Equals, HashCode, ToString])]
public class Person { }
```

`[CompileTimeProcessor]` marca a annotation pra ser processada durante a compilação, podendo gerar código auxiliar.

---

## 15. Generics

### 15.1 Sintaxe

```ldp3
public class Box<T> {
    private T content;
    public method get() returns T { return this.content; }
}

public method swap<T>(T a, T b) returns (T, T) {
    return (b, a);
}
```

### 15.2 Constraints

```ldp3
public class Cache<T extends Serializable> { }
public class Sorted<T implements Comparable<T>> { }
public method clamp<T extends Numeric>(T value, T min, T max) returns T { }
```

### 15.3 Variance (declaration-site, estilo C#)

```ldp3
public interface Producer<out T> {    // covariante
    method produce() returns T;
}

public interface Consumer<in T> {     // contravariante
    method consume(T item) returns void;
}

public interface Box<T> { }           // invariante (default)
```

---

## 16. Pattern matching

### 16.1 Match statement

```ldp3
match (s) {
    case Circle(double r) {
        return PI * r * r;
    }
    case Square(double side) {
        return side * side;
    }
    case Triangle(double b, double h) {
        return b * h / 2.0;
    }
}
```

Quando o tipo é `sealed`, exaustividade é **obrigatória**; sem `default`. Em outros casos `default` é exigido.

### 16.2 Match como expressão

```ldp3
double area = match (shape) {
    case Circle(double r) -> PI * r * r;
    case Square(double s) -> s * s;
    case Triangle(double b, double h) -> b * h / 2.0;
};
```

`->` pra single-expression; `{ }` pra blocos multi-linha.

---

## 17. Memória

### 17.1 Alocação básica

```ldp3
int x = new int on stack;
int* y = new int on heap;
Dog rex = new Dog("Rex", 5) on stack;
Dog* heavyDog = new Dog("Big", 10) on heap;

delete heavyDog;             // omite local quando inequívoco
delete heavyDog from heap;   // explícito
```

Stack é liberada automaticamente no fim do escopo. Heap exige `delete` explícito.

**A localização é opcional — sem cerimônia no caso comum.** Você não é obrigado a
escrever `on stack` / `on heap`. Quando omitida, o compilador escolhe o default
sensato: **objetos vão pra stack** (RAII — liberados automaticamente, sem `delete`),
e **arrays e coleções dinâmicas vão pra heap** (são naturalmente dinâmicos).
Escreva a localização explícita só quando quiser forçar algo diferente do default
(ou quando o tipo ponteiro / o escopo de vida exigir heap).

```ldp3
Dog rex = new Dog("Rex", 5);            // sem cerimônia -> stack (RAII)
Dog* big = new Dog("Big", 10) on heap;  // o "canhão": heap manual, exige delete
```

Princípio de design: no caso comum você escreve código direto, sem ritual; quando
precisa do controle fino de memória, ele está lá pra disparar.

### 17.2 Regiões nomeadas: o tipo `region`

`region` é tipo nativo da linguagem, equivalente a `int` ou `boolean` no sentido de ser primitivo. Variáveis do tipo `region` representam porções de memória com regras de aceitação de tipos.

Regions podem ser declaradas como:

- **Variáveis locais** em métodos (liberadas no fim do escopo)
- **Campos de classe** (com modificador de acesso; lifetime do objeto)
- **Variáveis em namespace** (lifetime do program)

**Sintaxe de declaração e alocação:**

A forma canônica usa `itself` como auto-referência à variável sendo declarada, seguida de method chaining para configurar a region:

```ldp3
import System.Memory.Units.*;   // bytes, kilobytes, megabytes, gigabytes, terabytes, exabytes

region A = itself.allocate(1024 bytes);
region B = itself.allocate(64 kilobytes);
region C = itself.allocate(2 megabytes);
region D = itself.allocate(sizeof(Dog) * 100 bytes);
```

Formas equivalentes (ver seção sobre `itself`):

```ldp3
// Forma 1: com itself (mais legível)
region small = itself.allocate(8 kilobytes);

// Forma 2: nome explícito (idêntica em semântica)
region small = small.allocate(8 kilobytes);

// Forma 3: declaração separada da inicialização
region small;
small = itself.allocate(8 kilobytes);
```

Exemplo como campo de classe:

```ldp3
public class Main {
    public region parking = itself.allocate(1024 bytes);
    private region anotherParking = itself.allocate(1024 bytes);
    protected region yetAnotherParking = itself.at(0x100, 1024 bytes);
}
```

Dentro de `sizeof()` pode ir qualquer expressão.

**Estado vazio:**

Uma `region` declarada sem inicialização (`region small;`) existe em **estado vazio** — sem backing memory. Apenas duas operações são permitidas em region vazia:

1. Alocação via `.allocate(...)` ou `.at(...)`
2. Atribuição com cópia de outra region (`small = otherRegion;`)

Qualquer outra operação (alocar objeto dentro dela, `accepts`, `rejects`, etc.) em region vazia é erro de compilação. O compilador rastreia estado vazio via flow analysis. Após primeira operação válida, a region sai do estado vazio.

### 17.3 Accepts e rejects

`accepts` e `rejects` são features de primeiro nível da linguagem, invocadas via sintaxe de método encadeada após `.allocate()` ou `.at()`. Retornam a própria region para permitir chaining contínuo.

```ldp3
region E = itself.allocate(4096 bytes).accepts({Dog, Cat, Animal.Cnidarians});
region F = itself.allocate(8192 bytes).rejects({String, ArrayList<?>});
region G = itself.allocate(2 kilobytes).accepts({Dog}).rejects({Cat});
```

Tipos podem usar notação dot pra denotar família de subclasses (`Animal.Cnidarians`).

Violações geram **ambos** erro estático (quando tipo conhecido em compile-time) e exception em runtime.

Embora a sintaxe seja de método (`.accepts(...)`), `accepts` e `rejects` continuam sendo keywords da linguagem — o compilador valida tipos contra elas no nível de sistema de tipos, não apenas em runtime. A escolha de sintaxe é apenas estética e consistência com o resto da linguagem orientada a objetos.

### 17.4 Endereçamento direto

```ldp3
region H = itself.at(0x1000, 4096 bytes);

region I = itself.atMultiple({
    0x1000 accepts {Dog},
    0x2000 accepts {Cat},
    0x3000 rejects {String}
});
```

`region.at(address, size)` cria region em endereço físico específico. Combinável com `.accepts()`/`.rejects()`:

```ldp3
region mmio = itself.at(0xB8000, 4000 bytes).accepts({VGAChar});
```

### 17.5 Uso de região

```ldp3
Dog* rex = new Dog("Rex") in region A;
delete rex from region A;
```

Múltiplos `delete` podem ser combinados:

```ldp3
delete c, b;
delete a of region parking, b of region anotherParking, c of region yetAnotherParking;
```

### 17.6 Disambiguação com `of region`

Quando há múltiplas variáveis de mesmo nome em regions diferentes, o sufixo `of region X` desambigua:

```ldp3
Car a = new Car(...) in region parking;
Car a = new Car(...) in region anotherParking;

delete a of region parking;
Car d = a of region anotherParking;   // d é cópia
```

A sintaxe é geral: aplicável a expressões de acesso a campos, atribuição, delete, release.

### 17.7 Liberação

Regiões declaradas dentro de um escopo léxico são liberadas automaticamente no fim do bloco (rodando destrutores). Liberação manual:

```ldp3
release region A;
```

Quando uma região é liberada, todos os objetos dentro dela são destruídos (destrutores rodam).

### 17.8 Tipo `address` e API `Memory`

`address` é tipo primitivo que representa um endereço físico de memória. Usado pra interop de baixo nível e como escape hatch pra manipulação fora do escopo de declaração.

```ldp3
address endereco = Memory.getMemory(a.chassi of region anotherParking);
release a at address endereco;
```

`Memory` é módulo da stdlib com APIs:

- `Memory.getMemory(expr)` retorna `address` do alvo em memória
- `Memory.alloc(int bytes)` retorna `address` de bloco alocado
- `Memory.free(address)` libera bloco
- `Memory.read<T>(address)` retorna valor T no endereço
- `Memory.write<T>(address, T value)` escreve valor

Para operações em endereço específico fora de declarações de region (como `delete X at address Y` ou `release X at address Y`), `at` permanece reconhecido pelo compilador no contexto dessas operações low-level. Em declarações de region a sintaxe canônica é `region.at(addr, size)`.

---

### 17.9 `itself` — pronome de auto-referência

`itself` é pronome que, dentro de um *initializer de declaração*, refere-se à variável sendo declarada na mesma linha. Permite escrever cadeias de inicialização sem repetir o nome.

```ldp3
region small = itself.allocate(8 kilobytes).accepts({Particle});
// equivalente a:
region small = small.allocate(8 kilobytes).accepts({Particle});
```

As duas formas são semanticamente idênticas. `itself` é apenas estética — deixa explícito que o destino é a variável sendo declarada, sem precisar repetir o nome (útil quando o nome é longo ou aparece várias vezes).

**Escopo de `itself`:**

`itself` é válido apenas em dois contextos:

1. **Initializer de declaração de variável local:**
   ```ldp3
   public method exemplo() returns void {
       region cache = itself.allocate(64 megabytes);
       Dog rex = itself.fromBreed(Breed.labrador);
   }
   ```

2. **Initializer de declaração de campo de classe:**
   ```ldp3
   public class GameWorld {
       private region world = itself.allocate(256 megabytes).accepts({Entity});
       private HashMap<String, Player> players = itself.empty();
   }
   ```

Fora desses contextos, `itself` é erro de compilação. Especificamente, **não é válido** em:

- Corpo de método (use `this` para referência à instância)
- Argumentos de função
- Expressões condicionais ou ternárias soltas
- Lambda bodies

**Identidade local à linha:**

Cada `itself` é local à sua linha de declaração. Linhas adjacentes têm `itself` diferentes:

```ldp3
Dog rex = itself.fromBreed(Breed.labrador);    // itself = rex
Connection conn = itself.connect("localhost"); // itself = conn (não há ambiguidade)
HashMap<String, int> cache = itself.empty();   // itself = cache
```

Não há "escopo de itself" persistindo entre linhas — cada declaração tem seu próprio referente claro.

**Tipos compatíveis com `itself`:**

Para `T x = itself.method()` funcionar, o tipo `T` precisa ter um *estado vazio bem-definido* para que a variável exista antes do initializer completar. `region` tem isso nativamente (estado vazio sem backing memory; ver seção 17.2). Outras classes opt-in por declaração explícita; mecanismo formal de opt-in está documentado em "Issues abertas" (seção 40) para resolução em versão futura.

Para tipos sem estado vazio, `itself` em initializer ainda funciona se for usado puramente como *factory call* — `itself.method()` é interpretado como chamada static method do tipo, equivalente a `T.method()`. Nesse modo, `itself` é shorthand para evitar nomear o tipo.

```ldp3
Dog rex = itself.fromBreed(Breed.labrador);
// equivalente a:
Dog rex = Dog.fromBreed(Breed.labrador);
```

### 17.10 `literal` — sufixos de literal numérico

`literal` declara que uma função pode ser usada como sufixo após literais numéricos. Permite criar DSLs de unidades sem custo de runtime e sem precisar de feature dedicada por unidade na linguagem.

```ldp3
public comptime literal kilobytes(int x) returns ByteSize {
    return new ByteSize(x * 1024);
}

// Uso:
region cache = itself.allocate(64 kilobytes);
// compilador expande para: itself.allocate(kilobytes(64))
// que é comptime, então resolvido em compile-time
```

**Regras:**

1. **Deve ser `comptime`.** Se a expansão não pode ser feita em compile-time, a feature perde sentido (literal suffix vira chamada de função em runtime). Compilador exige `comptime literal` juntos.

2. **Deve ter exatamente um parâmetro.** Um sufixo de literal recebe apenas o literal. Mais ou menos parâmetros é erro de compilação.

3. **Tipo do parâmetro determina onde o sufixo aplica:**
   - `literal X(int x)` → aplica a literais inteiros (`int8`-`int64` ou `uint8`-`uint64`)
   - `literal X(double x)` → aplica a literais decimais (`float32`, `float64`)
   - Tipos numéricos específicos restringem ainda mais

4. **Tipo de retorno é livre.** Pode retornar primitivo, struct, classe — o tipo da expressão `8 kilobytes` é o tipo de retorno da função `kilobytes`.

5. **Função precisa estar no escopo via import.** Sem import, sem sufixo. Isso evita poluição do escopo global.

6. **Overloading permitido.** `literal seconds(int x)` e `literal seconds(double x)` podem coexistir; compilador escolhe baseado no tipo do literal.

**Exemplos de uso:**

Unidades de tempo:

```ldp3
public comptime literal nanoseconds(int x) returns Duration { return new Duration(x); }
public comptime literal milliseconds(int x) returns Duration { return new Duration(x * 1000 * 1000); }
public comptime literal seconds(int x) returns Duration { return new Duration(cast<int64>(x) * 1000 * 1000 * 1000); }

Duration timeout = 500 milliseconds;
defer within 100 milliseconds { /* ... */ }
```

Unidades de ângulo:

```ldp3
public comptime literal radians(double x) returns Angle { return new Angle(x); }
public comptime literal degrees(double x) returns Angle { return new Angle(x * 3.14159265358979 / 180.0); }

Angle a = 90 degrees;
```

**Stdlib v1.0 fornece:**

`System.Memory.Units` com seis sufixos retornando `ByteSize`:

```ldp3
namespace System.Memory.Units {
    public comptime literal bytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x)); }
    public comptime literal kilobytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L); }
    public comptime literal megabytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L * 1024L); }
    public comptime literal gigabytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L * 1024L * 1024L); }
    public comptime literal terabytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L * 1024L * 1024L * 1024L); }
    public comptime literal exabytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L * 1024L * 1024L * 1024L * 1024L * 1024L); }
}

public struct ByteSize {
    public final int64 bytes;
    public constructor ByteSize(int64 bytes) { this.bytes = bytes; }
}
```

`ByteSize` é struct distinta — `1 bytes` (= `ByteSize(1)`) é tipo diferente de `int` literal `1`. Isso impede misturar acidentalmente bytes com outras unidades semanticamente diferentes, e força APIs de memória (como `region.allocate(...)`) a aceitarem exatamente `ByteSize`, não `int` cru.

**Modo freestanding:** `literal` é mantida em modo freestanding (compile-time only). Stdlib de freestanding fornece tipos de unidade próprios ou kernel devs definem os seus.

---

### 17.11 Sabores de região (estratégia de recuperação)

Uma região tem um **sabor** (*flavor*): a estratégia com que ela recupera memória. Todo sabor é uma
palavra-chave **contextual** — reconhecida só imediatamente antes de `region`, e identificador normal em
qualquer outro lugar. `region` puro é `bump` (o padrão histórico, byte-idêntico ao que sempre foi).

```ldp3
region R           = itself.allocate(64 kilobytes);                       // bump (padrão)
bump region R      = itself.allocate(64 kilobytes);                       // bump explícito
pool region R      = itself.allocate(64 kilobytes);                       // free-list, recupera por objeto
stack region R     = itself.allocate(64 kilobytes);                       // LIFO: mark/rollback
fixedslot region R = itself.allocate(64 kilobytes).accepts({Particle});  // pool de um só tamanho
ring region R      = itself.allocate(64 kilobytes).accepts({LogLine});   // circular, descarta o mais antigo
growable pool region R = itself.allocate(64 kilobytes);                   // encadeia um novo bloco ao encher
```

Gramática: `region-decl := [ 'growable' ] [ flavor ] 'region' NOME [ '=' region-init ] ';'` onde
`flavor := 'bump' | 'pool' | 'stack' | 'fixedslot' | 'ring'`. Prefixos universais precedem tudo
(`public eternal lazy growable pool region cache = …`). O sabor vale também em **campo de classe**
(`private pool region den;`).

**Semântica de cada sabor:**

- **bump** — linear/monotônico. Aloca avançando um cursor; não libera objeto individual; `release`/`.clear()`
  libera tudo de uma vez. Alocação mais rápida (caminho inline, byte-idêntico). Uso: alocar-muitos-liberar-junto.
- **pool** — free-list segregada por classe de tamanho. `new … in R` reusa um slot livre ou avança um novo;
  `delete … from R` / `extract` devolvem o slot; `new` posterior reusa. Ponteiros nunca movem. Uso: churn de
  tamanhos variados (terminais, entidades).
- **stack** — bump mais `mark`/`rollback` (LIFO). `checkpoint m = mark of region R;` grava o cursor;
  `rollback region R to m;` roda os destrutores de tudo alocado após `m` (do mais novo pro mais velho) e
  rebobina o cursor. Uso: escopos aninhados, checkpoints por-frame/por-request.
- **fixedslot** — pool de um único tamanho, de um **único tipo aceito** (`accepts({T})` é obrigatório).
  Todos os slots idênticos → alocação/liberação O(1), zero fragmentação. Uso: churn homogêneo (um pool de `Particle`).
- **ring** — buffer circular de capacidade fixa; ao encher, uma nova alocação **sobrescreve a mais antiga**
  (rodando o destrutor dela antes). Sem `delete` individual (auto-descarta). Uso: histórico/streaming limitado.

**Crescimento (`growable`):** por padrão a região é fixa e uma região cheia **trapa** (sem UB) com um
diagnóstico claro. `growable` encadeia um novo bloco no overflow (lista ligada de blocos; alocação
amortizada O(1); `release` libera a cadeia inteira). Compõe com bump/pool/fixedslot; é **contraditória**
com `ring` (limitado por definição) e com `at address` (memória externa não cresce).

**Operações:**

```ldp3
Terminal* t = extract terminals[i] from region R;   // relocar pro heap, destrackear, recuperar o slot
checkpoint m = mark of region R;                     // só stack: grava o cursor
rollback region R to m;                              // só stack: destrói + rebobina
```

`extract` é um operador prefixo sobre um lvalue, **só do lado direito**: relocar o objeto pra uma alocação
heap nova, transferir a posse ao chamador (que deve `delete` ou ligar a um valor/`T*`), tirá-lo do
rastreamento da região (o `release` não o destrói de novo) e marcar a origem como **movida**
(use-after-extract é erro de compilação, como `move`). Em pool/fixedslot o slot vago é recuperado; em bump
ele fica morto até o `release`. `checkpoint` é o único **tipo embutido novo** (um cursor opaco; copiável, sem
destrutor).

**Introspecção** — métodos comuns, sem palavras-chave: `R.used()`, `R.capacity()`, `R.remaining()`,
`R.contains(ptr)`, `R.grow(N bytes)`.

**Diagnósticos** (todos ricos, roteados por `diag::classify`, com *why*/*fix*/*prevent*):

| código | condição |
|---|---|
| LDP3-1710 | dois sabores numa região (`pool stack region`) |
| LDP3-1711 | `fixedslot`/`ring` sem `.accepts({T})` de exatamente um tipo |
| LDP3-1712 | `growable` com `ring` / `at address` / `stack` |
| LDP3-1713 | `mark`/`rollback` numa região não-`stack` |
| LDP3-1714 | `rollback` com um checkpoint de outra região |
| LDP3-1715 | `delete … from region` numa região `ring` (auto-descarta) |
| LDP3-1717 | uso de uma variável depois de `extract` |
| LDP3-1719 | modificador de sabor numa declaração que não é região |
| LDP3-1720 | resultado de `extract` não ligado (statement solto) |

(LDP3-1718 — extrair um objeto cujo campo vive na mesma região — está reservado; a checagem precisa de
análise de fluxo de região e chega numa versão futura.)

**Compatibilidade:** `region` puro é `bump`, byte-idêntico ao de antes; as palavras novas são contextuais,
então nenhum programa existente muda de significado.

---

## 18. Persistents

`persistent` é um modificador que vive **dentro de classes**: pode marcar campos, variáveis internas, classes internas, structs internas. Marca que o elemento desacopla seu tempo de vida do tempo de vida da instância que o contém: sobrevive ao destrutor do objeto-pai e pode reataca quando uma variável "equivalente" é criada de novo.

### 18.1 Identidade do persistent

A identidade de um persistent é amarrada à **tripla**:

```
(escopo léxico, nome da variável, region)
```

- **Escopo léxico**: a função, método, ou bloco onde a variável foi declarada. Variáveis com mesmo nome em escopos diferentes têm persistents independentes.
- **Nome da variável**: o identificador léxico no código fonte.
- **Region**: a porção de memória onde o objeto foi alocado (heap implícita, stack implícita, ou region nomeada).

Duas variáveis que diferem em qualquer uma das três coordenadas têm persistents **independentes**.

### 18.2 Reattach automático

Quando uma variável com mesma tripla é recriada (após delete da anterior), os persistents reatacam automaticamente: o novo objeto vê os valores que estavam vivos antes.

```ldp3
Car c = new Car(Marca.chevrolet, Motor.v8, TipoChassi.aco) on heap;
delete c;
Car c = new Car(Marca.chevrolet, Motor.v8) on heap;  // reataca; chassi vem do persistent anterior
```

Quando a tripla difere, persistents são independentes:

```ldp3
Car a = new Car(...) in region parking;
Car a = new Car(...) in region anotherParking;  // OK; region diferente -> persistent independente
```

### 18.3 Disambiguação com `of region`

Quando múltiplas variáveis de mesmo nome existem em escopos compatíveis mas regions diferentes, o sufixo `of region X` desambigua tanto a referência ao objeto quanto a referência aos persistents:

```ldp3
Car a = new Car(...) in region parking;
Car a = new Car(...) in region anotherParking;

Console.printf($"chassi de parking: {a.chassi of region parking}");
Console.printf($"chassi de anotherParking: {a.chassi of region anotherParking}");

a.chassi of region parking = TipoChassi.ferro;   // modifica persistent específico
```

Atribuição entre persistents de regions diferentes via `of region` é **proibida**:

```ldp3
a of region parking = a of region anotherParking;   // ERRO
```

Cópia por valor para nova variável é permitida:

```ldp3
Car d = a of region parking;   // d é cópia independente
```

### 18.4 Acesso pós-destrutor

Persistents sobrevivem ao `delete` do objeto-pai e continuam acessíveis via path qualificado:

```ldp3
Car c = new Car(...) on heap;
delete c;
Console.printf($"chassi: {c.chassi}");   // OK, persistent ainda vivo
c.chassi = TipoChassi.ferro;             // OK, persistents permitem escrita pós-delete
```

Persistents marcados `constant persistent` são imutáveis pós-construção:

```ldp3
public class Car {
    public constant persistent int numero_de_passageiros = 5;
}
```

### 18.5 Persistents em arrays e containers

Elementos de arrays e containers podem ter persistents que sobrevivem ao `delete` do container:

```ldp3
Car[] carArray = new Car[6]();
// ... preenche carArray com 6 carros
delete carArray;
Console.printf($"chassi do carro 3: {carArray[2].chassi}");   // OK, persistent vive
release persistent carArray[1].chassi;   // libera só esse
```

A identidade aí é `(escopo, nome do array, índice, region)`. Reattach funciona quando array de mesmo nome é recriado: elementos cujos persistents não foram liberados explicitamente reatacam.

### 18.6 Liberação

Liberação simples (uma):
```ldp3
release persistent c.chassi;
```

Liberação múltipla:
```ldp3
release persistent b.chassi, c.chassi;
release persistent carArray[1].chassi, carArray[2].chassi;
```

Liberação por endereço direto (escape hatch pra liberar persistents fora do escopo de origem):
```ldp3
address endereco = Memory.getMemory(a.chassi of region anotherParking);
release a at address endereco;
```

`Memory.getMemory(...)` retorna o `address` físico do persistent na memória, permitindo libertação a partir de qualquer escopo.

### 18.7 Localização em memória

Persistents podem ter sua localização em memória especificada na declaração ou alocada na heap implícita por default. Também podem ser explicitamente colocados via `new` em uma region específica:

```ldp3
public class Cache {
    private persistent in region LongTerm string skeleton = "CacheSkeleton";
}
```

### 18.8 Sincronização

Modificações de persistents são **sequenciais**: duas classes ou threads não podem modificar um persistent simultaneamente. Mutex é implícito.

### 18.9 Construtor com parâmetros parciais

Quando uma classe tem persistents que mapeiam pra parâmetros do construtor (por nome do parâmetro = nome do campo persistent), o reattach permite omitir esses parâmetros — o valor vem do persistent existente:

```ldp3
public class Car {
    public persistent TipoChassi chassi;
    public Motor motor;
    public Marca marca;

    public constructor Car(TipoChassi chassi, Motor motor, Marca marca) {
        this.chassi = chassi;
        this.motor = motor;
        this.marca = marca;
    }
}

// Primeira criação:
Car a = new Car(Marca.chevrolet, Motor.v8, TipoChassi.aco) in region parking;
delete a of region parking;

// Reattach: chassi pode ser omitido, valor vem do persistent.
Car a = new Car(Marca.chevrolet, Motor.v8) in region parking;
```

Se o argumento for fornecido, ele **sobrescreve** o valor do persistent.

A correspondência parâmetro-persistent é feita por **nome do parâmetro casando com nome do campo persistent**. Se o construtor tem parâmetros com nomes que não casam com persistents, eles seguem obrigatórios normalmente.

### 18.10 Destrutor

Persistents podem ter destrutor próprio, que executa quando `release persistent` é chamado (não quando o objeto-pai é destruído).

### 18.11 Conversão de forma no reimport

Se um persistent existe quando a classe é reimportada com tipo diferente, ocorre conversão automática quando possível. Enquanto o persistent órfão existir com tipo incompatível, novas instâncias da variável associada à mesma tripla não podem ser criadas até `release persistent` explícito.

### 18.12 Aliasing e cópia

Atribuição entre variáveis tem semântica de cópia para classes (igual structs em C#), não de referência:

```ldp3
Thing t1 = new Thing();
Thing t2 = t1;   // cópia profunda; persistents de t2 são novos e independentes
```

Pra compartilhar instância (referência verdadeira), usa ponteiro ou referência explícita:

```ldp3
Thing t1 = new Thing();
Thing* t2 = &t1;   // mesma instância
Thing& t3 = t1;    // referência à mesma instância
```

### 18.13 Eternal persistents

Persistents que não devem nunca ser liberados explicitamente (caches globais, configuração que vive durante todo o programa, estado long-running) são marcados com a keyword `eternal`:

```ldp3
public class ConfigCache {
    public eternal persistent HashMap<String, String> settings;
    public eternal persistent string appVersion = "1.0.0";
    
    public persistent int sessionCounter = 0;   // não eternal, exige release
}
```

Semântica de `eternal persistent`:

- Sobrevive ao destrutor do objeto-pai (como persistent normal).
- **Não exige release explícito.** O compilador aceita ausência de release pra persistents marcados `eternal`.
- Sobrevive ao unimport da classe declarante. Continua acessível indefinidamente.
- Liberado automaticamente no shutdown do programa, com destrutor rodando.
- Pode ser liberado manualmente com `release eternal X.field` se desejado, mas não é obrigatório.

`eternal` é modifier de lifetime aplicável a múltiplos contextos da linguagem, não só a persistents. Ver seção 18.14.

### 18.14 `eternal` como modifier universal de lifetime

`eternal` indica que um recurso vive durante toda a duração do programa e o compilador não exige cleanup explícito. Aplicável a:

```ldp3
// Persistents:
public eternal persistent int settings = 0;

// Regions:
public eternal region globalCache = itself.allocate(64 megabytes);

// Threads:
public eternal thread monitor = new thread(lambda() returns void { /* ... */ });

// Channels:
public eternal Channel<Log> logger = new Channel<Log>(capacity: 1000);

// Static fields heap-allocated:
public eternal static ArrayList<Player> players = new ArrayList<Player>() on heap;

// Singletons:
public class Logger {
    public eternal static Logger instance = new Logger() on heap;
}
```

Em todos os casos a semântica é a mesma: vive durante toda execução do programa, compilador não exige cleanup, runtime libera no shutdown rodando destrutores.

### 18.15 Liberação obrigatória de persistents (erro de compilação)

Persistents **não-eternal** que não têm `release persistent` detectável em nenhum lugar do programa geram **erro de compilação**, não apenas warning:

```
error: persistent 'Car.chassi' não tem 'release persistent' detectado em
       nenhum lugar do programa. Persistents não-eternal exigem liberação
       explícita pra evitar memory leak.
       
       Soluções:
         (1) Adicione 'release persistent obj.chassi' no local apropriado.
         (2) Marque o campo como 'eternal persistent' se persistência
             durante todo o programa é intencional.
         (3) Marque o método com [[persistent_released_elsewhere(reason)]]
             se a liberação é delegada a código externo (FFI, plugin).
```

Análise é global (interprocedural): se qualquer método do programa libera o persistent, erro não dispara. Programador pode marcar liberação delegada com annotation explícita:

```ldp3
[[persistent_released_elsewhere(reason: "released by plugin cleanup hook")]]
public method createCar() returns Car {
    Car c = new Car(...) on heap;
    return c;   // outra parte do código vai liberar
}
```

**Caso especial — persistents em loops.** Quando o compilador detecta criação de persistent dentro de loop, emite warning adicional (não erro):

```
warning: persistent 'Car.chassi' criado em loop. Cada iteração reataca o
         persistent anterior. Verifique cuidadosamente se o último persistent
         criado pela última iteração é liberado após o loop ou marque como
         'eternal persistent' se acúmulo é intencional.
```

Compilador também pode emitir aviso de profiling pra eternals:

```
info: programa tem 12 eternal persistents declarados, totalizando
      aproximadamente 4.3KB de uso permanente de memória.
```

Útil pra análise de footprint de memória do programa.

---

## 19. Move e disciplinas de ownership

LDP3 oferece três disciplinas de ownership pra classes: **default** (semântica de cópia, como Java), **movable** (transferência explícita preserva uma única referência ativa), e **unique** (apenas uma referência viva por vez em todo o programa). A disciplina é declarada na classe e é parte do seu contrato — outras classes que usam a sua aprendem a disciplina ao olhar a declaração, não ao ler documentação.

A motivação é eliminar uma classe inteira de bugs comuns em manual memory management: use-after-free, double-free, e ownership ambíguo de recursos como arquivos, mutexes, conexões e handles de hardware. C++ tenta resolver com `unique_ptr`/`shared_ptr` na biblioteca, mas a sintaxe é confusa (`std::move` não move nada, apenas faz cast pra rvalue reference) e o estado pós-move é "valid but unspecified", gerando bugs silenciosos. LDP3 resolve no sistema de tipos, com sintaxe explícita e estado pós-move rastreado pelo compilador.

### 19.1 As três disciplinas

Disciplina é declarada como prefixo na classe, antes de `class`:

```ldp3
public class Buffer {
    // default: copy semantics
    // pode ter múltiplas referências, atribuição copia
}

public movable class Connection {
    // exige `move` explícito ao transferir ownership
    // estado pós-move: variável invalidada
}

public unique class FileHandle {
    // só pode existir uma referência viva no programa por vez
    // toda atribuição é move implícito
}
```

A disciplina é parte do tipo, não da referência. Toda variável do tipo `Connection` tem a mesma disciplina em qualquer contexto. Isso evita o inferno de C++ onde `Connection*` e `unique_ptr<Connection>` e `shared_ptr<Connection>` são tipos diferentes com semânticas diferentes pra mesma classe.

### 19.2 Comportamento de cada disciplina

**Default (sem prefixo):**

```ldp3
Buffer b1 = new Buffer() on heap;
Buffer b2 = b1;       // ambos válidos, comportamento de cópia
b1.write(data);        // OK
b2.write(otherData);   // OK
```

Atribuição copia. Múltiplas referências coexistem. Não tem garantia de unicidade.

**Movable:**

```ldp3
Connection c1 = new Connection() on heap;
Connection c2 = move c1;   // c1 invalidado
c1.send(data);              // ERRO de compilação: variável movida não pode ser usada

c1 = new Connection() on heap;   // OK: reassign reativa c1
c1.send(data);                    // OK
```

Atribuição sem `move` para tipo movable é erro de compilação. O compilador rastreia o estado de cada variável (válida, movida, reassignada). Variável movida pode ser reassignada, e a partir daí é válida de novo.

**Unique:**

```ldp3
public unique class FileHandle { /* ... */ }

FileHandle f1 = new FileHandle("data.txt") on heap;
FileHandle f2 = f1;   // implicit move; f1 invalidado
// equivalente a: FileHandle f2 = move f1;
```

Pra unique, toda atribuição é move (a keyword é opcional, mas recomendada por clareza). Garantia de unicidade é mantida pelo compilador: a qualquer instante, apenas uma variável referencia o objeto.

Tipos unique não podem ser passados por valor para múltiplos parâmetros simultaneamente, nem armazenados em containers que duplicam referências. Tentativas geram erro de compilação.

### 19.3 Move como família de operações

A keyword `move` opera em múltiplos eixos, todos expressos com sintaxe explícita que carrega informação no ponto de uso.

**Move entre variáveis (transferência de ownership):**

```ldp3
Connection c2 = move c1;
```

Forma básica. `c1` invalidado, `c2` é o novo dono.

**Move entre regions (transferência de localização):**

```ldp3
Connection* c = new Connection() in region staging;
// ... configuração inicial ...
move c from region staging to region production;
// mesma variável, region mudou. staging não tem mais o objeto.
```

Capability única de LDP3: mover objeto entre regions sem realocar logicamente. Internamente o compilador pode escolher entre memcpy físico e apenas atualizar tracking de region, dependendo da configuração das regions envolvidas. Use case principal: padrão builder onde se constrói em region temporária e "promove" pra region permanente quando completo.

**Move combinando ownership e region:**

```ldp3
Connection c1 = new Connection() in region staging;
Connection c2 = move c1 into region production;
// transfere ownership para c2 E muda region para production
// operação atômica
```

`into` é a preposição que combina os dois eixos. Mais conciso e claro que duas operações separadas.

**Move com cast de disciplina (raro):**

```ldp3
public movable class Connection { /* ... */ }
public unique class ExclusiveConnection extends Connection { /* ... */ }

Connection c = new Connection() on heap;
ExclusiveConnection e = move c as ExclusiveConnection;
```

Upgrade de movable para unique requer conversão explícita via `as`. Downgrade (unique para movable) é proibido — viola a garantia de unicidade.

**Sintaxe formal geral:**

```
move <source> [into <destination_var>] [to|into region <R>] [from region <R0>] [as <Type>] [carrying|leaving|releasing persistents];
```

Quando aparece no lado direito de uma atribuição:

```
<Type> <var> = move <source> [from region <R0>] [into region <R>] [as <Type>] [carrying|leaving|releasing persistents];
```

Compilador valida que combinações fazem sentido. Inconsistências geram erros específicos.

### 19.4 Estado pós-move e rastreamento

O compilador rastreia o estado de cada variável movable ou unique em três valores: **válida**, **movida**, **não-inicializada**.

Após `move`, a variável fonte fica no estado **movida**. Uso de variável movida é erro de compilação:

```ldp3
Connection c1 = new Connection() on heap;
Connection c2 = move c1;
c1.send(data);
// ERRO: variável 'c1' foi movida na linha N. Acesso após move é proibido.
//       Reassigne c1 com nova alocação antes de usar.
```

**Reassign reativa a variável:**

```ldp3
Connection c1 = new Connection() on heap;
Connection c2 = move c1;            // c1: movida
c1 = new Connection() on heap;      // c1: válida de novo
c1.send(data);                       // OK
```

Reassign é o caminho idiomático para reuso de variável após move. Loops que consomem e recriam ficam limpos:

```ldp3
mutable Connection c = new Connection() on heap;
for (int i in 0..10) {
    consume(move c);
    c = new Connection() on heap;
}
```

**Destrutor de variável movida não roda:**

```ldp3
public method exemplo() returns void {
    Connection c1 = new Connection() on heap;
    Connection c2 = move c1;
    // ... fim do método ...
    // destrutor roda em c2, não em c1
    // c1 foi conceitualmente "consumida" pelo move
}
```

O compilador insere chamadas de destrutor apenas nas variáveis que estão em estado **válida** ao fim do escopo. Isso evita double-free automaticamente.

**Move parcial de campos é proibido por default:**

```ldp3
public class Connection {
    public movable Socket socket;
    public mutable Config config;
}

Connection c1 = new Connection() on heap;
Socket s = move c1.socket;
// ERRO: move parcial de campo 'socket' não é permitido.
//       Marque a classe 'Connection' como 'partitionable' para permitir.
```

Mover só um campo deixaria o objeto-pai em estado inconsistente. Por padrão, a única forma de mover é o objeto inteiro.

### 19.5 Partitionable: move parcial opt-in

Classes marcadas `partitionable` permitem move parcial de campos individuais. Decisão consciente de quem desenha a classe.

```ldp3
public partitionable class Connection {
    public movable Socket socket;
    public mutable Config config;
}

Connection c1 = new Connection() on heap;
Socket s = move c1.socket;
// OK: socket é movable e a classe é partitionable
// c1.socket fica no estado movida
// c1.config continua válido
```

Após move parcial, o objeto-pai continua existindo mas o campo movido fica inacessível até reassign. O compilador rastreia cada campo individualmente.

**Reassign de campo movido:**

```ldp3
c1.socket = new Socket() on heap;   // OK: reativa o campo
c1.socket.send(data);                // OK
```

**Restrições:**

- Apenas campos com disciplina `movable` ou `unique` podem ser movidos parcialmente. Campos default (copy semantics) são copiados, não movidos.
- Acesso ao objeto-pai com algum campo em estado movida é permitido para os campos restantes, mas não para o campo movido.
- Destrutor do objeto-pai só roda destrutores de campos em estado válida.
- Tentar passar o objeto-pai com campos movidos para função que espera o objeto inteiro é erro: o objeto está em estado parcial.

`partitionable` é capability poderosa mas perigosa. O compilador valida cada acesso a campo movido como erro, e mensagens de erro indicam exatamente qual campo está em qual estado.

### 19.6 Move em assinaturas de método

**Argumentos por move:**

```ldp3
public method consume(move Connection c) returns void {
    // c é movido para dentro do método
    // caller perde ownership após a chamada
    c.send(data);
    // destrutor roda em c ao fim do método
}

Connection c1 = new Connection() on heap;
consume(move c1);   // sintaxe casa no caller: move explícito
// c1 invalidado aqui
```

A keyword `move` aparece tanto na assinatura do método quanto na chamada. Verbosidade que carrega informação: lendo a chamada, você sabe que vai perder ownership sem precisar consultar a assinatura.

**Retorno por move:**

```ldp3
public method create() returns move Connection {
    Connection c = new Connection() on heap;
    return move c;
}

Connection c1 = create();
// c1 é o novo dono
// internamente, retorno por move evita cópia
```

`returns move T` indica transferência de ownership pro caller. Sem `move`, o retorno é cópia (pra classes default) ou erro de compilação (pra movable/unique).

**Interação com `unique`:**

Métodos que retornam tipos unique sempre retornam por move (implícito). A keyword é opcional na assinatura mas recomendada por clareza:

```ldp3
public method openFile(string path) returns FileHandle {
    return new FileHandle(path) on heap;
    // implicit move
}

public method openFile(string path) returns move FileHandle {
    return move new FileHandle(path) on heap;
    // explícito, recomendado
}
```

### 19.7 Interação com persistents

Persistents seguem o objeto durante o move por padrão. A tripla de identidade `(escopo, nome, region)` é atualizada quando a variável é movida, e os persistents reataçam à nova tripla automaticamente.

```ldp3
public movable class Car {
    public persistent TipoChassi chassi;
}

Car c1 = new Car(...) on heap;
c1.chassi = TipoChassi.aco;
Car c2 = move c1;
// persistents de c1 agora estão atrelados a c2
// tripla foi atualizada de (escopo, "c1", heap) para (escopo, "c2", heap)
Console.println(c2.chassi);   // "aco"
```

Esse é o comportamento default porque casa com a intuição mais comum: move conceitualmente "renomeia" ou "relocaliza" o objeto, e persistents fazem parte do estado do objeto.

**Qualificadores explícitos:**

Pra casos onde o comportamento padrão não é desejado, três qualificadores contextuais controlam o que acontece com os persistents:

```ldp3
Car c2 = move c1 carrying persistents;
// equivalente ao default: persistents seguem para nova tripla
// keyword explícita pra documentar intenção

Car c2 = move c1 leaving persistents;
// persistents ficam órfãos na tripla antiga (escopo, "c1", region)
// c2 começa sem persistents
// persistents podem ser reataçados se uma variável de nome "c1" for criada depois

Car c2 = move c1 releasing persistents;
// persistents são liberados explicitamente
// nem c1 nem c2 têm os valores antigos
```

Quando o move é entre regions, os qualificadores também aplicam:

```ldp3
move c1 from region staging to region production carrying persistents;
// persistents seguem o objeto para a nova region
// tripla muda de (escopo, "c1", staging) para (escopo, "c1", production)

move c1 from region staging to region production leaving persistents;
// persistents ficam órfãos na tripla (escopo, "c1", staging)
// o objeto em production começa sem persistents
```

**Por que carrying é o default:**

A intuição mais comum é que persistents fazem parte do objeto e seguem com ele. Os outros dois qualificadores existem para casos específicos:

- `leaving` — útil quando o programador quer preservar persistents na localização original para futura reataçamento, mantendo o novo objeto limpo.
- `releasing` — útil em refactor de código onde persistents antigos não são mais relevantes e devem ser explicitamente descartados.

**Tipos unique + persistents:**

A combinação é permitida porque move em tipos unique sempre transfere o objeto inteiro. Comportamento padrão (carrying) é idêntico a movable.

**Tipos default + persistents:**

Persistents em tipos com copy semantics têm regras já definidas em seção 18 — cópia gera tripla nova com persistents independentes. `move` não se aplica a tipos default, então os qualificadores também não.

### 19.8 Cascade move

O prefixo universal `cascade` aplica a `move`:

```ldp3
cascade move tree from region old to region new;
// move tree + todos os objetos referenciados recursivamente para nova region
```

Use case real: snapshot/restore de game state, transferência de subsistema inteiro entre arenas, promoção de árvore de objetos de scratch region pra permanente.

**Regras de propagação:**

1. O move propaga por referências contidas em campos do objeto-alvo.
2. Cada objeto movido obedece sua própria disciplina de ownership. Objetos default são copiados durante a cascata; objetos movable/unique são movidos.
3. Cycle detection: se uma referência cíclica é encontrada, o compilador erra em compile-time quando detecta estaticamente, ou em runtime caso contrário.
4. Persistents seguem (carrying) por default em cada nível da cascata. Qualificadores aplicam à raiz e propagam:

```ldp3
cascade move tree from region old to region new leaving persistents;
// tree e todos os filhos movidos
// persistents de todos ficam órfãos nas respectivas triplas antigas
```

5. Se algum objeto na cascata é unique e já tem outra referência viva em outro lugar, a cascata falha (erro de compilação se detectado estaticamente, exception em runtime caso contrário).

### 19.9 Combinações inválidas

O compilador rejeita combinações contraditórias com mensagens específicas:

**`unique` + `partitionable` é contraditório:**

```
error: 'unique' e 'partitionable' são contraditórios.
       'unique' garante uma única referência viva ao objeto inteiro.
       'partitionable' permite mover campos separadamente, criando referências
       independentes a partes do objeto, o que quebra a garantia de unicidade.
       Escolha uma das duas disciplinas.
```

**Move de tipo default:**

```
error: tipo 'Buffer' não tem disciplina de ownership.
       Use 'movable' ou 'unique' na declaração da classe, ou faça atribuição
       normal sem 'move' (que terá semântica de cópia).
```

**Move parcial em classe não-partitionable:**

```
error: move parcial de campo 'socket' não é permitido.
       A classe 'Connection' precisa ser declarada 'partitionable' para permitir
       move de campos individuais.
```

**Downgrade de unique para movable via cast:**

```
error: cast 'as Connection' rebaixa disciplina de 'unique' para 'movable'.
       Isso viola a garantia de unicidade do tipo original.
       Para abandonar unicidade, libere o objeto unique com 'delete' e crie
       uma nova instância da classe movable.
```

**Uso após move:**

```
error: variável 'c1' foi movida na linha 42. Acesso após move é proibido.
       Reassigne 'c1' com nova alocação antes de usar.
```

**Qualificadores de persistents em tipo sem persistents:**

```
warning: qualificador 'carrying persistents' aplicado a classe 'Buffer' que
         não declara persistents. Qualificador será ignorado.
```

### 19.10 Ordem composicional com prefixos universais

`movable`, `unique` e `partitionable` aparecem na ordem composicional canônica imediatamente após visibilidade:

```
[annotations]
[visibilidade] [movable|unique] [partitionable] [eternal] [lazy] [final] [comptime] [volatile] [cascade] [static] [mutable] [persistent|transient] [constant] [in region X]
<tipo> <nome> [= inicializador];
```

Exemplo combinado:

```ldp3
public unique partitionable eternal final class GlobalRegistry {
    public movable persistent Connection primaryConnection;
    public mutable Config config;
}
```

Lê-se: classe única globalmente, com move parcial permitido, vive até o fim do programa, não pode ser estendida nem substituída. Tem um campo movable que sobrevive ao destrutor da instância, e um campo mutável normal.

A combinação `unique partitionable` viola a regra anti-contradição da seção 19.9, então este exemplo seria rejeitado. Forma válida sem contradição:

```ldp3
public movable partitionable eternal final class GlobalRegistry { /* ... */ }
```

Ou:

```ldp3
public unique eternal final class GlobalRegistry { /* ... */ }
```

### 19.11 Modo freestanding

As keywords `move`, `movable`, `unique`, `partitionable` e `into` são **mantidas em modo freestanding**. Disciplinas de ownership são compile-time only e não dependem de runtime gerenciado, então são essenciais pra kernel devs que querem segurança de ownership sem custo de runtime.

Os qualificadores `carrying`, `leaving` e `releasing` são **removidos em modo freestanding** porque dependem de persistents (que não existem em freestanding). Em kernel, move sempre transfere o objeto sem qualificador adicional.

### 19.12 Comparação com outras linguagens

| Conceito | LDP3 | C++ | Rust |
|----------|------|-----|------|
| Declaração de disciplina | No tipo (classe) | Via wrapper (`unique_ptr`, `shared_ptr`) | No tipo (trait `Copy`/sem) |
| Sintaxe de move | `move x` keyword | `std::move(x)` função | `x` (implícito em assignment) |
| Estado pós-move | Rastreado, erro de compilação | "Valid but unspecified" | Rastreado, erro de compilação |
| Move entre regions | Sim, `from`/`to`/`into` | Manual (alloc + copy + free) | Não tem regions |
| Move parcial | Opt-in via `partitionable` | Implícito (membros movem independentemente) | Permitido para structs |
| Move + persistents | `carrying`/`leaving`/`releasing` | N/A (sem persistents) | N/A (sem persistents) |
| Cascade move | Sim, `cascade move` | Manual | Manual |
| Visibilidade no caller | `move x` explícito | `std::move(x)` explícito | Implícito em `=` |

LDP3 oferece a integração mais profunda entre move semantics e o resto da linguagem (regions, persistents, prefixos universais). Sintaxe é mais verbosa que Rust, mais explícita que C++. A verbosidade carrega informação que ajuda leitura e refactoring — quem lê uma linha com `move` sabe exatamente o que ela faz sem consultar nada externo.

---

## 20. Concorrência

Concorrência em LDP3 é fornecida principalmente via stdlib, não via keywords dedicadas. As classes `Thread`, `Channel<T>`, `Mutex<T>` são tipos da stdlib (não keywords). Apenas `async`/`await` permanecem como keywords por afetarem geração de código.

### 20.1 Threads (stdlib)

`Thread` é classe da stdlib (`System.Concurrency.Thread`). Não é keyword.

```ldp3
Thread t = new Thread(lambda() returns void { /* ... */ }) on heap;
t.start();
t.join();
```

### 20.2 Async/await (sistema separado de threads)

Async usa um pool de worker threads gerenciado pela linguagem. Threads OS explícitas são tipos da stdlib. Conceitualmente diferentes; podem coexistir.

```ldp3
public async method fetchData(String url) returns Result<string, IOError> {
    Response r = await httpClient.get(url);
    return Ok(r.body);
}

// Em código async:
Result<string, IOError> data = await fetchData("https://example.com");
```

`async` e `await` permanecem keywords porque afetam transformação de código pelo compilador (state machine generation).

### 20.3 Channels (stdlib)

`Channel<T>` é classe genérica da stdlib (`System.Concurrency.Channel`). Não é keyword. Sintaxe de uso é idêntica à de qualquer classe stdlib.

```ldp3
Channel<Dog> chan = new Channel<Dog>(capacity: 10) on heap;

// Thread/coroutine 1:
chan.send(rex);

// Thread/coroutine 2:
Dog received = chan.receive();
```

### 20.4 Select (stdlib)

Seleção entre múltiplos channels é fornecida pelo método estático `Channel.select(...)` da stdlib, usando builder pattern. Não há keyword `select`.

```ldp3
Channel.select()
    .receive(chanA, lambda(Dog d) returns void { d.bark(); })
    .receive(chanB, lambda(Cat c) returns void { c.meow(); })
    .timeout(milliseconds(1000), lambda() returns void { /* timeout */ })
    .run();
```

Comparado à versão keyword (em rascunhos anteriores da linguagem), o builder é mais verboso mas usa mecanismos existentes (métodos estáticos, lambdas, fluent API). Sem perda de capability.

### 20.5 Mutex

```ldp3
Mutex<ArrayList<Dog>> dogs = new Mutex<ArrayList<Dog>>(...) on heap;

synchronized (dogs) using ArrayList<Dog>& list {
    list.add(rex);
}
```

### 20.6 Atomic e volatile

```ldp3
atomic<int> counter;
private volatile int flag;
```

Async pode usar channels (`await chan.receive()`). Segurar mutex através de `await` é **proibido** pelo compilador (previne deadlock clássico).

---

## 21. Exceptions e Result

### 21.1 Exceptions (unchecked)

```ldp3
public class IOException extends Exception { }

public method readFile(String path) throws(IOException, NetworkException) returns string {
    if (!exists(path)) {
        throw new IOException($"Arquivo {path} não existe");
    }
    // ...
}

try {
    string data = readFile("config.json");
} catch (IOException e) {
    Console.println(e.message);
} catch (NetworkException e) {
    // ...
} finally {
    // sempre executa
}
```

`throws` é **keyword** (não annotation). Compilador emite warning se método lança algo não declarado.

### 21.2 Result alternativo

```ldp3
public method openFile(String path) returns Result<File, IOError> {
    if (!exists(path)) {
        return Err(new IOError("not found"));
    }
    return Ok(new File(path));
}

// Pattern match:
Result<File, IOError> r = openFile(path);
match (r) {
    case Ok(File f) { /* ... */ }
    case Err(IOError e) { /* ... */ }
}

// Açúcar pra propagar:
File f = try? openFile(path);   // se Err, propaga pro Result do caller
```

### 21.3 Option

```ldp3
public method findDog(String name) returns Option<Dog> {
    if (notFound) { return None(); }
    return Some(dog);
}
```

### 21.4 Representação: value vs boxed (o `*`)

`Result<T,E>` e `Option<T>` têm **duas representações**, escolhidas pelo `*` — sem custo de sintaxe, e o
`Ok`/`Err`/`Some`/`None` é o mesmo nos dois casos:

- **Value (sem `*`)** — a forma padrão e rápida. `Result<T,E>` / `Option<T>` é uma **união etiquetada por
  valor** (`{ tag, payload }`), passada em registradores como o `Result` do Rust ou o `std::expected` do
  C++. `Ok(x)` não aloca nada, não há `delete`, e um laço quente de `Result` não toca o heap. É a forma pra
  retornar um resultado que se consome logo (match/`try?`).

  ```ldp3
  public method parse(int x) returns Result<int, int> {   // value: nada no heap
      if (x < 0) { return Err(0 - x); }
      return Ok(x);
  }
  Result<int, int> r = parse(5);
  match (r) { case Ok(int v) { /* ... */ } case Err(int e) { /* ... */ } }
  int v = try? parse(5);                                   // propaga o Err por valor
  ```

- **Boxed (`*`)** — `Result<T,E>*` / `Option<T>*` é o objeto no heap (a classe selada `Ok`/`Err` /
  `Some`/`None`), com `new ... on heap` implícito no açúcar e `delete` pra liberar. Use quando precisar
  **guardar, compartilhar ou armazenar** a variante além do ponto de uso (num campo, numa coleção). O
  compilador (`ldp3c`) distingue pelo `*`: código existente com `Result<T,E>*` + `delete` continua igual.

  ```ldp3
  Result<int, int>* r = parse(5);   // no heap; guardável
  // ... usa r ...
  delete r;                          // libera; num value seria no-op
  ```

Regra prática: **use a forma value por padrão** (é a que vence o error-code em performance); recorra ao
`*` só quando a variante precisa sobreviver ao seu consumidor imediato. (Limites atuais da forma value:
payload que não cabe em 64 bits — `Decimal`, tupla, `struct` por valor, ou ponteiro explícito — usa a forma
boxed; e um método `async` que retorna Result/Option deve usar a forma boxed por ora.)

---

## 22. Lambdas e funções

### 22.1 Tipo função

```ldp3
function<int, int, int> add = lambda(int a, int b) returns int { return a + b; };
int result = add(3, 5);
```

### 22.2 Captura explícita

```ldp3
int x = 10;
int y = 20;
function<int> get = lambda[captures: byvalue x, byref y]() returns int {
    return x + y;
};
```

### 22.3 Method references

```ldp3
function<void> bark = methodref rex.bark;
bark();
```

### 22.4 Named arguments e requires named

```ldp3
public method configure(int volume, int duration, requires named boolean repeat) returns void { }

dog.configure(5, 2, repeat: false);          // OK
dog.configure(volume: 5, duration: 2, repeat: false);   // OK
dog.configure(5, 2, false);                  // ERRO: repeat é requires named
```

### 22.5 Múltiplos retornos via tupla

```ldp3
public method divmod(int a, int b) returns (int quotient, int remainder) {
    return (a / b, a % b);
}

(int q, int r) = divmod(17, 5);
```

### 22.6 Generators (yield)

```ldp3
public method primes() returns Iterator<int> {
    mutable int n = 2;
    while (true) {
        if (isPrime(n)) { yield n; }
        n++;
    }
}

for (int p in primes()) {
    if (p > 1000) { break; }
}
```

---

## 23. Recursos com escopo

### 23.1 Defer

LIFO; roda no fim do escopo incluindo unwinding de exception.

```ldp3
public method processFile(String path) returns void {
    File f = new File(path) on heap;
    defer { delete f; }
    // se der throw aqui, delete f ainda roda
    f.read();
}
```

### 23.2 Using

Açúcar pra recursos com escopo bem definido. Tipo deve implementar `Disposable`.

```ldp3
using (File f = new File(path) on heap) {
    f.read();
}   // delete f automático no fim
```

---

## 24. Type aliases e newtype

```ldp3
public typealias DogList = ArrayList<Dog>;
public typealias Callback = function<void, int>;
public typealias UserId = int64;     // transparente: UserId == int64

public newtype OrderId = int64;       // tipo distinto: OrderId não aceita int64 sem cast
```

---

## 25. Arrays

Arrays nativos são dinâmicos: o tamanho não é fixo em compile-time e pode crescer em runtime.

```ldp3
int[] arr = [1, 2, 3, 4];                   // literal
int[] dyn = new int[size]();                // tamanho inicial em runtime
Car[] carArray = new Car[Car.sizeof()]();   // pode usar sizeof() ou qualquer expressão

int len = arr.length();                      // tamanho atual
arr.length(arr.length() + 1);               // cresce em 1
```

Acesso por índice via `arr[i]`. Multi-dimensional via `int[][] matrix = [[1, 2, 3], [4, 5, 6]]`.

Pra crescimento e operações mais ricas (insert, remove, contains), `ArrayList<T>` da stdlib continua sendo opção mais expressiva.

---

## 26. FFI

```ldp3
extern cdecl method malloc(int size) returns void*;
extern cdecl method printf(String format, ...) returns int;

extern cdecl library sqlite3 {
    method sqlite3_open(string path, Database** db) returns int;
    method sqlite3_close(Database* db) returns int;
}

extern stdcall library at path./libs/custom.so {
    method custom_func() returns void;
}
```

Calling conventions são **keywords** (não strings): `cdecl`, `stdcall`, `fastcall`, etc.

Nome de library é **identifier**, não string.

---

## 27. Ponteiros e aritmética

Classes têm **semântica de valor** por default: a atribuição é cópia profunda (ver §8.2).
Ponteiros (`T*`) e referências (`T&`) são o opt-in para **compartilhar** uma instância — quando
você quer que múltiplas variáveis vejam e mutem o mesmo objeto, em vez de cópias independentes.
Não são obrigatórios em uso normal; só quando o compartilhamento é intencional.

Aritmética de ponteiro é **permitida em todos os tipos** mas o compilador emite warning, pois em ponteiros pra classe avançar não faz sentido semântico e pode corromper memória.

```ldp3
Dog* p = &rex;
p++;   // warning: aritmética em ponteiro de classe pode corromper memória
```

---

## 28. Compile-time evaluation

### 28.1 Const

```ldp3
public const int MAX_DOGS = 100;
public const int BUFFER_SIZE = sizeof(Dog) * MAX_DOGS;
```

### 28.2 Static assert

```ldp3
static_assert(BUFFER_SIZE < 65536, "buffer não cabe em região de 16-bit");
```

### 28.3 Comptime functions

```ldp3
public method fibonacci(int n) returns int comptime {
    if (n < 2) { return n; }
    return fibonacci(n-1) + fibonacci(n-2);
}

public const int FIB10 = fibonacci(10);   // calculado em compile-time
```

### 28.4 Lazy initialization

```ldp3
private lazy Dog expensiveDog = new Dog("LazyRex") on heap;
// só aloca na primeira leitura; thread-safe por default (mutex implícito)
```

---

## 29. Contracts

Pré-condições, pós-condições e invariantes de classe. Não obrigatórios; opcionais para documentar.

```ldp3
public method withdraw(int amount) returns void
    requires amount > 0
    requires amount <= this.balance
    ensures this.balance == old(this.balance) - amount
{
    this.balance = this.balance - amount;
}

public class Account {
    invariant this.balance >= 0;
    // ...
}
```

Checagem em runtime (debug) ou em compile-time onde possível.

---

## 30. Unimport

Unimport remove uma referência do compilador em runtime. **Unloading agressivo**: toda porção que tinha referência à entidade unimportada é deletada de memória, exceto persistents. É uma das features mais únicas e ousadas da LDP3.

### 30.1 Sintaxe

Unimport opera em três granularidades:

```ldp3
unimport Dog;                                    // símbolo individual (classe, interface, enum, etc)
unimport namespace audio.mixers;                 // namespace inteiro
unimport bundle audio from program GameEngine;   // bundle inteiro
```

Todas as três granularidades são permitidas. Unimport de bundle é equivalente a unimport de todos os símbolos de todos os namespaces daquele bundle.

### 30.2 Comportamento básico

- Toda referência ao símbolo unimportado é removida de memória.
- Persistents sobrevivem como órfãos; path qualificado (`rex.skeleton`) continua funcionando.
- Eternal persistents sobrevivem como órfãos da mesma forma. Diferença: eternal persistents permanecem acessíveis até o fim do programa mesmo sem reimport.
- Persistents órfãos não-eternal não podem dar reattach até o objeto-pai ser reimportado.
- Enquanto um persistent órfão existir, **não é possível instanciar nova variável de mesmo nome** que pertencia ao tipo unimportado. É necessário `release persistent` primeiro.

### 30.3 Reimport

```ldp3
import Dog;   // recarrega a versão atual do arquivo no disco
```

- Re-carrega a versão atual do arquivo (lê do disco no momento do import).
- Se a forma da classe mudou, persistents com tipos compatíveis sofrem conversão automática quando possível.
- Versão nova entra em vigor pra novas instâncias e pra órfãos compatíveis que reatacam.

### 30.4 Interação com hierarquia de tipos

**Subtyping.** Subclasses sobrevivem como órfãs quando a superclasse é unimportada. Métodos herdados continuam acessíveis através de uma vtable órfã que mantém o código herdado em memória mesmo após o unimport da superclasse. O runtime garante que vtables órfãs não sejam liberadas enquanto houver subclasse viva.

**Catalogs e enums.** Quando um catalog é unimportado, enums que o implementam ficam órfãos. Métodos exigidos pelo catalog continuam funcionando através de tabelas auxiliares mantidas pelo runtime. Quando o catalog é reimportado, o enum reataca automaticamente.

**Interfaces.** Quando uma interface é unimportada, classes que implementam ficam órfãs. Métodos da interface continuam invocáveis através de vtable órfã.

### 30.5 Interação com construtor e destrutor em andamento

Unimport durante construção ou destruição em outra thread é tratado com sincronização:

- Unimport **bloqueia** até todos os construtores e destrutores em execução da entidade alvo completarem.
- Novos construtores da entidade alvo são bloqueados após início do unimport.
- Se algum constructor/destructor entra em loop infinito, unimport pode timeout (configurável; default 30 segundos) e lançar `UnimportTimeoutException`.

### 30.6 Interação com threads ativas

Quando uma thread está executando código de uma entidade que vai ser unimportada:

- Unimport **bloqueia** até todas as threads ativas saírem do código da entidade.
- Threads em loop dentro do código unimportado eventualmente disparam timeout.
- Após timeout, o runtime tem duas opções controladas por flag:
  - **Modo gentil (default):** unimport falha, lança `UnimportBlockedException`. Programa continua.
  - **Modo forçado** (`unimport force`): runtime termina as threads bloqueadas, completa unimport. Threads terminadas viram zombie threads coletadas no fim do programa.

```ldp3
unimport Dog;            // modo gentil
unimport Dog force;      // modo forçado
unimport Dog timeout(milliseconds(5000));   // timeout customizado
```

### 30.7 Interação com generics monomorfizados

Generics são monomorfizados em compile-time. `ArrayList<Dog>`, `HashMap<String, Dog>`, `Channel<Dog>` viram código especializado pra Dog. Unimport de Dog também unimporta esses códigos monomorfizados.

- O runtime mantém registry de monomorfizações por tipo.
- Unimport de Dog dispara unimport em cascata de todas as monomorfizações que referenciam Dog.
- Containers ativos com Dog ficam órfãos junto. `ArrayList<Dog>* dogs;` continua acessível, mas operações que exigem código de Dog (como destrutor de elementos) ficam bloqueadas até reimport.

### 30.8 Interação com callbacks FFI

Funções extern C podem registrar callbacks que apontam pra métodos LDP3:

- Unimport de classe que tem método registrado como callback C **bloqueia** até callback ser explicitamente removido via API.
- Programador é responsável por desregistrar callbacks antes de unimport, ou marcar callbacks como `eternal` (callbacks eternal são preservados em runtime mesmo após unimport).

```ldp3
[[eternal_callback]]
public method onSignal(int sig) returns void { /* ... */ }
```

### 30.9 Interação com async/await

Tarefas async suspensas em métodos de classe unimportada:

- Unimport **detecta** tarefas async pendentes na entidade alvo.
- Cada tarefa pendente recebe sinal de cancelamento; o runtime lança `UnimportedTypeException` no ponto de await quando a tarefa retomaria.
- Async tasks completam o cleanup normal via defer e finalmente.
- Após todas as tarefas serem canceladas, unimport prossegue.

### 30.10 Interação com channels

Channels ativos com tipo unimportado:

- Channels mantidos no programa: ficam órfãos. Threads bloqueadas em `receive` recebem `UnimportedTypeException`. Threads em `send` recebem mesma exception.
- Mensagens já dentro do channel são destruídas (destrutor roda se ainda disponível).
- Após reimport, channels órfãos podem ser reatacados se nome de variável (tripla `escopo, nome, region`) bate.

### 30.11 Interação com snapshots de regions

Snapshots tirados antes do unimport contêm dados serializados internamente:

- Restore de snapshot que contém tipos unimportados lança `SnapshotIncompatibleException`.
- Se a classe é reimportada antes do restore, snapshot é validado contra nova versão. Conversão automática roda quando tipos são compatíveis.
- Snapshots podem ser marcados como `eternal snapshot` pra sobreviverem a unimport (mantêm metadata de tipo embutida).

### 30.12 Interação com reflection

Reflection vê normalmente tipos unimportados, mas com estado refletindo o unimport:

```ldp3
Type t = reflect.typeOf<Dog>();
unimport Dog;

t.isAlive();                  // retorna false
t.hasOrphanedPersistents();   // retorna true se há persistents órfãos
t.methods();                  // ainda lista métodos (metadata preservada)
t.method("bark").invoke(...); // lança UnimportedTypeException
```

Metadata de tipos unimportados consome memória até o fim do programa, exceto se o programa explicitamente chama `reflect.purgeUnimported()`.

### 30.13 Compilação parcial e unimport

Em build variants com compilação parcial, programa pode tentar unimport de bundle que nunca foi import:

- Unimport de bundle ausente: no-op silencioso. Não erra.
- Unimport de classe específica de bundle ausente: lança `BundleNotLoadedException` (mesma exception de uso normal de bundle ausente).

### 30.14 Cleanup de persistents órfãos no fim do programa

Persistents órfãos não-eternal que nunca recebem release explícito:

- Acumulam em memória durante toda a execução.
- No shutdown do programa, runtime varre persistents órfãos e roda destrutores antes de liberar.
- Programa pode listar e gerenciar órfãos via `reflect.orphanedPersistents()`.

```ldp3
ArrayList<OrphanedPersistent> orphans = reflect.orphanedPersistents();
for (OrphanedPersistent o in orphans) {
    Console.println($"órfão: {o.path()}, bytes: {o.size()}");
    o.release();
}
```

### 30.15 Custo de runtime do suporte a unimport

Cada classe tem metadata em runtime que permite unimport: vtable, monomorfizações registradas, persistents associados, callbacks registrados, snapshots dependentes. Esse metadata é gerado pelo compilador e empacotado no binário.

Em modo completo (default), o custo é assumido — todas as classes são unimportáveis.

Em casos onde overhead não é aceitável, classes podem ser marcadas como não-unimportáveis:

```ldp3
[[not_unimportable]]
public class HotPathStruct { /* ... */ }
```

Classes marcadas perdem capacidade de unimport mas economizam metadata. Compilador erra se código tentar `unimport HotPathStruct`.

Em modo freestanding, unimport não existe e todas as classes são implicitamente não-unimportáveis.

### 30.16 Sintaxe expandida de unimport

Combinando todas as variantes:

```ldp3
// Granularidades:
unimport Dog;                                    // classe
unimport interface Animal;                        // interface
unimport enum Color;                              // enum
unimport catalog Severity;                        // catalog
unimport namespace audio.mixers;                  // namespace
unimport bundle audio;                            // bundle local
unimport bundle audio from program GameEngine;   // bundle cross-program

// Modificadores:
unimport Dog force;                              // força mesmo com threads ativas
unimport Dog timeout(milliseconds(5000));        // timeout customizado
unimport Dog force timeout(milliseconds(1000));  // ambos
cascade unimport Dog;                            // unimport propagado em cascata (subclasses + monomorfizações)
```

### 30.17 Caso especial: unimport de eternal

Eternal persistents e eternal regions sobrevivem ao unimport da classe que os declarou:

- Path qualificado continua funcionando indefinidamente.
- Não exigem reimport pra acesso.
- Liberação explícita via `release eternal X.field` ou ao final do programa.

### 30.18 Validação de reimport via `expecting`

Reimport sem validação representa vetor de ataque: atacante substitui arquivo no disco entre `unimport` e `import`, programa carrega código não-autêntico. Pra ambientes que exigem garantia de autenticidade de código (fintech, healthcare, governamental, militar, compliance), LDP3 oferece mecanismo de validação **challenge-response simétrico**.

A linguagem não impõe algoritmo criptográfico, não tem primitivos crypto built-in, e não usa strings de hash. Em vez disso, programador define **blocos de código** que produzem valor de validação. Validação acontece comparando valores produzidos pelo código antigo e pelo código novo.

**Sintaxe básica:**

```ldp3
var a = unimport Dog expecting {
    // bloco executado no código antigo antes de descarregar
    return computeIntegrityValue();
};

import Dog expecting a {
    // bloco executado no código novo após carregar
    // deve produzir valor bit-a-bit idêntico a 'a'
    return computeIntegrityValue();
} onFailure {
    // comportamento de falha definido pelo programador
    panic("validação de reimport falhou");
};
```

**Sintaxe com challenge (using):**

Programador pode passar variáveis adicionais como contexto pros blocos:

```ldp3
int challenge = Random.nextInt();

var a = unimport Dog expecting using challenge {
    return Dog.responseTo(challenge);
};

import Dog expecting a using challenge {
    return Dog.responseTo(challenge);
} onFailure {
    Console.println("código não autêntico detectado");
    System.exit(1);
};
```

**Regras semânticas:**

1. O bloco do `unimport expecting { ... }` executa no contexto do código antigo antes do descarregamento. Tem acesso completo ao estado interno da classe (campos privados, métodos privados, constantes privadas).

2. O bloco do `import expecting a { ... }` executa no contexto do código novo após o carregamento. Tem acesso ao estado interno do código novo.

3. O tipo da variável de validação (`a`) é inferido do retorno do bloco. Pode ser qualquer tipo da linguagem.

4. Comparação dos dois valores é **bit-a-bit estrita**, não via operator overload de `==`. Comparação direta da representação em memória. Isso previne spoofing via implementação maliciosa de `equals()`.

5. **Não há comportamento default em caso de falha.** Programador deve fornecer bloco `onFailure { ... }` explícito. Compilador erra se `onFailure` é omitido em `import` com `expecting`.

6. A variável de validação pode ter qualquer escopo e lifetime — local, campo de classe, eternal, persistent, em region específica. Aproveita todo o sistema de lifetime da linguagem.

7. Validação por `expecting` funciona tanto no nível top-level quanto dentro de métodos e funções. Sem restrição de escopo.

8. Cascade pode ser combinado com expecting mas **é desaconselhado** — comportamento de validação composta sobre hierarquia é não-trivial. Quando combinados, cada entidade validada gera valor próprio; programador é responsável por interpretar resultado.

**Por que challenge-response em vez de hash/signature direto:**

A linguagem deliberadamente evita primitivos criptográficos built-in (SHA, RSA, Ed25519, etc) porque:

- Adicionar sequências de bytes como tipo primitivo pesa no design da linguagem
- Algoritmos crypto evoluem (algoritmos pós-quânticos, novos padrões); strings de hash congelam linguagem
- Programador pode implementar qualquer algoritmo via biblioteca ou FFI sem mudança na linguagem
- Modelo challenge-response é mais geral: cobre hash, signature, MAC, validação contextual, qualquer coisa

Programador implementa validação na complexidade desejada: trivial em desenvolvimento, sofisticada em produção fintech.

**Exemplos de uso real:**

```ldp3
// Modo dev: validação simples por constantes internas
var a = unimport Dog expecting {
    return Dog.MAGIC_NUMBER * Dog.SECRET_SEED;
};

import Dog expecting a {
    return Dog.MAGIC_NUMBER * Dog.SECRET_SEED;
} onFailure {
    Console.println("desenvolvimento: código local mudou");
};

// Modo produção: validação com challenge randomizado
int challenge = Random.nextInt();
var b = unimport Plugin expecting using challenge {
    return Plugin.computeHMAC(challenge, Plugin.TRUSTED_KEY);
};

import Plugin expecting b using challenge {
    return Plugin.computeHMAC(challenge, Plugin.TRUSTED_KEY);
} onFailure {
    Logger.security("plugin reimport rejected", challenge);
    Plugin.quarantine();
    panic("plugin authentication failed");
};

// Modo eternal: validação que vive todo o programa
public eternal var dogProof = unimport Dog expecting {
    return Dog.computeFingerprint();
};

// Mais tarde, em qualquer momento do programa:
import Dog expecting dogProof {
    return Dog.computeFingerprint();
} onFailure {
    AuditLog.record(SecurityEvent.REIMPORT_FAILURE, "Dog");
    System.exit(1);
};
```

**Garantias de segurança:**

- Código no disco substituído por atacante não pode forjar validação sem replicar algoritmo interno do código original.
- Atacante precisa conhecer constantes privadas, métodos privados, e estrutura interna que o bloco de validação usa.
- Validação pode ser arbitrariamente complexa — programador escolhe nível de paranoia.

**O que não é prevenido:**

- Atacante que controla o processo em execução (debugger, dll injection) pode modificar tanto `a` quanto blocos.
- Atacante que substitui binário inicial do programa antes da execução.
- Defesas contra esses cenários precisam vir do sistema operacional ou hardware (TPM, secure enclaves).

### 30.19 Resumo do modelo

Unimport é poderoso e exige cooperação do runtime. O custo é aceito como parte da identidade da linguagem. O modelo segue quatro princípios:

1. **Unloading é agressivo, exceto pra persistents.** Persistents sobrevivem por design.
2. **Sincronização é implícita.** Compilador e runtime cuidam de threads ativas, construtores em andamento, async tasks pendentes, e callbacks FFI registrados.
3. **Programador pode forçar quando necessário.** `force`, `timeout`, `cascade` dão controle pra casos especiais.
4. **Validação de autenticidade é opt-in via challenge-response.** Programador define algoritmo via blocos de código; linguagem não impõe primitivos crypto.

---

## 31. Reflection

Namespace `reflect` provê APIs pra inspeção e manipulação em runtime:

```ldp3
Type t = reflect.typeOf<Dog>();
ArrayList<Method> methods = t.methods();
ArrayList<Field> fields = t.fields();

Dog d = cast<Dog>(t.instantiate("Rex", 5));
Method m = t.method("bark");
m.invoke(d, []);

ArrayList<Annotation> annotations = t.annotations();
```

Annotations customizadas são acessíveis via reflection.

---

## 32. Features adicionais

### 32.1 Operações reversíveis (stdlib)

Operações reversíveis são padrão suportado pela stdlib via interface genérica `Reversible<TArgs>`. Não há keywords `reversible`/`forward`/`backward`/`reverse` — programador implementa a interface explicitamente.

```ldp3
public interface Reversible<TArgs> {
    method forward(TArgs args) returns void;
    method backward(TArgs args) returns void;
}

public class MoveLeft implements Reversible<Car&> {
    public override method forward(Car& car) returns void {
        car.x = car.x - 1;
    }
    public override method backward(Car& car) returns void {
        car.x = car.x + 1;
    }
}

// Uso:
MoveLeft op = new MoveLeft() on heap;
op.forward(car);     // aplica operação
op.backward(car);    // reverte operação
```

Use cases (undo/redo, simulações com rollback, debugging time-travel) continuam viáveis. Stdlib pode fornecer auxiliares como `ReversibleStack<TArgs>` que rastreia operações e permite undo automático.

A abordagem via stdlib é mais verbosa que keyword dedicada mas usa apenas mecanismos existentes (interfaces, generics, classes). Linguagem fica mais simples sem perda de capability.

### 32.2 Memory snapshots (stdlib)

Captura e restauração de estado de regiões é fornecida via métodos da stdlib em `region`. Não há keywords `snapshot`/`restore`. Implementação interna pode usar copy-on-write.

```ldp3
region world = itself.allocate(64 megabytes);
// ... popula com estado ...

RegionSnapshot save1 = world.snapshot();

// ... modificações ...

world.restore(save1);   // estado volta ao momento do snapshot
```

`RegionSnapshot` é tipo da stdlib (`System.Memory.RegionSnapshot`). Snapshots são objetos first-class: podem ser passados, guardados em coleções, serializados pra disco via `Serializable`.

API completa:
- `region.snapshot()` returns `RegionSnapshot` — captura estado atual
- `region.restore(snap: RegionSnapshot)` returns `void` — restaura estado
- `RegionSnapshot.serialize()` returns `byte[]` — serializa pra persistência
- `RegionSnapshot.deserialize(bytes: byte[])` returns `RegionSnapshot` — desserializa

### 32.3 Type witnesses (stdlib)

Prova de tipo carregada como valor, eliminando casts repetidos em hot loops. Implementado via classe genérica `TypeWitness<T>` da stdlib, não via keyword.

```ldp3
TypeWitness<Dog> proof = TypeWitness.of<Dog>(animal);
if (proof != null) {
    proof.access().bark();
    proof.access().feed();
    // acesso direto, sem checagem de tipo repetida
}
```

Witnesses podem ser passados pra outros métodos, garantindo type-safety através de chamadas:

```ldp3
public method handleDog(TypeWitness<Dog> dogProof) returns void {
    dogProof.access().bark();   // 100% garantido
}
```

`TypeWitness<T>` é classe da stdlib (`System.Reflection.TypeWitness`). Método estático `TypeWitness.of<T>(obj)` retorna witness não-null se obj é de tipo T, null caso contrário.

### 32.4 Compile-time string DSLs

Funções marcadas com `comptime` em parâmetros string parseiam, validam, e geram código em tempo de compilação:

```ldp3
public comptime method query(comptime string sql) returns ResultSet { /* ... */ }

ResultSet rs = query("SELECT * FROM users WHERE id = ?");
// compilador parseia SQL, valida sintaxe, infere tipo do parâmetro,
// gera código que executa SEM parser em runtime
```

Aplicações: SQL validadas em compile-time, regex compiladas antes do programa rodar, format strings tipo-seguras, JSON pre-parseado.

### 32.5 Lifecycle hooks de classe

Hooks declarativos no nível da classe inteira, separados do construtor/destructor de instância:

```ldp3
public class Server {
    onClassLoad { Console.println("Server class carregada"); }
    onFirstInstance { startupGlobalState(); }
    onLastInstanceDestroyed { cleanupGlobalState(); }
    onClassUnload { releasePersistents(); }
}
```

Casos de uso: inicialização lazy global, cleanup quando todas as instâncias morrem, integração com unimport (`onClassUnload` roda no unload).

### 32.6 Bidirectional types

Propriedades que computam transformações pra ambas as direções:

```ldp3
public class Temperature {
    private double celsius;

    public bidirectional double fahrenheit {
        celsius to fahrenheit: celsius * 9.0 / 5.0 + 32.0;
        fahrenheit to celsius: (fahrenheit - 32.0) * 5.0 / 9.0;
    }
}

temp.fahrenheit = 100.0;   // converte e armazena em celsius
double f = temp.fahrenheit;   // lê celsius e converte
```

Aplicações: representações alternativas do mesmo dado (Celsius/Fahrenheit, radianos/graus, polar/cartesiano), units of measure.

### 32.7 Resource tokens (capability-based)

Recursos requerem tokens que provam permissão. Útil pra sandboxing, plugins limitados, separação de privilégios:

```ldp3
public method readFile(FileAccessToken token, String path) returns string { /* ... */ }

FileAccessToken token = system.requestFileAccess();
if (token != null) {
    string content = readFile(token, "config.json");
}
```

Combina com unimport: código de plugin pode ser carregado sem tokens privilegiados, restringindo o que pode fazer.

### 32.8 Mutable dispatch tables

Toda classe expõe `class.methods` como ArrayList<Method> mutável. Permite monkey-patching em runtime sem perder type safety:

```ldp3
Dog.methods.replace("bark", lambda(Dog d) returns void {
    Console.println("woof remix");
});
// todos os Dogs (existentes e futuros) tem novo bark
```

Aplicações: AOP genuíno, mocking de testes sem framework, hot patching localizado. Combina com unimport para hot reload de comportamento sem recompilação.

### 32.9 Affinity hints

Sugere ao compilador como organizar campos na memória pra otimizar cache locality:

```ldp3
public class Particle {
    public affinity hot {
        float x;
        float y;
        float z;
    }
    public affinity cold {
        string debugName;
        ArrayList<Tag> tags;
    }
}
```

Hot loop iterando partículas acessa só campos hot, beneficiando cache. Data-oriented design promovido a feature de linguagem.

### 32.10 Defer com garantias temporais

Variante de `defer` com janela máxima de tempo pra execução do cleanup:

```ldp3
public method handleConnection(Socket s) returns void {
    defer within milliseconds(100) { s.close(); }
    // se cleanup demora mais de 100ms, exception ou alert
}
```

Aplicações: soft real-time systems, jogos com frame budget, audio com deadline de buffer.

### 32.11 Inline tests via annotations + stdlib

Testes acompanham o código testado via annotations `@Test` e a stdlib `Test`. Não há keywords `tests`/`assert` — testes são apenas métodos anotados que usam métodos da stdlib `Test`.

```ldp3
public class MathUtils {
    public static method add(int a, int b) returns int {
        return a + b;
    }
    
    @Test
    public static method add_basic() returns void {
        Test.assertEqual(MathUtils.add(2, 2), 4);
        Test.assertEqual(MathUtils.add(0, 0), 0);
        Test.assertEqual(MathUtils.add(-1, 1), 0);
    }
}
```

A annotation `@Test` é fornecida pela stdlib (`System.Test.Test`). Métodos anotados são descobertos pela ferramenta `ldp3 test` que os executa.

Para funções puras, o compilador pode otimizar testes pra compile-time via `comptime`. Para funções com side effects, testes rodam em build-time/test-time.

API stdlib `Test`:
- `Test.assertEqual(actual, expected)` — assertion de igualdade
- `Test.assertTrue(condition)` — assertion booleana
- `Test.assertFalse(condition)` — assertion booleana negativa
- `Test.assertThrows<E>(action)` — assertion de exception
- `Test.assertWithin(actual, expected, tolerance)` — assertion de tolerância numérica

Testes acompanham o código, refactoring não perde testes, e o mecanismo usa apenas features existentes da linguagem (annotations, métodos estáticos, classes).

---

## 33. Comentários

```ldp3
// comentário de linha
/* comentário
   de bloco */
/// comentário de documentação (extraído por ferramentas)
```

---

## 34. Standard library

### 34.1 Coleções
`ArrayList<T>`, `LinkedList<T>`, `HashMap<K, V>`, `HashSet<T>`, `Stack<T>`, `Queue<T>`, `Deque<T>`, `TreeMap<K, V>`, `TreeSet<T>`

### 34.2 Strings
`String`, `string`, `StringBuilder`

### 34.3 I/O
`File`, `Stream`, `Reader`, `Writer`, `Console`, `Path`

### 34.4 Concorrência
`Thread`, `Mutex<T>`, `Channel<T>`, `Semaphore`, `Atomic<T>`

### 34.5 Tempo
`Instant`, `Duration`, `Calendar`, `LocalDate`, `LocalTime`

### 34.6 Math
`Math`, `Random`, `BigInteger`, `Decimal`

### 34.7 Net
`Socket`, `HttpClient`, `URL`

### 34.8 Reflect
namespace `reflect.*`

### 34.9 Resultados
`Result<T, E>`, `Option<T>`

### 34.10 Serialização
`Serializable`, `Json`, `Binary`

---

## 35. Build target

A LDP3 compila pra nativo via **LLVM**. Performance máxima é prioridade. A linguagem é de propósito geral, incluindo jogos.

### 35.1 Desafios de implementação conhecidos

Features que requerem runtime gerenciado e exigem trabalho de implementação em cima do alvo nativo:

- **Unimport / hot reload**: requer registry de tipos vivos, mini-linker em runtime pra carregar/descarregar code segments, mecanismo de patching pra rebind referências.
- **Reflection robusta**: metadata de tipos completo gerado em compile-time e empacotado no binário.
- **Persistents com reattach**: requer registry global de persistents órfãos chaveado por escopo + nome de variável.

Esses são pontos onde a implementação exigirá esforço significativo. A alternativa de VM customizada com JIT resolveria nativamente, mas a decisão foi LLVM pela performance.

---

## 36. Modo freestanding

LDP3 oferece dois modos de compilação:

- **Modo completo** (default) — toda a linguagem disponível, com runtime gerenciado para reflection, unimport, persistents, async, exceptions, e stdlib completa.
- **Modo freestanding** (flag `--freestanding`) — subset projetado pra rodar sem sistema operacional embaixo: kernels, bootloaders, firmware, hipervisores, embedded sem OS.

O modo freestanding existe porque sistemas operacionais e código bare-metal não toleram dependências escondidas de runtime — não há malloc, não há thread scheduler, não há filesystem, não há exception handler antes de você construir tudo isso.

### 36.1 Filosofia do modo freestanding

Princípio central: **nenhuma feature do modo freestanding gera chamadas escondidas a código de runtime**. Tudo o que executa em runtime corresponde diretamente a algo que o programador escreveu. Layout de memória é previsível. Não há alocação implícita. Não há background threads.

Isso é o equivalente moderno do que C/C++ oferecem em modo freestanding, com features adicionais que mantêm essa garantia.

### 36.2 Features disponíveis em modo freestanding

**Tipos primitivos completos** (todos):
- Inteiros bit-width: `int8`, `int16`, `int32`, `int64`, `uint8` até `uint64`
- Ponto flutuante: `float32`, `float64`
- Outros: `boolean`, `char`, `void`, `address`

**Estruturas de dados:**
- `class` — com OOP completa (herança, virtual, abstract, sealed)
- `struct` com bit fields — essencial pra hardware
- `record` — DTOs imutáveis
- `union` — interpretação alternativa de memória
- `enum` — incluindo Java-style com métodos
- `catalog` — interface pra enums

**Memória:**
- `new ... on stack` e `new ... on heap` (heap precisa de allocator implementado pelo próprio kernel)
- Regions nomeadas com `allocate`, `at address`, `accepts`/`rejects`
- Ponteiros `T*` e referências `T&`
- Aritmética de ponteiro
- API `Memory` com `read<T>`, `write<T>`, `getMemory`

**Controle de fluxo:**
- `if`, `else`, `while`, `do-while`, `for`, `foreach`
- `switch` com fall-through e `default`
- `match` com exhaustiveness pra sealed
- `break`, `continue`, `goto` (label no mesmo método, ou endereço/função em FFI)
- Ranges

**Tipos e abstração:**
- `interface` com métodos abstratos e default
- Generics com constraints e variance
- `typealias` e `newtype`
- `partial` classes
- Operator overloading

**Compile-time:**
- `const` e `static_assert`
- `comptime` functions
- Compile-time string DSLs

**Pra kernel especificamente:**
- FFI com `extern cdecl`/`stdcall`/`fastcall`
- Inline assembly (pendente formalização — issue aberta)
- Bit fields em struct com layout previsível
- Endereçamento direto via region `at address`
- `volatile` em campos
- Calling conventions explícitas

**Features de qualidade de vida que não geram runtime:**
- Pattern matching exaustivo
- Contracts (`requires`, `ensures`, `invariant`) — checagem em compile-time onde possível, sem custo runtime quando não
- Type witnesses
- Bidirectional types
- Affinity hints
- Defer (estático, sem unwinding)
- Named arguments
- Type inference em locais
- String interpolation (sem alocação dinâmica de String)
- Imutabilidade por default (`mutable` explícito)
- Modificadores de acesso (`public`, `private`, `protected`, `internal`)
- Lifecycle hooks de classe (`onClassLoad`, `onFirstInstance`, etc — usados pra inicialização estática)

### 36.3 Features removidas em modo freestanding

Cada remoção tem justificativa técnica clara:

**Exceptions completas (`try`/`catch`/`finally`/`throw`/`throws`)**
- Razão: stack unwinding exige tabelas de unwinding em runtime, lookup dinâmico, e código de cleanup gerado pelo compilador.
- Alternativa em freestanding: `Result<T, E>` e `Option<T>` continuam disponíveis, agora como mecanismo único de tratamento de erro.

**Reflection (`reflect.*`)**
- Razão: exige metadata gigantesco em runtime (tabelas de tipos, nomes de métodos como strings, parâmetros, anotações). Kernel não tem espaço pra isso.
- Alternativa: nenhuma direta. Código de kernel não precisa inspecionar tipos dinamicamente.

**Unimport e hot reload (`unimport`, reimport)**
- Razão: exige registry de tipos vivos em runtime, mini-linker que carrega e descarrega code segments. Antes do kernel estar de pé, ninguém pode fazer isso.
- Alternativa: nenhuma. Em kernel, código é estático após o boot.

**Persistents (`persistent`, `release persistent`)**
- Razão: dependem de registry global indexado pela tripla `(escopo, nome, region)`, mutex implícito, lookup em runtime.
- Alternativa: campos `static` normais cobrem o caso de "valor que persiste enquanto programa roda".

**Async/await (`async`, `await`)**
- Razão: exige scheduler de worker threads gerenciado pela linguagem. Mas o kernel é quem implementa schedulers; não pode depender de um.
- Alternativa: threads cruas (do próprio kernel) e channels (se implementados sem dependência de runtime).

**Annotations customizadas em runtime**
- Razão: leitura de annotations customizadas exige reflection.
- Alternativa: annotations existem em compile-time (incluindo `[CompileTimeProcessor]`). Só não podem ser lidas em runtime.

**Stdlib gerenciada inteira**
- `ArrayList`, `HashMap`, `LinkedList`, `Stack`, `Queue`, `Deque`, `TreeMap`, `TreeSet`
- `String` (a classe imutável), `StringBuilder`
- `File`, `Stream`, `Reader`, `Writer`, `Console`, `Path`
- `Thread`, `Mutex<T>`, `Channel<T>` (versões gerenciadas), `Semaphore`, `Atomic<T>`
- `Instant`, `Duration`, `Calendar`, `LocalDate`, `LocalTime`
- `BigInteger`, `Decimal`
- `Socket`, `HttpClient`, `URL`
- `Json`, `Binary`, `Serializable`

- Razão: dependem de alocação dinâmica, sistema operacional, ou ambos.
- Alternativa: kernel implementa suas próprias estruturas de dados em cima dos primitivos disponíveis.

**Inline tests (`tests { }`)**
- Razão: framework de tests precisa de runtime pra coleta e relatório.
- Alternativa: tests em compile-time via `static_assert` cobrem casos puros.

**Reversible methods, memory snapshots, mutable dispatch tables, lazy initialization, resource tokens**
- Razão: todas dependem de tracking em runtime ou metadata dinâmica.
- Alternativa: não há substituto direto; código de kernel não precisa dessas abstrações.

**Lambdas com captura dinâmica**
- Razão: closures com capture exigem alocação no heap. Lambdas sem capture podem virar function pointers — essas continuam permitidas.

**Bundles cross-program e IPC**
- Razão: IPC depende de OS rodando.
- Alternativa: bundles internos continuam funcionando como unidade de compilação dentro do kernel.

### 36.4 Restrições adicionais em modo freestanding

Mesmo com features mantidas, o modo freestanding adiciona regras:

**Sem alocação implícita.** Operações que normalmente alocam (concatenação de string com `+`, criação de array via literal `[1, 2, 3]`) ou geram erro de compilação ou exigem region explícita.

**Globais limitadas a literais e expressões const.** Variáveis globais que exigem código de inicialização (chamada de construtor não-trivial) são proibidas — não há mecanismo de "static constructor" rodando antes de `main`. Lifecycle hooks `onClassLoad` rodam no boot, mas ordem é determinada pelo programador via setup explícito.

**Sem chamadas escondidas a runtime do compilador.** Operações como divisão de 64-bit em arquiteturas 32-bit normalmente viram chamadas a funções de runtime (`__udivdi3` etc). Em freestanding, o compilador erra e exige implementação explícita ou uso de intrinsics.

**Bounds checking opcional via annotation.** Por default, arrays têm bounds checking em runtime mesmo em freestanding. Pra hot paths, annotation `[[no_bounds_check]]` em método ou bloco desabilita.

**Sem overflow checking automático.** Em modo freestanding, overflow numérico é wrap-around por default (sem custo). Pra checagem explícita, usar `checked(x + y)`.

### 36.5 Lista de keywords em modo freestanding

Keywords removidas em modo freestanding:

```
async  await  catch  delegate  finally  lazy
persistent  release
throw  throws  try
unimport  using
within
onClassUnload  onLastInstanceDestroyed
```

Keywords mantidas (subset essencial):

```
abstract  address  affinity  annotation  as
boolean  break  bundle  byCatalog
case  cast  catalog  class  cold  comptime  const  constructor  continue
default  defer  delete  deprecated  destructor  do
else  ensures  enum  extends  extern
false  final  for  from  function
get  goto
hot
if  implements  import  in  index  init  into  itself
int8  int16  int32  int64  uint8  uint16  uint32  uint64  float32  float64
interface  internal  invariant  is
lambda  library  literal
match  method  module  movable  move  mutable
namespace  new  newtype  null
of  old  on  onClassLoad  onFirstInstance  operator  out  override
package  partial  partitionable  permits  private  program  protected  public
record  region  requires  return  returns
sealed  serializable  set  short  static  static_assert
step  string  String  struct  super  switch  synchronized
this  transient  true  typealias
union  unique  var  version  void  volatile
while  yield
bidirectional  to
cdecl  stdcall  fastcall
```

### 36.6 Comparação numérica

| Categoria | Modo completo | Modo freestanding |
|-----------|---------------|-------------------|
| Keywords principais | 133 | 112 |
| Contextual keywords | 13 | 10 (algumas keywords promovidas a contextuais; `carrying`/`leaving`/`releasing` removidas com persistents) |
| Stdlib types | ~50 | 0 (kernel implementa suas próprias) |
| Features de runtime | ~25 | 0 |
| Features compile-time | ~30 | ~28 |
| Features de tipo | ~15 | ~15 |

Modo freestanding tem **115 keywords principais** versus 133 do completo — redução de 14%. Cada keyword removida tem razão técnica clara, não corte arbitrário. As 18 keywords removidas correspondem exatamente às features que dependem de runtime gerenciado: exceptions (5), persistents (2), async (2), unimport (2), lazy (1), using (1), defer com timeout (1), lifecycle hooks dinâmicos (2), within (1). Reduções adicionais vêm de features que foram migradas pra stdlib na v1.0 (reversible methods, snapshots, witnesses, tests, threads, channels, select, aritmética alternativa) e portanto não existem como keywords em modo nenhum. A tétrade do caos (`goto`/`comefrom`/`abstainfrom`/`reinstate`) **permanece em freestanding**: nenhuma depende do runtime gerenciado (branches em compile-time + um reference counter atômico global), e abstainfrom é peça-chave de power management em kernel/embedded.

As keywords de ownership (`move`, `movable`, `unique`, `partitionable`, `into`) são **mantidas** em modo freestanding porque são compile-time only. Os qualificadores contextuais `carrying`, `leaving`, `releasing` são **removidos** porque dependem de persistents (que não existem em freestanding).

### 36.7 Comparação com outras linguagens em modo bare-metal

| Linguagem | Modo bare-metal | Features OOP | Bit fields | Type-safe regions | Pattern matching exaustivo | Generics |
|-----------|-----------------|--------------|------------|-------------------|----------------------------|----------|
| C | Sim (default) | Não | Sim (não-portável) | Não | Não | Macros |
| C++ freestanding | Sim (`-ffreestanding`) | Sim | Sim (não-portável) | Não | Não | Templates |
| Rust `no_std` | Sim | Limitado (traits) | Via crates | Não | Sim | Sim |
| Zig (default) | Sim | Não | Sim | Não | Sim | Sim (comptime) |
| **LDP3 freestanding** | **Sim** | **Sim completo** | **Sim, layout previsível** | **Sim, nativo** | **Sim** | **Sim com variance** |

LDP3 freestanding combina OOP completo (que Rust e Zig não têm) com regions type-safe (que ninguém tem) e bit fields previsíveis (que só C/C++ têm, com restrições). Para escrita de kernel novo onde organização orientada a objetos faz sentido (drivers, subsistemas, abstração de hardware), é proposta única.

### 36.8 Flag de compilação e arquivo de bundle

Modo freestanding é ativado por:

```
ldp3 build --freestanding --target=x86_64-unknown-none --output=kernel.elf
```

Bundles compilados em modo freestanding geram artefatos compatíveis: `.ldb` em formato ELF bare-metal, sem dependências dinâmicas, sem linker scripts assumindo libc.

Programs e bundles podem declarar requisito de modo:

```ldp3
program myKernel freestanding;

public bundle boot freestanding {
    // ...
}
```

Com a declaração `freestanding`, o compilador erra se qualquer feature não-freestanding é usada, mesmo sem a flag de linha de comando. Isso garante que código de kernel não usa acidentalmente algo de runtime.

### 36.9 Hello world em modo freestanding (kernel mínimo)

```ldp3
program tinyKernel freestanding;

public bundle main freestanding {

    public namespace boot {

        // mapeia VGA text buffer com type safety
        public region vga_text = itself.at(0xB8000, 4000 bytes).accepts({VGAChar});

        public struct VGAChar {
            public mutable uint8 character;
            public mutable uint8 attribute;
        }

        public class Main {

            public static method main(string[] args) returns int {
                // escreve "Hi!" no VGA buffer diretamente
                VGAChar* buffer = cast<VGAChar*>(0xB8000);
                buffer[0] = new VGAChar() in region vga_text;
                buffer[0].character = 'H';
                buffer[0].attribute = 0x0F;
                buffer[1] = new VGAChar() in region vga_text;
                buffer[1].character = 'i';
                buffer[1].attribute = 0x0F;
                buffer[2] = new VGAChar() in region vga_text;
                buffer[2].character = '!';
                buffer[2].attribute = 0x0F;

                // loop infinito (kernel não retorna)
                while (true) { }

                return 0;
            }
        }
    }
}
```

Esse kernel mínimo, compilado com `--freestanding`, gera ELF de menos de 1KB que pode ser carregado por bootloader (GRUB com Multiboot, ou direto via QEMU `-kernel`). Demonstra: region com endereço direto + accepts, ponteiros, structs com layout previsível, acesso direto a hardware (VGA buffer), tudo em código orientado a objetos sem perder controle low-level.

---

## 37. Prefixos universais

LDP3 promove seis keywords a **prefixos universais** — modificadores aplicáveis a qualquer declaração ou operação compatível na linguagem. Cada prefixo tem semântica consistente independente do contexto onde é aplicado, criando vocabulário composicional que expressa intenções sofisticadas sem necessidade de keywords especializadas.

Os seis prefixos universais são: `cascade`, `eternal`, `lazy`, `comptime`, `volatile`, `final`.

### 37.1 `cascade` — propagação por dependências

Sintaxe: `cascade <operação>;`

Executa a operação propagando-a recursivamente através das dependências/referências do alvo.

```ldp3
cascade delete player;                  // delete player + tudo owned
cascade release persistent session;     // release todos os persistents do session
cascade unimport Dog;                   // unimport Dog + subclasses + monomorfizações
cascade Console.println(player);        // println do player + filhos recursivamente
cascade clone source into dest;         // deep clone
cascade snapshot of region world;       // snapshot incluindo regions referenciadas
cascade validate(player);               // valida player + filhos
cascade map(items, transform);          // aplica transform recursivamente
cascade reverse player.move();          // reverte cadeia de moves reversíveis
```

**Regras de propagação:**

1. Cascade segue **composição** (campos owned), não associação (referências externas). Campos marcados `external` ou ponteiros pra fora são pulados.
2. Cycle detection é automática. Runtime detecta ciclos e pula objetos já visitados.
3. Cascade respeita visibilidade. Não atravessa campos `private` em classe externa.
4. Operações suportam cascade implementando a interface `Cascadable<T>`. Operações que não implementam são erro de compilação ao receber prefixo cascade.

**Parâmetros opcionais:**

```ldp3
cascade(depth: 3) delete tree;                       // limita profundidade
cascade(unlimited) delete tree;                       // sem limite (default)
cascade(types: {Item, Pet}) delete inventory;        // só propaga em tipos listados
cascade(except: {World}) delete player;              // propaga exceto em tipos listados
cascade(depth: 2, except: {Pet}) clone player;       // combinações
```

### 37.2 `eternal` — vida durante todo o programa

Sintaxe: `eternal <declaração>;`

Recurso vive durante toda a execução do programa. Compilador não exige cleanup explícito. Runtime libera no shutdown rodando destrutores.

```ldp3
eternal persistent int settings = 0;                                    // persistent eterno
eternal region globalCache = itself.allocate(64 megabytes);                    // region eterna
eternal thread monitor = new thread(lambda() returns void { /* ... */ }); // thread eterna
eternal Channel<Log> logger = new Channel<Log>(capacity: 1000);          // channel eterno
eternal static ArrayList<Player> players = new ArrayList<Player>();      // field estático eterno
eternal snapshot save = snapshot of region world;                        // snapshot eterno
```

Eternal sobrevive a unimport da classe declarante (ver 29.17). Path qualificado continua funcionando indefinidamente.

### 37.3 `lazy` — adia execução até primeiro acesso

Sintaxe: `lazy <declaração ou operação>;`

A operação ou inicialização não acontece imediatamente, e sim na primeira vez que o valor é acessado. Thread-safe por default via mutex implícito.

```ldp3
lazy Dog rex = new Dog("Rex");                       // só aloca no primeiro uso
lazy result = expensiveCalculation();                // só executa quando lido
lazy import Dog;                                      // só importa quando primeira instância criada
lazy region cache = itself.allocate(1 gigabytes);            // só aloca quando primeiro objeto entra
lazy thread monitor = startMonitor();                 // só inicia thread quando referenciada
lazy snapshot save = snapshot of region world;        // só captura quando solicitado
lazy comptime ArrayList<int> primes = computePrimes(1000);  // computa em compile-time mas só carrega quando acessado
```

**Aplicações reais:**

- Startup mais rápido (recursos pesados carregam sob demanda)
- Otimização automática de código não usado em build variants
- Imports lazy permitem programas iniciarem sem carregar deps opcionais

### 37.4 `comptime` — executa durante compilação

Sintaxe: `comptime <declaração ou expressão>;`

Operação executa durante a compilação, não em runtime. Zero overhead em runtime — valor calculado embutido no binário.

```ldp3
comptime method fibonacci(int n) returns int { /* ... */ }   // método compile-time
comptime int fib10 = fibonacci(10);                          // cálculo compile-time
comptime ArrayList<int> primes = computePrimes(1000);        // tabela em compile-time
comptime assert(BUFFER_SIZE > 0);                            // checagem compile-time
comptime String version = readFile("VERSION");                // leitura compile-time
comptime if (TARGET == "x86") { /* ... */ }                  // ramificação compile-time
```

**Aplicações reais:**

- Lookup tables pré-computadas, perfect hashes, jump tables
- Configuração baseada em build (paths, versão, target)
- Compile-time DSLs (regex compilada, SQL validada)
- Optimization hints validados estaticamente
- Inline tests que rodam durante build

### 37.5 `volatile` — não otimizável

Sintaxe: `volatile <declaração ou operação>;`

Compilador não pode otimizar essa operação assumindo que valores não mudam fora do controle dele. Leituras sempre fazem fetch real, escritas sempre fazem store real.

```ldp3
volatile int hardwareRegister = 0;                       // campo volatile
volatile result = Memory.read<int>(0x1000);              // leitura volatile
volatile method readSensor() returns int { /* ... */ }   // método sempre executado
volatile region mmio = itself.at(0xB8000, 4000 bytes);  // region não cacheada
```

**Aplicações reais:**

- Drivers de hardware (MMIO)
- Multithreading sem locks completos
- Embedded com interrupções
- Hardware registers que mudam fora do controle do programa

### 37.6 `final` — não modificável/sobrescrevível

Sintaxe: `final <declaração>;`

Recurso não pode ser modificado, sobrescrito, substituído ou removido. Garante imutabilidade estrutural.

```ldp3
final class Foo { /* ... */ }                            // não extensível
final method bar() returns void { /* ... */ }            // não overridable
final region world = itself.allocate(64 megabytes);             // não pode ser realocada
final thread monitor = startMonitor();                    // não pode ser substituída
final ArrayList<Item> inventory = new ArrayList<Item>(); // referência imutável (conteúdo mutável)
final import Dog;                                         // não pode ser unimportada
final eternal region kernelCode = itself.at(0x100000, 4 megabytes);  // combinado
```

`final import` é especialmente poderoso: impede `unimport` acidental ou malicioso. Programador declara "este import é permanente neste programa".

### 37.7 Composicionalidade

Prefixos podem ser combinados livremente quando semanticamente compatíveis. Compilador valida combinações e rejeita contradições.

```ldp3
eternal lazy region globalCache = itself.allocate(64 megabytes);
// region que vive pra sempre, mas só aloca quando primeiro objeto entra

eternal comptime int VERSION_HASH = computeHash(VERSION);
// constante computada em compile-time, persistente até fim do programa

final lazy thread monitor = startMonitor();
// thread iniciada sob demanda, não pode ser substituída

cascade lazy delete tree;
// delete propagado recursivamente, mas só quando necessário (lazy aqui pouco usual)

volatile comptime int MMIO_BASE = readConfig("base_addr");
// constante de hardware lida em compile-time, não cacheável em runtime

eternal final region kernelCode = itself.at(0x100000, 4 megabytes);
// region de kernel imutável durante todo programa

public eternal lazy final static persistent in region globalConfigCache
    HashMap<String, ConfigEntry> cache = loadInitialConfig();
// cache de configuração global: visível, eterno, lazy, imutável, estático,
// persistente entre unimports, alocado em região nomeada
```

### 37.8 Combinações inválidas

Combinações semanticamente contraditórias são erro de compilação:

- `mutable final` — contradição (mutável mas imutável)
- `persistent transient` — contradição (sobrevive ao destrutor mas não é serializado)
- `comptime volatile` — contradição (compile-time mas pode mudar em runtime)
- `comptime lazy` (em alguns contextos) — comptime já executa antes do runtime, lazy é redundante

Compilador emite mensagem clara identificando contradição:

```
error: 'mutable' e 'final' são modificadores contraditórios.
       'final' implica que o valor não pode ser modificado após inicialização.
       'mutable' permite reatribuição.
       Use apenas um.
```

### 37.9 Ordem composicional canônica

Pra garantir consistência visual e facilitar leitura, compilador impõe ordem canônica:

```
[annotations]
[visibilidade] [eternal] [lazy] [final] [comptime] [volatile] [cascade] [static] [mutable] [persistent|transient] [constant] [in region X]
<tipo> <nome> [= inicializador];
```

Outras ordens são rejeitadas com sugestão de correção:

```
error: ordem de modificadores incorreta.
       Encontrado: 'public static eternal lazy int x'
       Esperado:   'public eternal lazy static int x'
       Reorganize os modificadores conforme a ordem canônica.
```

Pra **operações** (não declarações), os prefixos que aplicam são `cascade`, `lazy`, `comptime`:

```
[cascade] [lazy] [comptime] <operação>;
```

### 37.10 A linguagem não obriga uso de prefixos

Prefixos universais são ferramentas opcionais. Programa simples nunca precisa encostar neles:

```ldp3
public class Calculator {
    public int sum(int a, int b) returns int {
        return a + b;
    }
}
```

Declaração mínima absoluta é tão simples quanto em qualquer linguagem moderna. Prefixos existem pra quando programador precisa expressar intenção precisa — não como obrigação.

Filosofia: **simples é simples, complexo é expressível**. Programador casual escreve código limpo. Programador especialista expressa intenções sofisticadas quando necessário. A linguagem cresce com o programador.

### 37.11 Comparação com outras linguagens

| Conceito | LDP3 | Outras linguagens |
|----------|------|-------------------|
| Propagação recursiva | `cascade` universal | SQL `ON CASCADE`, manual em geral |
| Vida = duração do programa | `eternal` universal | `static`, manual em geral |
| Adiamento de execução | `lazy` universal | Scala/Kotlin `lazy` (só vars), C# `Lazy<T>` (classe) |
| Compile-time evaluation | `comptime` universal | Zig `comptime` (universal), Rust `const fn` (limitado), C++ `constexpr` (limitado) |
| Não otimizável | `volatile` universal | C/C++/Java `volatile` (só campos) |
| Imutável estrutural | `final` universal | Java `final` (classes/métodos/campos), Kotlin `val` (vars) |

LDP3 é única em ter os seis conceitos como prefixos universais com semântica consistente. Zig chegou perto com `comptime`. Nenhuma outra linguagem fez algo similar com tantos conceitos.

---

## 38. Toolchain e ecossistema

### 38.1 CLI unificada: `ldp3`

Toda a toolchain vive em um único binário `ldp3` com subcomandos. Distribuição simples, PATH limpo, descoberta de comandos via `ldp3 --help`.

```
ldp3 --version                  versão do compilador
ldp3 run [arquivo.ldp3]         compila e executa; sem argumento, usa projeto atual
ldp3 build                      compila projeto inteiro (todos os bundles)
ldp3 compile arquivo.ldp3       compila arquivo específico sem executar
ldp3 plug nome                  baixa dependência pra packages/
ldp3 plug                       baixa todas as dependências do manifesto
ldp3 plug --update              atualiza todas as dependências
ldp3 plug --global ferramenta   instala binário globalmente (raro)
ldp3 unplug nome                remove dependência
ldp3 new nome-projeto           cria novo projeto com estrutura padrão
ldp3 init                       inicializa projeto no diretório atual
ldp3 test                       roda inline tests do projeto
ldp3 fmt [arquivo.ldp3]         formata código
ldp3 doc                        gera documentação HTML a partir de ///
ldp3 clean                      remove build-output/
ldp3 lsp                        (interno) inicia language server pra IDE
```

`ldp3 lsp` nunca é chamado diretamente pelo programador — apenas extensões de IDE invocam.

### 38.2 Vocabulário de comandos

LDP3 adota termos próprios pra comandos comuns, mantendo identidade da linguagem:

- `plug` / `unplug` — instalar / desinstalar dependência (em vez de `install`/`remove`)

A escolha de vocabulário próprio acompanha a estética da linguagem (bundles, catalogs, persistents, regions, unimport — todos termos com identidade).

### 38.3 Estrutura de projeto

Projeto LDP3 mínimo tem dois elementos: um arquivo de manifesto (`.toml`) e pelo menos um arquivo `.ldp3` contendo o entry point.

Estrutura completa recomendada:

```
meu_projeto/
├── projeto.toml         (manifesto; nome livre, identificado por estrutura)
├── src/                 (código fonte; opcional mas recomendado)
│   └── main.ldp3
├── packages/            (dependências baixadas; gitignored)
└── build-output/        (output do compilador; gitignored)
```

### 38.4 Manifesto

O manifesto declara metadata do projeto. Identificado pelo compilador via header `[ldp3_project]` na primeira linha (não pelo nome do arquivo). Compilador faz scan rápido sem iterar o arquivo inteiro.

```toml
[ldp3_project]

[program]
name = "meu_projeto"
version = "0.1.0"
language_version = "1.0"
entry = "src/main.ldp3"

[dependencies]
audio_lib = "1.2.0"           # versão exata
math_utils = ">=2.0.0"        # mínima
graphics = "^3.1.0"           # compatible range (3.x.x, não 4)
network = "~1.5.2"            # patch updates only (1.5.x)

[build]
output = "build-output/"
target = "x86_64-linux"
freestanding = false
```

**Múltiplos manifestos:** se a pasta contiver múltiplos arquivos com header `[ldp3_project]`, o compilador erra a menos que sejam **idênticos byte a byte** (caso útil pra backups ou duplicação acidental).

**Manifesto ausente:** compilador permite execução de arquivo isolado via `ldp3 run arquivo.ldp3`. Internamente cria manifesto efêmero com defaults: nome do arquivo como projeto, versão `0.0.0`, sem dependências, language_version igual à versão do compilador, entry = arquivo passado.

**Pasta `src/`:** não é obrigatória. Caminho do entry point é declarado no manifesto. Sem `src/`, programador pode apontar `entry = "main.ldp3"` direto. A pasta `src/` é recomendada por organização mas não imposta — evita que o compilador precise procurar o entry no programa inteiro.

### 38.5 Language version (editions)

Toda evolução incompatível da linguagem (mudança de sintaxe, semântica, ou keywords) gera nova `language_version`. Projetos declaram qual versão usam; compilador adapta seu comportamento à versão declarada.

```toml
[program]
language_version = "1.0"      # código segue regras da LDP3 1.0
```

Compilador novo (digamos 2.5) continua compilando código que declara `language_version = "1.0"`. Bibliotecas e código antigos não quebram quando linguagem evolui. Modelo seguindo Rust editions.

`language_version` é obrigatório em projetos com manifesto. Em arquivos isolados (sem manifesto), usa a versão default do compilador.

### 38.6 Gerenciamento de dependências via Git

`ldp3 plug` resolve dependências via Git, sem registry central. Sem infraestrutura de hospedagem; nomes resolvem pra URLs Git.

```
ldp3 plug audio_lib                          # nome curto: resolve via convenção
ldp3 plug github.com/usuario/audio_lib       # URL Git explícita
ldp3 plug github.com/usuario/audio_lib@1.2.0 # com tag de versão
ldp3 plug gitlab.com/grupo/lib               # qualquer host Git
```

Nomes curtos como `audio_lib` resolvem via mapeamento que pode ser configurado em arquivo global `~/.ldp3/sources.toml` ou cair pra default (a definir — GitHub por convenção inicial).

Versões correspondem a tags Git no repositório. Sem tag, usa último commit do branch default.

Dependências são instaladas em `packages/` do projeto, isoladas por projeto (não globais). Evita conflitos entre versões usadas em projetos diferentes.

Quando comunidade crescer e registry central oficial fizer sentido, migração pode ser feita preservando compatibilidade com Git URLs.

### 38.7 Integração com IDEs via LSP

LDP3 suporta IDEs via Language Server Protocol. Funcionamento é plug-and-play do ponto de vista do usuário:

1. Programador instala extensão LDP3 no VS Code (ou outro IDE com suporte LSP) via marketplace.
2. Programador abre arquivo `.ldp3`.
3. Extensão automaticamente invoca `ldp3 lsp` em background.
4. IntelliSense, autocomplete, hover, diagnostics, goto definition aparecem sem configuração adicional.

Programador nunca executa `ldp3 lsp` diretamente.

**Features LSP da v1:**

- Diagnostics (errors/warnings em tempo real)
- Hover (tipos e documentação ao passar mouse)
- Go to definition
- Autocomplete básico (membros, escopo)
- Document symbols (outline)
- Syntax highlighting via TextMate grammar

**Features LSP de v2+:**

- Find all references
- Rename refactoring
- Code actions / quick fixes
- Inlay hints (tipos inferidos visíveis inline)
- Semantic highlighting
- Snippets

### 38.8 Debug Adapter Protocol (futuro)

Debugger via DAP (Debug Adapter Protocol) fica planejado pra v2 do toolchain. Permite breakpoints, step-by-step, inspeção de variáveis em IDEs com suporte. v1 do toolchain pode contar com debugging via `Console.println` e logs.

### 38.9 IDE próprio

Eventualmente um IDE dedicado pra LDP3 pode ser desenvolvido, com features específicas que IDEs genéricos não oferecem nativamente: visualização de regions e seus conteúdos, inspeção de persistents órfãos, hot reload via unimport sem reiniciar processo, debugger de kernel em modo freestanding. Pra v1, integração com VS Code via LSP é suficiente.

---

## 39. Lista de keywords

LDP3 tem **133 keywords principais** + **13 contextuais** + **20 tipos primitivos** (também keywords reservadas).

Para o catálogo completo com explicação de cada keyword, exemplos de uso, regras de combinação, e ordem canônica de modificadores, consulte o documento separado `LDP3_keywords.md`.

### Resumo numérico

| Categoria | Quantidade |
|-----------|------------|
| Keywords principais | 133 |
| Contextual keywords | 13 |
| Tipos primitivos (também keywords) | 20 |
| Modo freestanding | 115 keywords |

### Prefixos universais

Seis keywords funcionam como prefixos universais com semântica consistente em qualquer contexto compatível:

- `cascade` — propagação recursiva por dependências
- `eternal` — vida igual à do programa
- `lazy` — adia execução até primeiro acesso
- `comptime` — executa em compile-time
- `volatile` — não otimizável
- `final` — não modificável/sobrescrevível/removível

Composição livre quando semânticamente compatíveis. Compilador valida combinações.

### Contextual keywords

Reservadas apenas em contextos específicos: `byCatalog`, `address`, `cdecl`, `stdcall`, `fastcall`, `hot`, `cold`, `to`, `force`, `timeout`, `carrying`, `leaving`, `releasing`.

### Identifiers reservados pela stdlib

`Memory`, `System`, `Console` — módulos da stdlib não devem ser usados como identificadores.

---

## 40. Issues abertas / pendências pra próxima iteração

1. **Inline assembly** — indefinido após remoção de `unsafe`. Decisão sugerida: bloco `asm("x86_64") { }` direto.
2. **Decimal** — listado na stdlib. Confirmar se é classe ou tipo primitivo.
3. **Memory ordering atômico** (`acquire`, `release`, `seqcst`) — adiar pra v2.
4. **Goto pra número de linha** — RESOLVIDO: removido (frágil sob refactoring + atravessa fronteiras; a tétrade é intra-method). Use labels.
5. **Pointer arithmetic com warning** — definir quando warning é emitido (todos os casos? só ponteiros de classe?).
6. **Stdlib pra jogos** — Vector2/3/4, Matrix, Quaternion, Color, Audio, Path utilities a confirmar.
7. **Sintaxe `Type.sizeof()`** vs `sizeof(Type)` — código de exemplo usa as duas; padronizar uma.
8. **Resolução de construtor com parâmetros parciais** — quando enum/argumento omitido casa com persistent pelo nome, definir regra precisa pra casos ambíguos (múltiplos persistents com nomes parecidos, overloading de construtor).
9. **Persistents em containers** — identidade é `(escopo, nome do container, índice, region)`. Confirmar comportamento ao redimensionar containers e ao remover elementos do meio (índices deslizam ou não?).
10. **`positionOf(...)` builtin** — função global apareceu no código de exemplo; documentar assinatura e semântica.
11. **Precisão da análise de warning de persistent leak** — análise global interprocedural é cara. Definir limite prático (toda a codebase? só o módulo atual? análise on-demand?). Definir comportamento quando persistent é exportado pra outro programa via bundle público.
12. **Formato `.ldb` e `.ldh`** — especificar formato binário do bundle compilado e do header de ABI. Considerar metadata embutida (versão, fingerprint, dependências, capabilities exigidas).
13. **Protocolo IPC pra cross-program access** — definir mecanismo de serialização, descoberta de programs (`Program.connect(...)`), autenticação, e tratamento de falhas de rede/processo. Performance vs portabilidade vs segurança.
14. **Resolução de versão de bundle** — quando program declara `requires bundle audio version >= 1.2.0`, e em runtime estão disponíveis 1.2.0 e 1.5.0, qual é escolhida? Sempre a mais alta compatível? Configurável? Pinning?
15. **Build system pra build variants** — ferramenta de linha de comando pra montar builds com conjuntos específicos de bundles (`ldp3 build --variant=lite`, `ldp3 build --include=audio,video --exclude=plugins`). Não é design da linguagem em si mas é necessário pra viabilizar a feature.

---

## 41. Plano de implementação

### 41.1 Decisões de implementação

- **Linguagem de implementação:** C++20
- **Backend:** LLVM 17+
- **Target inicial:** Windows x86_64 (com MSVC + Visual Studio 2022 Community)
- **Build system:** CMake
- **Dependências:** LLVM via vcpkg ou build manual
- **Versionamento:** Git

### 41.2 Alvo da primeira release (Release 0.1)

**Objetivo concreto:** Implementar tic-tac-toe completo em LDP3 usando OOP + manual memory + regions.

Features mínimas necessárias para esse alvo:

**Lexer:**
- Todos os tokens necessários para subset usado em tic-tac-toe
- Aproximadamente 40-50 keywords (subset)
- Identificadores, literais (int, string), operadores, pontuação
- Comentários `//` e `/* */`

**Parser:**
- Declaração de program, bundle, namespace
- Declaração de class com campos, construtores, destrutores, métodos
- Modificadores: public, private, mutable, static
- Type system básico: primitivos, ponteiros, arrays, classes
- Statements: declaração de variável, atribuição, if/else, while, return
- Expressions: literais, identificadores, member access, method calls, operadores
- Region declaration e release
- Enum declaration

**Semantic analyzer:**
- Symbol table com scope resolution
- Type checking
- Validação de visibility
- Validação de mutable methods
- Validação de region types (accepts/rejects)

**Codegen LLVM:**
- Tipos primitivos mapeando para LLVM types
- Classes como struct + vtables simples
- Métodos como funções com `this` como primeiro parâmetro
- Allocação on stack (alloca)
- Allocação on heap (call malloc)
- Allocação in region (call para region allocator)
- Delete (call free ou region deallocator)
- Method dispatch
- String handling básico
- Builtin `System.IO.printf` que gera call para printf da libc

**Runtime mínimo:**
- Region implementation (arena allocator)
- String type básico

### 41.3 Estimativa de tempo

Com 20h semanais consistentes:

- **Mês 1:** Setup + Lexer
- **Mês 2-3:** Parser
- **Mês 4-5:** Semantic analyzer
- **Mês 6-7:** Codegen LLVM básico
- **Mês 8:** Runtime + Regions
- **Mês 9:** Builtin printf + integration + testing
- **Mês 10:** Tic-tac-toe funcionando end-to-end

Total: **10 meses** para Release 0.1 funcional.

### 41.4 Milestones futuros

- **Release 0.2:** Generics com variance, pattern matching, sealed, catalogs, interfaces, bidirectional types. Suporte multi-arquitetura (Linux x86_64 adicional).
- **Release 0.3:** Stdlib expandida (ArrayList, HashMap, File I/O), threads e mutex básicos.
- **Release 0.4:** Modo freestanding completo. Capacidade de escrever kernel.
- **Release 0.5:** Persistents implementados.
- **Release 0.6:** Unimport implementado com validação via expecting.
- **Release 0.7:** Async/await, channels, select.
- **Release 0.8:** Reflection, lifecycle hooks dinâmicos.
- **Release 0.9:** Bundles com partial compilation, build variants.
- **Release 1.0:** Linguagem completa funcional, LSP, formatter, doc generator.

### 41.5 Estrutura sugerida do projeto

```
ldp3-compiler/
├── CMakeLists.txt
├── README.md
├── docs/
│   ├── architecture.md
│   └── design-decisions.md
├── src/
│   ├── lexer/
│   │   ├── token.h
│   │   ├── lexer.h
│   │   └── lexer.cpp
│   ├── parser/
│   │   ├── ast.h
│   │   ├── parser.h
│   │   └── parser.cpp
│   ├── semantic/
│   │   ├── analyzer.h
│   │   ├── symbol_table.h
│   │   ├── type_system.h
│   │   └── analyzer.cpp
│   ├── codegen/
│   │   ├── codegen.h
│   │   └── codegen.cpp
│   ├── driver/
│   │   ├── compiler.h
│   │   └── compiler.cpp
│   └── cli/
│       └── main.cpp
├── runtime/
│   ├── region.h
│   ├── region.cpp
│   ├── string.h
│   └── string.cpp
├── stdlib/
│   └── (futuro: bibliotecas em LDP3)
├── tests/
│   ├── unit/
│   ├── integration/
│   └── samples/
│       ├── hello_world.ldp3
│       └── tic_tac_toe.ldp3
└── tools/
    └── (futuro: ldp3-fmt, ldp3-lsp, ldp3-doc)
```

### 41.6 Princípios de implementação

1. **Correção antes de performance.** Primeira versão pode ser lenta. Otimizar depois.
2. **Testes desde dia 1.** Cada componente tem testes unitários.
3. **Mensagens de erro de qualidade.** Source location tracking desde início.
4. **Documentação à medida que implementa.** Não deixa pra depois.
5. **Commits frequentes.** Histórico granular ajuda debugging.
6. **Não implementa features que não usa.** Foco no alvo atual.
7. **Refactor sem medo.** Primeira versão sempre é refeita.

### 41.7 Recursos de referência

- LLVM Kaleidoscope Tutorial (llvm.org/docs/tutorial)
- Crafting Interpreters (Bob Nystrom, gratuito online)
- Engineering a Compiler (Cooper & Torczon)
- LLVM Programmer's Manual
- Código fonte do Clang (para padrões)

---

## 42. Notas finais

Esta especificação representa LDP3 v1.0 — versão completa pronta para implementação. Mudanças incompatíveis no design futuro devem incrementar versão da linguagem (declarada em `language_version` no manifesto de projeto).

Issues abertas listadas na seção 40 são detalhes técnicos que podem ser resolvidos durante implementação sem afetar design central.

LDP3 é projeto pessoal de João Tavares. Implementação será desenvolvida em Windows x86_64 inicialmente, com expansão para outras plataformas em releases futuros.

**Filosofia central:** Simples é simples, complexo é expressível. A linguagem cresce com o programador. Features avançadas existem para quem precisa, sem onerar quem não precisa.

**Fim da especificação.**
