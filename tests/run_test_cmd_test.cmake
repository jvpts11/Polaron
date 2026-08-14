# `polaron test` end-to-end, invoked via `cmake -P`.
#
# Builds a project whose entry file holds two [Test] methods (one passing, one failing), runs `polaron test`,
# and checks the report plus a non-zero exit; then, with only a passing test, checks a zero exit.
#
# Required -D args: POLARON, WORKDIR

set(app "${WORKDIR}/testcmd_app")
file(REMOVE_RECURSE "${app}")
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"app\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n")

file(WRITE "${app}/src/main.pol"
"import System.Test.Assert;\nprogram App;\npublic bundle main {\n    public namespace app {\n        public class Tests {\n            [Test]\n            public static method passes() returns boolean { return Assert.eq(1, 1); }\n            [Test]\n            public static method fails() returns boolean { return Assert.eq(1, 2); }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" test
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "test (1 fail): ${out}${err}")
string(REGEX REPLACE "[ \t\r\n]+" " " flat "${out}")
if(NOT flat MATCHES "1 passed, 1 failed")
    message(FATAL_ERROR "expected '1 passed, 1 failed', got: [${flat}]")
endif()
if(rc EQUAL 0)
    message(FATAL_ERROR "polaron test must exit non-zero when a test fails")
endif()

# Only a passing test now: polaron test must succeed.
file(WRITE "${app}/src/main.pol"
"import System.Test.Assert;\nprogram App;\npublic bundle main {\n    public namespace app {\n        public class Tests {\n            [Test]\n            public static method passes() returns boolean { return Assert.eq(1, 1); }\n        }\n    }\n}\n")
execute_process(COMMAND "${POLARON}" test
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out)
message(STATUS "test (all pass): ${out}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron test must exit zero when all tests pass, got ${rc}")
endif()

# Arguments after `--` reach the runner: --filter narrows the run, --list names the tests without
# running them.
execute_process(COMMAND "${POLARON}" test -- --list
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out)
string(REGEX REPLACE "[ \t\r\n]+" " " flat "${out}")
if(NOT flat MATCHES "Tests\\.passes")
    message(FATAL_ERROR "polaron test -- --list must name the tests, got: [${flat}]")
endif()
if(flat MATCHES "PASS")
    message(FATAL_ERROR "polaron test -- --list must not RUN anything, got: [${flat}]")
endif()

execute_process(COMMAND "${POLARON}" test -- --filter nothing_matches_this
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out)
string(REGEX REPLACE "[ \t\r\n]+" " " flat "${out}")
if(NOT flat MATCHES "0 passed, 0 failed")
    message(FATAL_ERROR "polaron test -- --filter must narrow the run, got: [${flat}]")
endif()

# A [library] project's tests must RUN. A library normally builds to a .polb with no entry point, and
# `polaron test` used to take that path: it wrote the bundle and exited 0 having run nothing, which a CI
# reads as "all tests passed".
set(lib "${WORKDIR}/testcmd_lib")
file(REMOVE_RECURSE "${lib}")
file(MAKE_DIRECTORY "${lib}/src")
file(WRITE "${lib}/polaron.toml"
"[polaron_project]\n[library]\nname = \"mylib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n")
file(WRITE "${lib}/src/lib.pol" [==[
import System.Test.Test;
program MyLib;

public bundle MyLib {
    public namespace Core {
        public class Adder {
            public static method add(int a, int b) returns int {
                return a + b;
            }

            [Test]
            public static method add_works() returns void {
                Test.assertEqual(Adder.add(2, 2), 4);
                return;
            }
        }
    }
}
]==])
execute_process(COMMAND "${POLARON}" test
    WORKING_DIRECTORY "${lib}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "test (library): ${out}${err}")
string(REGEX REPLACE "[ \t\r\n]+" " " flat "${out}")
if(NOT flat MATCHES "PASS Adder\\.add_works")
    message(FATAL_ERROR "polaron test on a [library] must run its tests, got: [${flat}]")
endif()
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron test on a [library] with a passing test must exit zero, got ${rc}")
endif()

message(STATUS "OK: polaron test")
