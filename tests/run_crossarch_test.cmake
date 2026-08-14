# Cross-compile a HOSTED Polaron program for another architecture and RUN it. Invoked via `cmake -P`.
#
# The suite already boots bare-metal images for AArch64 and i686, and that proves the compiler and the
# freestanding shims. It says nothing about the HOSTED runtime -- the allocator, the String helpers,
# everything that talks to a libc -- because a kernel links none of it. That half was recorded as
# blocked for months on "no sysroot, no qemu-user", which turned out to be one apt-get away.
#
# Every step here produces a real artifact for the target: polc emits that triple's IR, clang
# assembles it against that target's sysroot, the cross g++ compiles the runtime and links, and
# qemu-user executes the result. A wrong answer is the target's.
#
# Required -D args: POLC, PROGRAM, TRIPLE, CROSS_GXX, SYSROOT, QEMU, EXPECTED, RUNTIME, WORKDIR.
#
# CROSS_GXX is the compiler's full path, not a prefix: Ubuntu ships the less common cross toolchains
# only as `g++-12-<arch>-linux-gnu`, so the binary is `powerpc-linux-gnu-g++-12` and no prefix rule
# produces that.

get_filename_component(_tag "${TRIPLE}" NAME)
set(_d "${WORKDIR}/cross_${_tag}")
file(MAKE_DIRECTORY "${_d}")

execute_process(COMMAND "${POLC}" "${PROGRAM}" "--target=${TRIPLE}" -o "${_d}/p.ll"
                RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed for ${TRIPLE} (exit ${rc})\n${o}\n${e}")
endif()

# M68K NEEDS A STEP THE OTHERS DO NOT: LLVM addresses every global with a 16-bit PC-relative
# displacement (`move.l (g,%pc), %d0`), so nothing bigger than 32 KB links -- `relocation truncated to
# fit: R_68K_PC16`. It is not a relocation model, not a code model, not the small-data threshold: it is
# what the backend does, and GCC uses absolute addressing for the identical source. So the assembly is
# emitted, the operand form rewritten, and the same clang assembles it.
#
# Through `polaron fix-asm` rather than a copy of the rule here: the build applies the same transform,
# and two spellings of a subtle rule is how they drift.
if(TRIPLE MATCHES "^m68k")
    execute_process(COMMAND clang "--target=${TRIPLE}" -Wno-override-module "--sysroot=${SYSROOT}"
                            -fno-pic -S "${_d}/p.ll" -o "${_d}/p.s"
                    RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "clang failed to emit ${TRIPLE} assembly (exit ${rc})\n${o}\n${e}")
    endif()
    execute_process(COMMAND "${POLARON}" fix-asm "${_d}/p.s" RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "polaron fix-asm failed on ${_d}/p.s")
    endif()
    execute_process(COMMAND clang "--target=${TRIPLE}" "--sysroot=${SYSROOT}"
                            -c "${_d}/p.s" -o "${_d}/p.o"
                    RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "assembling the rewritten ${TRIPLE} assembly failed (exit ${rc})\n${e}")
    endif()
else()
    execute_process(COMMAND clang "--target=${TRIPLE}" -Wno-override-module "--sysroot=${SYSROOT}"
                            -c "${_d}/p.ll" -o "${_d}/p.o"
                    RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "clang failed for ${TRIPLE} (exit ${rc})\n${o}\n${e}")
    endif()
endif()

# `-w`: the runtime is compiled for a target whose libc headers warn differently, and a warning is not
# what this test is about. NOT piped anywhere -- a compiler whose stdout pipe closes early takes
# SIGPIPE and dies part-way, and the only evidence is a missing object two steps later.
execute_process(COMMAND "${CROSS_GXX}" -std=c++20 -O2 -w -c "${RUNTIME}" -o "${_d}/rt.o"
                RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the runtime did not cross-compile for ${TRIPLE} (exit ${rc})\n${e}")
endif()

execute_process(COMMAND "${CROSS_GXX}" "${_d}/p.o" "${_d}/rt.o" -o "${_d}/prog"
                        -lpthread -ldl -lm
                RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "cross link failed for ${TRIPLE} (exit ${rc})\n${e}")
endif()

execute_process(COMMAND "${QEMU}" -L "${SYSROOT}" "${_d}/prog"
                OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc TIMEOUT 60)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the ${TRIPLE} program exited ${rc}\n  stdout: [${out}]\n  stderr: [${err}]")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "wrong answer on ${TRIPLE}:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()
message(STATUS "OK: ${TRIPLE} ran and said '${out}'")
