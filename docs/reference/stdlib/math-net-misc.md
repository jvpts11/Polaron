# LDP3 Standard Library — Math / Numerics / Net / Misc

This is the "everything numeric plus the outside world" half of the standard library: the
mathematics and numerics of `System.Math`, the cryptography of `System.Security`, the
sockets and HTTP client of `System.Net`, and a set of application-level building blocks in
`System.App`, rounded out by process results (`System.OS`) and an inline test framework
(`System.Test`).

Every type here is defined in the embedded prelude (the `kPreludeSource` raw string in
`src/cli/main.cpp`, lines ~6340–8360) and is written in **pure LDP3** over the compiler
builtins. The only exceptions are members marked `extern`, which link to a small runtime
helper for things the language can't do on its own — reading the OS CSPRNG
(`SecureRandom`), or talking to the network stack (`Socket`, `UdpSocket`, `Http`). Because
`System.Math` leans on its own `Numerics` class for transcendental functions rather than a
native math library, the scientific types work unchanged in freestanding builds.

A note on numeric style you'll see throughout: much of `System.Math` is deliberately
**integer-first**. `Stats`, `Matrix`, `Polygon`, and friends compute in `int`/`long` so
results are exact and reproducible, with parallel `double` types (`MatrixD`, `Vector2/3/4`,
`Numerics`, `Regression`) provided where floating point is the point. Immutable value types
(`BigInteger`, `Rational`, `Complex`, `Quaternion`, `Money`) return **new** objects from
each operation rather than mutating in place, matching LDP3's copy-by-value model.

All stdlib types require an **explicit import**. The import names the fully-qualified type,
e.g. `import System.Math.BigInteger;` or `import System.Net.Http;`. Each type below lists its
namespace and the exact import line.

Signatures are reproduced verbatim from the source. Only **public** members are listed
(constructors, public instance methods, public static methods, and public fields); private
helpers are omitted.

Namespaces covered:

- `System.Math` — big integers, number theory, statistics, linear algebra, geometry,
  transcendental functions, graphics/animation math, probabilistic sketches.
- `System.OS` — process results.
- `System.Security` — secure randomness and AES.
- `System.Net` — TCP/UDP sockets and a minimal HTTP client.
- `System.App` — resilience, rate limiting, a stack VM, feature flags, pooling, money.
- `System.Test` — the inline unit-test framework.

---

# System.Math

By far the largest namespace here, `System.Math` spans several families you can pick from by
task: exact number types (`BigInteger`, `Rational`, `Complex`, `Quaternion`); number theory
and combinatorics (`IntMath`, `NumberTheory`, `Sieve`, `Factorize`, `Crt`, `Combinatorics`);
statistics (`Stats`, `RunningStats`, `Regression`, `Correlation`); linear algebra (`Matrix`,
`MatrixD`, `Mat4`, the `Vector*` types, `GaussSolver`, `Fft`); computational geometry
(`Polygon`, `ConvexHull`); graphics and animation math (`Interpolation`, `Easing`, `Angle`);
probabilistic sketches for streaming data (`CountMinSketch`, `HyperLogLog`); and the
self-contained transcendental functions in `Numerics` that everything floating-point builds
on. Nothing here shadows a user class called `Math` — the integer helpers deliberately live
under `IntMath`.

## BigInteger

**Namespace:** `System.Math` · **Import:** `import System.Math.BigInteger;`

Arbitrary-precision signed integer (spec 34). Decimal digits (0..9) are stored
least-significant-first in an `int[]` with a separate sign flag. Supports construction from
`long`, sign-aware add/subtract/multiply/divide/remainder, comparison, and decimal rendering.
Use it when a product or sum would overflow `long` — a `BigInteger` grows its digit buffer
as needed. It is an immutable value type: each operation returns a fresh `BigInteger`, so
the operands are never modified. Note that construction is from `long`, so wrap literals in
`cast<long>(...)`.

```ldp3
import System.Math.BigInteger;

BigInteger a = new BigInteger(cast<long>(123456789)) on heap;
BigInteger b = new BigInteger(cast<long>(987654321)) on heap;
BigInteger product = a.multiply(b);        // 121932631112635269 — overflows a 32-bit int
System.IO.Console.println(product.toString());
```

- `public constructor BigInteger(long value)` — build from a signed 64-bit value.
- `public method isZero() returns boolean` — whether the value is exactly zero.
- `public method add(BigInteger other) returns BigInteger` — sign-aware sum (new value).
- `public method subtract(BigInteger other) returns BigInteger` — sign-aware difference (new value).
- `public method multiply(BigInteger other) returns BigInteger` — long multiplication with sign (new value).
- `public method compareTo(BigInteger other) returns int` — sign-aware compare: -1, 0, or 1.
- `public method divide(BigInteger other) returns BigInteger` — quotient truncated toward zero (zero on divide-by-zero).
- `public method remainder(BigInteger other) returns BigInteger` — remainder whose sign follows the dividend (zero on divide-by-zero).
- `public method toString() returns String` — decimal string, with a leading `-` when negative.

## IntMath

**Namespace:** `System.Math` · **Import:** `import System.Math.IntMath;`

Integer math helpers (spec 34.6) on plain `int`s, with no floating point: gcd/lcm, factorial,
primality, integer power and square root, combinatorics, modular exponentiation, and digit
utilities. (Named `IntMath` so it never shadows a user class called `Math`.)

- `public static method gcd(int a, int b) returns int` — greatest common divisor via Euclid (handles negatives).
- `public static method lcm(int a, int b) returns int` — least common multiple (0 when either input is 0).
- `public static method factorial(int n) returns int` — n! computed in an `int`.
- `public static method isPrime(int n) returns boolean` — primality by trial division.
- `public static method ipow(int base, int exp) returns int` — integer base raised to exp.
- `public static method isqrt(int n) returns int` — floor of the square root (0 for negative n).
- `public static method nCr(int n, int r) returns int` — binomial coefficient, multiplying/dividing as it goes to stay exact.
- `public static method nPr(int n, int r) returns int` — number of ordered r-arrangements of n items.
- `public static method modpow(int base, int exp, int mod) returns int` — modular exponentiation by repeated squaring (64-bit intermediates).
- `public static method digitSum(int n) returns int` — sum of the decimal digits of |n|.
- `public static method reverseDigits(int n) returns int` — digits of |n| reversed as an integer.
- `public static method isPalindrome(int n) returns boolean` — whether n is a non-negative decimal palindrome.

