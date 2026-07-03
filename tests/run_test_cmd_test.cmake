# `ldp3 test` end-to-end, invoked via `cmake -P`.
#
# Builds a project whose entry file holds two [Test] methods (one passing, one failing), runs `ldp3 test`,
# and checks the report plus a non-zero exit; then, with only a passing test, checks a zero exit.
#
# Required -D args: LDP3, WORKDIR

set(app "${WORKDIR}/testcmd_app")
file(REMOVE_RECURSE "${app}")
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"app\"\nlanguage_version = \"1.0\"\nentry = \"src/main.ldp3\"\n")

file(WRITE "${app}/src/main.ldp3"
"import System.Test.Assert;\nprogram App;\npublic bundle main {\n    public namespace app {\n        public class Tests {\n            [Test]\n            public static method passes() returns boolean { return Assert.eq(1, 1); }\n            [Test]\n            public static method fails() returns boolean { return Assert.eq(1, 2); }\n        }\n    }\n}\n")

execute_process(COMMAND "${LDP3}" test
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "test (1 fail): ${out}${err}")
string(REGEX REPLACE "[ \t\r\n]+" " " flat "${out}")
if(NOT flat MATCHES "1 passed, 1 failed")
    message(FATAL_ERROR "expected '1 passed, 1 failed', got: [${flat}]")
endif()
if(rc EQUAL 0)
    message(FATAL_ERROR "ldp3 test must exit non-zero when a test fails")
endif()

# Only a passing test now: ldp3 test must succeed.
file(WRITE "${app}/src/main.ldp3"
"import System.Test.Assert;\nprogram App;\npublic bundle main {\n    public namespace app {\n        public class Tests {\n            [Test]\n            public static method passes() returns boolean { return Assert.eq(1, 1); }\n        }\n    }\n}\n")
execute_process(COMMAND "${LDP3}" test
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out)
message(STATUS "test (all pass): ${out}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3 test must exit zero when all tests pass, got ${rc}")
endif()

message(STATUS "OK: ldp3 test")
