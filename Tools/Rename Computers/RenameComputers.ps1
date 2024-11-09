$DomainAdminCredentials = Get-Credential -Message "Enter Domain Admin Credentials to rename computers"
$domain = "ACDC"

$computers = Import-CSV ".\ComputerList.csv"

$renamedcomputers = @() 
$unavailablecomputers = @()

Foreach ($computer in $computers){
	
	$PingTest = Test-Connection -ComputerName $computer.CurrentName -Count 1 -quiet
	
	If ($PingTest){
		Write-Host "Renaming $($computer.currentname) to $($computer.NewName)"
			
			Invoke-Command -ComputerName $computer.CurrentName -Credential $DomainAdminCredentials -ScriptBlock {
				
				Rename-Computer -NewName $computer.NewName -DomainCredential $DomainAdminCredentials -Confirm:$false -Force	
				Add-Computer -NewName $computer.NewName -DomainName $domain -Credential $DomainAdminCredentials -Force -Restart
				
			}
			
			
			
			$renamedcomputers += $computer.CurrentName
		 
		}

	Else{
			Write-Warning "Failed to connect to computer $($computer.currentname)"
				$unavailablecomputers += $computer.CurrentName

		}
	}
	
	

$renamedcomputers | Out-File ".\renamedcomputers.txt"
$unavailablecomputers | Out-File ".\unavailablecomputers.txt"
$Error | Out-File ".\renamedcomputererrors.txt"