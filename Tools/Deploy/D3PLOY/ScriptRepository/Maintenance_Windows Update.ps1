if ($scope -eq '') {$params = @{'computername' = $computername}
}
else {$params = @{'credential' = $creds}
}


[string]$computernameArrayFix = $computernameArray

$AllComputers = $computernameArrayFix -replace(" ",",")

$Computers = $AllComputers.Split(',') 




$SB = {
	
	If ($null -eq (Get-Module -Name PSWindowsUpdate -ListAvailable) ) {
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
		Install-Module PSWindowsUpdate -Force
		Import-Module PSWindowsUpdate
	}
	
	Clear-WUJob
	Unregister-ScheduledTask -TaskName "PSWindowsUpdate2" -Confirm:$false
	
	quser | Select-Object -Skip 1 | ForEach-Object {
        $id = ($_ -split ' +')[-5]
        logoff $id
    } 

}

$SB2 = {
	
	$taskName = "PSWindowsUpdate"
	$taskPath = "\" 

	$task = Get-ScheduledTask -TaskName $taskName -TaskPath $taskPath

	$taskSettings = New-ScheduledTaskSettingsSet

	$taskSettings.StartWhenAvailable = $true
	$taskSettings.DisallowStartIfOnBatteries = $false
	$taskSettings.StopIfGoingOnBatteries = $false

	Register-ScheduledTask -TaskName "$($taskName)2" -TaskPath $taskPath -Action $task.Actions -Trigger $task.Triggers -Settings $taskSettings -Principal $task.Principal
	
	Unregister-ScheduledTask -TaskName "PSWindowsUpdate" -Confirm:$false
	
	Start-ScheduledTask -TaskName "$($taskName)2"
}

$SB3 = {
	
	Write-Host "Doing Stuff"

}


$global:Jobs = foreach($comp in $Computers) {
	
		Invoke-Command -credential $creds -ComputerName $comp -ScriptBlock $SB
		
		Invoke-WUJob -ComputerName $comp -credential $creds -Script {ipmo PSWindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot} -Confirm:$false -RunNow -ErrorAction Ignore
		
		Invoke-Command -credential $creds -ComputerName $comp -ScriptBlock $SB2
		
		Invoke-Command -credential $creds -ComputerName $comp -ScriptBlock $SB3 -AsJob -JobName "$($comp)ST" -ErrorAction Ignore
		
}	








