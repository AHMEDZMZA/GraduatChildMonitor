@echo off
setlocal enabledelayedexpansion

echo =======================================
echo     Child Monitor App Auto-Runner
echo =======================================
echo.

:: Get the actual IPv4 address of the active network adapter (the one with internet access)
for /f "delims=" %%i in ('powershell -Command "(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -eq 'Up' }).IPv4Address.IPAddress | Select-Object -First 1"') do set IP=%%i

if "%IP%"=="" (
    echo [WARNING] Could not detect active IP Address automatically. Defaulting to 192.168.1.10
    set "IP=192.168.1.10"
)

echo [INFO] Detected Network IP Address: %IP%
set "BASE_URL=http://%IP%:8086/api/"
echo [INFO] Using Base URL for API: %BASE_URL%
echo.

if /i "%1"=="build" (
    echo [INFO] Running build_runner to regenerate API client...
    call dart run build_runner build --delete-conflicting-outputs
    if !errorlevel! neq 0 (
        echo [ERROR] build_runner failed!
        pause
        exit /b !errorlevel!
    )
    echo [SUCCESS] build_runner finished.
    echo.
) else (
    echo [INFO] Skipping build_runner. ^(To run it, use: run_app.bat build^)
    echo.
)

echo [INFO] Starting Flutter app...
call flutter run --dart-define=BASE_URL="%BASE_URL%"

pause
