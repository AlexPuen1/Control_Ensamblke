@echo off
title Configurar Inicio Automatico con Windows
cd /d "%~dp0"

echo ===================================================
echo     Configurar Inicio Automatico con Windows
echo ===================================================
echo.
echo Selecciona una opcion:
echo [1] Activar inicio automatico al encender la PC (con ventana visible)
echo [2] Activar inicio automatico al encender la PC (en segundo plano / invisible)
echo [3] Desactivar inicio automatico con Windows
echo [4] Salir
echo.
set /p opt="Elige una opcion (1-4): "

set STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set SHORTCUT_PATH=%STARTUP_DIR%\ControlEnsamble.lnk

if "%opt%"=="1" (
    powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%~dp0iniciar.bat'; $s.WorkingDirectory = '%~dp0'; $s.Save()"
    echo.
    echo [OK] Acceso directo agregado a la carpeta de Inicio de Windows.
    echo Se ejecutara automaticamente cada vez que inicies sesion.
    echo.
    pause
    exit /b 0
)

if "%opt%"=="2" (
    powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%~dp0iniciar_segundo_plano.vbs'; $s.WorkingDirectory = '%~dp0'; $s.Save()"
    echo.
    echo [OK] Acceso directo agregado en segundo plano a la carpeta de Inicio de Windows.
    echo Se ejecutara silenciosamente cada vez que inicies sesion.
    echo.
    pause
    exit /b 0
)

if "%opt%"=="3" (
    if exist "%SHORTCUT_PATH%" (
        del /f /q "%SHORTCUT_PATH%"
        echo.
        echo [OK] Se desactivo el inicio automatico.
    ) else (
        echo.
        echo [INFO] No habia ningun inicio automatico configurado.
    )
    echo.
    pause
    exit /b 0
)

echo Operacion cancelada.
exit /b 0
