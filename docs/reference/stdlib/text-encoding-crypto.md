# Standard Library Reference — Text / Encoding / Crypto

Every type in this slice lives in the **`System.Text`** namespace. As with the rest of the Polaron
stdlib, each type must be imported explicitly by its fully-qualified name before use (importing the
namespace does not pull in its members). The import line for each type is shown under its heading.

This is where Polaron does its text work: building strings efficiently (`StringBuilder`), splitting and
formatting them (`Strings`), matching and searching (`Regex`, `Kmp`, `Manacher`), walking UTF-8
(`Utf8`), turning bytes into transportable text (`Hex`, `Base64`, `Base32`, `Base58`, `Ascii85`),
fingerprinting data (`Sha256`, `Sha1`, `Md5`, the CRC/Adler checksums, `Fletcher`), authenticating it
(`Hmac`), and a handful of compression and classic-algorithm utilities (`Huffman`, `Lz77`, `Rle`,
`Soundex`, `Calculator`).

The slice is pure Polaron built on top of the built-in `String`/`string` primitives and the raw-memory
`System.Memory` builtins — there is no new runtime dependency, and nothing here calls out to a system
crypto library, so the hashes are readable reference implementations rather than hardware-accelerated
ones. Because `String.charAt`/`String.length` work at the byte level, the encoding, checksum and hash
types treat a `String` as a byte buffer (`charAt(i) & 255` is the i-th byte), and several APIs
take/return `int[]` where each entry is a 0..255 byte. That byte-level view is exactly why a separate
`Utf8` type exists: to recover whole Unicode codepoints from those bytes.

The cryptographic hashes match their published test vectors, so they interoperate with other tools;
where an algorithm is broken for security (`Sha1`, `Md5`) the type says so and names the legacy use it
is kept for. In the examples below, a `// ->` comment shows the value a call returns.

> Only public members (constructors, methods, static methods) are listed. Private helpers used
> internally by each type are omitted.

---

## StringBuilder

```polaron
import System.Text.StringBuilder;
```

Growable text buffer (spec 34.5). Bytes live in a raw heap buffer (`System.Memory`) that doubles on
demand, so `append` is amortized O(1); `toString()` copies the accumulated bytes into an owned `String`.

- `public constructor StringBuilder()` — creates an empty buffer (initial capacity 16 bytes).
- `public method append(String s) returns StringBuilder` — appends a string's bytes (bulk memcpy); returns `this` for chaining.
- `public method appendChar(char c) returns StringBuilder` — appends a single byte; returns `this`.
- `public method appendInt(int value) returns StringBuilder` — appends the decimal text of an int (via `value.toString()`); returns `this`.
- `public method length() returns int` — the number of bytes accumulated so far.
- `public method toString() returns String` — copies the buffer into a fresh owned `String`.

Use it instead of `a.concat(b).concat(c)...` in a loop: repeated `concat` re-copies the whole
prefix each time (O(n²) total), whereas the builder appends in place and copies once at
`toString()`. The `append*` methods all return `this`, so calls chain.

```polaron
import System.Text.StringBuilder;

StringBuilder sb = new StringBuilder() on heap;
sb.append("count = ").appendInt(42).appendChar('!');
sb.length();     // -> 11
sb.toString();   // -> "count = 42!"
```

---

## Strings

```polaron
import System.Text.Strings;
```

String utilities the built-in `String` type does not carry as methods (spec 4): splitting, joining,
replacing, padding and trimming. Each is a static helper built from the `String` primitives, so it
allocates fresh owned `String`s and never mutates its input.

- `public static method split(String text, String separator) returns ArrayList<String>` — splits `text` on each non-overlapping `separator`; an empty separator returns the whole text unsplit.
- `public static method join(ArrayList<String> parts, String separator) returns String` — concatenates `parts` with `separator` between them (O(n) via `StringBuilder`).
- `public static method replace(String text, String target, String replacement) returns String` — replaces every non-overlapping occurrence of `target` with `replacement` (empty target returns `text` unchanged).
- `public static method padLeft(String text, int width, String pad) returns String` — left-pads `text` with repetitions of `pad` until it reaches `width` (returns `text` unchanged if already at least `width`).
- `public static method padRight(String text, int width, String pad) returns String` — right-pads `text` with repetitions of `pad` until it reaches `width`.
- `public static method format(String template, ArrayList<String> args) returns String` — fills each `{}` placeholder in `template` with the next argument in order; extra args are ignored, a `{}` with no argument left is dropped.
- `public static method count(String text, String sub) returns int` — counts the non-overlapping occurrences of `sub` in `text`.
- `public static method reverse(String text) returns String` — returns `text` with its characters (bytes) reversed.
- `public static method capitalize(String text) returns String` — upper-cases the first character and leaves the rest unchanged.
- `public static method trimStart(String text) returns String` — removes leading whitespace only (the built-in `String.trim` does both ends).
- `public static method trimEnd(String text) returns String` — removes trailing whitespace only.
- `public static method isBlank(String text) returns boolean` — whether `text` is empty or only whitespace.
- `public static method equalsIgnoreCase(String a, String b) returns boolean` — case-insensitive equality, comparing the lower-cased forms.

