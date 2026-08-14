@echo off
rem Install the Polaron VS Code extension for the current user. The reliable path is `code --install-extension`
rem on the packaged .vsix -- a hand-copied extension folder is NOT detected by modern VS Code (1.9x+). Falls
rem back to a folder copy only when the `code` CLI cannot be found. Safe to run by hand:
rem   install-vscode.cmd [path-to-vscode-folder]
rem Never fails the install (always exits 0), even when VS Code is absent.
setlocal enableextensions
set "SRC=%~1"
if "%SRC%"=="" set "SRC=%~dp0vscode"

rem The packaged .vsix that ships alongside the extension files.
set "VSIX="
for %%F in ("%SRC%\*.vsix") do set "VSIX=%%~fF"

rem Locate the VS Code CLI: PATH first, then the usual per-user and per-machine install locations.
set "CODE="
for %%C in (code.cmd) do if not defined CODE set "CODE=%%~$PATH:C"
if not defined CODE if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd" set "CODE=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd"
if not defined CODE if exist "%ProgramFiles%\Microsoft VS Code\bin\code.cmd" set "CODE=%ProgramFiles%\Microsoft VS Code\bin\code.cmd"

if defined CODE if defined VSIX (
  call "%CODE%" --install-extension "%VSIX%" --force
  if not errorlevel 1 (
    echo Polaron VS Code extension installed. Reload VS Code to activate it.
    exit /b 0
  )
  echo "code --install-extension" failed; falling back to a folder copy.
)

rem Fallback: copy the extension folder into the user extensions dir (best effort; modern VS Code may not
rem detect a hand-copied folder, so tell the user how to finish it via the CLI).
set "EXTROOT=%USERPROFILE%\.vscode\extensions"
if not exist "%EXTROOT%" (
  echo VS Code not detected ^(no code CLI and no user extensions folder^) - skipping.
  if defined VSIX echo To install later: code --install-extension "%VSIX%"
  exit /b 0
)
set "DEST=%EXTROOT%\polaron.pol-0.1.0"
xcopy /E /I /Y "%SRC%" "%DEST%" >nul 2>&1
if errorlevel 1 (
  echo Could not install the extension; skipping.
) else (
  echo Polaron VS Code extension copied to "%DEST%".
  if defined VSIX echo If VS Code does not detect it, run: code --install-extension "%VSIX%"
)
exit /b 0
