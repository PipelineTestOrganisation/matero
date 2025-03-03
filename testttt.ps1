$pathMainFolder = "C:\iisServer"
$nameProject = "angular"

$regexFolderCheck = "$nameProject-\d{4}-\d{2}-\d{2}( \(\d+\))?$"  

$NewPath = "$pathMainFolder\$nameProject"
$BackupPath = "$newPath-$(Get-Date -Format "yyyy-MM-dd")"
$BackupPath = "$newPath-2025-03-01"
$directories = Get-ChildItem -Path $pathMainFolder -Directory | Where-Object { $_.Name -match $regexFolderCheck }


if($directories.Count -gt 3){
        $directories | Sort-Object -Property LastWriteTime | Select-Object -First ($directories.Count - 2) | Remove-Item -Recurse
}


if(Test-Path $BackupPath){
    $duplicateItems = $directories | Where-Object { $_.Name -like $BackupPath }
    if ($duplicateItems) {
        $measure = $duplicateItems | Measure-Object
        for ($i = $($measure.Count -1); $i -ge 0; $i--) {
            
            if ($duplicateItems[$i].FullName) {
                Rename-Item -Path $duplicateItems[$i].FullName -NewName "$BackupPath ($($i + 1))"
            }
        }
    }
}

if(Test-Path $NewPath ){
    Move-Item -Path $NewPath -Destination $BackupPath
}

New-Item -ItemType Directory -Path $NewPath
Copy-Item -Recurse -Path C:\GitProjects\matero\test\dist\test\browser\* -Destination $NewPath
if(Test-Path "$BackupPath\web.config"){
    Copy-Item "$BackupPath\web.config" "$NewPath\web.config"
}