## Rational

**Namespace:** `System.Math` · **Import:** `import System.Math.Rational;`

An exact fraction kept in lowest terms with a positive denominator (spec 34.6). The constructor
divides out the gcd and normalizes the sign; arithmetic returns new reduced Rationals.

- `public constructor Rational(int n, int d)` — build n/d, reduced and sign-normalized.
- `public method numerator() returns int` — the reduced numerator.
- `public method denominator() returns int` — the reduced (positive) denominator.
- `public method add(Rational o) returns Rational` — sum, reduced (new value).
- `public method sub(Rational o) returns Rational` — difference, reduced (new value).
- `public method mul(Rational o) returns Rational` — product, reduced (new value).
- `public method toDouble() returns double` — floating-point approximation num/den.

## Complex

**Namespace:** `System.Math` · **Import:** `import System.Math.Complex;`

A complex number with `double` real and imaginary parts (spec 34.6). Immutable: `add`,
`sub`, `mul`, and `conjugate` each return a new `Complex`. Useful anywhere a computation
needs the imaginary axis — signal processing, root-finding, or feeding the `Fft`.

```ldp3
import System.Math.Complex;

Complex p = new Complex(1.0, 2.0) on heap;
Complex q = p.mul(new Complex(3.0, 4.0) on heap);   // (1+2i)(3+4i) = -5 + 10i
System.IO.Console.printf("%d + %di\n", cast<int>(q.real()), cast<int>(q.imag()));
```

- `public constructor Complex(double re, double im)` — build re + im·i.
- `public method real() returns double` — the real part.
- `public method imag() returns double` — the imaginary part.
- `public method add(Complex o) returns Complex` — complex sum (new value).
- `public method sub(Complex o) returns Complex` — complex difference (new value).
- `public method mul(Complex o) returns Complex` — complex product (new value).
- `public method conjugate() returns Complex` — the complex conjugate (new value).

## Stats

**Namespace:** `System.Math` · **Import:** `import System.Math.Stats;`

Summary statistics over an `int[]` (spec 34.6): totals, central tendency, spread, and order
statistics on a sorted copy. All results are integer-valued, which keeps them exact and
reproducible; when you need fractional means or variances, accumulate `double`s through
`RunningStats` (Welford) instead. Order statistics (`median`, `percentile`) sort a copy, so
the input array is left untouched.

```ldp3
import System.Math.Stats;

mutable int[] xs = new int[5]();
xs[0] = 4; xs[1] = 8; xs[2] = 15; xs[3] = 16; xs[4] = 23;
System.IO.Console.printf("sum=%d mean=%d median=%d p90=%d\n",
    Stats.sum(xs), Stats.mean(xs), Stats.median(xs), Stats.percentile(xs, 90));
// sum=66 mean=13 median=15 p90=23
```

- `public static method sum(int[] xs) returns int` — sum of all values.
- `public static method mean(int[] xs) returns int` — integer arithmetic mean (0 for empty).
- `public static method min(int[] xs) returns int` — smallest value.
- `public static method max(int[] xs) returns int` — largest value.
- `public static method variance(int[] xs) returns int` — population variance about the integer mean (0 for empty).
- `public static method stddev(int[] xs) returns int` — population standard deviation (isqrt of the variance).
- `public static method median(int[] xs) returns int` — middle value of a sorted copy; upper-middle for an even count.
- `public static method range(int[] xs) returns int` — max minus min (0 for empty).
- `public static method mode(int[] xs) returns int` — most frequent value; ties resolve to the first to reach the top count.
- `public static method percentile(int[] xs, int p) returns int` — value at percentile p in [0,100] by nearest-rank on a sorted copy.

## Dual

**Namespace:** `System.Math` · **Import:** `import System.Math.Dual;`

Forward-mode automatic differentiation via dual numbers (spec 34.6): each value carries its
derivative, and arithmetic propagates the chain rule. Evaluate a function with `variable(x)` and
read `deriv()` for the exact derivative at x; `constant(c)` has derivative 0.

- `public constructor Dual(double value, double deriv)` — build a dual number (value, derivative).
- `public static method variable(double x) returns Dual` — a seed variable at x (derivative 1).
- `public static method constant(double x) returns Dual` — a constant x (derivative 0).
- `public method value() returns double` — the primal value.
- `public method deriv() returns double` — the accumulated derivative.
- `public method add(Dual o) returns Dual` — sum with chain rule (new value).
- `public method sub(Dual o) returns Dual` — difference with chain rule (new value).
- `public method mul(Dual o) returns Dual` — product with the product rule (new value).

## Matrix

**Namespace:** `System.Math` · **Import:** `import System.Math.Matrix;`

A dense integer matrix stored row-major in one flat `int[]` (spec 34.6). Construction gives
you a zero-filled matrix you fill with `set`; `multiply`, `add`, and `transpose` return new
matrices, and `determinant` uses fraction-free Bareiss elimination so the result stays an
exact integer. For floating-point linear algebra (LU-style determinants, non-integer data)
use `MatrixD` instead.

```ldp3
import System.Math.Matrix;

mutable Matrix a = new Matrix(2, 2) on heap;
a.set(0, 0, 1); a.set(0, 1, 2);
a.set(1, 0, 3); a.set(1, 1, 4);
Matrix aT = a.transpose();
Matrix sq = a.multiply(a);            // ordinary matrix product (new matrix)
System.IO.Console.printf("det=%d\n", a.determinant());   // det=-2
```

