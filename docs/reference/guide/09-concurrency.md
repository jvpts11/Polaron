# 9. Concurrency

Most of what a program does with more than one thing at a time, Polaron expresses through ordinary
library types rather than dedicated syntax. `Thread`, `Mutex<T>`, `atomic<T>`, and `Channel<T>`
are all classes in the standard library, imported and used like any other class. Only `async` and
`await` remain keywords, and they earn that status for a concrete reason: they change how the
compiler generates code. An async method is not compiled as a straight-line function; it is rewritten
into a state machine that can pause in the middle and continue later. That rewrite cannot be a library
feature, so the two words that trigger it are part of the language.

The result is two facilities that solve two different problems. **OS threads** give you genuine
parallelism: separate execution contexts scheduled by the operating system, each running a piece of
code at the same time as the others. **Async/await** gives you cooperative concurrency over a fixed
pool of worker threads: many logical tasks that suspend and resume without each one consuming a whole
OS thread while it waits. The two systems are conceptually distinct, they can coexist in the same
program, and this chapter treats them in turn before covering the primitives that let concurrent code
share state without corrupting it.

Everything here depends on the runtime and the operating system. **Concurrency is not available in
freestanding mode** (see §9.9): the compiler rejects `async`/`await` outright there, and the thread,
channel, and lock types have nothing to lower to without an OS underneath.

## 9.1 Two models, side by side

Before the details, hold the distinction clearly. A `Thread` is a real operating-system thread. When
you `start()` one, the OS scheduler may run its code on a different core in true parallel with your
other threads. You pay for that with the cost of an OS thread, and you are responsible for
synchronizing any state the threads share.

An `async` method, by contrast, does not get its own OS thread. Calling it hands a small unit of work
to a shared pool of worker threads managed by the language runtime. While that work waits for
something (typically another async task), it is *suspended*: it steps off the worker entirely, freeing
that worker to run other tasks, and it is resumed later when what it was waiting for is ready. This is
how you can have thousands of outstanding async operations backed by a handful of OS threads.

You reach for threads when you want to run CPU-bound work on multiple cores, or when you need a
long-lived background worker. You reach for async when you have many operations that spend most of
their time waiting and you do not want to burn an OS thread on each one.

## 9.2 Threads

`Thread` lives at `System.Concurrency.Thread`. A thread runs a `function<void>` — a closure that takes
no arguments and returns nothing — which you hand to its constructor. Calling `start()` spawns the OS
thread and begins running the closure; calling `join()` blocks the calling thread until that thread has
finished.

```polaron
import System.IO.Console;
import System.Concurrency.Thread;
program ThreadSpawn;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                mutable int n = 21;
                function<void> work =
                    lambda[captures: byvalue n]() returns void {
                        System.IO.Console.printf("worker n=%d\n", n * 2);
                    };
                Thread t = new Thread(work) on heap;
                t.start();   // the closure now runs on its own OS thread
                t.join();    // wait for it to finish before continuing
                System.IO.Console.printf("main done\n");
                return;
            }
        }
    }
}
```

The lambda captures `n` **by value**, so the worker thread receives its own copy and does not race the
main thread over the original variable. This is the safe default and it matters: a closure that
outlives the scope it was created in must not hold a dangling reference. Because `main` calls `join()`
before printing its last line, the output is deterministic — the worker runs to completion first, so
the program prints `worker n=42` and then `main done`. Without the `join()`, the two prints could
interleave in either order, which is exactly the kind of nondeterminism threads introduce.

Under the hood `start()` calls into the runtime, which uses `CreateThread` on Windows and
`pthread_create` on POSIX; `join()` maps to `WaitForSingleObject` / `pthread_join`. You allocate the
`Thread` `on heap` here because it must outlive the statement that starts it.

## 9.3 Async, await, and `Task<T>`

An `async` method is written like any other method, with the `async` modifier in front, but it behaves
very differently at the call site. Instead of running to completion and returning a `T`, it returns
immediately with a `Task<T>` — a handle to a computation that will eventually produce a `T`. The body
is scheduled to run on the worker pool. You get the value out later by writing `await` on the task.

```polaron
import System.IO.Console;
import System.Concurrency.Task;
program AsyncBasic;

public bundle main {
    public namespace app {
        public class Main {
            public static async method sumA() returns int {
                mutable int s = 0;
                for (mutable int i = 1; i <= 100; i++) { s = s + i; }
                return s;
            }
            public static async method sumB() returns int {
                mutable int s = 0;
                for (mutable int i = 1; i <= 200; i++) { s = s + i; }
                return s;
            }
            public static method main(string[] args) returns void {
                Task<int> a = Main.sumA();   // scheduled on the pool; returns at once
                Task<int> b = Main.sumB();   // also scheduled; both may run concurrently
                int ra = await a;            // block here until a finishes
                int rb = await b;
                System.IO.Console.printf("a=%d b=%d\n", ra, rb);
                return;
            }
        }
    }
}
```

