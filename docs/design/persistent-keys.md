# Keyed persistents — key ownership

*Design note, 2026-08-03. Decided: a persistent is keyed by the declaring class's identity, with no new
keyword. This note settles the part that was left open — who owns the key, and for how long.*

## The problem

A persistent outlives the object that declared it. That is the whole feature. So the registry holds an
entry after the object is gone — and if the key is *the object*, the registry is holding a pointer to
something that no longer exists.

Storing a copy of the key object does not fix it either. LDP3's copy is one level deep
([§5.1](../reference/guide/05-memory-and-ownership.md)): a pointer field is copied **as a pointer**, so a
key containing one would still dangle the moment the pointee died. Copying deeper means `cascade clone`
on every attach, which drags an unbounded graph walk into a lookup.

And the obvious shortcut is worse than either: keying by the hash alone means two distinct identities
that collide **silently share state**. That is the exact bug class this language spends its effort
removing, in a feature whose whole subject is state.

## The decision: the key is BYTES, not an object

At attach time the compiler serialises the key into a byte string. The registry stores those bytes and
compares them with `memcmp`.

Every problem above disappears rather than being managed:

| | |
|---|---|
| Ownership | Bytes are self-contained. Copied once into registry memory, owned by it, freed with it. |
| Dangling | There is nothing to dangle. No pointer leaves the object. |
| Collisions | The hash picks a bucket; the **bytes** decide the match. Two identities never merge. |
| Freestanding | No callback from the runtime into LDP3 code, so hosted and bare metal run the same path. |
| Cost | Serialise once per distinct identity, at attach — never on access. |

## What gets serialised

The same fields the generated key hooks already use — `keyPart()` in `synthesizeValueKeyHooks`, which as
of today is the single source of truth for `equalsKey`, `hash` and `compareTo` alike:

- **primitives and `boolean`/`char`** — their bytes, in declaration order, fixed width
- **`String`** — length, then contents
- **nested `struct` / `record`** — recurse, in declaration order
- **pointers, arrays, references, nullable fields, class and enum references** — excluded, and already
  warned about at the declaration

Declaration order matters and is part of the contract: it is what makes the bytes stable across runs and
comparable at all. Reordering a class's fields changes its persistent keys, exactly as it changes its
layout.

## The constraint this imposes, stated plainly

**A class with a hand-written `equalsKey` cannot key a persistent.** The runtime compares bytes; it
cannot consult a method the program wrote. Rather than silently ignoring the hand-written version — which
would mean two different notions of "same" in one type, the disagreement this design exists to end — that
combination is a compile error:

> a persistent in `Session` cannot be keyed: this class declares its own `equalsKey`, and a persistent's
> key is compared as serialised bytes, which cannot call it. Either remove the hand-written `equalsKey`
> and let the key be generated from the value-typed fields, or drop `persistent` from this field.

If a hand-written `equalsKey` is genuinely needed *and* keyed persistence is genuinely needed, the answer
is a small value type holding exactly the identity, with the persistent declared on that.

## Release

Keying by value makes `release` mean something it could not mean before, and the two forms are both
needed:

```ldp3
release persistent s.hits;              // just this key's entry -- this session, this user
release persistent Session.hits all;    // every entry for the field -- shutdown, or a full reset
```

The existing compile-time obligation is satisfied by either. Without the second form a program could only
ever release the identities it still happened to be holding, which is not a release, it is a leak with
extra steps.

## Registry shape

The hosted registry grows; the freestanding one is fixed (a static slot table plus a static arena, no
allocator, panicking with the limit named — see `src/driver/build.cpp`). Both gain the same entry shape:

```
{ const char* classKey; u64 hash; u32 keyLen; const unsigned char* keyBytes; void* block; }
```

Lookup: hash the bytes, probe, and confirm with `keyLen` + `memcmp`. The `classKey` stays because two
different classes may produce identical key bytes and must not collide.

## Not doing

- **Cross-run persistence.** Persistents are in-process by definition (§5.9). Serialised keys make a
  file-backed variant *possible* later, but a durable store is a different feature with different
  failure modes, and inventing it here would be scope creep dressed as foresight.
- **Custom key serialisation hooks.** A program that wants control writes the value type it wants.
