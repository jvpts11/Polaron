// ldp3c -- the LDP3 compiler driver (CLI entry point).
//
// Release 0.1 / M1 (walking skeleton): the full pipeline is wired up.
//   ldp3c <in.ldp3> [-o <out.ll>]   compile to LLVM IR (stdout if no -o)
//   ldp3c --dump-tokens <in.ldp3>   lexer output
//   ldp3c --dump-ast <in.ldp3>      parser output
//   ldp3c --check <in.ldp3>         lex + parse + semantic, report entry point
//   ldp3c --version

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdio>
#include <fstream>
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
#include "parser/loopopt.h"
#include "parser/monomorphize.h"
#include "parser/parser.h"
#include "semantic/analyzer.h"

#include "bundle/ldh.h"

#ifdef LDP3_WITH_LLVM
#include "bundle/ldb.h"
#include "codegen/codegen.h"
#endif

namespace {

constexpr std::string_view kVersion = "ldp3c 0.1.0-dev";

std::optional<std::string> readFile(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) return std::nullopt;
    std::ostringstream buffer;
    buffer << in.rdbuf();
    return buffer.str();
}

// The embedded standard prelude. Parsed and merged into every program so that
// `import System.Memory.Units.kilobytes;` resolves without a stdlib on disk
// (spec 17.10). The unit literals return a heap-allocated ByteSize; the spec
// makes them comptime, so the allocation vanishes once comptime eval lands (F6).
constexpr std::string_view kPreludeSource = R"LDP3(
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
                mutable String content = "";
                for (mutable int i = 0; i < lines.size(); i++) {
                    content = content.concat(lines.get(i)).concat("\n");
                }
                File.writeAll(path, content);
                return;
            }
            public static method appendLine(String path, String line) returns void {
                File.appendAll(path, line.concat("\n"));
                return;
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
                mutable ArrayList<String> parts = Strings.split(path, "/");
                return parts.get(parts.size() - 1);
            }
            public static method dirname(String path) returns String {
                mutable ArrayList<String> parts = Strings.split(path, "/");
                if (parts.size() <= 1) { return ""; }
                mutable String result = "";
                for (mutable int i = 0; i < parts.size() - 1; i++) {
                    if (i > 0) { result = result.concat("/"); }
                    result = result.concat(parts.get(i));
                }
                return result;
            }
            public static method extension(String path) returns String {
                String base = Paths.basename(path);
                mutable ArrayList<String> parts = Strings.split(base, ".");
                if (parts.size() < 2) { return ""; }
                return parts.get(parts.size() - 1);
            }
        }
    }
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
            public method get(int i) returns T {
                return this.data[i];
            }
            public method set(int i, T item) returns void {
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
                for (mutable int j = i; j < this.count - 1; j++) {
                    this.data[j] = this.data[j + 1];
                }
                this.count = this.count - 1;
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
                for (mutable int i = 0; i < this.count; i++) {
                    if (keep(this.data[i])) { out.add(this.data[i]); }
                }
                return out;
            }
            public method map<R>(function<R, T> transform) returns ArrayList<R> {
                mutable ArrayList<R> out = new ArrayList<R>() on heap;
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
            // negative when a comes first, positive when b does. Stable insertion sort, leaves this list
            // untouched. The comparator keeps it generic -- the element type needs no ordering of its own.
            public method sortedBy(function<int, T, T> compare) returns ArrayList<T> {
                mutable ArrayList<T> out = new ArrayList<T>() on heap;
                for (mutable int i = 0; i < this.count; i++) { out.add(this.data[i]); }
                for (mutable int i = 1; i < out.size(); i++) {
                    mutable T key = out.get(i);
                    mutable int j = i - 1;
                    while (j >= 0 && compare(out.get(j), key) > 0) {
                        out.set(j + 1, out.get(j));
                        j = j - 1;
                    }
                    out.set(j + 1, key);
                }
                return out;
            }
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
            public constructor TreeNode(K k, V v) {
                this.key = k; this.value = v; this.left = null; this.right = null;
            }
        }
        // Ordered map backed by an (unbalanced) binary search tree (spec 34.1). Keys are Comparable.
        // get() on an absent key returns a zero/null value; probe with containsKey() first.
        public class TreeMap<K, V> {
            private mutable nullable TreeNode<K, V>* root;
            private mutable int count;
            public constructor TreeMap() { this.root = null; this.count = 0; }
            public method put(K key, V value) returns void {
                if (this.root == null) {
                    this.root = new TreeNode<K, V>(key, value) on heap;
                    this.count = this.count + 1;
                    return;
                }
                mutable nullable TreeNode<K, V>* cur = this.root;
                while (true) {
                    int c = key.compareTo(cur.key);
                    if (c == 0) { cur.value = value; return; }
                    if (c < 0) {
                        if (cur.left == null) {
                            cur.left = new TreeNode<K, V>(key, value) on heap;
                            this.count = this.count + 1;
                            return;
                        }
                        cur = cur.left;
                    } else {
                        if (cur.right == null) {
                            cur.right = new TreeNode<K, V>(key, value) on heap;
                            this.count = this.count + 1;
                            return;
                        }
                        cur = cur.right;
                    }
                }
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
            public method size() returns int { return this.count; }
            public method isEmpty() returns boolean { return this.count == 0; }
        }
        // BST node for TreeSet (self-referential generic).
        public class TreeSetNode<T> {
            public mutable T value;
            public mutable nullable TreeSetNode<T>* left;
            public mutable nullable TreeSetNode<T>* right;
            public constructor TreeSetNode(T v) { this.value = v; this.left = null; this.right = null; }
        }
        // Ordered set backed by an (unbalanced) binary search tree (spec 34.1). Elements Comparable.
        public class TreeSet<T> {
            private mutable nullable TreeSetNode<T>* root;
            private mutable int count;
            public constructor TreeSet() { this.root = null; this.count = 0; }
            public method add(T value) returns void {
                if (this.root == null) {
                    this.root = new TreeSetNode<T>(value) on heap;
                    this.count = this.count + 1;
                    return;
                }
                mutable nullable TreeSetNode<T>* cur = this.root;
                while (true) {
                    int c = value.compareTo(cur.value);
                    if (c == 0) { return; }
                    if (c < 0) {
                        if (cur.left == null) {
                            cur.left = new TreeSetNode<T>(value) on heap;
                            this.count = this.count + 1;
                            return;
                        }
                        cur = cur.left;
                    } else {
                        if (cur.right == null) {
                            cur.right = new TreeSetNode<T>(value) on heap;
                            this.count = this.count + 1;
                            return;
                        }
                        cur = cur.right;
                    }
                }
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
                this.words[i / 32] = this.words[i / 32] | (1 << (i % 32));
                return;
            }
            public method clear(int i) returns void {
                this.words[i / 32] = this.words[i / 32] & (~(1 << (i % 32)));
                return;
            }
            public method flip(int i) returns void {
                this.words[i / 32] = this.words[i / 32] ^ (1 << (i % 32));
                return;
            }
            public method get(int i) returns boolean {
                return (this.words[i / 32] & (1 << (i % 32))) != 0;
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
                for (mutable int i = 0; i < this.count; i++) {
                    Memory.write(nb + cast<address>(i), Memory.read<byte>(this.buf + cast<address>(i)));
                }
                Memory.free(this.buf);
                this.buf = nb;
                this.cap = n;
            }
            public method append(String s) returns StringBuilder {
                int n = s.length();
                this.ensure(n);
                for (mutable int i = 0; i < n; i++) {
                    Memory.write(this.buf + cast<address>(this.count), cast<byte>(s.charAt(i)));
                    this.count = this.count + 1;
                }
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
                mutable ArrayList<String> out = new ArrayList<String>() on heap;
                mutable String rest = text;
                mutable boolean more = true;
                while (more) {
                    int at = rest.indexOf(separator);
                    if (at < 0) {
                        out.add(rest);
                        more = false;
                    } else {
                        out.add(rest.substring(0, at));
                        rest = rest.substring(at + separator.length(), rest.length());
                    }
                }
                return out;
            }
            public static method join(ArrayList<String> parts, String separator) returns String {
                mutable String result = "";
                for (mutable int i = 0; i < parts.size(); i++) {
                    if (i > 0) { result = result.concat(separator); }
                    result = result.concat(parts.get(i));
                }
                return result;
            }
            public static method replace(String text, String target, String replacement) returns String {
                if (target.length() == 0) { return text; }
                mutable String result = "";
                mutable String rest = text;
                mutable boolean more = true;
                while (more) {
                    int at = rest.indexOf(target);
                    if (at < 0) {
                        result = result.concat(rest);
                        more = false;
                    } else {
                        result = result.concat(rest.substring(0, at));
                        result = result.concat(replacement);
                        rest = rest.substring(at + target.length(), rest.length());
                    }
                }
                return result;
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
                mutable String result = "";
                mutable String rest = template;
                mutable int next = 0;
                mutable boolean more = true;
                while (more) {
                    int at = rest.indexOf("{}");
                    if (at < 0) {
                        result = result.concat(rest);
                        more = false;
                    } else {
                        result = result.concat(rest.substring(0, at));
                        if (next < args.size()) {
                            result = result.concat(args.get(next));
                            next = next + 1;
                        }
                        rest = rest.substring(at + 2, rest.length());
                    }
                }
                return result;
            }
            // Counts the non-overlapping occurrences of a substring (spec 4).
            public static method count(String text, String sub) returns int {
                if (sub.length() == 0) { return 0; }
                mutable int hits = 0;
                mutable String rest = text;
                mutable boolean more = true;
                while (more) {
                    int at = rest.indexOf(sub);
                    if (at < 0) {
                        more = false;
                    } else {
                        hits = hits + 1;
                        rest = rest.substring(at + sub.length(), rest.length());
                    }
                }
                return hits;
            }
            // Reverses the characters of a string (spec 4); substring(i, i+1) yields each one-char piece.
            public static method reverse(String text) returns String {
                mutable String result = "";
                for (mutable int i = text.length() - 1; i >= 0; i--) {
                    result = result.concat(text.substring(i, i + 1));
                }
                return result;
            }
            // Upper-cases the first character and leaves the rest unchanged (spec 4).
            public static method capitalize(String text) returns String {
                if (text.length() == 0) { return text; }
                return text.substring(0, 1).toUpper().concat(text.substring(1, text.length()));
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
            public method add(Json v) returns void {  // append a child (array element / member)
                if (this.lastChild == null) { this.firstChild = v; } else { this.lastChild.nextSibling = v; }
                this.lastChild = v;
                this.childCount = this.childCount + 1;
            }
            public method put(String key, Json v) returns void { v.memberKey = key; this.add(v); }
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
            private method escapeInto(StringBuilder sb, String s) returns void {
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
            private method writeInto(StringBuilder sb) returns void {
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
            public static method parse(String src) returns Json {
                JsonParser p = new JsonParser(src) on heap;
                return p.parseValue();
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
            public method add(BigInteger other) returns BigInteger {  // same-sign add (draft)
                BigInteger r = BigInteger.addMag(this, other);
                r.neg = this.neg;
                return r;
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
            public method compareTo(BigInteger other) returns int {
                if (this.len != other.len) { return this.len < other.len ? -1 : 1; }
                for (mutable int i = this.len - 1; i >= 0; i--) {
                    if (this.dig[i] != other.dig[i]) { return this.dig[i] < other.dig[i] ? -1 : 1; }
                }
                return 0;
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
    }
)LDP3"
// (split: System.Net in its own literal.)
R"LDP3(
    public namespace System.Net {
        // A blocking TCP client socket (spec 34). The connect happens in the constructor; the handle
        // is the OS socket (or -1 on failure). send/receive/close lower to runtime winsock helpers.
        public class Socket {
            private mutable long handle;
            public constructor Socket(String host, int port) { this.handle = Net.connect(host, port); }
            public method isOpen() returns boolean { return this.handle >= cast<long>(0); }
            public method send(String data) returns long { return Net.send(this.handle, data); }
            public method receive(int max) returns String { return Net.recv(this.handle, max); }
            public method close() returns void { Net.close(this.handle); }
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

bool reportLexErrors(const std::string& path, const ldp3::Lexer& lexer) {
    if (!lexer.hasErrors()) return false;
    for (const ldp3::LexError& e : lexer.errors()) {
        std::fprintf(stderr, "%s:%d:%d: lex error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                     e.message.c_str());
    }
    return true;
}

bool reportParseErrors(const std::string& path, const ldp3::Parser& parser) {
    if (!parser.hasErrors()) return false;
    for (const ldp3::ParseError& e : parser.errors()) {
        std::fprintf(stderr, "%s:%d:%d: parse error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                     e.message.c_str());
    }
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

int checkProgram(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    appendPrelude(program);
    ldp3::resolveTypeAliases(program);           // expand `typealias` to its target everywhere (spec 24)
    ldp3::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    assignObjectRoot(program);                   // a class with no `extends` implicitly extends Object
    if (!ldp3::monomorphize(program)) return 1;  // expand generics; false on constraint error
    ldp3::SemanticAnalyzer sema;
    const bool semaOk = sema.analyze(program);
    for (const ldp3::SemaError& w : sema.warnings()) {
        std::fprintf(stderr, "%s:%d:%d: warning: %s\n", path.c_str(), w.loc.line, w.loc.col,
                     w.message.c_str());
    }
    if (!semaOk) {
        for (const ldp3::SemaError& e : sema.errors()) {
            std::fprintf(stderr, "%s:%d:%d: error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                         e.message.c_str());
        }
        return 1;
    }
    std::printf("OK: entry point %s\n", sema.entryPoint().qualifiedName.c_str());
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
            const std::vector<std::string>& dynDeps = {}) {
    ldp3::ast::Program program;
    std::string programName;
    // Keep each file's source alive only within its iteration: the AST copies
    // the lexemes it needs, and locations reference the (long-lived) path string.
    for (const std::string& path : inputs) {
        auto source = readFile(path);
        if (!source) {
            std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
            return 1;
        }
        ldp3::Lexer lexer(*source, path);
        std::vector<ldp3::Token> tokens = lexer.tokenize();
        if (reportLexErrors(path, lexer)) return 1;
        ldp3::Parser parser(std::move(tokens), path);
        ldp3::ast::Program prog = parser.parse();
        if (reportParseErrors(path, parser)) return 1;
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
        if (prog.isFreestanding) program.isFreestanding = true;
    }

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
    ldp3::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    assignObjectRoot(program);                   // a class with no `extends` implicitly extends Object
    if (!ldp3::monomorphize(program)) return 1;  // expand generics; false on constraint error
    if (optLevel > 0) ldp3::interchangeReductionLoops(program);  // loop interchange (sema re-checks it)
    ldp3::SemanticAnalyzer sema;
    const bool semaOk = sema.analyze(program, libraryMode);
    for (const ldp3::SemaError& w : sema.warnings()) {
        std::fprintf(stderr, "%.*s:%d:%d: warning: %s\n", static_cast<int>(w.loc.file.size()),
                     w.loc.file.data(), w.loc.line, w.loc.col, w.message.c_str());
    }
    if (!semaOk) {
        for (const ldp3::SemaError& e : sema.errors()) {
            std::fprintf(stderr, "%.*s:%d:%d: error: %s\n", static_cast<int>(e.loc.file.size()),
                         e.loc.file.data(), e.loc.line, e.loc.col, e.message.c_str());
        }
        return 1;
    }

#ifdef LDP3_WITH_LLVM
    ldp3::CodeGenerator codegen(program, sema.entryPoint(), inputs.front());
    if (!target.empty()) codegen.setTargetTriple(target);  // e.g. --target=x86_64-unknown-none
    codegen.setLibrary(libraryMode);  // a .ldb has no entry point / `main`
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

    if (args[0] == "--dump-tokens" || args[0] == "--dump-ast" || args[0] == "--check") {
        if (args.size() < 2) {
            std::fprintf(stderr, "error: %.*s requires an input file\n",
                         static_cast<int>(args[0].size()), args[0].data());
            return printUsage(argv[0]);
        }
        const std::string path(args[1]);
        if (args[0] == "--dump-tokens") return dumpTokens(path);
        if (args[0] == "--dump-ast") return dumpAst(path);
        return checkProgram(path);
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
    std::string output;
    std::string extractFrom;  // --extract-code <dep.ldb>: dump the bundle's CODE bitcode to -o
    std::string target;  // --target=<triple>, e.g. x86_64-unknown-none for freestanding/bare metal
    int optLevel = 0;    // -O0..-O3: run ldp3c's own optimization pipeline before emitting IR
    bool libraryMode = false;  // --lib: compile a bundle to a .ldb (+ .ldh), no entry point required
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
        } else if (args[i] == "--use") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use requires a .ldb file\n");
                return printUsage(argv[0]);
            }
            deps.emplace_back(args[i + 1]);
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
        } else {
            inputs.emplace_back(args[i]);
        }
    }
    if (!extractFrom.empty()) return extractCode(extractFrom, output);  // no compile: just dump CODE
    if (inputs.empty()) {
        std::fprintf(stderr, "error: no input files\n");
        return printUsage(argv[0]);
    }
    return compile(inputs, output, target, optLevel, libraryMode, deps, dynDeps);
}
