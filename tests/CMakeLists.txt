# CTest wiring for the LDP3 compiler.
#
# M0: smoke tests that prove the driver builds and runs. Unit tests for the
# lexer/parser/semantic stages join from M1 via a lightweight framework, and
# integration tests will compile sample programs and check their output.

add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 0\\.1\\.0-dev")

add_test(NAME cli_reads_sample
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(cli_reads_sample PROPERTIES
    PASS_REGULAR_EXPRESSION "read [0-9]+ bytes")
