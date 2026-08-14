; Inno Setup script for the Polaron toolchain GUI installer.
; Build it with the Inno Setup command-line compiler (https://jrsoftware.org/isdl.php):
;     ISCC installer\polaron.iss
; That produces dist\polaron-toolchain-setup.exe. Build the toolchain in Release first:
;     cmake --build build --config Release --target polaron polc polaron-studio polaron-lsp
; Installs both front-ends -- the classic `polaron` CLI and the `polaron-studio` TUI -- plus the compiler,
; the language server and the runtime lib. Does not bundle clang (Polaron links with an existing LLVM).

#define AppVersion "0.1.0"
#define BinDir "..\build\bin\Release"

[Setup]
AppName=Polaron Toolchain
AppVersion={#AppVersion}
AppPublisher=Joao Victor Pereira Tavares
DefaultDirName={autopf}\polaron
DefaultGroupName=Polaron
OutputDir=..\dist
OutputBaseFilename=polaron-toolchain-setup
Compression=lzma2
SolidCompression=yes
ChangesEnvironment=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern

[Files]
Source: "{#BinDir}\polaron.exe";        DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\polc.exe";       DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\polaron-studio.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\polaron-lsp.exe";    DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\polaron_rt.lib";     DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Polaron Studio";     Filename: "{app}\polaron-studio.exe"
Name: "{group}\Uninstall Polaron";  Filename: "{uninstallexe}"

[Tasks]
Name: addtopath; Description: "Add Polaron to my user PATH (so polaron and polaron-studio work from any terminal)"

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; \
    ValueData: "{olddata};{app}"; Tasks: addtopath; Check: NeedsAddPath(ExpandConstant('{app}'))

[Run]
Filename: "{app}\polaron.exe"; Parameters: "--version"; Flags: runhidden nowait

[Code]
function NeedsAddPath(Dir: string): Boolean;
var
  Path: string;
begin
  if not RegQueryStringValue(HKCU, 'Environment', 'Path', Path) then
  begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Dir + ';', ';' + Path + ';') = 0;
end;
