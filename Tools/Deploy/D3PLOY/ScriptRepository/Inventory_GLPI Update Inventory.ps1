if ($scope -eq '') {$params = @{'computername' = $computername}
}
else {$params = @{'credential' = $creds}
}


[string]$computernameArrayFix = $computernameArray

$AllComputers = $computernameArrayFix -replace(" ",",")

$Computers = $AllComputers.Split(',') 




$SB = {

	Start-Process -FilePath "C:\Program Files\GLPI-Agent\glpi-agent" -ArgumentList "--force" -Wait

}



$global:Jobs = foreach($comp in $Computers) {
		
		Invoke-Command -credential $creds -ComputerName $comp -ScriptBlock $SB -AsJob -JobName "$($comp)" -ErrorAction Stop

}	