# Boot the Polaron kernel under QEMU.
#   (default)  open a VGA window showing "Polaron kernel OK"
#   -Verify    headless: boot, read the VGA text buffer over the QEMU monitor, and check the text
#   -Headless  headless: boot and confirm it does not fault (spins) within the timeout
# Requires qemu-system-x86_64 (found on PATH or under C:\Program Files\qemu).
param(
    [switch]$Headless,
    [switch]$Verify,
    [int]$TimeoutSec = 4,
    [string]$Qemu = ""
)
$here = $PSScriptRoot
$elf = "$here\kernel.elf"
if (-not (Test-Path $elf)) { throw "kernel.elf not found; run build.ps1 first" }
if ($Qemu -eq "") {
    $Qemu = (Get-Command qemu-system-x86_64 -ErrorAction SilentlyContinue).Source
    if (-not $Qemu) { $Qemu = "C:\Program Files\qemu\qemu-system-x86_64.exe" }
}
if (-not (Test-Path $Qemu)) { throw "qemu-system-x86_64 not found (pass -Qemu <path>)" }

if ($Verify) {
    # Boot with the monitor on a socket, let the guest write VGA, then dump 0xB8000 to a file and decode
    # the low byte of each 16-bit cell back into text.
    $vga = "$here\vga.dump"; $vgaFwd = $vga -replace '\\','/'
    $p = Start-Process $Qemu -PassThru -ArgumentList `
        "-kernel","$elf","-display","none","-no-reboot","-monitor","tcp:127.0.0.1:5601,server,nowait"
    Start-Sleep -Seconds 2
    try {
        $c = New-Object System.Net.Sockets.TcpClient("127.0.0.1", 5601)
        $w = New-Object System.IO.StreamWriter($c.GetStream())
        $w.WriteLine("pmemsave 0xb8000 32 $vgaFwd"); $w.Flush(); Start-Sleep -Milliseconds 400
        $w.WriteLine("quit"); $w.Flush(); Start-Sleep -Milliseconds 300; $c.Close()
    } catch { Write-Host "monitor error: $_" }
    if (-not $p.HasExited) { $p.Kill() }
    Start-Sleep -Milliseconds 200
    if (-not (Test-Path $vga)) { Write-Host "FAIL: no VGA dump"; exit 1 }
    $b = [System.IO.File]::ReadAllBytes($vga)
    # Decode the low byte of each 16-bit VGA cell into text. A plain for-statement building a
    # StringBuilder, so this parses on stock Windows PowerShell 5.1 (not just pwsh 7).
    $sb = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $b.Length; $i += 2) {
        if ($b[$i] -ge 32 -and $b[$i] -lt 127) { [void]$sb.Append([char]$b[$i]) } else { [void]$sb.Append('.') }
    }
    $text = $sb.ToString()
    Write-Host "VGA: '$text'"
    if ($text -like "Polaron kernel OK*") { Write-Host "PASS"; exit 0 } else { Write-Host "FAIL"; exit 1 }
} elseif ($Headless) {
    $log = "$here\qemu.log"
    $p = Start-Process $Qemu -PassThru -NoNewWindow -ArgumentList `
        "-kernel","$elf","-display","none","-no-reboot","-no-shutdown","-d","int,guest_errors","-D","$log"
    Start-Sleep -Seconds $TimeoutSec
    if (-not $p.HasExited) { $p.Kill(); Write-Host "kernel still running after ${TimeoutSec}s (booted, spinning)" }
    else { Write-Host "QEMU exited early (exit $($p.ExitCode)) -- likely a fault; see qemu.log" }
} else {
    & $Qemu -kernel $elf
}
