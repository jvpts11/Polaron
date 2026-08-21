# Idiom warnings: `0Cxx` — escrever Polaron idiomático é escrever Polaron rápido

## A tese

Cada palavra-chave do Polaron é **informação directa para o compilador**. Onde o backend teria de
adivinhar, a construção diz-lhe o facto — e um facto conhecido é uma optimização que se pode fazer
sem provar nada primeiro.

O inverso é o que interessa aqui, e é contra-intuitivo: **escrever como C torna o programa mais
lento.** Não por o C ser lento, mas porque um padrão escrito à mão é opaco. Um `match` sobre um
`sealed enum` é uma tabela de saltos que o compilador sabe ser total; a mesma coisa escrita como uma
escada de `if`s é uma cadeia de comparações cuja exaustividade ninguém pode provar. Um `invariant`
vira um `llvm.assume` e permite içar o guard para fora do ciclo; o mesmo `if` repetido no topo de
cinco métodos é cinco ramos que ficam lá. Uma `region` diz ao binder onde acaba o tempo de vida; um
`Kmalloc.allocate` com um `release` à mão é um par opaco que obriga a assumir o pior.

Estes warnings existem para dizer isso ao autor **no sítio onde ele o está a perder**, com o custo
nomeado.

Há um segundo beneficiário, e não é menor: **o region binder precisa de um grafo OOP saudável.**
Arrays paralelos, ponteiros donos onde devia haver `weak`, e classes sem `invariant` são exactamente
o que faz o binder desistir e cair no caso conservador.

## Porquê uma classe nova, `0Cxx`

`0Bxx` é ADVICE: *«isto é provavelmente um erro»*. Estes são outra coisa: *«isto está correcto, e
está a deixar desempenho e verificação em cima da mesa»*. Merecem ser silenciáveis em separado
(`--no-idiom`), aparecer em bloco no relatório, e ter um `why` que nomeia a optimização perdida em
vez de um risco.

Cada entrada do catálogo tem a forma:

- **caret** — o padrão, numa linha.
- **why** — *o que o backend deixa de saber*. Esta é a diferença face aos outros warnings.
- **fix** — a construção que o substitui, com a forma exacta.
- **prevent** — o hábito.

---

## Onda 1 — alta confiança, custo de detecção baixo, e todos com um bug real no pico

| código | padrão detectado | construção em falta | o que o backend perde |
|---|---|---|---|
| `0C01` | **Prefixo partilhado**: 2+ campos da mesma classe cujo primeiro segmento identificador coincide (`slotIds`, `slotEntry`, `slotText`) | `record` / `class` | O prefixo É o tipo. Separados, são N campos independentes em N linhas de cache; juntos, um agregado que o backend passa em registos e vectoriza |
| `0C02` | **Arrays paralelos**: 2+ campos array na mesma classe indexados pela mesma variável no mesmo ciclo | array de `record` | SLP vectorization precisa dos campos adjacentes. Separados, cada acesso é um endereço-base diferente e o alias analysis tem de assumir o pior |
| `0C03` | **Par contado**: um `byte*` seguido de um `int` cujo nome é o mesmo radical + `Bytes`/`Len`/`Count` | um tipo de texto/fatia | Dois parâmetros que nada mantém sincronizados. Como um valor, viajam em registos e a relação comprimento↔ponteiro é conhecida — que é o que desbloqueia a eliminação do bounds check |
| `0C04` | **Escada de `if` sobre um `sealed enum`**: 2+ comparações `x == E.membro` em cadeia | `match` | Uma tabela de saltos que o compilador sabe ser total, contra uma cadeia de comparações que ele tem de percorrer. E a exaustividade deixa de ser verificável — foi assim que `Window.eventOf` perdeu o caso `resized` |
| `0C05` | **Guarda de gama que nomeia um membro do enum à mão** (`code > E.ultimo.code()`) | o `match` gera-o | Um membro novo não actualiza a guarda. O compilador conhece a gama; escrevê-la à mão é uma segunda fonte de verdade |
| `0C06` | **`mutable` num campo/local nunca atribuído depois da inicialização** | tirar o `mutable` | **Directo**: um campo imutável fica em registo através de chamadas e nunca é recarregado. Com `mutable`, cada chamada obriga a reler |
| `0C07` | **Ponteiro dono para algo que a classe não criou nem liberta** (atribuído de um parâmetro, sem `new`, sem `delete`) | `weak` | O binder não consegue formar a floresta de ownership e desiste. E é a diferença entre um duplo-free impossível e um duplo-free evitado por um booleano em tempo de execução |
| `0C08` | **Alocação dentro de um contexto de interrupção** (método alcançável a partir de um `interrupt`/`naked`, com `new`/`Kmalloc`) | pré-alocar, ou `in region` | Não é optimização: é o deadlock de tomar o lock do alocador dentro do handler. O pico pagou-o nos pipes e voltou a pagá-lo no rasterizador |

## Onda 2 — contratos e tempo de vida (onde está o desempenho a sério)

