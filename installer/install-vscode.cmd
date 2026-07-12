@echo off
rem Install the LDP3 VS Code extension for the current user by copying it into the VS Code extensions
rem folder. Called by the installer's optional "Install the VS Code extension" feature, and safe to run by
rem hand: install-vscode.cmd [path-to-extension]. No-op (never fails the install) when VS Code is absent.
setlocal
set "SRC=%~1"
if "%SRC%"=="" set "SRC=%~dp0vscode"
set "EXTROOT=%USERPROFILE%\.vscode\extensions"
if not exist "%EXTROOT%" (
  echo VS Code user extensions folder not found - is VS Code installed? Skipping.
  exit /b 0
)
rem The folder name follows VS Code's convention (publisher.name-version) so it is detected reliably.
set "DEST=%EXTROOT%\ldp3.ldp3-0.1.0"
xcopy /E /I /Y "%SRC%" "%DEST%" >nul 2>&1
if errorlevel 1 (
  echo Could not copy the extension; skipping.
) else (
  echo LDP3 VS Code extension installed to "%DEST%". Reload VS Code to activate it.
)
exit /b 0
