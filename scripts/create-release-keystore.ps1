# Cria keystore de release para EDUCLASS (Android).
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$androidDir = Join-Path $root "android"
$keystorePath = Join-Path $androidDir "upload-keystore.jks"
$keyPropsPath = Join-Path $androidDir "key.properties"
$keyPropsExample = Join-Path $androidDir "key.properties.example"

if (Test-Path $keystorePath) {
  Write-Host "Keystore ja existe: $keystorePath" -ForegroundColor Yellow
  exit 0
}

Write-Host "=== Criar keystore de RELEASE (EDUCLASS) ===" -ForegroundColor Cyan
$storePass = Read-Host "storePassword (guarde em local seguro)"
$keyPass = Read-Host "keyPassword (Enter = igual a storePassword)"
if ([string]::IsNullOrWhiteSpace($keyPass)) { $keyPass = $storePass }

Push-Location $androidDir
try {
  keytool -genkey -v `
    -keystore upload-keystore.jks `
    -keyalg RSA -keysize 2048 -validity 10000 `
    -alias upload `
    -storepass $storePass -keypass $keyPass `
    -dname "CN=EDUCLASS, OU=Mobile, O=Edugestao, L=Luanda, ST=Luanda, C=AO"
} finally {
  Pop-Location
}

if (-not (Test-Path $keyPropsPath)) {
  Copy-Item $keyPropsExample $keyPropsPath
  $content = Get-Content $keyPropsPath -Raw
  $content = $content.Replace("SUBSTITUA", $storePass)
  Set-Content -Path $keyPropsPath -Value $content -NoNewline
  Write-Host "Criado $keyPropsPath - confirme passwords se necessario." -ForegroundColor Green
}

Write-Host ""
Write-Host "Proximo passo:" -ForegroundColor Green
Write-Host '  .\scripts\firebase-android-sha.ps1'
Write-Host '  Registe SHA-1/SHA-256 RELEASE no Firebase + Play Integrity'
Write-Host '  Ver: docs\FIREBASE_RELEASE.md'