- `public constructor Matrix(int rows, int cols)` — allocate a zero-filled rows×cols matrix.
- `public method rows() returns int` — row count.
- `public method cols() returns int` — column count.
- `public method set(int r, int c, int value) returns void` — store value at (r, c).
- `public method get(int r, int c) returns int` — read the element at (r, c).
- `public method multiply(Matrix o) returns Matrix` — matrix product (new matrix).
- `public method transpose() returns Matrix` — transpose (new matrix).
- `public method add(Matrix o) returns Matrix` — elementwise sum (new matrix).
- `public method determinant() returns int` — exact integer determinant via Bareiss fraction-free elimination (0 if singular; assumes square).

## Polynomial

**Namespace:** `System.Math` · **Import:** `import System.Math.Polynomial;`

A polynomial with integer coefficients in ascending order, coeff i multiplying x^i (spec 34.6).

- `public constructor Polynomial(int[] coeffs)` — build from ascending coefficients (index i is the x^i term).
- `public method degree() returns int` — the polynomial degree (length − 1).
- `public method coeff(int i) returns int` — the i-th coefficient (0 if out of range).
- `public method evaluate(int x) returns int` — evaluate at x via Horner's method.
- `public method derivative() returns Polynomial` — the differentiated polynomial (new value).

## IntVector

**Namespace:** `System.Math` · **Import:** `import System.Math.IntVector;`

A fixed-length integer vector (spec 34.6). For floating SIMD vectors use the built-in
`vec2`/`vec3`/`vec4` types instead.

- `public constructor IntVector(int[] elems)` — wrap the given elements.
- `public method get(int i) returns int` — the i-th component.
- `public method size() returns int` — component count.
- `public method dot(IntVector o) returns int` — dot product.
- `public method normSquared() returns int` — squared Euclidean length.

## Sieve

**Namespace:** `System.Math` · **Import:** `import System.Math.Sieve;`

The sieve of Eratosthenes up to a limit (spec 34.6): the constructor marks composites once, then
lookups are constant-time.

- `public constructor Sieve(int limit)` — sieve all integers up to `limit` inclusive.
- `public method isPrime(int n) returns boolean` — constant-time primality within the sieved range.
- `public method count() returns int` — number of primes found up to the limit.

## Xorshift

**Namespace:** `System.Math` · **Import:** `import System.Math.Xorshift;`

A fast deterministic pseudo-random generator (xorshift32, spec 34.6): the same seed always
yields the same sequence, unlike the wall-clock-seeded `Random`.

- `public constructor Xorshift(int seed)` — seed the generator (a 0 seed is bumped to 1).
- `public method next() returns int` — the next raw 32-bit value.
- `public method nextInRange(int n) returns int` — a non-negative value in [0, n).

## GaussSolver

**Namespace:** `System.Math` · **Import:** `import System.Math.GaussSolver;`

A dense linear-system solver (spec 34.6) via Gaussian elimination with partial pivoting, using
`double` throughout.

- `public static method solve(double[] aug, int n) returns double[]` — solve [A|b] given as a flat row-major n×(n+1) augmented matrix (overwritten in place); returns the solution vector x.

## RunningStats

**Namespace:** `System.Math` · **Import:** `import System.Math.RunningStats;`

Online mean and variance via Welford's algorithm (spec 34.6): add samples one at a time in O(1)
space, then read the running statistics without keeping the data.

- `public constructor RunningStats()` — start an empty accumulator.
- `public method add(double x) returns void` — incorporate one sample.
- `public method getMean() returns double` — the running mean.
- `public method populationVariance() returns double` — population variance (0 with fewer than 1 sample).
- `public method sampleVariance() returns double` — sample variance (0 with fewer than 2 samples).
- `public method count() returns int` — number of samples seen.

## NumberTheory

**Namespace:** `System.Math` · **Import:** `import System.Math.NumberTheory;`

Number-theory toolkit (spec 34.6): gcd/lcm, fast modular exponentiation, deterministic
Miller-Rabin primality for 32-bit ints (witnesses 2, 3, 5, 7), and modular inverse.

- `public static method gcd(int a, int b) returns int` — greatest common divisor (handles negatives).
- `public static method lcm(int a, int b) returns int` — least common multiple (0 when either is 0).
- `public static method modpow(long base, long exp, long mod) returns long` — modular exponentiation by repeated squaring, in `long`.
- `public static method isPrime(int num) returns boolean` — deterministic Miller-Rabin primality for 32-bit ints.
- `public static method modInverse(int a, int m) returns int` — modular inverse via extended Euclid (−1 when a is not invertible mod m).

## Crt

**Namespace:** `System.Math` · **Import:** `import System.Math.Crt;`

Chinese remainder theorem (spec 34.6): solve x ≡ a[i] (mod n[i]) for pairwise-coprime moduli.

- `public static method solve(int[] a, int[] n, int k) returns long` — least non-negative x satisfying the first k congruences.

## Factorize

**Namespace:** `System.Math` · **Import:** `import System.Math.Factorize;`

Integer factorization by trial division (spec 34.6).

- `public static method largestPrimeFactor(int num) returns int` — the largest prime factor of num.
- `public static method factorCount(int num) returns int` — count of prime factors with multiplicity.

## Combinatorics

**Namespace:** `System.Math` · **Import:** `import System.Math.Combinatorics;`

Combinatorics (spec 34.6): factorials and binomials in `long`, Catalan numbers, and in-place
permutation enumeration.

- `public static method factorial(int n) returns long` — n! in a `long`.
- `public static method choose(int n, int k) returns long` — binomial coefficient (0 when k out of range).
- `public static method catalan(int n) returns long` — the nth Catalan number.
- `public static method nextPermutation(int[] a, int n) returns boolean` — advance a[0..n) to the next lexicographic permutation in place; false past the last.

## Polygon

**Namespace:** `System.Math` · **Import:** `import System.Math.Polygon;`

Planar geometry over integer coordinates given as parallel xs/ys arrays (spec 34.6).

- `public static method area2(int[] xs, int[] ys, int n) returns int` — twice the shoelace area (doubled so integer inputs stay integer), always non-negative.
- `public static method contains(int[] xs, int[] ys, int n, int px, int py) returns boolean` — point-in-polygon by ray casting.

