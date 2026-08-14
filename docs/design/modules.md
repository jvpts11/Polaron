# C++20 modules in the compiler

`src/driver/semver.cppm` is the worked example. Everything here was measured on this machine against
MSVC 14.51 and the WSL g++ 15 that builds the POSIX branch; none of it is quoted from the standard.

## What a module removes, and what it does not

Of the 522 `#include`s in `src/`:

| | count | verdict |
|---|---|---|
| `#include "..."` (ours) | 178 | **removable** — each becomes an `import` |
| `#pragma once` | 44 | **removable** — modules are not textually included |
| `#include <...>` (std) | ~300 | stays, confined to a global module fragment |
| `#include <llvm/...>` | ~44 | stays; LLVM is not modularised, and see the C1116 rule below |

The win is not the count. It is that a global module fragment's includes **do not reach the importer**:
a consumer that wants `std::string` says so itself instead of inheriting it from whatever it included.
`tests/unit/test_semver.cpp` needed `#include <string>` added for exactly this reason -- that was the
model working, not failing.

## The three rules, each measured

**1. Includes first, imports after.** In any translation unit that has both:

```cpp
#include "driver/sources.h"
#include <sstream>

import polaron.driver.semver;      // AFTER, always
```

The other order fails. `import` before `#include <llvm/IR/Module.h>` gives
`error C2572: 'std::_Sign_base': redefinition of default argument` from inside `<type_traits>` --
the standard library arriving twice, once as a module and once textually.

**2. A module's global module fragment may include the standard library, and nothing else.** Proven:
a module whose fragment holds only std headers, exporting
`std::map<std::string, std::unique_ptr<Node>>`, imported by a translation unit that includes
`Module.h`, `LLVMContext.h` and `IRBuilder.h` -- compiles.

**3. LLVM headers may never enter a module's global module fragment.** Put one there, and any importer
that also includes LLVM textually crashes the compiler:

```
fatal error C1116: unrecoverable error importing module 'polaron.b'.
Specialization of 'llvm::GlobalAlias::Op' with arguments '0'
note: IFC import detected. ... instructions for providing a repro for modules
```

An A/B pins it down: the same module imported by a consumer that does *not* include LLVM is fine, so
the fault is the two copies of LLVM's declarations meeting -- textual here, serialised in the IFC
there -- not the headers themselves. Each of `raw_ostream.h`, `StringRef.h`, `DenseMap.h`,
`LLVMContext.h`, `Type.h`, `Constants.h`, `Module.h` and `IRBuilder.h` passes on its own.

This is why `src/codegen/codegen_impl.h` stays a header. It is the only one of the 44 that includes
LLVM (25 of them), and it is a private implementation header included by the nine `codegen/*.cpp`
files -- it was never an interface. `src/cli/main.cpp` is the only other file that touches LLVM
directly. The LLVM island is those eleven files; the other 87 are free of it.

## The shape

An interface unit, replacing a header:

```cpp
module;

#include <optional>
#include <string>

export module polaron.driver.semver;

export namespace polaron::driver {
// ...declarations, unchanged...
}
```

Its implementation unit. `module X;` implicitly imports the interface, but **not** the interface's
fragment includes -- it states its own:

```cpp
module;

#include <cctype>
#include <string>

module polaron.driver.semver;

namespace polaron::driver {
// ...definitions, unchanged...
}
```

And the build. `FILE_SET CXX_MODULES` is what makes CMake scan and order these; listed as a plain
source, a `.cppm` compiles as an ordinary translation unit and the import fails with no useful
message:

```cmake
target_sources(polaron_driver PUBLIC FILE_SET CXX_MODULES FILES
    src/driver/semver.cppm)
```

`PUBLIC`, not `PRIVATE`, when the unit tests import it too.

## Naming

`polaron.<directory>.<file>` — `src/driver/semver.cppm` is `polaron.driver.semver`. The module name is
the include path that is no longer written.

## Both compilers

MSVC 14.51 via the Visual Studio generator, and g++ 15.2 in WSL with `-fmodules-ts`, each compile,
link and run a module interface plus a consumer. The POSIX branch is not left behind by this.

## Not done

43 of the 44 headers are convertible by the recipe above and have not been converted. The dependency
graph is shallow (maximum depth 4, no cycles); `parser/ast.h` is the most depended-upon at 19 files,
so it and `lexer/token.h` under it are the ones whose conversion drags the most with them -- a header
cannot `import`, so converting one forces every header that includes it to convert in the same step.
