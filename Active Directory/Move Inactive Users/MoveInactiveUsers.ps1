# Import the AD Module
Import-Module ActiveDirectory

# List all accounts which are inactive on your AD
$usersToLookFor = @(
    "IgnoreUser1",
	"IgnoreUser2")
	
Search-ADAccount -AccountInactive -TimeSpan 456.00:00:00 -Searchbase "OU=xxxxxx,DC=xxxxx,DC=xxxxx,DC=xxxx,DC=uk"  | 
  Where-Object {($_.DistinguishedName -notlike "*OU=Archive*") -and ($_.SamAccountName -notin $usersToLookFor)}  |
  Format-Table Name,ObjectClass -A

#confirm list is correct
$confirmation = Read-Host "Are you Sure You Want To Proceed?  is this list correct y/n:"
if ($confirmation -eq 'n') {
    exit
}


# Move all inactive AD users from others OU to the disabled users OU
Search-ADAccount -AccountInactive -TimeSpan 456.00:00:00 -Searchbase "OU=xxxxxx,DC=xxxx,DC=xxxxx,DC=xxxx,DC=uk" | 
  Where-Object {($_.DistinguishedName -notlike "*Archive*") -and ($_.SamAccountName -notin $usersToLookFor)}  | 
  Move-ADObject -TargetPath "OU=ArchivedUsers,DC=xxxx,DC=xxxx,DC=xxx,DC=uk"



#disable all users in that disabled users OU either they are already disabled or not
Get-ADUser -Filter {Enabled -eq $True} -SearchBase "OU=ArchivedUsers,DC=xxxx,DC=xxxxx,DC=xxxxx,DC=uk" | Disable-ADAccount


Write-Host "All Done"

Start-Sleep -s 30