---

## Regex

```polaron
import System.Text.Regex;
```

A small backtracking regular-expression matcher (spec 4): literals, `.` (any), character classes
`[abc]`/`[a-z]`/`[^...]`, the quantifiers `* + ?`, and the anchors `^` and `$`. Pure Polaron over the
`String` primitives.

- `public static method search(String pat, String text) returns boolean` — whether `pat` occurs anywhere in `text`; wrap the pattern in `^` and `$` to require a full match.

Matching is backtracking, so a pathological pattern like `(a*)*` has no equivalent here (there is no
grouping) but a greedy quantifier over a long run can still be quadratic; keep patterns simple. There
are no capture groups — `search` answers only yes/no. For plain substring search prefer `Kmp`, which
is linear.

```polaron
import System.Text.Regex;

Regex.search("a+b", "aaab");       // -> true
Regex.search("c.t", "cat");        // -> true   ('.' matches any one byte)
Regex.search("^[0-9]+$", "2026");  // -> true   (anchored: all digits)
Regex.search("^[0-9]+$", "20x6");  // -> false
```

---

## Utf8

```polaron
import System.Text.Utf8;
```

UTF-8 decoding (spec 4). Since `String.charAt`/`String.length` are byte-level, `Utf8` reads whole
Unicode codepoints out of the byte sequence. A lead byte's high bits give the character width.

- `public static method widthAt(String s, int i) returns int` — the number of bytes occupied by the character starting at byte offset `i` (advance by this).
- `public static method codepointAt(String s, int i) returns int` — the Unicode codepoint of the character at byte offset `i`.
- `public static method length(String s) returns int` — the number of Unicode characters (codepoints), not bytes.
- `public static method codepoints(String s) returns ArrayList<int>` — every codepoint in order.

Reach for this whenever "how many characters" or "the character at position k" must not count raw
bytes. To iterate characters, read `codepointAt(s, i)` and advance `i` by `widthAt(s, i)` rather than
by 1. The decoder trusts its input: it assumes well-formed UTF-8 and does not validate continuation
bytes.

```polaron
import System.Text.Utf8;

String s = "héllo";        // 'é' takes 2 UTF-8 bytes
s.length();             // -> 6   (bytes, since String is byte-level)
Utf8.length(s);         // -> 5   (Unicode characters)
Utf8.codepointAt(s, 1); // -> 233 (U+00E9, 'é')
Utf8.widthAt(s, 1);     // -> 2   (advance past the 2-byte character)
```

---

## Scanner

```polaron
import System.Text.Scanner;
```

A cursor over text that hands out tokens (spec 4): reads words, ints and lines from an in-memory
`String`, so it parses file contents or any text.

- `public constructor Scanner(String text)` — creates a scanner positioned at the start of `text`.
- `public method hasNext() returns boolean` — whether a non-whitespace token remains (skips leading whitespace).
- `public method nextWord() returns String` — reads up to the next whitespace and returns the token.
- `public method nextInt() returns int` — reads the next word and parses it as an int (`nextWord().toInt()`).
- `public method hasNextLine() returns boolean` — whether any input remains to read as a line.
- `public method nextLine() returns String` — reads to the next newline (consuming it) and returns the line without the terminator.

---

## Hex

```polaron
import System.Codecs.Hex;
```

Hexadecimal encoding (spec 4): each byte of a string becomes two lowercase hex digits, and back.

- `public static method encode(String data) returns String` — the lowercase hex of each byte of `data`.
- `public static method decode(String hex) returns String` — the bytes decoded from a hex string (case-insensitive; consumes digit pairs).

---

## Radix

```polaron
import System.Codecs.Radix;
```

Arbitrary-base integer conversion (spec 4), bases 2..36 using `0-9` then `a-z`.

