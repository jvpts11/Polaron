# Stdlib Reference — Parsing, Text Utilities, Time & JSON

This reference documents three neighbouring slices of the LDP3 standard library: the text
and parsing utilities under `System.Text`, the clocks and calendars under `System.Time`,
and the JSON document model under `System.Json`. Together they cover the everyday "read a
string, make sense of it, and stamp it with a time" work that most programs need before
they get to their real logic.

Everything here lives in the LDP3 prelude embedded in the compiler (`src/cli/main.cpp`,
the `kPreludeSource` raw string) and is written in **pure LDP3** on top of the
`System.Collections` and `System.Text` builtins. There is no hidden native magic: a
`Csv` parser is an ordinary LDP3 class walking a `String`, a `Json` tree is a chain of
heap objects, and `Instant.now()` bottoms out in a single clock builtin. That means these
classes are also worked examples of idiomatic LDP3 — every one obeys the same rules your
own code does (mandatory `this.`, explicit visibility, braces on every block).

A few themes run through the group:

- **`System.Text`** is the largest namespace: tokenizers and expression evaluators
  (`Rpn`, `ShuntingYard`), config and data formats (`Csv`, `Ini`, `Properties`,
  `QueryString`), string metrics for fuzzy matching (`Levenshtein`, `JaroWinkler`),
  encoders and codecs (`UrlCodec`, `VarInt`, `BitWriter`/`BitReader`), validators and
  checksums (`Luhn`, `Isbn`, `Validators`, `Uuid`, `Semver`), and small classics like
  `Roman`, `Caesar`, and `Slugify`. Most are stateless utilities exposed as `static`
  methods; a handful (`Ini`, `Properties`, `StateMachine`, `BitWriter`) are objects you
  construct and then query.
- **`System.Time`** models time in layers: a `Duration` is a span of milliseconds, an
  `Instant` is a point on the wall clock (epoch millis), and a `ZonedDateTime` is an
  `Instant` viewed through a fixed `ZoneOffset`. `Date`/`Calendar` handle the pure
  civil-calendar arithmetic, and `Stopwatch` measures elapsed time off the monotonic
  clock.
- **`System.Json`** is a tiny in-memory JSON model: `Json` is a tagged value (null / bool
  / number / string / array / object) you build up node by node or parse from text, then
  serialize back — with `JsonPointer` for RFC 6901 path lookups.

Every stdlib type requires an **explicit import** of its fully-qualified name, one class
per line:

```ldp3
import System.Text.CaseConvert;
import System.Time.Instant;
import System.Json.Json;
```

Signatures below are verbatim from the prelude. Private helper methods are omitted (only
public constructors, methods, and static methods are listed). Types are grouped by
namespace: `System.Text` (text/parsing utilities), `System.Time` (dates and clocks) and
`System.Json`.

---

# Namespace `System.Text`

The text namespace is a grab-bag of string-shaped tools. Most are pure `static` helpers you
call without allocating anything (`CaseConvert.toSnake`, `Roman.toRoman`, `Luhn.isValid`);
a few are small objects that hold parsed state (`Ini`, `Properties`, `StateMachine`) or a
growing buffer (`BitWriter`, `BitReader`). Everything operates on the builtin `String`/
`char` types and the `System.Collections` containers, so results come back as ordinary
`String`s, `ArrayList<String>`s, or maps you can feed straight into the rest of your program.

## Rpn

- Namespace: `System.Text` · Import: `import System.Text.Rpn;`
- Reverse Polish (postfix) evaluator: tokens are space-separated integers and the
  operators `+ - * / %`, evaluated with an operand stack. Complements the infix
  `Calculator`/`ShuntingYard`.

Public members:

- `public static method eval(String expr) returns int` — evaluate a space-separated postfix expression and return the result on top of the stack.

## ShuntingYard

- Namespace: `System.Text` · Import: `import System.Text.ShuntingYard;`
- Converts a space-separated infix expression (integers, `+ - * / %`, and parentheses) to
  Reverse Polish, ready for `Rpn.eval`. Higher-precedence operators pop first.

Public members:

- `public static method toRpn(String infix) returns String` — convert a space-separated infix expression to a space-separated RPN string.

## Template

- Namespace: `System.Text` · Import: `import System.Text.Template;`
- Fills `{name}` placeholders in a template from a map. An unknown key is left as-is, so
  the braces survive when there is no matching value.

