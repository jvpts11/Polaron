# Build a bare-metal project for another architecture and BOOT IT, invoked via `cmake -P`.
#
# Reading the emitted IR proves a target compiles; only running it proves the target works. The two
# answer different questions and this suite needs both -- an image can compile, link, and then fault on
# its first instruction because the entry symbol resolved to zero, which is a failure no amount of
# reading the .ll would have shown.
#
# Required -D args: POLARON (the driver), PROJECT (a directory with polaron.toml), QEMU, MACHINE,
#                   CPU, EXPECTED (a substring of the serial output), SERIAL (where to write it).
# Optional: TIMEOUT (seconds, default 20).
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
string(FIND "${_log}" "${EXPECTED}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the guest did not say '${EXPECTED}'\n--- serial ---\n${_log}")
endif()
# ALSO_EXPECTED: a second needle, so ONE boot can assert two independent things. Booting costs twenty
# seconds of wall clock, and a guest that prints two lines should not be started twice to have both
# read -- nor should the second claim go unasserted because asserting it was expensive.
if(ALSO_EXPECTED)
    string(FIND "${_log}" "${ALSO_EXPECTED}" _found2)
    if(_found2 EQUAL -1)
        message(FATAL_ERROR "the guest did not say '${ALSO_EXPECTED}'\n--- serial ---\n${_log}")
    endif()
    message(STATUS "OK: booted and said '${EXPECTED}' and '${ALSO_EXPECTED}'")
else()
    message(STATUS "OK: booted and said '${EXPECTED}'")
endif()
