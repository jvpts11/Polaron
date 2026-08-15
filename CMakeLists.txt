cmake_minimum_required(VERSION 3.20)
project(polaron LANGUAGES C CXX)  # C is enabled for LLVM's FindFFI probe on Linux

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

if(MSVC)
    add_compile_options(/W4 /permissive-)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Compiler core. Phase by phase: lexer -> parser -> semantic -> codegen.
set(POLARON_CORE_SOURCES
    src/lexer/token.cpp
    src/lexer/lexer.cpp
    src/parser/ast.cpp
    src/parser/parser.cpp
    src/parser/monomorphize.cpp
    src/parser/ipc.cpp  # spec 2.8: IPC proxy + dispatcher synthesis
    src/parser/loopopt.cpp
    src/parser/boundscheck.cpp
    src/parser/transformers.cpp  # `applies`: a transformer's members land in the type that takes it
    src/semantic/analyzer.cpp src/semantic/analyzer_typeof.cpp src/semantic/analyzer_stmt.cpp
    src/semantic/semutil.cpp  # the analyser's pure helpers: name suggestions, type-name questions
    src/semantic/comptime.cpp
    src/semantic/asmcheck.cpp  # semantic analysis of inline assembly, per architecture and dialect
    src/semantic/implicitthis.cpp  # a bare name finds the enclosing class's own member
    src/semantic/layouts.cpp  # `layout`: an interface for memory, implemented by value aggregates
    src/diag/catalog.cpp  # rich-diagnostic catalog: why/fix/prevent per error code
    src/diag/render.cpp   # rich-diagnostic renderer: snippet + caret + sections, or one concise line
    src/bundle/polh.cpp  # public-API header (.polh) generation; AST-only, no LLVM
    src/bundle/polb.cpp  # .polb container read/write + SHA-256 fingerprint; self-contained, no LLVM
    src/doc/htmldoc.cpp # `polaron doc`: HTML API docs from /// comments; AST-only, no LLVM
    src/fmt/formatter.cpp  # `polaron fmt`: token-reflow formatter; lexer-only, no LLVM
)

# The codegen backend needs the LLVM dev SDK (vcpkg: llvm:x64-windows).
# Configure with -DPOLARON_WITH_LLVM=ON and the vcpkg toolchain file.
option(POLARON_WITH_LLVM "Build the LLVM IR codegen backend" OFF)
if(POLARON_WITH_LLVM)
    find_package(LLVM REQUIRED CONFIG)
    message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION} (${LLVM_DIR})")
    add_definitions(${LLVM_DEFINITIONS})
    # The code generator, split. `codegen.cpp` is now only the public facade over `CodeGenerator::Impl`,
    # which is declared in the private header `codegen_impl.h`; the four files beside it define the
    # members that were too large to leave inline. Splitting one class across translation units needs
    # its declaration in a header, which is what that header exists for -- see its own comment.
    list(APPEND POLARON_CORE_SOURCES
        src/codegen/codegen.cpp
        src/codegen/codegen_call.cpp
        src/codegen/codegen_expr.cpp
        src/codegen/codegen_stmt.cpp
        src/codegen/codegen_types.cpp
        src/codegen/codegen_layout.cpp
        src/codegen/codegen_emit.cpp
        src/codegen/codegen_module.cpp
        src/codegen/codegen_entry.cpp
        src/codegen/cgutil.cpp)
endif()

add_library(polaron_core ${POLARON_CORE_SOURCES})
target_include_directories(polaron_core PUBLIC src)

if(POLARON_WITH_LLVM)
    target_include_directories(polaron_core SYSTEM PUBLIC ${LLVM_INCLUDE_DIRS})
    target_compile_definitions(polaron_core PUBLIC POLARON_WITH_LLVM=1)
    # core: IRBuilder/module. passes: our in-process optimization pipeline (PassBuilder) -- polc
    # runs its own middle-end passes (the transforms clang's default pipeline omits) before handing
    # the IR to clang for backend + link.
    # irreader: `polc --extract-code --remap-slots` parses a dependency's module back in to renumber
    # its vtables into the consuming program's merged slot layout (see extractCode in cli/main.cpp).
    llvm_map_components_to_libnames(POLARON_LLVM_LIBS core passes bitwriter irreader)
    target_link_libraries(polaron_core PUBLIC ${POLARON_LLVM_LIBS})
endif()