Public members:

- `public static method render(String tpl, HashMap<String, String> vars) returns String` — substitute each `{key}` in `tpl` with `vars[key]`, leaving unmatched placeholders untouched.

## Csv

- Namespace: `System.Text` · Import: `import System.Text.Csv;`
- Parses one line of comma-separated values into fields, honoring double-quoted fields so a
  comma inside quotes does not split. Quote characters are consumed, not kept. Reach for it
  when you are reading a single CSV record; pair it with `CsvWriter`/`CsvReader` when you
  need the stricter RFC 4180 escaping (doubled quotes).

```ldp3
import System.Text.Csv;
import System.Collections.ArrayList;

// The comma inside the quotes stays in one field.
ArrayList<String> fields = Csv.parse("a,\"b,c\",d");
System.IO.Console.printf("count=%d second=%s\n", fields.size(), fields.get(1));
// count=3 second=b,c
```

Public members:

- `public static method parse(String line) returns ArrayList<String>` — split one CSV line into its fields, respecting double quotes.

## CsvWriter

- Namespace: `System.Text` · Import: `import System.Text.CsvWriter;`
- CSV row writer (RFC 4180): joins cells with commas, quoting any cell that contains a
  comma, quote, or newline and doubling embedded quotes. Complements the `Csv` parser.

Public members:

- `public static method buildRow(String[] cells, int n) returns String` — build an RFC 4180 CSV row from the first `n` cells, quoting and escaping where needed.

## CsvReader

- Namespace: `System.Text` · Import: `import System.Text.CsvReader;`
- Parse one RFC 4180 CSV record, the inverse of `CsvWriter`: quoted fields may contain
  commas and escaped quotes (a doubled `""` becomes a single `"`). Returns the fields in
  order.

Public members:

- `public static method parseLine(String line) returns ArrayList<String>` — parse one RFC 4180 record, unescaping doubled quotes inside quoted fields.

## CaseConvert

- Namespace: `System.Text` · Import: `import System.Text.CaseConvert;`
- Identifier case conversion between camelCase and snake_case/kebab-case. `toSnake`/`toKebab`
  insert a separator before each interior uppercase letter and lowercase it; `toCamel`
  uppercases the letter after each separator.

Public members:

- `public static method toSnake(String s) returns String` — convert to snake_case (`_` before each interior uppercase letter, lowercased).
- `public static method toKebab(String s) returns String` — convert to kebab-case (`-` before each interior uppercase letter, lowercased).
- `public static method toCamel(String s) returns String` — convert snake_case/kebab-case to camelCase by uppercasing the character after each `_` or `-`.

## TextDistance

- Namespace: `System.Text` · Import: `import System.Text.TextDistance;`
- String similarity: the Levenshtein edit distance is the fewest single-character inserts,
  deletes, or substitutions to turn one string into another. Computed with two rolling DP
  rows.

Public members:

- `public static method levenshtein(String a, String b) returns int` — the Levenshtein edit distance between `a` and `b`.

## UrlCodec

- Namespace: `System.Text` · Import: `import System.Text.UrlCodec;`
- Percent-encoding for URLs: unreserved characters (letters, digits, `- _ . ~`) pass
  through, everything else becomes `%XX` of its byte. `decode` reverses `%XX` escapes.

Public members:

- `public static method encode(String s) returns String` — percent-encode `s`, leaving unreserved characters intact.
- `public static method decode(String s) returns String` — decode `%XX` escapes back to their bytes.

## QueryString

- Namespace: `System.Text` · Import: `import System.Text.QueryString;`
- URL query-string parsing: splits `"k=v&k=v"` on `&` into a map, with each key/value
  percent-decoded via `UrlCodec`. A key with no `=` maps to the empty string.

Public members:

- `public static method parse(String qs) returns HashMap<String, String>` — parse an `&`-separated query string into a decoded key→value map.

## WordWrap

- Namespace: `System.Text` · Import: `import System.Text.WordWrap;`
- Greedy word wrapping: splits text on spaces and packs words into lines no longer than the
  given width, returning the lines. A single word longer than the width gets its own line.

Public members:

- `public static method wrap(String text, int width) returns ArrayList<String>` — greedily wrap `text` into lines of at most `width` characters.

## Chars

