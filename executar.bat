@echo off
chcp 65001 >nul
title Edugestao - Flutter Launcher
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: ============================================================
::   MENU PRINCIPAL
:: ============================================================
:menu_principal
cls
echo.
echo  ============================================================
echo    Edugestao  ^|  Flutter Launcher
echo  ============================================================
echo.
echo   [1]  Executar app         (flutter run)
echo   [2]  Build release        (gerar artefacto)
echo   [3]  Utilitarios          (clean, analyze, test, ...)
echo.
echo   [Q]  Sair
echo.
set /p ACAO=  Opcao: 

if /i "!ACAO!"=="1" goto menu_plataforma_run
if /i "!ACAO!"=="2" goto menu_plataforma_build
if /i "!ACAO!"=="3" goto menu_utilitarios
if /i "!ACAO!"=="q" goto sair
goto menu_principal


:: ============================================================
::   EXECUTAR - selecao de plataforma
:: ============================================================
:menu_plataforma_run
cls
echo.
echo  -- Executar app --   Selecione a plataforma:
echo.
echo   [1]  Windows
echo   [2]  Android
echo   [3]  Web (Chrome)
echo   [4]  iOS
echo   [5]  Linux
echo   [6]  macOS
echo   [7]  Outro  (device id manual)
echo.
echo   [V]  Voltar
echo.
set /p PLAT=  Plataforma: 

if /i "!PLAT!"=="v" goto menu_principal
if "!PLAT!"=="1" ( set "RUN_DEVICE=-d windows" & set "PLAT_LABEL=Windows"        & goto menu_modo_run )
if "!PLAT!"=="2" ( set "RUN_DEVICE=-d android" & set "PLAT_LABEL=Android"        & goto menu_modo_run )
if "!PLAT!"=="3" ( set "RUN_DEVICE=-d chrome"  & set "PLAT_LABEL=Web (Chrome)"   & goto menu_modo_run )
if "!PLAT!"=="4" ( set "RUN_DEVICE=-d ios"     & set "PLAT_LABEL=iOS"            & goto menu_modo_run )
if "!PLAT!"=="5" ( set "RUN_DEVICE=-d linux"   & set "PLAT_LABEL=Linux"          & goto menu_modo_run )
if "!PLAT!"=="6" ( set "RUN_DEVICE=-d macos"   & set "PLAT_LABEL=macOS"          & goto menu_modo_run )
if "!PLAT!"=="7" goto plat_outro_run
goto menu_plataforma_run

:plat_outro_run
echo.
call flutter devices
echo.
set /p DEVICE_ID=  Device id: 
if "!DEVICE_ID!"=="" goto menu_plataforma_run
set "RUN_DEVICE=-d !DEVICE_ID!"
set "PLAT_LABEL=!DEVICE_ID!"
goto menu_modo_run

:menu_modo_run
cls
echo.
echo  -- Executar app --   Plataforma: !PLAT_LABEL!
echo.
echo   [1]  Debug     (hot reload, menos estavel no Windows)
echo   [2]  Profile   (medir performance)
echo   [3]  Release   (codigo optimizado, recomendado no Windows)
echo.
echo   [V]  Voltar
echo.
set /p MODO=  Modo: 

if "!MODO!"=="" if /i "!PLAT_LABEL!"=="Windows" set "MODO=3"

if /i "!MODO!"=="v" goto menu_plataforma_run
if "!MODO!"=="1" ( set "MODO_FLAG="          & set "MODO_LABEL=Debug"   & goto confirmar_run )
if "!MODO!"=="2" ( set "MODO_FLAG=--profile" & set "MODO_LABEL=Profile" & goto confirmar_run )
if "!MODO!"=="3" ( set "MODO_FLAG=--release" & set "MODO_LABEL=Release" & goto confirmar_run )
goto menu_modo_run

:confirmar_run
cls
echo.
echo  -- Confirmar execucao --
echo.
echo   Plataforma : !PLAT_LABEL!
echo   Modo       : !MODO_LABEL!
echo.
set /p SKIP_PREP=  Executar clean + pub get antes? [S/n]: 
if /i "!SKIP_PREP!"=="n" goto do_run

call :sub_clean_pubget
if errorlevel 1 goto erro

