$DomainAdminCredentials = Get-Credential -Message "Enter Domain Admin Credentials to rename computers"
$domain = "ACDC"
$computers = Import-CSV ".\ComputerList.csv"

$renamedcomputers = [System.Collections.Concurrent.ConcurrentBag[string]]::new()
$unavailablecomputers = [System.Collections.Concurrent.ConcurrentBag[string]]::new()
$ErrorList = [System.Collections.Concurrent.ConcurrentBag[string]]::new()


function Test-RemoteComputer {
	
    param (
        [string]$computerName
    )

    try {

        $pingResult = Test-Connection -ComputerName $computerName -Count 1 -Quiet
        if (-not $pingResult) {
            Write-Output "$computerName is not online."
            return $false
        }

        $psTestResult = Invoke-Command -ComputerName $computerName -Credential $DomainAdminCredentials -ScriptBlock { $PSVersionTable.PSVersion } -ErrorAction Stop
        if ($psTestResult) {
            Write-Output "$($computerName) is up and accepting commands"
            return $true
        }
    } catch {
        Write-Output "$($computerName) is up but not accepting commands. Waiting 60 seconds to try again."
        return $false
    }
}


$computers | ForEach-Object -Parallel {
    param (
        $computer,
        $DomainAdminCredentials,
        $renamedcomputers,
        $unavailablecomputers,
        $ErrorList
    )

    $PingTest = Test-Connection -ComputerName $computer.CurrentName -Count 1 -Quiet

    if ($PingTest) {
		
        try {
			
            Write-Host "Renaming $($computer.CurrentName) to $($computer.NewName)"
			
			Invoke-Command -ComputerName $computer.CurrentName -Credential $DomainAdminCredentials -ScriptBlock {
				
				Rename-Computer -NewName $computer.NewName -DomainCredential $DomainAdminCredentials -Confirm:$false -Force	
				Add-Computer -NewName $computer.NewName -DomainName $domain -Credential $DomainAdminCredentials -Force -Restart
				
			}

			Write-Host "Restarting $($computer.CurrentName) Please Wait"
			$renamedcomputers.Add($computer.CurrentName)
			
			Start-Sleep -S 120
			
			while ($true) {
				
				$isAvailable = Test-RemoteComputer -computerName $computer.NewName
				
				if ($isAvailable) {
					break
				} else {
					Start-Sleep -S 60
				}
				
			}
			
			Write-Host "Rejoining $($computer.NewName) to domain.  Make sure you have a ethernet cable plugged in"
            Invoke-Command -ComputerName $computer.NewName -Credential $DomainAdminCredentials -ScriptBlock {

				Add-Computer -DomainName $domain -Credential $DomainAdminCredentials -Force -Restart
				
            }
			
			while ($true) {
				
				$isAvailable = Test-RemoteComputer -computerName $computer.NewName
				
				if ($isAvailable) {
					break
				} else {
					Start-Sleep -S 60
				}
				
			}
			
			
        } catch {
			
            Write-Warning "Failed to rename computer $($computer.CurrentName)"
			$ErrorList.Add($computer.CurrentName)
			
        }
		
    } else {
        
		Write-Warning "Failed to connect to computer $($computer.CurrentName)"
        $unavailablecomputers.Add($computer.CurrentName)
		
    }
	
} -ArgumentList $_, $DomainAdminCredentials, $renamedcomputers, $unavailablecomputers, $ErrorList



$renamedcomputers | Out-File ".\renamedcomputers.txt"
$unavailablecomputers | Out-File ".\unavailablecomputers.txt"
$ErrorList | Out-File ".\renamedcomputererrors.txt"