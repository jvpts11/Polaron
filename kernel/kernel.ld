/* Link the Polaron kernel at the conventional 1 MiB load address, with the Multiboot2 header first (the
   spec requires it within the first 32 KiB of the image so the bootloader can find it). */
ENTRY(_start)

SECTIONS {
    . = 1M;

    .note.Xen : {
        *(.note.Xen)
    }

    .text : {
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(COMMON)
        *(.bss*)
    }
}
