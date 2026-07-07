/* Boot stub for the LDP3 kernel. A PVH boot note makes QEMU -kernel enter our 64-bit ELF at _start in
   32-bit protected mode; from there we bring up 64-bit long mode -- identity-map the first gigabyte with
   2 MiB pages, enable PAE, set EFER.LME, enable paging, load a 64-bit GDT and far-jump to 64-bit code --
   then call the LDP3 entry point kmain and halt. Assembled by clang's integrated assembler (GAS, Intel). */
.intel_syntax noprefix

/* ---- PVH boot note: QEMU -kernel accepts a 64-bit ELF that carries a XEN_ELFNOTE_PHYS32_ENTRY (type
   18) note and enters it at that address in 32-bit protected mode -- the clean way to direct-boot an
   ELF64 without GRUB. The entry is our 32-bit _start. ---- */
.section .note.Xen, "a"
.align 4
    .long 4                 /* namesz: "Xen\0" */
    .long 4                 /* descsz: a 32-bit entry address */
    .long 18                /* type: XEN_ELFNOTE_PHYS32_ENTRY */
    .asciz "Xen"
    .align 4
    .long _start

/* ---- page tables + stack ---- */
.section .bss
.align 4096
p4_table: .skip 4096
p3_table: .skip 4096
p2_table: .skip 4096
.align 16
stack_bottom: .skip 16384
stack_top:

/* ---- 32-bit entry ---- */
.section .text
.code32
.global _start
_start:
    mov esp, offset stack_top

    mov eax, offset p3_table
    or eax, 0b11
    mov [p4_table], eax
    mov eax, offset p2_table
    or eax, 0b11
    mov [p3_table], eax
    xor ecx, ecx
.map_p2:
    mov eax, 0x200000
    mul ecx
    or eax, 0b10000011
    mov [p2_table + ecx*8], eax
    inc ecx
    cmp ecx, 512
    jne .map_p2

    mov eax, offset p4_table
    mov cr3, eax
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    lgdt [gdt64_pointer]
    ljmp 0x08, offset long_mode_start

/* ---- 64-bit entry ---- */
.code64
long_mode_start:
    xor rax, rax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    call kmain
.hang:
    hlt
    jmp .hang

/* ---- 64-bit GDT ---- */
.section .rodata
.align 8
gdt64:
    .quad 0
    .quad 0x00209A0000000000
gdt64_pointer:
    .word gdt64_pointer - gdt64 - 1
    .quad gdt64
