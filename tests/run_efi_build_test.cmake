# `polaron build` for `image = "efi"`, and the artifact must be a PE32+ EFI APPLICATION.
#
# The claim is deliberately narrow -- it builds, and the header says the right three things -- and
# that is where this format's failures live. A UEFI image is loaded by firmware that reads exactly
# those fields and silently declines anything else: the wrong machine type, the wrong subsystem, or a
# file that is an ELF because the driver took the ordinary freestanding path. None of those is visible
# in the IR, none of them fails the link, and all of them look identical from the outside -- a machine
# that boots something else instead.
#
# NO EMULATOR IS NEEDED, which is what lets this run everywhere rather than only where OVMF exists.
# Horizon's own suite boots the same image under real firmware; this one is the part that can be
# checked on any machine with a compiler.
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

# `MZ`, the DOS header every PE file still begins with. First, because a build that quietly took the
# ELF path writes 0x7f 'E' 'L' 'F' here and the rest of this file would then read nonsense out of it.
file(READ "${IMAGE}" _mz LIMIT 2 HEX)
if(NOT _mz STREQUAL "4d5a")
    message(FATAL_ERROR "not a PE image: it starts ${_mz}, not 4d5a (MZ) -- an ELF starts 7f454c46")
endif()

# WHERE THE REAL HEADER IS, out of the field at offset 0x3C. Read rather than assumed: the DOS stub
# in front of it is not a fixed length, and a hard-coded offset here would pass on the images this
# linker happens to produce today.
file(READ "${IMAGE}" _lfanew_hex OFFSET 60 LIMIT 4 HEX)
string(SUBSTRING "${_lfanew_hex}" 0 2 _b0)
string(SUBSTRING "${_lfanew_hex}" 2 2 _b1)
string(SUBSTRING "${_lfanew_hex}" 4 2 _b2)
string(SUBSTRING "${_lfanew_hex}" 6 2 _b3)
math(EXPR _pe "0x${_b3}${_b2}${_b1}${_b0}")

file(READ "${IMAGE}" _sig OFFSET ${_pe} LIMIT 4 HEX)
if(NOT _sig STREQUAL "50450000")
    message(FATAL_ERROR "no PE signature at ${_pe}: found ${_sig}, expected 50450000")
endif()

# THE MACHINE, two bytes after the signature. 0x8664 is x86-64, stored little-endian.
file(READ "${IMAGE}" _machine OFFSET ${_pe} LIMIT 6 HEX)
string(SUBSTRING "${_machine}" 8 4 _mach)
if(NOT _mach STREQUAL "6486")
    message(FATAL_ERROR "PE machine is 0x${_mach} (little-endian), expected 6486 for x86-64")
endif()

# AND THE SUBSYSTEM, which is the field that makes a firmware willing to run the file at all. It is
# at offset 68 of the optional header, which begins 24 bytes past the signature. 10 is
# IMAGE_SUBSYSTEM_EFI_APPLICATION; 3 is a Windows console program, which links perfectly and is
# declined by every UEFI machine.
math(EXPR _subsys_at "${_pe} + 24 + 68")
file(READ "${IMAGE}" _subsys OFFSET ${_subsys_at} LIMIT 2 HEX)
if(NOT _subsys STREQUAL "0a00")
    message(FATAL_ERROR "PE subsystem is 0x${_subsys} (little-endian), expected 0a00 = EFI application")
endif()

message(STATUS "OK: ${PROJECT} built a PE32+ EFI application for x86-64")
