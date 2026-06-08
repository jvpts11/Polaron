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

# The LLVM IR codegen backend is wired in from M1, once the dev SDK
# (vcpkg: llvm:x64-windows) finishes building. Until then the frontend
# builds without it so the pipeline stays green.
option(LDP3_WITH_LLVM "Build the LLVM IR codegen backend" OFF)
if(LDP3_WITH_LLVM)
    find_package(LLVM REQUIRED CONFIG)
    message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION} (${LLVM_DIR})")
endif()

# Compiler driver. Phase by phase this grows into lexer -> parser ->
# semantic -> codegen; for now (M0) it is a thin CLI over file reading.
add_executable(ldp3c src/cli/main.cpp)
target_include_directories(ldp3c PRIVATE src)

enable_testing()
add_subdirectory(tests)
