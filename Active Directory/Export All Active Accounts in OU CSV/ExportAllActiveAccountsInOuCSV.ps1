# Import the AD Module
Import-Module ActiveDirectory

$usersToLookFor = @(
    "AccountToIgnore1",
	"AccountToIgnore2",  
	"AccountToIgnore3")

# List all active accounts 
Get-ADUser -Filter * -Properties mail,department,title -Searchbase "OU=xxxxx,DC=xxxx,DC=xxxx,DC=xxxx,DC=uk" | 
  Where { $_.Enabled -eq $True} |
  Where-Object {$_.SamAccountName -notin $usersToLookFor} | 
  Select-Object Name,UserPrincipalName,SID,ObjectGUID,Department,Title |
  Export-Csv -Path ".\All Users.csv"


