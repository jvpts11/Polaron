# CTest wiring for the LDP3 compiler.
#
# Two layers: integration smoke tests over the ldp3c driver, and granular
# unit tests (doctest) over the lexer/parser/semantic libraries.

# ---- Integration tests (driver) ----
add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 0\\.1\\.0-dev")

add_test(NAME lexer_dumps_tokens
    COMMAND ldp3c --dump-tokens "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(lexer_dumps_tokens PROPERTIES
    PASS_REGULAR_EXPRESSION "KwProgram")

add_test(NAME parser_dumps_ast
    COMMAND ldp3c --dump-ast "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(parser_dumps_ast PROPERTIES
    PASS_REGULAR_EXPRESSION "Program 'HelloWorld'")

add_test(NAME sema_accepts_entry_point
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(sema_accepts_entry_point PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

add_test(NAME sema_rejects_no_entry
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/no_entry.ldp3")
set_tests_properties(sema_rejects_no_entry PROPERTIES
    PASS_REGULAR_EXPRESSION "no entry point")

# ---- Codegen tests (only when the LLVM backend is built) ----
if(LDP3_WITH_LLVM)
    # The emitted IR contains an i32 main and a printf call.
    add_test(NAME codegen_emits_ir
        COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
    set_tests_properties(codegen_emits_ir PROPERTIES
        PASS_REGULAR_EXPRESSION "define i32 @main")

    # Full pipeline: compile to .exe with clang and check it prints correctly.
    find_program(LDP3_CLANG clang HINTS "C:/Program Files/LLVM/bin")
    if(LDP3_CLANG)
        add_test(NAME codegen_hello_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
            "-DEXPECTED=Resultado: 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
    else()
        message(STATUS "clang not found; skipping end-to-end codegen test")
    endif()
endif()

# ---- Unit tests (doctest, fetched at configure time) ----
include(FetchContent)
FetchContent_Declare(
    doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG v2.4.11
    GIT_SHALLOW TRUE
)
# doctest 2.4.11's CMakeLists declares a pre-3.5 minimum, which CMake 4
# rejects; permit the older policy for this dependency only.
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
FetchContent_MakeAvailable(doctest)
unset(CMAKE_POLICY_VERSION_MINIMUM)

add_executable(ldp3_unit_tests
    unit/test_main.cpp
    unit/test_lexer.cpp
    unit/test_parser.cpp
    unit/test_semantic.cpp
)
target_link_libraries(ldp3_unit_tests PRIVATE ldp3_core doctest::doctest)
add_test(NAME unit_tests COMMAND ldp3_unit_tests)