## ConvexHull

**Namespace:** `System.Math` · **Import:** `import System.Math.ConvexHull;`

Convex hull of a point set (spec 34.6) by Andrew's monotone chain, given parallel xs/ys arrays.

- `public static method size(int[] xs, int[] ys, int n) returns int` — number of hull vertices, dropping collinear points.

## CountMinSketch

**Namespace:** `System.Math` · **Import:** `import System.Math.CountMinSketch;`

Count-Min sketch (spec 34.1): a sub-linear frequency estimator over `depth` independent hash
rows. Estimates never underestimate (and are exact when the width avoids collisions).

- `public constructor CountMinSketch(int width, int depth)` — allocate a width×depth counter table.
- `public method add(String key, int count) returns void` — accumulate count for a key across all rows.
- `public method estimate(String key) returns int` — estimated frequency (the minimum matching row).

## HyperLogLog

**Namespace:** `System.Math` · **Import:** `import System.Math.HyperLogLog;`

HyperLogLog (spec 34.1): estimates distinct-element count in near-constant memory. Precision is
log2 of the register count (e.g. 10 → 1024 registers, ~3% error).

- `public constructor HyperLogLog(int precision)` — allocate 2^precision registers.
- `public method add(String key) returns void` — record one observed key.
- `public method estimate() returns int` — estimated cardinality, with linear counting in the small range.

## Numerics

**Namespace:** `System.Math` · **Import:** `import System.Math.Numerics;`

Self-contained transcendental functions in pure LDP3 (spec 34.6), so scientific classes never
depend on the `Math` builtin. sqrt is Newton's method; ln uses an atanh series; exp/sin/cos use
range-reduction plus Taylor series; pow is exp(e·ln(b)) for positive b.

- `public static method pi() returns double` — the constant π.
- `public static method abs(double x) returns double` — absolute value.
- `public static method sqrt(double x) returns double` — square root (0 for x ≤ 0).
- `public static method ln(double x) returns double` — natural logarithm (0 for x ≤ 0).
- `public static method exp(double x) returns double` — e^x.
- `public static method sin(double x) returns double` — sine.
- `public static method cos(double x) returns double` — cosine.
- `public static method pow(double b, double e) returns double` — b^e for positive b (0 when b ≤ 0).

## Interpolation

**Namespace:** `System.Math` · **Import:** `import System.Math.Interpolation;`

Interpolation helpers for animation and graphics (spec 34.6).

- `public static method lerp(double a, double b, double t) returns double` — linear interpolation a→b by t.
- `public static method inverseLerp(double a, double b, double v) returns double` — the t that maps to v (0 when a == b).
- `public static method clamp(double v, double lo, double hi) returns double` — clamp v into [lo, hi].
- `public static method smoothstep(double edge0, double edge1, double x) returns double` — Hermite smoothstep between the edges.
- `public static method remap(double v, double inLo, double inHi, double outLo, double outHi) returns double` — remap v from one range to another.

## Bits

**Namespace:** `System.Math` · **Import:** `import System.Math.Bits;`

Bit-twiddling helpers over 32-bit words (spec 34.6), using `uint` for logical (zero-fill) shifts.

- `public static method popcount(int x) returns int` — number of set bits.
- `public static method leadingZeros(int x) returns int` — count of leading zero bits (32 for 0).
- `public static method trailingZeros(int x) returns int` — count of trailing zero bits (32 for 0).
- `public static method isPow2(int n) returns boolean` — whether n is a positive power of two.
- `public static method nextPow2(int n) returns int` — smallest power of two ≥ n (1 for n ≤ 1).
- `public static method reverse(int x) returns int` — full 32-bit reversal.

## Vector2

**Namespace:** `System.Math` · **Import:** `import System.Math.Vector2;`

A 2D vector of doubles (spec 34.6). The components are public mutable fields; arithmetic returns
new heap vectors.

- `public mutable double x` — the x component (public field).
- `public mutable double y` — the y component (public field).
- `public constructor Vector2(double x, double y)` — build (x, y).
- `public method add(Vector2 o) returns Vector2` — vector sum (new value).
- `public method sub(Vector2 o) returns Vector2` — vector difference (new value).
- `public method scale(double s) returns Vector2` — scalar multiple (new value).
- `public method dot(Vector2 o) returns double` — dot product.
- `public method length() returns double` — Euclidean length (via Numerics.sqrt).

## Vector4

**Namespace:** `System.Math` · **Import:** `import System.Math.Vector4;`

A 4D vector of doubles, e.g. homogeneous coordinates (spec 34.6). Components are public mutable
fields.

- `public mutable double x` — the x component (public field).
- `public mutable double y` — the y component (public field).
- `public mutable double z` — the z component (public field).
- `public mutable double w` — the w component (public field).
- `public constructor Vector4(double x, double y, double z, double w)` — build (x, y, z, w).
- `public method add(Vector4 o) returns Vector4` — vector sum (new value).
- `public method dot(Vector4 o) returns double` — dot product.
- `public method length() returns double` — Euclidean length (via Numerics.sqrt).

## Easing

**Namespace:** `System.Math` · **Import:** `import System.Math.Easing;`

Easing curves mapping t in [0,1] to [0,1] for animation (spec 34.6).

- `public static method quadIn(double t) returns double` — quadratic ease-in.
- `public static method quadOut(double t) returns double` — quadratic ease-out.
- `public static method cubicIn(double t) returns double` — cubic ease-in.
- `public static method cubicOut(double t) returns double` — cubic ease-out.

## Angle

**Namespace:** `System.Math` · **Import:** `import System.Math.Angle;`

Angle conversions (spec 34.6).

- `public static method toRadians(double deg) returns double` — degrees to radians.
- `public static method toDegrees(double rad) returns double` — radians to degrees.

## Mat4

**Namespace:** `System.Math` · **Import:** `import System.Math.Mat4;`

A 4×4 matrix in row-major storage for 3D transforms (spec 34.6). Pairs with Vector4; each
operation returns a new matrix.

