Copy-Item -Path "./istanbulkart.apk" -Destination "./istanbulkart_modified.zip"

Expand-Archive -Path "./istanbulkart_modified.zip" -DestinationPath "./istanbulkart/"

Remove-Item -Path "./istanbulkart_modified.zip" -Force

$addrFirst = 0x000009BA

$addrSecond = 0x000009BE

$addrThird = 0x000009C2

$bytes  = [System.IO.File]::ReadAllBytes("./istanbulkart/AndroidManifest.xml")

# version set to 4.0.1

$bytes[$addrFirst] = 0x34

$bytes[$addrSecond] = 0x30

$bytes[$addrThird] = 0x31

[System.IO.File]::WriteAllBytes("./istanbulkart/AndroidManifest.xml", $bytes)

Remove-Item -Path "./istanbulkart/META-INF/" -Recurse -Force

$currentDirectory = Get-Location

$winrarPath = "C:\Program Files\WinRAR\WinRAR.exe"

$sourceDirectory = Join-Path -Path $currentDirectory -ChildPath "istanbulkart\"

$winrarCommand = "& `"$winrarPath`" a -kd32 -r `"..\istanbulkart_modified.zip`" `".`""
# you can use zipalign if you want to use built-in methods.

Set-Location -Path $sourceDirectory

Invoke-Expression -Command $winrarCommand

$winrarProcess = Get-Process "WinRAR" -ErrorAction SilentlyContinue
if ($winrarProcess -ne $null) {
    Wait-Process -Id $winrarProcess.Id
}

Set-Location -Path $currentDirectory

Rename-Item -Path "./istanbulkart_modified.zip" -NewName "./istanbulkart_modified.apk"

Remove-Item -Path "./istanbulkart/" -Recurse -Force

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore key.keystore ./istanbulkart_modified.apk key0

Rename-Item -Path "./istanbulkart_modified.apk" -NewName "./istanbulkart_modified_signed.apk"