# Standard Library Reference — Advanced Data Structures

This slice of the LDP3 standard library provides algorithmic and data-oriented types: prefix
trees, graphs, heaps, disjoint sets, balanced/unbalanced trees, order-statistic sets, dynamic
programming helpers, geometry/interval utilities, a small entity-component-system (ECS), and an
observer/event system.

All of these types live in the embedded LDP3 prelude (the `kPreludeSource` raw string in
`src/cli/main.cpp`). Every stdlib type must be imported explicitly before use. The three
namespaces covered here are:

- `System.Collections` — the algorithmic collections and structures (Range … SpatialGrid)
- `System.Ecs` — the entity-component-system core (World, ComponentStore)
- `System.Events` — the observer/event dispatch system (Signal, IntEvent, StringEvent, and their handlers)

Import a type with its fully qualified name, e.g. `import System.Collections.IntHeap;`.

Notes that apply throughout: an `int[]` is a heap-backed dynamic array; `T[]` is a generic array;
`function<R, A...>` is a closure/lambda type with return type `R` and argument types `A...`;
`nullable T*` is a nullable pointer; `T&` is a by-reference parameter.

---

## Range

**Namespace:** `System.Collections` — `import System.Collections.Range;`

A first-class range value (`start..end`, `start..=end`, and `step`), iterable with `foreach` and
queryable. Also exposes static helpers that materialize integer ranges as `ArrayList<int>`.

Public fields:
- `public int start;` — inclusive start of the range.
- `public int end;` — end bound (inclusive only when `inclusive` is true).
- `public int stride;` — the step increment (`step` is a reserved keyword, so the field is named `stride`).
- `public boolean inclusive;` — whether `end` is included.

Members:
- `public constructor Range(int start, int end, int stride, boolean inclusive)` — build a range with an explicit step and inclusivity.
- `public method size() returns int` — number of elements the range yields, honoring step direction and inclusivity.
- `public method contains(int v) returns boolean` — whether `v` is one of the range's yielded values.
- `public method toArray() returns int[]` — materialize the range into a freshly allocated `int[]`.
- `public static method upTo(int n) returns ArrayList<int>` — the list `0, 1, …, n-1`.
- `public static method between(int start, int end) returns ArrayList<int>` — the list `start, …, end-1`.
- `public static method stepBy(int start, int end, int by) returns ArrayList<int>` — `start` up to (exclusive) `end` in increments of `by`; empty if `by <= 0`.

---

## Trie

**Namespace:** `System.Collections` — `import System.Collections.Trie;`

A prefix tree over lowercase-letter words, stored as a flat arena (26 child links + end-of-word
flag per node indexed by node number, no node pointers). A link value of 0 means "none".

Members:
- `public constructor Trie()` — create an empty trie (root node only).
- `public method insert(String word) returns void` — add a word, creating nodes as needed.
- `public method contains(String word) returns boolean` — whether the exact word was inserted.
- `public method startsWith(String prefix) returns boolean` — whether any inserted word has the given prefix.

---

## Graph

**Namespace:** `System.Collections` — `import System.Collections.Graph;`

An undirected graph on a fixed vertex set, edges kept as two parallel lists (no per-node
pointers). Answers shortest hop count between vertices via BFS.

Members:
- `public constructor Graph(int vertices)` — create a graph with `vertices` vertices numbered `0..vertices-1`.
- `public method addEdge(int u, int v) returns void` — add an undirected edge between `u` and `v`.
- `public method distance(int src, int dst) returns int` — shortest hop count from `src` to `dst`, or `-1` if unconnected.

---

## SlotMap\<T>

**Namespace:** `System.Collections` — `import System.Collections.SlotMap;`

A generational arena: `insert` returns a stable integer handle (slot index and generation packed
into one int) that stays valid until removed, even as storage grows or slots are reused. A removed
slot bumps its generation so stale handles are detected.

