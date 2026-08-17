# Standard Library — Numerical methods, statistics, and units

`import System.Science.Roots;` · `import System.Science.Normal;` · `import System.Memory.Units.Span;`

Two things that look unrelated and are the same idea: **a number on its own is not a quantity.** The
statistics half gives a number its distribution; the units half gives it its dimension. Both exist so
that the meaning travels with the value instead of living in a variable name.

---

## 1. Units — a literal suffix that produces a type

```polaron
import System.Memory.Units.Span;
import System.Memory.Units.Length;

Span timeout = 30 seconds;
Length far = 4 kilometres;
Speed pace = Speed.over(far, timeout);
```

Polaron's unit suffixes are `comptime literal` declarations: `30 seconds` is not an int, it is a
`Span`, decided at compile time and costing nothing at run time. A method taking a `Span` cannot be
handed a number of milliseconds by mistake, because a bare number is not a `Span` at all.

> The suffix mechanism existed for **bytes** alone — `64 kilobytes` — and everything else a program
> measures went back to being a bare number, which is how a timeout in seconds reaches a parameter
> expecting milliseconds with nothing said.

| Type | Suffixes | Reading it back |
|---|---|---|
| `Span` (time) | `nanoseconds`, `microseconds`, `milliseconds`, `seconds`, `minutes`, `hours`, `days` | `asNanoseconds()`, `asMicroseconds()`, `asMilliseconds()`, `asSeconds()`, … |
| `Length` | `micrometres`, `millimetres`, `centimetres`, `metres`, `kilometres` | `asMillimetres()`, `asMetres()`, … |
| `Mass` | `milligrams`, `grams`, `kilograms`, `tonnes` | `asGrams()`, `asKilograms()`, … |
| `Speed` | built from the other two: `Speed.over(Length, Span)` | `asMetresPerSecond()`, `asKilometresPerHour()` |
| `Turn` | `degrees`, `radians`, `turns` | `asDegrees()`, `asRadians()` |

The readers are named `asX()` and not `x()` deliberately: they **truncate**, and `asSeconds()` on
1500 milliseconds is 1. A method called `seconds()` would be read as "the seconds part", which is a
different number.

One representation per dimension, always — a `Span` is nanoseconds, a `Length` is micrometres — so
adding two of them is adding two integers, and no conversion happens where it could be lost.

---

## 2. Root finding

```polaron
import System.Science.Roots;

double r = Roots.brent(lambda[](double x) returns double { return x * x - 2.0; },
                       0.0, 2.0, 1e-12, 100);
```

| Member | Method | When |
|---|---|---|
| `Roots.bisect(f, lo, hi, tol, iters)` | Bisection | Always converges when the bracket has a sign change. Slow and certain. |
| `Roots.newton(f, df, x0, tol, iters)` | Newton–Raphson | Fast when you have the derivative and a good start. |
| `Roots.secant(f, a, b, tol, iters)` | Secant | Newton's speed without the derivative. |
| `Roots.brent(f, lo, hi, tol, iters)` | Brent | The default. Bisection's guarantee with the secant's speed. |

## 3. Calculus and differential equations

| Member | What it does |
|---|---|
| `Calculus.derivative(f, x)` / `secondDerivative(f, x)` | Central differences, at a step chosen from the magnitude of `x`. |
| `Calculus.integrate(f, a, b, n)` | Definite integral (Simpson). |
| `Ode.euler(f, t0, y0, t1, steps)` | The simplest integrator; useful when the step is already tiny. |
| `Ode.rungeKutta(f, t0, y0, t1, steps)` | Fourth-order Runge–Kutta: the one to use. |

## 4. Distributions

Each is `pdf`/`pmf`, `cdf`, and where it is meaningful `quantile`.

| Type | Parameters |
|---|---|
| `Normal` | `pdf(x, mean, sd)`, `cdf`, `quantile(p, mean, sd)` |
| `Exponential` | `pdf(x, rate)`, `cdf`, `quantile` |
| `Poisson` | `pmf(k, mean)`, `cdf` |
| `Binomial` | `pmf(k, n, p)`, `cdf` |
| `ChiSquare` | `cdf(x, df)`, `pValue(x, df)` |
| `StudentT` | `cdf(t, df)`, `pValue(t, df)` |

## 5. Hypothesis tests, optimisation, decomposition

| Member | What it does |
|---|---|
| `Hypothesis.tTestOneSample(sample, expected)` | Returns the p-value. |
| `Hypothesis.chiSquareGoodness(observed, expected)` | Likewise. |
| `Optimize.minimize(f, lo, hi, tol, iters)` | Golden-section minimisation of a one-dimensional function. |
| `Optimize.descend(f, start, rate, steps)` | Gradient descent, where `f` answers the gradient. |
| `Decompose.lu(a, n, perm)` | LU decomposition in place; returns the determinant's sign-adjusted product. |

## 6. Special functions

`Special.gamma`, `lgamma`, `beta`, `lbeta`, `erf`, `erfc`, `lowerGamma`, `incompleteBeta` — the
pieces the distributions above are built from, exposed because anybody implementing another
distribution needs exactly these.

---

## 7. Where the rest of the mathematics is

This page is the numerical-methods half. The algebraic half — `BigInteger`, `Rational`, `Complex`,
`Matrix`, `Vec2`/`Vec3`/`Vec4`, `Fft`, `Statistics`, number theory and geometry — is in
[Math, Net & Misc](math-net-misc.md).
