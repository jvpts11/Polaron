# Compile an .ldp3 to LLVM IR and assert the IR CONTAINS a needle, invoked via `cmake -P`.
#
# For properties that live in the generated code rather than in the program's output. A behaviour test
# says "the program printed the right thing"; this says "the compiler emitted the thing that makes it
# possible" -- which is what you want when the failure mode is a silent omission that turns into a hang or
# a wrong answer far from its cause.
#
# Required -D args: LDP3C, INPUT, NEEDLE, WORKDIR
string(MD5 _tag "${INPUT}|${NEEDLE}")
set(ll "${WORKDIR}/ir_${_tag}.ll")

execute_process(COMMAND "${LDP3C}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${ll}")
    message(FATAL_ERROR "ldp3c reported success but wrote no IR to ${ll}")
endif()

file(READ "${ll}" _ir)
string(FIND "${_ir}" "${NEEDLE}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the emitted IR does not contain '${NEEDLE}'\n  input: ${INPUT}\n  ir:    ${ll}")
endif()
message(STATUS "OK: IR contains '${NEEDLE}'")
