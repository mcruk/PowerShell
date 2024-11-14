$startDate = Get-Date -Year (Get-Date).Year -Month 7 -Day 18
$endDate = Get-Date -Year (Get-Date).Year -Month 9 -Day 14

$currentDate = Get-Date
$usersPath = "C:\Users"
$String1 = ""
$String3 = ""
$drive = Get-PSDrive -Name C
$freeSpacePercentage = ($drive.Free / $drive.Used) * 100
$thresholdPercentage = 7



if ($currentDate -lt $startDate -or $currentDate -gt $endDate) {
    
    if ($freeSpacePercentage -lt $thresholdPercentage) {

		$thresholdDate = (Get-Date).AddDays(-28)
		
		$userFolders = Get-ChildItem -Path $usersPath -Directory

		foreach ($folder in $userFolders) {
			
			if ($folder.LastWriteTime -lt $thresholdDate) {
				
				$string4 = "/id:$($folder.Name) "
				
				$String3 = $String3 + $string4
				
			}
		}
		
		if($String1){
			
			Start-Process "C:\Program Files\DelProf2\DelProf2.exe" -ArgumentList "/u /i /ed:admin* /ed:beef /ed:Administrator /ed:Public /ed:Default $($String3)"
			
		}
		
	}else{
		
		$thresholdDate = (Get-Date).AddDays(-42)
		
		$userFolders = Get-ChildItem -Path $usersPath -Directory

		foreach ($folder in $userFolders) {
			
			if ($folder.LastWriteTime -lt $thresholdDate) {
				
				$string2 = "/id:$($folder.Name) "
				
				$String1 = $String1 + $string2
				
			}
		}
		
		if($String1){
			
			Start-Process "C:\Program Files\DelProf2\DelProf2.exe" -ArgumentList "/u /i /ed:admin* /ed:beef /ed:Administrator /ed:Public /ed:Default $($String1)"
		}
		
	}
    
    
	
} 






