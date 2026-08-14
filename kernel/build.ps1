# Build the bootable Polaron kernel: compile the freestanding kernel to a bare-metal object, assemble the
# boot stub, and link them at 1 MiB with the kernel linker script into a Multiboot2 kernel.elf.
param(
    [string]$POLC = "$PSScriptRoot\..\build\bin\Debug\polc.exe",
    [string]$Clang = ""
)
# Continue on native-command stderr (clang writes harmless warnings there); we gate on $LASTEXITCODE.
$ErrorActionPreference = "Continue"
# Prefer clang on PATH, falling back to the usual install location, so this runs on any machine.
if (-not $Clang) {
    $Clang = (Get-Command clang -ErrorAction SilentlyContinue).Source
    if (-not $Clang) { $Clang = "C:\Program Files\LLVM\bin\clang.exe" }
}
$here = $PSScriptRoot
$TT = "x86_64-unknown-none-elf"

Write-Host "[1/4] kernel.pol -> LLVM IR (freestanding)"
& $POLC "$here\kernel.pol" "--target=$TT" -o "$here\kernel_polaron.ll"
if ($LASTEXITCODE -ne 0) { throw "polc failed" }

Write-Host "[2/4] IR -> object"
& $Clang "--target=$TT" -ffreestanding -fno-exceptions -fno-rtti -mno-red-zone -c "$here\kernel_polaron.ll" -o "$here\kernel_polaron.o"
if ($LASTEXITCODE -ne 0) { throw "clang (IR) failed" }

Write-Host "[3/4] boot.s -> object"
& $Clang "--target=$TT" -c "$here\boot.s" -o "$here\boot.o"
if ($LASTEXITCODE -ne 0) { throw "clang (asm) failed" }

Write-Host "[4/4] link -> kernel.elf"
$LldDir = Split-Path $Clang
& "$LldDir\ld.lld.exe" -m elf_x86_64 -T "$here\kernel.ld" --build-id=none -o "$here\kernel.elf" "$here\boot.o" "$here\kernel_polaron.o"
if ($LASTEXITCODE -ne 0) { throw "link failed" }

Write-Host "OK -> $here\kernel.elf"
