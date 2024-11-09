$credentials = Get-Credential -Message "Enter Domain Admin Credentials"

$computers = Import-Csv -Path ".\ComputerList.csv"

$jobs = @()


foreach ($computer in $computers) {
	
    $computerName = $computer.NewName

    $job = Start-Job -ScriptBlock {
		
        param ($computerName, $credentials)

        Invoke-Command -ComputerName $computerName -Credential $credentials -ScriptBlock {
            Start-Process -FilePath "C:\Program Files\GLPI-Agent\glpi-agent" -ArgumentList "--force" -Wait
        }
    } -ArgumentList $computerName, $credentials

    $jobs += $job
}


$jobs | ForEach-Object {
	
    $_ | Wait-Job
    $result = Receive-Job -Job $_
    Write-Output $result
	
}


$jobs | ForEach-Object {
	
    Remove-Job -Job $_
	
}


Write-Host "Great success, you may exit the script"
Start-Sleep -s 999