- Namespace: `System.Text` · Import: `import System.Text.Chars;`
- Character classification and case conversion: the usual is-digit/letter/whitespace tests,
  ASCII upper/lower conversion, and `digitValue` (-1 if not a digit).

Public members:

- `public static method isDigit(char c) returns boolean` — true if `c` is `'0'`..`'9'`.
- `public static method isLetter(char c) returns boolean` — true if `c` is an ASCII letter.
- `public static method isWhitespace(char c) returns boolean` — true for space, tab, newline, or carriage return.
- `public static method isUpper(char c) returns boolean` — true if `c` is `'A'`..`'Z'`.
- `public static method isLower(char c) returns boolean` — true if `c` is `'a'`..`'z'`.
- `public static method toUpper(char c) returns char` — uppercase an ASCII letter, else return `c` unchanged.
- `public static method toLower(char c) returns char` — lowercase an ASCII letter, else return `c` unchanged.
- `public static method digitValue(char c) returns int` — numeric value of a digit character, or -1 if not a digit.

## Roman

- Namespace: `System.Text` · Import: `import System.Text.Roman;`
- Roman numerals: `toRoman` writes a positive integer greedily from the largest symbol
  down; `fromRoman` reads one back, subtracting a symbol whose value is less than the one
  after it.

Public members:

- `public static method toRoman(int n) returns String` — format a positive integer as a Roman numeral.
- `public static method fromRoman(String s) returns int` — parse a Roman numeral into its integer value.

## Ini

- Namespace: `System.Text` · Import: `import System.Text.Ini;`
- A minimal INI / config parser: reads `[section]` headers and `key=value` lines (`;` and
  `#` start comments; surrounding whitespace is trimmed) into a flat `"section.key"` → value
  map. `get` returns the value or `""` when absent; `has` reports presence.

Public members:

- `public constructor Ini(String text)` — parse INI text into an internal `"section.key"` → value map.
- `public method get(String section, String key) returns String` — the value for `section`/`key`, or `""` if absent.
- `public method has(String section, String key) returns boolean` — whether `section`/`key` is present.

## Properties

- Namespace: `System.Text` · Import: `import System.Text.Properties;`
- Java-style `.properties` parsing: flat `key=value` lines (space around `=` trimmed), with
  `#` and `!` comment lines skipped. Typed getters fall back to a default when a key is
  missing or malformed.

Public members:

- `public constructor Properties(String text)` — parse `.properties` text into a key→value map.
- `public method has(String key) returns boolean` — whether `key` is present.
- `public method getString(String key, String def) returns String` — the string value, or `def` if the key is absent.
- `public method getInt(String key, int def) returns int` — the value parsed as an int, or `def` if absent or malformed.
- `public method getBool(String key, boolean def) returns boolean` — true when the value equals `"true"`, `def` if the key is absent.

## Uuid

- Namespace: `System.Text` · Import: `import System.Text.Uuid;`
- RFC 4122 UUIDs: format 16 bytes as the canonical 8-4-4-4-12 hex string, build a version-4
  UUID from 16 random bytes (setting the version and variant bits), or generate one
  deterministically from an int seed via an inline xorshift. `isValid` checks the canonical
  shape. Use `v4` with bytes from `System.Security.SecureRandom` when you need real
  unpredictability; `v4Seeded` is for reproducible ids in tests and fixtures.

```ldp3
import System.Text.Uuid;

String id = Uuid.v4Seeded(12345);   // same seed → same UUID every run
System.IO.Console.println(id);
System.IO.Console.println(Uuid.isValid(id));   // true
```

Public members:

- `public static method format(int[] bytes) returns String` — format 16 bytes as the canonical `8-4-4-4-12` hex string.
- `public static method v4(int[] randomBytes) returns String` — build a version-4 UUID from 16 random bytes, setting the version/variant bits.
- `public static method v4Seeded(int seed) returns String` — generate a deterministic version-4 UUID from an int seed via xorshift.
- `public static method isValid(String s) returns boolean` — check that `s` has the canonical UUID shape (36 chars, dashes and hex in the right places).

## Semver

- Namespace: `System.Text` · Import: `import System.Text.Semver;`
- Semantic versioning (semver.org): parse `"major.minor.patch"` (an optional leading `v`
  and any `-prerelease`/`+build` suffix are ignored) and compare two versions field by
  field. `compareTo` returns -1, 0, or 1.

Public members:

- `public constructor Semver(String v)` — parse a version string into major/minor/patch.
- `public method getMajor() returns int` — the major component.
- `public method getMinor() returns int` — the minor component.
- `public method getPatch() returns int` — the patch component.
- `public method compareTo(Semver o) returns int` — compare against `o` field by field, returning -1, 0, or 1.
- `public method toString() returns String` — render as `"major.minor.patch"`.

## StateMachine

- Namespace: `System.Text` · Import: `import System.Text.StateMachine;`
- A simple deterministic finite state machine: register `(from, event)` → `to` transitions
  and drive them with `fire(event)`, which advances the current state and returns whether a
  transition existed. Transitions live in a `"state|event"` → next map.

Public members:

- `public constructor StateMachine(String initial)` — create a machine starting in state `initial`.
- `public method addTransition(String from, String event, String to) returns void` — register a `(from, event)` → `to` transition.
- `public method fire(String event) returns boolean` — advance on `event`; return true if a transition existed (and was taken).
- `public method state() returns String` — the current state.

## Glob

- Namespace: `System.Text` · Import: `import System.Text.Glob;`
- Glob / wildcard matching: `*` matches any run of characters (including none) and `?`
  matches exactly one. Iterative with backtracking on the last `*`, so it runs in linear
  space.

Public members:

- `public static method matches(String pattern, String text) returns boolean` — whether `text` matches the glob `pattern`.

## VarInt

- Namespace: `System.Text` · Import: `import System.Text.VarInt;`
- LEB128 variable-length integers: seven bits per byte, high bit set while more bytes
  follow, so small values take one byte. `encode` returns the bytes; `decode` reads them
  back.

Public members:

- `public static method encode(long value) returns ArrayList<int>` — LEB128-encode `value` into a list of bytes.
- `public static method decode(ArrayList<int> bytes) returns long` — decode a LEB128 byte sequence back to a long.

## BitWriter

- Namespace: `System.Text` · Import: `import System.Text.BitWriter;`
- A most-significant-bit-first bit writer: pack individual bits or fixed-width fields into a
  byte buffer, then read them back with `BitReader`. Useful for entropy coders such as
  Huffman.

Public members:

- `public constructor BitWriter()` — create an empty bit buffer.
- `public method writeBit(int bit) returns void` — append a single bit (low bit of `bit`), MSB-first.
- `public method writeBits(int value, int count) returns void` — append the low `count` bits of `value`, most-significant first.
- `public method bitCount() returns int` — the number of bits written so far.
- `public method toBytes() returns int[]` — the packed bytes (ceil of bit count / 8 entries).

## BitReader

- Namespace: `System.Text` · Import: `import System.Text.BitReader;`
- Reads bits most-significant-first out of a byte array, matching `BitWriter`.

Public members:

- `public constructor BitReader(int[] bytes)` — wrap a byte array for MSB-first bit reading.
- `public method readBit() returns int` — read the next single bit.
- `public method readBits(int count) returns int` — read the next `count` bits, most-significant first, into an int.

## Colors

- Namespace: `System.Text` · Import: `import System.Text.Colors;`
- 24-bit RGB color utilities: pack/unpack channels into a `0xRRGGBB` int, hex parse/format,
  linear interpolation between two colors (`t` is a 0..100 percent), Rec.601 luminance and
  grayscale.

Public members:

- `public static method pack(int r, int g, int b) returns int` — pack `r`/`g`/`b` (each masked to 8 bits) into a `0xRRGGBB` int.
- `public static method red(int c) returns int` — the red channel of a packed color.
- `public static method green(int c) returns int` — the green channel of a packed color.
- `public static method blue(int c) returns int` — the blue channel of a packed color.
- `public static method toHex(int c) returns String` — format a packed color as `#rrggbb`.
- `public static method fromHex(String s) returns int` — parse a hex color (optional leading `#`) into a packed int.
- `public static method lerp(int c1, int c2, int t) returns int` — linearly interpolate between `c1` and `c2` where `t` is a 0..100 percentage.
- `public static method luminance(int c) returns int` — Rec.601 luminance (0..255) of a packed color.
- `public static method grayscale(int c) returns int` — the packed grayscale color at the luminance of `c`.

## Caesar