- `public constructor Mat4()` — allocate a zero-filled 4×4 matrix.
- `public static method identity() returns Mat4` — the identity matrix (new value).
- `public method get(int r, int c) returns double` — read the element at (r, c).
- `public method set(int r, int c, double v) returns void` — store v at (r, c).
- `public method multiply(Mat4 o) returns Mat4` — matrix product (new value).
- `public method transpose() returns Mat4` — transpose (new value).

## Fft

**Namespace:** `System.Math` · **Import:** `import System.Math.Fft;`

Radix-2 fast Fourier transform (spec 34.6), iterative Cooley-Tukey over parallel real/imag arrays
whose length is a power of two. `inverse(forward(x)) == x`.

- `public static method forward(double[] re, double[] im, int n) returns void` — forward transform in place.
- `public static method inverse(double[] re, double[] im, int n) returns void` — inverse transform in place, divided by n.

## Regression

**Namespace:** `System.Math` · **Import:** `import System.Math.Regression;`

Ordinary least-squares linear regression (spec 34.6): fit y = slope·x + intercept from parallel
arrays and report the coefficient of determination r².

- `public constructor Regression(double[] x, double[] y, int n)` — fit the line over the first n points.
- `public method getSlope() returns double` — the fitted slope.
- `public method getIntercept() returns double` — the fitted intercept.
- `public method getR2() returns double` — the coefficient of determination r².
- `public method predict(double x) returns double` — the fitted value at x.

## Correlation

**Namespace:** `System.Math` · **Import:** `import System.Math.Correlation;`

Pearson correlation coefficient (spec 34.6).

- `public static method pearson(double[] x, double[] y, int n) returns double` — correlation in [−1, 1] over the first n pairs (0 when a spread is degenerate).

## Quaternion

**Namespace:** `System.Math` · **Import:** `import System.Math.Quaternion;`

Quaternions for 3D rotation math (spec 34.6): Hamilton product, conjugate, magnitude and
normalize. Immutable; operations return new heap quaternions.

- `public constructor Quaternion(double w, double x, double y, double z)` — build (w, x, y, z).
- `public method getW() returns double` — the scalar component w.
- `public method getX() returns double` — the i component x.
- `public method getY() returns double` — the j component y.
- `public method getZ() returns double` — the k component z.
- `public method magnitude() returns double` — Euclidean norm (via Numerics.sqrt).
- `public method conjugate() returns Quaternion` — the conjugate (new value).
- `public method mul(Quaternion o) returns Quaternion` — Hamilton product (new value).
- `public method normalize() returns Quaternion` — unit quaternion (identity when magnitude is 0).

## MatrixD

**Namespace:** `System.Math` · **Import:** `import System.Math.MatrixD;`

A dense `double` matrix stored row-major (spec 34.6).

- `public constructor MatrixD(int rows, int cols)` — allocate a zero-filled rows×cols matrix.
- `public method set(int r, int c, double v) returns void` — store v at (r, c).
- `public method get(int r, int c) returns double` — read the element at (r, c).
- `public method rowCount() returns int` — row count.
- `public method colCount() returns int` — column count.
- `public method mul(MatrixD o) returns MatrixD` — matrix product (new value).
- `public method transpose() returns MatrixD` — transpose (new value).
- `public method determinant() returns double` — determinant by Gaussian elimination with partial pivoting (0 if singular).

## Vector3

**Namespace:** `System.Math` · **Import:** `import System.Math.Vector3;`

A 3D vector of doubles (spec 34.6). Immutable; operations return new heap vectors.

- `public constructor Vector3(double x, double y, double z)` — build (x, y, z).
- `public method getX() returns double` — the x component.
- `public method getY() returns double` — the y component.
- `public method getZ() returns double` — the z component.
- `public method add(Vector3 o) returns Vector3` — vector sum (new value).
- `public method sub(Vector3 o) returns Vector3` — vector difference (new value).
- `public method scale(double s) returns Vector3` — scalar multiple (new value).
- `public method dot(Vector3 o) returns double` — dot product.
- `public method cross(Vector3 o) returns Vector3` — cross product (new value).
- `public method length() returns double` — Euclidean length (via Numerics.sqrt).
- `public method normalize() returns Vector3` — unit vector (zero vector when length is 0).

---

# System.OS

## ProcessResult

**Namespace:** `System.OS` · **Import:** `import System.OS.ProcessResult;`

The result of running a subprocess (spec 34): its captured stdout and exit code. Built by the
`Process.run(cmd)` builtin, which runs the command through the shell.

- `public String output` — the captured standard output (public field).
- `public int exitCode` — the process exit code (public field).
- `public constructor ProcessResult(String output, int exitCode)` — build from output and exit code.
- `public method success() returns boolean` — whether the exit code is 0.

---

# System.Security

## SecureRandom

**Namespace:** `System.Security` · **Import:** `import System.Security.SecureRandom;`

A cryptographically secure random source (spec 34): 64 bits per draw from the OS CSPRNG, suitable
for keys, tokens and nonces (unlike `System.Math.Random`, which is a fast PRNG). The draw links to
a runtime helper via `extern`.

- `public constructor SecureRandom()` — open the secure source.
- `public method nextLong() returns long` — 64 random bits.
- `public method nextInt() returns int` — a non-negative 31-bit random int.
- `public method nextIntMax(int max) returns int` — a random int in [0, max).
- `public method nextBool() returns boolean` — a random boolean.
- `public method nextDouble() returns double` — a random double in [0, 1) (52-bit mantissa).
- `public method nextBytes(int n) returns int[]` — n random bytes as ints in 0..255.

## Aes

**Namespace:** `System.Security` · **Import:** `import System.Security.Aes;`

AES block cipher (spec 34; FIPS-197), pure LDP3. Supports 128- and 256-bit keys (16 or 32 bytes);
S-boxes are generated from the GF(2^8) inverse plus the affine transform. `encryptBlock`/
`decryptBlock` are the raw 16-byte ECB primitive; `ctr()` is the recommended stream mode
(encryption and decryption are the same call). Bytes are carried as ints in 0..255.

