@echo off
title Installer e Configuratore Smart Ambiente scrcpy / ADB
color 0B

echo ===================================================
echo   SETUP AUTOMATICO AMBIENTE SCRCPY & ADB
echo ===================================================
echo.

set "TARGET_DIR=%USERPROFILE%\scrcpy_tools"
set "NEED_ADB=0"
set "NEED_SCRCPY=0"

rem --- 1. CONTROLLO ESISTENZA ADB ---
where adb >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] 'adb' e' gia' presente nel sistema!
    for /f "delims=" %%i in ('where adb') do echo      Percorso: %%i
) else (
    echo [MISSING] 'adb' non e' stato trovato nel PATH.
    set "NEED_ADB=1"
)

echo.

rem --- 2. CONTROLLO ESISTENZA SCRCPY ---
where scrcpy >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] 'scrcpy' e' gia' presente nel sistema!
    for /f "delims=" %%i in ('where scrcpy') do echo      Percorso: %%i
) else (
    echo [MISSING] 'scrcpy' non e' stato trovato nel PATH.
    set "NEED_SCRCPY=1"
)

echo.
echo ---------------------------------------------------

rem --- 3. SE ENTRAMBI ESISTONO, ESCI ---
if %NEED_ADB% equ 0 if %NEED_SCRCPY% equ 0 (
    color 0A
    echo [SUCCESS] Tutti i componenti sono gia' installati e raggiungibili!
    echo Non e' necessario scaricare nulla.
    goto END
)

rem --- 4. PREPARAZIONE CARTELLA PER I COMPONENTI MANCANTI ---
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

rem --- 5. DOWNLOAD DEDICATO PER CIO' CHE MANCA ---
if %NEED_ADB% equ 1 (
    if not exist "%TARGET_DIR%\platform-tools" (
        echo [DOWNLOAD] Scaricamento ed estrazione di Android Platform Tools (ADB)...
        powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile '%TARGET_DIR%\adb.zip'"
        powershell -Command "Expand-Archive -Path '%TARGET_DIR%\adb.zip' -DestinationPath '%TARGET_DIR%' -Force"
        del "%TARGET_DIR%\adb.zip"
    )
    
    echo [PATH] Aggiunta di ADB al PATH utente...
    powershell -Command "$p = [Environment]::GetEnvironmentVariable('PATH', 'User'); $target = '%TARGET_DIR%\platform-tools'; if ($p -notlike '*' + $target + '*') { [Environment]::SetEnvironmentVariable('PATH', $p + ';' + $target, 'User') }"
)

if %NEED_SCRCPY% equ 1 (
    if not exist "%TARGET_DIR%\scrcpy-win64" (
        echo [DOWNLOAD] Scaricamento ed estrazione di scrcpy...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-win64-v3.1.zip' -OutFile '%TARGET_DIR%\scrcpy.zip'"
        powershell -Command "Expand-Archive -Path '%TARGET_DIR%\scrcpy.zip' -DestinationPath '%TARGET_DIR%' -Force"
        ren "%TARGET_DIR%\scrcpy-win64-v3.1" "scrcpy-win64"
        del "%TARGET_DIR%\scrcpy.zip"
    )
    
    echo [PATH] Aggiunta di scrcpy al PATH utente...
    powershell -Command "$p = [Environment]::GetEnvironmentVariable('PATH', 'User'); $target = '%TARGET_DIR%\scrcpy-win64'; if ($p -notlike '*' + $target + '*') { [Environment]::SetEnvironmentVariable('PATH', $p + ';' + $target, 'User') }"
)

echo.
echo ===================================================
echo  SETUP COMPLETATO!
echo  IMPORTANTE: Riapri la finestra del terminale/prompt
echo  per caricare le nuove variabili di ambiente nel PATH.
echo ===================================================

:END
echo.
pause