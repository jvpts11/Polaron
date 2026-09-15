# `parse(print(m))` PRINTS IDENTICALLY -- ON A REAL MODULE.
#
# This is PIR's own acceptance criterion (docs/design/polaron-ir.md §1.6), and until a `.polb` began
# carrying a module there was nothing that ran it on anything but a hand-written fixture. What that
# cost is worth writing down, because every one of these was invisible and none of them was subtle:
#
#   * the printer emitted NO `type` declarations at all, and the reader's branch for them SKIPPED
#     them -- on the reasoning that *the types are rebuilt from their uses*, which is true of a
#     structural type and false of the only kind that line ever sees. A module said
#     `gep ptr @level of %Mixer imm 1` and gave the reader no way to know what `%Mixer` holds, so
#     reading one back produced the right instructions over EMPTY structs and the first `gep` past
#     field zero walked off the end;
#   * `blocks_` was a module-wide map, so the second function's `^entry` resolved to the first
#     function's block -- which is why the smallest reproducer was two functions, each of which
#     parses perfectly alone;
#   * `%` is both a value and a nominal type, `[` both an array type and an extra, and a parameter
#     may be NAMED `ptr` -- three ambiguities that had been settled by guessing at the word;
#   * a float printed at six significant digits, so `2147483647.0` came back as 2147480000: a
#     constant silently changed by writing it down;
#   * a `fact.requires` carried its clause as several LINES inside one token, in a format whose
#     lines are its structure;
#   * and the block pre-scan, once written, did not run: `atEnd()` skips whitespace and does not put
#     the line counter back, so the `sameLine()` asked after it compares a token's line with itself
#     and answers yes forever. A fix that reads correct and never executes.
#
# THE TEST IS THE IDENTITY, NOT THE PARSE. A parse that succeeds and loses something is the worse
# failure of the two: it hands back a module that compiles and is not the one that was written down.
# That is what caught the block ordering, which parsed fine and put the blocks in the order they were
# MENTIONED -- and block order is not decoration, since the backend lays them out in it.

set(_pir "${WORKDIR}/roundtrip.pir")

execute_process(COMMAND "${POLC}" "${INPUT}" --lib "--emit-pir=${_pir}" -o "${WORKDIR}/roundtrip.polb"
                RESULT_VARIABLE _rc OUTPUT_QUIET ERROR_VARIABLE _err)
if(NOT _rc EQUAL 0)
    message(FATAL_ERROR "polc could not emit the module (exit ${_rc}):\n${_err}")
endif()

execute_process(COMMAND "${POLC}" --check-pir "${_pir}"
                RESULT_VARIABLE _crc OUTPUT_VARIABLE _out ERROR_VARIABLE _cerr)
if(NOT _crc EQUAL 0)
    message(FATAL_ERROR "the module does not survive its own text form:\n${_out}${_cerr}")
endif()
if(NOT _out MATCHES "round trip identical")
    message(FATAL_ERROR "expected `round trip identical`, got:\n${_out}")
endif()
message(STATUS "${_out}")
