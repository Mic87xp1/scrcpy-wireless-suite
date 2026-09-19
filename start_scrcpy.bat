@echo off
title Avvio Automatizzato scrcpy Wi-Fi
color 0A

rem --- CONTROLLO DIPENDENZE (PREREQUISITI) ---
where adb >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERRORE CRITICO] 'adb' non e' installato o non e' presente nel PATH!
    echo Per favore, esegui prima lo script 'setup_environment.bat'.
    echo.
    pause
    exit /b 1
)

where scrcpy >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERRORE CRITICO] 'scrcpy' non e' installato o non e' presente nel PATH!
    echo Per favore, esegui prima lo script 'setup_environment.bat'.
    echo.
    pause
    exit /b 1
)

rem --- ESECUZIONE FLUSSO STREAMING ---
echo ===================================================
echo     CONFIGURATORE STREAMING SCRCPY WI-FI
echo ===================================================
echo.

set /p PHONE_IP="Inserisci l'IP del telefono (es. 192.168.1.157): "

echo.
echo [1/3] Pulizia vecchie connessioni ADB...
adb disconnect

echo.
echo [2/3] Connessione ADB a %PHONE_IP%:5555 in corso...
adb connect %PHONE_IP%:5555

echo.
echo [3/3] Avvio di scrcpy sul dispositivo %PHONE_IP%:5555...
scrcpy -s %PHONE_IP%:5555 -b 4M --max-fps=60 -m 1080 --audio-buffer=40 -w

echo.
echo ===================================================
echo Sessione terminata.
echo ===================================================
pause