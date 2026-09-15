# A HOSTED 32-BIT PROGRAM, built the way a user builds one: through the driver, from a manifest.
#
# Required -D args: POLARON (the driver), INPUT (the .pol), EXPECTED, WORKDIR
#
# NOT `run_exe_test.cmake` with a different triple. That script drives polc and clang itself and links
# against the x64 runtime object the suite compiles once -- so it could never link a 32-bit program,
# and teaching it to would duplicate the very decision being tested. What is under test here is the
# DRIVER's choice: that `target = "i686-pc-windows-msvc"` in a manifest picks the 32-bit runtime and
# the 32-bit Visual Studio libraries. Only the driver makes that choice, so only the driver can be
# asked whether it makes it.
#
# Skips rather than fails when the install has no 32-bit runtime: that is a property of the machine
# the compiler was built on (clang and llvm-lib present), not of the code under test, and a red test
# nobody can fix teaches people to ignore red tests.

set(proj "${WORKDIR}/i686_hosted")
file(REMOVE_RECURSE "${proj}")
file(MAKE_DIRECTORY "${proj}/src")
get_filename_component(_name "${INPUT}" NAME)
configure_file("${INPUT}" "${proj}/src/main.pol" COPYONLY)
file(WRITE "${proj}/polaron.toml"
"[polaron_project]

[program]
name = \"i686_hosted\"
version = \"0.1.0\"
language_version = \"1.0\"
entry = \"src/main.pol\"

[build]
output = \"build-output/\"
target = \"i686-pc-windows-msvc\"
")

# `LIB` IS UNSET FOR THE CHILD, and it is the whole reason this test failed under `ctest -j` while
# passing on its own. The suite runs inside a developer environment that exports `LIB` pointing at the
# x64 CRT so the `_runs` tests can link; clang honours `LIB` whatever `--target` says, so a 32-bit
# build inherits 64-bit libraries and dies with
#
#     lld-link: error: libucrt.lib(exit.obj): machine type x64 conflicts with x86
#
# which names the symptom and not the cause. Cleared here rather than worked around in the driver:
# `LIB` is the environment saying "link against these", and a cross build has no business obeying a
# variable set for the host. The same trap waits for anyone building for i686 from a `vcvars64`
# prompt, which is why it is written down.
execute_process(COMMAND "${CMAKE_COMMAND}" -E env --unset=LIB --unset=LIBPATH "${POLARON}" build
                WORKING_DIRECTORY "${proj}"
                OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    if("${out}${err}" MATCHES "no 32-bit runtime")
        message(STATUS "SKIP: this install has no polaron_rt32.lib")
        return()
    endif()
    message(FATAL_ERROR "polaron build failed (exit ${rc})\n  stdout: ${out}\n  stderr: ${err}")
endif()

set(exe "${proj}/build-output/i686_hosted.exe")
if(NOT EXISTS "${exe}")
    message(FATAL_ERROR "no executable at ${exe}\n  stdout: ${out}")
endif()

# THE PE HEADER SAYS WHICH MACHINE, and it is worth asking as well as running: a program that prints
# the right numbers while being an x86-64 binary would mean the target was ignored, and the run alone
# could not tell. `e_lfanew` at 0x3C points at the signature; the machine word follows it by four.
file(READ "${exe}" _lfanew_hex OFFSET 60 LIMIT 4 HEX)
string(SUBSTRING "${_lfanew_hex}" 0 2 _b0)
string(SUBSTRING "${_lfanew_hex}" 2 2 _b1)
string(SUBSTRING "${_lfanew_hex}" 4 2 _b2)
string(SUBSTRING "${_lfanew_hex}" 6 2 _b3)
math(EXPR _pe "0x${_b3} * 16777216 + 0x${_b2} * 65536 + 0x${_b1} * 256 + 0x${_b0}")
math(EXPR _machineAt "${_pe} + 4")
file(READ "${exe}" _machine_hex OFFSET ${_machineAt} LIMIT 2 HEX)
if(NOT _machine_hex STREQUAL "4c01")   # 0x014c, little-endian: IMAGE_FILE_MACHINE_I386
    message(FATAL_ERROR "the executable is not i386: machine word reads ${_machine_hex}, expected 4c01")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE ran ERROR_VARIABLE ranerr RESULT_VARIABLE runrc)
if(NOT runrc EQUAL 0)
    message(FATAL_ERROR "the 32-bit program exited with ${runrc}\n  stdout: ${ran}\n  stderr: ${ranerr}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " ran "${ran}")
string(STRIP "${ran}" ran)
if(NOT ran STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${ran}]\n  expected: [${EXPECTED}]")
endif()
message(STATUS "OK (i386): ${ran}")
