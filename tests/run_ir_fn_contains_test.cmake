# Compile a .pol to LLVM IR and assert that ONE NAMED FUNCTION's body contains a needle.
#
# run_ir_contains_test.cmake searches the whole module, which is the wrong question whenever the needle
# also appears somewhere it was never missing. The case this was written for: `llvm.assume` was emitted
# for every invariant, but only into the methods that WRITE fields -- a module-wide grep passes while
# the read-only method the optimisation exists for has none. Scope is the assertion.
#
# Required -D args: POLC, INPUT, FUNCTION, NEEDLE, WORKDIR.  Optional: ABSENT (assert it is NOT there).

string(MD5 _tag "${INPUT}|${FUNCTION}|${NEEDLE}")
set(ll "${WORKDIR}/irfn_${_tag}.ll")

execute_process(COMMAND "${POLC}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${ll}")
    message(FATAL_ERROR "polc reported success but wrote no IR to ${ll}")
endif()

file(READ "${ll}" _ir)

# A function body runs from its `define ... @<name>(` to the first line that is exactly `}`. Matching
# the closing brace at the start of a line is what keeps this from stopping inside a nested brace.
string(REGEX MATCH "\ndefine[^\n]*@\"?${FUNCTION}\"?\\([^\n]*\n(.*)" _rest "${_ir}")
if(_rest STREQUAL "")
    message(FATAL_ERROR "the emitted IR has no function '${FUNCTION}'\n  input: ${INPUT}\n  ir:    ${ll}")
endif()
set(_body "${CMAKE_MATCH_1}")
string(FIND "${_body}" "\n}" _end)
if(NOT _end EQUAL -1)
    string(SUBSTRING "${_body}" 0 ${_end} _body)
endif()

string(FIND "${_body}" "${NEEDLE}" _found)
if(ABSENT)
    if(NOT _found EQUAL -1)
        message(FATAL_ERROR "'${FUNCTION}' contains '${NEEDLE}' and must not\n  ir: ${ll}")
    endif()
    message(STATUS "OK: '${FUNCTION}' does not contain '${NEEDLE}'")
else()
    if(_found EQUAL -1)
        message(FATAL_ERROR
            "'${FUNCTION}' does not contain '${NEEDLE}'\n  input: ${INPUT}\n  ir:    ${ll}")
    endif()
    message(STATUS "OK: '${FUNCTION}' contains '${NEEDLE}'")
endif()
