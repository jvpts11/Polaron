# Toolchain Sub-project 2 (pending) — version ranges, transitive deps, plug-all, lockfile

Status: design (2026-07-04), implemented autonomously while João was at work. Closes the deferred items of
sub-project 2 before moving to sub-project 3. Built on the existing `ldp3` driver dependency layer.

## Decisions

- **No default GitHub org** (reversible): a bare package name still requires a `~/.ldp3/sources.toml` mapping
  or a full URL. Hardcoding an org now would bake in an ecosystem home that may be wrong once a real registry
  exists; adding one later is trivial. (João asked to be consulted; chose the safe default in his absence.)
- **In scope:** semver version ranges, `ldp3 plug` with no arguments (install every manifest dependency),
  transitive dependencies (plugging X installs and links X's own dependencies), and a lockfile.
- **Deferred:** `plug --update`, `plug --global`.

## Version ranges

The manifest's dependency versions follow spec 38.4: exact (`1.2.0`), caret (`^3.1.0` → >=3.1.0 <4.0.0),
tilde (`~1.5.2` → >=1.5.2 <1.6.0), minimum (`>=2.0.0`), or empty (the default branch). Caret on a 0.x version
narrows to the minor (`^0.2.3` → >=0.2.3 <0.3.0), matching npm.

Resolution when a range (anything but an exact tag or empty) is requested:
1. `git ls-remote --tags <url>` lists the remote tags without cloning (works offline for local repos).
2. Tags are parsed as semver (an optional leading `v` is stripped); non-semver tags are ignored.
3. The highest tag satisfying the range is selected and cloned. No match is a clear error.

An exact version clones that tag directly (today's behaviour); an empty version clones the default branch.

A small C++ semver type (`major.minor.patch`) with parse + compare + range-satisfies lives in
`src/driver/semver.{h,cpp}` and is unit-tested.

## Transitive dependencies

Plugging a package also installs its own dependencies. After cloning a package, its `ldp3.toml`
`[dependencies]` are resolved and plugged into the **same** target `packages/` (flat), guarded by a visited
set so cycles terminate. Only the directly requested package is recorded in the consumer's manifest;
transitive packages are recorded only in the lockfile.

The build computes the transitive closure: starting from the manifest's direct dependencies, it walks each
installed package's own `ldp3.toml` to gather every `.ldb` in the closure, then `--use`es each for the
compile and links every extracted object. The environment closure is resolved the same way within the
environment's `packages/`. A `collectClosure(packagesDir, directNames)` helper does the walk for both.

## `ldp3 plug` with no arguments

Installs every dependency listed in the project's manifest (and, transitively, their dependencies) into
`packages/`, skipping any already present. This is how a freshly cloned project (which ships its manifest but
gitignores `packages/`) is set up. If a lockfile is present, the exact locked versions are installed;
otherwise the manifest's ranges are resolved to the latest match and the lockfile is written.

## Lockfile

`ldp3.lock` next to the manifest records the exact resolved version of every installed package (direct and
transitive), one `name = "version"` line under a `[locked]` header. It is written whenever plugging resolves
versions, and read by `ldp3 plug` (no args) to reproduce an install exactly. A single package `plug <x>`
updates that package's line. `unplug` drops it.

## Components

- `src/driver/semver.{h,cpp}` (new) — semver parse, compare, and range-satisfies.
- `src/driver/lockfile.{h,cpp}` (new) — read/write `ldp3.lock`.
- `src/driver/git.{h,cpp}` (extend) — `gitListTags(url)` over `git ls-remote --tags`.
- `src/driver/deps.{h,cpp}` (extend) — range resolution, transitive recursion, `plugAll`, lockfile updates.
- `src/driver/build.{h,cpp}` (extend) — transitive closure resolution.
- `src/driver/ldp3_main.cpp` (extend) — `plug` with no args.

## Error handling

- A range with no matching tag → error listing what the range was.
- `git ls-remote` failure → error (network/URL).
- A dependency cycle → terminates via the visited set (no error; each package installed once).
- `plug` (no args) with no manifest → the existing "no ldp3.toml" error.

## Testing (hermetic, local git fixtures)

- Unit (doctest): semver parse/compare, range-satisfies across caret/tilde/min/exact; lockfile read/write.
- Integration: a local repo with multiple tags, plugged with `^1.0.0`, resolves to the highest 1.x tag; a
  library that itself depends on another (transitive) builds a consumer that links both; a manifest with a
  dependency, `ldp3 plug` (no args) installs it and writes `ldp3.lock`.

## Out of scope

`plug --update`, `plug --global`, a default GitHub org, non-semver version schemes, and registry hosting.
