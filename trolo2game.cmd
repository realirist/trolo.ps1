@echo off
setlocal

:: Variables
set "ZIP_URL=https://github.com/realirist/trolo.ps1/raw/refs/heads/main/trolo2game.zip"
set "TEMP_DIR=%TEMP%\trolo2tmp"
set "APPDATA_DIR=%APPDATA%\trolo2game"
set "START_MENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\trolo2game"
set "DESKTOP=%USERPROFILE%\Desktop"
set "EXE_PATH=%APPDATA_DIR%\trolo2\main.exe"

:: Cleanup previous temp
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

:: Download ZIP
powershell -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%TEMP_DIR%\trolo2game.zip'"

:: Unzip to TEMP_DIR
powershell -Command "Expand-Archive -Path '%TEMP_DIR%\trolo2game.zip' -DestinationPath '%TEMP_DIR%' -Force"

:: Move trolo2 folder to APPDATA
if exist "%APPDATA_DIR%" rd /s /q "%APPDATA_DIR%"
mkdir "%APPDATA_DIR%"
move "%TEMP_DIR%\trolo2" "%APPDATA_DIR%\"

:: Create Start Menu folder
if not exist "%START_MENU_DIR%" mkdir "%START_MENU_DIR%"

:: Create shortcut in Start Menu
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%START_MENU_DIR%\trolo2game.lnk'); $s.TargetPath='%EXE_PATH%'; $s.WorkingDirectory='%APPDATA_DIR%\trolo2'; $s.Save()"

:: Create shortcut on Desktop pointing to Start Menu shortcut
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP%\trolo2.lnk'); $s.TargetPath='%START_MENU_DIR%\trolo2game.lnk'; $s.Save()"

:: Cleanup temp
rd /s /q "%TEMP_DIR%"

echo Installation complete.
pause
