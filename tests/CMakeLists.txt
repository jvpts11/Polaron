# CTest wiring for the LDP3 compiler.
#
# Two layers: integration smoke tests over the ldp3c driver, and granular
# unit tests (doctest) over the lexer/parser/semantic libraries.

# ---- Integration tests (driver) ----
add_test(NAME cli_version COMMAND ldp3c --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3c 0\\.1\\.0-dev")

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

# catch of a non-polymorphic class must be rejected (was a silent catch-all).
add_test(NAME sema_rejects_catch_nonpoly
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/catch_nonpoly_bad.ldp3")
set_tests_properties(sema_rejects_catch_nonpoly PROPERTIES
    PASS_REGULAR_EXPRESSION "must participate in a class hierarchy")

# a `const` initializer that is not a compile-time constant must be rejected (spec 28.1).
add_test(NAME sema_rejects_nonconst_const
    COMMAND ldp3c --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/const_nonconst_bad.ldp3")
set_tests_properties(sema_rejects_nonconst_const PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

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
        PASS_REGULAR_EXPRESSION "call void @free")

    # Full pipeline: compile to .exe with clang and check it prints correctly.
    find_program(LDP3_CLANG clang HINTS "C:/Program Files/LLVM/bin")
    if(LDP3_CLANG)
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

        # M6: System.IO.readInt() via scanf; stdin "3 4" -> a=3 b=4 soma=7.
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

        # lazy region (spec 37.3): the backing block is allocated on first object insertion; an
        # unused lazy region is never allocated.
        add_test(NAME codegen_lazy_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DLDP3C=$<TARGET_FILE:ldp3c>"
            "-DCLANG=${LDP3_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_region.ldp3"
            "-DEXPECTED=v=42"
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
)
target_link_libraries(ldp3_unit_tests PRIVATE ldp3_core doctest::doctest)
add_test(NAME unit_tests COMMAND ldp3_unit_tests)
