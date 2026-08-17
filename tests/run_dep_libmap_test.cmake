# What a library needs on the link line reaches the program that links it, by BOTH routes.
#
# `driver_foreign_library_crosses_bundle` proves the NAME crosses: a consumer that declares nothing still
# learns its dependency's class comes from library `Crt`. This proves the other half -- what `Crt` IS.
#
# Two phases, because a library arrives two ways:
#
#   1. as a project next door, built from source. The mapping is read from its manifest.
#   2. as an installed bundle -- a .polb and a .polh, downloaded and unzipped, with no manifest beside
#      it. The mapping is read from INSIDE the bundle, which is why it is written there.
#
# Phase 2 is the one that was broken: the logical name resolved to itself and the linker went looking for
# `Crt.lib`, a file nobody has ever named. Neither consumer manifest below has a [libraries] section, and
# neither should need one.
#
# Required -D args: POLARON, WORKDIR

set(lib "${WORKDIR}/libmap_fixtures/libmap")
set(app "${WORKDIR}/libmap_app")
set(app2 "${WORKDIR}/libmap_app_installed")
file(REMOVE_RECURSE "${lib}" "${app}" "${app2}")
file(MAKE_DIRECTORY "${lib}/src")
file(MAKE_DIRECTORY "${app}/src")
file(MAKE_DIRECTORY "${app2}/src" "${app2}/libraries/libmap")

# `Crt` is the C runtime under a name of our own: linked already on every platform, so the mapping's job
# here is only to be FOUND. Unmapped, it would resolve to itself and the link would fail on `Crt.lib`.
file(WRITE "${lib}/polaron.toml"
"[polaron_project]\n[library]\nname = \"libmap\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Numbers.pol\"\n\n[libraries]\nCrt = { windows = \"kernel32\", linux = \"\", macos = \"\" }\n")
file(WRITE "${lib}/src/Numbers.pol"
"program LibMap;\npublic bundle LibMap {\n    public namespace Calc {\n        public class Numbers library Crt {\n            public extern cdecl static method magnitude(int x) returns int symbol(\"abs\");\n        }\n    }\n}\n")

set(mainSrc
"import System.IO.Console;\nimport LibMap.Calc.Numbers;\nprogram Consumer;\npublic bundle Consumer {\n    public namespace App {\n        public class Main {\n            public static method main(string[] args) returns void {\n                System.IO.Console.printf(\"magnitude = %d\\n\", Numbers.magnitude(0 - 5));\n                return;\n            }\n        }\n    }\n}\n")

# ---- phase 1: a path dependency, mapping read from the library's manifest ----
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Main.pol\"\n\n[dependencies]\nlibmap = { path = \"${lib}\" }\n")
file(WRITE "${app}/src/Main.pol" "${mainSrc}")

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "phase 1 (path dependency) failed (exit ${rc}). A link error naming 'Crt' means "
                        "the dependency's manifest was not consulted:\n${err}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "magnitude = 5")
    message(FATAL_ERROR "phase 1 output: [${out}]")
endif()
message(STATUS "OK: mapping read from the dependency's manifest")

# ---- phase 2: an INSTALLED bundle, with no manifest anywhere near it ----
if(NOT EXISTS "${lib}/build-output/libmap.polb")
    message(FATAL_ERROR "phase 1 should have built ${lib}/build-output/libmap.polb")
endif()
file(COPY "${lib}/build-output/libmap.polb" "${lib}/build-output/libmap.polh"
     DESTINATION "${app2}/libraries/libmap")
if(EXISTS "${app2}/libraries/libmap/polaron.toml")
    message(FATAL_ERROR "the installed library must NOT have a manifest for this phase to mean anything")
endif()

file(WRITE "${app2}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Main.pol\"\n\n[dependencies]\nlibmap = { path = \"libraries/libmap\", source = \"file://libmap@v1.0.0\" }\n")
file(WRITE "${app2}/src/Main.pol" "${mainSrc}")

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app2}" RESULT_VARIABLE rc2 OUTPUT_VARIABLE out2 ERROR_VARIABLE err2)
if(NOT rc2 EQUAL 0)
    message(FATAL_ERROR "phase 2 (installed bundle, no manifest) failed (exit ${rc2}). A link error "
                        "naming 'Crt' means the bundle is not carrying its own link requirements:\n${err2}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out2 "${out2}")
if(NOT out2 MATCHES "magnitude = 5")
    message(FATAL_ERROR "phase 2 output: [${out2}]")
endif()

message(STATUS "OK: a library's link requirements travel inside its bundle")
