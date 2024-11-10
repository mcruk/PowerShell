Import-Module ActiveDirectory

# Import users from CSV
Import-Csv ".\bulkChange.csv" | ForEach-Object {
    
	$samAccountName = $_."samAccountName" 
 
	#The below line if your CSV file includes password for all users
	$newPassword = ConvertTo-SecureString -AsPlainText $_."Password"  -Force

	# Reset user password.
	Set-ADAccountPassword -Identity $samAccountName -NewPassword $newPassword -Reset

	#Change description
	Set-ADuser -Identity $samAccountName –Description $_."Description"

	# Force user to reset password at next logon.
	# Remove this line if not needed for you
	#Set-AdUser -Identity $samAccountName -ChangePasswordAtLogon $true
	Write-Host " AD Password has been reset for: "$samAccountName
	
}

