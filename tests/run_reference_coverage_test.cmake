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

# ---- and every keyword is EXPLAINED somewhere, not only defined ----
#
# The check above passes as long as a word has a glossary entry, and that is how five features stayed
# invisible: `newtype`, `typealias`, `interrupt`, `region class` and `heap class` each had a correct
# definition in chapter 12 and no page anywhere that showed how to use one. A glossary is a place to
# look a word up once you know it exists; it is not where anybody learns a feature.
#
# So the second bar is that the word appears somewhere ELSE in the reference. It is deliberately low --
# one mention in one other page clears it -- because the point is to catch the feature that was added
# and never written about, not to legislate how much prose each keyword deserves.
#
# AND IT IS A FLOOR, NOT A GUARANTEE, which is worth saying plainly rather than leaving for somebody to
# discover the hard way: several keywords are ordinary English words (`on`, `of`, `call`, `index`,
# `record`), so a page that merely uses the word in a sentence clears the bar for them. A stricter rule
# -- shown inside a code example -- was measured and rejected: it flags `fastcall`, which IS documented,
# in a table, correctly. Nothing here removes the need to read the manual as a reader would.
file(GLOB_RECURSE refPages "${ROOT}/docs/reference/*.md")
set(unexplained "")
foreach(hit IN LISTS kwHits)
    string(REGEX REPLACE "^\\{\"([a-z_]+)\".*$" "\\1" kw "${hit}")
    set(found FALSE)
    foreach(page IN LISTS refPages)
        get_filename_component(pageName "${page}" NAME)
        if(pageName STREQUAL "12-keyword-reference.md")
            continue()
        endif()
        # The WORD, not one particular way of typesetting it. Requiring backticks around exactly the
        # keyword failed on every word that is never written alone: `cast<T>`, `on heap`, `mark of
        # region`, `function<int, int>`. Those are explained at length -- the test was matching the
        # formatting rather than the coverage.
        file(READ "${page}" pageText)
        if(pageText MATCHES "(^|[^A-Za-z_])${kw}([^A-Za-z_]|$)")
            set(found TRUE)
            break()
        endif()
    endforeach()
    if(NOT found)
        list(APPEND unexplained "${kw}")
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

if(missingKw OR missingCode OR unexplained)
    set(report "")
    if(missingKw)
        string(REPLACE ";" ", " kwList "${missingKw}")
        string(APPEND report "\n  keywords absent from 12-keyword-reference.md: ${kwList}")
    endif()
    if(unexplained)
        string(REPLACE ";" ", " unexList "${unexplained}")
        string(APPEND report "\n  keywords DEFINED in chapter 12 and explained nowhere else: ${unexList}")
    endif()
    if(missingCode)
        string(REPLACE ";" ", " codeList "${missingCode}")
        string(APPEND report "\n  diagnostic codes absent from 13-diagnostics.md: ${codeList}")
    endif()
    message(FATAL_ERROR "the reference no longer covers the language:${report}\n"
                        "Document each one where it belongs -- a glossary entry alone is not coverage; "
                        "`polc --explain <code>` has the text for a code.")
endif()

list(LENGTH codes codeCount)
message(STATUS "OK: ${kwCount} keywords and ${codeCount} diagnostic codes, all documented")
