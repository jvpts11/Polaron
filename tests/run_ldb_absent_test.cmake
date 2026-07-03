# End-to-end partial-compilation test driver, invoked via `cmake -P`.
#
# Builds a library to a .ldb, compiles a consumer that loads it dynamically and wraps the use in
# try/catch, then deletes the .ldb and runs: the program must catch BundleNotLoadedException and print
# its fallback (matched against CONTAINS) rather than crash.
#
# Required -D args: LDP3C, CLANG, LIB, APP, CONTAINS, WORKDIR

get_filename_component(CLANG_DIR "${CLANG}" DIRECTORY)
set(CLANGPP "${CLANG_DIR}/clang++.exe")
if(EXISTS "C:/Program Files/LLVM/bin/clang++.exe")
    set(CLANGPP "C:/Program Files/LLVM/bin/clang++.exe")
    set(CLANG_DIR "C:/Program Files/LLVM/bin")
endif()
set(ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
set(ldb "${WORKDIR}/e2e_absent.ldb")
set(ll "${WORKDIR}/e2e_absent_app.ll")
set(exe "${WORKDIR}/e2e_absent_app.exe")

execute_process(COMMAND "${LDP3C}" --lib "${LIB}" -o "${ldb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib failed (exit ${rc})")
endif()
execute_process(COMMAND "${LDP3C}" "${APP}" --use-dynamic "${ldb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c (consumer) failed (exit ${rc})")
endif()
execute_process(COMMAND "${CLANGPP}" -std=c++20 -Wno-override-module -Wno-deprecated "${ll}"
    "${ROOT}/runtime/ldp3_rt.cpp" "${ROOT}/runtime/ldp3_bundle.cpp" "${ROOT}/src/bundle/ldb.cpp"
    -I "${ROOT}/src" -o "${exe}" -llegacy_stdio_definitions RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang++ link failed (exit ${rc})")
endif()

# Remove the bundle so loading it at runtime fails -- the program must catch and continue.
file(REMOVE "${ldb}")
set(ENV{PATH} "${CLANG_DIR};$ENV{PATH}")
execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc} (the exception was not caught)\n  output: [${out}]")
endif()

string(FIND "${out}" "${CONTAINS}" found)
if(found EQUAL -1)
    message(FATAL_ERROR "output missing fallback:\n  got:    [${out}]\n  needle: [${CONTAINS}]")
endif()

message(STATUS "OK: caught absent bundle -> ${out}")
