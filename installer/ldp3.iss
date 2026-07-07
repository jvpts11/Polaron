; Inno Setup script for the LDP3 toolchain GUI installer.
; Build it with the Inno Setup command-line compiler (https://jrsoftware.org/isdl.php):
;     ISCC installer\ldp3.iss
; That produces dist\ldp3-toolchain-setup.exe. Build the toolchain in Release first:
;     cmake --build build --config Release --target ldp3 ldp3c ldp3-studio ldp3-lsp
; Installs both front-ends -- the classic `ldp3` CLI and the `ldp3-studio` TUI -- plus the compiler,
; the language server and the runtime lib. Does not bundle clang (LDP3 links with an existing LLVM).

#define AppVersion "0.1.0"
#define BinDir "..\build\bin\Release"

[Setup]
AppName=LDP3 Toolchain
AppVersion={#AppVersion}
AppPublisher=Joao Victor Pereira Tavares
DefaultDirName={autopf}\ldp3
DefaultGroupName=LDP3
OutputDir=..\dist
OutputBaseFilename=ldp3-toolchain-setup
Compression=lzma2
SolidCompression=yes
ChangesEnvironment=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern

[Files]
Source: "{#BinDir}\ldp3.exe";        DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\ldp3c.exe";       DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\ldp3-studio.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\ldp3-lsp.exe";    DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\ldp3_rt.lib";     DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\LDP3 Studio";     Filename: "{app}\ldp3-studio.exe"
Name: "{group}\Uninstall LDP3";  Filename: "{uninstallexe}"

[Tasks]
Name: addtopath; Description: "Add LDP3 to my user PATH (so ldp3 and ldp3-studio work from any terminal)"

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; \
    ValueData: "{olddata};{app}"; Tasks: addtopath; Check: NeedsAddPath(ExpandConstant('{app}'))

[Run]
Filename: "{app}\ldp3.exe"; Parameters: "--version"; Flags: runhidden nowait

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
