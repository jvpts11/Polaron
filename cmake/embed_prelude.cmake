# Wraps the standard library source in the raw string literals the compiler embeds.
#
# The prelude used to BE that literal, written inline in src/cli/main.cpp: 9 629 lines of Polaron inside
# 10 807 lines of "C++", 89% of which were not C++. The compiler could not see its own standard
# library as code -- no highlighting, no formatter, no LSP, no `go to definition` -- and editing it
# meant editing a ten-thousand-line C++ file. Diagnostics pointed at a `<prelude>` that was not a
# file anyone could open.
#
# Generating it here keeps the property the literal was for -- one self-contained binary, nothing to
# ship beside it -- and gives back the one it cost: a source file that is a source file.
#
# THE CHUNKING, and why it belongs here rather than in the .pol:
#
# MSVC accepts at most 65 535 characters in one string literal, and reports the overflow as
# `error C2026: string too big, TRAILING CHARACTERS TRUNCATED` -- which is not a refusal but a
# prelude quietly missing its tail. The library used to stay under that by carrying the C++ delimiters
# INSIDE the Polaron source: about 130 pairs of `)Polaron"` / `R"Polaron(` scattered through it, one every
# seventy lines or so, which every reader and every tool had to ignore.
#
# Cutting the text here instead removes all of them. Adjacent string literals are concatenated by the
# preprocessor before anything looks at their contents, so a chunk may end at ANY byte -- the split is
# invisible to the parser, and the .pol files go back to being only Polaron.
#
# THE LIBRARY IS ONE FILE PER SUBJECT, under src/prelude/lib/, and this assembles them.
#
# It was a single 9 540-line file. Splitting it is not cosmetics: it is what makes every later step
# small -- moving a type between subjects becomes a diff in two files instead of a diff in one file
# that everything else also lives in. It costs nothing at compile time, because the pieces are
# concatenated back into one source before anything parses them, exactly as before.
#
# ORDER MATTERS ONLY FOR READING, not for the compiler: declarations resolve across the whole bundle
# regardless of sequence, and same-named namespace blocks merge (the library already relied on that
# -- `Math` is declared in two places). It is sorted so the foundations come first anyway, because
# the assembled file is what a diagnostic points into.
set(PRELUDE_ORDER
    Runtime Memory Memory.Units Errors Collections Algorithms Text Codecs Math Time
    IO OS Net Concurrency Ipc Json Formats Compress Security Events Ecs App Test)

# Required -D args: PRELUDE_DIR, PRELUDE_OUT
# TWELVE THOUSAND, AND THE 65 535 ABOVE IS THE WRONG NUMBER FOR A RAW STRING.
#
# 65 535 is MSVC's limit for an ordinary string literal. A RAW one -- `R"tag( ... )tag"` -- is cut off
# far earlier: measured on MSVC 14.51 (Visual Studio 18), a 50 000-byte raw literal reports C2026
# roughly every sixteen thousand bytes, so the limit that actually binds is about 16 384. The error
# is the dangerous kind: "trailing characters TRUNCATED" is not a refusal, it is a standard library
# quietly missing its tail, and a compiler built that way fails much later with a type it cannot find.
#
# Twelve thousand leaves room under 16 384 for whatever a line of the library grows into, and costs
# only a few more adjacent literals -- which the preprocessor joins before anything reads them.
set(_CHUNK 12000)

set(_prelude "program __prelude;\npublic bundle System {\n")
foreach(_subject IN LISTS PRELUDE_ORDER)
    if("${_subject}" IN_LIST PRELUDE_OMIT)
        continue()
    endif()
    set(_f "${PRELUDE_DIR}/lib/${_subject}.pol")
    if(NOT EXISTS "${_f}")
        message(FATAL_ERROR
            "prelude: PRELUDE_ORDER names '${_subject}' but ${_f} does not exist.\n"
            "  Either the file was renamed and the list was not, or the list gained a typo.")
    endif()
    file(READ "${_f}" _part)
    string(APPEND _prelude "${_part}")
endforeach()
string(APPEND _prelude "}\n")

# Every .pol under lib/ must be named in PRELUDE_ORDER: a subject added to the directory and
# forgotten here would vanish from the library silently, which is the one failure this cannot afford.
#
# `-DPRELUDE_OMIT=A;B` deliberately leaves subjects out -- for measuring what a subject costs, which
# is otherwise impossible to do without editing this file and tripping the check below. Omitting is a
# loud, temporary thing: it prints what it dropped, so a build configured that way and forgotten
# cannot be mistaken for a normal one.
if(PRELUDE_OMIT)
    message(WARNING "prelude: OMITTING ${PRELUDE_OMIT} -- this build's standard library is INCOMPLETE")
endif()
file(GLOB _found "${PRELUDE_DIR}/lib/*.pol")
foreach(_f IN LISTS _found)
    get_filename_component(_full "${_f}" NAME)
    string(REGEX REPLACE "\\.pol$" "" _n "${_full}")
    if(NOT "${_n}" IN_LIST PRELUDE_ORDER AND NOT "${_n}" IN_LIST PRELUDE_OMIT)
        message(FATAL_ERROR
            "prelude: src/prelude/lib/${_full} exists but '${_n}' is not named in PRELUDE_ORDER.\n"
            "  Every subject file must be listed there, or it would vanish from the standard library\n"
            "  with no other sign. Add '${_n}' to PRELUDE_ORDER in cmake/embed_prelude.cmake,\n"
            "  or pass -DPRELUDE_OMIT=${_n} if you are deliberately measuring without it.")
    endif()
endforeach()

string(LENGTH "${_prelude}" _len)

set(_body "")
set(_pos 0)
while(_pos LESS _len)
    math(EXPR _remain "${_len} - ${_pos}")
    set(_take ${_CHUNK})
    if(_remain LESS _take)
        set(_take ${_remain})
    endif()
    string(SUBSTRING "${_prelude}" ${_pos} ${_take} _chunk)
    string(APPEND _body "R\"Polaron(${_chunk})Polaron\"\n")
    math(EXPR _pos "${_pos} + ${_take}")
endwhile()

file(WRITE "${PRELUDE_OUT}"
"// GENERATED by cmake/embed_prelude.cmake from src/prelude/prelude.pol -- do not edit.
// Edit the .pol source instead; this file is rewritten whenever it changes.
#pragma once
#include <string_view>

// Not constexpr: the literal is ~400 KB, past the 64 KB a standard C++ compiler must accept in a
// constant expression (clang enforces this; MSVC is lenient). It is only parsed at run time, so a
// plain const string_view over the static literal is all that is needed.
//
// Emitted as several adjacent literals rather than one -- see the chunking note in the generator.
const std::string_view kPreludeSource =
${_body};
")