- `public static method toBase(long n, int base) returns String` — renders `n` in the given base (with a leading `-` for negatives).
- `public static method fromBase(String s, int base) returns long` — parses such a string back to a long (case-insensitive).

---

## Base64

```polaron
import System.Codecs.Base64;
```

Base64 encoding (spec 4): three bytes become four characters of the standard alphabet, with `=`
padding on the final group.

- `public static method encode(String data) returns String` — Base64 of `data`'s bytes (standard `+`/`/` alphabet, `=` padded).
- `public static method decode(String data) returns String` — the bytes decoded from a padded Base64 string.

The standard (not URL-safe) alphabet, so output may contain `+` and `/`; `encode` then `decode`
round-trips exactly. Encoded text is about 4/3 the size of the input. For URL- or filename-safe
output without padding characters, use `Base32`, or `Hex` when readability matters more than size.

```polaron
import System.Codecs.Base64;

Base64.encode("Man");   // -> "TWFu"
Base64.encode("Ma");    // -> "TWE="   (one '=' pad for the short final group)
Base64.decode("TWFu");  // -> "Man"
```

---

## Base32

```polaron
import System.Codecs.Base32;
```

Base32 (RFC 4648) over a string's bytes: 5 bytes encode to 8 chars of the alphabet
`ABCDEFGHIJKLMNOPQRSTUVWXYZ234567`, `=` padded. Uses a 40-bit long buffer.

- `public static method encode(String data) returns String` — the padded Base32 of `data`'s bytes.
- `public static method decode(String s) returns String` — the bytes decoded from a Base32 string (stops at the first `=`).

---

## Base58

```polaron
import System.Codecs.Base58;
```

Base58 (the Bitcoin alphabet, spec 4): big-endian base-256 to base-58 with no `0`/`O`/`I`/`l`; leading
zero bytes are preserved as leading `1`s. Works over an `int[]` of bytes rather than a `String`.

- `public static method encode(int[] bytes, int n) returns String` — Base58 of the first `n` entries of `bytes` (each an 0..255 byte).
- `public static method decode(String s) returns int[]` — the decoded bytes.

---

## Ascii85

```polaron
import System.Codecs.Ascii85;
```

Ascii85 / Base85 (spec 4, Adobe variant without delimiters): four bytes become five printable chars
(base 85 starting at `!`); a final partial group emits one fewer char than its byte count plus one.

- `public static method encode(int[] bytes, int n) returns String` — Ascii85 of the first `n` entries of `bytes`.
- `public static method decode(String s) returns int[]` — the decoded bytes (short final groups are padded internally with `u`).

---

## Fletcher

```polaron
import System.Codecs.Fletcher;
```

Fletcher-16 checksum (spec 4) over a string's bytes: two running mod-255 sums combined as a 16-bit
value. Cheaper than CRC with good error detection.

- `public static method fletcher16(String data) returns int` — the 16-bit Fletcher checksum of `data`'s bytes.

---

## Digest

```polaron
import System.Security.Digest;
```

Non-cryptographic checksums and hashes over a string's bytes (spec 4), using unsigned 32-bit
arithmetic that wraps and shifts logically. Each result is returned as an `int` (the same 32 bits
reinterpreted).

- `public static method crc32(String data) returns int` — CRC-32 (reflected, the zip/png polynomial) of `data`'s bytes.
- `public static method fnv1a(String data) returns int` — 32-bit FNV-1a hash of `data`'s bytes.
- `public static method adler32(String data) returns int` — Adler-32 (the zlib checksum) of `data`'s bytes.

---

## Sha256

```polaron
import System.Security.Sha256;
```

SHA-256 cryptographic hash (FIPS 180-4), pure Polaron over 32-bit unsigned arithmetic (spec 4). The
method is named `digest`, not `hash`, since `hash` is the `Hashable` interface method. Also provides
the shared byte/hex plumbing (`toHex`, `putWord`) reused by the other hash types.

- `public static method toHex(int[] bytes, int n) returns String` — the lowercase hex of the first `n` entries of `bytes` (each treated as a 0..255 byte).
- `public static method digestRaw(int[] data, int len) returns int[]` — hashes the first `len` bytes of `data`, returning the 32 raw output bytes (used by `Hmac`).
- `public static method digest(String msg) returns String` — the 64-character lowercase hex digest of `msg`'s bytes.
- `public static method digestBytes(int[] data, int len) returns String` — the lowercase hex digest of the first `len` bytes of `data`.

