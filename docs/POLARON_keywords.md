# Polaron — Catálogo Completo de Keywords

Documento de referência para todas as keywords da linguagem Polaron.

> Escrito quando a linguagem ainda tinha o nome provisório **LDP3**, e com exemplos que em vários
> pontos contradizem a especificação — quando divergirem, vale
> [`POLARON_specification.md`](POLARON_specification.md), e a referência pública atualizada é
> [`docs/reference/`](reference/README.md).

**Total:** 133 keywords principais + 13 contextuais + 20 tipos primitivos (também keywords).

**Modo freestanding:** 112 keywords (remove 21 dependentes de runtime managed; mantém keywords de ownership, `itself`, `literal` que são compile-time only). Note que 19 keywords da versão original foram migradas pra stdlib na v1.0 e portanto não existem em modo nenhum (15 da rodada anterior + `allocate`, `at`, `kilobytes`, `megabytes`).

---

## Índice

- [Keywords principais por categoria](#keywords-principais-por-categoria)
- [Keywords em ordem alfabética](#keywords-em-ordem-alfabética)
- [Contextual keywords](#contextual-keywords)
- [Tipos primitivos](#tipos-primitivos)
- [Identifiers especiais reservados pela stdlib](#identifiers-especiais-reservados-pela-stdlib)
- [Prefixos universais](#prefixos-universais)
- [Keywords removidas em modo freestanding](#keywords-removidas-em-modo-freestanding)
- [Combinações válidas e inválidas](#combinações-válidas-e-inválidas)
- [Ordem composicional canônica](#ordem-composicional-canônica)

---

## Keywords principais por categoria

### Organização e estrutura

| Keyword | Função |
|---------|--------|
| `program` | Outermost organizacional unit, declaração de programa |
| `bundle` | Unidade de compilação independente |
| `namespace` | Organização lógica dentro de bundle |
| `class` | Declara classe |
| `interface` | Declara interface |
| `enum` | Declara enumeração |
| `catalog` | Interface para enums |
| `struct` | Tipo composto value-type |
| `record` | Tipo imutável tipo DTO |
| `union` | Tipo união |
| `module` | Reservada para uso futuro |
| `package` | Reservada para uso futuro |
| `library` | Reservada para uso futuro |
| `partial` | Declaração parcial de classe |

### Visibilidade

| Keyword | Função |
|---------|--------|
| `public` | Acessível de qualquer lugar |
| `private` | Acessível apenas dentro da classe declarante |
| `protected` | Acessível pela classe e subclasses |
| `internal` | Acessível apenas dentro do mesmo bundle |

### Métodos e funções

| Keyword | Função |
|---------|--------|
| `method` | Declara método em classe |
| `constructor` | Método especial de criação |
| `destructor` | Método especial de destruição |
| `returns` | Sintaxe de tipo de retorno |
| `return` | Retorna valor de método |
| `function` | Reservada para uso futuro |
| `delegate` | Tipo de referência a método |
| `lambda` | Função anônima |
| `operator` | Declara operator overload |
| `override` | Sobrescreve método de superclasse |
| `abstract` | Método sem implementação |
| `static` | Pertence à classe, não a instâncias |
| `this` | Referência à instância atual |
| `super` | Referência a superclasse |

### Memória manual

| Keyword | Função |
|---------|--------|
| `new` | Alocação de instância |
| `delete` | Liberação de memória |
| `on` | Especifica local de alocação (stack/heap) |
| `in` | Em region (`in region X`) ou foreach |
| `region` | Tipo nativo — porção nomeada de memória com type acceptance |
| `accepts` | Tipos aceitos por region (sintaxe `.accepts({...})`) |
| `rejects` | Tipos rejeitados por region (sintaxe `.rejects({...})`) |
| `release` | Libera persistent ou region |
| `of` | Disambiguação em regions |

> Nota: `allocate`, `at`, `kilobytes`, `megabytes` foram migrados pra stdlib. `region.allocate(N kilobytes)` e `region.at(addr, N bytes)` são métodos do tipo nativo `region`. Sufixos de tamanho (`bytes`, `kilobytes`, ... `exabytes`) são literal suffixes da stdlib `System.Memory.Units`. Ver seções 17.2-17.10 da spec.

### Ownership e disciplinas

| Keyword | Função |
|---------|--------|
| `movable` | Disciplina de classe — exige `move` explícito para transferência |
| `unique` | Disciplina de classe — uma única referência viva por vez no programa |
| `partitionable` | Permite move parcial de campos individuais (opt-in) |
| `move` | Transferência explícita de ownership entre variáveis, regions, ou tipos |
| `into` | Preposição em move (combina ownership + region em operação única) |

### Mutabilidade e lifecycle

| Keyword | Função |
|---------|--------|
| `mutable` | Permite modificação |
| `const` | Constante de compile-time |
| `persistent` | Sobrevive ao destrutor do objeto pai |
| `transient` | Não-serializável |
| `volatile` | Não otimizável (prefixo universal) |
| `final` | Não modificável/sobrescrevível (prefixo universal) |

### Prefixos universais

| Keyword | Função |
|---------|--------|
| `cascade` | Propagação recursiva por dependências |
| `eternal` | Vida igual à do programa |
| `lazy` | Adia execução até primeiro acesso |
| `comptime` | Executa em compile-time |
| `volatile` | Não otimizável pelo compilador |
| `final` | Não modificável/sobrescrevível/removível |

### Controle de fluxo

| Keyword | Função |
|---------|--------|
| `if` | Condicional |
| `else` | Cláusula em if-else |
| `while` | Loop while |
| `do` | Loop do-while |
| `for` | Loop for tradicional |
| `break` | Sai do loop ou switch |
| `continue` | Próxima iteração |
| `switch` | Switch tradicional com fall-through |
| `case` | Cláusula em switch ou match |
| `default` | Cláusula default |
| `match` | Pattern matching exaustivo |
| `goto` | Salto para label ou linha |
| `comefrom` | Interceptação inversa de fluxo (respeita encapsulamento) |
| `abstainfrom` | Desativa label e bloco subsequente (respeita encapsulamento) |
| `reinstate` | Reativa label previamente abstained |
| `index` | Em foreach com índice |
| `step` | Step customizado em range |
| `yield` | Em generators |

### Tipos

| Keyword | Função |
|---------|--------|
| `var` | Type inference |
| `void` | Sem retorno |
| `typealias` | Alias de tipo |
| `newtype` | Wrapper com identidade própria |
| `is` | Type check |
| `as` | Cast |
| `cast` | Cast explícito |
| `null` | Ausência de valor |
| `true` | Literal booleano |
| `false` | Literal booleano |

### Herança e polimorfismo

| Keyword | Função |
|---------|--------|
| `extends` | Herança |
| `implements` | Implementação de interface/catalog |
| `sealed` | Restringe subclasses |
| `permits` | Lista subclasses permitidas |
| `byCatalog` | Valores requeridos por catalog (contextual) |

### Concorrência

| Keyword | Função |
|---------|--------|
| `async` | Método assíncrono |
| `await` | Suspende até completar |
| `synchronized` | Mutex implícito |
| `using` | Variável bound em synchronized ou contexto em expecting |

> Nota: `Thread`, `Channel<T>`, `Mutex<T>` e `Channel.select(...)` são tipos/métodos da stdlib em vez de keywords. Ver seção 20 da spec.

### Tratamento de erros

| Keyword | Função |
|---------|--------|
| `try` | Bloco try |
| `catch` | Captura exception |
| `finally` | Bloco sempre executado |
| `throw` | Lança exception |
| `throws` | Lista exceptions possíveis |

### Generics e variance

| Keyword | Função |
|---------|--------|
| `in` | Variance contravariante |
| `out` | Variance covariante |

### Contracts

| Keyword | Função |
|---------|--------|
| `requires` | Precondition |
| `ensures` | Postcondition |
| `invariant` | Invariante de classe |
| `old` | Valor anterior em ensures |
| `static_assert` | Assertion em compile-time |

### Imports

| Keyword | Função |
|---------|--------|
| `import` | Carrega símbolo |
| `unimport` | Remove símbolo da memória |
| `from` | Em imports cross-bundle |
| `expecting` | Bloco de validação para autenticidade |
| `onFailure` | Bloco de falha em validação |

### Lifecycle hooks

| Keyword | Função |
|---------|--------|
| `onClassLoad` | Quando classe é carregada |
| `onClassUnload` | Quando classe é descarregada |
| `onFirstInstance` | Primeira instanciação |
| `onLastInstanceDestroyed` | Última destruição |

### Métodos reversíveis (stdlib)

> Migrados pra stdlib via interface `Reversible<TArgs>`. Programador implementa `forward()` e `backward()` manualmente. Não há mais keywords dedicadas. Ver seção 32.1 da spec.

### Snapshots (stdlib)

> Migrados pra stdlib. `region.snapshot()` retorna `RegionSnapshot`. `region.restore(snap)` aplica. Não há mais keywords dedicadas. Ver seção 32.2 da spec.

### Properties

| Keyword | Função |
|---------|--------|
| `get` | Getter automatizado |
| `set` | Setter automatizado |
| `init` | Setter only-at-construction |

### Operações aritméticas modificadas

| Keyword | Função |
|---------|--------|
| `checked` | Aritmética com check explícito (default) |

> Nota: `saturating`, `wrapping` e `unchecked` foram migradas pra métodos da stdlib em tipos inteiros: `x.saturatingAdd(y)`, `x.wrappingMul(y)`, `x.uncheckedDiv(y)`, etc. Ver seção 3.6 da spec.

### FFI

| Keyword | Função |
|---------|--------|
| `extern` | Função externa |
| `cdecl` | Calling convention C (contextual) |
| `stdcall` | Calling convention Windows (contextual) |
| `fastcall` | Calling convention fastcall (contextual) |

### Outros

| Keyword | Função |
|---------|--------|
| `affinity` | Hint de cache locality |
| `hot` | Campos acessados frequentemente (contextual) |
| `cold` | Campos acessados raramente (contextual) |
| `bidirectional` | Tipo com conversão bidirecional |
| `to` | Em bidirectional types (contextual) |
| `defer` | Adia execução para fim de escopo |
| `within` | Timeout em defer |
| `address` | Endereço de memória (contextual) |
| `force` | Modificador de unimport (contextual) |
| `timeout` | Modificador de unimport (contextual) |
| `annotation` | Declara annotation customizada |
| `deprecated` | Marca como deprecated |
| `serializable` | Marca como serializável |
| `version` | Reservada para versionamento |

---

## Keywords em ordem alfabética

### A

#### `abstainfrom`
Desativa um label e o bloco de código que ele introduz. O código entre o label alvo e a próxima label (ou fim do método) é pulado durante execução. `reinstate` reativa.

**Escopo:** mesma classe. Pode referenciar labels declarados em qualquer método da mesma classe, mas não cruza fronteiras de classe.

**Forma:**

```polaron
public class HardwareDriver {
    public method handleInterrupt() returns void {
        readHardware();              // sempre executa
        
        label processing;
        processInterrupt();          // pulado se "processing" estiver abstained
        validateState();
        
        label finalization;
        commitChanges();             // controlado separadamente por "finalization"
    }
    
    public method enterLowPower() returns void {
        abstainfrom handleInterrupt.processing;
    }
    
    public method exitLowPower() returns void {
        reinstate handleInterrupt.processing;
    }
}
```

Classes externas controlam comportamento chamando métodos públicos (`enterLowPower`, `exitLowPower`) que internamente fazem abstainfrom/reinstate. Encapsulamento preservado.

**Reference counting:**

Múltiplos `abstainfrom` do mesmo label stackam. Label ativo apenas quando todos os reinstates correspondentes ocorrem.

**Casos de uso:**

- Power management em kernel/embedded
- Feature flags em produção (interno à classe que possui a feature)
- Maintenance modes
- Circuit breakers
- A/B testing de codepaths

**Restrições de segurança:** abstainfrom é proibido em labels implícitas, imports/unimports, type checks, memory safety primitives, persistents lifecycle, regions, constructors/destructors, e contract checks. Apenas labels declaradas explicitamente pelo programador podem ser alvo.

**Removido em modo freestanding** (depende de runtime para reference counting).

Polaron é a primeira linguagem de produção a implementar `abstainfrom` legitimamente. Ver seção 7.11 da spec para regras completas.

#### `abstract`
Modificador de classe ou método. Classe abstract não pode ser instanciada diretamente. Método abstract não tem implementação e deve ser sobrescrito em subclasse concreta.

```polaron
public abstract class Animal {
    public abstract method makeSound() returns void;
}
```

#### `affinity`
Hint de cache locality. Agrupa campos como `hot` (acessados frequentemente juntos) ou `cold` (acessados raramente) para otimização de layout em memória.

```polaron
public class Particle {
    affinity hot {
        public mutable float32 x;
        public mutable float32 y;
        public mutable float32 vx;
        public mutable float32 vy;
    }
    affinity cold {
        public string name;
        public DateTime createdAt;
    }
}
```

#### `annotation`
Declara annotation customizada. Usado para criar metadata aplicável a classes, métodos, campos.

```polaron
public annotation Deprecated(string reason, string since) { }
```

#### `as`
Cast explícito de tipos compatíveis. Sintaxe alternativa para `cast<T>(value)` em casos específicos.

```polaron
Animal a = getAnimal();
Dog d = a as Dog;
```


#### `async`
Marca método como assíncrono. Pode usar `await` internamente. Executa em pool de workers gerenciado pelo runtime.

```polaron
public async method fetchData() returns Result<Data, Error> {
    Response r = await httpClient.get(url);
    return r.parse();
}
```


#### `await`
Suspende execução de método async até completar a tarefa awaited.

```polaron
int result = await computeAsync();
```

### B


#### `bidirectional`
Declara tipo com conversão bidirecional automática entre duas representações. Útil para unit conversions.

```polaron
bidirectional Celsius to Fahrenheit {
    forward { return celsius * 9 / 5 + 32; }
    backward { return (fahrenheit - 32) * 5 / 9; }
}
```

#### `boolean`
Tipo primitivo. Valores `true` ou `false`.

```polaron
boolean isReady = true;
```

#### `break`
Sai do loop ou switch atual.

```polaron
while (true) {
    if (done) {
        break;
    }
}
```

#### `bundle`
Unidade de compilação independente. Contém namespaces. Pode ser compilado, distribuído e carregado separadamente. Suporta build variants.

```polaron
public bundle audio {
    public namespace audio.mixers {
        // ...
    }
}
```

### C

#### `carrying`
Qualificador contextual de `move` que indica que persistents devem seguir o objeto para a nova tripla de identidade. É o comportamento default — a keyword aparece apenas para documentar intenção explicitamente.

**Escopo:** apenas em expressões `move`.

```polaron
Car c2 = move c1 carrying persistents;
// equivalente ao default: persistents seguem para nova tripla

move c1 from region staging to region production carrying persistents;
// persistents seguem o objeto durante move entre regions
```

**Removido em modo freestanding** (depende de persistents).

Ver `move`, `leaving`, `releasing` para detalhes. Ver seção 19.7 da spec.

#### `case`
Cláusula em `switch` ou `match`.

```polaron
switch (color) {
    case Color.RED: handleRed(); break;
    case Color.BLUE: handleBlue(); break;
}
```

#### `cascade`
**Prefixo universal.** Propaga operação recursivamente através de dependências/referências do alvo. Aplicável a delete, release, unimport, clone, print, qualquer operação que faça sentido propagar.

```polaron
cascade delete player;              // delete player + tudo owned
cascade unimport Dog;                // unimport Dog + subclasses + monomorfizações
cascade Console.println(tree);       // print tree + filhos recursivamente
```

#### `cast`
Cast explícito entre tipos.

```polaron
int x = cast<int>(floatValue);
```

#### `catalog`
Interface para enums. Força que enums implementadores tenham tanto métodos específicos quanto valores específicos (via `byCatalog`).

```polaron
public catalog Severity {
    INFO
    int weight();
}

public enum LogLevel extends Severity {
    INFO, WARN, ERROR
    byCatalog { INFO }
    public override method weight() returns int { /* ... */ }
}
```

#### `catch`
Captura exception em bloco try.

```polaron
try {
    doSomething();
} catch (IOException e) {
    handleError(e);
}
```


#### `class`
Declara classe. Unidade fundamental de OOP em Polaron.

```polaron
public class Dog {
    private string name;
    public method bark() returns void { /* ... */ }
}
```

#### `comefrom`
Controle de fluxo inverso ao `goto`. Onde `goto` declara o salto no ponto de origem, `comefrom` declara a interceptação no ponto de destino. Quando execução alcança o label ou linha referenciado, fluxo é redirecionado para o `comefrom`.

**Escopo:** mesma classe. Pode referenciar labels declarados em qualquer método da mesma classe, mas não cruza fronteiras de classe.

**Formas:**

```polaron
// Comefrom intra-method
public class Processor {
    public method retry() returns Data {
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

// Comefrom cross-method dentro da mesma classe
public class Driver {
    public method handleInterrupt() returns void {
        readHardware();
        label processing;
        processInterrupt();
    }
    
    public method onError() returns void {
        comefrom handleInterrupt.processing;
        logFailure();
    }
}

// Comefrom por número de linha
public method debug() returns void {
    comefrom line 42;
    print("Interceptado");
    // ...
    realizaOperacao();  // linha 42 — dispara comefrom
}
```

**Regras principais:**

1. Escopo mesma classe (erro de compilação se cruza fronteira de classe)
2. Multiple comefroms para mesmo target é erro de compilação
3. Forward references permitidas
4. Lambdas têm escopo separado
5. Dispara após o statement labeled executar
6. State não é resetado (cleanup é responsabilidade do programador)
7. Labels implícitas não são alvo (apenas labels declaradas pelo programador)
8. Labels são statement markers (sintaxe `label nome;`), não prefixos de declarações
9. IDE Polaron-compliant deve destacar labels que são alvo de comefrom

**Use cases reconhecidos:** retry com state preservation, intercepção de loops, restart de state machines, debug points isolados, multi-resource compensation, configuration reload, métodos auxiliares interceptando outros métodos da mesma classe.

Polaron é a primeira linguagem de produção a implementar `comefrom` como feature legítima, restrita ao escopo de classe, com disciplina de design que evita os problemas que tornaram comefrom joke em INTERCAL.

#### `comptime`
**Prefixo universal.** Executa código durante compilação. Zero overhead runtime. Valor é computado e embutido no binário.

```polaron
comptime int FIB_10 = fibonacci(10);
comptime ArrayList<int> primes = computePrimes(1000);
```

#### `const`
Constante de tempo de compilação. Valor não muda durante execução do programa.

```polaron
public const int MAX_SIZE = 1024;
```

#### `constructor`
Método especial chamado ao criar instância de classe. Nome igual ao da classe.

```polaron
public class Dog {
    public constructor Dog(string name) {
        this.name = name;
    }
}
```

#### `continue`
Salta para próxima iteração do loop atual.

```polaron
for (mutable int i in 0..100) {
    if (i % 2 == 0) continue;
    processOdd(i);
}
```

### D

#### `default`
Cláusula default em switch. Também usado em interfaces para métodos com implementação padrão.

```polaron
switch (status) {
    case Status.OK: handleOk(); break;
    default: handleUnknown(); break;
}
```

#### `defer`
Adia execução de código para fim do escopo atual. LIFO order. Pode ter timeout: `defer within milliseconds(N)`.

```polaron
public method process() returns void {
    File* f = openFile("data.txt");
    defer { closeFile(f); }
    // ...
}
```

#### `delegate`
Tipo de referência a método. Permite passar método como argumento ou armazenar em variável.

```polaron
delegate IntPredicate(int) returns boolean;
```

#### `delete`
Libera memória alocada com `new`. Chama destrutor.

```polaron
Dog* rex = new Dog("Rex") on heap;
delete rex;
```

#### `deprecated`
Marca classe, método, ou campo como deprecated. Gera warning quando usado.

```polaron
deprecated public method oldMethod() returns void { /* ... */ }
```

#### `destructor`
Método especial chamado quando objeto é destruído. Sintaxe `~ClassName()`.

```polaron
public class Connection {
    public destructor ~Connection() {
        this.close();
    }
}
```

#### `do`
Loop do-while. Executa bloco pelo menos uma vez antes de testar condição.

```polaron
do {
    response = readInput();
} while (response != "quit");
```

### E

#### `else`
Cláusula em if-else.

```polaron
if (condition) {
    doA();
} else {
    doB();
}
```

#### `ensures`
Postcondition em contract. Validada após método executar.

```polaron
public method withdraw(int amount) returns void
    requires(amount > 0)
    ensures(this.balance == old(this.balance) - amount)
{
    this.balance = this.balance - amount;
}
```

#### `enum`
Tipo enumeração. Pode ter métodos (Java-style) e implementar catalogs.

```polaron
public enum Color {
    RED, GREEN, BLUE
    
    public method rgb() returns int { /* ... */ }
}
```

#### `eternal`
**Prefixo universal.** Recurso vive durante toda a execução do programa. Sem cleanup explícito necessário. Aplicável a persistents, regions, threads, channels, static fields.

```polaron
public eternal persistent int settings = 0;
public eternal region globalCache = allocate(64) megabytes;
public eternal thread monitor = new thread(/* ... */);
```

#### `expecting`
Em unimport/import, declara bloco de validação para verificar autenticidade do código.

```polaron
var proof = unimport Dog expecting {
    return Dog.computeFingerprint();
};

import Dog expecting proof {
    return Dog.computeFingerprint();
} onFailure {
    panic("authentication failed");
};
```

#### `extends`
Herança de classe ou interface.

```polaron
public class Puppy extends Dog { /* ... */ }
```

#### `extern`
Função externa (FFI). Pode especificar calling convention.

```polaron
extern cdecl method printf(const char* format, ...) returns int from "libc";
```

### F

#### `false`
Literal booleano.

```polaron
boolean done = false;
```

#### `final`
**Prefixo universal.** Não modificável, sobrescrevível, ou removível.

```polaron
public final class Singleton { /* ... */ }
public final method criticalOp() returns void { /* ... */ }
final import Dog;  // não pode ser unimportada
```

#### `finally`
Bloco em try que sempre executa, mesmo com exception.

```polaron
try {
    doWork();
} finally {
    cleanup();
}
```

#### `for`
Loop for tradicional. Em Polaron suporta range syntax.

```polaron
for (mutable int i in 0..10) {
    Console.println(i);
}

for (Item x in collection) {
    process(x);
}
```


#### `from`
Em imports cross-bundle ou cross-program.

```polaron
import Dog from bundle pets;
import audio from program GameEngine bundle audio;
```

#### `function`
Reservada para uso futuro. Atualmente toda função é método.

### G

#### `get`
Em properties, define getter automatizado.

```polaron
public class Person {
    public int age { get; }
}
```

#### `goto`
Salto para label. Suporta label nomeado, número de linha, ou endereço de memória.

```polaron
cleanup: 
    delete resource;
    return;

// ...

if (error) goto cleanup;
```

### I

#### `if`
Condicional. Brackets obrigatórios mesmo para uma linha.

```polaron
if (x > 0) {
    handlePositive();
}
```

#### `implements`
Implementação de interface ou catalog.

```polaron
public class FileLogger implements Logger { /* ... */ }
```

#### `import`
Carrega símbolo (classe, namespace, bundle) na memória do programa.

```polaron
import Dog;
import bundle audio;
import Greeter from bundle ui;
```

#### `in`
Em foreach, regions, ou variance.

```polaron
for (Item x in collection) { /* ... */ }
Dog* rex = new Dog() in region pets;
interface Comparable<in T> { /* contravariant */ }
```

#### `index`
Em foreach com índice.

```polaron
for (Item x in collection index i) {
    Console.println($"{i}: {x}");
}
```

#### `init`
Setter only-at-construction em properties.

```polaron
public class Config {
    public string apiKey { get; init; }
}
```

#### `into`
Preposição em expressões `move`. Combina transferência de ownership e mudança de region em uma operação atômica.

```polaron
Connection c1 = new Connection() in region staging;
Connection c2 = move c1 into region production;
// c1 invalidado, c2 é o novo dono, objeto agora vive em production

cascade clone source into dest;
// também usado em cascade clone para indicar destino
```

Ver `move` para uso completo. Ver seção 19.3 da spec.

#### `itself`
Pronome de auto-referência em initializers de declaração. Refere-se à variável sendo declarada na mesma linha.

```polaron
region small = itself.allocate(8 kilobytes).accepts({Particle});
// itself = small

Dog rex = itself.fromBreed(Breed.labrador);
// itself = rex
```

Válido apenas em (1) initializer de declaração de variável local e (2) initializer de declaração de campo de classe. Erro em qualquer outro contexto.

Cada `itself` é local à sua linha — não há ambiguidade entre linhas adjacentes que declaram coisas diferentes.

**Disponível em modo freestanding** (compile-time only, sem custo de runtime).

Ver seção 17.9 da spec.

#### `int8`, `int16`, `int32`, `int64`
Inteiros sinalizados com bit width específico.

```polaron
int8 a = -128;
int64 large = 9223372036854775807;
```

#### `interface`
Declara interface (contrato sem implementação obrigatória).

```polaron
public interface Drawable {
    method draw() returns void;
}
```

#### `internal`
Modificador de visibilidade. Acessível apenas dentro do mesmo bundle.

```polaron
internal class Helper { /* ... */ }
```

#### `invariant`
Contract invariant. Validado antes e depois de cada método público.

```polaron
public class Counter {
    invariant(this.count >= 0);
    private int count = 0;
}
```

#### `is`
Type check.

```polaron
if (obj is Dog) {
    Dog d = obj as Dog;
}
```

### K


### L

#### `lambda`
Declara função anônima. Captura explícita de variáveis.

```polaron
lambda(int x) returns int => x * 2;
items.forEach(lambda(Item x) returns void { process(x); });
```

#### `lazy`
**Prefixo universal.** Adia execução até primeiro acesso. Thread-safe implícito.

```polaron
lazy Dog rex = new Dog("Rex");
lazy import Dog;
lazy region cache = allocate(1) gigabytes;
```

#### `leaving`
Qualificador contextual de `move` que indica que persistents devem ficar órfãos na tripla de identidade antiga, sem seguir o objeto. O novo objeto começa sem persistents.

**Escopo:** apenas em expressões `move`.

```polaron
Car c2 = move c1 leaving persistents;
// persistents ficam atrelados a (escopo, "c1", region) e ficam órfãos
// c2 começa sem persistents
// uma nova variável "c1" criada depois pode reataçar os persistents
```

Use case: quando o programador quer preservar persistents na localização original para futura reataçamento, mantendo o novo objeto limpo.

**Removido em modo freestanding** (depende de persistents).

Ver `move`, `carrying`, `releasing`. Ver seção 19.7 da spec.

#### `library`
Reservada para uso futuro em sistema de bibliotecas.

#### `literal`
Declara função como sufixo de literal numérico. Função deve ser `comptime` com exatamente um parâmetro numérico. Expansão em compile-time, zero overhead em runtime.

```polaron
public comptime literal kilobytes(int x) returns ByteSize {
    return new ByteSize(x * 1024);
}

public comptime literal milliseconds(int x) returns Duration {
    return new Duration(x * 1000 * 1000);
}

// Uso:
ByteSize cacheSize = 64 kilobytes;   // expande para kilobytes(64) em compile-time
Duration timeout = 500 milliseconds; // expande para milliseconds(500) em compile-time
```

**Regras:**

- Deve ser `comptime`.
- Deve ter exatamente um parâmetro.
- Tipo do parâmetro determina onde o sufixo aplica (int vs double).
- Tipo de retorno é livre.
- Função precisa estar no escopo via import para sufixo funcionar.
- Overloading permitido.

**Stdlib v1.0** fornece em `System.Memory.Units`: `bytes`, `kilobytes`, `megabytes`, `gigabytes`, `terabytes`, `exabytes`, todas retornando `ByteSize`.

**Disponível em modo freestanding** (compile-time only).

Ver seção 17.10 da spec.

### M

#### `match`
Pattern matching exaustivo. Validado em compile-time para sealed classes.

```polaron
int result = match(shape) {
    case Circle c -> c.area();
    case Square s -> s.side * s.side;
    case Triangle t -> t.base * t.height / 2;
};
```


#### `method`
Declara método em classe. Palavra obrigatória.

```polaron
public method bark() returns void { /* ... */ }
```

#### `module`
Reservada para uso futuro.

#### `movable`
Disciplina de ownership de classe. Exige uso explícito de `move` para transferir ownership entre variáveis. Atribuição sem `move` é erro de compilação.

```polaron
public movable class Connection {
    private Socket socket;
    public method send(byte[] data) returns void { /* ... */ }
}

Connection c1 = new Connection() on heap;
Connection c2 = move c1;   // c1 invalidado
c1.send(data);              // ERRO: variável movida
c1 = new Connection() on heap;  // OK: reassign reativa
```

Compilador rastreia estado de cada variável movable (válida, movida, não-inicializada). Use após move é erro de compilação. Destrutor não roda em variáveis movidas, evitando double-free.

**Disponível em modo freestanding** (compile-time only).

Ver `move`, `unique`, `partitionable`. Ver seção 19 da spec.

#### `move`
Keyword que transfere ownership de objeto entre variáveis, regions, ou disciplinas. Opera em múltiplos eixos com sintaxe explícita.

**Forma básica (entre variáveis):**

```polaron
Connection c2 = move c1;   // c1 invalidado, c2 é novo dono
```

**Move entre regions:**

```polaron
move c from region staging to region production;
```

**Move combinando ownership e region:**

```polaron
Connection c2 = move c1 into region production;
```

**Move com cast de disciplina:**

```polaron
ExclusiveConnection e = move c as ExclusiveConnection;
// upgrade de movable para unique
```

**Move em argumentos de método:**

```polaron
public method consume(move Connection c) returns void { /* ... */ }
consume(move c1);   // c1 invalidado após chamada
```

**Move em retorno de método:**

```polaron
public method create() returns move Connection { /* ... */ }
```

**Move com qualificadores de persistents:**

```polaron
Car c2 = move c1 carrying persistents;   // default: persistents seguem
Car c2 = move c1 leaving persistents;     // persistents ficam órfãos
Car c2 = move c1 releasing persistents;   // persistents liberados
```

**Cascade move (propaga recursivamente):**

```polaron
cascade move tree from region old to region new;
```

**Sintaxe formal:**

```
move <source> [into <dest>] [to|into region <R>] [from region <R0>] [as <Type>] [carrying|leaving|releasing persistents];
```

**Disponível em modo freestanding** (compile-time only).

Ver `movable`, `unique`, `partitionable`, `into`. Ver seção 19 completa da spec.

#### `mutable`
Permite modificação. Aplicável a variáveis, parâmetros, métodos (que mutam estado), campos.

```polaron
mutable int counter = 0;
public mutable method increment() returns void { /* ... */ }
```

### N

#### `namespace`
Organização lógica dentro de bundle. Contém classes, interfaces, enums, etc.

```polaron
public namespace game.entities {
    public class Player { /* ... */ }
}
```

#### `new`
Alocação de instância. Sintaxe completa especifica local.

```polaron
Dog rex = new Dog("Rex") on stack;
Dog* heavyDog = new Dog("Big") on heap;
Car tesla = new Car() in region garage;
```

#### `newtype`
Wrapper de tipo com identidade própria. Diferente de `typealias` que é apenas alias.

```polaron
newtype UserId = int;
newtype OrderId = int;
// UserId e OrderId são distintos mesmo sendo int
```

#### `null`
Literal de ausência de valor. Disponível apenas para tipos opcionais.

```polaron
Optional<Dog> maybeDog = null;
```

### O

#### `of`
Disambiguação em regions.

```polaron
Car* tesla of region parking = /* ... */;
```

#### `old`
Em ensures contracts, refere ao valor anterior à execução do método.

```polaron
public method increment() returns void
    ensures(this.count == old(this.count) + 1)
{
    this.count = this.count + 1;
}
```

#### `on`
Especifica local de alocação.

```polaron
Dog rex = new Dog() on stack;
Dog* heavy = new Dog() on heap;
```

#### `onClassLoad`
Lifecycle hook. Executa quando classe é carregada em memória.

```polaron
public class Database {
    onClassLoad { initializeDriver(); }
}
```

#### `onClassUnload`
Lifecycle hook. Executa quando classe é descarregada (unimport).

```polaron
public class Database {
    onClassUnload { cleanupDriver(); }
}
```

#### `onFirstInstance`
Lifecycle hook. Executa na primeira instanciação da classe.

```polaron
public class Logger {
    onFirstInstance { setupLogFile(); }
}
```

#### `onLastInstanceDestroyed`
Lifecycle hook. Executa quando última instância é destruída.

```polaron
public class ResourcePool {
    onLastInstanceDestroyed { releaseAllResources(); }
}
```

#### `onFailure`
Em import com expecting, bloco obrigatório que define comportamento quando validação falha.

```polaron
import Dog expecting proof {
    return Dog.fingerprint();
} onFailure {
    Logger.security("reimport failed");
    System.exit(1);
};
```

#### `operator`
Declara operator overload em classe.

```polaron
public class Vector {
    public operator method +(Vector other) returns Vector { /* ... */ }
}
```

#### `out`
Variance covariante em generics. Em parâmetros, indica output parameter.

```polaron
interface Producer<out T> { /* ... */ }
public method getMax(int[] arr, out int index) returns int { /* ... */ }
```

#### `override`
Modificador obrigatório quando método sobrescreve método de superclasse.

```polaron
public override method makeSound() returns void { /* ... */ }
```

### P

#### `package`
Reservada para uso futuro em sistema de packages.

#### `partial`
Declaração parcial de classe. Permite dividir definição entre arquivos.

```polaron
// File 1
public partial class Game { /* fields */ }
// File 2
public partial class Game { /* methods */ }
```

#### `partitionable`
Modificador de classe que permite move parcial de campos individuais. Opt-in obrigatório — sem `partitionable`, mover um campo isoladamente é erro de compilação.

```polaron
public partitionable class Connection {
    public movable Socket socket;
    public mutable Config config;
}

Connection c1 = new Connection() on heap;
Socket s = move c1.socket;
// OK: socket é movable e a classe é partitionable
// c1.socket fica em estado movida; c1.config continua válido

c1.socket = new Socket() on heap;   // reassign reativa o campo
```

**Restrições:**

- Apenas campos `movable` ou `unique` podem ser movidos parcialmente.
- Combinação `unique partitionable` é proibida (contradição).
- Destrutor do objeto-pai só roda destrutores de campos válidos.

**Disponível em modo freestanding** (compile-time only).

Ver `move`, `movable`. Ver seção 19.5 da spec.

#### `permits`
Em sealed class, lista subclasses permitidas.

```polaron
public sealed class Animal permits Dog, Cat, Bird { /* ... */ }
```

#### `persistent`
Campo sobrevive ao destrutor do objeto pai. Acessível via path após delete. Reataca automaticamente em recriação com mesma identidade (escopo + nome + region).

```polaron
public class Car {
    public persistent TipoChassi chassi;
    public Motor motor;
}
```

#### `private`
Modificador de visibilidade. Acessível apenas dentro da classe declarante.

#### `program`
Declaração de programa. Outermost organizacional unit.

```polaron
program myGame;
```

#### `protected`
Modificador de visibilidade. Acessível pela classe e subclasses.

#### `public`
Modificador de visibilidade. Acessível de qualquer lugar.

### R

#### `record`
Tipo imutável tipo DTO. Auto-gera construtor, equals, hashCode, toString.

```polaron
public record Point(int x, int y);
```

#### `region`
Porção nomeada de memória com type acceptance rules.

```polaron
region pets = allocate(1) megabytes accepts {Dog, Cat} rejects {Wild};
```

#### `reinstate`
Reativa um label previamente abstained via `abstainfrom`. Implementa reference counting interno: múltiplos abstainfroms requerem mesmo número de reinstates para o label voltar ativo.

**Escopo:** mesma classe. Mesma regra que `abstainfrom`.

```polaron
public class HardwareDriver {
    public method exitLowPower() returns void {
        reinstate handleInterrupt.processing;
    }
}
```

**Semântica:**

```polaron
abstainfrom myLabel;  // counter = 1, abstained
abstainfrom myLabel;  // counter = 2, abstained
reinstate myLabel;    // counter = 1, ainda abstained
reinstate myLabel;    // counter = 0, reinstated
```

Reinstate em label já reinstated (counter = 0) é warning, não erro. Sem efeito.

**Removido em modo freestanding** (depende de runtime para reference counting).

Ver `abstainfrom` para mais detalhes e seção 7.11 da spec para regras completas.

#### `release`
Libera persistent ou region.

```polaron
release persistent car.chassi;
release region pets;
```

#### `releasing`
Qualificador contextual de `move` que indica que persistents devem ser explicitamente liberados durante o move. Nem o objeto antigo nem o novo retêm os persistents.

**Escopo:** apenas em expressões `move`.

```polaron
Car c2 = move c1 releasing persistents;
// persistents de (escopo, "c1", region) são liberados
// c2 começa sem persistents
// nenhuma reataçamento futuro é possível
```

Use case: refactor de código onde persistents antigos não são mais relevantes e devem ser descartados explicitamente, evitando que reataçamento acidental traga estado obsoleto.

**Removido em modo freestanding** (depende de persistents).

Ver `move`, `carrying`, `leaving`, `release`. Ver seção 19.7 da spec.

#### `requires`
Precondition em contract. Validada antes de método executar.

```polaron
public method withdraw(int amount) returns void
    requires(amount > 0 && amount <= this.balance)
{
    /* ... */
}
```


#### `return`
Retorna de método. Pode incluir valor.

```polaron
return 42;
return;
```

#### `returns`
Sintaxe de declaração de tipo de retorno.

```polaron
public method computeAge() returns int { /* ... */ }
```



### S


#### `sealed`
Modificador de classe. Restringe subclasses a lista declarada com `permits`. Habilita pattern matching exaustivo.

```polaron
public sealed class Shape permits Circle, Square, Triangle { /* ... */ }
```


#### `serializable`
Marca classe ou campo como serializável.

```polaron
public serializable class User { /* ... */ }
```

#### `set`
Em properties, define setter automatizado.

```polaron
public class Person {
    public int age { get; set; }
}
```

#### `short`
Alias para `int16`.


#### `static`
Pertence à classe, não a instâncias.

```polaron
public static method create() returns Instance { /* ... */ }
public static int count = 0;
```

#### `static_assert`
Assertion validada em compile-time.

```polaron
static_assert(sizeof(int) == 4, "int must be 32-bit");
```

#### `step`
Em range com step customizado.

```polaron
for (mutable int i in 0..100 step 2) {
    /* só pares */
}
```

#### `string`
Tipo primitivo de string mutável.

```polaron
mutable string buffer = "hello";
buffer = buffer + " world";
```

#### `String`
Tipo de string imutável (classe). Distinto de `string`.

```polaron
String immutable = "constant value";
```

#### `struct`
Tipo composto value-type. Suporta bit fields.

```polaron
public struct PacketHeader {
    public mutable uint8 version : 4;
    public mutable uint8 type : 4;
}
```

#### `super`
Referência a superclasse. Usado para chamar métodos da superclasse.

```polaron
public override method makeSound() returns void {
    super.makeSound();
    extraBehavior();
}
```

#### `switch`
Switch tradicional com fall-through. Distinto de `match` que é pattern matching.

```polaron
switch (status) {
    case 0: handleZero(); break;
    case 1: 
    case 2: handleOneOrTwo(); break;
    default: handleOther(); break;
}
```

#### `synchronized`
Sincronização com mutex implícito.

```polaron
synchronized(sharedResource) using SharedResource& res {
    res.update();
}
```

### T


#### `this`
Referência a instância atual. Uso obrigatório para acessar campos da própria classe.

```polaron
public method setName(string name) returns void {
    this.name = name;
}
```


#### `throw`
Lança exception.

```polaron
throw new InvalidArgumentException("value out of range");
```

#### `throws`
Em declaração de método, lista exceptions possíveis.

```polaron
public method openFile(string path) returns File* throws IOException { /* ... */ }
```

#### `transient`
Campo não-serializável. Não persiste em snapshots ou serialização.

```polaron
public class User {
    public string name;
    public transient string sessionToken;  // não serializa
}
```

#### `true`
Literal booleano.

#### `try`
Bloco try em exception handling. Também usado em try-catch obrigatório para bundles opcionais.

```polaron
try {
    File* f = openFile("data.txt");
} catch (IOException e) {
    handleError(e);
}
```

#### `typealias`
Alias de tipo sem identidade nova. Diferente de `newtype`.

```polaron
typealias UserList = ArrayList<User>;
```

### U

#### `uint8`, `uint16`, `uint32`, `uint64`
Inteiros não-sinalizados com bit width específico.

```polaron
uint8 byte = 255;
uint64 huge = 18446744073709551615;
```

#### `union`
Tipo união. Interpretação alternativa de mesma memória.

```polaron
public union FloatBits {
    public float32 asFloat;
    public uint32 asInt;
}
```


#### `unimport`
Remove referência de símbolo do programa em runtime. Descarrega código da memória.

```polaron
unimport Dog;
unimport namespace audio.mixers;
unimport bundle audio;
```

#### `unique`
Disciplina de ownership de classe. Garante que apenas uma referência viva ao objeto existe no programa a qualquer momento. Atribuição é move implícito automaticamente.

```polaron
public unique class FileHandle {
    private int fd;
    public method read(byte[] buffer) returns int { /* ... */ }
}

FileHandle f1 = new FileHandle("data.txt") on heap;
FileHandle f2 = f1;   // implicit move; f1 invalidado
// equivalente a: FileHandle f2 = move f1;

f1.read(buffer);   // ERRO: variável movida
```

**Restrições:**

- Tipos unique não podem ser passados por valor para múltiplos parâmetros simultaneamente.
- Tipos unique não podem ser armazenados em containers que duplicam referências.
- Downgrade `unique` → `movable` via cast é proibido (viola garantia de unicidade).
- Combinação `unique partitionable` é proibida (contradição).

Use cases canônicos: `FileHandle`, `Mutex`, `Connection`, qualquer recurso que não deve ser duplicado.

**Disponível em modo freestanding** (compile-time only).

Ver `movable`, `move`, `partitionable`. Ver seção 19 da spec.

#### `using`
Em synchronized, declara variável bound. Em expecting, passa contexto para blocos de validação.

```polaron
synchronized(obj) using ObjectType& ref {
    ref.update();
}

var proof = unimport Dog expecting using challenge {
    return Dog.responseTo(challenge);
};
```

### V

#### `var`
Declaração de variável com type inference.

```polaron
var counter = 0;        // int
var name = "Alice";     // string
var dog = new Dog();    // Dog
```

#### `version`
Reservada para versionamento em bundles.

#### `void`
Tipo de retorno para métodos sem valor de retorno.

```polaron
public method log(string msg) returns void { /* ... */ }
```

#### `volatile`
**Prefixo universal.** Não otimizável pelo compilador. Leituras sempre fazem fetch real.

```polaron
public volatile int hardwareRegister = 0;
```

### W

#### `while`
Loop while tradicional.

```polaron
while (condition) {
    doWork();
}
```


#### `within`
Em defer com timeout.

```polaron
defer within milliseconds(100) {
    cleanupResources();
}
```


### Y

#### `yield`
Em generators, retorna valor próximo sem terminar função.

```polaron
public method fibonacci() returns Generator<int> {
    mutable int a = 0;
    mutable int b = 1;
    while (true) {
        yield a;
        int temp = a + b;
        a = b;
        b = temp;
    }
}
```

---

## Contextual keywords

Estas palavras são reservadas apenas em contextos específicos. Podem ser usadas como identificadores em outros lugares.

| Keyword | Contexto |
|---------|----------|
| `byCatalog` | No corpo de enum que implementa catalog |
| `address` | Em declaração de region ou variável de endereço |
| `cdecl` | Em extern, calling convention C |
| `stdcall` | Em extern, calling convention Windows stdcall |
| `fastcall` | Em extern, calling convention fastcall |
| `hot` | Em affinity, campos acessados frequentemente |
| `cold` | Em affinity, campos acessados raramente |
| `to` | Em bidirectional types ou em move (`move x to region Y`) |
| `force` | Modificador de unimport |
| `timeout` | Modificador de unimport |
| `carrying` | Qualificador de `move` — persistents seguem o objeto (default) |
| `leaving` | Qualificador de `move` — persistents ficam órfãos na tripla antiga |
| `releasing` | Qualificador de `move` — persistents são liberados explicitamente |

---

## Tipos primitivos

Tipos primitivos também são keywords reservadas.

### Inteiros sinalizados
- `int8` — 8 bits, -128 a 127
- `int16` — 16 bits, -32,768 a 32,767
- `int32` — 32 bits
- `int64` — 64 bits
- `int` — alias para `int32`
- `short` — alias para `int16`
- `long` — alias para `int64`

### Inteiros não-sinalizados
- `uint8` — 8 bits, 0 a 255
- `uint16` — 16 bits, 0 a 65,535
- `uint32` — 32 bits
- `uint64` — 64 bits
- `byte` — alias para `uint8`

### Ponto flutuante
- `float32` — 32 bits IEEE 754
- `float64` — 64 bits IEEE 754
- `float` — alias para `float32`
- `double` — alias para `float64`

### Outros
- `boolean` — true ou false
- `char` — caractere Unicode
- `void` — sem valor

### Strings
- `string` — string mutável
- `String` — string imutável (classe)

---

## Identifiers especiais reservados pela stdlib

Estes não são keywords técnicas mas são reservados pela stdlib e não devem ser usados como identificadores.

### `Memory`
Módulo com operações de baixo nível.

```polaron
Memory.getMemory(address);   // endereço físico de persistent
Memory.read<T>(addr);        // leitura tipada
Memory.write<T>(addr, val);  // escrita tipada
Memory.zero(buffer);          // zera buffer
Memory.copy(src, dst);        // copia memória
```

### `System`
Módulo principal de I/O e sistema.

```polaron
System.IO.printf(...);        // output formatado
System.IO.readLine();         // input de linha
System.exit(code);            // termina programa
System.getEnv(name);          // variável de ambiente
System.getArgs();             // argumentos da linha de comando
```

### `Console`
Alias para `System.IO` em algumas operações comuns.

```polaron
Console.println(value);
Console.print(value);
```

---

## Prefixos universais

Seis keywords funcionam como **prefixos universais** com semântica consistente em qualquer contexto onde aplicáveis. Podem ser combinados livremente quando semânticamente compatíveis.

### `cascade`
Propagação recursiva através de dependências.

```polaron
cascade delete player;
cascade unimport Dog;
cascade Console.println(tree);
cascade clone source into dest;
```

Parâmetros opcionais:
```polaron
cascade(depth: 3) delete tree;
cascade(types: {Item}) delete inventory;
cascade(except: {Pet}) clone player;
```

### `eternal`
Vida igual à duração do programa.

```polaron
public eternal persistent int settings = 0;
public eternal region globalCache = allocate(64) megabytes;
public eternal thread monitor = startMonitor();
public eternal Channel<Log> logger = new Channel<Log>();
public eternal static ArrayList<Player> players = new ArrayList<Player>();
```

### `lazy`
Adia execução até primeiro acesso.

```polaron
lazy Dog rex = new Dog("Rex");
lazy result = expensiveCalculation();
lazy import Dog;
lazy region cache = allocate(1) gigabytes;
lazy thread monitor = startMonitor();
```

### `comptime`
Executa em compile-time, zero overhead runtime.

```polaron
comptime method fibonacci(int n) returns int { /* ... */ }
comptime int fib10 = fibonacci(10);
comptime ArrayList<int> primes = computePrimes(1000);
comptime assert(BUFFER_SIZE > 0);
comptime String version = readFile("VERSION");
comptime if (TARGET == "x86") { /* ... */ }
```

### `volatile`
Não otimizável pelo compilador.

```polaron
volatile int hardwareRegister = 0;
volatile result = Memory.read<int>(0x1000);
volatile method readSensor() returns int { /* ... */ }
volatile region mmio = at address 0xB8000 size 4000 bytes;
```

### `final`
Não modificável, sobrescrevível ou removível.

```polaron
final class Foo { /* ... */ }
final method bar() returns void { /* ... */ }
final region world = allocate(64) megabytes;
final thread monitor = startMonitor();
final import Dog;  // não pode ser unimportada
```

---

## Keywords removidas em modo freestanding

Modo freestanding remove 21 keywords principais que dependem de runtime managed:

```
async       await       catch       delegate    finally
lazy        persistent  release     throw       throws
try         unimport    using       within      onClassUnload
onLastInstanceDestroyed  onFailure  expecting   comefrom
abstainfrom reinstate
```

E também remove 3 contextuais ligadas a persistents:

```
carrying    leaving     releasing
```

Modo freestanding **mantém** as keywords de ownership (`move`, `movable`, `unique`, `partitionable`, `into`) porque são compile-time only e essenciais para escrever kernels e drivers com segurança de ownership.

Modo freestanding mantém **112 keywords** suficientes para escrever kernels, drivers, firmware, e código bare-metal com OOP completo, generics, manual memory, regions com endereço direto, bit fields, FFI, e disciplinas de ownership.

> Nota: 19 keywords da versão original foram migradas pra stdlib na v1.0 e portanto não aparecem em nenhum dos modos: `thread`, `channel`, `select`, `snapshot`, `restore`, `reverse`, `reversible`, `forward`, `backward`, `witness`, `assert`, `tests`, `saturating`, `wrapping`, `unchecked`, `allocate`, `at`, `kilobytes`, `megabytes`.

---

## Combinações válidas e inválidas

### Combinações válidas

```polaron
public eternal lazy final static persistent in region globalCache
    HashMap<String, ConfigEntry> settings = loadConfig();
```

Esta declaração combina sete modificadores. Cada palavra documenta semântica específica.

### Combinações inválidas

Compilador rejeita contradições com mensagens claras:

| Combinação | Razão |
|------------|-------|
| `mutable final` | Contradição — mutável mas imutável |
| `persistent transient` | Contradição — sobrevive mas não serializa |
| `comptime volatile` | Contradição — compile-time mas pode mudar em runtime |
| `comptime lazy` | Redundância — comptime já executa antes do runtime |
| `unique partitionable` | Contradição — unicidade global vs move de campos separados |
| `movable` em classe default | Não existe — disciplinas são mutuamente exclusivas |
| Move sem disciplina | Erro — `move x` requer que tipo de x seja movable ou unique |

---

## Ordem composicional canônica

Para garantir consistência visual e facilitar leitura, compilador impõe ordem canônica:

```
[annotations]
[visibilidade] [movable|unique] [partitionable] [eternal] [lazy] [final] [comptime] [volatile] [cascade] [static] [mutable] [persistent|transient] [constant] [in region X]
<tipo> <nome> [= inicializador];
```

Exemplo correto:
```polaron
public movable partitionable eternal lazy final static persistent in region cache
    HashMap<String, int> data = loadData();
```

Para classes, a disciplina de ownership (`movable` ou `unique`) aparece logo após a visibilidade:

```polaron
public movable class Connection { /* ... */ }
public unique class FileHandle { /* ... */ }
public movable partitionable class GameState { /* ... */ }
```

Outras ordens são rejeitadas com sugestão de correção.

Para **operações** (não declarações), prefixos aplicáveis são `cascade`, `lazy`, `comptime`:

```
[cascade] [lazy] [comptime] <operação>;
```

---

## Contagens finais

| Categoria | Quantidade |
|-----------|------------|
| Keywords principais | 133 |
| Contextual keywords | 13 |
| Tipos primitivos (também keywords) | 20 |
| Modo freestanding | 112 keywords |

**Total absoluto:** 166 palavras reservadas considerando todas as categorias.

---

*Documento gerado da especificação v1.0.*
