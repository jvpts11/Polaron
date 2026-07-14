# Progresso noturno 2 — 2026-06-18 → 19 (autônomo)

Você pediu pra fechar F7 e F8. Resumo honesto do que deu e do que travou (sem chutar).

## Feito e commitado esta noite
- **Persistents — GRAFOS COMPLETOS:** lista ligada (serialização recursiva), DAGs (dedup via
  object ids), ciclos (não loopam), `null` literal. Runtime mínimo `runtime/ldp3_rt.c`. Tudo cross-run.
- **Store junto do .exe** (via GetModuleFileNameA), como você decidiu.
- (Mais cedo no dia: reattach de objeto via `this`, serialização estrutural, persistent local.)
- **F7-persistents está essencialmente completo.**

## NÃO fiz — e por quê (a regra é não chutar sintaxe/semântica)
- **comefrom:** a semântica operacional é ambígua na spec. "execução alcança o label → vai pro
  comefrom", mas o exemplo de retry sugere o oposto (goto reverso), e não está claro como o
  comefrom dentro de `if` se comporta. Preciso de um trace passo-a-passo seu.
- **reflection / lifecycle hooks:** vagos na spec (só menções, sem sintaxe; marcados "Release 0.8").
- **F8 (Thread/Channel/Mutex):** são stdlib (F10) e usam **lambdas** + threads de OS (FFI) — travado
  por pré-requisitos. async/await usa pool de worker threads (runtime gerenciado).
- **release / partial-ctor (persistents):** possível ambiguidade — sintaxe do `release`? e no §18.9,
  no reattach o construtor sobrescreve o persistent ou mantém o valor reatacado?

## Lambdas — FEITO (commits 705045e, be19381, 2965c5f, 99dbc55, 7f9bd92, ee8f561, 7d5a74a)
`function<Ret,Params>` (tipo) + `lambda(params) returns T { body }` (expr). Cada lambda vira uma
função top-level; a chamada é indireta pelo ponteiro. Funciona: como **valor** (add=8 square=36),
como **callback/argumento** (r=49), **void sem params** (hi=7), **ordem superior** (retorna lambda,
d=42), **em campo de classe** (strategy pattern, v=105), e com **clone no monomorphizer** (robustez
pra generics), e **closures** (captura byvalue + byref). **113 CTest + 190 doctest verde.** Lambdas
estão 100% (MVP) -- inclusive captura.

Limitações conhecidas (próximos refinamentos):
- **Captura (closures) FEITO** — `lambda[captures: byvalue x, byref y]` funciona (byvalue c=15
  814fa77, byref b=9 1f6bb2e, clone no mono 77b7ea7). Function value = ponteiro p/ um closure
  {code, env} no heap; o env carrega os capturados (byvalue copia o valor, byref compartilha o
  storage da variável); a lambda lê o env (arg 0) ao entrar. **Isso destrava F8** (Thread/async
  recebem closures). Cobertura extra: retorno boolean (03e5a22), char com `if` no corpo (44f7f65).
- **Tipos function aninhados + lambda de ordem superior FEITO** (7f9bd92, ee8f561): parseTypeRef
  divide o token `>>` em dois `>`, e o split de `function<...>` (codegen+sema) é balanceado por
  nível de `<>`. `makeDoubler` (lambda que retorna lambda) roda: d=42.
- **Generics gerais aninhados** (`Box<List<int>>`) ainda NÃO: os typeArgs são lexemes simples;
  precisam de parseTypeRef recursivo (o `>>`-split já existe agora). Refinamento separado.
- **F8** está DESTRAVADO pelos closures, mas a spec §20 mostra que `Thread`/`Channel`/`Mutex` são
  classes da **stdlib** (`System.Concurrency.*`) -> dependem de **F10** (stdlib real, que ainda não
  existe); e `async`/`await` exigem **state-machine generation** (transformação de código, complexo).
  Ou seja: F8 não "fecha" sem F10 (ou um `Thread` builtin via CreateThread no runtime). Decisão sua.

## Dúvidas pra você de manhã
1. comefrom: trace passo-a-passo da semântica same-method.
2. release de persistent: sintaxe exata?
3. partial-ctor (§18.9): no reattach, construtor sobrescreve ou mantém?
4. F8: como prosseguir, já que Thread/Channel/Mutex são stdlib (dependem de F10)? (a) F10 stdlib
   mínima primeiro; (b) `Thread` builtin via CreateThread no runtime (destrava concorrência sem a
   stdlib inteira); (c) async/await isolado (state machine); ou (d) pausar F8, voltar pra F4/F5/F6.
