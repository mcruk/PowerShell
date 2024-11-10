# Import the AD Module
Import-Module ActiveDirectory

# List all accounts which are already disabled on your AD
Search-ADAccount -UsersOnly -AccountDisabled -Searchbase "DC=xxxx,DC=xxxxx,DC=xxxxx,DC=uk" |
  Format-Table Name,UserPrincipalName,SID,ObjectGUID

start-sleep -s 999
  



