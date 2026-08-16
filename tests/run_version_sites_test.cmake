# The toolchain version is written down in six places, and a bump that misses one ships a lie.
#
# This has happened three times. polc said 1.0.0 while polaron said 1.0.13; cli_version was left
# behind at 1.0.18; and the language reference's version stamp sat at 1.0.16 while the compiler was
# at 1.0.46 -- thirty versions of drift, because the only two sites anyone tested were the two that
# had a test. Pinning each site individually is what produced that: a site with no test drifts.
#
# So instead of six pinned constants, one canonical source (polc's kVersion) and a check that every
# other site repeats it. A new site is added to SITES below and is then covered forever.
#
#   cmake -DROOT=<repo root> -P run_version_sites_test.cmake

if(NOT DEFINED ROOT)
    message(FATAL_ERROR "run_version_sites_test: -DROOT=<repo root> is required")
endif()

# ---- the canonical version: what `polc --version` prints ----
file(READ "${ROOT}/src/cli/main.cpp" cli)
if(NOT cli MATCHES "kVersion = \"polc ([0-9]+\\.[0-9]+\\.[0-9]+)\"")
    message(FATAL_ERROR "run_version_sites_test: no kVersion in src/cli/main.cpp -- the canonical site moved")
endif()
set(version "${CMAKE_MATCH_1}")
message(STATUS "canonical version: ${version}")

# ---- every other site, and the exact spelling it must carry ----
# The two CTest regexes spell the dots `\\.` in the CMake source, so that is what the file holds.
string(REPLACE "." "\\\\." dotted "${version}")
set(SITES
    "src/driver/polaron_main.cpp|kVersion = \"polaron ${version}\""
    "installer/build-msi.ps1|[string]$Version = \"${version}\""
    "installer/polaron.wxs|Version=\"${version}.0\""
    "docs/reference/make-pdf.py|VERSION = \"${version}\""
    "tests/CMakeLists.txt|PASS_REGULAR_EXPRESSION \"polc ${dotted}\""
    "tests/CMakeLists.txt|PASS_REGULAR_EXPRESSION \"polaron ${dotted}\""
)

set(stale "")
foreach(site IN LISTS SITES)
    string(FIND "${site}" "|" bar)
    string(SUBSTRING "${site}" 0 ${bar} relative)
    math(EXPR after "${bar} + 1")
    string(SUBSTRING "${site}" ${after} -1 expected)

    if(NOT EXISTS "${ROOT}/${relative}")
        list(APPEND stale "${relative}: file is gone -- update SITES in run_version_sites_test.cmake")
        continue()
    endif()
    file(READ "${ROOT}/${relative}" body)
    string(FIND "${body}" "${expected}" found)
    if(found EQUAL -1)
        list(APPEND stale "${relative}: does not carry `${expected}`")
    else()
        message(STATUS "  ok  ${relative}")
    endif()
endforeach()

if(stale)
    string(REPLACE ";" "\n  " report "${stale}")
    message(FATAL_ERROR
        "the version bump to ${version} did not reach every site:\n  ${report}\n"
        "Bump each one to match polc's kVersion, which is the canonical version.")
endif()
