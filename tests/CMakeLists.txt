# CTest wiring for the Polaron compiler.
#
# Two layers: integration smoke tests over the polc driver, and granular
# unit tests (doctest) over the lexer/parser/semantic libraries.

# ---- Integration tests (driver) ----
add_test(NAME borrow_call_arguments COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>" "-DSAMPLES=${CMAKE_CURRENT_SOURCE_DIR}/samples"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_borrow_call_arguments.cmake")
# The toolchain version lives in six places and every bump has to touch all of them. Pinning them
# one at a time is what let them drift -- polc said 1.0.0 while polaron said 1.0.13, and the language
# reference's stamp sat 30 versions behind because no test looked at it. `version_sites` below reads
# polc's kVersion as the canonical version and requires every other site to repeat it, so a
# half-done bump fails there rather than shipping.
add_test(NAME version_sites COMMAND "${CMAKE_COMMAND}"
    "-DROOT=${CMAKE_CURRENT_SOURCE_DIR}/.."
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_version_sites_test.cmake")
add_test(NAME cli_version COMMAND polc --version)
set_tests_properties(cli_version PROPERTIES
    PASS_REGULAR_EXPRESSION "polc 1\\.0\\.174")

# ---- PIR (docs/design/polaron-ir.md) ----
#
# Stage 1: a real program lowers to PIR and the module VERIFIES. The check is not "did it print
# something" -- it is that `pir::verify` found nothing to say about a module lowered from a program
# with the whole standard library monomorphised into it. A lowering can keep producing text long
# after it stopped producing a well-formed module, and that is exactly what this refuses to let
# happen quietly.
#
# Gaps are expected here and are not failures: they are the work queue, printed and counted.
# ...and the four shapes that were found producing a module which does NOT verify: rule 19 on an
# `async` guard nothing unwinds to, on a `try` whose body cannot throw, and on a landing reached only
# by a division guard's edge; rule 2 on an empty block the deep-clone lowering left behind. Every one
# of them was silent -- `polc` prints the complaint and exits 0, and nothing in the suite read that
# stream, so eighteen complaints sat in the corpus while one of them segfaulted on Linux.
foreach(sample fixed_array type_queries collections_basic abstain_raii
               async_try lint_shapes try_all_catches_return cascade_clone)
    add_test(NAME pir_lowers_${sample} COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/${sample}.pol"
        "-DOUT=${CMAKE_CURRENT_BINARY_DIR}/pir_${sample}.ll"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_verify_test.cmake")
endforeach()

# The two the list above cannot express: a compilation that is REFUSED (and must still not complain
# about its own IR while refusing), and a LIBRARY build, which is the only thing that emits the
# prelude's own `try` blocks -- `Test.assertDoesNotThrow` among them.
add_test(NAME pir_lowers_ffi_syscall_refusal COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_syscall.pol"
    "-DOUT=${CMAKE_CURRENT_BINARY_DIR}/pir_ffi_syscall.ll"
    "-DREFUSAL_OK=ON"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_verify_test.cmake")
add_test(NAME pir_lowers_library_prelude COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.pol"
    "-DOUT=${CMAKE_CURRENT_BINARY_DIR}/pir_library_prelude.polb"
    "-DLIB=ON"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_verify_test.cmake")

# Stage 2: the second backend emits a module LLVM accepts, and §12's facts actually arrive.
if(POLARON_WITH_LLVM)
    foreach(sample fixed_array collections_basic)
        add_test(NAME pir_backend_${sample} COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/${sample}.pol"
            "-DOUT=${CMAKE_CURRENT_BINARY_DIR}/pirback_${sample}.ll"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_backend_test.cmake")
    endforeach()

    # Stage 3's ORACLE STOOD HERE -- `pir_differential_*`, which required every function the trusted
    # path defined to exist in the PIR module, ratcheted so the count could only go down. It reached
    # one each (`Test.__onClassLoad`, synthesised for the test framework) and then it reached its
    # purpose: the flip happened, and the path it compared against is deleted.
    if(POLARON_CLANG)
        # `pir_behaviour_*` STOOD HERE: nine samples built BOTH ways, linked, run, and required to
        # print the same thing and to exit holding the same bytes in the same number of blocks.
        #
        # Every one of the nine is still tested, and none of them lost anything that was about the
        # PROGRAM. What each pair asserted was `output(A) == output(B)` and `live(A) == live(B)`, and
        # both halves survive as the absolute form directly below: `live_<sample>` pins the exit
        # heap against a recorded number, and the sample's own `codegen_<sample>` pins its output.
        # A comparison of two arms says less than a number, not more -- it cannot tell you that BOTH
        # arms are wrong, which is what four of Wave 1's defects turned out to be.
        #
        # Why these nine, kept as a list because the reasons are the record of what a corpus cannot
        # reach on its own:
        #
        #   addr_static           not one of the 844 samples stored the address of an object in a
        #                         static. pico's ring-3 guest does -- two `atomic<int>` cells on a
        #                         frame outliving every thread it spawns -- and PIR read an INVENTED
        #                         global rather than the pointer, so the kernel reported a user page
        #                         fault at CR2=0x8. Eight lines reproduce it.
        #   entry_wrapper         the synthesised `main` was SKIPPED by the shape comparison (609 of
        #                         the census's 9 402 difference lines were that one function), so
        #                         something had to assert what it must DO: argv built and intact,
        #                         static class load before the first line of user code, exit 0.
        #   unwind_raii           the defect it guards was invisible to output on every sample that
        #                         had it -- the rethrow edge existed and nothing walked it.
        #   generator             identical output from the first day, and 304 bytes in 12 blocks
        #                         against 112 in 5: three `foreach`es over generators, none
        #                         disposed, plus a `delete` through an interface-typed local that
        #                         ran the destructor and left the block. Nothing stdout can see.
        #
        # ---- THE ABSOLUTE HALF: what each program still holds when it ends, against a number ----
        #
        # Every check above is a COMPARISON, and a comparison stops existing when the second side is
        # deleted -- which Wave 2 does. Worse, it was never able to see the other thing at all: PIR
        # was built against the trusted path, so a defect in BOTH never diverges. Five memory defects
        # reached the census that way, and three of the four found afterwards were wrong answers
        # rather than divergences.
        #
        # These numbers were read off working binaries and written down by somebody who looked. When
        # one moves, either the program changed or a defect landed; `POLARON_LIVE=2` prints the
        # breakdown by size class and usually names it -- a 24-byte block is a String object and
        # almost nothing else.
        #
        # `112/5` is what the prelude itself leaves behind, so it is the floor for a program that
        # holds nothing of its own. The samples that sit above it say why in their own comments.
        #
        # TWO OF THEM CAME DOWN TO THE FLOOR WHEN §11.5 LANDED, and the ratchet is what made me look
        # -- which is the whole of what it is for. `random_shuffle` writes `new Random(...) on heap`
        # twice and deletes neither: two 16-byte objects, `144/7` -> `112/5`. `region_field_dtor`
        # holds one the same way, `128/6` -> `112/5`. Escape analysis proved neither leaves its
        # frame and gave it the frame, so the object dies with the call and the leak is not there to
        # count any more.
        #
        # The numbers were not changed to make a test green. They were changed because the programs
        # now hold what they hold, and the reason is written here so the next move has to justify
        # itself against a stated cause rather than against a number somebody once read off.
        set(LIVE_hello_world           "112/5")
        set(LIVE_addr_static           "112/5")
        set(LIVE_entry_wrapper         "112/5")
        set(LIVE_unwind_raii           "144/7")
        set(LIVE_bare_object_dispatch  "112/5")
        set(LIVE_region_field_dtor     "112/5")   # was 128/6; §11.5 gave its one un-freed object the frame
        set(LIVE_receiver_once         "112/5")
        set(LIVE_generator             "112/5")
        set(LIVE_struct_array_stride   "112/5")
        set(LIVE_value_compat          "112/5")
        set(LIVE_value_try             "112/5")
        set(LIVE_custom_iterator       "112/5")
        set(LIVE_enum_singleton_once   "112/5")
        set(LIVE_value_element_copy    "112/5")
        set(LIVE_scoped                "112/5")
        set(LIVE_shadow_namespace_name "112/5")
        set(LIVE_lossy_widening        "112/5")
        # THESE TWO FELL BY EIGHT BYTES PER OBJECT, and nothing about them leaks differently.
        #
        # Every class in the prelude used to be given an implicit `Object` base whether or not it
        # needed one -- the last debt `dynamic` left behind, one word in `assignObjectRoot`. The word
        # is gone, so a prelude class with nothing in front of it no longer carries a vtable pointer
        # it never used. `400/17 -> 304/17` is twelve surviving objects × 8; `176/7 -> 160/7` is two.
        # The BLOCK COUNTS are unchanged in both, which is the half that says this is a size change
        # and not a lifetime one: the same objects are alive, each smaller.
        set(LIVE_encoding_hex_base64   "304/17")   # was 400/17; -96 = 12 objects × the removed header
        set(LIVE_deep_call_chain       "160/7")    # was 176/7;  -16 =  2 objects × the same
        set(LIVE_random_shuffle        "112/5")   # was 144/7; the two `Random`s it never deleted
        set(LIVE_null_cast_checked     "128/6")
        foreach(sample hello_world addr_static entry_wrapper unwind_raii bare_object_dispatch
                       region_field_dtor receiver_once generator struct_array_stride value_compat
                       value_try custom_iterator enum_singleton_once value_element_copy scoped
                       shadow_namespace_name lossy_widening encoding_hex_base64 deep_call_chain
                       random_shuffle null_cast_checked)
            add_test(NAME live_${sample} COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DCLANG=${POLARON_CLANG}"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/${sample}.pol"
                "-DEXPECT_LIVE=${LIVE_${sample}}"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                "-DRT=${POLARON_RT_OBJ}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_live_test.cmake")
        endforeach()

        # ---- GOLDEN IR: the exact shape of a few functions, written down ----
        #
        # The shape gate is a comparison and stops existing when the second back end does. These
        # recordings replace it for the handful of functions whose shape IS the rule -- chosen small
        # enough that a diff is readable, and one line of reasoning each:
        #
        #   Main.makeValue      §21's value form. Two returns, no allocation, `%__polaron_variant`
        #                       built with `insertvalue`. It is the whole of D2 in nine lines, and
        #                       the shape a regression would break first.
        #   Holder.fieldOffCall D14. `return table().n;` is ONE call in the source, and this is the
        #                       function where it was two.
        #   Snap.Snap           D1. A constructor that nulls its String field, copies the incoming
        #                       one and releases what was there -- the protocol, in order.
        #
        # A recording is updated by running once with POLARON_BLESS_GOLDEN=1 and READING the result,
        # which is deliberately a thing somebody has to decide to do.
        foreach(g "value_compat:Main.makeValue" "implicit_this_receiver:Holder.fieldOffCall"
                  "value_copy_string_field:Snap.Snap")
            string(FIND "${g}" ":" _at)
            string(SUBSTRING "${g}" 0 ${_at} _sample)
            math(EXPR _rest "${_at} + 1")
            string(SUBSTRING "${g}" ${_rest} -1 _fn)
            add_test(NAME golden_ir_${_sample} COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/${_sample}.pol"
                "-DFUNCTION=${_fn}"
                "-DGOLDEN=${CMAKE_CURRENT_SOURCE_DIR}/golden/${_sample}.${_fn}.ll"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_golden_ir_test.cmake")
        endforeach()

        # ...and this one bites too. `POLARON_REINTRODUCE_D14` restores the double evaluation of a
        # receiver, which makes `Holder.fieldOffCall` call `Holder.table` twice -- so the recording
        # must stop matching. Registered `WILL_FAIL`: it passes when the check refuses.
        add_test(NAME golden_ir_catches_reintroduced_defect COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/implicit_this_receiver.pol"
            "-DFUNCTION=Holder.fieldOffCall"
            "-DGOLDEN=${CMAKE_CURRENT_SOURCE_DIR}/golden/implicit_this_receiver.Holder.fieldOffCall.ll"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_golden_ir_test.cmake")
        set_tests_properties(golden_ir_catches_reintroduced_defect PROPERTIES
            ENVIRONMENT "POLARON_REINTRODUCE_D14=1"
            WILL_FAIL TRUE)

        # ---- AND WHAT THE MACHINE ACTUALLY GETS, read out of the object ----
        #
        # `x86_intrcc` in the IR is a REQUEST. What makes an interrupt handler correct is that its
        # epilogue is `iretq` and not `retq`: an ordinary return against a stack the CPU laid out for
        # an interrupt return corrupts the interrupted context, silently, and no IR-level check can
        # tell the two apart. The differential could not either -- both paths emitted the attribute.
        #
        # Two handlers in the sample, so two `iret`. An exact count, because "at least one" would
        # pass a build that got the second one wrong.
        find_program(POLARON_OBJDUMP llvm-objdump HINTS "C:/Program Files/LLVM/bin" "/usr/bin" "/usr/local/bin")
        if(POLARON_OBJDUMP)
            add_test(NAME object_interrupt_returns_with_iret COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DCLANG=${POLARON_CLANG}"
                "-DOBJDUMP=${POLARON_OBJDUMP}"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.pol"
                "-DPOLARONFLAGS=--target=x86_64-unknown-none"
                "-DCLANGFLAGS=--target=x86_64-unknown-none -ffreestanding"
                "-DNEEDLE=iret"
                "-DCOUNT=2"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_object_test.cmake")

            # ...and the same object must not call the allocator. A handler runs at an IRQL where
            # taking the allocator's lock deadlocks, and on bare metal there is no allocator at all.
            add_test(NAME object_interrupt_does_not_allocate COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DCLANG=${POLARON_CLANG}"
                "-DOBJDUMP=${POLARON_OBJDUMP}"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.pol"
                "-DPOLARONFLAGS=--target=x86_64-unknown-none"
                "-DCLANGFLAGS=--target=x86_64-unknown-none -ffreestanding"
                "-DNEEDLE=__polaron_malloc"
                "-DCOUNT=0"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_object_test.cmake")
        endif()

        # ...AND A CHECK THAT HAS NEVER BEEN SEEN TO FAIL IS A CLAIM, NOT AN INSTRUMENT.
        #
        # Wave 2's exit criterion asks for the absolute checks to be "demonstrated to fail on a
        # reintroduced defect BEFORE the deletion", and this is that demonstration, kept as a test so
        # it stays true. `POLARON_REINTRODUCE_D6` restores exactly one leak the wave fixed -- a
        # `String` handed back by a call, not recorded as a temporary -- and the same sample that
        # passes at 304/17 above must then fail against it.
        #
        # It keeps the CLEAN expectation on purpose: the test asserts the check refuses, so the
        # number here is the one the program measures WITHOUT the defect, and the defect's own
        # number never has to be written down or maintained.
        #
        # `WILL_FAIL` inverts the verdict: this test passes when the check it runs REFUSES. If the
        # instrument ever stops noticing, this goes red, which is the only way an absent alarm can
        # announce itself.
        add_test(NAME live_catches_reintroduced_defect COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/encoding_hex_base64.pol"
            "-DEXPECT_LIVE=304/17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            "-DRT=${POLARON_RT_OBJ}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_live_test.cmake")
        set_tests_properties(live_catches_reintroduced_defect PROPERTIES
            ENVIRONMENT "POLARON_REINTRODUCE_D6=1"
            WILL_FAIL TRUE)

        # `pir_shape_classified` AND `pir_batch_agreement` STOOD HERE, and both are gone with the
        # second back end, on 2026-08-25.
        #
        # They were the two largest instruments in this file. `pir_batch_agreement` compiled a
        # hundred and twenty samples BOTH ways, linked and ran each pair, and required identical
        # output; `pir_shape_classified` compared the two modules body by body and checked every
        # remaining difference against a classification in `tests/pir_shape_baseline.md`. Between
        # them they found most of what Wave 1 fixed.
        #
        # Neither can be kept, and neither can be half-kept: a comparison with one arm is not a
        # weaker comparison, it is a program compiled and run with nothing to check the answer
        # against. What replaces them is directly above -- `live_*`, `golden_ir_*`, `object_*` --
        # and the replacement is not like-for-like on purpose. An absolute check is the only kind
        # that can say a back end is WRONG rather than merely DIFFERENT, which matters because PIR
        # was built against the trusted path: four of the defects Wave 1 closed had been sitting in
        # both, agreeing with each other, called correct by every comparison in this file.
    endif()
endif()

# THE REFERENCE COVERS THE LANGUAGE, checked against the compiler rather than against good intentions.
# Every keyword the lexer reserves and every diagnostic code the compiler can emit must appear in the
# chapter that lists them. Nine keywords and eighty codes were missing when this was first run.
add_test(NAME reference_covers_the_language COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DROOT=${CMAKE_CURRENT_SOURCE_DIR}/.."
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_reference_coverage_test.cmake")

# AND THE OTHER HALF OF THE MANUAL: every public type in the standard library is mentioned somewhere
# in the reference. Measured before it existed: 109 of 338 were not, and nobody had noticed, because
# a manual's absences are invisible -- documentation is not read looking for what is missing from it.
add_test(NAME reference_covers_the_stdlib COMMAND "${CMAKE_COMMAND}"
    "-DROOT=${CMAKE_CURRENT_SOURCE_DIR}/.."
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_stdlib_coverage_test.cmake")

# EVERY EXAMPLE COMPILES, RUNS, AND PRINTS WHAT ITS HEADER SAYS IT PRINTS. An example that does not
# build is a lie told where a reader is most likely to trust it, and the seven that lived here before
# had never been built by anything at all.
add_test(NAME examples_run COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DEXAMPLES=${CMAKE_CURRENT_SOURCE_DIR}/../examples"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_examples_test.cmake")
# NINETY, AND IT SAYS WHY. Every other test in this suite fits inside the thirty-second default, and a
# test that needs more should have to explain itself rather than inherit a number nobody chose. This
# one builds and RUNS each example end to end -- polc, clang and a link per example -- and takes about
# thirty-seven seconds; ninety is that with room for a slower machine and still short enough that a
# wedged build is noticed while somebody is still watching.
set_tests_properties(examples_run PROPERTIES TIMEOUT 90)

# ---- polaron driver (unified toolchain) integration tests ----
add_test(NAME polaron_version COMMAND polaron --version)
set_tests_properties(polaron_version PROPERTIES
    PASS_REGULAR_EXPRESSION "polaron 1\\.0\\.174")

# polaron-studio (the TUI): renders one frame of the shell non-interactively (no clang needed).
add_test(NAME polaron_studio_shell COMMAND "${CMAKE_COMMAND}"
    "-DSTUDIO=$<TARGET_FILE:polaron-studio>"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_studio_selftest.cmake")
set_tests_properties(polaron_studio_shell PROPERTIES TIMEOUT 30)

add_test(NAME polaron_new_scaffolds
    COMMAND polaron new demoproj
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set_tests_properties(polaron_new_scaffolds PROPERTIES
    PASS_REGULAR_EXPRESSION "created project 'demoproj'")

add_test(NAME polaron_new_wrote_manifest
    COMMAND "${CMAKE_COMMAND}" -E cat "${CMAKE_CURRENT_BINARY_DIR}/demoproj/polaron.toml")
set_tests_properties(polaron_new_wrote_manifest PROPERTIES
    DEPENDS polaron_new_scaffolds
    PASS_REGULAR_EXPRESSION "\\[polaron_project\\]")

# plug/unplug: hermetic local-git fixture, cloned + compiled to a .polb (needs polc + git, not clang).
add_test(NAME polaron_plug_unplug COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_plug_test.cmake")
set_tests_properties(polaron_plug_unplug PROPERTIES TIMEOUT 90)

# ... and the installed library may span several files: the fixture's entry names a class declared in
# its sibling, which is how one-type-per-file libraries are written and how this used to fail.
add_test(NAME polaron_plug_multifile COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_plug_multifile_test.cmake")
set_tests_properties(polaron_plug_multifile PROPERTIES TIMEOUT 120)

# Version ranges: several tags, plug ^1.0.0 resolves to the highest 1.x (needs polc + git, not clang).
add_test(NAME polaron_version_range COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_range_test.cmake")
set_tests_properties(polaron_version_range PROPERTIES TIMEOUT 90)

# plug (no args) + lockfile: a fresh clone installs its declared deps and reproduces from the lock.
add_test(NAME polaron_plug_all COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_plugall_test.cmake")
set_tests_properties(polaron_plug_all PROPERTIES TIMEOUT 90)

# THE OPEN WORLD: a C++ program calls into Polaron through the generated header.
#
# Everything else end-to-end here is Polaron calling Polaron. The closed world is checked by exact
# verification against the .polh fingerprint; the open world had a working export mechanism, no header
# for anyone to read, and nothing that ever tried it from the far side.
if(POLARON_CLANG)
    add_test(NAME abi_c_export_calls_in COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DCLANG=${POLARON_CLANG}"
        "-DPOL=${CMAKE_CURRENT_SOURCE_DIR}/samples/c_export_api.pol"
        "-DCALLER=${CMAKE_CURRENT_SOURCE_DIR}/samples/c_export_caller.cpp"
        "-DEXPECTED=add=42 squares=338350 even7=0 even8=1"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_c_export_test.cmake")
endif()

# WEBASSEMBLY: the module LINKS, which is a step past "the backend accepts it". polc emits wasm32 IR,
# clang assembles it, and wasm-ld produces a real module -- checked for the `\0asm` magic and for the
# method actually being in it. There is no wasm host on this machine (no node, no wasmtime), so this
# is as far as verification reaches; it is a missing tool rather than missing work.
find_program(POLARON_WASM_LD wasm-ld HINTS "C:/Program Files/LLVM/bin" "/usr/bin" "/usr/local/bin")
if(POLARON_CLANG AND POLARON_WASM_LD)
    add_test(NAME port_wasm32_links COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DCLANG=${POLARON_CLANG}"
        "-DWASMLD=${POLARON_WASM_LD}"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wasm_pure_math.pol"
        "-DSYMBOL=Squares.sumTo"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_wasm_link_test.cmake")

    # ...and the DRIVER builds one, importing nothing. The test above drives polc/clang/wasm-ld by
    # hand, which proved the compiler and the linker were ready while saying nothing about
    # `polaron build` -- and `polaron build` could not produce a wasm module at all: the freestanding
    # path linked with `ld.lld` unconditionally and a wasm object is not an ELF ("unknown file type").
    # It also exposed the entry wrapper marshalling an argv that a bare wasm module does not have, for
    # want of the substring `none` in `wasm32-unknown-unknown`.
    #
    # The assertion is NO undefined symbols, not "it linked": an undefined symbol in a wasm module is
    # an IMPORT, a demand on the host, so linking proves nothing about self-containment.
    find_program(POLARON_LLVM_NM llvm-nm HINTS "C:/Program Files/LLVM/bin" "/usr/bin" "/usr/local/bin")
    if(POLARON_LLVM_NM)
        add_test(NAME port_wasm32_driver_builds COMMAND "${CMAKE_COMMAND}"
            "-DPOLARON=$<TARGET_FILE:polaron>"
            "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/wasm"
            "-DMODULE=${CMAKE_CURRENT_SOURCE_DIR}/wasm/build-output/wasmmod.wasm"
            "-DNM=${POLARON_LLVM_NM}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_wasm_build_test.cmake")
    endif()

    # A BARE-METAL IMAGE WITH ITS OWN `heap class`, and the claim is only that it LINKS.
    #
    # That combination had no test, and the hole was exactly shaped: the freestanding tests either
    # inspect the IR or boot under QEMU, and a duplicate symbol is invisible to both -- it is not a
    # property of one module, it appears when the driver's shim object meets the one codegen made.
    # Codegen emits `define @__polaron_malloc` from the program's heap class; the driver decided
    # whether to supply an allocator by looking for that NAME in the IR, saw codegen's own definition,
    # and supplied a second. Every freestanding program with a heap class stopped linking, the suite
    # stayed green, and the pico kernel could not be built at all.
    add_test(NAME port_freestanding_heap_class_links COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/fsheap"
        "-DIMAGE=${CMAKE_CURRENT_SOURCE_DIR}/fsheap/build-output/fsheap.elf"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_fs_build_test.cmake")

    # A UEFI APPLICATION, WHICH IS THE ONE IMAGE FORMAT THAT IS NOT AN ELF.
    #
    # `image = "efi"` produces a PE32+ executable, because the firmware on a machine built in the last
    # several years reads a PE header and nothing else -- it will not read a boot sector, so every
    # other route this compiler offers is unreachable there. The format's failures are all header
    # fields: the wrong machine type, the wrong subsystem, or an ELF written under a `.efi` name
    # because the driver quietly took the ordinary freestanding path. None of them fails the link,
    # none is visible in the IR, and all three look the same from outside -- a machine that boots
    # something else.
    add_test(NAME port_uefi_application_builds COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/efiapp"
        "-DIMAGE=${CMAKE_CURRENT_SOURCE_DIR}/efiapp/build-output/efiapp.efi"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_efi_build_test.cmake")

    # ...and the module RUNS IN A BROWSER. The two tests above stop at the artifact -- it links, it has
    # the right symbols, it imports nothing -- and none of that catches a module that instantiates and
    # then traps on its first allocation. Which is what happened: codegen declared `memset` with a
    # 64-bit length on a 32-bit target, x86 ignored the extra half for years, and WebAssembly checks
    # signatures and traps. `new Box() on heap` worked while `new byte[16]()` beside it did not.
    find_program(POLARON_CHROME NAMES chrome google-chrome chromium msedge
        HINTS "C:/Program Files/Google/Chrome/Application"
              "C:/Program Files (x86)/Microsoft/Edge/Application" "/usr/bin")
    if(POLARON_CHROME)
        add_test(NAME port_wasm32_runs_in_browser COMMAND "${CMAKE_COMMAND}"
            "-DPOLARON=$<TARGET_FILE:polaron>"
            "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/wasmsite"
            "-DMODULE=${CMAKE_CURRENT_SOURCE_DIR}/wasmsite/build-output/wasmsite.wasm"
            "-DCHROME=${POLARON_CHROME}"
            "-DPAGE=${CMAKE_CURRENT_BINARY_DIR}/wasmsite.html"
            "-DSHOT=${CMAKE_CURRENT_BINARY_DIR}/wasmsite"
            "-DEXPECTED=Polaron says 42 after 2 clicks"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_wasm_browser_test.cmake")
        set_tests_properties(port_wasm32_runs_in_browser PROPERTIES TIMEOUT 180)
    else()
        message(STATUS "no Chrome/Edge found: the wasm browser test will not run")
    endif()
endif()

# EVERY TARGET, WITHOUT OWNING ONE. The C-library signature audit runs on the host and needs neither a
# cross toolchain nor an emulator, because what it checks is what polc DECLARES.
#
# This exists because the same mistake was made four times in one day -- `memcpy`, `memset`, a third
# `memcpy` call site, and `strlen`, each with a fixed 64-bit width, each right on x86-64 and wrong on
# every 32-bit target. Two were found by WebAssembly (which checks signatures and traps), one by i686,
# one by reading. LLVM's own verifier cannot help: it checks a call against its declaration, and both
# were wrong together.
#
# The rows below run everywhere, including Windows, which is the point: a width bug should not need
# somebody to own the other machine before anyone can see it.
add_test(NAME codegen_libc_signatures_match_target COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DPROGRAM=${CMAKE_CURRENT_SOURCE_DIR}/samples/crossarch_hosted.pol"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_libc_audit_test.cmake")

# THE HOSTED RUNTIME ON OTHER ARCHITECTURES, cross-compiled and RUN under qemu-user.
#
# The boot tests below prove the compiler and the freestanding shims on AArch64 and i686. They prove
# nothing about the hosted runtime, which a kernel does not link -- and that half was recorded as
# blocked on tooling this machine did not have. It does now:
#
#   apt-get install qemu-user gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
#     gcc-riscv64-linux-gnu g++-riscv64-linux-gnu gcc-i686-linux-gnu g++-i686-linux-gnu \
#     gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
#
# Each row is skipped when its toolchain is absent, so this costs Windows nothing and turns on wherever
# the pieces exist.
#
# THE 32-BIT ROWS ARE THE ONES THAT EARN THEIR KEEP. i686 caught a `memcpy` length still declared 64
# bits at a call site that had escaped the helper -- 64-bit targets cannot see that bug, because there
# the wrong width happens to be the right one, and x86-64 had hidden it for years. armv7 is the second
# 32-bit machine and a different word order and ABI besides.
foreach(_arch aarch64 riscv64 i686 armv7 powerpc m68k)
    # Each row carries its own triple, compiler NAME and sysroot -- none of them follows from the
    # architecture. armv7's tools are `arm-linux-gnueabihf-*` and it is HARD FLOAT, because that is
    # what the Debian/Ubuntu cross toolchain builds and a soft-float object will not link against it;
    # powerpc's compiler is only shipped versioned. Hence full names rather than a prefix rule.
    if(_arch STREQUAL "aarch64")
        set(_triple aarch64-unknown-linux-gnu)
        set(_qemuname qemu-aarch64)
        set(_sysroot /usr/aarch64-linux-gnu)
        set(_gxxnames aarch64-linux-gnu-g++)
    elseif(_arch STREQUAL "riscv64")
        set(_triple riscv64-unknown-linux-gnu)
        set(_qemuname qemu-riscv64)
        set(_sysroot /usr/riscv64-linux-gnu)
        set(_gxxnames riscv64-linux-gnu-g++)
    elseif(_arch STREQUAL "i686")
        set(_triple i686-unknown-linux-gnu)
        set(_qemuname qemu-i386)
        set(_sysroot /usr/i686-linux-gnu)
        set(_gxxnames i686-linux-gnu-g++)
    elseif(_arch STREQUAL "armv7")
        set(_triple armv7-unknown-linux-gnueabihf)
        set(_qemuname qemu-arm)
        set(_sysroot /usr/arm-linux-gnueabihf)
        set(_gxxnames arm-linux-gnueabihf-g++)
    elseif(_arch STREQUAL "powerpc")
        # 32-bit PowerPC, and the row that proves the width fix: the compiler has NO data layout for
        # this target, so its pointer width comes from the triple alone (see `sizeTy`). Ubuntu ships
        # this toolchain only versioned, hence the second candidate name.
        set(_triple powerpc-unknown-linux-gnu)
        set(_qemuname qemu-ppc)
        set(_sysroot /usr/powerpc-linux-gnu)
        set(_gxxnames powerpc-linux-gnu-g++ powerpc-linux-gnu-g++-12)
    else()
        # 68000. The row that proves the assembly rewrite: without it LLVM's 16-bit PC-relative
        # addressing makes this target unlinkable for any program with a runtime behind it.
        set(_triple m68k-unknown-linux-gnu)
        set(_qemuname qemu-m68k)
        set(_sysroot /usr/m68k-linux-gnu)
        set(_gxxnames m68k-linux-gnu-g++ m68k-linux-gnu-g++-12)
    endif()
    find_program(POLARON_CROSS_GXX_${_arch} NAMES ${_gxxnames})
    find_program(POLARON_QEMU_USER_${_arch} ${_qemuname})
    if(POLARON_CROSS_GXX_${_arch} AND POLARON_QEMU_USER_${_arch} AND EXISTS "${_sysroot}")
        add_test(NAME port_${_arch}_hosted_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DPOLARON=$<TARGET_FILE:polaron>"
            "-DPROGRAM=${CMAKE_CURRENT_SOURCE_DIR}/samples/crossarch_hosted.pol"
            "-DTRIPLE=${_triple}"
            "-DCROSS_GXX=${POLARON_CROSS_GXX_${_arch}}"
            "-DSYSROOT=${_sysroot}"
            "-DQEMU=${POLARON_QEMU_USER_${_arch}}"
            "-DRUNTIME=${CMAKE_CURRENT_SOURCE_DIR}/../runtime/polaron_rt.cpp"
            "-DEXPECTED=polaron: 42, len 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_crossarch_test.cmake")
        set_tests_properties(port_${_arch}_hosted_runs PROPERTIES TIMEOUT 300)
    endif()
endforeach()

# A BINARY FOR DISTRIBUTIONS OLDER THAN THIS ONE. Linux only: the question does not exist on Windows.
#
# What stops a Linux binary running elsewhere is a versioned symbol, not a distribution name. Built
# here a Polaron program requires up to `GLIBC_2.34` (2021), and anything older refuses to start it
# with a message about the loader. `--static` removes the requirement entirely, and this test asserts
# the ABSENCE -- a static link that silently fell back to dynamic would still link and still run here.
if(UNIX AND NOT APPLE)
    find_program(POLARON_READELF readelf)
    find_program(POLARON_OBJDUMP objdump)
    if(POLARON_READELF AND POLARON_OBJDUMP)
        add_test(NAME build_static_has_no_glibc_requirement COMMAND "${CMAKE_COMMAND}"
            "-DPOLARON=$<TARGET_FILE:polaron>"
            "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/staticprj"
            "-DEXE=${CMAKE_CURRENT_SOURCE_DIR}/staticprj/build-output/distroproof"
            "-DEXPECTED=distro-proof 42 len 12"
            "-DREADELF=${POLARON_READELF}"
            "-DOBJDUMP=${POLARON_OBJDUMP}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_static_link_test.cmake")
        set_tests_properties(build_static_has_no_glibc_requirement PROPERTIES TIMEOUT 300)
    endif()
endif()

# An `interrupt` handler is an x86 calling convention (`x86_intrcc`) and exists nowhere else. Ungated,
# polc emitted it for AArch64 and clang's BACKEND died with "unsupported calling convention" plus an
# invitation to file a bug against LLVM -- no source line, no method name, wrong project.
add_test(NAME port_interrupt_needs_x86 COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_atomic_ok.pol"
    "-DTARGET_TRIPLE=aarch64-unknown-none-elf"
    "-DEXPECT_ERROR=`interrupt` is an x86 calling convention"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_target_error_test.cmake")

# ... and a feature the target does not have is REFUSED with the reason, which is the whole agreement
# behind the port: an old or small machine may be missing something, and the compiler says which.
add_test(NAME port_wasm32_threads_error COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_counter.pol"
    "-DTARGET_TRIPLE=wasm32-unknown-unknown"
    "-DEXPECT_ERROR=threads are not available on wasm32-unknown-unknown"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_target_error_test.cmake")

# POLARON RUNS ON ARM, and this is where that is proved rather than asserted.
#
# Reading the emitted IR shows a target COMPILES; it cannot show that the image boots. This builds the
# bare-metal AArch64 project under tests/arm64 and runs it on QEMU's `virt` board, checking the serial
# output for the sum the guest computes -- 0x529ae, which is only right if the AArch64 lowering is.
#
# Skipped, not failed, when QEMU is absent: a machine without an ARM emulator can still run the suite,
# and a test that fails for want of a tool teaches people to ignore failures.
find_program(POLARON_QEMU_AARCH64 qemu-system-aarch64
    HINTS "C:/Program Files/qemu" "/usr/bin" "/usr/local/bin")
if(POLARON_QEMU_AARCH64)
    add_test(NAME port_aarch64_boots COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/arm64"
        "-DIMAGE=${CMAKE_CURRENT_SOURCE_DIR}/arm64/build-output/arm64boot.elf"
        "-DQEMU=${POLARON_QEMU_AARCH64}"
        "-DMACHINE=virt"
        "-DCPU=cortex-a57"
        # ...AND A FLAVOURED REGION, which is the region CORE rather than the arena: a descriptor the
        # runtime lays out, a per-slot header, and a free-list. Six hundred objects through a region
        # of one kilobyte, so the answer arriving at all is slot reclaim working and the answer being
        # right is every slot reading back as what was stored in it.
        #
        # ON THIS ROW AND NOT ON i686, and that is a finding rather than a preference: the core is
        # C++ and divides 64-bit numbers, so a 32-bit freestanding link asks for `__udivdi3` and
        # `__umoddi3` and fails. Flavoured regions have never worked on a 32-bit bare-metal target.
        "-DEXPECTED=sum1..100^2 = 0x00000000000529ae;pool = 0x0000000000007404"
        "-DSERIAL=${CMAKE_CURRENT_BINARY_DIR}/arm64boot.serial.txt"
        "-DTIMEOUT=20"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_qemu_boot_test.cmake")
    set_tests_properties(port_aarch64_boots PROPERTIES TIMEOUT 120)
else()
    message(STATUS "qemu-system-aarch64 not found: the AArch64 boot test will not run")
endif()

# ... and on a Pentium III, which is the machine this port was actually aimed at.
#
# 32-bit x86 shares nothing with x86-64 but a family name: 32-bit registers, a different ABI, and no
# 64-bit arithmetic in one instruction. The guest computes the same sum in a `long`, so every shift
# below 32 bits crosses a register boundary and the answer is right only if the i686 lowering is.
find_program(POLARON_QEMU_I386 qemu-system-i386
    HINTS "C:/Program Files/qemu" "/usr/bin" "/usr/local/bin")
if(POLARON_QEMU_I386)
    add_test(NAME port_i686_boots COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DPROJECT=${CMAKE_CURRENT_SOURCE_DIR}/i686"
        "-DIMAGE=${CMAKE_CURRENT_SOURCE_DIR}/i686/build-output/i686boot.elf"
        "-DQEMU=${POLARON_QEMU_I386}"
        "-DMACHINE=pc"
        "-DCPU=pentium3"
        # THREE CLAIMS, ONE BOOT. The sum is the 64-bit arithmetic. The ports are a region class on
        # bare metal: its arena is static here rather than reserved address space, and its
        # `Descriptor*` fields are 32-bit offsets from that arena's base, so the sum comes out right
        # only if each narrow pointer read back as the object that was stored -- a wrong base does
        # not fail to link, it walks into the arena. 0x3f8 + 0x2f8 + 0x3e8 = 2776 = 0xad8.
        #
        # AND THE THIRD IS THE FAILURE REPORTER, which is Polaron now rather than a generated C++
        # translation unit, and which had nothing asserting it beyond the fact that it linked. The
        # first time this ran it said `jÔ = 8591002698, Sÿ = 412318131120`: the three texts were
        # declared `address`, which means SIXTY-FOUR BITS in Polaron, against the `ptr` codegen
        # emits -- four bytes wide on this machine -- so every argument after the first was read from
        # the wrong offset. A 64-bit target cannot show that, which is what puts this on the i686 row.
        "-DEXPECTED=sum1..100^2 = 0x00000000000529ae;ports = 0x0000000000000ad8;index = 2776, length = 12"
        "-DSERIAL=${CMAKE_CURRENT_BINARY_DIR}/i686boot.serial.txt"
        "-DTIMEOUT=20"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_qemu_boot_test.cmake")
    set_tests_properties(port_i686_boots PROPERTIES TIMEOUT 120)
else()
    message(STATUS "qemu-system-i386 not found: the i686 boot test will not run")
endif()

if(POLARON_CLANG)
    # THE RUNTIME IS COMPILED ONCE, not once per test. Every end-to-end test used to hand clang
    # `runtime/polaron_rt.cpp`, so each of them rebuilt winsock2, windows.h and the whole runtime from
    # source to produce an object identical to the one the test before it had just produced --
    # measured at 1.63 s each, which was roughly half the wall-clock of the entire suite.
    #
    # Built here with the SAME clang the tests link with, rather than reusing the MSVC-built
    # polaron_rt.lib: same-ABI or not, mixing the two compilers is the kind of thing that works in 656
    # tests and fails in one. Wired into the build (not a test) so it exists before anything runs,
    # whatever order ctest -j picks.
    set(POLARON_RT_OBJ "${CMAKE_CURRENT_BINARY_DIR}/polaron_rt_clang${CMAKE_C_OUTPUT_EXTENSION}")
    add_custom_command(OUTPUT "${POLARON_RT_OBJ}"
        COMMAND "${POLARON_CLANG}" -c "${CMAKE_CURRENT_SOURCE_DIR}/../runtime/polaron_rt.cpp"
                -o "${POLARON_RT_OBJ}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../runtime/polaron_rt.cpp"
        COMMENT "Compiling the Polaron runtime once for the end-to-end tests")
    add_custom_target(polaron_rt_for_tests ALL DEPENDS "${POLARON_RT_OBJ}")

    add_test(NAME polaron_compile_produces_exe
        COMMAND polaron compile "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    # No .exe in the regex: the driver names the binary hello_world.exe on Windows, hello_world on POSIX.
    set_tests_properties(polaron_compile_produces_exe PROPERTIES
        PASS_REGULAR_EXPRESSION "wrote .*hello_world")

    add_test(NAME polaron_build_project
        COMMAND polaron build
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(polaron_build_project PROPERTIES
        DEPENDS polaron_new_scaffolds
        PASS_REGULAR_EXPRESSION "wrote .*demoproj")

    # A debug build (-g -O0, DWARF) still compiles and links the project (a debugger's breakpoint binding
    # and variable reading are proven separately with @@LOW@@UPPLINGB@@@@-dap).
    add_test(NAME polaron_build_debug
        COMMAND polaron build --debug
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(polaron_build_debug PROPERTIES
        DEPENDS polaron_new_scaffolds
        PASS_REGULAR_EXPRESSION "wrote .*demoproj")

    add_test(NAME polaron_run_bare_file
        COMMAND polaron run "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    set_tests_properties(polaron_run_bare_file PROPERTIES
        PASS_REGULAR_EXPRESSION "Resultado: 42")

    add_test(NAME polaron_clean_removes_output
        COMMAND polaron clean
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(polaron_clean_removes_output PROPERTIES
        DEPENDS polaron_build_project
        PASS_REGULAR_EXPRESSION "cleaned")

    # ONE PROJECT DIRECTORY, FIVE TESTS THAT WRITE IN IT. `polaron_build_project` and
    # `polaron_build_debug` both run `polaron build` inside `demoproj`, into the same `build-output`,
    # and `clean` deletes that out from under whichever is still going. `DEPENDS` orders them after
    # the scaffold and says nothing about each other, so under `-j` they collide -- measured here as
    # `polaron_build_debug` failing in a full run and passing on its own.
    #
    # Same defect the bundle tests had, and the same fix: a shared LOCK, not a fixed order, because
    # what they contend for is the directory and not a sequence. Worth the two minutes, because a
    # failure that goes away when you re-run trains you to re-run instead of to look -- which is
    # exactly how a real one gets waved through.
    foreach(_dp polaron_new_scaffolds polaron_new_wrote_manifest polaron_build_project
                polaron_build_debug polaron_clean_removes_output)
        if(TEST ${_dp})
            set_tests_properties(${_dp} PROPERTIES RESOURCE_LOCK demoproj)
        endif()
    endforeach()

    # End to end: plug a local library and build+run a consumer that calls into it.
    add_test(NAME polaron_dep_build COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_dep_build_test.cmake")
    set_tests_properties(polaron_dep_build PROPERTIES TIMEOUT 90)

    # Environments: env new, plug -e into it, build a consumer that declares it, list, remove.
    add_test(NAME polaron_environments COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_env_test.cmake")
    set_tests_properties(polaron_environments PROPERTIES TIMEOUT 90)

    # `polaron fmt`: normalize whitespace, idempotently, without changing what the program does.
    add_test(NAME polaron_fmt_command COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_fmt_test.cmake")
    set_tests_properties(polaron_fmt_command PROPERTIES TIMEOUT 90)

    # `polaron doc`: render public API HTML from /// comments (parse-only, no clang needed but grouped here).
    add_test(NAME polaron_doc_command COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_doc_test.cmake")
    set_tests_properties(polaron_doc_command PROPERTIES TIMEOUT 60)

    # `polaron test`: discover and run [Test] methods, failing the command when a test fails.
    add_test(NAME polaron_test_command COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_test_cmd_test.cmake")
    set_tests_properties(polaron_test_command PROPERTIES TIMEOUT 90)

    # Transitive deps: plug xlib (which depends on ylib); build a consumer that links the whole closure.
    add_test(NAME polaron_transitive_deps COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_transitive_test.cmake")
    set_tests_properties(polaron_transitive_deps PROPERTIES TIMEOUT 120)
endif()

add_test(NAME lexer_dumps_tokens
    COMMAND polc --dump-tokens "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol")
set_tests_properties(lexer_dumps_tokens PROPERTIES
    PASS_REGULAR_EXPRESSION "KwProgram")

add_test(NAME parser_dumps_ast
    COMMAND polc --dump-ast "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol")
set_tests_properties(parser_dumps_ast PROPERTIES
    PASS_REGULAR_EXPRESSION "Program 'HelloWorld'")

# PORTING: an `asm` block names the architecture it is written for, and building for another one is an
# ERROR FROM POLARON rather than a message from clang's assembler about a file called `<inline asm>`.
# The compiler cannot port assembly; what it can do is say so at the line that wrote it.
add_test(NAME codegen_asm_wrong_arch_errors
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_wrong_arch.pol"
            --target=aarch64-unknown-linux-gnu -o "${CMAKE_CURRENT_BINARY_DIR}/asm_wrong_arch.ll")
set_tests_properties(codegen_asm_wrong_arch_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "block is written for x86_64, and the target is aarch64")

# ...and the same source is fine for the architecture it WAS written for. No output pattern: the claim
# is that it compiles, and ctest already fails a non-zero exit. Asserting a message here would test the
# wording of a success rather than the success.
add_test(NAME codegen_asm_right_arch_ok
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_wrong_arch.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/asm_right_arch.ll")

# ---- THE ADDRESS FAMILY, AND THE DISCIPLINE THAT MAKES IT WORTH HAVING ----
#
# Three tests, and the middle one is the important one: a warning that fires on correct code is a
# warning people learn to ignore, so the positive sample is deliberately full of masks, distances,
# page numbers and widened counts -- every shape that looks like an address and is not.
add_test(NAME sema_address_discipline_is_quiet_on_correct_code
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_discipline.pol")
set_tests_properties(sema_address_discipline_is_quiet_on_correct_code PROPERTIES
    FAIL_REGULAR_EXPRESSION "Polaron-0B4D|Polaron-0B4E")

# ...and it does fire on the two shapes it is for. A number used as an address, and an address stored
# in a number: both warnings, so the program still compiles.
add_test(NAME sema_address_discipline_flags_a_constant_used_as_an_address
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_discipline_bad.pol")
set_tests_properties(sema_address_discipline_flags_a_constant_used_as_an_address PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0B4D")

add_test(NAME sema_address_discipline_flags_an_address_in_an_int
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_discipline_bad.pol")
set_tests_properties(sema_address_discipline_flags_an_address_in_an_int PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0B4E")

# A `weak` FIELD OVER AN INTERFACE ATE ITS TARGET'S FIELDS.
#
# The intrusive weak list's head was placed after each class's own fields and located by the field's
# STATIC type, so `weak SomeInterface*` wrote the head eight bytes into the implementer -- over its
# first two fields, silently. The head now sits directly behind the vtable pointer for every class in
# a weakly-referenced hierarchy, so a base and its subclasses agree on where it is. Run rather than
# inspected: the failure was corrupted DATA, which no IR pattern would have caught.
add_test(NAME codegen_weak_through_interface_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_through_interface.pol"
    "-DEXPECTED=624 x 384 / through weak: 624 x 384 / after unlink: 624 x 384"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A HOSTED PROGRAM FOR A 32-BIT MACHINE. The i686 data layout has been in `dataLayoutFor` all along,
# so `--target=i686-pc-windows-msvc` always produced correct 32-bit IR -- and then had nothing to link
# against, because `polaron_rt.lib` is x86-64. Correct IR and an unlinkable program is worse than no
# support, because it looks like support. This builds one through the DRIVER, from a manifest, checks
# the PE machine word really is i386, runs it, and reads back a pointer size of 4.
if(WIN32)
    add_test(NAME driver_i686_hosted_runs COMMAND "${CMAKE_COMMAND}"
        "-DPOLARON=$<TARGET_FILE:polaron>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hosted_i686.pol"
        "-DEXPECTED=Point(1, 1) Point(2, 4) Point(3, 9) big=123456789000 addr=8 half=4"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_i686_hosted_test.cmake")
endif()

# A `record` WITH A 64-BIT FIELD COULD NOT BE DECLARED: the generated `hashCode` accumulates into an
# `int`, and a `long` field made it assign a `long` to it -- reported on the `public record` line,
# about an assignment nobody wrote. The float fields had been folded down for this reason years ago;
# the wide integers were the same problem one type across, and nothing in the corpus had put a `long`
# in a record until a reader of OLE property sets needed one for a FILETIME.
add_test(NAME codegen_record_long_field_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_long_field.pol"
    "-DEXPECTED=Stamp(133700000000000000, 7) equal=true different=false hashed=true"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A RECORD HOLDING AN ARRAY, which could not be declared at all: the generated `toString` asked a
# `byte[]` to describe itself, the error named the record rather than the field, and a hand-written
# `toString` was refused as a duplicate name. The key generation had always left arrays out -- two
# arrays holding the same bytes are different arrays -- and this is that fact reaching the other
# generated method. Without it, a compound-file directory slot has to be spelled as parallel lists.
add_test(NAME codegen_record_array_field_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_array_field.pol"
    "-DEXPECTED=Slot(/Contents, byte[128], byte[9482]) 9482"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A CODE ADDRESS, TAKEN AND CALLED. `methodptr<Ret, Params...>` is the FFI's near side and the type
# a destructor registry stores; `Class.method` without a call is where one comes from. The TYPE
# worked and the CALL did not: the predicate deciding whether a value is callable knew only the
# closure spelling while carrying a comment naming both, so `f(21)` fell through to method
# resolution by name and came out as `call i32 %21()` -- the argument called, with no arguments.
# Compiled clean, every time, and the type had no test anywhere in the repository.
add_test(NAME codegen_methodptr_calls_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/methodptr_calls.pol"
    "-DEXPECTED=42 30 done"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and the SHAPE of that call, because a right answer does not prove a right instruction.
#
# `call void %` is the assertion, and it is the one the bug could never satisfy: the broken path had
# no return type to give the instruction and fell back to `i32` every time, so a `methodptr<void,
# int>` came out as `call i32 %n()`. Written without register numbers, so it survives any
# renumbering of the lowering; written as the VOID call, so it fails on the exact defect.
add_test(NAME ir_methodptr_call_carries_its_return_type COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/methodptr_calls.pol"
    "-DFUNCTION=Main.main"
    "-DNEEDLE=call void %"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_fn_contains_test.cmake")

# STORAGE THAT EXISTS BEFORE THE PROGRAM DOES: `new T[N]() on static`. Two arrays, so that separate
# storage is proven rather than assumed, and both ends of each one written and read back -- the
# length word lives at offset zero and an off-by-a-header reads it as an element.
add_test(NAME codegen_static_array_storage_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_array_storage.pol"
    "-DEXPECTED=1024 7 9 256 3"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...AND IT IS ZEROES IN THE IMAGE, which is the half the printed answer cannot show. A global whose
# initialiser carries the length word is a `.data` global, and 65 536 zeroes then travel in the file:
# measured on the four bootstrap buffers this exists for, some 450 KiB against a kernel of 1.9 MB.
# The exact spelling is pinned because "all zero" is the whole claim -- `1032` is `int[256]` plus the
# eight-byte header, and a change to either shows up here rather than as a fatter image.
add_test(NAME ir_static_array_is_zeroed_in_the_image COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_array_storage.pol"
    "-DNEEDLE=@Vault.counts.storage = internal global [1032 x i8] zeroinitializer"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# AND TOUCHING ONE COSTS NO ALLOCATION, which is the entire reason the placement exists: the layer
# that needs it is the one the allocator is built on. `on stack` said this and did the opposite --
# an array's placement was read by nothing, so `new byte[1024]() on stack` in this compiler's own
# bare-metal failure reporter called `__polaron_malloc(1032)` from inside a fired guard.
add_test(NAME ir_static_array_costs_no_allocation COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_array_storage.pol"
    "-DFUNCTION=Vault.poke"
    "-DNEEDLE=__polaron_malloc"
    "-DABSENT=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_fn_contains_test.cmake")

# A RECORD INSIDE A RECORD INSIDE A RECORD, with a `String` at the bottom. The deep copy treated a
# field whose type is a RECORD the way it treats one whose type is a reference class -- allocate a
# sub-object, store its address -- and an inline aggregate is not a pointer: eight bytes of address
# went over the first eight bytes of the sub-object. It takes THREE levels to show, because a record
# directly inside another has no inner field left to misread; the sample uses four, since a fix that
# recurses one level short would pass the three-level case.
add_test(NAME codegen_record_nested_string_field_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_nested_string_field.pol"
    "-DEXPECTED=200 things, 0 wrong Thing7 fmt7 mm7 deep7"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A TRANSFORMER THAT BRINGS A `String`. The `int hits = 0` case was already covered; a String owns
# storage, so an initializer that never runs leaves the field holding whatever the allocation held
# and the first assignment releases it. The fault lands nowhere near the field, as
# STATUS_HEAP_CORRUPTION with no line -- which is how it was found, in a reader whose every command
# died before printing anything.
add_test(NAME codegen_transformer_applied_string_field_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_applied_string_field.pol"
    "-DEXPECTED=first: not opened then: no allocation table cleared: ''"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A TERNARY OVER TWO RECORDS took the first arm every time: one arm is a value read out of storage,
# the other a value built on the spot, the two shapes did not meet, and the else edge silently
# carried `undef`. It wrote a compound file's directory with the root entry's start and size in all
# sixteen records. Joining the shapes is the fix worth having; refusing is the fix available today.
add_test(NAME codegen_rejects_ternary_record_arms
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/ternary_record_arms_bad.pol"
                 -o "${CMAKE_CURRENT_BINARY_DIR}/ternary_record_arms_bad.ll")
set_tests_properties(codegen_rejects_ternary_record_arms PROPERTIES
    PASS_REGULAR_EXPRESSION "the two arms of .\\? :. are shapes this compiler cannot join yet"
    WILL_FAIL FALSE)

# AN ENUM SAID ITS NAME EVERYWHERE EXCEPT IN AN INTERPOLATION, where it said its ordinal.
#
# `k.toString()`, `"" + k` and a record's generated `toString` all reach the method; `$"{k}"` read
# the machine type, found an integer, and printed the number. RUN rather than inspected, because the
# claim is about what the program SAYS -- and the sample pins the other half too: an enum that
# writes no `toString` still prints its ordinal, which is the only answer there is for it.
add_test(NAME codegen_interp_enum_tostring_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_enum_tostring.pol"
    "-DEXPECTED=interp=TWO explicit=TWO record=Holder(ONE, 3) plain=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A POINTER TO A POINTER IS NOT THE POINTER. `T*`, `T&` and `T` mix freely by design; `T**` slipping
# into that set is how the pico desktop shipped blank window titles and an invisible mouse cursor --
# `&this.back` on a field that is already a `Surface*`, accepted silently, drawing into the
# compositor's own fields. The message names the shape, so the test asks for the sentence and not only
# for a failure.
add_test(NAME sema_pointer_to_pointer_is_not_a_pointer
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_depth_bad.pol")
set_tests_properties(sema_pointer_to_pointer_is_not_a_pointer PROPERTIES
    WILL_FAIL TRUE)
add_test(NAME sema_pointer_to_pointer_says_which_way
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_depth_bad.pol")
set_tests_properties(sema_pointer_to_pointer_says_which_way PROPERTIES
    PASS_REGULAR_EXPRESSION "level\\(s\\) of pointer too many")

# A NARROW ADDRESS WIDENS WITH ZEROES, and this is the test for a bug that reached a running machine:
# an argument was widened by `coerceToType`, which sees LLVM types where an i16 carries no signedness,
# and it chose `sext`. `short address` 0x8000 arrived in an `address` parameter as
# 0xFFFF_FFFF_FFFF_8000 and the kernel page-faulted on a non-canonical address. The IR must contain the
# zero-extension; `sext` of that value would be the bug returning.
add_test(NAME codegen_narrow_address_widens_unsigned COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/address_discipline.pol"
    "-DNEEDLE=zext i16"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# `lock xchg` -- the atomic exchange a spinlock is made of, which the asm checker refused outright: it
# read the PREFIX as the mnemonic and reported "'lock' is not a known x86_64 instruction". No output
# pattern, for the same reason as the arch test above: the claim is that it compiles. That it RUNS is
# proved where it is used -- two processors reaching 40000 increments with none lost, which needs two
# processors and so cannot be claimed in this suite.
add_test(NAME codegen_asm_lock_prefix_compiles
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_lock_prefix.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/asm_lock_prefix.ll")

# A PREFIX IS STRIPPED, NOT WAVED THROUGH. `lock` in front of a mnemonic that does not exist is still an
# unknown instruction, and the message names the mnemonic rather than the prefix. Without this the fix
# that accepted `lock xchg` could have been "add lock to the known set", which accepts `lock anything`.
add_test(NAME codegen_asm_lock_prefix_still_checks
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_lock_bad.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/asm_lock_bad.ll")
set_tests_properties(codegen_asm_lock_prefix_still_checks PROPERTIES
    PASS_REGULAR_EXPRESSION "'xhcg' is not a known x86_64 instruction")

# `on heap` on a region class is refused rather than obeyed OR ignored. Ignoring it would be the worst
# of the three: the author wrote a placement and the compiler did something else without saying so.
add_test(NAME codegen_region_class_on_heap_errors
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_on_heap.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/region_class_on_heap.ll")
set_tests_properties(codegen_region_class_on_heap_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is a .region class., so .on heap. has nowhere to put this")

# And `on stack`, which had to be asked for separately: it IS the default, so silence and the written
# word arrive identical unless the parser records which it was. A written placement the compiler
# silently overrides is the case these refusals exist to prevent.
add_test(NAME codegen_region_class_on_stack_errors
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_on_stack.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/region_class_on_stack.ll")
set_tests_properties(codegen_region_class_on_stack_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is a .region class., so .on stack. has nowhere to put this")

# `move x into region R` is `in region R` spelled as a move, and a rule that holds only for the
# spelling it was written against is not a rule.
add_test(NAME codegen_region_class_move_in_errors
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_move_in.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/region_class_move_in.ll")
set_tests_properties(codegen_region_class_move_in_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "would move it out of the only region its instances may be in")

# `private` DENIES SOMEBODY. It was parsed, carried in the AST, written into the `.polh` and printed in
# the generated documentation -- and never reached the analyzer's symbol table, so there was nothing to
# check against. `Polaron-0201` sat in the diagnostic catalog with its explanation written, for a rule
# nothing enforced. TYPE visibility was checked all along, which is what made the hole easy to miss.
add_test(NAME sema_private_member_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/private_member_reached.pol")
set_tests_properties(sema_private_member_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "'secret' is private to 'Dog'")

# The word a type uses to say "not by `new`": a singleton, a factory, a type built only through its own
# static maker. Same cause -- `ClassInfo` never received the constructor's visibility.
add_test(NAME sema_private_constructor_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/private_constructor_reached.pol")
set_tests_properties(sema_private_constructor_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "'Made' is private to 'Made'")

# Static calls resolve on a different path in the compiler, and the region check lived only on the
# instance one -- so handing something to a static was invisible, at the longest-lived storage a
# program has. The scan had the matching gap: a static method names its own class to keep anything.
add_test(NAME sema_escape_through_static_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_through_static.pol")
set_tests_properties(sema_escape_through_static_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "'register' keeps that argument")

# An extern has no body, so no summary can exist and nothing was checked: handing a pointer to C was
# the quiet way out of the whole analysis. `address` is how a program says its proof stops here.
add_test(NAME sema_escape_through_extern_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_through_extern.pol")
set_tests_properties(sema_escape_through_extern_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is an extern function")

# Constructors had no escape summary, so `new Keeper(x)` was checked against nothing -- and that is
# the call every object graph is built out of. The summary does not refuse the construction: it BOUNDS
# the object, so a keeper built over a frame-local item is frame-local whatever `on heap` says, and
# the complaint lands on the `return` that carries it out.
add_test(NAME sema_escape_through_constructor_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_through_constructor.pol")
set_tests_properties(sema_escape_through_constructor_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "returns something that does not outlive the call")

# A call reads the escape summary of the STATIC type, and an interface method has no body. Until the
# summary was unioned onto the interfaces too, calling through one was the only way to hand an object
# somewhere without being seen -- in a program organised around interfaces, that is every call.
add_test(NAME sema_escape_through_interface_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_through_interface.pol")
set_tests_properties(sema_escape_through_interface_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "'keep' keeps that argument")

# The other half of the check above: the branch that empties RETURNS, so nothing reaches the read
# with the rows freed. Refusing correct code is the failure mode that gets an analysis switched off.
add_test(NAME sema_borrow_branch_ok
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_branch_ok.pol")
set_tests_properties(sema_borrow_branch_ok PROPERTIES
    FAIL_REGULAR_EXPRESSION "error")

# A view that outlives what it views. Each of the three statements is fine alone -- build the result,
# empty the table, read the result -- and the order is the bug. This is the shape a database gets
# wrong, and the reason the region binder tracks where a returned collection's contents came from.
add_test(NAME sema_borrow_after_clear_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_after_clear.pol")
set_tests_properties(sema_borrow_after_clear_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "use of 'answer' after 'people' was emptied")

# The rule that nesting in space creates: the parent's release would take the child's storage
# with it, so it may not go first. §10 ordered lifetimes; this makes the order physical.
add_test(NAME sema_subregion_parent_first_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/subregion_bad.pol")
set_tests_properties(sema_subregion_parent_first_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "was carved out of 'world', so its memory is part of this one")

# Interpolation now prints a newtype by its underlying type -- and this is what stops that widening
# from becoming "prints anything". A newtype over a class has no representation printf can take, and
# the message must name what the AUTHOR wrote (`Corner`), not what it resolved to. Without this file
# the check could quietly become no check at all and every sample would still pass.
add_test(NAME sema_interp_newtype_over_class_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_newtype_bad.pol")
set_tests_properties(sema_interp_newtype_over_class_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "interp_newtype_bad.pol:22:53.*got 'Corner'")

# A LIFECYCLE HOOK IS A BODY, and it was not analyzed at all: `onClassLoad` is where a real program
# fills its tables, and none of it was type-checked or held to a `demand`. A type error reached the
# code generator and came back from LLVM's module verifier naming no source line; a `demand 1 == 2`
# built clean, which is an assertion that reads as protection and is not any. Both are ordinary
# errors now. The positive half is `lifecycle_onclassload.pol`, whose hook carries a demand that
# HOLDS -- without it the fix could have been "reject every hook" and this sample would still pass.
add_test(NAME sema_lifecycle_hook_is_analyzed
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_hook_bad.pol")
set_tests_properties(sema_lifecycle_hook_is_analyzed PROPERTIES
    PASS_REGULAR_EXPRESSION "lifecycle_hook_bad.pol:24:17.*demand not met")

# `.rejects({T})` has been in the analyzer since regions arrived and no sample used it. A rule with
# no test is a rule that works until someone refactors near it.
add_test(NAME sema_region_rejects_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_rejects_bad.pol")
set_tests_properties(sema_region_rejects_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "region 'pen' rejects type 'Cat'")

# Everything beneath a region class must be one. A plain class inheriting from an abstract region class
# would put its instances outside the family's region, and totality is the whole feature.
add_test(NAME sema_region_class_escapee_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_escapee.pol")
set_tests_properties(sema_region_class_escapee_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "extends the region class")

# Extraction relocates an object out of a region it would otherwise die with. A region class's arena is
# the only place its instances may be, so there is nowhere to extract TO -- the same refusal as `on heap`.
add_test(NAME sema_region_class_extract_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_extract.pol")
set_tests_properties(sema_region_class_extract_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is a .region class.: its arena is the only place")

# `extern syscall(N)`: a syscall is not a language and has no symbol -- it is the machine's instruction
# with a NUMBER, so the method gets a body rather than a declaration. Checked by reading the IR for
# another target, because a Linux syscall cannot be run here; the constraint string IS the contract
# (rax for the number, rdi/rsi/rdx for the arguments, rcx and r11 destroyed by the instruction).
add_test(NAME codegen_ffi_syscall_emits COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_syscall.pol"
    "-DTARGET_TRIPLE=x86_64-unknown-linux-gnu"
    "-DNEEDLE=asm sideeffect \"syscall\""
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# A METHOD EXPORTED TO SOMETHING OUTSIDE THE PROGRAM SURVIVES REACHABILITY. `unknown <world>` says
# the caller adopts a foreign ABI, so the caller is not in the program and no edge inside it can ever
# reach the method; a `naked` body then takes its own `.bss` down with it when the function goes.
# pico failed to link on `undefined symbol: stack_bottom` -- a label inside an asm body nobody calls.
#
# ITS OWN TEST BECAUSE THE ORACLE IS BLIND TO IT. Every sample is compiled with and without
# reachability and compared against GlobalDCE, which shares the blind spot exactly: it would delete an
# unreferenced entry point too, so both modes agreed and the hole passed. An oracle answers only the
# question it can ask, and a freestanding entry point is a fact about the LINKER, not the module.
add_test(NAME codegen_exported_entry_survives_reachability COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reach_exported_entry.pol"
    "-DNEEDLE=probe_stack_bottom"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# THE NARROW ADDRESS TYPES (docs/design/porting.md): `half address` 32, `short address` 16,
# `byte address` 8, beside the `address` that is 64 on every target. Domain types for addresses that
# genuinely are not the machine's pointer -- a real-mode offset, a zero page, a physical address stored
# narrow in a hardware structure. The needle is the struct: two `shortaddress` fields must lay out as
# two i16, or the type is a comment rather than a type.
add_test(NAME codegen_narrow_address_layout COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_address.pol"
    "-DNEEDLE=%class.RealModePointer = type { i16, i16 }"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# ...and a narrow address is still an ADDRESS: the rule that makes crossing to a number a written cast
# holds for all four widths. Hosted on purpose -- freestanding is exempt, because on bare metal turning
# an integer into an address is the work.
add_test(NAME sema_narrow_address_is_not_a_number
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_address_rule.pol")
set_tests_properties(sema_narrow_address_is_not_a_number PROPERTIES
    PASS_REGULAR_EXPRESSION "An address is not an integer that happens to be that wide"
    WILL_FAIL FALSE)

# THE NARROW `A*` (region-classes design, step 6). A region class's instances all live in one
# contiguous arena, so a pointer to one is its OFFSET from that base -- and an offset fits in 32 bits.
# Narrowed in FIELDS only: that is where the cache win is, while a local lives in a register where 32
# bits buy nothing. Measured against the identical class declared without `region`:
#   without  { ptr, i32, i32, ptr, ptr }  32 bytes
#   with     { ptr, i32, i32, i32, i32 }  24 bytes
# The behaviour test is the one that matters -- a wrong base or a lost null does not fail to link, it
# walks into the arena and dies (or worse, does not).
add_test(NAME codegen_region_class_narrow_layout COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_narrow.pol"
    "-DNEEDLE=%class.Node = type { ptr, i32, i32, i32, i32 }"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# `naked` reaches the IR as an attribute, and this is the first thing that ever checked it. The
# keyword parsed and lowered for months with no sample anywhere -- found by asking which keywords the
# reference never shows in use, which turned out to name a hole in the tests as well as in the manual.
# A lost `naked` does not fail to compile or to link: it produces a function that destroys the stack
# it was handed, at an entry point, where there is nothing left to print the reason with.
add_test(NAME codegen_naked_has_no_prologue COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/naked_entry.pol"
    "-DNEEDLE=attributes #0 = { naked noinline optnone }"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

add_test(NAME codegen_region_class_narrow_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_narrow.pol"
    "-DEXPECTED=1 2 3 4 5 6 7 / root=4 leftmost=1 rightmost=7 / missing=0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# CONTRACTS AS OPTIMIZATIONS: an `invariant` must reach the methods that READ.
#
# Every invariant is handed to the optimiser at entry as an `llvm.assume`. The list being assumed was
# the same one the exit checks had been narrowed to -- "the invariants this method might have broken" --
# so a method assigning no field got an empty list and no assumption at all. Exactly backwards: the
# read-only methods are the ones with something to gain. Measured on `HashMap$int$int`: `slotFor`,
# `get`, `containsKey`, `getOrDefault`, `keyArray` and `valueArray` had ZERO assumes and kept every
# bounds check while `put`/`grow`/`merge`/`remove` had five each. Splitting the lists took the map
# benchmark from 48.2 ms to 39.8.
#
# Scoped to the FUNCTION on purpose: a module-wide grep for `llvm.assume` passes with the bug present,
# because the constructor is special-cased to keep every invariant. That is why this harness exists.
add_test(NAME codegen_invariant_assume_reaches_readonly COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/invariant_assume_readonly.pol"
    "-DFUNCTION=Table.probe"
    "-DNEEDLE=llvm.assume"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_fn_contains_test.cmake")

# ...and it still runs correctly: assuming what is checked must not change the answer.
add_test(NAME codegen_invariant_assume_readonly_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/invariant_assume_readonly.pol"
    "-DEXPECTED=7"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and on a target that has no such contract, the compiler says so instead of emitting something that
# assembles and then does something arbitrary.
# THE TARGET IS NAMED, not inherited from whatever machine runs the suite.
#
# This used to compile for the host and assume the host was Windows. On Linux the host target IS
# `x86_64-linux`, which is the RIGHT target for a Linux syscall -- so polc accepted it, correctly, and
# the test failed for being written from one machine's point of view. The first Linux run of this
# suite is what said so.
add_test(NAME codegen_ffi_syscall_wrong_target_errors
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_syscall.pol"
            --target=x86_64-pc-windows-msvc
            -o "${CMAKE_CURRENT_BINARY_DIR}/ffi_syscall_win.ll")
set_tests_properties(codegen_ffi_syscall_wrong_target_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is available on Linux/x86-64")

# `cdecl` binding a mangled symbol: a warning, because the evidence is in the name and no C compiler
# produces an Itanium or MSVC mangling. Not an error -- pasting a mangled symbol by hand is how a C++
# binding works without a mangler of our own.
add_test(NAME sema_ffi_mangled_cdecl_warns
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_mangled_cdecl.pol")
set_tests_properties(sema_ffi_mangled_cdecl_warns PROPERTIES
    PASS_REGULAR_EXPRESSION "is an Itanium MANGLED name")

# A foreign function is a class member and only that: the namespace-level forms declared a loose
# function, ignored their own visibility, and threw away the library name they parsed.
# A dotted region READS ITS QUALIFIER. `Other.arena` used to resolve to `this.arena` -- silently, when
# the caller had a field of the same name -- in both the analyser and codegen.
add_test(NAME sema_region_qualifier_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_qualifier_ignored.pol")
set_tests_properties(sema_region_qualifier_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "is an instance field of 'Other', so there is no object here")

# ... and the other half of the same fix: a STATIC region field, which parsed and was unusable.
add_test(NAME codegen_region_static_field_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_static_field.pol"
    "-DEXPECTED=shared 7 11"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A GENERIC CLASS KEEPS ITS CONTRACTS. `cloneClass` copied eighteen things about a class and dropped
# the nineteenth -- `invariants` -- so every instantiated generic ran with its clauses unenforced. The
# stdlib's HashMap declares five and none of them had ever executed.
add_test(NAME contracts_generic_invariant_enforced COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_invariant_enforced.pol"
    "-DEXPECT_EXIT=1"
    "-DERRCONTAINS=invariant this.count >= 0"
    "-DCONTAINS=built 0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# `release region <family root>` -- the phase arena freed when the phase ends, and rebuilt lazily by
# the next `new`. The case explicit release exists for: a region class's arena belongs to the TYPE, so
# its lifetime would otherwise be the program's.
add_test(NAME codegen_region_class_release_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_release.pol"
    "-DCONTAINS=after release: 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ... and the guard on it firing: releasing an arena with something still in it would hand every live
# reference a dangling pointer, so it is refused with the family named.
add_test(NAME codegen_region_class_release_live_panics COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_release_live.pol"
    "-DEXPECT_EXIT=70"
    "-DERRCONTAINS=cannot release the region of 'Node': instances of it are still alive"
    "-DCONTAINS=built 7"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# The library list the driver reads back to build the link line: a set of libraries, not of classes.
add_test(NAME driver_foreign_library_list COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library_list.pol"
    "-DEXPECTED=C;SDL2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_foreign_libs_test.cmake")

# ... and it crosses a bundle boundary: the consumer declares nothing, its dependency declares SDL2.
add_test(NAME driver_foreign_library_crosses_bundle COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library_bundle_lib.pol"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library_bundle_app.pol"
    "-DEXPECTED=SDL2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_foreign_libs_test.cmake")

# ... and the mapping crosses a PROJECT boundary: the consumer's manifest says nothing about libraries,
# and the link still resolves the name through its dependency's manifest.
add_test(NAME driver_dependency_library_map COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_dep_libmap_test.cmake")
set_tests_properties(driver_dependency_library_map PROPERTIES TIMEOUT 120)

# `extern stdcall` on the target where it MEANS something: 32-bit x86, where the callee cleans the
# stack and the symbol is decorated `@N`. Both the declaration and the call site must carry it -- a
# declaration alone would be a callee promising one thing and every caller doing another.
add_test(NAME codegen_stdcall_is_real_on_i686 COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_stdcall.pol"
    "-DTARGET_TRIPLE=i686-pc-windows-msvc"
    "-DNEEDLE=call x86_stdcallcc i32 @MessageBeep"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# ... and the other half: on x86-64 the three conventions are one ABI, so the word costs nothing and
# must emit nothing. Without this, "supported" could mean a convention stamped where the backend
# cannot express it -- which fails inside LLVM, with no source line.
add_test(NAME codegen_stdcall_is_nothing_on_x86_64 COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_stdcall.pol"
    "-DNEEDLE=x86_stdcallcc"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

# A library whose class shares a short name with a standard-library class still links. That collision
# gives the STANDARD LIBRARY's class a qualified key, and the bundle used to carry it strongly.
add_test(NAME driver_library_shares_a_stdlib_name COMMAND "${CMAKE_COMMAND}"
    "-DPOLARON=$<TARGET_FILE:polaron>"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_shared_name_lib_test.cmake")
set_tests_properties(driver_library_shares_a_stdlib_name PROPERTIES TIMEOUT 180)

add_test(NAME parser_loose_extern_errors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_loose_extern.pol")
set_tests_properties(parser_loose_extern_errors PROPERTIES
    PASS_REGULAR_EXPRESSION "a foreign function is declared as a member of a class")

add_test(NAME sema_accepts_entry_point
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol")
set_tests_properties(sema_accepts_entry_point PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

add_test(NAME sema_rejects_no_entry
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/no_entry.pol")
set_tests_properties(sema_rejects_no_entry PROPERTIES
    PASS_REGULAR_EXPRESSION "no entry point")

# A field name declared twice in one class compiled silently: the layout got a slot per declaration and
# every use resolved to the last one, leaving the first as storage never written and never read. The
# method case has been rejected for a long time; the field case was simply missing, and agents-exe
# carried a dead duplicate `int[] best` for weeks with nothing noticing.
# Option/Result have two representations and only the `*` tells them apart. Mixing them compiled: a
# pointer went into a variant slot and `match` read the tag out of it -- measured, `match` answered 0
# for a Some(7). No error, no crash, wrong answer. The message has to name both spellings, because
# both are legal Polaron and the target is what chooses.
add_test(NAME sema_rejects_boxed_sum_into_value
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/option_boxed_into_value_bad.pol")
set_tests_properties(sema_rejects_boxed_sum_into_value PROPERTIES
    PASS_REGULAR_EXPRESSION "'Option' plain is the value form: build it with 'Some\\(...\\)' and no 'new'")

add_test(NAME sema_rejects_duplicate_field
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/duplicate_field_bad.pol")
set_tests_properties(sema_rejects_duplicate_field PROPERTIES
    PASS_REGULAR_EXPRESSION "field 'n' is already declared in class 'Box'")

# spec 32.11: a test that reads another class's [BeforeAll]/[AfterAll] fixture is reading state that
# class may already have torn down. It cost a whole afternoon in agents-exe, where it surfaced as an
# access violation in a suite that had printed nothing but passes. Warned, not rejected: the compiler
# cannot know the lifetime, only that the shape is the one that goes wrong.
add_test(NAME sema_warns_cross_class_fixture
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/cross_class_fixture_bad.pol")
set_tests_properties(sema_warns_cross_class_fixture PROPERTIES
    PASS_REGULAR_EXPRESSION "this test reads 'Fixture', which owns a \\[BeforeAll\\]/\\[AfterAll\\] fixture, from class 'Readers'")

# The RETURN must check the type of what it returns, not only its nullability (Polaron-0303). Without it,
# `return someDog;` from a method `returns Cat` produced valid IR and reinterpreted the object -- vtable
# pointer included -- because every class is an opaque `ptr` at the LLVM level. The sample also holds the
# three shapes that must KEEP compiling (a literal adapting, a narrower int widening, a subclass), so a
# fix that over-rejects fails here too instead of quietly costing everyone a cast.
add_test(NAME sema_rejects_wrong_return_type
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/return_type_bad.pol")
set_tests_properties(sema_rejects_wrong_return_type PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot return a value of type 'Dog' from a method returning 'Cat'")

# Signed and unsigned operands may not be mixed: `address(1) < int(-1)` answered TRUE, because -1
# sign-extends and the comparison is then unsigned. WIDTH is deliberately not the rule -- a narrower
# integer widens silently, and `address`/`ulong` are one type under two names. The sample carries five
# forms that must keep compiling, so an over-strict rule fails this test too.
add_test(NAME sema_rejects_mixed_signedness
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/mixed_signedness_bad.pol")
set_tests_properties(sema_rejects_mixed_signedness PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot mix signed and unsigned operands")

# The three-state flow analysis (uninitialized / valid / moved-deleted) the guide has always described
# and the implementation did not have. The parser used to forbid the uninitialized state outright, so it
# could not arise. This file holds the REJECTIONS; flow_states.pol holds the shapes that must keep
# compiling, so a too-strict analysis fails that one and a too-loose one fails this.
add_test(NAME sema_rejects_uninitialized_read
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/flow_states_bad.pol")
set_tests_properties(sema_rejects_uninitialized_read PROPERTIES
    PASS_REGULAR_EXPRESSION "is used before it is initialized")

# Null safety has its OWN code (Polaron-0300). Folded into Polaron-0301 it inherited that code's advice --
# "convert explicitly with cast<T>(value)" -- which cannot work, because casting does not turn null into
# a non-nullable value. Pins the CODE, not the prose, so the wording stays free to improve.
add_test(NAME sema_null_error_has_own_code
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/null_to_nonnullable_bad.pol")
set_tests_properties(sema_null_error_has_own_code PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0300")

# --check accepts a whole program spanning several files (what an editor checks), not just one file.
add_test(NAME check_accepts_multifile_program
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_b.pol"
                          "${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_a.pol")
set_tests_properties(check_accepts_multifile_program PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

# --overlay: the bytes come from a scratch copy (an unsaved buffer), the diagnostics name the real file.
# The clean base checks clean; overlaid with the broken scratch, the error is reported -- against the base.
add_test(NAME check_base_is_clean
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.pol")
set_tests_properties(check_base_is_clean PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

add_test(NAME check_overlay_reports_against_the_real_file
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.pol"
            --overlay "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.pol=${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_broken.pol")
set_tests_properties(check_overlay_reports_against_the_real_file PROPERTIES
    WILL_FAIL TRUE)

# The same run, checking the diagnostic names overlay_base (the real file), not overlay_broken (the scratch).
add_test(NAME check_overlay_names_the_base_not_the_scratch
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.pol"
            --overlay "${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_base.pol=${CMAKE_CURRENT_SOURCE_DIR}/samples/overlay_broken.pol")
set_tests_properties(check_overlay_names_the_base_not_the_scratch PROPERTIES
    PASS_REGULAR_EXPRESSION "overlay_base.pol:[0-9]+:[0-9]+: error\\[Polaron-[0-9]+\\]: use of undeclared variable 'undeclaredHere'")

# A name error offers "did you mean?" with the closest field / local (what powers the editor quick fix).
add_test(NAME check_suggests_the_closest_field
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.pol")
set_tests_properties(check_suggests_the_closest_field PROPERTIES
    PASS_REGULAR_EXPRESSION "no field 'heigth'; did you mean 'height'")

add_test(NAME check_suggests_the_closest_local
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.pol")
set_tests_properties(check_suggests_the_closest_local PROPERTIES
    PASS_REGULAR_EXPRESSION "undeclared variable 'totl'; did you mean 'total'")

# Rich diagnostics: a normal build (not --check/-q) prints why / fix / prevent under the error, with a
# stable code and a source snippet.
add_test(NAME rich_diagnostic_has_why_fix_prevent
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.pol" -o "${CMAKE_CURRENT_BINARY_DIR}/dym.ll")
set_tests_properties(rich_diagnostic_has_why_fix_prevent PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-0102\\].*\n.*\n.*\n.*\n.* why: ")

# --check / -q stays one machine-parseable line per diagnostic, now carrying the code.
add_test(NAME concise_diagnostic_is_one_line_with_code
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/did_you_mean_bad.pol" -o "${CMAKE_CURRENT_BINARY_DIR}/dym.ll" -q)
set_tests_properties(concise_diagnostic_is_one_line_with_code PROPERTIES
    PASS_REGULAR_EXPRESSION "did_you_mean_bad.pol:[0-9]+:[0-9]+: error\\[Polaron-0102\\]: class 'Point' has no field")

# The monomorphizer, the transformer expander and the layout checker report from their own files, so
# they had neither the compiled source nor the map from the concatenated library back to its subject
# files: their diagnostics printed with nothing under the caret. One resolver, installed by the
# driver, gives every reporting site both.
add_test(NAME every_reporter_shows_its_source_line
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bound_untrusted_bad.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/tbu.ll")
set_tests_properties(every_reporter_shows_its_source_line PROPERTIES
    PASS_REGULAR_EXPRESSION "25 \\| .*public procedure into<Yards y>")

# THE WRITE-UP PRINTS EVERY TIME. An earlier version showed it once per code and pointed later
# occurrences back at the first, which decides for the reader that they have had enough explaining --
# and someone fixing the fourth of four errors is looking at that one, not scrolling up.
add_test(NAME rich_writeup_prints_on_every_diagnostic
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol" -o "${CMAKE_CURRENT_BINARY_DIR}/hw_once.ll")
set_tests_properties(rich_writeup_prints_on_every_diagnostic PROPERTIES
    PASS_REGULAR_EXPRESSION "why:.*\n(.*\n)+.*why:")

# ...and `--noVerbose` is how a reader who already knows says so, once, on the command line.
add_test(NAME noverbose_drops_the_writeup
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol" -o "${CMAKE_CURRENT_BINARY_DIR}/hw_nv.ll" --noVerbose)
set_tests_properties(noverbose_drops_the_writeup PROPERTIES
    PASS_REGULAR_EXPRESSION "see:     .polc --explain Polaron-0B01."
    FAIL_REGULAR_EXPRESSION " why: ")

# Errors red, warnings yellow -- the escapes go OUTSIDE the token, so `error[Polaron-NNNN]` stays one
# unbroken substring for a grep and for every regex in this file. (CMake has no `\033`, so the escape
# byte is built rather than written.)
string(ASCII 27 POLARON_ESC)
add_test(NAME diagnostics_are_coloured_by_severity
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_after_clear.pol" --color)
set_tests_properties(diagnostics_are_coloured_by_severity PROPERTIES
    PASS_REGULAR_EXPRESSION "${POLARON_ESC}\\[31merror\\[Polaron-1724\\]${POLARON_ESC}\\[0m")

add_test(NAME warnings_are_coloured_yellow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol" --color)
set_tests_properties(warnings_are_coloured_yellow PROPERTIES
    PASS_REGULAR_EXPRESSION "${POLARON_ESC}\\[33mwarning\\[Polaron-0B01\\]${POLARON_ESC}\\[0m")

# A `String` REBUILT ON EVERY TURN OF A LOOP (Polaron-0B0B). `String` is immutable, so `s = s + piece`
# allocates and copies everything accumulated so far -- 18.5x on this compiler's own benchmarks, and
# invisible at the site, because the line that pays is the shortest one in the body.
add_test(NAME lint_string_building_in_a_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/string_build_loop.pol")
set_tests_properties(lint_string_building_in_a_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0B\\]: 'out' is rebuilt")

# ...and it is NARROW, which is the half that makes it worth having. An accumulator declared inside
# the loop starts empty every iteration, a fixed number of pieces outside a loop is what `+` is for,
# and the builder is the fix -- so none of the three may be named. A lint that fires on the fix it
# recommends is a lint people turn off.
add_test(NAME lint_string_building_is_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/string_build_loop.pol")
set_tests_properties(lint_string_building_is_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'line' is rebuilt|'joined' is rebuilt|'sb' is rebuilt")

# ADVICE ABOUT THE STANDARD LIBRARY IS NOT THE READER'S PROBLEM. The prelude arrives with every
# program, is the same in all of them, and nothing in the reader's own file can change a line of it.
# The first structural lint made the point at once: a real (and bounded) re-copying buffer in
# `Tls.pol` printed four times on every hello-world, which is how a useful warning teaches people to
# stop reading warnings.
#
# THE EXAMPLE MOVED FROM 0B0B TO 0B40, because 0B0B was the re-copying buffer and it is now zero --
# the two record readers carry an `[Allow]` naming the bound the protocol puts on them. A pair of
# tests that pin a specific code has to be pointed at a code that still fires, and 0B40 is the one
# with a hundred and seventy of them and a note in the baseline saying why they stay.
add_test(NAME lint_prelude_advice_is_hidden_by_default
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol")
set_tests_properties(lint_prelude_advice_is_hidden_by_default PROPERTIES
    FAIL_REGULAR_EXPRESSION "Polaron-0B40")

# ...and the other half, or the standard library becomes the one code base the lints never see.
add_test(NAME lint_prelude_advice_can_be_asked_for
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol" --lint-prelude)
set_tests_properties(lint_prelude_advice_can_be_asked_for PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0B40")

# `mutable` NEVER MUTATED (Polaron-0B0D). A name is constant unless it says the word, so `mutable` is
# a declaration that this will change and every reader plans for it. The rule is EXACT rather than
# conservative, and the sample is where that is pinned: writing an array element through the name,
# writing a field through it, deleting it and handing it to a call are all things that need no
# `mutable`, checked against the compiler rather than assumed.
add_test(NAME lint_mutable_never_mutated
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_shapes.pol")
set_tests_properties(lint_mutable_never_mutated PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0D\\]: 'spare' is declared mutable")

# ...and the loop counter, which really is reassigned, must stay quiet.
add_test(NAME lint_mutable_spares_a_real_mutation
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_shapes.pol")
set_tests_properties(lint_mutable_spares_a_real_mutation PROPERTIES
    FAIL_REGULAR_EXPRESSION "'total' is declared mutable|'i' is declared mutable")

# A CATCH WITH AN EMPTY BODY destroys the evidence at the one point where it existed (Polaron-0B0E).
add_test(NAME lint_swallowed_catch
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_shapes.pol")
set_tests_properties(lint_swallowed_catch PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0E\\]: this catch has an empty body")

# `async` WITH NOTHING TO SUSPEND ON pays for a state machine, a Task and a scheduling hop and uses
# none of it (Polaron-0B0F) -- and the method that does await must not be named.
add_test(NAME lint_async_never_awaits
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_async.pol")
set_tests_properties(lint_async_never_awaits PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0F\\]: 'idle' is async"
    FAIL_REGULAR_EXPRESSION "'real' is async")

# `[Allow(code:, why:)]` -- THE ESCAPE VALVE. Advice is a rule about a shape, and a shape can be
# right for a reason the compiler cannot see; without a way to say so the first honest disagreement
# makes the whole set noise. On the method, and on the class for everything inside it.
add_test(NAME lint_allow_suppresses_with_a_reason
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_allow.pol")
set_tests_properties(lint_allow_suppresses_with_a_reason PROPERTIES
    FAIL_REGULAR_EXPRESSION "'slot' is declared mutable|'a' is declared mutable|'b' is declared mutable")

# ...and it is a decision per declaration, not a switch somebody flipped for the file.
add_test(NAME lint_allow_is_not_a_file_switch
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_allow.pol")
set_tests_properties(lint_allow_is_not_a_file_switch PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0D\\]: 'other' is declared mutable")

# A STALE `[Allow]` IS A CLAIM THAT HAS STOPPED BEING TRUE (Polaron-0B0C) -- the shape it excused was
# rewritten and the note now describes code that is not there. Worse than no note, because the next
# reader believes it. This is the failure mode the valve itself introduces, so it is caught.
add_test(NAME lint_allow_reports_itself_when_stale
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_allow.pol")
set_tests_properties(lint_allow_reports_itself_when_stale PROPERTIES
    PASS_REGULAR_EXPRESSION "warning\\[Polaron-0B0C\\]: this \\[Allow\\] never suppressed anything")

# The reason is MANDATORY, and it costs nothing to enforce: `why` has no default, so the compiler's
# own required-field check refuses a suppression nobody can review.
add_test(NAME lint_allow_demands_a_reason
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_allow_no_reason.pol")
set_tests_properties(lint_allow_demands_a_reason PROPERTIES
    PASS_REGULAR_EXPRESSION "annotation 'Allow' requires a value for field 'why'")

# THE SIX RULES THE CATALOGUE DESCRIBES IN TERMS THIS LANGUAGE DOES NOT HAVE.
#
# Each was refused once, and each time for the same wrong reason: the analysis the catalogue names is
# unavailable, so the rule was called impossible. Every one of them has a decidable shape that says
# the same thing. `super.m()` cannot be written, but an override with the base's body word for word
# can be compared. `keep` is not a keyword, but the escape summary already says which parameters a
# method stores. Constant folding does remove the arithmetic, but only at some optimisation levels
# and it never gives the value a name.
add_test(NAME lint_constant_computed_at_runtime
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_constant_computed_at_runtime PROPERTIES
    PASS_REGULAR_EXPRESSION "0B47\\]: 'slots' is 64")

add_test(NAME lint_same_guard_at_every_call_site
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_same_guard_at_every_call_site PROPERTIES
    PASS_REGULAR_EXPRESSION "0B48\\]: 2 call sites of 'Proof.guarded'")

# ...and the callee is named by its OWNER, because a bare method name is not one method. Three
# classes with a `grow()` of their own, one call site each, were counted as three call sites of a
# single `grow` -- the same shape as the shared-name defects the compiler has been bitten by before.
add_test(NAME lint_same_guard_does_not_merge_across_classes
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bounds.pol")
set_tests_properties(lint_same_guard_does_not_merge_across_classes PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B48")

# ...and the guard has to be ABOUT the call. A condition naming neither the receiver nor any argument
# is a branch that happens to contain a call, and a `requires` there moves somebody else's question
# into the callee: `if (this.kind == 0) { sb.append("null"); }` was being read as a rule about append.
add_test(NAME lint_same_guard_must_be_about_the_call
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_same_guard_must_be_about_the_call PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B48.*'Proof.blend'")

# Polaron-0B40 SAYS A PRICE IS PAID, so it has to agree with the pass that stops paying it. A loop
# the bounds-check hoister versions runs its fast copy with no per-element check at all, and advising
# against that loop charges for nothing. The rule asks `boundsChecksHoistable` -- the pass's own
# conditions, not a second copy of them -- and this pair fixes both answers: the loop with a call in
# it (which the pass refuses, because a callee could free the array) is reported...
add_test(NAME lint_index_bound_not_the_array
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bounds.pol")
set_tests_properties(lint_index_bound_not_the_array PROPERTIES
    PASS_REGULAR_EXPRESSION "0B40\\]: this loop indexes 'into'")

# ...and the two clean copy loops beside it, of exactly the same shape, are not. Without this the
# narrowing could go all the way to silence and only the ratchet number would notice.
add_test(NAME lint_index_bound_silent_when_hoistable
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bounds.pol")
set_tests_properties(lint_index_bound_silent_when_hoistable PROPERTIES
    FAIL_REGULAR_EXPRESSION "indexes 'bigger'")

add_test(NAME lint_unproven_no_alias_in_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_unproven_no_alias_in_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "0B49\\]: this loop writes 'out' and reads 'src'")

add_test(NAME lint_call_blocks_vectorization
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_call_blocks_vectorization PROPERTIES
    PASS_REGULAR_EXPRESSION "0B4A\\]: this loop is element-wise arithmetic with a call")

add_test(NAME lint_kept_argument_never_reused
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_kept_argument_never_reused PROPERTIES
    PASS_REGULAR_EXPRESSION "0B4B\\]: 'take' keeps 'later'")

# ...but a `weak` field keeps nothing: storing an argument in one is no handover, and `move` is wrong.
add_test(NAME lint_weak_link_is_not_kept
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_weak_link_is_not_kept.pol")
set_tests_properties(lint_weak_link_is_not_kept PROPERTIES
    FAIL_REGULAR_EXPRESSION "Polaron-0B4B|error")

add_test(NAME lint_override_repeats_the_base
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_override_repeats_the_base PROPERTIES
    PASS_REGULAR_EXPRESSION "0B4C\\]: 'Copy.greet' overrides 'Base.greet' with the same body")

# ...and the two that must stay quiet: an override that does something else, and a numeric loop with
# nothing standing between it and the vector unit.
add_test(NAME lint_proof_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol")
set_tests_properties(lint_proof_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'Copy.differs'")

add_test(NAME lint_proof_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_proof.pol"
    "-DCONTAINS=64 3 2 4 6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE ABOUT WHAT A DECLARATION COSTS. The three size-based rules compute an approximate
# layout here rather than reaching into the code generator: they do not need the exact answer, only
# whether the written order wastes a noticeable fraction and whether a parameter is big.
add_test(NAME lint_check_repeats_its_contract
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_check_repeats_its_contract PROPERTIES
    PASS_REGULAR_EXPRESSION "0B3F\\]: this tests the negation")

add_test(NAME lint_region_held_too_long
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_region_held_too_long PROPERTIES
    PASS_REGULAR_EXPRESSION "0B41\\]: region 'pen' is released 8 statements after")

add_test(NAME lint_regions_with_one_lifetime
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_regions_with_one_lifetime PROPERTIES
    PASS_REGULAR_EXPRESSION "0B42\\]: 2 regions are opened and released")

add_test(NAME lint_eternal_that_is_released
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_eternal_that_is_released PROPERTIES
    PASS_REGULAR_EXPRESSION "0B43\\]: 'keep' is declared eternal and released")

add_test(NAME lint_padding_from_field_order
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_padding_from_field_order PROPERTIES
    PASS_REGULAR_EXPRESSION "0B45\\]: 'Ragged' is 32 bytes as written and 24 widest-first")

add_test(NAME lint_large_value_by_value
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_large_value_by_value PROPERTIES
    PASS_REGULAR_EXPRESSION "0B46\\]: 'weigh' takes 'load' by value")

# ...and the two that must stay quiet: a struct already ordered widest-first, and the three members
# the COMPILER writes for a value aggregate, whose signatures are nobody's decision to act on.
add_test(NAME lint_cost_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol")
set_tests_properties(lint_cost_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'Tidy' is|'equalsKey' takes|'compareTo' takes")

add_test(NAME lint_cost_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_cost.pol"
    "-DCONTAINS=7 6 24 9 7 1 1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE LAST OF THE STRUCTURAL ADVICE. Eight rules, and two of them were looking at the wrong thing
# until this sample said so: the lazy rule searched the DUMPED TEXT for `this.field`, which `dump`
# never writes contiguously (it puts `Member '.field'` on its own line), so it found nothing ever;
# and the raw-address rule searched the assigned VALUE for the word `address`, when what identifies
# the shape is the declared TYPE of the field.
add_test(NAME lint_tag_with_exclusive_fields
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_tag_with_exclusive_fields PROPERTIES
    PASS_REGULAR_EXPRESSION "0B36\\]: 'Piece.kind' is an enum beside")

add_test(NAME lint_mutex_over_one_primitive
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_mutex_over_one_primitive PROPERTIES
    PASS_REGULAR_EXPRESSION "0B37\\]: 'Counters.hits' locks a single 'int'")

add_test(NAME lint_lazy_always_needed
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_lazy_always_needed PROPERTIES
    PASS_REGULAR_EXPRESSION "0B38\\]: 'Counters.table' is lazy and the constructor reads it")

add_test(NAME lint_channel_never_consumed
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_channel_never_consumed PROPERTIES
    PASS_REGULAR_EXPRESSION "0B39\\]: 'Counters.outbox' is a channel")

add_test(NAME lint_move_instead_of_copy
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_move_instead_of_copy PROPERTIES
    PASS_REGULAR_EXPRESSION "0B3A\\]: 'taken' deep-copies 'source'")

add_test(NAME lint_list_without_capacity
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_list_without_capacity PROPERTIES
    PASS_REGULAR_EXPRESSION "0B3B\\]: 'got' starts empty and is filled in a loop")

# ...and not on a SCANNER, where the bound is the input and the count is a fraction of it nobody
# knows until the loop ends. Every parser in the library has that shape -- `Paths.split` walks
# characters and adds a segment per separator -- and all of them were being told to reserve the
# length of their input, which is forty elements to hold three.
add_test(NAME lint_list_capacity_is_not_advised_for_a_scanner
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_list_capacity_is_not_advised_for_a_scanner PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B3B\\]: 'marks'")

add_test(NAME lint_foreign_address_stored
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_foreign_address_stored PROPERTIES
    PASS_REGULAR_EXPRESSION "0B3C\\]: 'Borrowed.held' keeps a raw address")

add_test(NAME lint_dead_store_of_a_copy
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol")
set_tests_properties(lint_dead_store_of_a_copy PROPERTIES
    PASS_REGULAR_EXPRESSION "0B3D\\]: 'slot' is written here and written again")

add_test(NAME lint_final_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_final.pol"
    "-DCONTAINS=1 0 4 3 2 8"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE THAT NEEDS THE WHOLE PROGRAM: the difference between what a declaration promises and
# what anything actually does with it. None can be decided by reading one file.
#
# The public-with-no-outside-use rule shipped wrong twice and this sample is why. First it counted
# `System` towards "more than one bundle", so every single-bundle program looked like two; then it
# counted bundle ENTRIES rather than distinct names, and a program of two hundred files declaring
# `public bundle Agents` looked like two hundred bundles. Either way it fired on all ninety-nine
# public types in the game, which is a rule saying nothing.
add_test(NAME lint_discipline_never_exercised
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_discipline_never_exercised PROPERTIES
    PASS_REGULAR_EXPRESSION "0B30.*'Ticket' is declared movable and nothing")

add_test(NAME lint_public_with_no_outside_use
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_public_with_no_outside_use PROPERTIES
    PASS_REGULAR_EXPRESSION "0B31.*'Widget' is public and nothing outside bundle 'Tools'")

add_test(NAME lint_interface_never_polymorphic
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_interface_never_polymorphic PROPERTIES
    PASS_REGULAR_EXPRESSION "0B32.*holds a 'Nameable'")

add_test(NAME lint_field_never_read
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_field_never_read PROPERTIES
    PASS_REGULAR_EXPRESSION "0B33.*nothing reads 'Parent.unreadTally'")

add_test(NAME lint_public_written_only_inside
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_public_written_only_inside PROPERTIES
    PASS_REGULAR_EXPRESSION "0B34.*'Parent.touched' is public and only 'Parent' ever writes it")

add_test(NAME lint_ownership_cycle
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_ownership_cycle PROPERTIES
    PASS_REGULAR_EXPRESSION "0B35.*point at each other, and neither says which one owns")

# ...and the type the OTHER bundle uses must not be named, or the rule is not about the outside at
# all. Nor may any of it invent an error.
add_test(NAME lint_program_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_program_shapes_are_narrow PROPERTIES
    # Anchored to the message rather than spanning it with `.*`: ctest matches over the WHOLE
    # output, so a wildcard between a code and a name happily jumps from one diagnostic to another.
    # `Main` is the third name that must not appear, and it is the one that cannot be argued with:
    # the language finds `main` by looking for a PUBLIC class called `Main`, so this rule's advice,
    # taken, is answered with "this program has no entry point". Its bundle HAS an outside here --
    # `Extras` reaches into it -- so the rule is live and silent about this one on purpose.
    FAIL_REGULAR_EXPRESSION "0B31\\]: 'Coupon'|0B31\\]: 'Main'|0B31\\]: 'Parent'|: error")

# AND SILENT FOR A BUNDLE NOTHING OUTSIDE USES AT ALL. `Extras` is consumed by nobody, so every one
# of its public types trivially qualifies -- which is one fact about the bundle, not a sentence per
# type. The guard used to ask whether the PROGRAM had more than one bundle, which is not the same
# question: a game that links a library has two, nothing consumes the game, and the rule fired on
# all 187 of its public types. Its own note already said what that means: "a rule that fires on
# everything says nothing".
add_test(NAME lint_public_outside_use_needs_an_outside
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol")
set_tests_properties(lint_public_outside_use_needs_an_outside PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B31\\]: 'Tally'")

add_test(NAME lint_program_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_program.pol"
    "-DCONTAINS=1 4"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE ABOUT THINGS THAT ONLY HURT AT SCALE. Every one is correct at ten and a problem at ten
# thousand, which is why none of them looks wrong at the line where it is written.
add_test(NAME lint_many_of_one_kind
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_many_of_one_kind PROPERTIES
    PASS_REGULAR_EXPRESSION "0B29.*3 'Tag' are allocated one at a time")

add_test(NAME lint_runtime_check_of_constants
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_runtime_check_of_constants PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2A.*decided at compile time")

add_test(NAME lint_region_with_one_allocation
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_region_with_one_allocation PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2B.*region 'pen' is set up and torn down for a single allocation")

add_test(NAME lint_copy_hoistable_out_of_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_copy_hoistable_out_of_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2C.*'each' copies 'source' on every iteration")

add_test(NAME lint_linear_search_in_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_linear_search_in_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2D.*'contains' walks the whole collection")

# ...and the near-misses, plus the proof that none of it invents an error: one allocation is one
# allocation, a condition on an argument is a real check, and nothing is copied per iteration.
add_test(NAME lint_scale_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol")
set_tests_properties(lint_scale_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'plain'|: error")

add_test(NAME lint_scale_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_scale.pol"
    "-DCONTAINS=6 8 7 20 1 18"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE ABOUT WAITING. Both are correct code that makes other work wait for no reason.
#
# The independent-awaits rule shipped broken once and the sample caught it: it asked whether the
# second line mentions the first by searching the dumped TEXT, and a one-letter name is a substring
# of half the program -- `a` is inside `Waits.slow(2)` -- which silently turned the rule off for
# exactly the case it exists for. It looks for the identifier now.
add_test(NAME lint_lock_around_slow_work
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_concurrency.pol")
set_tests_properties(lint_lock_around_slow_work PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2E.*holds the lock across work")

add_test(NAME lint_sequential_independent_awaits
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_concurrency.pol")
set_tests_properties(lint_sequential_independent_awaits PROPERTIES
    PASS_REGULAR_EXPRESSION "0B2F.*'b' does not depend on 'a'")

# ...and the two that must stay quiet: a lock that covers only what it guards, and a wait that
# really does depend on the one before it.
add_test(NAME lint_concurrency_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_concurrency.pol")
set_tests_properties(lint_concurrency_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "quietUpdate")

# THE STANDARD LIBRARY IS HELD TO ITS OWN ADVICE, and this is the test that does the holding.
#
# Hiding the prelude's warnings is right for somebody compiling their own program -- they cannot act
# on a diagnostic about code they did not write -- and it left the one code base every program links
# against as the only one nothing was watching. A warning that fires in the library is not noise: it
# is a place the library does not follow the language it defines.
#
# A ratchet. The counts may fall freely and may never rise, so a rule can be added against the
# prelude as it stands, the count becomes the debt that rule found, and no later change may add to
# it. When a count falls the test says so and asks for the baseline to be tightened, which is what
# stops the debt from coming back.
add_test(NAME lint_prelude_holds_its_baseline COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol"
    "-DBASELINE=${CMAKE_CURRENT_SOURCE_DIR}/prelude_advice_baseline.txt"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_prelude_advice_ratchet.cmake")

# THE ADVICE ABOUT TABLES, CONVERSIONS AND ALLOCATION SHAPE.
add_test(NAME lint_primitive_obsession
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_primitive_obsession PROPERTIES
    PASS_REGULAR_EXPRESSION "0B24.*'place' takes 3 parameters of type 'int'")

add_test(NAME lint_parallel_array_table
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_parallel_array_table PROPERTIES
    PASS_REGULAR_EXPRESSION "0B25.*3 static arrays here are one row read sideways")

add_test(NAME lint_hand_written_conversion_pair
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_hand_written_conversion_pair PROPERTIES
    PASS_REGULAR_EXPRESSION "0B26.*'Metres' converts to and from 'Feet' by hand")

add_test(NAME lint_alloc_free_in_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_alloc_free_in_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "0B27.*this loop allocates and frees on every iteration")

add_test(NAME lint_array_grown_by_hand
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_array_grown_by_hand PROPERTIES
    PASS_REGULAR_EXPRESSION "0B28.*'add' allocates a new array, copies into it")

# ...and only where it is GROWTH. Allocating an array, copying element by element and freeing a
# scratch is what half the numeric library does, and none of it is a list anybody rewrote: the shape
# that is one is growth IN PLACE, where what was freed is then assigned the new array. Untested, the
# rule told `Decompose.determinant` and `Curve.publicPoint` to reach for a collection.
add_test(NAME lint_array_grown_by_hand_is_not_a_working_copy
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_array_grown_by_hand_is_not_a_working_copy PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B28.*'churn'")

# ...and the near-misses: one array is a list rather than a table, and a pair of coordinates is the
# concept rather than the problem.
add_test(NAME lint_table_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol")
set_tests_properties(lint_table_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B25.*'Single'|'at' takes")

add_test(NAME lint_tables_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_tables.pol"
    "-DCONTAINS=5 0 27 3 6 9 3 6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE ABOUT OWNERSHIP AND CONTRACT: five claims a declaration is making without saying so.
add_test(NAME lint_ownership_by_discipline
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_ownership_by_discipline PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1F.*'Keeper.owned' is freed by the destructor")

add_test(NAME lint_guard_that_is_an_invariant
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_guard_that_is_an_invariant PROPERTIES
    PASS_REGULAR_EXPRESSION "0B20.*3 methods here open by checking the same thing")

add_test(NAME lint_boolean_out_parameter
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_boolean_out_parameter PROPERTIES
    PASS_REGULAR_EXPRESSION "0B21.*'tryRead' returns a boolean and writes its real answer")

add_test(NAME lint_validation_that_is_a_contract
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_validation_that_is_a_contract PROPERTIES
    PASS_REGULAR_EXPRESSION "0B22.*'scaled' opens by rejecting its argument")

add_test(NAME lint_null_check_on_non_nullable
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_null_check_on_non_nullable PROPERTIES
    PASS_REGULAR_EXPRESSION "0B23.*'Held\\*' is non-nullable")

# ...and the near-misses: the field the destructor leaves alone, the method whose precondition is
# already on its signature, and the `nullable` that makes the null question a real one.
add_test(NAME lint_contract_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol")
set_tests_properties(lint_contract_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'Keeper.seen'|'halved' opens")

add_test(NAME lint_contracts_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_contracts.pol"
    "-DCONTAINS=7 5 6 4 4 4"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE ABOUT LIFETIME, CLEANUP AND HIERARCHY. All five are about something the declaration
# already knows and has not said. The throw-in-a-loop rule is here rather than with the flow ones
# because the first version only looked at loops at the top of a method and missed the one nested in
# a `try`, which is where a throwing loop usually is.
add_test(NAME lint_heap_with_lexical_lifetime
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_heap_with_lexical_lifetime PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1A.*'n' is allocated on the heap and deleted in the same block")

add_test(NAME lint_repeated_cleanup
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_repeated_cleanup PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1B.*'delete n' is repeated before 2")

add_test(NAME lint_throw_in_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_throw_in_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1C.*this throw is inside a loop")

add_test(NAME lint_hierarchy_not_sealed
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_hierarchy_not_sealed PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1D.*'Note' is extended only by Heavy, Light")

add_test(NAME lint_abstract_with_one_subtype
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_abstract_with_one_subtype PROPERTIES
    PASS_REGULAR_EXPRESSION "0B1E.*'Lone' is abstract and 'OnlyOne' is its only subtype")

# ...and the near-misses: a `sealed` base is the thing being recommended, and a heap object that
# escapes its block is the case the heap exists for.
add_test(NAME lint_memory_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol")
set_tests_properties(lint_memory_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'Closed' is|'Left' is|'Right' is")

add_test(NAME lint_memory_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_memory.pol"
    "-DCONTAINS=1 1 2 102 0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE THAT READS CONTROL FLOW. Five rules, each beside the shape that looks like it and is
# not. Two of these were nearly shipped wrong and the sample is why: `default` is REQUIRED on a
# `switch`, so the rule is about `match` alone; and asking `typeOf` after a body is analysed asks
# about names whose scope has been popped, which invented errors in the prelude until the lints
# moved to where the names are still live.
add_test(NAME lint_default_over_a_closed_set
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_default_over_a_closed_set PROPERTIES
    PASS_REGULAR_EXPRESSION "0B15.*default over sealed type 'Shape'"
    FAIL_REGULAR_EXPRESSION ": error")

add_test(NAME lint_if_chain_is_a_match
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_if_chain_is_a_match PROPERTIES
    PASS_REGULAR_EXPRESSION "0B16.*3 branches here compare 'code'")

add_test(NAME lint_repeated_magic_number
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_repeated_magic_number PROPERTIES
    PASS_REGULAR_EXPRESSION "0B17.*number 96 is written out 3 times")

# ...and a BIT PATTERN is not a number written out. `x & 255` is the low byte and the `&` is what
# says so. Thirty-seven of the standard library's hundred and twenty-six were `255` inside a mask,
# in the codecs and the hashes where the layout is the specification and a name would put a word
# between the reader and it.
add_test(NAME lint_magic_number_is_not_a_mask
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_magic_number_is_not_a_mask PROPERTIES
    FAIL_REGULAR_EXPRESSION "number 255 is written out")

add_test(NAME lint_throw_caught_here
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_throw_caught_here PROPERTIES
    PASS_REGULAR_EXPRESSION "0B18.*raises and catches its own exception")

add_test(NAME lint_result_never_examined
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_result_never_examined PROPERTIES
    PASS_REGULAR_EXPRESSION "0B19.*returns a 'Result.*' and the statement drops it")

# ...and the near-misses: a match that lists every permit, branches over different subjects, and a
# result that is read.
add_test(NAME lint_flow_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol")
set_tests_properties(lint_flow_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "sealed type 'Solid'|compare 'a'|compare 'b'")

add_test(NAME lint_flow_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_flow.pol"
    "-DCONTAINS=3 4 2 1 241 6 7 0 1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE ADVICE THAT READS A DECLARATION. Five rules, and the sample carries each one beside the
# near-miss that must stay quiet -- a class WITH state, a type that is already a record, constants
# that are not a set, and a record whose fields are its constructor parameters.
add_test(NAME lint_declaration_shapes
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_declaration_shapes PROPERTIES
    PASS_REGULAR_EXPRESSION "0B10.*'Helpers' is 3 static methods.*takes a 'Reading' first")

# ...and it stays quiet where there is no subject to move the behaviour onto. `Arithmetic` takes an
# `int` first and `Extremes` takes nothing at all: a transformer is applied BY a type, and neither of
# those has one, so the fix the rule names cannot be written. Untested, the rule reported the entire
# utility surface of the standard library -- 73 classes, `Strings` and `Files` and `Machine` among
# them -- with advice none of them can take.
# NO ADVICE ABOUT A BODY THE COMPILER WROTE. A record's `equals`, `hashCode`, `toString` and the
# value-key hooks beside them carry the record's own location, so a rule that reads a body reports
# at the declaration about code the author has never seen: `record Triple(int one, int two, int
# three)` earned "the number 31 is written out 3 times in this method", about a hash multiplier.
add_test(NAME lint_says_nothing_about_generated_bodies
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_says_nothing_about_generated_bodies PROPERTIES
    FAIL_REGULAR_EXPRESSION "the number 31 is written out")

add_test(NAME lint_statics_without_state_needs_a_subject
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_statics_without_state_needs_a_subject PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B10.*'(Arithmetic|Extremes)'")

# `int -> float` IS GROUPED WITH THE INTEGER WIDENINGS AND IS NOT ONE. A float has 24 bits of
# significand, so every whole number above 16777216 rounds -- one of the two silent narrowings the
# ledger names, and silent is the complaint. `double` holds every int exactly and stays quiet, which
# is what keeps this from being noise on the commonest conversion in the language.
add_test(NAME lint_lossy_widening
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lossy_widening.pol")
set_tests_properties(lint_lossy_widening PROPERTIES
    PASS_REGULAR_EXPRESSION "0B4A.*does not fit in a 'float'")

# ...and it does NOT fire on the double beside it.
add_test(NAME lint_lossy_widening_spares_double
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lossy_widening.pol")
set_tests_properties(lint_lossy_widening_spares_double PROPERTIES
    FAIL_REGULAR_EXPRESSION "0B4A.*'double'")

add_test(NAME codegen_lossy_widening_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lossy_widening.pol"
    "-DEXPECTED=f=16777216 d=16777217"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

add_test(NAME lint_data_without_behaviour
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_data_without_behaviour PROPERTIES
    PASS_REGULAR_EXPRESSION "0B11.*'Point' is 2 public fields")

add_test(NAME lint_constants_that_are_an_enum
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_constants_that_are_an_enum PROPERTIES
    PASS_REGULAR_EXPRESSION "0B12.*share the prefix 'SPEED_'")

add_test(NAME lint_static_takes_its_own_class
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_static_takes_its_own_class PROPERTIES
    PASS_REGULAR_EXPRESSION "0B13.*'Bag.combine' is static and takes a 'Bag'")

add_test(NAME lint_hungarian_notation
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_hungarian_notation PROPERTIES
    PASS_REGULAR_EXPRESSION "0B14.*'nTimes' spells an integer")

# ...and the five near-misses. This is the half that decides whether the set is usable: a class with
# state is guarding something, a `record` is the thing being recommended, and constants with no
# shared prefix are not a set.
add_test(NAME lint_declaration_shapes_are_narrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol")
set_tests_properties(lint_declaration_shapes_are_narrow PROPERTIES
    FAIL_REGULAR_EXPRESSION "'Counter' is|'Stretch' is|'Limits'|prefix 'WIDTH'|'Bag' is 1 public")

add_test(NAME lint_declarations_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_declarations.pol"
    "-DCONTAINS=8 8 0 2 5 3 12 3 80 10"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

add_test(NAME lint_shapes_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_shapes.pol"
    "-DCONTAINS=7 3 2 1 1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE LINT WALKER MUST SEE INTO EVERY BLOCK-BEARING STATEMENT, and for a long time it saw into six
# of the twelve: `match`, `switch`, `defer`, `using`, `synchronized` and a labelled statement were
# all invisible, so an assignment inside one of them did not exist as far as ten lints were
# concerned. That did not produce a missing warning, it produced a WRONG one -- "'packed' is
# declared mutable and nothing ever assigns to it" with the assignment three lines below, found in
# the game's own source. A wrong lint is worse than an absent one: the author removes a `mutable`
# the program needs, on the compiler's advice.
#
# One local per form, each assigned only inside that form. Naming all seven is the point: a walker
# that regains one blind spot fails on exactly the name it went blind to.
add_test(NAME lint_sees_into_every_block
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_blocks_seen.pol")
set_tests_properties(lint_sees_into_every_block PROPERTIES
    FAIL_REGULAR_EXPRESSION "'fromMatch' is declared mutable|'fromSwitch' is declared mutable|'fromDefault' is declared mutable|'fromDefer' is declared mutable|'fromUsing' is declared mutable|'fromLocked' is declared mutable|'fromLabel' is declared mutable")

# ...and the six forms really do run and really do assign, so the sample is a program and not a
# shape that happens to type-check. The defer prints last, after the return, which is what a defer
# is: `1 2 -1 4 5 6` then `from the defer: 3`.
add_test(NAME lint_blocks_seen_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_blocks_seen.pol"
    "-DCONTAINS=1 2 -1 4 5 6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A `requires` IS A THIRD ROUTE OUT OF 0B40, and the one a sub-range algorithm has. `sortRange(int[]
# a, int lo, int hi)` is static, so an invariant -- which speaks about fields -- cannot state the
# relation between its parameters; looping to `a.length()` would sort the whole array; `foreach`
# cannot walk a sub-range backwards. Every fix the rule named was unavailable, and the author who
# wrote the contract anyway was told again on every build.
#
# Sound because a `requires` is emitted as `br i1 %contract.ok, ...`: the body is dominated by a
# block where the condition is known, which is exactly what the range analysis reads.
add_test(NAME lint_bound_contract_is_a_fix
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bound_contract.pol")
set_tests_properties(lint_bound_contract_is_a_fix PROPERTIES
    FAIL_REGULAR_EXPRESSION "indexes 'bounded'")

# ...and the rule must still fire where nothing was promised, or the exemption above has simply
# turned the rule off. Two separate tests because CTest's PASS pattern is a list matched with OR:
# one regex naming both would pass on either half.
add_test(NAME lint_bound_no_promise_still_fires
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bound_contract.pol")
set_tests_properties(lint_bound_no_promise_still_fires PROPERTIES
    PASS_REGULAR_EXPRESSION "indexes 'unpromised'")

# ...and an unrelated promise is not a way out. `offtopic` declares `requires lo >= 0`, which is
# true and says nothing about how long anything is; the cost is still there, so the name still is.
# The promise has to be about the ARRAY -- which is also why the inner loop of `promised` is quiet
# even though its own bound is the LOWER one, a number no length could be compared against.
add_test(NAME lint_bound_unrelated_promise_still_fires
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bound_contract.pol")
set_tests_properties(lint_bound_unrelated_promise_still_fires PROPERTIES
    PASS_REGULAR_EXPRESSION "indexes 'offtopic'")

# A CURSOR IS A PLACE IN SOMETHING THAT EXISTS. `ArrayList.iterator()` handed its list to the cursor
# BY VALUE, and assignment copies in Polaron -- so every `foreach` over every ArrayList in the
# language deep-copied the whole collection and walked the duplicate. `seen 4 total 108` is a cursor
# over the list; `seen 3 total 6` is a cursor over a photograph of it taken when it was made.
#
# `sum 30` is the half that the fix broke first: a monomorphized generic over a POINTER has a name
# ending in `*` of its own, and the subtype check took one marker off each side before comparing, so
# `ArrayList$Cell*` and `ArrayList$Cell*&` stopped being the same type.
add_test(NAME iterator_is_a_view COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/iterator_is_a_view.pol"
    "-DCONTAINS=seen 4 total 108 sum 30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE TARGET DECIDES WHETHER AN ASSIGNMENT COPIES. `T* f = x` shares; `T f = x` copies. The PIR
# lowering asked the VALUE's pointer depth instead, so `this.direct = this` on a `Owner*` field
# deep-copied the object -- and inside a constructor that recursion reads fields not yet written and
# `memcpy`s from whatever the fresh allocation held. `lint_program.pol` segfaulted after its printf
# had run, and stdout being buffered to a pipe meant the crash ate the output: the program looked
# like it printed nothing.
#
# One hop and two, because the first guess was that only the chained form was broken. It was not.
add_test(NAME assign_shares_through_pointer COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/assign_shares_through_pointer.pol"
    "-DEXPECTED=direct=42 chained=42"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A ROUTE THAT SAYS NO MUST LEAVE NOTHING BEHIND. `Router.matches` captured `{name}` segments as it
# scanned, so a pattern that agreed on three segments and failed on the fourth had already written
# three parameters into the request -- and `dispatch` hands the same request to every route in turn,
# so a handler under a later pattern could read a binding from one that did not match. Found by
# Polaron-0B21, whose own sentence about the shape describes it exactly.
add_test(NAME router_leaves_nothing_after_a_no COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/router_partial_match.pol"
    "-DCONTAINS=false 0 true 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

add_test(NAME lint_bound_contract_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_bound_contract.pol"
    "-DCONTAINS=1 2 6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

add_test(NAME lint_allow_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lint_allow.pol"
    "-DCONTAINS=3 4 1 2 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# EVERY DIAGNOSTIC THE SUITE PRODUCES CARRIES A CODE, and so has a why/fix/prevent behind it.
#
# Codes are attached by matching text in the message, so rewording one silently drops its code and
# the diagnostic quietly loses half of itself -- it still prints, still looks fine, and nothing else
# in the build notices. Measured before this guard: 45 of 111 had none. The corpus is read from this
# file, so a new negative test joins the guard by existing.
#
# IN SHARDS, SO THAT NO SINGLE TEST RUNS FOR SIX MINUTES. It is hundreds of `polc` invocations -- one
# per catalog code and one per sample in the corpus -- and as ONE test they ran on ONE core for 358
# seconds while carrying a timeout of 900.
#
# WHAT THAT DID AND DID NOT BUY, measured rather than assumed. It does NOT make the suite meaningfully
# faster: the 1249 tests are 2821 seconds of CPU on eight cores, so the wall clock is 353 seconds
# either way and this test was never the thing everything else was waiting for. What it buys is that
# the LONGEST test is now twenty-odd seconds instead of six minutes -- which is what makes a short
# timeout possible, and a timeout is only protection if it is short enough to notice a hang. Nine
# hundred seconds meant a wedged compiler blocked the run for a quarter of an hour before saying so.
#
# Twenty-four, and the number is measured too: sixteen shards came in at 21 seconds alone and 33 under
# a fully loaded machine, which is over the line. These carry no TIMEOUT property of their own on
# purpose -- they inherit whatever the run asks for, so `ctest --timeout 30` means thirty here as well.
foreach(_shard RANGE 0 23)
    add_test(NAME diagnostics_all_carry_a_code_${_shard}
        COMMAND ${CMAKE_COMMAND} "-DPOLC=$<TARGET_FILE:polc>" "-DDIR=${CMAKE_CURRENT_SOURCE_DIR}"
                "-DSHARD=${_shard}" "-DSHARDS=24"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/diagnostic_codes.cmake")
endforeach()

# The region binder refuses for four different reasons, and each says which one. Before this, all
# four printed the frame-escape write-up -- confident advice for a mistake the reader did not make.
add_test(NAME region_reasons_have_distinct_codes
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_through_extern.pol")
set_tests_properties(region_reasons_have_distinct_codes PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1723\\]")

# Two objects the caller happened to have, with nothing ordering them. The sentence must not claim an
# ordering it does not have: "A outlives B" is the frame wording and is false here.
add_test(NAME region_incomparable_says_nothing_orders_them
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_between_objects.pol")
set_tests_properties(region_incomparable_says_nothing_orders_them PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1722\\]: region-binder: 'watch' keeps that argument, and nothing orders")

add_test(NAME region_use_after_invalidate_has_a_code
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_after_clear.pol")
set_tests_properties(region_use_after_invalidate_has_a_code PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1724\\]")

# `polc --explain <code>` prints a code's canonical why / fix / prevent.
add_test(NAME explain_prints_the_canonical_writeup
    COMMAND polc --explain Polaron-0101)
set_tests_properties(explain_prints_the_canonical_writeup PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0101 -- not declared in this scope")

add_test(NAME explain_rejects_an_unknown_code
    COMMAND polc --explain Polaron-9999)
set_tests_properties(explain_rejects_an_unknown_code PROPERTIES
    WILL_FAIL TRUE)

# Even a syntax error is rich: a stable code, a snippet, and the why/fix/prevent sections.
add_test(NAME syntax_error_is_rich
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/syntax_bad.pol" -o "${CMAKE_CURRENT_BINARY_DIR}/syn.ll")
set_tests_properties(syntax_error_is_rich PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-0001\\]:.*\n.*syntax_bad.pol:9")

# A rule-classified semantic error (immutability) is coded and rich without a per-call-site change.
add_test(NAME immutable_assignment_is_coded
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/immutable_bad.pol")
set_tests_properties(immutable_assignment_is_coded PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-0401\\]: cannot assign to immutable")

# Region flavor / extract diagnostics (spec 17, flavors expansion): each malformed use gets its coded,
# rich Polaron-17NN diagnostic.
add_test(NAME sema_rejects_region_two_flavors
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_twoflavors.pol")
set_tests_properties(sema_rejects_region_two_flavors PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1710\\]")

add_test(NAME sema_rejects_flavor_on_non_region
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_flavor_nonregion.pol")
set_tests_properties(sema_rejects_flavor_on_non_region PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1719\\]")

add_test(NAME sema_rejects_use_after_extract
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_use_after_extract.pol")
set_tests_properties(sema_rejects_use_after_extract PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1717\\]")

add_test(NAME sema_rejects_bare_extract
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_bare_extract.pol")
set_tests_properties(sema_rejects_bare_extract PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1720\\]")

# `weak` must qualify a pointer to a class (an object with identity); `weak int` has no target.
add_test(NAME sema_rejects_weak_nonpointer
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_bad_nonptr.pol")
set_tests_properties(sema_rejects_weak_nonpointer PROPERTIES
    PASS_REGULAR_EXPRESSION "'weak' requires a pointer")

add_test(NAME sema_rejects_mark_nonstack
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_mark_nonstack.pol")
set_tests_properties(sema_rejects_mark_nonstack PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1713\\]")

add_test(NAME sema_rejects_rollback_wrong_region
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_rollback_wrongregion.pol")
set_tests_properties(sema_rejects_rollback_wrong_region PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1714\\]")

add_test(NAME sema_rejects_fixedslot_no_accepts
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_fixedslot_noaccepts.pol")
set_tests_properties(sema_rejects_fixedslot_no_accepts PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1711\\]")

add_test(NAME sema_rejects_ring_delete
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_ring_delete.pol")
set_tests_properties(sema_rejects_ring_delete PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1715\\]")

add_test(NAME sema_rejects_growable_ring
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_growable_ring.pol")
set_tests_properties(sema_rejects_growable_ring PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1712\\]")

add_test(NAME sema_rejects_extract_inner_field
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_bad_extract_innerfield.pol")
set_tests_properties(sema_rejects_extract_inner_field PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1718\\]")

# A catalog `extends` cycle must be reported, not crash (regression: it used to
# overflow the stack in isSubtype).
add_test(NAME sema_rejects_catalog_cycle
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_cycle.pol")
set_tests_properties(sema_rejects_catalog_cycle PROPERTIES
    PASS_REGULAR_EXPRESSION "catalog cycle involving")

# Wrong argument count must be a clean error, not a codegen "bad signature" crash.
add_test(NAME sema_rejects_bad_arg_count
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/arg_count_bad.pol")
set_tests_properties(sema_rejects_bad_arg_count PROPERTIES
    PASS_REGULAR_EXPRESSION "expects 2 argument")

# throw of a non-object must be reported (was an unchecked codegen crash).
add_test(NAME sema_rejects_throw_int
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/throw_int_bad.pol")
set_tests_properties(sema_rejects_throw_int PROPERTIES
    PASS_REGULAR_EXPRESSION "'throw' expects an object")

# (Removed: "catch of a non-polymorphic class" -- with Object as the universal root every class is
# polymorphic and therefore catchable, so that error scenario no longer exists.)

# a `const` initializer that is not a compile-time constant must be rejected (spec 28.1).
add_test(NAME sema_rejects_nonconst_const
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/const_nonconst_bad.pol")
set_tests_properties(sema_rejects_nonconst_const PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# `release region` RUNS THE DESTRUCTORS OF WHAT LIVES IN THE REGION.
#
# The dogs are made in `makeDog` and the arena is released in `~Pool`; no list the compiler keeps
# spans that gap, so the region has to keep its own. PIR gated the registry on `flavor == "stack"`
# and a plain `region` FIELD got neither the tracking nor the teardown -- and the sample that had the
# defect printed the same on both paths, because nothing in its region had a destructor that said
# anything. `~Dog 22 / ~Dog 11` is what the fix is for.
add_test(NAME codegen_region_field_dtor COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_field_dtor.pol"
    "-DCONTAINS=~Dog 22"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AN EXCEPTION LEAVING A METHOD STILL LEAVES ITS SCOPES.
#
# `exceptions_edge` has a stack object beside a `try` whose `catch` matches, so the rethrow edge
# exists in the IR and no program walks it -- which is why the corpus called this correct while the
# trusted path ran `~Guard` twice and PIR ran it once. This sample walks the other edge: a `throw`
# with no `try` at all, and a `try` whose `catch` does not match. Each must print its destructor
# before the caller's handler prints.
#
# `lowerTry`'s resume path ran the body's own teardown and not the scopes AROUND it, so an exception
# leaving the function tore down nothing declared before the `try`.
add_test(NAME codegen_unwind_raii COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unwind_raii.pol"
    # `dtor 2` is the one that matters: it is the destructor on the RESUME edge -- the `try` whose
    # `catch` did not match -- which is the path nothing in the corpus walked. `dtor 1` (a bare
    # `throw` with no `try`) already ran.
    "-DCONTAINS=dtor 2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A BARE `Object`, CONSTRUCTED AND DISPATCHED ON.
#
# Found by the shape census, not by the corpus: `Object.Object` wrote `@Object.vtable` on the trusted
# path and nothing on the PIR path, so slot 0 of a bare `Object` held whatever the allocator last
# left there and `a.equals(a)` jumped through it -- trusted printed and exited 0, PIR exited
# 0xC0000005. Not one of the 874 samples constructs a bare `Object`, which is exactly why comparing
# the two modules was needed to see it at all.
#
# The cause was an optimisation that went one step too far: `buildVtable` emits a table only for
# methods something actually dispatches, and returned early when there were none -- while
# `carriesVtable` had already decided the LAYOUT reserves the pointer. The slot existed and nothing
# filled it. Fixed by emitting the eight-byte table anyway when the layout carries the slot.
#
# It ran as WILL_FAIL for exactly as long as the defect lived, which is what a ratchet is for.
add_test(NAME codegen_bare_object_dispatch COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bare_object_dispatch.pol"
    "-DCONTAINS=same true"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# READING A VALUE AGGREGATE OUT OF A COLLECTION GIVES YOU THE VALUE.
#
# `ArrayList<Point>.get` is `return this.data[i];` with `T` monomorphised to a value struct. An
# element's address carries the ARRAY's type -- a slice, so the backend knows the stride -- and the
# return path only loaded when the source type was exactly `Ptr`. So it fell through to a conversion
# with nothing to convert a slice into a struct with, and the method came out as
# `ret %class.Point undef`: every element read back as zeros.
#
# Wrong ANSWERS, silently, on the most ordinary use of a collection there is -- and the corpus held
# no `ArrayList` of a `struct` whose elements it read back.
add_test(NAME codegen_value_element_copy COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_element_copy.pol"
    "-DEXPECTED=stored=1,2 after mutating source=1,2 read back=1,2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A NAMESPACE NAME IS NOT UNIQUE ACROSS BUNDLES.
#
# `App` is the obvious name for an application's namespace, and the standard library has one. Type
# resolution matched "your own namespace" on the NAME alone, so the two were one place: a program
# declaring any type the library also has in its `App` handed the library the program's version, and
# the errors landed inside the prelude on lines the author never wrote. `Money` is the collision
# that found it -- the library's has `long cents` and this one `int cents`, so they disagree about a
# field they both have. `Scanner`, already shadowed elsewhere in the corpus, never showed it: its
# fields are named differently, so nothing collided.
add_test(NAME codegen_shadow_namespace_name COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shadow_namespace_name.pol"
    "-DEXPECTED=money=300"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A `foreach` GOES THROUGH THE PROTOCOL, WHATEVER THE TYPE.
#
# The census found PIR's `foreach` over an `Iterable` differing in shape from the other path's
# (baseline class N), and the corpus could not say whether that mattered: its only `Iterable` is
# `ArrayList`, whose iteration a compiler may reasonably know by heart. This type's `hasNext` and
# `next` COUNT THEIR OWN CALLS, so a loop that walks the backing store directly cannot produce the
# numbers and one that goes through the protocol cannot avoid them. Both paths print 7 and 6.
add_test(NAME codegen_custom_iterator COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/custom_iterator.pol"
    "-DEXPECTED=sum=21 hasNext=7 next=6 second pass sum=21"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AWAIT SUSPENDS; IT DOES NOT BLOCK -- and a bounded pool is the only place that is visible.
#
# PIR lowered `await` to `__polaron_task_wait`, which sleeps on a condition variable and holds the
# worker. On an unbounded pool that is indistinguishable from suspending: same output, more threads.
# With more outstanding tasks than workers, each awaiting one more, every waiter holds a worker that
# the task it waits for needs -- the classic deadlock. Nothing in the corpus filled a pool.
#
# THE FAILURE MODE HERE IS A HANG, not a wrong number, so the timeout is the assertion. Sixty
# seconds is far more than the ~0.1s this takes when it works.
add_test(NAME codegen_await_bounded_pool COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/await_bounded_pool.pol"
    "-DEXPECTED=done=32 sum=496"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
set_tests_properties(codegen_await_bounded_pool PROPERTIES TIMEOUT 60)

# A JAVA-STYLE ENUM CONSTANT IS BUILT ONCE, HOWEVER MANY TIMES IT IS NAMED (spec 12.2).
#
# The census counted PIR emitting twelve constructor calls against three, and that number alone
# proves nothing: a lazily-built singleton guarded by a flag can be WRITTEN twelve times and RUN
# three. This constructor speaks, so the two can be told apart -- three constants, twelve mentions,
# and `build` must appear THREE times. It does, on both paths. D12 was a shape difference, not a
# behaviour one; what remains is code size, which belongs to the pass wave and not to this one.
add_test(NAME codegen_enum_singleton_once COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_singleton_once.pol"
    "-DEXPECTED=build 3 build 9 build 10 d 3 3 5 l 5 3 3 again 3 3 5 same=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# DEREFERENCING A NULLABLE RECEIVER IS CHECKED, AND SAYS WHERE (spec 3.7).
#
# PIR emitted this check nowhere, on any program. Hosted that loses the diagnostic; on a target with
# no MMU it loses everything, because there is no fault to take -- the read returns whatever is
# mapped at zero and the program carries on with a wrong answer. That is precisely the case the
# no-UB rule exists for.
#
# The sample reads through a live receiver TWICE before the null one, so a compiler that panics on
# every dereference cannot pass: `ok=7` and `still here` have to come out first.
add_test(NAME codegen_null_receiver_guard COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_receiver_guard.pol"
    "-DEXPECT_EXIT=70"
    "-DCONTAINS=still here"
    "-DERRCONTAINS=null reference dereference"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AN ARRAY OF STRUCTS STEPS BY THE STRUCT'S SIZE, NOT BY THE SUM OF ITS FIELDS.
#
# `Cell { int; double }` sums to twelve and measures sixteen. PIR scaled an index by the sum while
# the LLVM type it geps a FIELD through uses the real layout, so element one began four bytes before
# it lived and every write of a tag landed inside the previous element's double: `0.0 0.0 0.0 3.5`.
# The allocation was short by the same arithmetic -- `4 * 12` for data needing 64 -- so the last
# element wrote past the block.
#
# The corpus could not catch it: every array of value aggregates in it either has fields needing no
# padding, or never reads an element back past the first.
add_test(NAME codegen_struct_array_stride COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_array_stride.pol"
    "-DCONTAINS=total=8.0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A RECEIVER WRITTEN ONCE RUNS ONCE.
#
# `implicit_this_receiver.pol` covers the same three shapes and stayed green through the whole
# defect, because its receiver is `return this;` -- calling it twice and keeping the second answer
# prints what calling it once prints. The census could only see it as `calls Holder.table 1->2`, and
# a call count is not a wrong answer. Here the receiver counts its own evaluations, so the defect
# has to come out in the output or not at all.
#
# Two guesses made before the object was known, and abandoned after: the interrupt-binding probe
# (asked on EVERY member read) and the swizzle-lane probe (`.x` on a call named `transform`). Both
# evaluated the object to decide, and both dropped what they evaluated. `calls=3` is the claim.
add_test(NAME codegen_receiver_once COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/receiver_once.pol"
    "-DCONTAINS=calls=3"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# The entry wrapper, with real arguments: argv built and intact, and a static that class load set
# already readable on the FIRST line of user code. The shape comparison skips `main` because the two
# backends structure it differently on purpose; this is the absolute claim that replaces it.
add_test(NAME codegen_entry_wrapper_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entry_wrapper.pol"
    "-DRUNARGS=one two"
    "-DCONTAINS=ready=7"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
add_test(NAME codegen_entry_wrapper_argv COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entry_wrapper.pol"
    "-DRUNARGS=one two"
    "-DCONTAINS=argc=2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# main receives the real command-line arguments (spec 2.9): string[] args from argv.
add_test(NAME codegen_main_args_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/main_args.pol"
    "-DRUNARGS=foo bar baz"
    "-DCONTAINS=n=3 [foo][bar][baz]"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Regression: a pointer-to-generic type argument (HashMap<String, ArrayList<int>*>) must not corrupt the
# base ArrayList<int> instantiation (its get() must stay int, not int*).
add_test(NAME codegen_generic_ptr_typearg_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_ptr_typearg.pol"
    "-DEXPECTED=sum=30 size=2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Debug info (`polc -g`): the .ll carries DWARF metadata (compile unit, subprograms, line locations,
# local/parameter variables) and the program stays correct when built with debug info. Line breakpoints +
# variable inspection are proven separately with @@LOW@@UPPLINGB@@@@.
add_test(NAME codegen_debuginfo_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/debug_info.pol"
    "-DEXPECTED=r=42 t=15 p=15 d=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_debuginfo_test.cmake")

# A FUNCTION'S DEBUG LOCATIONS ARE ITS OWN. The builder kept the last location of the function defined
# before, and the block-argument phis of the next one were created before anything reset it -- so they
# were filed under the wrong subprogram, and LLVM refused the module. 148 of the 1,022 samples could not
# be compiled with `-g` at all; the test above compiles one program with it, and that program was never
# one of them. Any function with a merge point, defined after another, shows it. This sample is one of
# the 148, and a compile is the whole check: the refusal is an exit code.
add_test(NAME codegen_debuginfo_phi_stays_in_its_function
    COMMAND polc -g "${CMAKE_CURRENT_SOURCE_DIR}/samples/args_range.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/dbg_args_range.ll")

# Persistent subprocess (debugger/LSP): spawn `sort`, write lines, send EOF, read the sorted output back
# over the live pipe. Proves bidirectional stdio, unlike the one-shot Process.run.
add_test(NAME codegen_subprocess_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/subprocess.pol"
    "-DEXPECTED=apple banana cherry"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AES (spec 34, FIPS-197): AES-128/256 test vectors + ECB and CTR round-trips.
add_test(NAME codegen_aes_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/aes.pol"
    "-DCONTAINS=vec=1 ecb=1 ctr=1 changed=1 vec256=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ZonedDateTime (spec 34): an Instant read at a fixed UTC offset, with ISO-8601 formatting.
add_test(NAME codegen_zoned_datetime_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/zoned_datetime.pol"
    "-DCONTAINS=1969-12-31T21:00:00-03:00"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# UDP datagrams (spec 34): loopback send/receive round-trip with sender address.
add_test(NAME codegen_udp_socket_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/udp_socket.pol"
    "-DCONTAINS=ok=1 from=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Named concurrency primitives (spec 20): Semaphore + CountdownLatch across worker threads.
add_test(NAME codegen_concurrency_primitives_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/concurrency_primitives.pol"
    "-DCONTAINS=count=6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SecureRandom (spec 34): cryptographically secure randomness from the OS CSPRNG.
add_test(NAME codegen_secure_random_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/secure_random.pol"
    "-DCONTAINS=inRange=1 nonneg=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Environment variables (spec 34): Env.get / Env.set.
add_test(NAME codegen_env_vars_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/env_vars.pol"
    "-DCONTAINS=v=hello42 missing_len=0"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and the distinction the raw builtin cannot make: a variable that is NOT SET reads "" through
# Env.get, exactly like one set to "". A program could not tell a missing configuration from a blank
# one, and nothing failed -- it ran with a default nobody chose. The two lines checked here are the
# same two variables seen both ways: raw='' for both, present=1 for one and 0 for the other.
add_test(NAME codegen_system_environment_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_environment.pol"
    "-DCONTAINS=set: raw='cinco' present=1 value='cinco'"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
add_test(NAME codegen_system_environment_absent COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_environment.pol"
    "-DCONTAINS=absent: raw='' present=0 fallback='default'"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
# The machine answering for itself, and `require` refusing to invent a value.
add_test(NAME codegen_system_environment_machine COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_environment.pol"
    "-DCONTAINS=machine: os known=1 threads>0=1 page=4096 memory>0=1 pid>0=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
add_test(NAME codegen_system_environment_require COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_environment.pol"
    "-DCONTAINS=require threw: environment variable is not set: POLARON_NO_SUCH_VAR_ZZZ"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Stopwatch (spec 34): a monotonic elapsed-time timer over the high-resolution clock.
add_test(NAME codegen_stopwatch_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stopwatch.pol"
    "-DCONTAINS=ok=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Deep copy of an object with an array of concrete-class elements copies the elements too (spec 5).
add_test(NAME codegen_deep_copy_array_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy_array.pol"
    "-DCONTAINS=a0=10 a1=20 b0=99 b1=20"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Paths.dirname/basename handle the Windows '\' separator, not only '/'.
add_test(NAME codegen_paths_windows_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/paths_windows.pol"
    "-DCONTAINS=baseOk=1 dirOk=1 fwdOk=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# String.toDouble (spec 4) + Env.executablePath (spec 34): float parsing and the program's own path.
add_test(NAME codegen_parse_double_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/parse_double.pol"
    "-DCONTAINS=a=314 b=-150 c=42 exe_ok=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A leading UTF-8 BOM (from a Windows editor) must be skipped by the lexer, not lexed as a stray char.
add_test(NAME codegen_bom_source_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bom_source.pol"
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
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DOPT=-O2"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_affine.pol"
    "-DCONTAINS=sum=55502"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A HOSTED PROGRAM THAT INDEXES A RAW POINTER, AT -O2 -- which did not compile at all:
# `class 'int*' has no method 'length'`, from a guard `hoistBoundsChecks` synthesizes over the base
# of an indexed access. The symptom was known and the cure was aimed at the wrong place: the pass was
# skipped for FREESTANDING programs, where pointers are everywhere and it was noticed at once, so
# hosted code kept the bug and nothing here indexed a pointer at -O2 to find it.
#
# `-DOPT=-O2` is the whole test, for the same reason it is on `bce_affine` above: the pass does not
# run at -O0, so at the default this file compiles either way and proves nothing.
add_test(NAME codegen_bce_raw_pointer_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DOPT=-O2"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_raw_pointer.pol"
    "-DCONTAINS=sum=136"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# `address` no longer widens from/to a plain integer in hosted code: turning a number into a pointer
# is the conversion a no-exploitable-UB language has to make somebody write down. Freestanding is
# exempt -- the pico kernel does it 210 times and means every one of them.
add_test(NAME sema_rejects_address_from_int
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_int_bad.pol")
set_tests_properties(sema_rejects_address_from_int PROPERTIES
    PASS_REGULAR_EXPRESSION "address")

# A user type may share a simple name with a stdlib one; the stdlib keeps meaning its own.
add_test(NAME codegen_stdlib_name_shadow_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stdlib_name_shadow.pol"
    "-DCONTAINS=42 4 5 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...but a name the COMPILER provides cannot be taken over, because the stdlib calls it.
add_test(NAME sema_rejects_builtin_type_name
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/builtin_name_bad.pol")
set_tests_properties(sema_rejects_builtin_type_name PROPERTIES
    PASS_REGULAR_EXPRESSION "is a type the compiler provides")

# A lone string literal is text, not a printf format: `%` in it is a percent sign.
add_test(NAME codegen_percent_literal_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/percent_literal.pol"
    "-DCONTAINS=progress: 50% done"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# spec 19.6: `move T` in a signature demands `move` at the call and at the return.
add_test(NAME sema_rejects_missing_move_at_call
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/move_signature_bad.pol")
set_tests_properties(sema_rejects_missing_move_at_call PROPERTIES
    PASS_REGULAR_EXPRESSION "has to say so")

# A command's body is type-checked like any other body. Written when the construct was a lambda,
# whose `typeOf` built the signature and returned without visiting the body -- a blind spot the size
# of every callback in the language. A command cannot have it by construction (it becomes an ordinary
# method before the analyzer runs), and the promise is still worth holding a program against.
add_test(NAME sema_checks_command_body
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/command_body_bad.pol")
set_tests_properties(sema_checks_command_body PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0101")

# `movable` is enforced at all four destinations a value can reach, not only at a local's declaration
# and reassignment. The sample trips the field, the argument and the return in one file.
add_test(NAME sema_rejects_movable_without_move
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/ownership_sites_bad.pol")
set_tests_properties(sema_rejects_movable_without_move PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0405")

# One constructor per class, for the same reason there is one method per name. A second one used to be
# accepted and its parameters APPENDED to the first's, so the error landed on the call site as
# "expects 3 arguments" -- a message with no relation to the mistake.
add_test(NAME sema_rejects_second_constructor
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/second_constructor_bad.pol")
set_tests_properties(sema_rejects_second_constructor PROPERTIES
    PASS_REGULAR_EXPRESSION "already has a constructor")

# `interrupt` -- the three things the declaration exists to forbid. The value of the keyword is in
# what it refuses, not in the calling convention: that is about fifty lines of codegen and LLVM
# already had it.
#
# Calling one is simulating an interrupt, which is a different thing wearing the same name.
add_test(NAME sema_rejects_interrupt_call
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_call_bad.pol")
set_tests_properties(sema_rejects_interrupt_call PROPERTIES
    PASS_REGULAR_EXPRESSION "an interrupt cannot be called")

# It is ENTERED, so there is no caller for a value to go back to. The one way to resume somewhere
# else is to modify the trap the hardware pushed -- which is why the parameter is not decoration.
add_test(NAME sema_rejects_interrupt_returning_value
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_returns_bad.pol")
set_tests_properties(sema_rejects_interrupt_returning_value PROPERTIES
    PASS_REGULAR_EXPRESSION "an interrupt must return void")

# `static` would take away the object the handler exists to reach. That object is the entire
# argument for `interrupt` being its own declaration form: a free handler has no state, an instance
# one reads `this.buffer` and `this.head`, and a kernel built on sixteen device objects needs the
# second. Accepting `static interrupt` would quietly hand the driver model back to C.
add_test(NAME sema_rejects_static_interrupt
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_static_bad.pol")
set_tests_properties(sema_rejects_static_interrupt PROPERTIES
    PASS_REGULAR_EXPRESSION "'static' cannot be applied to an interrupt")

# Two in one class. The duplicate is caught by the existing no-overloading rule -- an interrupt is a
# `MethodDecl` -- but that message explains "each method name must be unique" for a declaration whose
# name the author never wrote. This test pins the message to the rule the namelessness actually
# expresses, so it cannot quietly regress to the generic one.
add_test(NAME sema_rejects_two_interrupts
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_twice_bad.pol")
set_tests_properties(sema_rejects_two_interrupts PROPERTIES
    PASS_REGULAR_EXPRESSION "already declares an interrupt -- one device, one handler")

# The trap parameter is WORLD-SHAPED, and the two halves of that rule are what keep the portable
# meaning from becoming a portable lie. Bare metal hands over the frame the CPU pushed (an object
# with fields); a hosted world hands over a code -- a signal number, a console control type -- and
# no frame exists to point at. Getting either wrong type-checks and then delivers the wrong thing:
# a signal number reinterpreted as a pointer, or a frame that never arrives.
add_test(NAME sema_rejects_hosted_interrupt_frame
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_hosted_frame_bad.pol")
set_tests_properties(sema_rejects_hosted_interrupt_frame PROPERTIES
    PASS_REGULAR_EXPRESSION "a hosted interrupt is entered with a CODE")

add_test(NAME sema_rejects_freestanding_interrupt_code
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_freestanding_code_bad.pol")
set_tests_properties(sema_rejects_freestanding_interrupt_code PROPERTIES
    PASS_REGULAR_EXPRESSION "a freestanding interrupt receives the frame the CPU pushed")

# Rules 2 and 3 are about what the handler REACHES, and these two pin the reachability rather than
# the local case. The sample's handler is innocent on its own -- it calls one method -- and the
# allocation is two hops down. Both messages must carry the PATH: "Log.record allocates" is a fact
# about Log, and a fact about Log is not a bug; "the interrupt reaches it, via drain and record" is,
# and it is the sentence that says which of the two to change.
add_test(NAME sema_rejects_interrupt_reaching_heap
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_reaches_bad.pol")
set_tests_properties(sema_rejects_interrupt_reaching_heap PROPERTIES
    PASS_REGULAR_EXPRESSION "must not allocate on the heap \\(reached via drain, record\\)")

add_test(NAME sema_rejects_interrupt_reaching_shared_state
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_reaches_bad.pol")
set_tests_properties(sema_rejects_interrupt_reaching_shared_state PROPERTIES
    PASS_REGULAR_EXPRESSION "'Log.written' is mutable state an interrupt reaches \\(reached via drain, record\\)")

# ...AND THE TWO PATHS NOBODY WRITES, which is where the rule used to stop.
#
# The walk follows `callees`, and a constructor and a destructor were never in it -- worse, neither
# had a row in the facts table at all, because only METHODS were given a key. So a handler holding
# `Scratch s = new Scratch() on stack;` -- whose constructor allocates and whose destructor frees --
# compiled clean, with an allocation and a free in an interrupt handler and no diagnostic anywhere.
#
# The `reentrant` message has always ended *"including the destructor that runs at the end of a
# scope"*. It is a promise the code now keeps.
#
# `(reached via Scratch)` names the constructor and `(reached via ~)` the destructor, so the two are
# separate tests: one of them passing while the other regresses is the failure worth catching.
add_test(NAME sema_rejects_interrupt_reaching_implicit_constructor
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_implicit_calls_bad.pol")
set_tests_properties(sema_rejects_interrupt_reaching_implicit_constructor PROPERTIES
    PASS_REGULAR_EXPRESSION "must not allocate on the heap \\(reached via Scratch\\)")

add_test(NAME sema_rejects_interrupt_reaching_implicit_destructor
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_implicit_calls_bad.pol")
set_tests_properties(sema_rejects_interrupt_reaching_implicit_destructor PROPERTIES
    PASS_REGULAR_EXPRESSION "must not free memory \\(reached via ~\\)")

# THE TRAP IS READ-ONLY, and this is a measurement rather than caution. `x86_intrcc` takes the frame
# as `byval`, which promises the callee a private copy, so LLVM is entitled to treat writes through
# it as writes to that copy -- and does: at -O2 a plain store is deleted outright, and a `volatile`
# one lands in a scratch buffer the epilogue discards (`subq $16,%rsp` ... `addq $16,%rsp`). Both
# were compiled and read. `iretq` returns exactly where it came from either way, so a scheduler
# written this way runs forever without ever scheduling -- the precise failure this keyword exists
# to make impossible, arrived at through the keyword itself.
add_test(NAME sema_rejects_writing_the_trap
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_trap_write_bad.pol")
set_tests_properties(sema_rejects_writing_the_trap PROPERTIES
    PASS_REGULAR_EXPRESSION "the trap an interrupt receives is READ-ONLY")

# `atomic<T>` is one `lock`-prefixed instruction when T fits a machine word and a `__atomic_*`
# library call when it does not. Freestanding has nothing to link those against, so the declaration
# used to compile and the KERNEL failed at link time naming a symbol nobody wrote. Refused where the
# type is written instead. `interrupt_atomic_ok` is the other side of this: `atomic<int>` still
# compiles, so the check does not over-fire on the case the rules above depend on.
add_test(NAME sema_rejects_wide_atomic_freestanding
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_wide_bad.pol")
set_tests_properties(sema_rejects_wide_atomic_freestanding PROPERTIES
    PASS_REGULAR_EXPRESSION "is wider than a machine word")

# `implements Shared` opens the thread boundary to a program's own types, so the check that it did
# not open it to EVERY type: the same closure, over a class that holds a plain int, is still a data
# race and still refused. `thread_shared_type` is the other side -- the declaration is the whole
# difference between the two samples.
add_test(NAME sema_rejects_unshared_type_in_thread
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_unshared_type_bad.pol")
set_tests_properties(sema_rejects_unshared_type_in_thread PROPERTIES
    PASS_REGULAR_EXPRESSION "this thread's work carries 'into'")

# `transformer` -- what a type GAINS by applying it, which is the one thing none of the other
# declarations said. A procedure with no body is a SOCKET, and the error lands on the `applies` line
# because that line is where the obligation was taken on -- not inside the transformer, which is
# correct and is somebody else's file.
add_test(NAME sema_rejects_unimplemented_socket
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_socket_bad.pol")
set_tests_properties(sema_rejects_unimplemented_socket PROPERTIES
    PASS_REGULAR_EXPRESSION "requires `procedure label`, and does not implement it")

# A STATIC FIELD WHOSE INITIALIZER MUST ALLOCATE. A global's value is written into the binary
# before the program starts, so a `String` or a `new T[n]()` has nothing to write. The guard that
# refuses an unevaluable initializer asked `isNumericStaticType` first and so covered only the
# numeric half: this half was silently zeroed to a null pointer, and failed later and elsewhere --
# once as a bounds panic on an array whose length came out 0, once as an access violation on first
# read of a String. The standard library's own `Test` class was written this way and survived only
# because its runner calls `reset()` first; it uses `onClassLoad` now.
#
# A FULL COMPILE AND NOT `--check`, which is itself worth knowing: the guard lives in codegen, so
# semantic analysis alone reports this file as OK. An editor or the LSP would show it clean and the
# error would arrive at build time. Moving the check to the analyzer wants the folder that decides
# "can this be evaluated", which is codegen's -- so it is stated here rather than half-moved.
add_test(NAME codegen_rejects_allocating_static_initializer
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/static_alloc_init_bad.pol"
                  -o "${CMAKE_CURRENT_BINARY_DIR}/static_alloc_init_bad.ll")
set_tests_properties(codegen_rejects_allocating_static_initializer PROPERTIES
    # Short on purpose: the diagnostic is wrapped for the terminal, so a regex spanning the wrap
    # would match the message as a string and not as it is printed.
    PASS_REGULAR_EXPRESSION "must be ALLOCATED")

# Provenance is checked in BOTH directions, and both halves are needed. Without the first, a
# transformer-brought member could be written `method` and read as the type's own; without the
# second, `procedure` would quietly decay into a synonym for `method` on types that apply nothing.
# Together they are what makes provenance survive a terminal, a diff and a review -- which is what
# Java's `@Override` tries to be and fails at, because it can be left out.
add_test(NAME sema_rejects_method_for_procedure
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_method_bad.pol")
set_tests_properties(sema_rejects_method_for_procedure PROPERTIES
    PASS_REGULAR_EXPRESSION "is written `procedure`, not `method`")

add_test(NAME sema_rejects_procedure_without_transformer
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_procedure_bad.pol")
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
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_mutual_bad.pol")
set_tests_properties(sema_rejects_asymmetric_mutual PROPERTIES
    PASS_REGULAR_EXPRESSION "is `mutual`, and 'Kelvin' implements `into<Celsius>`")

# TOTALITY, and partiality DEDUCED rather than annotated. A per-target procedure converts FROM the
# type it is written on, and a class is closed over its fields, so the conversion must cover them --
# nobody wrote `total` anywhere. The dual is what makes the rule honest: a STATIC per-target
# procedure converts *to* this type, its source is the parameter, that source is open, and it is
# fallible by construction. `Errno -> int` is total; `int -> Errno` is not, and neither needed a word.
add_test(NAME sema_rejects_partial_conversion
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_totality_bad.pol")
set_tests_properties(sema_rejects_partial_conversion PROPERTIES
    PASS_REGULAR_EXPRESSION "must be total -- and it never reads: fraction")

# The warning itself, and that it fires ONCE and only on the by-value half: the same sample has a
# `Basket*` parameter mutated the same way three lines down, and that one is correct.
add_test(NAME sema_warns_byvalue_mutation
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/byvalue_mutation_warn.pol")
set_tests_properties(sema_warns_byvalue_mutation PROPERTIES
    PASS_REGULAR_EXPRESSION "'add' changes the object it is called on, and 'b' is a parameter taken BY VALUE")

add_test(NAME sema_warns_transformer_naming
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_naming_warn.pol")
set_tests_properties(sema_warns_transformer_naming PROPERTIES
    PASS_REGULAR_EXPRESSION "transformer 'Describable' should be named `TDescriber`")

# AN ADDRESS DECLARED AS A NUMBER, with no cast to point at. `int vram = 0xB8000;` is the commonest
# and quietest form of the mistake `address` exists to stop, and the cast check could not see it.
add_test(NAME sema_warns_address_shaped_declaration
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_shaped_decl.pol")
set_tests_properties(sema_warns_address_shaped_declaration PROPERTIES
    PASS_REGULAR_EXPRESSION "`vram` is declared `int` and holds what is written as an address")

# ...AND THE SILENCE, which is the half that decides whether anybody reads the other one. A big hex
# constant is not always a place: `0x53425355` is 'USBS' (every byte a printable character), `magic`
# says what it is in its own name, `0xFFFFFFFF` is a mask and `0x800` is smaller than a page. The
# first of those was found by running this check over pico, where it was the only thing it reported.
add_test(NAME sema_address_shaped_spares_magics
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_shaped_decl.pol")
set_tests_properties(sema_address_shaped_spares_magics PROPERTIES
    PASS_REGULAR_EXPRESSION "`apic` is declared `long`"
    FAIL_REGULAR_EXPRESSION "`(usbStatus|magic|mask|small|framebuffer|count)` is declared")

# ...AND THE OTHER TWO PLACES AN ADDRESS CAN ARRIVE. A check that only reads declarations reports a
# clean kernel while the addresses turn up somewhere else: a driver names its bases in a `fixed` block
# and ASSIGNS to its fields three hundred lines away, which is where a reader is no longer looking at
# the type. Both forms warn; a `fixed` is the highest-value one of the three.
add_test(NAME sema_warns_address_shaped_assignment
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_shaped_assign.pol")
set_tests_properties(sema_warns_address_shaped_assignment PROPERTIES
    PASS_REGULAR_EXPRESSION "`(Base|where|spot)` is declared `int`")

# ...AND THE SILENCE AGAIN, now over the families a KERNEL is actually made of. Running the first
# version of this check over pico reported 64 places, and not one of them was an address: ARGB
# colours, Unicode codepoints, single-bit device flags, register offsets and MSR numbers. A warning
# that fires on half the constants in every driver is a warning that gets switched off.
add_test(NAME sema_address_shaped_spares_devices
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_shaped_assign.pol")
set_tests_properties(sema_address_shaped_spares_devices PROPERTIES
    PASS_REGULAR_EXPRESSION "`Base` is declared `int`"
    FAIL_REGULAR_EXPRESSION "`(Ident|Magic|Mask|Port|EnableBit|Argb|RegHead|proper|kept)` is declared")

# A `typealias` MUST NOT CHANGE THE PROGRAM. Declaring one makes the alias pass re-clone every class
# with an empty substitution, so the cloner becomes a rewrite of the whole program -- and everything
# it silently fails to copy is silently deleted from a program whose author added two words in
# another file. pico lost its inline assembly, its `volatile` locals, its byte literals, its layouts,
# its unions and its chaos tetrad in one build, and polc crashed emitting a `naked` method whose body
# had been removed. Three needles, one per clone path that was broken.
add_test(NAME codegen_alias_reclone_keeps_asm COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/alias_reclone_fidelity.pol"
    "-DTARGET_TRIPLE=x86_64-unknown-none-elf"
    "-DNEEDLE=asm sideeffect"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# The one that cost the kernel: a `volatile int*` LOCAL is how every MMIO register and every wait
# loop in a freestanding program is read, and without the word -O2 hoists the read out of the loop.
add_test(NAME codegen_alias_reclone_keeps_volatile_locals COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/alias_reclone_fidelity.pol"
    "-DTARGET_TRIPLE=x86_64-unknown-none-elf"
    "-DNEEDLE=load volatile"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# ...and the chaos tetrad, whose `abstainfrom` lowers to a private counter. A dropped `abstainfrom`
# leaves the label with nothing to disable it, so a one-shot runs every time.
add_test(NAME codegen_alias_reclone_keeps_abstain COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/alias_reclone_fidelity.pol"
    "-DTARGET_TRIPLE=x86_64-unknown-none-elf"
    "-DNEEDLE=@abstain."
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# A `cascade` OVER A SHARED NODE LINKS BARE METAL. Two classes owning the same kind of thing makes
# the owned graph stop being a forest, so the walk allocates a visited set -- which was a hosted
# runtime call and three undefined symbols on a freestanding target. `define` and not `declare` is
# the whole assertion: the set is generated from the program's own `heap class`, like the String
# helpers, so a program that says where memory comes from has said enough for `cascade` to work.
add_test(NAME codegen_freestanding_cascade_defines_ptrset COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_shared_freestanding.pol"
    "-DTARGET_TRIPLE=x86_64-unknown-none-elf"
    "-DNEEDLE=define internal i32 @__polaron_ptrset_add"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

# ...and a HOSTED program still takes the runtime's own. Generating a second copy into every hosted
# module would be a duplicate definition of something the runtime library already exports.
add_test(NAME codegen_hosted_cascade_uses_runtime_ptrset COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_graph.pol"
    "-DNEEDLE=define internal i32 @__polaron_ptrset_add"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

# AN ENUM FIELD IS PART OF A TYPE'S IDENTITY. It was counted with the class references and left out
# of the generated key, so a record whose own comment said the kind was part of what it is compared
# two different kinds as EQUAL. Found in Stone Reports, on the type that reads a directory entry.
add_test(NAME codegen_record_enum_field_is_identity COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_enum_field_is_identity.pol"
    "-DEXPECTED=kinds differ: false same kind: true ordered: -1 hashes differ: true"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and the OTHER rule about an enum in a record stands, with a sentence that says where to edit:
# an enum that writes no `toString` has none for the generated one to ask.
add_test(NAME sema_record_enum_field_needs_tostring
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/record_enum_field_needs_tostring_bad.pol")
set_tests_properties(sema_record_enum_field_needs_tostring PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0103.*has no .toString. to ask")

# THE KEY WARNING NAMES ONLY THE HOOKS IT IS ACTUALLY GENERATING. `HalfPainted` writes equalsKey and
# hash, so only `compareTo` is generated and only `compareTo` may be named -- and the consequence
# changes with it, from "compare EQUAL" to "order as equal", because the equality is the author's now.
add_test(NAME sema_key_warning_names_generated_hooks
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/record_key_hooks_warn.pol")
set_tests_properties(sema_key_warning_names_generated_hooks PROPERTIES
    PASS_REGULAR_EXPRESSION "field 'swatch' of 'HalfPainted'.*left out of compareTo.*order as equal")

# ...and it is SILENT for the record that wrote all three. This is the half that matters: a warning
# that survives its own fix is a warning people learn to scroll past. `Painted` must not be named.
add_test(NAME sema_key_warning_stops_when_fixed
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/record_key_hooks_warn.pol")
set_tests_properties(sema_key_warning_stops_when_fixed PROPERTIES
    FAIL_REGULAR_EXPRESSION "of 'Painted'")

# A TYPED ARENA REFUSES THE WRONG TYPE, and until now it refused it only when the region happened to
# be a LOCAL: the accepts check was never reached for a region held in a field, which is the only
# place a container can keep one. So `accepts({T})` on a pool's own arena meant nothing.
add_test(NAME sema_rejects_wrong_type_in_region_field
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/arena_pool_wrong_type.pol")
set_tests_properties(sema_rejects_wrong_type_in_region_field PROPERTIES
    PASS_REGULAR_EXPRESSION "region 'this.pen' does not accept type 'Cat'")

# `collective` -- the relation must be COMPLETE over the appliers, and the two ways it can fail.
#
# A gap: `D` applies the transformer and nothing leads from `A` to it, so the set is not one
# relation. The message names the pair and the cheap fix -- any conversion that reaches it, because
# the rest is composed.
# A NON-NULL PROOF DOES NOT SURVIVE A BACK EDGE. The body of a loop is read once and stands for
# every iteration, so a proof made before the loop cannot be believed inside it once the body has
# assigned the name away. This compiled until 2026-08-20, and the narrowing it fed is not advice:
# `typeOf` reports the non-nullable type to argument passing, to `return` and to field assignment.
# What caught the null was the runtime trap, which is the guarantee of last resort.
add_test(NAME sema_rejects_null_proof_across_back_edge
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/null_proof_back_edge_bad.pol")
set_tests_properties(sema_rejects_null_proof_across_back_edge PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0300.*'nullable Node\\*', which is nullable")

# ...and the proofs a loop does NOT take away still hold, or the fix above would cost every
# narrowing inside every loop: one proven before the loop and untouched by it, one made by the
# loop's own condition, and one made by a guard clause in the body.
add_test(NAME sema_keeps_null_proofs_a_loop_does_not_kill
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/null_proof_in_loop.pol")
set_tests_properties(sema_keeps_null_proofs_a_loop_does_not_kill PROPERTIES
    FAIL_REGULAR_EXPRESSION "error")

add_test(NAME sema_rejects_collective_gap
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_collective_gap_bad.pol")
set_tests_properties(sema_rejects_collective_gap PROPERTIES
    PASS_REGULAR_EXPRESSION "nothing leads from 'A' to 'D'")

# A tie: a diamond, where `A` reaches `D` through two routes of the same length that do not agree.
# REFUSED rather than resolved, which is the rule the rest of the feature already follows -- there is
# never an implicit winner and never an order. Two transformers bringing the same member is settled
# by the type; two equally short routes are settled by writing the conversion.
add_test(NAME sema_rejects_collective_ambiguity
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_collective_ambiguous_bad.pol")
set_tests_properties(sema_rejects_collective_ambiguity PROPERTIES
    PASS_REGULAR_EXPRESSION "two equally short ways to reach 'D'")

# `final procedure` seals a body. Calls between procedures inside a transformer dispatch to the
# APPLIED version, which is what makes the feature useful and is exactly what makes this word
# necessary: a type could otherwise replace the step the algorithm depends on. It was parsed and
# stored and read by nobody, so the replacement passed in silence.
add_test(NAME sema_rejects_replacing_final_procedure
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_final_bad.pol")
set_tests_properties(sema_rejects_replacing_final_procedure PROPERTIES
    PASS_REGULAR_EXPRESSION "declares `final procedure ordering`, so 'Box' may not replace it")

# `freestanding transformer` -- the bodies obey the bare-metal subset, checked HERE rather than in
# somebody else's kernel. The program in this sample is hosted, and the interpolation is still
# refused, because the modifier is a promise the transformer made about its own bodies.
#
# The modifier did not parse at all before: the declaration scanned past `mutual` and `explicit` and
# nothing else, so the design note's own `RegionOwner` example was unwritable.
add_test(NAME sema_rejects_freestanding_transformer_body
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_freestanding_bad.pol")
set_tests_properties(sema_rejects_freestanding_transformer_body PROPERTIES
    PASS_REGULAR_EXPRESSION "came from `freestanding transformer TNamer`")

# THE SUBJECT RULE, which the design note states and nothing checked. An action lives in a method or
# a procedure and both have a subject; an instance procedure has its in the receiver, and a static one
# has to name it. The same rule that turned namespace-level `static_assert` into `demand`.
add_test(NAME sema_rejects_subjectless_static_procedure
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_subject_bad.pol")
set_tests_properties(sema_rejects_subjectless_static_procedure PROPERTIES
    PASS_REGULAR_EXPRESSION "`static procedure max` names no subject")

# THE ENUM ROW OF THE TOTALITY TABLE. A class is closed over its fields, an enum over its CONSTANTS.
# `match` exhaustiveness already covered the natural spelling, but never this one: an if/else chain
# over constants was checked by nothing, and the constant it forgot fell through to the last line.
add_test(NAME sema_rejects_partial_enum_conversion
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_enum_totality_bad.pol")
set_tests_properties(sema_rejects_partial_enum_conversion PROPERTIES
    PASS_REGULAR_EXPRESSION "closed over its constants.*never names: EACCES")

# The region binder is ON by default. Returning a pointer to an object in this method's own frame is
# rejected -- the gap the analysis was named for and did not close until now.
add_test(NAME sema_rejects_escape_by_return
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_return_bad.pol")
set_tests_properties(sema_rejects_escape_by_return PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1721")

# THE FIVE SHAPES THE BINDER USED TO LET THROUGH, each one a real lifetime bug that compiled clean
# until the pass that closed it. They were found by pointing a battery of small wrong programs at
# the analysis rather than by reading it, which is the only way to learn what a checker is silent
# about: reading tells you what it looks for.
#
# 1. AN ACCESSOR'S ANSWER outliving the object it came from. The analysis knew a call could keep a
#    borrow of its ARGUMENT and not that it could hand back a borrow of its RECEIVER -- which is
#    what every accessor in every class does.
add_test(NAME sema_rejects_borrow_of_receiver
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_borrow_of_receiver_bad.pol")
set_tests_properties(sema_rejects_borrow_of_receiver PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# 2. AN ALIAS. `delete b` follows the name, so one extra line naming the same object walked past it.
add_test(NAME sema_rejects_alias_after_delete
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_alias_after_delete_bad.pol")
set_tests_properties(sema_rejects_alias_after_delete PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# 3. A POINTER INTO A FRAME VALUE. `return p` was refused and `return &p.a` was not.
add_test(NAME sema_rejects_interior_pointer_escape
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_interior_pointer_bad.pol")
set_tests_properties(sema_rejects_interior_pointer_escape PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1721")

# 4. AN ARRAY IN A LOCAL REGION, RETURNED -- the chapter's own headline case, passing on two counts:
#    a region-allocated ARRAY was not recorded as living in the region, and the return gate read
#    `T*` and not `T[]`. The message names the region's flavour.
add_test(NAME sema_rejects_region_array_escape
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_region_array_bad.pol")
set_tests_properties(sema_rejects_region_array_escape PROPERTIES
    PASS_REGULAR_EXPRESSION "bump region")

# 5. AN OUT PARAMETER. The same escape as a return, spelled backwards, and there was no branch for it.
add_test(NAME sema_rejects_out_parameter_escape
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_out_parameter_bad.pol")
set_tests_properties(sema_rejects_out_parameter_escape PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1721")

# A NUMBER FILED IN A STATIC FIELD IS NOT A KEEP, and the pointer still is. The number check read
# only `this.field = ...`, so a static method storing an `address` it read out of its argument was
# recorded as keeping the argument -- the Horizon kernel's `Ram.open(&frames)` was refused while the
# compiler's own advice said `open` only reads through `frames`.
add_test(NAME sema_number_into_static_is_not_a_keep
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_number_into_static_ok.pol")
set_tests_properties(sema_number_into_static_is_not_a_keep PROPERTIES
    FAIL_REGULAR_EXPRESSION "error")
add_test(NAME sema_rejects_pointer_into_static
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_pointer_into_static_bad.pol")
set_tests_properties(sema_rejects_pointer_into_static PROPERTIES
    PASS_REGULAR_EXPRESSION "error\\[Polaron-1721\\]: region-binder: 'open' keeps that argument")

# AND THE ADVICE THAT MAKES REGIONS SOMETHING THE ANALYSIS ASKS FOR rather than something an author
# has to think of unprompted: three or more hand-paired allocations are a region written longhand,
# and the flavour is chosen from what the method does -- `pool` when the pairs are inside a loop,
# `bump` when they are not. Run as well as checked, because the advice must not change what the
# program computes.
add_test(NAME lint_suggests_a_region_with_its_flavour
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_advice_flavours.pol")
set_tests_properties(lint_suggests_a_region_with_its_flavour PROPERTIES
    PASS_REGULAR_EXPRESSION "bump region written out longhand")

add_test(NAME lint_suggests_a_pool_region_for_a_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_advice_flavours.pol")
set_tests_properties(lint_suggests_a_pool_region_for_a_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "pool region written out longhand")

add_test(NAME codegen_region_advice_flavours_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_advice_flavours.pol"
    "-DEXPECTED=flat=10 looped=36"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# TWO OWNERS FOR ONE OBJECT, written as one assignment: a pointer copied between two fields that are
# both freed by their destructors, so whichever object is destroyed second frees what the first
# already freed. Read off the destructors, like every other ownership answer here.
add_test(NAME sema_warns_two_owners_for_one_object
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/two_owners_for_one_object.pol")
set_tests_properties(sema_warns_two_owners_for_one_object PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0B53")

# ...and it is about OWNERSHIP, not about assignment. The same line, from the same place, into the
# same shape of field, in a class whose destructor frees nothing: a view over somebody else's
# storage, written the ordinary way. Silent -- and it runs, because the proof that the ownership is
# right is that the allocator is intact at exit. Without this half the rule would refuse every view
# in the language.
add_test(NAME sema_two_owners_rule_spares_a_borrower
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrowed_field_is_not_a_second_owner_ok.pol")
set_tests_properties(sema_two_owners_rule_spares_a_borrower PROPERTIES
    FAIL_REGULAR_EXPRESSION "Polaron-0B53")

add_test(NAME codegen_borrowed_field_is_not_a_second_owner_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/borrowed_field_is_not_a_second_owner_ok.pol"
    "-DEXPECTED=4"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# FREEING SOMETHING YOU BORROWED -- the mirror of the read-after-free rule, from the same fact, and
# the harder half to see: the second free happens in a destructor, in another file, on a path this
# method never mentions.
add_test(NAME sema_rejects_deleting_a_borrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_a_borrow_bad.pol")
set_tests_properties(sema_rejects_deleting_a_borrow PROPERTIES
    PASS_REGULAR_EXPRESSION "does not own what it points at")

# ...and its control, which is what stopped the first version of that rule: taking a borrow, reading
# it, and deleting the OWNER is the commonest correct shape there is. (The first version also refused
# an alias and a grow-and-replace, fourteen times, in the standard library.)
add_test(NAME codegen_borrow_used_and_owner_freed_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_used_and_owner_freed_ok.pol"
    "-DEXPECTED=7"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A COMMAND IS A BODY THAT RUNS SOMEWHERE ELSE. Analysed where it is written, with the state that
# holds there, it is always innocent; the call site knows what has been freed since and never looked
# inside. A lambda needed its body REPLAYED at the call to answer this; a command's baggage is a
# declared list, so the two lines above the call are the whole summary -- which is the concrete form
# of what `carries` buys. The call ABOVE the delete stays silent, which is the difference between
# this and a rule about commands that carry pointers.
add_test(NAME sema_rejects_command_called_after_free
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/command_called_after_free_bad.pol")
set_tests_properties(sema_rejects_command_called_after_free PROPERTIES
    PASS_REGULAR_EXPRESSION "carries 'b', and 'b' is gone by here")

# A METHOD THAT FREES WHAT IT WAS GIVEN IS NOT A METHOD THAT LETS IT ESCAPE -- and §11.5's summary
# only asked the second question, so an object whose method does `delete this` was given a frame slot
# and the allocator was handed a stack address. Exit 0xC0000374, nothing printed. The cost of the
# fix is one allocation across the whole corpus (heap-to-stack 50 -> 49).
add_test(NAME codegen_self_delete_is_not_a_frame_slot COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/self_delete_is_not_a_frame_slot.pol"
    "-DEXPECTED=3 after"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THE SECOND TIME ROUND THE LOOP. A body analysed once, with the state that holds at the top, is
# checked in the only order where "free at the bottom, read at the top" is innocent. Answered by
# replaying the body with the state the previous iteration left -- so every obligation the analyser
# already tracks crosses the back edge, rather than one new rule per kind.
add_test(NAME sema_rejects_loop_that_frees_then_reads_next_iteration
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/loop_frees_at_the_end_and_reads_at_the_top_bad.pol")
set_tests_properties(sema_rejects_loop_that_frees_then_reads_next_iteration PROPERTIES
    PASS_REGULAR_EXPRESSION "on the next iteration of this loop")

# ...and the control that makes the replay worth its cost: the same three ingredients -- a loop, a
# `delete this` in it, reads of the receiver above -- in a program that is CORRECT, because the path
# that frees also leaves. A rule that recognised the arrangement would refuse this; a replay of the
# flow does not, because that path never reaches the end of an iteration.
add_test(NAME codegen_loop_frees_then_leaves_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loop_frees_then_leaves_ok.pol"
    "-DEXPECTED=3"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# AN OBJECT THAT FREES ITSELF AND KEEPS READING ITSELF. The use-after-free rule follows local names
# and `this` is not one, so this was the one name in the language that could be freed and read with
# nothing said.
add_test(NAME sema_rejects_use_after_delete_this
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_this_then_read_bad.pol")
set_tests_properties(sema_rejects_use_after_delete_this PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0402")

# CHANGING A COLLECTION WHILE WALKING IT -- what a borrow checker gets from exclusivity, answered
# here without claiming it: the collection is named in the loop header, and a method that writes a
# field of its own receiver is one the walk cannot survive.
add_test(NAME sema_rejects_mutation_while_walking
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_mutates_what_it_walks_bad.pol")
set_tests_properties(sema_rejects_mutation_while_walking PROPERTIES
    PASS_REGULAR_EXPRESSION "while this loop is walking it")

# ...and its control, which is the commonest loop in the language and must stay quiet.
add_test(NAME codegen_foreach_builds_another_list_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_builds_another_list.pol"
    "-DEXPECTED=4 doubled"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# THREE MORE SHAPES OF THE SAME MISTAKE, each a way of holding a reference into an object past the
# object. They were found the way the first five were: by writing the wrong program and watching the
# analysis say nothing.
#
# A FIELD PATH. Only calls were followed as borrows, so `Leaf* deep = t.branch.leaf` -- the plainest
# way there is to take a reference into another object -- was invisible.
add_test(NAME sema_rejects_borrow_through_field_chain
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_through_field_chain_bad.pol")
set_tests_properties(sema_rejects_borrow_through_field_chain PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# A CONTAINER'S ELEMENT. `ArrayList.get` returns `T`, so the shape of the call said nothing -- and
# the owner's destructor said everything: it frees those elements, so handing one out is lending.
add_test(NAME sema_rejects_borrow_of_an_owned_element
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_of_an_owned_element_bad.pol")
set_tests_properties(sema_rejects_borrow_of_an_owned_element PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# AN ALIAS OF A BORROW, which is one assignment walking out of the rule the same way an alias of a
# deleted name used to.
add_test(NAME sema_rejects_alias_of_a_borrow
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/alias_of_a_borrow_bad.pol")
set_tests_properties(sema_rejects_alias_of_a_borrow PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# THREE COMPOSITIONS, each two facts the analysis already had that had never met.
add_test(NAME sema_rejects_borrow_handed_to_a_keeper
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_handed_to_a_keeper_bad.pol")
set_tests_properties(sema_rejects_borrow_handed_to_a_keeper PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

add_test(NAME sema_rejects_borrow_of_a_parameter_via_accessor
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_of_a_parameter_via_accessor_bad.pol")
set_tests_properties(sema_rejects_borrow_of_a_parameter_via_accessor PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

add_test(NAME sema_rejects_borrow_into_static_storage
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_into_static_storage_bad.pol")
set_tests_properties(sema_rejects_borrow_into_static_storage PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1721")

# THREE MORE WAYS A BORROW OUTLIVES WHAT IT POINTS AT: a method that frees its own field and
# replaces it, a borrow out of an object's own region, and a borrow taken on one branch and read on
# all of them.
add_test(NAME sema_rejects_borrow_after_field_replaced
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/method_frees_its_own_field_bad.pol")
set_tests_properties(sema_rejects_borrow_after_field_replaced PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

add_test(NAME sema_rejects_borrow_out_of_a_region_field
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_out_of_a_region_field_bad.pol")
set_tests_properties(sema_rejects_borrow_out_of_a_region_field PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

add_test(NAME sema_rejects_borrow_taken_in_one_branch
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_taken_in_one_branch_bad.pol")
set_tests_properties(sema_rejects_borrow_taken_in_one_branch PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# A `delete` INSIDE A LOOP. Not the borrow rule -- the plain use-after-free rule, walked out of by
# one `for`, because a loop restored the flow state from before its body and threw the obligations
# away with the proofs.
add_test(NAME sema_rejects_delete_inside_a_loop
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_inside_a_loop_bad.pol")
set_tests_properties(sema_rejects_delete_inside_a_loop PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0402")

# THE MUTATION SUMMARY, BOTH WAYS. A mutating call bound to a name is still a mutation...
add_test(NAME sema_rejects_foreach_mutating_call_bound
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_mutating_call_bound_bad.pol")
set_tests_properties(sema_rejects_foreach_mutating_call_bound PROPERTIES
    PASS_REGULAR_EXPRESSION "while this loop is walking it")

# ...and a read-only call that happens to assign a local is not. This one caught a rule that had the
# two commonest cases backwards while passing the entire suite.
add_test(NAME codegen_foreach_read_only_call_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_read_only_call_ok.pol"
    "-DEXPECTED=9"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# `surveyed` -- THE ONE ESCAPE THAT KEEPS THE COVER. Six samples, and between them they are the
# whole feature: the refusal it answers, the cure, the price, the limit, and the two places the word
# is refused outright.
#
# 1. The refusal it exists to answer: a pointer handed to a C function nothing in this program can
#    speak for.
add_test(NAME sema_rejects_unsurveyed_foreign_call
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_foreign_call_bad.pol")
set_tests_properties(sema_rejects_unsurveyed_foreign_call PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1723")

# 2. ...and the same call inside a surveyed wrapper, which compiles AND runs. The guess did not
#    disappear; it moved to a name and a line.
add_test(NAME codegen_surveyed_foreign_wrapper_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_foreign_wrapper_ok.pol"
    "-DEXPECTED=ok"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# 3. THE PRICE. Marking a method makes its CALLERS stricter -- the inversion that separates this
#    from an `unsafe`, where the freedom is local and the suspicion evaporates.
add_test(NAME sema_surveyed_exports_its_suspicion
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_exports_its_suspicion_bad.pol")
set_tests_properties(sema_surveyed_exports_its_suspicion PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1721")

# 4. THE LIMIT. Only the refusal about what cannot be PLACED is suspended; what the analysis can
#    still prove wrong is still refused inside a marked body.
add_test(NAME sema_surveyed_still_refuses_the_provable
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_still_refuses_the_provable_bad.pol")
set_tests_properties(sema_surveyed_still_refuses_the_provable PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-1724")

# 5. It is inherited: an override may not widen what the base promised, because a caller holding a
#    base reference reads the base's promise and would never see it.
add_test(NAME sema_rejects_surveyed_override_of_unsurveyed_base
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_override_widens_base_bad.pol")
set_tests_properties(sema_rejects_surveyed_override_of_unsurveyed_base PROPERTIES
    PASS_REGULAR_EXPRESSION "is surveyed but the method it overrides is not")

# 6. And never on a destructor, which is where ownership is declared and read from.
add_test(NAME sema_rejects_surveyed_destructor
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/surveyed_destructor_bad.pol")
set_tests_properties(sema_rejects_surveyed_destructor PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot be applied to a destructor")

# ...and `--no-region-binder` compiles that same program. There is no safe dialect in which you hand
# out a pointer to a dead frame, so the way to do it is to turn the analysis off and mean it.
add_test(NAME sema_no_region_binder_allows_escape
    COMMAND polc --check --no-region-binder "${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_return_bad.pol")
set_tests_properties(sema_no_region_binder_allows_escape PROPERTIES
    PASS_REGULAR_EXPRESSION "OK: entry point")

# What the binder must NOT complain about with it on: a heap object stored into a longer-lived field,
# and a heap object returned. Getting this wrong is why the analysis stayed switched off.
add_test(NAME codegen_escape_ok_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_ok.pol"
    "-DCONTAINS=sum=6 loose=10"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A static field may be written in terms of other static fields, in any order. This folded to nothing
# and emitted `i32 0` with no diagnostic until Polaron-0608 existed -- see the sample for what that cost.
add_test(NAME codegen_static_from_static_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_from_static.pol"
    "-DCONTAINS=statics fold"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and one that cannot be evaluated in any order is an error, not a zero. Pinned on the CODE and
# not the prose, which is the pattern every new rejection test follows.
add_test(NAME codegen_rejects_static_init_cycle
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/static_init_not_const_bad.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/static_init_not_const_bad.ll")
set_tests_properties(codegen_rejects_static_init_cycle PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0608")

# THE `this.` RECEIVER IS OPTIONAL AND THE CLASS NAME IS NOT. An instance method written bare is not
# missing a subject -- `this` is the subject, and the language supplies it. A static method has none:
# it belongs to the class, so the class is named at the call. The reference always said so ("Belongs
# to the class, not an instance. Called via `ClassName.member`"); only the compiler disagreed.
add_test(NAME codegen_unqualified_self_call_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unqualified_self_call.pol"
    "-DCONTAINS=self=7 20 14"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...and the refusal, which the running program above cannot prove. A rule tested only by what it
# allows is a rule that can quietly stop working.
add_test(NAME sema_rejects_unqualified_static_call
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/unqualified_static_call_bad.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/unqualified_static_call_bad.ll")
set_tests_properties(sema_rejects_unqualified_static_call PROPERTIES
    WILL_FAIL TRUE)

# AND WHEN THE CLASS NAME IS AMBIGUOUS, the namespace is what separates the two -- at a static call,
# which is where it could not be said. `text.Reader` in an expression is a chain of nodes and not one
# name, so the substitution that renames colliding types never matched it; the compiler's own
# diagnostic said the case was "not resolved yet" and offered two ways to avoid needing it. It is
# collapsed in the renaming pass now, so everything downstream sees the ordinary `Class.method`.
add_test(NAME codegen_static_call_by_namespace_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_call_by_namespace.pol"
    "-DEXPECTED=2 101"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# And the same for a FIELD: read, written, static, and inherited, all without a prefix -- with `this.`
# left in the one place it distinguishes anything, a parameter of the same name as the field it sets.
add_test(NAME codegen_implicit_this_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/implicit_this.pol"
    "-DEXPECTED=counter = 6 tally = 5 made = 2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# ...but an instance method still needs an object: calling one unqualified from a static context must fail
# with a diagnostic that names the cause and the fix, not a bare "unknown call".
add_test(NAME sema_rejects_instance_call_from_static
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/instance_from_static_bad.pol")
set_tests_properties(sema_rejects_instance_call_from_static PROPERTIES
    PASS_REGULAR_EXPRESSION "instance method of 'Main'.*object")

# An async method returns the value form of Result/Option (spec 20.2 + 21.2): codegen boxes the
# { tag, payload } struct through the Task's 64-bit result slot and unboxes it on await.
add_test(NAME codegen_async_value_result_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_value_result.pol"
    "-DEXPECTED=42 -5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# TCP server (spec 34): ServerSocket listen/accept + a client over loopback.
add_test(NAME codegen_tcp_server_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tcp_server.pol"
    "-DCONTAINS=reply=pong"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Directory / filesystem metadata (spec 34.4): mkdir/isDir/size/listDir.
add_test(NAME codegen_fs_directory_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fs_directory.pol"
    "-DCONTAINS=n=1 first=a.txt isd=1 sz=2"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Process.run (spec 34): runs a subprocess and returns its captured stdout + exit code.
add_test(NAME codegen_process_run_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_run.pol"
    "-DCONTAINS=hello123"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A compile-time string DSL (spec 32.4): a comptime method folds a comptime string arg at compile time.
add_test(NAME codegen_comptime_string_dsl_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_string_dsl.pol"
    "-DCONTAINS=cols=4"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Decorator over an iterator: an interface-typed field is stored by reference, not deep-copied
# (a value copy sized by the field-less interface truncated the concrete object -> crash).
add_test(NAME codegen_interface_field_delegation_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interface_field_delegation.pol"
    "-DCONTAINS=sum=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A class-wrapped matrix multiply: the loop-interchange optimizer's OOP path must reorder the reduction
# only when the fresh result field provably cannot alias the inputs, keeping the result identical.
add_test(NAME codegen_matmul_class_interchange_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matmul_class_interchange.pol"
    "-DCONTAINS=total=49500"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Bounds-check hoisting (loop versioning): clean for-loops over arrays run an unchecked fast copy under a
# proven guard. The versioned result must equal the checked one (fill by param bound, copy, inclusive sum).
add_test(NAME codegen_bce_hoist_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DOPT=-O2"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bce_hoist.pol"
    "-DCONTAINS=sum=1498500"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A class-returning method whose body ends in while(true): the unreachable fall-through must not emit an
# i32 return on a pointer-returning function.
add_test(NAME codegen_while_true_return_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/while_true_return.pol"
    "-DCONTAINS=v=42"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Box-Muller gaussian sampling tracks the empirical rule (68/95) for a fixed seed; seededNow() runs.
add_test(NAME codegen_random_gaussian_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/random_gaussian.pol"
    "-DCONTAINS=pct1=68 pct2=95"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# BigInteger signed arithmetic: mixed-sign add/subtract, truncated divide/remainder, wide multiply.
add_test(NAME codegen_bigint_arith_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bigint_arith.pol"
    "-DCONTAINS=142857 1 -142857 -1 -70 -150 999998000001"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD vector methods: dot, length (magnitude), normalize, and the 3D cross product.
add_test(NAME codegen_simd_vec_ops_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_vec_ops.pol"
    "-DCONTAINS=dot=3 len=3 nx=10 cx=0 cy=6 cz=-6"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# checked(expr) computes overflow-trapping arithmetic; in range it just yields the value.
add_test(NAME codegen_checked_overflow_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checked_overflow.pol"
    "-DCONTAINS=s=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Explicit overflow-mode integer methods: wrapping (modular) vs saturating (clamp to range).
add_test(NAME codegen_overflow_methods_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/overflow_methods.pol"
    "-DCONTAINS=sat=2147483647 wrapNeg=1"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD lane write: assign a single lane of a vector by name (v.y) or by index (v[i]).
add_test(NAME codegen_simd_lane_write_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_lane_write.pol"
    "-DCONTAINS=x=1 y=20 z=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Decimal primitive: exact fixed-point arithmetic and trimmed toString.
add_test(NAME codegen_decimal_math_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/decimal_math.pol"
    "-DCONTAINS=1.8 0.45 1.2 5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# SIMD mat4: identity, matrix*vector transform, matrix*matrix multiply, element read.
add_test(NAME codegen_simd_mat4_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_mat4.pol"
    "-DCONTAINS=tp=123 q=567 m2=5"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Parameter passing is by value for a plain class type (deep copy, like assignment); `&`/`*` share.
add_test(NAME codegen_value_parameter_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_parameter.pol"
    "-DCONTAINS=value=7 ref=99"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Returning a freshly-built object (operator overloading / factory) with a plain `return new X(...)`:
# the escaping object is promoted to the heap instead of dangling into the freed frame.
add_test(NAME codegen_return_new_object_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/return_new_object.pol"
    "-DCONTAINS=sum=4,6 big=40,60 made=7,8"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A collection of interface-typed elements: ArrayList<Shape> with per-element virtual dispatch. Needs
# Object's methods (equalsKey) to resolve on an interface receiver and interfaces to count as Objects.
add_test(NAME codegen_polymorphic_collection_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/polymorphic_collection.pol"
    "-DCONTAINS=total=35"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# Lazy iterator pipeline from the stdlib (#25): filter + map + fold over a Stream, evaluated on demand.
add_test(NAME codegen_lazy_streams_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_streams.pol"
    "-DCONTAINS=total=220"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# The argument to a comptime parameter must be a compile-time constant (spec 32.4).
add_test(NAME sema_rejects_comptime_arg
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_arg_bad.pol")
set_tests_properties(sema_rejects_comptime_arg PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# a switch without a default case is a compile error (spec 7.3: default is mandatory).
add_test(NAME sema_rejects_switch_no_default
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_no_default_bad.pol")
set_tests_properties(sema_rejects_switch_no_default PROPERTIES
    PASS_REGULAR_EXPRESSION "must have a 'default' case")

# `try?` in a method that does not return Result/Option is a clean compile error (spec 21.2), not a
# codegen type-mismatch crash.
add_test(NAME sema_rejects_try_nonresult
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_nonresult_bad.pol")
set_tests_properties(sema_rejects_try_nonresult PROPERTIES
    PASS_REGULAR_EXPRESSION "can only be used inside a method that returns Result or Option")

# `try?` forwards the failure value UNCHANGED (codegen: CreateRet on the very value it tested), so the
# operand's error type must be the one this method returns. The check used to compare base names only --
# "Result" against "Result" -- which is the one comparison that can never fail here, so a
# Result<int,IoError> propagated out of a Result<int,int> reached the binary and was reinterpreted.
# Nothing downstream could catch it: every value-form Result is one LLVM StructType and every boxed one an
# opaque ptr. Pins the CODE so the wording stays free to improve.
add_test(NAME sema_rejects_try_error_type
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_error_type_bad.pol")
set_tests_properties(sema_rejects_try_error_type PROPERTIES
    PASS_REGULAR_EXPRESSION "Polaron-0504")

# The same rule's other half: a None carries no error value, so it cannot be propagated out as an Err.
add_test(NAME sema_rejects_try_family_cross
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/try_family_bad.pol")
set_tests_properties(sema_rejects_try_family_cross PROPERTIES
    PASS_REGULAR_EXPRESSION "same family")

# a non-terminating comptime evaluation hits the step/recursion budget and is
# rejected gracefully (spec 28.3), not a hang or crash.
add_test(NAME sema_rejects_comptime_runaway
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_runaway_bad.pol")
set_tests_properties(sema_rejects_comptime_runaway PROPERTIES
    PASS_REGULAR_EXPRESSION "must be a compile-time constant")

# a `demand` that does not hold (spec 28.2) -- condition uses a comptime call -- reports its reason.
add_test(NAME sema_rejects_demand_fail
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_fail_bad.pol")
set_tests_properties(sema_rejects_demand_fail PROPERTIES
    PASS_REGULAR_EXPRESSION "demand not met: fib.10. is not 99")

# A byte budget that is EXCEEDED must fail the build. Checked with a full compile and not
# `--check`, because a size is only knowable against the target's layout, which exists in the code
# generator: the analyzer defers exactly the sizeof-bearing assertions to it. The trade is
# deliberate -- one authority on layout instead of two models that can disagree -- and the cost is
# that a blown budget shows up at build time rather than in the editor's live check.
add_test(NAME codegen_rejects_exceeded_size_budget
    COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_budget_bad.pol"
            -o "${CMAKE_CURRENT_BINARY_DIR}/sizeof_budget_bad.ll")
set_tests_properties(codegen_rejects_exceeded_size_budget PROPERTIES
    PASS_REGULAR_EXPRESSION "demand not met: Wide must fit eight bytes")

# A parse error inside a string interpolation is reported WHERE IT IS. The embedded expression is
# lexed and parsed on its own, so its diagnostics used to count from that substring's line 1 and
# landed on the import at the top of the file -- the first error a reader sees, pointing at
# innocent code. The fault here is on line 14.
add_test(NAME sema_reports_interpolation_error_in_place
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_error_location.pol")
set_tests_properties(sema_reports_interpolation_error_in_place PROPERTIES
    PASS_REGULAR_EXPRESSION "interp_error_location.pol:14:")

# a non-eternal persistent with no release anywhere is a compile error (spec 18.15).
add_test(NAME sema_rejects_unreleased_persistent
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_unreleased_bad.pol")
set_tests_properties(sema_rejects_unreleased_persistent PROPERTIES
    PASS_REGULAR_EXPRESSION "no 'release persistent'")

# an invariant generic gives no subtyping between instantiations (spec 15.3).
add_test(NAME sema_rejects_invariant_assign
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_invariant_bad.pol")
set_tests_properties(sema_rejects_invariant_assign PROPERTIES
    PASS_REGULAR_EXPRESSION "Box.Animal")

# `unique partitionable` is contradictory and must be rejected (spec 19.9).
add_test(NAME sema_rejects_unique_partitionable
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable_unique_bad.pol")
set_tests_properties(sema_rejects_unique_partitionable PROPERTIES
    PASS_REGULAR_EXPRESSION "contradictory")

# extending a sealed type's permitted variant must be rejected (variants are final),
# else match's exhaustiveness assumption is unsound.
add_test(NAME sema_rejects_extend_permit
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/extend_permit_bad.pol")
set_tests_properties(sema_rejects_extend_permit PROPERTIES
    PASS_REGULAR_EXPRESSION "a sealed variant")

# a generic constraint carries its own type arguments (spec 15.2): implementing Comparable<Dog> does
# not satisfy `<T implements Comparable<T>>` when T is Cat.
add_test(NAME sema_rejects_generic_bound_args
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_bound_args_bad.pol")
set_tests_properties(sema_rejects_generic_bound_args PROPERTIES
    PASS_REGULAR_EXPRESSION "does not satisfy constraint 'T extends Comparable<Cat>'")

# a `final class` cannot be extended; a `final method` cannot be overridden (spec 15).
add_test(NAME sema_rejects_final_class
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/final_class_bad.pol")
set_tests_properties(sema_rejects_final_class PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot extend final class")
add_test(NAME sema_rejects_final_method
    COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/final_method_bad.pol")
set_tests_properties(sema_rejects_final_method PROPERTIES
    PASS_REGULAR_EXPRESSION "cannot override final method")

# ---- Codegen tests (only when the LLVM backend is built) ----
if(POLARON_WITH_LLVM)
    # The emitted IR contains an i32 main and a printf call.
    add_test(NAME codegen_emits_ir
        COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol")
    set_tests_properties(codegen_emits_ir PROPERTIES
        PASS_REGULAR_EXPRESSION "define i32 @main")

    # volatile (spec 37.5) must lower to volatile loads/stores in the IR, not be
    # optimized away. (The run test only proves the result is unchanged.)
    add_test(NAME codegen_volatile_emits_volatile
        COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_access.pol")
    set_tests_properties(codegen_volatile_emits_volatile PROPERTIES
        PASS_REGULAR_EXPRESSION "store volatile")

    # region RAII (spec 17.7): a region with no explicit release is still freed at
    # the end of its block -- the IR must contain the scope-end free.
    add_test(NAME codegen_region_raii_frees
        COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_raii.pol")
    set_tests_properties(codegen_region_raii_frees PROPERTIES
        PASS_REGULAR_EXPRESSION "call void @__polaron_region_release")

    # F9: `--lib` compiles a bundle to a .polb (+ .polh). The round-trip (--lib then --dump-polb) must
    # show the bundle name and the public method signature in the generated .polh.
    add_test(NAME bundle_lib_roundtrip COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_lib.pol"
        "-DCONTAINS=public method gain(int delta) returns int"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_test.cmake")

    # THE BUNDLE CARRIES THE MODULE, AND THE MODULE CAN BE READ BACK.
    #
    # `polh` lets a consumer skip parsing and analysis, `code` lets it skip emission; neither skips
    # the part between them, which is where the work now is. The `pir` section is what a consumer
    # needs in order to INLINE ACROSS THE BOUNDARY and still reason about what it inlined --
    # devirtualisation needs the classes, the slot map and the replaceable set, and none of those
    # survive the drop to bitcode.
    #
    # THE CHECK IS THAT IT PARSES, NOT THAT IT IS PRESENT. A byte count says the section exists,
    # which is not the question anybody asks of it; `--dump-polb` reads it back and reports how many
    # functions came out. When this section was first written the answer was `WILL NOT PARSE` at line
    # 60 of 175 440 -- `parse(print(m))` is PIR's own acceptance criterion and it had never been run
    # on a real module, so it held for modules with no generics in them and for nothing else.
    add_test(NAME bundle_carries_a_readable_module COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_lib.pol"
        "-DCONTAINS=functions"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_test.cmake")

    # ...AND THE MODULE SURVIVES ITS OWN TEXT FORM UNCHANGED. See the script for the eight defects
    # this found on the day it was written, every one of them in machinery that had shipped for
    # months, and all of them invisible because nothing had ever read a real module back.
    add_test(NAME pir_round_trip_is_identical COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_lib.pol"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_roundtrip_test.cmake")

    # A GENERATED HEADER MUST PARSE WITH THE PARSER THAT GENERATED IT. The emitter wrote
    # `static extern` where spec 37.9 demands `extern static`, so any bundle with an external static
    # method produced a .polh this compiler could not read back -- surfacing far from the cause, as
    # "failed to parse the header of bundle X". The .polh is checked for the canonical order.
    add_test(NAME bundle_polh_modifier_order COMMAND "${CMAKE_COMMAND}"
        "-DPOLC=$<TARGET_FILE:polc>"
        "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/polh_modifier_order.pol"
        "-DCONTAINS=public extern cdecl static method time(long ptr) returns long"
        "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_test.cmake")

    # F9 phase 2: two bundles whose vtable layouts collide cannot be linked together; depending on
    # both is rejected rather than silently dispatching through the wrong slot. (No clang needed.)

    # Full pipeline: compile to .exe with clang and check it prints correctly.
    # (POLARON_CLANG is resolved once at the top level; see the root CMakeLists.txt.)
    if(POLARON_CLANG)
        # F9 phase 2: a consumer imports a separately-compiled bundle via --use, links its .polb CODE,
        # and calls a static method across the bundle boundary -> Calc.square(7) = 49.
        add_test(NAME bundle_static_call_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_app.pol"
            "-DEXPECTED=square = 49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # AN IMPORTED `abstract` CLASS, EXTENDED. Two ledger entries meet in this one shape: `polc`
        # segfaulted on an imported abstract class (exit 139, both back ends, no diagnostic), and a
        # cross-bundle constructor symbol was built from the qualified key on one side and the bare
        # name on the other, so `super(4)` failed to link. An abstract base is the only shape with
        # both, because it is never instantiated itself: what crosses is a vtable slot and a
        # constructor only a subclass reaches.
        #
        # 416 separates the three things that must be right -- `describe` is compiled INSIDE the
        # library and calls `area()` through the slot the library assigned, `sides` is the 4 that
        # `super` carried across, and the constructor linked at all.
        add_test(NAME bundle_abstract_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_abstract_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_abstract_app.pol"
            "-DEXPECTED=describe=416 through base=16"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # F9 phase 2 (instances): the consumer creates, uses, and destroys an imported class through
        # the bundle's exported __new/__delete (opaque layout) -> Counter(10)+1+1 = 12.
        add_test(NAME bundle_instance_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_app.pol"
            "-DEXPECTED=value = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # ABI: a public field declared AFTER private ones must sit at the same offset on both sides of
        # the bundle boundary. Private fields do not cross the .polh by name, so the header has to
        # reserve their BYTES -- including a weak slot's SIXTEEN and `boolean`'s FOUR. Without that the
        # consumer's write lands in a private field while both sides stay self-consistent, which is
        # exactly why no earlier test caught it: none of them read a field across the boundary.
        add_test(NAME bundle_field_offset_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_field_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_field_app.pol"
            "-DEXPECTED=visible = 7, get = 7, hidden = 11, packed = 18"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # ABI: implementing a `layout` reorders a struct's fields widest-alignment-first, so the header
        # has to carry the layout AND the `implements` that names it. Without them the consumer lays the
        # struct out as declared and disagrees with the bundle about every offset after the first --
        # silently, since each side stays consistent with itself.
        add_test(NAME bundle_layout_order_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_layout_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_layout_app.pol"
            "-DEXPECTED=flag = 1, when = 1000, kind = 2, value = 77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # F9 phase 2 (virtual dispatch): a Shape pointer to an imported Square dispatches area()
        # through the bundle's vtable; the consumer seeds the .polb's slot layout -> Square.area = 25.
        add_test(NAME bundle_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.pol"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # A CONSUMER DECLARING A NAME THE LIBRARY ALSO USES. Nothing this program declares may change
        # how a library symbol is named: the rename used to rewrite the IMPORTED `Square` to
        # `geo__Square`, and the link failed on `geo__Square.__new` against an exported `Square.__new`.
        # The library here is the same one bundle_virtual_runs uses -- what differs is the consumer.
        add_test(NAME bundle_shadowed_name_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shadow_app.pol"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # ABI: a LOCAL class extending an IMPORTED base -- listed as unaudited in docs/design/abi.md,
        # and it was broken. A bundle is compiled into an OPEN world, but devirtualization asked the
        # whole-program question "does anything extend this?", got "no" inside the library, and
        # compiled the library's own `this.weight()` as a direct call. The consumer's override was
        # walked straight past: `total` gave 17 instead of 57 while the consumer's own `w.weight()`
        # gave the right 5 -- two dispatches on one object disagreeing, and it links silently.
        # The three numbers separate the local override, the inherited method, and the call the
        # LIBRARY makes on itself.
        add_test(NAME bundle_inherit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_inherit_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_inherit_app.pol"
            "-DEXPECTED=weight = 5, label = 100, total = 57"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # A LIBRARY SHIPS A TRANSFORMER, and a consumer in another bundle applies it.
        #
        # `applies` used to be a whole-program feature and nothing said so: `polh.cpp` wrote classes
        # and enums, the word `transformer` appeared nowhere in src/bundle at all, so the standard
        # library could not publish a `TComparer` and neither could anybody else.
        #
        # What has to cross is the BODY, not a signature -- a transformer is expanded, never called,
        # so a header carrying only its shape would ship half the feature: the sockets would still be
        # demanded and every free implementation would silently vanish. It travels as its own source,
        # which for a declaration with no runtime existence is the complete form of it.
        #
        # `70` is the transformer's own body running inside the consumer's Dog, reached through the
        # interface the transformer promised on Dog's behalf -- so `satisfies` crosses too.
        add_test(NAME bundle_transformer_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bundle_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bundle_app.pol"
            "-DEXPECTED=70"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # F9 phase 2 (plugin callback): the consumer implements an imported interface and hands its
        # object to the bundle, which dispatches describe() back across the boundary -> 42.
        add_test(NAME bundle_plugin_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_app.pol"
            "-DEXPECTED=rendered = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # ABI, external world: TWO bundles built without ever seeing each other, in one program. Slots
        # are numbered globally by method name, so each library numbered its own world from 0 and they
        # disagree -- this was refused outright ("vtable layout incompatible ... cannot be linked
        # together"), which for a language that ships binary libraries is the feature not existing.
        # The consumer's compile is the only one that sees both, so it publishes the merged numbering
        # and each dependency's baked tables are permuted into it on extraction. A wrong permutation
        # still LINKS, so this asserts the output: Square.area = 4, Dog.speak = 7.
        add_test(NAME two_bundle_link_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIBA=${CMAKE_CURRENT_SOURCE_DIR}/samples/twobundle_shapes.pol"
            "-DLIBB=${CMAKE_CURRENT_SOURCE_DIR}/samples/twobundle_animals.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/twobundle_app.pol"
            "-DEXPECTED=4 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_two_bundle_link_test.cmake")

        # The same reconciliation on the two bundles that USED to be the standing proof it was
        # impossible: this pair was `bundle_vtable_conflict_rejected`, a test whose whole assertion was
        # that polc refuses them. It is kept, inverted, because a limitation removed is worth a test
        # that it stays removed -- and because these are real library shapes rather than the four-line
        # pair above. The consumer names only ShapeLib's types; PluginLib rides along as a second
        # dependency whose numbering disagrees.
        add_test(NAME bundle_vtable_conflict_reconciled COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIBA=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.pol"
            "-DLIBB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_plugin_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.pol"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_two_bundle_link_test.cmake")

        # F9 phase 3 (dynamic load): the consumer loads the bundle at runtime (--use-dynamic). The
        # loader AOT-compiles the .polb's bitcode to a DLL with clang and resolves the call -> 49.
        add_test(NAME bundle_dynamic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_app.pol"
            "-DEXPECTED=square = 49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_dynamic_test.cmake")

        # ... and the loader's cached image may never be the reason a working program stops working.
        # The harness runs this one twice, ruining the cached image in between; the second run has to
        # rebuild it and print the same line. Its own bundle name, because the image is keyed by it and
        # a shared one would mean two tests poisoning each other under `ctest -j`.
        add_test(NAME bundle_dynamic_survives_a_ruined_cache COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_cache_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_cache_app.pol"
            "-DEXPECTED=twice = 42"
            "-DPOISON_CACHE=CacheLib"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_dynamic_test.cmake")

        # F9 phase 3 (dynamic instance): a class instance from a runtime-loaded bundle, created and
        # used through __new/__delete and method thunks -> Counter(10)+1+1 = 12.
        add_test(NAME bundle_dynamic_instance_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_app.pol"
            "-DEXPECTED=value = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_dynamic_test.cmake")

        # F9 phase 3 (dynamic virtual): a virtual call on an instance from a runtime-loaded bundle,
        # dispatched through the bundle's vtable -> Square.area = 25.
        add_test(NAME bundle_dynamic_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_shape_app.pol"
            "-DEXPECTED=area = 25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_dynamic_test.cmake")

        # F9 phase 3 (partial compilation, spec 2.4): the bundle is absent at runtime; the program
        # wraps the use in try/catch and catches BundleNotLoadedException instead of crashing.
        add_test(NAME bundle_absent_caught COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_optional_app.pol"
            "-DCONTAINS=calc not available"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_absent_test.cmake")

        # F9 phase 3 (ABI check, spec 2.5): a different bundle is present at runtime; its fingerprint
        # does not match what the program compiled against, caught as BundleAbiMismatchException.
        add_test(NAME bundle_abi_mismatch_caught COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_calc_lib.pol"
            "-DLIB2=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_counter_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_abi_app.pol"
            "-DCONTAINS=calc ABI mismatch"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_abi_test.cmake")

        add_test(NAME codegen_hello_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/own_namespace_wins.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/clone_keeps_field_kind.pol"
            "-DEXPECTED=weak=0 delegated=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `layout`: an interface for memory. The printed number is the proof that implementing one
        # ORDERED THE FIELDS -- the struct is written worst-first (a byte between two ints, twice),
        # which measures 16 as declared and 12 ordered widest-first. 16 would not have compiled at
        # all, so 12 is unreachable unless the reordering happened.
        add_test(NAME codegen_layout_packed_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_packed.pol"
            "-DEXPECTED=tick = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AN ARRAY OF A VALUE AGGREGATE HOLDS ITS ELEMENTS INLINE, not pointers to them. This was
        # found by dogfood: `cells[0].a` on a freshly allocated array was an access violation,
        # because the slot held the null the zero-init wrote and the field read dereferenced it.
        # Seven checks in one run -- zero-init, write, read, distinct slots, a method on an element,
        # read-modify-write, whole-element copy and its independence -- so the count IS the diagnosis.
        add_test(NAME codegen_struct_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_array.pol"
            "-DEXPECTED=inline = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And the type that cannot be made to fit. Not a --check test: a budget is measured against
        # the target's real layout, which only exists in the code generator, so the refusal has to
        # come from a real compile.
        add_test(NAME codegen_rejects_layout_over_budget
            COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_over_budget.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/layout_over_budget.ll")
        set_tests_properties(codegen_rejects_layout_over_budget PROPERTIES
            PASS_REGULAR_EXPRESSION "measures 16.*a tick must stay five to a cache line")

        # A CONCESSION IS A WORD THE AUTHOR WRITES, and this is the test that it is not granted by
        # asking for a size. It is the regression test for a live defect in the first design: naming
        # any layout authorised the compiler to permute the fields, so `layout WireRecord`, whose own
        # message says BOTH ENDS INDEX IT, was reordered by the act of stating its size.
        #
        # A size check could never have caught it -- two declarations differing only in field order
        # come out the same size once both are sorted, which is precisely the number a test would
        # have compared. So this reads the first byte of a value through its own ADDRESS, and
        # declares the same four fields in two orders so that "the compiler made both ends agree"
        # becomes visible as two numbers that must differ.
        #
        # `wire 12 8` is the two declarations staying different; `first 1 100` is each starting with
        # its own first field. Before the fix both lines read `8 8` and `100 100`. The `compact` pair
        # is the same shapes under a layout that DOES concede, so the test proves the two answers
        # differ rather than merely proving one of them.
        add_test(NAME codegen_layout_concession_is_explicit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_concession_is_explicit.pol"
            "-DEXPECTED=wire 12 8 first 1 100 compact 8 8 sorted 100 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE TARGET RESOLVES, THE LAYOUT JUDGES -- the half of the second design that was missing.
        #
        # `layout`'s own header calls it *an interface for memory*, and an interface declares an
        # obligation the implementer provides. Until this, a layout had only constraints: it could
        # say a type must measure 20 bytes and there was no way for the type to say *and here is
        # how*. `resolvedBy` names the member, a bodyless one on the layout is an obligation and a
        # bodied one a default, and the target's own always wins.
        #
        # THE NUMBERS ARE ADDRESSES, NOT SIZES, and that is the point of the test. A size is
        # satisfied by any arrangement that adds up; what `isolate` promises is that two fields do
        # not share a cache line, and only the DISTANCE between them answers that. `apart 64` is the
        # promise kept -- 4 would be the two counters adjacent, which measures the same 8 bytes and
        # is exactly the false sharing the declaration exists to prevent.
        #
        # `counters 128` is the other half and it is not decoration: stopping at 68 would put the
        # second element of an array of them 68 bytes in, so its first counter shares a line with
        # the previous element's second one -- the guarantee holding inside one object and failing
        # one subscript away. `packet 12` / `order 0 8` are `pad`, the verb with no other spelling:
        # a reserved word the device does not read, which is part of the format rather than a value
        # anybody should be able to name.
        add_test(NAME codegen_layout_resolver_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_resolver.pol"
            "-DEXPECTED=counters 128 apart 64 packet 12 order 0 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THE LAYOUT SURVIVES BEING CLONED, which is the tenth time that sentence is a test.
        #
        # `cloneClass` copies a declaration field by field, so a field added to `ClassDecl` later is
        # dropped by it silently -- the invariants, the four lifecycle hooks, `comptime`, `asm`, the
        # `volatile` on locals, and now `onArrange`. What makes this instance worse than the others
        # is what the silence costs: dropping a lifecycle hook loses a line of OUTPUT, dropping
        # `onArrange` loses a GUARANTEE. A layout with no hook asks for nothing, so `fitWithin` stops
        # being checked and a type twice its budget compiles clean.
        #
        # The `typealias` in the sample is the whole test. `resolveTypeAliases` sends EVERY class in
        # the program through the cloner the moment one is declared anywhere, so the guarantee held
        # until somebody three files away wrote an alias and then stopped, silently at both moments.
        # Found from the other end: a probe type named `Queue`, which the standard library also
        # declares, reported `use of undeclared variable 'itself'` inside a resolver that was fine.
        add_test(NAME codegen_layout_survives_the_cloner COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_survives_the_cloner.pol"
            "-DEXPECTED=tick 12 over caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THE REFUSAL NAMES THE WORD THAT WOULD SOLVE IT, with the number. Without this the
        # second design is strictly worse than the first for every author who wanted the reordering
        # and did not know a word had appeared: the build stops and the message is a size. The
        # compiler can answer the question it raises -- it has the fields and it has the target's
        # data layout -- so it measures the other arrangement and quotes what that one costs.
        add_test(NAME codegen_layout_refusal_names_the_concession
            COMMAND polc "${CMAKE_CURRENT_SOURCE_DIR}/samples/layout_names_the_concession.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/layout_names_the_concession.ll")
        set_tests_properties(codegen_layout_refusal_names_the_concession PROPERTIES
            PASS_REGULAR_EXPRESSION
                "measures 12.*does not permit reordering.*permits reorder. it measures 8, which fits")

        # `itself` as the universal pronoun the keyword reference always described: "the entity being
        # declared". Bare it is that entity, followed by a '.' it is that entity's TYPE. The compiler
        # honoured it in two places only -- the region initializer and lambda self-recursion -- and
        # those are instances of the rule rather than exceptions to it. The lambda form is exercised
        # here beside the general ones so that generalizing the pronoun cannot quietly break it.
        add_test(NAME codegen_itself_pronoun_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/itself_pronoun.pol"
            "-DEXPECTED=a = 10 total = 10 fact = 120"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: variables and arithmetic with precedence; a + b * 2 = 50.
        add_test(NAME codegen_expr_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/expr.pol"
            "-DEXPECTED=c = 50"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: reassignment + mutable + ++; 1 -> +5 -> ++ = 7.
        add_test(NAME codegen_mutable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutable.pol"
            "-DEXPECTED=x = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M2: comparison + logical operators + boolean.
        add_test(NAME codegen_logic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/logic.pol"
            "-DEXPECTED=less=1 both=1 sum_gt=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M3: if/else with branches; 7 is odd and > 5 -> 102.
        add_test(NAME codegen_if_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/control_if.pol"
            "-DEXPECTED=result=102"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M3: for + while loops; sum 1..10 = 55, halving 100 to 1 takes 6 steps.
        add_test(NAME codegen_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loop.pol"
            "-DEXPECTED=sum=55 steps=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: class with constructor + instance methods + fields; two increments -> 2.
        add_test(NAME codegen_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_counter.pol"
            "-DEXPECTED=count = 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: a destructor runs at end of scope (RAII): ctor, hello, dtor.
        add_test(NAME codegen_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_dtor.pol"
            "-DEXPECTED=ctor hello dtor"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `weak T*` auto-nulls when its target is deleted: before=live id, after=-1 (nulled on its own).
        add_test(NAME codegen_weak_ref_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_ref.pol"
            "-DEXPECTED=before=42 after=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: new ... on heap + delete (ctor with a param, destructor on delete).
        add_test(NAME codegen_heap_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_heap.pol"
            "-DEXPECTED=value = 42 freeing 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: static methods, called as ClassName.method(args).
        add_test(NAME codegen_static_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_static.pol"
            "-DEXPECTED=square=25 total=125"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # static fields: class-wide state accessed as ClassName.field (read/write).
        add_test(NAME codegen_static_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_field.pol"
            "-DEXPECTED=count = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # null pointer literal: assign to a pointer, compare with == / != .
        add_test(NAME codegen_null_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_literal.pol"
            "-DEXPECTED=null=1 set=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ---- COMMAND VALUES (reference 14.1), which is what the lambda tests became ----
        #
        # `lambda.pol`, `lambda_bool.pol`, `lambda_char.pol` and `lambda_void.pol` were one test
        # written four times, differing only in the return type of the value they built. They are one
        # file now: a command value of each kind of answer -- int, boolean, char, and none at all --
        # including a `char` decided by an `if`, which is the case that proves the body is a body and
        # not one expression wearing braces.
        add_test(NAME codegen_command_values_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_values.pol"
            "-DEXPECTED=add=8 square=36 p=1 q=0 g=A h=B hi=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A command passed as an argument -- the shape every callback in the language now has, and
        # the reason a command TYPE exists: `apply` is compiled without knowing `square` was written.
        add_test(NAME codegen_command_callback_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_callback.pol"
            "-DEXPECTED=r=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A command that answers with a command. This was `function<function<int,int>>`, and the test
        # largely existed to prove the parser could split the `>>`; a command type is a NAME, so
        # there is nothing to nest and the factory reads like any method returning an object.
        add_test(NAME codegen_command_returns_command_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_returns_command.pol"
            "-DEXPECTED=d=42 t=63"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A command in a class field -- the strategy pattern, called as `this.op(x)`.
        add_test(NAME codegen_command_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_field.pol"
            "-DEXPECTED=v=105 w=25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WHAT A COMMAND HOLDS, AND WHEN IT TOOK IT. The closure test, and the answer has changed:
        # baggage is always copied at construction, so the value the command answers with does not
        # move when the local it came from does. `lambda_byref.pol` has no successor and is gone with
        # the feature -- a command that shared a caller's local could not outlive the frame it was
        # written in, which is the one thing a command is for.
        add_test(NAME codegen_command_carries_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_carries.pol"
            "-DEXPECTED=c=15 after=15 far=115"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the three together in one program, because that is how they appear in real code and
        # a test per shape never exercises the seams between them.
        add_test(NAME codegen_command_showcase_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_showcase.pol"
            "-DEXPECTED=r=25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cast<T> between signed and unsigned integers (source signedness drives sext vs zext).
        add_test(NAME codegen_cast_signedness_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cast_signedness.pol"
            "-DEXPECTED=u = 4294967295 si = -1294967296 wid = 4294967295 ext = 255 wide = 4294967295"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # chained member access through value-typed class fields (o.inner.deeper.y), read + write.
        add_test(NAME codegen_chained_access_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/chained_access.pol"
            "-DEXPECTED=x = 7 y = 100 x = 42 y = 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # deep copy of a class-valued field from a variable (heap copy, independent of the source).
        add_test(NAME codegen_class_field_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_field_copy.pol"
            "-DEXPECTED=h = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # nested generic types: Box<List<int>> (recursive type-arg parsing + '>>' split).
        add_test(NAME codegen_nested_generics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nested_generics.pol"
            "-DEXPECTED=first = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: an OS thread via the prelude's System.Concurrency.Thread (CreateThread + join).
        add_test(NAME codegen_thread_spawn_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_spawn.pol"
            "-DEXPECTED=worker n=42 main done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Mutex<T> + synchronized -- two threads increment a shared counter under a lock; the
        # total is deterministic (200000) only because the lock makes each increment atomic.
        add_test(NAME codegen_mutex_synchronized_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutex_synchronized.pol"
            "-DEXPECTED=total=200000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: atomic<T> -- two threads each increment a shared lock-free counter; total=200000.
        add_test(NAME codegen_atomic_counter_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_counter.pol"
            "-DEXPECTED=total=200000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: System.Os.Machine.threads() -- how many threads the machine runs at once, so a worker
        # pool does not hold a number somebody guessed.
        add_test(NAME codegen_machine_threads_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/machine_threads.pol"
            "-DEXPECTED=threads: plausible"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: `implements Shared` -- a program's own type crossing a thread boundary. Two threads
        # count into one object whose fields are atomics; the total is exact.
        add_test(NAME codegen_thread_shared_type_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_shared_type.pol"
            "-DEXPECTED=total=100000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Channel<T> -- a producer thread sends into a bounded channel; main receives + sums.
        add_test(NAME codegen_channel_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel.pol"
            "-DEXPECTED=sum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: Channel.select -- poll several channels via the fluent builder; the ready one wins.
        add_test(NAME codegen_channel_select_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel_select.pol"
            "-DEXPECTED=b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: atomic<T> operators -- ++ / -- / += / -= and atomic store.
        add_test(NAME codegen_atomic_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/atomic_ops.pol"
            "-DEXPECTED=v=7 set=100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `&Class.staticField` -- the address of a static field, which the analyzer refused to type
        # because its bit-field guard asked for the type of the RECEIVER, and a class name is not a
        # variable. Nothing could take the address of a static; a futex word is exactly one.
        add_test(NAME codegen_static_field_address_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_field_address.pol"
            "-DEXPECTED=value=42 wide=908"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A METHOD THAT RETURNS A CATALOG, which the guide lists as a first-class thing to do and the
        # compiler could not emit at all: a catalog value is a tagged ordinal (i64) and `return
        # Grade.ok` handed back the enum's own value -- an i32 ordinal, or a java-style enum's
        # SINGLETON POINTER. The module verifier rejected it every time, so any method whose result was
        # "one of a closed set of outcomes, each carrying its own data" failed to build. Both
        # implementer flavours and a catalog-typed local are in the sample, because the packing differs.
        add_test(NAME codegen_catalog_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_return.pol"
            "-DEXPECTED=100 50 7 0 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await (slice A) -- two async tasks run on the worker pool; main awaits both.
        add_test(NAME codegen_async_basic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_basic.pol"
            "-DEXPECTED=a=5050 b=20100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await state machine (slice B) -- awaiting inside an async method suspends it;
        # the body is split into states across the awaits (sum=60).
        add_test(NAME codegen_async_chain_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_chain.pol"
            "-DEXPECTED=sum=60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await with control flow (slice C) -- await inside a loop (coroutine lowering).
        add_test(NAME codegen_async_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_loop.pol"
            "-DEXPECTED=loopsum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8: async/await temp spilling (spec 20.2) -- a value computed before an `await` (a
        # sibling operand, or the call receiver) survives the suspend via the state object.
        add_test(NAME codegen_async_spill_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_spill.pol"
            "-DEXPECTED=result=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (B9): a value struct owning a heap field, live across an await, is heap-promoted into
        # the coroutine state and freed (block + owned fields) at completion -- 200x guards leak/double-free.
        add_test(NAME codegen_async_value_struct_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_value_struct.pol"
            "-DEXPECTED=total=39800"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (B8): a defer runs when an async body throws an uncaught exception (unwind to the guard),
        # not just on a normal return -- the awaiter re-throws and catches. Prints "defer ran" then "caught".
        add_test(NAME codegen_async_defer_throw_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_defer_throw.pol"
            "-DCONTAINS=defer ran"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F8 + F6: async/await combined with try/catch/finally (spec 20.2 + 21.1) -- awaits inside
        # the try and catch, a thrown error caught, and a value live across the try's invoke edges.
        add_test(NAME codegen_async_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/async_try.pol"
            "-DEXPECTED=ok=130 bad=115"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 30.18: reimport validation via challenge-response -- unimport produces a value, the
        # matching reimport reproduces it (success) or not (onFailure runs).
        add_test(NAME codegen_reimport_expecting_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reimport_expecting.pol"
            # `named=4` because the sample declares a LOCAL called `expecting` and prints it:
            # the word is a soft keyword and an ordinary name everywhere else. The sample carried
            # that line on both machines and only one of the two expectations was updated with it.
            "-DEXPECTED=named=4 proof=1007 validated rejected done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime local (spec 28.3): a value computed at compile time, usable as e.g. an array size.
        add_test(NAME codegen_comptime_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_local.pol"
            "-DEXPECTED=x=14 len=14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unary operator overload (spec 6.5): a no-arg operator <op> is invoked by the prefix form.
        add_test(NAME codegen_unary_operator_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unary_operator.pol"
            "-DEXPECTED=bx=-3 by=-4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # int-style enum casts to its ordinal int (spec 12.1).
        add_test(NAME codegen_enum_to_int_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_to_int.pol"
            "-DEXPECTED=i=2 ord=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # inline assembly (spec issue 1): asm("arch") { raw } emits a side-effecting inline asm block.
        add_test(NAME codegen_inline_asm_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_asm.pol"
            "-DEXPECTED=x=42 ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # FFI callback (spec 26): a capture-free lambda passed to a C function as a raw fn pointer.
        add_test(NAME codegen_ffi_callback_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_callback.pol"
            "-DEXPECTED=r=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `interrupt` OUTSIDE freestanding, and the only test in this file that proves the entry
        # point is real by handing it to something that has never heard of Polaron: it installs the
        # handler with the C runtime's own `signal()` and raises the signal for real. A hosted
        # interrupt lowers to `void(int)` -- what `signal()` takes on POSIX and through the Windows
        # CRT -- so one shape installs on both instead of an answer per operating system.
        #
        # `caught=2` means the CRT entered a method whose receiver was bound by `box.interrupt`, and
        # the field it wrote was read back afterwards. Nothing short of running it shows that: the
        # IR tests beside it would pass just as happily on an entry nobody can call.
        add_test(NAME codegen_interrupt_hosted_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_hosted.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_applies.pol"
            "-DEXPECTED=<dog> [cat]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `call T.p()` reaching the transformer's own body from inside the type's override. `[<cat>]`
        # is both at once: the brackets are Cat's replacement, the angle brackets are the original it
        # asked for anyway. Without `call` the original is UNREACHABLE -- `this.describe()` from
        # inside `describe()` is the override calling itself -- which is the whole reason the word
        # exists, alongside there being no receiver to write to the left of the dot.
        add_test(NAME codegen_transformer_call_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_call.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_generic.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_each.pol"
            "-DEXPECTED=212 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `error ParseFailed;` -- a transformer's own failure type, so a failure names the conversion
        # that failed instead of surfacing as somebody else's exception. Synthesized ONCE, at the
        # transformer, as an ordinary class in its namespace: two types that fail the same conversion
        # must raise the same thing or a caller cannot write one `catch`.
        add_test(NAME codegen_transformer_error_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_error.pol"
            "-DEXPECTED=empty port port=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `collective` -- THE 1 -> N RELATION. `mutual` says a PAIR is symmetric; this says the types
        # that apply the transformer form ONE set, so each of them can become any of the others.
        #
        # What makes it affordable rather than N-squared is COMPOSITION: three procedures in a cycle
        # (C -> F, F -> K, K -> C) produce all SIX conversions, and the three nobody wrote are chained
        # along the unique shortest path. `212 373 212` is one written conversion followed by two
        # composed ones, in both directions round the cycle.
        #
        # The pattern this removes is the canonical pivot type that everything converts through --
        # because a pivot IS a path through this graph, so it stops being something to write.
        add_test(NAME codegen_transformer_collective_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_collective.pol"
            "-DEXPECTED=212 373 212"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `satisfies` -- the transformer promises the interface ON BEHALF OF whoever applies it, and
        # its procedures are the implementation. Neither class line names `IShown`, and both bind to
        # it: `70` is the transformer's own body running inside Dog, `100` is Cat replacing it. Before
        # this clause the pair had to be written on every applying type with nothing connecting them.
        add_test(NAME codegen_transformer_satisfies_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_satisfies.pol"
            "-DEXPECTED=70 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE FILESYSTEM THE LIBRARY DID NOT REACH. The runtime has had exists/size/remove/isDir/mkdir/
        # rename since file I/O landed and the compiler exposed all ten File builtins -- `Files` wrapped
        # four, so a stdlib with HyperLogLog and Manacher in it could not tell you whether a file
        # existed. Builds a tree, asks about it, walks it, copies, renames, and takes it down.
        add_test(NAME codegen_files_metadata_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/files_metadata.pol"
            "-DEXPECTED=made=1 isdir=1 size=5 file=1 walk=3 copied=hello renamed=1 gone=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NUMBER THAT KNOWS WHAT IT MEASURES. `System.Memory.Units.ByteSize` proved the mechanism --
        # `64 kilobytes` is a literal suffix producing a TYPE -- and it existed for bytes alone, so
        # everything else a program measures went back to a bare number, which is how a timeout in
        # seconds reaches a parameter expecting milliseconds with nothing said. Each quantity keeps one
        # canonical unit; arithmetic exists only where it means something, and `distance + duration` is
        # a compile error, which is the entire reason to have the types.
        add_test(NAME codegen_typed_units_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/typed_units.pol"
            "-DEXPECTED=ms=1500 secs=1 sum=90 km=5 deg=90 rad=1.5708 wrap=10 speed=20 back=1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NAMESPACE MAY CONTAIN A NAMESPACE. Spec 2.7 promises `Bundle.Ns1.Ns2.Type` -- "namespace(s)",
        # plural -- and only the dotted spelling parsed; the block form died on "expected 'class',
        # 'struct', 'union', 'interface' or 'layout'", which never mentions nesting. Flattened at parse
        # time to the dotted form, so nothing downstream learns a new shape: three levels deep, and
        # both spellings in one program. The imports are the proof -- they name the full path, which is
        # what the compiler demanded.
        add_test(NAME codegen_nested_namespace_block_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nested_namespace_block.pol"
            "-DEXPECTED=deep=7 bottom=9 mixed=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # EVERY WAY A SHADOWED TYPE CAN BE WRITTEN, IN ONE PROGRAM. The three gaps pinned by
        # shadow_stdlib_name were found by ACCIDENT -- somebody added `Color` to the library and the
        # compiler fell over in three unrelated places. They were never in what was tested; they were
        # in what the renaming pass never walked, and nothing walked it because a collision is rare.
        # This collides on purpose on four stdlib names at once -- a class, an enum, a record and a
        # generic argument -- and uses each in every construct that can name a type: field, parameter,
        # return, array, generic instance, cast, sizeof, nullable, switch, interpolation, unimport. A
        # node kind the rewrite misses is now a failing test rather than a bug report.
        add_test(NAME codegen_shadow_stdlib_wide_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shadow_stdlib_wide.pol"
            "-DEXPECTED=field=3 param=7 ret=10 arr=2 gen=2 cast=0 size=4 null=1 match=2 chain=10 static=5 done=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # DECLARING A TYPE THE STANDARD LIBRARY ALSO DECLARES. Yours wins -- the compiler says so -- and
        # implementing that means renaming both apart and rewriting every reference. THREE kinds were
        # never rewritten: an enum's method bodies (only its name was renamed), `sizeof`'s argument (a
        # type written where a value goes, and bare identifiers are deliberately left alone by the clone
        # that also monomorphizes generics), and `unimport`/`reimport`, which the statement clone did
        # not handle at all, so the statement was silently dropped. None fires until a stdlib type
        # shares a name with a user's: no collision, no renaming, nothing to walk. This test exists so
        # they cannot come back the day somebody renames the library's `Color`.
        add_test(NAME codegen_shadow_stdlib_name_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shadow_stdlib_name.pol"
            "-DEXPECTED=green=2 red=1 size=4 count=3 after=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND READING ITS OWN FIELDS WITHOUT `this.`. The pass that makes the prefix optional kept one
        # flat name -> declaration map, so a type sharing a short name with the library gathered the
        # OTHER declaration's fields: every bare field in its own methods came out as an undeclared
        # variable, on a line whose field is declared four lines above. Found in a real program, where
        # it read as "structs do not support the optional prefix" -- the struct was a coincidence.
        add_test(NAME codegen_shadow_stdlib_bare_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shadow_stdlib_bare_field.pol"
            "-DEXPECTED=x=3 total=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE SPATIAL AND GAME LAYER. `SpatialGrid` -- insert and queryRect -- was the only spatial
        # structure, and a uniform grid is the right answer only for a uniform population: give it a
        # world where everything is in one town and it becomes a linear scan of that town's cell, which
        # is exactly what a game has. No procedural noise and no colour type existed at all, in a
        # language whose north-star is a 3D god-game. The last number is the one worth having a test
        # for: blending in LINEAR light puts the midpoint of black and white at 188, not 128.
        add_test(NAME codegen_spatial_game_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/spatial_game.pol"
            "-DEXPECTED=rect=4 circle=2 near=12 box3=2 noise=1 seeds=1 range=1 hue=120 blend=188"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `Stats` could say what a sample LOOKED like and nothing could say whether it was SURPRISING.
        # Distributions, special functions, root finding, integration, ODE solvers, optimisation and
        # matrix decompositions were all absent. Every number is checked against a closed form or a
        # value that can be looked up, because an approximation that is subtly wrong returns a
        # plausible number on every input and there is nothing to notice.
        add_test(NAME codegen_science_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/science.pol"
            "-DEXPECTED=gamma=24.0000 erf=0.842701 ncdf=0.841345 nq=1.000000 pois=0.676676 binom=0.623047 root=1.414214 deriv=12.000000 integral=9.000000 ode=2.718282 min=3.000000 det=-6.000000 solve=1.000000,3.000000 eig=1.000000,3.000000 p=0.000009"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE COMPILER BUG THE SCIENCE SLICE FOUND, pinned on its own. Calling a callable value has
        # that value's return type, and codegen's `typeName` had no rule for it -- so `f(x)` typed as
        # an integer. Invisible until two such calls met in ONE expression: `f(a) - f(b)` emitted an
        # integer subtraction over two doubles, sign-extending each and converting back, which the
        # module verifier refuses. One call per statement was fine, which is why every existing use in
        # the library (map/filter/sortedBy, all of which hand the value straight back) never showed
        # it. The value is a `command` now and the promise is the same one.
        add_test(NAME codegen_command_value_return_type COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_value_arithmetic.pol"
            "-DEXPECTED=diff=0.500000 both=7.500000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A URL YOU CAN TAKE APART, AND A REQUEST YOU CAN BUILD. `Http.get(host, port, path)` was the
        # entire client -- one verb, no headers, no body -- and there was no Url type at all, so every
        # caller had already split the host from the path by hand. Opens no socket on purpose: building
        # a request and reading a response are pure, which is what makes them testable without a
        # server. The last field is the regression: a BODY containing `X-Secret: leaked` used to answer
        # as though it were a header, because the search scanned the whole response.
        add_test(NAME codegen_http_client_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/http_client.pol"
            "-DCONTAINS=resp: status=200 type=text/plain body=hello notheader="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # PARALLEL ALGORITHMS. Thread, Mutex, Channel and atomic were all here -- every primitive and
        # not one algorithm -- so every program that wanted a loop across the machine wrote the pool
        # itself, and got the chunk arithmetic wrong in the same place: the last one. The answers are
        # checked against closed forms, so a dropped or double-counted chunk fails the test, and the
        # two edges a hand-written pool trips on (nothing to do, one item) are asserted too.
        add_test(NAME codegen_parallel_algorithms_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/parallel_algorithms.pol"
            "-DEXPECTED=width=1 sum=4999950000 mapped=9999900000 empty=0 one=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # REAL DEFLATE. `Huffman`, `Lz77` and `Rle` were already here as hand-written pieces, and not
        # one of them can read a byte any other program wrote -- nothing could open a `.gz`, decode
        # `Content-Encoding: gzip`, or look inside a PNG. Checks the round-trip, that it is genuinely
        # smaller, that a back-reference may OVERLAP its own output (the trick the format rests on),
        # the gzip container, and that a corrupted trailer is refused rather than returned as data.
        add_test(NAME codegen_gzip_roundtrip_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/gzip_roundtrip.pol"
            "-DEXPECTED=same=1 smaller=1 overlap=1 gz=1 crc=1 corrupt=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THREE FORMATS THE LANGUAGE COULD NOT READ. JSON, CSV, INI and Properties existed; TOML, YAML
        # and XML did not, which is most of the configuration in the world. TOML and YAML parse into
        # `Json` -- they are two more syntaxes for the same tree, so they share the document model and
        # everything built over it. XML gets its own, because an element has attributes AND children
        # and flattening that into a map loses the difference between them.
        add_test(NAME codegen_formats_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/formats_toml_yaml_xml.pol"
            "-DEXPECTED=toml: name=Polaron port=8080 ratio=1.5 owner=Joao tags=3 hosts=2 second=beta yaml: name=Polaron port=8080 debug=1 deep=2 items=3 second=two host0=alpha xml: root=config id=7 kids=2 host=alpha port=8080 text=hello & <world>"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A DECIMAL NUMBER IS LEGAL JSON, and the parser died on one: the model held only `long`, so the
        # number reader took the integer part and left `.5` in the stream, the object parser met a `.`
        # where it wanted a comma, and it ran off the end of the input. An access violation, on a shape
        # almost every real service returns. Integer and real stay distinct through parse and write.
        add_test(NAME codegen_json_reals_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/json_reals.pol"
            "-DEXPECTED=half=0.5 pi=3.14159 exp=1500 port=8080 isreal=1 0 out={\"a\":0.5,\"n\":7}"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AN OPEN FILE, which the language did not have: every other file call moves a WHOLE file, so
        # the first line of a log cost the whole log. Never a limit of the platform -- no handle had
        # crossed into Polaron. Writes 26 bytes, then seeks around the file without reading it in.
        add_test(NAME codegen_file_stream_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_stream.pol"
            "-DEXPECTED=wrote=26 at10=KLMN tail=WXYZ pos=26 closed=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE OTHER HALF OF THE RULE. A visibility check that only refuses is half-measured, and every
        # way to get this wrong is an over-refusal: own private through `this`, `protected` in a
        # subclass, a private constructor reached from the type's own static maker, and `internal`,
        # which is the same program and therefore denies nobody inside one compilation.
        add_test(NAME codegen_visibility_allowed_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/visibility_allowed.pol"
            "-DEXPECTED=legs=4 own=1 made=7 shared=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A TRANSFORMER DEMANDED, not merely given: `method larger<T applies TComparer>`.
        #
        # Until this existed a transformer was a second-class citizen beside an interface — it could
        # equip a type and could not be required of one, so generic code routed through a parallel
        # interface. That is not a spelling inconvenience: an interface means a vtable and a virtual
        # call, so the workaround paid at RUN TIME to state a COMPILE-TIME requirement, inside the one
        # construct whose whole claim is that it costs neither.
        #
        # `Card` proves the transitive half: it applies TOrderer, which applies TComparer, and
        # satisfies a constraint naming either — the closure the expansion pass already computes.
        add_test(NAME codegen_transformer_constraint_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_constraint.pol"
            "-DEXPECTED=larger of 5 and 9: 9 larger of 40 and 12: 40 ordered pick: 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # ...and the half that makes it mean something. `Stone` has a `compare` of the right shape and
        # never says `applies`, so it is refused. Under a structural reading it would qualify by
        # accident — and then adding a method named `compare` to any class, for any reason, would
        # silently enrol it in a relation nobody wrote, while removing one would break a constraint in
        # a file that never mentioned it.
        add_test(NAME sema_rejects_unapplied_constraint COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_constraint_bad.pol")
        set_tests_properties(sema_rejects_unapplied_constraint PROPERTIES
            WILL_FAIL TRUE)

        # THE TARGET AS A BOUND VARIABLE: `procedure into<Fahrenheit f> returns Fahrenheit`.
        #
        # The pair was asymmetric — `from<Other>(Other value)` names the SOURCE, and `into<Other>()`
        # named the target not at all, so one side could read its counterpart and the other could only
        # conjure it through a constructor whose parameter list it had to know already. A relation
        # between two types is not one until both ends can be named.
        #
        # The target is storage with no constructor of its own run over it: the body IS its
        # construction, which is why `f.degrees` reaches a PRIVATE field of another class and is not a
        # hole. Fahrenheit said `entrusts`.
        add_test(NAME codegen_transformer_bound_target_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bound_target.pol"
            "-DEXPECTED=100C is 212F 212F is 100C round trip: 100 fields kept: 212 and 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # Consent. `applies` is equipment and nobody else's business; being ASSEMBLED is different in
        # kind, because the body that binds you runs where your constructor would have and yours does
        # not. Only the target can hand that over, and `Yards` never did.
        add_test(NAME sema_rejects_binding_untrusted_target COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bound_untrusted_bad.pol")
        set_tests_properties(sema_rejects_binding_untrusted_target PROPERTIES WILL_FAIL TRUE)
        # ...and completeness, which is what `entrusts` bought. A target left half-built hands back
        # storage that looks like an object: an unassigned field does not read empty, it reads
        # whatever was last there, so the wrong value is plausible and stable. Checked by the dataflow
        # a constructor already passes — the same map and the same join, because two ways of proving
        # one thing is how one of them ends up weaker.
        add_test(NAME sema_rejects_incomplete_bound_target COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_bound_incomplete_bad.pol")
        set_tests_properties(sema_rejects_incomplete_bound_target PROPERTIES WILL_FAIL TRUE)

        # A BODY DERIVED FROM THE SHAPE OF THE APPLYING TYPE — the capability that changes what a
        # transformer IS, from a mixin facility into a metaprogramming one.
        #
        # `record` already does this for `equals` and `clone`, hard-coded in the compiler because it
        # was not expressible in the language; `TCloner` and `TEquator` were not unwritten but
        # UNWRITABLE. And the capability existed at run time and we paid for it: `System.Serialize`
        # walks `t.fields()` / `f.name()` / `f.typeName()` with reflection metadata, allocation and
        # dispatch. The words in the sample are deliberately the same — what changes is when it
        # happens and what it costs, because `comptime foreach` is unrolled.
        #
        # `described:` is the one that matters most: the body BRANCHES on the field's type, and the
        # arm that does not apply is written for a different type and need not type-check for this
        # one — so a decided condition and its dead arm are gone before the analyzer sees them.
        # `inherited too:` proves the shape includes what came from above, base-most first.
        add_test(NAME codegen_transformer_structural_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_structural.pol"
            "-DEXPECTED=copy: 7 42 same as original: 1 changed one field: 0 described: whole=7 tag=hello ratio=2 inherited too: base=3 own=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A TRANSFORMER APPLIED TO A BASE AND TO ITS DERIVED CLASS. It puts a member on each and the
        # derived one overrides — refused, until now, for not saying `override`: a word nobody was
        # there to write, since the compiler made the member. The same sentence already governed the
        # copy that answers a `satisfies` interface, and what `override` exists to make visible IS
        # visible here, on the class line in the reader's own file.
        #
        # The structural case is what makes it worth having: one body over `itself.fields` becomes a
        # DIFFERENT body in each class, and the right one runs through the vtable.
        add_test(NAME codegen_transformer_hierarchy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_hierarchy.pol"
            "-DEXPECTED=base: one=1 derived: one=2 two=3 through the base type: one=4 two=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AN INITIALIZER ON A FIELD A TRANSFORMER BRINGS — listed as an improvement to build, and it
        # ALREADY WORKED. Like the operators before it, what was missing was the test, which is the
        # difference between a feature and an accident that has not been broken yet.
        add_test(NAME codegen_transformer_applied_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_applied_field.pol"
            "-DEXPECTED=front: 2 wide 80 back: 1 wide 90"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # ...and the obligation that makes the initializer worth having. Without the `= 0`, `Door`'s
        # constructor must assign a field its class never declared — because an unassigned field does
        # not start empty, it starts as whatever was last in that storage, and the field being
        # somebody else's does not soften that.
        add_test(NAME sema_requires_applied_field_assigned COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_applied_field_bad.pol")
        set_tests_properties(sema_requires_applied_field_assigned PROPERTIES WILL_FAIL TRUE)

        # A RULE THAT TRAVELS WITH THE STATE IT IS ABOUT. A transformer could bring a field and not
        # the property that must hold of it, so the applier was left maintaining a rule about state it
        # never declared — or, more honestly, not maintaining it, because nothing said what it was.
        add_test(NAME codegen_transformer_invariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_invariant.pol"
            "-DEXPECTED=counted: 2 still holds: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # ...and the half that proves it. A rule that travels and is never enforced is a comment:
        # `Gate` drives the count negative through a method of its own, touching state it did not
        # declare and breaking a rule it never read, and the program dies at the method boundary.
        add_test(NAME codegen_transformer_invariant_enforced COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_invariant_broken.pol"
            "-DPANIC=invariant itself.hits >= 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        # ...naming the method that broke it, which is the applier's and not the transformer's.
        add_test(NAME codegen_transformer_invariant_names_the_method COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_invariant_broken.pol"
            "-DPANIC=in Gate.rewind"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # `when itself applies TComparer` — MORE FOR A TYPE THAT HAS MORE. `applies` was
        # all-or-nothing, so a transformer that could do better for a type with an ordering had to
        # demand the ordering of everybody or give it to nobody. The condition is the constraint form
        # built the same day, read at the DECLARATION instead of at a call site.
        add_test(NAME codegen_transformer_conditional_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_conditional.pol"
            "-DEXPECTED=plain: count=3 first=10 ranked: count=3 first=10 largest=30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # ...and the member is ABSENT, not present-and-broken. A conditional body that existed and
        # failed at run time would be the shape this language keeps refusing: a thing that looks
        # available and is not. Calling it is an ordinary "no such method", in the caller's own file.
        add_test(NAME sema_conditional_procedure_absent COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_conditional_bad.pol")
        set_tests_properties(sema_conditional_procedure_absent PROPERTIES WILL_FAIL TRUE)

        # THE LAW OF THE RELATION, written on the procedure that is the relation. A conversion that
        # compiles and one that is RIGHT are different things, and nothing in the declaration used to
        # say which you had.
        #
        # `invariant` on a procedure is not the transformer-level one doing double duty: that one is
        # about state and is checked on entry to every method, which a round-trip law cannot be —
        # it would convert on every call, and the conversion calls methods, which check the
        # invariant, which converts. The POSITION tells them apart, with no new word and no rule that
        # reads the expression to guess its subject.
        #
        # Checkable rather than checked, and honestly so: a property test needs VALUES the compiler
        # cannot invent for an arbitrary type, so the law becomes a method whose RECEIVER is the
        # sample. And it earns its keep on the first try — 100C round-trips, 37C does not, because
        # integer division loses the remainder both ways. A conversion that compiles, runs, and is
        # wrong for most inputs.
        add_test(NAME codegen_transformer_law_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_law.pol"
            "-DEXPECTED=100 degrees: 212F, law holds 1 37 degrees: 98F, law holds 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ONE SOCKET, FOUR OPERATORS. The design note listed this as an improvement to build, with the
        # guess that it might already work because operators are ordinary `MethodDecl`s -- and it does.
        # What was missing was the test, which is the difference between a feature and an accident that
        # has not been broken yet. It is also the flagship example that note said it lacked: `Coin` says
        # how two coins compare and gains an ordering, expanded at compile time with no vtable.
        add_test(NAME codegen_transformer_operators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_operators.pol"
            "-DEXPECTED=less=1 more=0 le=1 ge=0 eqle=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AN ENUM APPLIES A TRANSFORMER. The design note's flagship conversion is `Errno -> int`, and
        # until the clause was accepted on an enum the example that motivated per-target procedures
        # was the one shape the language could not write. Its constants stay ordinals; what it gains
        # is members, which an ordinal enum has always been able to hold.
        add_test(NAME codegen_transformer_enum_convert_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transformer_enum_convert.pol"
            "-DEXPECTED=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A freestanding image must not carry the managed String runtime, and the way it did was
        # indirect: `onClassLoad` hooks are called from the entry, that call is emitted BEFORE
        # dead-stripping, and the prelude's `Test` -- the only class in it with a hook -- assigns two
        # static `String`s. So an empty kernel failed at link on `__polaron_str_copy`/`__polaron_str_free`,
        # naming symbols its author never wrote. pico stopped building on exactly this.
        #
        # An ABSENCE test, which is the shape this defect needs: a presence test catches a feature
        # that stopped being emitted, and nothing here stopped -- something started.
        add_test(NAME codegen_freestanding_has_no_string_runtime COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_no_prelude_hooks.pol"
            "-DNEEDLE=__polaron_str_copy"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # A DATA-CARRYING ENUM NEEDS NO ALLOCATOR. Every constant of one is a singleton -- one object
        # for the whole run, never freed -- and it was built with `__polaron_malloc` on first touch. So
        # a freestanding program that named a single constant of one did not link, and the feature was
        # unavailable on bare metal: pico's DNS resolver, whose every outcome is such a constant, was
        # where this surfaced. The storage is now a slot in the image.
        add_test(NAME codegen_freestanding_data_enum_has_no_allocator COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_value_types.pol"
            "-DNEEDLE=__polaron_malloc"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # ...and A SMALL VALUE STRUCT IS COPIED WITHOUT A C LIBRARY. Assignment is copying, so passing
        # a four-byte struct by value is a copy -- emitted as a CALL to `memcpy`, with the length
        # written as a constant expression that never folded, so even four bytes went out as a libcall.
        # `llvm.memcpy` with a literal size is expanded inline instead; a genuinely large copy still
        # becomes the libcall, which the freestanding runtime provides weakly.
        add_test(NAME codegen_freestanding_struct_copy_has_no_libc COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_value_types.pol"
            "-DNEEDLE=call ptr @memcpy"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # `unimport` REFUSES while instances are alive, and that precondition is what makes ripping
        # the code and poisoning the table safe: with nothing alive, no object's vtable pointer,
        # fields or destructor can outlive the code being removed.
        #
        # `refused` is the rip rejected with the object still live; `gone` is the guard closing after
        # the object was deleted and the class removed; `16` is the value read before any of it.
        #
        # The count comes down in a DESTRUCTOR, which is why an unimportable class is given one even
        # when it wrote none -- `dtorImpl` returns "" otherwise and no death site calls anything.
        # Marking that has to happen AFTER the unimportable set is known; doing it during the layout
        # pass, where the set is still empty, left the count stuck at 1 and refused a class with
        # nothing alive.
        add_test(NAME codegen_unimport_refuses_live_instances COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_virtual_call.pol"
            "-DEXPECTED=refused gone 16"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `unimport` takes the class's OWN STORAGE, not only its code. A static field is memory that
        # belonged to the TYPE rather than to any object, and with the live-instance refusal in place
        # nobody is left who can read it -- so leaving it holding its last value leaves state behind
        # for a type that no longer exists, and `reimport` would bring the class back mid-history.
        # `counted=3` then `back=0` is the class returning at its starting state.
        add_test(NAME codegen_unimport_clears_statics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_clears_statics.pol"
            "-DEXPECTED=counted=3 back=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `unimport`/`reimport` BARE METAL, which is what the feature was measured against: ripping a
        # driver's code out of a running kernel without rebooting it. The needle is the guard's
        # freestanding lowering -- `__polaron_panic`, which a kernel already overrides -- and it stands
        # for the whole result: this image needs that plus `__polaron_unload_fn`/`__polaron_reload_fn` and
        # NOTHING else. No libc, no C++ unwinder, no prelude dragged in behind them.
        add_test(NAME codegen_unimport_freestanding COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_freestanding.pol"
            "-DNEEDLE=declare void @__polaron_reload_fn"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # ...and the negative half of the same claim: NO unwinder reaches a bare-metal image -- on
        # either exception model, and whatever machine builds it.
        #
        # This asked for `__cxa_throw` and nothing else, so on Windows it verified NOTHING: the model
        # here starts a throw with `_CxxThrowException`, and the sample emitted two of them out of a
        # division guard in `RegionCore.entriesIn`. The backend read only the TRIPLE, and this suite
        # builds freestanding programs for the host triple on purpose -- that is how it runs them --
        # so `program ... freestanding` looked hosted to it. Both personalities are named too: a
        # frame that declares one carries a relocation to a runtime the target does not have.
        foreach(_model "x86_64-pc-windows-msvc" "x86_64-unknown-linux-gnu")
            string(REGEX REPLACE "[^a-z0-9]+" "_" _slug "${_model}")
            add_test(NAME codegen_unimport_freestanding_has_no_unwinder_${_slug} COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_freestanding.pol"
                "-DNEEDLE=__cxa_throw|_CxxThrowException|__gxx_personality_v0|__CxxFrameHandler3"
                "-DPOLARONFLAGS=--target=${_model}"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")
        endforeach()

        # REFLECTION BARE METAL. The gate that barred it came from spec 36.3's list rather than from
        # a measurement: against an empty program it needs `__polaron_malloc` (the kernel's own, via the
        # `heap class` bridge) and `memcpy`, plus `strcmp` to look a method up by name. No libc
        # runtime, no unwinder, no managed anything.
        #
        # Not academic either: `Method.firstByte()` is how `unimport` is tested -- reading back the
        # 0xCC that replaced the code -- which is a bare-metal question by nature.
        add_test(NAME codegen_reflect_freestanding COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_freestanding.pol"
            "-DNEEDLE=@type.Nic = private constant %ReflectType"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # `String` AND `string` BARE METAL. The gate said they lower to `__polaron_str_copy`/`_free`,
        # "which bare metal has no runtime to provide" -- premise true, conclusion false. Those are
        # OURS, not libc, and the hosted ones are written purely in terms of malloc, free and memcpy,
        # so codegen generates them from the program's own `heap class` like the allocator bridge.
        #
        # With a heap class present this sample's ONLY external is `llvm.memcpy`. It also closes a
        # real bug: lowercase `string` was never gated, so `string s = "hello";` compiled in a kernel
        # and failed at link on these very symbols -- a missing gate, found mid-hunt for excess ones.
        add_test(NAME codegen_string_freestanding COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_freestanding.pol"
            "-DNEEDLE=define internal ptr @__polaron_str_copy"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # ...and the claim that makes it worth having: no C library reached the image.
        add_test(NAME codegen_string_freestanding_has_no_libc COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_freestanding.pol"
            "-DNEEDLE=declare i32 @snprintf"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # ---- §11.5: escape analysis (docs/design/polaron-ir.md) ----
        #
        # THE ANSWER FIRST, as always: three methods whose objects go three different ways still
        # print the same three numbers. An object moved onto the stack while somebody holds its
        # address does not crash -- it reads correctly for exactly as long as the frame is untouched,
        # which is the worst possible failure and the reason the refusals below carry the weight.
        add_test(NAME codegen_escape_to_the_frame_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_to_the_frame.pol"
            "-DEXPECTED=contained=6 given=0 handed=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THE PASS IS WHAT MOVED IT. Narrowed to one method, because the same program has
        # allocations that must NOT move and a whole-file search for `[heap]` finds those and calls
        # it a pass that did nothing.
        add_test(NAME pir_escape_gives_the_frame_what_stays COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_to_the_frame.pol"
            "-DIN_FN=Main.contained"
            "-DABSENT=[heap]"
            "-DWITHOUT=fold,guards,immutable,dead,purity,reach,devirt"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pass_matters_test.cmake")

        # A POINTER THAT IS RETURNED IS THE PLAINEST ESCAPE THERE IS, and the one where getting it
        # wrong hands the caller a pointer into a frame that has ended.
        add_test(NAME pir_escape_keeps_a_returned_object_on_the_heap COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_to_the_frame.pol"
            "-DIN_FN=Main.handedBack"
            "-DNEEDLE=alloca %Point @Point [heap]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # ...AND ONE STORED INTO ANOTHER OBJECT. `Keeper.keep` writes the POINTER into `this`, so
        # the summary must say parameter 1 of that method escapes -- which is the half of the
        # interprocedural answer that has to be right for the other half to be worth having.
        add_test(NAME pir_escape_keeps_a_stored_object_on_the_heap COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_to_the_frame.pol"
            "-DIN_FN=Main.givenAway"
            "-DNEEDLE=alloca %Point @Point [heap]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # ---- `Machine` — a standard library for bare metal (Wave 5) ----
        #
        # The freestanding mode worked by REFUSAL: half a dozen checks asked which file a
        # declaration came from and told a bare-metal program what it may not have, with nothing
        # offered in its place. So every kernel hand-wrote text output, port I/O, memory operations
        # and serial — Horizon has written a great deal of it and nobody else could use any.
        #
        # A BUNDLE OF ITS OWN, assembled from `src/prelude/machine/` beside `lib/`, and the
        # directory is not organisation: the gate decides what a program may have by asking which
        # FILE a declaration came from, so a tier the language knows about and the compiler's own
        # checks cannot see is today's failure inverted.
        #
        # `--check` and not a run: this is a freestanding program with no host to run on, and what
        # is being asserted is that it RESOLVES — before `Machine` existed the four imports did not,
        # and every line of what they name was written by hand per kernel.
        add_test(NAME sema_machine_prelude_resolves
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/machine_prelude.pol")

        # ...AND ONE OF ITS ENTRIES IS RUN, WHICH NONE OF THEM WAS.
        #
        # The two tests around this one are a `--check` and a grep of the emitted IR. Neither
        # executes anything, so `Machine.Format` -- the formatter that exists because every kernel
        # otherwise writes one by hand -- had never produced a digit, and two things were wrong with
        # it that only running finds:
        #
        #   1. it asked for `byte[] into`, and a `T[]` here is a pointer to a HEAP block with a
        #      length header. The only way to make one is to allocate, in the tier whose two stated
        #      premises are no heap and no `String`; an inline `byte[16]`, which is what a kernel
        #      has, does not convert to it. The parameter could not be satisfied by the programs the
        #      entry exists for -- and the demonstration sample hid that by writing `new byte[64]()`,
        #      which compiles because that sample happens to run somewhere with an allocator;
        #   2. its replacement was called `Span`, and `System.Units.Span` is a length of TIME. A
        #      program importing one got the other -- a struct of one `long`, read as a pointer and a
        #      capacity -- so the formatter returned the right COUNT and wrote its digits through the
        #      first eight bytes of a duration. Horizon printed `F:OK` and two NUL bytes where
        #      `F:OK16` belonged, from a hundred and fifty call sites at once.
        #
        # So this asserts the BYTES and not the count, because the count is what both bugs got right.
        # Hosted, because that is what can be run here -- the tier is importable from a hosted
        # program and the buffer is on the frame, so nothing about the assertion needs bare metal.
        add_test(NAME codegen_machine_format_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/machine_format_runs.pol"
            "-DEXPECTED=dec 2 [49 54] neg 3 [45 52 50] hex 6 [48 120 48 48 102 102] pad 4 [48 48 48 55] text 5 [104 105 33 33 33]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and it reaches the machine. `out dx, al` is the `Machine.Port` primitive everything else
        # on x86 goes through, with the operand PLACED rather than moved by the block — the two
        # features landing in the same wave, one using the other.
        add_test(NAME codegen_machine_prelude_emits_port_io COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/machine_prelude.pol"
            "-DNEEDLE=out dx, al"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # ---- `comptime if` — the untaken branch is parsed and nothing else (Wave 5) ----
        #
        # *A `comptime` statement is EVALUATED at build time; whatever RUNTIME code its body contains
        # is emitted, once per evaluation.* For an `if` that means one branch is the program and the
        # other never existed. It must PARSE — so it is syntax and not text — but it is not analysed
        # and not emitted, so target-conditional code may name things that do not exist in the other
        # mode: `Console` in a freestanding program, an aarch64 register in an x86 block.
        #
        # It used to lower BOTH arms and leave a branch on a constant for LLVM to fold, which folds
        # the CODE and not the NAMES — an arm mentioning something the target lacks still had to
        # lower, so `comptime if` could select behaviour and never select availability. The sample's
        # dead branches call `Missing.gone()`, `NotThere.either()` and `AlsoNotThere.at().all()`,
        # none of which is declared anywhere: it compiling IS the assertion.
        #
        # This is what makes one `Machine` library partitioned by target possible at all; the
        # alternative is two libraries that drift.
        add_test(NAME codegen_comptime_if_prunes_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_if_prunes.pol"
            "-DEXPECTED=picked=64 nested=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ---- `reentrant` — the wide property `interrupt` was a special case of (Wave 5) ----
        #
        # `interrupt` carried a bespoke list of prohibitions — must not allocate, must not free,
        # must not reach shared mutable state — checked over the call graph. Every entry on that
        # list is an implication of **may be entered again while an earlier entry is still
        # running**, and naming the sentence buys three things a "does not allocate" marker cannot:
        # `interrupt` stops having rules of its own; it **catches the lock**, because a `reentrant`
        # method that takes a `Mutex` deadlocks against itself; and a method that is not a handler
        # but must be equally careful gains a way to say so.
        #
        # One walk and two sets of roots: the machinery was already there and the second kind of
        # root is the whole change.
        add_test(NAME codegen_reentrant_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reentrant_method.pol"
            "-DEXPECTED=pushed=3 head=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND IT IS VIRAL, WHICH IS WHERE THE VALUE IS. `refill` allocates and frees; it is not a
        # handler, so the `interrupt` rule never looked at it, and the method reaching it is not a
        # handler either. One word on `pump` connects them, and the diagnostic names the PATH —
        # *"Ring.refill frees memory"* is a fact about Ring and not a bug; *"pump is reentrant and
        # reaches it, via refill"* is the bug, and says which of the two to change.
        add_test(NAME sema_rejects_reentrant_reaching_the_allocator
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/reentrant_method_bad.pol")
        set_tests_properties(sema_rejects_reentrant_reaching_the_allocator PROPERTIES
            PASS_REGULAR_EXPRESSION "reentrant. method must not free memory \\(reached via refill\\)")

        # ---- `move` into a thread — the fourth way across the boundary (Wave 5) ----
        #
        # `atomic<T>`, `Mutex<T>` and `Channel<T>` are three ways to SHARE. None of them is the
        # obvious one, which is **not to share** — to hand it over. A thread that receives its chunk
        # by `move` is its sole holder, so no race is possible because there is no second holder:
        # safe by construction rather than by a lock, and it costs nothing. It is also the common
        # case, one worker and one chunk, and it needed no relaxation of the rule that protects the
        # dangerous case — only a third capture mode, because `byvalue` copies and `byref` shares
        # and neither says *the outer scope no longer has this*.
        add_test(NAME codegen_thread_move_capture_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DPOLARONFLAGS=--region-binder"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_move_capture.pol"
            "-DEXPECTED=worked=1 sum=499500"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND THE INVALIDATION, which is what makes it a promise rather than a reassuring word.
        # *Sole holder* has to be enforced somewhere or the mode is a third spelling of `byref`; it
        # is enforced by the same machinery every other `move` uses, so reading the handed-away
        # variable is `Polaron-0402` at the line that reads it.
        add_test(NAME sema_rejects_reading_what_a_thread_was_given
            COMMAND polc --check --region-binder
                    "${CMAKE_CURRENT_SOURCE_DIR}/samples/thread_move_capture_bad.pol")
        set_tests_properties(sema_rejects_reading_what_a_thread_was_given PROPERTIES
            PASS_REGULAR_EXPRESSION "use of variable 'chunk' after it was moved")

        # ---- `shareable` — a modifier, and a checked one (Wave 5) ----
        #
        # It began as `implements Shared`, a marker interface. `ownership.md` §20.4 moved it to a
        # modifier, and the decisive reason only became live when `dynamic` landed: **a class that
        # implements an interface carries a header**, so a value type declaring itself shareable
        # would acquire eight bytes and an indirection for a property that generates no calls —
        # exactly the cost AP-02 is about, arriving through a word chosen for convenience.
        # `size=4` below is that reason measured: a `shareable struct Ticket { int id; }` is four
        # bytes, which as a marker interface it could not have been.
        #
        # Three shapes that are legal, one per clause of the rule: every mutable field `atomic`, the
        # type entirely immutable, and a mutable field that is itself shareable.
        add_test(NAME codegen_shareable_modifier_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shareable_modifier.pol"
            "-DEXPECTED=counted=3 frozen=7 nested=9 size=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND THE CHECK, which is the half that makes the word worth anything (§14). A bare
        # permission would be a one-word hole in the no-UB principle — written over a type with a
        # plain mutable `int` it is exactly the race the compiler otherwise refuses, and that
        # refusal is what makes AP-33 invert. Trading it for a password hands the objection back
        # after winning it.
        add_test(NAME sema_rejects_shareable_over_a_racy_field
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/shareable_modifier_bad.pol")
        set_tests_properties(sema_rejects_shareable_over_a_racy_field PROPERTIES
            PASS_REGULAR_EXPRESSION "is .shareable., but its field 'hits' is mutable")

        # ---- `readonly` -- declared, and then checked (B.1 / D.6) ----
        #
        # The analysis existed already: every body records what it writes, and the call graph is
        # recorded beside it. What was missing was the DECLARATION, which is what turns an inference
        # the compiler kept to itself into a promise a reader can rely on.
        add_test(NAME codegen_readonly_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/readonly_methods.pol"
            "-DEXPECTED=area=12 perimeter=14 grown=48"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the refusal, which is the half that makes the word worth anything. TWO of them: one
        # body that writes a field (a cache is a write), and one that writes nothing itself and calls
        # the first -- because a promise about a body that mostly calls other bodies is a promise
        # about them, or it is not a promise.
        add_test(NAME sema_rejects_readonly_that_writes
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/readonly_writes_bad.pol")
        set_tests_properties(sema_rejects_readonly_that_writes PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-0815.*calls something that writes")

        # ---- CONST GENERICS: `fixed` in the brackets (A.3) ----
        #
        # `ArrayList<T>` has a hole where a TYPE goes; until now there was none where a NUMBER goes.
        # Four things at once, and each is a case a region cannot reach: the extent is IN THE TYPE
        # (`T[R * C]`, no header, no allocation), so the value EMBEDS as a field; the dimensions are
        # CONSTANTS in the body; and they UNIFY in a signature.
        add_test(NAME codegen_const_generics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_generics.pol"
            "-DEXPECTED=rows=2 cols=3 cell=7 sum=7 product=2,4 embedded=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE CLAIM THE FEATURE IS FOR, HELD: a 4x3 times a 7x9 does not compile. With the
        # dimensions as runtime FIELDS -- what `Math.Matrix` does -- it compiles and fails while
        # somebody is using it, which is a failure of text dying in the user's hands.
        add_test(NAME sema_rejects_a_shape_that_does_not_meet
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/const_generics_shape_bad.pol")
        set_tests_properties(sema_rejects_a_shape_that_does_not_meet PROPERTIES
            PASS_REGULAR_EXPRESSION "has type 'Grid.int.7.9' but the parameter type is 'Grid.int.3.9&'")

        # ...and a bare value parameter is RESERVED, not spent: `<int a>` is the runtime-bound extent
        # that arrives later, so it is refused with a message rather than quietly given the stamped
        # meaning -- a form that silently means the wrong thing today cannot be given the right one
        # tomorrow.
        add_test(NAME sema_rejects_a_bare_value_type_parameter
            COMMAND polc --check
                    "${CMAKE_CURRENT_SOURCE_DIR}/samples/const_generics_bare_value_bad.pol")
        set_tests_properties(sema_rejects_a_bare_value_type_parameter PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-010B.*VALUE parameter that binds at run time")

        # ---- `mustuse` and its valve (B.2) ----
        #
        # The rule existed for two type names written into the compiler -- `Result` and `Option`.
        # The property was never theirs alone, and now a library can say it: on the TYPE (once, for
        # every method that will ever return one) or on a single METHOD. `discard` is the answer,
        # at the line, because a rule that cannot be answered is a rule people switch off.
        add_test(NAME codegen_mustuse_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mustuse.pol"
            "-DEXPECTED=ticket=1 reading=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the same three calls without it, where two are reported and the third is not.
        add_test(NAME sema_reports_a_dropped_mustuse
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/mustuse_dropped_bad.pol")
        set_tests_properties(sema_reports_a_dropped_mustuse PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-0B19.*returns a 'int' and the statement drops it")

        # ---- `Channel<T>.send` transfers (docs/design, C.3) ----
        #
        # A slot is 64 bits, so an object crosses as a REFERENCE and the sender keeps holding it:
        # two threads, one object, and nothing on the line saying so. Everywhere else a travelling
        # value is copied -- assignment deep-copies, a command's baggage is copied at construction --
        # so the channel was the one place where the easy spelling was the sharing one. The same
        # sample proves the exemption: `ints.send(1)` on a `Channel<int>` stays legal, because a
        # number in a slot IS the value and there is nothing on the other side to alias.
        add_test(NAME sema_rejects_channel_send_without_move
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/channel_send_needs_move_bad.pol")
        set_tests_properties(sema_rejects_channel_send_without_move PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-0814.*by reference, so .send. transfers it")

        # ---- `command` -- the two refusals the two forms need (reference 14.1) ----
        #
        # A command TYPE is a role, and a role says what will be CALLED. What a command holds is the
        # other half and differs between commands playing the same role, so baggage written here
        # would demand they all carry the same things.
        add_test(NAME sema_rejects_carries_on_a_command_type
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/command_type_carries_bad.pol")
        set_tests_properties(sema_rejects_carries_on_a_command_type PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-0108.*says what will be called, not what it holds")

        # ...and the inline form is written AT the use, so a carried name with nothing behind it is a
        # field that stays empty forever. The declared form gets to separate the two because there
        # the declaration and the use are in different places; here they are the same place.
        add_test(NAME sema_rejects_inline_command_without_values
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/command_inline_no_value_bad.pol")
        set_tests_properties(sema_rejects_inline_command_without_values PROPERTIES
            PASS_REGULAR_EXPRESSION "Polaron-010A.*carries its values with it")

        # ---- `unique` over a value type (Wave 5) ----
        #
        # `ownership.md` §5: the ownership disciplines lived on CLASSES, which is why `atomic<T>` is
        # a class and every use of one is a separate heap allocation. Whether a value lives inside
        # its owner or is reached through a pointer is what `struct` versus `class` already decides;
        # `unique` says WHO MAY HOLD IT, and it was pinned to one side by a sentence.
        #
        # Found already working, which is this repository's most repeated lesson — `ownership.md`
        # §19 states it: *"the method that keeps failing is trusting the notes. Read the repository,
        # not the record."* What was NOT there is §6.1's diagnostic, below.
        add_test(NAME codegen_unique_value_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unique_value.pol"
            "-DEXPECTED=moved=3 inline=10 sum=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # CONTAGION, AND THE DIAGNOSTIC THAT NAMES ITS CAUSE. A type with a `unique` field cannot be
        # copied — arithmetic, not a choice — and §6.1 requires the message to say WHICH field,
        # because it is frequently two types below the line being refused. The needle is the naming,
        # not the refusal: the refusal was already there and said nothing useful.
        add_test(NAME sema_rejects_copying_a_unique_value
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/unique_value_bad.pol")
        set_tests_properties(sema_rejects_copying_a_unique_value PROPERTIES
            PASS_REGULAR_EXPRESSION "its field 'head' is 'unique'")

        # ---- `dynamic` — the object header becomes a word the author writes (Wave 5) ----
        #
        # AP-02 outright: *every object carries a vtable pointer, including ones with no virtual
        # method at all.* It was right, and the cost came from ONE LOOP IN THE DRIVER that gave
        # `extends Object` to every hosted class — so `class Tag`, which nothing extends and nothing
        # overrides, was sixteen bytes because nobody had written anything.
        #
        # Seven numbers, and each separates something: `plain` and `sealed` are 8 (a class is its
        # fields, and `final` no longer has to argue for it); `asked` is 16 because the word was
        # written; `derived` and `implementer` are 16 because for them it was never a choice; `tag`
        # proves a headerless class still constructs, calls and deletes; and `spoke` proves dispatch
        # is untouched where a class does carry its type, which is the thing the header is FOR.
        #
        # C++ cannot state this: `virtual` is per-method and the header appears as a side effect
        # neither declaration mentions.
        add_test(NAME codegen_dynamic_header_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dynamic_header.pol"
            "-DEXPECTED=plain=8 sealed=8 asked=16 derived=16 implementer=16 tag=7 spoke=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THE SHAPE IN THE IR, because `sizeof` is a number a program prints and the layout
        # is what the machine sees. `%class.Tag = type { i32, i32 }` — two ints and nothing in front
        # of them — is the whole of AP-02's answer in one line.
        add_test(NAME codegen_dynamic_header_is_absent_from_the_type COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dynamic_header.pol"
            "-DNEEDLE=%class.Tag = type { i32, i32 }"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # ---- `asm` operand constraints — choosing the register (Wave 5) ----
        #
        # The mechanism was built with exactly ONE constraint: every output `=r`, every input `r`,
        # any general-purpose register. A block needing a value somewhere specific had to move it
        # there itself, and AP-18 measured the cost — **C is 13 bytes tighter across three blocks**,
        # because its constraint language lets the allocator do the placing.
        #
        # The vocabulary is the architecture's own register names, not C's letter codes: `"ax"`, not
        # `"a"`. A private alphabet is a second thing to learn for a fact the machine already names,
        # and it runs out — C spells the `edx:eax` pair `"A"` and has no letter left for another.
        add_test(NAME codegen_asm_operand_place_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_operand_place.pol"
            "-DEXPECTED=doubled=84 sum=30 free=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the constraint reached LLVM as the register and not as `r`. Without this the
        # program above still prints 84 — the block would move the value itself, which is exactly
        # what the feature exists to stop paying for, and it is invisible in the output.
        add_test(NAME codegen_asm_operand_place_is_the_register COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_operand_place.pol"
            "-DNEEDLE=\"={ax},{cx},~{rax},~{memory}\""
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # AND THE REFUSAL, whose real subject is a PORT rather than a typo. A block copied from the
        # x86 side with the arch word changed has every mnemonic checked against the new target and,
        # without a table for that target's registers, its constraints checked against nothing — so
        # the one line still saying x86 is the one line nothing looks at. Teaching the checker
        # aarch64's register families (§6.2) is what makes the message possible.
        add_test(NAME sema_rejects_asm_place_from_another_arch
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/asm_operand_place_bad.pol")
        set_tests_properties(sema_rejects_asm_place_from_another_arch PROPERTIES
            PASS_REGULAR_EXPRESSION "is not a register on aarch64")

        # ---- `super.m()` — the body this one overrides, called by name (Wave 5) ----
        #
        # An override that wants to EXTEND rather than replace had no way to say so. AP-29 was
        # written as a decorator chain — each level calling `super.render()` and adding a term —
        # and did not compile: *"'super' can only be used as 'super(...)' in a constructor"*. The
        # finding was rewritten around the gap, so the objection it existed to test was never
        # reached. The LOWERING had done the work all along; the refusal was one layer above it.
        #
        # Four numbers, separating four things: the chain runs every level (113); an object that IS
        # a `Shadow` enters three levels down (49); ordinary dispatch through a `Base*` is unchanged
        # (113); and `super.name()` where the immediate parent is silent walks the base's OWN chain
        # to `Base.name` (100). The last is what found the second bug — see below.
        add_test(NAME codegen_super_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/super_method.pol"
            "-DEXPECTED=chain=113 skipOne=49 dispatched=113 past=100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND THE REFUSAL, which is the half with something to lose. `super.m()` names a key rather
        # than looking one up, and **a call naming a key nothing defines emits nothing at all** —
        # the backend finds no function and the value is quietly undef. That is not a theory: it is
        # what the sample above did before the lowering walked the base's chain, and it read as an
        # access violation with no diagnostic anywhere in the compile.
        add_test(NAME sema_rejects_super_without_a_body
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/super_method_bad.pol")
        set_tests_properties(sema_rejects_super_without_a_body PROPERTIES
            PASS_REGULAR_EXPRESSION "to call through 'super'")

        # ---- `enum` with payloads — the sum the language had two of, hard-coded (Wave 5) ----
        #
        # `Result<T,E>` and `Option<T>` were the only sums in Polaron, written out in the prelude by
        # hand as a sealed base with one class per case, with their four case names — `Ok`, `Err`,
        # `Some`, `None` — built into the parser, the type checker and the lowerer. A user could not
        # write a third. The word `enum` over cases that carry data now produces THE SAME
        # DECLARATIONS the prelude writes by hand, so a user sum inherits monomorphisation,
        # exhaustiveness, positional destructuring and the tag test without a second mechanism.
        #
        # Six lines, separating six things: a payload read back through a pattern (12); a payload of
        # arity two (12, on numbers chosen so the two areas cannot coincide by accident); a case
        # with NO payload, which is still a case and not an ordinal (0); the declaration order,
        # visible without opening the value (012); a GENERIC sum instantiated at `int`, which is
        # what makes a payload sized (42); and its empty case.
        add_test(NAME codegen_enum_payload_cases_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_cases.pol"
            "-DCONTAINS=circle 12 rect 12 empty 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The generic half, asked separately so a regression that reaches only the instantiated sum
        # cannot hide behind the concrete one passing. `Holder<int>` is what makes the payload sized.
        add_test(NAME codegen_enum_payload_generic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_cases.pol"
            "-DCONTAINS=held 42 none is absent"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And the declaration order, which is the one fact a sum can answer without being opened.
        add_test(NAME codegen_enum_payload_ordinals_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_cases.pol"
            "-DCONTAINS=ordinals 012"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE DISCRIMINATION, which is where this feature can go wrong silently. `BRIGHT(Level.HIGH)`
        # and `Circle(int radius)` are the same shape and mean opposite things — one gives THE
        # constant its data once, the other says every construction brings its own — and the hard
        # case is a java-style argument that is a qualified name, because `Level.HIGH` ends in an
        # identifier exactly the way a declaration does. Read wrong in either direction, one of the
        # two enums below stops existing. Both are in one file so one test covers both readings.
        add_test(NAME codegen_enum_payload_vs_javastyle_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_vs_javastyle.pol"
            "-DCONTAINS=level 2 ordinal 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_enum_payload_sum_beside_javastyle COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_vs_javastyle.pol"
            "-DCONTAINS=radius 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AND THE REFUSAL THE SEALING BUYS. A sum desugars to a sealed hierarchy precisely so that a
        # forgotten case is NAMED. The alternative — three unrelated classes — compiles only with a
        # `default`, and a `default` is the arm that swallows the case added next year.
        add_test(NAME sema_rejects_enum_sum_missing_a_case
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_payload_cases_bad.pol")
        set_tests_properties(sema_rejects_enum_sum_missing_a_case PROPERTIES
            PASS_REGULAR_EXPRESSION "missing case 'Rect'")

        # ---- `entity` — a value type whose ARRAYS are transposed (Wave 5) ----
        #
        # AP-06, the objection that STANDS: *"a loop over one field of ten thousand objects touches
        # ten thousand cache lines where a column touches six hundred, so at this level you must
        # abandon the type."* Polaron could already express structure-of-arrays and run level with
        # C, but only by dissolving `Particle` into parallel `float[]`s — and the measurement was
        # written twice and failed twice, because the thing the program is about had no type either
        # time. No library can fix it: the transposition has to happen BELOW the type.
        #
        # THE ADDRESSES ARE WHAT IS ASKED, and they have to be. Reading `swarm[3].y` back gives 30
        # under either arrangement, so a compiler that quietly kept rows passes every value test in
        # this file. Two distances separate them and cannot both be produced by accident: the step
        # from one row's `x` to the next is 4 in columns and 8 in rows, and the distance from `x` to
        # `y` within row zero is the whole x column (400) in columns and 4 in rows.
        add_test(NAME codegen_entity_storage_is_columnar COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_columns.pol"
            "-DCONTAINS=step 4 column 400"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and that the values are right, which is the half the addresses do not cover: a walk
        # down the whole x column, and a field read back through the second index.
        add_test(NAME codegen_entity_reads_back_what_was_written COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_columns.pol"
            "-DCONTAINS=y3 30 step 4 column 400 sumx 4950"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE SECOND REPRESENTATION. `Particle p = swarm[i]` materialises — one value out of each
        # column into a local — and it is a COPY: writing the copy afterwards must not touch the
        # block. A view would print 99 for the last line, and everything above it would still pass.
        add_test(NAME codegen_entity_row_materialises_as_a_copy COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_columns.pol"
            "-DCONTAINS=row 7 70 untouched 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `pass` — written for ONE ROW, run over the population. `swarm.advance(2)` twice must give
        # `x1 = 12` and not 6 (the loop ran once) or 24 (the call was emitted twice, which is what
        # happened while `emitCall` returning no value for a void pass read as "not handled").
        add_test(NAME codegen_entity_pass_runs_over_every_row COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_pass.pol"
            "-DCONTAINS=x0 0 x1 12 x9 108"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `index i` — the row's position, bound by the same word `foreach` uses. `tagged` is the sum
        # of the ten indices: 45 if each row saw its own, 100 if every row saw the loop's final one.
        add_test(NAME codegen_entity_pass_index_is_the_row COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_pass.pol"
            "-DCONTAINS=tagged 45"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE LOOP IS INSIDE THE CALLEE, with the body lowered into it. A method compiled once and
        # called per row would give every number above and hand back the cost the construct exists
        # to remove — so the absence of a call in the pass's own body is the assertion, in the shape
        # `run_pass_matters_test` established in Wave 3.
        add_test(NAME pir_entity_pass_body_has_no_call_per_row COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_pass.pol"
            "-DFUNCTION=Particle.advance"
            "-DNEEDLE=call"
            "-DABSENT=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_fn_contains_test.cmake")

        # ...and that it IS a loop rather than a straight line the row count happened to fold away.
        add_test(NAME pir_entity_pass_body_is_a_loop COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_pass.pol"
            "-DFUNCTION=Particle.advance"
            "-DNEEDLE=pass.head"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_fn_contains_test.cmake")

        # AND THE REFUSAL. Each field becomes a column of N of them, so each needs a width decided
        # at the declaration; an array's length is a property of the value and not of the type.
        # Laid out anyway it would be a column of slice headers — a side table wearing a field, and
        # a side table is the type dissolving again, which is the exact failure AP-06 records.
        add_test(NAME sema_rejects_entity_field_with_no_width
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/entity_column_bad.pol")
        set_tests_properties(sema_rejects_entity_field_with_no_width PROPERTIES
            PASS_REGULAR_EXPRESSION "each become a COLUMN")

        # ---- `[Allow]` on a LOCAL, which used to be a syntax error (Wave 7) ----
        #
        # Every other place the compiler reports advice has somewhere to answer it — a class, a
        # method and a field all take an annotation. A local did not, so the one kind of advice that
        # is ABOUT a local could not be answered: change code that was right, or put the `[Allow]` on
        # the whole method and switch the rule off for every other local in it.
        #
        # THE ASSERTION IS THE SECOND LOCAL. `spare` is exempted and `forgotten` is not, in the same
        # method — so the exemption is about the DECLARATION and not about the scope. An
        # implementation that pushed the allow as a frame, which is how every other `[Allow]` here
        # works, would silence both and this test would still see a clean compile.
        add_test(NAME sema_allow_on_a_local_covers_only_that_local
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/allow_on_a_local.pol")
        set_tests_properties(sema_allow_on_a_local_covers_only_that_local PROPERTIES
            PASS_REGULAR_EXPRESSION "'forgotten' is declared mutable")

        # ...and that it RUNS, which is the half a `--check` cannot see: an annotation the parser
        # accepts and the lowering trips over would pass the check above and produce no program.
        add_test(NAME codegen_allow_on_a_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/allow_on_a_local.pol"
            "-DCONTAINS=spare 0 forgotten 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ---- `0B3C` fired on the shape its own fix recommends (Wave 7) ----
        #
        # The rule is "this keeps a raw address in a field" and its advice is to wrap the address in
        # a type that OWNS it and frees it — which is a class with an address in a field, so taking
        # the advice earned the same warning about the type written to answer it. Advice that refuses
        # its own remedy teaches a reader to stop reading it.
        #
        # A DESTRUCTOR is how a type says it owns something: the one place that runs when the object
        # dies, what a wrapper is for, and impossible to write by accident. The assertion is the
        # DISCRIMINATION — `Borrowed` is still reported — because a test that only checked the silent
        # half would pass on a rule that had been switched off entirely.
        add_test(NAME sema_address_owner_is_not_the_defect
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_owner_is_the_fix.pol")
        set_tests_properties(sema_address_owner_is_not_the_defect PROPERTIES
            PASS_REGULAR_EXPRESSION "'Borrowed.at' keeps a raw address")

        # ...and the other half of the discrimination, which a PASS_REGULAR_EXPRESSION cannot state:
        # `Mapped` must NOT be reported. `FAIL_REGULAR_EXPRESSION` is how the absence is asserted.
        add_test(NAME sema_address_owner_is_silent
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/address_owner_is_the_fix.pol")
        set_tests_properties(sema_address_owner_is_silent PROPERTIES
            FAIL_REGULAR_EXPRESSION "'Mapped.at' keeps a raw address")

        # ---- `0B2B` counted SITES and not allocations (Wave 7) ----
        #
        # "This region is set up and torn down for one object" is right about one object and was
        # counting `new ... in region r` sites in the source. A LOOP is one site and N allocations —
        # which is precisely the shape the rule's own reasoning calls earning its keep — so it
        # reported the case a region exists for, and taking the advice would replace one reservation
        # with N calls to the allocator.
        add_test(NAME sema_region_filled_by_a_loop_is_not_the_defect
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_filled_by_a_loop.pol")
        set_tests_properties(sema_region_filled_by_a_loop_is_not_the_defect PROPERTIES
            FAIL_REGULAR_EXPRESSION "region 'many' is set up")

        # ...and the discrimination: a region that really does hold one object is still reported.
        add_test(NAME sema_region_with_one_object_is_still_reported
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_filled_by_a_loop.pol")
        set_tests_properties(sema_region_with_one_object_is_still_reported PROPERTIES
            PASS_REGULAR_EXPRESSION "region 'lone' is set up")

        # ...and that the loop really did put eight objects in it, which the two checks above cannot
        # see: a rule silenced by an arena that quietly allocated nothing would satisfy both.
        add_test(NAME codegen_region_filled_by_a_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_filled_by_a_loop.pol"
            "-DCONTAINS=loop 28 lone 99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ---- `0B45` was silent on the textbook case, because it skipped classes (Wave 7) ----
        #
        # "The declared field order costs bytes that a layout would recover" was guarded by *only an
        # inline aggregate has a layout the author's order decides* — which confuses WHERE the bytes
        # live with WHETHER the order costs. A class's fields are laid out in the order written
        # exactly as a struct's, and the class case is the MORE expensive of the two: a struct's
        # holes cost a few bytes of stack per call, a class with a million instances carries a
        # million copies of them.
        #
        # The sample declares the same three fields twice, once as each, so the rule has to give the
        # same answer to a question the word `class` has nothing to do with. `WastefulObject` is the
        # one that was accepted.
        add_test(NAME sema_padding_costs_a_class_too
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/padding_costs_a_class_too.pol")
        set_tests_properties(sema_padding_costs_a_class_too PROPERTIES
            PASS_REGULAR_EXPRESSION "'WastefulObject' is 24 bytes as written and 16 widest-first")

        # ---- §11.7: the region binder's answer, held against the graph's ----
        #
        # `escapesToReceiver` -- which parameters a method stores into its receiver -- is read off
        # the AST by pattern. §11.5 needed the same fact for a different reason and computed it from
        # the instructions. Two independent answers to one question is the arrangement that catches
        # a wrong one, and it is what §11.9 already has with `GlobalDCE`.
        #
        # Run WITH `--region-binder`, because without it the AST side is never computed and the
        # comparison has one operand -- a test that passes by not asking is the failure mode this
        # whole group of files exists to avoid. And run over programs with real traffic in this
        # shape: `escape_to_the_frame` has a method that keeps its parameter and one that does not,
        # side by side, which is the discrimination the two sides must make the same way.
        add_test(NAME pir_region_binder_agrees_with_the_graph COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/escape_to_the_frame.pol"
            "-DPOLARONFLAGS=--region-binder"
            "-DMARKER=pir §11.7:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_oracle_agrees_test.cmake")

        # ...and over the program the region binder was BUILT for, which is where the pattern match
        # is at full stretch: borrows through fields, through calls and back out of them.
        add_test(NAME pir_region_binder_agrees_on_borrow_traffic COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_branch_ok.pol"
            "-DPOLARONFLAGS=--region-binder"
            "-DMARKER=pir §11.7:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_oracle_agrees_test.cmake")

        # ---- §11.6: allocation hoisting (docs/design/polaron-ir.md) ----
        #
        # `sum` allocates and deletes inside one iteration, so ten iterations share one frame slot.
        # `chain` holds the previous iteration's object across the back edge, so two are live at
        # once and one slot cannot hold two -- it stays on the heap. Both print their number, which
        # is the assertion that comes before any claim about what moved.
        add_test(NAME codegen_hoist_allocation_from_loop_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hoist_allocation_from_loop.pol"
            "-DEXPECTED=sum=45 chain=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        add_test(NAME pir_hoist_lifts_a_per_iteration_allocation COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hoist_allocation_from_loop.pol"
            "-DIN_FN=Main.sum"
            "-DABSENT=[heap]"
            "-DWITHOUT=fold,guards,immutable,dead,purity,reach,devirt"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pass_matters_test.cmake")

        # THE REFUSAL, and the one that costs a wrong program rather than a slow one: two objects
        # from two iterations live at the same moment cannot share one frame slot.
        add_test(NAME pir_hoist_leaves_an_overlapping_allocation COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hoist_allocation_from_loop.pol"
            "-DIN_FN=Main.chain"
            "-DNEEDLE=alloca %Cell @Cell [heap]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # ---- §12: the allocator hands back memory nothing else holds ----
        #
        # `noalias` on `__polaron_malloc`'s return, which is the single strongest fact an alias
        # analysis can be given and was missing for the most ordinary of reasons: three call sites
        # each asked for the symbol and none of them owned the fact about it. The row read 3 across
        # 892 sample programs -- three `unique class` declarations, the only other place it fires.
        add_test(NAME codegen_allocator_is_noalias COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interface_default.pol"
            "-DNEEDLE=declare noalias ptr @__polaron_malloc"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # ---- §11.8: devirtualisation (docs/design/polaron-ir.md) ----
        #
        # THE ANSWER MUST NOT MOVE. Before anything is claimed about what the pass removed, the
        # program has to still print what it printed -- a devirtualisation that reaches the wrong
        # body is not a slow program, it is a wrong one, and `bundle_inherit_runs` is the reminder
        # that the symptom is a plausible number rather than a crash.
        add_test(NAME codegen_devirt_sole_implementation_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_sole_implementation.pol"
            "-DEXPECTED=meter=21 rated=40 codec=7 sides=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THE PASS IS WHAT DOES IT. `run_pass_matters_test` compiles the program twice and
        # asserts the DIFFERENCE: the direct call appears only when `devirt` is in the pass list,
        # and the `vtable.load` it replaced appears only when it is not. Wave 3's exit criterion for
        # §11 is that every pass has a test which FAILS when that pass is turned off, and a presence
        # test alone does not do it -- the backend's inline cache emits the same direct call from
        # the other side, which is why this one reads PIR rather than the .ll.
        #
        # An interface with one implementer, checked here because it is the shape a program written
        # to interfaces most often has, and the one the lowering can never collapse on its own:
        # `Meter` implements nothing, so there is no body to call directly and it must dispatch.
        add_test(NAME pir_devirt_collapses_sole_interface COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_sole_implementation.pol"
            "-DNEEDLE=call i32 @Thermometer.reading"
            "-DABSENT=vtable.load ptr @Meter"
            "-DWITHOUT=fold,guards,immutable,dead,purity,reach"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pass_matters_test.cmake")

        # An abstract base with one concrete class under it. The empty slot in `Engine.vtable` is
        # not a second answer -- an abstract class is never the dynamic type of anything -- and a
        # pass that counted it as one would leave this case dispatching forever.
        add_test(NAME pir_devirt_collapses_abstract_base COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_sole_implementation.pol"
            "-DNEEDLE=call i32 @Diesel.power"
            "-DABSENT=vtable.load ptr @Engine"
            "-DWITHOUT=fold,guards,immutable,dead,purity,reach"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pass_matters_test.cmake")

        # A `sealed` base and its one permitted subclass.
        add_test(NAME pir_devirt_collapses_sealed_permits COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_sole_implementation.pol"
            "-DNEEDLE=call i32 @Passthrough.decode"
            "-DABSENT=vtable.load ptr @Codec"
            "-DWITHOUT=fold,guards,immutable,dead,purity,reach"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pass_matters_test.cmake")

        # AND THE OTHER SIDE OF A BUNDLE BOUNDARY, which is where this pass was wrong the day it was
        # written. `openWorld` was asked only of the compilation WRITING a library; using one has
        # the mirror-image problem, and it is worse, because a `.polh` names a bundle's public types
        # and nothing else. The library here ships an abstract `Source`, a public `Visible` and a
        # non-public `Internal`, and hands out an `Internal` through a factory. The consumer can name
        # two of those three, counted one implementation, and compiled `s.rate()` into
        # `@Visible.rate`: it printed 3 where the answer is 9, linked without a word, and ran.
        #
        # Which is Wave 2's `total = 17` seen in a mirror. Both halves of the boundary are now the
        # same question, and this is the machine asking it -- I had read the pass and believed it.
        add_test(NAME devirt_hidden_subclass_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DLIB=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_hidden_subclass_lib.pol"
            "-DAPP=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_hidden_subclass_app.pol"
            "-DEXPECTED=rate = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_polb_link_test.cmake")

        # AND THE REFUSAL, which is the assertion with something to lose. `Shape` has two
        # implementations of `sides`, so that call must stay a dispatch in BOTH compilations -- a
        # pass that collapses it is not an optimisation, it is a wrong program, and this is the only
        # test here that would notice.
        add_test(NAME pir_devirt_leaves_two_implementations_alone COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/devirt_sole_implementation.pol"
            "-DNEEDLE=vtable.load ptr @Shape"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # class const in a compile-time context (spec 28.1): static_assert + sibling ref via owner.
        add_test(NAME codegen_const_in_class_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_in_class_comptime.pol"
            "-DEXPECTED=d=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extern C function as a static class member (spec 26): LibC.abs(...) links to the C symbol.
        add_test(NAME codegen_extern_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/extern_in_class.pol"
            "-DEXPECTED=abs=42 labs=1000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # const as a static class member (spec 28.1): read through the owner as Type.NAME, folded.
        add_test(NAME codegen_const_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_in_class.pol"
            "-DEXPECTED=a=100 b=200 r=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # importing a class brings its literal suffixes into scope (spec 17.10): 64 kib -> Units.kib.
        add_test(NAME codegen_literal_suffix_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_suffix_import.pol"
            "-DEXPECTED=a=65536 b=2097152"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value struct returned by value (spec 11): two calls must not alias each other's result.
        add_test(NAME codegen_struct_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_return.pol"
            "-DEXPECTED=a=100 b=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # What a type answers about itself, and inside a generic about whatever was substituted:
        # typeName, sizeof, isValue, owns, and an enum's member count. Compile-time facts folded to
        # constants -- not reflection, which costs and is absent in freestanding. `sizeof` used to
        # demand a class, so `Box<int>` failed with "use of undeclared variable 'int'".
        add_test(NAME codegen_type_queries_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/type_queries.pol"
            "-DEXPECTED=int 4 Dog true 2 true false false true"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `T[N]` -- an array whose extent is in its type. It lives where it is declared (no `new`,
        # no header, no `delete`), `length()` is a constant rather than a header read, and the
        # bounds check is against that constant. `int[]` is untouched: the two differ only in
        # whether the length is part of the type, which is what the spelling says.
        add_test(NAME codegen_fixed_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fixed_array.pol"
            "-DEXPECTED=16 0 0 42 3 4 9 7 10 3 4 5 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And the storage really is inline: no allocation, no header, no free. `[16 x i32]` in the
        # IR is the whole claim -- a heap array would be a `ptr` and a call to the allocator.
        add_test(NAME codegen_fixed_array_is_inline COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fixed_array.pol"
            "-DNEEDLE=alloca [16 x i32]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # A generic keeps every statement and expression it was written with. `cloneStmt` and
        # `cloneExpr` build every instantiation and knew 27 of 36 statement kinds and 30 of 35
        # expression kinds; the other fourteen were dropped FROM THE INSTANCE in a program that still
        # compiled -- `synchronized` losing its lock, `yield` losing what made it a generator,
        # `await` no longer waiting, the array literal, `??`. And the implicit-`this` walk had the
        # same shape of hole, so a bare field name inside `??` was reported undeclared.
        add_test(NAME codegen_generic_keeps_its_body_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_keeps_its_body.pol"
            "-DEXPECTED=3 6 7 fallback"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `typealias` anywhere must not change what any other class IS. Declaring one runs every
        # class in the program through `cloneClass`, which listed the facts it copied -- so a fact
        # added to `ClassDecl` later was dropped in silence, from every class, in any program that
        # happened to contain an alias. It cost `layout`, `union`, `heap class`, `region class`,
        # `final`, every transformer marker and every `applies` clause; and one level down,
        # `cloneMember` was dropping `isProcedure` the same way.
        add_test(NAME codegen_alias_keeps_class_facts_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/alias_keeps_class_facts.pol"
            "-DEXPECTED=3 4 7 true"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A boolean interpolates as `true`/`false`, which is the only spelling the language has for
        # one. It fell through to the integer case and printed 1/0, so `$"{flag}"` and
        # `$"{flag.toString()}"` disagreed about the same value and the lossy one was the default.
        # Nine expectations in this file encoded that; they were the defect written down.
        add_test(NAME codegen_interp_boolean_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_boolean.pol"
            "-DEXPECTED=true false true false eq true lt false true"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String ==/!= compares content (spec 4), not the buffer pointer (weld-dogfood BUG2).
        add_test(NAME codegen_string_equality_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_equality.pol"
            "-DEXPECTED=eq=true ne=true same=false"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ArrayList<string> and ArrayList<String> are the same instantiation (weld-dogfood BUG1).
        add_test(NAME codegen_generic_string_alias_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_string_alias.pol"
            "-DEXPECTED=n=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # abstainfrom disables up to the NEXT label, not the method end (weld-dogfood BUG5).
        add_test(NAME codegen_abstain_next_label_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/abstain_next_label.pol"
            "-DEXPECTED=AB|B"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Value structs inside aggregates (spec 11): a class field, an array element, a nested struct,
        # and an operator returning a struct by value. Regression guard for the 2026-07 codegen fixes
        # (operator sret dispatch + owned-heap promotion of `new` into a value-aggregate slot).
        add_test(NAME codegen_struct_in_aggregate_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_in_aggregate.pol"
            "-DEXPECTED=field=10,20 elem=30,40 nested=5,7 op=7,16 fbf=99,88 mret=77,66"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime literal as a class member (spec 17.10): qualified call Units.kib(N) + overload.
        add_test(NAME codegen_literal_in_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_in_class.pol"
            "-DEXPECTED=a=65536 b=2048 c=1536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # literal-suffix overloading by parameter type (spec 17.10 rule 6): scaled(int)/scaled(double).
        add_test(NAME codegen_literal_overload_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literal_overload.pol"
            "-DEXPECTED=a=10 b=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # built-in enum parse() (spec 12.5): EnumType.parse(s) -> Option<EnumType> (Some/None).
        add_test(NAME codegen_enum_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_parse.pol"
            "-DEXPECTED=r1=1 r2=-1 mars=10 pluto=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # built-in enum methods (spec 12.5): count() and random() (a value in declaration range).
        add_test(NAME codegen_enum_random_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_random.pol"
            "-DEXPECTED=count=4 valid=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match expression block arms (spec 16.2): `-> { ... yield expr; }` multi-line arms.
        add_test(NAME codegen_match_expr_block_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_expr_block.pol"
            "-DEXPECTED=a=27 b=36"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Channel.select with a timeout (spec 20.4): an empty channel makes select fire the timeout.
        add_test(NAME codegen_channel_select_timeout_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/channel_select_timeout.pol"
            "-DEXPECTED=timeout"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sizeof(Type) / sizeof(expr) (spec, issue #7): the byte size of a type or expression.
        # Decimal primitive (spec 34): exact fixed-point arithmetic, comparison and conversions.
        add_test(NAME codegen_decimal_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/decimal.pol"
            "-DCONTAINS=total=59.97 tax=4.7976 expensive=1 whole=59 half=2.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflection field get/set (spec 31): Field.get/set read and write a field through Object.
        add_test(NAME codegen_reflect_field_getset_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_field_getset.pol"
            "-DEXPECTED=before=10 after=99 direct=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # AUTOMATIC SERIALIZATION WITH NO MACRO AND NO GENERATED CODE: `System.Serialize` walks a
        # type's fields through reflection, asks each what it is DECLARED as (Field.typeName, added
        # for this) and writes it. Adding a field to `Player` changes the JSON with nothing else
        # recompiled. Also covers `[Serializable]` and reflection inside a generic method.
        add_test(NAME codegen_auto_serialize_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/auto_serialize.pol"
            "-DEXPECTED=shape=Player{name:String,score:int,alive:boolean,ratio:double} json={\"name\":\"Ada\",\"score\":42,\"alive\":true,\"ratio\":0.5} serializable=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # VALIDATION RULES WRITTEN ON THE FIELDS THEY ARE ABOUT (System.Validate): the rules are
        # annotations, the checker is one reflective walk, and there is no processor, macro or builder
        # DSL anywhere. Covers Field.annotations() and Annotation.args() -- a rule that carries a
        # value (`[Range(min: 1, max: 130)]`) is unwritable without both.
        add_test(NAME codegen_validate_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/validate_annotations.pol"
            "-DEXPECTED=good=1 problems=0 bad=4 name: must not be empty age: must be between 1 and 130 email: is not an address score: must be positive"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A PROGRAM ASSEMBLED FROM PARTS THAT DO NOT NAME EACH OTHER'S CONSTRUCTORS (System.Inject):
        # the container reads a type's fields, sees what each is declared as, and builds what it must.
        # Registered types are shared, so `Report` and `Store` get the SAME Clock -- which is what the
        # last line checks, because a container that quietly builds two is a different program.
        add_test(NAME codegen_inject_services_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inject_services.pol"
            "-DEXPECTED=wired=1 unwired=0 stamp=100 stored=1 at=100 shared=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A CONTAINER WHOSE ELEMENTS LIVE IN ONE ARENA AND WHOSE ARENA KNOWS WHAT MAY GO IN IT
        # (System.Arena). A thousand nodes: one allocation for the arena, a pointer bump each, one
        # release for all of them. The refusal half is sema_rejects_wrong_type_in_region_field.
        add_test(NAME codegen_arena_pool_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arena_pool.pol"
            "-DEXPECTED=made=1000 first=0 last=999 sum=499500 after=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # TWO OBJECTS, FIELD BY FIELD (System.Compare): equal, and if not, WHERE. Also pins that the
        # language's own deep copy and the reflective walk agree -- `Player c = a;` IS the clone, which
        # is why there is no reflective deepClone beside these.
        add_test(NAME codegen_compare_objects_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/compare_objects.pol"
            "-DEXPECTED=same=1 copy=1 changes=2 name: Ada vs Grace score: 41 vs 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SORTING A RAW ARRAY (System.Arrays), which the library had no way to do: `ArrayList.sortedBy`
        # was the only sort in 305 types, so an `int[]` had to become an ArrayList to be put in order.
        # One generic method per operation with a comparator (no overloading), plus `Ints` for the
        # order nobody disagrees about.
        add_test(NAME codegen_arrays_sort_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arrays_sort.pol"
            "-DEXPECTED=ints=0123456789 sorted=1 found=4 missing=-1 sum=45 min=0 max=9 words=apple/banana/cherry/date desc=9876543210"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # READING BACK AN ISO-8601 TIMESTAMP, which the library could write and not read -- half a
        # format. Tested as a ROUND TRIP (format, parse, format) because that is the property a caller
        # depends on, and it catches an offset applied in the wrong direction, which reading the
        # fields would not.
        add_test(NAME codegen_time_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/time_parse.pol"
            "-DEXPECTED=date=2026-08-15 dow=6 valid=1 bad=0 utc=2026-07-03T14:05:09Z round=2026-07-03T14:05:09-03:00 same=1 shifted=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHUFFLING AND PICKING: the generator could produce numbers and there was nothing to do with
        # them to an array. Asserts the PROPERTIES a shuffle must have -- it is a permutation, it is
        # deterministic for a seed, it moved something -- rather than a particular order, which would
        # only pin this generator's internals.
        add_test(NAME codegen_random_shuffle_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/random_shuffle.pol"
            "-DEXPECTED=same=1 moved=1 deterministic=1 picked=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # HOW A LAZY PIPELINE ENDS AND HOW IT IS LIMITED: `Stream` had filter/map/fold and no `toList`,
        # so a chain could only be walked into a list the caller had already made. The counters in the
        # sample are the only honest test of laziness -- an eager `take` would print the same numbers
        # and touch all ten elements.
        add_test(NAME codegen_stream_adapters_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stream_adapters.pol"
            "-DEXPECTED=first3=2/4/6 pulled=6 after2=6/8/10 under7=1/2/3/4/5/6 pulledWhile=7 any=1 all=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # TWO SYNCHRONISERS THE LIBRARY SHIPPED AND NOTHING EXERCISED. Found by counting: of 285
        # standard library types, 25 were touched by no sample, and these are the two where being
        # wrong costs the most. Both are checked by what they make IMPOSSIBLE -- a thread released
        # early sees a smaller count, a reader that catches a half-written pair reports it -- rather
        # than by timing, which is how a concurrency test becomes a coin toss. Ran 8x clean.
        add_test(NAME codegen_barrier_rwlock_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/barrier_rwlock.pol"
            "-DEXPECTED=parties=4 minSeen=4 writes=400 consistent=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE REST OF WHAT NOTHING RAN: zlib (round trip), Mass (two spellings of one quantity agree),
        # the exponential distribution (CDF from 0 to 1, quantile inverts it), and a String-keyed
        # HashMap. Properties rather than magic numbers, so the test says what is required and not
        # merely what happened once.
        add_test(NAME codegen_untested_corners_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/untested_corners.pol"
            "-DEXPECTED=zlib=1 mass=1 exp=1 map=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE VERBS THE COLLECTIONS WERE MISSING: ArrayList.sort in place (sortedBy duplicates the
        # list), addAll/reverse/lastIndexOf, HashMap.keys()/values()/clear(). And a LIST OF BOOLEANS,
        # which did not compile at all -- a collection requires `equalsKey` of its element type and
        # boolean was left out of the Hashable builtins as "not a useful map key", which is true and
        # is the wrong test.
        add_test(NAME codegen_collection_verbs_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_verbs.pol"
            "-DEXPECTED=sorted=1/2/3/5/8 reversed=8/5/3/2/1 last=2 all=7 keys=3 cleared=0 flags=3 firstOff=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # EVERY COLLECTION OVER EVERY ELEMENT TYPE. Written as a probe, kept as a test: it found three
        # holes with nothing in common on the surface and everything underneath -- a collection asks
        # `equalsKey` (a map also `hash`) of its element type, and boolean, char and double could not
        # answer, so `ArrayList<boolean>`, `HashMap<char,int>` and `ArrayList<double>` did not compile.
        add_test(NAME codegen_collection_matrix_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_matrix.pol"
            "-DEXPECTED=counts=21 chars=2 doubles=1 bools=1 front=first"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # EMITTING ONLY WHAT THE PROGRAM CAN REACH, checked against the answer that already exists.
        #
        # `emitFunctions` used to build a body for every method of every class -- all ~320 of the
        # standard library -- and GlobalDCE then deleted what nothing reached: on hello_world, 323
        # classes emitted for TWO surviving functions, which is 143 of its 330 ms spent producing IR
        # to throw away. Now the reachable set is computed first, from edges the analyzer records
        # where it already resolves each name.
        #
        # The risk of that is a missed edge, which is a symbol that is not there -- and it is testable,
        # because LLVM's GlobalDCE computes the true answer on the IR. So each of these compiles one
        # program twice, with the pass on and off, and requires the two FINAL modules to name exactly
        # the same things. DCE runs either way, so an over-approximation still lands on the identical
        # result and a hole lands on a smaller one.
        #
        # One sample per KIND OF ROOT, because that is where the holes were: an ordinary program, a
        # polymorphic one (vtables reference bodies), literal suffixes (`64 kilobytes` builds a
        # ByteSize through a constructor nobody calls), reflection (a Type token takes every method's
        # address), unimport (the code table anchors by name), the test runner, and a freestanding
        # program (whose `heap class` is called by generated code alone).
        foreach(_reach hello_world shapes regions reflect_typeof unimport collection_matrix
                       inject_services string_freestanding)
            add_test(NAME reachability_matches_dce_${_reach} COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/${_reach}.pol"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/reachability_oracle.cmake")
        endforeach()

        # STATE THAT OUTLIVES THE OBJECT HOLDING IT (System.Persist), which no other language's standard
        # library can offer: a memo whose answers survive the memo, and an append-only log that
        # survives its writer, both destroyed and rebuilt on every call. Also pins the property a
        # SCHEMA MIGRATION must have -- rewriting the old entries does not change what they add up to.
        # Neither class is `eternal`: that waives the release obligation, which is not a promise a
        # library may make for its user.
        add_test(NAME codegen_persist_memo_events_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_memo_events.pol"
            "-DEXPECTED=memo: size=5 misses=5 hits=6 answer=25 log: events=6 balance=140 migrated=2 balance=140 version=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WHAT YOU DO WITH A RESULT OR AN OPTION WITHOUT OPENING IT. They carried `isOk`/`isSome` and
        # nothing else, so every use had to `match` -- right when a program branches on the outcome,
        # ceremony when it only wants a default. On the abstract base where both variants answer alike
        # and overridden where they differ, so `match` and these cannot drift apart.
        add_test(NAME codegen_option_result_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option_result_ops.pol"
            "-DEXPECTED=ok=7 orElse=7 err=404 errOr=404 isErr=1 some=9 none=-1 big=1 small=0 missing=0 matched: ok 7 / err 404"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A GENERIC BASE'S CONCRETE METHOD CALLING ITS OWN ABSTRACT ONE, over a POINTER type argument.
        # `Box$Node*` ends in a `*` that belongs to the class NAME, and the virtual-dispatch decision
        # stripped it with `baseType` -- right for `Dog*`, wrong here -- landing on `Box$Node`, no
        # class at all, so the call fell through to the direct path where an abstract method has no
        # body. Found by giving `Option<T>` an `isNone()`.
        add_test(NAME codegen_generic_ptr_template_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_ptr_template_method.pol"
            "-DEXPECTED=int: full=1 empty=0 ptr: full=1 empty=0 hollow: full=0 empty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE THIRD OF THE RESILIENCE TRIO (System.App.Retry): a breaker says when to stop calling and
        # a bucket how often, and neither says what to do about the call that just failed. Pins the two
        # things the hand-written version gets wrong -- backoff with no CAP (an hour by the twelfth
        # attempt) and capping AFTER multiplying (a long wraps and the delay comes back small, checked
        # at attempt 40).
        add_test(NAME codegen_retry_backoff_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/retry_backoff.pol"
            "-DEXPECTED=curve=100/200/400/800/1600/2000/2000 far=2000 attempts: allow=1 left=3 -> allow=0 left=0 reset=3 jitter: none=800 half=600 full=404 with breaker: tries=2 state=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE SERVER SIDE OF HTTP (System.Net), the half that was missing: HttpRequest builds and
        # HttpResponse reads, both the CLIENT's view, and a server had only `accept()`. Parsing,
        # routing and writing are separate from the I/O, so this test hands them TEXT and opens no
        # socket -- a server that can only be tested by being run is a server nobody tests.
        add_test(NAME codegen_http_router_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/http_router.pol"
            "-DEXPECTED=parsed: verb=GET path=/users/42 q=1 host=example.com routed: 200 {\"id\":42,\"full\":\"1\"} missing: 404 not found wrong verb: 405 method not allowed raw: HTTP/1.1 201 Created | len=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WRITING TO A TERMINAL (System.Terminal): the library had `println` and nothing else, so every
        # command-line tool reinvented colour and alignment slightly differently. `Style` decides what
        # text looks like and `Table` where it goes, and they are separate because THE WIDTH OF A
        # STYLED STRING IS NOT ITS LENGTH -- a table measuring with `length()` pushes every row after a
        # coloured cell out of line. The alignment is checked BY THE PROGRAM (every line the same
        # on-screen width), since the harness collapses whitespace and cannot carry column positions.
        add_test(NAME codegen_terminal_table_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/terminal_table.pol"
            "-DCONTAINS=styled=12 wide=3 stripped=red"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_terminal_table_aligns COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/terminal_table.pol"
            "-DCONTAINS=lines=4 aligned=1 width=19 rightAligned=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflection over annotations (spec 31): Type.annotations() lists a class's applied annotations.
        add_test(NAME codegen_reflect_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_annotations.pol"
            "-DCONTAINS=count=2 Marker Audited"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Method-level annotation reflection (spec 31): Method.annotations() lists a method's annotations.
        add_test(NAME codegen_method_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/method_annotations.pol"
            "-DCONTAINS=save ann=Audited count=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # PriorityQueue<T> (spec 34.1): a min-heap; polling yields ascending order -> 12345.
        add_test(NAME codegen_priority_queue_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/priority_queue.pol"
            "-DCONTAINS=size=5 peek=1 12345"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # for-in over a collection directly (spec 34): iterates a toArray() snapshot -> sum=60 total=6.
        add_test(NAME codegen_foreach_collection_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_collection.pol"
            "-DCONTAINS=sum=60 total=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Functional pipeline on a collection (spec 34): ArrayList forEach/filter/map/reduce with lambdas.
        add_test(NAME codegen_collection_functional_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_functional.pol"
            "-DCONTAINS=1 2 3 4 5 evens=2 e0=2 e1=4 d0=2 d4=10 sum=15 anyOdd=1 allEven=0 big=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arithmetic with no correct answer is an EXCEPTION in a hosted program (catchable, so a caller
        # decides what a bad divisor means) and a PANIC in freestanding, where there is no exception
        # machinery. Both used to terminate the process even when hosted, so a division whose divisor came
        # from input could not be handled at all. Also checks the BASE class catches the specific one.
        add_test(NAME codegen_arith_faults_catchable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arith_faults_catchable.pol"
            "-DEXPECTED=div: division by zero ovf: integer overflow survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `checked()` must trap on UNSIGNED overflow too (it was silently dropped for unsigned operands)
        # (`if (checkedArith_ && !uns && ...)`), so the one arithmetic opt-in the language has did nothing
        # on an unsigned type -- and said nothing about it.
        add_test(NAME codegen_checked_unsigned_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checked_unsigned_bad.pol"
            "-DEXPECTED=caught: integer overflow survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # No-UB: ArrayList.get/set past the logical size (but inside spare capacity) must panic cleanly
        # rather than return an uninitialized slot. The raw-array check only catches index >= capacity.
        add_test(NAME codegen_arraylist_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_oob_bad.pol"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Same guard on the mutating index accessor: removeAt past the size must panic, not silently
        # corrupt the count. insertAt shares the mechanism; valid paths are covered by the wider suite.
        add_test(NAME codegen_arraylist_removeat_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_removeat_oob_bad.pol"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Slice is a non-owning window over an array: get/set past the window length must panic even when
        # the index still lands inside the backing array (else it silently reads/writes a neighbour).
        add_test(NAME codegen_slice_oob_panics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/slice_oob_bad.pol"
            "-DPANIC=array index out of bounds"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # No-UB: an allocation the machine cannot serve must stop the program saying so. The runtime
        # used to return NULL and nothing downstream checks it, so exhaustion surfaced as an access
        # violation at address zero in unrelated code.
        add_test(NAME codegen_out_of_memory_panics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/out_of_memory_bad.pol"
            "-DPANIC=out of memory"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # Companion: the same guard must leave valid in-bounds access untouched, including across a grow.
        add_test(NAME codegen_arraylist_bounds_ok_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist_bounds_ok.pol"
            "-DCONTAINS=size=10 first=100 last=900 sum=1204"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Args + Range (spec 34): command-line option parsing and integer range lists.
        add_test(NAME codegen_args_range_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/args_range.pol"
            "-DCONTAINS=hasN=1 n=42 up=5 r0=0 r3=9 rn=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # HTTP over Socket (spec 34): request building + response parsing (status/body/header).
        add_test(NAME codegen_http_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/http_parse.pol"
            "-DCONTAINS=status=200 body=hello ctype=text/plain reqOk=1 hostOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Nested generics (spec 15.1): generic Event<T> with an ArrayList<Handler<T>> field instantiates.
        add_test(NAME codegen_generic_event_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_event.pol"
            "-DCONTAINS=total=15 nsub=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Event dispatch (spec 34): Signal/IntEvent/StringEvent publish to subscribed handler functions.
        add_test(NAME codegen_events_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/events.pol"
            "-DCONTAINS=msg=hi total=17 nsig=1 ntick=2 nmsg=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Entity-component-system (spec 34): World entity ids + recycling, ComponentStore sparse set, system.
        add_test(NAME codegen_ecs_world_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecs_world.pol"
            "-DCONTAINS=a=1,2 c=4,4 size=3 bDead=0 dReuse=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Char utils + Roman numerals + percentile (spec 4/34.6): case/digit, 2024<->Roman, percentiles.
        add_test(NAME codegen_chars_roman_pct_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/chars_roman_pct.pol"
            "-DCONTAINS=up=A lo=z dig=1 rom=MMXXIV back=2024 p50=3 p25=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL encoding + word wrap + digit utils (spec 4/34.6): percent-encode, greedy wrap, digit math.
        add_test(NAME codegen_url_wrap_digits_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/url_wrap_digits.pol"
            "-DCONTAINS=enc=a%20b%21 dec=a b! nl=2 l0=the quick ds=6 rd=321 pal=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Edit distance + determinant + stats (spec 4/34.6): Levenshtein, Bareiss det, sum/range/mode.
        add_test(NAME codegen_textdist_det_stats_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/textdist_det_stats.pol"
            "-DCONTAINS=lev=3 det=-2 sum=14 range=2 mode=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Templating + CSV (spec 34): named placeholder substitution and quoted-field CSV parsing.
        add_test(NAME codegen_template_csv_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/template_csv.pol"
            "-DCONTAINS=tpl=Hi Ada, n=42, {miss} nf=3 f1=b,c"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deterministic PRNG + modpow (spec 34.6): reproducible Xorshift sequence, modular exponentiation.
        add_test(NAME codegen_rng_modpow_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rng_modpow.pol"
            "-DCONTAINS=r1=270369 det=1 range=1 mp=24 mp2=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Sieve + Bloom filter + deque (spec 34): primes up to 30, membership test, double-ended queue.
        add_test(NAME codegen_sieve_bloom_deque_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sieve_bloom_deque.pol"
            "-DCONTAINS=p2=1 p15=0 cnt=10 cat=1 fish=0 pf=0 pb=2 front=1 sz=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arena + heap + union-find (spec 17/34.1): stale-handle rejection, min-heap order, disjoint sets.
        add_test(NAME codegen_arena_heap_uf_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arena_heap_uf.pol"
            "-DCONTAINS=sm1=10 stale2=0 sm3=99 pop=1 c02=1 grp=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Adler-32 checksum (spec 4): zlib checksum of "abc".
        add_test(NAME codegen_adler_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/adler.pol"
            "-DCONTAINS=adler=38600999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RLE compression + expression evaluator (spec 34): round-trip RLE and precedence/paren arithmetic.
        add_test(NAME codegen_rle_calc_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rle_calc.pol"
            "-DCONTAINS=enc=a3b4c1 rt=1 a=14 b=20 c=60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Polynomials + integer vectors (spec 34.6): Horner eval/derivative, dot product, squared norm.
        add_test(NAME codegen_poly_vector_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/poly_vector.pol"
            "-DCONTAINS=eval=17 deg=2 dval=14 dot=32 norm=14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Autodiff + matrices (spec 34.6): Dual forward-mode derivatives, Matrix multiply/transpose.
        add_test(NAME codegen_autodiff_matrix_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/autodiff_matrix.pol"
            "-DCONTAINS=fval=30 fder=28 c00=19 c11=50 t01=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More math (spec 34.6): IntMath combinatorics (nCr/nPr), Stats variance/stddev/median.
        add_test(NAME codegen_math_extras_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_extras.pol"
            "-DCONTAINS=c52=10 c104=210 p53=60 var=2 std=1 med=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Leveled logging (spec 34): Logger drops messages below the configured level.
        add_test(NAME codegen_logger_levels_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/logger_levels.pol"
            "-DCONTAINS=[INFO] app: hello [WARN] app: careful [ERROR] app: boom"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checksums + dates (spec 4/34): CRC-32 and FNV-1a, Date leap/epoch/dayOfWeek/addDays.
        add_test(NAME codegen_digest_date_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/digest_date.pol"
            "-DCONTAINS=crc=891568578 fnv=440920331 leap=1 feb=29 epoch=10957 dow=6 add=2000-2-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Hex/Base64 encoding (spec 4): encode bytes to text and decode back, round-tripping.
        add_test(NAME codegen_encoding_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/encoding_hex_base64.pol"
            "-DCONTAINS=hex=414243 back=ABC b64=TWFu dec=Man decMa=Ma decM=M"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Math kit (spec 34.6): IntMath integer helpers, Rational, Complex, Stats.
        add_test(NAME codegen_math_kit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_kit.pol"
            "-DCONTAINS=gcd=6 lcm=12 fact=120 p7=1 p8=0 isqrt=7 ipow=1024 rat=5/6 cx=-5+10i sum=66 mean=13 min=4 max=23"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pointers in generic collections (spec 17.8/15.1): ArrayList<Node*>/HashMap<int,Node*> share refs.
        add_test(NAME codegen_pointer_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_collections.pol"
            "-DCONTAINS=a=99 b=20 mapB=20 shared=99 size=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `delete` of a generic collection with a pointer type argument (ArrayList<Node*>,
        # HashMap<int,Node*>) is accepted, frees the collection, and leaves the borrowed pointees alone.
        add_test(NAME codegen_delete_pointer_collection_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_pointer_collection.pol"
            "-DCONTAINS=deleted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Arbitrary-base integer conversion (spec 4), bases 2..36, pure Polaron.
        add_test(NAME codegen_radix_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/radix.pol"
            "-DCONTAINS=hex=ff bin=1010 zero=0 neg=-ff"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Ascii85 / Base85 (spec 4) in pure Polaron, encode/decode round-trip ("Man " -> 9jqo^).
        add_test(NAME codegen_ascii85_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ascii85.pol"
            "-DCONTAINS=man=9jqo^ roundtrip=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Base58 (Bitcoin alphabet, spec 4) in pure Polaron, encode/decode round-trip.
        add_test(NAME codegen_base58_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/base58.pol"
            "-DCONTAINS=enc=9Ajdvzr roundtrip=1 zeros=111"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-224 (FIPS 180-4) in pure Polaron: verified against the "abc" and "" reference vectors.
        add_test(NAME codegen_sha224_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha224.pol"
            "-DCONTAINS=abc=23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-256 (FIPS 180-4) in pure Polaron: verified against the "abc" and "" reference vectors.
        add_test(NAME codegen_sha256_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha256.pol"
            "-DCONTAINS=abc=ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # HMAC-SHA256 (RFC 2104) and Base32 (RFC 4648) in pure Polaron, verified against reference vectors.
        add_test(NAME codegen_hmac_base32_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hmac_base32.pol"
            "-DCONTAINS=hmac=f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Huffman coding (spec 34.1) in pure Polaron: build prefix codes, encode to bits, decode round-trip.
        add_test(NAME codegen_huffman_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/huffman.pol"
            "-DCONTAINS=rawbits=424 encbits=204 match=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RFC 4122 UUID v4 (seeded) and semantic-version parsing/comparison, both pure Polaron.
        add_test(NAME codegen_uuid_semver_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/uuid_semver.pol"
            "-DCONTAINS=uuid=9797c112-41d7-4d76-af35-925007fe8286 valid=1 v=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SHA-1 (FIPS 180-1) and a minimal INI parser, both pure Polaron, verified against reference vectors.
        add_test(NAME codegen_sha1_ini_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sha1_ini.pol"
            "-DCONTAINS=sha1abc=a9993e364706816aba3e25717850c26c9cd0d89d"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Immutable list and enum-ordinal-keyed map/set (spec 34.1), pure Polaron.
        add_test(NAME codegen_enum_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_collections.pol"
            "-DCONTAINS=em0=red has1=0 emsize=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Frequency counter / multiset of ints (spec 34.1): count/mostCommon/total, pure Polaron.
        add_test(NAME codegen_int_counter_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/int_counter.pol"
            "-DCONTAINS=c3=3 c2=2 c9=0 common=3 max=3 total=6 distinct=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Navigable sorted int set (spec 34.1): floor/ceiling/rank/kth, pure Polaron.
        add_test(NAME codegen_sorted_int_set_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sorted_int_set.pol"
            "-DCONTAINS=size=5 has3=1 has4=0 floor4=3 ceil4=5 rank5=3 k0=1 k4=8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Comparator combinators over closures (spec 34.1): naturalInt/reversed/thenComparing, pure Polaron.
        add_test(NAME codegen_comparators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comparators.pol"
            "-DCONTAINS=asc=1,2,3 desc=3,2,1 tie=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quickselect k-th smallest (spec 34.1), pure Polaron.
        add_test(NAME codegen_quickselect_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/quickselect.pol"
            "-DCONTAINS=min=1 k3=3 max=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Min-tracking stack and sliding-window maximum (spec 34.1), pure Polaron.
        add_test(NAME codegen_minstack_window_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/minstack_window.pol"
            "-DCONTAINS=min1=1 popped=1 min2=2 size=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interval merging and Kadane's max subarray (spec 34.1), pure Polaron.
        add_test(NAME codegen_merge_kadane_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/merge_kadane.pol"
            "-DCONTAINS=merged=3 covered=10 first=1-6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 2D Fenwick tree (grid range sums) and Fletcher-16 checksum (spec 34.1/4), pure Polaron.
        add_test(NAME codegen_fenwick2d_fletcher_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fenwick2d_fletcher.pol"
            "-DCONTAINS=total=11 mid=8 row0=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 2D spatial hash grid (spec 34.1) for broad-phase rectangle queries, pure Polaron.
        add_test(NAME codegen_spatial_grid_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/spatial_grid.pol"
            "-DCONTAINS=box20=3 box9=2 far=1 all=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Directed graph (spec 34.1): topological sort (Kahn) and cycle detection, pure Polaron.
        add_test(NAME codegen_digraph_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/digraph.pol"
            "-DCONTAINS=order=0,1,2,3 cnt=4 cycle=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Generic bidirectional map and multimap (spec 34) in pure Polaron.
        add_test(NAME codegen_bimap_multimap_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bimap_multimap.pol"
            "-DCONTAINS=byKey=2 byVal=one size=2 has=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Range-query structures (spec 34.1): Fenwick (prefix/range sums), iterative segment tree, sparse table.
        add_test(NAME codegen_range_queries_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/range_queries.pol"
            "-DCONTAINS=fw_pre7=46 fw_r2to5=28"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Graph algorithms (Dijkstra shortest paths + Prim MST) and an O(1) LRU cache, both pure Polaron.
        add_test(NAME codegen_graph_lru_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/graph_lru.pol"
            "-DCONTAINS=dist=0,3,1,4,7 mst=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Adler-32 checksum (RFC 1950 / zlib) in pure Polaron, verified against reference vectors.
        add_test(NAME codegen_adler32_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/adler32.pol"
            "-DCONTAINS=abc=38600999 wiki=300286872 empty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # MD5 (RFC 1321) and CRC-16/XMODEM in pure Polaron, verified against reference vectors.
        add_test(NAME codegen_md5_crc_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/md5_crc.pol"
            "-DCONTAINS=md5abc=900150983cd24fb0d6963f7d28e17f72"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A finite state machine and glob/wildcard matching (spec 34), both pure Polaron.
        add_test(NAME codegen_statemachine_glob_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/statemachine_glob.pol"
            "-DCONTAINS=t1=1 t2=0 mid=unlocked end=locked"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Numerical linear algebra (Gaussian elimination) + Welford streaming statistics, both pure Polaron.
        add_test(NAME codegen_math_sci_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_sci.pol"
            "-DCONTAINS=x=1 y=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # LZ77 sliding-window compression (round-trip) and Soundex phonetic codes, both pure Polaron.
        add_test(NAME codegen_lz77_soundex_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lz77_soundex.pol"
            "-DCONTAINS=raw=35 toks=7 ok=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Chinese remainder theorem and integer factorization (spec 34.6), pure Polaron.
        add_test(NAME codegen_crt_factorize_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/crt_factorize.pol"
            "-DCONTAINS=crt=23"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Number theory (gcd/lcm/modpow/Miller-Rabin/modInverse) + combinatorics, both pure Polaron.
        add_test(NAME codegen_number_theory_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/number_theory.pol"
            "-DCONTAINS=p97=1 p100=0 p7919=1 modpow=24"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Classic algorithms (spec 34.1): 0/1 knapsack, longest common subsequence, interval scheduling.
        add_test(NAME codegen_algorithms_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/algorithms.pol"
            "-DCONTAINS=knap=9 lcs=4 sched=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Identifier case conversion (spec 34): camelCase <-> snake_case/kebab-case, pure Polaron.
        add_test(NAME codegen_case_convert_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/case_convert.pol"
            "-DCONTAINS=snake=hello_world kebab=hello-world camel=helloWorld camel2=fooBarBaz"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A variadic extern C function (spec 26): trailing ... in a class-member extern (printf).
        add_test(NAME codegen_ffi_variadic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_variadic.pol"
            "-DCONTAINS=x=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport with a timeout(...) modifier (spec 30.6): parses; the timeout is a no-op in-process.
        add_test(NAME codegen_unimport_timeout_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_timeout.pol"
            "-DCONTAINS=new caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator ++/-- overload dispatch (spec 6.5): c++ reassigns c to the operator's result.
        add_test(NAME codegen_operator_incr_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_incr.pol"
            "-DCONTAINS=n=6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `v++` on a value struct moves the operator's sret result back into the variable's
        # storage (freeing the old value's owned fields first) -- 1000 iterations must not corrupt.
        add_test(NAME codegen_struct_incr_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_incr.pol"
            "-DEXPECTED=n=1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct that OWNS an int[] compiles (synthesized equalsKey no longer crashes
        # on `array == array`) and `v++` moves the owned array correctly over 1000 iterations.
        add_test(NAME codegen_struct_incr_owned_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_incr_owned.pol"
            "-DEXPECTED=n=1000 first=1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: == / != on arrays is identity comparison (heap-block pointer), not a codegen crash.
        add_test(NAME codegen_array_equality_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_equality.pol"
            "-DEXPECTED=r=1011"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A record may implement a generic interface (spec 10): record Point3D implements Ordered<Point3D>.
        add_test(NAME codegen_record_generic_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_generic_iface.pol"
            "-DCONTAINS=cmp=-4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `symbol("...")` separates the Polaron name from the linker name. Without it the C symbol IS
        # the method's name, so a binding could not be given a name of its own -- the reason the FFI
        # declarations were rebuilt (docs/design/ffi-model.md).
        add_test(NAME codegen_ffi_symbol_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_symbol.pol"
            "-DCONTAINS=magnitude = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The FFI axis is the LANGUAGE, not the calling convention: cdecl/cppdecl/rustdecl/zigdecl.
        # `rustdecl` lowers to the C ABI today (neither Rust nor Zig has a stable native one), and this
        # test is what keeps that documented behaviour honest rather than merely asserted.
        add_test(NAME codegen_ffi_languages_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_languages.pol"
            "-DCONTAINS=abs = 42, labs = 1000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NON-STATIC extern passes the object as the foreign function's first argument -- the hidden
        # `this` of a C++ member function, and the object-oriented-C idiom. It used to die at the LLVM
        # verifier, because the call site already passed a receiver the declaration did not have.
        add_test(NAME codegen_ffi_receiver_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_receiver.pol"
            "-DCONTAINS=12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A REGION CLASS A: every instance comes from ONE region owned by the type. The point is not
        # allocation speed (regions already beat malloc 12x) -- it is TOTALITY, which is what would let
        # `unimport` answer "is any A alive?" in O(1), let every instance be walked linearly, and let an
        # `A*` become a 32-bit offset. See docs/design/region-classes.md.
        add_test(NAME codegen_region_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class.pol"
            "-DCONTAINS=3 nodes, sum = 60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bstract region class declares a region shared by the whole family beneath it -- the phase
        # arena (a compiler's AST nodes, a frame's scratch objects) that a single-type region cannot
        # express. Ident and Call are different sizes and reach ONE block, the root's.
        add_test(NAME codegen_region_class_family_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_family.pol"
            "-DCONTAINS=ident=7 call=42 total=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The author is not the only one who allocates an A: assignment is a deep copy, and the copy
        # the COMPILER makes went to the stack (a local) or the heap (a field). Outside the arena, a
        # narrow `A*` field storing `(i32)(p - base)` is a wild pointer -- this program used to die
        # with an access violation and no diagnostic.
        add_test(NAME codegen_region_class_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_copy.pol"
            "-DCONTAINS=original=4 copy=77 through-field=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `new A()` with no placement parses as location "stack" -- the default for every class -- and
        # RAII registration read that field, so a region class instance was filed as a stack object and
        # destructed at the closing brace while the arena still held it and every `A*` still pointed at
        # it. The design says the opposite in as many words.
        add_test(NAME codegen_region_class_outlives_block_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_outlives_block.pol"
            "-DEXPECTED=kept out of the block still readable: 42 destructor ran"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The one allocation site that cannot know the class at compile time. The type token carries
        # the arena's own `new` (null for a class that has none), so `instantiate` places by the
        # class's rule instead of reaching for malloc, and reflection never learns what a region is.
        add_test(NAME codegen_region_class_reflect_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_reflect.pol"
            "-DCONTAINS=built=5 then=77 through-field=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # class LibC library C -- the library named on the class, which is the unit that already
        # groups its externs. An identifier and not a string, so the per-platform file name has to live
        # in the manifest rather than in the source.
        add_test(NAME codegen_ffi_library_clause_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library_clause.pol"
            "-DCONTAINS=magnitude = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A String argument to an extern C function is marshalled to a char* (spec 26).
        add_test(NAME codegen_ffi_string_arg_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_string_arg.pol"
            "-DCONTAINS=hello from polaron"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch on a String matches by value, not pointer identity (spec 7.3).
        add_test(NAME codegen_switch_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_string.pol"
            "-DCONTAINS=HELLO"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Navigable ops on the ordered TreeMap (spec 34.1): first/last/floor/ceiling/higher/lower, pure Polaron.
        add_test(NAME codegen_treemap_navigable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/treemap_navigable.pol"
            "-DCONTAINS=first=10 last=50 floor25=20 ceil25=30 higher20=30 lower20=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style .properties parsing (spec 34) with typed getters, pure Polaron.
        add_test(NAME codegen_properties_config_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/properties_config.pol"
            "-DCONTAINS=name=Polaron port=8080 debug=1 missing=42 has=1 nokey=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL query-string parsing (spec 34) with percent-decoding, pure Polaron.
        add_test(NAME codegen_query_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/query_string.pol"
            "-DCONTAINS=a=1 b=2 c=hello me=A B x="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # JSON Pointer resolution (RFC 6901) and pretty-printing (spec 34), pure Polaron.
        add_test(NAME codegen_json_pointer_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/json_pointer.pol"
            "-DCONTAINS=n1=20 name=bob oob=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The System.Test unit-test framework (spec 34): Assert + TestRunner, pure Polaron.
        add_test(NAME codegen_test_framework_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_framework.pol"
            "-DCONTAINS=4 passed, 0 failed"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # CSV record parsing (RFC 4180, spec 34) with quoted fields, pure Polaron.
        add_test(NAME codegen_csv_reader_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/csv_reader.pol"
            "-DCONTAINS=n=4 f0=a f1=b,c"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # CSV row writing (RFC 4180, spec 34) with quoting/escaping, pure Polaron.
        add_test(NAME codegen_csv_writer_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/csv_writer.pol"
            "-DCONTAINS=row=a,\"b,c\",\"d\"\"e\""
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Human-friendly byte sizes and ordinals (spec 34), pure Polaron.
        add_test(NAME codegen_humanize_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/humanize.pol"
            "-DCONTAINS=b1=500 B b2=1.5 KB b3=1.0 MB b4=5.0 GB"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Spell integers in English words (spec 34), pure Polaron.
        add_test(NAME codegen_number_words_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/number_words.pol"
            "-DCONTAINS=d=one million two hundred thirty four thousand five hundred sixty seven"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a return implicitly widens to the declared type (int -> long/double, sign-extended).
        add_test(NAME codegen_return_widen_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/return_widen.pol"
            "-DCONTAINS=rl=42 rd=7.0 rneg=-5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: unary-minus double as a ternary arm (once mis-typed as int -> hung codegen).
        add_test(NAME codegen_unary_ternary_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unary_ternary.pol"
            "-DCONTAINS=sign=-1.0 r=2.0 k=-2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checksum validators (spec 34): Luhn (mod-10) and ISBN-13, pure Polaron.
        add_test(NAME codegen_validators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/validators.pol"
            "-DCONTAINS=luhnOk=1 luhnBad=0 isbnOk=1 isbnBad=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Line diff (LCS) and format validators (email/url/IBAN, spec 34), pure Polaron.
        add_test(NAME codegen_text_diff_validators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/text_diff_validators.pol"
            "-DCONTAINS=common=3 added=1 removed=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Levenshtein edit distance (spec 34) in pure Polaron.
        add_test(NAME codegen_levenshtein_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/levenshtein.pol"
            "-DCONTAINS=kit=3 empty=3 same=0 flaw=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Jaro-Winkler string similarity (spec 34) in pure Polaron.
        add_test(NAME codegen_jaro_winkler_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/jaro_winkler.pol"
            "-DCONTAINS=martha=0.961 dixon=0.813 same=1.000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # URL slugs and English pluralization (spec 34) in pure Polaron.
        add_test(NAME codegen_slug_inflect_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/slug_inflect.pol"
            "-DCONTAINS=p=cats,buses,parties,boxes,days"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Calendar arithmetic (spec 34): leap years, days in month, Zeller day-of-week, day-of-year.
        add_test(NAME codegen_calendar_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/calendar.pol"
            "-DCONTAINS=y2000sat=6 y2024mon=1 leap2000=1 leap1900=0 feb2024=29 doy=61"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Feature flags and an object-id pool (spec 34) in pure Polaron.
        add_test(NAME codegen_feature_pool_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/feature_pool.pol"
            "-DCONTAINS=a=0,1,2 exhausted=-1 reuse=1 inUse=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Fixed-point money as integer cents (spec 34), pure Polaron.
        add_test(NAME codegen_money_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/money.pol"
            "-DCONTAINS=a=$12.34 sum=$14.84 prod=$15.00 neg=-$0.75"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A bytecode stack virtual machine (spec 34) in pure Polaron, running factorial and a summation loop.
        add_test(NAME codegen_stack_vm_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stack_vm.pol"
            "-DCONTAINS=fact5=120 sum10=55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Resilience patterns (spec 34): a circuit breaker and a token-bucket rate limiter, deterministic.
        add_test(NAME codegen_resilience_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/resilience.pol"
            "-DCONTAINS=open=1 blocked=0 half=1 halfstate=2 closed=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RPN evaluation and shunting-yard infix->RPN (spec 34), pure Polaron.
        add_test(NAME codegen_rpn_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rpn.pol"
            "-DCONTAINS=shunt=1 2 + 3 * eval=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Classic ciphers (spec 34): Caesar/rot13 and Vigenere, verified against the ATTACKATDAWN vector.
        add_test(NAME codegen_ciphers_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ciphers.pol"
            "-DCONTAINS=vig=LXFOPVEFRNHR back=ATTACKATDAWN"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 3D vector math (spec 34.6) in pure Polaron: dot, cross, length, normalize.
        add_test(NAME codegen_vector3_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/vector3.pol"
            "-DCONTAINS=cross=0.0,0.0,1.0 dot=0.0 len=5.0 nlen=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Dense double matrix (spec 34.6) in pure Polaron: multiply, transpose, determinant.
        add_test(NAME codegen_matrixd_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matrixd.pol"
            "-DCONTAINS=c00=19.0 c11=50.0 t01=3.0 det=-2.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # itself.atMultiple (spec 17.4): a multi-range region; new T in R routes by type.
        add_test(NAME codegen_region_atmultiple_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_atmultiple.pol"
            "-DCONTAINS=d=7 c=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport granularity (spec 30.1): unimport enum X / unimport namespace N.
        add_test(NAME codegen_unimport_granularity_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_granularity.pol"
            "-DCONTAINS=ns caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND IT TAKES AWAY THE NAMESPACE AND NOT THE STANDARD LIBRARY WITH IT.
        #
        # Two lines put things in the expanded set that the author never named: the namespace was
        # matched by NAME across every bundle, and the prelude has an `App`; and every generic
        # instantiation in the program lived in one arbitrary namespace -- the first the monomorphiser
        # saw, which for a user program is the user's -- so `ArrayList$String` and forty more of the
        # library's types were sitting in whatever namespace was being unimported.
        #
        # §30 means the word literally: vtables poisoned to a trap, machine code overwritten with
        # `int3`. So the library's code was being erased under a running program.
        #
        # The check is a CALL and not a count, because a poisoned vtable and an int3'd body both
        # answer a size question correctly and neither answers *does it still work*. `after 3` is the
        # library on the far side of the statement; `gone caught` is the namespace really having
        # gone, without which the first line would also pass if `unimport` had stopped doing
        # anything at all.
        add_test(NAME codegen_unimport_namespace_spares_the_library COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport_namespace_spares_the_library.pol"
            "-DEXPECTED=before 3 after 3 gone caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `in region X` field placement (spec 18.7): accepted; the field works normally.
        add_test(NAME codegen_field_in_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/field_in_region.pol"
            "-DCONTAINS=v=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Move qualifiers (spec 19.3): move x from/to region relocates the object into the destination.
        add_test(NAME codegen_move_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/move_region.pol"
            "-DCONTAINS=id=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete a of region X` (spec 17.6): destroys a region object in place (destructor, no free).
        add_test(NAME codegen_delete_of_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_of_region.pol"
            "-DCONTAINS=after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Reflective Method.invoke returns the boxed result (spec 31); unboxed with a cast.
        add_test(NAME codegen_reflect_invoke_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_invoke_return.pol"
            "-DCONTAINS=v=49"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A property with both a custom get and set (spec 8.4): read via getter, write via setter.
        add_test(NAME codegen_property_getset_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/property_getset.pol"
            "-DCONTAINS=f=212"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A first-class Range value (spec 7.5): stored, queried (size/contains) and iterated.
        add_test(NAME codegen_range_value_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/range_value.pol"
            "-DCONTAINS=sum=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A record auto-generates toString (spec 10): "Name(f0, f1)".
        add_test(NAME codegen_record_tostring_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_tostring.pol"
            "-DCONTAINS=Point(3, 4)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # await ch.receive() (spec 20.7): a channel receive is awaitable (passthrough).
        add_test(NAME codegen_await_channel_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/await_channel.pol"
            "-DCONTAINS=sum=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete a, b;` frees several objects in one statement (spec 19.1).
        add_test(NAME codegen_delete_multi_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_multi.pol"
            "-DCONTAINS=done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Nullable primitive (spec 3.7): boxed as a null-capable pointer; == null and ?? work.
        add_test(NAME codegen_nullable_primitive_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_primitive.pol"
            "-DCONTAINS=xnull=1 ynull=0 z=5 w=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Checked class downcast (spec 6.3, no-UB): an invalid cast throws ClassCastException.
        add_test(NAME codegen_cast_checked_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cast_checked.pol"
            "-DCONTAINS=caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The is / as / as? type operators (spec 6.4).
        add_test(NAME codegen_is_as_operators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/is_as_operators.pol"
            "-DCONTAINS=adog=1 cdog=0 okNull=0 noNull=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # COMMANDS THAT CARRY COMMANDS -- composition, which is what closures were mostly used for.
        # The old test's subject was automatic free-variable capture: a returned lambda held `n`
        # because its body mentioned it. `addBy` holds `n` because its declaration says so, and
        # `composed` holds the two commands it runs for the same reason.
        add_test(NAME codegen_command_composition_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_composition.pol"
            "-DCONTAINS=add5=15 dbl=20 composed=30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 4x4 transform matrix (spec 34.6): identity/multiply/transpose, pure Polaron.
        add_test(NAME codegen_mat4_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mat4.pol"
            "-DCONTAINS=id00=1.0 id12=0.0 prod03=5.0 prod22=3.0 trans01=7.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Graphics/animation math (spec 34.6): Vector2/Vector4/Easing/Angle, pure Polaron.
        add_test(NAME codegen_graphics_math_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/graphics_math.pol"
            "-DCONTAINS=len=5.00 dot=11.00 addx=4.00"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bit-twiddling helpers (spec 34.6): popcount/clz/ctz/isPow2/nextPow2/reverse, pure Polaron.
        add_test(NAME codegen_bits_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bits.pol"
            "-DCONTAINS=pc=8 lz=31 tz=3 p16=1 p17=0 np17=32 np16=16 rev=16"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interpolation helpers (spec 34.6): lerp/inverseLerp/clamp/smoothstep/remap, pure Polaron.
        add_test(NAME codegen_interpolation_math_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interpolation_math.pol"
            "-DCONTAINS=lerp=5.00 inv=0.75 ss=0.50 remap=50.00 clamp=10.00"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quaternion 3D rotation math (spec 34.6) in pure Polaron: product, magnitude, normalize.
        add_test(NAME codegen_quaternion_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/quaternion.pol"
            "-DCONTAINS=mag=5.4772 pw=0.0 px=1.0 py=0.0 pz=0.0 normmag=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Least-squares regression and Pearson correlation (spec 34.6) in pure Polaron.
        add_test(NAME codegen_regression_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regression.pol"
            "-DCONTAINS=slope=2.0000 intercept=1.0000 r2=1.0000 predict5=11.0000 pearson=1.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Radix-2 fast Fourier transform (spec 34.6) in pure Polaron, forward + inverse round-trip.
        add_test(NAME codegen_fft_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fft.pol"
            "-DCONTAINS=dc_re=4.0000 dc_im=0.0000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Self-contained transcendentals (spec 34.6): sqrt/exp/ln/sin/cos/pow in pure Polaron.
        add_test(NAME codegen_numerics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/numerics.pol"
            "-DCONTAINS=sqrt2=1.414214 exp1=2.718282 ln_e=1.000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 24-bit RGB color utilities (spec 34): pack/unpack, hex, lerp, luminance, pure Polaron.
        add_test(NAME codegen_colors_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/colors.pol"
            "-DCONTAINS=pack=16744448 hex=#ff8000 r=255 g=128 b=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Probabilistic data structures (spec 34.1): Count-Min sketch and HyperLogLog, pure Polaron.
        add_test(NAME codegen_probabilistic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/probabilistic.pol"
            "-DCONTAINS=cms_a=5 cms_b=3 cms_c=1 cms_z=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Binary serialization (spec 4): LEB128 varints and MSB-first bit packing, round-tripped, pure Polaron.
        add_test(NAME codegen_binary_serial_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/binary_serial.pol"
            "-DCONTAINS=vlen=2 b0=172 b1=2 val=300 big=123456789"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Computational geometry (spec 34.6): shoelace area, point-in-polygon, and convex hull, pure Polaron.
        add_test(NAME codegen_geometry_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/geometry.pol"
            "-DCONTAINS=area2=32 in=1 out=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String algorithms (spec 34.1): KMP substring search and Manacher longest-palindrome, pure Polaron.
        add_test(NAME codegen_string_search_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_search.pol"
            "-DCONTAINS=idx=6 cnt=3 miss=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pointer-linked binary search tree (spec 34.1): insert/contains/size + sorted in-order traversal.
        add_test(NAME codegen_bst_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bst.pol"
            "-DCONTAINS=has4=1 has6=0 size=6 first=1 last=8 mid=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Node structures via arenas (spec 34.1): Trie (arena) and Graph (edge list + BFS).
        add_test(NAME codegen_trie_graph_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/trie_graph.pol"
            "-DCONTAINS=cat=1 ca=0 pre=1 cab=0 d03=2 d05=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More collections (spec 34.1): Multiset, RingBuffer, LinkedHashMap.
        add_test(NAME codegen_collection_more_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_more.pol"
            "-DCONTAINS=cx=2 ctotal=3 rbpeek=2 rbfull=1 lmk0=z lmz=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bitset (spec 34.1): packed bit flags with set/clear/flip/get/count.
        add_test(NAME codegen_bitset_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitset_ops.pol"
            "-DCONTAINS=g3=1 g4=0 g99=1 count=3 g40=0 g4=1 count=3 size=100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Scanner (spec 4): tokenize text into ints/words/lines with a stateful cursor.
        add_test(NAME codegen_scanner_tokens_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/scanner_tokens.pol"
            "-DCONTAINS=n=42 a=hello b=world more=0 l1=first l2=second l3=third"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # UTF-8 decoding (spec 4): Utf8.length/codepointAt/widthAt/codepoints over byte-level strings.
        add_test(NAME codegen_utf8_decode_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/utf8_decode.pol"
            "-DCONTAINS=bytes=8 chars=5 cp3=233 width3=2 cps_n=5 cps_last=8364"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Backtracking regex (spec 4): literals, ., classes, * + ?, ^ $ anchors via Regex.search.
        add_test(NAME codegen_regex_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regex_match.pol"
            "-DCONTAINS=star=1 full=1 nofull=0 dot=1 digits=1 lower=1 mixed=0 opt=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Path-string manipulation (spec 34.4): Paths join/basename/dirname/extension.
        add_test(NAME codegen_path_utils_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/path_utils.pol"
            "-DCONTAINS=join=src/lib/file.pol base=file.pol dir=src/lib ext=pol noext=[]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Line-oriented file I/O (spec 34.4): Files.writeLines/appendLine/readLines round-trip.
        add_test(NAME codegen_file_lines_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_lines.pol"
            "-DCONTAINS=n=4 first=alpha last=delta"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Even more Strings utilities (spec 4): one-sided trims, isBlank, equalsIgnoreCase.
        add_test(NAME codegen_string_extras_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_extras.pol"
            "-DCONTAINS=tsLen=4 teLen=4 blank1=1 blank2=0 eq=1 neq=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # More Strings utilities (spec 4): format placeholders, count, reverse, capitalize.
        add_test(NAME codegen_string_format_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_format.pol"
            "-DCONTAINS=fmt=Ann is 42 years old count=2 rev=olleh cap=World"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Strings utility (spec 4): split/join/replace/pad built on the String primitives.
        add_test(NAME codegen_string_utils_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_utils.pol"
            "-DCONTAINS=n=3 p1=bb join=a-bb-ccc repl=hi world hi padL=[00042] padR=[42...]"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Search terminals (spec 34): find/min/max over a collection, each returning Option<T>.
        add_test(NAME codegen_collection_search_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_search.pol"
            "-DCONTAINS=find=30 min=10 max=50 none=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and CALLING A METHOD on what those return, which crashed. The value form is a
        # { tag, payload } pair, so `find(...).isSome()` loaded a pointer out of the tag and
        # dispatched through address 1. Every method on Option/Result was affected and none was ever
        # exercised outside `match`, which reads the tag itself. Three lines, so a failure says which
        # of the three shapes broke: a present value, an absent one, and Result's two sides.
        add_test(NAME codegen_option_value_methods_hit COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option_value_methods.pol"
            "-DCONTAINS=hit: isSome=1 isNone=0 valueOr=4 present=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_option_value_methods_miss COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option_value_methods.pol"
            "-DCONTAINS=miss: isSome=0 isNone=1 valueOr=-7 present=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_option_value_methods_result COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option_value_methods.pol"
            "-DCONTAINS=result: okIs=1 okValue=3 errIs=1 errValue=-2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # TOTAL CONTROL OF THE FILESYSTEM, under rules that stop the usual mistakes. One line per
        # rule, so a failure says which one broke.
        #   missing -- a file that is not there read as "" through the builtin, exactly like an empty
        #              one. The plain read now refuses and names the path; tryRead/readOr are the two
        #              ways to ask about a file whose absence is ordinary.
        #   temp    -- a scratch file exists inside its scope and is gone after it, whatever happened
        #              in between. The constructor creates it, because a factory returning one by
        #              value would hand back a copy and destroy the original.
        #   paths   -- `..` resolved WITHOUT the filesystem (so it works on a path not yet created),
        #              and `relative`, which is what a tool prints.
        #   glob    -- `*` stays inside one component and `**` crosses directories: the distinction
        #              every hand-written matcher forgets, so it silently sees only the top level.
        add_test(NAME codegen_file_control_missing COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_control.pol"
            "-DCONTAINS=missing: threw=1 message=cannot read 'nope.txt' try=0 or='default'"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_control_temp COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_control.pol"
            "-DCONTAINS=temp: inside=1 gone after scope=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_control_paths COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_control.pol"
            "-DCONTAINS=paths: normalize=a/d abs=1 stem=report.tar ext=dir/report.md rel=sub/two.pol"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_control_glob COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_control.pol"
            "-DCONTAINS=glob: shallow=1 deep=2 exact=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The matcher on its own, because `glob` only ever hands it paths a walk produced -- and
        # every corner of a pattern language is somewhere a walk never goes. Ten rules: `*` stops at
        # a separator and `**` does not, `?` is exactly one and also stops, a pattern must match the
        # WHOLE name, and a separator in a pattern matches either kind.
        add_test(NAME codegen_file_control_patterns COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_control.pol"
            "-DCONTAINS=patterns: 10 of 10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # READING A REAL CERTIFICATE. The input is a genuine self-signed root exported from a Windows
        # trust store -- nothing invented for the test, because a DER reader tested against a
        # certificate written for the test is tested against its own assumptions.
        #
        # The signature line is the one that matters: a self-signed root is signed by its own key, so
        # verifying it exercises DER navigation, the exact bytes of the signed body (one byte out and
        # the hash differs), SHA-256, the modulus and exponent, the modular exponentiation and the
        # PKCS#1 unpadding — all at once, with no way to be right by accident.
        add_test(NAME codegen_certificate_parse COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_parse.pol"
            "-DCONTAINS=read: wellFormed=1 selfIssued=1 isCA=1 sigAlg=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The dates against epochs computed outside the program: a calendar conversion off by a day or
        # by a leap year shows up here as a number, not as a certificate that expires on the wrong
        # afternoon. The `notBefore` is a UTCTime with a two-digit year, so it also pins the 50-year
        # pivot RFC 5280 specifies.
        add_test(NAME codegen_certificate_dates COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_parse.pol"
            "-DCONTAINS=valid: from=1331769600 until=1962921599"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_certificate_signature COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_parse.pol"
            "-DCONTAINS=signature: verifiesWithOwnKey=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE PRIMITIVES EVERY KEY IN A TLS CONNECTION IS DERIVED FROM, against published vectors --
        # FIPS 180-4, RFC 4231 and RFC 5869 — rather than against a second implementation of ours,
        # which would only test our own understanding twice.
        #
        # SHA-384 and SHA-512 were missing from the library entirely, and that was not cosmetic: of
        # this machine's 68 root certificates, twelve are signed with SHA-384 and one with SHA-512. A
        # client that cannot compute them cannot follow a chain to a third of the authorities the
        # machine trusts, and the honest response to a signature it cannot check is to refuse — so the
        # hole would have surfaced as sites that simply do not work.
        add_test(NAME codegen_tls_primitives COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=sha512: abc=1 empty=1 multiblock=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_tls_hkdf COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=hkdf: prk=1 okm=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The early secret is the published starting point of the TLS 1.3 schedule; matching it means
        # extract, expand and the label construction all agree with the specification at once.
        # The key exchange, against RFC 7748 AND against the property that makes it an exchange: what
        # each side computes from the other's public value must agree. A scalar multiplication that
        # is subtly wrong can still agree with itself, so the vector alone would not catch it.
        add_test(NAME codegen_tls_x25519 COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=x25519: vector=1 agrees=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # THE OTHER KEY EXCHANGE, on the curve RFC 8446 makes mandatory (x25519 is only a SHOULD).
        # The vector is .NET's two ephemeral keys and the SHA-256 of the secret they agreed, so what
        # is witnessed is that our number is THEIR number. The off-curve refusal is the same
        # invalid-curve attack the signature verifier guards against, and in a key exchange it hands
        # the other side control of the group the secret is computed in.
        add_test(NAME codegen_tls_p256_ecdh COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=p256 ecdh: vector=1 publicKey=1 offCurveRefused=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # AES-GCM against NIST SP 800-38D, and the field that matters most: a flipped bit in the tag
        # must make `open` REFUSE. Decrypting first and checking after is how a program ends up acting
        # on bytes an attacker chose.
        add_test(NAME codegen_tls_gcm COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=gcm: vector=1 roundTrip=1 forgedTagRefused=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_tls_key_schedule COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tls_primitives.pol"
            "-DCONTAINS=keyschedule: earlySecret=1 keyIsSixteen=1 ivIsTwelve=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE CERTIFICATES THIS MACHINE ALREADY TRUSTS, and a chain checked all the way to one.
        #
        # A root is its own issuer, so every root carries a signature by its own key: verifying a
        # sample of them tests the whole path against certificates from real authorities -- many
        # issuers, many encodings, RSA with SHA-256/384/512 and ECDSA -- rather than against the one
        # certificate somebody picked for a test.
        #
        # The counts move with the machine, so the ASSERTION is that every root the library claims it
        # can check does check out. Measured across the whole store once: 30 checked, 30 verified, 36
        # unsupported -- of which 29 are SHA-1, MD5 or MD2 roots that a modern client must refuse.
        add_test(NAME codegen_trust_store COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/trust_store.pol"
            "-DCONTAINS=every checked root verified: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_trust_store PROPERTIES TIMEOUT 180)
        # "Unsupported" used to mix two opposite things: roots a modern client is SUPPOSED to refuse,
        # and roots this library could not reach. Six of them were P-384 — a curve, not a policy —
        # and nothing in the count said so. Now every refusal must be an obsolete digest, so a modern
        # algorithm falling out of reach fails here instead of hiding in a number.
        add_test(NAME codegen_trust_store_refusals_are_policy COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/trust_store.pol"
            "-DCONTAINS=every refusal is an obsolete digest: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_trust_store_refusals_are_policy PROPERTIES TIMEOUT 180)
        add_test(NAME codegen_trust_store_loads COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/trust_store.pol"
            "-DCONTAINS=store: loaded=1 many=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_trust_store_loads PROPERTIES TIMEOUT 180)

        # AN https:// URL FETCHED FOR REAL. `HttpClient` used to answer one with a made-up response
        # reading "TLS not available" — a library shipping the protocol and not the transport. These
        # need a network, deliberately: the P-384 gap that made example.com unreachable was invisible
        # to every offline test here, and only a real server showed it.
        #
        # IT ASSERTS A STATUS LINE, NOT A PARTICULAR STATUS. Everything this test can honestly promise
        # happens on our side of the socket: the handshake completes, the record layer decrypts, and an
        # HTTP response is parsed out of it. WHICH status the far end chooses is the far end's business.
        # Asserting `200` tied the suite to a third party's uptime, and duly failed on a machine whose
        # route reached a Cloudflare edge answering 526 (its origin's certificate, not ours) while curl
        # from the same shell got 200 through a different one. A suite that goes red for that teaches
        # people to re-run it, which is how a real failure gets waved through.
        add_test(NAME codegen_https_fetch COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/https_client.pol"
            "-DCONTAINS=status: "
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_https_fetch PROPERTIES TIMEOUT 120)
        # The load-bearing half. Anyone can encrypt to whoever answered the socket; with nothing
        # trusted, every signature in the chain still checks out and the connection must still fail.
        add_test(NAME codegen_https_refuses_untrusted COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/https_client.pol"
            "-DCONTAINS=without a trust store: refused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_https_refuses_untrusted PROPERTIES TIMEOUT 120)
        # A server that will not continue says why, by number. Reporting every refusal with one
        # sentence is how a version mismatch and a rejected hostname become the same bug report.
        add_test(NAME codegen_tls_alert_named COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/https_client.pol"
            "-DCONTAINS=alert 48: unknown certificate authority"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_tls_alert_named PROPERTIES TIMEOUT 120)

        # SIGNATURE VERIFICATION, against signatures this project did not produce. Both vectors were
        # made by .NET's own ECDSA and RSA-PSS and verified there before being written down — a
        # verifier tested against a signer we also wrote is a verifier tested against its own
        # misunderstanding, and cryptographic code fails by giving the wrong ANSWER rather than by
        # crashing, so an outside oracle is the only useful witness.
        #
        # ECDSA matters because most certificates the internet presents are ECDSA: a client that
        # verifies only RSA either refuses the servers people use or treats "I cannot check this" as
        # "this checks out". PSS matters because TLS 1.3 requires it for CertificateVerify — the
        # message that proves the server holds the key belonging to the certificate it just sent.
        #
        # The NO answers carry the weight. A verifier that skips a step still passes every test made
        # of valid signatures; only the refusals show it is doing the work.
        add_test(NAME codegen_ecdsa_verify COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecdsa_verify.pol"
            "-DCONTAINS=valid signature: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # An off-curve public key is the invalid-curve attack: the arithmetic then happens in a group
        # the attacker chose. Four multiplications to check, so skipping it would be a decision.
        add_test(NAME codegen_ecdsa_refuses COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecdsa_verify.pol"
            "-DCONTAINS=point off the curve: 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # P-384, and the reason it is not optional: connecting to example.com refused the certificate
        # because Cloudflare's intermediate is on that curve, and twelve of this machine's sixty-eight
        # roots are too. One curve implemented is a third of the web reported as a certificate
        # problem. Nothing about it is a second implementation — the same limbs, the same Montgomery
        # reduction and the same point formulas, told a different prime.
        add_test(NAME codegen_ecdsa_p384 COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecdsa_verify.pol"
            "-DCONTAINS=p384 valid signature: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_ecdsa_p384_refuses COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecdsa_verify.pol"
            "-DCONTAINS=p384 point off the curve: 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The budget: a handshake verifies two or three signatures, and the same work on the standard
        # library's decimal BigInteger measured over a second EACH — which is why this arithmetic is
        # purpose-built with 16-bit limbs and Montgomery reduction.
        add_test(NAME codegen_ecdsa_fast_enough COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ecdsa_verify.pol"
            "-DCONTAINS=one verification: under 200 ms"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_rsa_pss_verify COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rsa_pss_verify.pol"
            "-DCONTAINS=valid signature: 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_rsa_pss_refuses COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/rsa_pss_verify.pol"
            "-DCONTAINS=tampered signature: 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WHAT A CLIENT REFUSES. Encryption is not authentication: a handshake with whoever answered
        # the socket stops somebody listening and does nothing about somebody answering in the
        # server's place. These are the checks that turn an encrypted pipe into a conversation with a
        # named party, and each REFUSES BY THROWING — a boolean can be dropped, and a validation
        # result that is dropped is the same program as one that never validated.
        #
        # The hostname line is RFC 6125, and the NOs are what matter: a wildcard that swallowed a dot
        # or matched the bare domain is a certificate for one subdomain accepted for a whole zone.
        add_test(NAME codegen_certificate_hostnames COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_refusals.pol"
            "-DCONTAINS=names: exact=1 wrongHost=0 wildcard=1 bareDomain=0 twoLabels=0 caseFolds=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_certificate_refuses_empty COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_refusals.pol"
            "-DCONTAINS=empty chain: refused=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_certificate_refuses_untrusted COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_refusals.pol"
            "-DCONTAINS=untrusted: refused=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The validity window asked DIRECTLY. Routing it through `check` would prove nothing here:
        # the hostname is tested first and this certificate covers no DNS name, so it would refuse
        # before reading a date — a test that passes for the wrong reason.
        add_test(NAME codegen_certificate_validity_window COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/certificate_refusals.pol"
            "-DCONTAINS=window: before=0 inside=1 after=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A CHAIN OF METHOD CALLS COMPILES IN LINEAR TIME. This one is a stopwatch: the TIMEOUT is the
        # assertion, and a regression shows up as a test that never finishes rather than a wrong
        # answer.
        #
        # `typeName` in the codegen needed two different things about a call's receiver -- the
        # callee's type, and separately whether it is a `mat4` -- and each recursed into the receiver.
        # Two derivations per level is 2^depth: measured, 8 links took 481 ms, 14 took 24 SECONDS, 18
        # never finished. It hid because the ANALYSER is linear over the same expression (`--check`
        # was flat), the emitted IR is linear, and the doubling happened in a pure query that emits
        # nothing -- so counting emissions found nothing either.
        #
        # It matters far beyond the sample: a fluent builder, `b.append(x).append(y)...`, is the same
        # shape, and stopped compiling past about fifteen links. The same defect was fixed once
        # before for binary expressions and fixed AT THAT NODE, so it returned through another one;
        # the memo is on the mechanism instead.
        add_test(NAME codegen_deep_call_chain COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_call_chain.pol"
            "-DCONTAINS=chain: 24 links, length=24"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # Generous next to the 0.3 s it takes now, and far under the 24 s the defect cost at 14 links
        # -- so it catches a return of the exponential without failing on a slow machine.
        set_tests_properties(codegen_deep_call_chain PROPERTIES TIMEOUT 60)
        add_test(NAME codegen_deep_call_chain_fluent COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_call_chain.pol"
            "-DCONTAINS=fluent: length=31"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_deep_call_chain_fluent PROPERTIES TIMEOUT 60)

        # A REAL TOOL over the whole filesystem/process surface, written to find out whether it is
        # actually finished -- a directory-syncing program of the kind everybody writes eventually.
        # Stricter than a checklist, because a checklist only asks about the calls somebody already
        # thought of: this one found `Paths.joinAll` missing in its fourth line (Polaron has no
        # overloading and no variadic parameters, so `join` taking two segments meant nesting).
        #
        # The second sync copying NOTHING is the claim that matters: a tool that copies everything
        # every time cannot be used on a large tree, and the size+mtime comparison that decides is
        # the one `isNewerThan` exists for. The hook proves an argument holding a space and an `&`
        # reaches another program whole.
        add_test(NAME codegen_tree_sync_incremental COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tree_sync.pol"
            "-DCONTAINS=second: copied=0 skipped=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_tree_sync_changed_only COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tree_sync.pol"
            "-DCONTAINS=changed: copied=1 skipped=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_tree_sync_manifest COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tree_sync.pol"
            "-DCONTAINS=manifest: lines=3 firstIsRelative=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_tree_sync_hook COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tree_sync.pol"
            "-DCONTAINS=hook: argumentIntact=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE REST OF THE SURFACE. After the two tools, the question "which call in this area does no
        # sample touch?" was asked of the samples rather than of memory, and thirteen came back.
        # They are here. A method nothing calls is a method whose first caller is a user -- and all
        # three defects the tools found were in code that had been written, read and believed.
        add_test(NAME codegen_system_surface_paths COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=paths: sepIsOne=1 pieces=3 pathSepMatches=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_system_surface_times COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=times: accessedKnown=1 usedAddsUp=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # `moveTo` changes the process's working directory, so the sample puts it back -- and this
        # checks that it went AND returned.
        add_test(NAME codegen_system_surface_places COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=places: exeDirHoldsExe=1 homeExists=1 movedAndBack=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # A SHARED lock is held by two readers at once; an exclusive one would refuse the second.
        # That distinction is invisible unless two holders try together.
        add_test(NAME codegen_system_surface_shared_lock COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=shared: twoReadersAtOnce=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_system_surface_command COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=command: argAllPassed=1 windowFlagHarmless=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # Both ends of the range: the most negative long is the one input with no positive
        # counterpart, so a naive negate overflows on exactly it.
        add_test(NAME codegen_string_builder_long COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/system_surface.pol"
            "-DCONTAINS=builder: longRoundTrip=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A SECOND REAL TOOL, deliberately a different kind: a build watcher, which keeps a worker
        # ALIVE over a pipe rather than running one process per file. Between it and the syncing tool
        # every call in this area is exercised by a program instead of a checklist -- and this one
        # found three things a checklist would not have.
        #
        #   - There was NO WAY TO WRITE TO STDERR. Every diagnostic a Polaron program produced went
        #     to stdout, mixed into whatever the program was for -- and stderr is the very stream
        #     `mergeStderr` exists to control, which the library could ask for and no program could
        #     produce. `Console.error`/`errorln` now do, taking a String (compose it by interpolation).
        #   - `clearEnv()` HANDED THE CHILD EVERYTHING. An empty environment and "inherit mine"
        #     reached the runtime as the same value -- a count of zero -- so the feature whose whole
        #     purpose is running something blind did the opposite, silently. The same defect this
        #     whole area exists to remove, in the code that removes it.
        #   - ...and once that was separated, a Windows environment block of a single zero byte is
        #     MALFORMED: two are required, one closing the last string and one closing the block. An
        #     empty environment is "\0\0".
        add_test(NAME codegen_build_watcher_worker COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/build_watcher.pol"
            "-DCONTAINS=worker: replies=2 lastOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_build_watcher_stderr COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/build_watcher.pol"
            "-DCONTAINS=stderr: merged=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_build_watcher_cleared_env COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/build_watcher.pol"
            "-DCONTAINS=env: cleared=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_build_watcher_backup COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/build_watcher.pol"
            "-DCONTAINS=backup: files=3 identical=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The log of a FAILED run is the one scratch file that must survive the scope it was made in.
        add_test(NAME codegen_build_watcher_evidence COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/build_watcher.pol"
            "-DCONTAINS=evidence: keptOnFailure=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE SIX THINGS A PROGRAM NEEDS FROM A FILESYSTEM THAT NOTHING ELSE HERE PROVIDES.
        #   replace -- a plain write TRUNCATES and then fills, so a crash between the two leaves the
        #              caller's save file empty. `replace` writes beside it and renames, and leaves
        #              no `.new` behind when it is done.
        #   move    -- `rename` cannot cross a volume and simply FAILS there, so a program ignoring
        #              the boolean has lost the file. `move` falls back to copy-then-delete.
        #   lock    -- held on the open HANDLE, so the operating system releases it if the process
        #              dies. The second holder must be REFUSED: a lock granted twice is not a lock.
        #   lines   -- read without loading the file, and with the `\r` of a Windows ending dropped,
        #              which is the commonest reason a comparison that looks right fails.
        #   child   -- feeding stdin (which `run` could not do at all) and giving up on a child that
        #              never finishes. The first version of that timeout drained the output BEFORE it
        #              started counting, so a hung child -- which holds its stdout open -- blocked the
        #              read and the deadline was never reached. This test is what found it.
        add_test(NAME codegen_file_replace_atomic COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=replace: contentKept=1 noLeftovers=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_move COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=move: arrived=1 sourceGone=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_lock COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=lock: taken=1 secondRefused=1 afterUnlock=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_line_reader COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=lines: count=3 second=beta noTrailingCR=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # A LineReader IS an Iterator<String>, so a routine written over the interface counts the
        # lines of a file without knowing it is one -- which is the point of having the interface.
        add_test(NAME codegen_file_line_iterator COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=iterator: counted=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # How big a tree is before copying it, and what is FREE right now -- a different number from
        # what the machine has, and the one to size a cache against. Sizing against the total is how
        # a program that behaves on an idle machine takes a busy one down.
        add_test(NAME codegen_machine_sizes COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=sizes: treeBytes>0=1 freeMemory>0=1 lessThanTotal=1 uptime>0=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_process_input_and_timeout COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_durability.pol"
            "-DCONTAINS=child: fedInput=1 timedOut=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # A child that spins forever is started here on purpose, so a hang in this group means the
        # deadline stopped working rather than a slow machine.
        set_tests_properties(codegen_process_input_and_timeout PROPERTIES TIMEOUT 120)

        # WHAT A FILE RECORDS, WHAT ITS BYTES ARE, WHAT A LINK POINTS AT, AND WHAT CHANGED.
        #   metadata -- the read-only switch, `touch`, and whether a CREATION time is recorded at
        #               all. `st_ctime` is not it: that is the status-change time, and answering
        #               "created" with it reports a chmod as a creation. -1 means not recorded.
        #   bytes    -- four bytes including a NUL and 0xFF, out and back unchanged, and a file four
        #               bytes long: a writer that stopped at the NUL would have produced one.
        #   hardlink -- a second NAME for the same file. Checked here because it needs no privilege
        #               anywhere; the symbolic-link half prints `permitted=0` on a Windows without
        #               Developer Mode and runs in full on POSIX, so the line is matched by prefix.
        #   watch    -- the three answers, and that a change is reported ONCE: a second poll with
        #               nothing in between must be empty, or every caller acting on it acts twice.
        add_test(NAME codegen_file_metadata COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_metadata_links.pol"
            "-DCONTAINS=metadata: readOnly=1 backToWritable=1 touched=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_bytes COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_metadata_links.pol"
            "-DCONTAINS=bytes: wrote=4 read=4 identical=1 zeroByteSurvived=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_hardlink COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_metadata_links.pol"
            "-DCONTAINS=hardlink: sameContent=1 survivesDelete=1 notASymlink=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_file_symlink_reports COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_metadata_links.pol"
            "-DCONTAINS=symlink: permitted="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_directory_watch COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_metadata_links.pol"
            "-DCONTAINS=watch: added=1 changed=1 removed=1 secondPollEmpty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # RUNNING ANOTHER PROGRAM WITHOUT A SHELL BETWEEN YOU AND IT.
        #
        # `Process.run(cmd)` takes one string and hands it to cmd.exe or /bin/sh, so every argument is
        # shell syntax and no care at the call site can fix it -- the call site is where the string is
        # built. A Command keeps the program and its arguments apart the whole way down.
        #
        # The sample runs ITSELF (no external tool echoes its arguments on both platforms) with an
        # argument holding `&`, `|`, `>`, quotes, `$(...)`, `%PATH%` and backslashes. Four claims, and
        # the third is the one that makes the sample a demonstration rather than an assertion: the
        # SAME redirection through the old path does create the file.
        add_test(NAME codegen_process_no_shell_echo COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=echoed: identical=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_process_no_shell_inert COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=no shell ran: redirect file absent=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_process_shell_obeys COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=through a shell: redirect obeyed=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # The two things a command STRING cannot carry at all -- `cd x && ...` is shell syntax, which
        # is the thing being removed -- and the exit code, which `close` alone throws away.
        add_test(NAME codegen_process_no_shell_directory COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=directory: child saw the temp dir=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_process_no_shell_env COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=environment: child saw POLARON_CHILD_ZZZ=passed"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_process_no_shell_exit COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=exit code: ok=0 bad=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # ...and a program that is not there answers -1 on BOTH platforms. Windows learns that from
        # CreateProcess; POSIX forks successfully and only the child finds out, so it needs a
        # close-on-exec pipe carrying the child's errno -- without it, "not found" and a program that
        # genuinely returned 127 are the same answer.
        add_test(NAME codegen_process_no_shell_missing COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/process_no_shell.pol"
            "-DCONTAINS=missing program: exit=-1 outputLen=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sortedBy (spec 34): order a collection by a comparator lambda, leaving the original untouched.
        add_test(NAME codegen_collection_sorted_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_sorted.pol"
            "-DCONTAINS=asc=10,20,30,40,50 desc0=50 orig0=30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Iterable/Iterator (spec 34): an ArrayList walked through the Iterable interface by a generic helper.
        add_test(NAME codegen_collection_iterator_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_iterator.pol"
            "-DCONTAINS=total=66 count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Slice (spec 34): a non-owning window over an array range; get/set through, sub narrows, toArray copies.
        add_test(NAME codegen_collection_slice_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_slice.pol"
            "-DCONTAINS=len=4 s0=20 s3=50 a1=999 mid_len=2 mid0=30 copy1=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mutating collection ops (spec 34.1): ArrayList set/removeAt/remove/clear, HashMap/HashSet remove.
        add_test(NAME codegen_collection_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_ops.pol"
            "-DCONTAINS=size=3 head=99 idx30=1 has99=1 removed=1 size=2 cleared=0 map removed=1 size=2 has2=0 v3=300 set size=2 has6=0 has7=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mutable string (spec 4): append grows in place; assignment copies (value semantics).
        add_test(NAME codegen_mutable_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/mutable_string.pol"
            "-DCONTAINS=hi! there a=x b=xy"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Interpolation as a value (spec 4.1): $"..." builds a String, interpolating ints, strings
        # and expressions.
        add_test(NAME codegen_interp_string_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_string.pol"
            "-DCONTAINS=n=7, hello world! len=17 7 doubled is 14"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String (spec 4): literal, length, charAt, substring, equals and + concatenation.
        add_test(NAME codegen_strings_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/strings.pol"
            "-DCONTAINS=Hello, world! len=13 c=w sub=world eq=1 ne=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Boxing (spec 3.4): a primitive assigned to an Object is boxed; cast<T> unboxes it -> 42 / 1.
        add_test(NAME codegen_boxing_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/boxing.pol"
            "-DEXPECTED=n=42 flag=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        add_test(NAME codegen_sizeof_type_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_type.pol"
            "-DEXPECTED=n=8 n2=8 mpos=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent-bearing objects in an array (spec 18.5): an object without a name binding still
        # gets a usable persistent block, so its persistent fields work instead of crashing.
        add_test(NAME codegen_persist_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_array.pol"
            "-DEXPECTED=c0=11 c1=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalog-typed dispatch (spec 12.4): a catalog with a single implementing enum dispatches a
        # method called on a catalog-typed value to that enum's implementation.
        add_test(NAME codegen_catalog_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_dispatch.pol"
            "-DEXPECTED=w=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A catalog-implementing ordinal enum may separate its methods from the constants with a `;`
        # (regression guard: this stateless form was wrongly rejected as java-style). Multi-implementer.
        add_test(NAME codegen_catalog_semicolon_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_semicolon_methods.pol"
            "-DEXPECTED=a=angry b=high"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # multi-implementer catalog dispatch (spec 12.4): a runtime type tag picks the right enum's
        # method when several enums implement the catalog.
        add_test(NAME codegen_catalog_multi_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_multi_dispatch.pol"
            "-DCONTAINS=w1=7 w2=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A java-style enum implementing a catalog (2026-08-09: the two compose): byCatalog constants
        # take constructor arguments, catalog methods live on the desugared twin class, and dispatch
        # through a catalog-typed value resolves the tagged ordinal back to the constant's singleton.
        add_test(NAME codegen_catalog_java_enum_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_java_enum.pol"
            "-DCONTAINS=p=1 b=10 g=95 n=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Mixed implementers of one catalog: an ordinal enum and a java-style enum behind the same
        # catalog-typed receiver; the type tag picks the implementer, the ordinal picks the singleton.
        add_test(NAME codegen_catalog_java_mixed_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_java_mixed_dispatch.pol"
            "-DCONTAINS=w1=7 w2=42 w3=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # v.name() (spec 12.5): the declared identifier back as a String, on ordinal and
        # java-style enum values alike -- the fourth of the generated quartet.
        add_test(NAME codegen_enum_name_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_name.pol"
            "-DCONTAINS=a=GREEN b=GREEN p=MARS"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cast<int> of a java-style enum value yields its declaration ordinal, never the
        # singleton's pointer bits (regression: it used to truncate the address).
        add_test(NAME codegen_java_enum_ordinal_cast_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_ordinal_cast.pol"
            "-DCONTAINS=e=0 m=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A methods-only enum with NO catalog stays ORDINAL: methods never make an enum
        # object-backed (regression: one method used to turn every constant into a heap
        # singleton, visible as sizeof 8 where 4 was promised).
        add_test(NAME codegen_enum_plain_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_plain_methods.pol"
            "-DCONTAINS=b=2 ord=1 n=3 sz=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A catalog-typed value passed as an ARGUMENT keeps its tag (spec 12.6). Regression: the
        # tagged ordinal lowers to i64 exactly as `long` does, so coercing an argument to the
        # parameter's LLVM shape alone dropped the type tag and dispatched every call to whichever
        # enum owned tag 0 -- silently wrong (200 read as 11); from a java-style implementer the
        # same path failed module verification.
        add_test(NAME codegen_catalog_arg_passing_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_arg_passing.pol"
            "-DEXPECTED=m=11 200 20 c=30 e=7 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # An enum's count() is a compile-time constant, so it may stand in a demand (spec 12.5 +
        # 28.2) -- which is what holds a multi-family index space to the size of each family. A
        # class's own static count() must still fall through to an ordinary runtime call.
        add_test(NAME codegen_demand_enum_count_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_enum_count.pol"
            "-DEXPECTED=shelf=12 idx=4 holds=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # FFI struct by value (spec 26): a small struct is passed to and returned from a C function
        # by value (the runtime provides the matching C helpers).
        add_test(NAME codegen_ffi_struct_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_struct.pol"
            "-DEXPECTED=s=7 qx=30 qy=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # auto-generated record hashCode (spec 10): equal records hash equal, different ones differ.
        add_test(NAME codegen_record_hashcode_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_hashcode.pol"
            "-DEXPECTED=eq=1 same=1 diff=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A hex literal WRITTEN with more than 32 bits of digits is 64-bit, whatever signed value it
        # equals. 0xFFFFFFFFFFFFF000 == -4096 as an int64, so typing literals by value truncated the mask
        # to 0xFFFFF000 -- which silently drops every address above 4 GiB.
        add_test(NAME codegen_wide_hex_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_hex_literal.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_server.pol"
            "-DNEEDLE=IpcDispatch.handle"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # spec 37.4: a `comptime` local is computed during compilation and EMBEDDED. An IR test and not
        # a behaviour one on purpose -- a local that recomputed the same answer at run time would print
        # exactly the same thing and pass a `_runs` test. That is what used to happen: the prefix was
        # parsed, stored on the declaration and read by nobody, so the program emitted a real
        # `call @Main.fib(i32 10)`. fib(10) = 55, so the folded constant must be in the IR.
        add_test(NAME codegen_comptime_local_folds COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_local_folds.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.pol"
            "-DNEEDLE=define x86_intrcc void @\"Keyboard$interrupt\"(ptr byval(%class.Trap)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # `kbd.interrupt` BINDS the object and yields the entry point in one act, because an
        # interrupt vector holds an address and nothing else -- there is nowhere to put the receiver
        # except a slot the entry reads on arrival. Without the store the entry would load null and
        # the kernel would fault inside its own handler, so the store IS the feature.
        add_test(NAME codegen_interrupt_binds_receiver COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.pol"
            # THE STORE is the property, not what the stored value happens to be CALLED. `%kbd1` is
            # one backend's naming of an SSA value; the other numbers it `%1`. Pinning the name was
            # pinning an implementation detail, and it went red the day the default backend changed
            # while the feature it tests worked perfectly.
            "-DNEEDLE=, ptr @\"Keyboard$interrupt$self\", align 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # The OTHER half of rule 3, and the half that decides whether the rule is worth having: the
        # escape hatch must EXIST bare metal, or a correct program becomes inexpressible and the rule
        # only teaches people to route around it. `atomic<T>` on x86-64 is a `lock`-prefixed
        # instruction with no runtime behind it, so this sample compiles freestanding and the IR
        # carries a real `atomicrmw` -- no `__atomic_*` libcall a kernel could not link.
        add_test(NAME codegen_interrupt_atomic_state_ok COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_atomic_ok.pol"
            # The claim is a REAL `atomicrmw` with no `__atomic_*` libcall behind it -- what the
            # pointer operand is named is one backend's spelling (`%atomic.value` against `%value`)
            # and not part of it.
            "-DNEEDLE=atomicrmw add ptr %"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # The parameterless form still gets a frame-sized `byval`, because x86_intrcc is how LLVM is
        # told the size of what the CPU pushed -- it is not the handler's argument list.
        add_test(NAME codegen_interrupt_without_trap COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interrupt_entry.pol"
            "-DNEEDLE=define x86_intrcc void @\"Spurious$interrupt\"(ptr byval({ i64, i64, i64, i64, i64 })"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # `cast<T*>` on a nullable ASSERTS non-null and now verifies it: an exception when hosted, a
        # panic in freestanding. It used to reinterpret with no check, so a broken promise surfaced as an
        # access violation with nothing naming who promised -- while `cast<Dog>(animal)` verified and
        # threw. The sample also carries the cast-free form the narrowing makes possible.
        add_test(NAME codegen_null_cast_checked_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_cast_checked.pol"
            "-DEXPECTED=caught: null where a value was asserted narrowed: 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deferred initialization, guard-clause narrowing, and a proof made by an initializer -- the
        # shapes the flow analysis must ACCEPT. Runs, so the narrowing is proved not to change behaviour.
        add_test(NAME codegen_flow_states_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/flow_states.pol"
            "-DEXPECTED=branch=10 guard=0 pos=0 init=5 test=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # b"..." (spec 36): raw NUL-terminated bytes typed `byte*`, not a String object -- what
        # freestanding needs, since building a String requires a runtime a kernel does not have. Also
        # asserts `b` is still usable as an ordinary identifier.
        add_test(NAME codegen_bytes_literal_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bytes_literal.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_struct_hash.pol"
            "-DEXPECTED=same=1 diff=0 chain=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        set_tests_properties(codegen_wide_struct_hash_runs PROPERTIES TIMEOUT 120)

        # in-scope persistent reattach (spec 18.2): a deleted variable redeclared with the same name
        # reattaches its persistent, so the new object sees the prior value.
        add_test(NAME codegen_reattach_in_scope_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reattach_in_scope.pol"
            "-DEXPECTED=re=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # region as a class field (spec 17): allocate into `this.arena`, an arena owned by the object.
        add_test(NAME codegen_region_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_field.pol"
            "-DEXPECTED=a=11 b=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # partitionable partial field move (spec 19.9): a movable field is moved out individually,
        # the parent stays valid for its other fields, and the moved field is reassignable.
        add_test(NAME codegen_partitionable_move_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable_move.pol"
            "-DEXPECTED=s=7 cfg=9 re=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # property with a custom set body (spec 8.4): assignment runs the setter (clamps negatives).
        add_test(NAME codegen_property_setter_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/property_setter.pol"
            "-DEXPECTED=b=50 b=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # conversion operator (spec 6.6): cast<T>(obj) invokes a user-defined `operator cast<T>`.
        add_test(NAME codegen_conversion_operator_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/conversion_operator.pol"
            "-DEXPECTED=f=212"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `delete X from region R` (spec 17.7): runs the destructor now and removes the object from
        # the region teardown, so it is not destroyed again on release.
        add_test(NAME codegen_delete_from_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_from_region.pol"
            "-DEXPECTED=before ~Dog 1 mid ~Dog 2 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE `static_assert` THE C++ REGION CORE CARRIED. It ended with
        #   static_assert(sizeof(PolaronRegionDesc) <= POLARON_REGION_HDR, ...)
        # and the Polaron core that replaced it cannot say that: there is no `sizeof` to write it
        # with. The claim is sharp -- the compiler hardcodes 448 as the offset where a region's
        # OBJECTS begin, and a descriptor past 448 writes its own fields over the first one, silently
        # -- so it is checked by consequence. The free-list table is the descriptor's last field, and
        # a >512-byte object freed from a pool writes its final entry, at +384. The marker in the
        # first slot is read back afterwards.
        # AN `int` AGAINST AN `address`, narrowed afterwards. The mixed-width widening read only
        # `Int` pairs, so `8192 - (at & 4095)` was typed after its 32-bit literal while the backend
        # computed 64 bits; the `cast<int>` then emitted nothing, and the division stored an i64 into
        # an i32 local, which the optimiser folded to `undef`. It hung Horizon's NVMe multi-block read.
        # `-O2` is the whole test: unoptimised, the oversized store lands on the stack beside the
        # local and the right low half is read back, so the defect is invisible there.
        add_test(NAME codegen_int_minus_address_cast_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/int_minus_address_cast.pol"
            "-DEXPECTED=16 8192 15 7936"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NULL-TEST CHAIN NARROWS EVERY NAME IN IT on the arm where all the tests agree (`||` in the
        # else, `&&` in the then); an `&&` guard clause still narrows nothing below it.
        add_test(NAME codegen_narrow_null_chain_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_null_chain.pol"
            "-DEXPECTED=5 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_narrow_null_chain_and_guard_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_null_chain_bad.pol")
        set_tests_properties(sema_narrow_null_chain_and_guard_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "error\\[Polaron-0300\\]")

        # AN INLINE ARRAY ASSIGNED TO AN INLINE ARRAY FIELD copies its elements. It stored the source's
        # address into the field's first eight bytes. Checked at -O0 and -O2: they failed differently.
        add_test(NAME codegen_inline_array_field_assign_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_array_field_assign.pol"
            "-DEXPECTED=7 8 9 0 | 1 2 3 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_inline_array_field_assign_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_array_field_assign.pol"
            "-DEXPECTED=7 8 9 0 | 1 2 3 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `weak` FIELD IN A STRUCT IS REFUSED: a struct is copied by value and has no end of life a
        # weak node can be unlinked at, so the target's list ended up pointing into dead stack.
        add_test(NAME sema_weak_field_in_struct_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_field_in_struct_bad.pol")
        set_tests_properties(sema_weak_field_in_struct_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "'weak' is not allowed on a field of struct 'Place'")

        # A VALUE STRUCT RETURNED BY A DISPATCHED CALL is given a home like a direct call's result;
        # reassigning a struct local from one crashed. Both optimisation levels, which fail differently.
        add_test(NAME codegen_virtual_struct_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_struct_return.pol"
            "-DEXPECTED=perm 1 | none 0 7 | 0 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_virtual_struct_return_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_struct_return.pol"
            "-DEXPECTED=perm 1 | none 0 7 | 0 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # EACH ARM OF A `match` STARTS FROM THE STATE BEFORE IT: a guard in one arm narrowed the same name
        # in the arms below. What every arm that falls through proves still holds after the `match`.
        add_test(NAME sema_match_arm_narrowing_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/match_arm_narrowing_bad.pol")
        set_tests_properties(sema_match_arm_narrowing_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "argument 1 to 'weigh' is 'nullable Box\\*', which is nullable")
        add_test(NAME codegen_match_arm_narrowing_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_arm_narrowing.pol"
            "-DEXPECTED=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE RIGHT OPERAND OF `&&`/`||` IS TYPED WITH THE LEFT ONE'S PROOF, as an `if` body is -- and
        # only with what it proves: `b == null && weigh(b)` stays refused.
        add_test(NAME codegen_narrow_in_and_value_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_in_and_value.pol"
            "-DEXPECTED=true false true"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_narrow_in_and_value_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_in_and_value_bad.pol")
        set_tests_properties(sema_narrow_in_and_value_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "argument 1 to 'weigh' is 'nullable Box\\*', which is nullable")

        # ...AND EACH ARM OF `?:` WITH WHAT THE CONDITION PROVES FOR IT, a `nullable int` included so
        # the narrowed value reaches the code generator; the arm it does not clear stays refused.
        add_test(NAME codegen_narrow_in_ternary_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_in_ternary.pol"
            "-DEXPECTED=3 0 6 -1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_narrow_in_ternary_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/narrow_in_ternary_bad.pol")
        set_tests_properties(sema_narrow_in_ternary_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "argument 1 to 'weigh' is 'nullable Box\\*', which is nullable")

        # A `nullable int` PROVEN PRESENT IS READ AS THE NUMBER, and a number going to a `nullable`
        # parameter or result is boxed. The code generator has no narrowing, so a proven box arrived
        # as its address: `n + 1` added to the pointer and `int m = n;` stored `undef`, silently.
        add_test(NAME codegen_nullable_primitive_proven_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_primitive_proven.pol"
            "-DEXPECTED=6 -1 5 5 0 true 10 5 -7 3 7 42 -7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_nullable_primitive_proven_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_primitive_proven.pol"
            "-DEXPECTED=6 -1 5 5 0 true 10 5 -7 3 7 42 -7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A STRUCT OVER SIXTEEN BYTES IS RETURNED THROUGH A CALLER-OWNED `sret` SLOT, not as a
        # first-class aggregate: a method with several exits had them joined by a `phi` of the struct,
        # every byte of it spilled -- a 10,952-byte frame in Horizon's path walk. The values arrive
        # from four exits, through an interface and from a static factory; the IR says `sret`.
        add_test(NAME codegen_big_struct_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/big_struct_return.pol"
            "-DEXPECTED=3 198 -2 -1 -3 7 198"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_big_struct_return_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/big_struct_return.pol"
            "-DEXPECTED=3 198 -2 -1 -3 7 198"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME ir_big_struct_returns_through_a_slot COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/big_struct_return.pol"
            "-DNEEDLE=sret(%class.Answer)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")

        # A POINTER FIELD IN A COPIED STRUCT IS SHARED, NOT CLONED. The field's type name is kept
        # without its stars, so `Box*` read as `Box` and the copy allocated a fresh Box.
        add_test(NAME codegen_struct_pointer_field_shared_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_pointer_field_shared.pol"
            "-DEXPECTED=true 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A NUMBER BACK TO AN ENUM WITH DATA: `cast<Pair>(i)` picks the constant, and a number outside
        # the set is a ClassCastException. It was refused by the analyzer and miscompiled past it.
        add_test(NAME codegen_data_enum_from_ordinal_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/data_enum_from_ordinal.pol"
            "-DEXPECTED=37 1 refused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_data_enum_from_ordinal_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/data_enum_from_ordinal.pol"
            "-DEXPECTED=37 1 refused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and on bare metal the refusal is the failure report, never a throw nothing can catch.
        # Built for the bare-metal target, as a kernel is: without one, a `freestanding` program is
        # lowered for the host and has the host's unwinder.
        add_test(NAME codegen_freestanding_data_enum_from_ordinal_throws_nothing COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_data_enum_from_ordinal.pol"
            "-DPOLARONFLAGS=--target=x86_64-unknown-none-elf"
            "-DNEEDLE=__cxa_throw"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # AN `eternal` OBJECT IN `main` MAY BE KEPT BY ANOTHER ONE: the entry point's frame lasts the run.
        # The same lines in a method that returns stay refused.
        add_test(NAME codegen_eternal_in_entry_is_kept_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/eternal_in_entry_is_kept.pol"
            "-DEXPECTED=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_eternal_outside_entry_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/eternal_outside_entry_bad.pol")
        set_tests_properties(sema_eternal_outside_entry_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "region-binder: 'register' keeps that argument")

        # A `weak` FIELD LEAVES ITS TARGET'S LIST WHEN ITS HOLDER DIES, including a holder deleted from a
        # region through its base class. The target's delete nulled a field in the reused slot.
        add_test(NAME codegen_weak_holder_dies_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_holder_dies.pol"
            "-DEXPECTED=reused 1 sees 7 after 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_weak_holder_dies_o2_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O2"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_holder_dies.pol"
            "-DEXPECTED=reused 1 sees 7 after 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A PROGRAM'S OWN TYPE NAMED LIKE A LIBRARY GENERIC (`Result`) is visible where it is declared.
        # It was warned "yours wins" and then refused at its own declaration, told to import the other.
        add_test(NAME codegen_own_type_named_like_library_generic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/own_type_named_like_library_generic.pol"
            "-DEXPECTED=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A BORROW TAKEN AFTER ITS SOURCE WAS EMPTIED is a borrow of what the source holds now: an
        # emptying strands the borrows live at that moment and no later one. It was kept per source,
        # so every `people.at(0)` after a `people.clear()` was refused, and a destructor could not
        # read a field after its own cleanup. The old borrow is still refused (the `_bad` twin).
        add_test(NAME codegen_borrow_taken_after_clear_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_taken_after_clear.pol"
            "-DEXPECTED=10 30 spare 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_borrow_taken_before_clear_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/borrow_taken_after_clear_bad.pol")
        set_tests_properties(sema_borrow_taken_before_clear_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "use of 'before' after 'people' was emptied"
            FAIL_REGULAR_EXPRESSION "use of 'after' after")

        # DELETING WHAT A CARRIER HANDED OVER. A result struct that frees nothing lends no storage it
        # owns, so deleting what `file()` returned is the owner's cleanup, not a second free. It was
        # refused as one (sema_rejects_deleting_a_borrow keeps the owning case refused).
        add_test(NAME codegen_delete_what_a_carrier_handed_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_what_a_carrier_handed.pol"
            "-DEXPECTED=made 7 ~Box 7 refused 22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A VALUE STRUCT ARGUMENT TO A DISPATCHED CALL travels by value, as it does to a direct one.
        # The virtual path pushed arguments unconverted, so a struct in storage went as its address.
        add_test(NAME codegen_virtual_struct_argument_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_struct_argument.pol"
            "-DEXPECTED=7 7 15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # IDENTITY BETWEEN A `nullable T*` AND A `T*` compiles and answers correctly; a pointer to an
        # unrelated type is still refused (sema_nullable_pointer_identity_other_type_refused).
        add_test(NAME codegen_nullable_pointer_identity_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_pointer_identity.pol"
            "-DEXPECTED=found second, head is not second, nothing is null"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME sema_nullable_pointer_identity_other_type_refused
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable_pointer_identity_bad.pol")
        set_tests_properties(sema_nullable_pointer_identity_other_type_refused PROPERTIES
            PASS_REGULAR_EXPRESSION "operator '==' requires operands of the same type")

        add_test(NAME codegen_region_header_fits_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_header_fits.pol"
            "-DEXPECTED=header fits"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the same thing over a POOL region, which the test above does not reach: the three
        # flavors took three arms of one `else if` in the lowering, and only the arm the bump region
        # took emptied the local. A pool RECLAIMS the slot, so the second destruct landed on the
        # object that had reused it -- `~Dog 3 ~Dog 2 ~Dog 3`. `reused 1` holds the pool to actually
        # reclaiming, without which the bug stops being observable and this stops testing for it.
        add_test(NAME codegen_delete_from_pool_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/delete_from_pool_region.pol"
            "-DEXPECTED=before ~Dog 1 mid reused 1 ~Dog 3 ~Dog 2 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `for (i in 0..n)` inside a generic class CRASHED the compiler: `cloneExpr` had never been
        # taught `RangeExpr`, so expansion returned null for the iterable and the analyzer's foreach
        # dereferenced it. All three range forms are exercised, because all three go through it.
        add_test(NAME codegen_generic_range_for_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_range_for.pol"
            "-DEXPECTED=total=232"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A static field in a generic class -- unusable until now, because the implicit-this pass
        # qualifies a bare field with the TEMPLATE's name and monomorphization then renames the
        # class. Per-instantiation sharing is checked too: Box<int> and Box<boolean> have their own.
        add_test(NAME codegen_generic_static_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_static_field.pol"
            "-DEXPECTED=7 shared=2 other=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `sealed enum E permits A, B, C;` and a `match` over its constants -- the form the
        # specifications write throughout, refused twice over until now: at the parser (`sealed`
        # was only for classes; `case Caught {` wanted positional bindings) and at the analyzer
        # (a case name was looked up as a TYPE).
        add_test(NAME codegen_sealed_enum_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed_enum_match.pol"
            "-DEXPECTED=40 0 0 count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `permits` enum with a BODY, and a total match-EXPRESSION over its own constants inside
        # one of its methods. Two halves of the same missing thing: `permits` said what the constants
        # are and then refused to let them do anything, and the expression form of `match` looked
        # every case name up as a TYPE -- so the two spellings of `sealed enum` and the two forms of
        # `match` each disagreed about what they could handle, for no reason anybody chose. An enum
        # whose whole point is that every case is named is the first thing you want to answer a
        # question with, arm by arm, with no `default` to hide the constant added next year.
        add_test(NAME codegen_sealed_enum_permits_body_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed_enum_permits_body.pol"
            "-DEXPECTED=it was caught it got away it ran out of food n=3 ord=2 sz=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And what the word buys: the constant added later is NAMED at every match that forgot it,
        # instead of being swallowed by a `default`.
        add_test(NAME sema_rejects_inexhaustive_sealed_enum_match COMMAND polc
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed_enum_match_bad.pol")
        set_tests_properties(sema_rejects_inexhaustive_sealed_enum_match PROPERTIES
            PASS_REGULAR_EXPRESSION "not exhaustive: missing Escaped")

        # A LITERAL that does not fit a bit field is REFUSED, and a computed value is still
        # truncated. The line is drawn between what the compiler can read and what it cannot:
        # `b.state = 6` into three signed bits is a mistake it can see with nothing to run, and
        # there is no reading of it under which the author wanted -2. Truncation stays for counts
        # and sums -- spec 11.1 -- and `bit_fields.pol` tests that half, through variables.
        #
        # Raised from a warning on 2026-08-13 because of what the warning found: the fauna layout of
        # a real game budgeted `int state : 3` for eight states and `int species : 5` for eighteen,
        # in a document whose every other number had been measured.
        #
        # BOTH MACHINES FOUND THIS THE SAME DAY AND MADE THE SAME CALL. The fork's `bit_fields.pol`
        # already says so in its own header -- "a LITERAL that does not fit is refused instead" --
        # and moves its overflowing values through variables for exactly this reason. Only its test
        # was left asking for the warning that the sample had stopped emitting.
        add_test(NAME sema_rejects_bitfield_literal_overflow COMMAND polc
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/bit_field_literal_bad.pol")
        set_tests_properties(sema_rejects_bitfield_literal_overflow PROPERTIES
            PASS_REGULAR_EXPRESSION "does not fit 'state'")

        # A packed bit field still has no address. Untested until the guard that says so was
        # rewritten to stop type-probing a type-name receiver -- see static_field_address.pol.
        add_test(NAME sema_rejects_bitfield_address COMMAND polc
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/bit_field_address_bad.pol")
        set_tests_properties(sema_rejects_bitfield_address PROPERTIES
            PASS_REGULAR_EXPRESSION "cannot take the address of 'mode'")

        # And the computed half still compiles clean: same struct, same overflow, through a variable.
        add_test(NAME sema_accepts_bitfield_runtime_truncation COMMAND polc
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/bit_fields.pol")

        # A `fixed` may be defined in terms of another one, in another class, declared LATER --
        # constants fold to a fixed point rather than in declaration order. It was legal only when
        # the other constant happened to come first, in a file the compiler happened to read first,
        # and the diagnostic blamed the initializer for not being constant when it plainly was.
        add_test(NAME codegen_fixed_from_other_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fixed_from_other_class.pol"
            "-DEXPECTED=cut=6200 half=3100 band=2 name=6200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And a ring of them still fails, with a message that says so rather than blaming the
        # initializer for not being a constant.
        add_test(NAME sema_rejects_constant_ring COMMAND polc
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/fixed_ring_bad.pol")
        set_tests_properties(sema_rejects_constant_ring PROPERTIES
            PASS_REGULAR_EXPRESSION "ring of")

        # A value struct with no constructor starts at ZERO. A class was always safe -- the analyzer
        # refuses a constructor that leaves a field unassigned -- and a struct that declares none had
        # nobody to hold to that promise, so it came back holding the stack. Found in a real game the
        # first time one was used: a fresh bitmask claimed memberships nobody had granted. A struct
        # that DOES declare a constructor is untouched, which the sample checks too.
        add_test(NAME codegen_struct_starts_at_zero_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_starts_at_zero.pol"
            "-DEXPECTED=fresh: n=0 bits=0 flag=0 set: bit3=1 bit4=0 own: n=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A PROGRAM CAN FAIL ON PURPOSE. `main` returns void, so every LDP3 program exited 0 -- one
        # that printed "I do not know that command" and one that did what it was asked were the same
        # run to a script, a build, or a gate. Checked on both halves: the code arrives, and what was
        # printed before it still reaches the reader (`exit`, not `_exit`).
        add_test(NAME codegen_exit_code_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exit_code.pol"
            "-DEXPECTED=refused: I do not know that command"
            "-DEXPECT_EXIT=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `System.OS.Signals`: installing an interrupt handler without an `extern cdecl` in user
        # code. The debt is recorded in docs/design/interrupt.md -- the keyword worked and every
        # user of it had to declare `signal()` themselves. The extern still exists, once, in the
        # library. Installs for real and hands the signal back.
        add_test(NAME codegen_signals_answer_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/signals_answer.pol"
            "-DEXPECTED=installed=1 asked=0 after=2 gaveback=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A name declared in two namespaces re-clones every class, and the cloner knew four of the
        # six kinds of member: a `comptime literal` and a `fixed` came back null and were DROPPED.
        # The visible failure was `import System.Memory.Units.kilobytes` reported as an unknown
        # symbol -- an import of the standard library breaking because of a collision elsewhere.
        add_test(NAME codegen_qualify_keeps_members_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/qualify_keeps_members.pol"
            "-DEXPECTED=42 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # numeric widening + compile-time literal coercion: a fitting literal initializes a narrower
        # type, narrow integers widen, and mixed-width values compare after widening.
        add_test(NAME codegen_numeric_widen_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/numeric_widen.pol"
            "-DEXPECTED=b=9 s=300 i=5 total=305 eq=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # interface default methods (spec 9): an interface method body is inherited unless overridden;
        # the default dispatches other interface methods on `this` virtually.
        add_test(NAME codegen_interface_default_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interface_default.pol"
            "-DEXPECTED=alice=101 bob=999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # inherited class invariants (spec 29): a base invariant is checked on a subclass method's
        # exit too; here every step keeps it satisfied, so the program completes.
        add_test(NAME codegen_inherited_invariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inherited_invariant.pol"
            "-DEXPECTED=count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach with an index variable (spec 7.6): `for (index i, T v in ...)` over array + range.
        add_test(NAME codegen_foreach_index_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_index.pol"
            "-DEXPECTED=dot=200 last=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # for-in over an integer range (spec 7.5): exclusive `..`, inclusive `..=`, and `step`.
        add_test(NAME codegen_for_range_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/for_range.pol"
            "-DEXPECTED=excl=10 incl=15 step=20 count=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comefrom (spec 7.10): the jump is written at the DESTINATION. Reaching `label L;` is
        # hijacked to wherever `comefrom L;` sits -- forward it steals (the code after the label
        # never runs), backward it retries (the comefrom is a no-op on the way down).
        add_test(NAME codegen_comefrom_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comefrom.pol"
            "-DEXPECTED=start forward ok n=1 n=2 n=3 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a `comefrom` that leaves a scope runs its teardown (destructors/defers/String/region),
        # like `goto` -- Noisy's dtor fires when comefrom exits the if-body. Prints start / ~1 / after.
        add_test(NAME codegen_comefrom_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comefrom_cleanup.pol"
            "-DCONTAINS=~1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: abstainfrom that skips a stack-object decl also skips its destructor -- no dtor on
        # unconstructed memory (no-UB). run(0)=cbd (ctor/body/dtor), run(1) abstained=nothing. Prints cbd|!
        add_test(NAME codegen_abstain_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/abstain_raii.pol"
            "-DEXPECTED=cbd|!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic constraint (spec 15.2) satisfied + a chained call on a generic method result.
        add_test(NAME codegen_generic_constraint_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_constraint.pol"
            "-DEXPECTED=area = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: structured exceptions via WinEH -- throw, unwind, catch (spec 21.1).
        add_test(NAME codegen_exceptions_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions.pol"
            "-DEXPECTED=before caught code=42 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: an exception thrown in a called method unwinds to the caller's catch (invoke).
        add_test(NAME codegen_exceptions_propagate_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_propagate.pol"
            "-DEXPECTED=caught code=7 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: finally runs on both the caught path and the normal-completion path.
        add_test(NAME codegen_exceptions_finally_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_finally.pol"
            "-DEXPECTED=caught finally body ok finally"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: typed multi-catch matched in order against the exception's dynamic type (subtype-aware).
        add_test(NAME codegen_exceptions_typed_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_typed.pol"
            "-DEXPECTED=app code=5 kind=2 net code=9 kind=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: RAII on unwind -- stack destructors run (reverse order) as an exception propagates out.
        add_test(NAME codegen_exceptions_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_raii.pol"
            "-DEXPECTED=dtor 2 dtor 1 caught 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: nested try + rethrow -- an unmatched inner exception reaches the enclosing catch.
        add_test(NAME codegen_exceptions_nested_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_nested.pol"
            "-DEXPECTED=outer B code=2 tag=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: throw inside a catch handler propagates to the outer try; stack object + try coexist.
        add_test(NAME codegen_exceptions_edge_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions_edge.pol"
            "-DEXPECTED=rethrow as B outer B 2 caught A dtor 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # WHAT THE ITANIUM MODEL HAS TO EMIT, read off the IR rather than by running it -- because
        # this machine is Windows and the model under test is the other one. Four needles, one test
        # each, so a failure says WHICH half is missing: the exception the runtime allocated, the
        # clause that routes a Polaron throw into our handler, and the pair that takes the object out
        # and ends the catch.
        #
        # Before these existed, the Itanium `Op::Landing` stored field 0 of the landing pad -- the
        # `_Unwind_Exception*` header -- as the caught object. No clause ever matched, every
        # exception was re-raised out of its own function, and forty-five tests on Linux died with
        # `terminate called without an active exception` while the Windows corpus stayed green: the
        # back end had only ever been validated against one of the two models it claims to support.
        foreach(_probe "allocates|__cxa_allocate_exception"
                       "names_void_ptr|catch ptr @_ZTIPv"
                       "begins_catch|__cxa_begin_catch"
                       "ends_catch|__cxa_end_catch")
            string(REPLACE "|" ";" _parts "${_probe}")
            list(GET _parts 0 _name)
            list(GET _parts 1 _needle)
            add_test(NAME codegen_exceptions_itanium_${_name} COMMAND "${CMAKE_COMMAND}"
                "-DPOLC=$<TARGET_FILE:polc>"
                "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions.pol"
                "-DNEEDLE=${_needle}"
                "-DTARGET_TRIPLE=x86_64-unknown-linux-gnu"
                "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
                -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_contains_test.cmake")
        endforeach()

        # ...AND THE OTHER MODEL MUST NOT GAIN ANY OF IT. Which model is used is decided by the
        # triple, and the Windows corpus is the one that has always worked: an `__cxa_begin_catch`
        # appearing in a module built for `windows-msvc` would mean that choice broke, which is the
        # one way this work could damage what already passes.
        add_test(NAME codegen_exceptions_msvc_has_no_itanium_catch COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/exceptions.pol"
            "-DNEEDLE=__cxa_begin_catch"
            "-DPOLARONFLAGS=--target=x86_64-pc-windows-msvc"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ir_absent_test.cmake")

        # THE SHAPE THE VERIFIER HAD BEEN POINTING AT ALL ALONG: a virtual call inside a `try`,
        # whose callee throws. The handler must run, and on BOTH models it did not -- the call went
        # through the object's table as an ordinary call, with no edge to the handler, so the throw
        # left the function past a `catch` written to stop it.
        #
        # `Test.assertDoesNotThrow` is the standard library's own instance of this, which is why no
        # program's own code ever ran the shape: it is only emitted in a `--lib` build.
        add_test(NAME codegen_virtual_call_in_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_call_in_try.pol"
            "-DEXPECTED=quiet caught code=9 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: Result<T,E>/Option<T> built-in sealed sum types matched exhaustively (no default).
        add_test(NAME codegen_result_option_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_option.pol"
            "-DEXPECTED=r=7 e=-404 some 9 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value Result<T,E> / Option<T> (spec 21, value form): no `*` -> a tagged-union value, so Ok/Err/
        # Some/None allocate nothing and a hot loop of them is malloc-free (the E5 fix).
        add_test(NAME codegen_value_result_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_result.pol"
            "-DEXPECTED=ok 21 err 1 some 5 loopsum=499500"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # try? on a value Result/Option (spec 21.2): yields the payload on Ok/Some, early-returns the value
        # on Err/None (propagation) -- no boxing. Also a reference payload and a value Result by value.
        add_test(NAME codegen_value_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_try.pol"
            "-DEXPECTED=a=10 b=-3 ok=5 some=40 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value/boxed Result interop (spec 21): `delete` on a value Result is a no-op (owns no heap), and
        # the boxed form (`*`) keeps working side by side.
        add_test(NAME codegen_value_compat_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_compat.pol"
            "-DEXPECTED=v=7 boxed=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: Ok(x)/Err(x)/Some(x)/None() construction sugar in return and typed var-decl positions.
        add_test(NAME codegen_result_sugar_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_sugar.pol"
            "-DEXPECTED=a=7 b=-404 c=5 d=-404 some 9 none"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F6: try? propagation -- Ok/Some yields the value, Err/None early-returns to the caller.
        add_test(NAME codegen_result_try_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result_try.pol"
            "-DEXPECTED=a=10 b=-3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a generic class/method body containing a `match` (monomorphizer used to crash).
        add_test(NAME codegen_generic_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_match.pol"
            "-DEXPECTED=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistents (spec 18, F7): in-process semantics -- a `static persistent` is run-lifetime
        # storage, like a static field. bump() 3x in one run -> runs = 3.
        add_test(NAME codegen_persist_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_demo.pol"
            "-DEXPECTED=runs = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistents in LOCALS (spec 18): a persistent local reattaches across CALLS within a run
        # (it is not reinitialized). 3 calls -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_local.pol"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # object reattach (spec 18.2): a persistent INSTANCE field lives outside the object and
        # survives delete, reattaching when the variable is recreated within the run -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_object_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_object.pol"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # object reattach via `this` (spec 18.2): methods/ctor reach the persistent through the
        # object's __persist pointer; chassi keeps counting across calls in one run -> a=1 b=2 c=3.
        add_test(NAME codegen_persist_this_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_this.pol"
            "-DEXPECTED=a=1 b=2 c=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: inline field initializers + synthesized default constructor.
        add_test(NAME codegen_field_init_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/class_field_init.pol"
            "-DEXPECTED=area = 1920"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M4: no-ceremony forms - `new T()` defaulting to stack + println.
        add_test(NAME codegen_ergonomics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ergonomics.pol"
            "-DEXPECTED=x = 15 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5: dynamic int array - new T[n](), a[i] r/w, a.length(), delete.
        add_test(NAME codegen_arrays_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arrays.pol"
            "-DEXPECTED=sum=45 len=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5: char[] field, written/read via this.cells[i], freed in destructor.
        add_test(NAME codegen_board_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/board.pol"
            "-DEXPECTED=XOX"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M5+: string interpolation lowered to printf (%d/%c inferred per type).
        add_test(NAME codegen_interpolation_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interpolation.pol"
            "-DEXPECTED=score: 10 x 7 turn of X sum = 17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Console.read() reads a line as a String; toInt() parses it. stdin "3\n4" -> a=3 b=4 sum=7.
        add_test(NAME codegen_readint_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.pol"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/read_echo.in"
            "-DEXPECTED=a=3 b=4 sum=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M7 north-star: full tic-tac-toe; scripted moves 1,4,2,5,3 -> X wins.
        add_test(NAME codegen_tictactoe_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.pol"
            "-DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/samples/tic_tac_toe.in"
            "-DCONTAINS=Player X wins!"
            "-DEXPECTED="
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M8: structural inheritance - inherited field/method + implicit super().
        add_test(NAME codegen_inherit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inherit.pol"
            "-DEXPECTED=woof! legs=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M8: virtual dispatch - base-typed variable calls the derived override.
        add_test(NAME codegen_polymorphism_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/polymorphism.pol"
            "-DEXPECTED=woof meow"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M10: the closing north-star - enum + interface + abstract + override +
        # virtual dispatch, all in one program.
        add_test(NAME codegen_shapes_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/shapes.pol"
            "-DEXPECTED=Square (kind 0) area: 16 Circle (kind 1) area: 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Multi-interface dispatch: a class implementing two interfaces must send
        # each interface's call to the right (global) vtable slot.
        add_test(NAME codegen_multi_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/multi_iface.pol"
            "-DEXPECTED=name 7 size 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # M9: simple int-style enum (constants as ordinals, comparison).
        add_test(NAME codegen_enums_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enums.pol"
            "-DEXPECTED=is red? true blue code = 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase A1: pointers/refs share an instance (T* + address-of).
        add_test(NAME codegen_pointers_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointers.pol"
            "-DEXPECTED=b=5 p=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase A2: value semantics - `T b = a` copies, `T* p = &a` shares.
        add_test(NAME codegen_value_semantics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_semantics.pol"
            "-DEXPECTED=after copy: a=1 b=99 after share: a=42 p=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the mistake that follows from it: changing an object received BY VALUE changes a
        # copy, so the caller's object is left as it was and nothing fails. Three of these were found
        # in the standard library in one night, all silent. The sample runs so the two halves are
        # visible side by side -- the by-value one really does come out zero.
        add_test(NAME codegen_byvalue_mutation_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/byvalue_mutation_warn.pol"
            "-DEXPECTED=byValue=0 byPointer=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase B: ownership - `move` transfers, source becomes invalid.
        add_test(NAME codegen_ownership_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ownership.pol"
            "-DEXPECTED=moved value = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # 0.2 Fase D: scoped resources - using disposes; defer runs LIFO at end.
        add_test(NAME codegen_scoped_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/scoped.pol"
            "-DEXPECTED=inside using closing 3 body deferred 2 deferred 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Types: floating point - double arithmetic and int -> float widening.
        add_test(NAME codegen_floats_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/floats.pol"
            "-DEXPECTED=pi=3.14 area=12.56 half=1.5 n=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Types: wide integers - int64/long and int -> long widening.
        add_test(NAME codegen_bitwidths_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwidths.pol"
            "-DEXPECTED=big=10000000000 sum=10000000005 wide=200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Short-circuit && / || : the right operand runs only when needed.
        # Exact match: any extra "touched!" would mean the right side ran eagerly.
        add_test(NAME codegen_short_circuit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/short_circuit.pol"
            "-DEXPECTED=or-ok touched! and-ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Explicit numeric casts: narrowing, float->int truncation, int->float.
        add_test(NAME codegen_casts_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/casts.pol"
            "-DEXPECTED=low = 5 truncated = 3 d = 3.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Explicit super(args): forward arguments to the base constructor.
        add_test(NAME codegen_super_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/super_args.pol"
            "-DEXPECTED=legs = 4 barks = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Unsigned integers: udiv, unsigned compare, %u / %llu printing.
        add_test(NAME codegen_unsigned_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unsigned.pol"
            "-DEXPECTED=big = 3000000000 half = 1500000000 big > 1 = true huge = 18000000000000000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # float is f32, double is f64: 2^24+1 survives in f64 but not in f32.
        add_test(NAME codegen_floats32_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/floats32.pol"
            "-DEXPECTED=f32 back = 16777216 f64 back = 16777217 pi = 3.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Deep value copy: copying a class duplicates its array, so mutating the
        # copy leaves the original untouched.
        add_test(NAME codegen_deep_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy.pol"
            "-DEXPECTED=a[0] = 10 b[0] = 999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # struct: value type with fields/constructor/methods; copy is independent.
        add_test(NAME codegen_structs_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/structs.pol"
            "-DEXPECTED=sum = 7 p.x = 3 q.x = 100"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime literal suffix function at namespace level (called explicitly).
        add_test(NAME codegen_literals_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/literals.pol"
            "-DEXPECTED=size = 65536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # import + `N suffix` syntax: 64 kib -> kib(64), enabled by the import.
        add_test(NAME codegen_suffixes_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/suffixes.pol"
            "-DEXPECTED=size = 65536"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Embedded stdlib: import System.Memory.Units + ByteSize via `N unit`.
        add_test(NAME codegen_units_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/units.pol"
            "-DEXPECTED=a = 65536 b = 2097152"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regions: itself.allocate arena, new ... in region (bump), release.
        add_test(NAME codegen_regions_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/regions.pol"
            "-DEXPECTED=a = 3 b = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A UTF-8 BOM made every document parser return an empty tree, in silence: three bytes that
        # every Windows editor writes and no format expects. Found by rendering an SVG written with
        # PowerShell -- a valid file, a blank image, and nothing anywhere to say why.
        add_test(NAME codegen_bom_documents_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bom_documents.pol"
            "-DEXPECTED=xml root kids 1"
            "-DCONTAINS=toml 8080"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `ArrayList<int[]>` -- a list of buffers -- did not compile at all: an array has no
        # `equalsKey`, so the failure surfaced inside the standard library for a collection the
        # caller merely declared. An array is a reference and answers by identity, which is why the
        # equal-looking twin is NOT found.
        add_test(NAME codegen_collection_of_arrays_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_of_arrays.pol"
            "-DEXPECTED=count 2"
            "-DCONTAINS=has a true has twin false"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A region carved out of another region: nesting in SPACE, where §10 gave only nesting in
        # scope. The child's block comes from the parent, so a per-phase arena inside a per-world one
        # costs no second allocation and releasing the world reclaims every arena in it at once.
        # The parent's own objects survive the child's release, which is what the second line checks.
        add_test(NAME codegen_subregion_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/subregion.pol"
            "-DEXPECTED=frame 2 world 1"
            "-DCONTAINS=after 1 cat 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region flavor (spec 17, flavors expansion): a `pool region` parses, allocates and runs.
        add_test(NAME codegen_region_pool_parse_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_pool_parse.pol"
            "-DEXPECTED=age=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Pool region reclaim: 200000 objects churned through a 4 KiB region (holds ~128 slots) complete
        # only because `delete X from region` returns each slot to the free-list -- no overflow panic.
        add_test(NAME codegen_region_pool_churn_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_pool_churn.pol"
            "-DEXPECTED=sum=9900000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extract X from region R: relocate an object to the heap; it survives the region's release, and
        # is then deleted by the caller (spec 17, flavors expansion).
        add_test(NAME codegen_region_extract_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_extract.pol"
            "-DEXPECTED=out=42 still=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # stack region mark/rollback (spec 17): 100000 objects churn through an 8 KiB stack region across
        # 1000 mark/rollback rounds -- works only via cursor rewind, and every object is destructed
        # (runtime registry), so the counter is exact.
        add_test(NAME codegen_region_stack_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_stack.pol"
            "-DEXPECTED=destroyed=100000 final=100001"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `toString` ON A STRING, which had no builtin and therefore lowered to NOTHING.
        #
        # A String method is a builtin here, and one that is not covered records a gap rather than
        # falling through to whatever unrelated class declares that name. But a gap emits no value, so
        # an expression that wanted the string got one that was never computed. Horizon's kernel
        # printed `String.toString(no builtin)` on every build until this was added.
        #
        # The concatenations are the assertion. A compiler that returned the receiver by accident
        # would satisfy `direct` alone; joining proves a real value came back, and asking the result
        # its length proves it is the object that went in.
        add_test(NAME codegen_string_tostring_identity_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_tostring_identity.pol"
            "-DEXPECTED=direct horizon joined name=horizon twice horizonhorizon len 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND A CHECKPOINT THAT CROSSES A METHOD BOUNDARY, which the sample above does not.
        #
        # `region_stack.pol` marks and rolls back inside one method, so its checkpoint is never a
        # return value or a parameter -- and the whole of this bug lived in that gap. `checkpoint` was
        # missing from the table mapping a type name to a machine type, so it became an opaque struct:
        # `returns checkpoint` computed the cursor and emitted `ret undef`, and a `checkpoint`
        # parameter arrived as undef. `rollback` then set the region's cursor to whatever was in the
        # register.
        #
        # `after=0` is the assertion. The cursor after the last rewind must be exactly where it was
        # before the first allocation; a lost mark makes it a number nobody chose.
        add_test(NAME codegen_checkpoint_crosses_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checkpoint_crosses_methods.pol"
            "-DEXPECTED=empty=0 after=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # fixedslot region (single-size pool, spec 17): the pool churn through a one-type region reclaims.
        add_test(NAME codegen_region_fixedslot_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_fixedslot.pol"
            "-DEXPECTED=sum=9900000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ring region (circular buffer, spec 17): 10 writes into a 3-entry ring evict the oldest 7 (their
        # destructors run); release destructs the 3 still live.
        add_test(NAME codegen_region_ring_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_ring.pol"
            "-DEXPECTED=evicted=7 final=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # growable region (spec 17): 1000 live objects grow a 256-byte region past its initial block by
        # chaining -- a fixed region would overflow. release frees the whole chain.
        add_test(NAME codegen_region_growable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_growable.pol"
            "-DEXPECTED=sum=24500"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A flavor on a region FIELD (spec 17): a `pool region` field churns + reclaims via `this.field`.
        add_test(NAME codegen_region_field_pool_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_field_pool.pol"
            "-DEXPECTED=s=100000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region accepts/rejects: an accepted type is allowed.
        add_test(NAME codegen_region_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_constraints.pol"
            "-DEXPECTED=d = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # record: compact value type with fields, a method and auto equals().
        add_test(NAME codegen_records_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/records.pol"
            "-DEXPECTED=sum = 7 p==q true p==r false"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # record with float/double fields: the synthesized toString() renders each field through
        # that field's toString(), so this regressed the whole declaration when float had none.
        add_test(NAME codegen_record_float_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/record_float_field.pol"
            "-DEXPECTED=Sample(3, 1.5, 2.25) 0.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enum: constants with constructor args, fields and methods.
        add_test(NAME codegen_enum_java_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_java.pol"
            "-DEXPECTED=earth = 5 mars = 10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: `delete` of a Java-style enum array must not double-free the shared singletons.
        add_test(NAME codegen_enum_array_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_array_delete.pol"
            "-DCONTAINS=deleted ok"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: reflection Field.get() reads int fields after reference/wide fields at the right offset.
        add_test(NAME codegen_reflect_field_after_ref_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_field_after_ref.pol"
            "-DEXPECTED=capX=111 capY=222 leaderIdx=333"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: reflection fields() enumerates inherited fields too, and Field.get() reads them.
        add_test(NAME codegen_reflect_inherited_fields_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_inherited_fields.pol"
            "-DEXPECTED=count=2 inherited a=11 own b=22"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct works as a HashMap key and TreeSet element (synthesized hash/equalsKey/compareTo).
        add_test(NAME codegen_value_struct_keys_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_struct_keys.pol"
            "-DEXPECTED=get=100 has55=no treesize=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression: a value struct with many numeric fields (26 here) gets a synthesized structural
        # hash() whose deep arithmetic chain used to make codegen's typeName cost O(4^fields) -- it hung
        # the compiler (e.g. OpenGL's 26-field PixelFormatDescriptor under --lib). Must compile fast now.
        add_test(NAME codegen_struct_wide_hash_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/struct_wide_hash.pol"
            "-DEXPECTED=got=770 size=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Generics: monomorphized Box<int>/Box<double> (distinct) and Pair<A,B>.
        add_test(NAME codegen_generics_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generics.pol"
            "-DEXPECTED=bi=42 bd=2.5 first=7 second=X"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Operator overloading: a + b dispatches to the class's operator method.
        add_test(NAME codegen_operators_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operators.pol"
            "-DEXPECTED=c = 11 22 33"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Properties: auto (get/set, get/init) and a computed get-only property.
        add_test(NAME codegen_properties_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/properties.pol"
            "-DEXPECTED=area = 12 w = 3 h = 4 area = 40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Multiple files forming one program: Main (part B) uses Greeter (part A).
        add_test(NAME codegen_multifile_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_a.pol"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/multifile_b.pol"
            "-DEXPECTED=greet = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Same type name in two namespaces of a multi-file program: legal (namespaces scope type
        # names), disambiguated internally to <ns>__Type. The import validator used to look up only
        # the bare name, miss it after the rename, and reject the import as an unknown symbol.
        add_test(NAME codegen_ns_collision_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ns_collision_a.pol"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/ns_collision_b.pol"
            "-DEXPECTED=geo=7 phys=20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Bundle-first import: `import main.lib.Calc;` names the bundle, and part B (namespace app)
        # reaches Calc (namespace lib) across namespaces.
        add_test(NAME codegen_bundle_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_import_a.pol"
            "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/bundle_import_b.pol"
            "-DEXPECTED=sum = 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # C-style union: fields share storage (write asFloat, read asInt bits).
        add_test(NAME codegen_unions_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unions.pol"
            "-DEXPECTED=bits = 1069547520 back = 1.5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match: dynamic type dispatch with positional field destructuring.
        add_test(NAME codegen_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match.pol"
            "-DEXPECTED=square side = 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # sealed + exhaustive match (no default needed since all permits covered).
        add_test(NAME codegen_sealed_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed.pol"
            "-DEXPECTED=circle r = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match as an expression (spec 16.2): each arm yields a value via `->`.
        add_test(NAME codegen_match_expr_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_expr.pol"
            "-DEXPECTED=area = 27 area = 25 d = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # contracts (spec 29): requires/ensures (with old()) + invariant runtime checks, happy path.
        add_test(NAME codegen_contracts_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contracts.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.pol"
            "-DPANIC=requires this.seats >= wanted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_names_the_method COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.pol"
            "-DPANIC=in Gate.admit"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_names_the_place COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.pol"
            "-DPANIC=contract_report.pol:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_contract_shows_the_values COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report.pol"
            "-DPANIC=left = 4, right = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # AND THE SAME BARE METAL. The values were the one part of the message a freestanding program
        # did without: `__polaron_panic` takes a finished string and a kernel has no stdio to build one
        # with, so codegen dropped them before the call. They now go through the same `__polaron_fail` in
        # both targets, and the driver emits a reporter that formats them and hands the whole message
        # to that same panic (src/driver/build.cpp).
        #
        # A SEPARATE test from the hosted one above rather than a second needle on it: what regresses
        # here is a branch on `isFreestanding`, so a hosted program can keep passing while every kernel
        # loses the line -- which is exactly what used to happen. This sample is a `freestanding`
        # program compiled and run hosted, the way the other freestanding samples are; the bare-metal
        # formatter itself is proved by the kernel that dogfoods it.
        add_test(NAME codegen_freestanding_contract_shows_the_values COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report_freestanding.pol"
            "-DPANIC=left = 4, right = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        # The clause, the place and the method were never missing bare metal -- only the values were.
        # Pinned so a future simplification of the message cannot take the rest of it with them.
        add_test(NAME codegen_freestanding_contract_names_the_clause COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/contract_report_freestanding.pol"
            "-DPANIC=requires this.seats >= wanted"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # The same treatment for the no-UB guards, which had the same fault: `array index out of
        # bounds` names the KIND of accident and withholds what finds it. The index and the length
        # together usually make the mistake obvious on sight, and both were in registers already.
        add_test(NAME codegen_bounds_shows_the_numbers COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.pol"
            "-DPANIC=index = 9, length = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_bounds_names_the_method COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.pol"
            "-DPANIC=in Shelf.at"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        add_test(NAME codegen_bounds_names_the_place COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bounds_report.pol"
            "-DPANIC=bounds_report.pol:"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")

        # System.Memory.Buffer (spec 17.8): an owned block of raw bytes whose LENGTH TRAVELS WITH THE
        # POINTER. Allocator hands out a bare address and Raw reads wherever it is pointed; Buffer is
        # the pair made safe, and it frees itself, so the two commonest raw-memory faults stop being
        # possible to write by accident.
        add_test(NAME codegen_memory_buffer_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer.pol"
            "-DEXPECTED=length = 32 ints = 7 11 byte = 3 long = 1234567 last = 99 copied = 42 generic = 55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # Writing past the end stops the program and says which clause, where, and with what numbers.
        # A bounds check that cannot be seen failing is indistinguishable from no bounds check.
        add_test(NAME codegen_memory_buffer_overrun_stops COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer_overrun.pol"
            "-DPANIC=left = 34, right = 32"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_panic_test.cmake")
        # The clause itself is quoted from the PRELUDE's own text, which has no file on disk: the
        # compiler registers it under `<prelude>` so a stdlib diagnostic reads like any other.
        add_test(NAME codegen_prelude_contract_quotes_its_clause COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/memory_buffer_overrun.pol"
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
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sizeof_comptime.pol"
            "-DEXPECTED=Packed = 20 TwoNibbles = 1 vec2 = 8 vec4 = 16 float = 4 short = 2 long = 8 local long = 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Result<T, E> (two type params + inheritance + virtual).
        add_test(NAME codegen_result_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/result.pol"
            "-DEXPECTED=ok: true 7 err: false 404"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Option<T> (generics + inheritance + virtual compose into Result/Option).
        add_test(NAME codegen_option_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/option.pol"
            "-DEXPECTED=a: some=true val=42 b: some=false val=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic virtual dispatch + upcast: Animal<int>* a = new Dog<int>() (spec 15).
        add_test(NAME codegen_generic_virtual_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_virtual.pol"
            "-DEXPECTED=sound = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # variance markers <out T> / <in T> (spec 15): no-op under monomorphization.
        add_test(NAME codegen_variance_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance.pol"
            "-DEXPECTED=get = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic inheritance (spec 15): class Derived<T> extends Base<T>.
        add_test(NAME codegen_generic_inherit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_inherit.pol"
            "-DEXPECTED=total = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic linked node: Node<T> with a recursive generic pointer field Node<T>*.
        add_test(NAME codegen_generic_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_list.pol"
            "-DEXPECTED=total = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a method returning a generic type: Factory.make() returns Box<int>*.
        add_test(NAME codegen_generic_factory_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_factory.pol"
            "-DEXPECTED=v = 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic class implementing an interface, dispatched via interface upcast.
        add_test(NAME codegen_generic_iface_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_iface.pol"
            "-DEXPECTED=describe = 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value semantics: assignment deep-copies; a pointer shares the instance.
        add_test(NAME codegen_value_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_copy.pol"
            "-DEXPECTED=a=7 b=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # final modifier (spec 15): explicitly immutable field / local.
        add_test(NAME codegen_final_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/final_modifier.pol"
            "-DEXPECTED=y = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic Stack<T> over linked nodes: a real generic data structure.
        add_test(NAME codegen_generic_stack_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_stack.pol"
            "-DEXPECTED=popped 30 20, count 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bubble sort: arrays + nested loops + swap + a static method taking an array.
        add_test(NAME codegen_bubble_sort_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bubble_sort.pol"
            "-DEXPECTED=1 2 5 8 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # recursive static methods: factorial + fibonacci.
        add_test(NAME codegen_recursion_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/recursion.pol"
            "-DEXPECTED=fact(5)=120 fib(10)=55"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a small OOP program: inheritance + super + override + virtual + contracts.
        add_test(NAME codegen_bank_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bank.pol"
            "-DEXPECTED=balance = 1650"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # match as a statement: dynamic-type dispatch + positional destructuring.
        add_test(NAME codegen_match_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/match_dispatch.pol"
            "-DEXPECTED=rect area 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # math demo: recursion + modulo (Euclid GCD) and an iterative power loop.
        add_test(NAME codegen_math_demo_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_demo.pol"
            "-DEXPECTED=gcd(48,18)=6 pow(2,10)=1024"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic methods: obj.m<int>(...) monomorphized per call (spec 15.1).
        add_test(NAME codegen_generic_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_method.pol"
            "-DEXPECTED=id=42 pick=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generics constraints (spec 15.2): Box<T extends Shape> accepts Circle.
        add_test(NAME codegen_generics_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generics_constraints.pol"
            "-DEXPECTED=area = 48"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `demand` (spec 28.2): compile-time checks; they hold, so the program builds/runs.
        add_test(NAME codegen_demand_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand.pol"
            "-DEXPECTED=checks passed = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # break / continue in for and while loops (spec 7).
        add_test(NAME codegen_loops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loops.pol"
            "-DEXPECTED=for sum = 8 while total = 12"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach over an array (spec 7).
        add_test(NAME codegen_foreach_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach.pol"
            "-DEXPECTED=sum of squares = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # C#-style `foreach` keyword, alongside the `for (T v in coll)` form (spec 7.6).
        add_test(NAME codegen_foreach_csharp_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_csharp.pol"
            "-DEXPECTED=sum of squares = 30 count = 11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch with C-style fall-through (spec 7.3).
        add_test(NAME codegen_switch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch.pol"
            "-DEXPECTED=zero one one two other"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # showcase: many 0.2 features combined end to end.
        add_test(NAME codegen_showcase_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/showcase.pol"
            "-DEXPECTED=areas: 12 9 total 21 odd sum = 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # labeled break/continue to an outer loop (spec 7.4).
        add_test(NAME codegen_labeled_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/labeled.pol"
            "-DEXPECTED=found = 23 sum = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch over an enum value (enum constants are ordinals).
        add_test(NAME codegen_switch_enum_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_enum.pol"
            "-DEXPECTED=code = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # switch over a Java-style enum (singleton objects): matches on identity, not ordinals.
        #
        # ALSO THE GUARD ON THE CLOSED-INTEGER LOWERING, which is why it is worth more than it looks.
        # `Planet.MARS` answers an ordinal when the constant folder is asked for one -- so a rule
        # that decides "closed set of integers" by asking the folder about every case takes this
        # program too, and compares a POINTER against 0, 1, 2. Every arm then misses and the whole
        # switch takes its default. This test is what says so.
        add_test(NAME codegen_switch_enum_java_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_enum_java.pol"
            "-DEXPECTED=mars"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A CALL INSIDE A STRING CONCATENATION RUNS ONCE.
        #
        # It is not a feature; it is the assumption every other test here rests on, and it was FALSE
        # for the whole life of this back end. `"count " + c.bump().toString()` called `bump` twice,
        # so every number a program printed that way was wrong -- and any expression that both
        # computes and changes something gave a different answer depending on where it was printed.
        #
        # WHY NOTHING CAUGHT IT: a call that is evaluated twice and has no side effect is invisible,
        # and hundreds of samples here concatenate a getter into a message. The sample uses a counter
        # for exactly that reason.
        #
        # The cause was the `Decimal.toString` path lowering the receiver to find out whether it was
        # a `Decimal`, deciding it was not, and falling through to the ordinary path -- which lowered
        # it again. Third instance of that shape in this back end: see `lowerPassCall` and
        # `entityColumnAddress` for the other two.
        add_test(NAME codegen_call_in_concat_runs_once COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/call_in_concat_once.pol"
            "-DEXPECTED=one 1 two 2 local 3 both 4 5 nested 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # An interface method satisfied by an INHERITED implementation, in three shapes, plus the
        # diamond a driver base class always makes: `Peripheral implements Driver` defines `start`,
        # and `E1000 extends Peripheral implements NetworkCard` where `NetworkCard implements
        # Driver`. Every one of them works; the test exists because the hunt for the bug above went
        # through here first, and "it works" is only knowledge once something asks.
        add_test(NAME codegen_iface_inherited_impl_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/iface_inherited_impl.pol"
            "-DEXPECTED=direct hello iface hello base 7 louder HELLO diamond machine both machine WIDGET serial 11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and a `weak` reference whose type is an INTERFACE, which is what a subsystem written
        # against a contract rather than against a part has to hold. Every `weak` in this tree named
        # a class before this.
        #
        # `tag 23` AND `high 20` ARE THE SHARP END. They call a method that returns a STRUCT BY
        # VALUE, through the interface, and then use the result as a receiver and as a place to read
        # a field from. `this` is always a pointer -- including for a value struct -- and a returned
        # struct has no address, so the lowering used to pass the struct's own eight bytes where the
        # pointer goes: `Tag{20,3}` became `this = 0x300000014`. Horizon's
        # `NetworkCard.hardwareAddress()` is exactly this, and it is the one method of that
        # interface returning a value type: six others were probed live in the kernel and answered,
        # and the machine stopped on this one.
        add_test(NAME codegen_weak_to_interface_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/weak_to_interface.pol"
            "-DEXPECTED=held 4 name card sent 3 tag 23 high 20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A SYSCALL DISPATCHER'S SHAPE: sparse, out-of-order `fixed` members as the case values.
        # Horizon's kernel entry is ninety-seven arms of exactly this, and it is the dispatch every
        # call from every program goes through.
        add_test(NAME codegen_switch_fixed_dispatch_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_fixed_dispatch.pol"
            "-DCONTAINS=8 -> sought"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...AND THAT IT IS ONE TERMINATOR AND NOT A CHAIN, which the program's output cannot say:
        # a compare chain answers every one of those six lines correctly and costs a compare per arm.
        # The needle names the sparse values in source order, so a rule that quietly renumbered them
        # dense -- which would still print the right thing for a subject that is always in range --
        # fails here.
        add_test(NAME pir_switch_over_fixed_members_is_one_terminator COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_fixed_dispatch.pol"
            "-DIN_FN=Main.serve"
            "-DNEEDLE=case 0 -> "
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # ...AND A `String` SUBJECT STILL GETS THE CHAIN, because there is no case value to switch
        # on: matching text is a CALL, and a call cannot be an arm of a jump table however constant
        # the literal beside it is. `__polaron_str_eq` appears only on the chain path, so its
        # presence in `classify` is the assertion.
        add_test(NAME pir_switch_over_strings_stays_a_chain COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/switch_string.pol"
            "-DIN_FN=Main.classify"
            "-DNEEDLE=__polaron_str_eq"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_pir_contains_test.cmake")

        # do-while: the body runs at least once (spec 7).
        add_test(NAME codegen_dowhile_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dowhile.pol"
            "-DEXPECTED=count = 5 runs = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # compound assignment: x += e and friends (spec 6).
        add_test(NAME codegen_compound_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/compound.pol"
            "-DEXPECTED=x = 2 a0 = 17"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bitwise compound assignment: &= |= ^= <<= >>= (spec 6).
        add_test(NAME codegen_bitwise_compound_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwise_compound.pol"
            "-DEXPECTED=x = 20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bitwise operators: & | ^ << >> (spec 6).
        add_test(NAME codegen_bitwise_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bitwise.pol"
            "-DEXPECTED=and = 8 or = 14 xor = 6 shl = 48 shr = 6 not = -13"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ternary conditional expression: c ? a : b (spec 6).
        add_test(NAME codegen_ternary_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ternary.pol"
            "-DEXPECTED=max = 7 min = 3 sign = 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator[]= overloading: indexed assignment (spec 6.5).
        add_test(NAME codegen_operator_index_set_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_index_set.pol"
            "-DEXPECTED=p = 10 20"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # operator[] overloading (spec 6.5).
        add_test(NAME codegen_operator_index_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/operator_index.pol"
            "-DEXPECTED=t0 = 10 t1 = 20 t2 = 30"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # enum built-ins count()/values() (spec 12.5).
        add_test(NAME codegen_enum_builtins_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/enum_builtins.pol"
            "-DEXPECTED=count = 3 sum of ordinals = 3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # pointer fields (Node* next) -- linked structures; the assign must store, not copy.
        add_test(NAME codegen_linked_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/linked_list.pol"
            "-DEXPECTED=total = 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # tuples (spec 22.5): multi-value return + destructuring + a tuple literal.
        add_test(NAME codegen_tuple_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/tuple.pol"
            "-DEXPECTED=q=3 r=2 lo=3 hi=9 x=4 y=10"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bidirectional properties (spec 32.6): one property converting both ways over a backing field
        # (Celsius <-> Fahrenheit): reading converts out of the field, assigning converts into it.
        add_test(NAME codegen_bidirectional_property_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bidirectional_property.pol"
            "-DEXPECTED=f=212.0 c=0.0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cross-program IPC (spec 2.8) + capability tokens (spec 32.7): two programs, one named pipe /
        # unix socket, an object that lives in the engine and is called from the client, and a policy
        # that refuses one capability and grants another.
        add_test(NAME codegen_ipc_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DSERVER=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_server.pol"
            "-DCLIENT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ipc_client.pol"
            "-DEXPECTED=client: plays=1,2 client: volume=9 client: 'root' refused client: mixdown=900"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_ipc_test.cmake")

        # inline tests (spec 32.11): `@Test` methods calling the stdlib Test assertions, run by --test.
        # A void test's verdict comes from its assertions; the boolean form still works.
        add_test(NAME codegen_inline_tests_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/inline_tests.pol"
            "-DEXPECTED=PASS MathUtils.add_basic PASS MathUtils.predicates_and_tolerance PASS MathUtils.still_boolean tests: 3 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The rest of spec 32.11: [BeforeAll]/[AfterAll] build the class fixture once, [Setup]/[Teardown]
        # bracket each test, [Ignore] and a runtime Test.skip both report SKIP, and the report is
        # deterministic (durations are opt-in behind --timing) so it can be compared exactly.
        add_test(NAME codegen_test_lifecycle_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.pol"
            "-DEXPECTED=PASS Census.fixture_built_once PASS Census.values_stay_in_band PASS Census.setup_ran_for_this_test SKIP Census.needs_a_bigger_world -- needs a 4096-cell world; this fixture is 64 SKIP Census.forest_regrows -- regrowth is not implemented yet PASS Census.boolean_form_still_works PASS Arithmetic.arrays_and_text tests: 5 passed, 0 failed, 2 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --filter narrows the run to matching test names; --list names them without running anything,
        # which also means a filtered-out class never pays for its [BeforeAll] fixture.
        add_test(NAME codegen_test_filter_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.pol"
            "-DRUNARGS=--filter Arithmetic"
            "-DEXPECTED=PASS Arithmetic.arrays_and_text tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The rest of the framework: [Cases] over int and String rows, [Repeat], [ExpectedToFail]
        # (which RUNS and reports XFAIL), [Tag] + [MaxTime], output capture and golden comparison,
        # and the breadth of the assertion set.
        add_test(NAME codegen_test_full_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.pol"
            "-DEXPECTED=PASS Parser.every_seed_lands_in_band[0] PASS Parser.every_seed_lands_in_band[1] PASS Parser.every_seed_lands_in_band[2] PASS Parser.every_name_is_lowercase[0] PASS Parser.every_name_is_lowercase[1] PASS Parser.stable_across_runs XFAIL Parser.nested_quotes the parser drops the inner quote PASS Parser.large_input PASS Report.printed_output_is_captured PASS Report.golden_file_comparison PASS Report.the_assertion_surface tests: 11 passed, 0 failed, 0 skipped, 1 expected to fail"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --tag selects a group; the [MaxTime] budget on that same test must not trip.
        add_test(NAME codegen_test_tag_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.pol"
            "-DRUNARGS=--tag slow"
            "-DEXPECTED=PASS Parser.large_input tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --bench runs the [Benchmark] methods and no tests at all. The ns/op figure varies, so only
        # the shape is pinned.
        add_test(NAME codegen_test_bench_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.pol"
            "-DRUNARGS=--bench --filter summing_speed"
            "-DCONTAINS=BENCH Parser.summing_speed"
            "-DEXPECTED=unused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # --format=json emits one machine-readable document. A test's own printing is captured into
        # its record rather than being interleaved, which is what keeps the JSON well-formed.
        add_test(NAME codegen_test_json_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_full.pol"
            "-DRUNARGS=--format=json --filter every_seed"
            "-DCONTAINS={\"tests\":[{\"name\":\"Parser.every_seed_lands_in_band[0]\",\"status\":\"PASS\""
            "-DEXPECTED=unused"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Test.assertNoLeaks over a clean allocate/free round-trip, plus the accounting it is built
        # on moving in both directions. The second test is what stops the assertion from being green
        # by construction -- without it, a counter stuck at zero would pass everything.
        add_test(NAME codegen_test_no_leaks_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_no_leaks.pol"
            "-DEXPECTED=PASS Probe.clean_round_trip_leaves_nothing PASS Probe.a_leak_shows_up_in_the_live_total tests: 2 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `String` OWNS ITS BUFFER, and the scope end is where it gives it back (spec 21).
        #
        # This is here because NOTHING ELSE COULD SEE IT. A leaked String prints exactly what an
        # owned one prints, so the 846-sample differential -- which compares what programs write --
        # called the two backends equal on every string test in the corpus while one of them was
        # releasing nothing at all. Only a probe that ASKS THE ALLOCATOR catches it, and only after
        # `--test` was made to work through both backends could that probe be pointed at either.
        #
        # Two rounds of the same work: the second must leave the live total where the first did.
        # Through the AST-to-LLVM path it does. Through PIR the total doubles -- 19200 bytes to
        # 38400 -- which is every String of the first round still held.
        add_test(NAME codegen_string_ownership_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_string_ownership.pol"
            "-DEXPECTED=PASS Probe.strings_do_not_leak PASS Probe.string_fields_do_not_leak tests: 2 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A test runs against a LOADED program: the synthesized runner emits the onClassLoad hooks
        # the program's own main would (spec 32.5). Without this, agents-exe's whole suite panicked
        # in its first fixture on a table an onClassLoad fills.
        add_test(NAME codegen_test_class_load_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_class_load.pol"
            "-DEXPECTED=PASS Loading.the_class_was_loaded_before_the_tests_ran tests: 1 passed, 0 failed, 0 skipped"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The same check runs under `--check`, which is what the editor calls: a malformed test is
        # reported while you type, not only on the day someone runs the suite.
        add_test(NAME test_check_reports_malformed_declarations
            COMMAND polc --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol")
        set_tests_properties(test_check_reports_malformed_declarations PROPERTIES
            PASS_REGULAR_EXPRESSION "already has a '\\[Setup\\]' method")

        # Malformed test declarations are compile errors, not silent no-ops. Each shape gets its own
        # assertion against the same sample, so a fix that repairs one message cannot mask the others.
        add_test(NAME test_rejects_duplicate_hook
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_duplicate_hook PROPERTIES
            PASS_REGULAR_EXPRESSION "already has a '\\[Setup\\]' method")

        add_test(NAME test_rejects_instance_hook
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_instance_hook PROPERTIES
            PASS_REGULAR_EXPRESSION "must be a public static method returning void")

        add_test(NAME test_rejects_hook_that_is_also_a_test
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_hook_that_is_also_a_test PROPERTIES
            PASS_REGULAR_EXPRESSION "cannot mark the same method")

        add_test(NAME test_rejects_ignore_without_test
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_ignore_without_test PROPERTIES
            PASS_REGULAR_EXPRESSION "has no effect: it only applies to a '\\[Test\\]' method")

        add_test(NAME test_rejects_parameter_without_cases
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_parameter_without_cases PROPERTIES
            PASS_REGULAR_EXPRESSION "takes parameters, so it needs a '\\[Cases")

        add_test(NAME test_rejects_mismatched_cases_source
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_mismatched_cases_source PROPERTIES
            PASS_REGULAR_EXPRESSION "must be a public static method returning 'int\\[\\]'")

        add_test(NAME test_rejects_benchmark_that_is_also_a_test
            COMMAND polc --test "${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle_bad.pol"
                    -o "${CMAKE_CURRENT_BINARY_DIR}/testbad.ll")
        set_tests_properties(test_rejects_benchmark_that_is_also_a_test PROPERTIES
            PASS_REGULAR_EXPRESSION "a benchmark measures, a test judges")

        add_test(NAME codegen_test_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=--test"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/test_lifecycle.pol"
            "-DRUNARGS=--list"
            "-DEXPECTED=Census.fixture_built_once Census.values_stay_in_band Census.setup_ran_for_this_test Census.needs_a_bigger_world Census.forest_regrows Census.boolean_form_still_works Arithmetic.arrays_and_text"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # named escape hatches: `[[no_bounds_check]]` (spec 36.4) drops the bounds check in that method,
        # and wrappingDiv/uncheckedDiv (spec 3.6) wrap INT_MIN / -1 instead of trapping (0 still panics).
        add_test(NAME codegen_hot_path_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hot_path.pol"
            "-DEXPECTED=hot=10 checked=10 wrapDiv=-2147483648 uncheckedDiv=-2147483648 plainDiv=-1073741824"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # pointer arithmetic (spec 27): +/-/++/-- step by whole elements, `q - p` is an element count,
        # and a pointer to a class is warned about (the program still compiles and runs).
        add_test(NAME codegen_pointer_arith_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/pointer_arith.pol"
            "-DEXPECTED=p1=10 p3=30 p2=20 gap=2 q=10 age=7 back=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `T*[]` (spec 27): a raw array of pointers -- a[i] is a T*, delete frees the array not the pointees.
        add_test(NAME codegen_ptr_array_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ptr_array.pol"
            "-DCONTAINS=sum=11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # N-level pointers (spec 17.8): T**/T***/T**** declare, deref with prefix '*', address-of chains,
        # out-parameters through a T**, and class double pointers.
        add_test(NAME codegen_n_level_pointers_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/n_level_pointers.pol"
            "-DCONTAINS=triple deref = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a generic constraint with type arguments (spec 15.2) is satisfied by the right instantiation.
        add_test(NAME codegen_generic_bound_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_bound_args.pol"
            "-DEXPECTED=cmp=-5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # affinity hints (spec 32.9): hot fields are packed first in the object and cold ones last,
        # whatever order the blocks were written in; a subclass still starts with the base's layout.
        add_test(NAME codegen_affinity_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/affinity.pol"
            "-DEXPECTED=x=3.0 y=3.0 id=7 tx=11.0 ty=22.0 tid=9 tag=42 ux=11.0 uid=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # mutable dispatch tables (spec 32.8): replacing a method rewrites the class's vtable slot, so
        # instances created before AND after the patch dispatch to the replacement (which may capture).
        add_test(NAME codegen_dispatch_table_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/dispatch_table.pol"
            "-DEXPECTED=woof (3) woof remix woof remix loudness=107 captured=1005 woof remix poodle=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generators (spec 22.6): a method that yields produces a lazy Iterator<T> -- bounded, unbounded
        # (stopped by `break`), instance (capturing `this`), and driven by hand through the interface.
        add_test(NAME codegen_generator_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generator.pol"
            "-DEXPECTED=evens=20 primes=10 last=29 ticks=3210 first=0 more=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # THE REGION BINDER, over VALUES rather than over names.
        #
        # Four spellings of one escape, all real, and only two of which used to be seen. Lifetime was
        # a property of a NAME, so an escape had to be a bare identifier on both sides: a temporary,
        # an array element, a field read or a call result were invisible, and real code is made of
        # those. (b) is an escape nobody named and (d) is an object in a REGION — the thing the
        # analysis is named after, and a codebase that used regions well was one it had nothing to
        # say about.
        add_test(NAME sema_rejects_the_four_escape_shapes COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_escape_shapes_bad.pol")
        set_tests_properties(sema_rejects_the_four_escape_shapes PROPERTIES WILL_FAIL TRUE)
        # ...and the harder half: the shapes that must stay QUIET. Every store here outlives the
        # frame and every one is correct, because the receiver takes ownership — told apart by the
        # DESTRUCTOR, which the author already had to write. Without that half an earlier version
        # reported every constructor, setter and `list.add` in the language: 808 of 925 tests, which
        # is not a measurement but noise, and a checker that cries at `add` gets switched off.
        add_test(NAME codegen_region_ownership_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_ownership_ok.pol"
            "-DEXPECTED=owned: 7 handed over: 42 collected: 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # PLACING THE VALUES THE ANALYSIS USED TO SHRUG AT. `Unknown` is what `lifetimeOf` answers
        # when it cannot say where a value lives, and it is PERMISSIVE — so every shape it did not
        # handle was a hole rather than a question. Closing them is the prerequisite for the default
        # ever being flipped, and it REDUCES what flipping costs: measured on the standard library,
        # `--strict-regions` went from 35 sites to 18, because most of what looked unplaceable was
        # placeable all along.
        #
        # Four shapes: `null` (points at nothing, so fits anywhere — left out, strict refused
        # `this.kept = null` in most constructors); a ternary (as short-lived as its shorter arm); a
        # static call (names its class, not an object, and every factory is spelled that way); and
        # transitive freshness (a factory handing back another factory's result). All must be SILENT,
        # including under strict — a checker is judged by what it stays quiet about.
        add_test(NAME codegen_region_placing_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_placing_values.pol"
            "-DEXPECTED=made 3 kept 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        # NOT YET A TEST UNDER `--strict-regions`, and the reason is the remaining work rather than a
        # problem with the sample: strict makes an unplaceable value an ERROR, and the standard
        # library still has 18 of them, so `polc` exits non-zero on any program at all. The sample's
        # own lines are already silent under strict — checked by hand, 2026-08-16 — and this becomes
        # a test the day the prelude is clean. The 18 is the tracker.

        # SUB-REGIONS AND NESTING (§10). Two explicit regions used to be compared by IDENTITY, so a
        # nest of them was a set of unrelated boxes and the direction that is a bug looked exactly
        # like the direction that is fine.
        #
        # The order needs no model of the nest: regions are released last-in-first-out, and one
        # declared inside a block is necessarily born after the region enclosing it — so "born
        # earlier" IS "dies later", and one number per region orders an arbitrarily deep nest.
        #
        # BOTH directions are in the sample, because a rule that refuses everything is not an order.
        # The scratch node pointing at durable data must stay silent; the durable node pointing into
        # the scratch region is the one error.
        add_test(NAME sema_orders_nested_regions COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_nesting_bad.pol")
        set_tests_properties(sema_orders_nested_regions PROPERTIES WILL_FAIL TRUE)

        # READING THROUGH A POINTER INTO A RELEASED REGION. Not checked at all before — embarrassing
        # precisely because it is easy: the analyzer already kept flow-sensitive `deleted_`/`freed_`
        # sets for `delete`, so the machinery existed and did not cover regions. It gets its own
        # message, because nobody wrote a `delete` to move.
        add_test(NAME sema_rejects_use_after_release COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_use_after_release_bad.pol")
        set_tests_properties(sema_rejects_use_after_release PROPERTIES WILL_FAIL TRUE)
        # A VIRTUAL CALL MAY RUN ANY OVERRIDE, so the escape summary read at a call site is the union
        # over all of them. `Sink.accept` keeps nothing and `Keeper.accept` keeps what it is given;
        # through a `Sink*` the base's summary said "fine" and the object may well be a Keeper.
        #
        # The one place inheritance costs this analysis anything — and worth being exact: it is not
        # that ownership and inheritance conflict. Inheritance is an identity relation, the region
        # tree is a containment one, and a hierarchy adds no nodes to it at all. What it adds is
        # several callees behind one call, answered by the union, computable because the hierarchy is
        # closed at compile time.
        add_test(NAME sema_rejects_escape_through_override COMMAND "$<TARGET_FILE:polc>"
            --check "${CMAKE_CURRENT_SOURCE_DIR}/samples/region_virtual_escape_bad.pol")
        set_tests_properties(sema_rejects_escape_through_override PROPERTIES WILL_FAIL TRUE)

        # A DEFERRED CLEANUP RUNS AT SCOPE EXIT, AND THE FLOW ANALYSIS HAS TO SAY SO.
        #
        # `defer { delete b; }` followed by any read of `b` was refused as a use-after-delete: the
        # deferred body was analyzed inline, so the delete was recorded as having happened AT the
        # defer. That is the canonical two lines of the feature — allocate, then say next to the
        # allocation how it ends — so `defer` could not be used for the one thing it is for.
        #
        # Found by writing a real program rather than by a checklist: a SQL engine's entry point
        # allocates four things that all die with the call, and by hand that was a try, a catch
        # freeing three in order, and the same three frees repeated on the success path.
        add_test(NAME codegen_defer_then_use_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/defer_then_use.pol"
            "-DEXPECTED=value 7 pair 3 and 4 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `defer within <budget>` (spec 32.10): a cleanup with a time budget. Under budget it is silent;
        # over budget the cleanup still completes and the runtime alerts on stderr (checked via
        # ERRCONTAINS -- the alert is a diagnostic, so it is deliberately not on stdout).
        add_test(NAME codegen_defer_within_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/defer_within.pol"
            "-DEXPECTED=quick body closed 1 slow body closed 2 done"
            "-DERRCONTAINS=defer overran its budget"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `partial` classes (spec 8.3): two declarations of the same class are folded into one.
        add_test(NAME codegen_partial_class_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partial_class.pol"
            "-DEXPECTED=barks=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # interpolation format specifiers (spec 4.1): `{pi:0.00}` fixes the decimals; no spec = unchanged.
        add_test(NAME codegen_interp_format_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_format.pol"
            "-DEXPECTED=pi=3.14 pi3=3.142 n=42 raw=3.14159"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # foreach over a user Iterable/Iterator (spec 9.2): lazy, no snapshot -- an infinite Fibonacci
        # iterator is consumed with break (sum=88) and an Iterable is driven through iterator() (prod=24).
        add_test(NAME codegen_foreach_iterable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/foreach_iterable.pol"
            "-DEXPECTED=sum=88 prod=24"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 14.1/14.2: the built-in `@Name` annotation spelling (alongside `[Name]`), and `deprecated`
        # methods (each call site warns; the program still builds and runs).
        add_test(NAME codegen_deprecated_and_at_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deprecated_and_at_annotations.pol"
            "-DEXPECTED=a=42 b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # constraints on a generic METHOD (spec 15.2): <T implements Shape> is enforced at each call site.
        add_test(NAME codegen_generic_method_constraints_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_method_constraints.pol"
            "-DEXPECTED=sq=25 ci=15"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # named arguments (spec 22.4): `name: value` at the call site, in any order, plus `requires named`
        # parameters that may not be passed positionally.
        add_test(NAME codegen_named_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/named_args.pol"
            "-DEXPECTED=a=502 b=502 c=502 d=502 e=521 f=520"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs value contract (spec 12.3/12.4): enum extends catalog, byCatalog
        # constants continue the ordinals (3..5), enum is a subtype of the catalog.
        add_test(NAME codegen_catalog_values_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_values.pol"
            "-DEXPECTED=0 1 2 3 4 5 5 6"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs method contract (spec 12.3/12.4): the enum implements the catalog's
        # methods; instance methods take the enum value as `this`, dispatched statically.
        add_test(NAME codegen_catalog_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_methods.pol"
            "-DEXPECTED=100 10 10 1 2 11"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # catalogs extending catalogs (spec 12.3): the contract is transitive; an enum
        # satisfying the chain is a subtype of every catalog in it.
        add_test(NAME codegen_catalog_extends_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_extends.pol"
            "-DEXPECTED=own=0 a=1 c=3 foo=7 bar=9 count=4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # call args are coerced to the parameter's type across ctor/method/static/virtual
        # (e.g. an i32 literal into an int64 param, an int into a float param).
        add_test(NAME codegen_arg_coercion_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arg_coercion.pol"
            "-DEXPECTED=15 3 7 41"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # value semantics on reassignment: `b = a` deep-copies (owned arrays duplicated),
        # so mutating b does not change a.
        add_test(NAME codegen_deep_copy_reassign_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/deep_copy_reassign.pol"
            "-DEXPECTED=a=10 b=999"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # arrays sized/indexed by the real element width: int64[] and double[] round-trip
        # 8-byte elements (and a value > INT32_MAX) instead of corrupting the heap.
        add_test(NAME codegen_wide_arrays_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/wide_arrays.pol"
            "-DEXPECTED=a2=5000000012 d2=3 sum=10000000024 len=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # block-scoped RAII: a stack dtor / defer runs at its block's end on the path that
        # ran it -- per loop iteration, and never for a not-taken branch (no dtor on
        # uninitialized memory).
        add_test(NAME codegen_block_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/block_raii.pol"
            "-DEXPECTED=start dtor 0 dtor 1 dtor 2 body 0 defer 0 body 1 defer 1 end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a goto that leaves scopes runs their defers + destructors first (spec 7.9), innermost
        # scope first and LIFO within a scope -- previously the skipped scopes leaked.
        add_test(NAME codegen_goto_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_cleanup.pol"
            "-DEXPECTED=start defer dtor 2 dtor 1 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a throw caught by an enclosing try runs the try-body's block-scoped defers + destructors
        # while unwinding to the catch (spec 23.1) -- previously they were skipped on the caught path.
        add_test(NAME codegen_try_body_cleanup_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/try_body_cleanup.pol"
            "-DEXPECTED=start defer dtor 1 caught after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # delete / using on an `on stack` object: destruct once, never free() a stack
        # pointer, never double-destruct at scope exit.
        add_test(NAME codegen_stack_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stack_delete.pol"
            "-DEXPECTED=dtor 1 after delete in using dtor 2 end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # virtual destructor dispatch: delete through a base pointer runs the most-derived
        # destructor (then chains to the base), instead of the static type's.
        add_test(NAME codegen_virtual_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/virtual_dtor.pol"
            "-DEXPECTED=~Derived ~Base ~Square"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # finally runs on early exits (return out of try, break leaving a nested try), not
        # only the normal/caught fall-through.
        add_test(NAME codegen_finally_exits_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/finally_exits.pol"
            "-DEXPECTED=finally-return r=1 iter 0 finally-iter 0 finally-iter 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # final class + final method used correctly compile and run.
        add_test(NAME codegen_final_types_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/final_types.pol"
            "-DEXPECTED=rgb=255"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # bit-fields (spec 11.1): `field : N` masks the stored value to N bits.
        add_test(NAME codegen_bit_fields_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bit_fields.pol"
            "-DEXPECTED=a=4 b=7 c=904"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Quake III fast inverse square root: union bit-reinterpretation + magic constant
        # + one Newton step. A real-world workout for unions/float32/casts/arg coercion.
        add_test(NAME codegen_fast_inv_sqrt_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/fast_inv_sqrt.pol"
            "-DEXPECTED=rsqrt(4)~=499/1000 rsqrt(0.25)~=1996/1000 rsqrt(100)~=99/1000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # namespace-level compile-time consts (spec 28.1): literals, arithmetic,
        # bitwise, hex bases, and references to earlier consts -- int/bool/char/double.
        add_test(NAME codegen_const_values_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/const_values.pol"
            "-DEXPECTED=MAX=100 DOUBLED=200 SHIFT=16 ENABLED=1 GRADE=A MASKED=15 SCALED=150"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # volatile (spec 37.5): a volatile field and local still round-trip correctly
        # (volatility doesn't change a single-threaded result).
        add_test(NAME codegen_volatile_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_access.pol"
            "-DEXPECTED=reg=42 sum=84"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime methods (spec 28.3): recursive fib + iterative factorial folded
        # at compile time into namespace consts (and a const built from them).
        add_test(NAME codegen_comptime_fn_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_fn.pol"
            "-DEXPECTED=fib10=55 fact5=120 combined=175"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime methods returning double (spec 28.3): mixed int/double body folds.
        add_test(NAME codegen_comptime_double_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_double.pol"
            "-DEXPECTED=total=450 half=350"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # a demand's condition may use consts + comptime calls (shared evaluator).
        add_test(NAME codegen_demand_comptime_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/demand_comptime.pol"
            "-DEXPECTED=demands met"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete (spec 37.1): deleting an object also deletes the objects it
        # owns by composition (value-typed class fields), recursively.
        add_test(NAME codegen_cascade_delete_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_delete.pol"
            "-DEXPECTED=~Outer ~Mid ~Leaf done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete follows owned pointers, and a runtime visited-set frees a cyclic owned
        # graph exactly once (spec 37.1); `external` pointers are associations and are skipped.
        add_test(NAME codegen_cascade_graph_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_graph.pol"
            "-DEXPECTED=~Node 1 ~Node 2 ~Node 3 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete over a `unique class` graph: every pointer is a sole owner, so the owned graph
        # is provably a forest -- the compiler drops the runtime visited-set (fast path) yet still frees
        # the whole tree exactly once (right checksum, clean exit, no double-free panic).
        add_test(NAME codegen_cascade_forest_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_forest.pol"
            "-DCONTAINS=sum=496"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy region (spec 37.3): the backing block is allocated on first object insertion; an
        # unused lazy region is never allocated.
        add_test(NAME codegen_lazy_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_region.pol"
            "-DEXPECTED=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Region empty-state (spec 17.2 form 3): `region r;` declared unallocated, allocated later.
        add_test(NAME codegen_region_empty_state_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_empty_state.pol"
            "-DCONTAINS=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy import (spec 37.3): a lazily imported class runs its onClassLoad on the first
        # instance, not at boot, so "start" prints before "server loaded".
        add_test(NAME codegen_lazy_import_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_import.pol"
            "-DEXPECTED=start server loaded made server"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # volatile region (spec 37.5, MMIO): objects in the region are accessed volatilely. Built at
        # -O3 to confirm the volatile loads/stores survive optimization.
        add_test(NAME codegen_volatile_region_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_region.pol"
            "-DEXPECTED=ctrl=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy thread (spec 37.3): the Thread object is created on first reference, deferring spawn.
        add_test(NAME codegen_lazy_thread_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_thread.pol"
            "-DEXPECTED=before after decl thread ran 7 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade validate(X) checks invariants and cascade Console.println(X) describes each node
        # in the owned graph (spec 37.1), reusing the cycle-safe walk.
        add_test(NAME codegen_cascade_ops_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_ops.pol"
            "-DEXPECTED=Node 1 Node 2 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade clone X into Y deep-copies the owned graph into a fresh graph; mutating the clone
        # leaves the original untouched (spec 37.1).
        add_test(NAME codegen_cascade_clone_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_clone.pol"
            "-DEXPECTED=1 2 100 200"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade unimport X unimports X and its subclasses; a call on a subclass instance then
        # raises UnimportedTypeException (spec 37.1).
        add_test(NAME codegen_cascade_unimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_unimport.pol"
            "-DEXPECTED=woof dog is dead"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade delete also frees objects owned through INHERITED value fields.
        add_test(NAME codegen_cascade_inherited_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_inherited.pol"
            "-DEXPECTED=~Derived ~Base ~Leaf done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # qualified names (F4): the same type name in two namespaces (app.Box vs
        # lib.Box) is two distinct types, each resolved within its own namespace.
        add_test(NAME codegen_qualified_names_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/qualified_names.pol"
            "-DEXPECTED=app=1 lib=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # qualified names cover catalogs too: app.Tier and lib.Tier are distinct.
        add_test(NAME codegen_catalog_collision_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/catalog_collision.pol"
            "-DEXPECTED=app=1 lib=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # explicit qualified type reference: app.Box and lib.Box in one scope, no import.
        add_test(NAME codegen_qualified_explicit_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/qualified_explicit.pol"
            "-DEXPECTED=app=1 lib=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # partitionable (spec 19.9): a partitionable class compiles and runs.
        add_test(NAME codegen_partitionable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partitionable.pol"
            "-DEXPECTED=value=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # cascade move (spec 19.8): a graph moved to another region survives the
        # release of the source region.
        add_test(NAME codegen_cascade_move_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/cascade_move.pol"
            "-DEXPECTED=id=42 v=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # move on a parameter type transfers ownership into a function (spec 19.6).
        add_test(NAME codegen_move_signature_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/move_signature.pol"
            "-DEXPECTED=consumed 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection forwards arguments to instantiate (constructor) and invoke (method) (spec 31).
        add_test(NAME codegen_reflect_args_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_args.pol"
            "-DEXPECTED=age=7 age=99"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # extern library block groups external C functions under one convention (spec 26).
        add_test(NAME codegen_ffi_library_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_library.pol"
            "-DEXPECTED=5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # releasing a region runs its objects' destructors before freeing the arena (spec 17.7).
        add_test(NAME codegen_region_dtor_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_dtor.pol"
            "-DEXPECTED=before ~Dog 2 ~Dog 1 after"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic method returning a tuple, destructured at the call site (spec 15.1).
        add_test(NAME codegen_generic_tuple_return_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/generic_tuple_return.pol"
            "-DEXPECTED=5 9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # break/continue run destructors and defers for loop-body objects before leaving (spec 7.8).
        add_test(NAME codegen_loop_teardown_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/loop_teardown.pol"
            "-DEXPECTED=iter 0 dtor 0 iter 1 dtor 1 done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enum constants are singletons (spec 12.2): == / != compare identity.
        add_test(NAME codegen_java_enum_compare_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_compare.pol"
            "-DEXPECTED=1 0 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # System.SQL's little-endian byte codec round-trips (the CI-safe check for the pure-Polaron TDS
        # client; a live query needs a server -- see tests/samples/sql_query.pol).
        add_test(NAME codegen_sql_codec_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sql_codec.pol"
            "-DEXPECTED=65 4660 168496141 Hi"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A `transient` field resets (does not copy) on a value copy (spec: derived/scratch state).
        add_test(NAME codegen_transient_copy_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/transient_copy.pol"
            "-DEXPECTED=21 42 21 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Java-style enums order by ordinal (declaration index), like Java's compareTo (spec 12.2).
        add_test(NAME codegen_java_enum_order_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/java_enum_order.pol"
            "-DEXPECTED=1 1 1 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # safe navigation obj?.member (spec 3.7): null when obj is null, else the member; nullable.
        add_test(NAME codegen_safe_navigation_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/safe_navigation.pol"
            "-DEXPECTED=8 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # null-coalescing a ?? b (spec 3.7): a if non-null else b; result is non-null when b is.
        add_test(NAME codegen_null_coalesce_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/null_coalesce.pol"
            "-DEXPECTED=99 7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # array literals [a,b,c] (spec 25), including nested multi-dimensional via inference.
        add_test(NAME codegen_array_literals_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_literals.pol"
            "-DEXPECTED=10 30 len=3 y 2 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # multi-dimensional arrays (spec 25): int[][] type, nested literals, m[i][j], as parameter.
        add_test(NAME codegen_array_multidim_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_multidim.pol"
            "-DEXPECTED=2 3 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # arr.length(n) resizes a dynamic array (spec 25): preserves elements, zeros the grown part.
        add_test(NAME codegen_array_grow_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/array_grow.pol"
            "-DEXPECTED=len=4 1 2 30 40 len=1 1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # goto (spec 7.9) jumps forward to a later label in a regular method, skipping code between.
        add_test(NAME codegen_goto_forward_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_forward.pol"
            "-DEXPECTED=non-negative negative"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # goto (spec 7.9) + abstainfrom/reinstate (spec 7.11).
        add_test(NAME codegen_goto_abstainfrom_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/goto_abstainfrom.pol"
            "-DEXPECTED=after goto body body"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onClassLoad lifecycle hook (spec 32.5): runs once before main.
        add_test(NAME codegen_lifecycle_onclassload_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_onclassload.pol"
            "-DEXPECTED=Server loaded main start ports 8"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onFirstInstance / onLastInstanceDestroyed (spec 32.5): instance-count hooks.
        add_test(NAME codegen_lifecycle_instances_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_instances.pol"
            "-DEXPECTED=start pool setup pool teardown end"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Null safety (spec 3.7): nullable T, null assignment, flow narrowing via if (x != null).
        add_test(NAME codegen_nullable_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/nullable.pol"
            "-DEXPECTED=total=105 aIsNull=1 bIsNull=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # COMMANDS, END TO END (reference 14.1): a command as a value, as a parameter, handed back by
        # a method, carrying baggage, and a bound `methodref` with virtual dispatch through it. The
        # part that is not a rewrite of the old lambda test is the last field: the baggage is copied
        # at construction, so changing the local afterwards does not change the command.
        add_test(NAME codegen_commands_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/commands.pol"
            "-DEXPECTED=a=10 b=107 c=12 d=15 e=400 f=107"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # polc's own optimization pipeline (-O3) with the recursive-inlining pass: self- and
        # mutually-recursive functions must give the same results optimized as not.
        add_test(NAME codegen_recursion_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/recursion_opt.pol"
            "-DEXPECTED=fib=6765 fact=479001600 even=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # polc's loop-interchange pass (-O3): the matmul reduction nest is rewritten to the
        # cache-friendly form and must still produce the exact same checksum.
        add_test(NAME codegen_matmul_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/../performance tests/matrixmul.pol"
            "-DEXPECTED=checksum=236236288"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Loop interchange, pattern B (-O3): direct accumulation `c[..] += a*b` with no scalar
        # accumulator. Must give the same checksum as the unoptimized build.
        add_test(NAME codegen_matmul_direct_opt_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/matmul_direct.pol"
            "-DEXPECTED=checksum=1666368"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `volatile method` (spec 37.5): emitted noinline/optnone; must compile and run under -O3.
        add_test(NAME codegen_volatile_method_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DOPT=-O3"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/volatile_method.pol"
            "-DEXPECTED=v=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `eternal` local (spec 37.2): lives for the whole program, so its destructor does not run
        # at scope end -- the output must be exactly "using=1" with no "freed".
        add_test(NAME codegen_eternal_local_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/eternal_local.pol"
            "-DEXPECTED=using=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A REGION CLASS INSTANCE OUTLIVES THE METHOD THAT MADE IT -- the factory, which is the
        # ordinary shape for a class with identity and a lifecycle. `Node* one = new Node(v); ...
        # return one;` was refused twice over: the region binder called it "an object living in this
        # method's own frame", and the emitter's escape promotion wrote `on heap` onto the `new` and
        # then reported "`Node` is a region class, so `on heap` has nowhere to put this" -- pointing
        # at a line with no placement on it. The compiler wrote the placement and blamed the author.
        # `return new Node(v)` on one line was accepted the whole time, which is what made it look
        # like a rule rather than a hole.
        add_test(NAME codegen_region_class_returned_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_class_returned.pol"
            "-DEXPECTED=raised 3, sum = 60"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Type aliases and newtype (spec 24): transparent `typealias` (primitive, function, generic)
        # and distinct `newtype` (cast across the boundary). Also the two places a newtype is asked
        # what it is MADE OF rather than what it is called: `fixed` of a newtype type, and printing
        # one -- with a 64-bit and an unsigned one, the two the printer used to get wrong. Plus a
        # `record` with newtype fields and an `ArrayList` of one: neither could be DECLARED before,
        # and neither error named a line the author had written.
        add_test(NAME codegen_type_aliases_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/type_aliases.pol"
            "-DEXPECTED=t=20 r=26 order=1007 big=5000000000 batch=4000000000 none=-1 line=1007 held=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `partial` ACROSS FILES (spec 8.3) -- the case the keyword exists for, and the one that never worked.
#
# Two bugs at once. `mergePartialClasses` matched parts within one `Namespace` OBJECT, and a bundle
# written across N files is N Bundle objects of the same name each holding its own namespace object of
# the same name -- so parts in different files never met. And it ran inside `monomorphize`, eight
# passes late, by which time `qualifyNamespaces` had renamed one of the colliding names and the
# analyzer had reported a redeclaration. Found by splitting a kernel's scheduler in two.
add_test(NAME codegen_partial_across_files_runs COMMAND "${CMAKE_COMMAND}"
    "-DPOLC=$<TARGET_FILE:polc>"
    "-DCLANG=${POLARON_CLANG}"
    "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/partial_two_files/a.pol"
    "-DINPUT2=${CMAKE_CURRENT_SOURCE_DIR}/samples/partial_two_files/b.pol"
    "-DEXPECTED=sum=30"
    "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

# A `fixed` may have a NEWTYPE over a numeric type (spec 24 + 28.1). Naming the values is the
        # first thing anyone does with a newtype, and it was refused -- so the feature worked for
        # parameters and not for the constants those parameters are called with. Found in a kernel,
        # where `openLine(line, vector)` takes two small integers that compile fine when swapped.
        add_test(NAME codegen_newtype_fixed_const_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/newtype_fixed_const.pol"
            "-DEXPECTED=timer=32 keyboard=33 line=1 sum=65"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Custom annotations (spec 14.3): declare with `annotation`, apply `[Name(args)]` on a
        # class/method/field; [CompileTimeProcessor] (spec 14.4). Validated, then compiles & runs.
        add_test(NAME codegen_annotations_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/annotations.pol"
            "-DEXPECTED=length=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Self-referential generic instantiation (Node<int> with a Node<T>* field) -- regression
        # for the cloneExpr null-literal crash.
        add_test(NAME codegen_self_ref_generic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/self_ref_generic.pol"
            "-DEXPECTED=a=5 b=9 via=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: LinkedList (pointer-based self-referential nodes, O(1) append/head-removal).
        add_test(NAME codegen_linkedlist_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/linkedlist_stdlib.pol"
            "-DEXPECTED=size=3 g0=10 g2=30 rm=10 size=3 g0=20 g2=40"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: String search/transform methods (spec 34.5).
        add_test(NAME codegen_string_methods_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_methods_stdlib.pol"
            "-DEXPECTED=idx=7 has=1 sw=1 ew=1 nf=-1 up=1 lo=1 trlen=2 treq=1 rp=6 rpeq=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: JSON (spec 34) -- value tree, serialize, parse, round-trip.
        add_test(NAME codegen_json_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/json_stdlib.pol"
            "-DEXPECTED=name=1 ver=1 cool=1 n0=10 n1=20 roundtrip=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: rich time -- Duration + Instant (spec 34).
        add_test(NAME codegen_duration_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/duration_stdlib.pol"
            "-DEXPECTED=aMs=2000 aSec=2 sumMs=2500 before=1 after=1 elapsedMs=2500 nowOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: Time (spec 34) -- monotonic/wall clock + sleep (checks invariants, not values).
        add_test(NAME codegen_time_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/time_stdlib.pol"
            "-DEXPECTED=slept=1 nanoOk=1 unixOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: File I/O (spec 34.4) -- write/read/append/exists/remove over runtime stdio.
        add_test(NAME codegen_file_io_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/file_io_stdlib.pol"
            "-DEXPECTED=w=1 ex=1 len=10 eq=1 len2=11 d=1 ex2=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: StringBuilder (System.Memory buffer) + int.toString (itoa) + Memory.readString.
        add_test(NAME codegen_stringbuilder_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stringbuilder_stdlib.pol"
            "-DEXPECTED=len=17 eq=1 c0=c clast=!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # StringBuilder.clear: emptied and refilled three times, so a batch is itself and not the
        # batches before it run together. Keeps the buffer, which is why it exists.
        add_test(NAME codegen_stringbuilder_clear_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stringbuilder_clear.pol"
            "-DEXPECTED=first emptied to 0 second batch 012"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A sealed java-style enum: three holes that only met when one enum carried data, kept a
        # static of its own AND was matched over. The sealing was dropped by the desugaring, the
        # static could not be read back, and the match trapped at runtime with no arm to land in --
        # each invisible while the other two hid it.
        add_test(NAME codegen_sealed_java_enum_match_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/sealed_java_enum_match.pol"
            "-DEXPECTED=how many 2 ordinal 1 label fast score 0.25 0.75 brisk false true held slow 0.25"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # StringBuilder lifetime: the destructor that reclaims its raw buffer must run on an explicit
        # delete AND on scope exit, and toString()'s result must outlive the builder. Guards the fix
        # for the leak where the builder had no destructor at all -- a double free crashes this.
        add_test(NAME codegen_stringbuilder_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/stringbuilder_lifetime.pol"
            "-DEXPECTED=s=abc scoped=6 total=3890"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Collection lifetime: every collection's destructor reclaims its backing -- an array for most,
        # a node chain or tree for the rest -- and String elements are released with it. Guards the fix
        # for nine collections that had no destructor at all; a double free crashes this.
        add_test(NAME codegen_collection_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collection_lifetime.pol"
            "-DEXPECTED=sizes=4000 ok=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Value copy duplicates String fields, as it already did array fields. Sharing them entangled
        # the objects' lifetimes: `add(new T(...) on heap)` released the temporary's text while the
        # stored copy still pointed at it (read-back garbage, then a double free).
        add_test(NAME codegen_value_copy_string_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/value_copy_string_field.pol"
            "-DEXPECTED=count=5 total=75 first=snapshot body 0 copy=independent/independent survived"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Regression (#252): a mutable `string` owns its buffer through the full lifecycle (init/assign/
        # return/field), like an immutable String -- `string d = concat(...)` no longer reads empty.
        add_test(NAME codegen_string_mutable_lifetime_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_mutable_lifetime.pol"
            "-DEXPECTED=foobar|foobarfoo|foobar|n!|foobar"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # Collections of class-typed elements (ArrayList<Class>, HashMap<K,Object>) -- regression.
        add_test(NAME codegen_object_collections_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/object_collections.pol"
            "-DEXPECTED=kids=2 k0=2 k1=3 mapv7=70 mapv9=90"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: collection iteration -- toArray / keyArray / valueArray (+ sorted tree order).
        add_test(NAME codegen_collections_iter_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collections_iter_stdlib.pol"
            "-DEXPECTED=sum=6 tslen=3 s0=1 s1=3 s2=5 ksum=30 vsum=300"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: HashMap / HashSet (open addressing); int + String keys (Hashable builtins).
        add_test(NAME codegen_hashmap_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/hashmap_stdlib.pol"
            "-DEXPECTED=size=3 g1=100 g2=200 g17=999 has5=0 has2=1 after grow: size=20 g7=70 g19=190 g2=20 set size=2 has5=1 has6=0 str ga=1 gb=2 hasG=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: TreeMap / TreeSet (BST, self-ref nodes); int + String keys (Comparable builtins).
        add_test(NAME codegen_treemap_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/treemap_stdlib.pol"
            "-DEXPECTED=size=3 g2=22 g5=50 g8=80 has3=0 has8=1 gNone=0 str size=3 apple=1 cherry=3 hasX=0 set size=3 has5=1 has7=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: array-backed collections -- Stack / Queue / Deque (spec 34.1).
        add_test(NAME codegen_collections_basic_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/collections_basic.pol"
            "-DEXPECTED=stack=3 2 queue=10 20 deque=0 1 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: networking (spec 34) -- TCP client; connect to a closed port fails gracefully.
        add_test(NAME codegen_net_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/net_stdlib.pol"
            "-DEXPECTED=open=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: BigInteger (spec 34) -- arbitrary precision (18-digit multiply).
        add_test(NAME codegen_bigint_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/bigint_stdlib.pol"
            "-DEXPECTED=sumEq=1 prodEq=1 cmp=-1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: extended Math (trig/clamp/lerp) + Random (nextRange/nextDouble/nextBool).
        add_test(NAME codegen_math_extra_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_extra_stdlib.pol"
            "-DEXPECTED=clamp=10 lerp=25 hypot=5 cbrt=3 log2=3 atan2x100=78 rangeOk=1 dOk=1 boolOk=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: Math (LLVM intrinsics) + Random (xorshift64); seed 42 is deterministic.
        add_test(NAME codegen_math_stdlib_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/math_stdlib.pol"
            "-DEXPECTED=sqrt=4 pow=1024 max=7 floor=3 rand=5 46 78"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: address type, int<->pointer casts, raw pointer indexing, Memory API.
        add_test(NAME codegen_low_level_memory_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/low_level_memory.pol"
            "-DEXPECTED=sum=300 read=999 addr=0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: a `freestanding` program -- regions/Memory/pointers/FFI, no managed
        # runtime; emits via an external C function (compiled hosted here).
        add_test(NAME codegen_freestanding_kernel_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_kernel.pol"
            "-DEXPECTED=OK"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # The chaos tetrad (goto/comefrom/abstainfrom/reinstate) works in freestanding: no managed
        # runtime, just branches and an atomic counter (spec 7.9-7.11).
        add_test(NAME codegen_freestanding_tetrad_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/freestanding_tetrad.pol"
            "-DEXPECTED=BB"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # `checked(...)` ON BARE METAL PANICS, and used to do nothing whatsoever: the overflow bit
        # was extracted and dropped, because the back end asked the triple instead of asking whether
        # anything could be thrown. The exit code IS the test -- 72 is what a guard leaves the
        # process with -- and `A` proves the program reached the arithmetic rather than dying before
        # it.
        add_test(NAME codegen_checked_freestanding_panics COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/checked_freestanding_panics.pol"
            "-DCONTAINS=A"
            "-DERRCONTAINS=arithmetic overflow"
            "-DEXPECT_EXIT=72"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: FFI -- `extern cdecl method` declares + calls external C functions.
        add_test(NAME codegen_ffi_extern_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/ffi_extern.pol"
            "-DEXPECTED=abs=42 labs=1000000"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F9 freestanding: region over fixed memory -- itself.at(addr, size), for memory-mapped HW.
        add_test(NAME codegen_region_at_address_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_at_address.pol"
            "-DEXPECTED=v=77 raw=77"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # SIMD vectors (vec2/3/4): construction, element-wise ops, .xyzw + [i], by-value.
        add_test(NAME codegen_simd_vectors_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/simd_vectors.pol"
            "-DEXPECTED=c=11,22,33,44 d.z=6 dot=32 idxsum=110"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # defined behaviour: saturating float->int cast + unary minus on float (no UB).
        add_test(NAME codegen_defined_conversions_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/defined_conversions.pol"
            "-DEXPECTED=2147483647 -2147483648 42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # unimport (spec 30): physical code overwrite (byte=204) + UnimportedTypeException
        # on new and on a method call to a surviving instance.
        add_test(NAME codegen_unimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/unimport.pol"
            "-DEXPECTED=Woof! live refused byte=204 new caught"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reimport (spec 30.3): reload physically-unloaded code from the .exe on disk.
        add_test(NAME codegen_reimport_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reimport.pol"
            "-DEXPECTED=Woof! unimported Woof!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # onClassUnload (spec 32.5): fires when the class is unimported.
        add_test(NAME codegen_lifecycle_onunload_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lifecycle_onunload.pol"
            "-DEXPECTED=using cache cache unloaded done"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent partial constructor (spec 18.9): omitted persistent param reattaches.
        add_test(NAME codegen_persist_partial_ctor_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_partial_ctor.pol"
            "-DEXPECTED=7 17 27"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # persistent reattach by array index (spec 18.5): arr[i] keeps its own block across delete.
        add_test(NAME codegen_persist_array_reattach_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_array_reattach.pol"
            "-DCONTAINS=0 1 0 2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # F10 stdlib: real String + Console.print/println + String.length().
        add_test(NAME codegen_string_console_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_console.pol"
            "-DEXPECTED=Hello, World! direct literal no newline end len=13"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection (spec 31): reflect.typeOf<T>() + Type.name().
        add_test(NAME codegen_reflect_typeof_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_typeof.pol"
            "-DEXPECTED=Dog name=Dog len=3"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ArrayList<T> (F10 stdlib): growable list, value and reference elements.
        add_test(NAME codegen_arraylist_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/arraylist.pol"
            "-DEXPECTED=size=5 sum=150 alpha beta gamma"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection (spec 31): Type method/field enumeration.
        add_test(NAME codegen_reflect_members_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_members.pol"
            "-DEXPECTED=methods=2 fields=2 bark sit age tag"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # String methods (F10 stdlib): length/isEmpty/charAt/equals/concat/substring.
        add_test(NAME codegen_string_methods_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/string_methods.pol"
            "-DEXPECTED=Hello, World! len=13 empty=0 char0=H char7=W World eq=1 ne=0 emptyIsEmpty=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection invoke (spec 31): Type.method(name) + Method.name()/invoke(receiver).
        add_test(NAME codegen_reflect_invoke_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_invoke.pol"
            "-DEXPECTED=bark Woof! (sits)"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection construction (spec 31): Type.instantiate() + cast<T> downcast.
        add_test(NAME codegen_reflect_instantiate_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_instantiate.pol"
            "-DEXPECTED=Dog built age=7 Woof! Woof!"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # reflection collections (spec 31): Type.methods()/fields() -> ArrayList<String>.
        add_test(NAME codegen_reflect_methods_list_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/reflect_methods_list.pol"
            "-DEXPECTED=methods size=2 bark sit fields size=1 age"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy (spec 37.3): a lazy local initializes on first access, once; an
        # unaccessed lazy local is never initialized.
        add_test(NAME codegen_lazy_init_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_init.pol"
            "-DEXPECTED=before after decl constructing 1 x=1 y=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # lazy field (spec 28.4): a class-typed field is built on first access, once.
        add_test(NAME codegen_lazy_field_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/lazy_field.pol"
            "-DEXPECTED=before after holder constructing a=42 b=42"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # release persistent (spec 18.15) satisfies a non-eternal persistent's
        # release obligation; the program compiles and runs.
        add_test(NAME codegen_persist_release_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/persist_release.pol"
            "-DEXPECTED=slot=2"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # comptime if (spec 37.4): the branch is chosen at compile time from a const
        # condition; here DEBUG=false and LEVEL>=2, so "debug off" and "level high".
        add_test(NAME codegen_comptime_if_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/comptime_if.pol"
            "-DEXPECTED=debug off level high"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # region RAII: a region with no explicit release still runs and frees cleanly.
        add_test(NAME codegen_region_raii_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_raii.pol"
            "-DEXPECTED=a = 5"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A '%' inside an interpolation is TEXT. The literal segments used to be pasted into the
        # printf format string raw, so `100%success` became `%s`: printf read a value nobody passed,
        # treated it as a char* and followed it (exit 0xC0000005). One percent in every position --
        # leading, between holes, trailing, doubled, and right before a live conversion letter.
        add_test(NAME codegen_interp_percent_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/interp_percent.pol"
            "-DEXPECTED=50% of 1 | 1.2% | 1% and 2 | 100%success 1 | 1.2%%"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # A call to the type's OWN method is the type it returns, including when a member is read off
        # it. Every path that types a call needs a receiver to read the return type from, so a call
        # written without one fell through to the fallback and was typed `int` -- invisible until
        # something read a member off the result, and then reported as "no such field" pointing at
        # the field rather than at the call whose type was invented.
        add_test(NAME codegen_implicit_this_receiver_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/implicit_this_receiver.pol"
            "-DEXPECTED=4 8 4"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # And the way that WORKS, beside the way that is refused, so the error's advice is checked
        # rather than merely written: `onClassLoad` runs after the program has started, which is
        # when allocation becomes possible. A scalar keeps its declaration initializer, because a
        # scalar IS a constant and there is something to write into the binary.
        add_test(NAME codegen_static_alloc_init_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/static_alloc_init.pol"
            "-DEXPECTED=9 42 7 hello"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # spec 32.2: capture a region, keep working, put it back. Exercises all three forms and, more
        # to the point, that the restore RUNS DESTRUCTORS before it copies the bytes -- without that,
        # the space the newer object had is reused while a pointer to it still looks valid.
        add_test(NAME codegen_region_snapshot_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/region_snapshot.pol"
            "-DEXPECTED=before=2 after=1"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # generic variance (spec 15.3): covariant `out` and contravariant `in` make
        # a Producer<Dog>/Consumer<Animal> usable as Producer<Animal>/Consumer<Dog>.
        add_test(NAME codegen_variance_covariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_covariant.pol"
            "-DEXPECTED=make=7"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")
        add_test(NAME codegen_variance_contravariant_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/variance_contravariant.pol"
            "-DEXPECTED=tag=9"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ---- `command` -- the third kind of member (reference 14.1) ----
        #
        # The declared form built by naming it, the ROLE that lets an API take one without naming any
        # particular command, the call written as a call, and a command held in a field. The
        # structural conformance is what makes this worth a RUNNING test rather than an IR check:
        # `Gate` does not name `IntTest`, `count` does not name `aboveFloor`, and the numbers printed
        # are the proof that the two met anyway.
        add_test(NAME codegen_command_member_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_member.pol"
            "-DEXPECTED=over10=2 all=5 field=1 0"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # ...and the inline form, which is the same construct written at the use. Two of them in one
        # call site, each with its own baggage, because the names the compiler gives them are its own
        # business and nothing an author writes can collide with them.
        add_test(NAME codegen_command_inline_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/command_inline.pol"
            "-DEXPECTED=above6=3 isSeven=1 sum=58"
            "-DWORKDIR=${CMAKE_CURRENT_BINARY_DIR}"
            -P "${CMAKE_CURRENT_SOURCE_DIR}/run_exe_test.cmake")

        # finally runs even when the exception propagates uncaught out of the try,
        # to be caught by an outer try (spec 21.1).
        add_test(NAME codegen_finally_uncaught_runs COMMAND "${CMAKE_COMMAND}"
            "-DPOLC=$<TARGET_FILE:polc>"
            "-DCLANG=${POLARON_CLANG}"
            "-DINPUT=${CMAKE_CURRENT_SOURCE_DIR}/samples/finally_uncaught.pol"
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

add_executable(polaron_unit_tests
    unit/test_main.cpp
    unit/test_lexer.cpp
    unit/test_parser.cpp
    unit/test_semantic.cpp
    unit/test_polb.cpp  # .polb container read/write + fingerprint (self-contained)
    unit/test_manifest.cpp  # toolchain driver: manifest TOML-subset parser
    unit/test_sources.cpp   # toolchain driver: dependency source resolution
    unit/test_semver.cpp    # toolchain driver: semver parsing + range matching
    unit/test_formatter.cpp # polaron fmt: token-reflow formatting
    unit/test_discovery.cpp # toolchain driver: project discovery
    unit/test_jsonout.cpp   # toolchain driver: --json workspace output
    unit/test_lsp_json.cpp  # language server: JSON-RPC value parse/dump
    unit/test_pir.cpp       # PIR: the text form round-trips, and the §9 verifier rules bite
    ${CMAKE_SOURCE_DIR}/src/lsp/json.cpp
)
target_link_libraries(polaron_unit_tests PRIVATE polaron_core polaron_driver doctest::doctest)
# test_semver.cpp does `import polaron.driver.semver`, so this target's sources need scanning as well
# -- see the note beside the module file set in the root CMakeLists.txt for why it is not the default.
set_target_properties(polaron_unit_tests PROPERTIES CXX_SCAN_FOR_MODULES ON)
add_test(NAME unit_tests COMMAND polaron_unit_tests)

# The language server as a PROCESS: headers, dispatch, and the shape of definition/hover replies.
# The unit tests cover its JSON layer; this covers what an editor actually talks to. Skipped when no
# Python is available rather than failing a build that is otherwise fine.
find_package(Python3 COMPONENTS Interpreter QUIET)
if(Python3_FOUND)
    add_test(NAME lsp_protocol COMMAND ${Python3_EXECUTABLE}
        "${CMAKE_CURRENT_SOURCE_DIR}/lsp_probe.py" $<TARGET_FILE:polaron-lsp>)
endif()

# The bundle tests build fixed-name .polb/.polh artifacts in a shared directory, so they cannot run
# concurrently with each other under `ctest -j`. A shared resource lock serializes them among themselves
# while they still overlap the (parallel-safe) codegen tests. The `if(TEST ...)` guard keeps this valid
# in configurations where a given bundle test was not defined.
foreach(_bt bundle_lib_roundtrip bundle_polh_modifier_order bundle_vtable_conflict_reconciled bundle_static_call_runs
        bundle_instance_runs bundle_virtual_runs bundle_plugin_runs bundle_dynamic_runs
        bundle_dynamic_instance_runs bundle_dynamic_virtual_runs bundle_absent_caught
        bundle_abi_mismatch_caught two_bundle_link_runs bundle_inherit_runs)
    if(TEST ${_bt})
        set_tests_properties(${_bt} PROPERTIES RESOURCE_LOCK bundle_artifacts)
    endif()
endforeach()
