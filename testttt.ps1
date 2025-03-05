$pathMainFolderToDeploy = "C:\iisServer"
$nameProject = "angular"
$pathBuildFolder = "C:\GitProjects\matero\test\dist\test\browser"


$regexFolderCheck = "$nameProject-\d{4}-\d{2}-\d{2}( \((\d{0,2})\))?$"  

$NewPath = "$pathMainFolderToDeploy\$nameProject"
$BackupPath = "$newPath-$(Get-Date -Format "yyyy-MM-dd")"
$directories = Get-ChildItem -Path $pathMainFolderToDeploy -Directory | Where-Object { $_.Name -match $regexFolderCheck }

if ($directories.Count -gt 3) {
    $directories | Sort-Object -Property LastWriteTime | Select-Object -First 1 | Remove-Item -Recurse
}

$directories = Get-ChildItem -Path $pathMainFolderToDeploy -Directory | Where-Object { $_.Name -match $regexFolderCheck }

if (Test-Path $BackupPath) {

    $duplicateItems = $directories | Where-Object { $_.FullName -match [regex]::Escape($BackupPath) + "(\s\(\d+\))?$" }
    if ($duplicateItems) {
        $measure = $duplicateItems | Measure-Object
        for ($i = $($measure.Count - 1); $i -ge 0; $i--) {
            if ($duplicateItems[$i].FullName -and $duplicateItems[$i].FullName -ne "$BackupPath ($($i + 1))") {
                Rename-Item -Path $duplicateItems[$i].FullName -NewName "$BackupPath ($($i + 1))"
            }
        }
    }
}

if (Test-Path $NewPath ) {
    Move-Item -Path $NewPath -Destination $BackupPath
}

New-Item -ItemType Directory -Path $NewPath
Copy-Item -Recurse -Path "$pathBuildFolder\*" -Destination $NewPath
if (Test-Path "$BackupPath\web.config") {
    Copy-Item "$BackupPath\web.config" "$NewPath\web.config"
}