The two calls to `sumA()` and `sumB()` do not compute anything at the call site; each returns a
`Task<int>` right away, and the actual summing happens on pool workers. Only when `main` reaches
`await a` does it wait for a result. Notice that `main` is an ordinary (non-async) method: awaiting a
task from ordinary code is legal and simply *blocks* the current thread until the task completes. The
distinction between blocking and suspending is the heart of the model, and the next sections make it
precise.

`Task<T>` is `System.Concurrency.Task`; it wraps the runtime task handle. You almost never touch its
internals — you create one by calling an async method and consume it with `await`.

### 9.3.1 How an async method becomes a state machine

When the compiler sees `async`, it does not emit a normal function. It rewrites the method into a
**state machine** whose local variables no longer live on the call stack but in a heap-allocated *state
object*. Each `await` in the body marks a point where the method may pause. The compiler splits the
body at every such point into a *suspend* half and a *resume* half, and it builds a small dispatch at
the top of the resume function — an entry switch — that jumps to whichever resume point the method last
stopped at.

This rewrite is why locals move to the heap. A value defined before an `await` and used after it must
survive the pause, and a stack frame does not survive a function returning. By storing locals in the
state object, the method can return control to the worker pool at an `await`, come back later, and find
all its variables exactly where it left them.

The worker pool itself is a fixed set of OS threads created once, sized to the machine (the number of
logical processors, clamped to a sane minimum and maximum). They pull ready-to-run work — pairs of
*(resume function, state object)* — off a shared queue and run it. A worker never sleeps waiting on an
individual task; when a task suspends, the worker just picks up the next queued item.

### 9.3.2 What `await` actually does

Inside an async method, `await someTask` does three things. It saves the awaited task's handle into the
state object, it advances the state counter to the resume point that follows, and it asks the runtime
whether the awaited task is already finished.

If the task is **not** yet done, `await` registers the current method's resume function as a
*continuation* on that task and then *returns* — the worker is released to do other work, and no OS
thread is parked. When the awaited task later completes, the runtime schedules the registered
continuation back onto the pool, a worker picks it up, the entry switch jumps straight to the resume
point, and execution continues as if it had never stopped.

If the task **is** already done, `await` takes a fast path: there is nothing to wait for, so it does not
suspend at all and simply reads the result and continues in place.

```polaron
import System.IO.Console;
import System.Concurrency.Task;
program AsyncChain;

public bundle main {
    public namespace app {
        public class Main {
            public static async method val(int n) returns int { return n; }
            public static async method pipeline() returns int {
                int a = await Main.val(10);   // suspend; resume with a = 10
                int b = await Main.val(20);   // suspend; resume with b = 20
                int c = await Main.val(30);   // suspend; resume with c = 30
                return a + b + c;             // 60
            }
            public static method main(string[] args) returns void {
                Task<int> t = Main.pipeline();
                System.IO.Console.printf("sum=%d\n", await t);   // 60
                return;
            }
        }
    }
}
```

`pipeline()` suspends three times, once at each `await`, and each time its locals `a`, `b`, and `c`
persist in the state object across the pause. The final `return a + b + c` *completes* the task with the
value `60`, which is what `main`'s `await t` ultimately reads.

### 9.3.3 Awaiting inside loops and conditionals

Because the async lowering is a genuine coroutine transform and not a shallow trick, `await` is allowed
anywhere in the method body, including inside loops and `if` blocks. The control flow you write is the
control flow you get; the compiler splits each `await`'s block into a suspend/resume pair and wires the
entry switch so that resuming jumps back into the loop at the right place.

```polaron
import System.IO.Console;
import System.Concurrency.Task;
program AsyncLoop;

public bundle main {
    public namespace app {
        public class Main {
            public static async method val(int n) returns int { return n; }
            public static async method sumLoop() returns int {
                mutable int total = 0;
                for (mutable int i = 1; i <= 5; i++) {
                    int x = await Main.val(i);   // suspend/resume once per iteration
                    total = total + x;
                }
                return total;                    // 15
            }
            public static method main(string[] args) returns void {
                Task<int> t = Main.sumLoop();
                System.IO.Console.printf("loopsum=%d\n", await t);   // 15
                return;
            }
        }
    }
}
```

