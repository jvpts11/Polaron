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

# The LLVM IR codegen backend is wired in from the codegen milestone, once the
# dev SDK (vcpkg: llvm:x64-windows) finishes building. Until then the frontend
# builds without it so the pipeline stays green.
option(LDP3_WITH_LLVM "Build the LLVM IR codegen backend" OFF)
if(LDP3_WITH_LLVM)
    find_package(LLVM REQUIRED CONFIG)
    message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION} (${LLVM_DIR})")
endif()

# Compiler core. Phase by phase this grows: lexer (now) -> parser -> semantic
# -> codegen.
add_library(ldp3_core
    src/lexer/token.cpp
    src/lexer/lexer.cpp
)
target_include_directories(ldp3_core PUBLIC src)

add_executable(ldp3c src/cli/main.cpp)
target_link_libraries(ldp3c PRIVATE ldp3_core)

enable_testing()
add_subdirectory(tests)
