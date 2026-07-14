# CTest wiring for the LDP3 compiler.
#
# Two layers: integration smoke tests over the ldp3c driver, and granular
# unit tests (doctest) over the lexer/parser/semantic libraries.

# ---- Integration tests (driver) ----
add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 1\\.0\\.0")

# ---- ldp3 driver (unified toolchain) integration tests ----
add_test(NAME ldp3_version COMMAND ldp3 --version)
set_tests_properties(ldp3_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3 1\\.0\\.0")

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
add_test(NAME codegen_bce_affine_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_affine.ldp3"
    "-DCONTAINS=sum=55502"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# The this./ClassName. receiver on a same-class method call is optional: a bare `name(...)` resolves to
# this.name / ClassName.name (static, instance, and inside constructors) and runs.
add_test(NAME codegen_unqualified_self_call_runs COMMAND "${CMAKE_COMMAND}"
    "-DLDP3C=$<TARGET_FILE:ldp3c>"
    "-DCLANG=${LDP3_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unqualified_self_call.ldp3"
    "-DCONTAINS=self=7 20 14"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...but an instance method still needs an object: calling one unqualified from a static context must fail
# with a diagnostic that names the cause and the fix, not a bare "unknown call".
add_test(NAME sema_rejects_instance_call_from_static
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/instance_from_static_bad.ldp3")
set_tests_properties(sema_rejects_instance_call_from_static PROPERTIES
    PASS_REGULAR_EXPRESSION "instance method of 'Main'.*object")

# An async method returning the value form of Result/Option is not supported yet (the value would be
# corrupted through the Task result slot); it must fail cleanly, pointing at the boxed form.
add_test(NAME sema_rejects_async_value_result
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/async_value_result_bad.ldp3")
set_tests_properties(sema_rejects_async_value_result PROPERTIES
    PASS_REGULAR_EXPRESSION "async method returning a value Result/Option is not supported")

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

# a non-terminating comptime evaluation hits the step/recursion budget and is
# rejected gracefully (spec 28.3), not a hang or crash.
add_test(NAME sema_rejects_comptime_runaway
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_runaway_bad.ldp3")
set_tests_properties(sema_rejects_comptime_runaway PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# a failing static_assert (spec 28.2) -- condition uses a comptime call -- reports its message.
add_test(NAME sema_rejects_static_assert_fail
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/static_assert_fail_bad.ldp3")
set_tests_properties(sema_rejects_static_assert_fail PROPERTIES
    PASS_REGULAR_EXPRESSION "static assertion failed: fib.10. is not 99")

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
            "-DEXPECTED=r1=1 r2=-1"
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

        # multi-implementer catalog dispatch (spec 12.4): a runtime type tag picks the right enum's
        # method when several enums implement the catalog.
        add_test(NAME codegen_catalog_multi_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_multi_dispatch.ldp3"
            "-DCONTAINS=w1=7 w2=42"
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

        # comefrom (spec 7.10): jump to a label, forward (skip ahead) or backward (retry).
        add_test(NAME codegen_comefrom_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comefrom.ldp3"
            "-DEXPECTED=forward ok n=1 n=2 n=3 done"
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
            "-DEXPECTED=placar: 10 x 7 vez do X soma = 17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Console.read() reads a line as a String; toInt() parses it. stdin "3\n4" -> a=3 b=4 soma=7.
        add_test(NAME codegen_readint_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.ldp3"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.in"
            "-DEXPECTED=a=3 b=4 soma=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M7 north-star: full tic-tac-toe; scripted moves 1,4,2,5,3 -> X wins.
        add_test(NAME codegen_tictactoe_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.ldp3"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.in"
            "-DCONTAINS=Jogador X venceu!"
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

        # Java-style enum: constants with constructor args, fields and methods.
        add_test(NAME codegen_enum_java_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_java.ldp3"
            "-DEXPECTED=earth = 5 mars = 10"
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

        # static_assert (spec 28.2): compile-time checks; they hold, so the program builds/runs.
        add_test(NAME codegen_static_assert_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_assert.ldp3"
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

        # inline tests (spec 32.11): `@Test` methods calling the stdlib Test assertions, run by --test.
        # A void test's verdict comes from its assertions; the boolean form still works.
        add_test(NAME codegen_inline_tests_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_tests.ldp3"
            "-DEXPECTED=PASS add_basic PASS predicates_and_tolerance PASS still_boolean tests: 3 passed, 0 failed"
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

        # static_assert conditions may use consts + comptime calls (shared evaluator).
        add_test(NAME codegen_static_assert_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_assert_comptime.ldp3"
            "-DEXPECTED=static asserts passed"
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

# The bundle tests build fixed-name .ldb/.ldh artifacts in a shared directory, so they cannot run
# concurrently with each other under `ctest -j`. A shared resource lock serializes them among themselves
# while they still overlap the (parallel-safe) codegen tests. The `if(TEST ...)` guard keeps this valid
# in configurations where a given bundle test was not defined.
foreach(_bt bundle_lib_roundtrip bundle_vtable_conflict_rejected bundle_static_call_runs
        bundle_instance_runs bundle_virtual_runs bundle_plugin_runs bundle_dynamic_runs
        bundle_dynamic_instance_runs bundle_dynamic_virtual_runs bundle_absent_caught
        bundle_abi_mismatch_caught)
    if(TEST ${_bt})
        set_tests_properties(${_bt} PROPERTIES RESOURCE_LOCK bundle_artifacts)
    endif()
endforeach()
