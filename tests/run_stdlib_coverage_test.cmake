# Every public type in the standard library appears in the reference, checked mechanically.
#
# The sibling of `run_reference_coverage_test.cmake`, for the other half of the manual. That one
# derives the keyword list and the diagnostic list from the compiler; this one derives the type list
# from the prelude itself -- `src/prelude/lib/*.pol`, which IS the standard library.
#
# It was written after measuring: 109 of 338 public types had never been mentioned on any page. Not
# one of them was noticed by anybody, because a manual's absences are invisible -- nobody reads
# documentation looking for what is not in it, and the library grows in the same commits that are
# too busy to write a page. An area added without a word about it fails here at the moment it is
# added, which is the only time writing that page is cheap.
#
# WHAT COUNTS AS DOCUMENTED is the type's name appearing anywhere in the reference -- a mention in a
# table, a signature, a sentence. Deliberately weak: a strict rule (a heading per type, a signature
# per member) would be gamed by a generator, and a generated page is what this test exists to avoid.
# What it catches is the real failure, which is silence.
#
# Required -D args: ROOT

file(GLOB preludeFiles "${ROOT}/src/prelude/lib/*.pol")
if(preludeFiles STREQUAL "")
    message(FATAL_ERROR "no prelude sources under ${ROOT}/src/prelude/lib")
endif()
file(GLOB refFiles "${ROOT}/docs/reference/guide/*.md" "${ROOT}/docs/reference/stdlib/*.md")
if(refFiles STREQUAL "")
    message(FATAL_ERROR "no reference pages under ${ROOT}/docs/reference")
endif()

set(refText "")
foreach(f IN LISTS refFiles)
    file(READ "${f}" one)
    string(APPEND refText "${one}")
endforeach()

set(missing "")
set(total 0)
foreach(f IN LISTS preludeFiles)
    file(READ "${f}" src)
    # `public class Foo`, and the same for the other five kinds a type can be declared as. The
    # generic parameters are not part of the name a page writes.
    string(REGEX MATCHALL "public (class|interface|enum|record|struct|catalog|annotation) [A-Za-z_][A-Za-z0-9_]*"
           hits "${src}")
    foreach(hit IN LISTS hits)
        string(REGEX REPLACE "^public [a-z]+ " "" name "${hit}")
        math(EXPR total "${total} + 1")
        # A word boundary on both sides: `Sha` must not be satisfied by `Sha256`.
        if(NOT refText MATCHES "[^A-Za-z0-9_]${name}[^A-Za-z0-9_]")
            list(APPEND missing "${name}")
        endif()
    endforeach()
endforeach()

if(missing)
    list(REMOVE_DUPLICATES missing)
    list(LENGTH missing count)
    string(REPLACE ";" " " shown "${missing}")
    message(FATAL_ERROR
        "${count} public standard-library type(s) appear nowhere in docs/reference:\n  ${shown}\n"
        "Add them to the page their area belongs to (docs/reference/stdlib/), or to a new page and "
        "the README's index. A library nobody can read is a library nobody uses.")
endif()
message(STATUS "stdlib coverage: ${total} public type declarations, all present in the reference")
