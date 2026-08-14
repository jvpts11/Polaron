// AArch64 boot stub: what has to be true before compiled code can run, and nothing else.
//
// QEMU's `virt` machine with `-kernel <elf>` enters at the ELF entry point in EL1 with x0 holding the
// device tree address, and that is all it promises. There is no stack pointer, and .bss holds whatever
// the loader left in that RAM -- so a global a Polaron program expects to start at zero does not.
//
// Both are handled here rather than in the kernel, for the reason every boot stub exists: this is the
// window in which compiled code cannot yet run correctly, so the work in it has to be instructions.

.section .text.boot
.globl _start
_start:
    // A stack. It lives in .bss below, so this is only an address until the zeroing loop runs -- which
    // is fine, because nothing between here and there calls anything.
    adrp    x1, __stack_top
    add     x1, x1, :lo12:__stack_top
    mov     sp, x1

    // Zero .bss, using the bounds the generated linker script provides. Bytewise on purpose: the
    // section is not guaranteed to be 8-byte aligned at either end, and correctness here is worth
    // more than the microseconds.
    adrp    x1, __bss_start
    add     x1, x1, :lo12:__bss_start
    adrp    x2, __bss_end
    add     x2, x2, :lo12:__bss_end
1:  cmp     x1, x2
    b.hs    2f
    strb    wzr, [x1], #1
    b       1b

2:  bl      kmain

    // kmain returned, which a kernel is not supposed to do. Park the core rather than running off the
    // end of the image into whatever follows it.
3:  wfe
    b       3b

// 64 KiB of stack, in .bss so it costs the image nothing on disk.
.section .bss
.align 16
__stack_bottom:
    .space 65536
.globl __stack_top
__stack_top:
