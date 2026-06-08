# CTest wiring for the LDP3 compiler.
#
# Integration smoke tests over the ldp3c driver. Granular unit tests for the
# lexer/parser stages join via a lightweight framework as the surface grows.

add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 0\\.1\\.0-dev")

add_test(NAME cli_reads_sample
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(cli_reads_sample PROPERTIES
    PASS_REGULAR_EXPRESSION "read [0-9]+ bytes")

# M1: the lexer tokenizes the hello-world sample; the keyword 'program' must
# come through as KwProgram.
add_test(NAME lexer_dumps_tokens
    COMMAND ldp3c --dump-tokens "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(lexer_dumps_tokens PROPERTIES
    PASS_REGULAR_EXPRESSION "KwProgram")
