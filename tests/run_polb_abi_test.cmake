# End-to-end ABI-mismatch test driver, invoked via `cmake -P`.
#
# Compiles a consumer against bundle LIB, then replaces the .polb at runtime with a different bundle
# LIB2 (a different ABI fingerprint). Loading it must raise BundleAbiMismatchException, which the
# consumer catches and reports (matched against CONTAINS).
#
# Required -D args: POLC, CLANG, LIB, LIB2, APP, CONTAINS, WORKDIR

get_filename_component(CLANG_DIR "${CLANG}" DIRECTORY)
if(CMAKE_HOST_WIN32)
    set(CLANGPP "${CLANG_DIR}/clang++.exe")
    if(EXISTS "C:/Program Files/LLVM/bin/clang++.exe")
        set(CLANGPP "C:/Program Files/LLVM/bin/clang++.exe")
        set(CLANG_DIR "C:/Program Files/LLVM/bin")
    endif()
else()
    set(CLANGPP "${CLANG_DIR}/clang++")
endif()
set(ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
set(polb "${WORKDIR}/e2e_abi.polb")
set(other "${WORKDIR}/e2e_abi_other.polb")
set(ll "${WORKDIR}/e2e_abi_app.ll")
set(exe "${WORKDIR}/e2e_abi_app.exe")

execute_process(COMMAND "${POLC}" --lib "${LIB}" -o "${polb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib (LIB) failed (exit ${rc})")
endif()
execute_process(COMMAND "${POLC}" --lib "${LIB2}" -o "${other}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib (LIB2) failed (exit ${rc})")
endif()
execute_process(COMMAND "${POLC}" "${APP}" --use-dynamic "${polb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc (consumer) failed (exit ${rc})")
endif()
if(CMAKE_HOST_WIN32)
    set(_platlink -llegacy_stdio_definitions)
else()
    set(_platlink -rdynamic -lpthread -ldl -lm)  # -rdynamic: a dlopened bundle resolves our symbols
endif()
execute_process(COMMAND "${CLANGPP}" -std=c++20 -Wno-override-module -Wno-deprecated "${ll}"
    "${ROOT}/runtime/polaron_rt.cpp" "${ROOT}/runtime/polaron_bundle.cpp" "${ROOT}/src/bundle/polb.cpp"
    -I "${ROOT}/src" -o "${exe}" ${_platlink} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang++ link failed (exit ${rc})")
endif()

# Swap in a different bundle at the expected path: its fingerprint will not match.
file(COPY_FILE "${other}" "${polb}" ONLY_IF_DIFFERENT)
if(CMAKE_HOST_WIN32)
    set(ENV{PATH} "${CLANG_DIR};$ENV{PATH}")
else()
    set(ENV{PATH} "${CLANG_DIR}:$ENV{PATH}")
endif()
execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc} (the exception was not caught)\n  output: [${out}]")
endif()

string(FIND "${out}" "${CONTAINS}" found)
if(found EQUAL -1)
    message(FATAL_ERROR "output missing fallback:\n  got:    [${out}]\n  needle: [${CONTAINS}]")
endif()

message(STATUS "OK: caught ABI mismatch -> ${out}")
