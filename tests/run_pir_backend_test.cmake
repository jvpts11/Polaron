# Stage 2: PIR -> LLVM, and the §12 hand-off measured.
#
# Two properties, and the second is the project's whole point:
#
#   1. The module the SECOND backend emits VERIFIES. A backend that produces something LLVM refuses
#      tells you nothing about anything.
#   2. The facts actually arrive. The measurement of 2026-08-18 found the old path forwarding one
#      `llvm.assume`, four `NoAlias` returns and three attributes on `this` -- out of 18 827 lines of
#      codegen. "We emit the attributes now" is a claim; these numbers are the evidence, and a
#      regression that quietly stops emitting them fails here instead of showing up as a benchmark
#      nobody ran.
set(ENV{POLARON_VIA_PIR} "1")
execute_process(COMMAND "${POLC}" "${INPUT}" -o "${OUT}"
                ERROR_VARIABLE diags RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed with POLARON_VIA_PIR=1:\n${diags}")
endif()
if(NOT diags MATCHES "pir->llvm handoff:")
    message(FATAL_ERROR "the second backend did not run:\n${diags}")
endif()
if(diags MATCHES "does not verify" OR diags MATCHES "pir->llvm: [A-Z]")
    message(FATAL_ERROR "the emitted LLVM module does not verify:\n${diags}")
endif()
# The rows of §12 this program exercises. Zero means the fact stopped being forwarded.
foreach(fact nonnull align nounwind checked)
    if(diags MATCHES "${fact}=0 ")
        message(FATAL_ERROR "section 12: `${fact}` is no longer forwarded to LLVM:\n${diags}")
    endif()
endforeach()
