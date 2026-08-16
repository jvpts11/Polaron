# A dependency's [libraries] mapping applies to the program that links it, via `cmake -P`.
#
# `driver_foreign_library_crosses_bundle` proves the NAME crosses: a consumer that declares nothing still
# learns its dependency's class comes from library `Crt`. This proves the other half -- what `Crt` IS.
# That mapping belongs to the library, because the library is what knows; a consumer forced to repeat it
# is keeping somebody else's private business in its own manifest, and a consumer that does not repeat it
# links nothing at all. The failure was a linker looking for `Crt.lib`, a file nobody ever named.
#
# The consumer's manifest below has NO [libraries] section on purpose. Without the inheritance, the
# logical name resolves to itself and the link fails; with it, `Crt` resolves through the dependency's
# manifest to the platform's file.
#
# Required -D args: POLARON, WORKDIR

set(lib "${WORKDIR}/libmap_fixtures/libmap")
set(app "${WORKDIR}/libmap_app")
file(REMOVE_RECURSE "${lib}" "${app}")
file(MAKE_DIRECTORY "${lib}/src")
file(MAKE_DIRECTORY "${app}/src")

file(WRITE "${lib}/polaron.toml"
"[polaron_project]\n[library]\nname = \"libmap\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Numbers.pol\"\n\n[libraries]\nCrt = { windows = \"kernel32\", linux = \"\", macos = \"\" }\n")
file(WRITE "${lib}/src/Numbers.pol"
"program LibMap;\npublic bundle LibMap {\n    public namespace Calc {\n        public class Numbers library Crt {\n            public extern cdecl static method magnitude(int x) returns int symbol(\"abs\");\n        }\n    }\n}\n")

file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Main.pol\"\n\n[dependencies]\nlibmap = { path = \"${lib}\" }\n")
file(WRITE "${app}/src/Main.pol"
"import System.IO.Console;\nimport LibMap.Calc.Numbers;\nprogram Consumer;\npublic bundle Consumer {\n    public namespace App {\n        public class Main {\n            public static method main(string[] args) returns void {\n                System.IO.Console.printf(\"magnitude = %d\\n\", Numbers.magnitude(0 - 5));\n                return;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "run: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron run failed (exit ${rc}). A link error naming 'Crt' means the "
                        "dependency's [libraries] mapping was not consulted:\n${err}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "magnitude = 5")
    message(FATAL_ERROR "expected 'magnitude = 5' in output, got: [${out}]")
endif()

message(STATUS "OK: a dependency's library mapping reaches the link")
