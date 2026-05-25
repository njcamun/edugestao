[Setup]
AppId={{7CFE93E0-6DAB-4B72-B4D8-BF79C403CC0D}
AppName=EDUCLASS
AppVersion=1.0.1
AppPublisher=EDUCLASS
AppVerName=EDUCLASS 1.0.1
AppComments=Sistema de gestao escolar offline-first com sincronizacao cloud.
VersionInfoCompany=EDUCLASS
VersionInfoDescription=Instalador do EDUCLASS
VersionInfoProductName=EDUCLASS
VersionInfoProductVersion=1.0.1
DefaultDirName={autopf}\EDUCLASS
DefaultGroupName=EDUCLASS
DisableProgramGroupPage=yes
OutputDir=..\..\build\distributions
OutputBaseFilename=edugestao-windows-setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
UninstallDisplayIcon={app}\edugestao.exe
SetupIconFile=..\runner\resources\app_icon.ico
WizardImageStretch=no
CloseApplications=yes
CloseApplicationsFilter=edugestao.exe
UsePreviousAppDir=yes
UsePreviousGroup=yes
UsePreviousTasks=yes

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "Criar atalho no ambiente de trabalho"; GroupDescription: "Atalhos:"

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\oauth.desktop.local.bat"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "..\..\client_secret_*.json"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[InstallDelete]
Type: filesandordirs; Name: "{app}\data"
Type: files; Name: "{app}\*.dll"
Type: files; Name: "{app}\*.exe"
Type: files; Name: "{app}\*.json"
Type: files; Name: "{app}\*.lib"
Type: files; Name: "{app}\*.exp"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Icons]
Name: "{group}\EDUCLASS"; Filename: "{app}\edugestao.exe"
Name: "{autodesktop}\EDUCLASS"; Filename: "{app}\edugestao.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\edugestao.exe"; Description: "Executar EDUCLASS"; Flags: nowait postinstall skipifsilent
