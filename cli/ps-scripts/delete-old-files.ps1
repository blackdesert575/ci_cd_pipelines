$homeDir = $env:USERPROFILE

$targetPath = Join-Path -Path $homeDir -ChildPath "temp"

$cmd = "forfiles /p `"$targetPath`" /s /m *.txt /d -60 /c `"cmd /c del @path`""

Invoke-Expression $cmd

Write-Host "Delete $targetPath ..."