$BackupPath = "C:\iisServer\angular-27-02-2025"
$NewPath = "C:\iisServer\angular"

if(Test-Path $BackupPath){
    $duplicateItems = Get-Item "$BackupPath*"
    if ($duplicateItems) {
        $measure = $duplicateItems | Measure-Object
        Write-Output "Count: $($measure.Count)"
        for ($i = $($measure.Count -1); $i -ge 0; $i--) {
            Write-Output "Index: $i"
            if ($duplicateItems[$i].FullName) {
                Write-Output "FullName: $($duplicateItems[$i].FullName)"
                Rename-Item -Path $duplicateItems[$i].FullName -NewName "$BackupPath ($($i + 1))"
            } else {
                Write-Output "FullName is null for index $i"
            }
        }
    }
}


if(Test-Path $NewPath ){
    Move-Item -Path $NewPath -Destination $BackupPath
}
Copy-Item -Recurse dist\test\browser\* "$NewPath\"
if(Test-Path "$BackupPath\web.config"){
    Copy-Item "$BackupPath\web.config" "$NewPath\web.config"
}