// 32-bit x86 boot stub: the multiboot handshake, a stack, and a zeroed .bss.
//
// QEMU's `-kernel` implements the multiboot protocol, so it looks for this header near the start of the
// image and then enters at `_start` in 32-bit protected mode with paging off, a valid GDT, and no
// stack. That last omission is why this file exists at all.

.set MB_MAGIC,  0x1BADB002
.set MB_FLAGS,  0x0
.set MB_CHECK,  -(MB_MAGIC + MB_FLAGS)

// `"a"` -- ALLOCATABLE, and its absence made this test pass by luck for as long as the image stayed
// small. Without the flag the linker treats `.multiboot` as metadata: the script's `. = 1M;
// .multiboot : {...}` is ignored, the section gets address 0, it lands in NO load segment, and the
// only reason QEMU ever booted this image is that it scans the FILE for the magic and the section
// happened to sit at file offset 0x14f0. Grow `.text` past the search window -- which one region class
// did, 0x474 to 0x50dc -- and the header slides to 0x6310, QEMU says "Error loading uncompressed kernel
// without PVH ELF Note", and the guest writes nothing at all. A test that depends on the size of the
// program it is testing is not testing what it says.
.section .multiboot, "a"
.align 4
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECK

.section .text.boot
.globl _start
_start:
    mov     $__stack_top, %esp

    // Zero .bss with the bounds from the generated linker script. Bytewise, for the same reason as the
    // AArch64 stub: neither end is guaranteed aligned, and correctness is worth more than the cycles.
    mov     $__bss_start, %edi
    mov     $__bss_end, %ecx
    sub     %edi, %ecx
    xor     %al, %al
    cld
    rep stosb

    call    kmain

    // kmain returned, which a kernel is not supposed to do.
1:  hlt
    jmp     1b

// 64 KiB of stack, in .bss so it costs the image nothing on disk.
.section .bss
.align 16
__stack_bottom:
    .space 65536
.globl __stack_top
__stack_top:
