# CTest wiring for the LDP3 compiler.
#
# Two layers: integration smoke tests over the ldp3c driver, and granular
# unit tests (doctest) over the lexer/parser/semantic libraries.

# ---- Integration tests (driver) ----
# The toolchain version lives in SIX places and every bump has to touch all of them:
#   src/cli/main.cpp (kVersion)      src/driver/ldp3_main.cpp (kVersion)
#   installer/build-msi.ps1          installer/ldp3.wxs
#   docs/reference/README.md         and the two tests below.
# The two compilers had already drifted apart before this was written down -- ldp3c said 1.0.0
# while ldp3 said 1.0.13 -- because only one test pinned a version and it pinned the stale one.
# Both are pinned now, so a half-done bump fails here instead of shipping.
add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 1\\.0\\.33")

# ---- ldp3 driver (unified toolchain) integration tests ----
add_test(NAME ldp3_version COMMAND ldp3 --version)
set_tests_properties(ldp3_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3 1\\.0\\.33")

# ldp3-studio (the TUI): renders one frame of the shell non-interactively (no clang needed).
add_test(NAME ldp3_studio_shell COMMAND "${CMAKE_COMMAND}"
    "-DSTUDIO=$<TARGET_FILE:ldp3-studio>"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_studio_selftest.cmake")
set_tests_properties(ldp3_studio_shell PROPERTIES TIMEOUT 30)

add_test(NAME ldp3_new_scaffolds
    COMMAND ldp3 new demoproj
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set_tests_properties(ldp3_new_scaffolds PROPERTIES
    PASS_REGULAR_EXPRESSION "created project 'demoproj'")

add_test(NAME ldp3_new_wrote_manifest
    COMMAND "${CMAKE_COMMAND}" -E cat "${CMAKE_CURRENT_BINARY_DIR}/demoproj/ldp3.toml")
set_tests_properties(ldp3_new_wrote_manifest PROPERTIES
    DEPENDS ldp3_new_scaffolds
    PASS_REGULAR_EXPRESSION "\\[ldp3_project\\]")

# plug/unplug: hermetic local-git fixture, cloned + compiled to a .ldb (needs ldp3c + git, not clang).
add_test(NAME ldp3_plug_unplug COMMAND "${CMAKE_COMMAND}"
    "-DLDP3=$<TARGET_FILE:ldp3>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_plug_test.cmake")
set_tests_properties(ldp3_plug_unplug PROPERTIES TIMEOUT 90)

# Version ranges: several tags, plug ^1.0.0 resolves to the highest 1.x (needs ldp3c + git, not clang).
add_test(NAME ldp3_version_range COMMAND "${CMAKE_COMMAND}"
    "-DLDP3=$<TARGET_FILE:ldp3>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_range_test.cmake")
set_tests_properties(ldp3_version_range PROPERTIES TIMEOUT 90)

# plug (no args) + lockfile: a fresh clone installs its declared deps and reproduces from the lock.
add_test(NAME ldp3_plug_all COMMAND "${CMAKE_COMMAND}"
    "-DLDP3=$<TARGET_FILE:ldp3>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_plugall_test.cmake")
set_tests_properties(ldp3_plug_all PROPERTIES TIMEOUT 90)

if(LDP3_CLANG)
    # THE RUNTIME IS COMPILED ONCE, not once per test. Every end-to-end test used to hand clang
    # `runtime/ldp3_rt.cpp`, so each of them rebuilt winsock2, windows.h and the whole runtime from
    # source to produce an object identical to the one the test before it had just produced --
    # measured at 1.63 s each, which was roughly half the wall-clock of the entire suite.
    #
    # Built here with the SAME clang the tests link with, rather than reusing the MSVC-built
    # ldp3_rt.lib: same-ABI or not, mixing the two compilers is the kind of thing that works in 656
    # tests and fails in one. Wired into the build (not a test) so it exists before anything runs,
    # whatever order ctest -j picks.
    set(LDP3_RT_OBJ "${CMAKE_CURRENT_BINARY_DIR}/ldp3_rt_clang${CMAKE_C_OUTPUT_EXTENSION}")
    add_custom_command(OUTPUT "${LDP3_RT_OBJ}"
        COMMAND "${LDP3_CLANG}" -c "${CMAKE_CURRENT_SOURCE_DIR}/../runtime/ldp3_rt.cpp"
                -o "${LDP3_RT_OBJ}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../runtime/ldp3_rt.cpp"
        COMMENT "Compiling the LDP3 runtime once for the end-to-end tests")
    add_custom_target(ldp3_rt_for_tests ALL DEPENDS "${LDP3_RT_OBJ}")

    add_test(NAME ldp3_compile_produces_exe
        COMMAND ldp3 compile "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    # No .exe in the regex: the driver names the binary hello_world.exe on Windows, hello_world on POSIX.
    set_tests_properties(ldp3_compile_produces_exe PROPERTIES
        PASS_REGULAR_EXPRESSION "wrote .*hello_world")

    add_test(NAME ldp3_build_project
        COMMAND ldp3 build
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(ldp3_build_project PROPERTIES
        DEPENDS ldp3_new_scaffolds
        PASS_REGULAR_EXPRESSION "wrote .*demoproj")

    # A debug build (-g -O0, DWARF) still compiles and links the project (a debugger's breakpoint binding
    # and variable reading are proven separately with lldb-dap).
    add_test(NAME ldp3_build_debug
        COMMAND ldp3 build --debug
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(ldp3_build_debug PROPERTIES
        DEPENDS ldp3_new_scaffolds
        PASS_REGULAR_EXPRESSION "wrote .*demoproj")

    add_test(NAME ldp3_run_bare_file
        COMMAND ldp3 run "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    set_tests_properties(ldp3_run_bare_file PROPERTIES
        PASS_REGULAR_EXPRESSION "Resultado: 42")

    add_test(NAME ldp3_clean_removes_output
        COMMAND ldp3 clean
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(ldp3_clean_removes_output PROPERTIES
        DEPENDS ldp3_build_project
        PASS_REGULAR_EXPRESSION "cleaned")

    # End to end: plug a local library and build+run a consumer that calls into it.
    add_test(NAME ldp3_dep_build COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_dep_build_test.cmake")
    set_tests_properties(ldp3_dep_build PROPERTIES TIMEOUT 90)

    # Environments: env new, plug -e into it, build a consumer that declares it, list, remove.
    add_test(NAME ldp3_environments COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_env_test.cmake")
    set_tests_properties(ldp3_environments PROPERTIES TIMEOUT 90)

    # `ldp3 fmt`: normalize whitespace, idempotently, without changing what the program does.
    add_test(NAME ldp3_fmt_command COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_fmt_test.cmake")
    set_tests_properties(ldp3_fmt_command PROPERTIES TIMEOUT 90)

    # `ldp3 doc`: render public API HTML from /// comments (parse-only, no clang needed but grouped here).
    add_test(NAME ldp3_doc_command COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_doc_test.cmake")
    set_tests_properties(ldp3_doc_command PROPERTIES TIMEOUT 60)

    # `ldp3 test`: discover and run [Test] methods, failing the command when a test fails.
    add_test(NAME ldp3_test_command COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_test_cmd_test.cmake")
    set_tests_properties(ldp3_test_command PROPERTIES TIMEOUT 90)

    # Transitive deps: plug xlib (which depends on ylib); build a consumer that links the whole closure.
    add_test(NAME ldp3_transitive_deps COMMAND "${CMAKE_COMMAND}"
        "-DLDP3=$<TARGET_FILE:ldp3>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_transitive_test.cmake")
    set_tests_properties(ldp3_transitive_deps PROPERTIES TIMEOUT 120)
endif()

add_test(NAME lexer_dumps_tokens
    COMMAND ldp3c --dump-tokens "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(lexer_dumps_tokens PROPERTIES
    PASS_REGULAR_EXPRESSION "KwProgram")

add_test(NAME parser_dumps_ast
    COMMAND ldp3c --dump-ast "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(parser_dumps_ast PROPERTIES
    PASS_REGULAR_EXPRESSION "Program 'HelloWorld'")

add_test(NAME sema_accepts_entry_point
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
set_tests_properties(sema_accepts_entry_point PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

add_test(NAME sema_rejects_no_entry
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/no_entry.ldp3")
set_tests_properties(sema_rejects_no_entry PROPERTIES
    PASS_REGULAR_EXPRESSION "no entry point")

# A field name declared twice in one class compiled silently: the layout got a slot per declaration and
# every use resolved to the last one, leaving the first as storage never written and never read. The
# method case has been rejected for a long time; the field case was simply missing, and agents-exe
# carried a dead duplicate `int[] best` for weeks with nothing noticing.
add_test(NAME sema_rejects_duplicate_field
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/duplicate_field_bad.ldp3")
set_tests_properties(sema_rejects_duplicate_field PROPERTIES
    PASS_REGULAR_EXPRESSION "field 'n' is already declared in class 'Box'")

# spec 32.11: a test that reads another class's [BeforeAll]/[AfterAll] fixture is reading state that
# class may already have torn down. It cost a whole afternoon in agents-exe, where it surfaced as an
# access violation in a suite that had printed nothing but passes. Warned, not rejected: the compiler
# cannot know the lifetime, only that the shape is the one that goes wrong.
add_test(NAME sema_warns_cross_class_fixture
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/cross_class_fixture_bad.ldp3")
set_tests_properties(sema_warns_cross_class_fixture PROPERTIES
    PASS_REGULAR_EXPRESSION "this test reads 'Fixture', which owns a \\[BeforeAll\\]/\\[AfterAll\\] fixture, from class 'Readers'")

# The RETURN must check the type of what it returns, not only its nullability (LDP3-0303). Without it,
# `return someDog;` from a method `returns Cat` produced valid IR and reinterpreted the object -- vtable
# pointer included -- because every class is an opaque `ptr` at the LLVM level. The sample also holds the
# three shapes that must KEEP compiling (a literal adapting, a narrower int widening, a subclass), so a
# fix that over-rejects fails here too instead of quietly costing everyone a cast.
add_test(NAME sema_rejects_wrong_return_type
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/return_type_bad.ldp3")
set_tests_properties(sema_rejects_wrong_return_type PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot return a value of type 'Dog' from a method returning 'Cat'")

# Signed and unsigned operands may not be mixed: `address(1) < int(-1)` answered TRUE, because -1
# sign-extends and the comparison is then unsigned. WIDTH is deliberately not the rule -- a narrower
# integer widens silently, and `address`/`ulong` are one type under two names. The sample carries five
# forms that must keep compiling, so an over-strict rule fails this test too.
add_test(NAME sema_rejects_mixed_signedness
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/mixed_signedness_bad.ldp3")
set_tests_properties(sema_rejects_mixed_signedness PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot mix signed and unsigned operands")

# The three-state flow analysis (uninitialized / valid / moved-deleted) the guide has always described
# and the implementation did not have. The parser used to forbid the uninitialized state outright, so it
# could not arise. This file holds the REJECTIONS; flow_states.ldp3 holds the shapes that must keep
# compiling, so a too-strict analysis fails that one and a too-loose one fails this.
add_test(NAME sema_rejects_uninitialized_read
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/flow_states_bad.ldp3")
set_tests_properties(sema_rejects_uninitialized_read PROPERTIES
    PASS_REGULAR_EXPRESSION "is used before it is initialized")

# Null safety has its OWN code (LDP3-0300). Folded into LDP3-0301 it inherited that code's advice --
# "convert explicitly with cast<T>(value)" -- which cannot work, because casting does not turn null into
# a non-nullable value. Pins the CODE, not the prose, so the wording stays free to improve.
add_test(NAME sema_null_error_has_own_code
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/null_to_nonnullable_bad.ldp3")
set_tests_properties(sema_null_error_has_own_code PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0300")

# --check accepts a whole program spanning several files (what an editor checks), not just one file.
add_test(NAME check_accepts_multifile_program
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_b.ldp3"
                          "${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_a.ldp3")
set_tests_properties(check_accepts_multifile_program PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

# --overlay: the bytes come from a scratch copy (an unsaved buffer), the diagnostics name the real file.
# The clean base checks clean; overlaid with the broken scratch, the error is reported -- against the base.
add_test(NAME check_base_is_clean
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.ldp3")
set_tests_properties(check_base_is_clean PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

add_test(NAME check_overlay_reports_against_the_real_file
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.ldp3"
            --overlay "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.ldp3=${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_broken.ldp3")
set_tests_properties(check_overlay_reports_against_the_real_file PROPERTIES
    WILL_FAIL TRUE)

# The same run, checking the diagnostic names overlay_base (the real file), not overlay_broken (the scratch).
add_test(NAME check_overlay_names_the_base_not_the_scratch
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.ldp3"
            --overlay "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.ldp3=${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_broken.ldp3")
set_tests_properties(check_overlay_names_the_base_not_the_scratch PROPERTIES
    PASS_REGULAR_EXPRESSION "overlay_base.ldp3:[0-9]+:[0-9]+: error\\[LDP3-[0-9]+\\]: use of undeclared variable 'undeclaredHere'")

# A name error offers "did you mean?" with the closest field / local (what powers the editor quick fix).
add_test(NAME check_suggests_the_closest_field
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.ldp3")
set_tests_properties(check_suggests_the_closest_field PROPERTIES
    PASS_REGULAR_EXPRESSION "no field 'heigth'; did you mean 'height'")

add_test(NAME check_suggests_the_closest_local
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.ldp3")
set_tests_properties(check_suggests_the_closest_local PROPERTIES
    PASS_REGULAR_EXPRESSION "undeclared variable 'totl'; did you mean 'total'")

# Rich diagnostics: a normal build (not --check/-q) prints why / fix / prevent under the error, with a
# stable code and a source snippet.
add_test(NAME rich_diagnostic_has_why_fix_prevent
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.ldp3" -o "${CMAKE_CURRENT_BINARY_DIR}/dym.ll")
set_tests_properties(rich_diagnostic_has_why_fix_prevent PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-0102\\].*\n.*\n.*\n.*\n.* why: ")

# --check / -q stays one machine-parseable line per diagnostic, now carrying the code.
add_test(NAME concise_diagnostic_is_one_line_with_code
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.ldp3" -o "${CMAKE_CURRENT_BINARY_DIR}/dym.ll" -q)
set_tests_properties(concise_diagnostic_is_one_line_with_code PROPERTIES
    PASS_REGULAR_EXPRESSION "did_you_mean_bad.ldp3:[0-9]+:[0-9]+: error\\[LDP3-0102\\]: class 'Point' has no field")

# `ldp3c --explain <code>` prints a code's canonical why / fix / prevent.
add_test(NAME explain_prints_the_canonical_writeup
    COMMAND ldp3c --explain LDP3-0101)
set_tests_properties(explain_prints_the_canonical_writeup PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0101 -- not declared in this scope")

add_test(NAME explain_rejects_an_unknown_code
    COMMAND ldp3c --explain LDP3-9999)
set_tests_properties(explain_rejects_an_unknown_code PROPERTIES
    WILL_FAIL TRUE)

# Even a syntax error is rich: a stable code, a snippet, and the why/fix/prevent sections.
add_test(NAME syntax_error_is_rich
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/syntax_bad.ldp3" -o "${CMAKE_CURRENT_BINARY_DIR}/syn.ll")
set_tests_properties(syntax_error_is_rich PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-0001\\]:.*\n.*syntax_bad.ldp3:9")

# A rule-classified semantic error (immutability) is coded and rich without a per-call-site change.
add_test(NAME immutable_assignment_is_coded
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/immutable_bad.ldp3")
set_tests_properties(immutable_assignment_is_coded PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-0401\\]: cannot assign to immutable")

# Region flavor / extract diagnostics (spec 17, flavors expansion): each malformed use gets its coded,
# rich LDP3-17NN diagnostic.
add_test(NAME sema_rejects_region_two_flavors
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_twoflavors.ldp3")
set_tests_properties(sema_rejects_region_two_flavors PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1710\\]")

add_test(NAME sema_rejects_flavor_on_non_region
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_flavor_nonregion.ldp3")
set_tests_properties(sema_rejects_flavor_on_non_region PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1719\\]")

add_test(NAME sema_rejects_use_after_extract
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_use_after_extract.ldp3")
set_tests_properties(sema_rejects_use_after_extract PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1717\\]")

add_test(NAME sema_rejects_bare_extract
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_bare_extract.ldp3")
set_tests_properties(sema_rejects_bare_extract PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1720\\]")

# `weak` must qualify a pointer to a class (an object with identity); `weak int` has no target.
add_test(NAME sema_rejects_weak_nonpointer
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_bad_nonptr.ldp3")
set_tests_properties(sema_rejects_weak_nonpointer PROPERTIES
    PASS_REGULAR_EXPRESSION "'weak' requires a pointer")

add_test(NAME sema_rejects_mark_nonstack
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_mark_nonstack.ldp3")
set_tests_properties(sema_rejects_mark_nonstack PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1713\\]")

add_test(NAME sema_rejects_rollback_wrong_region
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_rollback_wrongregion.ldp3")
set_tests_properties(sema_rejects_rollback_wrong_region PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1714\\]")

add_test(NAME sema_rejects_fixedslot_no_accepts
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_fixedslot_noaccepts.ldp3")
set_tests_properties(sema_rejects_fixedslot_no_accepts PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1711\\]")

add_test(NAME sema_rejects_ring_delete
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_ring_delete.ldp3")
set_tests_properties(sema_rejects_ring_delete PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1715\\]")

add_test(NAME sema_rejects_growable_ring
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_growable_ring.ldp3")
set_tests_properties(sema_rejects_growable_ring PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1712\\]")

add_test(NAME sema_rejects_extract_inner_field
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_extract_innerfield.ldp3")
set_tests_properties(sema_rejects_extract_inner_field PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[LDP3-1718\\]")

# A catalog `extends` cycle must be reported, not crash (regression: it used to
# overflow the stack in isSubtype).
add_test(NAME sema_rejects_catalog_cycle
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_cycle.ldp3")
set_tests_properties(sema_rejects_catalog_cycle PROPERTIES
    PASS_REGULAR_EXPRESSION "catalog cycle involving")

# Wrong argument count must be a clean error, not a codegen "bad signature" crash.
add_test(NAME sema_rejects_bad_arg_count
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/arg_count_bad.ldp3")
set_tests_properties(sema_rejects_bad_arg_count PROPERTIES
    PASS_REGULAR_EXPRESSION "expects 2 argument")

# throw of a non-object must be reported (was an unchecked codegen crash).
add_test(NAME sema_rejects_throw_int
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/throw_int_bad.ldp3")
set_tests_properties(sema_rejects_throw_int PROPERTIES
    PASS_REGULAR_EXPRESSION "'throw' expects an object")

# (Removed: "catch of a non-polymorphic class" -- with Object as the universal root every class is
# polymorphic and therefore catchable, so that error scenario no longer exists.)

# a `const` initializer that is not a compile-time constant must be rejected (spec 28.1).
add_test(NAME sema_rejects_nonconst_const
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/const_nonconst_bad.ldp3")
set_tests_properties(sema_rejects_nonconst_const PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# main receives the real command-line arguments (spec 2.9): string[] args from argv.
add_test(NAME codegen_main_args_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/main_args.ldp3"
    "-DRUNARGS=foo bar baz"
    "-DCONTAINS=n=3 [foo][bar][baz]"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Regression: a pointer-to-generic type argument (HashMap<String, ArrayList<int>*>) must not corrupt the
# base ArrayList<int> instantiation (its get() must stay int, not int*).
add_test(NAME codegen_generic_ptr_typearg_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_ptr_typearg.ldp3"
    "-DEXPECTED=sum=30 size=2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Debug info (`ldp3c -g`): the .ll carries DWARF metadata (compile unit, subprograms, line locations,
# local/parameter variables) and the program stays correct when built with debug info. Line breakpoints +
# variable inspection are proven separately with lldb.
add_test(NAME codegen_debuginfo_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/debug_info.ldp3"
    "-DEXPECTED=r=42 t=15"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_debuginfo_test.cmake")

# Persistent subprocess (debugger/LSP): spawn `sort`, write lines, send EOF, read the sorted output back
# over the live pipe. Proves bidirectional stdio, unlike the one-shot Process.run.
add_test(NAME codegen_subprocess_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/subprocess.ldp3"
    "-DEXPECTED=apple banana cherry"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AES (spec 34, FIPS-197): AES-128/256 test vectors + ECB and CTR round-trips.
add_test(NAME codegen_aes_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/aes.ldp3"
    "-DCONTAINS=vec=1 ecb=1 ctr=1 changed=1 vec256=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ZonedDateTime (spec 34): an Instant read at a fixed UTC offset, with ISO-8601 formatting.
add_test(NAME codegen_zoned_datetime_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/zoned_datetime.ldp3"
    "-DCONTAINS=1969-12-31T21:00:00-03:00"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# UDP datagrams (spec 34): loopback send/receive round-trip with sender address.
add_test(NAME codegen_udp_socket_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/udp_socket.ldp3"
    "-DCONTAINS=ok=1 from=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Named concurrency primitives (spec 20): Semaphore + CountdownLatch across worker threads.
add_test(NAME codegen_concurrency_primitives_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/concurrency_primitives.ldp3"
    "-DCONTAINS=count=6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SecureRandom (spec 34): cryptographically secure randomness from the OS CSPRNG.
add_test(NAME codegen_secure_random_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/secure_random.ldp3"
    "-DCONTAINS=inRange=1 nonneg=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Environment variables (spec 34): Env.get / Env.set.
add_test(NAME codegen_env_vars_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/env_vars.ldp3"
    "-DCONTAINS=v=hello42 missing_len=0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Stopwatch (spec 34): a monotonic elapsed-time timer over the high-resolution clock.
add_test(NAME codegen_stopwatch_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stopwatch.ldp3"
    "-DCONTAINS=ok=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Deep copy of an object with an array of concrete-class elements copies the elements too (spec 5).
add_test(NAME codegen_deep_copy_array_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy_array.ldp3"
    "-DCONTAINS=a0=10 a1=20 b0=99 b1=20"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Paths.dirname/basename handle the Windows '\' separator, not only '/'.
add_test(NAME codegen_paths_windows_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/paths_windows.ldp3"
    "-DCONTAINS=baseOk=1 dirOk=1 fwdOk=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# String.toDouble (spec 4) + Env.executablePath (spec 34): float parsing and the program's own path.
add_test(NAME codegen_parse_double_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/parse_double.ldp3"
    "-DCONTAINS=a=314 b=-150 c=42 exe_ok=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A leading UTF-8 BOM (from a Windows editor) must be skipped by the lexer, not lexed as a stray char.
add_test(NAME codegen_bom_source_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bom_source.ldp3"
    "-DCONTAINS=bom ok"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Affine bounds-check hoisting (index `base + i`) in for- and while-loops + a small matmul: the versioned
# result must equal the fully-checked one.
#
# -DOPT=-O2 is the whole point of this test and it was missing. hoistBoundsChecks only runs when
# optLevel > 0, so at -O0 -- the default -- this compiled a program with every check in place and
# asserted that it printed the right answer, which it would have with the pass deleted. A bounds check
# eliminated without proof, the one failure mode that turns a safe language into an unsafe one, could
# not have been caught here.
add_test(NAME codegen_bce_affine_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DOPT=-O2"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_affine.ldp3"
    "-DCONTAINS=sum=55502"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# `address` no longer widens from/to a plain integer in hosted code: turning a number into a pointer
# is the conversion a no-exploitable-UB language has to make somebody write down. Freestanding is
# exempt -- the pico kernel does it 210 times and means every one of them.
add_test(NAME sema_rejects_address_from_int
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_int_bad.ldp3")
set_tests_properties(sema_rejects_address_from_int PROPERTIES
    PASS_REGULAR_EXPRESSION "address")

# A user type may share a simple name with a stdlib one; the stdlib keeps meaning its own.
add_test(NAME codegen_stdlib_name_shadow_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stdlib_name_shadow.ldp3"
    "-DCONTAINS=42 4 5 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...but a name the COMPILER provides cannot be taken over, because the stdlib calls it.
add_test(NAME sema_rejects_builtin_type_name
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/builtin_name_bad.ldp3")
set_tests_properties(sema_rejects_builtin_type_name PROPERTIES
    PASS_REGULAR_EXPRESSION "is a type the compiler provides")

# A lone string literal is text, not a printf format: `%` in it is a percent sign.
add_test(NAME codegen_percent_literal_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/percent_literal.ldp3"
    "-DCONTAINS=progress: 50% done"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# spec 19.6: `move T` in a signature demands `move` at the call and at the return.
add_test(NAME sema_rejects_missing_move_at_call
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/move_signature_bad.ldp3")
set_tests_properties(sema_rejects_missing_move_at_call PROPERTIES
    PASS_REGULAR_EXPRESSION "has to say so")

# A lambda body is type-checked like any other body.
add_test(NAME sema_checks_lambda_body
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_body_bad.ldp3")
set_tests_properties(sema_checks_lambda_body PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0101")

# `movable` is enforced at all four destinations a value can reach, not only at a local's declaration
# and reassignment. The sample trips the field, the argument and the return in one file.
add_test(NAME sema_rejects_movable_without_move
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/ownership_sites_bad.ldp3")
set_tests_properties(sema_rejects_movable_without_move PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0405")

# One constructor per class, for the same reason there is one method per name. A second one used to be
# accepted and its parameters APPENDED to the first's, so the error landed on the call site as
# "expects 3 arguments" -- a message with no relation to the mistake.
add_test(NAME sema_rejects_second_constructor
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/second_constructor_bad.ldp3")
set_tests_properties(sema_rejects_second_constructor PROPERTIES
    PASS_REGULAR_EXPRESSION "already has a constructor")

# `interrupt` -- the three things the declaration exists to forbid. The value of the keyword is in
# what it refuses, not in the calling convention: that is about fifty lines of codegen and LLVM
# already had it.
#
# Calling one is simulating an interrupt, which is a different thing wearing the same name.
add_test(NAME sema_rejects_interrupt_call
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_call_bad.ldp3")
set_tests_properties(sema_rejects_interrupt_call PROPERTIES
    PASS_REGULAR_EXPRESSION "an interrupt cannot be called")

# It is ENTERED, so there is no caller for a value to go back to. The one way to resume somewhere
# else is to modify the trap the hardware pushed -- which is why the parameter is not decoration.
add_test(NAME sema_rejects_interrupt_returning_value
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_returns_bad.ldp3")
set_tests_properties(sema_rejects_interrupt_returning_value PROPERTIES
    PASS_REGULAR_EXPRESSION "an interrupt must return void")

# `static` would take away the object the handler exists to reach. That object is the entire
# argument for `interrupt` being its own declaration form: a free handler has no state, an instance
# one reads `this.buffer` and `this.head`, and a kernel built on sixteen device objects needs the
# second. Accepting `static interrupt` would quietly hand the driver model back to C.
add_test(NAME sema_rejects_static_interrupt
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_static_bad.ldp3")
set_tests_properties(sema_rejects_static_interrupt PROPERTIES
    PASS_REGULAR_EXPRESSION "'static' cannot be applied to an interrupt")

# Two in one class. The duplicate is caught by the existing no-overloading rule -- an interrupt is a
# `MethodDecl` -- but that message explains "each method name must be unique" for a declaration whose
# name the author never wrote. This test pins the message to the rule the namelessness actually
# expresses, so it cannot quietly regress to the generic one.
add_test(NAME sema_rejects_two_interrupts
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_twice_bad.ldp3")
set_tests_properties(sema_rejects_two_interrupts PROPERTIES
    PASS_REGULAR_EXPRESSION "already declares an interrupt -- one device, one handler")

# The trap parameter is WORLD-SHAPED, and the two halves of that rule are what keep the portable
# meaning from becoming a portable lie. Bare metal hands over the frame the CPU pushed (an object
# with fields); a hosted world hands over a code -- a signal number, a console control type -- and
# no frame exists to point at. Getting either wrong type-checks and then delivers the wrong thing:
# a signal number reinterpreted as a pointer, or a frame that never arrives.
add_test(NAME sema_rejects_hosted_interrupt_frame
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_hosted_frame_bad.ldp3")
set_tests_properties(sema_rejects_hosted_interrupt_frame PROPERTIES
    PASS_REGULAR_EXPRESSION "a hosted interrupt is entered with a CODE")

add_test(NAME sema_rejects_freestanding_interrupt_code
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_freestanding_code_bad.ldp3")
set_tests_properties(sema_rejects_freestanding_interrupt_code PROPERTIES
    PASS_REGULAR_EXPRESSION "a freestanding interrupt receives the frame the CPU pushed")

# Rules 2 and 3 are about what the handler REACHES, and these two pin the reachability rather than
# the local case. The sample's handler is innocent on its own -- it calls one method -- and the
# allocation is two hops down. Both messages must carry the PATH: "Log.record allocates" is a fact
# about Log, and a fact about Log is not a bug; "the interrupt reaches it, via drain and record" is,
# and it is the sentence that says which of the two to change.
add_test(NAME sema_rejects_interrupt_reaching_heap
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_reaches_bad.ldp3")
set_tests_properties(sema_rejects_interrupt_reaching_heap PROPERTIES
    PASS_REGULAR_EXPRESSION "must not allocate on the heap \\(reached via drain, record\\)")

add_test(NAME sema_rejects_interrupt_reaching_shared_state
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_reaches_bad.ldp3")
set_tests_properties(sema_rejects_interrupt_reaching_shared_state PROPERTIES
    PASS_REGULAR_EXPRESSION "'Log.written' is mutable state an interrupt reaches \\(reached via drain, record\\)")

# THE TRAP IS READ-ONLY, and this is a measurement rather than caution. `x86_intrcc` takes the frame
# as `byval`, which promises the callee a private copy, so LLVM is entitled to treat writes through
# it as writes to that copy -- and does: at -O2 a plain store is deleted outright, and a `volatile`
# one lands in a scratch buffer the epilogue discards (`subq $16,%rsp` ... `addq $16,%rsp`). Both
# were compiled and read. `iretq` returns exactly where it came from either way, so a scheduler
# written this way runs forever without ever scheduling -- the precise failure this keyword exists
# to make impossible, arrived at through the keyword itself.
add_test(NAME sema_rejects_writing_the_trap
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_trap_write_bad.ldp3")
set_tests_properties(sema_rejects_writing_the_trap PROPERTIES
    PASS_REGULAR_EXPRESSION "the trap an interrupt receives is READ-ONLY")

# `atomic<T>` is one `lock`-prefixed instruction when T fits a machine word and a `__atomic_*`
# library call when it does not. Freestanding has nothing to link those against, so the declaration
# used to compile and the KERNEL failed at link time naming a symbol nobody wrote. Refused where the
# type is written instead. `interrupt_atomic_ok` is the other side of this: `atomic<int>` still
# compiles, so the check does not over-fire on the case the rules above depend on.
add_test(NAME sema_rejects_wide_atomic_freestanding
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_wide_bad.ldp3")
set_tests_properties(sema_rejects_wide_atomic_freestanding PROPERTIES
    PASS_REGULAR_EXPRESSION "is wider than a machine word")

# `transformer` -- what a type GAINS by applying it, which is the one thing none of the other
# declarations said. A procedure with no body is a SOCKET, and the error lands on the `applies` line
# because that line is where the obligation was taken on -- not inside the transformer, which is
# correct and is somebody else's file.
add_test(NAME sema_rejects_unimplemented_socket
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_socket_bad.ldp3")
set_tests_properties(sema_rejects_unimplemented_socket PROPERTIES
    PASS_REGULAR_EXPRESSION "requires `procedure label`, and does not implement it")

# Provenance is checked in BOTH directions, and both halves are needed. Without the first, a
# transformer-brought member could be written `method` and read as the type's own; without the
# second, `procedure` would quietly decay into a synonym for `method` on types that apply nothing.
# Together they are what makes provenance survive a terminal, a diff and a review -- which is what
# Java's `@Override` tries to be and fails at, because it can be left out.
add_test(NAME sema_rejects_method_for_procedure
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_method_bad.ldp3")
set_tests_properties(sema_rejects_method_for_procedure PROPERTIES
    PASS_REGULAR_EXPRESSION "is written `procedure`, not `method`")

add_test(NAME sema_rejects_procedure_without_transformer
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_procedure_bad.ldp3")
set_tests_properties(sema_rejects_procedure_without_transformer PROPERTIES
    PASS_REGULAR_EXPRESSION "no transformer this type applies declares it")

# The naming convention, `T` + stem + `er`. A WARNING, so it nudges without breaking code that
# predates it -- and it generates the name rather than only demanding one, because a diagnostic that
# says "wrong" and stops costs the reader the rename. `able`/`ible` are trimmed first, which is what
# makes the design note's own examples come out right: Describable -> TDescriber, not TDescribableer.
# `mutual`: the pair must be symmetric. Kelvin knows the way to Celsius; Celsius answers only
# Fahrenheit, so half the relation is missing and the error lands on the side that took the
# obligation on, naming the type that did not answer.
#
# Checkable ONLY because the family is per-target -- `into$Celsius` is a member you can read on
# Kelvin. With one generic body over every T there would be nothing but call sites to inspect, which
# is a different and much stronger promise. That is the capability `each` bought back.
add_test(NAME sema_rejects_asymmetric_mutual
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_mutual_bad.ldp3")
set_tests_properties(sema_rejects_asymmetric_mutual PROPERTIES
    PASS_REGULAR_EXPRESSION "is `mutual`, and 'Kelvin' implements `into<Celsius>`")

# TOTALITY, and partiality DEDUCED rather than annotated. A per-target procedure converts FROM the
# type it is written on, and a class is closed over its fields, so the conversion must cover them --
# nobody wrote `total` anywhere. The dual is what makes the rule honest: a STATIC per-target
# procedure converts *to* this type, its source is the parameter, that source is open, and it is
# fallible by construction. `Errno -> int` is total; `int -> Errno` is not, and neither needed a word.
add_test(NAME sema_rejects_partial_conversion
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_totality_bad.ldp3")
set_tests_properties(sema_rejects_partial_conversion PROPERTIES
    PASS_REGULAR_EXPRESSION "must be total -- and it never reads: fraction")

add_test(NAME sema_warns_transformer_naming
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_naming_warn.ldp3")
set_tests_properties(sema_warns_transformer_naming PROPERTIES
    PASS_REGULAR_EXPRESSION "transformer 'Describable' should be named `TDescriber`")

# The region binder is ON by default. Returning a pointer to an object in this method's own frame is
# rejected -- the gap the analysis was named for and did not close until now.
add_test(NAME sema_rejects_escape_by_return
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_return_bad.ldp3")
set_tests_properties(sema_rejects_escape_by_return PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-1721")

# ...and `--no-region-binder` compiles that same program. There is no safe dialect in which you hand
# out a pointer to a dead frame, so the way to do it is to turn the analysis off and mean it.
add_test(NAME sema_no_region_binder_allows_escape
    COMMAND ldp3c --check --no-region-binder "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_return_bad.ldp3")
set_tests_properties(sema_no_region_binder_allows_escape PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

# What the binder must NOT complain about with it on: a heap object stored into a longer-lived field,
# and a heap object returned. Getting this wrong is why the analysis stayed switched off.
add_test(NAME codegen_escape_ok_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_ok.ldp3"
    "-DCONTAINS=sum=6 loose=10"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A static field may be written in terms of other static fields, in any order. This folded to nothing
# and emitted `i32 0` with no diagnostic until LDP3-0608 existed -- see the sample for what that cost.
add_test(NAME codegen_static_from_static_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_from_static.ldp3"
    "-DCONTAINS=statics fold"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and one that cannot be evaluated in any order is an error, not a zero. Pinned on the CODE and
# not the prose, which is the pattern every new rejection test follows.
add_test(NAME codegen_rejects_static_init_cycle
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/static_init_not_const_bad.ldp3"
            -o "${CMAKE_CURRENT_BINARY_DIR}/static_init_not_const_bad.ll")
set_tests_properties(codegen_rejects_static_init_cycle PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0608")

# The this./ClassName. receiver on a same-class method call is optional: a bare `name(...)` resolves to
# this.name / ClassName.name (static, instance, and inside constructors) and runs.
add_test(NAME codegen_unqualified_self_call_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unqualified_self_call.ldp3"
    "-DCONTAINS=self=7 20 14"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# And the same for a FIELD: read, written, static, and inherited, all without a prefix -- with `this.`
# left in the one place it distinguishes anything, a parameter of the same name as the field it sets.
add_test(NAME codegen_implicit_this_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/implicit_this.ldp3"
    "-DEXPECTED=counter = 6 tally = 5 made = 2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...but an instance method still needs an object: calling one unqualified from a static context must fail
# with a diagnostic that names the cause and the fix, not a bare "unknown call".
add_test(NAME sema_rejects_instance_call_from_static
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/instance_from_static_bad.ldp3")
set_tests_properties(sema_rejects_instance_call_from_static PROPERTIES
    PASS_REGULAR_EXPRESSION "instance method of 'Main'.*object")

# An async method returns the value form of Result/Option (spec 20.2 + 21.2): codegen boxes the
# { tag, payload } struct through the Task's 64-bit result slot and unboxes it on await.
add_test(NAME codegen_async_value_result_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_value_result.ldp3"
    "-DEXPECTED=42 -5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# TCP server (spec 34): ServerSocket listen/accept + a client over loopback.
add_test(NAME codegen_tcp_server_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tcp_server.ldp3"
    "-DCONTAINS=reply=pong"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Directory / filesystem metadata (spec 34.4): mkdir/isDir/size/listDir.
add_test(NAME codegen_fs_directory_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fs_directory.ldp3"
    "-DCONTAINS=n=1 first=a.txt isd=1 sz=2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Process.run (spec 34): runs a subprocess and returns its captured stdout + exit code.
add_test(NAME codegen_process_run_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_run.ldp3"
    "-DCONTAINS=hello123"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A compile-time string DSL (spec 32.4): a comptime method folds a comptime string arg at compile time.
add_test(NAME codegen_comptime_string_dsl_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_string_dsl.ldp3"
    "-DCONTAINS=cols=4"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Decorator over an iterator: an interface-typed field is stored by reference, not deep-copied
# (a value copy sized by the field-less interface truncated the concrete object -> crash).
add_test(NAME codegen_interface_field_delegation_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interface_field_delegation.ldp3"
    "-DCONTAINS=sum=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A class-wrapped matrix multiply: the loop-interchange optimizer's OOP path must reorder the reduction
# only when the fresh result field provably cannot alias the inputs, keeping the result identical.
add_test(NAME codegen_matmul_class_interchange_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matmul_class_interchange.ldp3"
    "-DCONTAINS=total=49500"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Bounds-check hoisting (loop versioning): clean for-loops over arrays run an unchecked fast copy under a
# proven guard. The versioned result must equal the checked one (fill by param bound, copy, inclusive sum).
add_test(NAME codegen_bce_hoist_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DOPT=-O2"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_hoist.ldp3"
    "-DCONTAINS=sum=1498500"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A class-returning method whose body ends in while(true): the unreachable fall-through must not emit an
# i32 return on a pointer-returning function.
add_test(NAME codegen_while_true_return_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/while_true_return.ldp3"
    "-DCONTAINS=v=42"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Box-Muller gaussian sampling tracks the empirical rule (68/95) for a fixed seed; seededNow() runs.
add_test(NAME codegen_random_gaussian_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/random_gaussian.ldp3"
    "-DCONTAINS=pct1=68 pct2=95"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# BigInteger signed arithmetic: mixed-sign add/subtract, truncated divide/remainder, wide multiply.
add_test(NAME codegen_bigint_arith_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bigint_arith.ldp3"
    "-DCONTAINS=142857 1 -142857 -1 -70 -150 999998000001"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD vector methods: dot, length (magnitude), normalize, and the 3D cross product.
add_test(NAME codegen_simd_vec_ops_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_vec_ops.ldp3"
    "-DCONTAINS=dot=3 len=3 nx=10 cx=0 cy=6 cz=-6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# checked(expr) computes overflow-trapping arithmetic; in range it just yields the value.
add_test(NAME codegen_checked_overflow_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checked_overflow.ldp3"
    "-DCONTAINS=s=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Explicit overflow-mode integer methods: wrapping (modular) vs saturating (clamp to range).
add_test(NAME codegen_overflow_methods_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/overflow_methods.ldp3"
    "-DCONTAINS=sat=2147483647 wrapNeg=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD lane write: assign a single lane of a vector by name (v.y) or by index (v[i]).
add_test(NAME codegen_simd_lane_write_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_lane_write.ldp3"
    "-DCONTAINS=x=1 y=20 z=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Decimal primitive: exact fixed-point arithmetic and trimmed toString.
add_test(NAME codegen_decimal_math_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/decimal_math.ldp3"
    "-DCONTAINS=1.8 0.45 1.2 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD mat4: identity, matrix*vector transform, matrix*matrix multiply, element read.
add_test(NAME codegen_simd_mat4_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_mat4.ldp3"
    "-DCONTAINS=tp=123 q=567 m2=5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Parameter passing is by value for a plain class type (deep copy, like assignment); `&`/`*` share.
add_test(NAME codegen_value_parameter_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_parameter.ldp3"
    "-DCONTAINS=value=7 ref=99"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Returning a freshly-built object (operator overloading / factory) with a plain `return new X(...)`:
# the escaping object is promoted to the heap instead of dangling into the freed frame.
add_test(NAME codegen_return_new_object_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/return_new_object.ldp3"
    "-DCONTAINS=sum=4,6 big=40,60 made=7,8"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A collection of interface-typed elements: ArrayList<Shape> with per-element virtual dispatch. Needs
# Object's methods (equalsKey) to resolve on an interface receiver and interfaces to count as Objects.
add_test(NAME codegen_polymorphic_collection_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/polymorphic_collection.ldp3"
    "-DCONTAINS=total=35"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Lazy iterator pipeline from the stdlib (#25): filter + map + fold over a Stream, evaluated on demand.
add_test(NAME codegen_lazy_streams_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_streams.ldp3"
    "-DCONTAINS=total=220"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# The argument to a comptime parameter must be a compile-time constant (spec 32.4).
add_test(NAME sema_rejects_comptime_arg
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_arg_bad.ldp3")
set_tests_properties(sema_rejects_comptime_arg PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# a switch without a default case is a compile error (spec 7.3: default is mandatory).
add_test(NAME sema_rejects_switch_no_default
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_no_default_bad.ldp3")
set_tests_properties(sema_rejects_switch_no_default PROPERTIES
    PASS_REGULAR_EXPRESSION "must have a 'default' case")

# `try?` in a method that does not return Result/Option is a clean compile error (spec 21.2), not a
# codegen type-mismatch crash.
add_test(NAME sema_rejects_try_nonresult
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_nonresult_bad.ldp3")
set_tests_properties(sema_rejects_try_nonresult PROPERTIES
    PASS_REGULAR_EXPRESSION "can only be used inside a method that returns Result or Option")

# `try?` forwards the failure value UNCHANGED (codegen: CreateRet on the very value it tested), so the
# operand's error type must be the one this method returns. The check used to compare base names only --
# "Result" against "Result" -- which is the one comparison that can never fail here, so a
# Result<int,IoError> propagated out of a Result<int,int> reached the binary and was reinterpreted.
# Nothing downstream could catch it: every value-form Result is one LLVM StructType and every boxed one an
# opaque ptr. Pins the CODE so the wording stays free to improve.
add_test(NAME sema_rejects_try_error_type
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_error_type_bad.ldp3")
set_tests_properties(sema_rejects_try_error_type PROPERTIES
    PASS_REGULAR_EXPRESSION "LDP3-0504")

# The same rule's other half: a None carries no error value, so it cannot be propagated out as an Err.
add_test(NAME sema_rejects_try_family_cross
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_family_bad.ldp3")
set_tests_properties(sema_rejects_try_family_cross PROPERTIES
    PASS_REGULAR_EXPRESSION "same family")

# a non-terminating comptime evaluation hits the step/recursion budget and is
# rejected gracefully (spec 28.3), not a hang or crash.
add_test(NAME sema_rejects_comptime_runaway
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_runaway_bad.ldp3")
set_tests_properties(sema_rejects_comptime_runaway PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# a `demand` that does not hold (spec 28.2) -- condition uses a comptime call -- reports its reason.
add_test(NAME sema_rejects_demand_fail
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_fail_bad.ldp3")
set_tests_properties(sema_rejects_demand_fail PROPERTIES
    PASS_REGULAR_EXPRESSION "demand not met: fib.10. is not 99")

# A byte budget that is EXCEEDED must fail the build. Checked with a full compile and not
# `--check`, because a size is only knowable against the target's layout, which exists in the code
# generator: the analyzer defers exactly the sizeof-bearing assertions to it. The trade is
# deliberate -- one authority on layout instead of two models that can disagree -- and the cost is
# that a blown budget shows up at build time rather than in the editor's live check.
add_test(NAME codegen_rejects_exceeded_size_budget
    COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_budget_bad.ldp3"
            -o "${CMAKE_CURRENT_BINARY_DIR}/sizeof_budget_bad.ll")
set_tests_properties(codegen_rejects_exceeded_size_budget PROPERTIES
    PASS_REGULAR_EXPRESSION "demand not met: Wide must fit eight bytes")

# A parse error inside a string interpolation is reported WHERE IT IS. The embedded expression is
# lexed and parsed on its own, so its diagnostics used to count from that substring's line 1 and
# landed on the import at the top of the file -- the first error a reader sees, pointing at
# innocent code. The fault here is on line 14.
add_test(NAME sema_reports_interpolation_error_in_place
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_error_location.ldp3")
set_tests_properties(sema_reports_interpolation_error_in_place PROPERTIES
    PASS_REGULAR_EXPRESSION "interp_error_location.ldp3:14:")

# a non-eternal persistent with no release anywhere is a compile error (spec 18.15).
add_test(NAME sema_rejects_unreleased_persistent
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_unreleased_bad.ldp3")
set_tests_properties(sema_rejects_unreleased_persistent PROPERTIES
    PASS_REGULAR_EXPRESSION "no 'release persistent'")

# an invariant generic gives no subtyping between instantiations (spec 15.3).
add_test(NAME sema_rejects_invariant_assign
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_invariant_bad.ldp3")
set_tests_properties(sema_rejects_invariant_assign PROPERTIES
    PASS_REGULAR_EXPRESSION "Box.Animal")

# `unique partitionable` is contradictory and must be rejected (spec 19.9).
add_test(NAME sema_rejects_unique_partitionable
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable_unique_bad.ldp3")
set_tests_properties(sema_rejects_unique_partitionable PROPERTIES
    PASS_REGULAR_EXPRESSION "contradictory")

# extending a sealed type's permitted variant must be rejected (variants are final),
# else match's exhaustiveness assumption is unsound.
add_test(NAME sema_rejects_extend_permit
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/extend_permit_bad.ldp3")
set_tests_properties(sema_rejects_extend_permit PROPERTIES
    PASS_REGULAR_EXPRESSION "a sealed variant")

# a generic constraint carries its own type arguments (spec 15.2): implementing Comparable<Dog> does
# not satisfy `<T implements Comparable<T>>` when T is Cat.
add_test(NAME sema_rejects_generic_bound_args
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_bound_args_bad.ldp3")
set_tests_properties(sema_rejects_generic_bound_args PROPERTIES
    PASS_REGULAR_EXPRESSION "does not satisfy constraint 'T extends Comparable<Cat>'")

# a `final class` cannot be extended; a `final method` cannot be overridden (spec 15).
add_test(NAME sema_rejects_final_class
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/final_class_bad.ldp3")
set_tests_properties(sema_rejects_final_class PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot extend final class")
add_test(NAME sema_rejects_final_method
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/final_method_bad.ldp3")
set_tests_properties(sema_rejects_final_method PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot override final method")

# ---- Codegen tests (only when the LLVM backend is built) ----
if(LDP3_WITH_LLVM)
    # The emitted IR contains an i32 main and a printf call.
    add_test(NAME codegen_emits_ir
        COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
    set_tests_properties(codegen_emits_ir PROPERTIES
        PASS_REGULAR_EXPRESSION "define i32 @main")

    # volatile (spec 37.5) must lower to volatile loads/stores in the IR, not be
    # optimized away. (The run test only proves the result is unchanged.)
    add_test(NAME codegen_volatile_emits_volatile
        COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_access.ldp3")
    set_tests_properties(codegen_volatile_emits_volatile PROPERTIES
        PASS_REGULAR_EXPRESSION "store volatile")

    # region RAII (spec 17.7): a region with no explicit release is still freed at
    # the end of its block -- the IR must contain the scope-end free.
    add_test(NAME codegen_region_raii_frees
        COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_raii.ldp3")
    set_tests_properties(codegen_region_raii_frees PROPERTIES
        PASS_REGULAR_EXPRESSION "call void @__ldp3_region_release")

    # F9: `--lib` compiles a bundle to a .ldb (+ .ldh). The round-trip (--lib then --dump-ldb) must
    # show the bundle name and the public method signature in the generated .ldh.
    add_test(NAME bundle_lib_roundtrip COMMAND "${CMAKE_COMMAND}"
        "-DLDP3C=$<TARGET_FILE:ldp3c>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_lib.ldp3"
        "-DCONTAINS=public method gain(int delta) returns int"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_test.cmake")

    # A GENERATED HEADER MUST PARSE WITH THE PARSER THAT GENERATED IT. The emitter wrote
    # `static extern` where spec 37.9 demands `extern static`, so any bundle with an external static
    # method produced a .ldh this compiler could not read back -- surfacing far from the cause, as
    # "failed to parse the header of bundle X". The .ldh is checked for the canonical order.
    add_test(NAME bundle_ldh_modifier_order COMMAND "${CMAKE_COMMAND}"
        "-DLDP3C=$<TARGET_FILE:ldp3c>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ldh_modifier_order.ldp3"
        "-DCONTAINS=public extern cdecl static method time(long ptr) returns long"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_test.cmake")

    # F9 phase 2: two bundles whose vtable layouts collide cannot be linked together; depending on
    # both is rejected rather than silently dispatching through the wrong slot. (No clang needed.)
    add_test(NAME bundle_vtable_conflict_rejected COMMAND "${CMAKE_COMMAND}"
        "-DLDP3C=$<TARGET_FILE:ldp3c>"
        "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.ldp3"
        "-DLIB2=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_lib.ldp3"
        "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.ldp3"
        "-DCONTAINS=incompatible with another depended-on bundle"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_conflict_test.cmake")

    # Full pipeline: compile to .exe with clang and check it prints correctly.
    # (LDP3_CLANG is resolved once at the top level; see the root CMakeLists.txt.)
    if(LDP3_CLANG)
        # F9 phase 2: a consumer imports a separately-compiled bundle via --use, links its .ldb CODE,
        # and calls a static method across the bundle boundary -> Calc.square(7) = 49.
        add_test(NAME bundle_static_call_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_app.ldp3"
            "-DEXPECTED=square = 49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_link_test.cmake")

        # F9 phase 2 (instances): the consumer creates, uses, and destroys an imported class through
        # the bundle's exported __new/__delete (opaque layout) -> Counter(10)+1+1 = 12.
        add_test(NAME bundle_instance_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_app.ldp3"
            "-DEXPECTED=value = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_link_test.cmake")

        # F9 phase 2 (virtual dispatch): a Shape pointer to an imported Square dispatches area()
        # through the bundle's vtable; the consumer seeds the .ldb's slot layout -> Square.area = 25.
        add_test(NAME bundle_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.ldp3"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_link_test.cmake")

        # F9 phase 2 (plugin callback): the consumer implements an imported interface and hands its
        # object to the bundle, which dispatches describe() back across the boundary -> 42.
        add_test(NAME bundle_plugin_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_app.ldp3"
            "-DEXPECTED=rendered = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_link_test.cmake")

        # F9 phase 3 (dynamic load): the consumer loads the bundle at runtime (--use-dynamic). The
        # loader AOT-compiles the .ldb's bitcode to a DLL with clang and resolves the call -> 49.
        add_test(NAME bundle_dynamic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_app.ldp3"
            "-DEXPECTED=square = 49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_dynamic_test.cmake")

        # F9 phase 3 (dynamic instance): a class instance from a runtime-loaded bundle, created and
        # used through __new/__delete and method thunks -> Counter(10)+1+1 = 12.
        add_test(NAME bundle_dynamic_instance_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_app.ldp3"
            "-DEXPECTED=value = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_dynamic_test.cmake")

        # F9 phase 3 (dynamic virtual): a virtual call on an instance from a runtime-loaded bundle,
        # dispatched through the bundle's vtable -> Square.area = 25.
        add_test(NAME bundle_dynamic_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.ldp3"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_dynamic_test.cmake")

        # F9 phase 3 (partial compilation, spec 2.4): the bundle is absent at runtime; the program
        # wraps the use in try/catch and catches BundleNotLoadedException instead of crashing.
        add_test(NAME bundle_absent_caught COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_optional_app.ldp3"
            "-DCONTAINS=calc not available"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_absent_test.cmake")

        # F9 phase 3 (ABI check, spec 2.5): a different bundle is present at runtime; its fingerprint
        # does not match what the program compiled against, caught as BundleAbiMismatchException.
        add_test(NAME bundle_abi_mismatch_caught COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.ldp3"
            "-DLIB2=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.ldp3"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_abi_app.ldp3"
            "-DCONTAINS=calc ABI mismatch"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ldb_abi_test.cmake")

        add_test(NAME codegen_hello_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
            "-DEXPECTED=Resultado: 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A user type sharing a standard-library name, referenced from a second namespace of the same
        # program. The pass that disambiguates such names asked "is this the standard library?" by
        # comparing the NAMESPACE NAME -- and the stdlib has a namespace called `App`, which is the
        # likeliest name anybody gives a namespace of their own. Every ambiguous type referenced from
        # a user's `App` therefore resolved to the stdlib's, reported as a method missing from a
        # mangled class the program never wrote. Runs rather than only checks, so a resolution that
        # type-checks but binds to the wrong class still fails.
        add_test(NAME codegen_own_namespace_wins COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/own_namespace_wins.ldp3"
            "-DEXPECTED=total 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NAME COLLISION MUST NOT CHANGE WHAT THE FIELDS AROUND IT MEAN.
        #
        # Resolving an ambiguous name rewrites every class in the namespace, and the rewrite went
        # through a clone that copied thirteen of a field's eighteen properties. `weak`, `delegate`,
        # the affinity and the region flavor were dropped -- so declaring a class the standard library
        # also names turned every `weak T*` there into an OWNING pointer and un-delegated every class
        # that satisfied an interface by forwarding.
        #
        # It RUNS rather than only checking, because the two halves fail differently: losing `delegate`
        # fails to compile, and losing `weak` compiles perfectly and reads freed memory.
        add_test(NAME codegen_clone_keeps_field_kind COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/clone_keeps_field_kind.ldp3"
            "-DEXPECTED=weak=0 delegated=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `layout`: an interface for memory. The printed number is the proof that implementing one
        # ORDERED THE FIELDS -- the struct is written worst-first (a byte between two ints, twice),
        # which measures 16 as declared and 12 ordered widest-first. 16 would not have compiled at
        # all, so 12 is unreachable unless the reordering happened.
        add_test(NAME codegen_layout_packed_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_packed.ldp3"
            "-DEXPECTED=tick = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AN ARRAY OF A VALUE AGGREGATE HOLDS ITS ELEMENTS INLINE, not pointers to them. This was
        # found by dogfood: `cells[0].a` on a freshly allocated array was an access violation,
        # because the slot held the null the zero-init wrote and the field read dereferenced it.
        # Seven checks in one run -- zero-init, write, read, distinct slots, a method on an element,
        # read-modify-write, whole-element copy and its independence -- so the count IS the diagnosis.
        add_test(NAME codegen_struct_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_array.ldp3"
            "-DEXPECTED=inline = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And the type that cannot be made to fit. Not a --check test: a budget is measured against
        # the target's real layout, which only exists in the code generator, so the refusal has to
        # come from a real compile.
        add_test(NAME codegen_rejects_layout_over_budget
            COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_over_budget.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/layout_over_budget.ll")
        set_tests_properties(codegen_rejects_layout_over_budget PROPERTIES
            PASS_REGULAR_EXPRESSION "measures 16.*a tick must stay five to a cache line")

        # `itself` as the universal pronoun the keyword reference always described: "the entity being
        # declared". Bare it is that entity, followed by a '.' it is that entity's TYPE. The compiler
        # honoured it in two places only -- the region initializer and lambda self-recursion -- and
        # those are instances of the rule rather than exceptions to it. The lambda form is exercised
        # here beside the general ones so that generalizing the pronoun cannot quietly break it.
        add_test(NAME codegen_itself_pronoun_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/itself_pronoun.ldp3"
            "-DEXPECTED=a = 10 total = 10 fact = 120"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: variables and arithmetic with precedence; a + b * 2 = 50.
        add_test(NAME codegen_expr_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/expr.ldp3"
            "-DEXPECTED=c = 50"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: reassignment + mutable + ++; 1 -> +5 -> ++ = 7.
        add_test(NAME codegen_mutable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutable.ldp3"
            "-DEXPECTED=x = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: comparison + logical operators + boolean.
        add_test(NAME codegen_logic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/logic.ldp3"
            "-DEXPECTED=less=1 both=1 sum_gt=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M3: if/else with branches; 7 is odd and > 5 -> 102.
        add_test(NAME codegen_if_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/control_if.ldp3"
            "-DEXPECTED=result=102"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M3: for + while loops; sum 1..10 = 55, halving 100 to 1 takes 6 steps.
        add_test(NAME codegen_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loop.ldp3"
            "-DEXPECTED=sum=55 steps=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: class with constructor + instance methods + fields; two increments -> 2.
        add_test(NAME codegen_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_counter.ldp3"
            "-DEXPECTED=count = 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: a destructor runs at end of scope (RAII): ctor, hello, dtor.
        add_test(NAME codegen_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_dtor.ldp3"
            "-DEXPECTED=ctor hello dtor"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `weak T*` auto-nulls when its target is deleted: before=live id, after=-1 (nulled on its own).
        add_test(NAME codegen_weak_ref_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_ref.ldp3"
            "-DEXPECTED=before=42 after=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: new ... on heap + delete (ctor with a param, destructor on delete).
        add_test(NAME codegen_heap_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_heap.ldp3"
            "-DEXPECTED=value = 42 freeing 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: static methods, called as ClassName.method(args).
        add_test(NAME codegen_static_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_static.ldp3"
            "-DEXPECTED=square=25 total=125"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # static fields: class-wide state accessed as ClassName.field (read/write).
        add_test(NAME codegen_static_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_field.ldp3"
            "-DEXPECTED=count = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # null pointer literal: assign to a pointer, compare with == / != .
        add_test(NAME codegen_null_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_literal.ldp3"
            "-DEXPECTED=null=1 set=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambdas (function values, MVP no captures): assign to function<...> and call.
        add_test(NAME codegen_lambda_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda.ldp3"
            "-DEXPECTED=add=8 square=36"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambda passed as a callback argument (function-typed parameter).
        add_test(NAME codegen_lambda_callback_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_callback.ldp3"
            "-DEXPECTED=r=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # void lambda with no parameters (function<void>).
        add_test(NAME codegen_lambda_void_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_void.ldp3"
            "-DEXPECTED=hi=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # higher-order lambda: returns a lambda (nested function type + ">>" splitting).
        add_test(NAME codegen_lambda_hof_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_hof.ldp3"
            "-DEXPECTED=d=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambda stored in a class field (strategy pattern): this.op(x).
        add_test(NAME codegen_lambda_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_field.ldp3"
            "-DEXPECTED=v=105"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambda returning a non-int type (boolean).
        add_test(NAME codegen_lambda_bool_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_bool.ldp3"
            "-DEXPECTED=p=1 q=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambda returning char, with control flow (if) in the body.
        add_test(NAME codegen_lambda_char_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_char.ldp3"
            "-DEXPECTED=g=A h=B"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lambda integration: value + callback + field together.
        add_test(NAME codegen_lambda_showcase_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_showcase.ldp3"
            "-DEXPECTED=r=25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # closure: lambda captures a local byvalue.
        add_test(NAME codegen_lambda_capture_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_capture.ldp3"
            "-DEXPECTED=c=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # closure: lambda captures a local byref (sees post-capture mutation).
        add_test(NAME codegen_lambda_byref_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambda_byref.ldp3"
            "-DEXPECTED=b=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cast<T> between signed and unsigned integers (source signedness drives sext vs zext).
        add_test(NAME codegen_cast_signedness_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cast_signedness.ldp3"
            "-DEXPECTED=u = 4294967295 si = -1294967296 wid = 4294967295 ext = 255 wide = 4294967295"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # chained member access through value-typed class fields (o.inner.deeper.y), read + write.
        add_test(NAME codegen_chained_access_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/chained_access.ldp3"
            "-DEXPECTED=x = 7 y = 100 x = 42 y = 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # deep copy of a class-valued field from a variable (heap copy, independent of the source).
        add_test(NAME codegen_class_field_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_field_copy.ldp3"
            "-DEXPECTED=h = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # nested generic types: Box<List<int>> (recursive type-arg parsing + '>>' split).
        add_test(NAME codegen_nested_generics_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nested_generics.ldp3"
            "-DEXPECTED=first = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: an OS thread via the prelude's System.Concurrency.Thread (CreateThread + join).
        add_test(NAME codegen_thread_spawn_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_spawn.ldp3"
            "-DEXPECTED=worker n=42 main done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Mutex<T> + synchronized -- two threads increment a shared counter under a lock; the
        # total is deterministic (200000) only because the lock makes each increment atomic.
        add_test(NAME codegen_mutex_synchronized_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutex_synchronized.ldp3"
            "-DEXPECTED=total=200000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: atomic<T> -- two threads each increment a shared lock-free counter; total=200000.
        add_test(NAME codegen_atomic_counter_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_counter.ldp3"
            "-DEXPECTED=total=200000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Channel<T> -- a producer thread sends into a bounded channel; main receives + sums.
        add_test(NAME codegen_channel_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel.ldp3"
            "-DEXPECTED=sum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Channel.select -- poll several channels via the fluent builder; the ready one wins.
        add_test(NAME codegen_channel_select_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel_select.ldp3"
            "-DEXPECTED=b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: atomic<T> operators -- ++ / -- / += / -= and atomic store.
        add_test(NAME codegen_atomic_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_ops.ldp3"
            "-DEXPECTED=v=7 set=100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await (slice A) -- two async tasks run on the worker pool; main awaits both.
        add_test(NAME codegen_async_basic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_basic.ldp3"
            "-DEXPECTED=a=5050 b=20100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await state machine (slice B) -- awaiting inside an async method suspends it;
        # the body is split into states across the awaits (sum=60).
        add_test(NAME codegen_async_chain_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_chain.ldp3"
            "-DEXPECTED=sum=60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await with control flow (slice C) -- await inside a loop (coroutine lowering).
        add_test(NAME codegen_async_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_loop.ldp3"
            "-DEXPECTED=loopsum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await temp spilling (spec 20.2) -- a value computed before an `await` (a
        # sibling operand, or the call receiver) survives the suspend via the state object.
        add_test(NAME codegen_async_spill_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_spill.ldp3"
            "-DEXPECTED=result=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (B9): a value struct owning a heap field, live across an await, is heap-promoted into
        # the coroutine state and freed (block + owned fields) at completion -- 200x guards leak/double-free.
        add_test(NAME codegen_async_value_struct_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_value_struct.ldp3"
            "-DEXPECTED=total=39800"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (B8): a defer runs when an async body throws an uncaught exception (unwind to the guard),
        # not just on a normal return -- the awaiter re-throws and catches. Prints "defer ran" then "caught".
        add_test(NAME codegen_async_defer_throw_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_defer_throw.ldp3"
            "-DCONTAINS=defer ran"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8 + F6: async/await combined with try/catch/finally (spec 20.2 + 21.1) -- awaits inside
        # the try and catch, a thrown error caught, and a value live across the try's invoke edges.
        add_test(NAME codegen_async_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_try.ldp3"
            "-DEXPECTED=ok=130 bad=115"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 30.18: reimport validation via challenge-response -- unimport produces a value, the
        # matching reimport reproduces it (success) or not (onFailure runs).
        add_test(NAME codegen_reimport_expecting_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reimport_expecting.ldp3"
            "-DEXPECTED=proof=1007 validated rejected done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime local (spec 28.3): a value computed at compile time, usable as e.g. an array size.
        add_test(NAME codegen_comptime_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_local.ldp3"
            "-DEXPECTED=x=14 len=14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unary operator overload (spec 6.5): a no-arg operator <op> is invoked by the prefix form.
        add_test(NAME codegen_unary_operator_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unary_operator.ldp3"
            "-DEXPECTED=bx=-3 by=-4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # int-style enum casts to its ordinal int (spec 12.1).
        add_test(NAME codegen_enum_to_int_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_to_int.ldp3"
            "-DEXPECTED=i=2 ord=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # inline assembly (spec issue 1): asm("arch") { raw } emits a side-effecting inline asm block.
        add_test(NAME codegen_inline_asm_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_asm.ldp3"
            "-DEXPECTED=x=42 ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # FFI callback (spec 26): a capture-free lambda passed to a C function as a raw fn pointer.
        add_test(NAME codegen_ffi_callback_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_callback.ldp3"
            "-DEXPECTED=r=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `interrupt` OUTSIDE freestanding, and the only test in this file that proves the entry
        # point is real by handing it to something that has never heard of LDP3: it installs the
        # handler with the C runtime's own `signal()` and raises the signal for real. A hosted
        # interrupt lowers to `void(int)` -- what `signal()` takes on POSIX and through the Windows
        # CRT -- so one shape installs on both instead of an answer per operating system.
        #
        # `caught=2` means the CRT entered a method whose receiver was bound by `box.interrupt`, and
        # the field it wrote was read back afterwards. Nothing short of running it shows that: the
        # IR tests beside it would pass just as happily on an entry nobody can call.
        add_test(NAME codegen_interrupt_hosted_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_hosted.ldp3"
            "-DEXPECTED=caught=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A transformer end to end, run rather than inspected. `<dog>` is the transformer's OWN body
        # executing inside Dog and calling back into the socket Dog implemented -- the transformer
        # writes the algorithm and the type supplies the parts. `[cat]` is Cat having replaced that
        # body outright. Both halves in one line of output.
        #
        # It also proves the cost claim: a transformer is resolved entirely at compile time, by the
        # same copier that expands a generic, so what runs here is exactly the code someone would
        # have written by hand -- no vtable, no allocation, no indirection.
        add_test(NAME codegen_transformer_applies_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_applies.ldp3"
            "-DEXPECTED=<dog> [cat]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `call T.p()` reaching the transformer's own body from inside the type's override. `[<cat>]`
        # is both at once: the brackets are Cat's replacement, the angle brackets are the original it
        # asked for anyway. Without `call` the original is UNREACHABLE -- `this.describe()` from
        # inside `describe()` is the override calling itself -- which is the whole reason the word
        # exists, alongside there being no receiver to write to the left of the dot.
        add_test(NAME codegen_transformer_call_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_call.ldp3"
            "-DEXPECTED=[<cat>]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A GENERIC PROCEDURE, and its generics are ORDINARY ones: a real type parameter,
        # monomorphized per instantiation exactly like a generic method. `procedure` changes where a
        # signature is completed, not what `<T>` means.
        #
        # `s:42 m:7` is the transformer's one algorithm over any T, running inside two different
        # types, each answering the socket only it knows.
        add_test(NAME codegen_transformer_generic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_generic.ldp3"
            "-DEXPECTED=s:42 m:7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `procedure into<each Other>` -- the PER-TARGET family, and the capability the whole design
        # note is built on. Only a per-target body can write `new Fahrenheit(...)`, so conversion is
        # inexpressible with one generic body over every T: Celsius/Fahrenheit, Errno/int,
        # HidUsage/ScanCode all die without it, and `mutual`, totality and derivation lose the
        # declaration they read.
        #
        # `212 100` is the round trip: Celsius(100) -> Fahrenheit(212) -> Celsius(100).
        add_test(NAME codegen_transformer_each_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_each.ldp3"
            "-DEXPECTED=212 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `error ParseFailed;` -- a transformer's own failure type, so a failure names the conversion
        # that failed instead of surfacing as somebody else's exception. Synthesized ONCE, at the
        # transformer, as an ordinary class in its namespace: two types that fail the same conversion
        # must raise the same thing or a caller cannot write one `catch`.
        add_test(NAME codegen_transformer_error_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_error.ldp3"
            "-DEXPECTED=empty port port=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # class const in a compile-time context (spec 28.1): static_assert + sibling ref via owner.
        add_test(NAME codegen_const_in_class_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_in_class_comptime.ldp3"
            "-DEXPECTED=d=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extern C function as a static class member (spec 26): LibC.abs(...) links to the C symbol.
        add_test(NAME codegen_extern_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/extern_in_class.ldp3"
            "-DEXPECTED=abs=42 labs=1000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # const as a static class member (spec 28.1): read through the owner as Type.NAME, folded.
        add_test(NAME codegen_const_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_in_class.ldp3"
            "-DEXPECTED=a=100 b=200 r=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # importing a class brings its literal suffixes into scope (spec 17.10): 64 kib -> Units.kib.
        add_test(NAME codegen_literal_suffix_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_suffix_import.ldp3"
            "-DEXPECTED=a=65536 b=2097152"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value struct returned by value (spec 11): two calls must not alias each other's result.
        add_test(NAME codegen_struct_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_return.ldp3"
            "-DEXPECTED=a=100 b=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String ==/!= compares content (spec 4), not the buffer pointer (weld-dogfood BUG2).
        add_test(NAME codegen_string_equality_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_equality.ldp3"
            "-DEXPECTED=eq=1 ne=1 same=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ArrayList<string> and ArrayList<String> are the same instantiation (weld-dogfood BUG1).
        add_test(NAME codegen_generic_string_alias_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_string_alias.ldp3"
            "-DEXPECTED=n=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # abstainfrom disables up to the NEXT label, not the method end (weld-dogfood BUG5).
        add_test(NAME codegen_abstain_next_label_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/abstain_next_label.ldp3"
            "-DEXPECTED=AB|B"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Value structs inside aggregates (spec 11): a class field, an array element, a nested struct,
        # and an operator returning a struct by value. Regression guard for the 2026-07 codegen fixes
        # (operator sret dispatch + owned-heap promotion of `new` into a value-aggregate slot).
        add_test(NAME codegen_struct_in_aggregate_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_in_aggregate.ldp3"
            "-DEXPECTED=field=10,20 elem=30,40 nested=5,7 op=7,16 fbf=99,88 mret=77,66"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime literal as a class member (spec 17.10): qualified call Units.kib(N) + overload.
        add_test(NAME codegen_literal_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_in_class.ldp3"
            "-DEXPECTED=a=65536 b=2048 c=1536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # literal-suffix overloading by parameter type (spec 17.10 rule 6): scaled(int)/scaled(double).
        add_test(NAME codegen_literal_overload_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_overload.ldp3"
            "-DEXPECTED=a=10 b=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # built-in enum parse() (spec 12.5): EnumType.parse(s) -> Option<EnumType> (Some/None).
        add_test(NAME codegen_enum_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_parse.ldp3"
            "-DEXPECTED=r1=1 r2=-1 mars=10 pluto=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # built-in enum methods (spec 12.5): count() and random() (a value in declaration range).
        add_test(NAME codegen_enum_random_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_random.ldp3"
            "-DEXPECTED=count=4 valid=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match expression block arms (spec 16.2): `-> { ... yield expr; }` multi-line arms.
        add_test(NAME codegen_match_expr_block_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_expr_block.ldp3"
            "-DEXPECTED=a=27 b=36"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Channel.select with a timeout (spec 20.4): an empty channel makes select fire the timeout.
        add_test(NAME codegen_channel_select_timeout_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel_select_timeout.ldp3"
            "-DEXPECTED=timeout"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sizeof(Type) / sizeof(expr) (spec, issue #7): the byte size of a type or expression.
        # Decimal primitive (spec 34): exact fixed-point arithmetic, comparison and conversions.
        add_test(NAME codegen_decimal_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/decimal.ldp3"
            "-DCONTAINS=total=59.97 tax=4.7976 expensive=1 whole=59 half=2.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflection field get/set (spec 31): Field.get/set read and write a field through Object.
        add_test(NAME codegen_reflect_field_getset_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_field_getset.ldp3"
            "-DEXPECTED=before=10 after=99 direct=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflection over annotations (spec 31): Type.annotations() lists a class's applied annotations.
        add_test(NAME codegen_reflect_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_annotations.ldp3"
            "-DCONTAINS=count=2 Marker Audited"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Method-level annotation reflection (spec 31): Method.annotations() lists a method's annotations.
        add_test(NAME codegen_method_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/method_annotations.ldp3"
            "-DCONTAINS=save ann=Audited count=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # PriorityQueue<T> (spec 34.1): a min-heap; polling yields ascending order -> 12345.
        add_test(NAME codegen_priority_queue_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/priority_queue.ldp3"
            "-DCONTAINS=size=5 peek=1 12345"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # for-in over a collection directly (spec 34): iterates a toArray() snapshot -> sum=60 total=6.
        add_test(NAME codegen_foreach_collection_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_collection.ldp3"
            "-DCONTAINS=sum=60 total=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Functional pipeline on a collection (spec 34): ArrayList forEach/filter/map/reduce with lambdas.
        add_test(NAME codegen_collection_functional_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_functional.ldp3"
            "-DCONTAINS=1 2 3 4 5 evens=2 e0=2 e1=4 d0=2 d4=10 sum=15 anyOdd=1 allEven=0 big=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arithmetic with no correct answer is an EXCEPTION in a hosted program (catchable, so a caller
        # decides what a bad divisor means) and a PANIC in freestanding, where there is no exception
        # machinery. Both used to terminate the process even when hosted, so a division whose divisor came
        # from input could not be handled at all. Also checks the BASE class catches the specific one.
        add_test(NAME codegen_arith_faults_catchable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arith_faults_catchable.ldp3"
            "-DEXPECTED=div: division by zero ovf: integer overflow survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `checked()` must trap on UNSIGNED overflow too (it was silently dropped for unsigned operands)
        # (`if (checkedArith_ && !uns && ...)`), so the one arithmetic opt-in the language has did nothing
        # on an unsigned type -- and said nothing about it.
        add_test(NAME codegen_checked_unsigned_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checked_unsigned_bad.ldp3"
            "-DEXPECTED=caught: integer overflow survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # No-UB: ArrayList.get/set past the logical size (but inside spare capacity) must panic cleanly
        # rather than return an uninitialized slot. The raw-array check only catches index >= capacity.
        add_test(NAME codegen_arraylist_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_oob_bad.ldp3"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Same guard on the mutating index accessor: removeAt past the size must panic, not silently
        # corrupt the count. insertAt shares the mechanism; valid paths are covered by the wider suite.
        add_test(NAME codegen_arraylist_removeat_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_removeat_oob_bad.ldp3"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Slice is a non-owning window over an array: get/set past the window length must panic even when
        # the index still lands inside the backing array (else it silently reads/writes a neighbour).
        add_test(NAME codegen_slice_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/slice_oob_bad.ldp3"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # No-UB: an allocation the machine cannot serve must stop the program saying so. The runtime
        # used to return NULL and nothing downstream checks it, so exhaustion surfaced as an access
        # violation at address zero in unrelated code.
        add_test(NAME codegen_out_of_memory_panics COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/out_of_memory_bad.ldp3"
            "-DPANIC=out of memory"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Companion: the same guard must leave valid in-bounds access untouched, including across a grow.
        add_test(NAME codegen_arraylist_bounds_ok_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_bounds_ok.ldp3"
            "-DCONTAINS=size=10 first=100 last=900 sum=1204"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Args + Range (spec 34): command-line option parsing and integer range lists.
        add_test(NAME codegen_args_range_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/args_range.ldp3"
            "-DCONTAINS=hasN=1 n=42 up=5 r0=0 r3=9 rn=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # HTTP over Socket (spec 34): request building + response parsing (status/body/header).
        add_test(NAME codegen_http_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/http_parse.ldp3"
            "-DCONTAINS=status=200 body=hello ctype=text/plain reqOk=1 hostOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Nested generics (spec 15.1): generic Event<T> with an ArrayList<Handler<T>> field instantiates.
        add_test(NAME codegen_generic_event_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_event.ldp3"
            "-DCONTAINS=total=15 nsub=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Event dispatch (spec 34): Signal/IntEvent/StringEvent publish to subscribed handler functions.
        add_test(NAME codegen_events_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/events.ldp3"
            "-DCONTAINS=msg=hi total=17 nsig=1 ntick=2 nmsg=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Entity-component-system (spec 34): World entity ids + recycling, ComponentStore sparse set, system.
        add_test(NAME codegen_ecs_world_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecs_world.ldp3"
            "-DCONTAINS=a=1,2 c=4,4 size=3 bDead=0 dReuse=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Char utils + Roman numerals + percentile (spec 4/34.6): case/digit, 2024<->Roman, percentiles.
        add_test(NAME codegen_chars_roman_pct_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/chars_roman_pct.ldp3"
            "-DCONTAINS=up=A lo=z dig=1 rom=MMXXIV back=2024 p50=3 p25=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL encoding + word wrap + digit utils (spec 4/34.6): percent-encode, greedy wrap, digit math.
        add_test(NAME codegen_url_wrap_digits_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/url_wrap_digits.ldp3"
            "-DCONTAINS=enc=a%20b%21 dec=a b! nl=2 l0=the quick ds=6 rd=321 pal=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Edit distance + determinant + stats (spec 4/34.6): Levenshtein, Bareiss det, sum/range/mode.
        add_test(NAME codegen_textdist_det_stats_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/textdist_det_stats.ldp3"
            "-DCONTAINS=lev=3 det=-2 sum=14 range=2 mode=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Templating + CSV (spec 34): named placeholder substitution and quoted-field CSV parsing.
        add_test(NAME codegen_template_csv_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/template_csv.ldp3"
            "-DCONTAINS=tpl=Hi Ada, n=42, {miss} nf=3 f1=b,c"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deterministic PRNG + modpow (spec 34.6): reproducible Xorshift sequence, modular exponentiation.
        add_test(NAME codegen_rng_modpow_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rng_modpow.ldp3"
            "-DCONTAINS=r1=270369 det=1 range=1 mp=24 mp2=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Sieve + Bloom filter + deque (spec 34): primes up to 30, membership test, double-ended queue.
        add_test(NAME codegen_sieve_bloom_deque_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sieve_bloom_deque.ldp3"
            "-DCONTAINS=p2=1 p15=0 cnt=10 cat=1 fish=0 pf=0 pb=2 front=1 sz=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arena + heap + union-find (spec 17/34.1): stale-handle rejection, min-heap order, disjoint sets.
        add_test(NAME codegen_arena_heap_uf_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arena_heap_uf.ldp3"
            "-DCONTAINS=sm1=10 stale2=0 sm3=99 pop=1 c02=1 grp=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Adler-32 checksum (spec 4): zlib checksum of "abc".
        add_test(NAME codegen_adler_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/adler.ldp3"
            "-DCONTAINS=adler=38600999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RLE compression + expression evaluator (spec 34): round-trip RLE and precedence/paren arithmetic.
        add_test(NAME codegen_rle_calc_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rle_calc.ldp3"
            "-DCONTAINS=enc=a3b4c1 rt=1 a=14 b=20 c=60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Polynomials + integer vectors (spec 34.6): Horner eval/derivative, dot product, squared norm.
        add_test(NAME codegen_poly_vector_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/poly_vector.ldp3"
            "-DCONTAINS=eval=17 deg=2 dval=14 dot=32 norm=14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Autodiff + matrices (spec 34.6): Dual forward-mode derivatives, Matrix multiply/transpose.
        add_test(NAME codegen_autodiff_matrix_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/autodiff_matrix.ldp3"
            "-DCONTAINS=fval=30 fder=28 c00=19 c11=50 t01=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More math (spec 34.6): IntMath combinatorics (nCr/nPr), Stats variance/stddev/median.
        add_test(NAME codegen_math_extras_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_extras.ldp3"
            "-DCONTAINS=c52=10 c104=210 p53=60 var=2 std=1 med=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Leveled logging (spec 34): Logger drops messages below the configured level.
        add_test(NAME codegen_logger_levels_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/logger_levels.ldp3"
            "-DCONTAINS=[INFO] app: hello [WARN] app: careful [ERROR] app: boom"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checksums + dates (spec 4/34): CRC-32 and FNV-1a, Date leap/epoch/dayOfWeek/addDays.
        add_test(NAME codegen_digest_date_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/digest_date.ldp3"
            "-DCONTAINS=crc=891568578 fnv=440920331 leap=1 feb=29 epoch=10957 dow=6 add=2000-2-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Hex/Base64 encoding (spec 4): encode bytes to text and decode back, round-tripping.
        add_test(NAME codegen_encoding_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/encoding_hex_base64.ldp3"
            "-DCONTAINS=hex=414243 back=ABC b64=TWFu dec=Man decMa=Ma decM=M"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Math kit (spec 34.6): IntMath integer helpers, Rational, Complex, Stats.
        add_test(NAME codegen_math_kit_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_kit.ldp3"
            "-DCONTAINS=gcd=6 lcm=12 fact=120 p7=1 p8=0 isqrt=7 ipow=1024 rat=5/6 cx=-5+10i sum=66 mean=13 min=4 max=23"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pointers in generic collections (spec 17.8/15.1): ArrayList<Node*>/HashMap<int,Node*> share refs.
        add_test(NAME codegen_pointer_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_collections.ldp3"
            "-DCONTAINS=a=99 b=20 mapB=20 shared=99 size=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `delete` of a generic collection with a pointer type argument (ArrayList<Node*>,
        # HashMap<int,Node*>) is accepted, frees the collection, and leaves the borrowed pointees alone.
        add_test(NAME codegen_delete_pointer_collection_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_pointer_collection.ldp3"
            "-DCONTAINS=deleted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arbitrary-base integer conversion (spec 4), bases 2..36, pure LDP3.
        add_test(NAME codegen_radix_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/radix.ldp3"
            "-DCONTAINS=hex=ff bin=1010 zero=0 neg=-ff"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Ascii85 / Base85 (spec 4) in pure LDP3, encode/decode round-trip ("Man " -> 9jqo^).
        add_test(NAME codegen_ascii85_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ascii85.ldp3"
            "-DCONTAINS=man=9jqo^ roundtrip=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Base58 (Bitcoin alphabet, spec 4) in pure LDP3, encode/decode round-trip.
        add_test(NAME codegen_base58_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/base58.ldp3"
            "-DCONTAINS=enc=9Ajdvzr roundtrip=1 zeros=111"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-224 (FIPS 180-4) in pure LDP3: verified against the "abc" and "" reference vectors.
        add_test(NAME codegen_sha224_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha224.ldp3"
            "-DCONTAINS=abc=23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-256 (FIPS 180-4) in pure LDP3: verified against the "abc" and "" reference vectors.
        add_test(NAME codegen_sha256_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha256.ldp3"
            "-DCONTAINS=abc=ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # HMAC-SHA256 (RFC 2104) and Base32 (RFC 4648) in pure LDP3, verified against reference vectors.
        add_test(NAME codegen_hmac_base32_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hmac_base32.ldp3"
            "-DCONTAINS=hmac=f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Huffman coding (spec 34.1) in pure LDP3: build prefix codes, encode to bits, decode round-trip.
        add_test(NAME codegen_huffman_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/huffman.ldp3"
            "-DCONTAINS=rawbits=424 encbits=204 match=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RFC 4122 UUID v4 (seeded) and semantic-version parsing/comparison, both pure LDP3.
        add_test(NAME codegen_uuid_semver_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/uuid_semver.ldp3"
            "-DCONTAINS=uuid=9797c112-41d7-4d76-af35-925007fe8286 valid=1 v=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-1 (FIPS 180-1) and a minimal INI parser, both pure LDP3, verified against reference vectors.
        add_test(NAME codegen_sha1_ini_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha1_ini.ldp3"
            "-DCONTAINS=sha1abc=a9993e364706816aba3e25717850c26c9cd0d89d"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Immutable list and enum-ordinal-keyed map/set (spec 34.1), pure LDP3.
        add_test(NAME codegen_enum_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_collections.ldp3"
            "-DCONTAINS=em0=red has1=0 emsize=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Frequency counter / multiset of ints (spec 34.1): count/mostCommon/total, pure LDP3.
        add_test(NAME codegen_int_counter_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/int_counter.ldp3"
            "-DCONTAINS=c3=3 c2=2 c9=0 common=3 max=3 total=6 distinct=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Navigable sorted int set (spec 34.1): floor/ceiling/rank/kth, pure LDP3.
        add_test(NAME codegen_sorted_int_set_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sorted_int_set.ldp3"
            "-DCONTAINS=size=5 has3=1 has4=0 floor4=3 ceil4=5 rank5=3 k0=1 k4=8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Comparator combinators over closures (spec 34.1): naturalInt/reversed/thenComparing, pure LDP3.
        add_test(NAME codegen_comparators_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comparators.ldp3"
            "-DCONTAINS=asc=1,2,3 desc=3,2,1 tie=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quickselect k-th smallest (spec 34.1), pure LDP3.
        add_test(NAME codegen_quickselect_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/quickselect.ldp3"
            "-DCONTAINS=min=1 k3=3 max=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Min-tracking stack and sliding-window maximum (spec 34.1), pure LDP3.
        add_test(NAME codegen_minstack_window_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/minstack_window.ldp3"
            "-DCONTAINS=min1=1 popped=1 min2=2 size=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interval merging and Kadane's max subarray (spec 34.1), pure LDP3.
        add_test(NAME codegen_merge_kadane_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/merge_kadane.ldp3"
            "-DCONTAINS=merged=3 covered=10 first=1-6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 2D Fenwick tree (grid range sums) and Fletcher-16 checksum (spec 34.1/4), pure LDP3.
        add_test(NAME codegen_fenwick2d_fletcher_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fenwick2d_fletcher.ldp3"
            "-DCONTAINS=total=11 mid=8 row0=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 2D spatial hash grid (spec 34.1) for broad-phase rectangle queries, pure LDP3.
        add_test(NAME codegen_spatial_grid_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/spatial_grid.ldp3"
            "-DCONTAINS=box20=3 box9=2 far=1 all=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Directed graph (spec 34.1): topological sort (Kahn) and cycle detection, pure LDP3.
        add_test(NAME codegen_digraph_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/digraph.ldp3"
            "-DCONTAINS=order=0,1,2,3 cnt=4 cycle=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Generic bidirectional map and multimap (spec 34) in pure LDP3.
        add_test(NAME codegen_bimap_multimap_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bimap_multimap.ldp3"
            "-DCONTAINS=byKey=2 byVal=one size=2 has=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Range-query structures (spec 34.1): Fenwick (prefix/range sums), iterative segment tree, sparse table.
        add_test(NAME codegen_range_queries_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/range_queries.ldp3"
            "-DCONTAINS=fw_pre7=46 fw_r2to5=28"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Graph algorithms (Dijkstra shortest paths + Prim MST) and an O(1) LRU cache, both pure LDP3.
        add_test(NAME codegen_graph_lru_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/graph_lru.ldp3"
            "-DCONTAINS=dist=0,3,1,4,7 mst=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Adler-32 checksum (RFC 1950 / zlib) in pure LDP3, verified against reference vectors.
        add_test(NAME codegen_adler32_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/adler32.ldp3"
            "-DCONTAINS=abc=38600999 wiki=300286872 empty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # MD5 (RFC 1321) and CRC-16/XMODEM in pure LDP3, verified against reference vectors.
        add_test(NAME codegen_md5_crc_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/md5_crc.ldp3"
            "-DCONTAINS=md5abc=900150983cd24fb0d6963f7d28e17f72"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A finite state machine and glob/wildcard matching (spec 34), both pure LDP3.
        add_test(NAME codegen_statemachine_glob_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/statemachine_glob.ldp3"
            "-DCONTAINS=t1=1 t2=0 mid=unlocked end=locked"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Numerical linear algebra (Gaussian elimination) + Welford streaming statistics, both pure LDP3.
        add_test(NAME codegen_math_sci_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_sci.ldp3"
            "-DCONTAINS=x=1 y=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # LZ77 sliding-window compression (round-trip) and Soundex phonetic codes, both pure LDP3.
        add_test(NAME codegen_lz77_soundex_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lz77_soundex.ldp3"
            "-DCONTAINS=raw=35 toks=7 ok=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Chinese remainder theorem and integer factorization (spec 34.6), pure LDP3.
        add_test(NAME codegen_crt_factorize_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/crt_factorize.ldp3"
            "-DCONTAINS=crt=23"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Number theory (gcd/lcm/modpow/Miller-Rabin/modInverse) + combinatorics, both pure LDP3.
        add_test(NAME codegen_number_theory_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/number_theory.ldp3"
            "-DCONTAINS=p97=1 p100=0 p7919=1 modpow=24"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Classic algorithms (spec 34.1): 0/1 knapsack, longest common subsequence, interval scheduling.
        add_test(NAME codegen_algorithms_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/algorithms.ldp3"
            "-DCONTAINS=knap=9 lcs=4 sched=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Identifier case conversion (spec 34): camelCase <-> snake_case/kebab-case, pure LDP3.
        add_test(NAME codegen_case_convert_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/case_convert.ldp3"
            "-DCONTAINS=snake=hello_world kebab=hello-world camel=helloWorld camel2=fooBarBaz"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A variadic extern C function (spec 26): trailing ... in a class-member extern (printf).
        add_test(NAME codegen_ffi_variadic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_variadic.ldp3"
            "-DCONTAINS=x=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport with a timeout(...) modifier (spec 30.6): parses; the timeout is a no-op in-process.
        add_test(NAME codegen_unimport_timeout_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_timeout.ldp3"
            "-DCONTAINS=new caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator ++/-- overload dispatch (spec 6.5): c++ reassigns c to the operator's result.
        add_test(NAME codegen_operator_incr_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_incr.ldp3"
            "-DCONTAINS=n=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `v++` on a value struct moves the operator's sret result back into the variable's
        # storage (freeing the old value's owned fields first) -- 1000 iterations must not corrupt.
        add_test(NAME codegen_struct_incr_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_incr.ldp3"
            "-DEXPECTED=n=1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct that OWNS an int[] compiles (synthesized equalsKey no longer crashes
        # on `array == array`) and `v++` moves the owned array correctly over 1000 iterations.
        add_test(NAME codegen_struct_incr_owned_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_incr_owned.ldp3"
            "-DEXPECTED=n=1000 first=1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: == / != on arrays is identity comparison (heap-block pointer), not a codegen crash.
        add_test(NAME codegen_array_equality_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_equality.ldp3"
            "-DEXPECTED=r=1011"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A record may implement a generic interface (spec 10): record Point3D implements Ordered<Point3D>.
        add_test(NAME codegen_record_generic_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_generic_iface.ldp3"
            "-DCONTAINS=cmp=-4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A String argument to an extern C function is marshalled to a char* (spec 26).
        add_test(NAME codegen_ffi_string_arg_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_string_arg.ldp3"
            "-DCONTAINS=hello from ldp3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch on a String matches by value, not pointer identity (spec 7.3).
        add_test(NAME codegen_switch_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_string.ldp3"
            "-DCONTAINS=HELLO"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Navigable ops on the ordered TreeMap (spec 34.1): first/last/floor/ceiling/higher/lower, pure LDP3.
        add_test(NAME codegen_treemap_navigable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/treemap_navigable.ldp3"
            "-DCONTAINS=first=10 last=50 floor25=20 ceil25=30 higher20=30 lower20=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style .properties parsing (spec 34) with typed getters, pure LDP3.
        add_test(NAME codegen_properties_config_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/properties_config.ldp3"
            "-DCONTAINS=name=LDP3 port=8080 debug=1 missing=42 has=1 nokey=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL query-string parsing (spec 34) with percent-decoding, pure LDP3.
        add_test(NAME codegen_query_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/query_string.ldp3"
            "-DCONTAINS=a=1 b=2 c=hello me=A B x="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # JSON Pointer resolution (RFC 6901) and pretty-printing (spec 34), pure LDP3.
        add_test(NAME codegen_json_pointer_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/json_pointer.ldp3"
            "-DCONTAINS=n1=20 name=bob oob=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The System.Test unit-test framework (spec 34): Assert + TestRunner, pure LDP3.
        add_test(NAME codegen_test_framework_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_framework.ldp3"
            "-DCONTAINS=4 passed, 0 failed"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # CSV record parsing (RFC 4180, spec 34) with quoted fields, pure LDP3.
        add_test(NAME codegen_csv_reader_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/csv_reader.ldp3"
            "-DCONTAINS=n=4 f0=a f1=b,c"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # CSV row writing (RFC 4180, spec 34) with quoting/escaping, pure LDP3.
        add_test(NAME codegen_csv_writer_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/csv_writer.ldp3"
            "-DCONTAINS=row=a,\"b,c\",\"d\"\"e\""
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Human-friendly byte sizes and ordinals (spec 34), pure LDP3.
        add_test(NAME codegen_humanize_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/humanize.ldp3"
            "-DCONTAINS=b1=500 B b2=1.5 KB b3=1.0 MB b4=5.0 GB"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Spell integers in English words (spec 34), pure LDP3.
        add_test(NAME codegen_number_words_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/number_words.ldp3"
            "-DCONTAINS=d=one million two hundred thirty four thousand five hundred sixty seven"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a return implicitly widens to the declared type (int -> long/double, sign-extended).
        add_test(NAME codegen_return_widen_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/return_widen.ldp3"
            "-DCONTAINS=rl=42 rd=7.0 rneg=-5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: unary-minus double as a ternary arm (once mis-typed as int -> hung codegen).
        add_test(NAME codegen_unary_ternary_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unary_ternary.ldp3"
            "-DCONTAINS=sign=-1.0 r=2.0 k=-2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checksum validators (spec 34): Luhn (mod-10) and ISBN-13, pure LDP3.
        add_test(NAME codegen_validators_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/validators.ldp3"
            "-DCONTAINS=luhnOk=1 luhnBad=0 isbnOk=1 isbnBad=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Line diff (LCS) and format validators (email/url/IBAN, spec 34), pure LDP3.
        add_test(NAME codegen_text_diff_validators_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/text_diff_validators.ldp3"
            "-DCONTAINS=common=3 added=1 removed=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Levenshtein edit distance (spec 34) in pure LDP3.
        add_test(NAME codegen_levenshtein_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/levenshtein.ldp3"
            "-DCONTAINS=kit=3 empty=3 same=0 flaw=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Jaro-Winkler string similarity (spec 34) in pure LDP3.
        add_test(NAME codegen_jaro_winkler_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/jaro_winkler.ldp3"
            "-DCONTAINS=martha=0.961 dixon=0.813 same=1.000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL slugs and English pluralization (spec 34) in pure LDP3.
        add_test(NAME codegen_slug_inflect_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/slug_inflect.ldp3"
            "-DCONTAINS=p=cats,buses,parties,boxes,days"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Calendar arithmetic (spec 34): leap years, days in month, Zeller day-of-week, day-of-year.
        add_test(NAME codegen_calendar_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/calendar.ldp3"
            "-DCONTAINS=y2000sat=6 y2024mon=1 leap2000=1 leap1900=0 feb2024=29 doy=61"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Feature flags and an object-id pool (spec 34) in pure LDP3.
        add_test(NAME codegen_feature_pool_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/feature_pool.ldp3"
            "-DCONTAINS=a=0,1,2 exhausted=-1 reuse=1 inUse=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Fixed-point money as integer cents (spec 34), pure LDP3.
        add_test(NAME codegen_money_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/money.ldp3"
            "-DCONTAINS=a=$12.34 sum=$14.84 prod=$15.00 neg=-$0.75"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A bytecode stack virtual machine (spec 34) in pure LDP3, running factorial and a summation loop.
        add_test(NAME codegen_stack_vm_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stack_vm.ldp3"
            "-DCONTAINS=fact5=120 sum10=55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Resilience patterns (spec 34): a circuit breaker and a token-bucket rate limiter, deterministic.
        add_test(NAME codegen_resilience_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/resilience.ldp3"
            "-DCONTAINS=open=1 blocked=0 half=1 halfstate=2 closed=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RPN evaluation and shunting-yard infix->RPN (spec 34), pure LDP3.
        add_test(NAME codegen_rpn_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rpn.ldp3"
            "-DCONTAINS=shunt=1 2 + 3 * eval=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Classic ciphers (spec 34): Caesar/rot13 and Vigenere, verified against the ATTACKATDAWN vector.
        add_test(NAME codegen_ciphers_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ciphers.ldp3"
            "-DCONTAINS=vig=LXFOPVEFRNHR back=ATTACKATDAWN"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 3D vector math (spec 34.6) in pure LDP3: dot, cross, length, normalize.
        add_test(NAME codegen_vector3_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/vector3.ldp3"
            "-DCONTAINS=cross=0.0,0.0,1.0 dot=0.0 len=5.0 nlen=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Dense double matrix (spec 34.6) in pure LDP3: multiply, transpose, determinant.
        add_test(NAME codegen_matrixd_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matrixd.ldp3"
            "-DCONTAINS=c00=19.0 c11=50.0 t01=3.0 det=-2.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # itself.atMultiple (spec 17.4): a multi-range region; new T in R routes by type.
        add_test(NAME codegen_region_atmultiple_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_atmultiple.ldp3"
            "-DCONTAINS=d=7 c=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport granularity (spec 30.1): unimport enum X / unimport namespace N.
        add_test(NAME codegen_unimport_granularity_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_granularity.ldp3"
            "-DCONTAINS=ns caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `in region X` field placement (spec 18.7): accepted; the field works normally.
        add_test(NAME codegen_field_in_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/field_in_region.ldp3"
            "-DCONTAINS=v=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Move qualifiers (spec 19.3): move x from/to region relocates the object into the destination.
        add_test(NAME codegen_move_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/move_region.ldp3"
            "-DCONTAINS=id=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete a of region X` (spec 17.6): destroys a region object in place (destructor, no free).
        add_test(NAME codegen_delete_of_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_of_region.ldp3"
            "-DCONTAINS=after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflective Method.invoke returns the boxed result (spec 31); unboxed with a cast.
        add_test(NAME codegen_reflect_invoke_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_invoke_return.ldp3"
            "-DCONTAINS=v=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A property with both a custom get and set (spec 8.4): read via getter, write via setter.
        add_test(NAME codegen_property_getset_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/property_getset.ldp3"
            "-DCONTAINS=f=212"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A first-class Range value (spec 7.5): stored, queried (size/contains) and iterated.
        add_test(NAME codegen_range_value_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/range_value.ldp3"
            "-DCONTAINS=sum=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A record auto-generates toString (spec 10): "Name(f0, f1)".
        add_test(NAME codegen_record_tostring_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_tostring.ldp3"
            "-DCONTAINS=Point(3, 4)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # await ch.receive() (spec 20.7): a channel receive is awaitable (passthrough).
        add_test(NAME codegen_await_channel_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/await_channel.ldp3"
            "-DCONTAINS=sum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete a, b;` frees several objects in one statement (spec 19.1).
        add_test(NAME codegen_delete_multi_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_multi.ldp3"
            "-DCONTAINS=done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Nullable primitive (spec 3.7): boxed as a null-capable pointer; == null and ?? work.
        add_test(NAME codegen_nullable_primitive_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_primitive.ldp3"
            "-DCONTAINS=xnull=1 ynull=0 z=5 w=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checked class downcast (spec 6.3, no-UB): an invalid cast throws ClassCastException.
        add_test(NAME codegen_cast_checked_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cast_checked.ldp3"
            "-DCONTAINS=caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The is / as / as? type operators (spec 6.4).
        add_test(NAME codegen_is_as_operators_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/is_as_operators.ldp3"
            "-DCONTAINS=adog=1 cdog=0 okNull=0 noNull=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Closures via automatic free-variable capture (spec 22): capture a primitive and function values.
        add_test(NAME codegen_closures_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/closures.ldp3"
            "-DCONTAINS=add5=15 dbl=20 composed=30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 4x4 transform matrix (spec 34.6): identity/multiply/transpose, pure LDP3.
        add_test(NAME codegen_mat4_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mat4.ldp3"
            "-DCONTAINS=id00=1.0 id12=0.0 prod03=5.0 prod22=3.0 trans01=7.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Graphics/animation math (spec 34.6): Vector2/Vector4/Easing/Angle, pure LDP3.
        add_test(NAME codegen_graphics_math_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/graphics_math.ldp3"
            "-DCONTAINS=len=5.00 dot=11.00 addx=4.00"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bit-twiddling helpers (spec 34.6): popcount/clz/ctz/isPow2/nextPow2/reverse, pure LDP3.
        add_test(NAME codegen_bits_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bits.ldp3"
            "-DCONTAINS=pc=8 lz=31 tz=3 p16=1 p17=0 np17=32 np16=16 rev=16"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interpolation helpers (spec 34.6): lerp/inverseLerp/clamp/smoothstep/remap, pure LDP3.
        add_test(NAME codegen_interpolation_math_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interpolation_math.ldp3"
            "-DCONTAINS=lerp=5.00 inv=0.75 ss=0.50 remap=50.00 clamp=10.00"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quaternion 3D rotation math (spec 34.6) in pure LDP3: product, magnitude, normalize.
        add_test(NAME codegen_quaternion_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/quaternion.ldp3"
            "-DCONTAINS=mag=5.4772 pw=0.0 px=1.0 py=0.0 pz=0.0 normmag=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Least-squares regression and Pearson correlation (spec 34.6) in pure LDP3.
        add_test(NAME codegen_regression_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regression.ldp3"
            "-DCONTAINS=slope=2.0000 intercept=1.0000 r2=1.0000 predict5=11.0000 pearson=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Radix-2 fast Fourier transform (spec 34.6) in pure LDP3, forward + inverse round-trip.
        add_test(NAME codegen_fft_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fft.ldp3"
            "-DCONTAINS=dc_re=4.0000 dc_im=0.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Self-contained transcendentals (spec 34.6): sqrt/exp/ln/sin/cos/pow in pure LDP3.
        add_test(NAME codegen_numerics_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/numerics.ldp3"
            "-DCONTAINS=sqrt2=1.414214 exp1=2.718282 ln_e=1.000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 24-bit RGB color utilities (spec 34): pack/unpack, hex, lerp, luminance, pure LDP3.
        add_test(NAME codegen_colors_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/colors.ldp3"
            "-DCONTAINS=pack=16744448 hex=#ff8000 r=255 g=128 b=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Probabilistic data structures (spec 34.1): Count-Min sketch and HyperLogLog, pure LDP3.
        add_test(NAME codegen_probabilistic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/probabilistic.ldp3"
            "-DCONTAINS=cms_a=5 cms_b=3 cms_c=1 cms_z=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Binary serialization (spec 4): LEB128 varints and MSB-first bit packing, round-tripped, pure LDP3.
        add_test(NAME codegen_binary_serial_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/binary_serial.ldp3"
            "-DCONTAINS=vlen=2 b0=172 b1=2 val=300 big=123456789"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Computational geometry (spec 34.6): shoelace area, point-in-polygon, and convex hull, pure LDP3.
        add_test(NAME codegen_geometry_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/geometry.ldp3"
            "-DCONTAINS=area2=32 in=1 out=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String algorithms (spec 34.1): KMP substring search and Manacher longest-palindrome, pure LDP3.
        add_test(NAME codegen_string_search_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_search.ldp3"
            "-DCONTAINS=idx=6 cnt=3 miss=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pointer-linked binary search tree (spec 34.1): insert/contains/size + sorted in-order traversal.
        add_test(NAME codegen_bst_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bst.ldp3"
            "-DCONTAINS=has4=1 has6=0 size=6 first=1 last=8 mid=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Node structures via arenas (spec 34.1): Trie (arena) and Graph (edge list + BFS).
        add_test(NAME codegen_trie_graph_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/trie_graph.ldp3"
            "-DCONTAINS=cat=1 ca=0 pre=1 cab=0 d03=2 d05=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More collections (spec 34.1): Multiset, RingBuffer, LinkedHashMap.
        add_test(NAME codegen_collection_more_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_more.ldp3"
            "-DCONTAINS=cx=2 ctotal=3 rbpeek=2 rbfull=1 lmk0=z lmz=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bitset (spec 34.1): packed bit flags with set/clear/flip/get/count.
        add_test(NAME codegen_bitset_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitset_ops.ldp3"
            "-DCONTAINS=g3=1 g4=0 g99=1 count=3 g40=0 g4=1 count=3 size=100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Scanner (spec 4): tokenize text into ints/words/lines with a stateful cursor.
        add_test(NAME codegen_scanner_tokens_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/scanner_tokens.ldp3"
            "-DCONTAINS=n=42 a=hello b=world more=0 l1=first l2=second l3=third"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # UTF-8 decoding (spec 4): Utf8.length/codepointAt/widthAt/codepoints over byte-level strings.
        add_test(NAME codegen_utf8_decode_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/utf8_decode.ldp3"
            "-DCONTAINS=bytes=8 chars=5 cp3=233 width3=2 cps_n=5 cps_last=8364"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Backtracking regex (spec 4): literals, ., classes, * + ?, ^ $ anchors via Regex.search.
        add_test(NAME codegen_regex_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regex_match.ldp3"
            "-DCONTAINS=star=1 full=1 nofull=0 dot=1 digits=1 lower=1 mixed=0 opt=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Path-string manipulation (spec 34.4): Paths join/basename/dirname/extension.
        add_test(NAME codegen_path_utils_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/path_utils.ldp3"
            "-DCONTAINS=join=src/lib/file.ldp3 base=file.ldp3 dir=src/lib ext=ldp3 noext=[]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Line-oriented file I/O (spec 34.4): Files.writeLines/appendLine/readLines round-trip.
        add_test(NAME codegen_file_lines_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_lines.ldp3"
            "-DCONTAINS=n=4 first=alpha last=delta"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Even more Strings utilities (spec 4): one-sided trims, isBlank, equalsIgnoreCase.
        add_test(NAME codegen_string_extras_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_extras.ldp3"
            "-DCONTAINS=tsLen=4 teLen=4 blank1=1 blank2=0 eq=1 neq=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More Strings utilities (spec 4): format placeholders, count, reverse, capitalize.
        add_test(NAME codegen_string_format_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_format.ldp3"
            "-DCONTAINS=fmt=Ann is 42 years old count=2 rev=olleh cap=World"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Strings utility (spec 4): split/join/replace/pad built on the String primitives.
        add_test(NAME codegen_string_utils_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_utils.ldp3"
            "-DCONTAINS=n=3 p1=bb join=a-bb-ccc repl=hi world hi padL=[00042] padR=[42...]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Search terminals (spec 34): find/min/max over a collection, each returning Option<T>.
        add_test(NAME codegen_collection_search_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_search.ldp3"
            "-DCONTAINS=find=30 min=10 max=50 none=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sortedBy (spec 34): order a collection by a comparator lambda, leaving the original untouched.
        add_test(NAME codegen_collection_sorted_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_sorted.ldp3"
            "-DCONTAINS=asc=10,20,30,40,50 desc0=50 orig0=30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Iterable/Iterator (spec 34): an ArrayList walked through the Iterable interface by a generic helper.
        add_test(NAME codegen_collection_iterator_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_iterator.ldp3"
            "-DCONTAINS=total=66 count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Slice (spec 34): a non-owning window over an array range; get/set through, sub narrows, toArray copies.
        add_test(NAME codegen_collection_slice_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_slice.ldp3"
            "-DCONTAINS=len=4 s0=20 s3=50 a1=999 mid_len=2 mid0=30 copy1=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mutating collection ops (spec 34.1): ArrayList set/removeAt/remove/clear, HashMap/HashSet remove.
        add_test(NAME codegen_collection_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_ops.ldp3"
            "-DCONTAINS=size=3 head=99 idx30=1 has99=1 removed=1 size=2 cleared=0 map removed=1 size=2 has2=0 v3=300 set size=2 has6=0 has7=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mutable string (spec 4): append grows in place; assignment copies (value semantics).
        add_test(NAME codegen_mutable_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutable_string.ldp3"
            "-DCONTAINS=hi! there a=x b=xy"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interpolation as a value (spec 4.1): $"..." builds a String, interpolating ints, strings
        # and expressions.
        add_test(NAME codegen_interp_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_string.ldp3"
            "-DCONTAINS=n=7, hello world! len=17 7 doubled is 14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String (spec 4): literal, length, charAt, substring, equals and + concatenation.
        add_test(NAME codegen_strings_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/strings.ldp3"
            "-DCONTAINS=Hello, world! len=13 c=w sub=world eq=1 ne=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Boxing (spec 3.4): a primitive assigned to an Object is boxed; cast<T> unboxes it -> 42 / 1.
        add_test(NAME codegen_boxing_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/boxing.ldp3"
            "-DEXPECTED=n=42 flag=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        add_test(NAME codegen_sizeof_type_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_type.ldp3"
            "-DEXPECTED=n=16 n2=16 mpos=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent-bearing objects in an array (spec 18.5): an object without a name binding still
        # gets a usable persistent block, so its persistent fields work instead of crashing.
        add_test(NAME codegen_persist_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_array.ldp3"
            "-DEXPECTED=c0=11 c1=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalog-typed dispatch (spec 12.4): a catalog with a single implementing enum dispatches a
        # method called on a catalog-typed value to that enum's implementation.
        add_test(NAME codegen_catalog_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_dispatch.ldp3"
            "-DEXPECTED=w=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A catalog-implementing ordinal enum may separate its methods from the constants with a `;`
        # (regression guard: this stateless form was wrongly rejected as java-style). Multi-implementer.
        add_test(NAME codegen_catalog_semicolon_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_semicolon_methods.ldp3"
            "-DEXPECTED=a=angry b=high"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # multi-implementer catalog dispatch (spec 12.4): a runtime type tag picks the right enum's
        # method when several enums implement the catalog.
        add_test(NAME codegen_catalog_multi_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_multi_dispatch.ldp3"
            "-DCONTAINS=w1=7 w2=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A java-style enum implementing a catalog (2026-08-09: the two compose): byCatalog constants
        # take constructor arguments, catalog methods live on the desugared twin class, and dispatch
        # through a catalog-typed value resolves the tagged ordinal back to the constant's singleton.
        add_test(NAME codegen_catalog_java_enum_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_java_enum.ldp3"
            "-DCONTAINS=p=1 b=10 g=95 n=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mixed implementers of one catalog: an ordinal enum and a java-style enum behind the same
        # catalog-typed receiver; the type tag picks the implementer, the ordinal picks the singleton.
        add_test(NAME codegen_catalog_java_mixed_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_java_mixed_dispatch.ldp3"
            "-DCONTAINS=w1=7 w2=42 w3=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # v.name() (spec 12.5): the declared identifier back as a String, on ordinal and
        # java-style enum values alike -- the fourth of the generated quartet.
        add_test(NAME codegen_enum_name_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_name.ldp3"
            "-DCONTAINS=a=GREEN b=GREEN p=MARS"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cast<int> of a java-style enum value yields its declaration ordinal, never the
        # singleton's pointer bits (regression: it used to truncate the address).
        add_test(NAME codegen_java_enum_ordinal_cast_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_ordinal_cast.ldp3"
            "-DCONTAINS=e=0 m=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A methods-only enum with NO catalog stays ORDINAL: methods never make an enum
        # object-backed (regression: one method used to turn every constant into a heap
        # singleton, visible as sizeof 8 where 4 was promised).
        add_test(NAME codegen_enum_plain_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_plain_methods.ldp3"
            "-DCONTAINS=b=2 ord=1 n=3 sz=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A catalog-typed value passed as an ARGUMENT keeps its tag (spec 12.6). Regression: the
        # tagged ordinal lowers to i64 exactly as `long` does, so coercing an argument to the
        # parameter's LLVM shape alone dropped the type tag and dispatched every call to whichever
        # enum owned tag 0 -- silently wrong (200 read as 11); from a java-style implementer the
        # same path failed module verification.
        add_test(NAME codegen_catalog_arg_passing_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_arg_passing.ldp3"
            "-DEXPECTED=m=11 200 20 c=30 e=7 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # An enum's count() is a compile-time constant, so it may stand in a demand (spec 12.5 +
        # 28.2) -- which is what holds a multi-family index space to the size of each family. A
        # class's own static count() must still fall through to an ordinary runtime call.
        add_test(NAME codegen_demand_enum_count_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_enum_count.ldp3"
            "-DEXPECTED=shelf=12 idx=4 holds=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # FFI struct by value (spec 26): a small struct is passed to and returned from a C function
        # by value (the runtime provides the matching C helpers).
        add_test(NAME codegen_ffi_struct_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_struct.ldp3"
            "-DEXPECTED=s=7 qx=30 qy=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # auto-generated record hashCode (spec 10): equal records hash equal, different ones differ.
        add_test(NAME codegen_record_hashcode_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_hashcode.ldp3"
            "-DEXPECTED=eq=1 same=1 diff=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A hex literal WRITTEN with more than 32 bits of digits is 64-bit, whatever signed value it
        # equals. 0xFFFFFFFFFFFFF000 == -4096 as an int64, so typing literals by value truncated the mask
        # to 0xFFFFF000 -- which silently drops every address above 4 GiB.
        add_test(NAME codegen_wide_hex_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_hex_literal.ldp3"
            "-DEXPECTED=lit=140000000/140000000 decl=140000000/140000000 expr=140000000/140000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The IPC SEAM: a program that serves must have IpcRuntime.handle rewritten to call the
        # dispatcher synthesized for its own classes. The rewrite matched the namespace as "System.Ipc"
        # while the prelude declares it as `Ipc` (this pass runs BEFORE qualifyNamespaces), so it never
        # fired -- every server answered "this program exports nothing over IPC", the client raised an
        # uncaught IpcError and died with its stdout still buffered, which is what the 120-second timeout
        # actually was. Checking the emitted IR pins the seam itself, so the failure cannot come back as a
        # mysterious hang: no IpcDispatch in a serving program's output means the seam is gone again.
        add_test(NAME codegen_ipc_seam_installed COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_server.ldp3"
            "-DNEEDLE=IpcDispatch.handle"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # spec 37.4: a `comptime` local is computed during compilation and EMBEDDED. An IR test and not
        # a behaviour one on purpose -- a local that recomputed the same answer at run time would print
        # exactly the same thing and pass a `_runs` test. That is what used to happen: the prefix was
        # parsed, stored on the declaration and read by nobody, so the program emitted a real
        # `call @Main.fib(i32 10)`. fib(10) = 55, so the folded constant must be in the IR.
        add_test(NAME codegen_comptime_local_folds COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_local_folds.ldp3"
            "-DNEEDLE=store i32 55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # An `interrupt` emits TWO functions: the body as an ordinary method, and beside it the
        # entry the hardware jumps to, carrying `x86_intrcc` so LLVM writes the register save, the
        # pop of a pushed error code, and the `iretq`. IR tests and not behaviour ones because
        # nothing in a hosted process can enter one -- and because the defect these guard against
        # is exactly a keyword that parses and generates nothing.
        #
        # This is the strongest argument for the keyword and it is not "it would be tidier": pico's
        # equivalent stub is forty lines of hand-written assembly that a careful human wrote, twice
        # reviewed, and got wrong -- the entry gate decided whether to `swapgs` off the interrupted
        # code's `rax` instead of the saved CS, and reading never found it.
        add_test(NAME codegen_interrupt_entry_uses_x86_intrcc COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.ldp3"
            "-DNEEDLE=define x86_intrcc void @\"Keyboard$interrupt\"(ptr byval(%class.Trap)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # `kbd.interrupt` BINDS the object and yields the entry point in one act, because an
        # interrupt vector holds an address and nothing else -- there is nowhere to put the receiver
        # except a slot the entry reads on arrival. Without the store the entry would load null and
        # the kernel would fault inside its own handler, so the store IS the feature.
        add_test(NAME codegen_interrupt_binds_receiver COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.ldp3"
            "-DNEEDLE=store ptr %kbd1, ptr @\"Keyboard$interrupt$self\""
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # The OTHER half of rule 3, and the half that decides whether the rule is worth having: the
        # escape hatch must EXIST bare metal, or a correct program becomes inexpressible and the rule
        # only teaches people to route around it. `atomic<T>` on x86-64 is a `lock`-prefixed
        # instruction with no runtime behind it, so this sample compiles freestanding and the IR
        # carries a real `atomicrmw` -- no `__atomic_*` libcall a kernel could not link.
        add_test(NAME codegen_interrupt_atomic_state_ok COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_atomic_ok.ldp3"
            "-DNEEDLE=atomicrmw add ptr %atomic.value, i32 1 seq_cst"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # The parameterless form still gets a frame-sized `byval`, because x86_intrcc is how LLVM is
        # told the size of what the CPU pushed -- it is not the handler's argument list.
        add_test(NAME codegen_interrupt_without_trap COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.ldp3"
            "-DNEEDLE=define x86_intrcc void @\"Spurious$interrupt\"(ptr byval({ i64, i64, i64, i64, i64 })"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # `cast<T*>` on a nullable ASSERTS non-null and now verifies it: an exception when hosted, a
        # panic in freestanding. It used to reinterpret with no check, so a broken promise surfaced as an
        # access violation with nothing naming who promised -- while `cast<Dog>(animal)` verified and
        # threw. The sample also carries the cast-free form the narrowing makes possible.
        add_test(NAME codegen_null_cast_checked_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_cast_checked.ldp3"
            "-DEXPECTED=caught: null where a value was asserted narrowed: 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deferred initialization, guard-clause narrowing, and a proof made by an initializer -- the
        # shapes the flow analysis must ACCEPT. Runs, so the narrowing is proved not to change behaviour.
        add_test(NAME codegen_flow_states_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/flow_states.ldp3"
            "-DEXPECTED=branch=10 guard=0 pos=0 init=5 test=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # b"..." (spec 36): raw NUL-terminated bytes typed `byte*`, not a String object -- what
        # freestanding needs, since building a String requires a runtime a kernel does not have. Also
        # asserts `b` is still usable as an ordinary identifier.
        add_test(NAME codegen_bytes_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bytes_literal.ldp3"
            "-DEXPECTED=len=10 first=47 last=70 ident=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # COMPILE-TIME regression guard. The synthesized `hash` of a 20-field value type is a 40-deep
        # left-nested arithmetic chain, and the deep member chain in the same file is a 12-deep
        # receiver chain. codegen's typeName() used to recurse into the same subexpression 2x (binary
        # LHS, unary operand) and 9x (call receiver), making it exponential in depth: a 13-field
        # struct in the pico kernel took 181 SECONDS to emit. This test compiles in well under a
        # second now; if the double recursion returns, it fails on the ctest TIMEOUT, not on a value.
        add_test(NAME codegen_wide_struct_hash_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_struct_hash.ldp3"
            "-DEXPECTED=same=1 diff=0 chain=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_wide_struct_hash_runs PROPERTIES TIMEOUT 120)

        # in-scope persistent reattach (spec 18.2): a deleted variable redeclared with the same name
        # reattaches its persistent, so the new object sees the prior value.
        add_test(NAME codegen_reattach_in_scope_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reattach_in_scope.ldp3"
            "-DEXPECTED=re=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # region as a class field (spec 17): allocate into `this.arena`, an arena owned by the object.
        add_test(NAME codegen_region_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_field.ldp3"
            "-DEXPECTED=a=11 b=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # partitionable partial field move (spec 19.9): a movable field is moved out individually,
        # the parent stays valid for its other fields, and the moved field is reassignable.
        add_test(NAME codegen_partitionable_move_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable_move.ldp3"
            "-DEXPECTED=s=7 cfg=9 re=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # property with a custom set body (spec 8.4): assignment runs the setter (clamps negatives).
        add_test(NAME codegen_property_setter_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/property_setter.ldp3"
            "-DEXPECTED=b=50 b=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # conversion operator (spec 6.6): cast<T>(obj) invokes a user-defined `operator cast<T>`.
        add_test(NAME codegen_conversion_operator_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/conversion_operator.ldp3"
            "-DEXPECTED=f=212"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete X from region R` (spec 17.7): runs the destructor now and removes the object from
        # the region teardown, so it is not destroyed again on release.
        add_test(NAME codegen_delete_from_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_from_region.ldp3"
            "-DEXPECTED=before ~Dog 1 mid ~Dog 2 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # numeric widening + compile-time literal coercion: a fitting literal initializes a narrower
        # type, narrow integers widen, and mixed-width values compare after widening.
        add_test(NAME codegen_numeric_widen_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/numeric_widen.ldp3"
            "-DEXPECTED=b=9 s=300 i=5 total=305 eq=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # interface default methods (spec 9): an interface method body is inherited unless overridden;
        # the default dispatches other interface methods on `this` virtually.
        add_test(NAME codegen_interface_default_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interface_default.ldp3"
            "-DEXPECTED=alice=101 bob=999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # inherited class invariants (spec 29): a base invariant is checked on a subclass method's
        # exit too; here every step keeps it satisfied, so the program completes.
        add_test(NAME codegen_inherited_invariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inherited_invariant.ldp3"
            "-DEXPECTED=count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach with an index variable (spec 7.6): `for (index i, T v in ...)` over array + range.
        add_test(NAME codegen_foreach_index_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_index.ldp3"
            "-DEXPECTED=dot=200 last=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # for-in over an integer range (spec 7.5): exclusive `..`, inclusive `..=`, and `step`.
        add_test(NAME codegen_for_range_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/for_range.ldp3"
            "-DEXPECTED=excl=10 incl=15 step=20 count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comefrom (spec 7.10): the jump is written at the DESTINATION. Reaching `label L;` is
        # hijacked to wherever `comefrom L;` sits -- forward it steals (the code after the label
        # never runs), backward it retries (the comefrom is a no-op on the way down).
        add_test(NAME codegen_comefrom_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comefrom.ldp3"
            "-DEXPECTED=start forward ok n=1 n=2 n=3 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a `comefrom` that leaves a scope runs its teardown (destructors/defers/String/region),
        # like `goto` -- Noisy's dtor fires when comefrom exits the if-body. Prints start / ~1 / after.
        add_test(NAME codegen_comefrom_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comefrom_cleanup.ldp3"
            "-DCONTAINS=~1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: abstainfrom that skips a stack-object decl also skips its destructor -- no dtor on
        # unconstructed memory (no-UB). run(0)=cbd (ctor/body/dtor), run(1) abstained=nothing. Prints cbd|!
        add_test(NAME codegen_abstain_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/abstain_raii.ldp3"
            "-DEXPECTED=cbd|!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic constraint (spec 15.2) satisfied + a chained call on a generic method result.
        add_test(NAME codegen_generic_constraint_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_constraint.ldp3"
            "-DEXPECTED=area = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: structured exceptions via WinEH -- throw, unwind, catch (spec 21.1).
        add_test(NAME codegen_exceptions_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions.ldp3"
            "-DEXPECTED=before caught code=42 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: an exception thrown in a called method unwinds to the caller's catch (invoke).
        add_test(NAME codegen_exceptions_propagate_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_propagate.ldp3"
            "-DEXPECTED=caught code=7 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: finally runs on both the caught path and the normal-completion path.
        add_test(NAME codegen_exceptions_finally_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_finally.ldp3"
            "-DEXPECTED=caught finally body ok finally"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: typed multi-catch matched in order against the exception's dynamic type (subtype-aware).
        add_test(NAME codegen_exceptions_typed_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_typed.ldp3"
            "-DEXPECTED=app code=5 kind=2 net code=9 kind=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: RAII on unwind -- stack destructors run (reverse order) as an exception propagates out.
        add_test(NAME codegen_exceptions_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_raii.ldp3"
            "-DEXPECTED=dtor 2 dtor 1 caught 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: nested try + rethrow -- an unmatched inner exception reaches the enclosing catch.
        add_test(NAME codegen_exceptions_nested_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_nested.ldp3"
            "-DEXPECTED=outer B code=2 tag=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: throw inside a catch handler propagates to the outer try; stack object + try coexist.
        add_test(NAME codegen_exceptions_edge_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_edge.ldp3"
            "-DEXPECTED=rethrow as B outer B 2 caught A dtor 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: Result<T,E>/Option<T> built-in sealed sum types matched exhaustively (no default).
        add_test(NAME codegen_result_option_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_option.ldp3"
            "-DEXPECTED=r=7 e=-404 some 9 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value Result<T,E> / Option<T> (spec 21, value form): no `*` -> a tagged-union value, so Ok/Err/
        # Some/None allocate nothing and a hot loop of them is malloc-free (the E5 fix).
        add_test(NAME codegen_value_result_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_result.ldp3"
            "-DEXPECTED=ok 21 err 1 some 5 loopsum=499500"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # try? on a value Result/Option (spec 21.2): yields the payload on Ok/Some, early-returns the value
        # on Err/None (propagation) -- no boxing. Also a reference payload and a value Result by value.
        add_test(NAME codegen_value_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_try.ldp3"
            "-DEXPECTED=a=10 b=-3 ok=5 some=40 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value/boxed Result interop (spec 21): `delete` on a value Result is a no-op (owns no heap), and
        # the boxed form (`*`) keeps working side by side.
        add_test(NAME codegen_value_compat_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_compat.ldp3"
            "-DEXPECTED=v=7 boxed=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: Ok(x)/Err(x)/Some(x)/None() construction sugar in return and typed var-decl positions.
        add_test(NAME codegen_result_sugar_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_sugar.ldp3"
            "-DEXPECTED=a=7 b=-404 c=5 d=-404 some 9 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: try? propagation -- Ok/Some yields the value, Err/None early-returns to the caller.
        add_test(NAME codegen_result_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_try.ldp3"
            "-DEXPECTED=a=10 b=-3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a generic class/method body containing a `match` (monomorphizer used to crash).
        add_test(NAME codegen_generic_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_match.ldp3"
            "-DEXPECTED=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistents (spec 18, F7): in-process semantics -- a `static persistent` is run-lifetime
        # storage, like a static field. bump() 3x in one run -> runs = 3.
        add_test(NAME codegen_persist_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_demo.ldp3"
            "-DEXPECTED=runs = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistents in LOCALS (spec 18): a persistent local reattaches across CALLS within a run
        # (it is not reinitialized). 3 calls -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_local.ldp3"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # object reattach (spec 18.2): a persistent INSTANCE field lives outside the object and
        # survives delete, reattaching when the variable is recreated within the run -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_object_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_object.ldp3"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # object reattach via `this` (spec 18.2): methods/ctor reach the persistent through the
        # object's __persist pointer; chassi keeps counting across calls in one run -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_this_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_this.ldp3"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: inline field initializers + synthesized default constructor.
        add_test(NAME codegen_field_init_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_field_init.ldp3"
            "-DEXPECTED=area = 1920"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: no-ceremony forms - `new T()` defaulting to stack + println.
        add_test(NAME codegen_ergonomics_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ergonomics.ldp3"
            "-DEXPECTED=x = 15 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5: dynamic int array - new T[n](), a[i] r/w, a.length(), delete.
        add_test(NAME codegen_arrays_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arrays.ldp3"
            "-DEXPECTED=sum=45 len=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5: char[] field, written/read via this.cells[i], freed in destructor.
        add_test(NAME codegen_board_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/board.ldp3"
            "-DEXPECTED=XOX"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5+: string interpolation lowered to printf (%d/%c inferred per type).
        add_test(NAME codegen_interpolation_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interpolation.ldp3"
            "-DEXPECTED=score: 10 x 7 turn of X sum = 17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Console.read() reads a line as a String; toInt() parses it. stdin "3\n4" -> a=3 b=4 sum=7.
        add_test(NAME codegen_readint_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.ldp3"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.in"
            "-DEXPECTED=a=3 b=4 sum=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M7 north-star: full tic-tac-toe; scripted moves 1,4,2,5,3 -> X wins.
        add_test(NAME codegen_tictactoe_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.ldp3"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.in"
            "-DCONTAINS=Player X wins!"
            "-DEXPECTED="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M8: structural inheritance - inherited field/method + implicit super().
        add_test(NAME codegen_inherit_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inherit.ldp3"
            "-DEXPECTED=woof! legs=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M8: virtual dispatch - base-typed variable calls the derived override.
        add_test(NAME codegen_polymorphism_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/polymorphism.ldp3"
            "-DEXPECTED=woof meow"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M10: the closing north-star - enum + interface + abstract + override +
        # virtual dispatch, all in one program.
        add_test(NAME codegen_shapes_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shapes.ldp3"
            "-DEXPECTED=Square (kind 0) area: 16 Circle (kind 1) area: 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Multi-interface dispatch: a class implementing two interfaces must send
        # each interface's call to the right (global) vtable slot.
        add_test(NAME codegen_multi_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/multi_iface.ldp3"
            "-DEXPECTED=name 7 size 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M9: simple int-style enum (constants as ordinals, comparison).
        add_test(NAME codegen_enums_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enums.ldp3"
            "-DEXPECTED=is red? 1 blue code = 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase A1: pointers/refs share an instance (T* + address-of).
        add_test(NAME codegen_pointers_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointers.ldp3"
            "-DEXPECTED=b=5 p=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase A2: value semantics - `T b = a` copies, `T* p = &a` shares.
        add_test(NAME codegen_value_semantics_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_semantics.ldp3"
            "-DEXPECTED=after copy: a=1 b=99 after share: a=42 p=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase B: ownership - `move` transfers, source becomes invalid.
        add_test(NAME codegen_ownership_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ownership.ldp3"
            "-DEXPECTED=moved value = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase D: scoped resources - using disposes; defer runs LIFO at end.
        add_test(NAME codegen_scoped_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/scoped.ldp3"
            "-DEXPECTED=inside using closing 3 body deferred 2 deferred 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Types: floating point - double arithmetic and int -> float widening.
        add_test(NAME codegen_floats_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/floats.ldp3"
            "-DEXPECTED=pi=3.14 area=12.56 half=1.5 n=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Types: wide integers - int64/long and int -> long widening.
        add_test(NAME codegen_bitwidths_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwidths.ldp3"
            "-DEXPECTED=big=10000000000 sum=10000000005 wide=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Short-circuit && / || : the right operand runs only when needed.
        # Exact match: any extra "touched!" would mean the right side ran eagerly.
        add_test(NAME codegen_short_circuit_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/short_circuit.ldp3"
            "-DEXPECTED=or-ok touched! and-ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Explicit numeric casts: narrowing, float->int truncation, int->float.
        add_test(NAME codegen_casts_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/casts.ldp3"
            "-DEXPECTED=low = 5 truncated = 3 d = 3.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Explicit super(args): forward arguments to the base constructor.
        add_test(NAME codegen_super_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/super_args.ldp3"
            "-DEXPECTED=legs = 4 barks = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Unsigned integers: udiv, unsigned compare, %u / %llu printing.
        add_test(NAME codegen_unsigned_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unsigned.ldp3"
            "-DEXPECTED=big = 3000000000 half = 1500000000 big > 1 = 1 huge = 18000000000000000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # float is f32, double is f64: 2^24+1 survives in f64 but not in f32.
        add_test(NAME codegen_floats32_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/floats32.ldp3"
            "-DEXPECTED=f32 back = 16777216 f64 back = 16777217 pi = 3.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deep value copy: copying a class duplicates its array, so mutating the
        # copy leaves the original untouched.
        add_test(NAME codegen_deep_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy.ldp3"
            "-DEXPECTED=a[0] = 10 b[0] = 999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # struct: value type with fields/constructor/methods; copy is independent.
        add_test(NAME codegen_structs_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/structs.ldp3"
            "-DEXPECTED=sum = 7 p.x = 3 q.x = 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime literal suffix function at namespace level (called explicitly).
        add_test(NAME codegen_literals_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literals.ldp3"
            "-DEXPECTED=size = 65536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # import + `N suffix` syntax: 64 kib -> kib(64), enabled by the import.
        add_test(NAME codegen_suffixes_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/suffixes.ldp3"
            "-DEXPECTED=size = 65536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Embedded stdlib: import System.Memory.Units + ByteSize via `N unit`.
        add_test(NAME codegen_units_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/units.ldp3"
            "-DEXPECTED=a = 65536 b = 2097152"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regions: itself.allocate arena, new ... in region (bump), release.
        add_test(NAME codegen_regions_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regions.ldp3"
            "-DEXPECTED=a = 3 b = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region flavor (spec 17, flavors expansion): a `pool region` parses, allocates and runs.
        add_test(NAME codegen_region_pool_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_pool_parse.ldp3"
            "-DEXPECTED=age=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pool region reclaim: 200000 objects churned through a 4 KiB region (holds ~128 slots) complete
        # only because `delete X from region` returns each slot to the free-list -- no overflow panic.
        add_test(NAME codegen_region_pool_churn_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_pool_churn.ldp3"
            "-DEXPECTED=sum=9900000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extract X from region R: relocate an object to the heap; it survives the region's release, and
        # is then deleted by the caller (spec 17, flavors expansion).
        add_test(NAME codegen_region_extract_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_extract.ldp3"
            "-DEXPECTED=out=42 still=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # stack region mark/rollback (spec 17): 100000 objects churn through an 8 KiB stack region across
        # 1000 mark/rollback rounds -- works only via cursor rewind, and every object is destructed
        # (runtime registry), so the counter is exact.
        add_test(NAME codegen_region_stack_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_stack.ldp3"
            "-DEXPECTED=destroyed=100000 final=100001"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # fixedslot region (single-size pool, spec 17): the pool churn through a one-type region reclaims.
        add_test(NAME codegen_region_fixedslot_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_fixedslot.ldp3"
            "-DEXPECTED=sum=9900000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ring region (circular buffer, spec 17): 10 writes into a 3-entry ring evict the oldest 7 (their
        # destructors run); release destructs the 3 still live.
        add_test(NAME codegen_region_ring_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_ring.ldp3"
            "-DEXPECTED=evicted=7 final=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # growable region (spec 17): 1000 live objects grow a 256-byte region past its initial block by
        # chaining -- a fixed region would overflow. release frees the whole chain.
        add_test(NAME codegen_region_growable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_growable.ldp3"
            "-DEXPECTED=sum=24500"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A flavor on a region FIELD (spec 17): a `pool region` field churns + reclaims via `this.field`.
        add_test(NAME codegen_region_field_pool_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_field_pool.ldp3"
            "-DEXPECTED=s=100000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region accepts/rejects: an accepted type is allowed.
        add_test(NAME codegen_region_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_constraints.ldp3"
            "-DEXPECTED=d = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # record: compact value type with fields, a method and auto equals().
        add_test(NAME codegen_records_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/records.ldp3"
            "-DEXPECTED=sum = 7 p==q 1 p==r 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # record with float/double fields: the synthesized toString() renders each field through
        # that field's toString(), so this regressed the whole declaration when float had none.
        add_test(NAME codegen_record_float_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_float_field.ldp3"
            "-DEXPECTED=Sample(3, 1.5, 2.25) 0.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enum: constants with constructor args, fields and methods.
        add_test(NAME codegen_enum_java_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_java.ldp3"
            "-DEXPECTED=earth = 5 mars = 10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `delete` of a Java-style enum array must not double-free the shared singletons.
        add_test(NAME codegen_enum_array_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_array_delete.ldp3"
            "-DCONTAINS=deleted ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: reflection Field.get() reads int fields after reference/wide fields at the right offset.
        add_test(NAME codegen_reflect_field_after_ref_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_field_after_ref.ldp3"
            "-DEXPECTED=capX=111 capY=222 leaderIdx=333"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: reflection fields() enumerates inherited fields too, and Field.get() reads them.
        add_test(NAME codegen_reflect_inherited_fields_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_inherited_fields.ldp3"
            "-DEXPECTED=count=2 inherited a=11 own b=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct works as a HashMap key and TreeSet element (synthesized hash/equalsKey/compareTo).
        add_test(NAME codegen_value_struct_keys_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_struct_keys.ldp3"
            "-DEXPECTED=get=100 has55=no treesize=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct with many numeric fields (26 here) gets a synthesized structural
        # hash() whose deep arithmetic chain used to make codegen's typeName cost O(4^fields) -- it hung
        # the compiler (e.g. OpenGL's 26-field PixelFormatDescriptor under --lib). Must compile fast now.
        add_test(NAME codegen_struct_wide_hash_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_wide_hash.ldp3"
            "-DEXPECTED=got=770 size=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Generics: monomorphized Box<int>/Box<double> (distinct) and Pair<A,B>.
        add_test(NAME codegen_generics_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generics.ldp3"
            "-DEXPECTED=bi=42 bd=2.5 first=7 second=X"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Operator overloading: a + b dispatches to the class's operator method.
        add_test(NAME codegen_operators_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operators.ldp3"
            "-DEXPECTED=c = 11 22 33"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Properties: auto (get/set, get/init) and a computed get-only property.
        add_test(NAME codegen_properties_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/properties.ldp3"
            "-DEXPECTED=area = 12 w = 3 h = 4 area = 40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Multiple files forming one program: Main (part B) uses Greeter (part A).
        add_test(NAME codegen_multifile_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_a.ldp3"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_b.ldp3"
            "-DEXPECTED=greet = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Same type name in two namespaces of a multi-file program: legal (namespaces scope type
        # names), disambiguated internally to <ns>__Type. The import validator used to look up only
        # the bare name, miss it after the rename, and reject the import as an unknown symbol.
        add_test(NAME codegen_ns_collision_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ns_collision_a.ldp3"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/ns_collision_b.ldp3"
            "-DEXPECTED=geo=7 phys=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bundle-first import: `import main.lib.Calc;` names the bundle, and part B (namespace app)
        # reaches Calc (namespace lib) across namespaces.
        add_test(NAME codegen_bundle_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_import_a.ldp3"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_import_b.ldp3"
            "-DEXPECTED=sum = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # C-style union: fields share storage (write asFloat, read asInt bits).
        add_test(NAME codegen_unions_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unions.ldp3"
            "-DEXPECTED=bits = 1069547520 back = 1.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match: dynamic type dispatch with positional field destructuring.
        add_test(NAME codegen_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match.ldp3"
            "-DEXPECTED=square side = 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sealed + exhaustive match (no default needed since all permits covered).
        add_test(NAME codegen_sealed_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed.ldp3"
            "-DEXPECTED=circle r = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match as an expression (spec 16.2): each arm yields a value via `->`.
        add_test(NAME codegen_match_expr_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_expr.ldp3"
            "-DEXPECTED=area = 27 area = 25 d = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # contracts (spec 29): requires/ensures (with old()) + invariant runtime checks, happy path.
        add_test(NAME codegen_contracts_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contracts.ldp3"
            "-DEXPECTED=balance = 120"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WHAT A VIOLATED CONTRACT SAYS. It printed `contract violated: requires` and nothing else --
        # no clause, no place, no method, no values -- which is a bisection rather than a diagnostic.
        # Four separate assertions, because each part went missing for its own reason and each can
        # regress on its own: the clause text needs the source lookup wired into codegen, the method
        # name comes off the LLVM function, the location off the clause's own SourceLocation, and the
        # values need the comparison to be re-read in the failure path.
        add_test(NAME codegen_contract_names_the_clause COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.ldp3"
            "-DPANIC=requires this.seats >= wanted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_names_the_method COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.ldp3"
            "-DPANIC=in Gate.admit"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_names_the_place COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.ldp3"
            "-DPANIC=contract_report.ldp3:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_shows_the_values COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.ldp3"
            "-DPANIC=left = 4, right = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # AND THE SAME BARE METAL. The values were the one part of the message a freestanding program
        # did without: `__ldp3_panic` takes a finished string and a kernel has no stdio to build one
        # with, so codegen dropped them before the call. They now go through the same `__ldp3_fail` in
        # both targets, and the driver emits a reporter that formats them and hands the whole message
        # to that same panic (src/driver/build.cpp).
        #
        # A SEPARATE test from the hosted one above rather than a second needle on it: what regresses
        # here is a branch on `isFreestanding`, so a hosted program can keep passing while every kernel
        # loses the line -- which is exactly what used to happen. This sample is a `freestanding`
        # program compiled and run hosted, the way the other freestanding samples are; the bare-metal
        # formatter itself is proved by the kernel that dogfoods it.
        add_test(NAME codegen_freestanding_contract_shows_the_values COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report_freestanding.ldp3"
            "-DPANIC=left = 4, right = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        # The clause, the place and the method were never missing bare metal -- only the values were.
        # Pinned so a future simplification of the message cannot take the rest of it with them.
        add_test(NAME codegen_freestanding_contract_names_the_clause COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report_freestanding.ldp3"
            "-DPANIC=requires this.seats >= wanted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # The same treatment for the no-UB guards, which had the same fault: `array index out of
        # bounds` names the KIND of accident and withholds what finds it. The index and the length
        # together usually make the mistake obvious on sight, and both were in registers already.
        add_test(NAME codegen_bounds_shows_the_numbers COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.ldp3"
            "-DPANIC=index = 9, length = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_bounds_names_the_method COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.ldp3"
            "-DPANIC=in Shelf.at"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_bounds_names_the_place COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.ldp3"
            "-DPANIC=bounds_report.ldp3:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # System.Memory.Buffer (spec 17.8): an owned block of raw bytes whose LENGTH TRAVELS WITH THE
        # POINTER. Allocator hands out a bare address and Raw reads wherever it is pointed; Buffer is
        # the pair made safe, and it frees itself, so the two commonest raw-memory faults stop being
        # possible to write by accident.
        add_test(NAME codegen_memory_buffer_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer.ldp3"
            "-DEXPECTED=length = 32 ints = 7 11 byte = 3 long = 1234567 last = 99 copied = 42 generic = 55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # Writing past the end stops the program and says which clause, where, and with what numbers.
        # A bounds check that cannot be seen failing is indistinguishable from no bounds check.
        add_test(NAME codegen_memory_buffer_overrun_stops COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer_overrun.ldp3"
            "-DPANIC=left = 34, right = 32"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        # The clause itself is quoted from the PRELUDE's own text, which has no file on disk: the
        # compiler registers it under `<prelude>` so a stdlib diagnostic reads like any other.
        add_test(NAME codegen_prelude_contract_quotes_its_clause COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer_overrun.ldp3"
            "-DPANIC=requires offset + 4 <= this.size"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # sizeof as a COMPILE-TIME constant (spec 28.2 + issue #7), so a hot struct can carry a byte
        # budget the build enforces. The sample asserts its sizes AND prints them: an assertion that
        # disagreed with the layout the program actually gets would be worse than none at all.
        #
        # One test rather than one per fact: the harness names the executable after the input, so
        # several tests over one sample race for the same file under -j. Matching the whole output is
        # also the stricter assertion -- it pins vec2 = 8 (not the fallback 4 sizeof used to report)
        # and TwoNibbles = 1 (adjacent bit fields do share a storage unit) alongside the budget.
        add_test(NAME codegen_sizeof_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_comptime.ldp3"
            "-DEXPECTED=Packed = 20 TwoNibbles = 1 vec2 = 8 vec4 = 16 float = 4 short = 2 long = 8 local long = 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Result<T, E> (two type params + inheritance + virtual).
        add_test(NAME codegen_result_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result.ldp3"
            "-DEXPECTED=ok: 1 7 err: 0 404"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Option<T> (generics + inheritance + virtual compose into Result/Option).
        add_test(NAME codegen_option_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option.ldp3"
            "-DEXPECTED=a: some=1 val=42 b: some=0 val=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic virtual dispatch + upcast: Animal<int>* a = new Dog<int>() (spec 15).
        add_test(NAME codegen_generic_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_virtual.ldp3"
            "-DEXPECTED=sound = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # variance markers <out T> / <in T> (spec 15): no-op under monomorphization.
        add_test(NAME codegen_variance_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance.ldp3"
            "-DEXPECTED=get = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic inheritance (spec 15): class Derived<T> extends Base<T>.
        add_test(NAME codegen_generic_inherit_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_inherit.ldp3"
            "-DEXPECTED=total = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic linked node: Node<T> with a recursive generic pointer field Node<T>*.
        add_test(NAME codegen_generic_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_list.ldp3"
            "-DEXPECTED=total = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a method returning a generic type: Factory.make() returns Box<int>*.
        add_test(NAME codegen_generic_factory_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_factory.ldp3"
            "-DEXPECTED=v = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic class implementing an interface, dispatched via interface upcast.
        add_test(NAME codegen_generic_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_iface.ldp3"
            "-DEXPECTED=describe = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value semantics: assignment deep-copies; a pointer shares the instance.
        add_test(NAME codegen_value_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_copy.ldp3"
            "-DEXPECTED=a=7 b=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # final modifier (spec 15): explicitly immutable field / local.
        add_test(NAME codegen_final_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/final_modifier.ldp3"
            "-DEXPECTED=y = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Stack<T> over linked nodes: a real generic data structure.
        add_test(NAME codegen_generic_stack_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_stack.ldp3"
            "-DEXPECTED=popped 30 20, count 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bubble sort: arrays + nested loops + swap + a static method taking an array.
        add_test(NAME codegen_bubble_sort_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bubble_sort.ldp3"
            "-DEXPECTED=1 2 5 8 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # recursive static methods: factorial + fibonacci.
        add_test(NAME codegen_recursion_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/recursion.ldp3"
            "-DEXPECTED=fact(5)=120 fib(10)=55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a small OOP program: inheritance + super + override + virtual + contracts.
        add_test(NAME codegen_bank_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bank.ldp3"
            "-DEXPECTED=balance = 1650"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match as a statement: dynamic-type dispatch + positional destructuring.
        add_test(NAME codegen_match_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_dispatch.ldp3"
            "-DEXPECTED=rect area 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # math demo: recursion + modulo (Euclid GCD) and an iterative power loop.
        add_test(NAME codegen_math_demo_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_demo.ldp3"
            "-DEXPECTED=gcd(48,18)=6 pow(2,10)=1024"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic methods: obj.m<int>(...) monomorphized per call (spec 15.1).
        add_test(NAME codegen_generic_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_method.ldp3"
            "-DEXPECTED=id=42 pick=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generics constraints (spec 15.2): Box<T extends Shape> accepts Circle.
        add_test(NAME codegen_generics_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generics_constraints.ldp3"
            "-DEXPECTED=area = 48"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `demand` (spec 28.2): compile-time checks; they hold, so the program builds/runs.
        add_test(NAME codegen_demand_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand.ldp3"
            "-DEXPECTED=checks passed = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # break / continue in for and while loops (spec 7).
        add_test(NAME codegen_loops_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loops.ldp3"
            "-DEXPECTED=for sum = 8 while total = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach over an array (spec 7).
        add_test(NAME codegen_foreach_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach.ldp3"
            "-DEXPECTED=sum of squares = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # C#-style `foreach` keyword, alongside the `for (T v in coll)` form (spec 7.6).
        add_test(NAME codegen_foreach_csharp_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_csharp.ldp3"
            "-DEXPECTED=sum of squares = 30 count = 11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch with C-style fall-through (spec 7.3).
        add_test(NAME codegen_switch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch.ldp3"
            "-DEXPECTED=zero one one two other"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # showcase: many 0.2 features combined end to end.
        add_test(NAME codegen_showcase_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/showcase.ldp3"
            "-DEXPECTED=areas: 12 9 total 21 odd sum = 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # labeled break/continue to an outer loop (spec 7.4).
        add_test(NAME codegen_labeled_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/labeled.ldp3"
            "-DEXPECTED=found = 23 sum = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch over an enum value (enum constants are ordinals).
        add_test(NAME codegen_switch_enum_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_enum.ldp3"
            "-DEXPECTED=code = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch over a Java-style enum (singleton objects): matches on identity, not ordinals.
        add_test(NAME codegen_switch_enum_java_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_enum_java.ldp3"
            "-DEXPECTED=mars"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # do-while: the body runs at least once (spec 7).
        add_test(NAME codegen_dowhile_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dowhile.ldp3"
            "-DEXPECTED=count = 5 runs = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # compound assignment: x += e and friends (spec 6).
        add_test(NAME codegen_compound_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/compound.ldp3"
            "-DEXPECTED=x = 2 a0 = 17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bitwise compound assignment: &= |= ^= <<= >>= (spec 6).
        add_test(NAME codegen_bitwise_compound_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwise_compound.ldp3"
            "-DEXPECTED=x = 20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bitwise operators: & | ^ << >> (spec 6).
        add_test(NAME codegen_bitwise_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwise.ldp3"
            "-DEXPECTED=and = 8 or = 14 xor = 6 shl = 48 shr = 6 not = -13"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ternary conditional expression: c ? a : b (spec 6).
        add_test(NAME codegen_ternary_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ternary.ldp3"
            "-DEXPECTED=max = 7 min = 3 sign = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator[]= overloading: indexed assignment (spec 6.5).
        add_test(NAME codegen_operator_index_set_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_index_set.ldp3"
            "-DEXPECTED=p = 10 20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator[] overloading (spec 6.5).
        add_test(NAME codegen_operator_index_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_index.ldp3"
            "-DEXPECTED=t0 = 10 t1 = 20 t2 = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # enum built-ins count()/values() (spec 12.5).
        add_test(NAME codegen_enum_builtins_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_builtins.ldp3"
            "-DEXPECTED=count = 3 sum of ordinals = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # pointer fields (Node* next) -- linked structures; the assign must store, not copy.
        add_test(NAME codegen_linked_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/linked_list.ldp3"
            "-DEXPECTED=total = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # tuples (spec 22.5): multi-value return + destructuring + a tuple literal.
        add_test(NAME codegen_tuple_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tuple.ldp3"
            "-DEXPECTED=q=3 r=2 lo=3 hi=9 x=4 y=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bidirectional properties (spec 32.6): one property converting both ways over a backing field
        # (Celsius <-> Fahrenheit): reading converts out of the field, assigning converts into it.
        add_test(NAME codegen_bidirectional_property_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bidirectional_property.ldp3"
            "-DEXPECTED=f=212.0 c=0.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cross-program IPC (spec 2.8) + capability tokens (spec 32.7): two programs, one named pipe /
        # unix socket, an object that lives in the engine and is called from the client, and a policy
        # that refuses one capability and grants another.
        add_test(NAME codegen_ipc_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DSERVER=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_server.ldp3"
            "-DCLIENT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_client.ldp3"
            "-DEXPECTED=client: plays=1,2 client: volume=9 client: 'root' refused client: mixdown=900"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ipc_test.cmake")

        # inline tests (spec 32.11): `@Test` methods calling the stdlib Test assertions, run by --test.
        # A void test's verdict comes from its assertions; the boolean form still works.
        add_test(NAME codegen_inline_tests_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_tests.ldp3"
            "-DEXPECTED=PASS MathUtils.add_basic PASS MathUtils.predicates_and_tolerance PASS MathUtils.still_boolean tests: 3 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The rest of spec 32.11: [BeforeAll]/[AfterAll] build the class fixture once, [Setup]/[Teardown]
        # bracket each test, [Ignore] and a runtime Test.skip both report SKIP, and the report is
        # deterministic (durations are opt-in behind --timing) so it can be compared exactly.
        add_test(NAME codegen_test_lifecycle_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.ldp3"
            "-DEXPECTED=PASS Census.fixture_built_once PASS Census.values_stay_in_band PASS Census.setup_ran_for_this_test SKIP Census.needs_a_bigger_world -- needs a 4096-cell world; this fixture is 64 SKIP Census.forest_regrows -- regrowth is not implemented yet PASS Census.boolean_form_still_works PASS Arithmetic.arrays_and_text tests: 5 passed, 0 failed, 2 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --filter narrows the run to matching test names; --list names them without running anything,
        # which also means a filtered-out class never pays for its [BeforeAll] fixture.
        add_test(NAME codegen_test_filter_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.ldp3"
            "-DRUNARGS=--filter Arithmetic"
            "-DEXPECTED=PASS Arithmetic.arrays_and_text tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The rest of the framework: [Cases] over int and String rows, [Repeat], [ExpectedToFail]
        # (which RUNS and reports XFAIL), [Tag] + [MaxTime], output capture and golden comparison,
        # and the breadth of the assertion set.
        add_test(NAME codegen_test_full_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.ldp3"
            "-DEXPECTED=PASS Parser.every_seed_lands_in_band[0] PASS Parser.every_seed_lands_in_band[1] PASS Parser.every_seed_lands_in_band[2] PASS Parser.every_name_is_lowercase[0] PASS Parser.every_name_is_lowercase[1] PASS Parser.stable_across_runs XFAIL Parser.nested_quotes the parser drops the inner quote PASS Parser.large_input PASS Report.printed_output_is_captured PASS Report.golden_file_comparison PASS Report.the_assertion_surface tests: 11 passed, 0 failed, 0 skipped, 1 expected to fail"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --tag selects a group; the [MaxTime] budget on that same test must not trip.
        add_test(NAME codegen_test_tag_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.ldp3"
            "-DRUNARGS=--tag slow"
            "-DEXPECTED=PASS Parser.large_input tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --bench runs the [Benchmark] methods and no tests at all. The ns/op figure varies, so only
        # the shape is pinned.
        add_test(NAME codegen_test_bench_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.ldp3"
            "-DRUNARGS=--bench --filter summing_speed"
            "-DCONTAINS=BENCH Parser.summing_speed"
            "-DEXPECTED=unused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --format=json emits one machine-readable document. A test's own printing is captured into
        # its record rather than being interleaved, which is what keeps the JSON well-formed.
        add_test(NAME codegen_test_json_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.ldp3"
            "-DRUNARGS=--format=json --filter every_seed"
            "-DCONTAINS={\"tests\":[{\"name\":\"Parser.every_seed_lands_in_band[0]\",\"status\":\"PASS\""
            "-DEXPECTED=unused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Test.assertNoLeaks over a clean allocate/free round-trip, plus the accounting it is built
        # on moving in both directions. The second test is what stops the assertion from being green
        # by construction -- without it, a counter stuck at zero would pass everything.
        add_test(NAME codegen_test_no_leaks_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_no_leaks.ldp3"
            "-DEXPECTED=PASS Probe.clean_round_trip_leaves_nothing PASS Probe.a_leak_shows_up_in_the_live_total tests: 2 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A test runs against a LOADED program: the synthesized runner emits the onClassLoad hooks
        # the program's own main would (spec 32.5). Without this, agents-exe's whole suite panicked
        # in its first fixture on a table an onClassLoad fills.
        add_test(NAME codegen_test_class_load_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_class_load.ldp3"
            "-DEXPECTED=PASS Loading.the_class_was_loaded_before_the_tests_ran tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The same check runs under `--check`, which is what the editor calls: a malformed test is
        # reported while you type, not only on the day someone runs the suite.
        add_test(NAME test_check_reports_malformed_declarations
            COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3")
        set_tests_properties(test_check_reports_malformed_declarations PROPERTIES
            PASS_REGULAR_EXPRESSION "already has a '\\[Setup\\]' method")

        # Malformed test declarations are compile errors, not silent no-ops. Each shape gets its own
        # assertion against the same sample, so a fix that repairs one message cannot mask the others.
        add_test(NAME test_rejects_duplicate_hook
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_duplicate_hook PROPERTIES
            PASS_REGULAR_EXPRESSION "already has a '\\[Setup\\]' method")

        add_test(NAME test_rejects_instance_hook
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_instance_hook PROPERTIES
            PASS_REGULAR_EXPRESSION "must be a public static method returning void")

        add_test(NAME test_rejects_hook_that_is_also_a_test
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_hook_that_is_also_a_test PROPERTIES
            PASS_REGULAR_EXPRESSION "cannot mark the same method")

        add_test(NAME test_rejects_ignore_without_test
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_ignore_without_test PROPERTIES
            PASS_REGULAR_EXPRESSION "has no effect: it only applies to a '\\[Test\\]' method")

        add_test(NAME test_rejects_parameter_without_cases
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_parameter_without_cases PROPERTIES
            PASS_REGULAR_EXPRESSION "takes parameters, so it needs a '\\[Cases")

        add_test(NAME test_rejects_mismatched_cases_source
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_mismatched_cases_source PROPERTIES
            PASS_REGULAR_EXPRESSION "must be a public static method returning 'int\\[\\]'")

        add_test(NAME test_rejects_benchmark_that_is_also_a_test
            COMMAND ldp3c --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.ldp3"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_benchmark_that_is_also_a_test PROPERTIES
            PASS_REGULAR_EXPRESSION "a benchmark measures, a test judges")

        add_test(NAME codegen_test_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.ldp3"
            "-DRUNARGS=--list"
            "-DEXPECTED=Census.fixture_built_once Census.values_stay_in_band Census.setup_ran_for_this_test Census.needs_a_bigger_world Census.forest_regrows Census.boolean_form_still_works Arithmetic.arrays_and_text"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # named escape hatches: `[[no_bounds_check]]` (spec 36.4) drops the bounds check in that method,
        # and wrappingDiv/uncheckedDiv (spec 3.6) wrap INT_MIN / -1 instead of trapping (0 still panics).
        add_test(NAME codegen_hot_path_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hot_path.ldp3"
            "-DEXPECTED=hot=10 checked=10 wrapDiv=-2147483648 uncheckedDiv=-2147483648 plainDiv=-1073741824"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # pointer arithmetic (spec 27): +/-/++/-- step by whole elements, `q - p` is an element count,
        # and a pointer to a class is warned about (the program still compiles and runs).
        add_test(NAME codegen_pointer_arith_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_arith.ldp3"
            "-DEXPECTED=p1=10 p3=30 p2=20 gap=2 q=10 age=7 back=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `T*[]` (spec 27): a raw array of pointers -- a[i] is a T*, delete frees the array not the pointees.
        add_test(NAME codegen_ptr_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ptr_array.ldp3"
            "-DCONTAINS=sum=11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # N-level pointers (spec 17.8): T**/T***/T**** declare, deref with prefix '*', address-of chains,
        # out-parameters through a T**, and class double pointers.
        add_test(NAME codegen_n_level_pointers_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/n_level_pointers.ldp3"
            "-DCONTAINS=triple deref = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a generic constraint with type arguments (spec 15.2) is satisfied by the right instantiation.
        add_test(NAME codegen_generic_bound_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_bound_args.ldp3"
            "-DEXPECTED=cmp=-5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # affinity hints (spec 32.9): hot fields are packed first in the object and cold ones last,
        # whatever order the blocks were written in; a subclass still starts with the base's layout.
        add_test(NAME codegen_affinity_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/affinity.ldp3"
            "-DEXPECTED=x=3.0 y=3.0 id=7 tx=11.0 ty=22.0 tid=9 tag=42 ux=11.0 uid=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # mutable dispatch tables (spec 32.8): replacing a method rewrites the class's vtable slot, so
        # instances created before AND after the patch dispatch to the replacement (which may capture).
        add_test(NAME codegen_dispatch_table_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dispatch_table.ldp3"
            "-DEXPECTED=woof (3) woof remix woof remix loudness=107 captured=1005 woof remix poodle=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generators (spec 22.6): a method that yields produces a lazy Iterator<T> -- bounded, unbounded
        # (stopped by `break`), instance (capturing `this`), and driven by hand through the interface.
        add_test(NAME codegen_generator_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generator.ldp3"
            "-DEXPECTED=evens=20 primes=10 last=29 ticks=3210 first=0 more=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `defer within <budget>` (spec 32.10): a cleanup with a time budget. Under budget it is silent;
        # over budget the cleanup still completes and the runtime alerts on stderr (checked via
        # ERRCONTAINS -- the alert is a diagnostic, so it is deliberately not on stdout).
        add_test(NAME codegen_defer_within_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/defer_within.ldp3"
            "-DEXPECTED=quick body closed 1 slow body closed 2 done"
            "-DERRCONTAINS=defer overran its budget"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `partial` classes (spec 8.3): two declarations of the same class are folded into one.
        add_test(NAME codegen_partial_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partial_class.ldp3"
            "-DEXPECTED=barks=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # interpolation format specifiers (spec 4.1): `{pi:0.00}` fixes the decimals; no spec = unchanged.
        add_test(NAME codegen_interp_format_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_format.ldp3"
            "-DEXPECTED=pi=3.14 pi3=3.142 n=42 raw=3.14159"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach over a user Iterable/Iterator (spec 9.2): lazy, no snapshot -- an infinite Fibonacci
        # iterator is consumed with break (sum=88) and an Iterable is driven through iterator() (prod=24).
        add_test(NAME codegen_foreach_iterable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_iterable.ldp3"
            "-DEXPECTED=sum=88 prod=24"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 14.1/14.2: the built-in `@Name` annotation spelling (alongside `[Name]`), and `deprecated`
        # methods (each call site warns; the program still builds and runs).
        add_test(NAME codegen_deprecated_and_at_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deprecated_and_at_annotations.ldp3"
            "-DEXPECTED=a=42 b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # constraints on a generic METHOD (spec 15.2): <T implements Shape> is enforced at each call site.
        add_test(NAME codegen_generic_method_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_method_constraints.ldp3"
            "-DEXPECTED=sq=25 ci=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # named arguments (spec 22.4): `name: value` at the call site, in any order, plus `requires named`
        # parameters that may not be passed positionally.
        add_test(NAME codegen_named_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/named_args.ldp3"
            "-DEXPECTED=a=502 b=502 c=502 d=502 e=521 f=520"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs value contract (spec 12.3/12.4): enum extends catalog, byCatalog
        # constants continue the ordinals (3..5), enum is a subtype of the catalog.
        add_test(NAME codegen_catalog_values_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_values.ldp3"
            "-DEXPECTED=0 1 2 3 4 5 5 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs method contract (spec 12.3/12.4): the enum implements the catalog's
        # methods; instance methods take the enum value as `this`, dispatched statically.
        add_test(NAME codegen_catalog_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_methods.ldp3"
            "-DEXPECTED=100 10 10 1 2 11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs extending catalogs (spec 12.3): the contract is transitive; an enum
        # satisfying the chain is a subtype of every catalog in it.
        add_test(NAME codegen_catalog_extends_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_extends.ldp3"
            "-DEXPECTED=own=0 a=1 c=3 foo=7 bar=9 count=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # call args are coerced to the parameter's type across ctor/method/static/virtual
        # (e.g. an i32 literal into an int64 param, an int into a float param).
        add_test(NAME codegen_arg_coercion_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arg_coercion.ldp3"
            "-DEXPECTED=15 3 7 41"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value semantics on reassignment: `b = a` deep-copies (owned arrays duplicated),
        # so mutating b does not change a.
        add_test(NAME codegen_deep_copy_reassign_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy_reassign.ldp3"
            "-DEXPECTED=a=10 b=999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # arrays sized/indexed by the real element width: int64[] and double[] round-trip
        # 8-byte elements (and a value > INT32_MAX) instead of corrupting the heap.
        add_test(NAME codegen_wide_arrays_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_arrays.ldp3"
            "-DEXPECTED=a2=5000000012 d2=3 sum=10000000024 len=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # block-scoped RAII: a stack dtor / defer runs at its block's end on the path that
        # ran it -- per loop iteration, and never for a not-taken branch (no dtor on
        # uninitialized memory).
        add_test(NAME codegen_block_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/block_raii.ldp3"
            "-DEXPECTED=start dtor 0 dtor 1 dtor 2 body 0 defer 0 body 1 defer 1 end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a goto that leaves scopes runs their defers + destructors first (spec 7.9), innermost
        # scope first and LIFO within a scope -- previously the skipped scopes leaked.
        add_test(NAME codegen_goto_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_cleanup.ldp3"
            "-DEXPECTED=start defer dtor 2 dtor 1 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a throw caught by an enclosing try runs the try-body's block-scoped defers + destructors
        # while unwinding to the catch (spec 23.1) -- previously they were skipped on the caught path.
        add_test(NAME codegen_try_body_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/try_body_cleanup.ldp3"
            "-DEXPECTED=start defer dtor 1 caught after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # delete / using on an `on stack` object: destruct once, never free() a stack
        # pointer, never double-destruct at scope exit.
        add_test(NAME codegen_stack_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stack_delete.ldp3"
            "-DEXPECTED=dtor 1 after delete in using dtor 2 end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # virtual destructor dispatch: delete through a base pointer runs the most-derived
        # destructor (then chains to the base), instead of the static type's.
        add_test(NAME codegen_virtual_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_dtor.ldp3"
            "-DEXPECTED=~Derived ~Base ~Square"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # finally runs on early exits (return out of try, break leaving a nested try), not
        # only the normal/caught fall-through.
        add_test(NAME codegen_finally_exits_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/finally_exits.ldp3"
            "-DEXPECTED=finally-return r=1 iter 0 finally-iter 0 finally-iter 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # final class + final method used correctly compile and run.
        add_test(NAME codegen_final_types_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/final_types.ldp3"
            "-DEXPECTED=rgb=255"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bit-fields (spec 11.1): `field : N` masks the stored value to N bits.
        add_test(NAME codegen_bit_fields_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bit_fields.ldp3"
            "-DEXPECTED=a=4 b=7 c=904"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quake III fast inverse square root: union bit-reinterpretation + magic constant
        # + one Newton step. A real-world workout for unions/float32/casts/arg coercion.
        add_test(NAME codegen_fast_inv_sqrt_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fast_inv_sqrt.ldp3"
            "-DEXPECTED=rsqrt(4)~=499/1000 rsqrt(0.25)~=1996/1000 rsqrt(100)~=99/1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # namespace-level compile-time consts (spec 28.1): literals, arithmetic,
        # bitwise, hex bases, and references to earlier consts -- int/bool/char/double.
        add_test(NAME codegen_const_values_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_values.ldp3"
            "-DEXPECTED=MAX=100 DOUBLED=200 SHIFT=16 ENABLED=1 GRADE=A MASKED=15 SCALED=150"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # volatile (spec 37.5): a volatile field and local still round-trip correctly
        # (volatility doesn't change a single-threaded result).
        add_test(NAME codegen_volatile_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_access.ldp3"
            "-DEXPECTED=reg=42 sum=84"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime methods (spec 28.3): recursive fib + iterative factorial folded
        # at compile time into namespace consts (and a const built from them).
        add_test(NAME codegen_comptime_fn_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_fn.ldp3"
            "-DEXPECTED=fib10=55 fact5=120 combined=175"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime methods returning double (spec 28.3): mixed int/double body folds.
        add_test(NAME codegen_comptime_double_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_double.ldp3"
            "-DEXPECTED=total=450 half=350"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a demand's condition may use consts + comptime calls (shared evaluator).
        add_test(NAME codegen_demand_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_comptime.ldp3"
            "-DEXPECTED=demands met"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete (spec 37.1): deleting an object also deletes the objects it
        # owns by composition (value-typed class fields), recursively.
        add_test(NAME codegen_cascade_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_delete.ldp3"
            "-DEXPECTED=~Outer ~Mid ~Leaf done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete follows owned pointers, and a runtime visited-set frees a cyclic owned
        # graph exactly once (spec 37.1); `external` pointers are associations and are skipped.
        add_test(NAME codegen_cascade_graph_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_graph.ldp3"
            "-DEXPECTED=~Node 1 ~Node 2 ~Node 3 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete over a `unique class` graph: every pointer is a sole owner, so the owned graph
        # is provably a forest -- the compiler drops the runtime visited-set (fast path) yet still frees
        # the whole tree exactly once (right checksum, clean exit, no double-free panic).
        add_test(NAME codegen_cascade_forest_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_forest.ldp3"
            "-DCONTAINS=sum=496"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy region (spec 37.3): the backing block is allocated on first object insertion; an
        # unused lazy region is never allocated.
        add_test(NAME codegen_lazy_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_region.ldp3"
            "-DEXPECTED=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region empty-state (spec 17.2 form 3): `region r;` declared unallocated, allocated later.
        add_test(NAME codegen_region_empty_state_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_empty_state.ldp3"
            "-DCONTAINS=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy import (spec 37.3): a lazily imported class runs its onClassLoad on the first
        # instance, not at boot, so "start" prints before "server loaded".
        add_test(NAME codegen_lazy_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_import.ldp3"
            "-DEXPECTED=start server loaded made server"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # volatile region (spec 37.5, MMIO): objects in the region are accessed volatilely. Built at
        # -O3 to confirm the volatile loads/stores survive optimization.
        add_test(NAME codegen_volatile_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_region.ldp3"
            "-DEXPECTED=ctrl=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy thread (spec 37.3): the Thread object is created on first reference, deferring spawn.
        add_test(NAME codegen_lazy_thread_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_thread.ldp3"
            "-DEXPECTED=before after decl thread ran 7 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade validate(X) checks invariants and cascade Console.println(X) describes each node
        # in the owned graph (spec 37.1), reusing the cycle-safe walk.
        add_test(NAME codegen_cascade_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_ops.ldp3"
            "-DEXPECTED=Node 1 Node 2 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade clone X into Y deep-copies the owned graph into a fresh graph; mutating the clone
        # leaves the original untouched (spec 37.1).
        add_test(NAME codegen_cascade_clone_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_clone.ldp3"
            "-DEXPECTED=1 2 100 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade unimport X unimports X and its subclasses; a call on a subclass instance then
        # raises UnimportedTypeException (spec 37.1).
        add_test(NAME codegen_cascade_unimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_unimport.ldp3"
            "-DEXPECTED=woof dog is dead"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete also frees objects owned through INHERITED value fields.
        add_test(NAME codegen_cascade_inherited_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_inherited.ldp3"
            "-DEXPECTED=~Derived ~Base ~Leaf done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # qualified names (F4): the same type name in two namespaces (app.Box vs
        # lib.Box) is two distinct types, each resolved within its own namespace.
        add_test(NAME codegen_qualified_names_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/qualified_names.ldp3"
            "-DEXPECTED=app=1 lib=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # qualified names cover catalogs too: app.Tier and lib.Tier are distinct.
        add_test(NAME codegen_catalog_collision_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_collision.ldp3"
            "-DEXPECTED=app=1 lib=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # explicit qualified type reference: app.Box and lib.Box in one scope, no import.
        add_test(NAME codegen_qualified_explicit_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/qualified_explicit.ldp3"
            "-DEXPECTED=app=1 lib=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # partitionable (spec 19.9): a partitionable class compiles and runs.
        add_test(NAME codegen_partitionable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable.ldp3"
            "-DEXPECTED=value=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade move (spec 19.8): a graph moved to another region survives the
        # release of the source region.
        add_test(NAME codegen_cascade_move_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_move.ldp3"
            "-DEXPECTED=id=42 v=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # move on a parameter type transfers ownership into a function (spec 19.6).
        add_test(NAME codegen_move_signature_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/move_signature.ldp3"
            "-DEXPECTED=consumed 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection forwards arguments to instantiate (constructor) and invoke (method) (spec 31).
        add_test(NAME codegen_reflect_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_args.ldp3"
            "-DEXPECTED=age=7 age=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extern library block groups external C functions under one convention (spec 26).
        add_test(NAME codegen_ffi_library_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library.ldp3"
            "-DEXPECTED=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # releasing a region runs its objects' destructors before freeing the arena (spec 17.7).
        add_test(NAME codegen_region_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_dtor.ldp3"
            "-DEXPECTED=before ~Dog 2 ~Dog 1 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic method returning a tuple, destructured at the call site (spec 15.1).
        add_test(NAME codegen_generic_tuple_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_tuple_return.ldp3"
            "-DEXPECTED=5 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # break/continue run destructors and defers for loop-body objects before leaving (spec 7.8).
        add_test(NAME codegen_loop_teardown_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loop_teardown.ldp3"
            "-DEXPECTED=iter 0 dtor 0 iter 1 dtor 1 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enum constants are singletons (spec 12.2): == / != compare identity.
        add_test(NAME codegen_java_enum_compare_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_compare.ldp3"
            "-DEXPECTED=1 0 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # System.SQL's little-endian byte codec round-trips (the CI-safe check for the pure-LDP3 TDS
        # client; a live query needs a server -- see tests/samples/sql_query.ldp3).
        add_test(NAME codegen_sql_codec_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sql_codec.ldp3"
            "-DEXPECTED=65 4660 168496141 Hi"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `transient` field resets (does not copy) on a value copy (spec: derived/scratch state).
        add_test(NAME codegen_transient_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transient_copy.ldp3"
            "-DEXPECTED=21 42 21 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enums order by ordinal (declaration index), like Java's compareTo (spec 12.2).
        add_test(NAME codegen_java_enum_order_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_order.ldp3"
            "-DEXPECTED=1 1 1 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # safe navigation obj?.member (spec 3.7): null when obj is null, else the member; nullable.
        add_test(NAME codegen_safe_navigation_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/safe_navigation.ldp3"
            "-DEXPECTED=8 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # null-coalescing a ?? b (spec 3.7): a if non-null else b; result is non-null when b is.
        add_test(NAME codegen_null_coalesce_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_coalesce.ldp3"
            "-DEXPECTED=99 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # array literals [a,b,c] (spec 25), including nested multi-dimensional via inference.
        add_test(NAME codegen_array_literals_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_literals.ldp3"
            "-DEXPECTED=10 30 len=3 y 2 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # multi-dimensional arrays (spec 25): int[][] type, nested literals, m[i][j], as parameter.
        add_test(NAME codegen_array_multidim_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_multidim.ldp3"
            "-DEXPECTED=2 3 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # arr.length(n) resizes a dynamic array (spec 25): preserves elements, zeros the grown part.
        add_test(NAME codegen_array_grow_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_grow.ldp3"
            "-DEXPECTED=len=4 1 2 30 40 len=1 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # goto (spec 7.9) jumps forward to a later label in a regular method, skipping code between.
        add_test(NAME codegen_goto_forward_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_forward.ldp3"
            "-DEXPECTED=non-negative negative"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # goto (spec 7.9) + abstainfrom/reinstate (spec 7.11).
        add_test(NAME codegen_goto_abstainfrom_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_abstainfrom.ldp3"
            "-DEXPECTED=after goto body body"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onClassLoad lifecycle hook (spec 32.5): runs once before main.
        add_test(NAME codegen_lifecycle_onclassload_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_onclassload.ldp3"
            "-DEXPECTED=Server loaded main start"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onFirstInstance / onLastInstanceDestroyed (spec 32.5): instance-count hooks.
        add_test(NAME codegen_lifecycle_instances_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_instances.ldp3"
            "-DEXPECTED=start pool setup pool teardown end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Null safety (spec 3.7): nullable T, null assignment, flow narrowing via if (x != null).
        add_test(NAME codegen_nullable_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable.ldp3"
            "-DEXPECTED=total=105 aIsNull=1 bIsNull=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # First-class functions (spec 22): lambda values, byvalue/byref captures, functions as
        # parameters and return values, and methodref (bound method ref with virtual dispatch).
        add_test(NAME codegen_lambdas_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lambdas.ldp3"
            "-DEXPECTED=a=10 b=107 counter=3 c=12 d=15 e=400"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ldp3c's own optimization pipeline (-O3) with the recursive-inlining pass: self- and
        # mutually-recursive functions must give the same results optimized as not.
        add_test(NAME codegen_recursion_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/recursion_opt.ldp3"
            "-DEXPECTED=fib=6765 fact=479001600 even=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ldp3c's loop-interchange pass (-O3): the matmul reduction nest is rewritten to the
        # cache-friendly form and must still produce the exact same checksum.
        add_test(NAME codegen_matmul_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/../performance tests/matrixmul.ldp3"
            "-DEXPECTED=checksum=236236288"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Loop interchange, pattern B (-O3): direct accumulation `c[..] += a*b` with no scalar
        # accumulator. Must give the same checksum as the unoptimized build.
        add_test(NAME codegen_matmul_direct_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matmul_direct.ldp3"
            "-DEXPECTED=checksum=1666368"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `volatile method` (spec 37.5): emitted noinline/optnone; must compile and run under -O3.
        add_test(NAME codegen_volatile_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_method.ldp3"
            "-DEXPECTED=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `eternal` local (spec 37.2): lives for the whole program, so its destructor does not run
        # at scope end -- the output must be exactly "using=1" with no "freed".
        add_test(NAME codegen_eternal_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/eternal_local.ldp3"
            "-DEXPECTED=using=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Type aliases and newtype (spec 24): transparent `typealias` (primitive, function, generic)
        # and distinct `newtype` (cast across the boundary).
        add_test(NAME codegen_type_aliases_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/type_aliases.ldp3"
            "-DEXPECTED=t=20 r=26 order=1007"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Custom annotations (spec 14.3): declare with `annotation`, apply `[Name(args)]` on a
        # class/method/field; [CompileTimeProcessor] (spec 14.4). Validated, then compiles & runs.
        add_test(NAME codegen_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/annotations.ldp3"
            "-DEXPECTED=length=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Self-referential generic instantiation (Node<int> with a Node<T>* field) -- regression
        # for the cloneExpr null-literal crash.
        add_test(NAME codegen_self_ref_generic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/self_ref_generic.ldp3"
            "-DEXPECTED=a=5 b=9 via=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: LinkedList (pointer-based self-referential nodes, O(1) append/head-removal).
        add_test(NAME codegen_linkedlist_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/linkedlist_stdlib.ldp3"
            "-DEXPECTED=size=3 g0=10 g2=30 rm=10 size=3 g0=20 g2=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: String search/transform methods (spec 34.5).
        add_test(NAME codegen_string_methods_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_methods_stdlib.ldp3"
            "-DEXPECTED=idx=7 has=1 sw=1 ew=1 nf=-1 up=1 lo=1 trlen=2 treq=1 rp=6 rpeq=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: JSON (spec 34) -- value tree, serialize, parse, round-trip.
        add_test(NAME codegen_json_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/json_stdlib.ldp3"
            "-DEXPECTED=name=1 ver=1 cool=1 n0=10 n1=20 roundtrip=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: rich time -- Duration + Instant (spec 34).
        add_test(NAME codegen_duration_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/duration_stdlib.ldp3"
            "-DEXPECTED=aMs=2000 aSec=2 sumMs=2500 before=1 after=1 elapsedMs=2500 nowOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: Time (spec 34) -- monotonic/wall clock + sleep (checks invariants, not values).
        add_test(NAME codegen_time_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/time_stdlib.ldp3"
            "-DEXPECTED=slept=1 nanoOk=1 unixOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: File I/O (spec 34.4) -- write/read/append/exists/remove over runtime stdio.
        add_test(NAME codegen_file_io_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_io_stdlib.ldp3"
            "-DEXPECTED=w=1 ex=1 len=10 eq=1 len2=11 d=1 ex2=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: StringBuilder (System.Memory buffer) + int.toString (itoa) + Memory.readString.
        add_test(NAME codegen_stringbuilder_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stringbuilder_stdlib.ldp3"
            "-DEXPECTED=len=17 eq=1 c0=c clast=!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # StringBuilder lifetime: the destructor that reclaims its raw buffer must run on an explicit
        # delete AND on scope exit, and toString()'s result must outlive the builder. Guards the fix
        # for the leak where the builder had no destructor at all -- a double free crashes this.
        add_test(NAME codegen_stringbuilder_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stringbuilder_lifetime.ldp3"
            "-DEXPECTED=s=abc scoped=6 total=3890"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Collection lifetime: every collection's destructor reclaims its backing -- an array for most,
        # a node chain or tree for the rest -- and String elements are released with it. Guards the fix
        # for nine collections that had no destructor at all; a double free crashes this.
        add_test(NAME codegen_collection_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_lifetime.ldp3"
            "-DEXPECTED=sizes=4000 ok=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Value copy duplicates String fields, as it already did array fields. Sharing them entangled
        # the objects' lifetimes: `add(new T(...) on heap)` released the temporary's text while the
        # stored copy still pointed at it (read-back garbage, then a double free).
        add_test(NAME codegen_value_copy_string_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_copy_string_field.ldp3"
            "-DEXPECTED=count=5 total=75 first=snapshot body 0 copy=independent/independent survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (#252): a mutable `string` owns its buffer through the full lifecycle (init/assign/
        # return/field), like an immutable String -- `string d = concat(...)` no longer reads empty.
        add_test(NAME codegen_string_mutable_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_mutable_lifetime.ldp3"
            "-DEXPECTED=foobar|foobarfoo|foobar|n!|foobar"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Collections of class-typed elements (ArrayList<Class>, HashMap<K,Object>) -- regression.
        add_test(NAME codegen_object_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/object_collections.ldp3"
            "-DEXPECTED=kids=2 k0=2 k1=3 mapv7=70 mapv9=90"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: collection iteration -- toArray / keyArray / valueArray (+ sorted tree order).
        add_test(NAME codegen_collections_iter_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collections_iter_stdlib.ldp3"
            "-DEXPECTED=sum=6 tslen=3 s0=1 s1=3 s2=5 ksum=30 vsum=300"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: HashMap / HashSet (open addressing); int + String keys (Hashable builtins).
        add_test(NAME codegen_hashmap_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hashmap_stdlib.ldp3"
            "-DEXPECTED=size=3 g1=100 g2=200 g17=999 has5=0 has2=1 after grow: size=20 g7=70 g19=190 g2=20 set size=2 has5=1 has6=0 str ga=1 gb=2 hasG=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: TreeMap / TreeSet (BST, self-ref nodes); int + String keys (Comparable builtins).
        add_test(NAME codegen_treemap_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/treemap_stdlib.ldp3"
            "-DEXPECTED=size=3 g2=22 g5=50 g8=80 has3=0 has8=1 gNone=0 str size=3 apple=1 cherry=3 hasX=0 set size=3 has5=1 has7=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: array-backed collections -- Stack / Queue / Deque (spec 34.1).
        add_test(NAME codegen_collections_basic_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collections_basic.ldp3"
            "-DEXPECTED=stack=3 2 queue=10 20 deque=0 1 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: networking (spec 34) -- TCP client; connect to a closed port fails gracefully.
        add_test(NAME codegen_net_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/net_stdlib.ldp3"
            "-DEXPECTED=open=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: BigInteger (spec 34) -- arbitrary precision (18-digit multiply).
        add_test(NAME codegen_bigint_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bigint_stdlib.ldp3"
            "-DEXPECTED=sumEq=1 prodEq=1 cmp=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: extended Math (trig/clamp/lerp) + Random (nextRange/nextDouble/nextBool).
        add_test(NAME codegen_math_extra_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_extra_stdlib.ldp3"
            "-DEXPECTED=clamp=10 lerp=25 hypot=5 cbrt=3 log2=3 atan2x100=78 rangeOk=1 dOk=1 boolOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: Math (LLVM intrinsics) + Random (xorshift64); seed 42 is deterministic.
        add_test(NAME codegen_math_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_stdlib.ldp3"
            "-DEXPECTED=sqrt=4 pow=1024 max=7 floor=3 rand=5 46 78"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: address type, int<->pointer casts, raw pointer indexing, Memory API.
        add_test(NAME codegen_low_level_memory_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/low_level_memory.ldp3"
            "-DEXPECTED=sum=300 read=999 addr=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: a `freestanding` program -- regions/Memory/pointers/FFI, no managed
        # runtime; emits via an external C function (compiled hosted here).
        add_test(NAME codegen_freestanding_kernel_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_kernel.ldp3"
            "-DEXPECTED=OK"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The chaos tetrad (goto/comefrom/abstainfrom/reinstate) works in freestanding: no managed
        # runtime, just branches and an atomic counter (spec 7.9-7.11).
        add_test(NAME codegen_freestanding_tetrad_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_tetrad.ldp3"
            "-DEXPECTED=BB"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: FFI -- `extern cdecl method` declares + calls external C functions.
        add_test(NAME codegen_ffi_extern_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_extern.ldp3"
            "-DEXPECTED=abs=42 labs=1000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: region over fixed memory -- itself.at(addr, size), for memory-mapped HW.
        add_test(NAME codegen_region_at_address_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_at_address.ldp3"
            "-DEXPECTED=v=77 raw=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SIMD vectors (vec2/3/4): construction, element-wise ops, .xyzw + [i], by-value.
        add_test(NAME codegen_simd_vectors_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_vectors.ldp3"
            "-DEXPECTED=c=11,22,33,44 d.z=6 dot=32 idxsum=110"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # defined behaviour: saturating float->int cast + unary minus on float (no UB).
        add_test(NAME codegen_defined_conversions_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/defined_conversions.ldp3"
            "-DEXPECTED=2147483647 -2147483648 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport (spec 30): physical code overwrite (byte=204) + UnimportedTypeException
        # on new and on a method call to a surviving instance.
        add_test(NAME codegen_unimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport.ldp3"
            "-DEXPECTED=Woof! byte=204 new caught call caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reimport (spec 30.3): reload physically-unloaded code from the .exe on disk.
        add_test(NAME codegen_reimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reimport.ldp3"
            "-DEXPECTED=Woof! unimported Woof!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onClassUnload (spec 32.5): fires when the class is unimported.
        add_test(NAME codegen_lifecycle_onunload_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_onunload.ldp3"
            "-DEXPECTED=using cache cache unloaded done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent partial constructor (spec 18.9): omitted persistent param reattaches.
        add_test(NAME codegen_persist_partial_ctor_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_partial_ctor.ldp3"
            "-DEXPECTED=7 17 27"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent reattach by array index (spec 18.5): arr[i] keeps its own block across delete.
        add_test(NAME codegen_persist_array_reattach_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_array_reattach.ldp3"
            "-DCONTAINS=0 1 0 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: real String + Console.print/println + String.length().
        add_test(NAME codegen_string_console_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_console.ldp3"
            "-DEXPECTED=Hello, World! direct literal no newline end len=13"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection (spec 31): reflect.typeOf<T>() + Type.name().
        add_test(NAME codegen_reflect_typeof_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_typeof.ldp3"
            "-DEXPECTED=Dog name=Dog len=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ArrayList<T> (F10 stdlib): growable list, value and reference elements.
        add_test(NAME codegen_arraylist_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist.ldp3"
            "-DEXPECTED=size=5 sum=150 alpha beta gamma"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection (spec 31): Type method/field enumeration.
        add_test(NAME codegen_reflect_members_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_members.ldp3"
            "-DEXPECTED=methods=2 fields=2 bark sit age tag"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String methods (F10 stdlib): length/isEmpty/charAt/equals/concat/substring.
        add_test(NAME codegen_string_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_methods.ldp3"
            "-DEXPECTED=Hello, World! len=13 empty=0 char0=H char7=W World eq=1 ne=0 emptyIsEmpty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection invoke (spec 31): Type.method(name) + Method.name()/invoke(receiver).
        add_test(NAME codegen_reflect_invoke_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_invoke.ldp3"
            "-DEXPECTED=bark Woof! (sits)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection construction (spec 31): Type.instantiate() + cast<T> downcast.
        add_test(NAME codegen_reflect_instantiate_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_instantiate.ldp3"
            "-DEXPECTED=Dog built age=7 Woof! Woof!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection collections (spec 31): Type.methods()/fields() -> ArrayList<String>.
        add_test(NAME codegen_reflect_methods_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_methods_list.ldp3"
            "-DEXPECTED=methods size=2 bark sit fields size=1 age"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy (spec 37.3): a lazy local initializes on first access, once; an
        # unaccessed lazy local is never initialized.
        add_test(NAME codegen_lazy_init_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_init.ldp3"
            "-DEXPECTED=before after decl constructing 1 x=1 y=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy field (spec 28.4): a class-typed field is built on first access, once.
        add_test(NAME codegen_lazy_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_field.ldp3"
            "-DEXPECTED=before after holder constructing a=42 b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # release persistent (spec 18.15) satisfies a non-eternal persistent's
        # release obligation; the program compiles and runs.
        add_test(NAME codegen_persist_release_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_release.ldp3"
            "-DEXPECTED=slot=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime if (spec 37.4): the branch is chosen at compile time from a const
        # condition; here DEBUG=false and LEVEL>=2, so "debug off" and "level high".
        add_test(NAME codegen_comptime_if_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_if.ldp3"
            "-DEXPECTED=debug off level high"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # region RAII: a region with no explicit release still runs and frees cleanly.
        add_test(NAME codegen_region_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_raii.ldp3"
            "-DEXPECTED=a = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A '%' inside an interpolation is TEXT. The literal segments used to be pasted into the
        # printf format string raw, so `100%success` became `%s`: printf read a value nobody passed,
        # treated it as a char* and followed it (exit 0xC0000005). One percent in every position --
        # leading, between holes, trailing, doubled, and right before a live conversion letter.
        add_test(NAME codegen_interp_percent_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_percent.ldp3"
            "-DEXPECTED=50% of 1 | 1.2% | 1% and 2 | 100%success 1 | 1.2%%"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A call to the type's OWN method is the type it returns, including when a member is read off
        # it. Every path that types a call needs a receiver to read the return type from, so a call
        # written without one fell through to the fallback and was typed `int` -- invisible until
        # something read a member off the result, and then reported as "no such field" pointing at
        # the field rather than at the call whose type was invented.
        add_test(NAME codegen_implicit_this_receiver_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/implicit_this_receiver.ldp3"
            "-DEXPECTED=4 8 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 32.2: capture a region, keep working, put it back. Exercises all three forms and, more
        # to the point, that the restore RUNS DESTRUCTORS before it copies the bytes -- without that,
        # the space the newer object had is reused while a pointer to it still looks valid.
        add_test(NAME codegen_region_snapshot_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_snapshot.ldp3"
            "-DEXPECTED=before=2 after=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic variance (spec 15.3): covariant `out` and contravariant `in` make
        # a Producer<Dog>/Consumer<Animal> usable as Producer<Animal>/Consumer<Dog>.
        add_test(NAME codegen_variance_covariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_covariant.ldp3"
            "-DEXPECTED=make=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_variance_contravariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_contravariant.ldp3"
            "-DEXPECTED=tag=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # finally runs even when the exception propagates uncaught out of the try,
        # to be caught by an outer try (spec 21.1).
        add_test(NAME codegen_finally_uncaught_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/finally_uncaught.ldp3"
            "-DEXPECTED=throwing inner finally outer caught done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
    else()
        message(STATUS "clang not found; skipping end-to-end codegen test")
    endif()
endif()

# ---- Unit tests (doctest, fetched at configure time) ----
include(FetchContent)
FetchContent_Declare(
    doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG v2.4.11
    GIT_SHALLOW TRUE
)
# doctest 2.4.11's CMakeLists declares a pre-3.5 minimum, which CMake 4
# rejects; permit the older policy for this dependency only.
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
FetchContent_MakeAvailable(doctest)
unset(CMAKE_POLICY_VERSION_MINIMUM)

add_executable(ldp3_unit_tests
    unit/test_main.cpp
    unit/test_lexer.cpp
    unit/test_parser.cpp
    unit/test_semantic.cpp
    unit/test_ldb.cpp  # .ldb container read/write + fingerprint (self-contained)
    unit/test_manifest.cpp  # toolchain driver: manifest TOML-subset parser
    unit/test_sources.cpp   # toolchain driver: dependency source resolution
    unit/test_semver.cpp    # toolchain driver: semver parsing + range matching
    unit/test_formatter.cpp # ldp3 fmt: token-reflow formatting
    unit/test_discovery.cpp # toolchain driver: project discovery
    unit/test_jsonout.cpp   # toolchain driver: --json workspace output
    unit/test_lsp_json.cpp  # language server: JSON-RPC value parse/dump
    ${CMAKE_SOURCE_DIR}/src/lsp/json.cpp
)
target_link_libraries(ldp3_unit_tests PRIVATE ldp3_core ldp3_driver doctest::doctest)
add_test(NAME unit_tests COMMAND ldp3_unit_tests)

# The language server as a PROCESS: headers, dispatch, and the shape of definition/hover replies.
# The unit tests cover its JSON layer; this covers what an editor actually talks to. Skipped when no
# Python is available rather than failing a build that is otherwise fine.
find_package(Python3 COMPONENTS Interpreter QUIET)
if(Python3_FOUND)
    add_test(NAME lsp_protocol COMMAND ${Python3_EXECUTABLE}
        "${CMAKE_CURRENT_SOURCE_DIR}/lsp_probe.py" $<TARGET_FILE:ldp3-lsp>)
endif()

# The bundle tests build fixed-name .ldb/.ldh artifacts in a shared directory, so they cannot run
# concurrently with each other under `ctest -j`. A shared resource lock serializes them among themselves
# while they still overlap the (parallel-safe) codegen tests. The `if(TEST ...)` guard keeps this valid
# in configurations where a given bundle test was not defined.
foreach(_bt bundle_lib_roundtrip bundle_ldh_modifier_order bundle_vtable_conflict_rejected bundle_static_call_runs
        bundle_instance_runs bundle_virtual_runs bundle_plugin_runs bundle_dynamic_runs
        bundle_dynamic_instance_runs bundle_dynamic_virtual_runs bundle_absent_caught
        bundle_abi_mismatch_caught)
    if(TEST ${_bt})
        set_tests_properties(${_bt} PROPERTIES RESOURCE_LOCK bundle_artifacts)
    endif()
endforeach()