- Namespace: `System.Text` · Import: `import System.Text.Caesar;`
- Caesar shift cipher: rotate each letter by `n`, wrapping within its case; non-letters pass
  through. `decrypt` is the inverse shift; `rot13` is the classic shift of 13.

Public members:

- `public static method encrypt(String s, int n) returns String` — shift each letter forward by `n`, wrapping within its case.
- `public static method decrypt(String s, int n) returns String` — inverse of `encrypt` for shift `n`.
- `public static method rot13(String s) returns String` — the classic ROT13 (shift of 13).

## Vigenere

- Namespace: `System.Text` · Import: `import System.Text.Vigenere;`
- Vigenère cipher: a repeating-key poly-alphabetic shift over letters (case preserved,
  non-letters skipped and not consuming key). `encrypt` and `decrypt` are inverses.

Public members:

- `public static method encrypt(String s, String key) returns String` — Vigenère-encrypt `s` with the repeating `key`.
- `public static method decrypt(String s, String key) returns String` — Vigenère-decrypt `s` with the repeating `key`.

## Slugify

- Namespace: `System.Text` · Import: `import System.Text.Slugify;`
- URL/filename slugs: lowercase, collapse every run of non-alphanumeric characters to a
  single dash, and trim leading/trailing dashes.

Public members:

- `public static method make(String s) returns String` — turn `s` into a lowercase, dash-separated slug.

## Inflector

- Namespace: `System.Text` · Import: `import System.Text.Inflector;`
- English pluralization, simple rules: `-s`/`-x`/`-z`/`-ch`/`-sh` take `"es"`, a
  consonant+`y` becomes `"ies"`, otherwise append `"s"`.

Public members:

- `public static method pluralize(String w) returns String` — pluralize an English word by the simple suffix rules.

## Levenshtein

- Namespace: `System.Text` · Import: `import System.Text.Levenshtein;`
- Levenshtein edit distance: the minimum single-character insertions, deletions, and
  substitutions to turn one string into another, via two-row dynamic programming. Good for
  fuzzy matching and spell-checking.

Public members:

- `public static method distance(String a, String b) returns int` — the Levenshtein edit distance between `a` and `b`.

## JaroWinkler

- Namespace: `System.Text` · Import: `import System.Text.JaroWinkler;`
- Jaro-Winkler string similarity in [0,1]: the Jaro score adjusted upward for a common
  prefix (up to 4 chars, factor 0.1). Good for fuzzy matching short strings like names.

Public members:

- `public static method jaro(String s1, String s2) returns double` — the base Jaro similarity in [0,1].
- `public static method similarity(String s1, String s2) returns double` — the Jaro-Winkler similarity (Jaro boosted by a common-prefix bonus).

## Luhn

- Namespace: `System.Text` · Import: `import System.Text.Luhn;`
- Luhn (mod-10) checksum, as used by credit-card numbers: doubles every second digit from
  the right (subtracting 9 when over 9); valid when the total is a multiple of 10.
  Non-digits are skipped.

Public members:

- `public static method isValid(String s) returns boolean` — whether the digits in `s` pass the Luhn mod-10 check.

## Isbn

- Namespace: `System.Text` · Import: `import System.Text.Isbn;`
- ISBN-13 check digit: the 13 digits weighted 1,3,1,3,... must sum to a multiple of 10.

Public members:

- `public static method isValid13(String s) returns boolean` — whether `s` contains exactly 13 digits passing the ISBN-13 checksum.

## TextDiff

- Namespace: `System.Text` · Import: `import System.Text.TextDiff;`
- Line-level text diff via the longest common subsequence: `common` counts shared lines in
  order; `removed` and `added` are the lines only in the first or second version. Uses
  two-row LCS DP.

Public members:

- `public static method common(String[] a, int na, String[] b, int nb) returns int` — number of lines common to both versions (LCS length).
- `public static method removed(String[] a, int na, String[] b, int nb) returns int` — number of lines only in the first version (`na` minus the LCS length).
- `public static method added(String[] a, int na, String[] b, int nb) returns int` — number of lines only in the second version (`nb` minus the LCS length).

## Validators

- Namespace: `System.Text` · Import: `import System.Text.Validators;`
- Lightweight format validators: a heuristic email check (single `@`, dot in the domain, no
  spaces), an http/https URL check with a non-empty host, and IBAN via the ISO 7064 mod-97
  test.

Public members:

