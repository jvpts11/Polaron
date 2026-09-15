# DOES THE PASS DO ANYTHING? Compile the same program twice -- once with the §11 pipeline whole,
# once with one pass named out of it -- and assert the difference.
#
# Every other IR test here asks whether a needle is in the output. That answers "is this emitted",
# which is not the same question as "did this pass emit it": a needle can be there because some
# other part of the compiler happened to produce it, and then the pass can be deleted outright and
# the test still passes. `POLARON_PIR_PASSES=<list>` exists to close that gap -- it runs only the
# named passes -- and it was written for exactly this and then not used by anything.
#
# So the assertion is a DIFFERENCE, and a difference cannot be satisfied by accident:
#
#   with the pass   -- the needle must be there
#   without it      -- the needle must NOT be there
#
# Both halves matter. The first alone is the weak test above. The SECOND alone would pass for a
# compiler that never emits the needle at all -- and the pair is what says this pass, and no other
# part of the pipeline, is what produces it. That is Wave 3's exit criterion for §11 stated as a
# thing a machine checks: for every pass, a test that FAILS when that pass is turned off.
#
# ASSERTED ON PIR, NOT ON LLVM IR, and that is not a stylistic choice. A §11 pass edits the graph,
# and between the graph and the .ll sits the backend, which does some of the same work by other
# means: `speculate` builds an inline cache around a vtable call, so a direct `call @Thermometer.
# reading` appears in the LLVM output whether or not §11.8 ran. Measured there, the difference this
# file exists to assert is not visible at all, and the test would pass with the pass deleted.
#
# So the output read is `--emit-pir`, which is the module as the pass left it.
#
# Required -D args: POLC, INPUT, NEEDLE, WITHOUT (the pass list to run when the pass is off),
# WORKDIR. Optional: POLARONFLAGS (semicolon-separated), ABSENT (a second needle that must appear
# only when the pass is OFF -- the thing the pass REMOVED).
include("${CMAKE_CURRENT_LIST_DIR}/pir_one_function.cmake")

string(MD5 _tag "${INPUT}|matters|${NEEDLE}|${WITHOUT}|${IN_FN}")
set(on "${WORKDIR}/pass_${_tag}_on.pir")
set(off "${WORKDIR}/pass_${_tag}_off.pir")

separate_arguments(_extra UNIX_COMMAND "${POLARONFLAGS}")

# THE WHOLE PIPELINE. No environment variable at all, which is the state every other test and every
# real build runs in -- so what this half checks is the compiler as it actually ships.
execute_process(COMMAND "${POLC}" ${_extra} "${INPUT}" "--emit-pir=${on}" -o "${on}.ll"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT} with the pipeline whole")
endif()

# ...AND THE SAME PROGRAM WITH THE PASS NAMED OUT. `WITHOUT` lists every OTHER pass by name, rather
# than there being a "disable" flag, because the two are not equivalent: a list is a positive
# statement of what ran, so a pass added later is off in this half until somebody adds it -- and a
# test that silently starts running a new pass is a test whose difference is no longer the one it
# claims to measure.
execute_process(COMMAND "${CMAKE_COMMAND}" -E env "POLARON_PIR_PASSES=${WITHOUT}"
                        "${POLC}" ${_extra} "${INPUT}" "--emit-pir=${off}" -o "${off}.ll"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT} with POLARON_PIR_PASSES=${WITHOUT}")
endif()

if(NOT EXISTS "${on}" OR NOT EXISTS "${off}")
    message(FATAL_ERROR "polc reported success but did not write both outputs")
endif()

file(READ "${on}" _with)
file(READ "${off}" _without)

# ONE METHOD, when the claim is about one method. A whole-module search cannot tell "this allocation
# moved" from "some other allocation somewhere did not", and §11.5's tests are precisely a pair of
# methods that must be decided DIFFERENTLY in the same program -- one moved to the frame, one left on
# the heap. Searching the file for `[heap]` finds the second and says nothing about the first.
if(DEFINED IN_FN AND NOT IN_FN STREQUAL "")
    _narrow("${_with}" "${IN_FN}" "${on}" _with)
    _narrow("${_without}" "${IN_FN}" "${off}" _without)
endif()

# A PASS MAY HAVE NOTHING TO PUT IN. §11.8 replaces a `vtable.load` with a `call`, so there is a
# needle. §11.5 removes the word `[heap]` from an instruction and puts nothing at all: its entire
# effect is an absence, and demanding a needle for it would mean inventing one. So `NEEDLE` is
# optional -- but at least one of the two halves must be named, or the file asserts nothing and says
# so rather than passing.
if((NOT DEFINED NEEDLE OR NEEDLE STREQUAL "") AND (NOT DEFINED ABSENT OR ABSENT STREQUAL ""))
    message(FATAL_ERROR "run_pass_matters_test needs a NEEDLE, an ABSENT, or both")
endif()

if(DEFINED NEEDLE AND NOT NEEDLE STREQUAL "")
    string(FIND "${_with}" "${NEEDLE}" _a)
    if(_a EQUAL -1)
        message(FATAL_ERROR
            "the pass did not produce '${NEEDLE}'\n  input: ${INPUT}\n  ir:    ${on}")
    endif()

    string(FIND "${_without}" "${NEEDLE}" _b)
    if(NOT _b EQUAL -1)
        message(FATAL_ERROR
            "'${NEEDLE}' is emitted even with the pass turned off, so this test does not measure "
            "the pass -- something else in the pipeline produces it\n  input: ${INPUT}\n  ir:    ${off}")
    endif()
endif()

# ...AND WHAT THE PASS TOOK AWAY, when the test names it. The needle above says the pass produced
# something; this says the thing it replaced is gone. A pass that emits the fast path and leaves the
# slow one standing beside it has done half a job, and the half it did is the half that shows up in
# a presence test.
if(DEFINED ABSENT AND NOT ABSENT STREQUAL "")
    string(FIND "${_with}" "${ABSENT}" _c)
    if(NOT _c EQUAL -1)
        message(FATAL_ERROR
            "the pass ran but left '${ABSENT}' behind\n  input: ${INPUT}\n  ir:    ${on}")
    endif()
    string(FIND "${_without}" "${ABSENT}" _d)
    if(_d EQUAL -1)
        message(FATAL_ERROR
            "'${ABSENT}' is missing even with the pass turned off, so it is not what the pass "
            "removes\n  input: ${INPUT}\n  ir:    ${off}")
    endif()
endif()

message(STATUS "OK: '${NEEDLE}' appears only when the pass runs")