Members:
- `public constructor SlotMap()` — create an empty slot map with initial capacity 4.
- `public method insert(T value) returns int` — store a value and return its handle.
- `public method containsHandle(int h) returns boolean` — whether handle `h` still refers to a live slot of the matching generation.
- `public method get(int h) returns T` — the value at handle `h` (no staleness check).
- `public method remove(int h) returns void` — free the slot for a live handle, bumping its generation.
- `public method size() returns int` — number of occupied slots.

---

## IntHeap

**Namespace:** `System.Collections` — `import System.Collections.IntHeap;`

A binary min-heap of integers: `push`/`pop` keep the smallest element on top, so repeated `pop`
yields ascending order. The backing array grows as needed.

Members:
- `public constructor IntHeap()` — create an empty heap (initial capacity 8).
- `public method push(int v) returns void` — insert `v`, restoring the heap property.
- `public method pop() returns int` — remove and return the minimum.
- `public method peek() returns int` — the current minimum without removing it.
- `public method size() returns int` — number of elements.

---

## UnionFind

**Namespace:** `System.Collections` — `import System.Collections.UnionFind;`

Disjoint-set / union-find over a fixed range `0..n-1`, using union by rank with path halving.

Members:
- `public constructor UnionFind(int n)` — `n` singleton sets, one per element.
- `public method find(int x) returns int` — the representative (root) of `x`'s set, compressing the path.
- `public method merge(int a, int b) returns void` — union the sets containing `a` and `b`.
- `public method connected(int a, int b) returns boolean` — whether `a` and `b` are in the same set.
- `public method groups() returns int` — number of distinct sets remaining.

---

## BstNode

**Namespace:** `System.Collections` — `import System.Collections.BstNode;`

A node in a binary search tree, linked by nullable child pointers. `collect` does an in-order walk
appending keys in sorted order. (Used to build `Bst`, but public in its own right.)

Public fields:
- `public mutable int key;` — the node's key.
- `public mutable nullable BstNode* left;` — left child (smaller keys), or `null`.
- `public mutable nullable BstNode* right;` — right child (larger keys), or `null`.

Members:
- `public constructor BstNode(int k)` — a leaf node holding key `k` (both children `null`).
- `public method collect(ArrayList<int>& out) returns void` — in-order traversal, appending each key into the caller's list.

---

## Bst

**Namespace:** `System.Collections` — `import System.Collections.Bst;`

An ordered set of ints backed by an unbalanced (genuinely pointer-linked) binary search tree.
`insert` ignores duplicates; `inOrder` returns the keys sorted.

Members:
- `public constructor Bst()` — an empty tree.
- `public method insert(int k) returns void` — insert `k` (no-op if already present).
- `public method contains(int k) returns boolean` — membership test.
- `public method size() returns int` — number of distinct keys.
- `public method inOrder() returns ArrayList<int>` — all keys in ascending order.

---

## SortedIntSet

**Namespace:** `System.Collections` — `import System.Collections.SortedIntSet;`

A sorted set of ints on a growable sorted array with binary search: dedup insert, membership,
navigable floor/ceiling, and order statistics (rank and k-th smallest). `floor`/`ceiling` return
int min/max sentinels when absent.

Members:
- `public constructor SortedIntSet()` — an empty set (initial capacity 8).
- `public method add(int v) returns void` — insert `v`, keeping the array sorted; ignores duplicates.
- `public method contains(int v) returns boolean` — membership test.
- `public method rank(int v) returns int` — count of elements strictly less than `v`.
- `public method floor(int v) returns int` — largest element `<= v`, or `-2147483648` if none.
- `public method ceiling(int v) returns int` — smallest element `>= v`, or `2147483647` if none.
- `public method kth(int i) returns int` — the i-th smallest element (0-based).
- `public method size() returns int` — number of elements.

---

## IntCounter

**Namespace:** `System.Collections` — `import System.Collections.IntCounter;`

A multiset / frequency counter of ints backed by a `HashMap`. Tracks the running most-common
value, total, and distinct count in O(1) per add; `count` returns 0 for absent keys.