- `public static method isEmail(String s) returns boolean` — heuristic email check (single `@`, no spaces, a dot after the `@`).
- `public static method isUrl(String s) returns boolean` — check for an `http://`/`https://` prefix with a non-empty host.
- `public static method isIban(String s) returns boolean` — validate an IBAN via the ISO 7064 mod-97 test (spaces ignored).

## NumberWords

- Namespace: `System.Text` · Import: `import System.Text.NumberWords;`
- Spell an integer in English words, space-separated and lowercase, up to the billions
  (covers the full int range). Negative numbers are prefixed with `"minus"`.

Public members:

- `public static method toWords(int num) returns String` — spell `num` in lowercase English words.

## Humanize

- Namespace: `System.Text` · Import: `import System.Text.Humanize;`
- Human-friendly formatting: binary byte sizes (1024-based, one decimal above bytes) and
  English ordinals (1st, 2nd, 3rd, 11th, 21st), handling the 11-13 `"th"` exception.

Public members:

- `public static method bytes(long n) returns String` — format a byte count as a human-readable binary size (e.g. `"1.5 MB"`).
- `public static method ordinal(int n) returns String` — format `n` as an English ordinal (`"1st"`, `"2nd"`, `"11th"`, ...).

---

# Namespace `System.Time`

Time in LDP3 is built up in small, composable pieces rather than one do-everything
date-time class. A `Duration` is a length of time; an `Instant` is a point in time (epoch
milliseconds); a `ZoneOffset` shifts an instant into local wall-clock fields via
`ZonedDateTime`. For pure calendar math with no clock involved, `Date` and `Calendar` give
you leap-year rules, month lengths, and day-of-week. `Stopwatch` is the odd one out: it
reads the monotonic clock, not the wall clock, so it stays correct even if the system time
is changed while it runs. All of these read the underlying clock through the `Time`
builtin, which shares this namespace.

## Duration

- Namespace: `System.Time` · Import: `import System.Time.Duration;`
- A span of time in milliseconds. Shares the namespace with the `Time` builtin, so
  `Instant.now()` can read the clock without an extra import.

Public members:

- `public constructor Duration(long millis)` — a duration of `millis` milliseconds.
- `public static method ofMillis(long m) returns Duration` — construct from milliseconds.
- `public static method ofSeconds(long s) returns Duration` — construct from seconds.
- `public static method ofMinutes(long m) returns Duration` — construct from minutes.
- `public method toMillis() returns long` — the duration in milliseconds.
- `public method toSeconds() returns long` — the duration in whole seconds.
- `public method plus(Duration other) returns Duration` — a new duration summing this and `other`.
- `public method minus(Duration other) returns Duration` — a new duration subtracting `other` from this.

## Instant

- Namespace: `System.Time` · Import: `import System.Time.Instant;`
- A moment on the wall clock, as milliseconds since the Unix epoch. Subtract two instants
  with `since` to get a `Duration`, or push an instant forward with `plus`. Because an
  `Instant` is a bare epoch value it carries no time zone; wrap it in a `ZonedDateTime`
  when you need local calendar fields.

```ldp3
import System.Time.Instant;
import System.Time.Duration;

Instant start = Instant.now();
// ... do some work ...
Instant end = Instant.now();
Duration elapsed = end.since(start);
System.IO.Console.printf("took %d ms\n", elapsed.toMillis());

Instant deadline = start.plus(Duration.ofSeconds(30));   // 30s after start
```

Public members:

- `public constructor Instant(long ms)` — an instant at `ms` epoch milliseconds.
- `public static method now() returns Instant` — the current instant from the system clock.
- `public static method ofEpochMillis(long ms) returns Instant` — construct from epoch milliseconds.
- `public method toEpochMillis() returns long` — epoch milliseconds of this instant.
- `public method isBefore(Instant other) returns boolean` — whether this instant precedes `other`.
- `public method isAfter(Instant other) returns boolean` — whether this instant follows `other`.
- `public method plus(Duration d) returns Instant` — a new instant `d` later than this one.
- `public method since(Instant earlier) returns Duration` — the duration from `earlier` to this instant.

## ZoneOffset

- Namespace: `System.Time` · Import: `import System.Time.ZoneOffset;`
- A fixed offset from UTC, in seconds east of Greenwich (e.g. -3h for BRT). A pure offset,
  not a named zone with a DST rule table; `systemDefault()` reads the machine's current
  offset (including any active daylight saving) from the OS.

