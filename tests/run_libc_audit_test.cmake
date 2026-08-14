# The C-library signature audit, across every target this compiler can emit for. `cmake -P`.
#
# It needs NO cross toolchain and NO emulator: the check is on what polc DECLARES, and that is decided
# on the host. That is the whole reason it exists -- the four width bugs found on 2026-08-14 all
# needed somebody to own the other machine before they were visible, and three of the four had
# already shipped.
#
# Required -D args: POLC, PROGRAM, WORKDIR.

set(_targets
    x86_64-unknown-linux-gnu
    x86_64-pc-windows-msvc
    aarch64-unknown-linux-gnu
    riscv64-unknown-linux-gnu
    i686-unknown-linux-gnu
    armv7-unknown-linux-gnueabihf
    powerpc-unknown-linux-gnu      # 32-bit AND no data layout: the width comes from the triple alone
    wasm32-unknown-unknown
    x86_64-unknown-none            # bare metal
)

foreach(_t IN LISTS _targets)
    string(MD5 _tag "${_t}")
    execute_process(COMMAND "${POLC}" "${PROGRAM}" "--target=${_t}" -o "${WORKDIR}/audit_${_tag}.ll"
                    RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "polc failed for ${_t} (exit ${rc})\n${o}\n${e}")
    endif()
    # The audit reports as an `internal:` error, which would have failed the compile above -- but say
    # so explicitly, so a future change that downgrades it to a warning does not pass here silently.
    if("${o}${e}" MATCHES "internal:")
        message(FATAL_ERROR "the libc audit objected on ${_t}:\n${o}${e}")
    endif()
endforeach()

# ...and a target whose architecture LLVM cannot parse is REFUSED rather than guessed at. `sh4` is a
# real one: LLVM gives `UnknownArch`, so its pointer width is unknowable and every size below it would
# be a guess wearing a target's name.
execute_process(COMMAND "${POLC}" "${PROGRAM}" "--target=sh4-unknown-linux-gnu"
                        -o "${WORKDIR}/audit_sh4.ll"
                RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
if(rc EQUAL 0)
    message(FATAL_ERROR "sh4 was accepted; LLVM cannot say how wide its pointers are, so nothing "
                        "downstream can be right by anything but luck")
endif()
if(NOT "${o}${e}" MATCHES "architecture LLVM does not know")
    message(FATAL_ERROR "sh4 was refused for the wrong reason:\n${o}${e}")
endif()

message(STATUS "OK: libc signatures audited on 9 targets; an unknown architecture is refused")
