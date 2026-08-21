# Stage 1: every sample lowers to PIR, and the module VERIFIES.
#
# The check is not "did it print something" -- it is that `pir::verify` found nothing to say about a
# module lowered from a real program. That is the property that makes the lowering trustworthy, and
# it is the one that would silently rot: a lowering can keep producing text long after it stopped
# producing a well-formed module.
#
# Gaps are allowed and expected at this stage -- they are the work queue, printed and counted. What
# is not allowed is a verifier rule firing.
execute_process(COMMAND "${POLC}" "${INPUT}" --emit-pir=- -o "${OUT}"
                OUTPUT_VARIABLE pir ERROR_VARIABLE diags RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed on ${INPUT}:\n${diags}")
endif()
if(diags MATCHES "pir::verify")
    message(FATAL_ERROR "the lowering produced a module that does not verify:\n${diags}")
endif()
if(NOT pir MATCHES "module ")
    message(FATAL_ERROR "no PIR module was printed for ${INPUT}")
endif()
