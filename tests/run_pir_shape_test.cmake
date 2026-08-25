# THE SHAPE GATE: every difference between the two backends is one somebody has looked at.
#
# `--compare-ir` compares the two modules body by body. It existed before this and gated nothing,
# because a census over all 874 samples reported 9 402 differences and NOT ONE program in full
# agreement -- a report nobody can act on. Five memory defects walked past it while it was already
# built, and a sixth (a bare `Object` with no vtable pointer, an access violation) was found the
# moment the report became readable.
#
# Two of the classes are now answered inside the comparison itself -- promotion, and skipping the
# synthesised entry wrapper; see src/pir/shapediff.h. The rest are classified in
# tests/pir_shape_baseline.md, and this file is that classification made executable:
#
#   * a difference matching a known class passes, and the class is named in the log;
#   * ANYTHING ELSE FAILS.
#
# The gate is deliberately NOT "how many differ". A count lets a new defect hide on the day an old
# one is fixed. It is "what KIND", and a kind nobody has seen before stops the build.
#
# Required: POLC, SAMPLES (the directory), LIMIT.
file(GLOB samples "${SAMPLES}/*.pol")
list(SORT samples)
# EVERY Nth, NOT THE FIRST N -- the same reason run_pir_batch_test.cmake gives: the head of a sorted
# list is every file beginning with `a` or `b`, and closing whatever the head happens to exercise is
# not the same as closing the lowering.
list(LENGTH samples total)
math(EXPR stride "(${total} + ${LIMIT} - 1) / ${LIMIT}")
if(stride LESS 1)
    set(stride 1)
endif()
set(picked "")
set(at 0)
foreach(f ${samples})
    math(EXPR pick "${at} % ${stride}")
    if(pick EQUAL 0)
        list(APPEND picked "${f}")
    endif()
    math(EXPR at "${at} + 1")
endforeach()
set(samples ${picked})
list(LENGTH samples n)
message(STATUS "pir shape: ${n} of ${total} samples, every ${stride}th")

