#Run script as different use as it requires more permissions than a reqular admin account



if (!(Get-PSSnapIn Microsoft.Exchange.Management.PowerShell.RecipientManagement -Registered -ErrorAction SilentlyContinue)) {
	throw "Please install the Exchange 2019 CU12 and above Management Tools-Only install. See: https://docs.microsoft.com/en-us/Exchange/manage-hybrid-exchange-recipients-with-management-tools"
	break
}



# Load Recipient Management PowerShell Tools
Add-PSSnapIn Microsoft.Exchange.Management.PowerShell.RecipientManagement


$User = Read-Host "Please enter the user name e.g. B.Simpson"

Enable-RemoteMailbox $User -RemoteRoutingAddress "$($User)@XXXXXXXXXX.mail.onmicrosoft.com"

Start-Sleep -Seconds 5

write-host "Done, you can close the window"

Start-Sleep -Seconds 1