Members:
- `public constructor IntCounter()` — an empty counter.
- `public method add(int v) returns void` — tally one occurrence of `v`.
- `public method count(int v) returns int` — occurrences of `v` (0 if never added).
- `public method mostCommon() returns int` — the value with the highest running count.
- `public method maxCount() returns int` — the count of the most common value.
- `public method total() returns int` — total number of `add` calls.
- `public method distinct() returns int` — number of distinct values seen.

---

## ImmutableList\<T>

**Namespace:** `System.Collections` — `import System.Collections.ImmutableList;`

An immutable list: copies the source array at construction and exposes only reads, so contents can
never change afterward.

Members:
- `public constructor ImmutableList(T[] src, int count)` — copy the first `count` elements of `src`.
- `public method get(int i) returns T` — element at index `i`.
- `public method size() returns int` — number of elements.
- `public method isEmpty() returns boolean` — whether the list has no elements.

---

## EnumMap\<V>

**Namespace:** `System.Collections` — `import System.Collections.EnumMap;`

A dense map keyed by enum ordinal (LDP3 enums are int ordinals): values live in a flat array sized
to the enum, with a parallel presence flag. O(1) put/get/containsKey.

Members:
- `public constructor EnumMap(int size)` — a map covering ordinals `0..size-1`.
- `public method put(int ord, V v) returns void` — set the value for ordinal `ord`.
- `public method get(int ord) returns V` — the value at ordinal `ord`.
- `public method containsKey(int ord) returns boolean` — whether a value was set for `ord`.
- `public method size() returns int` — number of ordinals with a value.

---

## EnumSet

**Namespace:** `System.Collections` — `import System.Collections.EnumSet;`

A dense set of enum ordinals: a fixed-size flag array over the enum's constants, with O(1)
add/remove/contains and a maintained count.

Members:
- `public constructor EnumSet(int size)` — a set over ordinals `0..size-1`.
- `public method add(int ord) returns void` — include ordinal `ord`.
- `public method remove(int ord) returns void` — exclude ordinal `ord`.
- `public method contains(int ord) returns boolean` — whether `ord` is present.
- `public method size() returns int` — number of present ordinals.

---

## Fenwick

**Namespace:** `System.Collections` — `import System.Collections.Fenwick;`

A Fenwick tree / binary indexed tree: O(log n) point updates and prefix/range sums over int
values. Public API is 0-based.

Members:
- `public constructor Fenwick(int size)` — a tree over `size` positions, all zero.
- `public method add(int i, int delta) returns void` — add `delta` to position `i`.
- `public method prefixSum(int i) returns int` — sum of positions `0..i` inclusive.
- `public method rangeSum(int lo, int hi) returns int` — sum of positions `lo..hi` inclusive.

---

## SegmentTree

**Namespace:** `System.Collections` — `import System.Collections.SegmentTree;`

An iterative segment tree for range sums with O(log n) point updates, built from an `int[]`. Works
for any length `n`.

Members:
- `public constructor SegmentTree(int[] data)` — build the tree from the initial values.
- `public method update(int i, int value) returns void` — set position `i` to `value`.
- `public method query(int lo, int hi) returns int` — inclusive sum over `lo..hi`.

---

## SparseTable

**Namespace:** `System.Collections` — `import System.Collections.SparseTable;`

A sparse table for O(1) range-minimum queries over a fixed `int[]`, after O(n log n) build.

Members:
- `public constructor SparseTable(int[] data)` — precompute the sparse table from the data.
- `public method queryMin(int lo, int hi) returns int` — inclusive minimum over `lo..hi`.

---

## WeightedGraph

**Namespace:** `System.Collections` — `import System.Collections.WeightedGraph;`

A weighted undirected graph on a dense adjacency matrix (`-1` means no edge). Provides Dijkstra
shortest paths (O(V^2)) and minimum-spanning-tree weight via Prim.

