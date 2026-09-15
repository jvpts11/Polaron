# Compile an .pol and assert PIR -- the module as the §11 passes left it -- contains a needle.
#
# The counterpart of `run_ir_contains_test`, one level up. What each is for: the LLVM output says
# what the machine will run, and PIR says what the passes DECIDED. They are not interchangeable,
# because the backend does some of the same work by other means -- an inline cache around a vtable
# call puts a direct call in the .ll whether or not §11.8 collapsed anything -- so a claim about a
# pass measured on the .ll is a claim about the two of them together.
#
# It matters most for the REFUSALS. `pir_devirt_leaves_two_implementations_alone` asserts that a
# dispatch with two possible answers stays a dispatch, and there is nowhere else that can be asked:
# in the .ll it is an inline cache either way, and in the program's output it is the right answer
# either way, right up until the day it is not.
#
# Required -D args: POLC, INPUT, NEEDLE, WORKDIR. Optional: POLARONFLAGS (semicolon-separated),
# IN_FN (narrow the search to one function's body -- see pir_one_function.cmake).
include("${CMAKE_CURRENT_LIST_DIR}/pir_one_function.cmake")

string(MD5 _tag "${INPUT}|pir|${NEEDLE}|${IN_FN}")
set(pir "${WORKDIR}/pir_${_tag}.pir")

separate_arguments(_extra UNIX_COMMAND "${POLARONFLAGS}")
execute_process(COMMAND "${POLC}" ${_extra} "${INPUT}" "--emit-pir=${pir}" -o "${pir}.ll"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${pir}")
    message(FATAL_ERROR "polc reported success but wrote no PIR to ${pir}")
endif()

file(READ "${pir}" _text)
if(DEFINED IN_FN AND NOT IN_FN STREQUAL "")
    _narrow("${_text}" "${IN_FN}" "${pir}" _text)
endif()
string(FIND "${_text}" "${NEEDLE}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the emitted PIR does not contain '${NEEDLE}'\n  input: ${INPUT}\n  pir:   ${pir}")
endif()
message(STATUS "OK: PIR contains '${NEEDLE}'")
