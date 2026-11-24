@echo off
title Control Ensamble
cd /d "%~dp0"

echo ===================================================
echo          Iniciando Control Ensamble
echo ===================================================
echo.

:: 1. Verificar si Node.js esta instalado
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado o no se encuentra en el PATH del sistema.
    echo Por favor descargalo e instalalo desde: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

:: 2. Si no existe node_modules, instalar dependencias automaticamente
if not exist "node_modules\" (
    echo [INFO] Primera ejecucion detectada. Instalando dependencias...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Ocurrio un error al instalar las dependencias.
        pause
        exit /b 1
    )
    echo [OK] Dependencias instaladas correctamente.
    echo.
)

:: 3. Abrir la interfaz en el navegador web predeterminado
echo [INFO] Abriendo http://localhost:3000 en el navegador...
start "" cmd /c "ping 127.0.0.1 -n 3 >nul & start http://localhost:3000"

:: 4. Iniciar el servidor Node.js
echo [INFO] Servidor en ejecucion. Para detenerlo, cierra esta ventana.
echo.
node server.js

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] El servidor se detuvo de forma inesperada.
    pause
)
