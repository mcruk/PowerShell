Import-Module ActiveDirectory

Write-Host "CLient Secret Expire in X Days" 
Write-Host "Input can be comma seperated for multiple users" 

Start-Sleep -Seconds 5

if (Get-Module -ListAvailable -Name OneDriveShortcuts) {
	
    Write-Host "OneDriveShortcuts Module exists"
	
} else {
	
	Set-PSRepository PSGallery -InstallationPolicy Trusted
    Install-Module MSAL.PS
    Import-Module MSAL.PS
	Copy-Item -Path ".\onedriveshortcuts" -Destination "$($Env:USERPROFILE)\Documents\WindowsPowerShell\Modules" -Recurse
	
}


Import-module -name OneDriveShortcuts -Force


Clear-Host

$answer = read-host "Do Want to Use a CSV File?  Type YES to use CSV file containg list of users or type NO to manualy enter users. CSV must be named USERS"
if ($answer -eq 'YES') { 

	Clear-Host
	$UserNameInputArray = Import-Csv ".\USERS.csv" | select -ExpandProperty Name

} else {

	Clear-Host

	$UserNameInputArray = Read-Host "Please enter the target user name e.g b.bert or s.smith, b.bert"

	$UserNameInputArray = $UserNameInputArray.Trim()

	$UserNameInputArray = $UserNameInputArray.split(",")

} 




$answer2 = read-host "Enter Shortcut to Delete"
if ($answer2) { 
	
	Clear-Host

} else {

	Clear-Host
	write-host "Input can't be empty"
	
	start-sleep -s 10
	exit

} 

write-host "Ignore the red errors"
start-sleep -s 5


foreach($UserNameInput in $UserNameInputArray){


	$UserName = "$($UserNameInput)@YourDomain.uk"

	$UserExists = (Get-ADUser -Filter {UserPrincipalName -eq $UserName} -SearchBase "OU=xxxx,DC=xxxxx,DC=xxxx,DC=xxxx,DC=uk" -SearchScope SubTree).SAMAccountName

	if(!$UserExists){
		write-host "$($UserName) User not found or in wrong OU" -ForegroundColor Red
		continue;
	}

    Connect-ODS -TenantId "XXXX-XXXX-XXXX-XXXX" -ClientId "XXXX-XXXX-XXXX-XXXX" -ClientSecret (ConvertTo-SecureString -String "XXXX-XXXX-XXXX-XXXX" -AsPlainText -Force)
	
	
	try{
		Remove-OneDriveShortcut -ShortcutName "$($answer2)" -UserPrincipalName "$($UserName)" -ErrorAction silentlycontinue
		write-host "$($UserName) removed $($answer2)" -ForegroundColor Green
	}catch{
		write-host "$($UserName) already had $($answer2) deleted or never existed" -ForegroundColor Red
	}
	
	Disconnect-ODS
	
		
}	




Write-host "Operation Completed, you can close this window"
Start-Sleep -Seconds 120