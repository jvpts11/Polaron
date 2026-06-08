# CTest wiring for the LDP3 compiler.
#
# Integration smoke tests over the ldp3c driver. Granular unit tests for the
# lexer/parser/semantic stages join via a lightweight framework as the surface
# grows.

add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 0\\.1\\.0-dev")

add_test(NAME cli_reads_sample
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(cli_reads_sample PROPERTIES
    PASS_REGULAR_EXPRESSION "read [0-9]+ bytes")

# Lexer: 'program' tokenizes to KwProgram.
add_test(NAME lexer_dumps_tokens
    COMMAND ldp3c --dump-tokens "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(lexer_dumps_tokens PROPERTIES
    PASS_REGULAR_EXPRESSION "KwProgram")

# Parser: hello_world builds an AST rooted at Program 'HelloWorld'.
add_test(NAME parser_dumps_ast
    COMMAND ldp3c --dump-ast "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(parser_dumps_ast PROPERTIES
    PASS_REGULAR_EXPRESSION "Program 'HelloWorld'")

# Semantic: hello_world has a valid entry point.
add_test(NAME sema_accepts_entry_point
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(sema_accepts_entry_point PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

# Semantic: a program without 'class Main' is rejected.
add_test(NAME sema_rejects_no_entry
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/no_entry.ldp3")
set_tests_properties(sema_rejects_no_entry PROPERTIES
    PASS_REGULAR_EXPRESSION "no entry point")
