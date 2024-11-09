if ($scope -eq '') {$params = @{'computername' = $computername}
}
else {$params = @{'credential' = $creds}
}


[string]$computernameArrayFix = $computernameArray

$AllComputers = $computernameArrayFix -replace(" ",",")

$Computers = $AllComputers.Split(',') 




$SB = {
	if (!(Test-Path "C:\Program Files\DelProf2\DelProf2.exe" -PathType Leaf)) {
		
		new-psdrive  -name "AppDrive" -root "\\test\test" -PSProvider "FileSystem" -Credential $Using:Creds | out-null
		start-sleep -s 5
		
		Remove-Item "C:\tempInstall" -Force -Recurse

		New-Item -Path "C:\tempInstall" -type directory -Force
		
		Copy-Item "AppDrive:\delprof2\Delprof2\DelProf2.exe" "C:\Program Files\DelProf2\DelProf2.exe" -Force
		
		start-sleep -s 10
		
		Remove-Item -Path "C:\tempInstall" -Recurse -Force
		

		Get-PSDrive AppDrive | Remove-PSDrive
		
	}
	
}



$global:Jobs = foreach($comp in $Computers) {
		
		Invoke-Command -credential $creds -ComputerName $comp -ScriptBlock $SB -AsJob -JobName "$($comp)" -ErrorAction Stop

}	


