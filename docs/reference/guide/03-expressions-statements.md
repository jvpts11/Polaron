# 3. Expressions, Statements & Method Calls

The previous chapter showed how a program is *organized* — the program, bundle,
namespace, and class scaffolding. This chapter is about what goes *inside* a method:
the ordinary, everyday act of writing code. How you declare a variable, how you assign
to it, which operators the language gives you, how expressions and statements differ,
and — the thing you will do more than any other — how you call a method. None of this is
exotic; it is the vocabulary you use on every line. But LDP3 has a few firm rules here
(assignment is not an expression, member access always goes through `this.`, every block
is braced) that are worth stating plainly before you meet them scattered through later
chapters.

Everything in this chapter lives inside a method body, so keep the whole-program
skeleton from Chapter 2 in mind: what follows are the statements you would write inside
`main`, or inside any method you declare.

## 3.1 Statements and blocks

A method body is a sequence of **statements**, each terminated by a semicolon, executed
top to bottom. LDP3 is strict about layout in two ways that never relax:

- **Every block is braced.** A `{ }` block groups statements; there is no brace-less
  form. `if (x) return;` written without braces is a *syntax error*, not a shortcut. An
  `if`, a loop, a method body — all take a full `{ }`.
- **One statement per line, each ending in `;`.** Declarations, assignments, calls, and
  `return` all end with a semicolon. Blank lines and indentation are yours to arrange
  for readability; they carry no meaning.

The statement kinds you will use constantly are: a **variable declaration**
(`int n = 5;`), an **assignment** (`n = 6;`), an **expression statement** — usually a
method call whose result you ignore (`this.log();`), a **`return`**, and the
**control-flow** statements (`if`, `while`, `for`, `foreach`, `switch`, `match`) covered
in Chapter 7. A bare block `{ ... }` is itself a statement and opens a new scope.

```ldp3
import System.IO.Console;
program Statements;

public bundle Main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int a = 2;              // declaration
                int b = 3;              // declaration
                int sum = a + b;        // declaration initialised from an expression
                System.IO.Console.println($"sum = {sum}");   // expression statement (call)
                return;                 // return statement
            }
        }
    }
}
```

## 3.2 Variables

A variable binds a name to a value of a known type. You declare one by writing the type,
the name, and — almost always — an initializer:

```ldp3
int side = 4;
boolean ready = true;
char grade = 'A';
```

Two rules shape every declaration:

- **Immutable by default.** A variable you never reassign needs no annotation. If you
  intend to reassign it, you must mark it `mutable`. This makes the riskier choice —
  mutable state — the one that is visible in the source.
- **`var` infers the type of a local.** Inside a method body you may write `var` and let
  the compiler deduce the type from the initializer. Inference is a *local-only*
  convenience: fields, parameters, and return types always name their type explicitly.

```ldp3
int fixed = 10;            // immutable: reassigning it is a compile error
mutable int count = 0;     // mutable: expected to change
count = count + 1;         // fine

var total = fixed + count; // inferred as int
```

An immutable variable must be initialized where it is declared, since there is no later
chance to give it a value. A `mutable` one may be assigned afterwards as often as you
like.

## 3.3 Assignment

Assignment stores a new value in an existing `mutable` variable (or field, through
`this.`). Two properties of assignment in LDP3 catch newcomers, and both are deliberate:

**Assignment is a statement, not an expression.** It has no value, so it cannot appear
inside a condition or be chained. `if (x = 5) { ... }` is an error (the compiler will not
let a stray `=` masquerade as `==`), and `a = b = c;` does not compile — write the two
assignments on their own lines. This closes off a classic family of bugs at the cost of
one convenience.

**Assignment copies.** For a class value, `b = a;` makes `b` a deep, independent copy of
`a`; the two do not share state afterwards. This is covered in full in Chapter 5; it is
mentioned here only so the meaning of `=` is never a surprise. To make two names refer to
the *same* object you use a pointer or reference, also in Chapter 5.

**Compound assignment** combines an operator with assignment as a shorthand: `a += b` is
`a = a + b`. LDP3 offers the full set — arithmetic and bitwise alike:

```ldp3
mutable int a = 20;
a += 5;     // a = a + 5   -> 25
a -= 3;     // 22
a *= 2;     // 44
a /= 4;     // 11
a %= 3;     // 2
a <<= 4;    // 32   (bitwise shift-assign)
a &= 12;    // 0    (bitwise and-assign; also |=  ^=  >>=)
```

And **increment / decrement**, `++` and `--`, adjust a variable by one:

```ldp3
mutable int i = 0;
i++;        // 1
i--;        // 0
```

## 3.4 Operators

LDP3's operators are the familiar C-family set, with defined behavior on every edge case
(overflow traps, division by zero traps — see Chapter 8). Grouped by role:

