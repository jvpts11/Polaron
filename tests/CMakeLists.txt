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

# ---- Codegen tests (only when the LLVM backend is built) ----
if(LDP3_WITH_LLVM)
    # The emitted IR contains an i32 main and a printf call.
    add_test(NAME codegen_emits_ir
        COMMAND ldp3c "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3")
    set_tests_properties(codegen_emits_ir PROPERTIES
        PASS_REGULAR_EXPRESSION "define i32 @main")

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
