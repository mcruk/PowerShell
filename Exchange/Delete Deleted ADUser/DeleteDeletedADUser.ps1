# Install the MSOnline module if this is first use
Install-Module MSOnline
# Add the MSOnline module to the PowerShell session
Import-Module MSOnline
# Get credentials of Azure admin
$Credentials = Get-Credential
# Connect to Azure AD
Connect-MsolService -Credential $Credentials

Get-MsolUser -All -ReturnDeletedUsers | Sort-Object DisplayName


$title    = 'Delete Deleted Users'
$question = 'Are you sure you want to proceed? There is no undoing this.'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
	$title2    = 'Delete All Deleted Users'
	$question2 = 'Type Yes to delete all deleted Users `n Type No to delete a single user'
	$choices2  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title2, $question2, $choices2, 1)
	if ($decision -eq 0) {
		Write-Host 'Deleting all deleted users'
		Start-Sleep -Seconds 5
		Get-MsolUser -All -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force
		Write-Host 'All deleted users have been removed'
		Start-Sleep -Seconds 5
		Exit
	} else {
		$EmailAddress = Read-Host -Prompt 'Enter the email address of the account to delete'
		Remove-MsolUser -UserPrincipalName $EmailAddress -RemoveFromRecycleBin
		Write-Host $EmailAddress 'has been removed'
		Start-Sleep -Seconds 5
		Exit
	}	
	
} else {
    Write-Host 'cancelled'
	Start-Sleep -Seconds 5
	Exit
}