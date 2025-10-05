$homeDir = [Environment]::GetFolderPath("UserProfile")

$tempDir = Join-Path -Path $homeDir -ChildPath "temp"
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

for ($i = 0; $i -lt 90; $i++) {
    $date = (Get-Date).AddDays(-$i)
    $fileName = "$($date.ToString('yyyy-MM-dd')).txt"
    $filePath = Join-Path -Path $tempDir -ChildPath $fileName

    New-Item -Path $filePath -ItemType File -Force | Out-Null

    $file = Get-Item $filePath
    $file.CreationTime = $date
    $file.LastWriteTime = $date
}