# Build a bare-metal project for another architecture and BOOT IT, invoked via `cmake -P`.
#
# Reading the emitted IR proves a target compiles; only running it proves the target works. The two
# answer different questions and this suite needs both -- an image can compile, link, and then fault on
# its first instruction because the entry symbol resolved to zero, which is a failure no amount of
# reading the .ll would have shown.
#
# Required -D args: POLARON (the driver), PROJECT (a directory with polaron.toml), QEMU, MACHINE,
#                   CPU, EXPECTED (substrings of the serial output, a `;` list), SERIAL (where to
#                   write it).
# Optional: TIMEOUT (seconds, default 20).
#
# EXPECTED IS A LIST BECAUSE A BOOT IS EXPENSIVE. It was one needle, then a second under a second
# name (`ALSO_EXPECTED`), and a third claim would have wanted a third name -- which is a list spelled
# by hand, one variable at a time. Twenty seconds of wall clock says everything one boot can prove
# should be asserted on that boot, rather than left unasserted because asserting it was expensive.
#
# The guest PARKS rather than exiting -- a kernel that returns has nowhere to return to -- so QEMU is
# killed on a timeout and the serial log is the verdict. A timeout is therefore the NORMAL outcome and
# not a failure; what fails is the log not containing what it should.
if(NOT TIMEOUT)
    set(TIMEOUT 20)
endif()

file(REMOVE "${SERIAL}")
execute_process(COMMAND "${POLARON}" build WORKING_DIRECTORY "${PROJECT}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE buildOut ERROR_VARIABLE buildErr)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron build failed (exit ${rc}) in ${PROJECT}\n${buildOut}\n${buildErr}")
endif()

execute_process(COMMAND "${QEMU}" -machine "${MACHINE}" -cpu "${CPU}" -nographic -no-reboot
                        -kernel "${IMAGE}" -serial "file:${SERIAL}"
                TIMEOUT ${TIMEOUT} RESULT_VARIABLE qrc OUTPUT_QUIET ERROR_QUIET)

if(NOT EXISTS "${SERIAL}")
    message(FATAL_ERROR "the guest wrote nothing at all: no ${SERIAL} (qemu said ${qrc})")
endif()
file(READ "${SERIAL}" _log)
set(_needles ${EXPECTED} ${ALSO_EXPECTED})   # ALSO_EXPECTED still works; it is one more entry
foreach(_needle IN LISTS _needles)
    string(FIND "${_log}" "${_needle}" _found)
    if(_found EQUAL -1)
        message(FATAL_ERROR "the guest did not say '${_needle}'\n--- serial ---\n${_log}")
    endif()
endforeach()
list(LENGTH _needles _count)
message(STATUS "OK: booted and said all ${_count} of what it should")
