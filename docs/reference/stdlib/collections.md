# System.Collections — Standard Library Reference

This is LDP3's general-purpose container library: the growable list, the hash and tree maps and
sets, the stack/queue/deque family, priority queue, ring buffer, bitset, and the lazy `Stream`
pipeline — plus the `Iterator`/`Iterable`/`Hashable`/`Comparable` interfaces they are built on.
If you have reached for `ArrayList`, `HashMap`, or `TreeMap` in another language, the equivalents
live here.

All types below live in the `System.Collections` namespace and ship as part of the LDP3 prelude
(embedded in `src/cli/main.cpp` as `kPreludeSource`). They are ordinary LDP3 classes and interfaces
with no runtime magic — generic containers backed by dynamic arrays, ring buffers, linked and tree
nodes, and hash tables — compiled from that prelude just like your own code, so the signatures
shown are the verbatim declarations from the source.

How they fit LDP3:

- **Explicit imports.** Namespace visibility is enforced, so import each type by its fully
  qualified name before use, e.g. `import System.Collections.ArrayList;`. The import line is given
  under every type.
- **Generics are monomorphized.** `ArrayList<int>` and `ArrayList<String>` are separate compiled
  classes; there is no boxing and no shared erased representation.
- **Manual memory.** A collection is an object like any other: allocate it with
  `new ArrayList<int>() on heap` and `delete` it when done. The containers manage their own backing
  storage internally (for example, the doubling array `delete`s the old block when it grows).
- **Value semantics for elements.** Storing an element (`add`, `put`, `set`) is an assignment, and
  assignment in LDP3 is a copy. For a value type `T` the element is copied *into* the collection and
  `get` copies one back *out* — the collection owns those copies. To store shared instances instead
  of copies, use a pointer element type (`ArrayList<Node*>`): then the collection holds the pointers
  and does **not** own or `delete` the pointed-to objects — that stays your responsibility.

**Key/element constraints**

- `HashMap<K,V>` keys and `HashSet<T>` / `Multiset<T>` elements must implement `Hashable` (they call `hash()` / `equalsKey()`).
- `TreeMap<K,V>` keys, `TreeSet<T>` elements, and `PriorityQueue<T>` elements must implement `Comparable` (they call `compareTo()`).
- `ArrayList<T>.indexOf` / `contains` / `remove` call `equalsKey()` on the element, so `T` must be `Hashable` for those three methods.
- Primitive types (the `int` family, `String`) satisfy `Hashable` and `Comparable` through compiler builtins, so they may be used as keys/elements without boxing.

---

## Iterator&lt;T&gt; (interface)

`import System.Collections.Iterator;`

A cursor over a sequence: `hasNext` reports whether another element remains, `next` yields the current one and advances.

| Signature | Description |
|-----------|-------------|
| `method hasNext() returns boolean` | True while another element remains. |
| `method next() returns T` | Returns the current element and advances the cursor. |

---

## Iterable&lt;T&gt; (interface)

`import System.Collections.Iterable;`

Anything that can hand out a fresh `Iterator` over its elements, so a generic algorithm can walk any collection.

| Signature | Description |
|-----------|-------------|
| `method iterator() returns Iterator<T>` | Returns a new iterator positioned at the first element. |

---

## ArrayList&lt;T&gt; — `implements Iterable<T>`

`import System.Collections.ArrayList;`

A growable list backed by a dynamic array that doubles on overflow; the general-purpose sequence collection, with a full functional pipeline (spec 34).

