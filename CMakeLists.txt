cmake_minimum_required(VERSION 3.20)
project(ldp3 LANGUAGES CXX)

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
set(LDP3_CORE_SOURCES
    src/lexer/token.cpp
    src/lexer/lexer.cpp
    src/parser/ast.cpp
    src/parser/parser.cpp
    src/parser/monomorphize.cpp
    src/parser/loopopt.cpp
    src/semantic/analyzer.cpp
    src/semantic/comptime.cpp
    src/bundle/ldh.cpp  # public-API header (.ldh) generation; AST-only, no LLVM
    src/bundle/ldb.cpp  # .ldb container read/write + SHA-256 fingerprint; self-contained, no LLVM
)

# The codegen backend needs the LLVM dev SDK (vcpkg: llvm:x64-windows).
# Configure with -DLDP3_WITH_LLVM=ON and the vcpkg toolchain file.
option(LDP3_WITH_LLVM "Build the LLVM IR codegen backend" OFF)
if(LDP3_WITH_LLVM)
    find_package(LLVM REQUIRED CONFIG)
    message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION} (${LLVM_DIR})")
    add_definitions(${LLVM_DEFINITIONS})
    list(APPEND LDP3_CORE_SOURCES src/codegen/codegen.cpp)
endif()

add_library(ldp3_core ${LDP3_CORE_SOURCES})
target_include_directories(ldp3_core PUBLIC src)

if(LDP3_WITH_LLVM)
    target_include_directories(ldp3_core SYSTEM PUBLIC ${LLVM_INCLUDE_DIRS})
    target_compile_definitions(ldp3_core PUBLIC LDP3_WITH_LLVM=1)
    # core: IRBuilder/module. passes: our in-process optimization pipeline (PassBuilder) -- ldp3c
    # runs its own middle-end passes (the transforms clang's default pipeline omits) before handing
    # the IR to clang for backend + link.
    llvm_map_components_to_libnames(LDP3_LLVM_LIBS core passes bitwriter)
    target_link_libraries(ldp3_core PUBLIC ${LDP3_LLVM_LIBS})
endif()

add_executable(ldp3c src/cli/main.cpp)
target_link_libraries(ldp3c PRIVATE ldp3_core)

# Prebuilt runtime linked into every LDP3 program, placed next to the binaries so the driver finds it
# as a sibling of ldp3.exe.
add_library(ldp3_rt STATIC runtime/ldp3_rt.cpp)
set_target_properties(ldp3_rt PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

# Locate clang for the driver's compile-time default (same lookup the tests use).
find_program(LDP3_CLANG clang HINTS "C:/Program Files/LLVM/bin")
if(NOT LDP3_CLANG)
    set(LDP3_CLANG "clang")  # fall back to a PATH lookup at run time
endif()
configure_file(src/driver/config.h.in "${CMAKE_BINARY_DIR}/ldp3_config.h" @ONLY)

# The lightweight toolchain driver: spawns ldp3c + clang. No LLVM. Logic lives in a static lib so both
# the ldp3 binary and the unit tests can link it (modules are added task by task).
add_library(ldp3_driver STATIC
    src/driver/manifest.cpp
    src/driver/scaffold.cpp
    src/driver/process.cpp
    src/driver/toolchain.cpp
    src/driver/build.cpp
    src/driver/sources.cpp
    src/driver/git.cpp
    src/driver/deps.cpp)
target_include_directories(ldp3_driver PUBLIC src "${CMAKE_BINARY_DIR}")

add_executable(ldp3 src/driver/ldp3_main.cpp)
target_link_libraries(ldp3 PRIVATE ldp3_driver)

enable_testing()
add_subdirectory(tests)