Here `total` and the loop counter `i` both live in the state object, so they keep their values across
the suspension that happens on every iteration. The method resumes back into the loop body each time
until the loop finishes normally and the task completes with `15`.

There is one subtlety worth naming. When several `await`s appear in a *single expression*, a value
computed before one `await` must still be alive after the next one. The compiler handles this by
*spilling* such intermediate temporaries into scratch storage inside the state object and reloading them
in the resume block, so an expression like `await f() + await g() + await h()` evaluates correctly even
though each `await` splits the expression in two.

```polaron
public static async method combine() returns int {
    // the result of the first await survives the second and third awaits:
    int s = await Main.val(10) + await Main.val(20) + await Main.val(30);   // 60
    // a plain value computed before an await survives it too:
    int t = Main.twice(5) + await Main.val(7);                             // 17
    return s + t;                                                          // 77
}
```

### 9.3.4 Results and exceptions both propagate

An async task can finish in one of two ways: it can produce a value, or it can throw. Both outcomes
travel back to the awaiter. If the body reaches a `return`, the task completes with that value and the
awaiter's `await` yields it. If the body throws an exception that escapes it, the task completes in a
*failed* state carrying the exception, and when the awaiter reaches its `await`, the exception is
re-thrown there. In other words, `await` propagates a failure into the awaiting context exactly as if
the awaited work had run inline.

```polaron
import System.IO.Console;
import System.Concurrency.Task;
program AsyncTry;

public bundle main {
    public namespace app {
        public interface Throwable { }
        public class MyError implements Throwable {
            public mutable int code;
            public constructor MyError() { this.code = 1; }
        }
        public class Main {
            public static async method val(int n) returns int { return n; }
            public static async method work(boolean fail) returns int {
                int base = await Main.val(10);       // stays live across the whole try
                mutable int out = 0;
                try {
                    int a = await Main.val(20);
                    if (fail) { throw new MyError() on heap; }
                    out = base + a;                  // 30 when not failing
                } catch (MyError e) {
                    out = base + await Main.val(5);   // 15; note: await inside catch
                } finally {
                    out = out + 100;                 // always runs
                }
                return out;
            }
            public static method main(string[] args) returns void {
                Task<int> ok = Main.work(false);
                System.IO.Console.printf("ok=%d\n", await ok);    // 130
                Task<int> bad = Main.work(true);
                System.IO.Console.printf("bad=%d\n", await bad);  // 115
                return;
            }
        }
    }
}
```

This example is a good stress test of the model: an `await` sits inside a `try`, another sits inside a
`catch`, a `throw` is caught locally, and a `finally` runs on both paths. The value `base` is computed
before the `try` and remains valid through all of it because it lives in the state object. Exceptions
compose with async just as they do in ordinary code.

### 9.3.5 Awaiting outside an async method

`await` is not restricted to async bodies. When you write it in an ordinary method — as `main` does in
every example above — it cannot suspend a state machine, because there is none. Instead it simply
*blocks* the calling thread until the task completes and then reads the result. This is the natural way
to drive async work from a synchronous entry point: kick off the tasks, then block on their results at
the top level.

`await` also works on a **channel receive**, which is a special, degenerate case. A `Channel`'s
`receive()` already blocks until a value is available, so `await ch.receive()` is a pass-through: the
`await` adds no suspension of its own, it just reads the value the blocking receive produced. This lets
async-flavored code interoperate with channels without special ceremony.

```polaron
// producer thread fills the channel; the consumer awaits each receive
mutable int sum = 0;
for (mutable int i = 0; i < 5; i++) {
    sum = sum + await ch.receive();   // await on a channel receive == the blocking receive
}
```

## 9.4 `Mutex<T>` and `synchronized`

When two threads need to touch the same data, unsynchronized access is a bug. Polaron's answer is
`Mutex<T>` (from `System.Concurrency.Mutex`), a lock that *owns* the value it protects rather than
sitting beside it. You cannot reach the guarded value except through the lock, which makes it
structurally impossible to read or write it without holding the mutex.

The only way in is the `synchronized` statement:

```polaron
synchronized (m) using T& c {
    // c is a reference to the protected value; the lock is held for this whole block
}
```

`synchronized (m)` acquires the lock; `using T& c` binds `c` as a **reference** to the value inside the
mutex, so reads and writes of `c` hit the protected storage directly; and the closing brace releases
the lock. Crucially, the release is registered as a scope cleanup, which means it runs on **both**
normal exit and exception unwinding — if the body throws, the lock is still released as the stack
unwinds, so a failure inside a critical section cannot leave the mutex locked forever and deadlock the
next thread that wants it.