:do_run
set "RUN_EXTRA_ARGS="
if /i "!PLAT_LABEL!"=="Windows" (
	if "!MODO_LABEL!"=="Debug" (
		echo.
		echo  [AVISO] Debug no Windows pode causar crash nativo (ucrtbased.dll).
		set /p CONT_DEBUG=  Continuar em Debug mesmo assim? [s/N]: 
		if /i not "!CONT_DEBUG!"=="s" (
			set "MODO_FLAG=--release"
			set "MODO_LABEL=Release"
			echo  [INFO] A trocar para Release para maior estabilidade.
		)
	)
	call :sub_load_desktop_oauth
	call :sub_apply_windows_stability_patch
	if errorlevel 1 goto erro
)

echo.
echo  [RUN] flutter run !RUN_DEVICE! !MODO_FLAG! !RUN_EXTRA_ARGS!
echo.
call flutter run !RUN_DEVICE! !MODO_FLAG! !RUN_EXTRA_ARGS!
if errorlevel 1 goto erro
goto pos_acao


:: ============================================================
::   BUILD RELEASE - selecao de plataforma
:: ============================================================
:menu_plataforma_build
cls
echo.
echo  -- Build release --   Selecione a plataforma:
echo.
echo   [1]  Windows          (.exe)
echo   [2]  Android APK      (.apk)
echo   [3]  Android Bundle   (.aab  ^| Google Play)
echo   [4]  Web              (pasta build\web)
echo   [5]  iOS
echo   [6]  Linux
echo   [7]  macOS
echo.
echo   [V]  Voltar
echo.
set /p BPLAT=  Plataforma: 

if /i "!BPLAT!"=="v" goto menu_principal
if "!BPLAT!"=="1" ( set "BUILD_CMD=flutter build windows --release"   & set "BUILD_LABEL=Windows (.exe)"      & goto confirmar_build )
if "!BPLAT!"=="2" ( set "BUILD_CMD=flutter build apk --release"       & set "BUILD_LABEL=Android APK"         & goto confirmar_build )
if "!BPLAT!"=="3" ( set "BUILD_CMD=flutter build appbundle --release"  & set "BUILD_LABEL=Android App Bundle" & goto confirmar_build )
if "!BPLAT!"=="4" ( set "BUILD_CMD=flutter build web --release"        & set "BUILD_LABEL=Web"                & goto confirmar_build )
if "!BPLAT!"=="5" ( set "BUILD_CMD=flutter build ios --release"        & set "BUILD_LABEL=iOS"                & goto confirmar_build )
if "!BPLAT!"=="6" ( set "BUILD_CMD=flutter build linux --release"      & set "BUILD_LABEL=Linux"              & goto confirmar_build )
if "!BPLAT!"=="7" ( set "BUILD_CMD=flutter build macos --release"      & set "BUILD_LABEL=macOS"              & goto confirmar_build )
goto menu_plataforma_build

:confirmar_build
cls
echo.
echo  -- Confirmar build --
echo.
echo   Plataforma : !BUILD_LABEL!
echo.
set /p SKIP_PREP_B=  Executar clean + pub get antes? [S/n]: 
if /i "!SKIP_PREP_B!"=="n" goto do_build

call :sub_clean_pubget
if errorlevel 1 goto erro

:do_build
if /i "!BUILD_LABEL!"=="Windows (.exe)" (
	call :sub_apply_windows_stability_patch
	if errorlevel 1 goto erro
)

echo.
echo  [BUILD] !BUILD_CMD!
echo.
call !BUILD_CMD!
if errorlevel 1 goto erro
echo.
echo  Build concluido com sucesso.
goto pos_acao


:: ============================================================
::   UTILITARIOS
:: ============================================================
:menu_utilitarios
cls
echo.
echo  -- Utilitarios Flutter --
echo.
echo   [1]   flutter clean
echo   [2]   flutter pub get
echo   [3]   flutter pub upgrade
echo   [4]   flutter pub outdated
echo   [5]   flutter analyze
echo   [6]   flutter test
echo   [7]   flutter test --coverage
echo   [8]   dart run build_runner build
echo   [9]   dart run build_runner watch
echo   [10]  dart format lib
echo   [11]  flutter doctor -v
echo   [12]  flutter upgrade
echo   [13]  flutter devices
echo   [14]  flutter --version
echo.
echo   [V]   Voltar
echo.
set /p UTIL=  Opcao: 

