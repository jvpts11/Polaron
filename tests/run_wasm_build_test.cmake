# `polaron build` for wasm32, and the module must import NOTHING. Invoked via `cmake -P`.
#
# Distinct from run_wasm_link_test.cmake in the way that matters: that harness drives
# polc -> clang -> wasm-ld by hand, so it proved the compiler and the linker were ready while saying
# nothing about the DRIVER -- which linked every freestanding target with `ld.lld` and could not
# produce a wasm module at all.
#
# And it asserts self-containment rather than success. An undefined symbol in a wasm module is not a
# broken image the way it is in an ELF: it becomes an IMPORT, a demand on whatever host instantiates
# the module. So "it linked" is not the claim worth making. The claim worth making is that a Polaron
# program needs nothing from the host, and only the symbol table says that.
#
# Required -D args: POLARON, PROJECT, MODULE, NM.

execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf "${PROJECT}/build-output")
execute_process(COMMAND "${POLARON}" build WORKING_DIRECTORY "${PROJECT}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron build failed (exit ${rc}) in ${PROJECT}\n${out}\n${err}")
endif()
if(NOT EXISTS "${MODULE}")
    message(FATAL_ERROR "the build reported success but wrote no module at ${MODULE}\n${out}")
endif()

# The magic number, read as bytes: 0x00 'a' 's' 'm', then version 1.
file(READ "${MODULE}" _magic LIMIT 8 HEX)
if(NOT _magic MATCHES "^0061736d01000000")
    message(FATAL_ERROR "not a WebAssembly module: first 8 bytes are ${_magic}")
endif()

execute_process(COMMAND "${NM}" "${MODULE}" OUTPUT_VARIABLE _syms RESULT_VARIABLE nrc ERROR_QUIET)
if(NOT nrc EQUAL 0)
    message(FATAL_ERROR "llvm-nm could not read ${MODULE}")
endif()
string(REPLACE "\n" ";" _lines "${_syms}")
set(_undef "")
foreach(_l IN LISTS _lines)
    if(_l MATCHES "^[ \t]*U[ \t]+(.+)$")
        list(APPEND _undef "${CMAKE_MATCH_1}")
    endif()
endforeach()
if(_undef)
    string(REPLACE ";" ", " _pretty "${_undef}")
    message(FATAL_ERROR
        "the module imports ${_pretty} -- a Polaron module for a bare wasm target must be "
        "self-contained, and every name here is something the host would have to supply")
endif()

# ...and it is not an empty shell that trivially imports nothing.
string(FIND "${_syms}" "kmain" _hasEntry)
if(_hasEntry EQUAL -1)
    message(FATAL_ERROR "the module has no `kmain`: a bare wasm target is entered directly, not "
                        "through a C runtime's `main`\n${_syms}")
endif()
message(STATUS "OK: wasm module built by the driver, importing nothing")
