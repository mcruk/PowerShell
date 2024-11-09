#Open directory with list of computers .txt device per line
function Open-FilePicker {
    param (
        [string]$InitialDirectory = "C:\"
    )

    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.Filter = "Text Files (*.txt)|*.txt"
    $OpenFileDialog.ShowDialog() | Out-Null
    return $OpenFileDialog.FileName
}

$filePath = Open-FilePicker

if (![string]::IsNullOrEmpty($filePath)) {

    $computers = Get-Content -Path $filePath

    $credentials = Get-Credential

    foreach ($computer in $computers) {

        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
            Write-Host "$computer is online. Executing remote command..." -ForegroundColor Green


            try {
                Invoke-Command -ComputerName $computer -ScriptBlock {
					
					If ($null -eq (Get-Module -Name PSWindowsUpdate -ListAvailable) ) {
						Install-PackageProvider -Name NuGet -Force
						Install-Module PSWindowsUpdate -Force
						Import-Module PSWindowsUpdate
					}
					
					Clear-WUJob
					Unregister-ScheduledTask -TaskName "PSWindowsUpdate2" -Confirm:$false
					
					quser | Select-Object -Skip 1 | ForEach-Object {
						$id = ($_ -split ' +')[-5]
						logoff $id
					} 
					
				} -Credential $credentials
            }
            catch {
 
            }
			

				
            Invoke-WUJob -ComputerName $computer -credential $creds -Script {ipmo PSWindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot} -Confirm:$false -RunNow -ErrorAction Ignore
				
			
			$powerStatus = (Get-WmiObject -Class Win32_Battery).BatteryStatus

			if ($powerStatus -eq 1) {
				
				try {
					Invoke-Command -ComputerName $computer -ScriptBlock {
						
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
						
					} -Credential $credentials
				}
				catch {

				}
			
			}
	
			
        }
        else {
            Write-Host "$computer is offline" -ForegroundColor Red
        }
    }
	
} else {
    Write-Host "No file selected" -ForegroundColor Red
}

Start-Sleep -s 10