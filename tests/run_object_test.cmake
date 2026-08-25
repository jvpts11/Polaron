# WHAT THE MACHINE ACTUALLY GETS, read out of the object file.
#
# Every other check in this suite reads LLVM IR, which is one translation away from the instructions
# the processor executes. For most things that gap does not matter. For a calling convention it is
# the whole question: `x86_intrcc` in the IR is a REQUEST, and what makes an interrupt handler
# correct is that the epilogue is `iretq` and not `retq` -- an ordinary return against a stack the
# CPU laid out for an interrupt return corrupts the interrupted context, and does it silently.
#
# So this one compiles to an object and disassembles it. It is also the shape that survives Wave 2:
# nothing here compares two back ends, it states what the emitted code must contain.
#
# Required: POLC, CLANG, OBJDUMP, INPUT, NEEDLE, WORKDIR.
# Optional: POLARONFLAGS (semicolon-separated), CLANGFLAGS, COUNT (exact number of occurrences).
get_filename_component(tag "${INPUT}" NAME_WE)
set(ll "${WORKDIR}/obj_${tag}.ll")
set(obj "${WORKDIR}/obj_${tag}.o")

separate_arguments(_pf UNIX_COMMAND "${POLARONFLAGS}")
execute_process(COMMAND "${POLC}" ${_pf} "${INPUT}" -o "${ll}" RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()

separate_arguments(_cf UNIX_COMMAND "${CLANGFLAGS}")
execute_process(COMMAND "${CLANG}" ${_cf} -c "${ll}" -o "${obj}" RESULT_VARIABLE rc ERROR_VARIABLE ce)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang could not assemble it (exit ${rc})\n${ce}")
endif()

execute_process(COMMAND "${OBJDUMP}" -d "${obj}" OUTPUT_VARIABLE text ERROR_QUIET RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "objdump failed (exit ${rc}) on ${obj}")
endif()

string(REGEX MATCHALL "${NEEDLE}" hits "${text}")
list(LENGTH hits n)
if(DEFINED COUNT)
    if(NOT n EQUAL COUNT)
        message(FATAL_ERROR
                "the disassembly contains '${NEEDLE}' ${n} time(s), expected ${COUNT}.\n"
                "This reads the OBJECT, not the IR: a calling convention in the IR is a request, and\n"
                "what makes it real is the instruction the processor runs.")
    endif()
elseif(n EQUAL 0)
    message(FATAL_ERROR
            "the disassembly does not contain '${NEEDLE}'.\n"
            "This reads the OBJECT, not the IR: a calling convention in the IR is a request, and\n"
            "what makes it real is the instruction the processor runs.")
endif()