`digest` is the everyday entry point: pass a message, get its 64-character hex digest. The output
matches the FIPS 180-4 test vectors, so it interoperates with other SHA-256 tools. For keyed
authentication (proving a message came from someone holding a shared secret) use `Hmac.sha256`
rather than hashing the key and message concatenated.

```polaron
import System.Security.Sha256;

Sha256.digest("");     // -> "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
Sha256.digest("abc");  // -> "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
```

---

## Hmac

```polaron
import System.Security.Hmac;
```

HMAC-SHA256 keyed message authentication (RFC 2104), pure Polaron on top of `Sha256`. Keys longer than
the 64-byte block are hashed down first.

- `public static method sha256(String key, String msg) returns String` — the lowercase hex of HMAC-SHA256(`key`, `msg`).

---

## Sha1

```polaron
import System.Security.Sha1;
```

SHA-1 cryptographic hash (FIPS 180-1), pure Polaron over 32-bit unsigned arithmetic. SHA-1 is broken for
collision resistance; provided for legacy interop such as Git object ids. Reuses `Sha256.putWord`/`toHex`.

- `public static method digestRaw(int[] data, int len) returns int[]` — hashes the first `len` bytes of `data`, returning the 20 raw output bytes.
- `public static method digest(String msg) returns String` — the 40-character lowercase hex digest of `msg`'s bytes.

---

## Sha224

```polaron
import System.Security.Sha224;
```

SHA-224 (FIPS 180-4): the SHA-256 compression with different initial hash values and a 28-byte
(56 hex char) output. Reuses `Sha256.rotr`/`putWord`/`toHex`; the round constants match SHA-256.

- `public static method digest(String msg) returns String` — the 56-character lowercase hex digest of `msg`'s bytes.

---

## Md5

```polaron
import System.Security.Md5;
```

MD5 message digest (RFC 1321), pure Polaron over 32-bit unsigned arithmetic (little-endian, unlike the
SHA family). MD5 is broken for collision resistance; provided for legacy interop/checksums only.
Reuses `Sha256.toHex` for the final hex.

- `public static method digest(String msg) returns String` — the 32-character lowercase hex digest of `msg`'s bytes.

---

## Crc

```polaron
import System.Codecs.Crc;
```

CRC-16/XMODEM (spec 4): a 16-bit checksum over a string's bytes with polynomial `0x1021` and zero
initial value. Bitwise, table-free.

- `public static method crc16(String data) returns int` — the CRC-16/XMODEM checksum of `data`'s bytes.

---

## Adler32

```polaron
import System.Codecs.Adler32;
```

Adler-32 checksum (RFC 1950 / zlib): two running sums modulo 65521 combined as `(b << 16) | a`, with
`a` starting at 1. Faster than CRC but weaker; returned in a `long` so the high bit stays positive.

- `public static method checksum(String data) returns long` — the Adler-32 checksum of `data`'s bytes.

---

## BloomFilter

```polaron
import System.Collections.BloomFilter;
```

A probabilistic set that never misses a member but may report a false positive (spec 34.1). Two
independent hashes (`Digest.fnv1a` and `Digest.crc32`) set and test bits in a fixed bit array.
`mightContain` returning false is definitive; true means probably present.

- `public constructor BloomFilter(int size)` — creates a filter backed by a `size`-bit array.
- `public method add(String key) returns void` — records `key` in the filter.
- `public method mightContain(String key) returns boolean` — false means definitely absent; true means probably present.

---

## Huffman

```polaron
import System.Codecs.Huffman;
```

Huffman coding (spec 34.1): builds an optimal prefix code from a string's byte frequencies, stored in
flat arena arrays (no self-referential pointers). Construct once over the source text, then
encode/decode against that codebook. Ties are broken by lowest id, so a round-trip reproduces the
input exactly.

- `public constructor Huffman(String data)` — builds the codebook from the byte frequencies of `data`.
- `public method codeOf(int byteValue) returns String` — the `0`/`1` code assigned to a byte value (empty for bytes not in the source).
- `public method encode(String data) returns String` — turns `data` into its concatenated `0`/`1` bit string.
- `public method decode(String bits) returns String` — walks the tree over a `0`/`1` bit string to recover the original text.

---

## Lz77

```polaron
import System.Codecs.Lz77;
```

LZ77 sliding-window compression (spec 34.1): `encode` produces flattened `(offset, length, nextChar)`
triples over a bounded search window (`nextChar` is -1 only at the very end); `decode` replays them,
copying back-references (which may overlap, like run-length) to reconstruct the input exactly.