# The classes of tests/pir_shape_baseline.md, as patterns. Each is a difference somebody has looked
# at and written down; the label is what the log prints, so a failure says which class it is NOT.
set(known
    # R -- a value variant is unpacked ONCE PER ARM. §21's `{ tag, payload }` is two registers, and
    # PIR asks for each piece where the arm needs it: `case Ok(int a)` extracts the tag to test and
    # the payload to bind, and the next arm does the same. The other path extracts both once at the
    # top of the `match` and reuses them, so `extractvalue` doubles and the block count differs with
    # it -- the `unreachable` is the join no arm falls through to when every one of them returns.
    #
    # Same answers, more instructions, and the redundancy is exactly what a common-subexpression
    # pass removes: `value_try` agrees on output and on live bytes. Not correctness, therefore not
    # this wave.
    "R:extractvalue [0-9]+->[0-9]+"
    # C -- checked arithmetic. PIR emits the overflow intrinsic where the trusted path open-codes the
    # test, so the intrinsic appears on one side and `icmp`/`zext`/`__polaron_fail` vanish from the
    # other. A §12 hand-off row landing: the difference the migration exists to produce.
    "C:llvm[.](sadd|ssub|smul|uadd|usub|umul)[.]with[.]overflow"
    "C:__polaron_fail [0-9]+->[0-9]+"
    "C: (icmp|zext) [0-9]+->[0-9]+"
    # C, second half -- GUARD ELIMINATION. §11.3 runs on the PIR path and has no counterpart on the
    # trusted one, so a redundant check and the throw behind it are gone: `adler32` divides twice by
    # the same constant and PIR keeps one DivideByZeroException where the trusted path emits two.
    # The compile line says it out loud (`guards-removed=169`). The direction is always downward;
    # PIR emitting MORE throws than the trusted path would not be this.
    "C:(DivideByZero|Arithmetic|IndexOutOfRange|NullReference)[A-Za-z]*Exception[A-Za-z.$]* [0-9]+->[0-9]+"
    "C:_CxxThrowException [0-9]+->[0-9]+"
    # I -- an arithmetic idiom. PIR uses `select` where the trusted path uses a shift-and-mask
    # (`ashr 2->1, select 0->1` in colour packing). Same value, different instruction choice.
    "I: (ashr|lshr|shl|select|or|xor) [0-9]+->[0-9]+"
    # E -- index and bounds lowering. PIR computes an element address with adds where the trusted
    # path uses a getelementptr, and carries one more block. Seen in `ArrayList.get`/`.set` and
    # `HashMap.getOrDefault` -- the checked-index path. NOT confirmed to be that and no more; it is
    # classified as "looked at, and this is what it is a difference IN".
    "E: add [0-9]+->[0-9]+,  br [0-9]+->[0-9]+,  getelementptr"
    # D1 -- String field ownership: PIR implements neither half of the copy/free protocol. Both
    # halves, because the copy and the free appear in different functions.
    "D1:__polaron_str_copy [0-9]+->[0-9]+"
    "D1:__polaron_str_free [0-9]+->[0-9]+"
    # D2 -- the value form of Result/Option put on the heap by PIR. The name class needs `~` in it:
    # an `ArrayList<int[]>` mangles its Option as `None$int~arr`, and without the tilde three lines
    # of the corpus fell through to unclassified while being exactly this defect.
    "D2:(Ok|Err|Some|None)[$][A-Za-z0-9_$~]* 0->1"
    # D3 -- an LLVM memory intrinsic becomes a library call. The intrinsic is something LLVM reasons
    # about and can lower to inline moves; the call is opaque to it, and on a freestanding target it
    # needs a symbol that may not exist.
    "D3:llvm[.]mem(cpy|set|move)"
    "D3:calls mem(cpy|set|move) [0-9]+->[0-9]+"
    # D4 -- PIR emits fewer assumes.
    "D4:llvm[.]assume"
    # D5 -- the `Object` vtable pointer is never written. In `Object.Object` that is the whole body
    # (1->0); in every derived constructor it is one store of two (2->1), because the trusted path
    # writes the root's pointer and then the class's own and PIR writes only its own. An access
    # violation on a bare `Object`, not a number -- see samples/bare_object_dispatch.pol.
    "D5:getelementptr [0-9]+->[0-9]+,  store [0-9]+->[0-9]+"
    # D6 -- a destructor that does not free. `ArrayList$X.~ArrayList$X` calls `__polaron_free` on the
    # trusted path and not on the PIR one: the field-array leak the anti-procedural ledger already
    # carries (AP-15), here with its reach measured.
    "D6:__polaron_free [0-9]+->[0-9]+"
    "D6:__polaron_check_live [0-9]+->[0-9]+"
    # D7 -- an atomic read-modify-write becomes a load, an add and a store. The `abstainfrom`
    # counter: trusted emits `atomicrmw add ... seq_cst` and an atomic load; PIR emits plain ones.
    # Two threads abstaining lose updates, and on bare metal -- where AP-14 already noted the
    # counter is global by necessity and "mutable state anything that preempts the method also
    # touches" -- an interrupt between the load and the store loses one.
    "D7:atomicrmw [0-9]+->0"
    # D8 -- the null-receiver check is not emitted. The trusted path guards a dispatch with
    # `icmp eq ptr %recv, null` -> `__polaron_panic("null reference dereference")` -> `unreachable`,
    # naming the file and line. PIR emits NONE anywhere: two samples measured, trusted 2 and 2, PIR
    # 0 and 0. Not one guard eliminated -- the check is absent. A raw null dereference traps on a
    # hosted target, so the loss is the diagnostic; on bare metal with no MMU it is the language's
    # own no-UB rule, which says a null dereference is a named panic and not a fault.
    "D8:__polaron_panic [0-9]+->[0-9]+"
    # D9 -- RAII does not run when an exception unwinds. In `Main.objCase` the trusted path calls
    # `Guard.~Guard` TWICE: once in `dtor.live` (the normal exit) and once in `rethrow`, as
    # `call void @"Guard.~Guard"(ptr %6) [ "funclet"(token %5) ]` -- the Windows SEH cleanup path.
    # PIR calls it once, on the normal exit only. Every stack object with a destructor, every
    # `defer` and every `using` is skipped when a throw passes through the scope.
    "D9:[A-Za-z0-9_$~.]+[.]~[A-Za-z0-9_$~]+ [0-9]+->[0-9]+"
    # D10 -- a NON-CAPTURING lambda gets a heap closure instead of a static one. The trusted path
    # stores `@__polaron_closure`, a global, into the field and allocates nothing; PIR calls
    # `__polaron_malloc(16)` per construction and fills it with the lambda pointer and a null
    # capture. A lambda with no captures has no state, so the global is both correct and free.
    "D10:__polaron_malloc 0->1"
    # D11 -- `await` blocks instead of suspending. The trusted path calls `__polaron_await`, which
    # registers a continuation and returns 1 so the state machine RETURNS from its resume function
    # and frees the worker. PIR calls `__polaron_task_wait`, which is
    # `SleepConditionVariableCS(...)` until the task is done -- it holds the thread. With a bounded
    # pool, tasks waiting on tasks that need a worker is the classic pool deadlock, and suspension
    # is exactly what avoids it. F8 is recorded as "a real state machine with suspension".
    "D11:__polaron_(await|task_result|task_wait) [0-9]+->[0-9]+"
    # D13 -- objects living in a region never have their destructors run. `__polaron_region_teardown`
    # walks the region's track table and calls each live object's destructor before freeing the
    # table; PIR omits the call in `~LinkedList$int`, `~app__Pool`, `~Kennel` and `Pool$Node.
    # releaseAll`, and omits `__polaron_region_track` at the other end so nothing is registered to
    # destruct in the first place. D9 at region scope.
    #
    # `POLARON_LIVE` cannot see it: a region's memory comes from the arena, not the heap, so the
    # live-block totals of both paths match. What is lost is destructors, not bytes.
    "D13:__polaron_region_(teardown|track) [0-9]+->0"
    # P -- region-class lowering reaches the arena primitives directly. `__polaron_arena_alloc`,
    # `_base` and `_reserve` appear on the PIR side where the trusted path did not call them, and
    # `__polaron_region_init` and the literal-suffix helper disappear from it. The same family as F,
    # arriving as calls rather than as arithmetic.
    "P:__polaron_arena_(alloc|base|reserve) [0-9]+->[0-9]+"
    "P:__polaron_region_init [0-9]+->[0-9]+"
    "P:literal[.][A-Za-z0-9_$.]+ [0-9]+->[0-9]+"
    "P:ByteSize[.][A-Za-z0-9_$]+ [0-9]+->[0-9]+"
    # C, third half -- `strcmp` becomes `__polaron_str_eq`, and PIR is right. The runtime says why:
    # str_eq is length-aware, and "the data buffer need not be NUL-terminated, so this is correct
    # where strcmp is not".
    "C:__polaron_str_eq [0-9]+->[0-9]+"
    "C:calls strcmp [0-9]+->[0-9]+"
    # Q -- a constructor symbol is qualified on one path and bare on the other:
    # `Main.App.Scanner.Main.App.Scanner 0->1` against `Main.App.Scanner.Scanner 1->0`. The same
    # family as the anti-procedural ledger's cross-bundle constructor-symbol row, inside one module.
    # Each path defines and calls its own form.
    "Q:calls [A-Za-z0-9_$.]+[.][A-Za-z0-9_$]+[.][A-Za-z0-9_$.]+ [0-9]+->[0-9]+"
    # D12 -- a Java-style enum constant is re-constructed at every reference. The trusted path
    # treats it as a lazily-initialised singleton -- load `@Grade.ok.__inst`, construct once into
    # `@Grade.ok.__store`, remember it -- and calls the constructor three times for three constants.
    # PIR calls it twelve.
    #
    # D12 has no pattern here: it needs "the mangled name repeats the class", and CMake's regex has
    # no backreferences (measured -- `calls ([A-Za-z0-9_$]+)[.]\\1` does not match `Grade.Grade`).
    # Matching `calls <anything> N->M` instead would swallow every real defect that arrives as a
    # call count, so the check is done in code below rather than loosened into a catch-all.
    # K -- a block count that differs with nothing else to say. The comparator reports calls first,
    # then opcodes, then blocks, so a lone `br` or `blocks` line means the two agree about every
    # call and every other opcode and differ by a basic block -- an extra empty merge or landing
    # block. Named rather than ignored: a branch that vanished would show as calls or opcodes too.
    "K: br [0-9]+->[0-9]+"
    "K:blocks [0-9]+->[0-9]+"
    # L -- the `finally` body is duplicated across a different number of exit edges. `printf 4->5`
    # in one sample and `3->2` in another, and BOTH PROGRAMS PRINT THE SAME THING -- verified by
    # running them, not inferred. The difference is how many static call sites the body has, and
    # each path still runs it once.
    #
    # A `printf` count is broad enough to hide a genuine output change, and it is classified here
    # anyway for a reason that has to hold: output IS compared, by `pir_batch_agreement` over 120
    # samples and by `run_pir_behaviour_test`. A shape gate is not the instrument for what a program
    # prints, and pretending it is would make both weaker.
    "L:calls printf [0-9]+->[0-9]+"
    # N -- `foreach` over an `Iterable` without the protocol: PIR does not call `iterator()` or
    # `hasNext()`. Same output, and the live totals differ by exactly the D1 baseline -- so it costs
    # and saves nothing here.
    #
    # CANDIDATE, not benign: the corpus's only Iterable is `ArrayList`, whose iteration a compiler
    # may know. A USER type implementing `Iterator` with a `next()` that does anything would be
    # bypassed by the same lowering, and no sample would notice. Wave 1 owes a sample with a custom
    # iterator.
    "N:[.](iterator|hasNext|next)[A-Za-z0-9_$]* [0-9]+->0"
    # O -- a generator's coroutine helpers are qualified by the owning class on one path and bare on
    # the other: `Sequences$evens$Gen.Sequences$evens$current 0->1` against
    # `Sequences$evens$current 1->0`. Each path defines AND calls its own form -- PIR does not emit
    # the bare symbol at all -- and both `free` bodies call `__polaron_free`, so it is a name and not
    # a missing function. Output verified identical by running it.
    #
    # The qualified form is the one the shared-name fix established: a bare `nextWord` was one symbol
    # for two classes, and the key made it unique.
    "O:[$](current|resume|free|pump)[A-Za-z0-9_$]* [0-9]+->[0-9]+"
    # J -- SPECULATIVE DEVIRTUALISATION, and PIR is the one doing it. Where the trusted path loads a
    # vtable slot and calls indirectly, PIR compares the loaded pointer against a known target
    # (`icmp eq ptr %vfn, @"Some$int.isSome"`) and calls it directly when it matches. Both possible
    # targets therefore appear as direct calls that the trusted module does not contain.
    "J:(isSome|isOk|isNone|isErr) 0->1"
    # F -- address arithmetic. In region and arena code (`SlotMap`, `UnionFind`, `IntHeap`) PIR
    # computes an element address with `add`/`mul`/`and` where the trusted path uses a
    # getelementptr. Semantically the same address by inspection; classified as looked-at, and it is
    # the family §11.7's region binding will move onto the graph anyway.
    "F: (add|and|mul|ptrtoint|inttoptr) [0-9]+->[0-9]+"
    "F: getelementptr [0-9]+->[0-9]+"
    # H -- how a string literal reaches a call. The trusted path hands `printf` a raw C-string
    # global; PIR emits a `String` object and loads its `data` field out of it
    # (`getelementptr (i8, ptr @.strobj, i64 8)` -- offset 8 is `data` in `PolaronStr{len,data,hash}`).
    # The same pointer arrives either way, and the two loads are of a constant.
    "H: load [0-9]+->[0-9]+"
    "H: trunc [0-9]+->[0-9]+"
)

