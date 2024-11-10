# Import the AD Module
Import-Module ActiveDirectory

$usersToLookFor = @(
    "UserToIgnore1",
	"UserToIgnore2",  
	"UserToIgnore3")

# List all accounts which are already disabled on your AD
Search-ADAccount -UsersOnly -AccountDisabled -Searchbase "OU=xxxxxx,DC=xxxxx,DC=xxxxx,DC=xxxx,DC=uk"  |  
  Where-Object {($_.DistinguishedName -notlike "*OU=Archive*") -and ($_.SamAccountName -notin $usersToLookFor)}  |
  Format-Table Name,ObjectClass -A
  
#confirm list is correct
$confirmation = Read-Host "Are you Sure You Want To Proceed?  is this list correct y/n:"
if ($confirmation -eq 'n') {
    exit
}

# Move all disabled AD users from others OU to the disabled users OU
Search-ADAccount -UsersOnly -AccountDisabled -Searchbase "OU=xxxxxx,DC=xxxxx,DC=xxxxx,DC=xxxxx,DC=uk" |
  Where-Object {($_.DistinguishedName -notlike "*OU=Archive*") -and ($_.SamAccountName -notin $usersToLookFor)}  |
  Move-ADObject -TargetPath "OU=ArchivedUsers,DC=xxxxx,DC=xxxxx,DC=xxxxx,DC=uk"


#disable all users in that disabled users OU either they are already disabled or not
Get-ADUser -Filter {Enabled -eq $True} -SearchBase "OU=ArchivedUsers,DCxxxx,DC=xxxxx,DC=xxxx,DC=uk" | Disable-ADAccount


Write-Host "All Done"

Start-Sleep -s 30



