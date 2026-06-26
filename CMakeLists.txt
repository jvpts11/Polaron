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
    llvm_map_components_to_libnames(LDP3_LLVM_LIBS core passes)
    target_link_libraries(ldp3_core PUBLIC ${LDP3_LLVM_LIBS})
endif()

add_executable(ldp3c src/cli/main.cpp)
target_link_libraries(ldp3c PRIVATE ldp3_core)

enable_testing()
add_subdirectory(tests)