| Signature | Description |
|-----------|-------------|
| `public constructor ArrayList()` | Creates an empty list with capacity 4. |
| `public method add(T item) returns void` | Appends an element, doubling the backing array when full. |
| `public method ensureCapacity(int n) returns void` | Pre-grows the backing store to hold at least `n` elements; no-op if capacity already suffices; never shrinks. |
| `public method get(int i) returns T` | Returns the element at index `i`. |
| `public method set(int i, T item) returns void` | Overwrites the element at index `i`. |
| `public method indexOf(T item) returns int` | Index of the first element equal to `item` (via `equalsKey`), or -1 if absent. |
| `public method contains(T item) returns boolean` | True if any element equals `item`. |
| `public method removeAt(int i) returns void` | Removes the element at index `i`, shifting the tail left. |
| `public method remove(T item) returns boolean` | Removes the first element equal to `item`; returns whether one was removed. |
| `public method clear() returns void` | Resets the list to empty (length 0). |
| `public method toArray() returns T[]` | Copies the elements out into a fresh array. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the list has no elements. |
| `public method forEach(function<void, T> action) returns void` | Runs `action` on each element in order. |
| `public method filter(function<boolean, T> keep) returns ArrayList<T>` | Returns a new list with the elements for which `keep` is true. |
| `public method map<R>(function<R, T> transform) returns ArrayList<R>` | Returns a new list with `transform` applied to each element (may change type). |
| `public method reduce<R>(R seed, function<R, R, T> combine) returns R` | Folds the elements left-to-right into a single accumulator starting from `seed`. |
| `public method any(function<boolean, T> pred) returns boolean` | True if `pred` holds for at least one element. |
| `public method all(function<boolean, T> pred) returns boolean` | True if `pred` holds for every element. |
| `public method count(function<boolean, T> pred) returns int` | Number of elements satisfying `pred`. |
| `public method sortedBy(function<int, T, T> compare) returns ArrayList<T>` | Returns a new list ordered by `compare` (stable merge sort with insertion-sort fallback); leaves this list untouched. |
| `public method find(function<boolean, T> pred) returns Option<T>` | First element satisfying `pred` as `Some`, else `None`. |
| `public method min(function<int, T, T> compare) returns Option<T>` | Smallest element by `compare` as `Some`, or `None` when empty. |
| `public method max(function<int, T, T> compare) returns Option<T>` | Largest element by `compare` as `Some`, or `None` when empty. |
| `public override method iterator() returns Iterator<T>` | Returns an `ArrayListIterator<T>` over this list. |

```ldp3
import System.IO.Console;
import System.Collections.ArrayList;

ArrayList<int> nums = new ArrayList<int>() on heap;
nums.add(10);
nums.add(20);
nums.add(30);          // grows automatically past the initial capacity of 4
mutable int sum = 0;
for (mutable int i = 0; i < nums.size(); i++) {
    sum = sum + nums.get(i);
}
System.IO.Console.printf("size=%d sum=%d\n", nums.size(), sum);
```

---

## ArrayListIterator&lt;T&gt; — `implements Iterator<T>`

`import System.Collections.ArrayListIterator;`

The cursor an `ArrayList` hands out: walks indices `0..size` over the list it was given.

| Signature | Description |
|-----------|-------------|
| `public constructor ArrayListIterator(ArrayList<T> list)` | Binds the iterator to `list`, positioned at index 0. |
| `public override method hasNext() returns boolean` | True while the position is below the list's size. |
| `public override method next() returns T` | Returns the element at the current position and advances. |

---

## Stream&lt;T&gt; (abstract) — `implements Iterator<T>`

`import System.Collections.Stream;`

