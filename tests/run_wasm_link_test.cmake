# Compile a .pol for wasm32 and LINK IT INTO A REAL MODULE, invoked via `cmake -P`.
#
# "The backend accepts it" and "there is a module" are different claims. An object file can be emitted
# for a target whose linker then rejects it, and a module that links can still be malformed. This goes
# as far as this machine can: polc -> wasm32 IR -> clang -c -> wasm-ld -> a file whose first four
# bytes are `\0asm` and whose symbol table holds the method.
#
# It stops there because there is no wasm host here (no node, no wasmtime). That is a missing TOOL,
# not missing work -- unlike AArch64 and i686, which boot under QEMU in this same suite.
#
# Required -D args: POLC, CLANG, WASMLD, INPUT, SYMBOL, WORKDIR.
string(MD5 _tag "${INPUT}|${SYMBOL}")
set(ll "${WORKDIR}/wasm_${_tag}.ll")
set(obj "${WORKDIR}/wasm_${_tag}.o")
set(wasm "${WORKDIR}/wasm_${_tag}.wasm")
file(REMOVE "${wasm}")

execute_process(COMMAND "${POLC}" "${INPUT}" --target=wasm32-unknown-unknown -o "${ll}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) for wasm32 on ${INPUT}")
endif()

execute_process(COMMAND "${CLANG}" --target=wasm32-unknown-unknown -Wno-override-module
                        -c "${ll}" -o "${obj}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang failed to assemble the wasm32 object (exit ${rc})")
endif()

# --allow-undefined: a freestanding program still references the guard reporter, which no wasm host
# has provided here. --export-all keeps the symbol names so the check below can find one.
execute_process(COMMAND "${WASMLD}" --no-entry --export-all --allow-undefined "${obj}" -o "${wasm}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "wasm-ld failed (exit ${rc})")
endif()
if(NOT EXISTS "${wasm}")
    message(FATAL_ERROR "wasm-ld reported success but wrote no module")
endif()

# The magic number, read as bytes: 0x00 'a' 's' 'm', then version 1.
file(READ "${wasm}" _magic LIMIT 8 HEX)
if(NOT _magic MATCHES "^0061736d01000000")
    message(FATAL_ERROR "not a WebAssembly module: first 8 bytes are ${_magic}")
endif()

# And the method is really in it, rather than the module being an empty shell that happens to link.
#
# COMPARED IN HEX, because a wasm module is binary and `file(READ)` stops at the first NUL -- the
# search for the name then failed on a module that plainly contained it (llvm-objdump showed
# `<Squares.sumTo>` in the same file). A text search over binary data is a test that reports on how
# far the read got, not on what the file holds.
file(READ "${wasm}" _hex HEX)
string(HEX "${SYMBOL}" _symhex)
string(FIND "${_hex}" "${_symhex}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the module does not contain '${SYMBOL}' (looked for ${_symhex})")
endif()
message(STATUS "OK: wasm32 module links and exports '${SYMBOL}'")