| Group | Operators |
|-------|-----------|
| Arithmetic | `+`  `-`  `*`  `/`  `%` |
| Comparison | `==`  `!=`  `<`  `>`  `<=`  `>=` |
| Logical | `&&`  `\|\|`  `!` |
| Bitwise | `&`  `\|`  `^`  `~`  `<<`  `>>` |
| Increment / decrement | `++`  `--` |
| Conditional (ternary) | `cond ? a : b` |
| Assignment | `=` and the compound forms above |

The **logical** operators `&&` and `||` **short-circuit**: `a && b` never evaluates `b`
if `a` is already `false`, and `a || b` never evaluates `b` if `a` is already `true`.
This lets you guard an expensive or unsafe operand with a cheap test on its left.

The **ternary** operator is an *expression* — it produces a value — so it is the idiomatic
way to choose between two values without an `if` statement:

```ldp3
int larger = a > b ? a : b;
```

Operators follow the usual precedence (multiplication before addition, comparison before
`&&`, and so on). When in doubt, parenthesize; the parentheses cost nothing and document
intent:

```ldp3
boolean inRange = (x >= 0) && (x < limit);
int packed = (hi << 8) | lo;
```

## 3.5 Calling methods

Calling a method is the workhorse of the language, and there are exactly four call shapes
you will use.

**On another object.** Given a variable holding an object, name it, a dot, the method,
and the arguments in parentheses. Arguments are ordinary expressions:

```ldp3
Account acc = new Account(100) on stack;
acc.deposit(50);                 // call deposit(50) on acc
int bal = acc.balance();         // a call that returns a value
```

**On yourself, through `this.`** Inside a method, calling another method of the *same*
object still goes through `this.` — there is no implicit receiver. `this.area()` calls
this object's `area`; a bare `area()` would be an unknown name.

```ldp3
public method describe() returns void {
    System.IO.Console.println($"area = {this.area()}");   // one method calling another
    return;
}
```

**On a class (static).** A `static` method belongs to the class, not an instance, so you
call it through the class name: `Counter.inc()`, `Math.max(a, b)`. The standard-library
console you have been using is exactly this — `System.IO.Console.println(...)` is a static
call on the `Console` type.

**Chained.** When a call returns an object, you can call a method on that result directly,
building a chain left to right. Each call runs on the value the previous one returned:

```ldp3
String s = builder.append("a").append("b").toString();
```

In every shape, **arguments are passed by copy** for value types — a method receives its
own copy of a class argument and cannot alter the caller's object by mutating the
parameter. When a method genuinely needs to modify the caller's object, the caller passes
a pointer or reference (Chapter 5). A method's result comes back through `return`, and you
either use it (assign it, feed it to another call, test it) or discard it by writing the
call as its own statement.

A worked example ties the shapes together — one class whose method calls its own helper,
and a `Main` that constructs it and calls across to it:

```ldp3
import System.IO.Console;
program Calls;

public bundle Main {
    public namespace app {

        public class Greeter {
            private int excitement;

            public constructor Greeter(int excitement) {
                this.excitement = excitement;
            }

            // A method that calls another method on the same object, through this.
            public method greet() returns void {
                System.IO.Console.println($"hello (level {this.level()})");
                return;
            }

            public method level() returns int {
                return this.excitement * 2;
            }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Greeter g = new Greeter(3) on stack;
                g.greet();                        // call across to another object -> "hello (level 6)"
                System.IO.Console.println($"max = {Main.max(4, 9)}");   // static call on this class
                return;
            }

            // A static helper, called as Main.max(...)
            public static method max(int a, int b) returns int {
                return a > b ? a : b;
            }
        }
    }
}
```

## 3.6 Talking to the console

The most common thing a first program does is print, so it is worth pinning down the
console calls you will reach for constantly. They all live on `System.IO.Console` and
require `import System.IO.Console;` at the top of the file — nothing from the standard
library is available without an import.

- **`println(x)`** writes its argument followed by a newline.
- **`print(x)`** writes without a trailing newline.
- **`printf(format, args...)`** takes a C-style format string — `%d` for an integer, `%c`
  for a character, with `\n` and `\t` escapes — and substitutes the arguments in order.

A string on its own is **text, not a format**: `println("50% done")` prints a percent sign.
The format reading applies only when there are arguments to substitute, which is what
`printf` is for.

For building output from several values, **string interpolation** is usually clearer than
`printf`. Inside a `$"..."` string, each `{expr}` is evaluated and its value spliced into
the text:

```ldp3
import System.IO.Console;
program Printing;

public bundle Main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int x = 7;
                int y = 5;
                System.IO.Console.printf("x=%d y=%d\n", x, y);        // x=7 y=5
                System.IO.Console.println($"sum={x + y} max={x > y ? x : y}");  // sum=12 max=7
                System.IO.Console.print("no newline here");
                return;
            }
        }
    }
}
```

With variables, operators, expressions, statements, and the four call shapes in hand, you
can write the *body* of any method. The next chapter steps back up to the values those
statements move around — the primitive and composite types, and the rules that govern
them.
