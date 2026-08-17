# The reference documents every keyword and every diagnostic code, checked mechanically.
#
# A manual has one failure mode above all others: the language moves and the pages do not. It is not
# noticed, because nothing reads a manual looking for absences. Tonight nine keywords were missing --
# `transformer`, `applies`, `entrusts`, `call`, `procedure`, `weak`, `naked`, `interrupt`, `unknown` --
# every one of them from a feature added after the chapter was written, and eighty of the eighty-two
# diagnostic codes were absent from the chapter that lists diagnostic codes.
#
# So the two lists that CAN be derived from the compiler are derived from it and compared. A feature
# added without a word about it here fails this test at the moment it is added, which is the only time
# fixing it is cheap.
#
# Required -D args: POLC, ROOT

set(kwDoc "${ROOT}/docs/reference/guide/12-keyword-reference.md")
set(diagDoc "${ROOT}/docs/reference/guide/13-diagnostics.md")
foreach(f "${kwDoc}" "${diagDoc}")
    if(NOT EXISTS "${f}")
        message(FATAL_ERROR "the reference chapter is missing: ${f}")
    endif()
endforeach()
file(READ "${kwDoc}" kwText)
file(READ "${diagDoc}" diagText)

# ---- every keyword the lexer reserves ----
file(READ "${ROOT}/src/lexer/lexer.cpp" lexer)
string(REGEX MATCHALL "\\{\"[a-z_]+\", TokenKind::" kwHits "${lexer}")
set(missingKw "")
set(kwCount 0)
foreach(hit IN LISTS kwHits)
    string(REGEX REPLACE "^\\{\"([a-z_]+)\".*$" "\\1" kw "${hit}")
    math(EXPR kwCount "${kwCount} + 1")
    if(NOT kwText MATCHES "`${kw}`")
        list(APPEND missingKw "${kw}")
    endif()
endforeach()

# ---- every diagnostic code the compiler can emit ----
execute_process(COMMAND "${POLC}" --explain OUTPUT_VARIABLE explained RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --explain failed (exit ${rc})")
endif()
string(REGEX MATCHALL "Polaron-[0-9A-Fa-f]+[a-z]?" codes "${explained}")
list(REMOVE_DUPLICATES codes)
set(missingCode "")
foreach(code IN LISTS codes)
    if(NOT diagText MATCHES "${code}")
        list(APPEND missingCode "${code}")
    endif()
endforeach()

if(missingKw OR missingCode)
    set(report "")
    if(missingKw)
        string(REPLACE ";" ", " kwList "${missingKw}")
        string(APPEND report "\n  keywords absent from 12-keyword-reference.md: ${kwList}")
    endif()
    if(missingCode)
        string(REPLACE ";" ", " codeList "${missingCode}")
        string(APPEND report "\n  diagnostic codes absent from 13-diagnostics.md: ${codeList}")
    endif()
    message(FATAL_ERROR "the reference no longer covers the language:${report}\n"
                        "Document each one where it belongs; `polc --explain <code>` has the text for a code.")
endif()

list(LENGTH codes codeCount)
message(STATUS "OK: ${kwCount} keywords and ${codeCount} diagnostic codes, all documented")
