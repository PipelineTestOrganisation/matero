$BackupPath = "C:\iisServer\angular-27-02-2025"
$NewPath = "C:\iisServer\angular\"

$duplicateItems = Get-Item "$BackupPath*"
if ($duplicateItems) {
    $measure = $duplicateItems | Measure-Object
    for ($i = $measure.Count -1 ; $i -ge 0; $i--) {
        $duplicateItems[$i]
        Rename-Item -Path $duplicateItems[$i].FullName -NewName "$BackupPath ($($i + 1 ))"
    }
}

Move-Item -Path $NewPath -Destination $BackupPath
Copy-Item -r dist\test\browser\* $NewPath
Copy-Item "$BackupPath\web.config" $NewPath -ErrorAction SilentlyContinue