Members:
- `public constructor WeightedGraph(int vertices)` — a graph with no edges on `vertices` vertices.
- `public method addEdge(int u, int v, int w) returns void` — add/replace an undirected edge of weight `w`.
- `public method dijkstra(int src) returns int[]` — shortest-path distances from `src`; unreachable vertices stay at `1000000000`.
- `public method mstWeight() returns int` — total weight of a minimum spanning tree (Prim's algorithm).

---

## LruCache

**Namespace:** `System.Collections` — `import System.Collections.LruCache;`

A fixed-capacity LRU cache mapping int keys to int values with O(1) get/put. A doubly linked list
over slot arrays tracks recency; a `HashMap` finds a key's slot.

Members:
- `public constructor LruCache(int capacity)` — an empty cache holding up to `capacity` entries.
- `public method get(int key) returns int` — value for `key` (marks it most-recent), or `-1` if absent.
- `public method contains(int key) returns boolean` — whether `key` is cached (does not change recency).
- `public method put(int key, int value) returns void` — insert/update `key`, evicting the least-recently-used entry if full.
- `public method count() returns int` — current number of entries.

---

## Knapsack

**Namespace:** `System.Collections` — `import System.Collections.Knapsack;`

0/1 knapsack via the classic one-dimensional DP (swept high capacity to low so each item is used at
most once). Static-only utility.

Members:
- `public static method maxValue(int[] weights, int[] values, int n, int capacity) returns int` — maximum total value of items fitting within `capacity` (first `n` items).

---

## Lcs

**Namespace:** `System.Collections` — `import System.Collections.Lcs;`

Longest common subsequence length of two strings via a flat DP table. Static-only utility.

Members:
- `public static method length(String a, String b) returns int` — length of the longest common subsequence of `a` and `b`.

---

## QuickSelect

**Namespace:** `System.Collections` — `import System.Collections.QuickSelect;`

Quickselect for the k-th smallest element in expected linear time (Lomuto partition, last-element
pivot). Partitions the array in place.

Members:
- `public static method select(int[] a, int n, int k) returns int` — the k-th smallest element (0-indexed) among the first `n` of `a`; reorders `a` in place.

---

## Comparators

**Namespace:** `System.Collections` — `import System.Collections.Comparators;`

Comparator combinators built on closures; each returns a `function<int, int, int>` usable with
`ArrayList.sortedBy`.

Members:
- `public static method naturalInt() returns function<int, int, int>` — ascending int order.
- `public static method reversed(function<int, int, int> cmp) returns function<int, int, int>` — a comparator that flips `cmp`.
- `public static method thenComparing(function<int, int, int> first, function<int, int, int> second) returns function<int, int, int>` — `first`, falling back to `second` as a tie-breaker.

---

## MinStack

**Namespace:** `System.Collections` — `import System.Collections.MinStack;`

A stack that also reports its minimum in O(1) via a parallel stack of running minima.

Members:
- `public constructor MinStack(int capacity)` — an empty stack that holds up to `capacity` items.
- `public method push(int v) returns void` — push `v`.
- `public method pop() returns int` — pop and return the top.
- `public method peek() returns int` — the top without removing it.
- `public method getMin() returns int` — the current minimum among all pushed items.
- `public method size() returns int` — number of items.

---

## SlidingWindowMax

**Namespace:** `System.Collections` — `import System.Collections.SlidingWindowMax;`

Sliding-window maximum in linear time via a monotonic deque of indices. Static-only utility.

Members:
- `public static method maxOfEach(int[] a, int n, int k) returns int[]` — the maximum of each length-`k` window over the first `n` of `a` (returns `n-k+1` values).

---

## Kadane

**Namespace:** `System.Collections` — `import System.Collections.Kadane;`

Maximum-subarray sum by Kadane's algorithm. Static-only utility.

Members:
- `public static method maxSubarray(int[] a, int n) returns int` — largest sum of any contiguous run in the first `n` of `a` (0 if `n == 0`).

---

## IntervalMerge

**Namespace:** `System.Collections` — `import System.Collections.IntervalMerge;`

Interval merging: sorts intervals by start and coalesces overlaps in place. Static-only utility.

Members:
- `public static method merge(int[] starts, int[] ends, int n) returns int` — sort and coalesce `n` intervals in place, writing merged starts/ends into the first slots; returns the merged count.
- `public static method coveredLength(int[] starts, int[] ends, int mergedCount) returns int` — total length of the merged spans (`sum of ends[i] - starts[i]`).

---

## IntervalScheduler

**Namespace:** `System.Collections` — `import System.Collections.IntervalScheduler;`

Activity selection: the maximum number of mutually non-overlapping intervals, by the greedy
earliest-finishing-time rule. Static-only utility.

Members:
- `public static method maxNonOverlapping(int[] starts, int[] ends, int n) returns int` — the largest set of non-overlapping intervals among the first `n`.

---

## BiMap\<K, V>

**Namespace:** `System.Collections` — `import System.Collections.BiMap;`

A bidirectional map: keeps key->value and value->key in sync so either side can be looked up.
`put` overwrites both directions.

Members:
- `public constructor BiMap()` — an empty bidirectional map.
- `public method put(K k, V v) returns void` — associate `k` and `v` in both directions.
- `public method getByKey(K k) returns V` — the value mapped to key `k`.
- `public method getByValue(V v) returns K` — the key mapped to value `v`.
- `public method hasKey(K k) returns boolean` — whether key `k` is present.
- `public method size() returns int` — number of entries.

---

## MultiMap\<K, V>

**Namespace:** `System.Collections` — `import System.Collections.MultiMap;`

A multimap: each key maps to a growable list of values. `put` appends.

Members:
- `public constructor MultiMap()` — an empty multimap.
- `public method put(K k, V v) returns void` — append `v` to the list for key `k`.
- `public method countFor(K k) returns int` — number of values stored for `k` (0 if absent).
- `public method get(K k, int i) returns V` — the i-th value stored for key `k`.

---

## Fenwick2D

**Namespace:** `System.Collections` — `import System.Collections.Fenwick2D;`

A 2D Fenwick tree / binary indexed tree: O(log r · log c) point updates and rectangle sums over an
int grid. Coordinates are 0-based.

Members:
- `public constructor Fenwick2D(int rows, int cols)` — a `rows × cols` grid, all zero.
- `public method update(int r, int c, int delta) returns void` — add `delta` at cell `(r, c)`.
- `public method prefix(int r, int c) returns int` — sum over the rectangle `(0,0)..(r,c)` inclusive.
- `public method rangeSum(int r1, int c1, int r2, int c2) returns int` — sum over the rectangle `(r1,c1)..(r2,c2)` inclusive.

---

## DiGraph

**Namespace:** `System.Collections` — `import System.Collections.DiGraph;`

A directed graph on a dense adjacency matrix. `topoSort` produces a topological ordering by Kahn's
algorithm (lowest-index source first); a short order means a cycle.

Members:
- `public constructor DiGraph(int vertices)` — an edge-free directed graph on `vertices` vertices.
- `public method addEdge(int u, int v) returns void` — add a directed edge `u -> v`.
- `public method topoSort(int[] order) returns int` — fill `order` with a topological ordering; returns how many vertices were placed (< n means a cycle).
- `public method hasCycle() returns boolean` — whether the graph contains a cycle.

---

## SpatialGrid

**Namespace:** `System.Collections` — `import System.Collections.SpatialGrid;`

A uniform spatial hash grid for 2D broad-phase queries: points are bucketed by cell so `queryRect`
only scans overlapping cells. Coordinates are assumed non-negative.

Members:
- `public constructor SpatialGrid(int cellSize, int capacity)` — a grid with square cells of side `cellSize`, holding up to `capacity` points.
- `public method insert(int x, int y) returns void` — add a point at `(x, y)`.
- `public method queryRect(int x0, int y0, int x1, int y1) returns int` — count of inserted points inside the box `(x0,y0)..(x1,y1)` inclusive.

---

## World

**Namespace:** `System.Ecs` — `import System.Ecs.World;`

An entity-component-system core (data-oriented): hands out integer entity ids and recycles
destroyed ones. Component data lives outside the entity in `ComponentStore`.

Members:
- `public constructor World()` — an empty world (initial capacity 16).
- `public method createEntity() returns int` — allocate a new (or recycled) entity id and mark it alive.
- `public method destroyEntity(int e) returns void` — mark entity `e` dead and recycle its id.
- `public method isAlive(int e) returns boolean` — whether `e` is a live entity id.
- `public method size() returns int` — number of live entities.
- `public method capacity() returns int` — current entity-id capacity.

---

## ComponentStore\<T>

**Namespace:** `System.Ecs` — `import System.Ecs.ComponentStore;`

A sparse-set store mapping an entity id to one component of type `T`. Components live in a dense
array for fast iteration; the sparse array maps entity -> dense slot. `remove` is swap-with-last.
Sized for entity ids in `[0, maxEntities)`.

Members:
- `public constructor ComponentStore(int maxEntities)` — a store for entity ids `0..maxEntities-1`.
- `public method add(int e, T component) returns void` — attach `component` to entity `e`.
- `public method has(int e) returns boolean` — whether entity `e` has a component here.
- `public method get(int e) returns T` — the component attached to entity `e`.
- `public method set(int e, T component) returns void` — replace entity `e`'s component in place.
- `public method remove(int e) returns void` — detach entity `e`'s component (swap-with-last).
- `public method size() returns int` — number of stored components.
- `public method entityAt(int i) returns int` — the entity id at dense index `i` (for iteration).
- `public method at(int i) returns T` — the component at dense index `i` (for iteration).

---

## VoidHandler

**Namespace:** `System.Events` — `import System.Events.VoidHandler;`

A small object wrapping a no-argument handler function so it can be stored in an array. Used by
`Signal`.

Members:
- `public constructor VoidHandler(function<void> f)` — wrap the handler `f`.
- `public method invoke() returns void` — call the wrapped handler.

---

## Signal

**Namespace:** `System.Events` — `import System.Events.Signal;`

An event that fires with no payload (a notification such as `onSave`/`onClose`). Keeps its
handlers in a plain growable array and calls them all on `emit`.

Members:
- `public constructor Signal()` — an event with no subscribers.
- `public method subscribe(function<void> h) returns void` — register a handler to run on emit.
- `public method emit() returns void` — call every subscribed handler.
- `public method count() returns int` — number of subscribers.

---

## IntHandler

**Namespace:** `System.Events` — `import System.Events.IntHandler;`

A small object wrapping a handler taking one int argument so it can be stored in an array. Used by
`IntEvent`.

Members:
- `public constructor IntHandler(function<void, int> f)` — wrap the handler `f`.
- `public method invoke(int arg) returns void` — call the wrapped handler with `arg`.

---

## IntEvent

**Namespace:** `System.Events` — `import System.Events.IntEvent;`

An event that fires with an int payload (such as `onTick(elapsed)` or `onScore(points)`).

Members:
- `public constructor IntEvent()` — an event with no subscribers.
- `public method subscribe(function<void, int> h) returns void` — register an int-taking handler.
- `public method emit(int arg) returns void` — call every subscribed handler with `arg`.
- `public method count() returns int` — number of subscribers.

---

## StringHandler

**Namespace:** `System.Events` — `import System.Events.StringHandler;`

A small object wrapping a handler taking one `String` argument so it can be stored in an array.
Used by `StringEvent`.

Members:
- `public constructor StringHandler(function<void, String> f)` — wrap the handler `f`.
- `public method invoke(String arg) returns void` — call the wrapped handler with `arg`.

---

## StringEvent

**Namespace:** `System.Events` — `import System.Events.StringEvent;`

An event that fires with a `String` payload (such as `onMessage(text)` or `onError(reason)`).

Members:
- `public constructor StringEvent()` — an event with no subscribers.
- `public method subscribe(function<void, String> h) returns void` — register a String-taking handler.
- `public method emit(String arg) returns void` — call every subscribed handler with `arg`.
- `public method count() returns int` — number of subscribers.
