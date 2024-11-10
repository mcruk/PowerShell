$InDir = Read-Host "Enter the folder path containing the PDF docs or leave blank to use Temp folder"

if($InDir -eq ""){
	$InDir = ".\Temp"
}

& ".\PDF Merge Compress Split\Main.ps1" -cli $true -inputDirectory $InDir -recurse $true -mode compress -translate $false -outName maa

Start-Sleep -s 30