- `public constructor Aes(int[] key)` — build a cipher from a 16- or 32-byte key (expands the round keys).
- `public method encryptBlock(int[] input) returns int[]` — encrypt one 16-byte block (ECB).
- `public method decryptBlock(int[] input) returns int[]` — decrypt one 16-byte block (ECB).
- `public method ctr(int[] data, int[] iv) returns int[]` — CTR-mode keystream XORed with the data; symmetric, no padding. iv is a 16-byte nonce/counter start.

---

# System.Net

The networking namespace is thin and blocking by design: a handful of classes that wrap OS
socket handles through `extern` runtime helpers. `Socket`/`ServerSocket` are the TCP pair
(connect a client, or bind-listen-accept a server); `UdpSocket`/`Datagram` cover
connectionless UDP; and `Http`/`HttpResponse` layer a minimal HTTP/1.1 GET client on top of
`Socket`. There is no async here — a `receive` blocks until data arrives — so for
concurrency, drive sockets from `System.Thread` workers. Because the transport is `extern`,
these types are the one part of this reference that does not run in freestanding builds.

## Socket

**Namespace:** `System.Net` · **Import:** `import System.Net.Socket;`

A blocking TCP socket (spec 34) wrapping an OS handle (or −1 on failure). Build a client with
`Socket.connect`; `ServerSocket.accept()` also hands back a Socket. Send/receive/close lower to
runtime winsock helpers.

- `public constructor Socket(long handle)` — wrap an existing OS socket handle.
- `public static method connect(String host, int port) returns Socket` — open a client connection.
- `public method isOpen() returns boolean` — whether the handle is valid (≥ 0).
- `public method send(String data) returns long` — send bytes; returns the count sent.
- `public method receive(int max) returns String` — receive up to max bytes.
- `public method close() returns void` — close the socket.

## ServerSocket

**Namespace:** `System.Net` · **Import:** `import System.Net.ServerSocket;`

A listening TCP server socket (spec 34): bind+listen on a port, then accept the next connection.

- `public constructor ServerSocket(int port)` — bind and listen on the given port.
- `public method isOpen() returns boolean` — whether the listening handle is valid (≥ 0).
- `public method accept() returns Socket` — block for the next connection and return its Socket.
- `public method close() returns void` — close the listening socket.

## Datagram

**Namespace:** `System.Net` · **Import:** `import System.Net.Datagram;`

A received datagram (spec 34): its payload plus the sender's address, so a server can reply.

- `public String data` — the payload (public field).
- `public String host` — the sender's host (public field).
- `public int port` — the sender's port (public field).
- `public constructor Datagram(String data, String host, int port)` — build from payload and sender address.

## UdpSocket

**Namespace:** `System.Net` · **Import:** `import System.Net.UdpSocket;`

A UDP socket (spec 34): connectionless datagrams. Open with port 0 for an ephemeral client port,
or a fixed port to receive on.

