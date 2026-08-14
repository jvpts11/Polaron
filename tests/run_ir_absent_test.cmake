# Compile an .pol to LLVM IR and assert the IR does NOT contain a needle, invoked via `cmake -P`.
#
# The dual of run_ir_contains_test. Presence tests catch a feature that stopped being emitted;
# this catches something that started being emitted and should not have been -- a hosted-runtime
# symbol reaching a bare-metal image, a guard that stopped guarding. That failure never shows up as
# a wrong answer: it shows up at LINK, in somebody else's kernel, naming a symbol they never wrote.
#
# Required -D args: POLC, INPUT, NEEDLE, WORKDIR. Optional: POLARONFLAGS (semicolon-separated).
string(MD5 _tag "${INPUT}|absent|${NEEDLE}")
set(ll "${WORKDIR}/ir_${_tag}.ll")

separate_arguments(_extra UNIX_COMMAND "${POLARONFLAGS}")
execute_process(COMMAND "${POLC}" ${_extra} "${INPUT}" -o "${ll}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${ll}")
    message(FATAL_ERROR "polc reported success but wrote no IR to ${ll}")
endif()

file(READ "${ll}" _ir)
string(FIND "${_ir}" "${NEEDLE}" _found)
if(NOT _found EQUAL -1)
    message(FATAL_ERROR "the emitted IR contains '${NEEDLE}', and must not\n  input: ${INPUT}\n  ir:    ${ll}")
endif()
message(STATUS "OK: IR does not contain '${NEEDLE}'")
