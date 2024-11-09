$taskToKill = "G2Client"

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
					
					Stop-Process -Name $taskToKill -Force
						
				} -Credential $credentials
            }
            catch {
 
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