if /i "!UTIL!"=="v"  goto menu_principal
if "!UTIL!"=="1"  ( call flutter clean                                              & goto pos_util )
if "!UTIL!"=="2"  ( call flutter pub get                                            & goto pos_util )
if "!UTIL!"=="3"  ( call flutter pub upgrade                                        & goto pos_util )
if "!UTIL!"=="4"  ( call flutter pub outdated                                       & goto pos_util )
if "!UTIL!"=="5"  ( call flutter analyze                                            & goto pos_util )
if "!UTIL!"=="6"  ( call flutter test                                               & goto pos_util )
if "!UTIL!"=="7"  ( call flutter test --coverage                                    & goto pos_util )
if "!UTIL!"=="8"  ( call dart run build_runner build --delete-conflicting-outputs   & goto pos_util )
if "!UTIL!"=="9"  ( call dart run build_runner watch --delete-conflicting-outputs   & goto pos_util )
if "!UTIL!"=="10" ( call dart format lib                                            & goto pos_util )
if "!UTIL!"=="11" ( call flutter doctor -v                                          & goto pos_util )
if "!UTIL!"=="12" ( call flutter upgrade                                            & goto pos_util )
if "!UTIL!"=="13" ( call flutter devices                                            & goto pos_util )
if "!UTIL!"=="14" ( call flutter --version                                          & goto pos_util )
goto menu_utilitarios

:pos_util
echo.
pause
goto menu_utilitarios


:: ============================================================
::   SUBROTINAS
:: ============================================================
:sub_clean_pubget
echo.
echo  [1/2] flutter clean...
call flutter clean
if errorlevel 1 exit /b 1
echo.
echo  [2/2] flutter pub get...
call flutter pub get
if errorlevel 1 exit /b 1

call :sub_apply_windows_stability_patch
if errorlevel 1 exit /b 1

exit /b 0


:sub_apply_windows_stability_patch
if not exist "windows\flutter\generated_plugins.cmake" exit /b 0

echo.
echo  [PATCH] Aplicando estabilidade Windows (desativar firebase_auth nativo)...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='windows\flutter\generated_plugins.cmake';" ^
  "$c=Get-Content -Raw $p;" ^
  "$c=[regex]::Replace($c,'(?m)^\s*firebase_auth\s*\r?\n','');" ^
  "Set-Content -Path $p -Value $c -Encoding UTF8;"
if errorlevel 1 exit /b 1

if exist "windows\flutter\generated_plugin_registrant.cc" (
	powershell -NoProfile -ExecutionPolicy Bypass -Command ^
	  "$p='windows\flutter\generated_plugin_registrant.cc';" ^
	  "$c=Get-Content -Raw $p;" ^
	  "$c=$c -replace '(?m)^#include <firebase_auth\/firebase_auth_plugin_c_api\.h>\r?\n','';" ^
	  "$c=$c -replace 'FirebaseAuthPluginCApiRegisterWithRegistrar\([\s\S]*?\);\r?\n','';" ^
	  "Set-Content -Path $p -Value $c -Encoding UTF8;"
	if errorlevel 1 exit /b 1
)

echo  [OK] Patch Windows aplicado.
exit /b 0


:sub_load_desktop_oauth
set "RUN_EXTRA_ARGS="
set "GOOGLE_OAUTH_CLIENT_ID="
set "GOOGLE_OAUTH_CLIENT_SECRET="

if not exist "oauth.desktop.local.bat" (
	echo.
	echo  [AVISO] oauth.desktop.local.bat nao encontrado. O login Google no desktop pode falhar.
	exit /b 0
)

call oauth.desktop.local.bat

if "!GOOGLE_OAUTH_CLIENT_ID!"=="" (
	echo.
	echo  [AVISO] GOOGLE_OAUTH_CLIENT_ID nao definido em oauth.desktop.local.bat.
	exit /b 0
)

if "!GOOGLE_OAUTH_CLIENT_SECRET!"=="" (
	echo.
	echo  [AVISO] GOOGLE_OAUTH_CLIENT_SECRET nao definido em oauth.desktop.local.bat.
	exit /b 0
)

set "RUN_EXTRA_ARGS=--dart-define=GOOGLE_OAUTH_CLIENT_ID=!GOOGLE_OAUTH_CLIENT_ID! --dart-define=GOOGLE_OAUTH_CLIENT_SECRET=!GOOGLE_OAUTH_CLIENT_SECRET!"
echo.
echo  [INFO] OAuth desktop carregado de oauth.desktop.local.bat.
exit /b 0


:: ============================================================
::   HANDLERS FINAIS
:: ============================================================
:erro
echo.
echo  ERRO: O comando anterior falhou. Verifique o log acima.
pause
goto menu_principal

:pos_acao
echo.
pause
goto menu_principal

:sair
echo.
echo  Ate logo!
timeout /t 1 >nul
endlocal
exit /b 0