- `public constructor Lz77(int windowSize)` — creates a compressor with the given search-window size.
- `public method encode(String data) returns ArrayList<int>` — the flattened `(offset, length, nextChar)` triples.
- `public method decode(ArrayList<int> tokens) returns String` — reconstructs the original text from the triples.

---

## Soundex

```polaron
import System.Text.Soundex;
```

Soundex phonetic encoding (spec 34): maps a name to a letter followed by three digits so that
similar-sounding names share a code (e.g. Robert and Rupert both give R163). Vowels reset run
detection; `h` and `w` are transparent between equal-coded consonants.

- `public static method encode(String name) returns String` — the 4-character Soundex code of `name` (empty string for an empty name).

---

## Kmp

```polaron
import System.Text.Kmp;
```

Knuth-Morris-Pratt substring search (spec 34.1): a failure table (longest proper prefix that is also a
suffix) lets the scan never re-read text.

- `public static method indexOf(String text, String pattern) returns int` — the index of the first occurrence of `pattern` in `text`, or -1 (0 for an empty pattern).
- `public static method count(String text, String pattern) returns int` — the number of occurrences, counting overlaps.

---

## Manacher

```polaron
import System.Text.Manacher;
```

Manacher's algorithm (spec 34.1): the length of the longest palindromic substring in linear time, over
a transformed array with sentinels so odd and even palindromes are handled uniformly.

- `public static method longestPalindrome(String s) returns int` — the length of the longest palindromic substring of `s`.

---

## Rle

```polaron
import System.Codecs.Rle;
```

Run-length encoding of a string (spec 34): each run of a repeated character becomes that character
followed by its decimal count, e.g. `"aaabbbbc"` -> `"a3b4c1"`.

- `public static method encode(String s) returns String` — run-length encodes `s` (character then decimal run count).
- `public static method decode(String s) returns String` — reverses the encoding, reading a character and the digits that follow as a repeat count.

---

## Calculator

```polaron
import System.Text.Calculator;
```

Evaluates an integer arithmetic expression (spec 34): `+ - * /` with the usual precedence and
parentheses, by recursive descent. Spaces are ignored; division truncates toward zero.

- `public constructor Calculator(String expr)` — creates an evaluator over the expression string `expr`.
- `public method evaluate() returns int` — parses and evaluates the expression, returning the integer result.

---

## Sha384 / Sha512

```polaron
import System.Security.Sha384;
import System.Security.Sha512;
```

The other two members of the SHA-2 family, with the same shape as `Sha256`: a 48- and a 64-byte
digest over the 64-bit compression function. They are here because certificates ask for them by
name — a chain signed with SHA-384 cannot be verified with anything else.

- `public static method ofString(String s) returns int[]` — the digest of `s`'s bytes.
- `public static method ofBytes(int[] data, int count) returns int[]` — the digest of `count` bytes.
- `public static method hex(int[] digest) returns String` — the usual lower-case rendering.

---

## Deflate / Inflate / Gzip

```polaron
import System.Compress.Gzip;
```

Real DEFLATE (RFC 1951) and the gzip container (RFC 1952), written in Polaron — the compression a
`.gz` file, an HTTP `Content-Encoding: gzip` body and a PNG's pixel data are all made of. `Zlib`
above is the third container over the same codec.

| Type | Members |
|---|---|
| `Deflate` | `bytes(int[] data, int len) returns int[]`, `text(String s) returns int[]` — compressed, raw stream. |
| `Inflate` | `bytes(int[] data, int len) returns int[]`, `text(int[] data, int len) returns String` — back again. |
| `Gzip` | `compress(int[] data, int len)`, `compressText(String s)`, `decompress(int[] data, int len)` — the same with a gzip header, checksum and length. |
| `Crc32` | `ofBytes(int[] data, int count) returns long`, `ofString(String s) returns long` — the checksum gzip and PNG both carry. |

### `ByteArray` and `ByteSink`

The two helpers the codecs are written against, useful anywhere bytes are being built:

- `ByteArray.of(String s) returns int[]` — a string's bytes; `ByteArray.text(int[] data, int count)`
  turns them back.
- `ByteSink` — a growable byte buffer: `add(b)`, `size()`, `at(i)`, `toArray()`, and
  `repeatFrom(distance, count)`, which is the back-reference copy every LZ-family decoder needs and
  the one place an off-by-one silently produces plausible garbage.
