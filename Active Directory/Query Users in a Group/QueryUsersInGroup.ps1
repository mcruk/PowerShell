$GroupName = Read-Host "Enter the Group Name"
Get-ADGroupMember -Identity $GroupName | Select-Object name, objectClass,distinguishedName | export-csv ".\UsersInGroup.csv"