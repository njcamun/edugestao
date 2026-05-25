# Imprime SHA-1/SHA-256 debug e release para registo no Firebase Console.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$androidDir = Join-Path $root "android"
$keyProps = Join-Path $androidDir "key.properties"

Write-Host "=== EDUCLASS - impressoes digitais Android ===" -ForegroundColor Cyan
Write-Host "Pacote: com.example.edugestao"
Write-Host "Firebase: https://console.firebase.google.com/project/edugestao/settings/general"
Write-Host ""

Write-Host "--- DEBUG (flutter run) ---" -ForegroundColor Yellow
$debugKeystore = Join-Path $env:USERPROFILE ".android\debug.keystore"
if (Test-Path $debugKeystore) {
  keytool -list -v -keystore $debugKeystore -alias androiddebugkey -storepass android -keypass android 2>&1 |
    Select-String -Pattern "SHA1:|SHA256:"
} else {
  Write-Host "Keystore debug nao encontrado." -ForegroundColor Red
}

if (Test-Path $keyProps) {
  Write-Host ""
  Write-Host "--- RELEASE (upload-keystore / key.properties) ---" -ForegroundColor Yellow
  $props = @{}
  Get-Content $keyProps | ForEach-Object {
    if ($_ -match '^\s*([^#=]+)=(.*)$') {
      $props[$matches[1].Trim()] = $matches[2].Trim()
    }
  }
  $storeFile = $props['storeFile']
  $storePass = $props['storePassword']
  $alias = $props['keyAlias']
  if ($storeFile -and $storePass -and $alias) {
    $ksPath = Join-Path $androidDir $storeFile
    if (-not (Test-Path $ksPath)) { $ksPath = Join-Path $root $storeFile }
    if (Test-Path $ksPath) {
      keytool -list -v -keystore $ksPath -alias $alias -storepass $storePass 2>&1 |
        Select-String -Pattern "SHA1:|SHA256:"
    } else {
      Write-Host "Keystore release nao encontrado: $ksPath" -ForegroundColor Red
    }
  }
} else {
  Write-Host ""
  Write-Host "RELEASE: android/key.properties nao existe." -ForegroundColor Yellow
  Write-Host '  Execute: .\scripts\create-release-keystore.ps1'
}

Write-Host ""
Write-Host "--- Gradle signingReport ---" -ForegroundColor Yellow
Push-Location $androidDir
try {
  .\gradlew signingReport 2>&1 |
    Select-String -Pattern "Variant: (debug|release)$|SHA1:" |
    Select-Object -First 20
} finally {
  Pop-Location
}

Write-Host ""
Write-Host "Debug: docs\FIREBASE_APP_CHECK.md" -ForegroundColor Green
Write-Host "Release: docs\FIREBASE_RELEASE.md" -ForegroundColor Green
