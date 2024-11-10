Import-Module ActiveDirectory

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






foreach($UserNameInput in $UserNameInputArray){

	write-host $UserNameInput

	$UserName = "$($UserNameInput)@YourDomain.uk"

	$UserExists = (Get-ADUser -Filter {UserPrincipalName -eq $UserName} -SearchBase "OU=xxxxx,DC=xxxxx,DC=xxxxxx,DC=xxxxx,DC=uk" -SearchScope SubTree).SAMAccountName

	if(!$UserExists){
		write-host "$($UserName) User not found or in wrong OU"
		continue;
	}


	$GetUserGroups = (Get-ADPrincipalGroupMembership -Identity $UserExists | Get-ADGroup -Properties Description).Name

    Connect-ODS -TenantId "XXX-XXXX-XXXX-XXXX-XXXXX" -ClientId "XXX-XXXX-XXXX-XXXX-XXXXX" -ClientSecret (ConvertTo-SecureString -String "XXX-XXXX-XXXX-XXXX-XXXXX" -AsPlainText -Force)

	foreach ($UserGroup in $GetUserGroups){

		$TeamGroup = Switch ($UserGroup) {
			"TestTeamsMember" {"https://YourDomain.sharepoint.com/sites/Test";break}
			"Test2TeamsMember" {"https://YourDomain.sharepoint.com/sites/Test2";break}
			default { "EMPTY" }
		}

		if($TeamGroup -eq "EMPTY"){Continue}

		$DirectoryLibrary = Switch ($UserGroup) {
			"TestTeamsMember" {"Test";break}
			"Test2TeamsMember" {"Test2";break}
		}






		if(($UserGroup -eq "Test3TeamsMember") -or ($UserGroup -eq "Test4") ){

			try{
				New-OneDriveShortcut -Uri "$($TeamGroup)" -DocumentLibrary "Documents" -FolderPath "$($DirectoryLibrary)" -UserPrincipalName "$($UserName)" -ErrorAction silentlycontinue
			}catch{
				write-host "$($DirectoryLibrary) Folder/Shortcut Probably Exists on CLient" -ForegroundColor Red
			}



			
		
		}else{


			try{
				New-OneDriveShortcut -Uri "$($TeamGroup)" -DocumentLibrary "Documents" -FolderPath "$($DirectoryLibrary) Shared" -UserPrincipalName "$($UserName)" -ErrorAction silentlycontinue
			}catch{
				write-host "$($DirectoryLibrary) Folder/Shortcut Probably Exists on CLient" -ForegroundColor Red
			}



			try{
				New-OneDriveShortcut -Uri "$($TeamGroup)" -DocumentLibrary "Documents" -FolderPath "$($DirectoryLibrary) Media" -UserPrincipalName "$($UserName)" -ErrorAction silentlycontinue
			}catch{
				write-host "$($DirectoryLibrary) Folder/Shortcut Probably Exists on CLient" -ForegroundColor Red
			}
		
		}

		

	}
	
#end user name array foreach	
}	


Disconnect-ODS

Write-host "Operation Completed, you can close this window"
Start-Sleep -Seconds 120