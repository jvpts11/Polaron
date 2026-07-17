// ldp3c -- the LDP3 compiler driver (CLI entry point).
//
// Release 0.1 / M1 (walking skeleton): the full pipeline is wired up.
//   ldp3c <in.ldp3> [-o <out.ll>]   compile to LLVM IR (stdout if no -o)
//   ldp3c --dump-tokens <in.ldp3>   lexer output
//   ldp3c --dump-ast <in.ldp3>      parser output
//   ldp3c --check <in.ldp3>...      lex + parse + semantic only (no codegen), report every diagnostic
//   ldp3c --version

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <map>
#include <optional>
#include <tuple>
#include <sstream>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "lexer/lexer.h"
#include "lexer/token.h"
#include "parser/ast.h"
#include "parser/boundscheck.h"
#include "parser/loopopt.h"
#include "parser/ipc.h"
#include "parser/monomorphize.h"
#include "parser/parser.h"
#include "semantic/analyzer.h"

#include "bundle/ldh.h"
#include "diag/diagnostic.h"
#include "diag/render.h"
#include "doc/htmldoc.h"
#include "fmt/formatter.h"

#ifdef LDP3_WITH_LLVM
#include "bundle/ldb.h"
#include "codegen/codegen.h"
#endif

namespace {

constexpr std::string_view kVersion = "ldp3c 1.0.0";

std::optional<std::string> readFile(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) return std::nullopt;
    std::ostringstream buffer;
    buffer << in.rdbuf();
    return buffer.str();
}

// `--overlay <real>=<temp>`: read <real>'s CONTENT from <temp>, but keep calling it <real>.
//
// An editor checks a buffer that is not on disk yet. It writes the buffer to a scratch file and asks for
// a check -- and every diagnostic must still point at the file the user is looking at, not at the scratch
// copy. So the compiler is told both paths: the bytes come from one, the name from the other.
std::map<std::string, std::string> g_overlays;  // key(real) -> temp path

std::string overlayKey(const std::string& path) {
    std::error_code ec;
    std::filesystem::path c = std::filesystem::weakly_canonical(std::filesystem::path(path), ec);
    std::string s = (ec ? std::filesystem::path(path) : c).string();
#ifdef _WIN32
    for (char& ch : s) ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
#endif
    return s;
}

std::optional<std::string> readSource(const std::string& path) {
    const auto it = g_overlays.find(overlayKey(path));
    return readFile(it == g_overlays.end() ? path : it->second);
}

// The source of every file compiled this run, so the rich-diagnostic renderer can show the offending line.
// Keyed by the loc's file string (the path as it appears in SourceLocation), and holding the OVERLAID
// content when an overlay is in effect -- the snippet must show what was actually compiled.
std::map<std::string, std::string> g_sources;
bool g_concise = false;  // --concise: one machine-parseable line per diagnostic (implied by --check)

// The 1-based `line` of `file`'s compiled source, or "" if unavailable (e.g. the embedded prelude).
std::string sourceLineAt(std::string_view file, int line) {
    const auto it = g_sources.find(std::string(file));
    if (it == g_sources.end() || line < 1) return "";
    const std::string& src = it->second;
    std::size_t start = 0;
    for (int cur = 1; cur < line; ++cur) {
        const std::size_t nl = src.find('\n', start);
        if (nl == std::string::npos) return "";
        start = nl + 1;
    }
    std::size_t end = src.find('\n', start);
    std::string ln = src.substr(start, end == std::string::npos ? std::string::npos : end - start);
    if (!ln.empty() && ln.back() == '\r') ln.pop_back();
    return ln;
}

// Print one semantic diagnostic (error or warning) richly, unless concise output was requested.
void printSemaDiag(std::string_view severity, const ldp3::SemaError& d, bool concise) {
    const std::string file(d.loc.file);
    std::fputs(ldp3::diag::render(severity, file, d.loc.line, d.loc.col, d.message, d.code,
                                  sourceLineAt(d.loc.file, d.loc.line), concise)
                   .c_str(),
               stderr);
}

// The embedded standard prelude. Parsed and merged into every program so that
// `import System.Memory.Units.kilobytes;` resolves without a stdlib on disk
// (spec 17.10). The unit literals return a heap-allocated ByteSize; the spec
// makes them comptime, so the allocation vanishes once comptime eval lands (F6).
// Not constexpr: the concatenated literal is ~400 KB, past the 64 KB that a standard C++ compiler must
// accept in a constant expression (clang enforces this; MSVC is lenient). It is only parsed at run time,
// so a plain const string_view over the static literal is all that is needed.
const std::string_view kPreludeSource = R"LDP3(
program __prelude;
public bundle std {
    public namespace System.Memory.Units {
        public struct ByteSize {
            public final long bytes;
            public constructor ByteSize(long bytes) { this.bytes = bytes; }
            public comptime literal bytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x)) on heap;
            }
            public comptime literal kilobytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x) * 1024) on heap;
            }
            public comptime literal megabytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x) * 1024 * 1024) on heap;
            }
            public comptime literal gigabytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x) * 1024 * 1024 * 1024) on heap;
            }
            public comptime literal terabytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x) * 1024 * 1024 * 1024 * 1024) on heap;
            }
            public comptime literal exabytes(int x) returns ByteSize {
                return new ByteSize(cast<long>(x) * 1024 * 1024 * 1024 * 1024 * 1024 * 1024) on heap;
            }
        }
    }
    public namespace System.Concurrency {
        // An OS thread (spec 20.1). Holds a function<void> and its OS handle; start()/join() call
        // the low-level thread builtins, which lower to CreateThread / WaitForSingleObject.
        public class Thread {
            private function<void> work;
            private mutable long handle;
            public constructor Thread(function<void> w) {
                this.work = w;
                this.handle = cast<long>(0);
            }
            public method start() returns void {
                this.handle = System.Concurrency.__threadStart(this.work);
            }
            public method join() returns void {
                System.Concurrency.__threadJoin(this.handle);
            }
        }
        // The handle to an async computation that will produce a T (spec 20.2). `h` is the
        // runtime ldp3_task*; an async method returns one of these and `await` yields the T.
        public class Task<T> {
            public mutable long h;
            public constructor Task() { this.h = cast<long>(0); }
        }
        // A bounded blocking channel (spec 20.3): send() blocks while full, receive() blocks while
        // empty. The element T is passed as a 64-bit slot (an int or a reference).
        public class Channel<T> {
            public mutable long h;
            public constructor Channel(int capacity) {
                this.h = System.Concurrency.__chanNew(cast<long>(capacity));
            }
        }
        // A lock-free atomic cell (spec 20.6). get/set/add/increment/compareAndSet (and the atomic
        // ++ / += operators) lower to LLVM atomic instructions; T is an integer type.
        public class atomic<T> {
            public mutable T value;
            public constructor atomic(T initial) { this.value = initial; }
        }
        // A mutual-exclusion lock guarding a value of type T (spec 20.5). The value is reached
        // only through `synchronized (m) using T& x { ... }`, which holds the lock for the block.
        public class Mutex<T> {
            public mutable T value;
            public mutable long lock;
            public constructor Mutex(T initial) {
                this.value = initial;
                this.lock = System.Concurrency.__lockCreate();
            }
        }
        // A counting semaphore (spec 20): `n` permits over a bounded channel. acquire() blocks until a
        // permit is free; release() returns one. The channel's blocking send/receive do the waiting.
        public class Semaphore {
            private mutable Channel<int> tokens;   // 'permits' is a reserved word
            public constructor Semaphore(int n) {
                this.tokens = new Channel<int>(n) on heap;
                for (mutable int i = 0; i < n; i++) { this.tokens.send(1); }
            }
            public method acquire() returns void { int t = this.tokens.receive(); }
            public method signal() returns void { this.tokens.send(1); }   // 'release' is a reserved word
        }
        // A one-shot latch (spec 20): threads await() until `n` countDown() calls have happened. Once the
        // count reaches zero a token is placed in the gate and every waiter passes (take-then-return).
        public class CountdownLatch {
            private mutable atomic<int> count;
            private mutable Channel<int> gate;
            public constructor CountdownLatch(int n) {
                this.count = new atomic<int>(n) on heap;
                this.gate = new Channel<int>(1) on heap;
                if (n <= 0) { this.gate.send(1); }   // already open
            }
            public method countDown() returns void {
                int now = this.count.add(cast<int>(0 - 1));
                if (now == 0) { this.gate.send(1); }
            }
            public method waitFor() returns void {   // 'await' is a keyword
                int t = this.gate.receive();
                this.gate.send(t);   // leave the token so later/other waiters also pass
            }
            public method getCount() returns int { return this.count.get(); }
        }
)LDP3"
// (split: keep each literal under MSVC's ~16KB cap; still the same System.Concurrency namespace.)
R"LDP3(
        // A cyclic-style barrier (spec 20): `n` threads await() until all have arrived, then all proceed.
        // The n-th arrival releases n tokens; each thread (including it) takes one. Single use.
        public class Barrier {
            private mutable int parties;
            private mutable atomic<int> arrived;
            private mutable Channel<int> gate;
            public constructor Barrier(int n) {
                this.parties = n;
                this.arrived = new atomic<int>(0) on heap;
                this.gate = new Channel<int>(n) on heap;
            }
            public method arrive() returns void {   // block until all parties arrive ('await' is a keyword)
                int a = this.arrived.add(1);
                if (a == this.parties) {
                    for (mutable int i = 0; i < this.parties; i++) { this.gate.send(1); }
                }
                int t = this.gate.receive();
            }
        }
        // A reader/writer lock (spec 20), reader-preference: any number of readers, or one writer. Built
        // from two semaphores plus a reader counter (the first reader takes the write lock, the last frees
        // it).
        public class ReadWriteLock {
            private mutable Semaphore readerMutex;
            private mutable Semaphore writeSem;
            private mutable atomic<int> readers;
            public constructor ReadWriteLock() {
                this.readerMutex = new Semaphore(1) on heap;
                this.writeSem = new Semaphore(1) on heap;
                this.readers = new atomic<int>(0) on heap;
            }
            public method readLock() returns void {
                this.readerMutex.acquire();
                int r = this.readers.add(1);
                if (r == 1) { this.writeSem.acquire(); }
                this.readerMutex.signal();
            }
            public method readUnlock() returns void {
                this.readerMutex.acquire();
                int r = this.readers.add(cast<int>(0 - 1));
                if (r == 0) { this.writeSem.signal(); }
                this.readerMutex.signal();
            }
            public method writeLock() returns void { this.writeSem.acquire(); }
            public method writeUnlock() returns void { this.writeSem.signal(); }
        }
    }
    public namespace System.Errors {
        // Result<T,E> / Option<T> (spec 21.2-21.3): sealed sum types matched with `match`. Ok/Err/
        // Some/None are constructed with the type args taken from the expected type at the use site.
        // The abstract method forces a vtable so `match` can dispatch on the variant.
        public sealed abstract class Result<T, E> permits Ok, Err {
            public abstract method isOk() returns boolean;
        }
        public class Ok<T, E> extends Result<T, E> {
            public final T value;
            public constructor Ok(T value) { this.value = value; }
            public override method isOk() returns boolean { return true; }
        }
        public class Err<T, E> extends Result<T, E> {
            public final E error;
            public constructor Err(E error) { this.error = error; }
            public override method isOk() returns boolean { return false; }
        }
        public sealed abstract class Option<T> permits Some, None {
            public abstract method isSome() returns boolean;
        }
        public class Some<T> extends Option<T> {
            public final T value;
            public constructor Some(T value) { this.value = value; }
            public override method isSome() returns boolean { return true; }
        }
        public class None<T> extends Option<T> {
            public constructor None() {}
            public override method isSome() returns boolean { return false; }
        }
    }
    public namespace System.IO {
        // Console I/O (spec 2.9 / 4). The methods are recognized by the compiler and lower to
        // libc printf/scanf; this class exists so `import System.IO.Console;` resolves and the
        // usual namespace-visibility rules require importing it before use.
        public class Console {
        }
        // Line-oriented file helpers (spec 34.4): the File builtin reads and writes whole contents, and
        // Files layers lines on top of it through Strings, so a program reads a file into a list of lines
        // and writes a list back without handling the newline joins itself.
        public class Files {
            // Each line is terminated with a newline, and a trailing empty piece from the final newline is
            // dropped on read, so writeLines then readLines round-trips and appendLine adds a clean line.
            public static method readLines(String path) returns ArrayList<String> {
                mutable ArrayList<String> lines = Strings.split(File.readAll(path), "\n");
                if (lines.size() > 0 && lines.get(lines.size() - 1).length() == 0) {
                    lines.removeAt(lines.size() - 1);
                }
                return lines;
            }
            public static method writeLines(String path, ArrayList<String> lines) returns void {
                StringBuilder sb = new StringBuilder() on heap;  // concat in a loop was O(total^2)
                for (mutable int i = 0; i < lines.size(); i++) {
                    sb.append(lines.get(i));
                    sb.appendChar(cast<char>(10));  // '\n'
                }
                File.writeAll(path, sb.toString());
                return;
            }
            public static method appendLine(String path, String line) returns void {
                File.appendAll(path, line.concat("\n"));
                return;
            }
            // The entries of a directory (spec 34.4), one per element. Empty if the path is not a
            // directory. Wraps the newline-separated File.list.
            public static method listDir(String path) returns ArrayList<String> {
                mutable ArrayList<String> entries = Strings.split(File.list(path), "\n");
                if (entries.size() > 0 && entries.get(entries.size() - 1).length() == 0) {
                    entries.removeAt(entries.size() - 1);
                }
                return entries;
            }
        }
        // Path-string manipulation (spec 34.4): join segments, and pull apart a path into its directory,
        // final component, and extension. Pure string work over "/" -- it does not touch the filesystem.
        public class Paths {
            public static method join(String base, String name) returns String {
                if (base.length() == 0) { return name; }
                if (base.endsWith("/")) { return base.concat(name); }
                return base.concat("/").concat(name);
            }
            public static method basename(String path) returns String {
                int cut = Paths.lastSep(path);
                return cut < 0 ? path : path.substring(cut + 1, path.length());
            }
            public static method dirname(String path) returns String {
                int cut = Paths.lastSep(path);
                return cut < 0 ? "" : path.substring(0, cut);
            }
            // Index of the last path separator -- '/' or, on Windows, '\\'. -1 if there is none. Handling
            // both keeps dirname/basename correct on native Windows paths (e.g. an executable's own path).
            private static method lastSep(String path) returns int {
                mutable int last = 0 - 1; mutable int i = 0;
                while (i < path.length()) {
                    char c = path.charAt(i);
                    if (c == '/' || c == '\\') { last = i; }
                    i = i + 1;
                }
                return last;
            }
            public static method extension(String path) returns String {
                String base = Paths.basename(path);
                mutable ArrayList<String> parts = Strings.split(base, ".");
                if (parts.size() < 2) { return ""; }
                return parts.get(parts.size() - 1);
            }
        }
        // Leveled logging to the console (spec 34): each message carries a level (debug/info/warn/error)
        // and is printed with the logger's name only when its level is at or above the configured minimum,
        // which starts at info. A quick way to get structured, filterable output without a framework.
        public class Logger {
            private mutable String name;
            private mutable int minLevel;
            public constructor Logger(String name) {
                this.name = name;
                this.minLevel = 1;
            }
            public method setLevel(int level) returns void {
                this.minLevel = level;
                return;
            }
            private method emit(String level, String message) returns void {
                System.IO.Console.printf("[%s] %s: %s\n", level, this.name, message);
                return;
            }
            public method debug(String message) returns void {
                if (this.minLevel <= 0) { this.emit("DEBUG", message); }
                return;
            }
            public method info(String message) returns void {
                if (this.minLevel <= 1) { this.emit("INFO", message); }
                return;
            }
            public method warn(String message) returns void {
                if (this.minLevel <= 2) { this.emit("WARN", message); }
                return;
            }
            public method error(String message) returns void {
                if (this.minLevel <= 3) { this.emit("ERROR", message); }
                return;
            }
        }
        // Reads a program's command-line arguments (spec 34): has tests for a flag, value returns the token
        // after a flag (empty if absent), and get/count index the raw arguments. Wraps the String[] handed
        // to main, so a program parses its options without scanning the array by hand.
        public class Args {
            private mutable String[] argv;
            public constructor Args(String[] argv) {
                this.argv = argv;
            }
            public method has(String flag) returns boolean {
                for (mutable int i = 0; i < this.argv.length(); i++) {
                    if (this.argv[i].equals(flag)) { return true; }
                }
                return false;
            }
            public method value(String flag) returns String {
                for (mutable int i = 0; i < this.argv.length(); i++) {
                    if (this.argv[i].equals(flag) && i + 1 < this.argv.length()) {
                        return this.argv[i + 1];
                    }
                }
                return "";
            }
            public method count() returns int { return this.argv.length(); }
            public method get(int i) returns String { return this.argv[i]; }
        }
    }
)LDP3"
R"LDP3(
    public namespace System.Math {
        // Math (spec 34.6) is a compiler builtin (its functions lower to LLVM intrinsics), not a
        // real class -- a real `Math` class would clash with user classes named Math via namespace
        // disambiguation. The name `Math` is registered virtually so `import System.Math.Math;`
        // resolves (see the analyzer). Only Random is a real class here.
        // A deterministic PRNG (xorshift64), pure LDP3 over a ulong state (spec 34.6 Random).
        public class Random {
            private mutable ulong state;
            public constructor Random(ulong seed) {
                this.state = seed;
                if (this.state == cast<ulong>(0)) { this.state = cast<ulong>(1); }
            }
            public method nextInt() returns int {
                mutable ulong x = this.state;
                x = x ^ (x << 13);
                x = x ^ (x >> 7);
                x = x ^ (x << 17);
                this.state = x;
                return cast<int>(x >> 33);   // a non-negative 31-bit value
            }
            public method nextIntMax(int max) returns int {
                return this.nextInt() % max;   // [0, max)
            }
            public method nextRange(int lo, int hi) returns int {
                return lo + this.nextIntMax(hi - lo);   // [lo, hi)
            }
            public method nextDouble() returns double {
                return cast<double>(this.nextInt()) / 2147483648.0;   // [0, 1)
            }
            public method nextBool() returns boolean {
                return this.nextIntMax(2) == 0;
            }
            // sqrt/ln are kept private here so Random depends on no external class name -- the `Math`
            // builtin name can be shadowed by a user class, and the prelude must never rely on it. The
            // algorithms mirror System.Math.Math (Newton's method; atanh series after range reduction).
            private method sqrtD(double x) returns double {
                if (x <= 0.0) { return 0.0; }
                mutable double g = x;
                if (g > 1.0) { g = x / 2.0; }
                for (mutable int i = 0; i < 40; i++) { g = 0.5 * (g + x / g); }
                return g;
            }
            private method lnD(double x) returns double {
                if (x <= 0.0) { return 0.0; }
                mutable double v = x;
                mutable int e = 0;
                while (v >= 2.0) { v = v / 2.0; e = e + 1; }
                while (v < 1.0) { v = v * 2.0; e = e - 1; }
                double t = (v - 1.0) / (v + 1.0);
                double t2 = t * t;
                mutable double term = t;
                mutable double sum = 0.0;
                mutable int k = 1;
                while (k <= 25) { sum = sum + term / cast<double>(k); term = term * t2; k = k + 2; }
                return 2.0 * sum + cast<double>(e) * 0.6931471805599453;
            }
            // A standard-normal N(0, 1) sample via the Marsaglia polar method (spec 34.6): rejection
            // sampling inside the unit disc, then a sqrt/ln scale. nextGaussianScaled shifts and scales it.
            public method nextGaussian() returns double {
                mutable double s = 0.0;
                mutable double u = 0.0;
                mutable boolean ok = false;
                while (ok == false) {
                    u = 2.0 * this.nextDouble() - 1.0;
                    double v = 2.0 * this.nextDouble() - 1.0;
                    s = u * u + v * v;
                    if (s < 1.0) { if (s > 0.0) { ok = true; } }
                }
                return u * this.sqrtD(-2.0 * this.lnD(s) / s);
            }
            public method nextGaussianScaled(double mean, double stddev) returns double {
                return mean + stddev * this.nextGaussian();
            }
            // A generator seeded from the monotonic clock -- a fresh, non-reproducible sequence per run,
            // for when reproducibility is not wanted (the seeded constructor stays for deterministic runs).
            public static method seededNow() returns Random {
                return new Random(cast<ulong>(Time.nanos())) on heap;
            }
        }
    }
    public namespace System.Runtime {
        // The root of the class hierarchy (spec 3.4): every class implicitly extends Object. equals
        // defaults to identity and hashCode to the object's address; both are virtual so subclasses
        // (e.g. records) override them. toString() returns String and is added with the String type.
        public class Object {
            public method equals(Object other) returns boolean { return this == other; }
            public method hashCode() returns int { return 0; }
            // Identity-based key equality: every object is usable as a collection element/key, with
            // reference identity by default. A class overrides this (and hashCode) for value equality.
            public method equalsKey(Object other) returns boolean { return this == other; }
        }
        // Base for runtime exceptions (polymorphic, so it can be caught). UnimportedType
        // Exception is thrown when an unimported type is used (spec 30).
        public abstract class Exception {
            public abstract method message() returns String;
        }
        public class UnimportedTypeException extends Exception {
            public constructor UnimportedTypeException() {}
            public override method message() returns String { return "type was unimported"; }
        }
        // Thrown on first use of a dynamically-loaded bundle (--use-dynamic) that is absent at runtime
        // (spec 2.4): wrap the use in try/catch to run without it.
        public class BundleNotLoadedException extends Exception {
            public constructor BundleNotLoadedException() {}
            public override method message() returns String { return "bundle not loaded"; }
        }
        // Thrown when a loaded bundle's ABI fingerprint does not match what the program compiled
        // against (spec 2.5).
        public class BundleAbiMismatchException extends Exception {
            public constructor BundleAbiMismatchException() {}
            public override method message() returns String { return "bundle ABI mismatch"; }
        }
        // Thrown by an invalid class downcast: `cast<Dog>(animal)` / `animal as Dog` when the object is
        // not a Dog (spec 6.3). Catch it, or use `animal as? Dog` (yields null) / `animal is Dog`.
        public class ClassCastException extends Exception {
            public constructor ClassCastException() {}
            public override method message() returns String { return "invalid cast"; }
        }
    }
)LDP3"
// (split 0: keep each literal under MSVC's ~16KB cap.)
R"LDP3(
    public namespace System.Collections {
        // A cursor over a sequence: hasNext reports whether another element remains, next yields the
        // current one and advances (spec 34). Iterable is anything that can hand out a fresh Iterator
        // over its elements, so a generic algorithm can walk any collection through these two interfaces.
        public interface Iterator<T> {
            method hasNext() returns boolean;
            method next() returns T;
        }
        public interface Iterable<T> {
            method iterator() returns Iterator<T>;
        }
        // A growable list backed by a dynamic array that doubles on overflow (spec 31 uses
        // ArrayList<Method>/ArrayList<Field>; also a general-purpose collection).
        public class ArrayList<T> implements Iterable<T> {
            private mutable T[] data;
            private mutable int count;
            public constructor ArrayList() {
                this.data = new T[4]();
                this.count = 0;
            }
            public method add(T item) returns void {
                if (this.count >= this.data.length()) {
                    mutable T[] bigger = new T[this.data.length() * 2]();
                    for (mutable int i = 0; i < this.count; i++) {
                        bigger[i] = this.data[i];
                    }
                    delete this.data;
                    this.data = bigger;
                }
                this.data[this.count] = item;
                this.count = this.count + 1;
            }
            // Grow the backing store to hold at least n elements up front, so a known-size fill (a copy,
            // a filter/map/sort output) does not pay repeated doubling reallocations. A no-op when the
            // capacity already suffices; never shrinks.
            public method ensureCapacity(int n) returns void {
                if (n > this.data.length()) {
                    mutable T[] bigger = new T[n]();
                    for (mutable int i = 0; i < this.count; i++) { bigger[i] = this.data[i]; }
                    delete this.data;
                    this.data = bigger;
                }
            }
            public method get(int i) returns T {
                if (i < 0 || i >= this.count) {
                    // Past the logical size but still inside the backing store's spare capacity: the raw
                    // array check would not catch it, so force a clean "array index out of bounds" panic
                    // instead of returning an uninitialized slot (garbage for a value, a wild pointer for
                    // an object). No UB.
                    return this.data[this.data.length()];
                }
                return this.data[i];
            }
            public method set(int i, T item) returns void {
                if (i < 0 || i >= this.count) {
                    this.data[this.data.length()] = item;   // out of bounds -> clean panic, never a silent write
                    return;
                }
                this.data[i] = item;
            }
            public method indexOf(T item) returns int {  // -1 if absent (uses equalsKey)
                for (mutable int i = 0; i < this.count; i++) {
                    if (this.data[i].equalsKey(item)) { return i; }
                }
                return -1;
            }
            public method contains(T item) returns boolean {
                return this.indexOf(item) >= 0;
            }
            public method removeAt(int i) returns void {  // shift the tail left
                if (i < 0 || i >= this.count) {
                    // Out of range would silently decrement count (or leave a gap) without removing
                    // anything. Force a clean "array index out of bounds" panic instead. No UB.
                    mutable T oob = this.data[this.data.length()];
                    return;
                }
                for (mutable int j = i; j < this.count - 1; j++) {
                    this.data[j] = this.data[j + 1];
                }
                this.count = this.count - 1;
            }
            public method insertAt(int i, T item) returns void {  // shift the tail right, insert at i
                if (i < 0 || i > this.count) {   // count itself is valid here -- that is an append
                    this.data[this.data.length()] = item;   // out of bounds -> clean panic, no silent gap
                    return;
                }
                if (this.count >= this.data.length()) {
                    mutable T[] bigger = new T[this.data.length() * 2]();
                    for (mutable int k = 0; k < this.count; k++) { bigger[k] = this.data[k]; }
                    delete this.data;
                    this.data = bigger;
                }
                for (mutable int j = this.count; j > i; j--) {
                    this.data[j] = this.data[j - 1];
                }
                this.data[i] = item;
                this.count = this.count + 1;
            }
            public method remove(T item) returns boolean {  // remove first equal element
                int i = this.indexOf(item);
                if (i < 0) { return false; }
                this.removeAt(i);
                return true;
            }
            public method clear() returns void {
                this.count = 0;
            }
            public method toArray() returns T[] {
                mutable T[] out = new T[this.count]();
                for (mutable int i = 0; i < this.count; i++) { out[i] = this.data[i]; }
                return out;
            }
            public method size() returns int {
                return this.count;
            }
            public method isEmpty() returns boolean {
                return this.count == 0;
            }
            // Functional pipeline (spec 34): run over, and select from, the elements with a lambda.
            public method forEach(function<void, T> action) returns void {
                for (mutable int i = 0; i < this.count; i++) { action(this.data[i]); }
            }
            public method filter(function<boolean, T> keep) returns ArrayList<T> {
                mutable ArrayList<T> out = new ArrayList<T>() on heap;
                out.ensureCapacity(this.count);  // at most `count` kept; size once instead of growing
                for (mutable int i = 0; i < this.count; i++) {
                    if (keep(this.data[i])) { out.add(this.data[i]); }
                }
                return out;
            }
            public method map<R>(function<R, T> transform) returns ArrayList<R> {
                mutable ArrayList<R> out = new ArrayList<R>() on heap;
                out.ensureCapacity(this.count);  // output is exactly `count`; size once, no growth
                for (mutable int i = 0; i < this.count; i++) { out.add(transform(this.data[i])); }
                return out;
            }
            public method reduce<R>(R seed, function<R, R, T> combine) returns R {
                mutable R acc = seed;
                for (mutable int i = 0; i < this.count; i++) { acc = combine(acc, this.data[i]); }
                return acc;
            }
            public method any(function<boolean, T> pred) returns boolean {
                for (mutable int i = 0; i < this.count; i++) {
                    if (pred(this.data[i])) { return true; }
                }
                return false;
            }
            public method all(function<boolean, T> pred) returns boolean {
                for (mutable int i = 0; i < this.count; i++) {
                    if (!pred(this.data[i])) { return false; }
                }
                return true;
            }
            public method count(function<boolean, T> pred) returns int {
                mutable int hits = 0;
                for (mutable int i = 0; i < this.count; i++) {
                    if (pred(this.data[i])) { hits = hits + 1; }
                }
                return hits;
            }
            // Returns a new list with the elements ordered by a comparator (spec 34): compare(a, b) is
            // negative when a comes first, positive when b does. Stable merge sort, leaves this list
            // untouched. The comparator keeps it generic -- the element type needs no ordering of its own.
            public method sortedBy(function<int, T, T> compare) returns ArrayList<T> {
                mutable ArrayList<T> out = new ArrayList<T>() on heap;
                out.ensureCapacity(this.count);  // the copy is known-size; fill without reallocating
                for (mutable int i = 0; i < this.count; i++) { out.add(this.data[i]); }
                if (out.size() > 1) {
                    T[] scratch = new T[out.size()]();  // O(n) merge buffer, freed below
                    out.mergeSortRange(scratch, 0, out.size() - 1, compare);
                    delete scratch;
                }
                return out;
            }
            // Stable merge sort (O(n log n)) backing sortedBy; `tmp` is an n-element scratch array. Kept
            // internal to the collection. Two standard refinements over the textbook version: small ranges
            // fall back to an in-place insertion sort (no recursion/merge overhead, cache-friendly), and a
            // range whose two sorted halves are already in order skips the merge and its copy-back entirely.
            private method mergeSortRange(T[] tmp, int lo, int hi, function<int, T, T> compare) returns void {
                if (lo >= hi) { return; }
                if (hi - lo < 16) {  // insertion sort; stable -- only shifts strictly-greater elements
                    for (mutable int p = lo + 1; p <= hi; p = p + 1) {
                        T key = this.data[p];
                        mutable int q = p - 1;
                        while (q >= lo && compare(this.data[q], key) > 0) {
                            this.data[q + 1] = this.data[q];
                            q = q - 1;
                        }
                        this.data[q + 1] = key;
                    }
                    return;
                }
                int mid = (lo + hi) / 2;
                this.mergeSortRange(tmp, lo, mid, compare);
                this.mergeSortRange(tmp, mid + 1, hi, compare);
                if (compare(this.data[mid], this.data[mid + 1]) <= 0) { return; }  // already ordered
                mutable int i = lo;
                mutable int j = mid + 1;
                mutable int k = lo;
                while (i <= mid && j <= hi) {
                    if (compare(this.data[i], this.data[j]) <= 0) {
                        tmp[k] = this.data[i];
                        i = i + 1;
                    } else {
                        tmp[k] = this.data[j];
                        j = j + 1;
                    }
                    k = k + 1;
                }
                while (i <= mid) { tmp[k] = this.data[i]; i = i + 1; k = k + 1; }
                while (j <= hi) { tmp[k] = this.data[j]; j = j + 1; k = k + 1; }
                for (mutable int t = lo; t <= hi; t = t + 1) { this.data[t] = tmp[t]; }
            }
)LDP3"
R"LDP3(
            // Search terminals (spec 34): find returns the first element a predicate accepts, min/max the
            // smallest/largest by a comparator. Each returns Option<T> -- Some on a hit, None when the list
            // is empty or nothing matches -- so the empty case is in the type, not a sentinel.
            public method find(function<boolean, T> pred) returns Option<T> {
                for (mutable int i = 0; i < this.count; i++) {
                    if (pred(this.data[i])) { return Some(this.data[i]); }
                }
                return None();
            }
            public method min(function<int, T, T> compare) returns Option<T> {
                if (this.count == 0) { return None(); }
                mutable T best = this.data[0];
                for (mutable int i = 1; i < this.count; i++) {
                    if (compare(this.data[i], best) < 0) { best = this.data[i]; }
                }
                return Some(best);
            }
            public method max(function<int, T, T> compare) returns Option<T> {
                if (this.count == 0) { return None(); }
                mutable T best = this.data[0];
                for (mutable int i = 1; i < this.count; i++) {
                    if (compare(this.data[i], best) > 0) { best = this.data[i]; }
                }
                return Some(best);
            }
            public override method iterator() returns Iterator<T> {
                return new ArrayListIterator<T>(this) on heap;
            }
        }
        // The cursor an ArrayList hands out: walks indices 0..size over the list it was given.
        public class ArrayListIterator<T> implements Iterator<T> {
            private mutable ArrayList<T> list;
            private mutable int pos;
            public constructor ArrayListIterator(ArrayList<T> list) {
                this.list = list;
                this.pos = 0;
            }
            public override method hasNext() returns boolean {
                return this.pos < this.list.size();
            }
            public override method next() returns T {
                mutable T value = this.list.get(this.pos);
                this.pos = this.pos + 1;
                return value;
            }
        }
        // A lazy iterator pipeline (spec 25 / stdlib #25): a Stream is itself an Iterator, and each
        // transform (filter/map) wraps the previous stream and pulls elements on demand -- nothing runs
        // until a terminal op (fold/count/forEach) drives hasNext/next. Build one over any Iterator with
        // `new IteratorStream<T>(collection.iterator())`, then chain. map<R> may change the element type.
        public abstract class Stream<T> implements Iterator<T> {
            public abstract method hasNext() returns boolean;
            public abstract method next() returns T;
            public method filter(function<boolean, T> pred) returns Stream<T> {
                return new FilterStream<T>(this, pred) on heap;
            }
            public method map<R>(function<R, T> fn) returns Stream<R> {
                return new MapStream<T, R>(this, fn) on heap;
            }
            public method fold<R>(R init, function<R, R, T> combine) returns R {
                mutable R acc = init;
                while (this.hasNext()) { acc = combine(acc, this.next()); }
                return acc;
            }
            public method forEach(function<void, T> action) returns void {
                while (this.hasNext()) { action(this.next()); }
            }
            public method count() returns int {
                mutable int c = 0;
                while (this.hasNext()) { this.next(); c = c + 1; }
                return c;
            }
        }
        // Adapts a plain Iterator into a Stream (the head of a pipeline).
        public class IteratorStream<T> extends Stream<T> {
            private Iterator<T> src;
            public constructor IteratorStream(Iterator<T> src) { this.src = src; }
            public override method hasNext() returns boolean { return this.src.hasNext(); }
            public override method next() returns T { return this.src.next(); }
        }
        // Yields only the upstream elements that satisfy the predicate; caches one look-ahead so hasNext
        // can skip rejected elements without losing the accepted one.
        public class FilterStream<T> extends Stream<T> {
            private Stream<T> src;
            private function<boolean, T> pred;
            private mutable boolean hasCached;
            private mutable T cached;
            public constructor FilterStream(Stream<T> src, function<boolean, T> pred) {
                this.src = src; this.pred = pred; this.hasCached = false;
            }
            public override method hasNext() returns boolean {
                if (this.hasCached) { return true; }
                while (this.src.hasNext()) {
                    T v = this.src.next();
                    if (this.pred(v)) { this.cached = v; this.hasCached = true; return true; }
                }
                return false;
            }
            public override method next() returns T {
                this.hasCached = false;
                return this.cached;
            }
        }
        // Applies a transform to each upstream element as it is pulled, possibly changing the type
        // (T -> R). Extends Stream<R>, so map may be chained with a different element type.
        public class MapStream<T, R> extends Stream<R> {
            private Stream<T> src;
            private function<R, T> fn;
            public constructor MapStream(Stream<T> src, function<R, T> fn) {
                this.src = src; this.fn = fn;
            }
            public override method hasNext() returns boolean { return this.src.hasNext(); }
            public override method next() returns R { return this.fn(this.src.next()); }
        }
        // A non-owning window over a [start, start+len) range of an array (spec 34): no copy, just a
        // backing array and an offset. Reads go through the array's own bounds check, so there is no UB;
        // sub returns a narrower window, toArray copies the window out into a fresh array.
        public class Slice<T> {
            private mutable T[] backing;
            private mutable int start;
            private mutable int len;
            public constructor Slice(T[] array, int start, int len) {
                this.backing = array;
                this.start = start;
                this.len = len;
            }
            public method length() returns int {
                return this.len;
            }
            public method get(int i) returns T {
                return this.backing[this.start + i];
            }
            public method set(int i, T value) returns void {
                this.backing[this.start + i] = value;
            }
            public method sub(int from, int to) returns Slice<T> {
                return new Slice<T>(this.backing, this.start + from, to - from) on heap;
            }
            public method toArray() returns T[] {
                mutable T[] out = new T[this.len]();
                for (mutable int i = 0; i < this.len; i++) { out[i] = this.backing[this.start + i]; }
                return out;
            }
        }
)LDP3"
// Split here only to stay under the MSVC per-string-literal size limit; the two raw chunks concatenate
// into one continuous System.Collections namespace.
R"LDP3(
        // LIFO stack backed by a doubling array (spec 34.1).
        public class Stack<T> {
            private mutable T[] data;
            private mutable int count;
            public constructor Stack() { this.data = new T[4](); this.count = 0; }
            public method push(T item) returns void {
                if (this.count >= this.data.length()) {
                    mutable T[] bigger = new T[this.data.length() * 2]();
                    for (mutable int i = 0; i < this.count; i++) { bigger[i] = this.data[i]; }
                    delete this.data;
                    this.data = bigger;
                }
                this.data[this.count] = item;
                this.count = this.count + 1;
            }
            public method pop() returns T {
                this.count = this.count - 1;
                return this.data[this.count];
            }
            public method peek() returns T { return this.data[this.count - 1]; }
            public method toArray() returns T[] {  // bottom-to-top (insertion order)
                mutable T[] out = new T[this.count]();
                for (mutable int i = 0; i < this.count; i++) { out[i] = this.data[i]; }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // FIFO queue backed by a doubling ring buffer (spec 34.1).
        public class Queue<T> {
            private mutable T[] data;
            private mutable int head;
            private mutable int count;
            public constructor Queue() { this.data = new T[4](); this.head = 0; this.count = 0; }
            public method enqueue(T item) returns void {
                if (this.count >= this.data.length()) {
                    mutable T[] bigger = new T[this.data.length() * 2]();
                    for (mutable int i = 0; i < this.count; i++) {
                        bigger[i] = this.data[(this.head + i) % this.data.length()];
                    }
                    delete this.data;
                    this.data = bigger;
                    this.head = 0;
                }
                this.data[(this.head + this.count) % this.data.length()] = item;
                this.count = this.count + 1;
            }
            public method dequeue() returns T {
                T v = this.data[this.head];
                this.head = (this.head + 1) % this.data.length();
                this.count = this.count - 1;
                return v;
            }
            public method peek() returns T { return this.data[this.head]; }
            public method toArray() returns T[] {  // front-to-back
                mutable T[] out = new T[this.count]();
                for (mutable int i = 0; i < this.count; i++) {
                    out[i] = this.data[(this.head + i) % this.data.length()];
                }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // Double-ended queue backed by a doubling ring buffer (spec 34.1).
        public class Deque<T> {
            private mutable T[] data;
            private mutable int head;
            private mutable int count;
            public constructor Deque() { this.data = new T[4](); this.head = 0; this.count = 0; }
            private method grow() returns void {
                if (this.count < this.data.length()) { return; }
                mutable T[] bigger = new T[this.data.length() * 2]();
                for (mutable int i = 0; i < this.count; i++) {
                    bigger[i] = this.data[(this.head + i) % this.data.length()];
                }
                delete this.data;
                this.data = bigger;
                this.head = 0;
            }
            public method addLast(T item) returns void {
                this.grow();
                this.data[(this.head + this.count) % this.data.length()] = item;
                this.count = this.count + 1;
            }
            public method addFirst(T item) returns void {
                this.grow();
                this.head = (this.head + this.data.length() - 1) % this.data.length();
                this.data[this.head] = item;
                this.count = this.count + 1;
            }
            public method removeFirst() returns T {
                T v = this.data[this.head];
                this.head = (this.head + 1) % this.data.length();
                this.count = this.count - 1;
                return v;
            }
            public method removeLast() returns T {
                this.count = this.count - 1;
                return this.data[(this.head + this.count) % this.data.length()];
            }
            public method toArray() returns T[] {  // front-to-back
                mutable T[] out = new T[this.count]();
                for (mutable int i = 0; i < this.count; i++) {
                    out[i] = this.data[(this.head + i) % this.data.length()];
                }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // Singly-linked list node (helper for LinkedList).
        public class LinkedNode<T> {
            public mutable T value;
            public mutable nullable LinkedNode<T>* next;
            public constructor LinkedNode(T v) { this.value = v; this.next = null; }
        }
        // Linked list (spec 34.1): O(1) append + O(1) head removal, with self-referential generic
        // pointer nodes (LinkedNode<T> holds a LinkedNode<T>* next).
        public class LinkedList<T> {
            private mutable nullable LinkedNode<T>* head;
            private mutable nullable LinkedNode<T>* tail;
            private mutable int count;
            public constructor LinkedList() { this.head = null; this.tail = null; this.count = 0; }
            public method add(T item) returns void {
                LinkedNode<T>* node = new LinkedNode<T>(item) on heap;
                if (this.tail == null) { this.head = node; this.tail = node; }
                else { this.tail.next = node; this.tail = node; }
                this.count = this.count + 1;
            }
            public method get(int i) returns T {
                mutable nullable LinkedNode<T>* cur = this.head;
                for (mutable int j = 0; j < i; j++) { cur = cur.next; }
                return cur.value;
            }
            public method removeFirst() returns T {
                nullable LinkedNode<T>* node = this.head;
                T v = node.value;
                this.head = node.next;
                if (this.head == null) { this.tail = null; }
                delete node;
                this.count = this.count - 1;
                return v;
            }
            public method toArray() returns T[] {  // head-to-tail
                mutable T[] out = new T[this.count]();
                mutable nullable LinkedNode<T>* cur = this.head;
                for (mutable int i = 0; i < this.count; i++) { out[i] = cur.value; cur = cur.next; }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
)LDP3"
// (split: MSVC caps a single string literal ~16KB; adjacent literals concatenate.)
R"LDP3(
        // Keys of HashMap/HashSet implement Hashable<T>; keys of TreeMap/TreeSet implement
        // Comparable<T> (spec 34). The primitive types (int family, String) satisfy these via
        // compiler builtins, so they can be used as keys without boxing.
        public interface Hashable<T> {
            method hash() returns long;
            method equalsKey(T other) returns boolean;
        }
        public interface Comparable<T> {
            method compareTo(T other) returns int;
        }
        // Hash map with open addressing (linear probing); capacity is a power of two, load factor
        // 0.75 (spec 34.1). Keys must be Hashable. get() on an absent key returns a zero/null value;
        // probe with containsKey() first.
        public class HashMap<K, V> {
            private mutable K[] keys;
            private mutable V[] values;
            private mutable boolean[] used;
            private mutable int count;
            private mutable int cap;
            public constructor HashMap() {
                this.cap = 8;
                this.keys = new K[8]();
                this.values = new V[8]();
                this.used = new boolean[8]();
                this.count = 0;
            }
            private method slotFor(K key) returns int {
                int mask = this.cap - 1;
                mutable int i = cast<int>(key.hash()) & mask;
                while (this.used[i]) {
                    if (this.keys[i].equalsKey(key)) { return i; }
                    i = (i + 1) & mask;
                }
                return i;
            }
            private method grow() returns void {
                int oldCap = this.cap;
                mutable K[] oldK = this.keys;
                mutable V[] oldV = this.values;
                mutable boolean[] oldU = this.used;
                this.cap = oldCap * 2;
                this.keys = new K[this.cap]();
                this.values = new V[this.cap]();
                this.used = new boolean[this.cap]();
                this.count = 0;
                for (mutable int j = 0; j < oldCap; j++) {
                    if (oldU[j]) { this.put(oldK[j], oldV[j]); }
                }
                delete oldK;
                delete oldV;
                delete oldU;
            }
            public method put(K key, V value) returns void {
                if ((this.count + 1) * 4 >= this.cap * 3) { this.grow(); }
                int i = this.slotFor(key);
                if (!this.used[i]) { this.used[i] = true; this.count = this.count + 1; }
                this.keys[i] = key;
                this.values[i] = value;
            }
            public method get(K key) returns V {
                return this.values[this.slotFor(key)];
            }
            public method containsKey(K key) returns boolean {
                return this.used[this.slotFor(key)];
            }
            // Single-lookup helpers so callers avoid re-hashing the key. getOrDefault reads with one probe;
            // merge inserts `value` or replaces the existing value with combine(old, value) -- the efficient
            // way to tally (counts.merge(k, 1, add)) instead of containsKey + get + put (three probes).
            public method getOrDefault(K key, V defaultValue) returns V {
                int i = this.slotFor(key);
                if (this.used[i]) { return this.values[i]; }
                return defaultValue;
            }
            public method merge(K key, V value, function<V, V, V> combine) returns void {
                if ((this.count + 1) * 4 >= this.cap * 3) { this.grow(); }
                int i = this.slotFor(key);
                if (!this.used[i]) {
                    this.used[i] = true;
                    this.count = this.count + 1;
                    this.keys[i] = key;
                    this.values[i] = value;
                } else {
                    this.values[i] = combine(this.values[i], value);
                }
            }
            public method remove(K key) returns boolean {  // backward-shift: reinsert the cluster after i
                int i = this.slotFor(key);
                if (!this.used[i]) { return false; }
                int mask = this.cap - 1;
                this.used[i] = false;
                this.count = this.count - 1;
                mutable int j = (i + 1) & mask;
                while (this.used[j]) {
                    mutable K rk = this.keys[j];
                    mutable V rv = this.values[j];
                    this.used[j] = false;
                    this.count = this.count - 1;
                    this.put(rk, rv);
                    j = (j + 1) & mask;
                }
                return true;
            }
            public method keyArray() returns K[] {  // keys (arbitrary order); field is named `keys`
                mutable K[] out = new K[this.count]();
                mutable int j = 0;
                for (mutable int i = 0; i < this.cap; i++) {
                    if (this.used[i]) { out[j] = this.keys[i]; j = j + 1; }
                }
                return out;
            }
            public method valueArray() returns V[] {  // values (arbitrary order)
                mutable V[] out = new V[this.count]();
                mutable int j = 0;
                for (mutable int i = 0; i < this.cap; i++) {
                    if (this.used[i]) { out[j] = this.values[i]; j = j + 1; }
                }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // Hash set with open addressing (spec 34.1). Elements must be Hashable.
        public class HashSet<T> {
            private mutable T[] elems;
            private mutable boolean[] used;
            private mutable int count;
            private mutable int cap;
            public constructor HashSet() {
                this.cap = 8;
                this.elems = new T[8]();
                this.used = new boolean[8]();
                this.count = 0;
            }
            private method slotFor(T value) returns int {
                int mask = this.cap - 1;
                mutable int i = cast<int>(value.hash()) & mask;
                while (this.used[i]) {
                    if (this.elems[i].equalsKey(value)) { return i; }
                    i = (i + 1) & mask;
                }
                return i;
            }
            private method grow() returns void {
                int oldCap = this.cap;
                mutable T[] oldE = this.elems;
                mutable boolean[] oldU = this.used;
                this.cap = oldCap * 2;
                this.elems = new T[this.cap]();
                this.used = new boolean[this.cap]();
                this.count = 0;
                for (mutable int j = 0; j < oldCap; j++) {
                    if (oldU[j]) { this.add(oldE[j]); }
                }
                delete oldE;
                delete oldU;
            }
            public method add(T value) returns void {
                if ((this.count + 1) * 4 >= this.cap * 3) { this.grow(); }
                int i = this.slotFor(value);
                if (!this.used[i]) { this.used[i] = true; this.elems[i] = value; this.count = this.count + 1; }
            }
            public method contains(T value) returns boolean {
                return this.used[this.slotFor(value)];
            }
            public method remove(T value) returns boolean {  // backward-shift deletion
                int i = this.slotFor(value);
                if (!this.used[i]) { return false; }
                int mask = this.cap - 1;
                this.used[i] = false;
                this.count = this.count - 1;
                mutable int j = (i + 1) & mask;
                while (this.used[j]) {
                    mutable T re = this.elems[j];
                    this.used[j] = false;
                    this.count = this.count - 1;
                    this.add(re);
                    j = (j + 1) & mask;
                }
                return true;
            }
            public method toArray() returns T[] {  // elements (arbitrary order)
                mutable T[] out = new T[this.count]();
                mutable int j = 0;
                for (mutable int i = 0; i < this.cap; i++) {
                    if (this.used[i]) { out[j] = this.elems[i]; j = j + 1; }
                }
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // Binary-search-tree node for TreeMap (self-referential generic).
        public class TreeNode<K, V> {
            public mutable K key;
            public mutable V value;
            public mutable nullable TreeNode<K, V>* left;
            public mutable nullable TreeNode<K, V>* right;
            public mutable int height;  // AVL subtree height, for O(log n) balancing
            public constructor TreeNode(K k, V v) {
                this.key = k; this.value = v; this.left = null; this.right = null; this.height = 1;
            }
        }
        // Ordered map backed by an (unbalanced) binary search tree (spec 34.1). Keys are Comparable.
        // get() on an absent key returns a zero/null value; probe with containsKey() first.
        public class TreeMap<K, V> {
            private mutable nullable TreeNode<K, V>* root;
            private mutable int count;
            public constructor TreeMap() { this.root = null; this.count = 0; }
            public method put(K key, V value) returns void {
                this.root = this.insertNode(this.root, key, value);
            }
            // AVL balancing keeps height O(log n) so ordered/monotonic keys can't degenerate the tree into
            // a list (which made insert O(n^2)). Nodes are typed nullable; callers only dereference on the
            // non-null path, so the null branch is never taken where a deref would trap.
            private method nodeHeight(nullable TreeNode<K, V>* n) returns int {
                if (n == null) { return 0; }
                return n.height;
            }
            private method fixHeight(nullable TreeNode<K, V>* n) returns void {
                int lh = this.nodeHeight(n.left);
                int rh = this.nodeHeight(n.right);
                if (lh > rh) { n.height = lh + 1; } else { n.height = rh + 1; }
            }
            private method balance(nullable TreeNode<K, V>* n) returns int {
                return this.nodeHeight(n.left) - this.nodeHeight(n.right);
            }
            private method rotateRight(nullable TreeNode<K, V>* y) returns nullable TreeNode<K, V>* {
                nullable TreeNode<K, V>* x = y.left;
                y.left = x.right;
                x.right = y;
                this.fixHeight(y);
                this.fixHeight(x);
                return x;
            }
            private method rotateLeft(nullable TreeNode<K, V>* x) returns nullable TreeNode<K, V>* {
                nullable TreeNode<K, V>* y = x.right;
                x.right = y.left;
                y.left = x;
                this.fixHeight(x);
                this.fixHeight(y);
                return y;
            }
            private method insertNode(nullable TreeNode<K, V>* node, K key, V value) returns nullable TreeNode<K, V>* {
                if (node == null) {
                    this.count = this.count + 1;
                    return new TreeNode<K, V>(key, value) on heap;
                }
                int c = key.compareTo(node.key);
                if (c == 0) { node.value = value; return node; }
                if (c < 0) {
                    node.left = this.insertNode(node.left, key, value);
                } else {
                    node.right = this.insertNode(node.right, key, value);
                }
                this.fixHeight(node);
                int bf = this.balance(node);
                if (bf > 1) {
                    if (this.balance(node.left) < 0) { node.left = this.rotateLeft(node.left); }
                    return this.rotateRight(node);
                }
                if (bf < 0 - 1) {
                    if (this.balance(node.right) > 0) { node.right = this.rotateRight(node.right); }
                    return this.rotateLeft(node);
                }
                return node;
            }
            private method find(K key) returns nullable TreeNode<K, V>* {
                mutable nullable TreeNode<K, V>* cur = this.root;
                while (cur != null) {
                    int c = key.compareTo(cur.key);
                    if (c == 0) { return cur; }
                    if (c < 0) { cur = cur.left; } else { cur = cur.right; }
                }
                return null;
            }
            public method get(K key) returns V {
                nullable TreeNode<K, V>* n = this.find(key);
                if (n != null) { return n.value; }
                mutable V[] zero = new V[1]();  // zero/null default for an absent key
                V z = zero[0];
                delete zero;
                return z;
            }
            public method containsKey(K key) returns boolean { return this.find(key) != null; }
            private method fillKeys(nullable TreeNode<K, V>* node, K[] out, int idx) returns int {
                if (node == null) { return idx; }
                mutable int i = this.fillKeys(node.left, out, idx);
                out[i] = node.key;
                i = i + 1;
                return this.fillKeys(node.right, out, i);
            }
            private method fillValues(nullable TreeNode<K, V>* node, V[] out, int idx) returns int {
                if (node == null) { return idx; }
                mutable int i = this.fillValues(node.left, out, idx);
                out[i] = node.value;
                i = i + 1;
                return this.fillValues(node.right, out, i);
            }
            public method keyArray() returns K[] {  // sorted (in-order)
                mutable K[] out = new K[this.count]();
                this.fillKeys(this.root, out, 0);
                return out;
            }
            public method valueArray() returns V[] {  // by key order
                mutable V[] out = new V[this.count]();
                this.fillValues(this.root, out, 0);
                return out;
            }
)LDP3"
// Split only for the MSVC literal-size limit; still inside TreeMap in System.Collections.
R"LDP3(
            private method zeroKey() returns K {  // zero/null default when no navigable key exists
                mutable K[] zero = new K[1]();
                K z = zero[0];
                delete zero;
                return z;
            }
            public method firstKey() returns K {  // smallest key (leftmost)
                if (this.root == null) { return this.zeroKey(); }
                mutable nullable TreeNode<K, V>* cur = this.root;
                while (cur.left != null) { cur = cur.left; }
                return cur.key;
            }
            public method lastKey() returns K {  // largest key (rightmost)
                if (this.root == null) { return this.zeroKey(); }
                mutable nullable TreeNode<K, V>* cur = this.root;
                while (cur.right != null) { cur = cur.right; }
                return cur.key;
            }
            public method floorKey(K key) returns K {  // largest key <= given
                mutable nullable TreeNode<K, V>* cur = this.root;
                mutable nullable TreeNode<K, V>* best = null;
                while (cur != null) {
                    int c = key.compareTo(cur.key);
                    if (c == 0) { return cur.key; }
                    if (c < 0) { cur = cur.left; } else { best = cur; cur = cur.right; }
                }
                if (best == null) { return this.zeroKey(); }
                return best.key;
            }
            public method ceilingKey(K key) returns K {  // smallest key >= given
                mutable nullable TreeNode<K, V>* cur = this.root;
                mutable nullable TreeNode<K, V>* best = null;
                while (cur != null) {
                    int c = key.compareTo(cur.key);
                    if (c == 0) { return cur.key; }
                    if (c > 0) { cur = cur.right; } else { best = cur; cur = cur.left; }
                }
                if (best == null) { return this.zeroKey(); }
                return best.key;
            }
            public method higherKey(K key) returns K {  // smallest key > given
                mutable nullable TreeNode<K, V>* cur = this.root;
                mutable nullable TreeNode<K, V>* best = null;
                while (cur != null) {
                    int c = key.compareTo(cur.key);
                    if (c < 0) { best = cur; cur = cur.left; } else { cur = cur.right; }
                }
                if (best == null) { return this.zeroKey(); }
                return best.key;
            }
            public method lowerKey(K key) returns K {  // largest key < given
                mutable nullable TreeNode<K, V>* cur = this.root;
                mutable nullable TreeNode<K, V>* best = null;
                while (cur != null) {
                    int c = key.compareTo(cur.key);
                    if (c > 0) { best = cur; cur = cur.right; } else { cur = cur.left; }
                }
                if (best == null) { return this.zeroKey(); }
                return best.key;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // BST node for TreeSet (self-referential generic).
        public class TreeSetNode<T> {
            public mutable T value;
            public mutable nullable TreeSetNode<T>* left;
            public mutable nullable TreeSetNode<T>* right;
            public mutable int height;  // AVL subtree height
            public constructor TreeSetNode(T v) { this.value = v; this.left = null; this.right = null; this.height = 1; }
        }
        // Ordered set backed by an (unbalanced) binary search tree (spec 34.1). Elements Comparable.
        public class TreeSet<T> {
            private mutable nullable TreeSetNode<T>* root;
            private mutable int count;
            public constructor TreeSet() { this.root = null; this.count = 0; }
            public method add(T value) returns void {
                this.root = this.insertNode(this.root, value);
            }
            // AVL balancing (see TreeMap) so ordered inserts stay O(log n) instead of degenerating to O(n^2).
            private method nodeHeight(nullable TreeSetNode<T>* n) returns int {
                if (n == null) { return 0; }
                return n.height;
            }
            private method fixHeight(nullable TreeSetNode<T>* n) returns void {
                int lh = this.nodeHeight(n.left);
                int rh = this.nodeHeight(n.right);
                if (lh > rh) { n.height = lh + 1; } else { n.height = rh + 1; }
            }
            private method balance(nullable TreeSetNode<T>* n) returns int {
                return this.nodeHeight(n.left) - this.nodeHeight(n.right);
            }
            private method rotateRight(nullable TreeSetNode<T>* y) returns nullable TreeSetNode<T>* {
                nullable TreeSetNode<T>* x = y.left;
                y.left = x.right;
                x.right = y;
                this.fixHeight(y);
                this.fixHeight(x);
                return x;
            }
            private method rotateLeft(nullable TreeSetNode<T>* x) returns nullable TreeSetNode<T>* {
                nullable TreeSetNode<T>* y = x.right;
                x.right = y.left;
                y.left = x;
                this.fixHeight(x);
                this.fixHeight(y);
                return y;
            }
            private method insertNode(nullable TreeSetNode<T>* node, T value) returns nullable TreeSetNode<T>* {
                if (node == null) {
                    this.count = this.count + 1;
                    return new TreeSetNode<T>(value) on heap;
                }
                int c = value.compareTo(node.value);
                if (c == 0) { return node; }
                if (c < 0) {
                    node.left = this.insertNode(node.left, value);
                } else {
                    node.right = this.insertNode(node.right, value);
                }
                this.fixHeight(node);
                int bf = this.balance(node);
                if (bf > 1) {
                    if (this.balance(node.left) < 0) { node.left = this.rotateLeft(node.left); }
                    return this.rotateRight(node);
                }
                if (bf < 0 - 1) {
                    if (this.balance(node.right) > 0) { node.right = this.rotateRight(node.right); }
                    return this.rotateLeft(node);
                }
                return node;
            }
            public method contains(T value) returns boolean {
                mutable nullable TreeSetNode<T>* cur = this.root;
                while (cur != null) {
                    int c = value.compareTo(cur.value);
                    if (c == 0) { return true; }
                    if (c < 0) { cur = cur.left; } else { cur = cur.right; }
                }
                return false;
            }
            private method fill(nullable TreeSetNode<T>* node, T[] out, int idx) returns int {
                if (node == null) { return idx; }
                mutable int i = this.fill(node.left, out, idx);
                out[i] = node.value;
                i = i + 1;
                return this.fill(node.right, out, i);
            }
            public method toArray() returns T[] {  // sorted (in-order)
                mutable T[] out = new T[this.count]();
                this.fill(this.root, out, 0);
                return out;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
)LDP3"
// (split 1b: keep the collections literal under MSVC's ~16KB cap.)
R"LDP3(
        // Binary min-heap priority queue (spec 34.1): the smallest element (by compareTo) is served
        // first. Backed by a doubling array; add and poll are O(log n).
        public class PriorityQueue<T> {
            private mutable T[] heap;
            private mutable int count;
            public constructor PriorityQueue() { this.heap = new T[8](); this.count = 0; }
            public method add(T item) returns void {
                if (this.count >= this.heap.length()) {
                    mutable T[] bigger = new T[this.heap.length() * 2]();
                    for (mutable int j = 0; j < this.count; j++) { bigger[j] = this.heap[j]; }
                    delete this.heap;
                    this.heap = bigger;
                }
                this.heap[this.count] = item;
                mutable int i = this.count;
                this.count = this.count + 1;
                while (i > 0) {  // sift up
                    int parent = (i - 1) / 2;
                    if (this.heap[i].compareTo(this.heap[parent]) >= 0) { break; }
                    T tmp = this.heap[i];
                    this.heap[i] = this.heap[parent];
                    this.heap[parent] = tmp;
                    i = parent;
                }
            }
            public method peek() returns T { return this.heap[0]; }
            public method poll() returns T {
                T top = this.heap[0];
                this.count = this.count - 1;
                this.heap[0] = this.heap[this.count];
                mutable int i = 0;
                while (true) {  // sift down
                    int l = 2 * i + 1;
                    int r = 2 * i + 2;
                    mutable int smallest = i;
                    if (l < this.count && this.heap[l].compareTo(this.heap[smallest]) < 0) {
                        smallest = l;
                    }
                    if (r < this.count && this.heap[r].compareTo(this.heap[smallest]) < 0) {
                        smallest = r;
                    }
                    if (smallest == i) { break; }
                    T tmp = this.heap[i];
                    this.heap[i] = this.heap[smallest];
                    this.heap[smallest] = tmp;
                    i = smallest;
                }
                return top;
            }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // A compact set of bit flags packed into 32-bit words (spec 34.1): set/clear/flip/get a bit by
        // index, count the ones. Cheaper than a HashSet<int> for dense indices in a known range.
        public class Bitset {
            private mutable int[] words;
            private mutable int nbits;
            public constructor Bitset(int size) {
                this.nbits = size;
                this.words = new int[(size + 31) / 32]();
            }
            public method set(int i) returns void {
                this.words[i >> 5] = this.words[i >> 5] | (1 << (i & 31));
                return;
            }
            public method clear(int i) returns void {
                this.words[i >> 5] = this.words[i >> 5] & (~(1 << (i & 31)));
                return;
            }
            public method flip(int i) returns void {
                this.words[i >> 5] = this.words[i >> 5] ^ (1 << (i & 31));
                return;
            }
            public method get(int i) returns boolean {
                return (this.words[i >> 5] & (1 << (i & 31))) != 0;
            }
            public method count() returns int {
                mutable int total = 0;
                for (mutable int w = 0; w < this.words.length(); w++) {
                    mutable int x = this.words[w];
                    for (mutable int b = 0; b < 32; b++) {
                        if ((x & (1 << b)) != 0) { total = total + 1; }
                    }
                }
                return total;
            }
            public method size() returns int { return this.nbits; }
        }
        // Counts how many times each value is added (spec 34.1): a multiset over a HashMap. add bumps a
        // value's tally, count reads it (0 if absent), distinct is the number of values seen, total the sum
        // of all tallies. The element type must be Hashable, like any HashMap key. (Named Multiset rather
        // than Counter so it does not shadow a user class commonly called Counter.)
        public class Multiset<T> {
            private mutable HashMap<T, int> counts;
            public constructor Multiset() {
                this.counts = new HashMap<T, int>() on heap;
            }
            public method add(T item) returns void {
                if (this.counts.containsKey(item)) {
                    this.counts.put(item, this.counts.get(item) + 1);
                } else {
                    this.counts.put(item, 1);
                }
                return;
            }
            public method count(T item) returns int {
                if (this.counts.containsKey(item)) { return this.counts.get(item); }
                return 0;
            }
            public method distinct() returns int {
                return this.counts.size();
            }
            public method total() returns int {
                mutable int[] tallies = this.counts.valueArray();
                mutable int sum = 0;
                for (mutable int i = 0; i < tallies.length(); i++) { sum = sum + tallies[i]; }
                return sum;
            }
            public method keys() returns T[] {
                return this.counts.keyArray();
            }
        }
        // A fixed-capacity circular buffer (spec 34.1): push appends and, once full, overwrites the oldest
        // element; pop and peek read from the oldest end. Indices wrap with modulo, so there is no shifting.
        public class RingBuffer<T> {
            private mutable T[] buf;
            private mutable int head;
            private mutable int count;
            private mutable int cap;
            public constructor RingBuffer(int capacity) {
                this.cap = capacity;
                this.buf = new T[capacity]();
                this.head = 0;
                this.count = 0;
            }
            public method push(T item) returns void {
                int tail = (this.head + this.count) % this.cap;
                this.buf[tail] = item;
                if (this.count == this.cap) { this.head = (this.head + 1) % this.cap; }
                else { this.count = this.count + 1; }
                return;
            }
            public method pop() returns T {
                T v = this.buf[this.head];
                this.head = (this.head + 1) % this.cap;
                this.count = this.count - 1;
                return v;
            }
            public method peek() returns T { return this.buf[this.head]; }
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
            public method isFull() returns boolean { return this.count == this.cap; }
            public method capacity() returns int { return this.cap; }
        }
        // A map that remembers insertion order (spec 34.1): a HashMap for lookup plus a list of keys in the
        // order they were first added. put updates in place without reordering; keysInOrder walks them as
        // inserted, which a plain HashMap does not promise.
        public class LinkedHashMap<K, V> {
            private mutable HashMap<K, V> map;
            private mutable ArrayList<K> order;
            public constructor LinkedHashMap() {
                this.map = new HashMap<K, V>() on heap;
                this.order = new ArrayList<K>() on heap;
            }
            public method put(K key, V value) returns void {
                if (!this.map.containsKey(key)) { this.order.add(key); }
                this.map.put(key, value);
                return;
            }
            public method get(K key) returns V { return this.map.get(key); }
            public method containsKey(K key) returns boolean { return this.map.containsKey(key); }
            public method size() returns int { return this.map.size(); }
            public method isEmpty() returns boolean { return this.map.size() == 0; }
            public method keysInOrder() returns ArrayList<K> { return this.order; }
        }
        // Builds lists of integers over a range (spec 34.1): upTo(n) is 0..n-1, between(a,b) is a..b-1, and
        // step(a,b,s) walks a..b in increments of s. A convenience for counting loops expressed as data.
        public class Range {
            // A first-class range value (spec 7.5): `start..end`, `start..=end`, and `step`. Built by the
            // range operator (e.g. `var r = 0..10 step 2;`), iterable with foreach, and queryable.
            public int start;
            public int end;
            public int stride;   // the step increment (`step` is a reserved keyword)
            public boolean inclusive;
            public constructor Range(int start, int end, int stride, boolean inclusive) {
                this.start = start;
                this.end = end;
                this.stride = stride;
                this.inclusive = inclusive;
            }
            // Whether `i` is still within the range, honoring the step direction and inclusivity.
            private method inRange(int i) returns boolean {
                if (this.stride >= 0) {
                    if (this.inclusive) { return i <= this.end; }
                    return i < this.end;
                }
                if (this.inclusive) { return i >= this.end; }
                return i > this.end;
            }
            public method size() returns int {
                mutable int n = 0;
                mutable int i = this.start;
                while (this.inRange(i)) { n = n + 1; i = i + this.stride; }
                return n;
            }
            public method contains(int v) returns boolean {
                mutable int i = this.start;
                while (this.inRange(i)) { if (i == v) { return true; } i = i + this.stride; }
                return false;
            }
            public method toArray() returns int[] {
                mutable int n = this.size();
                mutable int[] a = new int[n]();
                mutable int idx = 0;
                mutable int i = this.start;
                while (this.inRange(i)) { a[idx] = i; idx = idx + 1; i = i + this.stride; }
                return a;
            }
            public static method upTo(int n) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                for (mutable int i = 0; i < n; i++) { out.add(i); }
                return out;
            }
            public static method between(int start, int end) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                for (mutable int i = start; i < end; i++) { out.add(i); }
                return out;
            }
            public static method stepBy(int start, int end, int by) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                if (by <= 0) { return out; }
                for (mutable int i = start; i < end; i = i + by) { out.add(i); }
                return out;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A prefix tree over lowercase-letter words (spec 34.1), stored as an arena: every node's 26 child
        // links and its end-of-word flag live in flat arrays indexed by node number, so there are no node
        // pointers. A link of 0 means "none" (node 0 is the root, which is never a child).
        public class Trie {
            private mutable int[] next;
            private mutable boolean[] isWord;
            private mutable int nodes;
            private mutable int cap;
            public constructor Trie() {
                this.cap = 8;
                this.next = new int[8 * 26]();
                this.isWord = new boolean[8]();
                this.nodes = 1;
            }
            private method ensure() returns void {
                if (this.nodes < this.cap) { return; }
                int nc = this.cap * 2;
                mutable int[] nn = new int[nc * 26]();
                mutable boolean[] nw = new boolean[nc]();
                for (mutable int i = 0; i < this.cap * 26; i++) { nn[i] = this.next[i]; }
                for (mutable int i = 0; i < this.cap; i++) { nw[i] = this.isWord[i]; }
                this.next = nn;
                this.isWord = nw;
                this.cap = nc;
                return;
            }
            public method insert(String word) returns void {
                mutable int node = 0;
                for (mutable int i = 0; i < word.length(); i++) {
                    int c = cast<int>(word.charAt(i)) - cast<int>('a');
                    if (this.next[node * 26 + c] == 0) {
                        this.ensure();
                        this.next[node * 26 + c] = this.nodes;
                        this.nodes = this.nodes + 1;
                    }
                    node = this.next[node * 26 + c];
                }
                this.isWord[node] = true;
                return;
            }
            public method contains(String word) returns boolean {
                mutable int node = 0;
                for (mutable int i = 0; i < word.length(); i++) {
                    int c = cast<int>(word.charAt(i)) - cast<int>('a');
                    if (this.next[node * 26 + c] == 0) { return false; }
                    node = this.next[node * 26 + c];
                }
                return this.isWord[node];
            }
            public method startsWith(String prefix) returns boolean {
                mutable int node = 0;
                for (mutable int i = 0; i < prefix.length(); i++) {
                    int c = cast<int>(prefix.charAt(i)) - cast<int>('a');
                    if (this.next[node * 26 + c] == 0) { return false; }
                    node = this.next[node * 26 + c];
                }
                return true;
            }
        }
        // An undirected graph on a fixed vertex set (spec 34.1), edges kept as two parallel lists so no
        // per-node pointers are needed. distance is the shortest hop count between two vertices by BFS, or
        // -1 if they are not connected.
        public class Graph {
            private mutable int n;
            private mutable ArrayList<int> eu;
            private mutable ArrayList<int> ev;
            public constructor Graph(int vertices) {
                this.n = vertices;
                this.eu = new ArrayList<int>() on heap;
                this.ev = new ArrayList<int>() on heap;
            }
            public method addEdge(int u, int v) returns void {
                this.eu.add(u);
                this.ev.add(v);
                return;
            }
            public method distance(int src, int dst) returns int {
                mutable int[] dist = new int[this.n]();
                for (mutable int i = 0; i < this.n; i++) { dist[i] = 0 - 1; }
                mutable Queue<int> q = new Queue<int>() on heap;
                dist[src] = 0;
                q.enqueue(src);
                while (!q.isEmpty()) {
                    int u = q.dequeue();
                    for (mutable int i = 0; i < this.eu.size(); i++) {
                        mutable int a = 0 - 1;
                        if (this.eu.get(i) == u) { a = this.ev.get(i); }
                        else { if (this.ev.get(i) == u) { a = this.eu.get(i); } }
                        if (a >= 0 && dist[a] < 0) {
                            dist[a] = dist[u] + 1;
                            q.enqueue(a);
                        }
                    }
                }
                return dist[dst];
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A generational arena (spec 17): insert returns a stable handle that stays valid until removed,
        // even as the backing storage grows or other slots are reused. A removed slot bumps its generation,
        // so an old handle to it no longer matches and containsHandle reports it stale. A handle packs the
        // slot index and generation into one int.
        public class SlotMap<T> {
            private mutable T[] values;
            private mutable int[] gens;
            private mutable boolean[] occ;
            private mutable int[] freeList;
            private mutable int freeCount;
            private mutable int cap;
            private mutable int len;
            public constructor SlotMap() {
                this.cap = 4;
                this.values = new T[4]();
                this.gens = new int[4]();
                this.occ = new boolean[4]();
                this.freeList = new int[4]();
                this.freeCount = 4;
                this.len = 0;
                for (mutable int i = 0; i < 4; i++) { this.freeList[i] = i; }
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable T[] nv = new T[nc]();
                mutable int[] ng = new int[nc]();
                mutable boolean[] no = new boolean[nc]();
                mutable int[] nf = new int[nc]();
                for (mutable int i = 0; i < this.cap; i++) {
                    nv[i] = this.values[i];
                    ng[i] = this.gens[i];
                    no[i] = this.occ[i];
                }
                mutable int fc = 0;
                for (mutable int i = this.cap; i < nc; i++) {
                    nf[fc] = i;
                    fc = fc + 1;
                }
                this.values = nv;
                this.gens = ng;
                this.occ = no;
                this.freeList = nf;
                this.freeCount = fc;
                this.cap = nc;
                return;
            }
            public method insert(T value) returns int {
                if (this.freeCount == 0) { this.grow(); }
                int slot = this.freeList[this.freeCount - 1];
                this.freeCount = this.freeCount - 1;
                this.values[slot] = value;
                this.occ[slot] = true;
                this.len = this.len + 1;
                return slot * 1048576 + this.gens[slot];
            }
            public method containsHandle(int h) returns boolean {
                int slot = h / 1048576;
                int gen = h % 1048576;
                return slot < this.cap && this.occ[slot] && this.gens[slot] == gen;
            }
            public method get(int h) returns T { return this.values[h / 1048576]; }
            public method remove(int h) returns void {
                if (this.containsHandle(h)) {
                    int slot = h / 1048576;
                    this.occ[slot] = false;
                    this.gens[slot] = this.gens[slot] + 1;
                    this.freeList[this.freeCount] = slot;
                    this.freeCount = this.freeCount + 1;
                    this.len = this.len - 1;
                }
                return;
            }
            public method size() returns int { return this.len; }
        }
        // A binary min-heap of integers (spec 34.1): push and pop keep the smallest element at the top, so
        // repeated pop yields ascending order. Backing array grows as needed.
        public class IntHeap {
            private mutable int[] h;
            private mutable int n;
            private mutable int cap;
            public constructor IntHeap() {
                this.cap = 8;
                this.h = new int[8]();
                this.n = 0;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable int[] nh = new int[nc]();
                for (mutable int i = 0; i < this.n; i++) { nh[i] = this.h[i]; }
                this.h = nh;
                this.cap = nc;
                return;
            }
            public method push(int v) returns void {
                if (this.n == this.cap) { this.grow(); }
                this.h[this.n] = v;
                mutable int i = this.n;
                this.n = this.n + 1;
                while (i > 0 && this.h[(i - 1) / 2] > this.h[i]) {
                    int t = this.h[i];
                    this.h[i] = this.h[(i - 1) / 2];
                    this.h[(i - 1) / 2] = t;
                    i = (i - 1) / 2;
                }
                return;
            }
            public method pop() returns int {
                int top = this.h[0];
                this.n = this.n - 1;
                this.h[0] = this.h[this.n];
                mutable int i = 0;
                while (true) {
                    int l = 2 * i + 1;
                    int r = 2 * i + 2;
                    mutable int sm = i;
                    if (l < this.n && this.h[l] < this.h[sm]) { sm = l; }
                    if (r < this.n && this.h[r] < this.h[sm]) { sm = r; }
                    if (sm == i) { return top; }
                    int t = this.h[i];
                    this.h[i] = this.h[sm];
                    this.h[sm] = t;
                    i = sm;
                }
                return top;
            }
            public method peek() returns int { return this.h[0]; }
            public method size() returns int { return this.n; }
        }
        // Disjoint-set / union-find over a fixed range 0..n-1 (spec 34.1): merge joins two elements' sets,
        // connected tests membership, groups counts the distinct sets. Union by rank with path halving.
        public class UnionFind {
            private mutable int[] parent;
            private mutable int[] rnk;
            private mutable int count;
            public constructor UnionFind(int n) {
                this.parent = new int[n]();
                this.rnk = new int[n]();
                this.count = n;
                for (mutable int i = 0; i < n; i++) { this.parent[i] = i; }
            }
            public method find(int x) returns int {
                mutable int r = x;
                while (this.parent[r] != r) {
                    this.parent[r] = this.parent[this.parent[r]];
                    r = this.parent[r];
                }
                return r;
            }
            public method merge(int a, int b) returns void {
                int ra = this.find(a);
                int rb = this.find(b);
                if (ra == rb) { return; }
                if (this.rnk[ra] < this.rnk[rb]) {
                    this.parent[ra] = rb;
                } else {
                    if (this.rnk[ra] > this.rnk[rb]) {
                        this.parent[rb] = ra;
                    } else {
                        this.parent[rb] = ra;
                        this.rnk[ra] = this.rnk[ra] + 1;
                    }
                }
                this.count = this.count - 1;
                return;
            }
            public method connected(int a, int b) returns boolean { return this.find(a) == this.find(b); }
            public method groups() returns int { return this.count; }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A node in a binary search tree (spec 34.1), linked by scalar nullable pointers to its children
        // (arrays/lists of pointers are not yet supported, but a `nullable T*` link field is). collect does an
        // in-order walk, appending keys in sorted order.
        public class BstNode {
            public mutable int key;
            public mutable nullable BstNode* left;
            public mutable nullable BstNode* right;
            public constructor BstNode(int k) {
                this.key = k;
                this.left = null;
                this.right = null;
            }
            public method collect(ArrayList<int>& out) returns void {  // & : accumulate into the caller's list
                if (this.left != null) { this.left.collect(out); }
                out.add(this.key);
                if (this.right != null) { this.right.collect(out); }
                return;
            }
        }
        // An ordered set of integers backed by an unbalanced binary search tree (spec 34.1): insert ignores
        // duplicates, contains tests membership, and inOrder returns the keys sorted. A genuinely
        // pointer-linked structure (each node points to its children).
        public class Bst {
            private mutable nullable BstNode* root;
            private mutable int count;
            public constructor Bst() {
                this.root = null;
                this.count = 0;
            }
            public method insert(int k) returns void {
                if (this.root == null) {
                    this.root = new BstNode(k) on heap;
                    this.count = this.count + 1;
                    return;
                }
                mutable nullable BstNode* cur = this.root;
                mutable boolean done = false;
                while (!done) {
                    if (k < cur.key) {
                        if (cur.left == null) {
                            cur.left = new BstNode(k) on heap;
                            this.count = this.count + 1;
                            done = true;
                        } else {
                            cur = cur.left;
                        }
                    } else {
                        if (k > cur.key) {
                            if (cur.right == null) {
                                cur.right = new BstNode(k) on heap;
                                this.count = this.count + 1;
                                done = true;
                            } else {
                                cur = cur.right;
                            }
                        } else {
                            done = true;
                        }
                    }
                }
                return;
            }
            public method contains(int k) returns boolean {
                mutable nullable BstNode* cur = this.root;
                while (cur != null) {
                    if (k == cur.key) { return true; }
                    if (k < cur.key) { cur = cur.left; } else { cur = cur.right; }
                }
                return false;
            }
            public method size() returns int { return this.count; }
            public method inOrder() returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                if (this.root != null) { this.root.collect(out); }
                return out;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A sorted set of ints (spec 34.1) on a growable sorted array with binary search: add (deduping),
        // contains, navigable floor (largest <= v) and ceiling (smallest >= v), plus order statistics rank
        // (count of elements < v) and kth (the i-th smallest). floor/ceiling return int min/max when absent.
        public class SortedIntSet {
            private mutable int[] data;
            private mutable int count;
            public constructor SortedIntSet() {
                this.data = new int[8]();
                this.count = 0;
            }
            private method lowerBound(int v) returns int {
                mutable int lo = 0;
                mutable int hi = this.count;
                while (lo < hi) {
                    int mid = (lo + hi) / 2;
                    if (this.data[mid] < v) { lo = mid + 1; } else { hi = mid; }
                }
                return lo;
            }
            private method ensure(int need) returns void {
                if (need <= this.data.length()) { return; }
                mutable int[] bigger = new int[this.data.length() * 2]();
                for (mutable int i = 0; i < this.count; i++) { bigger[i] = this.data[i]; }
                this.data = bigger;
                return;
            }
            public method add(int v) returns void {
                int p = this.lowerBound(v);
                if (p < this.count && this.data[p] == v) { return; }
                this.ensure(this.count + 1);
                for (mutable int i = this.count; i > p; i = i - 1) { this.data[i] = this.data[i - 1]; }
                this.data[p] = v;
                this.count = this.count + 1;
                return;
            }
            public method contains(int v) returns boolean {
                int p = this.lowerBound(v);
                return p < this.count && this.data[p] == v;
            }
            public method rank(int v) returns int { return this.lowerBound(v); }
            public method floor(int v) returns int {
                int p = this.lowerBound(v);
                if (p < this.count && this.data[p] == v) { return v; }
                if (p == 0) { return -2147483648; }
                return this.data[p - 1];
            }
            public method ceiling(int v) returns int {
                int p = this.lowerBound(v);
                if (p == this.count) { return 2147483647; }
                return this.data[p];
            }
            public method kth(int i) returns int { return this.data[i]; }
            public method size() returns int { return this.count; }
        }
        // A multiset / frequency counter of ints (spec 34.1) backed by a HashMap: add tallies occurrences and
        // tracks the running most-common value, total, and distinct count in O(1) per add; count returns 0 for
        // absent keys.
        public class IntCounter {
            private mutable HashMap<int, int> counts;
            private mutable int total;
            private mutable int distinct;
            private mutable int best;
            private mutable int bestCount;
            public constructor IntCounter() {
                this.counts = new HashMap<int, int>() on heap;
                this.total = 0; this.distinct = 0; this.best = 0; this.bestCount = 0;
            }
            public method add(int v) returns void {
                mutable int c = 1;
                if (this.counts.containsKey(v)) { c = this.counts.get(v) + 1; } else { this.distinct = this.distinct + 1; }
                this.counts.put(v, c);
                this.total = this.total + 1;
                if (c > this.bestCount) { this.bestCount = c; this.best = v; }
                return;
            }
            public method count(int v) returns int {
                if (this.counts.containsKey(v)) { return this.counts.get(v); }
                return 0;
            }
            public method mostCommon() returns int { return this.best; }
            public method maxCount() returns int { return this.bestCount; }
            public method total() returns int { return this.total; }
            public method distinct() returns int { return this.distinct; }
        }
        // An immutable list (spec 34.1): copies the source array at construction and exposes only reads
        // (get/size/isEmpty), so the contents can never change afterwards.
        public class ImmutableList<T> {
            private mutable T[] data;
            private mutable int n;
            public constructor ImmutableList(T[] src, int count) {
                this.n = count;
                this.data = new T[count]();
                for (mutable int i = 0; i < count; i++) { this.data[i] = src[i]; }
            }
            public method get(int i) returns T { return this.data[i]; }
            public method size() returns int { return this.n; }
            public method isEmpty() returns boolean { return this.n == 0; }
        }
        // A dense map keyed by enum ordinal (spec 34.1): since LDP3 enums are int ordinals, values live in a
        // flat array of the enum's size, with a parallel presence flag. O(1) put/get/containsKey.
        public class EnumMap<V> {
            private mutable V[] values;
            private mutable boolean[] present;
            private mutable int count;
            public constructor EnumMap(int size) {
                this.values = new V[size]();
                this.present = new boolean[size]();
                this.count = 0;
            }
            public method put(int ord, V v) returns void {
                if (!this.present[ord]) { this.count = this.count + 1; this.present[ord] = true; }
                this.values[ord] = v;
                return;
            }
            public method get(int ord) returns V { return this.values[ord]; }
            public method containsKey(int ord) returns boolean { return this.present[ord]; }
            public method size() returns int { return this.count; }
        }
        // A dense set of enum ordinals (spec 34.1): a fixed-size flag array over the enum's constants, with
        // O(1) add/remove/contains and a maintained count.
        public class EnumSet {
            private mutable boolean[] bits;
            private mutable int count;
            public constructor EnumSet(int size) { this.bits = new boolean[size](); this.count = 0; }
            public method add(int ord) returns void { if (!this.bits[ord]) { this.bits[ord] = true; this.count = this.count + 1; } return; }
            public method remove(int ord) returns void { if (this.bits[ord]) { this.bits[ord] = false; this.count = this.count - 1; } return; }
            public method contains(int ord) returns boolean { return this.bits[ord]; }
            public method size() returns int { return this.count; }
        }
        // A Fenwick tree / binary indexed tree (spec 34.1): O(log n) point updates and prefix/range sums over
        // int values. Indices are 0-based at the public API; the lowest-set-bit trick (x & -x) walks the tree.
        public class Fenwick {
            private mutable int[] tree;
            private mutable int n;
            public constructor Fenwick(int size) {
                this.n = size;
                this.tree = new int[size + 1]();
            }
            public method add(int i, int delta) returns void {
                mutable int x = i + 1;
                while (x <= this.n) { this.tree[x] = this.tree[x] + delta; x = x + (x & (0 - x)); }
                return;
            }
            public method prefixSum(int i) returns int {
                mutable int x = i + 1;
                mutable int s = 0;
                while (x > 0) { s = s + this.tree[x]; x = x - (x & (0 - x)); }
                return s;
            }
            public method rangeSum(int lo, int hi) returns int {
                if (lo == 0) { return this.prefixSum(hi); }
                return this.prefixSum(hi) - this.prefixSum(lo - 1);
            }
        }
        // An iterative segment tree (spec 34.1) for range sums with O(log n) point updates. Built from an int[];
        // query(lo, hi) is the inclusive sum, update(i, value) sets one position. Works for any length n.
        public class SegmentTree {
            private mutable int[] t;
            private mutable int n;
            public constructor SegmentTree(int[] data) {
                this.n = data.length();
                this.t = new int[2 * this.n]();
                for (mutable int i = 0; i < this.n; i++) { this.t[this.n + i] = data[i]; }
                for (mutable int i = this.n - 1; i >= 1; i = i - 1) { this.t[i] = this.t[2*i] + this.t[2*i+1]; }
            }
            public method update(int i, int value) returns void {
                mutable int p = i + this.n;
                this.t[p] = value;
                p = p / 2;
                while (p >= 1) { this.t[p] = this.t[2*p] + this.t[2*p+1]; p = p / 2; }
                return;
            }
            public method query(int lo, int hi) returns int {
                mutable int res = 0;
                mutable int l = lo + this.n;
                mutable int r = hi + this.n + 1;
                while (l < r) {
                    if ((l & 1) == 1) { res = res + this.t[l]; l = l + 1; }
                    if ((r & 1) == 1) { r = r - 1; res = res + this.t[r]; }
                    l = l / 2; r = r / 2;
                }
                return res;
            }
        }
        // A sparse table (spec 34.1) for O(1) range-minimum queries over a fixed int[], after O(n log n) build.
        // Rows are stored flat (row j at offset j*n); queryMin(lo, hi) is the inclusive minimum.
        public class SparseTable {
            private mutable int[] table;
            private mutable int n;
            private mutable int k;
            public constructor SparseTable(int[] data) {
                this.n = data.length();
                mutable int K = 1;
                while ((1 << K) <= this.n) { K = K + 1; }
                this.k = K;
                this.table = new int[K * this.n]();
                for (mutable int i = 0; i < this.n; i++) { this.table[i] = data[i]; }
                for (mutable int j = 1; j < K; j++) {
                    mutable int i = 0;
                    while (i + (1 << j) <= this.n) {
                        int a = this.table[(j-1)*this.n + i];
                        int b = this.table[(j-1)*this.n + i + (1 << (j-1))];
                        if (a < b) { this.table[j*this.n + i] = a; } else { this.table[j*this.n + i] = b; }
                        i = i + 1;
                    }
                }
            }
            public method queryMin(int lo, int hi) returns int {
                int len = hi - lo + 1;
                mutable int j = 0;
                while ((1 << (j + 1)) <= len) { j = j + 1; }
                int a = this.table[j*this.n + lo];
                int b = this.table[j*this.n + (hi - (1 << j) + 1)];
                if (a < b) { return a; }
                return b;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A weighted undirected graph (spec 34.1) on a dense adjacency matrix (-1 means no edge). dijkstra
        // returns the shortest-path distances from src (O(V^2), unreachable stay at "infinity"); mstWeight is
        // the total weight of a minimum spanning tree via Prim. Vertices are 0..vertices-1.
        public class WeightedGraph {
            private mutable int[] adj;
            private mutable int n;
            public constructor WeightedGraph(int vertices) {
                this.n = vertices;
                this.adj = new int[vertices * vertices]();
                for (mutable int i = 0; i < vertices * vertices; i++) { this.adj[i] = -1; }
            }
            public method addEdge(int u, int v, int w) returns void {
                this.adj[u * this.n + v] = w;
                this.adj[v * this.n + u] = w;
                return;
            }
            public method dijkstra(int src) returns int[] {
                int INF = 1000000000;
                mutable int[] dist = new int[this.n]();
                mutable boolean[] visited = new boolean[this.n]();
                for (mutable int i = 0; i < this.n; i++) { dist[i] = INF; }
                dist[src] = 0;
                for (mutable int iter = 0; iter < this.n; iter++) {
                    mutable int u = -1;
                    mutable int best = INF;
                    for (mutable int i = 0; i < this.n; i++) {
                        if (!visited[i] && dist[i] < best) { best = dist[i]; u = i; }
                    }
                    if (u == -1) { iter = this.n; }
                    else {
                        visited[u] = true;
                        for (mutable int v = 0; v < this.n; v++) {
                            int w = this.adj[u * this.n + v];
                            if (w >= 0 && !visited[v] && dist[u] + w < dist[v]) { dist[v] = dist[u] + w; }
                        }
                    }
                }
                return dist;
            }
            public method mstWeight() returns int {
                int INF = 1000000000;
                mutable int[] key = new int[this.n]();
                mutable boolean[] inMst = new boolean[this.n]();
                for (mutable int i = 0; i < this.n; i++) { key[i] = INF; }
                key[0] = 0;
                mutable int total = 0;
                for (mutable int iter = 0; iter < this.n; iter++) {
                    mutable int u = -1;
                    mutable int best = INF;
                    for (mutable int i = 0; i < this.n; i++) {
                        if (!inMst[i] && key[i] < best) { best = key[i]; u = i; }
                    }
                    if (u == -1) { iter = this.n; }
                    else {
                        inMst[u] = true;
                        total = total + key[u];
                        for (mutable int v = 0; v < this.n; v++) {
                            int w = this.adj[u * this.n + v];
                            if (w >= 0 && !inMst[v] && w < key[v]) { key[v] = w; }
                        }
                    }
                }
                return total;
            }
        }
        // A fixed-capacity LRU cache (spec 34) mapping int keys to int values, with O(1) get/put. A doubly
        // linked list over slot arrays tracks recency (head = most recent); a HashMap finds a key's slot.
        // get returns -1 when the key is absent; put evicts the least-recently-used entry when full.
        public class LruCache {
            private mutable int cap;
            private mutable int size;
            private mutable int head;
            private mutable int tail;
            private mutable int[] keys;
            private mutable int[] vals;
            private mutable int[] prev;
            private mutable int[] next;
            private mutable HashMap<int, int> slotByKey;
            public constructor LruCache(int capacity) {
                this.cap = capacity;
                this.size = 0;
                this.head = -1;
                this.tail = -1;
                this.keys = new int[capacity]();
                this.vals = new int[capacity]();
                this.prev = new int[capacity]();
                this.next = new int[capacity]();
                this.slotByKey = new HashMap<int, int>() on heap;
            }
            private method unlink(int s) returns void {
                int p = this.prev[s];
                int nx = this.next[s];
                if (p != -1) { this.next[p] = nx; } else { this.head = nx; }
                if (nx != -1) { this.prev[nx] = p; } else { this.tail = p; }
                return;
            }
            private method pushHead(int s) returns void {
                this.prev[s] = -1;
                this.next[s] = this.head;
                if (this.head != -1) { this.prev[this.head] = s; }
                this.head = s;
                if (this.tail == -1) { this.tail = s; }
                return;
            }
            public method get(int key) returns int {
                if (!this.slotByKey.containsKey(key)) { return -1; }
                int s = this.slotByKey.get(key);
                this.unlink(s);
                this.pushHead(s);
                return this.vals[s];
            }
            public method contains(int key) returns boolean { return this.slotByKey.containsKey(key); }
            public method put(int key, int value) returns void {
                if (this.slotByKey.containsKey(key)) {
                    int s = this.slotByKey.get(key);
                    this.vals[s] = value;
                    this.unlink(s);
                    this.pushHead(s);
                    return;
                }
                mutable int s = 0;
                if (this.size < this.cap) {
                    s = this.size;
                    this.size = this.size + 1;
                } else {
                    s = this.tail;
                    this.slotByKey.remove(this.keys[s]);
                    this.unlink(s);
                }
                this.keys[s] = key;
                this.vals[s] = value;
                this.slotByKey.put(key, s);
                this.pushHead(s);
                return;
            }
            public method count() returns int { return this.size; }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // 0/1 knapsack (spec 34.1): maximum total value of items fitting in a capacity, via the classic
        // one-dimensional DP swept from high capacity to low so each item is used at most once.
        public class Knapsack {
            public static method maxValue(int[] weights, int[] values, int n, int capacity) returns int {
                mutable int[] dp = new int[capacity + 1]();
                for (mutable int i = 0; i < n; i++) {
                    for (mutable int c = capacity; c >= weights[i]; c = c - 1) {
                        int cand = dp[c - weights[i]] + values[i];
                        if (cand > dp[c]) { dp[c] = cand; }
                    }
                }
                return dp[capacity];
            }
        }
        // Longest common subsequence length (spec 34.1) of two strings via a flat DP table.
        public class Lcs {
            public static method length(String a, String b) returns int {
                int m = a.length();
                int n = b.length();
                mutable int[] dp = new int[(m + 1) * (n + 1)]();
                int w = n + 1;
                for (mutable int i = 1; i <= m; i++) {
                    for (mutable int j = 1; j <= n; j++) {
                        if (a.charAt(i - 1) == b.charAt(j - 1)) {
                            dp[i*w + j] = dp[(i-1)*w + (j-1)] + 1;
                        } else {
                            int up = dp[(i-1)*w + j];
                            int left = dp[i*w + (j-1)];
                            if (up > left) { dp[i*w + j] = up; } else { dp[i*w + j] = left; }
                        }
                    }
                }
                return dp[m*w + n];
            }
        }
        // Quickselect (spec 34.1): the k-th smallest element (0-indexed) in expected linear time, using
        // Lomuto partitioning with a last-element pivot. Partitions the array in place.
        public class QuickSelect {
            private static method partition(int[] a, int lo, int hi) returns int {
                int pivot = a[hi];
                mutable int i = lo;
                for (mutable int j = lo; j < hi; j++) {
                    if (a[j] < pivot) {
                        int t = a[i]; a[i] = a[j]; a[j] = t;
                        i = i + 1;
                    }
                }
                int t2 = a[i]; a[i] = a[hi]; a[hi] = t2;
                return i;
            }
            public static method select(int[] a, int n, int k) returns int {
                mutable int lo = 0;
                mutable int hi = n - 1;
                while (lo < hi) {
                    int p = QuickSelect.partition(a, lo, hi);
                    if (p == k) { return a[p]; }
                    if (p < k) { lo = p + 1; } else { hi = p - 1; }
                }
                return a[lo];
            }
        }
        // Comparator combinators (spec 34.1) built on closures: naturalInt gives ascending int order,
        // reversed flips a comparator, and thenComparing chains a tie-breaker after a primary comparator.
        // Each returns a function<int,int,int> usable with ArrayList.sortedBy.
        public class Comparators {
            public static method naturalInt() returns function<int, int, int> {
                return lambda(int a, int b) returns int { return a - b; };
            }
            public static method reversed(function<int, int, int> cmp) returns function<int, int, int> {
                return lambda(int a, int b) returns int { return cmp(b, a); };
            }
            public static method thenComparing(function<int, int, int> first, function<int, int, int> second)
                returns function<int, int, int> {
                return lambda(int a, int b) returns int {
                    int r = first(a, b);
                    if (r != 0) { return r; }
                    return second(a, b);
                };
            }
        }
        // A stack that also reports its minimum in O(1) (spec 34.1): a parallel stack carries the running
        // minimum at each depth. push/pop/peek/getMin/size.
        public class MinStack {
            private mutable int[] vals;
            private mutable int[] mins;
            private mutable int top;
            public constructor MinStack(int capacity) {
                this.vals = new int[capacity]();
                this.mins = new int[capacity]();
                this.top = 0;
            }
            public method push(int v) returns void {
                this.vals[this.top] = v;
                if (this.top == 0 || v < this.mins[this.top - 1]) { this.mins[this.top] = v; }
                else { this.mins[this.top] = this.mins[this.top - 1]; }
                this.top = this.top + 1;
                return;
            }
            public method pop() returns int { this.top = this.top - 1; return this.vals[this.top]; }
            public method peek() returns int { return this.vals[this.top - 1]; }
            public method getMin() returns int { return this.mins[this.top - 1]; }
            public method size() returns int { return this.top; }
        }
        // Sliding-window maximum (spec 34.1): the maximum of every length-k window, in linear time via a
        // monotonic deque of indices. Returns the n-k+1 maxima.
        public class SlidingWindowMax {
            public static method maxOfEach(int[] a, int n, int k) returns int[] {
                mutable int[] out = new int[n - k + 1]();
                mutable int[] dq = new int[n]();
                mutable int head = 0;
                mutable int tail = 0;
                mutable int oi = 0;
                for (mutable int i = 0; i < n; i++) {
                    while (head < tail && dq[head] <= i - k) { head = head + 1; }
                    while (head < tail && a[dq[tail - 1]] <= a[i]) { tail = tail - 1; }
                    dq[tail] = i; tail = tail + 1;
                    if (i >= k - 1) { out[oi] = a[dq[head]]; oi = oi + 1; }
                }
                return out;
            }
        }
        // Maximum-subarray sum (spec 34.1) by Kadane's algorithm: the largest sum of any contiguous run.
        public class Kadane {
            public static method maxSubarray(int[] a, int n) returns int {
                if (n == 0) { return 0; }
                mutable int best = a[0];
                mutable int cur = a[0];
                for (mutable int i = 1; i < n; i++) {
                    int ext = cur + a[i];
                    if (a[i] > ext) { cur = a[i]; } else { cur = ext; }
                    if (cur > best) { best = cur; }
                }
                return best;
            }
        }
        // Interval merging (spec 34.1): sorts intervals by start and coalesces overlaps in place, writing the
        // merged starts/ends back into the first `count` slots and returning that count; coveredLength totals
        // the merged spans.
        public class IntervalMerge {
            public static method merge(int[] starts, int[] ends, int n) returns int {
                for (mutable int i = 1; i < n; i++) {
                    int ks = starts[i]; int ke = ends[i];
                    mutable int j = i - 1;
                    while (j >= 0 && starts[j] > ks) { starts[j+1] = starts[j]; ends[j+1] = ends[j]; j = j - 1; }
                    starts[j+1] = ks; ends[j+1] = ke;
                }
                if (n == 0) { return 0; }
                mutable int count = 1;
                for (mutable int i = 1; i < n; i++) {
                    if (starts[i] <= ends[count-1]) {
                        if (ends[i] > ends[count-1]) { ends[count-1] = ends[i]; }
                    } else {
                        starts[count] = starts[i]; ends[count] = ends[i]; count = count + 1;
                    }
                }
                return count;
            }
            public static method coveredLength(int[] starts, int[] ends, int mergedCount) returns int {
                mutable int total = 0;
                for (mutable int i = 0; i < mergedCount; i++) { total = total + (ends[i] - starts[i]); }
                return total;
            }
        }
        // Activity selection (spec 34.1): the maximum number of mutually non-overlapping intervals, by the
        // greedy earliest-finishing-time rule (intervals are sorted by end time first). starts[i]/ends[i]
        // describe interval i.
        public class IntervalScheduler {
            public static method maxNonOverlapping(int[] starts, int[] ends, int n) returns int {
                mutable int[] s = new int[n]();
                mutable int[] e = new int[n]();
                for (mutable int i = 0; i < n; i++) { s[i] = starts[i]; e[i] = ends[i]; }
                for (mutable int i = 1; i < n; i++) {
                    int ke = e[i]; int ks = s[i];
                    mutable int j = i - 1;
                    while (j >= 0 && e[j] > ke) { e[j+1] = e[j]; s[j+1] = s[j]; j = j - 1; }
                    e[j+1] = ke; s[j+1] = ks;
                }
                mutable int count = 0;
                mutable int lastEnd = -2147483647;
                for (mutable int i = 0; i < n; i++) {
                    if (s[i] >= lastEnd) { count = count + 1; lastEnd = e[i]; }
                }
                return count;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Collections namespace.
R"LDP3(
        // A bidirectional map (spec 34): keeps key->value and value->key in sync so either side can be looked
        // up. put overwrites both directions; getByKey/getByValue resolve across them.
        public class BiMap<K, V> {
            private mutable HashMap<K, V> fwd;
            private mutable HashMap<V, K> bwd;
            public constructor BiMap() {
                this.fwd = new HashMap<K, V>() on heap;
                this.bwd = new HashMap<V, K>() on heap;
            }
            public method put(K k, V v) returns void {
                this.fwd.put(k, v);
                this.bwd.put(v, k);
                return;
            }
            public method getByKey(K k) returns V { return this.fwd.get(k); }
            public method getByValue(V v) returns K { return this.bwd.get(v); }
            public method hasKey(K k) returns boolean { return this.fwd.containsKey(k); }
            public method size() returns int { return this.fwd.size(); }
        }
        // A multimap (spec 34): each key maps to a growable list of values. put appends; countFor and get(k,i)
        // read the list for a key.
        public class MultiMap<K, V> {
            private mutable HashMap<K, ArrayList<V>> map;
            public constructor MultiMap() { this.map = new HashMap<K, ArrayList<V>>() on heap; }
            public method put(K k, V v) returns void {
                if (!this.map.containsKey(k)) { this.map.put(k, new ArrayList<V>() on heap); }
                mutable ArrayList<V> lst = this.map.get(k);
                lst.add(v);
                return;
            }
            public method countFor(K k) returns int {
                if (!this.map.containsKey(k)) { return 0; }
                return this.map.get(k).size();
            }
            public method get(K k, int i) returns V { return this.map.get(k).get(i); }
        }
        // A 2D Fenwick tree / binary indexed tree (spec 34.1): O(log r * log c) point updates and O(1)-indexed
        // rectangle sums over an int grid. update/prefix/rangeSum take 0-based coordinates.
        public class Fenwick2D {
            private mutable int[] tree;
            private mutable int rows;
            private mutable int cols;
            public constructor Fenwick2D(int rows, int cols) {
                this.rows = rows;
                this.cols = cols;
                this.tree = new int[(rows + 1) * (cols + 1)]();
            }
            public method update(int r, int c, int delta) returns void {
                mutable int i = r + 1;
                while (i <= this.rows) {
                    mutable int j = c + 1;
                    while (j <= this.cols) {
                        this.tree[i * (this.cols + 1) + j] = this.tree[i * (this.cols + 1) + j] + delta;
                        j = j + (j & (0 - j));
                    }
                    i = i + (i & (0 - i));
                }
                return;
            }
            public method prefix(int r, int c) returns int {
                mutable int s = 0;
                mutable int i = r + 1;
                while (i > 0) {
                    mutable int j = c + 1;
                    while (j > 0) {
                        s = s + this.tree[i * (this.cols + 1) + j];
                        j = j - (j & (0 - j));
                    }
                    i = i - (i & (0 - i));
                }
                return s;
            }
            public method rangeSum(int r1, int c1, int r2, int c2) returns int {
                mutable int s = this.prefix(r2, c2);
                if (r1 > 0) { s = s - this.prefix(r1 - 1, c2); }
                if (c1 > 0) { s = s - this.prefix(r2, c1 - 1); }
                if (r1 > 0 && c1 > 0) { s = s + this.prefix(r1 - 1, c1 - 1); }
                return s;
            }
        }
        // A directed graph (spec 34.1) on a dense adjacency matrix: topoSort fills a topological ordering by
        // Kahn's algorithm (lowest-index source first) and returns how many vertices were placed; fewer than
        // n means a cycle, which hasCycle reports.
        public class DiGraph {
            private mutable int[] adj;
            private mutable int n;
            public constructor DiGraph(int vertices) {
                this.n = vertices;
                this.adj = new int[vertices * vertices]();
            }
            public method addEdge(int u, int v) returns void { this.adj[u * this.n + v] = 1; return; }
            public method topoSort(int[] order) returns int {
                mutable int[] indeg = new int[this.n]();
                for (mutable int u = 0; u < this.n; u++) {
                    for (mutable int v = 0; v < this.n; v++) {
                        if (this.adj[u * this.n + v] == 1) { indeg[v] = indeg[v] + 1; }
                    }
                }
                mutable boolean[] done = new boolean[this.n]();
                mutable int cnt = 0;
                mutable boolean progress = true;
                while (progress) {
                    mutable int pick = -1;
                    mutable int i = 0;
                    while (i < this.n) {
                        if (!done[i] && indeg[i] == 0) { pick = i; i = this.n; }
                        else { i = i + 1; }
                    }
                    if (pick == -1) { progress = false; }
                    else {
                        done[pick] = true; order[cnt] = pick; cnt = cnt + 1;
                        for (mutable int j = 0; j < this.n; j++) {
                            if (this.adj[pick * this.n + j] == 1) { indeg[j] = indeg[j] - 1; }
                        }
                    }
                }
                return cnt;
            }
            public method hasCycle() returns boolean {
                mutable int[] o = new int[this.n]();
                return this.topoSort(o) < this.n;
            }
        }
        // A uniform spatial hash grid (spec 34.1) for 2D broad-phase queries: points are bucketed by
        // cell (a HashMap from a packed cell key to the point indices in it), so queryRect only scans the
        // cells overlapping the query box. Coordinates are assumed non-negative.
        public class SpatialGrid {
            private mutable int cell;
            private mutable int[] px;
            private mutable int[] py;
            private mutable int n;
            private mutable HashMap<int, ArrayList<int>> buckets;
            public constructor SpatialGrid(int cellSize, int capacity) {
                this.cell = cellSize;
                this.px = new int[capacity]();
                this.py = new int[capacity]();
                this.n = 0;
                this.buckets = new HashMap<int, ArrayList<int>>() on heap;
            }
            private method key(int cx, int cy) returns int { return cx * 100000 + cy; }
            public method insert(int x, int y) returns void {
                int idx = this.n;
                this.px[idx] = x; this.py[idx] = y; this.n = this.n + 1;
                int ck = this.key(x / this.cell, y / this.cell);
                if (!this.buckets.containsKey(ck)) { this.buckets.put(ck, new ArrayList<int>() on heap); }
                this.buckets.get(ck).add(idx);
                return;
            }
            public method queryRect(int x0, int y0, int x1, int y1) returns int {
                int cx0 = x0 / this.cell; int cy0 = y0 / this.cell;
                int cx1 = x1 / this.cell; int cy1 = y1 / this.cell;
                mutable int count = 0;
                for (mutable int cx = cx0; cx <= cx1; cx++) {
                    for (mutable int cy = cy0; cy <= cy1; cy++) {
                        int ck = this.key(cx, cy);
                        if (this.buckets.containsKey(ck)) {
                            mutable ArrayList<int> lst = this.buckets.get(ck);
                            for (mutable int i = 0; i < lst.size(); i++) {
                                int idx = lst.get(i);
                                if (this.px[idx] >= x0 && this.px[idx] <= x1
                                    && this.py[idx] >= y0 && this.py[idx] <= y1) { count = count + 1; }
                            }
                        }
                    }
                }
                return count;
            }
        }
    }
)LDP3"
// (split: System.Ecs in its own literal.)
R"LDP3(
    public namespace System.Ecs {
        // An entity-component-system core (spec 34, data-oriented identity of LDP3). World hands out integer
        // entity ids and recycles destroyed ones; component data lives outside the entity in ComponentStore.
        public class World {
            private mutable boolean[] alive;
            private mutable int[] freeList;
            private mutable int freeCount;
            private mutable int next;
            private mutable int cap;
            private mutable int count;
            public constructor World() {
                this.cap = 16;
                this.alive = new boolean[16]();
                this.freeList = new int[16]();
                this.freeCount = 0;
                this.next = 0;
                this.count = 0;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable boolean[] na = new boolean[nc]();
                mutable int[] nf = new int[nc]();
                for (mutable int i = 0; i < this.cap; i++) { na[i] = this.alive[i]; }
                for (mutable int i = 0; i < this.freeCount; i++) { nf[i] = this.freeList[i]; }
                this.alive = na;
                this.freeList = nf;
                this.cap = nc;
                return;
            }
            public method createEntity() returns int {
                mutable int id = 0;
                if (this.freeCount > 0) {
                    id = this.freeList[this.freeCount - 1];
                    this.freeCount = this.freeCount - 1;
                } else {
                    if (this.next == this.cap) { this.grow(); }
                    id = this.next;
                    this.next = this.next + 1;
                }
                this.alive[id] = true;
                this.count = this.count + 1;
                return id;
            }
            public method destroyEntity(int e) returns void {
                if (e >= 0 && e < this.cap && this.alive[e]) {
                    this.alive[e] = false;
                    this.freeList[this.freeCount] = e;
                    this.freeCount = this.freeCount + 1;
                    this.count = this.count - 1;
                }
                return;
            }
            public method isAlive(int e) returns boolean { return e >= 0 && e < this.cap && this.alive[e]; }
            public method size() returns int { return this.count; }
            public method capacity() returns int { return this.cap; }
        }
        // A sparse-set store mapping an entity id to one component of type T (spec 34). Components live in a
        // dense array for fast iteration (size/entityAt index it); the sparse array maps entity -> dense slot.
        // remove is a swap-with-last. Sized for entity ids in [0, maxEntities).
        public class ComponentStore<T> {
            private mutable T[] dense;
            private mutable int[] denseEntity;
            private mutable int[] sparse;
            private mutable int count;
            private mutable int cap;
            public constructor ComponentStore(int maxEntities) {
                this.sparse = new int[maxEntities]();
                for (mutable int i = 0; i < maxEntities; i++) { this.sparse[i] = 0 - 1; }
                this.dense = new T[8]();
                this.denseEntity = new int[8]();
                this.count = 0;
                this.cap = 8;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable T[] nd = new T[nc]();
                mutable int[] ne = new int[nc]();
                for (mutable int i = 0; i < this.count; i++) {
                    nd[i] = this.dense[i];
                    ne[i] = this.denseEntity[i];
                }
                this.dense = nd;
                this.denseEntity = ne;
                this.cap = nc;
                return;
            }
            public method add(int e, T component) returns void {
                if (this.count == this.cap) { this.grow(); }
                this.dense[this.count] = component;
                this.denseEntity[this.count] = e;
                this.sparse[e] = this.count;
                this.count = this.count + 1;
                return;
            }
            public method has(int e) returns boolean { return this.sparse[e] >= 0; }
            public method get(int e) returns T { return this.dense[this.sparse[e]]; }
            public method set(int e, T component) returns void {
                this.dense[this.sparse[e]] = component;
                return;
            }
            public method remove(int e) returns void {
                int idx = this.sparse[e];
                if (idx < 0) { return; }
                int last = this.count - 1;
                this.dense[idx] = this.dense[last];
                this.denseEntity[idx] = this.denseEntity[last];
                this.sparse[this.denseEntity[last]] = idx;
                this.sparse[e] = 0 - 1;
                this.count = this.count - 1;
                return;
            }
            public method size() returns int { return this.count; }
            public method entityAt(int i) returns int { return this.denseEntity[i]; }
            public method at(int i) returns T { return this.dense[i]; }
        }
    }
)LDP3"
// (split: System.Events in its own literal.)
R"LDP3(
    public namespace System.Events {
        // Observer/event dispatch (spec 34): a publisher keeps a list of handler functions and calls them all
        // on emit. Each handler is wrapped in a small object so it can live in an ArrayList (function values
        // are not directly storable in a list yet). These are the concrete payload types; a fully generic
        // Event<T> awaits nested-generic monomorphization.
        public class VoidHandler {
            private mutable function<void> fn;
            public constructor VoidHandler(function<void> f) { this.fn = f; }
            public method invoke() returns void { this.fn(); return; }
        }
        // Fires with no payload (a notification), e.g. onSave, onClose. Handlers live in a plain growable
        // array (not an ArrayList) so the type needs no equality and the event works in freestanding too.
        public class Signal {
            private mutable VoidHandler[] hs;
            private mutable int count;
            private mutable int cap;
            public constructor Signal() {
                this.cap = 4;
                this.hs = new VoidHandler[4]();
                this.count = 0;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable VoidHandler[] nh = new VoidHandler[nc]();
                for (mutable int i = 0; i < this.count; i++) { nh[i] = this.hs[i]; }
                this.hs = nh;
                this.cap = nc;
                return;
            }
            public method subscribe(function<void> h) returns void {
                if (this.count == this.cap) { this.grow(); }
                this.hs[this.count] = new VoidHandler(h) on heap;
                this.count = this.count + 1;
                return;
            }
            public method emit() returns void {
                for (mutable int i = 0; i < this.count; i++) { this.hs[i].invoke(); }
                return;
            }
            public method count() returns int { return this.count; }
        }
        public class IntHandler {
            private mutable function<void, int> fn;
            public constructor IntHandler(function<void, int> f) { this.fn = f; }
            public method invoke(int arg) returns void { this.fn(arg); return; }
        }
        // Fires with an int payload, e.g. onTick(elapsed), onScore(points).
        public class IntEvent {
            private mutable IntHandler[] hs;
            private mutable int count;
            private mutable int cap;
            public constructor IntEvent() {
                this.cap = 4;
                this.hs = new IntHandler[4]();
                this.count = 0;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable IntHandler[] nh = new IntHandler[nc]();
                for (mutable int i = 0; i < this.count; i++) { nh[i] = this.hs[i]; }
                this.hs = nh;
                this.cap = nc;
                return;
            }
            public method subscribe(function<void, int> h) returns void {
                if (this.count == this.cap) { this.grow(); }
                this.hs[this.count] = new IntHandler(h) on heap;
                this.count = this.count + 1;
                return;
            }
            public method emit(int arg) returns void {
                for (mutable int i = 0; i < this.count; i++) { this.hs[i].invoke(arg); }
                return;
            }
            public method count() returns int { return this.count; }
        }
        public class StringHandler {
            private mutable function<void, String> fn;
            public constructor StringHandler(function<void, String> f) { this.fn = f; }
            public method invoke(String arg) returns void { this.fn(arg); return; }
        }
        // Fires with a String payload, e.g. onMessage(text), onError(reason).
        public class StringEvent {
            private mutable StringHandler[] hs;
            private mutable int count;
            private mutable int cap;
            public constructor StringEvent() {
                this.cap = 4;
                this.hs = new StringHandler[4]();
                this.count = 0;
            }
            private method grow() returns void {
                int nc = this.cap * 2;
                mutable StringHandler[] nh = new StringHandler[nc]();
                for (mutable int i = 0; i < this.count; i++) { nh[i] = this.hs[i]; }
                this.hs = nh;
                this.cap = nc;
                return;
            }
            public method subscribe(function<void, String> h) returns void {
                if (this.count == this.cap) { this.grow(); }
                this.hs[this.count] = new StringHandler(h) on heap;
                this.count = this.count + 1;
                return;
            }
            public method emit(String arg) returns void {
                for (mutable int i = 0; i < this.count; i++) { this.hs[i].invoke(arg); }
                return;
            }
            public method count() returns int { return this.count; }
        }
    }
)LDP3"
// (split 2: another ~16KB literal boundary.)
R"LDP3(
    public namespace System.Text {
        // Growable text buffer (spec 34.5). Bytes live in a raw heap buffer (System.Memory) that
        // doubles on demand, so append is amortized O(1); toString() copies into an owned String.
        public class StringBuilder {
            private mutable address buf;
            private mutable int count;
            private mutable int cap;
            public constructor StringBuilder() {
                this.cap = 16;
                this.buf = Memory.alloc(16);
                this.count = 0;
            }
            private method ensure(int extra) returns void {
                if (this.count + extra <= this.cap) { return; }
                mutable int n = this.cap * 2;
                while (n < this.count + extra) { n = n * 2; }
                address nb = Memory.alloc(n);
                Memory.copy(nb, this.buf, this.count);  // bulk memcpy, not byte-by-byte
                Memory.free(this.buf);
                this.buf = nb;
                this.cap = n;
            }
            public method append(String s) returns StringBuilder {
                int n = s.length();
                this.ensure(n);
                Memory.writeString(this.buf + cast<address>(this.count), s);  // bulk memcpy, not byte-by-byte
                this.count = this.count + n;
                return this;
            }
            public method appendChar(char c) returns StringBuilder {
                this.ensure(1);
                Memory.write(this.buf + cast<address>(this.count), cast<byte>(c));
                this.count = this.count + 1;
                return this;
            }
            public method appendInt(int value) returns StringBuilder {
                return this.append(value.toString());
            }
            public method length() returns int { return this.count; }
            public method toString() returns String {
                return Memory.readString(this.buf, this.count);
            }
        }
        // String utilities that the built-in String type does not carry as methods (spec 4): splitting,
        // joining, replacing, and padding. Each is a static helper built from the String primitives
        // (indexOf/substring/concat/repeat), so they allocate fresh owned Strings and never mutate input.
        public class Strings {
            public static method split(String text, String separator) returns ArrayList<String> {
                // Cursor scan over the original text (the old rest = rest.substring(...) resliced the
                // whole remainder every step -> O(n^2)). Only the emitted pieces allocate -> O(n).
                mutable ArrayList<String> out = new ArrayList<String>() on heap;
                int n = text.length();
                int m = separator.length();
                if (m == 0) { out.add(text); return out; }  // empty separator: no split (avoids a stall)
                mutable int start = 0;
                mutable int i = 0;
                while (i + m <= n) {
                    mutable boolean hit = true;
                    for (mutable int j = 0; j < m; j++) {
                        if (text.charAt(i + j) != separator.charAt(j)) { hit = false; }
                    }
                    if (hit) {
                        out.add(text.substring(start, i));
                        i = i + m;
                        start = i;
                    } else {
                        i = i + 1;
                    }
                }
                out.add(text.substring(start, n));
                return out;
            }
            public static method join(ArrayList<String> parts, String separator) returns String {
                StringBuilder sb = new StringBuilder() on heap;  // O(n); repeated concat was O(n^2)
                for (mutable int i = 0; i < parts.size(); i++) {
                    if (i > 0) { sb.append(separator); }
                    sb.append(parts.get(i));
                }
                return sb.toString();
            }
            public static method replace(String text, String target, String replacement) returns String {
                int tlen = target.length();
                if (tlen == 0) { return text; }
                int n = text.length();
                StringBuilder sb = new StringBuilder() on heap;  // O(n*m); the old concat+substring was O(n^2)
                mutable int i = 0;
                while (i < n) {
                    mutable boolean hit = i + tlen <= n;
                    mutable int j = 0;
                    while (hit && j < tlen) {
                        if (text.charAt(i + j) != target.charAt(j)) { hit = false; }
                        j = j + 1;
                    }
                    if (hit) {
                        sb.append(replacement);
                        i = i + tlen;
                    } else {
                        sb.appendChar(text.charAt(i));
                        i = i + 1;
                    }
                }
                return sb.toString();
            }
            public static method padLeft(String text, int width, String pad) returns String {
                if (text.length() >= width) { return text; }
                return pad.repeat(width - text.length()).concat(text);
            }
            public static method padRight(String text, int width, String pad) returns String {
                if (text.length() >= width) { return text; }
                return text.concat(pad.repeat(width - text.length()));
            }
            // Fills each {} placeholder in the template with the next argument, in order (spec 4). Extra
            // arguments are ignored; a {} with no argument left is dropped. Arguments are already strings,
            // so callers stringify with toString() first.
            public static method format(String template, ArrayList<String> args) returns String {
                int n = template.length();
                StringBuilder sb = new StringBuilder() on heap;  // O(n); the old concat+substring was O(n^2)
                mutable int i = 0;
                mutable int next = 0;
                while (i < n) {
                    if (i + 1 < n && template.charAt(i) == 123 && template.charAt(i + 1) == 125) {
                        if (next < args.size()) {
                            sb.append(args.get(next));
                            next = next + 1;
                        }
                        i = i + 2;
                    } else {
                        sb.appendChar(template.charAt(i));
                        i = i + 1;
                    }
                }
                return sb.toString();
            }
            // Counts the non-overlapping occurrences of a substring (spec 4).
            public static method count(String text, String sub) returns int {
                int m = sub.length();
                if (m == 0) { return 0; }
                // Cursor scan (the old rest = rest.substring(...) resliced the remainder each hit -> O(n^2)).
                mutable int hits = 0;
                int n = text.length();
                mutable int i = 0;
                while (i + m <= n) {
                    mutable boolean hit = true;
                    for (mutable int j = 0; j < m; j++) {
                        if (text.charAt(i + j) != sub.charAt(j)) { hit = false; }
                    }
                    if (hit) { hits = hits + 1; i = i + m; } else { i = i + 1; }
                }
                return hits;
            }
            // Reverses the characters of a string (spec 4); substring(i, i+1) yields each one-char piece.
            public static method reverse(String text) returns String {
                // StringBuilder, not result = result.concat(...) which recopied the whole string each
                // step (O(n^2)).
                StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = text.length() - 1; i >= 0; i--) {
                    sb.appendChar(text.charAt(i));
                }
                return sb.toString();
            }
            // Upper-cases the first character and leaves the rest unchanged (spec 4).
            public static method capitalize(String text) returns String {
                if (text.length() == 0) { return text; }
                return text.substring(0, 1).toUpper().concat(text.substring(1, text.length()));
            }
            private static method isSpaceChar(char c) returns boolean {
                return c == ' ' || c == '\t' || c == '\n' || c == '\r';
            }
            // Trims whitespace from one end only (spec 4); the built-in String.trim does both ends.
            public static method trimStart(String text) returns String {
                mutable int i = 0;
                while (i < text.length() && Strings.isSpaceChar(text.charAt(i))) { i = i + 1; }
                return text.substring(i, text.length());
            }
            public static method trimEnd(String text) returns String {
                mutable int e = text.length();
                while (e > 0 && Strings.isSpaceChar(text.charAt(e - 1))) { e = e - 1; }
                return text.substring(0, e);
            }
            // Whether a string is empty or only whitespace (spec 4).
            public static method isBlank(String text) returns boolean {
                for (mutable int i = 0; i < text.length(); i++) {
                    if (!Strings.isSpaceChar(text.charAt(i))) { return false; }
                }
                return true;
            }
            // Case-insensitive equality, comparing the lower-cased forms (spec 4).
            public static method equalsIgnoreCase(String a, String b) returns boolean {
                return a.toLower().equals(b.toLower());
            }
        }
)LDP3"
// Split here only to stay under the MSVC per-string-literal size limit; the two raw chunks concatenate
// into one continuous System.Text namespace.
R"LDP3(
        // A small backtracking regular-expression matcher (spec 4): literals, . (any), character classes
        // [abc]/[a-z]/[^...], the quantifiers * + ?, and the anchors ^ and $. search reports whether the
        // pattern occurs in the text; wrap a pattern in ^ and $ to require a full match. Pure LDP3 over
        // the String primitives -- the helpers recurse to handle backtracking.
        public class Regex {
            // The index just past the atom starting at pi: one char, or the whole [...] class.
            private static method atomEnd(String pat, int pi) returns int {
                if (pat.charAt(pi) == '[') {
                    mutable int j = pi + 1;
                    if (j < pat.length() && pat.charAt(j) == '^') { j = j + 1; }
                    if (j < pat.length() && pat.charAt(j) == ']') { j = j + 1; }
                    while (j < pat.length() && pat.charAt(j) != ']') { j = j + 1; }
                    return j + 1;
                }
                return pi + 1;
            }
            // Whether ch is in the class spelled between [ and ] (indices [start, end)); ^ first negates.
            private static method matchClass(String pat, int start, int end, char ch) returns boolean {
                mutable int i = start;
                mutable boolean negate = false;
                if (i < end && pat.charAt(i) == '^') { negate = true; i = i + 1; }
                mutable boolean found = false;
                while (i < end) {
                    if (i + 2 < end && pat.charAt(i + 1) == '-') {
                        if (ch >= pat.charAt(i) && ch <= pat.charAt(i + 2)) { found = true; }
                        i = i + 3;
                    } else {
                        if (pat.charAt(i) == ch) { found = true; }
                        i = i + 1;
                    }
                }
                if (negate) { return !found; }
                return found;
            }
            // Whether the single atom at [pi, atomEnd) matches one character ch.
            private static method matchAtom(String pat, int pi, int atomEnd, char ch) returns boolean {
                char p = pat.charAt(pi);
                if (p == '.') { return true; }
                if (p == '[') { return Regex.matchClass(pat, pi + 1, atomEnd - 1, ch); }
                return p == ch;
            }
            // Matches at least min repetitions of the atom, then the rest; backtracks from the longest run.
            private static method matchStar(int min, String pat, int pi, int atomEnd, String text, int ti)
                    returns boolean {
                mutable int count = 0;
                while (ti + count < text.length() &&
                       Regex.matchAtom(pat, pi, atomEnd, text.charAt(ti + count))) {
                    count = count + 1;
                }
                mutable int k = count;
                while (k >= min) {
                    if (Regex.matchHere(pat, atomEnd + 1, text, ti + k)) { return true; }
                    k = k - 1;
                }
                return false;
            }
            // Whether pat[pi:] matches text[ti:].
            private static method matchHere(String pat, int pi, String text, int ti) returns boolean {
                if (pi >= pat.length()) { return true; }
                if (pat.charAt(pi) == '$' && pi + 1 == pat.length()) { return ti == text.length(); }
                int ae = Regex.atomEnd(pat, pi);
                mutable char quant = ' ';
                if (ae < pat.length()) {
                    char q = pat.charAt(ae);
                    if (q == '*' || q == '+' || q == '?') { quant = q; }
                }
                if (quant == '*') { return Regex.matchStar(0, pat, pi, ae, text, ti); }
                if (quant == '+') { return Regex.matchStar(1, pat, pi, ae, text, ti); }
                if (quant == '?') {
                    if (ti < text.length() && Regex.matchAtom(pat, pi, ae, text.charAt(ti))) {
                        if (Regex.matchHere(pat, ae + 1, text, ti + 1)) { return true; }
                    }
                    return Regex.matchHere(pat, ae + 1, text, ti);
                }
                if (ti < text.length() && Regex.matchAtom(pat, pi, ae, text.charAt(ti))) {
                    return Regex.matchHere(pat, ae, text, ti + 1);
                }
                return false;
            }
            public static method search(String pat, String text) returns boolean {
                if (pat.length() > 0 && pat.charAt(0) == '^') { return Regex.matchHere(pat, 1, text, 0); }
                for (mutable int start = 0; start <= text.length(); start++) {
                    if (Regex.matchHere(pat, 0, text, start)) { return true; }
                }
                return false;
            }
        }
        // UTF-8 decoding (spec 4): String.charAt and String.length are byte-level, so Utf8 reads whole
        // Unicode codepoints out of the byte sequence -- length counts characters, codepointAt decodes the
        // one at a byte offset, and codepoints returns them all. A lead byte's high bits give the width.
        public class Utf8 {
            private static method seqLen(int lead) returns int {
                if (lead < 128) { return 1; }     // 0xxxxxxx (ASCII)
                if (lead >= 240) { return 4; }    // 11110xxx
                if (lead >= 224) { return 3; }    // 1110xxxx
                if (lead >= 192) { return 2; }    // 110xxxxx
                return 1;                          // a stray continuation byte: step over it
            }
            // The number of bytes occupied by the character at byte offset i (advance by this).
            public static method widthAt(String s, int i) returns int {
                return Utf8.seqLen(cast<int>(s.charAt(i)));
            }
            // The Unicode codepoint of the character at byte offset i.
            public static method codepointAt(String s, int i) returns int {
                mutable int lead = cast<int>(s.charAt(i));
                int n = Utf8.seqLen(lead);
                if (n == 1) { return lead; }
                mutable int cp = 0;
                if (n == 2) { cp = lead - 192; }
                if (n == 3) { cp = lead - 224; }
                if (n == 4) { cp = lead - 240; }
                for (mutable int k = 1; k < n; k++) {
                    cp = cp * 64 + (cast<int>(s.charAt(i + k)) - 128);
                }
                return cp;
            }
            // The number of Unicode characters (codepoints), not bytes.
            public static method length(String s) returns int {
                mutable int count = 0;
                mutable int i = 0;
                while (i < s.length()) {
                    i = i + Utf8.seqLen(cast<int>(s.charAt(i)));
                    count = count + 1;
                }
                return count;
            }
            // Every codepoint in order.
            public static method codepoints(String s) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                mutable int i = 0;
                while (i < s.length()) {
                    out.add(Utf8.codepointAt(s, i));
                    i = i + Utf8.seqLen(cast<int>(s.charAt(i)));
                }
                return out;
            }
        }
        // A cursor over text that hands out tokens (spec 4): nextWord reads up to the next whitespace,
        // nextInt parses that token, and nextLine reads to the newline. hasNext/hasNextLine report whether
        // more remains. It walks a String, so it parses file contents or any in-memory text.
        public class Scanner {
            private mutable String src;
            private mutable int pos;
            public constructor Scanner(String text) {
                this.src = text;
                this.pos = 0;
            }
            private static method isSpace(char c) returns boolean {
                return c == ' ' || c == '\t' || c == '\n' || c == '\r';
            }
            private method skipSpaces() returns void {
                while (this.pos < this.src.length() && Scanner.isSpace(this.src.charAt(this.pos))) {
                    this.pos = this.pos + 1;
                }
                return;
            }
            public method hasNext() returns boolean {
                this.skipSpaces();
                return this.pos < this.src.length();
            }
            public method nextWord() returns String {
                this.skipSpaces();
                mutable int start = this.pos;
                while (this.pos < this.src.length() && !Scanner.isSpace(this.src.charAt(this.pos))) {
                    this.pos = this.pos + 1;
                }
                return this.src.substring(start, this.pos);
            }
            public method nextInt() returns int {
                return this.nextWord().toInt();
            }
            public method hasNextLine() returns boolean {
                return this.pos < this.src.length();
            }
            public method nextLine() returns String {
                mutable int start = this.pos;
                while (this.pos < this.src.length() && this.src.charAt(this.pos) != '\n') {
                    this.pos = this.pos + 1;
                }
                mutable String line = this.src.substring(start, this.pos);
                if (this.pos < this.src.length()) { this.pos = this.pos + 1; }
                return line;
            }
        }
        // Hexadecimal encoding (spec 4): each byte of a string becomes two lowercase hex digits, and back.
        public class Hex {
            private static method hexVal(char c) returns int {
                if (c >= '0' && c <= '9') { return cast<int>(c) - cast<int>('0'); }
                if (c >= 'a' && c <= 'f') { return cast<int>(c) - cast<int>('a') + 10; }
                if (c >= 'A' && c <= 'F') { return cast<int>(c) - cast<int>('A') + 10; }
                return 0;
            }
            public static method encode(String data) returns String {
                String digits = "0123456789abcdef";
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < data.length(); i++) {
                    int b = cast<int>(data.charAt(i));
                    sb.appendChar(digits.charAt(b / 16));
                    sb.appendChar(digits.charAt(b % 16));
                }
                return sb.toString();
            }
            public static method decode(String hex) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i + 1 < hex.length(); i = i + 2) {
                    int hi = Hex.hexVal(hex.charAt(i));
                    int lo = Hex.hexVal(hex.charAt(i + 1));
                    sb.appendChar(cast<char>(hi * 16 + lo));
                }
                return sb.toString();
            }
        }
        // Arbitrary-base integer conversion (spec 4), bases 2..36 using 0-9 then a-z. toBase renders a long
        // (with a leading '-' for negatives); fromBase parses such a string back (case-insensitive).
        public class Radix {
            private static method digitChar(int d) returns char {
                if (d < 10) { return cast<char>(cast<int>('0') + d); }
                return cast<char>(cast<int>('a') + d - 10);
            }
            private static method digitValue(char c) returns int {
                if (c >= '0' && c <= '9') { return cast<int>(c) - cast<int>('0'); }
                if (c >= 'a' && c <= 'z') { return cast<int>(c) - cast<int>('a') + 10; }
                if (c >= 'A' && c <= 'Z') { return cast<int>(c) - cast<int>('A') + 10; }
                return 0;
            }
            public static method toBase(long n, int base) returns String {
                if (n == 0) { return "0"; }
                mutable long v = n;
                mutable boolean neg = false;
                if (v < 0) { neg = true; v = 0 - v; }
                mutable StringBuilder rev = new StringBuilder() on heap;
                while (v > 0) {
                    rev.appendChar(Radix.digitChar(cast<int>(v % cast<long>(base))));
                    v = v / cast<long>(base);
                }
                mutable StringBuilder out = new StringBuilder() on heap;
                if (neg) { out.appendChar('-'); }
                String r = rev.toString();
                for (mutable int i = r.length() - 1; i >= 0; i = i - 1) { out.appendChar(r.charAt(i)); }
                return out.toString();
            }
            public static method fromBase(String s, int base) returns long {
                mutable int i = 0;
                mutable boolean neg = false;
                if (s.length() > 0 && s.charAt(0) == '-') { neg = true; i = 1; }
                mutable long v = 0;
                while (i < s.length()) {
                    v = v * cast<long>(base) + cast<long>(Radix.digitValue(s.charAt(i)));
                    i = i + 1;
                }
                if (neg) { return 0 - v; }
                return v;
            }
        }
        // Base64 encoding (spec 4): three bytes become four characters of the standard alphabet, with =
        // padding on the final group; decode reverses it. Bytes are read from and written to String storage.
        public class Base64 {
            private static method val(char c) returns int {
                if (c >= 'A' && c <= 'Z') { return cast<int>(c) - cast<int>('A'); }
                if (c >= 'a' && c <= 'z') { return cast<int>(c) - cast<int>('a') + 26; }
                if (c >= '0' && c <= '9') { return cast<int>(c) - cast<int>('0') + 52; }
                if (c == '+') { return 62; }
                if (c == '/') { return 63; }
                return 0;
            }
            public static method encode(String data) returns String {
                String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                int n = data.length();
                while (i < n) {
                    int b0 = cast<int>(data.charAt(i));
                    mutable int b1 = 0;
                    boolean has1 = i + 1 < n;
                    if (has1) { b1 = cast<int>(data.charAt(i + 1)); }
                    mutable int b2 = 0;
                    boolean has2 = i + 2 < n;
                    if (has2) { b2 = cast<int>(data.charAt(i + 2)); }
                    int triple = b0 * 65536 + b1 * 256 + b2;
                    sb.appendChar(alpha.charAt((triple / 262144) % 64));
                    sb.appendChar(alpha.charAt((triple / 4096) % 64));
                    if (has1) { sb.appendChar(alpha.charAt((triple / 64) % 64)); } else { sb.appendChar('='); }
                    if (has2) { sb.appendChar(alpha.charAt(triple % 64)); } else { sb.appendChar('='); }
                    i = i + 3;
                }
                return sb.toString();
            }
            public static method decode(String data) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                int n = data.length();
                while (i + 3 < n) {
                    int triple = Base64.val(data.charAt(i)) * 262144 + Base64.val(data.charAt(i + 1)) * 4096
                               + Base64.val(data.charAt(i + 2)) * 64 + Base64.val(data.charAt(i + 3));
                    sb.appendChar(cast<char>((triple / 65536) % 256));
                    if (data.charAt(i + 2) != '=') { sb.appendChar(cast<char>((triple / 256) % 256)); }
                    if (data.charAt(i + 3) != '=') { sb.appendChar(cast<char>(triple % 256)); }
                    i = i + 4;
                }
                return sb.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Base32 (RFC 4648) over a string's bytes: 5 bytes encode to 8 chars of the alphabet
        // ABCDEFGHIJKLMNOPQRSTUVWXYZ234567, '=' padded. encode/decode round-trip. Uses a 40-bit long buffer.
        public class Base32 {
            private static method val(char c) returns int {
                if (c >= 'A' && c <= 'Z') { return cast<int>(c) - cast<int>('A'); }
                if (c >= '2' && c <= '7') { return cast<int>(c) - cast<int>('2') + 26; }
                return 0;
            }
            public static method encode(String data) returns String {
                String AL = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
                mutable StringBuilder sb = new StringBuilder() on heap;
                int n = data.length();
                mutable int i = 0;
                while (i < n) {
                    mutable long buf = 0;
                    mutable int cnt = 0;
                    for (mutable int j = 0; j < 5; j++) {
                        buf = buf << 8;
                        if (i + j < n) {
                            buf = buf | cast<long>(cast<int>(data.charAt(i + j)) & 255);
                            cnt = cnt + 1;
                        }
                    }
                    mutable int outc = 8;
                    if (cnt == 1) { outc = 2; }
                    if (cnt == 2) { outc = 4; }
                    if (cnt == 3) { outc = 5; }
                    if (cnt == 4) { outc = 7; }
                    for (mutable int k = 0; k < 8; k++) {
                        int shift = 35 - k * 5;
                        int idx = cast<int>((buf >> shift) & cast<long>(31));
                        if (k < outc) { sb.appendChar(AL.charAt(idx)); } else { sb.appendChar('='); }
                    }
                    i = i + 5;
                }
                return sb.toString();
            }
            public static method decode(String s) returns String {
                mutable StringBuilder out = new StringBuilder() on heap;
                mutable long buf = 0;
                mutable int bits = 0;
                int n = s.length();
                for (mutable int i = 0; i < n; i++) {
                    char c = s.charAt(i);
                    if (c == '=') { return out.toString(); }
                    buf = (buf << 5) | cast<long>(Base32.val(c));
                    bits = bits + 5;
                    if (bits >= 8) {
                        bits = bits - 8;
                        out.appendChar(cast<char>(cast<int>((buf >> bits) & cast<long>(255))));
                    }
                }
                return out.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Base58 (the Bitcoin alphabet, spec 4): big-endian base-256 to base-58 with no 0/O/I/l, leading zero
        // bytes preserved as leading '1's. encode takes the first n bytes of an int[]; decode returns the bytes.
        public class Base58 {
            private static method al() returns String { return "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"; }
            private static method val(char c) returns int {
                String a = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
                for (mutable int i = 0; i < a.length(); i++) { if (a.charAt(i) == c) { return i; } }
                return 0;
            }
            public static method encode(int[] bytes, int n) returns String {
                String a = Base58.al();
                mutable int zeros = 0;
                while (zeros < n && bytes[zeros] == 0) { zeros = zeros + 1; }
                mutable int[] buf = new int[n + 1]();
                for (mutable int i = 0; i < n; i++) { buf[i] = bytes[i] & 255; }
                mutable StringBuilder rev = new StringBuilder() on heap;
                mutable int start = zeros;
                while (start < n) {
                    mutable int rem = 0;
                    for (mutable int i = start; i < n; i++) {
                        int acc = rem * 256 + buf[i];
                        buf[i] = acc / 58;
                        rem = acc % 58;
                    }
                    rev.appendChar(a.charAt(rem));
                    if (buf[start] == 0) { start = start + 1; }
                }
                mutable StringBuilder out = new StringBuilder() on heap;
                for (mutable int i = 0; i < zeros; i++) { out.appendChar('1'); }
                String r = rev.toString();
                for (mutable int i = r.length() - 1; i >= 0; i = i - 1) { out.appendChar(r.charAt(i)); }
                return out.toString();
            }
            public static method decode(String s) returns int[] {
                mutable int zeros = 0;
                while (zeros < s.length() && s.charAt(zeros) == '1') { zeros = zeros + 1; }
                mutable int[] tmp = new int[s.length() + 1]();
                mutable int blen = 0;
                for (mutable int i = 0; i < s.length(); i++) {
                    mutable int carry = Base58.val(s.charAt(i));
                    for (mutable int j = 0; j < blen; j++) {
                        int acc = tmp[j] * 58 + carry;
                        tmp[j] = acc & 255;
                        carry = acc >> 8;
                    }
                    while (carry > 0) { tmp[blen] = carry & 255; blen = blen + 1; carry = carry >> 8; }
                }
                mutable int[] out = new int[zeros + blen]();
                for (mutable int i = 0; i < blen; i++) { out[zeros + i] = tmp[blen - 1 - i]; }
                return out;
            }
        }
        // Ascii85 / Base85 (spec 4, Adobe variant without delimiters): four bytes become five printable chars
        // (base 85 starting at '!'), a final partial group emitting one fewer char than its bytes+1. encode
        // takes the first n bytes; decode returns the bytes (padding a short final group with 'u').
        public class Ascii85 {
            public static method encode(int[] bytes, int n) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                while (i < n) {
                    mutable long val = 0;
                    mutable int cnt = 0;
                    for (mutable int k = 0; k < 4; k++) {
                        val = val * 256;
                        if (i + k < n) { val = val + cast<long>(bytes[i + k] & 255); cnt = cnt + 1; }
                    }
                    mutable int[] dig = new int[5]();
                    mutable long v = val;
                    for (mutable int k = 4; k >= 0; k = k - 1) { dig[k] = cast<int>(v % 85); v = v / 85; }
                    for (mutable int k = 0; k < cnt + 1; k++) { sb.appendChar(cast<char>(33 + dig[k])); }
                    i = i + 4;
                }
                return sb.toString();
            }
            public static method decode(String s) returns int[] {
                int n = s.length();
                mutable int total = 0;
                mutable int gi = 0;
                while (gi < n) { mutable int c = n - gi; if (c > 5) { c = 5; } total = total + (c - 1); gi = gi + 5; }
                mutable int[] out = new int[total]();
                mutable int pos = 0;
                mutable int i = 0;
                while (i < n) {
                    mutable int c = n - i; if (c > 5) { c = 5; }
                    mutable long val = 0;
                    for (mutable int k = 0; k < 5; k++) {
                        mutable int d = 84;
                        if (k < c) { d = cast<int>(s.charAt(i + k)) - 33; }
                        val = val * 85 + cast<long>(d);
                    }
                    for (mutable int k = 0; k < c - 1; k++) {
                        int shift = (3 - k) * 8;
                        out[pos] = cast<int>((val >> shift) & cast<long>(255));
                        pos = pos + 1;
                    }
                    i = i + 5;
                }
                return out;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Fletcher-16 checksum (spec 4) over a string's bytes: two running mod-255 sums combined as a 16-bit
        // value. Cheaper than CRC with good error detection.
        public class Fletcher {
            public static method fletcher16(String data) returns int {
                mutable int s1 = 0;
                mutable int s2 = 0;
                for (mutable int i = 0; i < data.length(); i++) {
                    s1 = (s1 + (cast<int>(data.charAt(i)) & 255)) % 255;
                    s2 = (s2 + s1) % 255;
                }
                return (s2 << 8) | s1;
            }
        }
        // Non-cryptographic checksums and hashes over a string's bytes (spec 4): CRC-32 (reflected, the
        // zip/png polynomial) and 32-bit FNV-1a. Uses unsigned 32-bit arithmetic, which wraps and shifts
        // logically. Returned as int (the same 32 bits reinterpreted).
        public class Digest {
            public static method crc32(String data) returns int {
                mutable uint crc = cast<uint>(4294967295);
                uint poly = cast<uint>(3988292384);
                for (mutable int i = 0; i < data.length(); i++) {
                    crc = crc ^ cast<uint>(cast<int>(data.charAt(i)));
                    for (mutable int b = 0; b < 8; b++) {
                        if ((crc & cast<uint>(1)) != cast<uint>(0)) { crc = (crc >> 1) ^ poly; }
                        else { crc = crc >> 1; }
                    }
                }
                crc = crc ^ cast<uint>(4294967295);
                return cast<int>(crc);
            }
            public static method fnv1a(String data) returns int {
                mutable uint h = cast<uint>(2166136261);
                uint prime = cast<uint>(16777619);
                for (mutable int i = 0; i < data.length(); i++) {
                    h = (h ^ cast<uint>(cast<int>(data.charAt(i)))) * prime;
                }
                return cast<int>(h);
            }
            // Adler-32 (the zlib checksum): two running sums modulo 65521, packed high-sum over low-sum.
            public static method adler32(String data) returns int {
                mutable uint a = cast<uint>(1);
                mutable uint b = cast<uint>(0);
                uint m = cast<uint>(65521);
                for (mutable int i = 0; i < data.length(); i++) {
                    a = (a + cast<uint>(cast<int>(data.charAt(i)))) % m;
                    b = (b + a) % m;
                }
                return cast<int>((b << 16) | a);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // SHA-256 cryptographic hash (FIPS 180-4), pure LDP3 over 32-bit unsigned arithmetic (spec 4). digest
        // returns the 64-character lowercase hex of the hash. The method is named digest, not hash, since hash
        // is the Hashable interface method.
        public class Sha256 {
            private static method rotr(uint x, int n) returns uint { return (x >> n) | (x << (32 - n)); }
            private static method putWord(int[] out, int off, uint w) returns void {
                out[off]   = cast<int>((w >> 24) & cast<uint>(255));
                out[off+1] = cast<int>((w >> 16) & cast<uint>(255));
                out[off+2] = cast<int>((w >> 8) & cast<uint>(255));
                out[off+3] = cast<int>(w & cast<uint>(255));
                return;
            }
            // Lowercase hex of the first n bytes of an int[] (each entry treated as a 0..255 byte).
            public static method toHex(int[] bytes, int n) returns String {
                String digs = "0123456789abcdef";
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < n; i++) {
                    int b = bytes[i] & 255;
                    sb.appendChar(digs.charAt((b >> 4) & 15));
                    sb.appendChar(digs.charAt(b & 15));
                }
                return sb.toString();
            }
            // Core: hash the first len bytes of data, returning the 32 raw output bytes (used by Hmac).
            public static method digestRaw(int[] data, int len) returns int[] {
                mutable int padded = len + 1;
                while (padded % 64 != 56) { padded = padded + 1; }
                padded = padded + 8;
                mutable int[] m = new int[padded]();
                for (mutable int i = 0; i < len; i++) { m[i] = data[i] & 255; }
                m[len] = 128;
                long bits = cast<long>(len) * cast<long>(8);
                for (mutable int i = 0; i < 8; i++) {
                    m[padded - 1 - i] = cast<int>((bits >> (i * 8)) & cast<long>(255));
                }
                mutable uint[] k = new uint[64]();
                k[0]=cast<uint>(0x428a2f98); k[1]=cast<uint>(0x71374491); k[2]=cast<uint>(0xb5c0fbcf); k[3]=cast<uint>(0xe9b5dba5);
                k[4]=cast<uint>(0x3956c25b); k[5]=cast<uint>(0x59f111f1); k[6]=cast<uint>(0x923f82a4); k[7]=cast<uint>(0xab1c5ed5);
                k[8]=cast<uint>(0xd807aa98); k[9]=cast<uint>(0x12835b01); k[10]=cast<uint>(0x243185be); k[11]=cast<uint>(0x550c7dc3);
                k[12]=cast<uint>(0x72be5d74); k[13]=cast<uint>(0x80deb1fe); k[14]=cast<uint>(0x9bdc06a7); k[15]=cast<uint>(0xc19bf174);
                k[16]=cast<uint>(0xe49b69c1); k[17]=cast<uint>(0xefbe4786); k[18]=cast<uint>(0x0fc19dc6); k[19]=cast<uint>(0x240ca1cc);
                k[20]=cast<uint>(0x2de92c6f); k[21]=cast<uint>(0x4a7484aa); k[22]=cast<uint>(0x5cb0a9dc); k[23]=cast<uint>(0x76f988da);
                k[24]=cast<uint>(0x983e5152); k[25]=cast<uint>(0xa831c66d); k[26]=cast<uint>(0xb00327c8); k[27]=cast<uint>(0xbf597fc7);
                k[28]=cast<uint>(0xc6e00bf3); k[29]=cast<uint>(0xd5a79147); k[30]=cast<uint>(0x06ca6351); k[31]=cast<uint>(0x14292967);
                k[32]=cast<uint>(0x27b70a85); k[33]=cast<uint>(0x2e1b2138); k[34]=cast<uint>(0x4d2c6dfc); k[35]=cast<uint>(0x53380d13);
                k[36]=cast<uint>(0x650a7354); k[37]=cast<uint>(0x766a0abb); k[38]=cast<uint>(0x81c2c92e); k[39]=cast<uint>(0x92722c85);
                k[40]=cast<uint>(0xa2bfe8a1); k[41]=cast<uint>(0xa81a664b); k[42]=cast<uint>(0xc24b8b70); k[43]=cast<uint>(0xc76c51a3);
                k[44]=cast<uint>(0xd192e819); k[45]=cast<uint>(0xd6990624); k[46]=cast<uint>(0xf40e3585); k[47]=cast<uint>(0x106aa070);
                k[48]=cast<uint>(0x19a4c116); k[49]=cast<uint>(0x1e376c08); k[50]=cast<uint>(0x2748774c); k[51]=cast<uint>(0x34b0bcb5);
                k[52]=cast<uint>(0x391c0cb3); k[53]=cast<uint>(0x4ed8aa4a); k[54]=cast<uint>(0x5b9cca4f); k[55]=cast<uint>(0x682e6ff3);
                k[56]=cast<uint>(0x748f82ee); k[57]=cast<uint>(0x78a5636f); k[58]=cast<uint>(0x84c87814); k[59]=cast<uint>(0x8cc70208);
                k[60]=cast<uint>(0x90befffa); k[61]=cast<uint>(0xa4506ceb); k[62]=cast<uint>(0xbef9a3f7); k[63]=cast<uint>(0xc67178f2);
                mutable uint h0=cast<uint>(0x6a09e667); mutable uint h1=cast<uint>(0xbb67ae85);
                mutable uint h2=cast<uint>(0x3c6ef372); mutable uint h3=cast<uint>(0xa54ff53a);
                mutable uint h4=cast<uint>(0x510e527f); mutable uint h5=cast<uint>(0x9b05688c);
                mutable uint h6=cast<uint>(0x1f83d9ab); mutable uint h7=cast<uint>(0x5be0cd19);
                mutable uint[] w = new uint[64]();
                mutable int blk = 0;
                while (blk < padded) {
                    for (mutable int t = 0; t < 16; t++) {
                        int b = blk + t * 4;
                        w[t] = (cast<uint>(m[b]) << 24) | (cast<uint>(m[b+1]) << 16)
                             | (cast<uint>(m[b+2]) << 8) | cast<uint>(m[b+3]);
                    }
                    for (mutable int t = 16; t < 64; t++) {
                        uint s0 = Sha256.rotr(w[t-15],7) ^ Sha256.rotr(w[t-15],18) ^ (w[t-15] >> 3);
                        uint s1 = Sha256.rotr(w[t-2],17) ^ Sha256.rotr(w[t-2],19) ^ (w[t-2] >> 10);
                        w[t] = w[t-16] + s0 + w[t-7] + s1;
                    }
                    mutable uint a=h0; mutable uint b2=h1; mutable uint c=h2; mutable uint d=h3;
                    mutable uint e=h4; mutable uint f=h5; mutable uint g=h6; mutable uint hh=h7;
                    for (mutable int t = 0; t < 64; t++) {
                        uint bigS1 = Sha256.rotr(e,6) ^ Sha256.rotr(e,11) ^ Sha256.rotr(e,25);
                        uint ch = (e & f) ^ ((~e) & g);
                        uint t1 = hh + bigS1 + ch + k[t] + w[t];
                        uint bigS0 = Sha256.rotr(a,2) ^ Sha256.rotr(a,13) ^ Sha256.rotr(a,22);
                        uint maj = (a & b2) ^ (a & c) ^ (b2 & c);
                        uint t2 = bigS0 + maj;
                        hh=g; g=f; f=e; e=d+t1; d=c; c=b2; b2=a; a=t1+t2;
                    }
                    h0=h0+a; h1=h1+b2; h2=h2+c; h3=h3+d; h4=h4+e; h5=h5+f; h6=h6+g; h7=h7+hh;
                    blk = blk + 64;
                }
                mutable int[] out = new int[32]();
                Sha256.putWord(out,0,h0); Sha256.putWord(out,4,h1); Sha256.putWord(out,8,h2); Sha256.putWord(out,12,h3);
                Sha256.putWord(out,16,h4); Sha256.putWord(out,20,h5); Sha256.putWord(out,24,h6); Sha256.putWord(out,28,h7);
                return out;
            }
            // Hash a String (bytes are charAt & 255) into the 64-character lowercase hex digest.
            public static method digest(String msg) returns String {
                int len = msg.length();
                mutable int[] data = new int[len + 1]();
                for (mutable int i = 0; i < len; i++) { data[i] = cast<int>(msg.charAt(i)) & 255; }
                return Sha256.toHex(Sha256.digestRaw(data, len), 32);
            }
            // Hash the first len bytes of an int[] into the lowercase hex digest.
            public static method digestBytes(int[] data, int len) returns String {
                return Sha256.toHex(Sha256.digestRaw(data, len), 32);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // HMAC-SHA256 keyed message authentication (RFC 2104), pure LDP3 on top of Sha256. sha256 returns the
        // lowercase hex of HMAC-SHA256(key, msg). Keys longer than the 64-byte block are hashed down first.
        public class Hmac {
            public static method sha256(String key, String msg) returns String {
                int B = 64;
                int klen = key.length();
                mutable int[] keyBytes = new int[klen + 1]();
                for (mutable int i = 0; i < klen; i++) { keyBytes[i] = cast<int>(key.charAt(i)) & 255; }
                mutable int[] kb = new int[B]();
                if (klen > B) {
                    int[] kh = Sha256.digestRaw(keyBytes, klen);
                    for (mutable int i = 0; i < 32; i++) { kb[i] = kh[i]; }
                } else {
                    for (mutable int i = 0; i < klen; i++) { kb[i] = keyBytes[i]; }
                }
                int mlen = msg.length();
                mutable int[] inner = new int[B + mlen]();
                for (mutable int i = 0; i < B; i++) { inner[i] = kb[i] ^ 54; }
                for (mutable int i = 0; i < mlen; i++) { inner[B + i] = cast<int>(msg.charAt(i)) & 255; }
                int[] ih = Sha256.digestRaw(inner, B + mlen);
                mutable int[] outer = new int[B + 32]();
                for (mutable int i = 0; i < B; i++) { outer[i] = kb[i] ^ 92; }
                for (mutable int i = 0; i < 32; i++) { outer[B + i] = ih[i]; }
                return Sha256.toHex(Sha256.digestRaw(outer, B + 32), 32);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // SHA-1 cryptographic hash (FIPS 180-1), pure LDP3 over 32-bit unsigned arithmetic. digest returns the
        // 40-character lowercase hex. (SHA-1 is broken for collision resistance; provided for legacy interop
        // such as Git object ids.) Reuses Sha256.putWord/toHex for the byte/hex plumbing.
        public class Sha1 {
            private static method rotl(uint x, int n) returns uint { return (x << n) | (x >> (32 - n)); }
            public static method digestRaw(int[] data, int len) returns int[] {
                mutable int padded = len + 1;
                while (padded % 64 != 56) { padded = padded + 1; }
                padded = padded + 8;
                mutable int[] m = new int[padded]();
                for (mutable int i = 0; i < len; i++) { m[i] = data[i] & 255; }
                m[len] = 128;
                long bits = cast<long>(len) * cast<long>(8);
                for (mutable int i = 0; i < 8; i++) {
                    m[padded - 1 - i] = cast<int>((bits >> (i * 8)) & cast<long>(255));
                }
                mutable uint h0 = cast<uint>(0x67452301); mutable uint h1 = cast<uint>(0xEFCDAB89);
                mutable uint h2 = cast<uint>(0x98BADCFE); mutable uint h3 = cast<uint>(0x10325476);
                mutable uint h4 = cast<uint>(0xC3D2E1F0);
                mutable uint[] w = new uint[80]();
                mutable int blk = 0;
                while (blk < padded) {
                    for (mutable int t = 0; t < 16; t++) {
                        int b = blk + t * 4;
                        w[t] = (cast<uint>(m[b]) << 24) | (cast<uint>(m[b+1]) << 16)
                             | (cast<uint>(m[b+2]) << 8) | cast<uint>(m[b+3]);
                    }
                    for (mutable int t = 16; t < 80; t++) {
                        w[t] = Sha1.rotl(w[t-3] ^ w[t-8] ^ w[t-14] ^ w[t-16], 1);
                    }
                    mutable uint a = h0; mutable uint b2 = h1; mutable uint c = h2; mutable uint d = h3; mutable uint e = h4;
                    for (mutable int t = 0; t < 80; t++) {
                        mutable uint f = cast<uint>(0);
                        mutable uint k = cast<uint>(0);
                        if (t < 20) { f = (b2 & c) | ((~b2) & d); k = cast<uint>(0x5A827999); }
                        else {
                            if (t < 40) { f = b2 ^ c ^ d; k = cast<uint>(0x6ED9EBA1); }
                            else {
                                if (t < 60) { f = (b2 & c) | (b2 & d) | (c & d); k = cast<uint>(0x8F1BBCDC); }
                                else { f = b2 ^ c ^ d; k = cast<uint>(0xCA62C1D6); }
                            }
                        }
                        uint tmp = Sha1.rotl(a, 5) + f + e + k + w[t];
                        e = d; d = c; c = Sha1.rotl(b2, 30); b2 = a; a = tmp;
                    }
                    h0 = h0 + a; h1 = h1 + b2; h2 = h2 + c; h3 = h3 + d; h4 = h4 + e;
                    blk = blk + 64;
                }
                mutable int[] out = new int[20]();
                Sha256.putWord(out, 0, h0); Sha256.putWord(out, 4, h1); Sha256.putWord(out, 8, h2);
                Sha256.putWord(out, 12, h3); Sha256.putWord(out, 16, h4);
                return out;
            }
            public static method digest(String msg) returns String {
                int len = msg.length();
                mutable int[] data = new int[len + 1]();
                for (mutable int i = 0; i < len; i++) { data[i] = cast<int>(msg.charAt(i)) & 255; }
                return Sha256.toHex(Sha1.digestRaw(data, len), 20);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // SHA-224 (FIPS 180-4), the SHA-256 compression with different initial hash values and a 28-byte
        // (56 hex char) output. Reuses Sha256.rotr/putWord/toHex; the round constants match SHA-256.
        public class Sha224 {
            public static method digest(String msg) returns String {
                int len = msg.length();
                mutable int padded = len + 1;
                while (padded % 64 != 56) { padded = padded + 1; }
                padded = padded + 8;
                mutable int[] m = new int[padded]();
                for (mutable int i = 0; i < len; i++) { m[i] = cast<int>(msg.charAt(i)) & 255; }
                m[len] = 128;
                long bits = cast<long>(len) * cast<long>(8);
                for (mutable int i = 0; i < 8; i++) {
                    m[padded - 1 - i] = cast<int>((bits >> (i * 8)) & cast<long>(255));
                }
                mutable uint[] k = new uint[64]();
                k[0]=cast<uint>(0x428a2f98); k[1]=cast<uint>(0x71374491); k[2]=cast<uint>(0xb5c0fbcf); k[3]=cast<uint>(0xe9b5dba5);
                k[4]=cast<uint>(0x3956c25b); k[5]=cast<uint>(0x59f111f1); k[6]=cast<uint>(0x923f82a4); k[7]=cast<uint>(0xab1c5ed5);
                k[8]=cast<uint>(0xd807aa98); k[9]=cast<uint>(0x12835b01); k[10]=cast<uint>(0x243185be); k[11]=cast<uint>(0x550c7dc3);
                k[12]=cast<uint>(0x72be5d74); k[13]=cast<uint>(0x80deb1fe); k[14]=cast<uint>(0x9bdc06a7); k[15]=cast<uint>(0xc19bf174);
                k[16]=cast<uint>(0xe49b69c1); k[17]=cast<uint>(0xefbe4786); k[18]=cast<uint>(0x0fc19dc6); k[19]=cast<uint>(0x240ca1cc);
                k[20]=cast<uint>(0x2de92c6f); k[21]=cast<uint>(0x4a7484aa); k[22]=cast<uint>(0x5cb0a9dc); k[23]=cast<uint>(0x76f988da);
                k[24]=cast<uint>(0x983e5152); k[25]=cast<uint>(0xa831c66d); k[26]=cast<uint>(0xb00327c8); k[27]=cast<uint>(0xbf597fc7);
                k[28]=cast<uint>(0xc6e00bf3); k[29]=cast<uint>(0xd5a79147); k[30]=cast<uint>(0x06ca6351); k[31]=cast<uint>(0x14292967);
                k[32]=cast<uint>(0x27b70a85); k[33]=cast<uint>(0x2e1b2138); k[34]=cast<uint>(0x4d2c6dfc); k[35]=cast<uint>(0x53380d13);
                k[36]=cast<uint>(0x650a7354); k[37]=cast<uint>(0x766a0abb); k[38]=cast<uint>(0x81c2c92e); k[39]=cast<uint>(0x92722c85);
                k[40]=cast<uint>(0xa2bfe8a1); k[41]=cast<uint>(0xa81a664b); k[42]=cast<uint>(0xc24b8b70); k[43]=cast<uint>(0xc76c51a3);
                k[44]=cast<uint>(0xd192e819); k[45]=cast<uint>(0xd6990624); k[46]=cast<uint>(0xf40e3585); k[47]=cast<uint>(0x106aa070);
                k[48]=cast<uint>(0x19a4c116); k[49]=cast<uint>(0x1e376c08); k[50]=cast<uint>(0x2748774c); k[51]=cast<uint>(0x34b0bcb5);
                k[52]=cast<uint>(0x391c0cb3); k[53]=cast<uint>(0x4ed8aa4a); k[54]=cast<uint>(0x5b9cca4f); k[55]=cast<uint>(0x682e6ff3);
                k[56]=cast<uint>(0x748f82ee); k[57]=cast<uint>(0x78a5636f); k[58]=cast<uint>(0x84c87814); k[59]=cast<uint>(0x8cc70208);
                k[60]=cast<uint>(0x90befffa); k[61]=cast<uint>(0xa4506ceb); k[62]=cast<uint>(0xbef9a3f7); k[63]=cast<uint>(0xc67178f2);
                mutable uint h0=cast<uint>(0xc1059ed8); mutable uint h1=cast<uint>(0x367cd507);
                mutable uint h2=cast<uint>(0x3070dd17); mutable uint h3=cast<uint>(0xf70e5939);
                mutable uint h4=cast<uint>(0xffc00b31); mutable uint h5=cast<uint>(0x68581511);
                mutable uint h6=cast<uint>(0x64f98fa7); mutable uint h7=cast<uint>(0xbefa4fa4);
                mutable uint[] w = new uint[64]();
                mutable int blk = 0;
                while (blk < padded) {
                    for (mutable int t = 0; t < 16; t++) {
                        int b = blk + t * 4;
                        w[t] = (cast<uint>(m[b]) << 24) | (cast<uint>(m[b+1]) << 16)
                             | (cast<uint>(m[b+2]) << 8) | cast<uint>(m[b+3]);
                    }
                    for (mutable int t = 16; t < 64; t++) {
                        uint s0 = Sha256.rotr(w[t-15],7) ^ Sha256.rotr(w[t-15],18) ^ (w[t-15] >> 3);
                        uint s1 = Sha256.rotr(w[t-2],17) ^ Sha256.rotr(w[t-2],19) ^ (w[t-2] >> 10);
                        w[t] = w[t-16] + s0 + w[t-7] + s1;
                    }
                    mutable uint a=h0; mutable uint b2=h1; mutable uint c=h2; mutable uint d=h3;
                    mutable uint e=h4; mutable uint f=h5; mutable uint g=h6; mutable uint hh=h7;
                    for (mutable int t = 0; t < 64; t++) {
                        uint bigS1 = Sha256.rotr(e,6) ^ Sha256.rotr(e,11) ^ Sha256.rotr(e,25);
                        uint ch = (e & f) ^ ((~e) & g);
                        uint t1 = hh + bigS1 + ch + k[t] + w[t];
                        uint bigS0 = Sha256.rotr(a,2) ^ Sha256.rotr(a,13) ^ Sha256.rotr(a,22);
                        uint maj = (a & b2) ^ (a & c) ^ (b2 & c);
                        uint t2 = bigS0 + maj;
                        hh=g; g=f; f=e; e=d+t1; d=c; c=b2; b2=a; a=t1+t2;
                    }
                    h0=h0+a; h1=h1+b2; h2=h2+c; h3=h3+d; h4=h4+e; h5=h5+f; h6=h6+g; h7=h7+hh;
                    blk = blk + 64;
                }
                mutable int[] out = new int[28]();
                Sha256.putWord(out,0,h0); Sha256.putWord(out,4,h1); Sha256.putWord(out,8,h2);
                Sha256.putWord(out,12,h3); Sha256.putWord(out,16,h4); Sha256.putWord(out,20,h5);
                Sha256.putWord(out,24,h6);
                return Sha256.toHex(out, 28);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // MD5 message digest (RFC 1321), pure LDP3 over 32-bit unsigned arithmetic (little-endian, unlike the
        // SHA family). digest returns the 32-character lowercase hex. (MD5 is broken for collision resistance;
        // provided for legacy interop/checksums only.) Reuses Sha256.toHex for the final hex.
        public class Md5 {
            private static method rotl(uint x, int n) returns uint { return (x << n) | (x >> (32 - n)); }
            private static method putLE(int[] out, int off, uint w) returns void {
                out[off]   = cast<int>(w & cast<uint>(255));
                out[off+1] = cast<int>((w >> 8) & cast<uint>(255));
                out[off+2] = cast<int>((w >> 16) & cast<uint>(255));
                out[off+3] = cast<int>((w >> 24) & cast<uint>(255));
                return;
            }
            public static method digest(String msg) returns String {
                int len = msg.length();
                mutable int padded = len + 1;
                while (padded % 64 != 56) { padded = padded + 1; }
                padded = padded + 8;
                mutable int[] m = new int[padded]();
                for (mutable int i = 0; i < len; i++) { m[i] = cast<int>(msg.charAt(i)) & 255; }
                m[len] = 128;
                long bitLen = cast<long>(len) * cast<long>(8);
                for (mutable int i = 0; i < 8; i++) {
                    m[padded - 8 + i] = cast<int>((bitLen >> (i * 8)) & cast<long>(255));
                }
                mutable int[] s = new int[64]();
                int[] sv = new int[16]();
                sv[0]=7; sv[1]=12; sv[2]=17; sv[3]=22; sv[4]=5; sv[5]=9; sv[6]=14; sv[7]=20;
                sv[8]=4; sv[9]=11; sv[10]=16; sv[11]=23; sv[12]=6; sv[13]=10; sv[14]=15; sv[15]=21;
                for (mutable int i = 0; i < 64; i++) {
                    int grp = i / 16;
                    s[i] = sv[grp * 4 + (i % 4)];
                }
                mutable uint[] k = new uint[64]();
                k[0]=cast<uint>(0xd76aa478); k[1]=cast<uint>(0xe8c7b756); k[2]=cast<uint>(0x242070db); k[3]=cast<uint>(0xc1bdceee);
                k[4]=cast<uint>(0xf57c0faf); k[5]=cast<uint>(0x4787c62a); k[6]=cast<uint>(0xa8304613); k[7]=cast<uint>(0xfd469501);
                k[8]=cast<uint>(0x698098d8); k[9]=cast<uint>(0x8b44f7af); k[10]=cast<uint>(0xffff5bb1); k[11]=cast<uint>(0x895cd7be);
                k[12]=cast<uint>(0x6b901122); k[13]=cast<uint>(0xfd987193); k[14]=cast<uint>(0xa679438e); k[15]=cast<uint>(0x49b40821);
                k[16]=cast<uint>(0xf61e2562); k[17]=cast<uint>(0xc040b340); k[18]=cast<uint>(0x265e5a51); k[19]=cast<uint>(0xe9b6c7aa);
                k[20]=cast<uint>(0xd62f105d); k[21]=cast<uint>(0x02441453); k[22]=cast<uint>(0xd8a1e681); k[23]=cast<uint>(0xe7d3fbc8);
                k[24]=cast<uint>(0x21e1cde6); k[25]=cast<uint>(0xc33707d6); k[26]=cast<uint>(0xf4d50d87); k[27]=cast<uint>(0x455a14ed);
                k[28]=cast<uint>(0xa9e3e905); k[29]=cast<uint>(0xfcefa3f8); k[30]=cast<uint>(0x676f02d9); k[31]=cast<uint>(0x8d2a4c8a);
                k[32]=cast<uint>(0xfffa3942); k[33]=cast<uint>(0x8771f681); k[34]=cast<uint>(0x6d9d6122); k[35]=cast<uint>(0xfde5380c);
                k[36]=cast<uint>(0xa4beea44); k[37]=cast<uint>(0x4bdecfa9); k[38]=cast<uint>(0xf6bb4b60); k[39]=cast<uint>(0xbebfbc70);
                k[40]=cast<uint>(0x289b7ec6); k[41]=cast<uint>(0xeaa127fa); k[42]=cast<uint>(0xd4ef3085); k[43]=cast<uint>(0x04881d05);
                k[44]=cast<uint>(0xd9d4d039); k[45]=cast<uint>(0xe6db99e5); k[46]=cast<uint>(0x1fa27cf8); k[47]=cast<uint>(0xc4ac5665);
                k[48]=cast<uint>(0xf4292244); k[49]=cast<uint>(0x432aff97); k[50]=cast<uint>(0xab9423a7); k[51]=cast<uint>(0xfc93a039);
                k[52]=cast<uint>(0x655b59c3); k[53]=cast<uint>(0x8f0ccc92); k[54]=cast<uint>(0xffeff47d); k[55]=cast<uint>(0x85845dd1);
                k[56]=cast<uint>(0x6fa87e4f); k[57]=cast<uint>(0xfe2ce6e0); k[58]=cast<uint>(0xa3014314); k[59]=cast<uint>(0x4e0811a1);
                k[60]=cast<uint>(0xf7537e82); k[61]=cast<uint>(0xbd3af235); k[62]=cast<uint>(0x2ad7d2bb); k[63]=cast<uint>(0xeb86d391);
                mutable uint a0 = cast<uint>(0x67452301); mutable uint b0 = cast<uint>(0xefcdab89);
                mutable uint c0 = cast<uint>(0x98badcfe); mutable uint d0 = cast<uint>(0x10325476);
                mutable uint[] w = new uint[16]();
                mutable int blk = 0;
                while (blk < padded) {
                    for (mutable int t = 0; t < 16; t++) {
                        int b = blk + t * 4;
                        w[t] = cast<uint>(m[b]) | (cast<uint>(m[b+1]) << 8)
                             | (cast<uint>(m[b+2]) << 16) | (cast<uint>(m[b+3]) << 24);
                    }
                    mutable uint a = a0; mutable uint b2 = b0; mutable uint c = c0; mutable uint d = d0;
                    for (mutable int i = 0; i < 64; i++) {
                        mutable uint f = cast<uint>(0);
                        mutable int g = 0;
                        if (i < 16) { f = (b2 & c) | ((~b2) & d); g = i; }
                        else {
                            if (i < 32) { f = (d & b2) | ((~d) & c); g = (5 * i + 1) % 16; }
                            else {
                                if (i < 48) { f = b2 ^ c ^ d; g = (3 * i + 5) % 16; }
                                else { f = c ^ (b2 | (~d)); g = (7 * i) % 16; }
                            }
                        }
                        f = f + a + k[i] + w[g];
                        a = d; d = c; c = b2;
                        b2 = b2 + Md5.rotl(f, s[i]);
                    }
                    a0 = a0 + a; b0 = b0 + b2; c0 = c0 + c; d0 = d0 + d;
                    blk = blk + 64;
                }
                mutable int[] out = new int[16]();
                Md5.putLE(out, 0, a0); Md5.putLE(out, 4, b0); Md5.putLE(out, 8, c0); Md5.putLE(out, 12, d0);
                return Sha256.toHex(out, 16);
            }
        }
        // CRC-16/XMODEM (spec 4): a 16-bit checksum over a string's bytes with polynomial 0x1021 and zero
        // initial value, returned as an int. Bitwise, table-free.
        public class Crc {
            public static method crc16(String data) returns int {
                mutable int crc = 0;
                int n = data.length();
                for (mutable int i = 0; i < n; i++) {
                    crc = crc ^ ((cast<int>(data.charAt(i)) & 255) << 8);
                    for (mutable int b = 0; b < 8; b++) {
                        if ((crc & 32768) != 0) { crc = ((crc << 1) ^ 4129) & 65535; }
                        else { crc = (crc << 1) & 65535; }
                    }
                }
                return crc;
            }
        }
        // Adler-32 checksum (RFC 1950 / zlib): two running sums modulo 65521 combined as (b << 16) | a, with
        // a starting at 1. Faster than CRC but weaker; returned in a long so the high bit stays positive.
        public class Adler32 {
            public static method checksum(String data) returns long {
                mutable long a = 1;
                mutable long b = 0;
                long mod = 65521;
                for (mutable int i = 0; i < data.length(); i++) {
                    a = (a + cast<long>(cast<int>(data.charAt(i)) & 255)) % mod;
                    b = (b + a) % mod;
                }
                return (b << 16) | a;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // A Bloom filter: a probabilistic set that never misses a member but may report a false positive
        // (spec 34.1). Two independent hashes (FNV-1a and CRC-32 from Digest) set and test bits in a fixed
        // bit array. mightContain returning false is definitive; true means probably present.
        public class BloomFilter {
            private mutable boolean[] bits;
            private mutable int m;
            public constructor BloomFilter(int size) {
                this.m = size;
                this.bits = new boolean[size]();
            }
            private method idx(int h) returns int {
                int r = h % this.m;
                if (r < 0) { return r + this.m; }
                return r;
            }
            public method add(String key) returns void {
                this.bits[this.idx(Digest.fnv1a(key))] = true;
                this.bits[this.idx(Digest.crc32(key))] = true;
                return;
            }
            public method mightContain(String key) returns boolean {
                return this.bits[this.idx(Digest.fnv1a(key))] && this.bits[this.idx(Digest.crc32(key))];
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Huffman coding (spec 34.1): builds an optimal prefix code from a string's byte frequencies and
        // packs it into a tree stored in flat arena arrays (no self-referential pointers). encode turns the
        // text into a '0'/'1' bit string; decode walks the tree to recover it. Construct once over the source
        // text, then encode/decode against that codebook. Two smallest nodes are merged each step (ties by
        // lowest id) for a deterministic tree, so a round-trip always reproduces the input exactly.
        public class Huffman {
            private mutable int[] freq;
            private mutable int[] left;
            private mutable int[] right;
            private mutable int[] parent;
            private mutable int[] bit;
            private mutable int[] sym;
            private mutable int count;
            private mutable int root;
            private mutable String[] codes;

            public constructor Huffman(String data) {
                this.freq = new int[512]();
                this.left = new int[512]();
                this.right = new int[512]();
                this.parent = new int[512]();
                this.bit = new int[512]();
                this.sym = new int[512]();
                this.codes = new String[256]();
                mutable boolean[] alive = new boolean[512]();
                mutable int[] cnt = new int[256]();
                int n = data.length();
                for (mutable int i = 0; i < n; i++) {
                    int ch = cast<int>(data.charAt(i)) & 255;
                    cnt[ch] = cnt[ch] + 1;
                }
                this.count = 0;
                for (mutable int b = 0; b < 256; b++) {
                    if (cnt[b] > 0) {
                        int id = this.count;
                        this.freq[id] = cnt[b];
                        this.sym[id] = b;
                        this.left[id] = -1;
                        this.right[id] = -1;
                        this.parent[id] = -1;
                        alive[id] = true;
                        this.count = id + 1;
                    }
                }
                mutable int live = this.count;
                this.root = 0;
                while (live > 1) {
                    mutable int a = -1;
                    mutable int b2 = -1;
                    for (mutable int i = 0; i < this.count; i++) {
                        if (alive[i]) {
                            if (a == -1) { a = i; }
                            else {
                                if (this.freq[i] < this.freq[a]) { b2 = a; a = i; }
                                else {
                                    if (b2 == -1) { b2 = i; }
                                    else { if (this.freq[i] < this.freq[b2]) { b2 = i; } }
                                }
                            }
                        }
                    }
                    int id = this.count;
                    this.freq[id] = this.freq[a] + this.freq[b2];
                    this.left[id] = a;
                    this.right[id] = b2;
                    this.sym[id] = -1;
                    this.parent[id] = -1;
                    this.parent[a] = id;
                    this.bit[a] = 0;
                    this.parent[b2] = id;
                    this.bit[b2] = 1;
                    alive[a] = false;
                    alive[b2] = false;
                    alive[id] = true;
                    this.count = id + 1;
                    this.root = id;
                    live = live - 1;
                }
                for (mutable int i = 0; i < this.count; i++) {
                    if (this.left[i] == -1) {
                        mutable int[] tmp = new int[64]();
                        mutable int d = 0;
                        mutable int node = i;
                        while (this.parent[node] != -1) {
                            tmp[d] = this.bit[node];
                            d = d + 1;
                            node = this.parent[node];
                        }
                        mutable StringBuilder sb = new StringBuilder() on heap;
                        if (d == 0) { sb.appendChar('0'); }
                        for (mutable int j = d - 1; j >= 0; j = j - 1) {
                            if (tmp[j] == 0) { sb.appendChar('0'); } else { sb.appendChar('1'); }
                        }
                        this.codes[this.sym[i]] = sb.toString();
                    }
                }
                return;
            }
            // The '0'/'1' code assigned to a byte value (empty string for bytes not in the source).
            public method codeOf(int byteValue) returns String { return this.codes[byteValue & 255]; }
            public method encode(String data) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                int n = data.length();
                for (mutable int i = 0; i < n; i++) {
                    sb.append(this.codes[cast<int>(data.charAt(i)) & 255]);
                }
                return sb.toString();
            }
            public method decode(String bits) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                int n = bits.length();
                if (this.left[this.root] == -1) {
                    for (mutable int i = 0; i < n; i++) { sb.appendChar(cast<char>(this.sym[this.root])); }
                    return sb.toString();
                }
                mutable int node = this.root;
                for (mutable int i = 0; i < n; i++) {
                    if (bits.charAt(i) == '0') { node = this.left[node]; } else { node = this.right[node]; }
                    if (this.left[node] == -1) {
                        sb.appendChar(cast<char>(this.sym[node]));
                        node = this.root;
                    }
                }
                return sb.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // LZ77 sliding-window compression (spec 34.1): encode produces flattened (offset, length, nextChar)
        // triples over a bounded search window (nextChar is -1 only at the very end); decode replays them,
        // copying back-references (which may overlap, like run-length) to reconstruct the input exactly.
        public class Lz77 {
            private mutable int window;
            public constructor Lz77(int windowSize) { this.window = windowSize; }
            public method encode(String data) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                int n = data.length();
                mutable int i = 0;
                while (i < n) {
                    mutable int bestLen = 0;
                    mutable int bestOff = 0;
                    mutable int start = i - this.window;
                    if (start < 0) { start = 0; }
                    for (mutable int j = start; j < i; j++) {
                        mutable int len = 0;
                        while (i + len < n && len < 255 && data.charAt(j + len) == data.charAt(i + len)) {
                            len = len + 1;
                        }
                        if (len > bestLen) { bestLen = len; bestOff = i - j; }
                    }
                    int nextPos = i + bestLen;
                    out.add(bestOff);
                    out.add(bestLen);
                    if (nextPos < n) {
                        out.add(cast<int>(data.charAt(nextPos)) & 255);
                        i = nextPos + 1;
                    } else {
                        out.add(-1);
                        i = nextPos;
                    }
                }
                return out;
            }
            public method decode(ArrayList<int> tokens) returns String {
                mutable int total = 0;
                mutable int t = 0;
                while (t < tokens.size()) {
                    total = total + tokens.get(t + 1);
                    if (tokens.get(t + 2) >= 0) { total = total + 1; }
                    t = t + 3;
                }
                mutable int[] buf = new int[total + 1]();
                mutable int pos = 0;
                t = 0;
                while (t < tokens.size()) {
                    int off = tokens.get(t);
                    int len = tokens.get(t + 1);
                    int ch = tokens.get(t + 2);
                    int base = pos - off;
                    for (mutable int k = 0; k < len; k++) { buf[pos] = buf[base + k]; pos = pos + 1; }
                    if (ch >= 0) { buf[pos] = ch; pos = pos + 1; }
                    t = t + 3;
                }
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < pos; i++) { sb.appendChar(cast<char>(buf[i])); }
                return sb.toString();
            }
        }
        // Soundex phonetic encoding (spec 34): maps a name to a letter followed by three digits so that
        // similar-sounding names share a code (e.g. Robert and Rupert both give R163). Vowels reset run
        // detection; h and w are transparent between equal-coded consonants.
        public class Soundex {
            private static method digit(char c) returns int {
                if (c == 'b' || c == 'f' || c == 'p' || c == 'v') { return 1; }
                if (c == 'c' || c == 'g' || c == 'j' || c == 'k' || c == 'q' || c == 's' || c == 'x' || c == 'z') { return 2; }
                if (c == 'd' || c == 't') { return 3; }
                if (c == 'l') { return 4; }
                if (c == 'm' || c == 'n') { return 5; }
                if (c == 'r') { return 6; }
                return 0;
            }
            private static method lower(char c) returns char {
                if (c >= 'A' && c <= 'Z') { return cast<char>(cast<int>(c) + 32); }
                return c;
            }
            private static method upper(char c) returns char {
                if (c >= 'a' && c <= 'z') { return cast<char>(cast<int>(c) - 32); }
                return c;
            }
            public static method encode(String name) returns String {
                if (name.length() == 0) { return ""; }
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.appendChar(Soundex.upper(name.charAt(0)));
                mutable int prev = Soundex.digit(Soundex.lower(name.charAt(0)));
                mutable int count = 1;
                mutable int i = 1;
                while (i < name.length() && count < 4) {
                    char c = Soundex.lower(name.charAt(i));
                    if (c == 'h' || c == 'w') {
                        i = i + 1;
                    } else {
                        int d = Soundex.digit(c);
                        if (d != 0 && d != prev) { sb.appendInt(d); count = count + 1; }
                        prev = d;
                        i = i + 1;
                    }
                }
                while (count < 4) { sb.appendChar('0'); count = count + 1; }
                return sb.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Knuth-Morris-Pratt substring search (spec 34.1): a failure table (longest proper prefix that is also
        // a suffix) lets the scan never re-read text. indexOf returns the first match or -1; count reports
        // occurrences, counting overlaps.
        public class Kmp {
            private static method buildLps(String p) returns int[] {
                int m = p.length();
                mutable int[] lps = new int[m + 1]();
                mutable int len = 0;
                mutable int i = 1;
                while (i < m) {
                    if (p.charAt(i) == p.charAt(len)) {
                        len = len + 1; lps[i] = len; i = i + 1;
                    } else {
                        if (len != 0) { len = lps[len - 1]; }
                        else { lps[i] = 0; i = i + 1; }
                    }
                }
                return lps;
            }
            public static method indexOf(String text, String pattern) returns int {
                int n = text.length();
                int m = pattern.length();
                if (m == 0) { return 0; }
                int[] lps = Kmp.buildLps(pattern);
                mutable int i = 0;
                mutable int j = 0;
                while (i < n) {
                    if (text.charAt(i) == pattern.charAt(j)) {
                        i = i + 1; j = j + 1;
                        if (j == m) { return i - m; }
                    } else {
                        if (j != 0) { j = lps[j - 1]; }
                        else { i = i + 1; }
                    }
                }
                return -1;
            }
            public static method count(String text, String pattern) returns int {
                int n = text.length();
                int m = pattern.length();
                if (m == 0) { return 0; }
                int[] lps = Kmp.buildLps(pattern);
                mutable int i = 0;
                mutable int j = 0;
                mutable int total = 0;
                while (i < n) {
                    if (text.charAt(i) == pattern.charAt(j)) {
                        i = i + 1; j = j + 1;
                        if (j == m) { total = total + 1; j = lps[j - 1]; }
                    } else {
                        if (j != 0) { j = lps[j - 1]; }
                        else { i = i + 1; }
                    }
                }
                return total;
            }
        }
        // Manacher's algorithm (spec 34.1): the length of the longest palindromic substring in linear time,
        // over a transformed array with sentinels so odd and even palindromes are handled uniformly.
        public class Manacher {
            public static method longestPalindrome(String s) returns int {
                int n = s.length();
                if (n == 0) { return 0; }
                int t = 2 * n + 3;
                mutable int[] c = new int[t]();
                c[0] = 1;
                c[t - 1] = 2;
                for (mutable int i = 0; i < n; i++) {
                    c[2 + 2*i] = cast<int>(s.charAt(i)) & 255;
                    c[1 + 2*i] = 3;
                }
                c[t - 2] = 3;
                mutable int[] p = new int[t]();
                mutable int center = 0;
                mutable int right = 0;
                mutable int best = 0;
                for (mutable int i = 1; i < t - 1; i++) {
                    if (i < right) {
                        int mirror = 2 * center - i;
                        int span = right - i;
                        if (p[mirror] < span) { p[i] = p[mirror]; } else { p[i] = span; }
                    }
                    while (c[i + p[i] + 1] == c[i - p[i] - 1]) { p[i] = p[i] + 1; }
                    if (i + p[i] > right) { center = i; right = i + p[i]; }
                    if (p[i] > best) { best = p[i]; }
                }
                return best;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Run-length encoding of a string (spec 34): each run of a repeated character becomes that character
        // followed by its decimal count, e.g. "aaabbbbc" -> "a3b4c1". decode reverses it, reading a
        // character and the digits that follow as a repeat count.
        public class Rle {
            public static method encode(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                while (i < s.length()) {
                    char c = s.charAt(i);
                    mutable int run = 1;
                    while (i + run < s.length() && s.charAt(i + run) == c) { run = run + 1; }
                    sb.appendChar(c);
                    sb.appendInt(run);
                    i = i + run;
                }
                return sb.toString();
            }
            public static method decode(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                while (i < s.length()) {
                    char c = s.charAt(i);
                    i = i + 1;
                    mutable int count = 0;
                    while (i < s.length() && s.charAt(i) >= '0' && s.charAt(i) <= '9') {
                        count = count * 10 + (cast<int>(s.charAt(i)) - cast<int>('0'));
                        i = i + 1;
                    }
                    for (mutable int k = 0; k < count; k++) { sb.appendChar(c); }
                }
                return sb.toString();
            }
        }
        // Evaluates an integer arithmetic expression (spec 34): + - * / with the usual precedence and
        // parentheses, by recursive descent. Spaces are ignored; division truncates toward zero.
        public class Calculator {
            private mutable String s;
            private mutable int pos;
            public constructor Calculator(String expr) {
                this.s = expr;
                this.pos = 0;
            }
            private method peek() returns char {
                if (this.pos < this.s.length()) { return this.s.charAt(this.pos); }
                return cast<char>(0);
            }
            private method skip() returns void {
                while (this.pos < this.s.length() && this.s.charAt(this.pos) == ' ') { this.pos = this.pos + 1; }
                return;
            }
            private method factor() returns int {
                this.skip();
                if (this.peek() == '(') {
                    this.pos = this.pos + 1;
                    int v = this.expr();
                    this.skip();
                    this.pos = this.pos + 1;
                    return v;
                }
                mutable int n = 0;
                while (this.peek() >= '0' && this.peek() <= '9') {
                    n = n * 10 + (cast<int>(this.peek()) - cast<int>('0'));
                    this.pos = this.pos + 1;
                }
                return n;
            }
            private method term() returns int {
                mutable int v = this.factor();
                this.skip();
                while (this.peek() == '*' || this.peek() == '/') {
                    char op = this.peek();
                    this.pos = this.pos + 1;
                    int r = this.factor();
                    this.skip();
                    if (op == '*') { v = v * r; } else { v = v / r; }
                }
                return v;
            }
            private method expr() returns int {
                mutable int v = this.term();
                this.skip();
                while (this.peek() == '+' || this.peek() == '-') {
                    char op = this.peek();
                    this.pos = this.pos + 1;
                    int r = this.term();
                    this.skip();
                    if (op == '+') { v = v + r; } else { v = v - r; }
                }
                return v;
            }
            public method evaluate() returns int {
                this.pos = 0;
                return this.expr();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Reverse Polish (postfix) evaluator (spec 34): tokens are space-separated integers and the operators
        // + - * / %, evaluated with an operand stack. Complements the infix Calculator.
        public class Rpn {
            private static method parseTok(String t) returns int {
                mutable int i = 0;
                mutable boolean neg = false;
                if (t.charAt(0) == '-') { neg = true; i = 1; }
                mutable int v = 0;
                while (i < t.length()) { v = v * 10 + (cast<int>(t.charAt(i)) - cast<int>('0')); i = i + 1; }
                if (neg) { return 0 - v; }
                return v;
            }
            private static method isNumber(String t) returns boolean {
                char c = t.charAt(0);
                if (c >= '0' && c <= '9') { return true; }
                return c == '-' && t.length() > 1;
            }
            public static method eval(String expr) returns int {
                ArrayList<String> toks = Strings.split(expr, " ");
                mutable int[] st = new int[toks.size() + 1]();
                mutable int sp = 0;
                for (mutable int i = 0; i < toks.size(); i++) {
                    String t = toks.get(i);
                    if (t.length() == 0) { continue; }
                    if (Rpn.isNumber(t)) { st[sp] = Rpn.parseTok(t); sp = sp + 1; }
                    else {
                        int b = st[sp - 1]; int a = st[sp - 2]; sp = sp - 2;
                        char op = t.charAt(0);
                        mutable int r = 0;
                        if (op == '+') { r = a + b; }
                        if (op == '-') { r = a - b; }
                        if (op == '*') { r = a * b; }
                        if (op == '/') { r = a / b; }
                        if (op == '%') { r = a % b; }
                        st[sp] = r; sp = sp + 1;
                    }
                }
                return st[sp - 1];
            }
        }
        // Shunting-yard (spec 34): converts a space-separated infix expression (integers, + - * / %, and
        // parentheses) to Reverse Polish, ready for Rpn.eval. Higher-precedence operators pop first.
        public class ShuntingYard {
            private static method prec(char op) returns int {
                if (op == '+' || op == '-') { return 1; }
                if (op == '*' || op == '/' || op == '%') { return 2; }
                return 0;
            }
            public static method toRpn(String infix) returns String {
                ArrayList<String> toks = Strings.split(infix, " ");
                mutable StringBuilder out = new StringBuilder() on heap;
                mutable char[] ops = new char[128]();
                mutable int sp = 0;
                for (mutable int i = 0; i < toks.size(); i++) {
                    String t = toks.get(i);
                    if (t.length() == 0) { continue; }
                    char c = t.charAt(0);
                    if ((c >= '0' && c <= '9') || (c == '-' && t.length() > 1)) {
                        if (out.length() > 0) { out.appendChar(' '); }
                        out.append(t);
                    } else {
                        if (c == '(') { ops[sp] = c; sp = sp + 1; }
                        else {
                            if (c == ')') {
                                while (sp > 0 && ops[sp - 1] != '(') {
                                    if (out.length() > 0) { out.appendChar(' '); }
                                    out.appendChar(ops[sp - 1]); sp = sp - 1;
                                }
                                sp = sp - 1;
                            } else {
                                while (sp > 0 && ShuntingYard.prec(ops[sp - 1]) >= ShuntingYard.prec(c)) {
                                    if (out.length() > 0) { out.appendChar(' '); }
                                    out.appendChar(ops[sp - 1]); sp = sp - 1;
                                }
                                ops[sp] = c; sp = sp + 1;
                            }
                        }
                    }
                }
                while (sp > 0) {
                    if (out.length() > 0) { out.appendChar(' '); }
                    out.appendChar(ops[sp - 1]); sp = sp - 1;
                }
                return out.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Fills {name} placeholders in a template from a map (spec 34): an unknown key is left as-is, so the
        // braces survive when there is no matching value.
        public class Template {
            public static method render(String tpl, HashMap<String, String> vars) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                while (i < tpl.length()) {
                    char c = tpl.charAt(i);
                    if (c == '{') {
                        mutable int j = i + 1;
                        mutable StringBuilder key = new StringBuilder() on heap;
                        while (j < tpl.length() && tpl.charAt(j) != '}') {
                            key.appendChar(tpl.charAt(j));
                            j = j + 1;
                        }
                        String k = key.toString();
                        if (vars.containsKey(k)) {
                            sb.append(vars.get(k));
                        } else {
                            sb.appendChar('{');
                            sb.append(k);
                            sb.appendChar('}');
                        }
                        i = j + 1;
                    } else {
                        sb.appendChar(c);
                        i = i + 1;
                    }
                }
                return sb.toString();
            }
        }
        // Parses one line of comma-separated values into fields (spec 34), honoring double-quoted fields so a
        // comma inside quotes does not split. Quote characters are consumed, not kept.
        public class Csv {
            public static method parse(String line) returns ArrayList<String> {
                mutable ArrayList<String> out = new ArrayList<String>() on heap;
                mutable StringBuilder cur = new StringBuilder() on heap;
                mutable boolean inQuotes = false;
                mutable int i = 0;
                while (i < line.length()) {
                    char c = line.charAt(i);
                    if (c == '"') {
                        inQuotes = !inQuotes;
                    } else {
                        if (c == ',' && !inQuotes) {
                            out.add(cur.toString());
                            cur = new StringBuilder() on heap;
                        } else {
                            cur.appendChar(c);
                        }
                    }
                    i = i + 1;
                }
                out.add(cur.toString());
                return out;
            }
        }
        // CSV row writer (RFC 4180, spec 34): joins cells with commas, quoting any cell that contains a comma,
        // quote or newline and doubling embedded quotes. Complements the Csv parser.
        public class CsvWriter {
            public static method buildRow(String[] cells, int n) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < n; i++) {
                    if (i > 0) { sb.appendChar(','); }
                    String c = cells[i];
                    boolean needQuote = c.contains(",") || c.contains("\"") || c.contains("\n");
                    if (needQuote) {
                        sb.appendChar('"');
                        for (mutable int j = 0; j < c.length(); j++) {
                            char ch = c.charAt(j);
                            if (ch == '"') { sb.appendChar('"'); sb.appendChar('"'); }
                            else { sb.appendChar(ch); }
                        }
                        sb.appendChar('"');
                    } else {
                        sb.append(c);
                    }
                }
                return sb.toString();
            }
        }
        // Parse one RFC 4180 CSV record (spec 34), the inverse of CsvWriter: quoted fields may contain commas
        // and escaped quotes (a doubled "" becomes a single "). Returns the fields in order.
        public class CsvReader {
            public static method parseLine(String line) returns ArrayList<String> {
                mutable ArrayList<String> out = new ArrayList<String>() on heap;
                mutable StringBuilder cur = new StringBuilder() on heap;
                mutable boolean inQuotes = false;
                mutable int i = 0;
                while (i < line.length()) {
                    char c = line.charAt(i);
                    if (inQuotes) {
                        if (c == '"') {
                            if (i + 1 < line.length() && line.charAt(i + 1) == '"') { cur.appendChar('"'); i = i + 1; }
                            else { inQuotes = false; }
                        } else { cur.appendChar(c); }
                    } else {
                        if (c == '"') { inQuotes = true; }
                        else {
                            if (c == ',') { out.add(cur.toString()); cur = new StringBuilder() on heap; }
                            else { cur.appendChar(c); }
                        }
                    }
                    i = i + 1;
                }
                out.add(cur.toString());
                return out;
            }
        }
        // Identifier case conversion (spec 34): between camelCase and snake_case/kebab-case. toSnake/toKebab
        // insert a separator before each interior uppercase letter and lowercase it; toCamel uppercases the
        // letter after each separator.
        public class CaseConvert {
            private static method lower(char c) returns char {
                if (c >= 'A' && c <= 'Z') { return cast<char>(cast<int>(c) + 32); }
                return c;
            }
            private static method upper(char c) returns char {
                if (c >= 'a' && c <= 'z') { return cast<char>(cast<int>(c) - 32); }
                return c;
            }
            private static method delimit(String s, char sep) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c >= 'A' && c <= 'Z') {
                        if (i > 0) { sb.appendChar(sep); }
                        sb.appendChar(CaseConvert.lower(c));
                    } else {
                        sb.appendChar(c);
                    }
                }
                return sb.toString();
            }
            public static method toSnake(String s) returns String { return CaseConvert.delimit(s, '_'); }
            public static method toKebab(String s) returns String { return CaseConvert.delimit(s, '-'); }
            public static method toCamel(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable boolean up = false;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c == '_' || c == '-') { up = true; }
                    else {
                        if (up) { sb.appendChar(CaseConvert.upper(c)); up = false; }
                        else { sb.appendChar(c); }
                    }
                }
                return sb.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // String similarity (spec 4): the Levenshtein edit distance is the fewest single-character inserts,
        // deletes, or substitutions to turn one string into another. Computed with two rolling DP rows.
        public class TextDistance {
            public static method levenshtein(String a, String b) returns int {
                int n = a.length();
                int m = b.length();
                mutable int[] prev = new int[m + 1]();
                mutable int[] cur = new int[m + 1]();
                for (mutable int j = 0; j <= m; j++) { prev[j] = j; }
                for (mutable int i = 1; i <= n; i++) {
                    cur[0] = i;
                    for (mutable int j = 1; j <= m; j++) {
                        mutable int cost = 1;
                        if (a.charAt(i - 1) == b.charAt(j - 1)) { cost = 0; }
                        mutable int best = prev[j] + 1;
                        if (cur[j - 1] + 1 < best) { best = cur[j - 1] + 1; }
                        if (prev[j - 1] + cost < best) { best = prev[j - 1] + cost; }
                        cur[j] = best;
                    }
                    mutable int[] t = prev;
                    prev = cur;
                    cur = t;
                }
                return prev[m];
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Percent-encoding for URLs (spec 4): unreserved characters (letters, digits, - _ . ~) pass through,
        // everything else becomes %XX of its byte. decode reverses %XX escapes.
        public class UrlCodec {
            private static method isUnreserved(char c) returns boolean {
                return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')
                    || c == '-' || c == '_' || c == '.' || c == '~';
            }
            private static method hexDigit(int v) returns char {
                if (v < 10) { return cast<char>(cast<int>('0') + v); }
                return cast<char>(cast<int>('A') + (v - 10));
            }
            private static method hexVal(char c) returns int {
                if (c >= '0' && c <= '9') { return cast<int>(c) - cast<int>('0'); }
                if (c >= 'A' && c <= 'F') { return cast<int>(c) - cast<int>('A') + 10; }
                return cast<int>(c) - cast<int>('a') + 10;
            }
            public static method encode(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (UrlCodec.isUnreserved(c)) {
                        sb.appendChar(c);
                    } else {
                        int v = cast<int>(c);
                        sb.appendChar('%');
                        sb.appendChar(UrlCodec.hexDigit(v / 16));
                        sb.appendChar(UrlCodec.hexDigit(v % 16));
                    }
                }
                return sb.toString();
            }
            public static method decode(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int i = 0;
                while (i < s.length()) {
                    char c = s.charAt(i);
                    if (c == '%' && i + 2 < s.length()) {
                        int v = UrlCodec.hexVal(s.charAt(i + 1)) * 16 + UrlCodec.hexVal(s.charAt(i + 2));
                        sb.appendChar(cast<char>(v));
                        i = i + 3;
                    } else {
                        sb.appendChar(c);
                        i = i + 1;
                    }
                }
                return sb.toString();
            }
        }
        // URL query-string parsing (spec 34): splits "k=v&k=v" on & into a map, with each key/value
        // percent-decoded via UrlCodec. A key with no '=' maps to the empty string.
        public class QueryString {
            public static method parse(String qs) returns HashMap<String, String> {
                mutable HashMap<String, String> m = new HashMap<String, String>() on heap;
                mutable ArrayList<String> parts = Strings.split(qs, "&");
                for (mutable int i = 0; i < parts.size(); i++) {
                    String p = parts.get(i);
                    if (p.length() == 0) { continue; }
                    int eq = p.indexOf("=");
                    if (eq < 0) { m.put(UrlCodec.decode(p), ""); }
                    else {
                        String k = UrlCodec.decode(p.substring(0, eq));
                        String v = UrlCodec.decode(p.substring(eq + 1, p.length()));
                        m.put(k, v);
                    }
                }
                return m;
            }
        }
        // Greedy word wrapping (spec 4): splits text on spaces and packs words into lines no longer than the
        // given width, returning the lines. A single word longer than the width gets its own line.
        public class WordWrap {
            public static method wrap(String text, int width) returns ArrayList<String> {
                mutable ArrayList<String> lines = new ArrayList<String>() on heap;
                mutable StringBuilder line = new StringBuilder() on heap;
                mutable StringBuilder word = new StringBuilder() on heap;
                mutable int i = 0;
                while (i <= text.length()) {
                    boolean atEnd = i == text.length();
                    mutable char c = ' ';
                    if (!atEnd) { c = text.charAt(i); }
                    if (atEnd || c == ' ') {
                        if (word.length() > 0) {
                            if (line.length() == 0) {
                                line.append(word.toString());
                            } else {
                                if (line.length() + 1 + word.length() <= width) {
                                    line.appendChar(' ');
                                    line.append(word.toString());
                                } else {
                                    lines.add(line.toString());
                                    line = new StringBuilder() on heap;
                                    line.append(word.toString());
                                }
                            }
                            word = new StringBuilder() on heap;
                        }
                    } else {
                        word.appendChar(c);
                    }
                    i = i + 1;
                }
                if (line.length() > 0) { lines.add(line.toString()); }
                return lines;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Character classification and case conversion (spec 4): the usual is-digit/letter/whitespace tests,
        // ASCII upper/lower conversion, and digitValue (-1 if not a digit).
        public class Chars {
            public static method isDigit(char c) returns boolean { return c >= '0' && c <= '9'; }
            public static method isLetter(char c) returns boolean {
                return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
            }
            public static method isWhitespace(char c) returns boolean {
                return c == ' ' || c == '\t' || c == '\n' || c == '\r';
            }
            public static method isUpper(char c) returns boolean { return c >= 'A' && c <= 'Z'; }
            public static method isLower(char c) returns boolean { return c >= 'a' && c <= 'z'; }
            public static method toUpper(char c) returns char {
                if (c >= 'a' && c <= 'z') { return cast<char>(cast<int>(c) - 32); }
                return c;
            }
            public static method toLower(char c) returns char {
                if (c >= 'A' && c <= 'Z') { return cast<char>(cast<int>(c) + 32); }
                return c;
            }
            public static method digitValue(char c) returns int {
                if (Chars.isDigit(c)) { return cast<int>(c) - cast<int>('0'); }
                return 0 - 1;
            }
        }
        // Roman numerals (spec 4): toRoman writes a positive integer greedily from the largest symbol down;
        // fromRoman reads one back, subtracting a symbol whose value is less than the one after it.
        public class Roman {
            public static method toRoman(int n) returns String {
                mutable int[] vals = new int[13]();
                vals[0] = 1000; vals[1] = 900; vals[2] = 500; vals[3] = 400; vals[4] = 100; vals[5] = 90;
                vals[6] = 50; vals[7] = 40; vals[8] = 10; vals[9] = 9; vals[10] = 5; vals[11] = 4; vals[12] = 1;
                mutable String[] syms = new String[13]();
                syms[0] = "M"; syms[1] = "CM"; syms[2] = "D"; syms[3] = "CD"; syms[4] = "C"; syms[5] = "XC";
                syms[6] = "L"; syms[7] = "XL"; syms[8] = "X"; syms[9] = "IX"; syms[10] = "V"; syms[11] = "IV"; syms[12] = "I";
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int x = n;
                for (mutable int i = 0; i < 13; i++) {
                    while (x >= vals[i]) {
                        sb.append(syms[i]);
                        x = x - vals[i];
                    }
                }
                return sb.toString();
            }
            private static method val(char c) returns int {
                if (c == 'M') { return 1000; }
                if (c == 'D') { return 500; }
                if (c == 'C') { return 100; }
                if (c == 'L') { return 50; }
                if (c == 'X') { return 10; }
                if (c == 'V') { return 5; }
                return 1;
            }
            public static method fromRoman(String s) returns int {
                mutable int total = 0;
                for (mutable int i = 0; i < s.length(); i++) {
                    int v = Roman.val(s.charAt(i));
                    if (i + 1 < s.length() && v < Roman.val(s.charAt(i + 1))) {
                        total = total - v;
                    } else {
                        total = total + v;
                    }
                }
                return total;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // A minimal INI / config parser (spec 34): reads [section] headers and key=value lines (';' and '#'
        // start comments; surrounding whitespace is trimmed) into a flat "section.key" -> value map. get
        // returns the value or "" when absent; has reports presence.
        public class Ini {
            private mutable HashMap<String, String> map;
            public constructor Ini(String text) {
                this.map = new HashMap<String, String>() on heap;
                mutable String section = "";
                ArrayList<String> lines = Strings.split(text, "\n");
                for (mutable int li = 0; li < lines.size(); li++) {
                    String line = lines.get(li).trim();
                    if (line.length() == 0) { continue; }
                    char first = line.charAt(0);
                    if (first == ';' || first == '#') { continue; }
                    if (first == '[') {
                        int close = line.indexOf("]");
                        if (close > 0) { section = line.substring(1, close); }
                    } else {
                        int eq = line.indexOf("=");
                        if (eq >= 0) {
                            String key = line.substring(0, eq).trim();
                            String val = line.substring(eq + 1, line.length()).trim();
                            this.map.put(section.concat(".").concat(key), val);
                        }
                    }
                }
                return;
            }
            public method get(String section, String key) returns String {
                String full = section.concat(".").concat(key);
                if (this.map.containsKey(full)) { return this.map.get(full); }
                return "";
            }
            public method has(String section, String key) returns boolean {
                return this.map.containsKey(section.concat(".").concat(key));
            }
        }
        // Java-style .properties parsing (spec 34): flat key=value lines (space around '=' trimmed), with #
        // and ! comment lines skipped. Typed getters (getString/getInt/getBool) fall back to a default when a
        // key is missing or malformed.
        public class Properties {
            private mutable HashMap<String, String> map;
            private static method trim(String s) returns String {
                mutable int a = 0;
                mutable int b = s.length();
                while (a < b && s.charAt(a) == ' ') { a = a + 1; }
                while (b > a && s.charAt(b - 1) == ' ') { b = b - 1; }
                return s.substring(a, b);
            }
            public constructor Properties(String text) {
                this.map = new HashMap<String, String>() on heap;
                mutable ArrayList<String> lines = Strings.split(text, "\n");
                for (mutable int i = 0; i < lines.size(); i++) {
                    String raw = Properties.trim(lines.get(i));
                    if (raw.length() == 0) { continue; }
                    char c0 = raw.charAt(0);
                    if (c0 == '#' || c0 == '!') { continue; }
                    int eq = raw.indexOf("=");
                    if (eq < 0) { continue; }
                    String k = Properties.trim(raw.substring(0, eq));
                    String v = Properties.trim(raw.substring(eq + 1, raw.length()));
                    this.map.put(k, v);
                }
            }
            public method has(String key) returns boolean { return this.map.containsKey(key); }
            public method getString(String key, String def) returns String {
                if (this.map.containsKey(key)) { return this.map.get(key); }
                return def;
            }
            public method getInt(String key, int def) returns int {
                if (!this.map.containsKey(key)) { return def; }
                String v = this.map.get(key);
                mutable int i = 0;
                mutable boolean neg = false;
                if (v.length() > 0 && v.charAt(0) == '-') { neg = true; i = 1; }
                mutable int n = 0;
                while (i < v.length()) {
                    char c = v.charAt(i);
                    if (c < '0' || c > '9') { return def; }
                    n = n * 10 + (cast<int>(c) - cast<int>('0'));
                    i = i + 1;
                }
                if (neg) { return 0 - n; }
                return n;
            }
            public method getBool(String key, boolean def) returns boolean {
                if (!this.map.containsKey(key)) { return def; }
                return this.map.get(key).equals("true");
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // RFC 4122 UUIDs (spec 34): format 16 bytes as the canonical 8-4-4-4-12 hex string, build a version-4
        // UUID from 16 random bytes (setting the version and variant bits), or generate one deterministically
        // from an int seed via an inline xorshift. isValid checks the canonical shape.
        public class Uuid {
            private static method hx(int v) returns char {
                String d = "0123456789abcdef";
                return d.charAt(v & 15);
            }
            public static method format(int[] bytes) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < 16; i++) {
                    if (i == 4 || i == 6 || i == 8 || i == 10) { sb.appendChar('-'); }
                    int b = bytes[i] & 255;
                    sb.appendChar(Uuid.hx(b >> 4));
                    sb.appendChar(Uuid.hx(b));
                }
                return sb.toString();
            }
            public static method v4(int[] randomBytes) returns String {
                mutable int[] b = new int[16]();
                for (mutable int i = 0; i < 16; i++) { b[i] = randomBytes[i] & 255; }
                b[6] = (b[6] & 15) | 64;
                b[8] = (b[8] & 63) | 128;
                return Uuid.format(b);
            }
            public static method v4Seeded(int seed) returns String {
                mutable ulong x = cast<ulong>(seed);
                if (x == cast<ulong>(0)) { x = cast<ulong>(1); }
                mutable int[] b = new int[16]();
                for (mutable int i = 0; i < 16; i++) {
                    x = x ^ (x << 13);
                    x = x ^ (x >> 7);
                    x = x ^ (x << 17);
                    b[i] = cast<int>((x >> 24) & cast<ulong>(255));
                }
                return Uuid.v4(b);
            }
            public static method isValid(String s) returns boolean {
                if (s.length() != 36) { return false; }
                for (mutable int i = 0; i < 36; i++) {
                    char c = s.charAt(i);
                    if (i == 8 || i == 13 || i == 18 || i == 23) {
                        if (c != '-') { return false; }
                    } else {
                        boolean hex = (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f');
                        if (!hex) { return false; }
                    }
                }
                return true;
            }
        }
        // Semantic versioning (semver.org): parse "major.minor.patch" (an optional leading 'v' and any
        // -prerelease/+build suffix are ignored) and compare two versions field by field. compareTo returns
        // -1, 0 or 1.
        public class Semver {
            private mutable int major;
            private mutable int minor;
            private mutable int patch;
            public constructor Semver(String v) {
                mutable int i = 0;
                if (v.length() > 0 && v.charAt(0) == 'v') { i = 1; }
                mutable int[] parts = new int[3]();
                mutable int pi = 0;
                mutable int cur = 0;
                int n = v.length();
                while (i < n && pi < 3) {
                    char c = v.charAt(i);
                    if (c >= '0' && c <= '9') { cur = cur * 10 + (cast<int>(c) - cast<int>('0')); }
                    else {
                        if (c == '.') { parts[pi] = cur; pi = pi + 1; cur = 0; }
                        else { i = n; }
                    }
                    i = i + 1;
                }
                if (pi < 3) { parts[pi] = cur; }
                this.major = parts[0];
                this.minor = parts[1];
                this.patch = parts[2];
            }
            public method getMajor() returns int { return this.major; }
            public method getMinor() returns int { return this.minor; }
            public method getPatch() returns int { return this.patch; }
            public method compareTo(Semver o) returns int {
                if (this.major != o.getMajor()) { if (this.major < o.getMajor()) { return -1; } return 1; }
                if (this.minor != o.getMinor()) { if (this.minor < o.getMinor()) { return -1; } return 1; }
                if (this.patch != o.getPatch()) { if (this.patch < o.getPatch()) { return -1; } return 1; }
                return 0;
            }
            public method toString() returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.appendInt(this.major).append(".").appendInt(this.minor).append(".").appendInt(this.patch);
                return sb.toString();
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // A simple deterministic finite state machine (spec 34): register (from, event) -> to transitions and
        // drive them with fire(event), which advances the current state and returns whether a transition
        // existed. Transitions live in a "state|event" -> next map.
        public class StateMachine {
            private mutable HashMap<String, String> transitions;
            private mutable String current;
            public constructor StateMachine(String initial) {
                this.transitions = new HashMap<String, String>() on heap;
                this.current = initial;
            }
            public method addTransition(String from, String event, String to) returns void {
                this.transitions.put(from.concat("|").concat(event), to);
                return;
            }
            public method fire(String event) returns boolean {
                String key = this.current.concat("|").concat(event);
                if (this.transitions.containsKey(key)) { this.current = this.transitions.get(key); return true; }
                return false;
            }
            public method state() returns String { return this.current; }
        }
        // Glob / wildcard matching (spec 34): '*' matches any run of characters (including none) and '?' matches
        // exactly one. Iterative with backtracking on the last '*', so it runs in linear space.
        public class Glob {
            public static method matches(String pattern, String text) returns boolean {
                int pn = pattern.length();
                int tn = text.length();
                mutable int p = 0;
                mutable int t = 0;
                mutable int star = -1;
                mutable int mark = 0;
                while (t < tn) {
                    if (p < pn && (pattern.charAt(p) == '?' || pattern.charAt(p) == text.charAt(t))) {
                        p = p + 1; t = t + 1;
                    } else {
                        if (p < pn && pattern.charAt(p) == '*') {
                            star = p; mark = t; p = p + 1;
                        } else {
                            if (star != -1) { p = star + 1; mark = mark + 1; t = mark; }
                            else { return false; }
                        }
                    }
                }
                while (p < pn && pattern.charAt(p) == '*') { p = p + 1; }
                return p == pn;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // LEB128 variable-length integers (spec 4): seven bits per byte, high bit set while more bytes follow,
        // so small values take one byte. encode returns the bytes; decode reads them back.
        public class VarInt {
            public static method encode(long value) returns ArrayList<int> {
                mutable ArrayList<int> out = new ArrayList<int>() on heap;
                mutable long v = value;
                mutable boolean more = true;
                while (more) {
                    mutable int b = cast<int>(v & cast<long>(127));
                    v = v >> 7;
                    if (v == 0) { more = false; } else { b = b | 128; }
                    out.add(b);
                }
                return out;
            }
            public static method decode(ArrayList<int> bytes) returns long {
                mutable long result = 0;
                mutable int shift = 0;
                mutable int i = 0;
                mutable boolean more = true;
                while (more && i < bytes.size()) {
                    int b = bytes.get(i);
                    result = result | (cast<long>(b & 127) << shift);
                    if ((b & 128) == 0) { more = false; }
                    shift = shift + 7;
                    i = i + 1;
                }
                return result;
            }
        }
        // A most-significant-bit-first bit writer (spec 4): pack individual bits or fixed-width fields into a
        // byte buffer, then read them back with BitReader. Useful for entropy coders such as Huffman.
        public class BitWriter {
            private mutable int[] buf;
            private mutable int nbits;
            public constructor BitWriter() {
                this.buf = new int[64]();
                this.nbits = 0;
            }
            private method ensure(int idx) returns void {
                if (idx < this.buf.length()) { return; }
                mutable int[] bigger = new int[this.buf.length() * 2]();
                for (mutable int i = 0; i < this.buf.length(); i++) { bigger[i] = this.buf[i]; }
                this.buf = bigger;
                return;
            }
            public method writeBit(int bit) returns void {
                int idx = this.nbits / 8;
                this.ensure(idx);
                int off = 7 - (this.nbits % 8);
                if ((bit & 1) == 1) { this.buf[idx] = this.buf[idx] | (1 << off); }
                this.nbits = this.nbits + 1;
                return;
            }
            public method writeBits(int value, int count) returns void {
                for (mutable int i = count - 1; i >= 0; i = i - 1) {
                    this.writeBit((value >> i) & 1);
                }
                return;
            }
            public method bitCount() returns int { return this.nbits; }
            public method toBytes() returns int[] {
                int n = (this.nbits + 7) / 8;
                mutable int[] out = new int[n]();
                for (mutable int i = 0; i < n; i++) { out[i] = this.buf[i]; }
                return out;
            }
        }
        // Reads bits most-significant-first out of a byte array, matching BitWriter (spec 4).
        public class BitReader {
            private mutable int[] buf;
            private mutable int pos;
            public constructor BitReader(int[] bytes) {
                this.buf = bytes;
                this.pos = 0;
            }
            public method readBit() returns int {
                int idx = this.pos / 8;
                int off = 7 - (this.pos % 8);
                this.pos = this.pos + 1;
                return (this.buf[idx] >> off) & 1;
            }
            public method readBits(int count) returns int {
                mutable int v = 0;
                for (mutable int i = 0; i < count; i++) { v = (v << 1) | this.readBit(); }
                return v;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // 24-bit RGB color utilities (spec 34): pack/unpack channels into a 0xRRGGBB int, hex parse/format,
        // linear interpolation between two colors (t is a 0..100 percent), Rec.601 luminance and grayscale.
        public class Colors {
            public static method pack(int r, int g, int b) returns int {
                return ((r & 255) << 16) | ((g & 255) << 8) | (b & 255);
            }
            public static method red(int c) returns int { return (c >> 16) & 255; }
            public static method green(int c) returns int { return (c >> 8) & 255; }
            public static method blue(int c) returns int { return c & 255; }
            private static method hx(int v) returns char {
                String d = "0123456789abcdef";
                return d.charAt(v & 15);
            }
            public static method toHex(int c) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.appendChar('#');
                int r = Colors.red(c);
                int g = Colors.green(c);
                int b = Colors.blue(c);
                sb.appendChar(Colors.hx(r >> 4)); sb.appendChar(Colors.hx(r));
                sb.appendChar(Colors.hx(g >> 4)); sb.appendChar(Colors.hx(g));
                sb.appendChar(Colors.hx(b >> 4)); sb.appendChar(Colors.hx(b));
                return sb.toString();
            }
            private static method hv(char c) returns int {
                if (c >= '0' && c <= '9') { return cast<int>(c) - cast<int>('0'); }
                if (c >= 'a' && c <= 'f') { return cast<int>(c) - cast<int>('a') + 10; }
                if (c >= 'A' && c <= 'F') { return cast<int>(c) - cast<int>('A') + 10; }
                return 0;
            }
            public static method fromHex(String s) returns int {
                mutable int i = 0;
                if (s.length() > 0 && s.charAt(0) == '#') { i = 1; }
                mutable int v = 0;
                while (i < s.length()) { v = (v << 4) | Colors.hv(s.charAt(i)); i = i + 1; }
                return v & 16777215;
            }
            public static method lerp(int c1, int c2, int t) returns int {
                int r = (Colors.red(c1) * (100 - t) + Colors.red(c2) * t) / 100;
                int g = (Colors.green(c1) * (100 - t) + Colors.green(c2) * t) / 100;
                int b = (Colors.blue(c1) * (100 - t) + Colors.blue(c2) * t) / 100;
                return Colors.pack(r, g, b);
            }
            public static method luminance(int c) returns int {
                return (299 * Colors.red(c) + 587 * Colors.green(c) + 114 * Colors.blue(c)) / 1000;
            }
            public static method grayscale(int c) returns int {
                int y = Colors.luminance(c);
                return Colors.pack(y, y, y);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Caesar shift cipher (spec 34): rotate each letter by n, wrapping within its case; non-letters pass
        // through. decrypt is the inverse shift; rot13 is the classic shift of 13.
        public class Caesar {
            private static method shiftChar(char c, int n) returns char {
                if (c >= 'A' && c <= 'Z') {
                    return cast<char>((cast<int>(c) - cast<int>('A') + n + 2600) % 26 + cast<int>('A'));
                }
                if (c >= 'a' && c <= 'z') {
                    return cast<char>((cast<int>(c) - cast<int>('a') + n + 2600) % 26 + cast<int>('a'));
                }
                return c;
            }
            public static method encrypt(String s, int n) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = 0; i < s.length(); i++) { sb.appendChar(Caesar.shiftChar(s.charAt(i), n)); }
                return sb.toString();
            }
            public static method decrypt(String s, int n) returns String { return Caesar.encrypt(s, 26 - (n % 26)); }
            public static method rot13(String s) returns String { return Caesar.encrypt(s, 13); }
        }
        // Vigenere cipher (spec 34): a repeating-key poly-alphabetic shift over letters (case preserved,
        // non-letters skipped and not consuming key). encrypt and decrypt are inverses.
        public class Vigenere {
            private static method proc(String s, String key, int dir) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable int ki = 0;
                int klen = key.length();
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    mutable boolean upper = c >= 'A' && c <= 'Z';
                    mutable boolean lower = c >= 'a' && c <= 'z';
                    if (upper || lower) {
                        char kc = key.charAt(ki % klen);
                        mutable int kshift = 0;
                        if (kc >= 'A' && kc <= 'Z') { kshift = cast<int>(kc) - cast<int>('A'); }
                        if (kc >= 'a' && kc <= 'z') { kshift = cast<int>(kc) - cast<int>('a'); }
                        mutable int base = cast<int>('A');
                        if (lower) { base = cast<int>('a'); }
                        int off = cast<int>(c) - base;
                        int shifted = (off + dir * kshift + 2600) % 26;
                        sb.appendChar(cast<char>(base + shifted));
                        ki = ki + 1;
                    } else {
                        sb.appendChar(c);
                    }
                }
                return sb.toString();
            }
            public static method encrypt(String s, String key) returns String { return Vigenere.proc(s, key, 1); }
            public static method decrypt(String s, String key) returns String { return Vigenere.proc(s, key, -1); }
        }
        // URL/filename slugs (spec 34): lowercase, collapse every run of non-alphanumeric characters to a
        // single dash, and trim leading/trailing dashes.
        public class Slugify {
            public static method make(String s) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable boolean pendingDash = false;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    mutable boolean alnum = (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z');
                    mutable char lc = c;
                    if (c >= 'A' && c <= 'Z') { lc = cast<char>(cast<int>(c) + 32); alnum = true; }
                    if (alnum) {
                        if (pendingDash && sb.length() > 0) { sb.appendChar('-'); }
                        pendingDash = false;
                        sb.appendChar(lc);
                    } else {
                        pendingDash = true;
                    }
                }
                return sb.toString();
            }
        }
        // English pluralization (spec 34), simple rules: -s/-x/-z/-ch/-sh take "es", a consonant+y becomes
        // "ies", otherwise append "s".
        public class Inflector {
            private static method endsWith(String s, String suf) returns boolean {
                int n = s.length();
                int m = suf.length();
                if (m > n) { return false; }
                for (mutable int i = 0; i < m; i++) {
                    if (s.charAt(n - m + i) != suf.charAt(i)) { return false; }
                }
                return true;
            }
            public static method pluralize(String w) returns String {
                int n = w.length();
                if (n == 0) { return w; }
                char last = w.charAt(n - 1);
                if (Inflector.endsWith(w, "s") || Inflector.endsWith(w, "x") || Inflector.endsWith(w, "z")
                    || Inflector.endsWith(w, "ch") || Inflector.endsWith(w, "sh")) {
                    return w.concat("es");
                }
                if (last == 'y') {
                    mutable boolean vowelBefore = false;
                    if (n >= 2) {
                        char b = w.charAt(n - 2);
                        if (b == 'a' || b == 'e' || b == 'i' || b == 'o' || b == 'u') { vowelBefore = true; }
                    }
                    if (!vowelBefore) { return w.substring(0, n - 1).concat("ies"); }
                }
                return w.concat("s");
            }
        }
        // Levenshtein edit distance (spec 34): the minimum single-character insertions, deletions, and
        // substitutions to turn one string into another, via two-row dynamic programming. Good for fuzzy
        // matching and spell-checking.
        public class Levenshtein {
            public static method distance(String a, String b) returns int {
                int n = a.length();
                int m = b.length();
                if (n == 0) { return m; }
                if (m == 0) { return n; }
                mutable int[] prev = new int[m + 1]();
                mutable int[] cur = new int[m + 1]();
                for (mutable int j = 0; j <= m; j++) { prev[j] = j; }
                for (mutable int i = 1; i <= n; i++) {
                    cur[0] = i;
                    for (mutable int j = 1; j <= m; j++) {
                        mutable int cost = 1;
                        if (a.charAt(i - 1) == b.charAt(j - 1)) { cost = 0; }
                        mutable int mn = prev[j] + 1;
                        int ins = cur[j - 1] + 1;
                        int sub = prev[j - 1] + cost;
                        if (ins < mn) { mn = ins; }
                        if (sub < mn) { mn = sub; }
                        cur[j] = mn;
                    }
                    for (mutable int j = 0; j <= m; j++) { prev[j] = cur[j]; }
                }
                return prev[m];
            }
        }
        // Jaro-Winkler string similarity (spec 34) in [0,1]: the Jaro score adjusted upward for a common
        // prefix (up to 4 chars, factor 0.1). Good for fuzzy matching short strings like names.
        public class JaroWinkler {
            public static method jaro(String s1, String s2) returns double {
                int n1 = s1.length();
                int n2 = s2.length();
                if (n1 == 0 && n2 == 0) { return 1.0; }
                if (n1 == 0 || n2 == 0) { return 0.0; }
                mutable int window = n1;
                if (n2 > window) { window = n2; }
                window = window / 2 - 1;
                if (window < 0) { window = 0; }
                mutable boolean[] m1 = new boolean[n1]();
                mutable boolean[] m2 = new boolean[n2]();
                mutable int matches = 0;
                for (mutable int i = 0; i < n1; i++) {
                    mutable int lo = i - window;
                    if (lo < 0) { lo = 0; }
                    mutable int hi = i + window;
                    if (hi > n2 - 1) { hi = n2 - 1; }
                    mutable int j = lo;
                    mutable boolean done = false;
                    while (j <= hi && !done) {
                        if (!m2[j] && s1.charAt(i) == s2.charAt(j)) {
                            m1[i] = true; m2[j] = true; matches = matches + 1; done = true;
                        }
                        j = j + 1;
                    }
                }
                if (matches == 0) { return 0.0; }
                mutable int k = 0;
                mutable int trans = 0;
                for (mutable int i = 0; i < n1; i++) {
                    if (m1[i]) {
                        while (!m2[k]) { k = k + 1; }
                        if (s1.charAt(i) != s2.charAt(k)) { trans = trans + 1; }
                        k = k + 1;
                    }
                }
                double mt = cast<double>(matches);
                double t = cast<double>(trans) / 2.0;
                return (mt / cast<double>(n1) + mt / cast<double>(n2) + (mt - t) / mt) / 3.0;
            }
            public static method similarity(String s1, String s2) returns double {
                double j = JaroWinkler.jaro(s1, s2);
                mutable int prefix = 0;
                mutable int i = 0;
                while (i < s1.length() && i < s2.length() && i < 4 && s1.charAt(i) == s2.charAt(i)) {
                    prefix = prefix + 1; i = i + 1;
                }
                return j + cast<double>(prefix) * 0.1 * (1.0 - j);
            }
        }
        // Luhn (mod-10) checksum (spec 34), as used by credit-card numbers: doubles every second digit from
        // the right (subtracting 9 when over 9); valid when the total is a multiple of 10. Non-digits skipped.
        public class Luhn {
            public static method isValid(String s) returns boolean {
                mutable int sum = 0;
                mutable boolean dbl = false;
                for (mutable int i = s.length() - 1; i >= 0; i = i - 1) {
                    char c = s.charAt(i);
                    if (c < '0' || c > '9') { continue; }
                    mutable int d = cast<int>(c) - cast<int>('0');
                    if (dbl) { d = d * 2; if (d > 9) { d = d - 9; } }
                    sum = sum + d;
                    dbl = !dbl;
                }
                return sum % 10 == 0;
            }
        }
        // ISBN-13 check digit (spec 34): the 13 digits weighted 1,3,1,3,... must sum to a multiple of 10.
        public class Isbn {
            public static method isValid13(String s) returns boolean {
                mutable int sum = 0;
                mutable int count = 0;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c < '0' || c > '9') { continue; }
                    int d = cast<int>(c) - cast<int>('0');
                    if (count % 2 == 0) { sum = sum + d; } else { sum = sum + 3 * d; }
                    count = count + 1;
                }
                if (count != 13) { return false; }
                return sum % 10 == 0;
            }
        }
)LDP3"
// Text diff and validators in their own literal; still System.Text.
R"LDP3(
        // Line-level text diff (spec 34) via the longest common subsequence: common counts shared lines in
        // order; removed and added are the lines only in the first or second version. Uses two-row LCS DP.
        public class TextDiff {
            private static method lcsLen(String[] a, int na, String[] b, int nb) returns int {
                mutable int[] prev = new int[nb + 1]();
                mutable int[] cur = new int[nb + 1]();
                for (mutable int i = 1; i <= na; i++) {
                    for (mutable int j = 1; j <= nb; j++) {
                        if (a[i - 1].equals(b[j - 1])) { cur[j] = prev[j - 1] + 1; }
                        else {
                            mutable int m = prev[j];
                            if (cur[j - 1] > m) { m = cur[j - 1]; }
                            cur[j] = m;
                        }
                    }
                    for (mutable int j = 0; j <= nb; j++) { prev[j] = cur[j]; }
                }
                return prev[nb];
            }
            public static method common(String[] a, int na, String[] b, int nb) returns int { return TextDiff.lcsLen(a, na, b, nb); }
            public static method removed(String[] a, int na, String[] b, int nb) returns int { return na - TextDiff.lcsLen(a, na, b, nb); }
            public static method added(String[] a, int na, String[] b, int nb) returns int { return nb - TextDiff.lcsLen(a, na, b, nb); }
        }
        // Lightweight format validators (spec 34): a heuristic email check (single @, dot in the domain, no
        // spaces), an http/https URL check with a non-empty host, and IBAN via the ISO 7064 mod-97 test.
        public class Validators {
            public static method isEmail(String s) returns boolean {
                mutable int at = 0 - 1;
                mutable int atCount = 0;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c == ' ') { return false; }
                    if (c == '@') { at = i; atCount = atCount + 1; }
                }
                if (atCount != 1 || at == 0 || at == s.length() - 1) { return false; }
                mutable boolean dot = false;
                for (mutable int i = at + 1; i < s.length(); i++) { if (s.charAt(i) == '.') { dot = true; } }
                return dot;
            }
            public static method isUrl(String s) returns boolean {
                mutable boolean https = s.startsWith("https://");
                mutable boolean http = s.startsWith("http://");
                if (!http && !https) { return false; }
                mutable int start = 7;
                if (https) { start = 8; }
                return s.length() > start;
            }
            public static method isIban(String s) returns boolean {
                mutable int len = 0;
                mutable char[] buf = new char[64]();
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c != ' ') { buf[len] = c; len = len + 1; }
                }
                if (len < 5) { return false; }
                mutable long running = 0;
                for (mutable int k = 0; k < len; k++) {
                    mutable int idx = k + 4;
                    if (idx >= len) { idx = idx - len; }
                    char c = buf[idx];
                    if (c >= '0' && c <= '9') { running = (running * 10 + cast<long>(cast<int>(c) - cast<int>('0'))) % 97; }
                    else {
                        if (c >= 'A' && c <= 'Z') { running = (running * 100 + cast<long>(cast<int>(c) - cast<int>('A') + 10)) % 97; }
                        else { return false; }
                    }
                }
                return running == 1;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Text namespace.
R"LDP3(
        // Spell an integer in English words (spec 34), space-separated and lowercase, up to the billions
        // (covers the full int range). Negative numbers are prefixed with "minus".
        public class NumberWords {
            private static method ones(int n) returns String {
                mutable String[] w = new String[10]();
                w[0]=""; w[1]="one"; w[2]="two"; w[3]="three"; w[4]="four";
                w[5]="five"; w[6]="six"; w[7]="seven"; w[8]="eight"; w[9]="nine";
                return w[n];
            }
            private static method teens(int n) returns String {
                mutable String[] w = new String[10]();
                w[0]="ten"; w[1]="eleven"; w[2]="twelve"; w[3]="thirteen"; w[4]="fourteen";
                w[5]="fifteen"; w[6]="sixteen"; w[7]="seventeen"; w[8]="eighteen"; w[9]="nineteen";
                return w[n - 10];
            }
            private static method tens(int n) returns String {
                mutable String[] w = new String[10]();
                w[2]="twenty"; w[3]="thirty"; w[4]="forty"; w[5]="fifty";
                w[6]="sixty"; w[7]="seventy"; w[8]="eighty"; w[9]="ninety";
                return w[n];
            }
            private static method under100(int n) returns String {
                if (n < 10) { return NumberWords.ones(n); }
                if (n < 20) { return NumberWords.teens(n); }
                int t = n / 10;
                int o = n % 10;
                if (o == 0) { return NumberWords.tens(t); }
                return NumberWords.tens(t).concat(" ").concat(NumberWords.ones(o));
            }
            private static method under1000(int n) returns String {
                if (n < 100) { return NumberWords.under100(n); }
                int h = n / 100;
                int r = n % 100;
                mutable String s = NumberWords.ones(h).concat(" hundred");
                if (r > 0) { s = s.concat(" ").concat(NumberWords.under100(r)); }
                return s;
            }
            public static method toWords(int num) returns String {
                if (num == 0) { return "zero"; }
                mutable int n = num;
                mutable String sign = "";
                if (n < 0) { sign = "minus "; n = 0 - n; }
                mutable String[] scale = new String[4]();
                scale[0]=""; scale[1]=" thousand"; scale[2]=" million"; scale[3]=" billion";
                mutable int[] grp = new int[4]();
                mutable int g = 0;
                mutable int m = n;
                while (m > 0) { grp[g] = m % 1000; m = m / 1000; g = g + 1; }
                mutable StringBuilder sb = new StringBuilder() on heap;
                for (mutable int i = g - 1; i >= 0; i = i - 1) {
                    if (grp[i] > 0) {
                        if (sb.length() > 0) { sb.appendChar(' '); }
                        sb.append(NumberWords.under1000(grp[i]));
                        sb.append(scale[i]);
                    }
                }
                return sign.concat(sb.toString());
            }
        }
        // Human-friendly formatting (spec 34): binary byte sizes (1024-based, one decimal above bytes) and
        // English ordinals (1st, 2nd, 3rd, 11th, 21st), handling the 11-13 "th" exception.
        public class Humanize {
            public static method bytes(long n) returns String {
                mutable String[] units = new String[5]();
                units[0]="B"; units[1]="KB"; units[2]="MB"; units[3]="GB"; units[4]="TB";
                mutable double d = cast<double>(n);
                mutable int u = 0;
                while (d >= 1024.0 && u < 4) { d = d / 1024.0; u = u + 1; }
                mutable StringBuilder sb = new StringBuilder() on heap;
                if (u == 0) {
                    sb.appendInt(cast<int>(n)); sb.appendChar(' '); sb.append(units[0]);
                } else {
                    int whole = cast<int>(d * 10.0 + 0.5);
                    sb.appendInt(whole / 10); sb.appendChar('.'); sb.appendInt(whole % 10);
                    sb.appendChar(' '); sb.append(units[u]);
                }
                return sb.toString();
            }
            public static method ordinal(int n) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.appendInt(n);
                int m100 = n % 100;
                mutable String suf = "th";
                if (m100 < 11 || m100 > 13) {
                    int m10 = n % 10;
                    if (m10 == 1) { suf = "st"; }
                    if (m10 == 2) { suf = "nd"; }
                    if (m10 == 3) { suf = "rd"; }
                }
                sb.append(suf);
                return sb.toString();
            }
        }
    }
    public namespace System.Time {
        // A span of time in milliseconds (spec 34). Same namespace as the `Time` builtin, so
        // Instant.now() can call Time.unixMillis() without an import.
        public class Duration {
            private mutable long ms;
            public constructor Duration(long millis) { this.ms = millis; }
            public static method ofMillis(long m) returns Duration { return new Duration(m) on heap; }
            public static method ofSeconds(long s) returns Duration { return new Duration(s * 1000) on heap; }
            public static method ofMinutes(long m) returns Duration { return new Duration(m * 60000) on heap; }
            public method toMillis() returns long { return this.ms; }
            public method toSeconds() returns long { return this.ms / 1000; }
            public method plus(Duration other) returns Duration {
                return new Duration(this.ms + other.toMillis()) on heap;
            }
            public method minus(Duration other) returns Duration {
                return new Duration(this.ms - other.toMillis()) on heap;
            }
        }
        // A moment on the wall clock, as milliseconds since the Unix epoch (spec 34).
        public class Instant {
            private mutable long epochMs;
            public constructor Instant(long ms) { this.epochMs = ms; }
            public static method now() returns Instant {
                return new Instant(Time.unixMillis()) on heap;
            }
            public static method ofEpochMillis(long ms) returns Instant {
                return new Instant(ms) on heap;
            }
            public method toEpochMillis() returns long { return this.epochMs; }
            public method isBefore(Instant other) returns boolean {
                return this.epochMs < other.toEpochMillis();
            }
            public method isAfter(Instant other) returns boolean {
                return this.epochMs > other.toEpochMillis();
            }
            public method plus(Duration d) returns Instant {
                return new Instant(this.epochMs + d.toMillis()) on heap;
            }
            public method since(Instant earlier) returns Duration {
                return new Duration(this.epochMs - earlier.toEpochMillis()) on heap;
            }
        }
        // A fixed offset from UTC (spec 34), in seconds east of Greenwich (e.g. -3h for BRT). A pure offset,
        // not a named zone with a DST rule table; systemDefault() reads the machine's current offset
        // (including any active daylight saving) from the OS.
        public class ZoneOffset {
            private mutable int secs;
            private extern cdecl static method __ldp3_local_utc_offset_seconds() returns int;
            public constructor ZoneOffset(int totalSeconds) { this.secs = totalSeconds; }
            public static method ofSeconds(int s) returns ZoneOffset { return new ZoneOffset(s) on heap; }
            public static method ofHours(int h) returns ZoneOffset { return new ZoneOffset(h * 3600) on heap; }
            public static method ofHoursMinutes(int h, int m) returns ZoneOffset {
                mutable int sign = 1;
                if (h < 0) { sign = 0 - 1; }
                return new ZoneOffset(h * 3600 + sign * m * 60) on heap;
            }
            public static method utc() returns ZoneOffset { return new ZoneOffset(0) on heap; }
            public static method systemDefault() returns ZoneOffset {
                return new ZoneOffset(ZoneOffset.__ldp3_local_utc_offset_seconds()) on heap;
            }
            public method totalSeconds() returns int { return this.secs; }
            public method id() returns String {   // "Z" or "+HH:MM" / "-HH:MM"
                if (this.secs == 0) { return "Z"; }
                mutable int t = this.secs;
                mutable String sign = "+";
                if (t < 0) { sign = "-"; t = 0 - t; }
                int hh = t / 3600;
                int mm = (t / 60) % 60;
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.append(sign);
                if (hh < 10) { sb.append("0"); }
                sb.appendInt(hh);
                sb.append(":");
                if (mm < 10) { sb.append("0"); }
                sb.appendInt(mm);
                return sb.toString();
            }
        }
        // A date-time at a fixed UTC offset (spec 34): an Instant paired with a ZoneOffset. The wall-clock
        // fields are the instant shifted by the offset; toInstant recovers the underlying UTC point.
        public class ZonedDateTime {
            private mutable Instant point;
            private mutable ZoneOffset zone;
            public constructor ZonedDateTime(Instant instant, ZoneOffset offset) {
                this.point = instant;
                this.zone = offset;
            }
            public static method now() returns ZonedDateTime {
                return new ZonedDateTime(Instant.now(), ZoneOffset.systemDefault()) on heap;
            }
            public static method ofInstant(Instant i, ZoneOffset off) returns ZonedDateTime {
                return new ZonedDateTime(i, off) on heap;
            }
            public method toInstant() returns Instant { return this.point; }
            public method offset() returns ZoneOffset { return this.zone; }
            private method localSecs() returns long {
                return this.point.toEpochMillis() / cast<long>(1000)
                     + cast<long>(this.zone.totalSeconds());
            }
            private method epochDay() returns long {
                mutable long ls = this.localSecs();
                mutable long day = ls / cast<long>(86400);
                mutable long sod = ls - day * cast<long>(86400);
                if (sod < cast<long>(0)) { day = day - cast<long>(1); }
                return day;
            }
            private method secondOfDay() returns int {
                mutable long ls = this.localSecs();
                mutable long day = ls / cast<long>(86400);
                mutable long sod = ls - day * cast<long>(86400);
                if (sod < cast<long>(0)) { sod = sod + cast<long>(86400); }
                return cast<int>(sod);
            }
            public method year() returns int { return Date.fromEpochDay(cast<int>(this.epochDay())).year(); }
            public method month() returns int { return Date.fromEpochDay(cast<int>(this.epochDay())).month(); }
            public method day() returns int { return Date.fromEpochDay(cast<int>(this.epochDay())).day(); }
            public method hour() returns int { return this.secondOfDay() / 3600; }
            public method minute() returns int { return (this.secondOfDay() / 60) % 60; }
            public method second() returns int { return this.secondOfDay() % 60; }
            public method toString() returns String {   // ISO-8601, e.g. 2026-07-03T14:05:09-03:00
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.appendInt(this.year());
                sb.append("-");
                int mo = this.month();
                if (mo < 10) { sb.append("0"); }
                sb.appendInt(mo);
                sb.append("-");
                int dd = this.day();
                if (dd < 10) { sb.append("0"); }
                sb.appendInt(dd);
                sb.append("T");
                int hh = this.hour();
                if (hh < 10) { sb.append("0"); }
                sb.appendInt(hh);
                sb.append(":");
                int mi = this.minute();
                if (mi < 10) { sb.append("0"); }
                sb.appendInt(mi);
                sb.append(":");
                int ss = this.second();
                if (ss < 10) { sb.append("0"); }
                sb.appendInt(ss);
                sb.append(this.zone.id());
                return sb.toString();
            }
        }
)LDP3"
// (split: keep each literal under MSVC's ~16KB cap; still the same System.Time namespace.)
R"LDP3(
        // A monotonic elapsed-time timer (spec 34): start/stop/reset accumulate high-resolution
        // nanoseconds from the monotonic clock (Time.nanos), unaffected by wall-clock changes.
        public class Stopwatch {
            private mutable long startNs;
            private mutable long accumNs;
            private mutable boolean running;
            public constructor Stopwatch() {
                this.startNs = 0;
                this.accumNs = 0;
                this.running = false;
            }
            public static method startNew() returns Stopwatch {
                mutable Stopwatch s = new Stopwatch() on heap;
                s.start();
                return s;
            }
            public method start() returns void {
                if (this.running) { return; }
                this.startNs = Time.nanos();
                this.running = true;
            }
            public method stop() returns void {
                if (this.running) {
                    this.accumNs = this.accumNs + (Time.nanos() - this.startNs);
                    this.running = false;
                }
            }
            public method reset() returns void {
                this.accumNs = 0;
                this.running = false;
            }
            public method elapsedNanos() returns long {
                if (this.running) { return this.accumNs + (Time.nanos() - this.startNs); }
                return this.accumNs;
            }
            public method elapsedMillis() returns long { return this.elapsedNanos() / 1000000; }
        }
        // A calendar date as year/month/day (spec 34): leap-year and month-length rules, conversion to and
        // from a day number counted from 1970-01-01, day of week (0=Sunday), and date arithmetic via
        // addDays. The civil<->days conversions are the standard proleptic-Gregorian algorithm.
        public class Date {
            private mutable int y;
            private mutable int mo;
            private mutable int d;
            public constructor Date(int year, int month, int day) {
                this.y = year;
                this.mo = month;
                this.d = day;
            }
            public method year() returns int { return this.y; }
            public method month() returns int { return this.mo; }
            public method day() returns int { return this.d; }
            public static method isLeap(int year) returns boolean {
                return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
            }
            public static method daysInMonth(int year, int month) returns int {
                if (month == 2) {
                    if (Date.isLeap(year)) { return 29; }
                    return 28;
                }
                if (month == 4 || month == 6 || month == 9 || month == 11) { return 30; }
                return 31;
            }
            public method toEpochDay() returns int {
                mutable int yy = this.y;
                if (this.mo <= 2) { yy = yy - 1; }
                int era = yy / 400;
                int yoe = yy - era * 400;
                mutable int mp = this.mo;
                if (mp > 2) { mp = mp - 3; } else { mp = mp + 9; }
                int doy = (153 * mp + 2) / 5 + this.d - 1;
                int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
                return era * 146097 + doe - 719468;
            }
            public method dayOfWeek() returns int {
                int e = this.toEpochDay();
                return (e + 4) % 7;
            }
            public static method fromEpochDay(int z0) returns Date {
                int z = z0 + 719468;
                int era = z / 146097;
                int doe = z - era * 146097;
                int yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
                mutable int y = yoe + era * 400;
                int doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
                int mp = (5 * doy + 2) / 153;
                int d = doy - (153 * mp + 2) / 5 + 1;
                mutable int m = mp;
                if (mp < 10) { m = mp + 3; } else { m = mp - 9; }
                if (m <= 2) { y = y + 1; }
                return new Date(y, m, d) on heap;
            }
            public method addDays(int n) returns Date {
                return Date.fromEpochDay(this.toEpochDay() + n);
            }
        }
        // Calendar arithmetic (spec 34): leap years, days in a month, day of the week (0=Sunday..6=Saturday
        // via Zeller's congruence) and day of the year.
        public class Calendar {
            public static method isLeapYear(int y) returns boolean {
                if (y % 400 == 0) { return true; }
                if (y % 100 == 0) { return false; }
                return y % 4 == 0;
            }
            public static method daysInMonth(int y, int m) returns int {
                if (m == 2) { if (Calendar.isLeapYear(y)) { return 29; } return 28; }
                if (m == 4 || m == 6 || m == 9 || m == 11) { return 30; }
                return 31;
            }
            public static method dayOfWeek(int year, int month, int day) returns int {
                mutable int m = month;
                mutable int y = year;
                if (m < 3) { m = m + 12; y = y - 1; }
                int k = y % 100;
                int j = y / 100;
                int h = (day + (13 * (m + 1)) / 5 + k + k / 4 + j / 4 + 5 * j) % 7;
                return (h + 6) % 7;
            }
            public static method dayOfYear(int y, int m, int d) returns int {
                mutable int total = d;
                for (mutable int mm = 1; mm < m; mm++) { total = total + Calendar.daysInMonth(y, mm); }
                return total;
            }
        }
    }
)LDP3"
// (split: System.Json in its own literal.)
R"LDP3(
    public namespace System.Json {
        // A JSON value (spec 34). kind: 0=null, 1=bool, 2=number(long), 3=string, 4=array, 5=object.
        // Built and read with pure-LDP3 code over System.Collections + System.Text.
        public class Json {
            private mutable int kind;
            private mutable boolean b;
            private mutable long num;
            private mutable String str;
            private mutable String memberKey;   // the key, when this node is an object member
            private mutable nullable Json* firstChild;   // array elements / object members (sibling chain)
            private mutable nullable Json* lastChild;    // tail, for O(1) append
            private mutable nullable Json* nextSibling;
            private mutable int childCount;
            public constructor Json(int k) {
                this.kind = k;
                this.b = false;
                this.num = cast<long>(0);
                this.str = "";
                this.memberKey = "";
                this.firstChild = null;
                this.lastChild = null;
                this.nextSibling = null;
                this.childCount = 0;
            }
            public static method ofNull() returns Json { return new Json(0) on heap; }
            public static method ofBool(boolean v) returns Json {
                Json j = new Json(1) on heap; j.b = v; return j;
            }
            public static method ofNum(long v) returns Json {
                Json j = new Json(2) on heap; j.num = v; return j;
            }
            public static method ofStr(String v) returns Json {
                Json j = new Json(3) on heap; j.str = v; return j;
            }
            public static method array() returns Json { return new Json(4) on heap; }
            public static method object() returns Json { return new Json(5) on heap; }
            public method add(Json* v) returns void {  // append a child (array element / member)
                if (this.lastChild == null) { this.firstChild = v; } else { this.lastChild.nextSibling = v; }
                this.lastChild = v;
                this.childCount = this.childCount + 1;
            }
            public method put(String key, Json* v) returns void { v.memberKey = key; this.add(v); }
            public method kindOf() returns int { return this.kind; }
            public method asBool() returns boolean { return this.b; }
            public method asNum() returns long { return this.num; }
            public method asStr() returns String { return this.str; }
            public method size() returns int { return this.childCount; }
            public method at(int i) returns nullable Json {
                mutable nullable Json* cur = this.firstChild;
                for (mutable int j = 0; j < i; j++) { cur = cur.nextSibling; }
                return cur;
            }
            public method field(String key) returns nullable Json {
                mutable nullable Json* cur = this.firstChild;
                while (cur != null) {
                    if (cur.memberKey.equals(key)) { return cur; }
                    cur = cur.nextSibling;
                }
                return Json.ofNull();
            }
            private method escapeInto(StringBuilder& sb, String s) returns void {
                sb.appendChar('"');
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c == '"') { sb.appendChar('\\'); sb.appendChar('"'); }
                    else {
                        if (c == '\\') { sb.appendChar('\\'); sb.appendChar('\\'); }
                        else { sb.appendChar(c); }
                    }
                }
                sb.appendChar('"');
            }
            private method writeInto(StringBuilder& sb) returns void {
                if (this.kind == 0) { sb.append("null"); return; }
                if (this.kind == 1) {
                    if (this.b) { sb.append("true"); } else { sb.append("false"); }
                    return;
                }
                if (this.kind == 2) { sb.append(this.num.toString()); return; }
                if (this.kind == 3) { this.escapeInto(sb, this.str); return; }
                if (this.kind == 4) {
                    sb.appendChar('[');
                    mutable nullable Json* cur = this.firstChild;
                    mutable boolean first = true;
                    while (cur != null) {
                        if (!first) { sb.appendChar(','); }
                        first = false;
                        cur.writeInto(sb);
                        cur = cur.nextSibling;
                    }
                    sb.appendChar(']');
                    return;
                }
                sb.appendChar('{');
                mutable nullable Json* m = this.firstChild;
                mutable boolean firstM = true;
                while (m != null) {
                    if (!firstM) { sb.appendChar(','); }
                    firstM = false;
                    this.escapeInto(sb, m.memberKey);
                    sb.appendChar(':');
                    m.writeInto(sb);
                    m = m.nextSibling;
                }
                sb.appendChar('}');
            }
            public method toString() returns String {
                StringBuilder sb = new StringBuilder() on heap;
                this.writeInto(sb);
                return sb.toString();
            }
            private method pad(StringBuilder& sb, int n) returns void {
                for (mutable int i = 0; i < n; i++) { sb.appendChar(' '); }
                return;
            }
            private method prettyInto(StringBuilder& sb, int depth) returns void {
                if (this.kind == 0) { sb.append("null"); return; }
                if (this.kind == 1) { if (this.b) { sb.append("true"); } else { sb.append("false"); } return; }
                if (this.kind == 2) { sb.append(this.num.toString()); return; }
                if (this.kind == 3) { this.escapeInto(sb, this.str); return; }
                if (this.kind == 4) {
                    if (this.childCount == 0) { sb.append("[]"); return; }
                    sb.appendChar('['); sb.appendChar('\n');
                    mutable nullable Json* cur = this.firstChild;
                    mutable boolean first = true;
                    while (cur != null) {
                        if (!first) { sb.appendChar(','); sb.appendChar('\n'); }
                        first = false;
                        this.pad(sb, depth + 2);
                        cur.prettyInto(sb, depth + 2);
                        cur = cur.nextSibling;
                    }
                    sb.appendChar('\n'); this.pad(sb, depth); sb.appendChar(']');
                    return;
                }
                if (this.childCount == 0) { sb.append("{}"); return; }
                sb.appendChar('{'); sb.appendChar('\n');
                mutable nullable Json* m = this.firstChild;
                mutable boolean firstM = true;
                while (m != null) {
                    if (!firstM) { sb.appendChar(','); sb.appendChar('\n'); }
                    firstM = false;
                    this.pad(sb, depth + 2);
                    this.escapeInto(sb, m.memberKey);
                    sb.appendChar(':'); sb.appendChar(' ');
                    m.prettyInto(sb, depth + 2);
                    m = m.nextSibling;
                }
                sb.appendChar('\n'); this.pad(sb, depth); sb.appendChar('}');
                return;
            }
            public method prettyString() returns String {   // indented multi-line JSON
                StringBuilder sb = new StringBuilder() on heap;
                this.prettyInto(sb, 0);
                return sb.toString();
            }
            public static method parse(String src) returns Json {
                JsonParser p = new JsonParser(src) on heap;
                return p.parseValue();
            }
        }
        // JSON Pointer (RFC 6901): resolve a "/a/0/b" path against a Json tree, stepping into object members
        // by key and array elements by index. Returns null if any step is missing or out of range.
        public class JsonPointer {
            private static method parseIndex(String s) returns int {
                if (s.length() == 0) { return -1; }
                mutable int v = 0;
                for (mutable int i = 0; i < s.length(); i++) {
                    char c = s.charAt(i);
                    if (c < '0' || c > '9') { return -1; }
                    v = v * 10 + (cast<int>(c) - cast<int>('0'));
                }
                return v;
            }
            public static method resolve(Json* root, String ptr) returns nullable Json {
                mutable nullable Json* cur = root;
                if (ptr.length() == 0) { return cur; }
                mutable int i = 0;
                if (ptr.charAt(0) == '/') { i = 1; }
                mutable StringBuilder tok = new StringBuilder() on heap;
                while (i <= ptr.length()) {
                    boolean atEnd = i == ptr.length();
                    if (atEnd || ptr.charAt(i) == '/') {
                        String t = tok.toString();
                        if (cur == null) { return null; }
                        int k = cur.kindOf();
                        if (k == 5) { cur = cur.field(t); }
                        else {
                            if (k == 4) {
                                int idx = JsonPointer.parseIndex(t);
                                if (idx < 0 || idx >= cur.size()) { return null; }
                                cur = cur.at(idx);
                            } else { return null; }
                        }
                        tok = new StringBuilder() on heap;
                    } else {
                        tok.appendChar(ptr.charAt(i));
                    }
                    i = i + 1;
                }
                return cur;
            }
        }
        // Recursive-descent JSON parser (minimal: null/bool/integer/string/array/object).
        public class JsonParser {
            private mutable String s;
            private mutable int pos;
            public constructor JsonParser(String src) { this.s = src; this.pos = 0; }
            private method skipWs() returns void {
                while (this.pos < this.s.length()) {
                    char c = this.s.charAt(this.pos);
                    if (c == ' ' || c == '\t' || c == '\n' || c == '\r') { this.pos = this.pos + 1; }
                    else { return; }
                }
            }
            private method parseString() returns String {
                StringBuilder sb = new StringBuilder() on heap;
                this.pos = this.pos + 1;  // opening quote
                while (this.pos < this.s.length()) {
                    char c = this.s.charAt(this.pos);
                    this.pos = this.pos + 1;
                    if (c == '"') { return sb.toString(); }
                    if (c == '\\') {
                        char e = this.s.charAt(this.pos);
                        this.pos = this.pos + 1;
                        if (e == 'n') { sb.appendChar('\n'); }
                        else { if (e == 't') { sb.appendChar('\t'); } else { sb.appendChar(e); } }
                    } else { sb.appendChar(c); }
                }
                return sb.toString();
            }
            public method parseValue() returns Json {
                this.skipWs();
                char c = this.s.charAt(this.pos);
                if (c == '{') { return this.parseObject(); }
                if (c == '[') { return this.parseArray(); }
                if (c == '"') { return Json.ofStr(this.parseString()); }
                if (c == 't') { this.pos = this.pos + 4; return Json.ofBool(true); }
                if (c == 'f') { this.pos = this.pos + 5; return Json.ofBool(false); }
                if (c == 'n') { this.pos = this.pos + 4; return Json.ofNull(); }
                mutable boolean neg = false;
                if (c == '-') { neg = true; this.pos = this.pos + 1; }
                mutable long acc = cast<long>(0);
                mutable boolean more = true;
                while (more && this.pos < this.s.length()) {
                    char d = this.s.charAt(this.pos);
                    if (d >= '0' && d <= '9') {
                        acc = acc * cast<long>(10) + cast<long>(d - '0');
                        this.pos = this.pos + 1;
                    } else { more = false; }
                }
                if (neg) { acc = cast<long>(0) - acc; }
                return Json.ofNum(acc);
            }
            private method parseArray() returns Json {
                Json arr = Json.array();
                this.pos = this.pos + 1;  // '['
                this.skipWs();
                if (this.s.charAt(this.pos) == ']') { this.pos = this.pos + 1; return arr; }
                while (true) {
                    arr.add(this.parseValue());
                    this.skipWs();
                    char c = this.s.charAt(this.pos);
                    this.pos = this.pos + 1;  // ',' or ']'
                    if (c == ']') { return arr; }
                }
                return arr;  // unreachable; satisfies the return-type checker
            }
            private method parseObject() returns Json {
                Json obj = Json.object();
                this.pos = this.pos + 1;  // '{'
                this.skipWs();
                if (this.s.charAt(this.pos) == '}') { this.pos = this.pos + 1; return obj; }
                while (true) {
                    this.skipWs();
                    String key = this.parseString();
                    this.skipWs();
                    this.pos = this.pos + 1;  // ':'
                    obj.put(key, this.parseValue());
                    this.skipWs();
                    char c = this.s.charAt(this.pos);
                    this.pos = this.pos + 1;  // ',' or '}'
                    if (c == '}') { return obj; }
                }
                return obj;  // unreachable; satisfies the return-type checker
            }
        }
    }
)LDP3"
// (split: System.Math reopened for BigInteger, its own literal.)
R"LDP3(
    public namespace System.Math {
        // Arbitrary-precision integer (spec 34): decimal digits (0..9) stored least-significant
        // first in an int[] (arrays of int work; this avoids the ArrayList<class> path). Supports
        // construction from long, same-sign add, multiply, compareTo, toString.
        public class BigInteger {
            private mutable int[] dig;
            private mutable int len;
            private mutable boolean neg;
            public constructor BigInteger(long value) {
                this.neg = value < cast<long>(0);
                mutable long v = value;
                if (this.neg) { v = cast<long>(0) - v; }
                this.dig = new int[24]();
                this.len = 1;
                this.dig[0] = 0;
                if (v > cast<long>(0)) {
                    this.len = 0;
                    while (v > cast<long>(0)) {
                        this.dig[this.len] = cast<int>(v % cast<long>(10));
                        v = v / cast<long>(10);
                        this.len = this.len + 1;
                    }
                }
            }
            private method ensure(int n) returns void {
                if (n <= this.dig.length()) { return; }
                mutable int cap = this.dig.length() * 2;
                while (cap < n) { cap = cap * 2; }
                mutable int[] nd = new int[cap]();
                for (mutable int i = 0; i < this.len; i++) { nd[i] = this.dig[i]; }
                delete this.dig;
                this.dig = nd;
            }
            public method isZero() returns boolean { return this.len == 1 && this.dig[0] == 0; }
            private method cmpMag(BigInteger o) returns int {  // compare magnitudes, ignoring sign
                if (this.len != o.len) { return this.len < o.len ? -1 : 1; }
                for (mutable int i = this.len - 1; i >= 0; i--) {
                    if (this.dig[i] != o.dig[i]) { return this.dig[i] < o.dig[i] ? -1 : 1; }
                }
                return 0;
            }
            private method copyMag() returns BigInteger {  // a fresh non-negative copy of this magnitude
                BigInteger r = new BigInteger(cast<long>(0)) on heap;
                r.ensure(this.len + 1);
                r.len = this.len;
                for (mutable int i = 0; i < this.len; i++) { r.dig[i] = this.dig[i]; }
                r.neg = false;
                return r;
            }
            private method subInPlace(BigInteger o) returns void {  // this.mag -= o.mag; assumes this.mag >= o.mag
                mutable int borrow = 0;
                mutable int i = 0;
                while (i < this.len) {
                    mutable int s = this.dig[i] - borrow;
                    if (i < o.len) { s = s - o.dig[i]; }
                    if (s < 0) { s = s + 10; borrow = 1; } else { borrow = 0; }
                    this.dig[i] = s;
                    i = i + 1;
                }
                while (this.len > 1 && this.dig[this.len - 1] == 0) { this.len = this.len - 1; }
            }
            private method mulTenAddInPlace(int d) returns void {  // this.mag = this.mag * 10 + d
                if (this.len == 1 && this.dig[0] == 0) { this.dig[0] = d; return; }
                this.ensure(this.len + 1);
                for (mutable int i = this.len; i > 0; i--) { this.dig[i] = this.dig[i - 1]; }
                this.dig[0] = d;
                this.len = this.len + 1;
            }
            private static method normSign(BigInteger r) returns void {  // -0 -> +0
                if (r.len == 1 && r.dig[0] == 0) { r.neg = false; }
            }
            private static method addMag(BigInteger a, BigInteger b) returns BigInteger {
                BigInteger r = new BigInteger(cast<long>(0)) on heap;
                int n = a.len > b.len ? a.len : b.len;
                r.ensure(n + 2);
                mutable int carry = 0;
                mutable int i = 0;
                r.len = 0;
                while (i < n || carry > 0) {
                    mutable int s = carry;
                    if (i < a.len) { s = s + a.dig[i]; }
                    if (i < b.len) { s = s + b.dig[i]; }
                    r.dig[i] = s % 10;
                    carry = s / 10;
                    i = i + 1;
                    r.len = i;
                }
                return r;
            }
            private method addSigned(BigInteger other, boolean otherNeg) returns BigInteger {
                if (this.neg == otherNeg) {   // like signs: add magnitudes, keep the sign
                    BigInteger r = BigInteger.addMag(this, other);
                    r.neg = this.neg;
                    BigInteger.normSign(r);
                    return r;
                }
                int c = this.cmpMag(other);   // unlike signs: the larger magnitude decides the sign
                if (c == 0) { return new BigInteger(cast<long>(0)) on heap; }
                if (c > 0) {
                    BigInteger r = this.copyMag();
                    r.subInPlace(other);
                    r.neg = this.neg;
                    BigInteger.normSign(r);
                    return r;
                }
                BigInteger r2 = other.copyMag();
                r2.subInPlace(this);
                r2.neg = otherNeg;
                BigInteger.normSign(r2);
                return r2;
            }
            public method add(BigInteger other) returns BigInteger { return this.addSigned(other, other.neg); }
            public method subtract(BigInteger other) returns BigInteger {
                boolean flipped = other.isZero() ? false : (other.neg == false);  // this - other = this + (-other)
                return this.addSigned(other, flipped);
            }
            public method multiply(BigInteger other) returns BigInteger {
                BigInteger r = new BigInteger(cast<long>(0)) on heap;
                int n = this.len + other.len;
                r.ensure(n + 1);
                r.len = n;
                for (mutable int i = 0; i < n; i++) { r.dig[i] = 0; }
                for (mutable int i = 0; i < this.len; i++) {
                    for (mutable int j = 0; j < other.len; j++) {
                        r.dig[i + j] = r.dig[i + j] + this.dig[i] * other.dig[j];
                    }
                }
                mutable int carry = 0;
                for (mutable int k = 0; k < n; k++) {
                    int s = r.dig[k] + carry;
                    r.dig[k] = s % 10;
                    carry = s / 10;
                }
                while (r.len > 1 && r.dig[r.len - 1] == 0) { r.len = r.len - 1; }
                r.neg = this.neg != other.neg;
                return r;
            }
            public method compareTo(BigInteger other) returns int {  // sign-aware
                boolean nt = this.neg && (this.isZero() == false);
                boolean no = other.neg && (other.isZero() == false);
                if (nt && (no == false)) { return -1; }
                if ((nt == false) && no) { return 1; }
                if (nt && no) { return 0 - this.cmpMag(other); }   // both negative: order reverses
                return this.cmpMag(other);
            }
            public method divide(BigInteger other) returns BigInteger {   // truncated toward zero
                if (other.isZero()) { return new BigInteger(cast<long>(0)) on heap; }
                BigInteger q = new BigInteger(cast<long>(0)) on heap;
                q.ensure(this.len + 1);
                q.len = this.len;
                for (mutable int z = 0; z < q.len; z++) { q.dig[z] = 0; }
                BigInteger rem = new BigInteger(cast<long>(0)) on heap;   // running remainder magnitude
                for (mutable int i = this.len - 1; i >= 0; i--) {
                    rem.mulTenAddInPlace(this.dig[i]);                    // bring down the next digit
                    mutable int d = 0;
                    while (rem.cmpMag(other) >= 0) { rem.subInPlace(other); d = d + 1; }
                    q.dig[i] = d;
                }
                while (q.len > 1 && q.dig[q.len - 1] == 0) { q.len = q.len - 1; }
                q.neg = this.neg != other.neg;
                BigInteger.normSign(q);
                return q;
            }
            public method remainder(BigInteger other) returns BigInteger {   // sign follows the dividend
                if (other.isZero()) { return new BigInteger(cast<long>(0)) on heap; }
                BigInteger rem = new BigInteger(cast<long>(0)) on heap;
                for (mutable int i = this.len - 1; i >= 0; i--) {
                    rem.mulTenAddInPlace(this.dig[i]);
                    while (rem.cmpMag(other) >= 0) { rem.subInPlace(other); }
                }
                rem.neg = this.neg;
                BigInteger.normSign(rem);
                return rem;
            }
            public method toString() returns String {
                StringBuilder sb = new StringBuilder() on heap;
                if (this.neg && this.isZero() == false) { sb.appendChar('-'); }
                for (mutable int i = this.len - 1; i >= 0; i--) {
                    sb.appendChar(cast<char>(48 + this.dig[i]));
                }
                return sb.toString();
            }
        }
)LDP3"
R"LDP3(
        // Integer math helpers (spec 34.6): gcd/lcm (Euclid), factorial, primality by trial division,
        // integer power and integer square root. All operate on plain ints, no floating point. (Named
        // IntMath, not MathX, to avoid shadowing a user class.)
        public class IntMath {
            public static method gcd(int a, int b) returns int {
                mutable int x = a;
                if (x < 0) { x = 0 - x; }
                mutable int y = b;
                if (y < 0) { y = 0 - y; }
                while (y != 0) {
                    int t = y;
                    y = x % y;
                    x = t;
                }
                return x;
            }
            public static method lcm(int a, int b) returns int {
                if (a == 0 || b == 0) { return 0; }
                int g = IntMath.gcd(a, b);
                int r = (a / g) * b;
                if (r < 0) { return 0 - r; }
                return r;
            }
            public static method factorial(int n) returns int {
                mutable int r = 1;
                for (mutable int i = 2; i <= n; i++) { r = r * i; }
                return r;
            }
            public static method isPrime(int n) returns boolean {
                if (n < 2) { return false; }
                mutable int i = 2;
                while (i * i <= n) {
                    if (n % i == 0) { return false; }
                    i = i + 1;
                }
                return true;
            }
            public static method ipow(int base, int exp) returns int {
                mutable int r = 1;
                for (mutable int i = 0; i < exp; i++) { r = r * base; }
                return r;
            }
            public static method isqrt(int n) returns int {
                if (n < 0) { return 0; }
                mutable int r = 0;
                while ((r + 1) * (r + 1) <= n) { r = r + 1; }
                return r;
            }
            // Binomial coefficient n-choose-r, multiplying and dividing as it goes so the running value
            // stays an exact integer and does not overflow as fast as n! would.
            public static method nCr(int n, int r) returns int {
                if (r < 0 || r > n) { return 0; }
                mutable int k = r;
                if (k > n - k) { k = n - k; }
                mutable int result = 1;
                for (mutable int i = 1; i <= k; i++) { result = result * (n - k + i) / i; }
                return result;
            }
            // Number of ordered arrangements of r items from n: n * (n-1) * ... * (n-r+1).
            public static method nPr(int n, int r) returns int {
                if (r < 0 || r > n) { return 0; }
                mutable int result = 1;
                for (mutable int i = 0; i < r; i++) { result = result * (n - i); }
                return result;
            }
            // Modular exponentiation base^exp mod m by repeated squaring (spec 34.6), using 64-bit
            // intermediates so the products do not overflow for moduli up to ~2^31.
            public static method modpow(int base, int exp, int mod) returns int {
                mutable long result = cast<long>(1);
                mutable long b = cast<long>(base % mod);
                mutable int e = exp;
                while (e > 0) {
                    if (e % 2 == 1) { result = (result * b) % cast<long>(mod); }
                    b = (b * b) % cast<long>(mod);
                    e = e / 2;
                }
                return cast<int>(result);
            }
            // Sum of the decimal digits of |n| (spec 34.6).
            public static method digitSum(int n) returns int {
                mutable int x = n;
                if (x < 0) { x = 0 - x; }
                mutable int s = 0;
                while (x > 0) {
                    s = s + x % 10;
                    x = x / 10;
                }
                return s;
            }
            // The digits of |n| reversed, as an integer (e.g. 123 -> 321).
            public static method reverseDigits(int n) returns int {
                mutable int x = n;
                if (x < 0) { x = 0 - x; }
                mutable int r = 0;
                while (x > 0) {
                    r = r * 10 + x % 10;
                    x = x / 10;
                }
                return r;
            }
            // Whether n is a non-negative decimal palindrome.
            public static method isPalindrome(int n) returns boolean {
                return n >= 0 && IntMath.reverseDigits(n) == n;
            }
        }
        // An exact fraction kept in lowest terms with a positive denominator (spec 34.6). The constructor
        // divides out the gcd and normalizes the sign; arithmetic returns new reduced Rationals.
        public class Rational {
            private mutable int num;
            private mutable int den;
            public constructor Rational(int n, int d) {
                mutable int g = IntMath.gcd(n, d);
                if (g == 0) { g = 1; }
                mutable int sign = 1;
                if (d < 0) { sign = 0 - 1; }
                this.num = sign * n / g;
                this.den = sign * d / g;
            }
            public method numerator() returns int { return this.num; }
            public method denominator() returns int { return this.den; }
            public method add(Rational o) returns Rational {
                return new Rational(this.num * o.denominator() + o.numerator() * this.den,
                                    this.den * o.denominator()) on heap;
            }
            public method sub(Rational o) returns Rational {
                return new Rational(this.num * o.denominator() - o.numerator() * this.den,
                                    this.den * o.denominator()) on heap;
            }
            public method mul(Rational o) returns Rational {
                return new Rational(this.num * o.numerator(), this.den * o.denominator()) on heap;
            }
            public method toDouble() returns double {
                return cast<double>(this.num) / cast<double>(this.den);
            }
        }
        // A complex number with double real and imaginary parts (spec 34.6): add/sub/mul and conjugate.
        public class Complex {
            private mutable double re;
            private mutable double im;
            public constructor Complex(double re, double im) {
                this.re = re;
                this.im = im;
            }
            public method real() returns double { return this.re; }
            public method imag() returns double { return this.im; }
            public method add(Complex o) returns Complex {
                return new Complex(this.re + o.real(), this.im + o.imag()) on heap;
            }
            public method sub(Complex o) returns Complex {
                return new Complex(this.re - o.real(), this.im - o.imag()) on heap;
            }
            public method mul(Complex o) returns Complex {
                return new Complex(this.re * o.real() - this.im * o.imag(),
                                   this.re * o.imag() + this.im * o.real()) on heap;
            }
            public method conjugate() returns Complex {
                return new Complex(this.re, 0.0 - this.im) on heap;
            }
        }
        // Summary statistics over an int array (spec 34.6): sum, integer mean, minimum and maximum.
        public class Stats {
            public static method sum(int[] xs) returns int {
                mutable int s = 0;
                for (mutable int i = 0; i < xs.length(); i++) { s = s + xs[i]; }
                return s;
            }
            public static method mean(int[] xs) returns int {
                if (xs.length() == 0) { return 0; }
                return Stats.sum(xs) / xs.length();
            }
            public static method min(int[] xs) returns int {
                mutable int m = xs[0];
                for (mutable int i = 1; i < xs.length(); i++) { if (xs[i] < m) { m = xs[i]; } }
                return m;
            }
            public static method max(int[] xs) returns int {
                mutable int m = xs[0];
                for (mutable int i = 1; i < xs.length(); i++) { if (xs[i] > m) { m = xs[i]; } }
                return m;
            }
            // Population variance about the integer mean (spec 34.6): the mean of the squared deviations.
            public static method variance(int[] xs) returns int {
                if (xs.length() == 0) { return 0; }
                int mean = Stats.mean(xs);
                mutable int acc = 0;
                for (mutable int i = 0; i < xs.length(); i++) {
                    int d = xs[i] - mean;
                    acc = acc + d * d;
                }
                return acc / xs.length();
            }
            // Population standard deviation, the integer square root of the variance.
            public static method stddev(int[] xs) returns int {
                return IntMath.isqrt(Stats.variance(xs));
            }
            // The middle value of a sorted copy (spec 34.6); for an even count this is the upper-middle.
            public static method median(int[] xs) returns int {
                int n = xs.length();
                if (n == 0) { return 0; }
                mutable int[] c = new int[n]();
                for (mutable int i = 0; i < n; i++) { c[i] = xs[i]; }
                for (mutable int i = 1; i < n; i++) {
                    int key = c[i];
                    mutable int j = i - 1;
                    while (j >= 0 && c[j] > key) {
                        c[j + 1] = c[j];
                        j = j - 1;
                    }
                    c[j + 1] = key;
                }
                return c[n / 2];
            }
            // Sum of all values (spec 34.6).
            public static method sum(int[] xs) returns int {
                mutable int s = 0;
                for (mutable int i = 0; i < xs.length(); i++) { s = s + xs[i]; }
                return s;
            }
            // Spread between the largest and smallest values.
            public static method range(int[] xs) returns int {
                if (xs.length() == 0) { return 0; }
                return Stats.max(xs) - Stats.min(xs);
            }
            // The most frequently occurring value; ties resolve to the first one reaching the top count.
            public static method mode(int[] xs) returns int {
                if (xs.length() == 0) { return 0; }
                mutable int best = xs[0];
                mutable int bestCount = 0;
                for (mutable int i = 0; i < xs.length(); i++) {
                    mutable int c = 0;
                    for (mutable int j = 0; j < xs.length(); j++) {
                        if (xs[j] == xs[i]) { c = c + 1; }
                    }
                    if (c > bestCount) {
                        bestCount = c;
                        best = xs[i];
                    }
                }
                return best;
            }
)LDP3"
// Split only for the MSVC literal-size limit; mid-class is fine since the literals are concatenated.
R"LDP3(
            // The value at the given percentile p in [0,100] of a sorted copy (spec 34.6), by nearest-rank
            // on the index (p of the way from first to last element).
            public static method percentile(int[] xs, int p) returns int {
                int n = xs.length();
                if (n == 0) { return 0; }
                mutable int[] c = new int[n]();
                for (mutable int i = 0; i < n; i++) { c[i] = xs[i]; }
                for (mutable int i = 1; i < n; i++) {
                    int key = c[i];
                    mutable int j = i - 1;
                    while (j >= 0 && c[j] > key) {
                        c[j + 1] = c[j];
                        j = j - 1;
                    }
                    c[j + 1] = key;
                }
                return c[(p * (n - 1)) / 100];
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Forward-mode automatic differentiation via dual numbers (spec 34.6): each value carries its
        // derivative alongside it, and the arithmetic propagates the chain rule. Evaluate a function with
        // variable(x) and the result's deriv() is the exact derivative at x; constant(c) has derivative 0.
        public class Dual {
            private mutable double v;
            private mutable double d;
            public constructor Dual(double value, double deriv) {
                this.v = value;
                this.d = deriv;
            }
            public static method variable(double x) returns Dual { return new Dual(x, 1.0) on heap; }
            public static method constant(double x) returns Dual { return new Dual(x, 0.0) on heap; }
            public method value() returns double { return this.v; }
            public method deriv() returns double { return this.d; }
            public method add(Dual o) returns Dual {
                return new Dual(this.v + o.value(), this.d + o.deriv()) on heap;
            }
            public method sub(Dual o) returns Dual {
                return new Dual(this.v - o.value(), this.d - o.deriv()) on heap;
            }
            public method mul(Dual o) returns Dual {
                return new Dual(this.v * o.value(), this.v * o.deriv() + this.d * o.value()) on heap;
            }
        }
        // A dense matrix of integers stored row-major in a flat array (spec 34.6): set/get by (row, col),
        // matrix multiply, transpose, and elementwise add. No per-element objects, just one int array.
        public class Matrix {
            private mutable int[] cells;
            private mutable int nrows;
            private mutable int ncols;
            public constructor Matrix(int rows, int cols) {
                this.nrows = rows;
                this.ncols = cols;
                this.cells = new int[rows * cols]();
            }
            public method rows() returns int { return this.nrows; }
            public method cols() returns int { return this.ncols; }
            public method set(int r, int c, int value) returns void {
                this.cells[r * this.ncols + c] = value;
                return;
            }
            public method get(int r, int c) returns int { return this.cells[r * this.ncols + c]; }
            public method multiply(Matrix o) returns Matrix {
                mutable Matrix m = new Matrix(this.nrows, o.cols()) on heap;
                for (mutable int i = 0; i < this.nrows; i++) {
                    for (mutable int j = 0; j < o.cols(); j++) {
                        mutable int s = 0;
                        for (mutable int k = 0; k < this.ncols; k++) { s = s + this.get(i, k) * o.get(k, j); }
                        m.set(i, j, s);
                    }
                }
                return m;
            }
            public method transpose() returns Matrix {
                mutable Matrix m = new Matrix(this.ncols, this.nrows) on heap;
                for (mutable int i = 0; i < this.nrows; i++) {
                    for (mutable int j = 0; j < this.ncols; j++) { m.set(j, i, this.get(i, j)); }
                }
                return m;
            }
            public method add(Matrix o) returns Matrix {
                mutable Matrix m = new Matrix(this.nrows, this.ncols) on heap;
                for (mutable int i = 0; i < this.nrows; i++) {
                    for (mutable int j = 0; j < this.ncols; j++) { m.set(i, j, this.get(i, j) + o.get(i, j)); }
                }
                return m;
            }
            // Exact integer determinant via the Bareiss fraction-free elimination (spec 34.6): every division
            // is exact, so it stays in integers. Returns 0 for a singular matrix; assumes a square matrix.
            public method determinant() returns int {
                int n = this.nrows;
                mutable int[] m = new int[n * n]();
                for (mutable int i = 0; i < n * n; i++) { m[i] = this.cells[i]; }
                mutable int prev = 1;
                mutable int sign = 1;
                for (mutable int k = 0; k < n - 1; k++) {
                    if (m[k * n + k] == 0) {
                        mutable int sw = 0 - 1;
                        for (mutable int r = k + 1; r < n; r++) {
                            if (m[r * n + k] != 0) { sw = r; }
                        }
                        if (sw < 0) { return 0; }
                        for (mutable int c = 0; c < n; c++) {
                            int t = m[k * n + c];
                            m[k * n + c] = m[sw * n + c];
                            m[sw * n + c] = t;
                        }
                        sign = 0 - sign;
                    }
                    for (mutable int i = k + 1; i < n; i++) {
                        for (mutable int j = k + 1; j < n; j++) {
                            m[i * n + j] = (m[i * n + j] * m[k * n + k] - m[i * n + k] * m[k * n + j]) / prev;
                        }
                    }
                    prev = m[k * n + k];
                }
                return sign * m[(n - 1) * n + (n - 1)];
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // A polynomial with integer coefficients in ascending order, coeff i multiplying x^i (spec 34.6).
        // evaluate uses Horner's method; derivative returns the differentiated polynomial.
        public class Polynomial {
            private mutable int[] c;
            public constructor Polynomial(int[] coeffs) { this.c = coeffs; }
            public method degree() returns int { return this.c.length() - 1; }
            public method coeff(int i) returns int {
                if (i < 0 || i >= this.c.length()) { return 0; }
                return this.c[i];
            }
            public method evaluate(int x) returns int {
                mutable int r = 0;
                for (mutable int i = this.c.length() - 1; i >= 0; i--) { r = r * x + this.c[i]; }
                return r;
            }
            public method derivative() returns Polynomial {
                if (this.c.length() <= 1) {
                    mutable int[] z = new int[1]();
                    return new Polynomial(z) on heap;
                }
                mutable int[] d = new int[this.c.length() - 1]();
                for (mutable int i = 1; i < this.c.length(); i++) { d[i - 1] = this.c[i] * i; }
                return new Polynomial(d) on heap;
            }
        }
        // A fixed-length vector of integers (spec 34.6): dot product and squared length. For the floating
        // SIMD vectors see the built-in vec2/vec3/vec4 types.
        public class IntVector {
            private mutable int[] e;
            public constructor IntVector(int[] elems) { this.e = elems; }
            public method get(int i) returns int { return this.e[i]; }
            public method size() returns int { return this.e.length(); }
            public method dot(IntVector o) returns int {
                mutable int s = 0;
                for (mutable int i = 0; i < this.e.length(); i++) { s = s + this.e[i] * o.get(i); }
                return s;
            }
            public method normSquared() returns int {
                mutable int s = 0;
                for (mutable int i = 0; i < this.e.length(); i++) { s = s + this.e[i] * this.e[i]; }
                return s;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // The sieve of Eratosthenes up to a limit (spec 34.6): the constructor marks composites once, then
        // isPrime answers in constant time and count totals the primes found.
        public class Sieve {
            private mutable boolean[] composite;
            private mutable int limit;
            public constructor Sieve(int limit) {
                this.limit = limit;
                this.composite = new boolean[limit + 1]();
                for (mutable int i = 2; i * i <= limit; i++) {
                    if (!this.composite[i]) {
                        for (mutable int j = i * i; j <= limit; j = j + i) { this.composite[j] = true; }
                    }
                }
            }
            public method isPrime(int n) returns boolean {
                if (n < 2) { return false; }
                return !this.composite[n];
            }
            public method count() returns int {
                mutable int c = 0;
                for (mutable int i = 2; i <= this.limit; i++) {
                    if (!this.composite[i]) { c = c + 1; }
                }
                return c;
            }
        }
        // A fast deterministic pseudo-random generator (xorshift32, spec 34.6): the same seed always yields
        // the same sequence, unlike the wall-clock-seeded Random. next returns the raw 32 bits; nextInRange
        // maps to [0, n).
        public class Xorshift {
            private mutable uint state;
            public constructor Xorshift(int seed) {
                this.state = cast<uint>(seed);
                if (this.state == cast<uint>(0)) { this.state = cast<uint>(1); }
            }
            public method next() returns int {
                mutable uint x = this.state;
                x = x ^ (x << 13);
                x = x ^ (x >> 17);
                x = x ^ (x << 5);
                this.state = x;
                return cast<int>(x);
            }
            public method nextInRange(int n) returns int {
                int v = this.next();
                int r = v % n;
                if (r < 0) { return r + n; }
                return r;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // A dense linear-system solver (spec 34.6) via Gaussian elimination with partial pivoting. solve takes
        // the system as a flat row-major n-by-(n+1) augmented matrix [A|b] (which it overwrites) and returns
        // the solution vector x. Uses double throughout.
        public class GaussSolver {
            private static method dabs(double x) returns double { if (x < 0.0) { return 0.0 - x; } return x; }
            public static method solve(double[] aug, int n) returns double[] {
                int w = n + 1;
                for (mutable int col = 0; col < n; col++) {
                    mutable int piv = col;
                    for (mutable int r = col + 1; r < n; r++) {
                        if (GaussSolver.dabs(aug[r*w + col]) > GaussSolver.dabs(aug[piv*w + col])) { piv = r; }
                    }
                    if (piv != col) {
                        for (mutable int c = 0; c < w; c++) {
                            double tmp = aug[col*w + c];
                            aug[col*w + c] = aug[piv*w + c];
                            aug[piv*w + c] = tmp;
                        }
                    }
                    double d = aug[col*w + col];
                    for (mutable int r = col + 1; r < n; r++) {
                        double factor = aug[r*w + col] / d;
                        for (mutable int c = col; c < w; c++) {
                            aug[r*w + c] = aug[r*w + c] - factor * aug[col*w + c];
                        }
                    }
                }
                mutable double[] x = new double[n]();
                for (mutable int i = n - 1; i >= 0; i = i - 1) {
                    mutable double s = aug[i*w + n];
                    for (mutable int j = i + 1; j < n; j++) { s = s - aug[i*w + j] * x[j]; }
                    x[i] = s / aug[i*w + i];
                }
                return x;
            }
        }
        // Online mean and variance (spec 34.6) via Welford's algorithm: add samples one at a time in O(1) space,
        // then read the running mean and the population or sample variance without keeping the data.
        public class RunningStats {
            private mutable int cnt;
            private mutable double mean;
            private mutable double m2;
            public constructor RunningStats() {
                this.cnt = 0;
                this.mean = 0.0;
                this.m2 = 0.0;
            }
            public method add(double x) returns void {
                this.cnt = this.cnt + 1;
                double delta = x - this.mean;
                this.mean = this.mean + delta / cast<double>(this.cnt);
                double delta2 = x - this.mean;
                this.m2 = this.m2 + delta * delta2;
                return;
            }
            public method getMean() returns double { return this.mean; }
            public method populationVariance() returns double {
                if (this.cnt < 1) { return 0.0; }
                return this.m2 / cast<double>(this.cnt);
            }
            public method sampleVariance() returns double {
                if (this.cnt < 2) { return 0.0; }
                return this.m2 / cast<double>(this.cnt - 1);
            }
            public method count() returns int { return this.cnt; }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Number-theory toolkit (spec 34.6): gcd/lcm, fast modular exponentiation, deterministic Miller-Rabin
        // primality for 32-bit ints (witnesses 2,3,5,7), and modular inverse via the extended Euclidean
        // algorithm (returns -1 when a is not invertible mod m).
        public class NumberTheory {
            public static method gcd(int a, int b) returns int {
                mutable int x = a; if (x < 0) { x = 0 - x; }
                mutable int y = b; if (y < 0) { y = 0 - y; }
                while (y != 0) { int t = y; y = x % y; x = t; }
                return x;
            }
            public static method lcm(int a, int b) returns int {
                if (a == 0 || b == 0) { return 0; }
                return (a / NumberTheory.gcd(a, b)) * b;
            }
            public static method modpow(long base, long exp, long mod) returns long {
                mutable long result = 1;
                mutable long b = base % mod;
                mutable long e = exp;
                while (e > 0) {
                    if ((e & 1) == 1) { result = (result * b) % mod; }
                    b = (b * b) % mod;
                    e = e >> 1;
                }
                return result;
            }
            private static method millerTest(long d, long n, long a) returns boolean {
                mutable long x = NumberTheory.modpow(a, d, n);
                if (x == 1 || x == n - 1) { return true; }
                mutable long dd = d;
                while (dd != n - 1) {
                    x = (x * x) % n;
                    dd = dd * 2;
                    if (x == 1) { return false; }
                    if (x == n - 1) { return true; }
                }
                return false;
            }
            public static method isPrime(int num) returns boolean {
                long n = cast<long>(num);
                if (n < 2) { return false; }
                if (n < 4) { return true; }
                if (n % 2 == 0) { return false; }
                mutable long d = n - 1;
                while (d % 2 == 0) { d = d / 2; }
                if (cast<long>(2) < n && !NumberTheory.millerTest(d, n, 2)) { return false; }
                if (cast<long>(3) < n && !NumberTheory.millerTest(d, n, 3)) { return false; }
                if (cast<long>(5) < n && !NumberTheory.millerTest(d, n, 5)) { return false; }
                if (cast<long>(7) < n && !NumberTheory.millerTest(d, n, 7)) { return false; }
                return true;
            }
            public static method modInverse(int a, int m) returns int {
                mutable int t = 0; mutable int newt = 1;
                mutable int r = m; mutable int newr = a % m;
                while (newr != 0) {
                    int q = r / newr;
                    int tmpt = t - q * newt; t = newt; newt = tmpt;
                    int tmpr = r - q * newr; r = newr; newr = tmpr;
                }
                if (r > 1) { return -1; }
                if (t < 0) { t = t + m; }
                return t;
            }
        }
        // Chinese remainder theorem (spec 34.6): solve x = a[i] (mod n[i]) for pairwise-coprime moduli,
        // returning the least non-negative solution. Combines congruences one at a time using modInverse.
        public class Crt {
            public static method solve(int[] a, int[] n, int k) returns long {
                mutable long x = cast<long>(a[0]);
                mutable long m = cast<long>(n[0]);
                for (mutable int i = 1; i < k; i++) {
                    int ni = n[i];
                    long inv = cast<long>(NumberTheory.modInverse(cast<int>(m % cast<long>(ni)), ni));
                    long diff = ((cast<long>(a[i]) - x) % cast<long>(ni) + cast<long>(ni)) % cast<long>(ni);
                    long t = (diff * inv) % cast<long>(ni);
                    x = x + m * t;
                    m = m * cast<long>(ni);
                }
                return ((x % m) + m) % m;
            }
        }
        // Integer factorization by trial division (spec 34.6): the largest prime factor and the count of
        // prime factors with multiplicity.
        public class Factorize {
            public static method largestPrimeFactor(int num) returns int {
                mutable long m = cast<long>(num);
                mutable int largest = 1;
                mutable long d = 2;
                while (d * d <= m) {
                    while (m % d == 0) { largest = cast<int>(d); m = m / d; }
                    d = d + 1;
                }
                if (m > 1) { largest = cast<int>(m); }
                return largest;
            }
            public static method factorCount(int num) returns int {
                mutable int m = num;
                mutable int count = 0;
                mutable int d = 2;
                while (d * d <= m) {
                    while (m % d == 0) { count = count + 1; m = m / d; }
                    d = d + 1;
                }
                if (m > 1) { count = count + 1; }
                return count;
            }
        }
        // Combinatorics (spec 34.6): factorial and binomial coefficients in long, the nth Catalan number, and
        // an in-place next-lexicographic-permutation (returns false past the last permutation).
        public class Combinatorics {
            public static method factorial(int n) returns long {
                mutable long r = 1;
                for (mutable int i = 2; i <= n; i++) { r = r * cast<long>(i); }
                return r;
            }
            public static method choose(int n, int k) returns long {
                if (k < 0 || k > n) { return cast<long>(0); }
                mutable int kk = k;
                if (kk > n - kk) { kk = n - kk; }
                mutable long r = 1;
                for (mutable int i = 0; i < kk; i++) {
                    r = r * cast<long>(n - i);
                    r = r / cast<long>(i + 1);
                }
                return r;
            }
            public static method catalan(int n) returns long {
                return Combinatorics.choose(2 * n, n) / cast<long>(n + 1);
            }
            public static method nextPermutation(int[] a, int n) returns boolean {
                mutable int i = n - 2;
                while (i >= 0 && a[i] >= a[i + 1]) { i = i - 1; }
                if (i < 0) { return false; }
                mutable int j = n - 1;
                while (a[j] <= a[i]) { j = j - 1; }
                int tmp = a[i]; a[i] = a[j]; a[j] = tmp;
                mutable int lo = i + 1; mutable int hi = n - 1;
                while (lo < hi) { int t2 = a[lo]; a[lo] = a[hi]; a[hi] = t2; lo = lo + 1; hi = hi - 1; }
                return true;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Planar geometry over integer coordinates (spec 34.6): Polygon.area2 is twice the shoelace area
        // (kept doubled so integer inputs stay integer), and contains tests point-in-polygon by ray casting.
        public class Polygon {
            public static method area2(int[] xs, int[] ys, int n) returns int {
                mutable int s = 0;
                for (mutable int i = 0; i < n; i++) {
                    int j = (i + 1) % n;
                    s = s + xs[i] * ys[j] - xs[j] * ys[i];
                }
                if (s < 0) { s = 0 - s; }
                return s;
            }
            public static method contains(int[] xs, int[] ys, int n, int px, int py) returns boolean {
                mutable boolean inside = false;
                mutable int j = n - 1;
                for (mutable int i = 0; i < n; i++) {
                    boolean straddles = (ys[i] > py) != (ys[j] > py);
                    if (straddles) {
                        int dx = xs[j] - xs[i];
                        int dy = ys[j] - ys[i];
                        int lhs = (px - xs[i]) * dy;
                        int rhs = dx * (py - ys[i]);
                        if (dy > 0) {
                            if (lhs < rhs) { inside = !inside; }
                        } else {
                            if (lhs > rhs) { inside = !inside; }
                        }
                    }
                    j = i;
                }
                return inside;
            }
        }
        // Convex hull of a point set (spec 34.6) by Andrew's monotone chain; size returns the number of hull
        // vertices, dropping collinear points. Points are given as parallel xs/ys arrays.
        public class ConvexHull {
            private static method cross(int[] xs, int[] ys, int o, int a, int b) returns int {
                return (xs[a] - xs[o]) * (ys[b] - ys[o]) - (ys[a] - ys[o]) * (xs[b] - xs[o]);
            }
            public static method size(int[] xs, int[] ys, int n) returns int {
                if (n < 3) { return n; }
                mutable int[] idx = new int[n]();
                for (mutable int i = 0; i < n; i++) { idx[i] = i; }
                for (mutable int i = 1; i < n; i++) {
                    int key = idx[i];
                    mutable int j = i - 1;
                    while (j >= 0 && (xs[idx[j]] > xs[key] || (xs[idx[j]] == xs[key] && ys[idx[j]] > ys[key]))) {
                        idx[j + 1] = idx[j];
                        j = j - 1;
                    }
                    idx[j + 1] = key;
                }
                mutable int[] hull = new int[2 * n]();
                mutable int k = 0;
                for (mutable int t = 0; t < n; t++) {
                    int p = idx[t];
                    while (k >= 2 && ConvexHull.cross(xs, ys, hull[k-2], hull[k-1], p) <= 0) { k = k - 1; }
                    hull[k] = p; k = k + 1;
                }
                int lower = k + 1;
                for (mutable int t = n - 2; t >= 0; t = t - 1) {
                    int p = idx[t];
                    while (k >= lower && ConvexHull.cross(xs, ys, hull[k-2], hull[k-1], p) <= 0) { k = k - 1; }
                    hull[k] = p; k = k + 1;
                }
                return k - 1;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Count-Min sketch (spec 34.1): a sub-linear frequency estimator. add accumulates counts across depth
        // independent hash rows; estimate returns the minimum row, which never underestimates (and is exact
        // when the width is large enough to avoid collisions).
        public class CountMinSketch {
            private mutable int[] table;
            private mutable int d;
            private mutable int w;
            public constructor CountMinSketch(int width, int depth) {
                this.w = width;
                this.d = depth;
                this.table = new int[width * depth]();
            }
            private method hash(String key, int row) returns int {
                mutable int acc = 17 + row * 31;
                for (mutable int i = 0; i < key.length(); i++) {
                    acc = acc * 131 + (cast<int>(key.charAt(i)) & 255);
                }
                acc = acc & 2147483647;
                return acc % this.w;
            }
            public method add(String key, int count) returns void {
                for (mutable int r = 0; r < this.d; r++) {
                    int idx = r * this.w + this.hash(key, r);
                    this.table[idx] = this.table[idx] + count;
                }
                return;
            }
            public method estimate(String key) returns int {
                mutable int best = 2147483647;
                for (mutable int r = 0; r < this.d; r++) {
                    int v = this.table[r * this.w + this.hash(key, r)];
                    if (v < best) { best = v; }
                }
                return best;
            }
        }
        // HyperLogLog (spec 34.1): estimates the number of distinct items in near-constant memory. Each key's
        // hash picks a register (low bits) and contributes the rank of its leading one-bit; estimate combines
        // the registers, with linear counting in the small-cardinality range. precision is log2 of the register
        // count (e.g. 10 -> 1024 registers, ~3% error).
        public class HyperLogLog {
            private mutable int[] reg;
            private mutable int p;
            private mutable int m;
            public constructor HyperLogLog(int precision) {
                this.p = precision;
                this.m = 1 << precision;
                this.reg = new int[this.m]();
            }
            private static method mix(String s) returns uint {
                mutable uint h = cast<uint>(2166136261);
                for (mutable int i = 0; i < s.length(); i++) {
                    h = (h ^ cast<uint>(cast<int>(s.charAt(i)) & 255)) * cast<uint>(16777619);
                }
                h = h ^ (h >> 16);
                h = h * cast<uint>(2246822519);
                h = h ^ (h >> 13);
                h = h * cast<uint>(3266489917);
                h = h ^ (h >> 16);
                return h;
            }
            private static method clz(uint x) returns int {
                if (x == cast<uint>(0)) { return 32; }
                mutable int n = 0;
                mutable uint v = x;
                while ((v & cast<uint>(2147483648)) == cast<uint>(0)) { n = n + 1; v = v << 1; }
                return n;
            }
            // Natural log without the Math builtin (whose bare name can bind to a user class named Math):
            // reduce x to [1,2) tracking the power of two, then sum the atanh series.
            private static method ln(double x) returns double {
                if (x <= 0.0) { return 0.0; }
                mutable double v = x;
                mutable int e = 0;
                while (v >= 2.0) { v = v / 2.0; e = e + 1; }
                while (v < 1.0) { v = v * 2.0; e = e - 1; }
                double t = (v - 1.0) / (v + 1.0);
                double t2 = t * t;
                mutable double term = t;
                mutable double sum = 0.0;
                mutable int k = 1;
                while (k <= 15) {
                    sum = sum + term / cast<double>(k);
                    term = term * t2;
                    k = k + 2;
                }
                return 2.0 * sum + cast<double>(e) * 0.6931471805599453;
            }
            public method add(String key) returns void {
                uint h = HyperLogLog.mix(key);
                int idx = cast<int>(h & cast<uint>(this.m - 1));
                uint rest = (h >> this.p) | (cast<uint>(1) << (31 - this.p));
                mutable int rank = HyperLogLog.clz(rest) + 1 - this.p;
                if (rank < 1) { rank = 1; }
                if (rank > this.reg[idx]) { this.reg[idx] = rank; }
                return;
            }
            public method estimate() returns int {
                double alpha = 0.7213 / (1.0 + 1.079 / cast<double>(this.m));
                mutable double sum = 0.0;
                mutable int zeros = 0;
                for (mutable int i = 0; i < this.m; i++) {
                    sum = sum + 1.0 / cast<double>(1 << this.reg[i]);
                    if (this.reg[i] == 0) { zeros = zeros + 1; }
                }
                mutable double est = alpha * cast<double>(this.m) * cast<double>(this.m) / sum;
                if (est <= 2.5 * cast<double>(this.m) && zeros > 0) {
                    est = cast<double>(this.m) * HyperLogLog.ln(cast<double>(this.m) / cast<double>(zeros));
                }
                return cast<int>(est);
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Self-contained transcendental functions (spec 34.6) in pure LDP3, so scientific classes never
        // depend on the Math builtin (whose bare name can bind to a user class called Math). sqrt is Newton's
        // method; ln reduces to [1,2) then an atanh series; exp reduces by ln2 then a Taylor series; sin/cos
        // reduce modulo 2*pi then Taylor; pow is exp(e*ln(b)) for positive b.
        public class Numerics {
            public static method pi() returns double { return 3.14159265358979323846; }
            public static method abs(double x) returns double { if (x < 0.0) { return 0.0 - x; } return x; }
            public static method sqrt(double x) returns double {
                if (x <= 0.0) { return 0.0; }
                mutable double g = x;
                if (g > 1.0) { g = x / 2.0; }
                for (mutable int i = 0; i < 40; i++) { g = 0.5 * (g + x / g); }
                return g;
            }
            public static method ln(double x) returns double {
                if (x <= 0.0) { return 0.0; }
                mutable double v = x;
                mutable int e = 0;
                while (v >= 2.0) { v = v / 2.0; e = e + 1; }
                while (v < 1.0) { v = v * 2.0; e = e - 1; }
                double t = (v - 1.0) / (v + 1.0);
                double t2 = t * t;
                mutable double term = t;
                mutable double sum = 0.0;
                mutable int k = 1;
                while (k <= 25) { sum = sum + term / cast<double>(k); term = term * t2; k = k + 2; }
                return 2.0 * sum + cast<double>(e) * 0.6931471805599453;
            }
            public static method exp(double x) returns double {
                double ln2 = 0.6931471805599453;
                double xr = x / ln2;
                mutable int k = cast<int>(xr + 0.5);
                if (x < 0.0) { k = cast<int>(xr - 0.5); }
                double r = x - cast<double>(k) * ln2;
                mutable double term = 1.0;
                mutable double sum = 1.0;
                for (mutable int i = 1; i <= 18; i++) { term = term * r / cast<double>(i); sum = sum + term; }
                mutable double p = 1.0;
                mutable int kk = k;
                if (kk >= 0) { for (mutable int i = 0; i < kk; i++) { p = p * 2.0; } }
                else { for (mutable int i = 0; i < 0 - kk; i++) { p = p / 2.0; } }
                return sum * p;
            }
            private static method reduce(double x) returns double {
                double tau = 6.283185307179586;
                mutable double r = x;
                while (r > 3.141592653589793) { r = r - tau; }
                while (r < 0.0 - 3.141592653589793) { r = r + tau; }
                return r;
            }
            public static method sin(double x) returns double {
                double r = Numerics.reduce(x);
                double r2 = r * r;
                mutable double term = r;
                mutable double sum = r;
                mutable int n = 1;
                while (n <= 12) {
                    term = 0.0 - term * r2 / cast<double>((2*n) * (2*n + 1));
                    sum = sum + term;
                    n = n + 1;
                }
                return sum;
            }
            public static method cos(double x) returns double {
                double r = Numerics.reduce(x);
                double r2 = r * r;
                mutable double term = 1.0;
                mutable double sum = 1.0;
                mutable int n = 1;
                while (n <= 12) {
                    term = 0.0 - term * r2 / cast<double>((2*n - 1) * (2*n));
                    sum = sum + term;
                    n = n + 1;
                }
                return sum;
            }
            public static method pow(double b, double e) returns double {
                if (b <= 0.0) { return 0.0; }
                return Numerics.exp(e * Numerics.ln(b));
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Math namespace.
R"LDP3(
        // Interpolation helpers (spec 34.6): linear interpolate and its inverse, clamp, Hermite smoothstep,
        // and remap of a value from one range to another. Handy for animation and graphics.
        public class Interpolation {
            public static method lerp(double a, double b, double t) returns double { return a + (b - a) * t; }
            public static method inverseLerp(double a, double b, double v) returns double {
                if (b == a) { return 0.0; }
                return (v - a) / (b - a);
            }
            public static method clamp(double v, double lo, double hi) returns double {
                if (v < lo) { return lo; }
                if (v > hi) { return hi; }
                return v;
            }
            public static method smoothstep(double edge0, double edge1, double x) returns double {
                double t = Interpolation.clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
                return t * t * (3.0 - 2.0 * t);
            }
            public static method remap(double v, double inLo, double inHi, double outLo, double outHi) returns double {
                double t = Interpolation.inverseLerp(inLo, inHi, v);
                return Interpolation.lerp(outLo, outHi, t);
            }
        }
        // Bit-twiddling helpers (spec 34.6) over 32-bit words: population count, leading/trailing zero counts,
        // power-of-two test and round-up, and full bit reversal. Uses uint for logical (zero-fill) shifts.
        public class Bits {
            public static method popcount(int x) returns int {
                mutable uint v = cast<uint>(x);
                mutable int c = 0;
                while (v != cast<uint>(0)) { c = c + cast<int>(v & cast<uint>(1)); v = v >> 1; }
                return c;
            }
            public static method leadingZeros(int x) returns int {
                mutable uint v = cast<uint>(x);
                if (v == cast<uint>(0)) { return 32; }
                mutable int n = 0;
                while ((v & cast<uint>(2147483648)) == cast<uint>(0)) { n = n + 1; v = v << 1; }
                return n;
            }
            public static method trailingZeros(int x) returns int {
                if (x == 0) { return 32; }
                mutable uint v = cast<uint>(x);
                mutable int n = 0;
                while ((v & cast<uint>(1)) == cast<uint>(0)) { n = n + 1; v = v >> 1; }
                return n;
            }
            public static method isPow2(int n) returns boolean { return n > 0 && (n & (n - 1)) == 0; }
            public static method nextPow2(int n) returns int {
                if (n <= 1) { return 1; }
                return 1 << (32 - Bits.leadingZeros(n - 1));
            }
            public static method reverse(int x) returns int {
                mutable uint v = cast<uint>(x);
                mutable uint r = cast<uint>(0);
                for (mutable int i = 0; i < 32; i++) {
                    r = (r << 1) | (v & cast<uint>(1));
                    v = v >> 1;
                }
                return cast<int>(r);
            }
        }
)LDP3"
// Graphics/animation math in its own literal; still System.Math.
R"LDP3(
        // A 2D vector (spec 34.6): add/sub/scale return new vectors; dot and length are scalars.
        public class Vector2 {
            public mutable double x;
            public mutable double y;
            public constructor Vector2(double x, double y) { this.x = x; this.y = y; }
            public method add(Vector2 o) returns Vector2 { return new Vector2(this.x + o.x, this.y + o.y) on heap; }
            public method sub(Vector2 o) returns Vector2 { return new Vector2(this.x - o.x, this.y - o.y) on heap; }
            public method scale(double s) returns Vector2 { return new Vector2(this.x * s, this.y * s) on heap; }
            public method dot(Vector2 o) returns double { return this.x * o.x + this.y * o.y; }
            public method length() returns double { return Numerics.sqrt(this.x * this.x + this.y * this.y); }
        }
        // A 4D vector (spec 34.6), e.g. homogeneous coordinates: add, dot, and length.
        public class Vector4 {
            public mutable double x;
            public mutable double y;
            public mutable double z;
            public mutable double w;
            public constructor Vector4(double x, double y, double z, double w) {
                this.x = x; this.y = y; this.z = z; this.w = w;
            }
            public method add(Vector4 o) returns Vector4 { return new Vector4(this.x+o.x, this.y+o.y, this.z+o.z, this.w+o.w) on heap; }
            public method dot(Vector4 o) returns double { return this.x*o.x + this.y*o.y + this.z*o.z + this.w*o.w; }
            public method length() returns double { return Numerics.sqrt(this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w); }
        }
        // Easing curves (spec 34.6) mapping t in [0,1] to [0,1] for animation: quadratic and cubic in/out.
        public class Easing {
            public static method quadIn(double t) returns double { return t * t; }
            public static method quadOut(double t) returns double { return t * (2.0 - t); }
            public static method cubicIn(double t) returns double { return t * t * t; }
            public static method cubicOut(double t) returns double { double u = 1.0 - t; return 1.0 - u * u * u; }
        }
        // Angle conversions (spec 34.6) between degrees and radians.
        public class Angle {
            public static method toRadians(double deg) returns double { return deg * Numerics.pi() / 180.0; }
            public static method toDegrees(double rad) returns double { return rad * 180.0 / Numerics.pi(); }
        }
        // A 4x4 matrix (spec 34.6) in row-major storage for 3D transforms: identity factory, get/set,
        // matrix product, and transpose (each returns a new matrix). Pairs with Vector4.
        public class Mat4 {
            private mutable double[] m;
            public constructor Mat4() { this.m = new double[16](); }
            public static method identity() returns Mat4 {
                mutable Mat4 r = new Mat4() on heap;
                for (mutable int i = 0; i < 4; i++) { r.set(i, i, 1.0); }
                return r;
            }
            public method get(int r, int c) returns double { return this.m[r * 4 + c]; }
            public method set(int r, int c, double v) returns void { this.m[r * 4 + c] = v; return; }
            public method multiply(Mat4 o) returns Mat4 {
                mutable Mat4 r = new Mat4() on heap;
                for (mutable int i = 0; i < 4; i++) {
                    for (mutable int j = 0; j < 4; j++) {
                        mutable double s = 0.0;
                        for (mutable int k = 0; k < 4; k++) { s = s + this.get(i, k) * o.get(k, j); }
                        r.set(i, j, s);
                    }
                }
                return r;
            }
            public method transpose() returns Mat4 {
                mutable Mat4 r = new Mat4() on heap;
                for (mutable int i = 0; i < 4; i++) {
                    for (mutable int j = 0; j < 4; j++) { r.set(j, i, this.get(i, j)); }
                }
                return r;
            }
        }
        // Radix-2 fast Fourier transform (spec 34.6), iterative Cooley-Tukey over parallel real/imag arrays
        // whose length is a power of two. forward transforms in place; inverse transforms and divides by n so
        // that inverse(forward(x)) == x. Twiddle factors advance by complex multiplication from Numerics.
        public class Fft {
            private static method transform(double[] re, double[] im, int n, int sign) returns void {
                mutable int j = 0;
                for (mutable int i = 1; i < n; i++) {
                    mutable int bit = n >> 1;
                    while ((j & bit) != 0) { j = j ^ bit; bit = bit >> 1; }
                    j = j | bit;
                    if (i < j) {
                        double tr = re[i]; re[i] = re[j]; re[j] = tr;
                        double ti = im[i]; im[i] = im[j]; im[j] = ti;
                    }
                }
                double tau = 6.283185307179586;
                mutable int len = 2;
                while (len <= n) {
                    double ang = cast<double>(sign) * tau / cast<double>(len);
                    double wr = Numerics.cos(ang);
                    double wi = Numerics.sin(ang);
                    mutable int base = 0;
                    while (base < n) {
                        mutable double cwr = 1.0;
                        mutable double cwi = 0.0;
                        int half = len / 2;
                        for (mutable int k = 0; k < half; k++) {
                            int a = base + k;
                            int b = base + k + half;
                            double ure = re[a];
                            double uim = im[a];
                            double vre = re[b] * cwr - im[b] * cwi;
                            double vim = re[b] * cwi + im[b] * cwr;
                            re[a] = ure + vre; im[a] = uim + vim;
                            re[b] = ure - vre; im[b] = uim - vim;
                            double ncwr = cwr * wr - cwi * wi;
                            cwi = cwr * wi + cwi * wr;
                            cwr = ncwr;
                        }
                        base = base + len;
                    }
                    len = len << 1;
                }
                return;
            }
            public static method forward(double[] re, double[] im, int n) returns void {
                Fft.transform(re, im, n, -1);
                return;
            }
            public static method inverse(double[] re, double[] im, int n) returns void {
                Fft.transform(re, im, n, 1);
                for (mutable int i = 0; i < n; i++) {
                    re[i] = re[i] / cast<double>(n);
                    im[i] = im[i] / cast<double>(n);
                }
                return;
            }
        }
        // Ordinary least-squares linear regression (spec 34.6): fit y = slope*x + intercept from parallel
        // arrays and report the coefficient of determination r-squared (computed without a square root).
        public class Regression {
            private mutable double slope;
            private mutable double intercept;
            private mutable double r2;
            public constructor Regression(double[] x, double[] y, int n) {
                mutable double sx = 0.0; mutable double sy = 0.0; mutable double sxy = 0.0;
                mutable double sxx = 0.0; mutable double syy = 0.0;
                for (mutable int i = 0; i < n; i++) {
                    sx = sx + x[i]; sy = sy + y[i]; sxy = sxy + x[i] * y[i];
                    sxx = sxx + x[i] * x[i]; syy = syy + y[i] * y[i];
                }
                double dn = cast<double>(n);
                this.slope = (dn * sxy - sx * sy) / (dn * sxx - sx * sx);
                this.intercept = (sy - this.slope * sx) / dn;
                double num = dn * sxy - sx * sy;
                double den = (dn * sxx - sx * sx) * (dn * syy - sy * sy);
                this.r2 = (num * num) / den;
            }
            public method getSlope() returns double { return this.slope; }
            public method getIntercept() returns double { return this.intercept; }
            public method getR2() returns double { return this.r2; }
            public method predict(double x) returns double { return this.slope * x + this.intercept; }
        }
        // Pearson correlation coefficient (spec 34.6) between two equal-length samples, in [-1, 1].
        public class Correlation {
            public static method pearson(double[] x, double[] y, int n) returns double {
                mutable double sx = 0.0; mutable double sy = 0.0; mutable double sxy = 0.0;
                mutable double sxx = 0.0; mutable double syy = 0.0;
                for (mutable int i = 0; i < n; i++) {
                    sx = sx + x[i]; sy = sy + y[i]; sxy = sxy + x[i] * y[i];
                    sxx = sxx + x[i] * x[i]; syy = syy + y[i] * y[i];
                }
                double dn = cast<double>(n);
                double num = dn * sxy - sx * sy;
                double den = Numerics.sqrt((dn * sxx - sx * sx) * (dn * syy - sy * sy));
                if (den == 0.0) { return 0.0; }
                return num / den;
            }
        }
        // Quaternions (spec 34.6) for 3D rotation math: Hamilton product, conjugate, magnitude and
        // normalize (via the Numerics square root). Immutable; operations return new heap quaternions.
        public class Quaternion {
            private mutable double w;
            private mutable double x;
            private mutable double y;
            private mutable double z;
            public constructor Quaternion(double w, double x, double y, double z) {
                this.w = w; this.x = x; this.y = y; this.z = z;
            }
            public method getW() returns double { return this.w; }
            public method getX() returns double { return this.x; }
            public method getY() returns double { return this.y; }
            public method getZ() returns double { return this.z; }
            public method magnitude() returns double {
                return Numerics.sqrt(this.w*this.w + this.x*this.x + this.y*this.y + this.z*this.z);
            }
            public method conjugate() returns Quaternion {
                return new Quaternion(this.w, 0.0 - this.x, 0.0 - this.y, 0.0 - this.z) on heap;
            }
            public method mul(Quaternion o) returns Quaternion {
                double nw = this.w*o.getW() - this.x*o.getX() - this.y*o.getY() - this.z*o.getZ();
                double nx = this.w*o.getX() + this.x*o.getW() + this.y*o.getZ() - this.z*o.getY();
                double ny = this.w*o.getY() - this.x*o.getZ() + this.y*o.getW() + this.z*o.getX();
                double nz = this.w*o.getZ() + this.x*o.getY() - this.y*o.getX() + this.z*o.getW();
                return new Quaternion(nw, nx, ny, nz) on heap;
            }
            public method normalize() returns Quaternion {
                double m = this.magnitude();
                if (m == 0.0) { return new Quaternion(1.0, 0.0, 0.0, 0.0) on heap; }
                return new Quaternion(this.w/m, this.x/m, this.y/m, this.z/m) on heap;
            }
        }
        // Dense double matrix (spec 34.6) stored row-major: element get/set, matrix multiply and transpose
        // (returning new matrices), and determinant by Gaussian elimination with partial pivoting.
        public class MatrixD {
            private mutable int rows;
            private mutable int cols;
            private mutable double[] data;
            public constructor MatrixD(int rows, int cols) {
                this.rows = rows; this.cols = cols; this.data = new double[rows * cols]();
            }
            public method set(int r, int c, double v) returns void { this.data[r * this.cols + c] = v; return; }
            public method get(int r, int c) returns double { return this.data[r * this.cols + c]; }
            public method rowCount() returns int { return this.rows; }
            public method colCount() returns int { return this.cols; }
            public method mul(MatrixD o) returns MatrixD {
                mutable MatrixD res = new MatrixD(this.rows, o.colCount()) on heap;
                for (mutable int i = 0; i < this.rows; i++) {
                    for (mutable int j = 0; j < o.colCount(); j++) {
                        mutable double s = 0.0;
                        for (mutable int k = 0; k < this.cols; k++) { s = s + this.get(i, k) * o.get(k, j); }
                        res.set(i, j, s);
                    }
                }
                return res;
            }
            public method transpose() returns MatrixD {
                mutable MatrixD res = new MatrixD(this.cols, this.rows) on heap;
                for (mutable int i = 0; i < this.rows; i++) {
                    for (mutable int j = 0; j < this.cols; j++) { res.set(j, i, this.get(i, j)); }
                }
                return res;
            }
            public method determinant() returns double {
                int n = this.rows;
                mutable double[] a = new double[n * n]();
                for (mutable int i = 0; i < n * n; i++) { a[i] = this.data[i]; }
                mutable double det = 1.0;
                for (mutable int col = 0; col < n; col++) {
                    mutable int piv = col;
                    for (mutable int r = col + 1; r < n; r++) {
                        if (Numerics.abs(a[r*n + col]) > Numerics.abs(a[piv*n + col])) { piv = r; }
                    }
                    if (Numerics.abs(a[piv*n + col]) == 0.0) { return 0.0; }
                    if (piv != col) {
                        for (mutable int c = 0; c < n; c++) {
                            double t = a[col*n + c]; a[col*n + c] = a[piv*n + c]; a[piv*n + c] = t;
                        }
                        det = 0.0 - det;
                    }
                    det = det * a[col*n + col];
                    for (mutable int r = col + 1; r < n; r++) {
                        double f = a[r*n + col] / a[col*n + col];
                        for (mutable int c = col; c < n; c++) { a[r*n + c] = a[r*n + c] - f * a[col*n + c]; }
                    }
                }
                return det;
            }
        }
        // A 3D vector (spec 34.6) of doubles: add/sub/scale, dot and cross products, length and normalize (via
        // the Numerics square root). Immutable; operations return new heap vectors.
        public class Vector3 {
            private mutable double x;
            private mutable double y;
            private mutable double z;
            public constructor Vector3(double x, double y, double z) { this.x = x; this.y = y; this.z = z; }
            public method getX() returns double { return this.x; }
            public method getY() returns double { return this.y; }
            public method getZ() returns double { return this.z; }
            public method add(Vector3 o) returns Vector3 { return new Vector3(this.x+o.getX(), this.y+o.getY(), this.z+o.getZ()) on heap; }
            public method sub(Vector3 o) returns Vector3 { return new Vector3(this.x-o.getX(), this.y-o.getY(), this.z-o.getZ()) on heap; }
            public method scale(double s) returns Vector3 { return new Vector3(this.x*s, this.y*s, this.z*s) on heap; }
            public method dot(Vector3 o) returns double { return this.x*o.getX() + this.y*o.getY() + this.z*o.getZ(); }
            public method cross(Vector3 o) returns Vector3 {
                return new Vector3(this.y*o.getZ() - this.z*o.getY(),
                                   this.z*o.getX() - this.x*o.getZ(),
                                   this.x*o.getY() - this.y*o.getX()) on heap;
            }
            public method length() returns double { return Numerics.sqrt(this.dot(this)); }
            public method normalize() returns Vector3 {
                double m = this.length();
                if (m == 0.0) { return new Vector3(0.0, 0.0, 0.0) on heap; }
                return this.scale(1.0 / m);
            }
        }
    }
)LDP3"
// (split: System.OS + System.Net in their own literal.)
R"LDP3(
    public namespace System.OS {
        // The result of running a subprocess (spec 34): its captured stdout and exit code. Built by
        // the `Process.run(cmd)` builtin, which runs the command through the shell.
        public class ProcessResult {
            public String output;
            public int exitCode;
            public constructor ProcessResult(String output, int exitCode) {
                this.output = output;
                this.exitCode = exitCode;
            }
            public method success() returns boolean { return this.exitCode == 0; }
        }
        // A persistent child process (debugger/LSP support): spawn a command, then exchange bytes over its
        // stdin/stdout for its whole lifetime. Unlike Process.run (one-shot, captures stdout to EOF), this
        // stays open for request/response protocols like DAP. Require `import System.OS.Subprocess;`.
        public class Subprocess {
            private mutable long handle;
            private constructor Subprocess(long h) {
                this.handle = h;
            }
            // Spawn `command` (run through the system shell). Check isValid() before use.
            public static method start(String command) returns Subprocess {
                return new Subprocess(Subproc.spawn(command)) on heap;
            }
            // Same, but the child's stderr is merged into its stdout: one stream carries everything it
            // prints. That is what you want from a tool that reports on stderr (a compiler), and exactly
            // what you must NOT do to a child speaking a framed protocol -- a stray log line would be read
            // as part of a message. Hence two spawns, and a caller that says which one it means.
            public static method startCombined(String command) returns Subprocess {
                return new Subprocess(Subproc.spawnCombined(command)) on heap;
            }
            public method isValid() returns boolean {
                return this.handle != cast<long>(0);
            }
            // Write bytes to the child's stdin; returns the number written (-1 on error).
            public method write(String data) returns int {
                return Subproc.writeStr(this.handle, data);
            }
            // Read the next available chunk from the child's stdout (blocks until data or EOF). Empty on EOF.
            public method read() returns String {
                return Subproc.readChunk(this.handle);
            }
            public method isAlive() returns boolean {
                return Subproc.isAlive(this.handle);
            }
            // True when read() would return immediately (data ready or EOF): pump without blocking a UI loop.
            public method canRead() returns boolean {
                return Subproc.canRead(this.handle);
            }
            // Send EOF to the child's stdin without killing it, so a well-behaved child can finish and exit.
            public method closeInput() returns void {
                Subproc.closeStdin(this.handle);
            }
            // Close pipes and terminate the child if still running.
            public method close() returns void {
                Subproc.kill(this.handle);
            }
        }
    }
    public namespace System.Security {
        // A cryptographically secure random source (spec 34): 64 bits per draw from the OS CSPRNG,
        // suitable for keys, tokens and nonces (unlike System.Math.Random, which is a fast PRNG). The
        // extern method links directly to the runtime helper.
        public class SecureRandom {
            private extern cdecl static method __ldp3_secure_random() returns long;
            public constructor SecureRandom() {}
            public method nextLong() returns long { return SecureRandom.__ldp3_secure_random(); }
            public method nextInt() returns int {
                return cast<int>((this.nextLong() >> 33) & cast<long>(2147483647));  // non-negative 31-bit
            }
            public method nextIntMax(int max) returns int { return this.nextInt() % max; }  // [0, max)
            public method nextBool() returns boolean { return (this.nextLong() & cast<long>(1)) == cast<long>(1); }
            public method nextDouble() returns double {
                mutable long bits = this.nextLong() & cast<long>(4503599627370495);  // low 52 bits
                return cast<double>(bits) / 4503599627370496.0;  // [0, 1)
            }
            public method nextBytes(int n) returns int[] {
                mutable int[] out = new int[n]();
                for (mutable int i = 0; i < n; i++) {
                    out[i] = cast<int>(this.nextLong() & cast<long>(255));
                }
                return out;
            }
        }
)LDP3"
// (split: keep each literal under MSVC's ~16KB cap; still the same System.Security namespace.)
R"LDP3(
        // AES block cipher (spec 34; FIPS-197), pure LDP3. Supports 128- and 256-bit keys (16 or 32 bytes).
        // The S-boxes are generated from the GF(2^8) multiplicative inverse plus the affine transform (so no
        // 256-entry literal tables). encryptBlock/decryptBlock are the raw 16-byte ECB primitive; ctr() is
        // the recommended stream mode (a keystream XORed with the data, so encryption and decryption are the
        // same call). Verified against the FIPS-197 test vector. Bytes are carried as ints in 0..255.
        public class Aes {
            private mutable int[] sbox;
            private mutable int[] invSbox;
            private mutable int[] rk;      // expanded round-key bytes: (rounds+1)*16
            private mutable int rounds;
            public constructor Aes(int[] key) {
                this.initTables();
                this.expandKey(key);
            }
            private method xtime(int x) returns int {
                mutable int r = (x << 1) & 255;
                if ((x & 128) != 0) { r = r ^ 27; }   // reduce by 0x11b
                return r;
            }
            private method rotl8(int b, int n) returns int {
                return ((b << n) | (b >> (8 - n))) & 255;
            }
            private method initTables() returns void {
                mutable int[] expt = new int[256]();   // powers of the generator 3
                mutable int[] logt = new int[256]();
                mutable int x = 1;
                for (mutable int i = 0; i < 255; i++) {
                    expt[i] = x;
                    logt[x] = i;
                    x = x ^ this.xtime(x);   // x *= 3 in GF(2^8)
                }
                this.sbox = new int[256]();
                this.invSbox = new int[256]();
                for (mutable int a = 0; a < 256; a++) {
                    mutable int inv = 0;
                    if (a != 0) { inv = expt[(255 - logt[a]) % 255]; }
                    mutable int s = inv ^ this.rotl8(inv, 1) ^ this.rotl8(inv, 2)
                                  ^ this.rotl8(inv, 3) ^ this.rotl8(inv, 4) ^ 99;   // affine, +0x63
                    s = s & 255;
                    this.sbox[a] = s;
                    this.invSbox[s] = a;
                }
            }
            private method gmul(int a, int b) returns int {
                mutable int p = 0;
                mutable int aa = a & 255;
                mutable int bb = b & 255;
                for (mutable int i = 0; i < 8; i++) {
                    if ((bb & 1) != 0) { p = p ^ aa; }
                    aa = this.xtime(aa);
                    bb = bb >> 1;
                }
                return p & 255;
            }
            private method expandKey(int[] key) returns void {
                int nk = key.length() / 4;          // 4 (AES-128) or 8 (AES-256)
                this.rounds = nk + 6;               // 10 or 14
                int nw = (this.rounds + 1) * 4;      // total 32-bit words
                this.rk = new int[nw * 4]();
                for (mutable int i = 0; i < nk * 4; i++) { this.rk[i] = key[i] & 255; }
                mutable int rcon = 1;
                mutable int w = nk;
                while (w < nw) {
                    mutable int t0 = this.rk[(w - 1) * 4 + 0];
                    mutable int t1 = this.rk[(w - 1) * 4 + 1];
                    mutable int t2 = this.rk[(w - 1) * 4 + 2];
                    mutable int t3 = this.rk[(w - 1) * 4 + 3];
                    if (w % nk == 0) {
                        int r0 = this.sbox[t1] ^ rcon;   // RotWord + SubWord + Rcon
                        int r1 = this.sbox[t2];
                        int r2 = this.sbox[t3];
                        int r3 = this.sbox[t0];
                        t0 = r0; t1 = r1; t2 = r2; t3 = r3;
                        rcon = this.xtime(rcon);
                    } else if (nk > 6 && (w % nk) == 4) {
                        t0 = this.sbox[t0]; t1 = this.sbox[t1];   // SubWord (AES-256)
                        t2 = this.sbox[t2]; t3 = this.sbox[t3];
                    }
                    this.rk[w * 4 + 0] = this.rk[(w - nk) * 4 + 0] ^ t0;
                    this.rk[w * 4 + 1] = this.rk[(w - nk) * 4 + 1] ^ t1;
                    this.rk[w * 4 + 2] = this.rk[(w - nk) * 4 + 2] ^ t2;
                    this.rk[w * 4 + 3] = this.rk[(w - nk) * 4 + 3] ^ t3;
                    w = w + 1;
                }
            }
            private method addRoundKey(int[] s, int round) returns void {
                for (mutable int i = 0; i < 16; i++) { s[i] = s[i] ^ this.rk[round * 16 + i]; }
            }
            private method subBytes(int[] s) returns void {
                for (mutable int i = 0; i < 16; i++) { s[i] = this.sbox[s[i]]; }
            }
            private method invSubBytes(int[] s) returns void {
                for (mutable int i = 0; i < 16; i++) { s[i] = this.invSbox[s[i]]; }
            }
            private method shiftRows(int[] s) returns void {   // state index = row + 4*col
                mutable int[] t = new int[16]();
                for (mutable int r = 0; r < 4; r++) {
                    for (mutable int c = 0; c < 4; c++) { t[r + 4 * c] = s[r + 4 * ((c + r) % 4)]; }
                }
                for (mutable int i = 0; i < 16; i++) { s[i] = t[i]; }
            }
            private method invShiftRows(int[] s) returns void {
                mutable int[] t = new int[16]();
                for (mutable int r = 0; r < 4; r++) {
                    for (mutable int c = 0; c < 4; c++) { t[r + 4 * c] = s[r + 4 * ((c - r + 4) % 4)]; }
                }
                for (mutable int i = 0; i < 16; i++) { s[i] = t[i]; }
            }
            private method mixColumns(int[] s) returns void {
                for (mutable int c = 0; c < 4; c++) {
                    int a0 = s[4 * c + 0];
                    int a1 = s[4 * c + 1];
                    int a2 = s[4 * c + 2];
                    int a3 = s[4 * c + 3];
                    s[4 * c + 0] = this.gmul(a0, 2) ^ this.gmul(a1, 3) ^ a2 ^ a3;
                    s[4 * c + 1] = a0 ^ this.gmul(a1, 2) ^ this.gmul(a2, 3) ^ a3;
                    s[4 * c + 2] = a0 ^ a1 ^ this.gmul(a2, 2) ^ this.gmul(a3, 3);
                    s[4 * c + 3] = this.gmul(a0, 3) ^ a1 ^ a2 ^ this.gmul(a3, 2);
                }
            }
            private method invMixColumns(int[] s) returns void {
                for (mutable int c = 0; c < 4; c++) {
                    int a0 = s[4 * c + 0];
                    int a1 = s[4 * c + 1];
                    int a2 = s[4 * c + 2];
                    int a3 = s[4 * c + 3];
                    s[4 * c + 0] = this.gmul(a0, 14) ^ this.gmul(a1, 11) ^ this.gmul(a2, 13) ^ this.gmul(a3, 9);
                    s[4 * c + 1] = this.gmul(a0, 9) ^ this.gmul(a1, 14) ^ this.gmul(a2, 11) ^ this.gmul(a3, 13);
                    s[4 * c + 2] = this.gmul(a0, 13) ^ this.gmul(a1, 9) ^ this.gmul(a2, 14) ^ this.gmul(a3, 11);
                    s[4 * c + 3] = this.gmul(a0, 11) ^ this.gmul(a1, 13) ^ this.gmul(a2, 9) ^ this.gmul(a3, 14);
                }
            }
            public method encryptBlock(int[] input) returns int[] {
                mutable int[] s = new int[16]();
                for (mutable int i = 0; i < 16; i++) { s[i] = input[i] & 255; }
                this.addRoundKey(s, 0);
                for (mutable int r = 1; r < this.rounds; r++) {
                    this.subBytes(s);
                    this.shiftRows(s);
                    this.mixColumns(s);
                    this.addRoundKey(s, r);
                }
                this.subBytes(s);
                this.shiftRows(s);
                this.addRoundKey(s, this.rounds);
                return s;
            }
            public method decryptBlock(int[] input) returns int[] {
                mutable int[] s = new int[16]();
                for (mutable int i = 0; i < 16; i++) { s[i] = input[i] & 255; }
                this.addRoundKey(s, this.rounds);
                for (mutable int r = this.rounds - 1; r > 0; r = r - 1) {
                    this.invShiftRows(s);
                    this.invSubBytes(s);
                    this.addRoundKey(s, r);
                    this.invMixColumns(s);
                }
                this.invShiftRows(s);
                this.invSubBytes(s);
                this.addRoundKey(s, 0);
                return s;
            }
            // CTR mode (spec 34): keystream = encryptBlock(counter) XOR data; symmetric, no padding. iv is a
            // 16-byte nonce/counter start; the counter increments big-endian per block.
            public method ctr(int[] data, int[] iv) returns int[] {
                int n = data.length();
                mutable int[] out = new int[n]();
                mutable int[] counter = new int[16]();
                for (mutable int i = 0; i < 16; i++) { counter[i] = iv[i] & 255; }
                mutable int off = 0;
                while (off < n) {
                    mutable int[] ks = this.encryptBlock(counter);
                    mutable int j = 0;
                    while (j < 16 && off + j < n) {
                        out[off + j] = (data[off + j] ^ ks[j]) & 255;
                        j = j + 1;
                    }
                    mutable int c = 15;
                    mutable boolean carry = true;
                    while (c >= 0 && carry) {
                        counter[c] = (counter[c] + 1) & 255;
                        if (counter[c] != 0) { carry = false; }
                        c = c - 1;
                    }
                    off = off + 16;
                }
                return out;
            }
        }
    }
    public namespace System.Net {
        // A blocking TCP socket (spec 34) wrapping an OS handle (or -1 on failure). Build a client with
        // Socket.connect(host, port); a ServerSocket.accept() also hands back a Socket. send/receive/
        // close lower to runtime winsock helpers.
        public class Socket {
            private mutable long handle;
            public constructor Socket(long handle) { this.handle = handle; }
            public static method connect(String host, int port) returns Socket {
                return new Socket(Net.connect(host, port)) on heap;
            }
            public method isOpen() returns boolean { return this.handle >= cast<long>(0); }
            public method send(String data) returns long { return Net.send(this.handle, data); }
            public method receive(int max) returns String { return Net.recv(this.handle, max); }
            public method close() returns void { Net.close(this.handle); }
        }
        // A listening TCP server socket (spec 34): bind+listen on a port, then accept() blocks for the
        // next connection and returns a Socket for it.
        public class ServerSocket {
            private mutable long handle;
            public constructor ServerSocket(int port) { this.handle = Net.listen(port); }
            public method isOpen() returns boolean { return this.handle >= cast<long>(0); }
            public method accept() returns Socket { return new Socket(Net.accept(this.handle)) on heap; }
            public method close() returns void { Net.close(this.handle); }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.Net namespace.
R"LDP3(
        // A received datagram (spec 34): its payload plus the sender's address, so a server can reply.
        public class Datagram {
            public String data;
            public String host;
            public int port;
            public constructor Datagram(String data, String host, int port) {
                this.data = data;
                this.host = host;
                this.port = port;
            }
        }
        // A UDP socket (spec 34): connectionless datagrams. Open with port 0 for an ephemeral client port,
        // or a fixed port to receive on. send addresses each datagram; receive returns the payload together
        // with the sender's address (via the runtime's last-sender record) for request/reply exchanges.
        public class UdpSocket {
            private mutable long handle;
            public constructor UdpSocket(int port) { this.handle = Net.udpOpen(port); }
            public method isOpen() returns boolean { return this.handle >= cast<long>(0); }
            public method send(String host, int port, String data) returns long {
                return Net.udpSend(this.handle, host, port, data);
            }
            public method receive(int max) returns Datagram {
                String payload = Net.udpRecv(this.handle, max);
                return new Datagram(payload, Net.udpPeerHost(), Net.udpPeerPort()) on heap;
            }
            public method close() returns void { Net.udpClose(this.handle); }
        }
        // A parsed HTTP response (spec 34): the raw text is kept and queried lazily. status reads the code
        // from the start line, header returns a field's value, and body is everything after the blank line.
        public class HttpResponse {
            private mutable String raw;
            public constructor HttpResponse(String raw) { this.raw = raw; }
            public method raw() returns String { return this.raw; }
            public method status() returns int {
                int sp = this.raw.indexOf(" ");
                if (sp < 0) { return 0; }
                mutable int n = 0;
                mutable int i = sp + 1;
                while (i < this.raw.length() && this.raw.charAt(i) >= '0' && this.raw.charAt(i) <= '9') {
                    n = n * 10 + (cast<int>(this.raw.charAt(i)) - cast<int>('0'));
                    i = i + 1;
                }
                return n;
            }
            public method body() returns String {
                int idx = this.raw.indexOf("\r\n\r\n");
                if (idx < 0) { return ""; }
                return this.raw.substring(idx + 4, this.raw.length());
            }
            public method header(String name) returns String {
                String key = name.concat(": ");
                int idx = this.raw.indexOf(key);
                if (idx < 0) { return ""; }
                int start = idx + key.length();
                mutable int end = start;
                while (end < this.raw.length() && this.raw.charAt(end) != '\r') { end = end + 1; }
                return this.raw.substring(start, end);
            }
        }
        // A minimal HTTP/1.1 client over Socket (spec 34). buildRequest formats a request line plus Host and
        // Connection: close headers; get opens a socket, sends a GET, drains the reply, and parses it. The
        // request building and response parsing are pure; get performs the network round-trip.
        public class Http {
            public static method buildRequest(String verb, String host, String path) returns String {
                mutable StringBuilder sb = new StringBuilder() on heap;
                sb.append(verb);
                sb.append(" ");
                sb.append(path);
                sb.append(" HTTP/1.1\r\nHost: ");
                sb.append(host);
                sb.append("\r\nConnection: close\r\n\r\n");
                return sb.toString();
            }
            public static method get(String host, int port, String path) returns HttpResponse {
                mutable Socket s = new Socket(Net.connect(host, port)) on heap;
                s.send(Http.buildRequest("GET", host, path));
                mutable StringBuilder sb = new StringBuilder() on heap;
                mutable boolean more = true;
                while (more) {
                    String chunk = s.receive(4096);
                    if (chunk.length() == 0) { more = false; } else { sb.append(chunk); }
                }
                s.close();
                return new HttpResponse(sb.toString()) on heap;
            }
        }
    }
)LDP3"
// Split only for the MSVC literal-size limit; a new namespace for application-layer utilities.
R"LDP3(
    public namespace System.App {
        // Circuit breaker (spec 34): trips to open after threshold consecutive failures and rejects calls
        // until a cooldown passes, then allows one trial (half-open); a success closes it again, a failure
        // reopens it. Time is passed in explicitly (milliseconds) so behavior is deterministic and testable.
        public class CircuitBreaker {
            private mutable int st;          // 0=closed, 1=open, 2=half-open
            private mutable int failures;
            private mutable int threshold;
            private mutable long openUntil;
            private mutable long cooldownMs;
            public constructor CircuitBreaker(int threshold, long cooldownMs) {
                this.st = 0;
                this.failures = 0;
                this.threshold = threshold;
                this.openUntil = 0;
                this.cooldownMs = cooldownMs;
            }
            public method allow(long now) returns boolean {
                if (this.st == 1) {
                    if (now >= this.openUntil) { this.st = 2; return true; }
                    return false;
                }
                return true;
            }
            public method recordSuccess() returns void { this.st = 0; this.failures = 0; return; }
            public method recordFailure(long now) returns void {
                this.failures = this.failures + 1;
                if (this.st == 2) { this.st = 1; this.openUntil = now + this.cooldownMs; return; }
                if (this.failures >= this.threshold) { this.st = 1; this.openUntil = now + this.cooldownMs; }
                return;
            }
            public method getState() returns int { return this.st; }
        }
        // Token-bucket rate limiter (spec 34): tokens refill continuously at ratePerMs up to capacity; each
        // acquire spends tokens if enough are available. Time is passed in explicitly (milliseconds).
        public class TokenBucket {
            private mutable double tokens;
            private mutable double capacity;
            private mutable double ratePerMs;
            private mutable long last;
            public constructor TokenBucket(double capacity, double ratePerMs) {
                this.tokens = capacity;
                this.capacity = capacity;
                this.ratePerMs = ratePerMs;
                this.last = 0;
            }
            public method tryAcquire(long now, int count) returns boolean {
                double elapsed = cast<double>(now - this.last);
                this.tokens = this.tokens + elapsed * this.ratePerMs;
                if (this.tokens > this.capacity) { this.tokens = this.capacity; }
                this.last = now;
                if (this.tokens >= cast<double>(count)) { this.tokens = this.tokens - cast<double>(count); return true; }
                return false;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.App namespace.
R"LDP3(
        // A tiny stack virtual machine (spec 34): executes a flat program of (opcode, operand) pairs against
        // an operand stack and a small memory. Opcodes: 0 HALT, 1 PUSH v, 2 STORE a, 3 LOAD a, 4 MUL, 5 SUB,
        // 6 JZ t, 7 JMP t, 8 ADD (jump targets are instruction indices). run returns the top of the stack.
        public class StackVm {
            public static method run(int[] prog, int plen, int memSize) returns int {
                mutable int[] stack = new int[256]();
                mutable int sp = 0;
                mutable int[] mem = new int[memSize]();
                mutable int ip = 0;
                mutable boolean running = true;
                while (running && ip * 2 < plen) {
                    int op = prog[ip * 2];
                    int arg = prog[ip * 2 + 1];
                    if (op == 0) { running = false; }
                    else {
                        if (op == 1) { stack[sp] = arg; sp = sp + 1; ip = ip + 1; }
                        else { if (op == 2) { sp = sp - 1; mem[arg] = stack[sp]; ip = ip + 1; }
                        else { if (op == 3) { stack[sp] = mem[arg]; sp = sp + 1; ip = ip + 1; }
                        else { if (op == 4) { sp = sp - 1; int b = stack[sp]; sp = sp - 1; stack[sp] = stack[sp] * b; sp = sp + 1; ip = ip + 1; }
                        else { if (op == 5) { sp = sp - 1; int b = stack[sp]; sp = sp - 1; stack[sp] = stack[sp] - b; sp = sp + 1; ip = ip + 1; }
                        else { if (op == 6) { sp = sp - 1; if (stack[sp] == 0) { ip = arg; } else { ip = ip + 1; } }
                        else { if (op == 7) { ip = arg; }
                        else { if (op == 8) { sp = sp - 1; int b = stack[sp]; sp = sp - 1; stack[sp] = stack[sp] + b; sp = sp + 1; ip = ip + 1; }
                        else { ip = ip + 1; } } } } } } } }
                    }
                }
                if (sp > 0) { return stack[sp - 1]; }
                return 0;
            }
        }
)LDP3"
// Split only for the MSVC literal-size limit; still the same System.App namespace.
R"LDP3(
        // Named feature flags (spec 34): enable/disable toggles by name, defaulting to off when unset.
        public class FeatureFlags {
            private mutable HashMap<String, boolean> flags;
            public constructor FeatureFlags() { this.flags = new HashMap<String, boolean>() on heap; }
            public method enable(String name) returns void { this.flags.put(name, true); return; }
            public method disable(String name) returns void { this.flags.put(name, false); return; }
            public method isEnabled(String name) returns boolean {
                if (this.flags.containsKey(name)) { return this.flags.get(name); }
                return false;
            }
        }
        // A fixed-capacity pool of reusable integer ids (spec 34): acquire hands out a fresh or recycled id
        // (or -1 when exhausted); recycle returns one for reuse. inUse reports the live count.
        public class ObjectPool {
            private mutable int[] freeIds;
            private mutable int freeCount;
            private mutable int nextId;
            private mutable int capacity;
            public constructor ObjectPool(int capacity) {
                this.capacity = capacity; this.freeIds = new int[capacity](); this.freeCount = 0; this.nextId = 0;
            }
            public method acquire() returns int {
                if (this.freeCount > 0) { this.freeCount = this.freeCount - 1; return this.freeIds[this.freeCount]; }
                if (this.nextId < this.capacity) { int id = this.nextId; this.nextId = this.nextId + 1; return id; }
                return -1;
            }
            public method recycle(int id) returns void {
                if (this.freeCount < this.capacity) { this.freeIds[this.freeCount] = id; this.freeCount = this.freeCount + 1; }
                return;
            }
            public method inUse() returns int { return this.nextId - this.freeCount; }
        }
        // Fixed-point money as integer cents (spec 34), avoiding floating-point rounding. plus/minus/times
        // return new amounts; format renders a signed dollar string like "$12.34".
        public class Money {
            private mutable long cents;
            public constructor Money(long cents) { this.cents = cents; }
            public method getCents() returns long { return this.cents; }
            public method plus(Money o) returns Money { return new Money(this.cents + o.getCents()) on heap; }
            public method minus(Money o) returns Money { return new Money(this.cents - o.getCents()) on heap; }
            public method times(int factor) returns Money { return new Money(this.cents * cast<long>(factor)) on heap; }
            public method format() returns String {
                mutable long c = this.cents;
                mutable StringBuilder sb = new StringBuilder() on heap;
                if (c < 0) { sb.appendChar('-'); c = 0 - c; }
                sb.appendChar('$');
                long dollars = c / 100;
                long rem = c % 100;
                sb.appendInt(cast<int>(dollars));
                sb.appendChar('.');
                if (rem < 10) { sb.appendChar('0'); }
                sb.appendInt(cast<int>(rem));
                return sb.toString();
            }
        }
    }
)LDP3"
// System.Test in its own literal (the unit-test framework, spec 34).
R"LDP3(
    public namespace System.Test {
        // Marker annotation (spec 32.11): a public static method returning boolean tagged @Test (or the
        // equivalent [Test] form) is an inline test, discovered and run by `ldp3 test`.
        public annotation Test {}
        // Boolean assertion helpers (spec 34): each returns whether the check holds, to be fed to
        // TestRunner.check. near compares doubles within an epsilon.
        // The assertion API of spec 32.11. Unlike Assert (whose helpers merely RETURN whether a check
        // holds), these RECORD a failure and print what went wrong, so a `@Test` method can be a plain
        // list of assertions returning void: `ldp3c --test` resets the counter around each test and
        // reads it back as that test's verdict.
        public class Test {
            private static mutable int fails;
            public static method reset() returns void {
                Test.fails = 0;
                return;
            }
            public static method failures() returns int {
                return Test.fails;
            }
            public static method assertEqual(int actual, int expected) returns void {
                if (actual != expected) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.printf("  assertion failed: expected %d, got %d\n",
                                             expected, actual);
                }
                return;
            }
            public static method assertEqualLong(long actual, long expected) returns void {
                if (actual != expected) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.printf("  assertion failed: expected %lld, got %lld\n",
                                             expected, actual);
                }
                return;
            }
            public static method assertEqualString(String actual, String expected) returns void {
                if (!actual.equals(expected)) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.printf("  assertion failed: expected %s, got %s\n",
                                             expected, actual);
                }
                return;
            }
            public static method assertTrue(boolean condition) returns void {
                if (!condition) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.println("  assertion failed: expected true");
                }
                return;
            }
            public static method assertFalse(boolean condition) returns void {
                if (condition) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.println("  assertion failed: expected false");
                }
                return;
            }
            // Numeric tolerance: |actual - expected| must not exceed it.
            public static method assertWithin(double actual, double expected, double tolerance)
                    returns void {
                mutable double d = actual - expected;
                if (d < 0.0) {
                    d = 0.0 - d;
                }
                if (d > tolerance) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.printf("  assertion failed: expected %f +/- %f, got %f\n",
                                             expected, tolerance, actual);
                }
                return;
            }
            // The action must throw E: a different exception propagates, and no exception at all is a
            // failure. E is monomorphized, so the catch below is a concrete type.
            public static method assertThrows<E>(function<void> action) returns void {
                mutable boolean threw = false;
                try {
                    action();
                }
                catch (E e) {
                    threw = true;
                }
                if (!threw) {
                    Test.fails = Test.fails + 1;
                    System.IO.Console.println("  assertion failed: expected an exception, none thrown");
                }
                return;
            }
        }
        public class Assert {
            public static method eq(int a, int b) returns boolean { return a == b; }
            public static method eqLong(long a, long b) returns boolean { return a == b; }
            public static method eqStr(String a, String b) returns boolean { return a.equals(b); }
            public static method near(double a, double b, double eps) returns boolean {
                mutable double d = a - b;
                if (d < 0.0) { d = 0.0 - d; }
                return d <= eps;
            }
            public static method isTrue(boolean c) returns boolean { return c; }
            public static method isFalse(boolean c) returns boolean { return !c; }
        }
        // A minimal unit-test runner (spec 34): check tallies a pass/fail and prints a line; report prints the
        // summary and allPassed says whether every check held. Lets LDP3 code (and this stdlib) self-test.
        public class TestRunner {
            private mutable int passed;
            private mutable int failed;
            public constructor TestRunner() { this.passed = 0; this.failed = 0; }
            public method check(String name, boolean cond) returns void {
                if (cond) { this.passed = this.passed + 1; System.IO.Console.printf("PASS %s\n", name); }
                else { this.failed = this.failed + 1; System.IO.Console.printf("FAIL %s\n", name); }
                return;
            }
            public method passed() returns int { return this.passed; }
            public method failed() returns int { return this.failed; }
            public method allPassed() returns boolean { return this.failed == 0; }
            public method report() returns void {
                System.IO.Console.printf("%d passed, %d failed\n", this.passed, this.failed);
                return;
            }
        }
    }
)LDP3"
// System.Ipc in its own literal: the cross-program IPC protocol (spec 2.8) and the capability tokens
// (spec 32.7) it enforces. The transport (Ipc.*) is a named pipe / Unix socket named after the program.
R"LDP3(
    public namespace System.Ipc {
        // A cross-program call failed: the peer threw, refused a capability, or the connection broke.
        public class IpcError extends Exception {
            private mutable String text;
            public constructor IpcError(String text) {
                this.text = text;
            }
            public override method message() returns String {
                return this.text;
            }
        }
        // The frame kinds. A request travels in EITHER direction: when a program lends out a T*, the
        // peer calls back into it on the same connection.
        public class IpcProto {
            public static method kCreate() returns int { return 1; }
            public static method kCall() returns int { return 2; }
            public static method kRelease() returns int { return 3; }
            public static method kCapability() returns int { return 4; }
            public static method kReplyOk() returns int { return 10; }
            public static method kReplyError() returns int { return 11; }
            // An error reply carrying `text`.
            public static method errorFrame(String text) returns String {
                IpcWriter w = new IpcWriter() on heap;
                w.putByte(IpcProto.kReplyError());
                w.putString(text);
                String f = w.toFrame();
                delete w;
                return f;
            }
            // An empty OK reply (a void return).
            public static method okFrame() returns String {
                IpcWriter w = new IpcWriter() on heap;
                w.putByte(IpcProto.kReplyOk());
                String f = w.toFrame();
                delete w;
                return f;
            }
        }
        // Builds a frame: scalars little-endian, strings length-prefixed. Both sides were compiled
        // against the same header, so the wire is schema-driven -- no per-value type tags.
        public class IpcWriter {
            private mutable StringBuilder sb;
            public constructor IpcWriter() {
                this.sb = new StringBuilder() on heap;
            }
            public method putByte(int b) returns void {
                this.sb.appendChar(cast<char>(b & 255));
                return;
            }
            public method putLong(long v) returns void {
                mutable int i = 0;
                while (i < 8) {
                    this.putByte(cast<int>((v >> (i * 8)) & cast<long>(255)));
                    i = i + 1;
                }
                return;
            }
            public method putInt(int v) returns void {
                this.putLong(cast<long>(v));
                return;
            }
            public method putBoolean(boolean b) returns void {
                if (b) {
                    this.putByte(1);
                } else {
                    this.putByte(0);
                }
                return;
            }
            public method putChar(char c) returns void {
                this.putByte(cast<int>(c) & 255);
                return;
            }
            public method putDouble(double d) returns void {
                this.putLong(Bits.doubleToLong(d));
                return;
            }
            public method putString(String s) returns void {
                this.putInt(s.length());
                this.sb.append(s);
                return;
            }
            public method toFrame() returns String {
                return this.sb.toString();
            }
            public destructor ~IpcWriter() returns void {
                delete this.sb;
            }
        }
        // Reads a frame back, in the same order it was written.
        public class IpcReader {
            private mutable String buf;
            private mutable int pos;
            public constructor IpcReader(String frame) {
                this.buf = frame;
                this.pos = 0;
            }
            public method atEnd() returns boolean {
                return this.pos >= this.buf.length();
            }
            public method getByte() returns int {
                int b = cast<int>(this.buf.charAt(this.pos)) & 255;
                this.pos = this.pos + 1;
                return b;
            }
            public method getLong() returns long {
                mutable long v = cast<long>(0);
                mutable int i = 0;
                while (i < 8) {
                    v = v | (cast<long>(this.getByte()) << (i * 8));
                    i = i + 1;
                }
                return v;
            }
            public method getInt() returns int {
                return cast<int>(this.getLong());
            }
            public method getBoolean() returns boolean {
                return this.getByte() != 0;
            }
            public method getChar() returns char {
                return cast<char>(this.getByte());
            }
            public method getDouble() returns double {
                return Bits.longToDouble(this.getLong());
            }
            public method getString() returns String {
                int n = this.getInt();
                String s = this.buf.substring(this.pos, this.pos + n);
                this.pos = this.pos + n;
                return s;
            }
        }
        // The program's own dispatcher. A program that exports nothing answers every request with an
        // error; a program that takes part in IPC has this body REWRITTEN by the compiler to call the
        // dispatcher it synthesized for that program's own classes.
        public class IpcRuntime {
            public static method handle(String frame) returns String {
                return IpcProto.errorFrame("this program exports nothing over IPC");
            }
        }
        // One connection. request() sends a frame and waits for its reply -- and while it waits, an
        // inbound request is a CALLBACK into an object this program lent out (a T* it passed), so it is
        // served right there and the wait resumes. Both peers are single-threaded over the channel, so
        // the next reply on the wire always belongs to the innermost outstanding request; no ids needed.
        public class IpcChannel {
            private mutable long conn;
            public constructor IpcChannel(long conn) {
                this.conn = conn;
            }
            public method connection() returns long {
                return this.conn;
            }
            public method request(String frame) throws(IpcError) returns IpcReader {
                Ipc.send(this.conn, frame);
                while (true) {
                    String msg = Ipc.recv(this.conn);
                    if (msg.length() == 0) {
                        throw new IpcError("the peer closed the connection") on heap;
                    }
                    IpcReader r = new IpcReader(msg) on heap;
                    int kind = r.getByte();
                    if (kind == IpcProto.kReplyOk()) {
                        return r;
                    }
                    if (kind == IpcProto.kReplyError()) {
                        String m = r.getString();
                        delete r;
                        throw new IpcError(m) on heap;
                    }
                    delete r;
                    String reply = IpcRuntime.handle(msg);   // a callback into an object we lent out
                    Ipc.send(this.conn, reply);
                }
            }
            public method close() returns void {
                Ipc.close(this.conn);
                return;
            }
        }
        // A capability granted by another program (spec 2.8 + 32.7): unforgeable because the ISSUER
        // remembers the nonce it minted and checks it on every call that demands the token.
        public class BundleAccessToken {
            private mutable long nonceValue;
            private mutable String capabilityName;
            public constructor BundleAccessToken(long nonce, String capability) {
                this.nonceValue = nonce;
                this.capabilityName = capability;
            }
            public method nonce() returns long {
                return this.nonceValue;
            }
            public method capability() returns String {
                return this.capabilityName;
            }
            // A refused request yields a token that was never granted. (LDP3's nullable does not narrow,
            // so a `nullable BundleAccessToken*` could never be passed to a method that demands one --
            // the type system itself pushes the answer here.)
            public method granted() returns boolean {
                return this.nonceValue != cast<long>(0);
            }
        }
        // The client's view of another running program.
        public class ProgramHandle {
            private mutable long conn;
            public constructor ProgramHandle(long conn) {
                this.conn = conn;
            }
            public method connection() returns long {
                return this.conn;
            }
            // The spec's fluent path: a.bundle("audio").namespace("mixers").type<StereoMixer>().
            // The names were already checked against the header at COMPILE time, so at runtime they are
            // a readable no-op that keeps the call site self-documenting.
            public method bundle(String name) returns ProgramHandle {
                return this;
            }
            public method namespace(String name) returns ProgramHandle {
                return this;
            }
            public method type<T>() returns RemoteType<T> {
                return new RemoteType<T>(this.conn) on heap;
            }
            // Ask the program for a capability. Its serve() policy decides; null means refused.
            public method requestAccess(String capability) returns BundleAccessToken* {
                IpcWriter w = new IpcWriter() on heap;
                w.putByte(IpcProto.kCapability());
                w.putString(capability);
                IpcChannel ch = new IpcChannel(this.conn) on heap;
                try {
                    IpcReader r = ch.request(w.toFrame());
                    long nonce = r.getLong();
                    delete r;
                    delete ch;
                    delete w;
                    return new BundleAccessToken(nonce, capability) on heap;
                }
                catch (IpcError e) {
                    delete ch;
                    delete w;
                    return new BundleAccessToken(cast<long>(0), capability) on heap;   // refused
                }
            }
            public method close() returns void {
                Ipc.close(this.conn);
                return;
            }
        }
        // A remote type, bound to a connection: instantiate() creates the object IN THE OTHER PROGRAM
        // and hands back a proxy to it.
        public class RemoteType<T> {
            private mutable long conn;
            public constructor RemoteType(long conn) {
                this.conn = conn;
            }
            public method instantiate() returns T {
                // id 0: the proxy's constructor makes the object in the other program.
                return new T(this.conn, cast<long>(0)) on heap;
            }
        }
        // Connecting to, and serving as, a program (spec 2.8).
        public class Program {
            // Connect to a running program by NAME (its pipe/socket is named after it). Null when it is
            // not running.
            public static method connect(String name) returns nullable ProgramHandle* {
                long c = Ipc.connect(name);
                if (c < cast<long>(0)) {
                    return null;
                }
                return new ProgramHandle(c) on heap;
            }
            // Serve this program's exported types forever. `auth` is the capability policy: it is asked
            // for every capability a client requests, and its answer is final.
            public static method serve(String name, function<boolean, String> auth) returns void {
                IpcServer.serve(name, auth);
                return;
            }
        }
        // The accept loop. One connection is served to completion, then the next is accepted -- the
        // channel is synchronous by construction, which is what lets replies be matched by nesting.
        public class IpcServer {
            private static mutable ArrayList<long> nonces;
            private static mutable ArrayList<String> caps;
            private static mutable boolean ready;
            public static method serve(String name, function<boolean, String> auth) returns void {
                IpcServer.nonces = new ArrayList<long>() on heap;
                IpcServer.caps = new ArrayList<String>() on heap;
                IpcServer.ready = true;
                long srv = Ipc.listen(name);
                if (srv < cast<long>(0)) {
                    return;
                }
                while (true) {
                    long c = Ipc.accept(srv);
                    if (c < cast<long>(0)) {
                        break;
                    }
                    IpcServer.session(c, auth);
                    Ipc.close(c);
                }
                Ipc.close(srv);
                return;
            }
            private static method session(long conn, function<boolean, String> auth) returns void {
                while (true) {
                    String msg = Ipc.recv(conn);
                    if (msg.length() == 0) {
                        return;
                    }
                    IpcReader peek = new IpcReader(msg) on heap;
                    int kind = peek.getByte();
                    if (kind == IpcProto.kCapability()) {
                        String cap = peek.getString();
                        delete peek;
                        Ipc.send(conn, IpcServer.grant(cap, auth));
                    } else {
                        delete peek;
                        Ipc.send(conn, IpcRuntime.handle(msg));
                    }
                }
                return;
            }
            // Mint a nonce for `cap` if the policy approves, and REMEMBER it: that memory is what makes
            // the token unforgeable -- a client cannot invent one this program never issued.
            private static method grant(String cap, function<boolean, String> auth) returns String {
                if (!auth(cap)) {
                    return IpcProto.errorFrame("capability refused: " + cap);
                }
                SecureRandom rng = new SecureRandom() on heap;   // a token nonce must not be guessable
                long nonce = rng.nextLong();
                delete rng;
                IpcServer.nonces.add(nonce);
                IpcServer.caps.add(cap);
                IpcWriter w = new IpcWriter() on heap;
                w.putByte(IpcProto.kReplyOk());
                w.putLong(nonce);
                String f = w.toFrame();
                delete w;
                return f;
            }
            // Called by the synthesized dispatcher before running any method that demands a token.
            public static method validate(long nonce, String cap) returns boolean {
                if (!IpcServer.ready) {
                    return false;   // this program never served, so it never issued a token
                }
                mutable int i = 0;
                while (i < IpcServer.nonces.size()) {
                    if (IpcServer.nonces.get(i) == nonce && IpcServer.caps.get(i).equals(cap)) {
                        return true;
                    }
                    i = i + 1;
                }
                return false;
            }
        }
    }
}
)LDP3";

// Parses the embedded prelude and merges its bundles into `prog`.
void appendPrelude(ldp3::ast::Program& prog) {
    ldp3::Lexer lexer(kPreludeSource, "<prelude>");  // string_view: static lifetime
    ldp3::Parser parser(lexer.tokenize(), "<prelude>");
    ldp3::ast::Program prelude = parser.parse();
    if (parser.hasErrors()) {
        std::fprintf(stderr, "internal error: the embedded prelude failed to parse\n");
        for (const ldp3::ParseError& e : parser.errors())
            std::fprintf(stderr, "  <prelude>:%d:%d: %s\n", e.loc.line, e.loc.col, e.message.c_str());
        return;
    }
    for (auto& bundle : prelude.bundles) {
        bundle.isPrelude = true;  // not user source; kept out of the .ldh
        prog.bundles.push_back(std::move(bundle));
    }
}

// Object is the root of the class hierarchy (spec 3.4): a regular class with no `extends` implicitly
// extends Object. Run after the prelude is merged so Object exists. Making a class extend Object makes
// it polymorphic (a vtable on every object), so Object's equals/hashCode dispatch on it. Excluded:
// interfaces, value types (struct/record/union), Object itself, and freestanding code -- freestanding
// needs a predictable layout with no hidden vtable (spec 36).
void assignObjectRoot(ldp3::ast::Program& program) {
    for (auto& bundle : program.bundles) {
        if (program.isFreestanding || bundle.isFreestanding) continue;
        for (auto& ns : bundle.namespaces)
            for (auto& cls : ns.classes)
                if (cls.superclass.empty() && cls.name != "Object" && !cls.isInterface &&
                    !cls.isStruct && !cls.isRecord && !cls.isUnion)
                    cls.superclass = "Object";
    }
}

int printUsage(const char* prog) {
    std::fprintf(stderr,
                 "usage: %s <input.ldp3> [-o <output.ll>] [--use <dep.ldb>] [--use-dynamic <dep.ldb>]\n"
                 "       %s --lib <input.ldp3> -o <output.ldb>   (compile a bundle; emits .ldb + .ldh)\n"
                 "       %s --extract-code <input.ldb> -o <output.bc>\n"
                 "       %s --dump-ldb <input.ldb>\n"
                 "       %s --dump-tokens <input.ldp3>\n"
                 "       %s --dump-ast <input.ldp3>\n"
                 "       %s --check <input.ldp3>\n"
                 "       %s --version\n",
                 prog, prog, prog, prog, prog, prog, prog, prog);
    return 2;
}

bool reportLexErrors(const std::string& path, const ldp3::Lexer& lexer, bool concise = false) {
    if (!lexer.hasErrors()) return false;
    for (const ldp3::LexError& e : lexer.errors())
        std::fputs(ldp3::diag::render("error", path, e.loc.line, e.loc.col, e.message,
                                      ldp3::diag::Code::LexError, sourceLineAt(path, e.loc.line), concise)
                       .c_str(),
                   stderr);
    return true;
}

bool reportParseErrors(const std::string& path, const ldp3::Parser& parser, bool concise = false) {
    if (!parser.hasErrors()) return false;
    for (const ldp3::ParseError& e : parser.errors())
        std::fputs(ldp3::diag::render("error", path, e.loc.line, e.loc.col, e.message,
                                      ldp3::diag::Code::SyntaxError, sourceLineAt(path, e.loc.line), concise)
                       .c_str(),
                   stderr);
    return true;
}

int dumpTokens(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    for (const ldp3::Token& tok : lexer.tokenize()) {
        const std::string_view name = ldp3::tokenKindName(tok.kind);
        std::printf("%s:%d:%d\t%.*s\t%s\n", path.c_str(), tok.loc.line, tok.loc.col,
                    static_cast<int>(name.size()), name.data(), tok.lexeme.c_str());
    }
    return reportLexErrors(path, lexer) ? 1 : 0;
}

// `ldp3c --fmt <file> [-o out]`: re-format a file's whitespace, in place by default.
int fmtFile(const std::string& path, const std::string& outPath) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    bool ok = false;
    const std::string formatted = ldp3::fmt::format(*source, path, &ok);
    if (!ok) {
        std::fprintf(stderr, "error: cannot format '%s' (it does not lex)\n", path.c_str());
        return 1;
    }
    const std::string& target = outPath.empty() ? path : outPath;
    std::ofstream out(target, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", target.c_str());
        return 1;
    }
    out << formatted;
    return 0;
}

// `ldp3c --doc <file> [-o out.html]`: parse a file and render its public API to HTML from /// comments.
int dumpDoc(const std::string& path, const std::string& outPath) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    const ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    const std::string html = ldp3::doc::generateHtml(program, lexer.docComments());
    if (outPath.empty()) {
        std::fputs(html.c_str(), stdout);
        return 0;
    }
    std::ofstream out(outPath, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", outPath.c_str());
        return 1;
    }
    out << html;
    std::printf("wrote %s\n", outPath.c_str());
    return 0;
}

int dumpAst(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    const ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    std::string out;
    program.dump(out, 0);
    std::fputs(out.c_str(), stdout);
    return 0;
}

// Compiles one or more .ldp3 files that together form a single program. Each
// file declares `program <Name>;` (all must agree); their bundles are merged
// (the semantic catalog is flat, so concatenation is enough). `inputs` outlives
// this call, so token SourceLocations (string_views into the paths) stay valid.
// Prints a .ldb's header (name, version, flags, fingerprint, code size) and its embedded .ldh.
int dumpLdb(const std::string& path) {
#ifdef LDP3_WITH_LLVM
    auto bytes = readFile(path);
    if (!bytes) {
        std::fprintf(stderr, "error: cannot open '%s'\n", path.c_str());
        return 1;
    }
    ldp3::LdbBundle b;
    if (!ldp3::readLdb(*bytes, b)) {
        std::fprintf(stderr, "error: '%s' is not a valid .ldb bundle\n", path.c_str());
        return 1;
    }
    std::printf("bundle: %s\n", b.name.c_str());
    std::printf("version: %s\n", b.version.c_str());
    std::printf("flags: 0x%04x%s\n", static_cast<unsigned>(b.flags),
                (b.flags & ldp3::LdbBundle::kFreestanding) ? " (freestanding)" : "");
    std::printf("fingerprint: ");
    for (unsigned char c : b.fingerprint) std::printf("%02x", c);
    std::printf("\ncode: %llu bytes of bitcode\n", static_cast<unsigned long long>(b.code.size()));
    for (const ldp3::LdbDep& d : b.deps)
        std::printf("dep: %s %s\n", d.name.c_str(), d.versionConstraint.c_str());
    for (const std::string& c : b.capabilities) std::printf("capability: %s\n", c.c_str());
    std::printf("--- .ldh ---\n%s", b.ldh.c_str());
    return 0;
#else
    (void)path;
    std::fprintf(stderr, "error: this ldp3c was built without the LLVM backend\n");
    return 1;
#endif
}

// Writes a .ldb's CODE section (LLVM bitcode) to `outPath`, for the linker to consume (clang accepts
// .bc directly). Used to link a depended-on bundle's implementation into the final executable.
int extractCode(const std::string& ldbPath, const std::string& outPath) {
#ifdef LDP3_WITH_LLVM
    if (outPath.empty()) {
        std::fprintf(stderr, "error: --extract-code requires -o <output.bc>\n");
        return 1;
    }
    auto bytes = readFile(ldbPath);
    if (!bytes) {
        std::fprintf(stderr, "error: cannot open '%s'\n", ldbPath.c_str());
        return 1;
    }
    ldp3::LdbBundle b;
    if (!ldp3::readLdb(*bytes, b)) {
        std::fprintf(stderr, "error: '%s' is not a valid .ldb bundle\n", ldbPath.c_str());
        return 1;
    }
    std::ofstream out(outPath, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", outPath.c_str());
        return 1;
    }
    out << b.code;
    return 0;
#else
    (void)ldbPath;
    (void)outPath;
    std::fprintf(stderr, "error: this ldp3c was built without the LLVM backend\n");
    return 1;
#endif
}

// Derives the .ldh path that sits next to a .ldb output (foo.ldb -> foo.ldh; otherwise append .ldh).
std::string ldhPathFor(const std::string& ldbPath) {
    if (ldbPath.size() >= 4 && ldbPath.compare(ldbPath.size() - 4, 4, ".ldb") == 0)
        return ldbPath.substr(0, ldbPath.size() - 4) + ".ldh";
    return ldbPath + ".ldh";
}

int compile(const std::vector<std::string>& inputs, const std::string& outPath,
            const std::string& target = "", int optLevel = 0, bool libraryMode = false,
            const std::vector<std::string>& deps = {},
            const std::vector<std::string>& dynDeps = {}, bool testMode = false,
            bool debugInfo = false, const std::vector<std::string>& remoteDeps = {},
            bool checkOnly = false) {
    ldp3::ast::Program program;
    std::string programName;
    // In check mode a broken file must not hide the others: an editor asks about the whole project and
    // expects every file's diagnostics back, so the front end keeps going and reports at the end.
    bool frontEndFailed = false;
    // Keep each file's source alive only within its iteration: the AST copies
    // the lexemes it needs, and locations reference the (long-lived) path string.
    for (const std::string& path : inputs) {
        auto source = readSource(path);
        if (!source) {
            std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
            return 1;
        }
        g_sources[path] = *source;  // for the rich-diagnostic snippet
        const bool frontEndConcise = checkOnly || g_concise;  // check/CI: one parseable line per error
        ldp3::diag::setConcise(frontEndConcise);  // so monomorphize's own diagnostics honour it too
        ldp3::Lexer lexer(*source, path);
        std::vector<ldp3::Token> tokens = lexer.tokenize();
        if (reportLexErrors(path, lexer, frontEndConcise)) {
            if (!checkOnly) return 1;
            frontEndFailed = true;
            continue;
        }
        ldp3::Parser parser(std::move(tokens), path);
        ldp3::ast::Program prog = parser.parse();
        if (reportParseErrors(path, parser, frontEndConcise)) {
            if (!checkOnly) return 1;
            frontEndFailed = true;
            continue;
        }
        if (programName.empty()) {
            programName = prog.name;
            program.name = prog.name;
            program.loc = prog.loc;
        } else if (prog.name != programName) {
            std::fprintf(stderr, "%s: error: program is '%s' but the first file declares '%s'\n",
                         path.c_str(), prog.name.c_str(), programName.c_str());
            return 1;
        }
        for (auto& bundle : prog.bundles) program.bundles.push_back(std::move(bundle));
        for (auto& imp : prog.imports) program.imports.push_back(std::move(imp));  // file-level (spec 2.7)
        program.hasQualifiedTypeRef |= prog.hasQualifiedTypeRef;
        // spec 2.8: a program that serves its types over IPC needs a dispatcher for them. Spotting the
        // call in the source is enough -- a false positive only synthesizes a dispatcher nobody calls.
        if (source->find("Program.serve") != std::string::npos) program.usesIpcServe = true;
        if (prog.isFreestanding) program.isFreestanding = true;
    }
    if (frontEndFailed) return 1;  // check mode: every file was lexed and parsed, and some did not survive

    std::vector<std::string> seedSlots;  // vtable slot layout adopted from imported bundles
    std::vector<std::pair<std::string, std::vector<std::string>>> depSlotMaps;  // (path, slots) per dep
    // Dynamic bundles to register with codegen: (AST bundle name, .ldb path, ABI fingerprint).
    std::vector<std::tuple<std::string, std::string, std::array<std::uint8_t, 32>>> dynBundleInfo;
#ifdef LDP3_WITH_LLVM
    // Depended-on bundles (--use foo.ldb): parse each .ldh as the bundle's public API and merge it as
    // an imported bundle (types visible; bodies stay in the .ldb, linked separately). The .ldb's
    // fingerprint must match its own header, catching a corrupt or tampered bundle.
    for (const std::string& depPath : deps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        ldp3::LdbBundle dep;
        if (!ldp3::readLdb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .ldb bundle\n", depPath.c_str());
            return 1;
        }
        if (ldp3::ldbFingerprint(dep.ldh) != dep.fingerprint) {
            std::fprintf(stderr, "error: bundle '%s' fingerprint does not match its header (corrupt)\n",
                         depPath.c_str());
            return 1;
        }
        ldp3::Lexer dlex(dep.ldh, depPath);
        ldp3::Parser dparser(dlex.tokenize(), depPath);
        dparser.setHeaderMode(true);
        ldp3::ast::Program dprog = dparser.parse();
        if (dparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n", depPath.c_str());
            return 1;
        }
        for (auto& b : dprog.bundles) {
            b.isImported = true;
            program.bundles.push_back(std::move(b));
        }
        // Adopt the bundle's vtable slot layout so virtual calls on its types hit the right slots.
        if (!dep.vtableSlots.empty()) depSlotMaps.emplace_back(depPath, dep.vtableSlots);
        for (const std::string& s : dep.vtableSlots)
            if (std::find(seedSlots.begin(), seedSlots.end(), s) == seedSlots.end())
                seedSlots.push_back(s);
    }
    // Remote bundles (--use-remote foo.ldb, spec 2.8): the types are known from the .ldh, but the code
    // runs in ANOTHER PROGRAM. synthesizeIpc turns each of their classes into a proxy whose methods are
    // RPCs, so nothing is linked and nothing is loaded -- the calls travel over the IPC channel.
    for (const std::string& depPath : remoteDeps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        ldp3::LdbBundle dep;
        if (!ldp3::readLdb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .ldb bundle\n", depPath.c_str());
            return 1;
        }
        ldp3::Lexer rlex(dep.ldh, depPath);
        ldp3::Parser rparser(rlex.tokenize(), depPath);
        rparser.setHeaderMode(true);
        ldp3::ast::Program rprog = rparser.parse();
        if (rparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n",
                         depPath.c_str());
            return 1;
        }
        for (auto& b : rprog.bundles) {
            b.isImported = true;   // synthesizeIpc clears this once it has given the classes bodies
            b.isRemote = true;
            program.bundles.push_back(std::move(b));
        }
    }
    // Dynamically-loaded bundles (--use-dynamic foo.ldb): same type-checking against the .ldh, but the
    // implementation is loaded at runtime (not linked). Codegen emits resolving thunks; record each
    // bundle's path and fingerprint so the thunk can load and verify it.
    for (const std::string& depPath : dynDeps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        ldp3::LdbBundle dep;
        if (!ldp3::readLdb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .ldb bundle\n", depPath.c_str());
            return 1;
        }
        if (ldp3::ldbFingerprint(dep.ldh) != dep.fingerprint) {
            std::fprintf(stderr, "error: bundle '%s' fingerprint does not match its header (corrupt)\n",
                         depPath.c_str());
            return 1;
        }
        ldp3::Lexer dlex(dep.ldh, depPath);
        ldp3::Parser dparser(dlex.tokenize(), depPath);
        dparser.setHeaderMode(true);
        ldp3::ast::Program dprog = dparser.parse();
        if (dparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n", depPath.c_str());
            return 1;
        }
        for (auto& b : dprog.bundles) {
            b.isImported = true;
            b.isDynamic = true;
            dynBundleInfo.emplace_back(b.name, depPath, dep.fingerprint);
            program.bundles.push_back(std::move(b));
        }
        if (!dep.vtableSlots.empty()) depSlotMaps.emplace_back(depPath, dep.vtableSlots);
        for (const std::string& s : dep.vtableSlots)
            if (std::find(seedSlots.begin(), seedSlots.end(), s) == seedSlots.end())
                seedSlots.push_back(s);
    }
    // Each bundle baked its vtable with its own 0-based slot numbering. They can be linked together
    // only if those numberings agree on a shared prefix (so the merged numbering preserves each
    // bundle's slots). Two bundles that each define their own virtual methods at the same slot cannot
    // coexist -- reject rather than silently dispatch through the wrong slot.
    for (const auto& [path, map] : depSlotMaps)
        for (std::size_t i = 0; i < map.size(); ++i)
            if (i >= seedSlots.size() || seedSlots[i] != map[i]) {
                std::fprintf(stderr,
                             "error: bundle '%s' has a vtable layout incompatible with another "
                             "depended-on bundle; they cannot be linked together\n",
                             path.c_str());
                return 1;
            }
#else
    if (!deps.empty() || !dynDeps.empty()) {
        std::fprintf(stderr, "error: --use/--use-dynamic needs the LLVM backend\n");
        return 1;
    }
#endif

    appendPrelude(program);
    // In a library the prelude is emitted into the .ldb with weak (linkonce_odr) linkage (handled in
    // codegen): static linking deduplicates it against the program's own prelude, and a dynamically
    // built DLL is self-contained (every class extends the prelude's Object). This matters now that
    // Object is the universal root, so even a trivial bundle references the prelude.
    ldp3::resolveTypeAliases(program);           // expand `typealias` to its target everywhere (spec 24)
    // Before qualifyNamespaces: the remote program's header carries ITS entry class, which this pass
    // drops. Left in place, two classes named Main would look like a name clash and both would be
    // renamed -- and this program would lose its entry point.
    if (!ldp3::synthesizeIpc(program)) return 1;  // spec 2.8: IPC proxies + this program's dispatcher
    ldp3::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    assignObjectRoot(program);                   // a class with no `extends` implicitly extends Object
    if (!ldp3::monomorphize(program)) return 1;  // expand generics; false on constraint error
    if (optLevel > 0) ldp3::interchangeReductionLoops(program);  // loop interchange (sema re-checks it)
    if (optLevel > 0) ldp3::hoistBoundsChecks(program);          // bounds-check hoisting (sema re-checks it)
    ldp3::SemanticAnalyzer sema;
    const bool semaOk = sema.analyze(program, libraryMode, testMode);
    // `--check` (used by the editor's live check) and `--concise` want one machine-parseable line per
    // diagnostic; a normal build shows the full rich explanation.
    const bool concise = checkOnly || g_concise;
    for (const ldp3::SemaError& w : sema.warnings()) printSemaDiag("warning", w, concise);
    if (!semaOk) {
        for (const ldp3::SemaError& e : sema.errors()) printSemaDiag("error", e, concise);
        return 1;
    }

    // `--check`: the answer is the diagnostics above, so stop here. Everything the front end can catch has
    // been caught, and codegen -- by far the slowest phase -- is skipped, which is what makes this fast
    // enough for an editor to run on every pause in typing.
    if (checkOnly) {
        if (!libraryMode) std::printf("OK: entry point %s\n", sema.entryPoint().qualifiedName.c_str());
        else std::printf("OK: library\n");
        return 0;
    }

#ifdef LDP3_WITH_LLVM
    ldp3::CodeGenerator codegen(program, sema.entryPoint(), inputs.front());
    codegen.setPatchedClasses(sema.patchedClasses());  // spec 32.8: they need a writable vtable
    // Always set a triple (and, through it, the data layout) -- with --target for freestanding/cross, or
    // the host's otherwise -- so ABI alignments are correct and hot loops vectorize. Without this the
    // module is layout-less and i64 loads emit `align 4`.
    std::string effectiveTriple = target;
    if (effectiveTriple.empty()) {
#ifdef _WIN32
        effectiveTriple = "x86_64-pc-windows-msvc";
#else
        effectiveTriple = "x86_64-unknown-linux-gnu";
#endif
    }
    codegen.setTargetTriple(effectiveTriple);
    codegen.setLibrary(libraryMode);  // a .ldb has no entry point / `main`
    codegen.setTestMode(testMode);    // --test: synthetic [Test] runner as the entry
    codegen.setDebugInfo(debugInfo);  // -g: emit DWARF debug metadata
    codegen.seedVtableSlots(seedSlots);  // adopt imported bundles' vtable slot layout
    for (const auto& [name, path, fp] : dynBundleInfo)
        codegen.addDynamicBundle(name, path, fp);  // runtime-resolving thunks for --use-dynamic
    if (!codegen.generate()) {
        for (const ldp3::CodegenError& e : codegen.errors()) {
            std::fprintf(stderr, "%.*s:%d:%d: codegen error: %s\n",
                         static_cast<int>(e.loc.file.size()), e.loc.file.data(), e.loc.line,
                         e.loc.col, e.message.c_str());
        }
        return 1;
    }
    codegen.optimize(optLevel);  // ldp3c's own optimization pipeline (no-op at -O0)

    if (libraryMode) {
        // Emit a self-describing .ldb bundle plus a standalone .ldh header. The bundle name is the
        // program name; versioning arrives with the manifest (F10 toolchain). CODE is bitcode so a
        // consumer can LTO it (static) or JIT it (dynamic).
        ldp3::LdbBundle bundle;
        bundle.name = program.name;
        bundle.version = "0.0.0";
        if (program.isFreestanding) bundle.flags |= ldp3::LdbBundle::kFreestanding;
        bundle.ldh = ldp3::generateLdh(program);
        bundle.fingerprint = ldp3::ldbFingerprint(bundle.ldh);
        bundle.code = codegen.toBitcode();
        bundle.vtableSlots = codegen.vtableSlotNames();  // so consumers seed the same slot layout
        const std::string ldbPath = outPath.empty() ? program.name + ".ldb" : outPath;
        const std::string ldhPath = ldhPathFor(ldbPath);
        std::ofstream ldb(ldbPath, std::ios::binary);
        if (!ldb) {
            std::fprintf(stderr, "error: cannot write bundle file '%s'\n", ldbPath.c_str());
            return 1;
        }
        ldb << ldp3::writeLdb(bundle);
        std::ofstream ldh(ldhPath, std::ios::binary);
        if (!ldh) {
            std::fprintf(stderr, "error: cannot write header file '%s'\n", ldhPath.c_str());
            return 1;
        }
        ldh << bundle.ldh;
        std::printf("OK: bundle '%s' -> %s, %s\n", program.name.c_str(), ldbPath.c_str(),
                    ldhPath.c_str());
        return 0;
    }

    const std::string ir = codegen.toIR();
    if (outPath.empty()) {
        std::fputs(ir.c_str(), stdout);
    } else {
        std::ofstream out(outPath, std::ios::binary);
        if (!out) {
            std::fprintf(stderr, "error: cannot write output file '%s'\n", outPath.c_str());
            return 1;
        }
        out << ir;
    }
    return 0;
#else
    (void)outPath;
    std::fprintf(stderr,
                 "error: this ldp3c was built without the LLVM backend "
                 "(configure with -DLDP3_WITH_LLVM=ON)\n");
    return 1;
#endif
}

}  // namespace

int main(int argc, char** argv) {
    const std::vector<std::string_view> args(argv + 1, argv + argc);
    if (args.empty()) return printUsage(argv[0]);

    if (args[0] == "--version" || args[0] == "-v") {
        std::printf("%s\n", kVersion.data());
        return 0;
    }

    // `--explain <code>`: the canonical write-up for a diagnostic code (why / how to fix / how to prevent),
    // the way `rustc --explain` works. With no code, list every code. `ldp3 explain <code>` forwards here.
    if (args[0] == "--explain") {
        if (args.size() < 2) {
            std::fputs(ldp3::diag::allCodesListing().c_str(), stdout);
            return 0;
        }
        const std::string code(args[1]);
        const ldp3::diag::Entry* e = ldp3::diag::entryByCodeString(code);
        if (e == nullptr) {
            std::fprintf(stderr, "error: unknown diagnostic code '%s' (try `ldp3c --explain` for a list)\n",
                         code.c_str());
            return 1;
        }
        std::printf("%s -- %.*s\n\n", code.c_str(), static_cast<int>(e->caret.size()), e->caret.data());
        std::printf("why:     %.*s\n\n", static_cast<int>(e->why.size()), e->why.data());
        std::printf("fix:     %.*s\n\n", static_cast<int>(e->fix.size()), e->fix.data());
        std::printf("prevent: %.*s\n", static_cast<int>(e->prevent.size()), e->prevent.data());
        return 0;
    }

    if (args[0] == "--dump-tokens" || args[0] == "--dump-ast") {
        if (args.size() < 2) {
            std::fprintf(stderr, "error: %.*s requires an input file\n",
                         static_cast<int>(args[0].size()), args[0].data());
            return printUsage(argv[0]);
        }
        const std::string path(args[1]);
        if (args[0] == "--dump-tokens") return dumpTokens(path);
        return dumpAst(path);
    }

    // `--check <file.ldp3>... [--lib] [--use <dep.ldb>]... [--overlay <real>=<temp>]...`
    // The front end only: every diagnostic the compiler can produce without generating code. It takes the
    // same inputs a build does -- a program spans several files and sees its dependencies' headers -- so an
    // editor gets the SAME answer the build would give, in a fraction of the time.
    if (args[0] == "--check") {
        std::vector<std::string> inputs;
        std::vector<std::string> deps;
        bool libraryMode = false;
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--lib") {
                libraryMode = true;
            } else if (args[i] == "--use" && i + 1 < args.size()) {
                deps.emplace_back(args[++i]);
            } else if (args[i] == "--overlay" && i + 1 < args.size()) {
                const std::string pair(args[++i]);
                const std::size_t eq = pair.rfind('=');  // rfind: a Windows path may hold no '=', the temp may
                if (eq == std::string::npos) {
                    std::fprintf(stderr, "error: --overlay expects <real>=<temp>\n");
                    return 2;
                }
                g_overlays[overlayKey(pair.substr(0, eq))] = pair.substr(eq + 1);
            } else if (args[i].rfind("--", 0) == 0) {
                std::fprintf(stderr, "error: unknown --check option '%.*s'\n",
                             static_cast<int>(args[i].size()), args[i].data());
                return 2;
            } else {
                inputs.emplace_back(args[i]);
            }
        }
        if (inputs.empty()) {
            std::fprintf(stderr, "error: --check requires an input file\n");
            return printUsage(argv[0]);
        }
        return compile(inputs, "", "", 0, libraryMode, deps, {}, false, false, {}, /*checkOnly=*/true);
    }

    if (args[0] == "--fmt") {  // re-format a file's whitespace (in place, or to -o)
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --fmt requires an input file\n");
            return printUsage(argv[0]);
        }
        std::string output;
        for (std::size_t i = 2; i + 1 < args.size(); ++i)
            if (args[i] == "-o") output = std::string(args[i + 1]);
        return fmtFile(std::string(args[1]), output);
    }

    if (args[0] == "--doc") {  // render a file's public API to HTML from its /// comments
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --doc requires an input file\n");
            return printUsage(argv[0]);
        }
        std::string output;
        for (std::size_t i = 2; i + 1 < args.size(); ++i)
            if (args[i] == "-o") output = std::string(args[i + 1]);
        return dumpDoc(std::string(args[1]), output);
    }

    if (args[0] == "--dump-ldb") {  // inspect a .ldb: print its header + embedded .ldh
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --dump-ldb requires a .ldb file\n");
            return printUsage(argv[0]);
        }
        return dumpLdb(std::string(args[1]));
    }

    // Compile mode: <input...> [-o <output>] [--lib] [--use <dep.ldb> ...]. May span several files.
    std::vector<std::string> inputs;
    std::vector<std::string> deps;  // --use <dep.ldb>: depended-on bundles to type-check/link against
    std::vector<std::string> dynDeps;  // --use-dynamic <dep.ldb>: bundles loaded at runtime
    std::vector<std::string> remoteDeps;  // --use-remote <dep.ldb>: spec 2.8, the code runs in ANOTHER
                                          // PROGRAM; the compiler synthesizes IPC proxies for its types
    std::string output;
    std::string extractFrom;  // --extract-code <dep.ldb>: dump the bundle's CODE bitcode to -o
    std::string target;  // --target=<triple>, e.g. x86_64-unknown-none for freestanding/bare metal
    int optLevel = 0;    // -O0..-O3: run ldp3c's own optimization pipeline before emitting IR
    bool libraryMode = false;  // --lib: compile a bundle to a .ldb (+ .ldh), no entry point required
    bool testMode = false;     // --test: emit a synthetic runner over the [Test] methods, not main
    bool debugInfo = false;    // -g: emit DWARF debug metadata (for lldb / the Forge debugger)
    for (std::size_t i = 0; i < args.size(); ++i) {
        if (args[i] == "-o") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: -o requires an output path\n");
                return printUsage(argv[0]);
            }
            output = std::string(args[i + 1]);
            ++i;
        } else if (args[i] == "--lib") {
            libraryMode = true;
        } else if (args[i] == "--test") {
            testMode = true;
        } else if (args[i] == "--use") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use requires a .ldb file\n");
                return printUsage(argv[0]);
            }
            deps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--use-remote") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use-remote requires a .ldb file\n");
                return printUsage(argv[0]);
            }
            remoteDeps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--use-dynamic") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use-dynamic requires a .ldb file\n");
                return printUsage(argv[0]);
            }
            dynDeps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--extract-code") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --extract-code requires a .ldb file\n");
                return printUsage(argv[0]);
            }
            extractFrom = std::string(args[i + 1]);
            ++i;
        } else if (args[i].rfind("--target=", 0) == 0) {
            target = std::string(args[i].substr(9));
        } else if (args[i] == "-O" || args[i] == "-O2") {
            optLevel = 2;
        } else if (args[i] == "-O0") {
            optLevel = 0;
        } else if (args[i] == "-O1") {
            optLevel = 1;
        } else if (args[i] == "-O3") {
            optLevel = 3;
        } else if (args[i] == "-g") {
            debugInfo = true;
            optLevel = 0;  // debug info survives best unoptimized (variables, line stepping)
        } else if (args[i] == "--concise" || args[i] == "-q") {
            g_concise = true;  // one machine-parseable line per diagnostic (CI / huge broken builds)
        } else {
            inputs.emplace_back(args[i]);
        }
    }
    if (!extractFrom.empty()) return extractCode(extractFrom, output);  // no compile: just dump CODE
    if (inputs.empty()) {
        std::fprintf(stderr, "error: no input files\n");
        return printUsage(argv[0]);
    }
    return compile(inputs, output, target, optLevel, libraryMode, deps, dynDeps, testMode, debugInfo,
                   remoteDeps);
}
