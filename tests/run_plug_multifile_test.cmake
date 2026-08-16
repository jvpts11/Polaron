# A library of more than one file survives being installed, via `cmake -P`.
#
# `polaron plug` compiles the dependency it just cloned, and compiled its ENTRY FILE ONLY -- so a library
# whose types live one per file (which is how they are meant to live) built perfectly in the directory it
# was written in and failed the moment anybody installed it, complaining about a class declared in the
# file next door. Found by installing a real one: the OpenGL library's `Gl.pol` names `Wgl`, which is in
# `Wgl.pol`, and `polaron plug` said `Wgl` was undeclared.
#
# The fixture is deliberately two files with the reference pointing across them, and the entry is the one
# that does the pointing.
#
# Required -D args: POLARON, WORKDIR

set(fix "${WORKDIR}/plugmulti_fixtures/multilib")
set(app "${WORKDIR}/plugmulti_app")
file(REMOVE_RECURSE "${fix}" "${app}")
file(MAKE_DIRECTORY "${fix}/src")
file(MAKE_DIRECTORY "${app}/src")

file(WRITE "${fix}/polaron.toml"
"[polaron_project]\n[library]\nname = \"multilib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Front.pol\"\n")
file(WRITE "${fix}/src/Front.pol"
"program MultiLib;\npublic bundle MultiLib {\n    public namespace Calc {\n        public class Front {\n            public static method quadruple(int x) returns int {\n                return Back.twice(Back.twice(x));\n            }\n        }\n    }\n}\n")
file(WRITE "${fix}/src/Back.pol"
"program MultiLib;\npublic bundle MultiLib {\n    public namespace Calc {\n        public class Back {\n            public static method twice(int x) returns int {\n                return x + x;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed (exit ${rc})")
endif()
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${fix}")
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed (exit ${rc})")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}")

file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Main.pol\"\n\n[dependencies]\n")
file(WRITE "${app}/src/Main.pol"
"import System.IO.Console;\nimport MultiLib.Calc.Front;\nprogram Consumer;\npublic bundle Consumer {\n    public namespace App {\n        public class Main {\n            public static method main(string[] args) returns void {\n                System.IO.Console.printf(\"quadruple = %d\\n\", Front.quadruple(3));\n                return;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" plug "${fix}@v1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron plug failed (exit ${rc}) -- an undeclared-name error naming a class "
                        "from the sibling file means only the entry was compiled:\n${err}")
endif()

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "run: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron run failed (exit ${rc}): ${err}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "quadruple = 12")
    message(FATAL_ERROR "expected 'quadruple = 12' in output, got: [${out}]")
endif()

message(STATUS "OK: a multi-file library survives installation")
