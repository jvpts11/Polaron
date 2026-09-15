# Stage 1: every sample lowers to PIR, and the module VERIFIES.
#
# The check is not "did it print something" -- it is that `pir::verify` found nothing to say about a
# module lowered from a real program. That is the property that makes the lowering trustworthy, and
# it is the one that would silently rot: a lowering can keep producing text long after it stopped
# producing a well-formed module.
#
# Gaps are allowed and expected at this stage -- they are the work queue, printed and counted. What
# is not allowed is a verifier rule firing.
# Two optional dials, for the shapes a plain compile of a program cannot reach:
#
#   LIB         compile as a library (`--lib`), which emits the WHOLE prelude rather than one
#               program's reachable set. It is the only way to reach `Test.assertDoesNotThrow`,
#               whose `try` around a call through a vtable carried a rule-19 complaint that no
#               program's own code could ever show.
#   REFUSAL_OK  the compilation is expected to FAIL -- `ffi_syscall` declares `extern syscall(...)`
#               on a target that has no syscall ABI. Refusing is the correct answer; complaining
#               about its own IR while refusing is not, and that is what this still reads.
set(_mode)
if(LIB)
    set(_mode --lib)
endif()
execute_process(COMMAND "${POLC}" ${_mode} "${INPUT}" --emit-pir=- -o "${OUT}"
                OUTPUT_VARIABLE pir ERROR_VARIABLE diags RESULT_VARIABLE rc)
if(NOT rc EQUAL 0 AND NOT REFUSAL_OK)
    message(FATAL_ERROR "polc failed on ${INPUT}:\n${diags}")
endif()
if(diags MATCHES "pir::verify")
    message(FATAL_ERROR "the lowering produced a module that does not verify:\n${diags}")
endif()
if(NOT pir MATCHES "module " AND NOT REFUSAL_OK)
    message(FATAL_ERROR "no PIR module was printed for ${INPUT}")
endif()