# The standard library is a REAL SOURCE FILE, src/prelude/prelude.pol, wrapped into the raw string
# literal the compiler embeds. It used to be written inline in main.cpp -- 9 629 lines of Polaron inside
# 10 807 lines of "C++" -- where none of this project's own tooling could see it. Generating it keeps
# the self-contained binary and gives the source back its file.
set(POLARON_PRELUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/prelude")
# CONFIGURE_DEPENDS, and it is not optional here. A plain GLOB is evaluated once, at configure time,
# so a subject file added afterwards is in no dependency list -- and the consequence is worse than
# "the new file is ignored": every later EDIT to that file is invisible too, because the build has no
# record that it exists. The standard library then silently keeps compiling from the last generated
# header, and the compiler runs against a version of its own library that is no longer on disk.
#
# Measured the hard way twice while adding subjects: a fix to a brand-new .pol changed nothing, twice,
# and the second time the generated header still held the text the source no longer had.
file(GLOB POLARON_PRELUDE_PARTS CONFIGURE_DEPENDS "${POLARON_PRELUDE_DIR}/lib/*.pol")
set(POLARON_PRELUDE_HDR "${CMAKE_BINARY_DIR}/generated/prelude_source.h")
add_custom_command(
    OUTPUT "${POLARON_PRELUDE_HDR}"
    COMMAND "${CMAKE_COMMAND}"
            "-DPRELUDE_DIR=${POLARON_PRELUDE_DIR}"
            "-DPRELUDE_OUT=${POLARON_PRELUDE_HDR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/embed_prelude.cmake"
    DEPENDS ${POLARON_PRELUDE_PARTS} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/embed_prelude.cmake"
    COMMENT "Embedding the standard library from src/prelude/lib/*.pol"
    VERBATIM)
add_custom_target(polaron_prelude DEPENDS "${POLARON_PRELUDE_HDR}")

add_executable(polc src/cli/main.cpp "${POLARON_PRELUDE_HDR}")
add_dependencies(polc polaron_prelude)
target_include_directories(polc PRIVATE "${CMAKE_BINARY_DIR}/generated")
target_link_libraries(polc PRIVATE polaron_core)
# Reserve a large stack: several compiler passes (parse, sema, codegen, and LLVM's own recursion) descend
# recursively over the whole program, so the 1 MB default overflows on big inputs (a large multi-file
# program like the Forge IDE). 256 MB reserve keeps deep-but-bounded recursion well inside the stack.
#
# THE FLAG FOLLOWS THE LINKER, NOT THE COMPILER, and branching on `MSVC` got that wrong. Building the
# compiler itself with clang++ on Windows takes the `else` branch and hands `-Wl,-z,stacksize=...` to
# lld-link, which knows no `-z` and reads the rest as a FILENAME:
#
#     lld-link: error: could not open 'stacksize=268435456': no such file or directory
#
# -- an error about a missing file, for a flag. Everything compiled; only the final link failed.
if(WIN32)
    if(MSVC)
        target_link_options(polc PRIVATE /STACK:268435456)      # cl/clang-cl driver
    else()
        target_link_options(polc PRIVATE -Wl,/stack:268435456)  # clang++ driver over lld-link
    endif()
else()
    target_link_options(polc PRIVATE -Wl,-z,stacksize=268435456)
endif()

# Prebuilt runtime linked into every Polaron program, placed next to the binaries so the driver finds it
# as a sibling of polaron.exe.
add_library(polaron_rt STATIC runtime/polaron_rt.cpp)
set_target_properties(polaron_rt PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

# Locate clang for the driver's compile-time default (same lookup the tests use).
#
# The standalone install is searched FIRST and on its own, because `HINTS` loses to the prefix path
# that vcpkg's toolchain file installs -- so a plain `find_program(... HINTS ...)` quietly picked
# vcpkg's clang 18 while a 22 sat in Program Files. That mattered the day the runtime's C headers
# became C++ ones: MSVC 14.51's <cstdio> static_asserts a minimum clang version, and the build failed
# inside `yvals_core.h` with "error STL1000: Unexpected compiler version" -- a message about the
# standard library, pointing nowhere near the toolchain that chose itself.
find_program(POLARON_CLANG clang PATHS "C:/Program Files/LLVM/bin" NO_DEFAULT_PATH)
if(NOT POLARON_CLANG)
    find_program(POLARON_CLANG clang)
endif()
if(NOT POLARON_CLANG)
    set(POLARON_CLANG "clang")  # fall back to a PATH lookup at run time
endif()
# Say which one was chosen and how old it is. The runtime is compiled with it AND includes the MSVC
# standard headers, so "too old" is a real, checkable condition rather than a matter of taste.
if(POLARON_CLANG AND NOT POLARON_CLANG STREQUAL "clang")
    execute_process(COMMAND "${POLARON_CLANG}" --version
                    OUTPUT_VARIABLE POLARON_CLANG_VERSION_TEXT
                    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX MATCH "clang version ([0-9]+)" _ "${POLARON_CLANG_VERSION_TEXT}")
    set(POLARON_CLANG_MAJOR "${CMAKE_MATCH_1}")
    message(STATUS "Using clang ${POLARON_CLANG_MAJOR} at ${POLARON_CLANG}")
    if(POLARON_CLANG_MAJOR AND POLARON_CLANG_MAJOR LESS 20)
        message(WARNING
            "clang ${POLARON_CLANG_MAJOR} is older than the MSVC C++ headers accept (they require 20+). "
            "The runtime includes <cstdio>, so this will fail with 'error STL1000: Unexpected compiler "
            "version' inside yvals_core.h. Install a newer LLVM or set POLARON_CLANG to one.")
    endif()
endif()
configure_file(src/driver/config.h.in "${CMAKE_BINARY_DIR}/polaron_config.h" @ONLY)

# The region core (runtime/polaron_region_core.hpp) is compiled TWICE: once into polaron_rt above, and once for
# the bare-metal target by `polaron build`. Embed its text in the driver so the second compilation uses the
# very same source rather than a copy that drifts. configure_file makes the header a configure-time
# dependency, so editing it regenerates this automatically.
#
# Emitted as SEVERAL adjacent raw literals rather than one. MSVC caps a single string literal at 16380
# bytes (C2026) and the core is past that, so one literal builds under clang and fails under the
# toolset this repository targets. Adjacent literals concatenate, so the value is identical either way
# and the chunk size is nobody's business but this loop's.
file(READ runtime/polaron_region_core.hpp POLARON_REGION_CORE_RAW)
string(LENGTH "${POLARON_REGION_CORE_RAW}" POLARON_RC_LEN)
set(POLARON_REGION_CORE_SRC "")
set(POLARON_RC_POS 0)
while(POLARON_RC_POS LESS POLARON_RC_LEN)
    math(EXPR POLARON_RC_TAKE "${POLARON_RC_LEN} - ${POLARON_RC_POS}")
    if(POLARON_RC_TAKE GREATER 8000)
        set(POLARON_RC_TAKE 8000)
    endif()
    string(SUBSTRING "${POLARON_REGION_CORE_RAW}" ${POLARON_RC_POS} ${POLARON_RC_TAKE} POLARON_RC_CHUNK)
    string(APPEND POLARON_REGION_CORE_SRC "R\"POLARONRC(${POLARON_RC_CHUNK})POLARONRC\"\n")
    math(EXPR POLARON_RC_POS "${POLARON_RC_POS} + ${POLARON_RC_TAKE}")
endwhile()
configure_file(src/driver/region_core_src.h.in "${CMAKE_BINARY_DIR}/polaron_region_core_src.h" @ONLY)

# The HEAP core travels the same way, and for a sharper reason. `__polaron_malloc` was written against
# libc and lived only in the hosted runtime, so a target without a C library had no heap at all: a
# WebAssembly module could compute but could not run `on heap`, hold a `String`, or use anything the
# prelude allocates. That is what made wasm a patch rather than a port, and the same hole was under
# every other architecture -- hidden only because pico wrote its own allocator and nobody else tried.
# Embedding the source here is what makes "the same heap, everywhere" true rather than aspirational.
#
# AND THE FILE HAS TO BE A CONFIGURE DEPENDENCY, which `file(READ)` alone does not make it.
#
# `configure_file` registers the `.in` template, not the source read into it, so editing the header
# below left the embedded copy at whatever it said when CMake last ran -- and the build SUCCEEDED,
# because a stale copy is still valid C++. It cost an hour: the driver kept writing version one of a
# header while the tree held version two, the freestanding heap silently failed to be emitted, and the
# only symptom was two undefined symbols in a wasm module. A generated artifact that can go stale
# without saying so is worse than one that is regenerated too often.
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
    runtime/polaron_region_core.hpp runtime/polaron_alloc_core.hpp)
file(READ runtime/polaron_alloc_core.hpp POLARON_ALLOC_CORE_RAW)
string(LENGTH "${POLARON_ALLOC_CORE_RAW}" POLARON_AC_LEN)
set(POLARON_ALLOC_CORE_SRC "")
set(POLARON_AC_POS 0)
while(POLARON_AC_POS LESS POLARON_AC_LEN)
    math(EXPR POLARON_AC_TAKE "${POLARON_AC_LEN} - ${POLARON_AC_POS}")
    if(POLARON_AC_TAKE GREATER 8000)
        set(POLARON_AC_TAKE 8000)
    endif()
    string(SUBSTRING "${POLARON_ALLOC_CORE_RAW}" ${POLARON_AC_POS} ${POLARON_AC_TAKE} POLARON_AC_CHUNK)
    string(APPEND POLARON_ALLOC_CORE_SRC "R\"POLARONAC(${POLARON_AC_CHUNK})POLARONAC\"\n")
    math(EXPR POLARON_AC_POS "${POLARON_AC_POS} + ${POLARON_AC_TAKE}")
endwhile()
configure_file(src/driver/alloc_core_src.h.in "${CMAKE_BINARY_DIR}/polaron_alloc_core_src.h" @ONLY)

# The lightweight toolchain driver: spawns polc + clang. No LLVM. Logic lives in a static lib so both
# the polaron binary and the unit tests can link it (modules are added task by task).
add_library(polaron_driver STATIC
    src/driver/manifest.cpp
    src/driver/scaffold.cpp
    src/driver/process.cpp
    src/driver/toolchain.cpp
    src/driver/build.cpp
    src/driver/sources.cpp
    src/driver/git.cpp
    src/driver/deps.cpp
    src/driver/environs.cpp
    src/driver/semver.cpp
    src/driver/lockfile.cpp
    src/driver/discovery.cpp
    src/driver/jsonout.cpp)
target_include_directories(polaron_driver PUBLIC src "${CMAKE_BINARY_DIR}")

# C++20 MODULE INTERFACES. A `.cppm` here replaces a header entirely: no `#pragma once`, no textual
# inclusion, and -- the part that matters -- its global-module-fragment `#include`s do not reach the
# importer. FILE_SET CXX_MODULES is what tells CMake to scan and order these ahead of the sources that
# import them; listing one as a plain source silently compiles it as an ordinary TU instead.
#
# PUBLIC rather than PRIVATE because the unit tests import these too. See docs/design/modules.md.
target_sources(polaron_driver PUBLIC FILE_SET CXX_MODULES FILES
    src/driver/semver.cppm)

# AND THE SOURCES THAT IMPORT IT MUST BE SCANNED TOO, which is not the default.
#
# CMake scans the members of the module file set and compiles every other source `unscanned`. MSVC does
# not care -- it is handed the `.ifc` with `/reference` and resolves the import from there -- so the
# Windows build was green while g++ reported `'import' does not name a type` on the first Linux build
# this project ever had. GCC needs the importing translation unit scanned so the module mapper can
# point it at the `.gcm`.
#
# One property, and it is the difference between "C++20 modules work here" and "C++20 modules work on
# the compiler I happened to try".
set_target_properties(polaron_driver PROPERTIES CXX_SCAN_FOR_MODULES ON)

add_executable(polaron src/driver/polaron_main.cpp)
target_link_libraries(polaron PRIVATE polaron_driver)

# --- polaron-studio: the TUI project/environment manager (toolchain sub-project 4) ---
# FTXUI is vendored in-tree (third_party/ftxui); build only the library, not its examples/docs/tests.
set(FTXUI_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(FTXUI_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(FTXUI_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(FTXUI_ENABLE_INSTALL OFF CACHE BOOL "" FORCE)
set(FTXUI_QUIET ON CACHE BOOL "" FORCE)
add_subdirectory(third_party/ftxui)

add_executable(polaron-studio src/studio/main.cpp src/studio/screens.cpp src/studio/engine.cpp)
target_link_libraries(polaron-studio PRIVATE polaron_driver ftxui::component)
if(MSVC)
  target_compile_options(polaron-studio PRIVATE /utf-8)  # keep the box-drawing/UTF-8 string literals intact
endif()

# --- polaron-lsp: the language server. Reuses only the compiler front-end (lexer/parser/ast) so it carries no
# LLVM; it speaks LSP over stdio for the VS Code extension's language client. ---
add_executable(polaron-lsp
    src/lsp/main.cpp
    src/lsp/json.cpp
    src/lsp/server.cpp
    src/lexer/token.cpp
    src/lexer/lexer.cpp
    src/parser/ast.cpp
    src/parser/parser.cpp)
target_include_directories(polaron-lsp PRIVATE src)
if(MSVC)
  target_compile_options(polaron-lsp PRIVATE /utf-8)
endif()

enable_testing()
add_subdirectory(tests)
