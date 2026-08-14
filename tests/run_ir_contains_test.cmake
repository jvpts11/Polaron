# Compile an .pol to LLVM IR and assert the IR CONTAINS a needle, invoked via `cmake -P`.
#
# For properties that live in the generated code rather than in the program's output. A behaviour test
# says "the program printed the right thing"; this says "the compiler emitted the thing that makes it
# possible" -- which is what you want when the failure mode is a silent omission that turns into a hang or
# a wrong answer far from its cause.
#
# Required -D args: POLC, INPUT, NEEDLE, WORKDIR.  Optional: TARGET (a triple).
#
# TARGET exists because some emitted code is architecture-specific and cannot be checked by running it
# here: a Linux syscall sequence, an ARM instruction selection. Compiling for another target and
# reading the IR is the only verification available on this machine, and it is a real one -- it is how
# the port work checks that a target emits what it should rather than merely that it compiles.
string(MD5 _tag "${INPUT}|${NEEDLE}|${TARGET}")
set(ll "${WORKDIR}/ir_${_tag}.ll")

set(_targetArg)
if(TARGET_TRIPLE)
    set(_targetArg "--target=${TARGET_TRIPLE}")
endif()
execute_process(COMMAND "${POLC}" "${INPUT}" ${_targetArg} -o "${ll}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${ll}")
    message(FATAL_ERROR "polc reported success but wrote no IR to ${ll}")
endif()

file(READ "${ll}" _ir)
string(FIND "${_ir}" "${NEEDLE}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the emitted IR does not contain '${NEEDLE}'\n  input: ${INPUT}\n  ir:    ${ll}")
endif()
message(STATUS "OK: IR contains '${NEEDLE}'")