- `public constructor UdpSocket(int port)` — open a UDP socket on the given port (0 = ephemeral).
- `public method isOpen() returns boolean` — whether the handle is valid (≥ 0).
- `public method send(String host, int port, String data) returns long` — send a datagram to an address; returns the count sent.
- `public method receive(int max) returns Datagram` — receive a datagram (payload plus the sender's address).
- `public method close() returns void` — close the socket.

## HttpResponse

**Namespace:** `System.Net` · **Import:** `import System.Net.HttpResponse;`

A parsed HTTP response (spec 34): the raw text is kept and queried lazily.

- `public constructor HttpResponse(String raw)` — wrap a raw response string.
- `public method raw() returns String` — the full raw response text.
- `public method status() returns int` — the status code from the start line (0 if unparseable).
- `public method body() returns String` — everything after the blank line ("" if none).
- `public method header(String name) returns String` — a header field's value ("" if absent).

## Http

**Namespace:** `System.Net` · **Import:** `import System.Net.Http;`

A minimal HTTP/1.1 client over Socket (spec 34). Request building and response parsing are pure;
`get` performs the network round-trip. `get` opens a `Socket`, sends a `GET` with
`Connection: close`, drains the whole reply, and hands back an `HttpResponse` you can query
for the status code, body, and individual headers. It is intentionally small — one verb, no
TLS, no redirects — for talking to plain-HTTP services and health-check endpoints.

```ldp3
import System.Net.Http;
import System.Net.HttpResponse;

HttpResponse res = Http.get("example.com", 80, "/");
System.IO.Console.printf("status=%d\n", res.status());
System.IO.Console.println(res.header("Content-Type"));
System.IO.Console.println(res.body());
```

- `public static method buildRequest(String verb, String host, String path) returns String` — format a request line with Host and Connection: close headers.
- `public static method get(String host, int port, String path) returns HttpResponse` — open a socket, send a GET, drain the reply, and parse it.

---

# System.App

## CircuitBreaker

**Namespace:** `System.App` · **Import:** `import System.App.CircuitBreaker;`

Circuit breaker (spec 34): trips open after `threshold` consecutive failures and rejects calls
until a cooldown passes, then allows one trial (half-open); a success closes it, a failure reopens
it. Time is passed in explicitly (milliseconds) so behavior is deterministic.

- `public constructor CircuitBreaker(int threshold, long cooldownMs)` — build with a failure threshold and cooldown.
- `public method allow(long now) returns boolean` — whether a call is permitted at time `now`.
- `public method recordSuccess() returns void` — record a success (closes the breaker).
- `public method recordFailure(long now) returns void` — record a failure (may open the breaker).
- `public method getState() returns int` — current state: 0 closed, 1 open, 2 half-open.

## TokenBucket

**Namespace:** `System.App` · **Import:** `import System.App.TokenBucket;`

Token-bucket rate limiter (spec 34): tokens refill continuously at `ratePerMs` up to capacity;
each acquire spends tokens if enough are available. Time is passed in explicitly (milliseconds).

- `public constructor TokenBucket(double capacity, double ratePerMs)` — build with a capacity and refill rate.
- `public method tryAcquire(long now, int count) returns boolean` — refill to `now` and spend `count` tokens if available.

## StackVm

**Namespace:** `System.App` · **Import:** `import System.App.StackVm;`

A tiny stack virtual machine (spec 34): executes a flat program of (opcode, operand) pairs against
an operand stack and a small memory. Opcodes: 0 HALT, 1 PUSH v, 2 STORE a, 3 LOAD a, 4 MUL, 5 SUB,
6 JZ t, 7 JMP t, 8 ADD (jump targets are instruction indices).

- `public static method run(int[] prog, int plen, int memSize) returns int` — run the program (plen ints, memSize memory cells) and return the top of the stack.

## FeatureFlags

**Namespace:** `System.App` · **Import:** `import System.App.FeatureFlags;`

Named feature flags (spec 34): enable/disable toggles by name, defaulting to off when unset.

- `public constructor FeatureFlags()` — start with all flags off.
- `public method enable(String name) returns void` — turn a flag on.
- `public method disable(String name) returns void` — turn a flag off.
- `public method isEnabled(String name) returns boolean` — whether a flag is on (false when unset).

## ObjectPool

**Namespace:** `System.App` · **Import:** `import System.App.ObjectPool;`

A fixed-capacity pool of reusable integer ids (spec 34).

- `public constructor ObjectPool(int capacity)` — build a pool of the given capacity.
- `public method acquire() returns int` — hand out a fresh or recycled id (−1 when exhausted).
- `public method recycle(int id) returns void` — return an id for reuse.
- `public method inUse() returns int` — count of live (unrecycled) ids.

## Money

**Namespace:** `System.App` · **Import:** `import System.App.Money;`

Fixed-point money as integer cents (spec 34), avoiding floating-point rounding.

- `public constructor Money(long cents)` — build an amount in cents.
- `public method getCents() returns long` — the amount in cents.
- `public method plus(Money o) returns Money` — sum (new value).
- `public method minus(Money o) returns Money` — difference (new value).
- `public method times(int factor) returns Money` — scaled amount (new value).
- `public method format() returns String` — a signed dollar string like "$12.34".

---

# System.Test

Tests live next to the code they test, as annotated static methods. There are no `test` or `assert`
keywords — it is all annotations, static methods and classes. `ldp3 test` (or `ldp3c --test`) finds
them, runs them, and exits non-zero if any failed.

Every annotation below may also be written `@Name`; the two spellings are identical (§10.3).

## The annotations

**Namespace:** `System.Test` · **Import:** `import System.Test.Test;`

| Annotation | Applies to | Meaning |
|---|---|---|
| `[Test]` | `public static` method returning `boolean` or `void` | An inline test. Returning `boolean` makes the test its own verdict; returning `void` takes the verdict from its `Test.assert*` calls. |
| `[Ignore(reason: "...")]` | a `[Test]` method | Reported as SKIP with the reason, never run. Keeps a known-broken case visible instead of commented out. |
| `[BeforeAll]` / `[AfterAll]` | `public static` method returning `void` | Run **once** around the whole class — where an expensive fixture is built and released. Skipped entirely when `--filter` selected none of the class's tests. |
| `[Setup]` / `[Teardown]` | `public static` method returning `void` | Run around **each** test of the class. |
| `[Cases(source: "m")]` | a `[Test]` taking **one** parameter | Runs once per element of the array `m` returns, reported as `Class.method[i]`. `m` must be a `public static` method of the same class returning an array of the parameter's type. |
| `[Repeat(times: N)]` | a `[Test]` method | Runs the whole test N times and reports one verdict, naming the runs that failed. For flakiness. |
| `[ExpectedToFail(reason: "...")]` | a `[Test]` method | Inverts the verdict: failing is expected (XFAIL), **passing is a failure**. Unlike `[Ignore]`, it still runs. |
| `[Tag(name: "...")]` | a `[Test]` method, repeatable | Groups tests for `--tag` / `--exclude-tag`. |
| `[MaxTime(ms: N)]` | a `[Test]` method | A passing test that took longer becomes a failure. A budget checked after the fact, not a timeout: it does not abort a hang. |
| `[Benchmark(iterations: N, warmup: M)]` | `public static` method, no arguments, returning `void` | Measured, never judged: warmup pass, then the timed loop, reported as ns/op. Runs only under `--bench`. |

At most one hook of each kind per class: two would have no defined order. A malformed test, hook or
annotation — not static, wrong return type, `[Ignore]` on something that is not a test, a hook or a
benchmark that is also a test, a parameter with no `[Cases]`, a `[Cases]` source of the wrong type —
is a **compile error**, not a silent no-op.

```ldp3
import System.Test.Test;

public class Census {
    private static mutable int[] cells;

    [BeforeAll]
    public static method buildWorld() returns void {
        Census.cells = new int[64]();
        return;
    }

    [AfterAll]
    public static method dropWorld() returns void {
        delete Census.cells;
        return;
    }

    [Test]
    public static method values_stay_in_band() returns void {
        Test.checking("every cell holds a value in 0..6");
        mutable int i = 0;
        while (i < Census.cells.length()) {
            Test.assertBetween(Census.cells[i], 0, 6);
            i = i + 1;
        }
        return;
    }

    [Ignore(reason: "regrowth is not implemented yet")]
    [Test]
    public static method forest_regrows() returns void {
        Test.fail("would fail today");
        return;
    }
}
```

## Test

**Namespace:** `System.Test` · **Import:** `import System.Test.Test;`

The assertions. Each records a failure and prints what went wrong; the test's verdict is "no
assertion failed". The runner resets the state around every test, so nothing bleeds between them.

**Naming the check**

- `public static method checking(String what) returns void` — names what the assertions that follow
  are checking. A bare `assertBetween(pct, 8, 22)` reports only numbers and leaves the reader
  guessing *which* criterion broke; with a label the failure reads
  `[mountain share stays in band] expected 8..22, got 31`. Cleared at the start of every test, so it
  costs nothing when unused.
- `public static method fail(String why) returns void` — record a failure directly, for a check no
  assertion covers.
- `public static method skip(String why) returns void` — give up at runtime on an unmet precondition
  (no GPU, no network, a fixture that could not be built). Reported as SKIP, which is neither a pass
  nor a defect.

**Equality and predicates**

- `assertEqual(int actual, int expected)` · `assertNotEqual(int actual, int unexpected)`
- `assertEqualLong(long actual, long expected)` · `assertEqualString(String actual, String expected)`
- `assertEqualChar(char, char)` · `assertEqualBoolean(boolean, boolean)` · `assertEqualDouble(double, double)`
  (exact — almost always the wrong tool; reach for `assertWithin`/`assertNear`)
- `assertTrue(boolean condition)` · `assertFalse(boolean condition)`
- `assertContains(String haystack, String needle)` · `assertStartsWith(String, String)` ·
  `assertEndsWith(String, String)`

**Arrays** — every one of these reports the **first differing index**, which with a thousand elements
is the whole diagnosis.

- `assertEqualIntArray(int[], int[])` · `assertEqualLongArray(long[], long[])` ·
  `assertEqualStringArray(String[], String[])`
- `assertEqualDoubleArray(double[] actual, double[] expected, double tolerance)` — element-wise; a
  computed array is never bit-identical.
- `assertSorted(int[] values)` — ascending, naming the first pair that breaks it.

**Ranges and tolerances** — most measurements of a generated or simulated system are only ever
"within an acceptable band", and writing that as `assertTrue(v >= 8 && v <= 22)` throws away the
numbers the report needs.

- `assertBetween(int value, int low, int high)` — inclusive.
- `assertAtLeast(int value, int minimum)` · `assertAtMost(int value, int maximum)`
- `assertBetweenDouble(double value, double low, double high)`
- `assertWithin(double actual, double expected, double tolerance)` — absolute tolerance.
- `assertNear(double actual, double expected, double relativeTolerance)` — tolerance as a *fraction*
  of the expected value, for quantities whose scale varies. `0.05` means "within 5%". Falls back to
  an absolute comparison when the expected value is zero.
- `assertThrows<E>(function<void> action)` — the action must throw `E`.
- `assertDoesNotThrow(function<void> action)` — and this one must not. Without it, a test that
  swallows an unexpected exception higher up reads as a pass.

**Output** — for code whose job is to produce text.

- `captureOutput(function<void> action) returns String` — runs the action with its printing diverted
  and returns that text.
- `assertMatchesGolden(String actual, String goldenPath)` — compares against a file of expected text
  and reports the **first differing line**; `--update-golden` rewrites the file instead, which is how
  an intended change is accepted.
- `artifact(String path)` — names a file the test produced, so a failure points at the evidence.
- `tempDir() returns String` — a scratch directory, created on first use and deliberately not cleaned
  up: a failing test's leftovers are usually what explains it.

**Memory** — the assertion only a manually-managed language can offer.

- `assertNoLeaks(function<void> action)` — the action must give back everything it took. Measures the
  **calling thread**'s **net** live bytes, so work handed to another thread is not covered and a leak
  exactly balanced by a matching free reads as clean. The assertion machinery allocates too
  (`checking` stores its label as a `String`), so keep `Test.*` calls out of the measured action.
- `liveBytes() returns long` — the live heap total on this thread, for asserting an allocation
  *budget* rather than a leak.

The runner also calls `reset()`, `failures()`, `wasSkipped()` and `skipReason()`; they are public so
a custom harness can reuse the same state, but a test does not need them.

## Running them

| Command | What it does |
|---|---|
| `ldp3 test` | Build and run the project's tests. |
| `ldp3 test -- --filter <text>` | Run only the tests whose `Class.method` name contains `<text>`. |
| `ldp3 test -- --tag <name>` / `--exclude-tag <name>` | Select or skip by `[Tag]`. |
| `ldp3 test -- --list` | Print the test names without running anything. |
| `ldp3 test -- --timing` | Add per-test and total durations to the report. |
| `ldp3 test -- --fail-fast` | Stop at the first failure (`[AfterAll]` still runs). |
| `ldp3 test -- --format=json` | One machine-readable document, each test's own output captured into its record. |
| `ldp3 test -- --bench` | Also run the `[Benchmark]` methods. |
| `ldp3 test -- --update-golden` | Rewrite golden files instead of comparing. |

A `[library]` project is tested the same way: `ldp3 test` builds its sources as an executable (the
runner supplies the entry point) instead of the usual `.ldb` bundle.

The report is **deterministic by default** — durations are opt-in behind `--timing` — so it can be
diffed, pasted into a review, or compared against a golden file:

```
PASS Census.values_stay_in_band
SKIP Census.forest_regrows -- regrowth is not implemented yet
FAIL Census.setup_ran_for_this_test
tests: 1 passed, 1 failed, 1 skipped
```

## Assert

**Namespace:** `System.Test` · **Import:** `import System.Test.Assert;`

Boolean assertion helpers (spec 34): each returns whether the check holds, to be fed to
`TestRunner.check`.

- `public static method eq(int a, int b) returns boolean` — int equality.
- `public static method eqLong(long a, long b) returns boolean` — long equality.
- `public static method eqStr(String a, String b) returns boolean` — string equality.
- `public static method near(double a, double b, double eps) returns boolean` — doubles within an epsilon.
- `public static method isTrue(boolean c) returns boolean` — passes through a true condition.
- `public static method isFalse(boolean c) returns boolean` — negates a condition.

## TestRunner

**Namespace:** `System.Test` · **Import:** `import System.Test.TestRunner;`

A minimal unit-test runner (spec 34): tally pass/fail, print each result and a summary. Lets LDP3
code (and this stdlib) self-test.

- `public constructor TestRunner()` — start with no results.
- `public method check(String name, boolean cond) returns void` — tally a pass/fail for `name` and print a line.
- `public method passed() returns int` — number of checks passed.
- `public method failed() returns int` — number of checks failed.
- `public method allPassed() returns boolean` — whether every check held.
- `public method report() returns void` — print the "N passed, M failed" summary.
