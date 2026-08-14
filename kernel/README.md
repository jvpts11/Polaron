# A bootable 64-bit Polaron kernel

A minimal operating-system kernel written in Polaron, booting on bare x86-64 under QEMU. It proves the
freestanding path (spec 36) end to end: Polaron source compiles to a bare-metal object with no runtime, no
libc and no managed features, links against a tiny assembly boot stub, and runs in 64-bit long mode
writing straight to hardware.

What it does: `kernel.pol` casts `0xB8000` to an `int16*` and writes `"Polaron kernel OK"` into the VGA
text buffer (each cell is a character byte plus a colour attribute byte), then spins.

## Files

| File | Role |
|------|------|
| `kernel.pol` | the kernel itself -- `program Kernel freestanding` writing to VGA |
| `boot.s`      | boot stub: PVH note, 32-bit entry, long-mode bring-up, `call kmain` |
| `kernel.ld`   | linker script: load at 1 MiB, PVH note first |
| `build.ps1`   | compile + assemble + link into `kernel.elf` |
| `run.ps1`     | boot under QEMU (window, `-Verify`, or `-Headless`) |

## Build and run

```powershell
./build.ps1              # -> kernel.elf
./run.ps1                # opens a QEMU window: "Polaron kernel OK"
./run.ps1 -Verify        # headless: reads the VGA buffer back and checks the text
```

Needs LLVM (clang + ld.lld) and QEMU (`qemu-system-x86_64`); both are located automatically.

## How it boots

1. **PVH entry.** QEMU's `-kernel` accepts a 64-bit ELF carrying a `XEN_ELFNOTE_PHYS32_ENTRY` note and
   enters it at `_start` in 32-bit protected mode. (QEMU's own Multiboot loader rejects 64-bit ELFs, so
   PVH is the clean way to direct-boot one without GRUB.)
2. **Long mode.** `_start` identity-maps the first gigabyte with 2 MiB pages, enables PAE, sets
   `EFER.LME`, turns on paging, loads a 64-bit GDT and far-jumps into 64-bit code.
3. **kmain.** The 64-bit stub calls `kmain`, the Polaron entry. For a bare-metal target the compiler emits
   the entry as `kmain(args)` (called with null) instead of the hosted `main(argc, argv)`, so nothing
   constructs an argv array or otherwise touches libc.

## Compiler support

The only compiler change this needed: for a bare-metal target triple (`...-none...`) the entry point is
emitted as `kmain` with no argv-array construction, and the dead-code stripper keeps `kmain` as a root.
Everything else -- `cast<int16*>`, raw pointer indexing, `while (true)` -- was already part of
freestanding mode.
