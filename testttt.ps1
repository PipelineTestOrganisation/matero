$BackupPath = "C:\iisServer\angular-27-02-2025"
$NewPath = "C:\iisServer\angular"

$duplicateItems = Get-Item "$BackupPath*"
if ($duplicateItems) {
    $measure = Measure-Object -InputObject $duplicateItems
    Write-Output $duplicateItems
    for ($i = $measure.Count; $i -ge 0; $i--) {
        if ($null -ne $duplicateItems[$i]) {
            $duplicateItems[$i].name
            Rename-Item -Path $duplicateItems[$i].FullName -NewName "$BackupPath ($($i + 1))"
        }
    }
}

Move-Item -Path $NewPath -Destination $BackupPath
Copy-Item -r dist\test\browser\* $NewPath
Copy-Item "$BackupPath\web.config" $NewPath -ErrorAction SilentlyContinue