| código | padrão detectado | construção em falta | o que o backend perde |
|---|---|---|---|
| `0C10` | **A mesma guarda no topo de 3+ métodos da mesma classe** (`if (this.n < 0 \|\| this.n > Max) return;`) | `invariant` | Um `invariant` é um `llvm.assume`: o guard sai de dentro do ciclo e as verificações redundantes desaparecem. Repetido à mão, ficam todos lá |
| `0C11` | **Guarda sobre um parâmetro como primeira instrução** | `requires` | O mesmo, do lado do chamador: o compilador pode provar a pré-condição no sítio da chamada e apagar a verificação dentro |
| `0C12` | **`new`/`Kmalloc.allocate` com libertação à mão em apenas alguns caminhos de saída** | `defer` | O ponto de libertação passa a ser estrutural e visível; à mão, os outros caminhos são fugas que ninguém vê |
| `0C13` | **Alocações repetidas com o mesmo tempo de vida num método** | `in region` + `release region` | O binder passa a poder provar tempos de vida por grupo e a eliminar guards de nulidade. Um par malloc/free à mão é opaco |
| `0C14` | **Alocação dentro de um ciclo cujo resultado morre na iteração** | içar, ou `in region` | Foi isto, literalmente, no rasterizador do pico: três arrays por glifo, sem um `delete` no ficheiro inteiro |
| `0C15` | **Classe só alocada `on heap` que nunca escapa do método** | `on stack` | Escapou uma vez ao pico e custou 322 mallocs por frame |

## Onda 3 — tipos, formas e a stdlib

| código | padrão detectado | construção em falta | o que o backend perde |
|---|---|---|---|
| `0C20` | **2+ campos `int` com sufixo `Id`** na mesma classe | `newtype` | Dois inteiros com significados diferentes deixam de ser trocáveis. O compilador passa a saber que nunca são o mesmo valor |
| `0C21` | **Máscara de bits à mão** (`1 << x`, `& (1 << x)`, `\| (1 << x)` sobre um campo `int`) | `sealed enum` + conjunto, ou `catalog` | Um conjunto tipado tem operações que o backend reconhece; deslocamentos à mão são aritmética anónima |
| `0C22` | **Classe só com campos públicos e sem métodos** | `record` | Semântica de valor: passa em registos, nunca faz alias, e ganha `equalsKey`/`hash`/`compareTo` gerados |
| `0C23` | **Campos lidos/escritos por deslocamentos de bytes explícitos** (`buf[4]`, `put32`) | `layout` | Os offsets exactos em vez de um GEP calculado, e zero adivinhação de packing |
| `0C24` | **3+ métodos cujo corpo inteiro é `return this.campo.mesmoNome(args);`** | `delegate` | A delegação é resolvida na declaração; o reenvio à mão é um frame de chamada por método |
| `0C25` | **Tabela de ponteiros para método indexada por um `int`** | `interface` + `override` | `vtable.load` é uma instrução que o compilador pode devirtualizar; uma tabela à mão é uma chamada indirecta opaca |
| `0C26` | **Lista ligada ou mapa escritos à mão** (campo `next` do próprio tipo; array + procura linear) | as colecções da `stdlib` | Estão disponíveis em freestanding, são testadas, e o backend reconhece as suas operações. E lógica em arrays cresce em complexidade mais depressa do que qualquer outra coisa |
| `0C27` | **`address` cheio onde o valor cabe em 32/16/8 bits** | `half`/`short`/`byte address` | Metade do tráfego de memória por ponteiro |
| `0C28` | **`fixed int` cujo nome e valor coincidem com um membro de um `sealed enum` noutro bundle** | importar o enum | Um formato de fio escrito duas vezes tem sempre uma cópia desactualizada |

---

## Como se detecta, sem falsos positivos a mais

Três regras que valem para todas:

1. **Só dentro da mesma classe/método.** Uma heurística que atravessa ficheiros gera ruído que ninguém
   consegue avaliar.
2. **Um limiar, nunca um.** `0C01` precisa de dois campos com o mesmo prefixo *e* que o prefixo não
   seja o nome da própria classe. `0C24` precisa de três métodos, não de um.
3. **Silenciável no sítio.** Um `@idiom(off)` na declaração, para o caso legítimo — e o caso legítimo
   existe: um `layout` de hardware tem campos com prefixo partilhado por o hardware os ter assim.

## Como se prova que valem

Cada warning entra com **um sample em `tests/samples/`** que o dispara e um que não. E os que
reclamam uma optimização entram com uma **medição**: o mesmo programa escrito das duas maneiras, com
os tempos. Um warning que diz «isto é mais lento» sem um número é exactamente a prosa a legislar que
estas regras existem para eliminar.

O corpus de validação é o **pico**: 27 achados verificados em `pico/DIAGNOSTICO.md`, dos quais
`0C01`, `0C02`, `0C03`, `0C04`, `0C05`, `0C07`, `0C08` e `0C14` têm um caso real e nomeado à espera.
