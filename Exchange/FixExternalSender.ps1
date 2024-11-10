

$Creds = Get-Credential
 
Write-Host "This script needs exchange managment tools installed" 
start-sleep -s 10
  
Write-Output "Importing Active Directory Module"
Import-Module ActiveDirectory
Write-Host "Done..."
Write-Host
Write-Host
  
  


$UsersLoginName = Read-Host "Enter the users login name e.g b.smith"
$UserFullName = Read-Host "Enter the users full name e.g Bob Smith"


$SetUser = Read-Host "Ready to go? (y/n)"
Write-Host
  
Enable-RemoteMailbox $UserFullName -RemoteRoutingAddress $UsersLoginName"@xxxxxxxxxxxxxxxxx.mail.onmicrosoft.com"
  
  
cls

Write-Host "You win. User should be able to recieve external mail, you may have to wait 30 min for changes.  Wait to exit"

Sleep 5

Get-PSSession | Remove-PSSession
Exit