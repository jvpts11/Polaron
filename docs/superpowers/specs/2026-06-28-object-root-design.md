# Design: Object as the root of the class hierarchy (F10 String, sub-spec 1 of 4)

Date: 2026-06-28
Status: approved (brainstorming). First of four sub-specs for F10 String:
1. **Object root** (this doc), 2. boxing of primitives, 3. String/string types, 4. real interpolation.

## Goal
Make `Object` the universal root of the class hierarchy (spec 3.4): every class implicitly extends
`Object`, every object is therefore polymorphic, and `Object` declares the universal methods. This is
the foundation boxing (`Object o = 42`), `String extends Object`, and reflection build on.

This sub-spec delivers `equals`/`hashCode` and the structural root. `toString()` returns `String`, so
it lands with sub-spec 3; `getClass()` lands with reflection. Boxing of primitives is sub-spec 2.

## The Object class
A built-in root class in the embedded prelude, namespace `System.Runtime`:

```ldp3
public class Object {
    public method equals(Object other) returns boolean { ... }  // default: identity (this == other)
    public method hashCode() returns int { ... }                // default: object address as int
    // method toString() returns String;  -- added in sub-spec 3 (needs String)
    // method getClass() returns ...;      -- added with reflection
}
```

- `equals` default is reference identity: `this == other` (pointer equality), returning a boolean.
- `hashCode` default is the object's address truncated to `int`.
- Both are virtual: a subclass may `override` them (e.g. records auto-generate value-based versions,
  spec 12). They occupy stable vtable slots like any virtual method.

## Implicit `extends Object`
A class declared with no `extends` clause implicitly extends `Object`:
- **Sema**: when a class has an empty superclass, set it to `Object` (after the prelude is merged, so
  `Object` is registered). `Object` itself has no superclass. Interfaces are unchanged -- `Object` is
  the root of *classes*, not interfaces; an interface does not extend `Object`.
- A class that already `extends X` is unchanged; the root of every chain is `Object`.
- `Object` is a concrete, instantiable class (`new Object()` is allowed).

## Every class becomes polymorphic
Because any object can be used as an `Object` and have `equals`/`hashCode` dispatched on it, every
class needs a vtable. Today only classes in an inheritance/interface/abstract relationship get one
(vtable pointer at field 0); now **every** class does.

- Codegen: `hasVtable` becomes true for every class (it already is for anything reachable from
  `Object` once `Object` is the universal superclass, since every class extends it). The vtable
  pointer sits at field 0; field indices shift accordingly. Codegen already computes field indices
  from the layout, so field access stays correct -- but any path that assumed a non-polymorphic class
  has no vtable (field 0 = first declared field) must be revisited.
- `Object`'s vtable carries `equals` and `hashCode`; every class's vtable includes those slots,
  pointing at the inherited `Object` implementation unless overridden.

## Upcast to Object
`Object o = someInstance;` (and passing any instance where an `Object` is expected) is a widening
upcast: the pointer is reused, `o` is statically `Object`. Calling `o.equals(...)` / `o.hashCode()`
dispatches through the object's vtable to the most-derived implementation. (Boxing a *primitive* into
`Object` is sub-spec 2; this sub-spec covers class instances only.)

## Reconciliation with Hashable/Comparable
`Object.equals`/`hashCode` are now universal, so the previously planned `Hashable` interface is
redundant and is dropped -- hash-based collections (HashMap, HashSet) use `Object.equals`/`hashCode`.
`Comparable` stays: it provides *ordering* (for TreeMap/TreeSet), which `Object` does not.

## Cross-bundle interaction (F9)
Every class now has `equals`/`hashCode` in its vtable, so the global vtable slot numbering includes
them. The existing slot-seeding for separately-compiled bundles already adopts a depended-on bundle's
slot layout, so this is consistent; `Object`'s methods simply take stable early slots shared by all.

## Out of scope (later sub-specs)
- `toString()` (returns `String`) -> sub-spec 3.
- Boxing primitives into `Object` -> sub-spec 2.
- `getClass()` / reflection over the hierarchy -> reflection (F10-deferred).

## Testing
- A class with no `extends` is an `Object`: `Object o = new Dog() on heap;` type-checks and runs.
- `o.equals(o)` is true; `o.equals(otherInstance)` is false (identity default).
- `o.hashCode()` returns a stable value for the same object within a run.
- A class overriding `equals`/`hashCode` (value-based) dispatches to the override through an `Object`
  reference.
- The existing 298-test suite stays green (the layout change is codegen-internal).