```polaron
import System.IO.Console;
import System.Concurrency.Thread;
import System.Concurrency.Mutex;
program MutexSynchronized;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                Mutex<int> counter = new Mutex<int>(0) on heap;
                function<void> work = lambda[captures: byvalue counter]() returns void {
                    for (mutable int i = 0; i < 100000; i++) {
                        synchronized (counter) using int& c {
                            c = c + 1;    // read-modify-write, protected by the lock
                        }
                    }
                };
                Thread t1 = new Thread(work) on heap;
                Thread t2 = new Thread(work) on heap;
                t1.start();
                t2.start();
                t1.join();
                t2.join();
                synchronized (counter) using int& c {
                    System.IO.Console.printf("total=%d\n", c);   // exactly 200000
                }
                return;
            }
        }
    }
}
```

Two threads each increment the shared counter one hundred thousand times. The `c = c + 1` inside the
`synchronized` block is a read-modify-write, which is not atomic on its own; without the lock the two
threads would routinely read the same value, both add one, and both write it back, losing an update.
With the lock, the total is exactly `200000`. Note that both threads share the *same* mutex: the
closure captures `counter` by value, but `Mutex` is a heap object referred to through its handle, so
both closures lock the one counter.

The mutex generalizes to any type. A `Mutex<ArrayList<Dog>>` guards a whole list, and
`synchronized (m) using ArrayList<Dog>& list { list.add(rex); }` mutates it safely.

There is one rule the compiler enforces: **you may not `await` while holding a mutex**. An `await`
inside a `synchronized` block is a compile-time error. The reason is the classic deadlock: suspending
an async task while it holds a lock can let the very work that must run to release it get stuck behind
the held lock. Forbidding the combination outright removes an entire family of hangs.

## 9.5 `atomic<T>`

For a single integer counter or flag, a full mutex is heavier than necessary. `atomic<T>` (from
`System.Concurrency.atomic`) is a **lock-free** cell whose operations compile directly to hardware
atomic instructions — no lock is taken, no thread ever blocks, and there are no lost updates. It is the
lock-free counterpart to the mutex example above.

```polaron
import System.IO.Console;
import System.Concurrency.Thread;
import System.Concurrency.atomic;
program AtomicCounter;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                atomic<int> counter = new atomic<int>(0) on heap;
                function<void> work = lambda[captures: byvalue counter]() returns void {
                    for (mutable int i = 0; i < 100000; i++) {
                        counter.increment();   // one indivisible atomic add
                    }
                };
                Thread t1 = new Thread(work) on heap;
                Thread t2 = new Thread(work) on heap;
                t1.start();
                t2.start();
                t1.join();
                t2.join();
                System.IO.Console.printf("total=%d\n", counter.get());   // exactly 200000
                return;
            }
        }
    }
}
```

The atomic cell offers both a method form and an operator form. The methods are:

- `get()` — an atomic load of the current value.
- `set(v)` — an atomic store.
- `add(n)` — atomically add `n` and return the **new** value.
- `increment()` — add one (the special case of `add`).
- `compareAndSet(expected, desired)` — if the current value equals `expected`, store `desired` and
  return `true`; otherwise leave it unchanged and return `false`. This is the primitive on which
  lock-free algorithms are built.

The operators read more naturally for simple counters and lower to the same atomic instructions:

```polaron
atomic<int> c = new atomic<int>(5) on heap;
c++;          // 6   (atomic add of 1)
c += 4;       // 10  (atomic add)
c--;          // 9   (atomic sub of 1)
c -= 2;       // 7   (atomic sub)
c = 100;      // atomic store of 100
int v = c.get();
```

Every one of these is sequentially consistent, the strongest and easiest-to-reason-about memory
ordering, so you never have to think about instruction reordering when using them.

## 9.6 `Channel<T>`

Channels are the message-passing side of Polaron concurrency: instead of sharing memory and guarding it
with a lock, threads communicate by handing values to each other. `Channel<T>`
(`System.Concurrency.Channel`) is a **bounded blocking queue**. You give it a capacity at construction.
`send(v)` blocks while the channel is full, and `receive()` blocks while it is empty. This back-pressure
is the point: a fast producer cannot outrun a slow consumer without limit, because it stalls once the
buffer fills.

