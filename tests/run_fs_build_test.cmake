# `polaron build` for a bare-metal target, and the image must LINK. Invoked via `cmake -P`.
#
# The gap this fills is specific and it cost a whole kernel build. Every other freestanding test in
# the suite either inspects the IR or boots an image under QEMU, and the IR ones cannot see a
# duplicate symbol because a duplicate is not a property of one module -- it appears when the driver's
# own shim object meets the one codegen produced. A program with its own `heap class` has codegen
# emit `define @__polaron_malloc`; the driver decided whether to supply an allocator by looking for
# that NAME in the IR, found codegen's definition, and supplied a second one.
#
# So the claim here is only "it linked", and that is the point: linking is where the class of defect
# lives. No emulator is needed for it, which is what lets this run everywhere instead of only where
# QEMU exists.
#
# Required -D args: POLARON, PROJECT, IMAGE.

execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf "${PROJECT}/build-output")
execute_process(COMMAND "${POLARON}" build WORKING_DIRECTORY "${PROJECT}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron build failed (exit ${rc}) in ${PROJECT}\n${out}\n${err}")
endif()
if(NOT EXISTS "${IMAGE}")
    message(FATAL_ERROR "the build reported success but wrote no image at ${IMAGE}\n${out}")
endif()

# ELF magic, so a build that wrote *something* under the right name still has to have written an
# object file. 0x7f 'E' 'L' 'F'.
file(READ "${IMAGE}" _magic LIMIT 4 HEX)
if(NOT _magic MATCHES "^7f454c46")
    message(FATAL_ERROR "not an ELF image: first 4 bytes are ${_magic}")
endif()

message(STATUS "OK: ${PROJECT} linked a bare-metal image with its own heap class")
