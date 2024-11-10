$rootFolder = "\\YOUR-SERVER\PATH\PATH\"

$outputCsv = ".\FolderSizes.csv"

$folderSizes = @()



$childFolders = Get-ChildItem -Path $rootFolder -Directory


foreach ($folder in $childFolders) {

    $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum

    $folderInfo = [pscustomobject]@{
        FolderName = $folder.Name
        FolderSizeMB = [math]::round($folderSize / 1MB, 2)
    }

    $folderInfo

    $folderSizes += $folderInfo
	
}


$folderSizes | Export-Csv -Path $outputCsv -NoTypeInformation

Write-Host "Output saved to $outputCsv"

Start-Sleep -s 9999