Public members:

- `public constructor ZoneOffset(int totalSeconds)` — an offset of `totalSeconds` seconds east of UTC.
- `public static method ofSeconds(int s) returns ZoneOffset` — construct from seconds.
- `public static method ofHours(int h) returns ZoneOffset` — construct from whole hours.
- `public static method ofHoursMinutes(int h, int m) returns ZoneOffset` — construct from hours and minutes (minutes take the sign of the hours).
- `public static method utc() returns ZoneOffset` — the zero (UTC) offset.
- `public static method systemDefault() returns ZoneOffset` — the machine's current UTC offset, read from the OS.
- `public method totalSeconds() returns int` — the offset in seconds east of UTC.
- `public method id() returns String` — the ISO id: `"Z"` for UTC, otherwise `"+HH:MM"`/`"-HH:MM"`.

## ZonedDateTime

- Namespace: `System.Time` · Import: `import System.Time.ZonedDateTime;`
- A date-time at a fixed UTC offset: an `Instant` paired with a `ZoneOffset`. The
  wall-clock fields are the instant shifted by the offset; `toInstant` recovers the
  underlying UTC point.

Public members:

- `public constructor ZonedDateTime(Instant instant, ZoneOffset offset)` — pair an instant with a fixed offset.
- `public static method now() returns ZonedDateTime` — the current instant at the system default offset.
- `public static method ofInstant(Instant i, ZoneOffset off) returns ZonedDateTime` — construct from an instant and an offset.
- `public method toInstant() returns Instant` — the underlying UTC instant.
- `public method offset() returns ZoneOffset` — the fixed UTC offset.
- `public method year() returns int` — the local calendar year.
- `public method month() returns int` — the local month (1-12).
- `public method day() returns int` — the local day of month.
- `public method hour() returns int` — the local hour (0-23).
- `public method minute() returns int` — the local minute (0-59).
- `public method second() returns int` — the local second (0-59).
- `public method toString() returns String` — the ISO-8601 rendering, e.g. `2026-07-03T14:05:09-03:00`.

## Stopwatch

- Namespace: `System.Time` · Import: `import System.Time.Stopwatch;`
- A monotonic elapsed-time timer: start/stop/reset accumulate high-resolution nanoseconds
  from the monotonic clock (`Time.nanos`), unaffected by wall-clock changes.

Public members:

- `public constructor Stopwatch()` — create a stopped stopwatch with zero elapsed time.
- `public static method startNew() returns Stopwatch` — create and immediately start a stopwatch.
- `public method start() returns void` — start (or resume) timing; a no-op if already running.
- `public method stop() returns void` — stop timing, adding the current interval to the accumulated total.
- `public method reset() returns void` — clear the accumulated time and stop.
- `public method elapsedNanos() returns long` — total elapsed nanoseconds (including the live interval if running).
- `public method elapsedMillis() returns long` — total elapsed time in whole milliseconds.

## Date

- Namespace: `System.Time` · Import: `import System.Time.Date;`
- A calendar date as year/month/day: leap-year and month-length rules, conversion to and
  from a day number counted from 1970-01-01, day of week (0=Sunday), and date arithmetic via
  `addDays`. The civil↔days conversions use the standard proleptic-Gregorian algorithm.

Public members:

- `public constructor Date(int year, int month, int day)` — a date with the given fields.
- `public method year() returns int` — the year component.
- `public method month() returns int` — the month component (1-12).
- `public method day() returns int` — the day-of-month component.
- `public static method isLeap(int year) returns boolean` — whether `year` is a leap year.
- `public static method daysInMonth(int year, int month) returns int` — the number of days in that month of that year.
- `public method toEpochDay() returns int` — the day number counted from 1970-01-01.
- `public method dayOfWeek() returns int` — the day of week, 0=Sunday..6=Saturday.
- `public static method fromEpochDay(int z0) returns Date` — the date at day number `z0` (from 1970-01-01).
- `public method addDays(int n) returns Date` — a new date `n` days after this one.

## Calendar

