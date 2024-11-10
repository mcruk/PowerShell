Write-Host "This Script Needs to be Run on Entra Connect Server"
Write-Host ""
Write-Host ""
Write-Host ""


write-host "https://mysignins.microsoft.com/security-info"
start microsoft-edge:https://mysignins.microsoft.com/security-info


Write-Host "Press enter again and again unill next prompt appears"
Read-Host "Press ENTER to continue..."

Clear-Host


Write-Host "Sign in with your personal account if admin or use 365admin"

#cd "$env:programfiles\Microsoft Azure Active Directory Connect"
#Import-Module .\AzureADSSO.psd1
Import-Module "C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1"
 
New-AzureADSSOAuthenticationContext
Get-AzureADSSOStatus | ConvertFrom-Json


Write-Host "Press enter if there are no errors, otherwise close the script."
Write-Host "Press enter again and again unill next prompt appears"
	
Read-Host "Press ENTER to continue..."

Clear-Host
Write-Host "at the prompt enter you domain admin detail mileend\BLABLA"
start-sleep -s 7
Clear-Host

$creds = Get-Credential
Update-AzureADSSOForest -OnPremCredentials $creds



Clear-Host

Write-Host "Check for errors"

Get-ADComputer AZUREADSSOACC -Properties * | FL Name,PasswordLastSet

Write-Host "You may exit"

start-sleep -s 60