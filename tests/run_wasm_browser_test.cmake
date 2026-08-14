# Build a Polaron wasm module and RUN IT IN A REAL BROWSER, invoked via `cmake -P`.
#
# Every other wasm check in this suite stops at the module: it links, it has the right symbols, it
# imports nothing. None of that catches a module that instantiates and then traps on its first
# allocation -- which is exactly what happened, because codegen declared `memset` with a 64-bit length
# on a 32-bit target and WebAssembly, unlike x86, CHECKS signatures.
#
# So this one loads the module in headless Chrome, calls its exported methods, and reads what the page
# rendered. It is the only test here that exercises the whole path a browser does.
#
# Required -D args: POLARON, PROJECT, MODULE, CHROME, PAGE, SHOT, EXPECTED.
# The page is generated here rather than kept in the tree, because it embeds the module as base64 --
# `fetch()` of a .wasm is blocked from file://, and this test must not need a web server.

execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf "${PROJECT}/build-output")
execute_process(COMMAND "${POLARON}" build WORKING_DIRECTORY "${PROJECT}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE bout ERROR_VARIABLE berr)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron build failed (exit ${rc})\n${bout}\n${berr}")
endif()
if(NOT EXISTS "${MODULE}")
    message(FATAL_ERROR "no module at ${MODULE}")
endif()

# CMake has no base64 encoder, but it has a hex reader -- and JavaScript can turn hex into bytes in one
# line. Same result, no extra tool.
file(READ "${MODULE}" _hex HEX)

file(WRITE "${PAGE}" "<!doctype html><meta charset=\"utf-8\"><body>\n"
"<h1 id=\"out\">loading</h1>\n<script>\n"
"const hex = '${_hex}';\n"
"const bytes = new Uint8Array(hex.length / 2);\n"
"for (let i = 0; i < bytes.length; i++) { bytes[i] = parseInt(hex.substr(i * 2, 2), 16); }\n"
"WebAssembly.instantiate(bytes, {}).then(({ instance }) => {\n"
"  const x = instance.exports;\n"
"  x.kmain(0);\n"
"  x.click(41);\n"
"  x.click(1);\n"
"  const mem = new Uint8Array(x.memory.buffer);\n"
"  const ptr = x.textPtr(), len = x.textLen();\n"
"  document.getElementById('out').textContent =\n"
"    new TextDecoder().decode(mem.subarray(ptr, ptr + len));\n"
"}).catch(e => { document.getElementById('out').textContent = 'FAILED: ' + e.message; });\n"
"</script></body>\n")

# --dump-dom writes to stdout, which is what the verdict is read from. The networking flags are not
# tidiness: without them Chrome spends tens of seconds on sign-in and update traffic before rendering,
# and the screenshot/dump lands after the timeout.
execute_process(COMMAND "${CHROME}" --headless=new --disable-gpu --no-sandbox --no-first-run
                        --disable-background-networking --disable-sync --disable-extensions
                        --user-data-dir=${SHOT}.profile --window-size=900,200
                        --virtual-time-budget=4000 --timeout=6000
                        --dump-dom "file://${PAGE}"
                OUTPUT_VARIABLE _dom ERROR_QUIET RESULT_VARIABLE crc TIMEOUT 90)

# A trap used to be an infinite loop on this target, so a HANG is a real failure mode and not a slow
# machine. Say so, because "timed out" on its own sends the next person to the wrong place.
if(crc STREQUAL "Process terminated due to timeout")
    message(FATAL_ERROR "the browser never finished: a Polaron guard firing in a wasm module must TRAP "
                        "(unreachable), never spin -- see the panic emitted by src/driver/build.cpp")
endif()

string(FIND "${_dom}" "${EXPECTED}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "the page did not render '${EXPECTED}'\n--- dom ---\n${_dom}")
endif()
message(STATUS "OK: the browser rendered '${EXPECTED}'")