- Namespace: `System.Time` · Import: `import System.Time.Calendar;`
- Calendar arithmetic: leap years, days in a month, day of the week (0=Sunday..6=Saturday
  via Zeller's congruence), and day of the year.

Public members:

- `public static method isLeapYear(int y) returns boolean` — whether `y` is a leap year.
- `public static method daysInMonth(int y, int m) returns int` — the number of days in month `m` of year `y`.
- `public static method dayOfWeek(int year, int month, int day) returns int` — the day of week (0=Sunday..6=Saturday) via Zeller's congruence.
- `public static method dayOfYear(int y, int m, int d) returns int` — the ordinal day of the year for the given date.

---

# Namespace `System.Json`

`System.Json` is a small, dependency-free JSON model: one `Json` type that is either a
null, a bool, a number, a string, an array, or an object, plus a recursive-descent parser
(`JsonParser`) and a JSON Pointer resolver (`JsonPointer`). You build a document by
constructing nodes and wiring them together with `add` (for array elements) and `put` (for
named members), and you read one back with `field`, `at`, and the `asX` accessors. It is a
document tree, not a schema binder — there is no reflection-based (de)serialization here,
which keeps it usable in freestanding builds.

## Json

- Namespace: `System.Json` · Import: `import System.Json.Json;`
- A JSON value. The `kind` code is 0=null, 1=bool, 2=number(long), 3=string, 4=array,
  5=object. Built and read with pure-LDP3 code over `System.Collections` + `System.Text`;
  arrays and object members are held as a sibling chain of child nodes. Numbers are `long`,
  so wrap integer literals in `cast<long>(...)` when building. `field` on a missing key
  returns a JSON null node (never a null pointer), so lookups chain safely.

```ldp3
import System.Json.Json;

Json obj = Json.object();
obj.put("name", Json.ofStr("LDP3"));
obj.put("version", Json.ofNum(cast<long>(1)));

Json nums = Json.array();
nums.add(Json.ofNum(cast<long>(10)));
nums.add(Json.ofNum(cast<long>(20)));
obj.put("nums", nums);

String text = obj.toString();                 // {"name":"LDP3","version":1,"nums":[10,20]}
Json parsed = Json.parse(text);               // round-trip back into a tree
System.IO.Console.println(parsed.field("name").asStr());          // LDP3
System.IO.Console.println(parsed.field("nums").at(0).asNum());    // 10
```

Public members:

- `public constructor Json(int k)` — create an empty node of kind `k` (0=null..5=object).
- `public static method ofNull() returns Json` — a JSON null value.
- `public static method ofBool(boolean v) returns Json` — a JSON boolean.
- `public static method ofNum(long v) returns Json` — a JSON number from a long.
- `public static method ofStr(String v) returns Json` — a JSON string.
- `public static method array() returns Json` — an empty JSON array.
- `public static method object() returns Json` — an empty JSON object.
- `public method add(Json* v) returns void` — append `v` as a child (array element or object member).
- `public method put(String key, Json* v) returns void` — set `v`'s member key to `key` and append it (object member).
- `public method kindOf() returns int` — the kind code (0=null..5=object).
- `public method asBool() returns boolean` — the boolean payload.
- `public method asNum() returns long` — the number payload.
- `public method asStr() returns String` — the string payload.
- `public method size() returns int` — the number of children (array elements / object members).
- `public method at(int i) returns nullable Json` — the `i`-th child, walking the sibling chain.
- `public method field(String key) returns nullable Json` — the object member named `key`, or a null Json node if absent.
- `public method toString() returns String` — the compact JSON serialization.
- `public method prettyString() returns String` — the indented, multi-line JSON serialization.
- `public static method parse(String src) returns Json` — parse a JSON string into a `Json` tree (via `JsonParser`).

## JsonPointer

- Namespace: `System.Json` · Import: `import System.Json.JsonPointer;`
- JSON Pointer (RFC 6901): resolve a `"/a/0/b"` path against a `Json` tree, stepping into
  object members by key and array elements by index. Returns null if any step is missing or
  out of range.

Public members:

- `public static method resolve(Json* root, String ptr) returns nullable Json` — resolve the RFC 6901 pointer `ptr` against `root`, or null if any step fails.

## JsonParser

- Namespace: `System.Json` · Import: `import System.Json.JsonParser;`
- Recursive-descent JSON parser (minimal: null/bool/integer/string/array/object). Usually
  reached through `Json.parse`, but the parser can be driven directly.

Public members:

- `public constructor JsonParser(String src)` — create a parser positioned at the start of `src`.
- `public method parseValue() returns Json` — parse the next JSON value at the current position.
