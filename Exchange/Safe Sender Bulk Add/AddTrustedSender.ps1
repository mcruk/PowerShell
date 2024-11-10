if (Get-Module -ListAvailable -Name ExchangeOnlineManagement) {
    Write-Host "ExchangeOnlineManagement already installed"
} 
else {
    Install-Module -Name ExchangeOnlineManagement
}


Import-Module ExchangeOnlineManagement

write-host ""
write-host ""
write-host ""
write-host ""
write-host ""
write-host ""
write-host ""
write-host "Run this script on server e.g DC1, or change file path in this script"
write-host "UserPrincipalName Must be used for target user e.g b.stevens but not b.stevens@YOURDOMAIN.uk"
write-host "Put the user names in the CSV file before continuing"
write-host "If more than one address in SafeSender col user comma to seperate"
write-host ""
write-host ""
write-host ""

start-sleep -s 10

$AdminName = Read-Host "Please enter your admin account name for Azure"

Connect-ExchangeOnline -UserPrincipalName $AdminName -ShowProgress $true



Import-Csv ".\SafeSenderList.csv" | ForEach-Object {
    Set-MailboxJunkEmailConfiguration $_.UserPrincipalName -TrustedSendersAndDomains @{Add="$($_.SafeSender)"}
}


Disconnect-ExchangeOnline -Confirm:$false