A lazy iterator pipeline (spec 25 / stdlib #25): a `Stream` is itself an `Iterator`, and each transform wraps the previous stream, pulling elements on demand. Nothing runs until a terminal op (`fold`/`count`/`forEach`) drives `hasNext`/`next`. The three concrete subclasses below inherit these members.

| Signature | Description |
|-----------|-------------|
| `public abstract method hasNext() returns boolean` | Whether the pipeline can yield another element. |
| `public abstract method next() returns T` | Pulls the next element through the pipeline. |
| `public method filter(function<boolean, T> pred) returns Stream<T>` | Wraps this stream in a `FilterStream` keeping only elements satisfying `pred`. |
| `public method map<R>(function<R, T> fn) returns Stream<R>` | Wraps this stream in a `MapStream` applying `fn` (may change the element type). |
| `public method fold<R>(R init, function<R, R, T> combine) returns R` | Terminal: folds all elements into an accumulator starting at `init`. |
| `public method forEach(function<void, T> action) returns void` | Terminal: runs `action` on each remaining element. |
| `public method count() returns int` | Terminal: consumes the stream and returns how many elements it produced. |

---

## IteratorStream&lt;T&gt; — `extends Stream<T>`

`import System.Collections.IteratorStream;`

Adapts a plain `Iterator` into a `Stream` (the head of a pipeline). Build one with `new IteratorStream<T>(collection.iterator())`, then chain `filter`/`map`.

| Signature | Description |
|-----------|-------------|
| `public constructor IteratorStream(Iterator<T> src)` | Wraps the source iterator `src`. |
| `public override method hasNext() returns boolean` | Delegates to the source iterator. |
| `public override method next() returns T` | Delegates to the source iterator. |

---

## FilterStream&lt;T&gt; — `extends Stream<T>`

`import System.Collections.FilterStream;`

Yields only the upstream elements that satisfy a predicate; caches one look-ahead so `hasNext` can skip rejected elements without losing the accepted one.

| Signature | Description |
|-----------|-------------|
| `public constructor FilterStream(Stream<T> src, function<boolean, T> pred)` | Wraps `src`, keeping elements for which `pred` is true. |
| `public override method hasNext() returns boolean` | Advances the source past rejected elements, caching the first accepted one. |
| `public override method next() returns T` | Returns the cached accepted element and clears the cache. |

---

## MapStream&lt;T, R&gt; — `extends Stream<R>`

`import System.Collections.MapStream;`

Applies a transform to each upstream element as it is pulled, possibly changing the type (`T` -> `R`); extends `Stream<R>` so it can be chained with a different element type.

| Signature | Description |
|-----------|-------------|
| `public constructor MapStream(Stream<T> src, function<R, T> fn)` | Wraps `src`, applying `fn` to each element. |
| `public override method hasNext() returns boolean` | Delegates to the source stream. |
| `public override method next() returns R` | Returns `fn` applied to the source's next element. |

---

## Slice&lt;T&gt;

`import System.Collections.Slice;`

A non-owning window over a `[start, start+len)` range of an array (spec 34): no copy, just a backing array and an offset. Reads go through the array's own bounds check, so there is no UB.

| Signature | Description |
|-----------|-------------|
| `public constructor Slice(T[] array, int start, int len)` | Creates a window of length `len` starting at `start` over `array`. |
| `public method length() returns int` | Number of elements in the window. |
| `public method get(int i) returns T` | Element at window-relative index `i`. |
| `public method set(int i, T value) returns void` | Writes `value` at window-relative index `i` (into the backing array). |
| `public method sub(int from, int to) returns Slice<T>` | Returns a narrower window over `[from, to)` relative to this slice. |
| `public method toArray() returns T[]` | Copies the window's elements out into a fresh array. |

---

## Stack&lt;T&gt;

`import System.Collections.Stack;`

LIFO stack backed by a doubling array (spec 34.1).

| Signature | Description |
|-----------|-------------|
| `public constructor Stack()` | Creates an empty stack with capacity 4. |
| `public method push(T item) returns void` | Pushes `item` on top, doubling the backing array when full. |
| `public method pop() returns T` | Removes and returns the top element. |
| `public method peek() returns T` | Returns the top element without removing it. |
| `public method toArray() returns T[]` | Copies the elements out, bottom-to-top (insertion order). |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the stack is empty. |

---

## Queue&lt;T&gt;

`import System.Collections.Queue;`

FIFO queue backed by a doubling ring buffer (spec 34.1).

| Signature | Description |
|-----------|-------------|
| `public constructor Queue()` | Creates an empty queue with capacity 4. |
| `public method enqueue(T item) returns void` | Appends `item` at the back, growing when full. |
| `public method dequeue() returns T` | Removes and returns the front element. |
| `public method peek() returns T` | Returns the front element without removing it. |
| `public method toArray() returns T[]` | Copies the elements out, front-to-back. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the queue is empty. |

---

## Deque&lt;T&gt;

`import System.Collections.Deque;`

Double-ended queue backed by a doubling ring buffer (spec 34.1).

| Signature | Description |
|-----------|-------------|
| `public constructor Deque()` | Creates an empty deque with capacity 4. |
| `public method addLast(T item) returns void` | Appends `item` at the back. |
| `public method addFirst(T item) returns void` | Prepends `item` at the front. |
| `public method removeFirst() returns T` | Removes and returns the front element. |
| `public method removeLast() returns T` | Removes and returns the back element. |
| `public method toArray() returns T[]` | Copies the elements out, front-to-back. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the deque is empty. |

---

## LinkedNode&lt;T&gt;

`import System.Collections.LinkedNode;`

Singly-linked list node (helper for `LinkedList`).

| Signature | Description |
|-----------|-------------|
| `public mutable T value` | The node's stored value. |
| `public mutable nullable LinkedNode<T>* next` | Pointer to the next node, or `null` at the tail. |
| `public constructor LinkedNode(T v)` | Creates a node holding `v` with `next` set to `null`. |

---

## LinkedList&lt;T&gt;

`import System.Collections.LinkedList;`

Linked list (spec 34.1): O(1) append and O(1) head removal, built from self-referential generic pointer nodes (`LinkedNode<T>` holding a `LinkedNode<T>* next`).

| Signature | Description |
|-----------|-------------|
| `public constructor LinkedList()` | Creates an empty list. |
| `public method add(T item) returns void` | Appends `item` at the tail (O(1)). |
| `public method get(int i) returns T` | Returns the element at index `i` (walks from the head). |
| `public method removeFirst() returns T` | Removes and returns the head element, freeing its node. |
| `public method toArray() returns T[]` | Copies the elements out, head-to-tail. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the list is empty. |

---

## Hashable&lt;T&gt; (interface)

`import System.Collections.Hashable;`

Implemented by keys of `HashMap`/`HashSet` (spec 34). Primitive types satisfy it via compiler builtins.

| Signature | Description |
|-----------|-------------|
| `method hash() returns long` | A hash code for this value. |
| `method equalsKey(T other) returns boolean` | Whether this value is equal to `other` for keying purposes. |

---

## Comparable&lt;T&gt; (interface)

`import System.Collections.Comparable;`

Implemented by keys of `TreeMap`/`TreeSet` and elements of `PriorityQueue` (spec 34). Primitive types satisfy it via compiler builtins.

| Signature | Description |
|-----------|-------------|
| `method compareTo(T other) returns int` | Negative if this precedes `other`, zero if equal, positive if it follows. |

---

## HashMap&lt;K, V&gt;

`import System.Collections.HashMap;`

Hash map with open addressing (linear probing); capacity is a power of two, load factor 0.75 (spec 34.1). Keys must be `Hashable`. `get()` on an absent key returns a zero/null value — probe with `containsKey()` first.

| Signature | Description |
|-----------|-------------|
| `public constructor HashMap()` | Creates an empty map with capacity 8. |
| `public method put(K key, V value) returns void` | Inserts or overwrites the value for `key`, growing at load factor 0.75. |
| `public method get(K key) returns V` | Value for `key`, or a zero/null value if absent (check `containsKey` first). |
| `public method containsKey(K key) returns boolean` | Whether `key` is present. |
| `public method getOrDefault(K key, V defaultValue) returns V` | Value for `key`, or `defaultValue` if absent (single probe). |
| `public method merge(K key, V value, function<V, V, V> combine) returns void` | Inserts `value`, or replaces the existing value with `combine(old, value)` — one probe (efficient tallying). |
| `public method remove(K key) returns boolean` | Removes `key` (backward-shift of its probe cluster); returns whether it was present. |
| `public method keyArray() returns K[]` | All keys, in arbitrary order. |
| `public method valueArray() returns V[]` | All values, in arbitrary order. |
| `public method size() returns int` | Number of entries. |
| `public method isEmpty() returns boolean` | True when the map has no entries. |

```ldp3
import System.IO.Console;
import System.Collections.HashMap;

HashMap<String, int> scores = new HashMap<String, int>() on heap;
scores.put("alpha", 1);
scores.put("beta", 2);
if (scores.containsKey("alpha")) {              // get() alone can't tell absent from zero
    System.IO.Console.printf("alpha=%d\n", scores.get("alpha"));
}
int g = scores.getOrDefault("gamma", -1);       // -1 because "gamma" is absent
System.IO.Console.printf("gamma=%d size=%d\n", g, scores.size());
```

---

## HashSet&lt;T&gt;

`import System.Collections.HashSet;`

Hash set with open addressing (spec 34.1). Elements must be `Hashable`.

| Signature | Description |
|-----------|-------------|
| `public constructor HashSet()` | Creates an empty set with capacity 8. |
| `public method add(T value) returns void` | Inserts `value` if not already present, growing at load factor 0.75. |
| `public method contains(T value) returns boolean` | Whether `value` is present. |
| `public method remove(T value) returns boolean` | Removes `value` (backward-shift deletion); returns whether it was present. |
| `public method toArray() returns T[]` | All elements, in arbitrary order. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the set is empty. |

---

## TreeNode&lt;K, V&gt;

`import System.Collections.TreeNode;`

Binary-search-tree node for `TreeMap` (self-referential generic).

| Signature | Description |
|-----------|-------------|
| `public mutable K key` | The node's key. |
| `public mutable V value` | The value mapped to `key`. |
| `public mutable nullable TreeNode<K, V>* left` | Left child (smaller keys), or `null`. |
| `public mutable nullable TreeNode<K, V>* right` | Right child (larger keys), or `null`. |
| `public mutable int height` | AVL subtree height, used for O(log n) balancing. |
| `public constructor TreeNode(K k, V v)` | Creates a leaf node for `k`/`v` (children `null`, height 1). |

---

## TreeMap&lt;K, V&gt;

`import System.Collections.TreeMap;`

Ordered map backed by an AVL-balanced binary search tree (spec 34.1). Keys are `Comparable`. `get()` on an absent key returns a zero/null value — probe with `containsKey()` first. Navigable-key queries return a zero/null key when none qualifies.

| Signature | Description |
|-----------|-------------|
| `public constructor TreeMap()` | Creates an empty map. |
| `public method put(K key, V value) returns void` | Inserts or overwrites `key`, rebalancing to keep height O(log n). |
| `public method get(K key) returns V` | Value for `key`, or a zero/null value if absent. |
| `public method containsKey(K key) returns boolean` | Whether `key` is present. |
| `public method keyArray() returns K[]` | All keys in sorted (in-order) order. |
| `public method valueArray() returns V[]` | All values, in key order. |
| `public method firstKey() returns K` | Smallest key (leftmost), or a zero/null key if empty. |
| `public method lastKey() returns K` | Largest key (rightmost), or a zero/null key if empty. |
| `public method floorKey(K key) returns K` | Largest key <= `key`, or a zero/null key if none. |
| `public method ceilingKey(K key) returns K` | Smallest key >= `key`, or a zero/null key if none. |
| `public method higherKey(K key) returns K` | Smallest key strictly > `key`, or a zero/null key if none. |
| `public method lowerKey(K key) returns K` | Largest key strictly < `key`, or a zero/null key if none. |
| `public method size() returns int` | Number of entries. |
| `public method isEmpty() returns boolean` | True when the map has no entries. |

---

## TreeSetNode&lt;T&gt;

`import System.Collections.TreeSetNode;`

BST node for `TreeSet` (self-referential generic).

| Signature | Description |
|-----------|-------------|
| `public mutable T value` | The node's element. |
| `public mutable nullable TreeSetNode<T>* left` | Left child (smaller values), or `null`. |
| `public mutable nullable TreeSetNode<T>* right` | Right child (larger values), or `null`. |
| `public mutable int height` | AVL subtree height. |
| `public constructor TreeSetNode(T v)` | Creates a leaf node for `v` (children `null`, height 1). |

---

## TreeSet&lt;T&gt;

`import System.Collections.TreeSet;`

Ordered set backed by an AVL-balanced binary search tree (spec 34.1). Elements are `Comparable`.

| Signature | Description |
|-----------|-------------|
| `public constructor TreeSet()` | Creates an empty set. |
| `public method add(T value) returns void` | Inserts `value` if not present, rebalancing to keep height O(log n). |
| `public method contains(T value) returns boolean` | Whether `value` is present. |
| `public method toArray() returns T[]` | All elements in sorted (in-order) order. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the set is empty. |

---

## PriorityQueue&lt;T&gt;

`import System.Collections.PriorityQueue;`

Binary min-heap priority queue (spec 34.1): the smallest element (by `compareTo`) is served first. Backed by a doubling array; `add` and `poll` are O(log n). Elements are `Comparable`.

| Signature | Description |
|-----------|-------------|
| `public constructor PriorityQueue()` | Creates an empty queue with capacity 8. |
| `public method add(T item) returns void` | Inserts `item` and sifts it up to restore the heap. |
| `public method peek() returns T` | Returns the smallest element without removing it. |
| `public method poll() returns T` | Removes and returns the smallest element, sifting down to restore the heap. |
| `public method size() returns int` | Number of elements. |
| `public method isEmpty() returns boolean` | True when the queue is empty. |

---

## Bitset

`import System.Collections.Bitset;`

A compact set of bit flags packed into 32-bit words (spec 34.1). Cheaper than a `HashSet<int>` for dense indices in a known range. (Non-generic.)

| Signature | Description |
|-----------|-------------|
| `public constructor Bitset(int size)` | Creates a bitset holding `size` bits, all cleared. |
| `public method set(int i) returns void` | Sets bit `i` to 1. |
| `public method clear(int i) returns void` | Clears bit `i` to 0. |
| `public method flip(int i) returns void` | Toggles bit `i`. |
| `public method get(int i) returns boolean` | Whether bit `i` is set. |
| `public method count() returns int` | Number of bits currently set (population count). |
| `public method size() returns int` | Total capacity in bits. |

---

## Multiset&lt;T&gt;

`import System.Collections.Multiset;`

Counts how many times each value is added (spec 34.1): a multiset over a `HashMap`. The element type must be `Hashable`, like any `HashMap` key. (Named `Multiset` rather than `Counter` so it does not shadow a user class.)

| Signature | Description |
|-----------|-------------|
| `public constructor Multiset()` | Creates an empty multiset. |
| `public method add(T item) returns void` | Bumps `item`'s tally by one. |
| `public method count(T item) returns int` | Current tally of `item` (0 if never added). |
| `public method distinct() returns int` | Number of distinct values seen. |
| `public method total() returns int` | Sum of all tallies. |
| `public method keys() returns T[]` | The distinct values, in arbitrary order. |

---

## RingBuffer&lt;T&gt;

`import System.Collections.RingBuffer;`

A fixed-capacity circular buffer (spec 34.1): `push` appends and, once full, overwrites the oldest element; `pop`/`peek` read from the oldest end. Indices wrap with modulo, so there is no shifting.

| Signature | Description |
|-----------|-------------|
| `public constructor RingBuffer(int capacity)` | Creates a buffer holding up to `capacity` elements. |
| `public method push(T item) returns void` | Appends `item`; when full, overwrites the oldest element and advances the head. |
| `public method pop() returns T` | Removes and returns the oldest element. |
| `public method peek() returns T` | Returns the oldest element without removing it. |
| `public method size() returns int` | Current number of elements. |
| `public method isEmpty() returns boolean` | True when the buffer holds nothing. |
| `public method isFull() returns boolean` | True when the buffer is at capacity. |
| `public method capacity() returns int` | The fixed maximum number of elements. |

---

## LinkedHashMap&lt;K, V&gt;

`import System.Collections.LinkedHashMap;`

A map that remembers insertion order (spec 34.1): a `HashMap` for lookup plus a list of keys in the order they were first added. `put` updates in place without reordering; `keysInOrder` walks them as inserted, which a plain `HashMap` does not promise. Keys must be `Hashable`.

| Signature | Description |
|-----------|-------------|
| `public constructor LinkedHashMap()` | Creates an empty ordered map. |
| `public method put(K key, V value) returns void` | Inserts or updates `key`; records first-insertion order. |
| `public method get(K key) returns V` | Value for `key` (delegates to the backing map). |
| `public method containsKey(K key) returns boolean` | Whether `key` is present. |
| `public method size() returns int` | Number of entries. |
| `public method isEmpty() returns boolean` | True when the map has no entries. |
| `public method keysInOrder() returns ArrayList<K>` | Keys in the order they were first inserted. |
