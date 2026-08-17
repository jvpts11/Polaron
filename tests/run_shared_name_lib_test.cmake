# A library may declare a class whose short name the standard library also uses, via `cmake -P`.
#
# `ByteWriter` is one of ninety-seven such names in the standard library's own TLS. Declaring one in a
# library made the compiler give the STANDARD LIBRARY's class a qualified key -- `System.Net.Tls.ByteWriter`
# -- which is correct, and then emit it into the .polb with strong linkage, which was not: the test for
# "is this a prelude class" read the first dot-separated segment of the symbol and got `System`.
#
# The consumer's own prelude defines the same symbols, so the link died on LNK2005 for ninety-seven
# things nobody in the program had written. It only bites when the short name is shared, which is why
# every other library linked and this was found by porting one that collides.
#
# STATIC METHODS ON PURPOSE. There is a SECOND defect in the same corner, not fixed here: an INSTANCE
# method of a shared-name class, called across a bundle boundary, dispatches through a vtable slot the
# library numbered differently -- the library's table has null where the consumer looks -- and the
# program crashes on the call. This test would then be measuring two things and reporting one. It
# measures the link, which is what was fixed; the dispatch defect is written up with its reproduction
# in the notes and needs the slot remap to follow a qualified class key.
#
# Required -D args: POLARON, WORKDIR

set(lib "${WORKDIR}/sharedname_fixtures/writerlib")
set(app "${WORKDIR}/sharedname_app")
file(REMOVE_RECURSE "${lib}" "${app}")
file(MAKE_DIRECTORY "${lib}/src" "${app}/src")

file(WRITE "${lib}/polaron.toml"
"[polaron_project]\n[library]\nname = \"writerlib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/ByteWriter.pol\"\n")
# The name is deliberately one the standard library also declares (System.Net.Tls.ByteWriter).
file(WRITE "${lib}/src/ByteWriter.pol"
"program WriterLib;\npublic bundle WriterLib {\n    public namespace Io {\n        public class ByteWriter {\n            public static method widthOf(int n) returns int { return n + 2; }\n        }\n    }\n}\n")

file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/Main.pol\"\n\n[dependencies]\nwriterlib = { path = \"${lib}\" }\n")
file(WRITE "${app}/src/Main.pol"
"import System.IO.Console;\nimport WriterLib.Io.ByteWriter;\nprogram Consumer;\npublic bundle Consumer {\n    public namespace App {\n        public class Main {\n            public static method main(string[] args) returns void {\n                System.IO.Console.printf(\"written = %d\\n\", ByteWriter.widthOf(40));\n                return;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the consumer failed (exit ${rc}). `duplicate symbol: System.…` means a .polb is "
                        "carrying the standard library's classes with strong linkage again:\n${err}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "written = 42")
    message(FATAL_ERROR "expected 'written = 42', got: [${out}]")
endif()

message(STATUS "OK: a library may share a short name with the standard library")