```polaron
import System.IO.Console;
import System.Concurrency.Thread;
import System.Concurrency.Channel;
program ChannelDemo;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                Channel<int> ch = new Channel<int>(4) on heap;    // capacity 4
                function<void> producer = lambda[captures: byvalue ch]() returns void {
                    for (mutable int i = 1; i <= 5; i++) {
                        ch.send(i);      // blocks once the buffer is full
                    }
                };
                Thread t = new Thread(producer) on heap;
                t.start();
                mutable int sum = 0;
                for (mutable int i = 0; i < 5; i++) {
                    sum = sum + ch.receive();   // blocks while empty
                }
                t.join();
                System.IO.Console.printf("sum=%d\n", sum);   // 15
                return;
            }
        }
    }
}
```

The producer sends `1..5` into a channel that holds only four, so it blocks on the fifth send until the
consumer has taken one out. The consumer receives five values and sums them to `15`. Because every value
crosses the channel one at a time under the channel's own lock, no external synchronization is needed:
the channel *is* the synchronization. Values ride through as 64-bit slots, which covers integers and
object references alike.

## 9.7 `Channel.select`

Sometimes you need to wait on *several* channels at once and act on whichever becomes ready first.
Earlier drafts of the language had a `select` keyword for this; the language settled instead on a
fluent builder, `Channel.select()`, which reuses ordinary static methods and lambdas and needs no new
syntax. You chain a `.receive(channel, handler)` arm for each channel you want to watch, optionally a
`.timeout(milliseconds, handler)` arm, and finish with `.run()`.

```polaron
import System.IO.Console;
import System.Concurrency.Thread;
import System.Concurrency.Channel;
program ChannelSelect;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                Channel<int> a = new Channel<int>(4) on heap;
                Channel<int> b = new Channel<int>(4) on heap;
                function<void> prod = lambda[captures: byvalue b]() returns void {
                    b.send(42);
                };
                Thread t = new Thread(prod) on heap;
                t.start();
                t.join();   // b now holds a value; a is still empty
                Channel.select()
                    .receive(a, lambda(int x) returns void {
                        System.IO.Console.printf("a=%d\n", x);
                    })
                    .receive(b, lambda(int y) returns void {
                        System.IO.Console.printf("b=%d\n", y);   // this arm fires: prints b=42
                    })
                    .run();
                return;
            }
        }
    }
}
```

The chain is entirely static — the compiler can see every arm at compile time — so it lowers the
builder into a poll loop rather than a runtime data structure. Each pass tries a *non-blocking* receive
on every listed channel; the first channel that has a value wins, and its handler runs with that value.
Channel `b` holds `42` and `a` is empty, so the `b` arm fires and prints `b=42`.

A `.timeout` arm bounds the wait. When no channel becomes ready within the given number of
milliseconds, the timeout handler runs instead, so `select` never hangs forever:

```polaron
Channel<int> a = new Channel<int>(4) on heap;   // stays empty
Channel.select()
    .receive(a, lambda(int x) returns void {
        System.IO.Console.printf("a=%d\n", x);
    })
    .timeout(20, lambda() returns void {
        System.IO.Console.println("timeout");   // no value within ~20 ms: this runs
    })
    .run();
```

## 9.8 A note on data races

A data race — two threads touching the same location at the same time, at least one of them writing,
with no synchronization between them — is undefined behavior in most systems languages and a source of
some of the hardest bugs there are. Polaron does not make races impossible, but its concurrency toolkit is
designed so that the *straightforward* way to share state is also the *safe* way.

Three ideas do the work. First, value semantics: assignment in Polaron is a deep copy, and closures capture
by value by default, so handing data to another thread tends to hand it a private copy rather than a
shared, aliased one. Two threads that each own their own copy cannot race over it. Second, when threads
genuinely must share mutable state, `Mutex<T>` makes the shared value *unreachable* except while the lock
is held, so you cannot forget to synchronize — the type system routes you through the lock — and the lock
is released even when the critical section throws. Third, `atomic<T>` gives you correct shared counters
and flags with no lock at all, and `Channel<T>` lets threads cooperate by passing values instead of
sharing memory, which sidesteps the whole problem: if the only thing that crosses between threads is a
message through a channel, there is nothing to race over.

The async side adds one guardrail of its own: the compiler forbids holding a mutex across an `await`,
closing off the most common way async code deadlocks itself.

## 9.9 Concurrency is not available in freestanding mode

Freestanding programs (§36 of the specification) run without an operating system and without the Polaron
runtime, so none of this chapter applies there. The compiler enforces the boundary directly: declaring
an `async` method or writing an `await` in freestanding mode is a compile-time error. The thread,
channel, mutex, and atomic-cell types likewise depend on OS threading primitives and the runtime's
worker pool, none of which exist in a freestanding target. If you are writing a kernel or a bare-metal
program, concurrency has to be built from whatever primitives your target hardware offers, outside the
facilities described here.