set(unknown "")
set(seenClasses "")
set(lineCount 0)
foreach(src ${samples})
    execute_process(COMMAND "${POLC}" --compare-ir "${src}" -o "${WORKDIR}/shape_probe.ll"
                    ERROR_VARIABLE report OUTPUT_QUIET RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        continue()   # a sample that does not compile is not this test's business
    endif()
    string(REPLACE "\n" ";" lines "${report}")
    foreach(line ${lines})
        # A difference line is `  <symbol>: <what>` -- two spaces, a mangled name (which may carry
        # `$`, `.` and `~`), a colon, a space. Matching only `^  [A-Za-z_]` also caught the INDENTED
        # PROSE of the compiler's own diagnostics, which is how `stack_vm.pol: fac[20]=3` -- a line
        # out of a rich diagnostic's body -- arrived here as the last unclassified "difference" in
        # the corpus. The filter has to know the shape of what it is reading.
        if(NOT line MATCHES "^  [A-Za-z_][A-Za-z0-9_$.~]*: ")
            continue()   # the summary, and everything else the compiler says, are not differences
        endif()
        math(EXPR lineCount "${lineCount} + 1")
        set(matched "")
        # D12 first, and in code: a CONSTRUCTOR call (the mangled name repeats the class) whose
        # count went UP. CMake's regex cannot say "repeats", so the two halves are compared here.
        if(line MATCHES "calls ([A-Za-z0-9_$]+)[.]([A-Za-z0-9_$]+) ([0-9]+)->([0-9]+)")
            if(CMAKE_MATCH_1 STREQUAL CMAKE_MATCH_2 AND CMAKE_MATCH_4 GREATER CMAKE_MATCH_3)
                set(matched "D12")
            endif()
        endif()
        # M -- PIR allocating FEWER, which is a different fact from PIR allocating more and must not
        # share a class with it. `Fns.compose` is `__polaron_malloc 4->2`: two closures where the
        # trusted path builds four, same output, and a live total lower by exactly those two.
        #
        # Fewer allocations is never a memory defect on its own -- either it is better, or something
        # that should have been built was not, and THAT shows as wrong output, which the stdout
        # oracle catches. PIR allocating MORE stays D2/D10 and stays a defect. The direction is
        # compared here because a regex cannot.
        if(matched STREQUAL "" AND line MATCHES "calls __polaron_malloc ([0-9]+)->([0-9]+)")
            if(CMAKE_MATCH_1 GREATER CMAKE_MATCH_2)
                set(matched "M")
            endif()
        endif()
        # J -- speculative devirtualisation, in two shapes. An indirect call PIR no longer makes,
        # and the giveaway of a guarded devirt: TWO direct calls appearing whose METHOD names are the
        # same, one per candidate type (`ArrayListIterator$int.hasNext` beside `DoublingIterator.
        # hasNext`; `Surface.width` beside `Tile.width`). A regex cannot say "the same method twice",
        # so it is counted here.
        if(matched STREQUAL "" AND line MATCHES "calls <indirect> [0-9]+->0")
            set(matched "J")
        endif()
        if(matched STREQUAL "" AND line MATCHES "calls [A-Za-z0-9_$]+[.]([A-Za-z0-9_]+) 0->1")
            set(meth "${CMAKE_MATCH_1}")
            string(REGEX MATCHALL "[.]${meth} 0->1" jhits "${line}")
            list(LENGTH jhits jn)
            if(jn GREATER 1)
                set(matched "J")
            endif()
        endif()
        foreach(k ${known})
            if(NOT matched STREQUAL "")
                break()
            endif()
            string(FIND "${k}" ":" at)
            string(SUBSTRING "${k}" 0 ${at} cls)
            math(EXPR rest "${at} + 1")
            string(SUBSTRING "${k}" ${rest} -1 pat)
            if(line MATCHES "${pat}")
                set(matched "${cls}")
                break()
            endif()
        endforeach()
        # D14 -- a receiver expression is evaluated twice. `fieldOffCall()` is `return table().n;`
        # -- ONE call in the source -- and PIR emits `calls Holder.table 1->2`. There `table()`
        # returns `this` and the doubling is harmless; the rule is not. A receiver that allocated,
        # logged, advanced a cursor or was a generator's `next()` would run twice, and AP-26 is
        # exactly the objection that you cannot see what code runs.
        #
        # DEAD LAST, AFTER EVERY NAMED PATTERN, and that placement is not tidiness. It matches any
        # dotted call whose count went up, which is the shape of half the classes above: run early
        # it swallowed O (a generator helper's symbol) and Q (a constructor's), and reported both as
        # a defect -- which would send the fix hunting the wrong thing. The greediest rule goes last.
        if(matched STREQUAL "" AND line MATCHES "calls [A-Za-z0-9_$.]+[.][A-Za-z0-9_$]+ ([0-9]+)->([0-9]+)")
            if(CMAKE_MATCH_2 GREATER CMAKE_MATCH_1)
                set(matched "D14")
            endif()
        endif()
        if(matched STREQUAL "")
            get_filename_component(who "${src}" NAME)
            list(APPEND unknown "${who}:${line}")
        else()
            list(APPEND seenClasses "${matched}")
        endif()
    endforeach()
endforeach()

list(REMOVE_DUPLICATES seenClasses)
list(SORT seenClasses)
list(LENGTH unknown nUnknown)
list(JOIN seenClasses " " shownClasses)
message(STATUS "pir shape: ${lineCount} difference lines, classes seen: ${shownClasses}")

if(nUnknown GREATER 0)
    set(head ${unknown})
    if(nUnknown GREATER 8)
        list(SUBLIST head 0 8 head)
    endif()
    list(JOIN head "\n" shown)
    message(FATAL_ERROR
            "the two backends differ in a way nobody has classified (${nUnknown} lines):\n${shown}\n"
            "Every known difference is in tests/pir_shape_baseline.md. If this one is real it is a "
            "defect; if it is expected it goes in that file AND in the pattern list here -- but it "
            "does not go unlooked-at, which is how five memory defects walked past this comparison.")
endif()
