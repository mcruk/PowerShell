# Import the AD Module
Import-Module ActiveDirectory

$OUpath = 'OU=xxxxx,DC=xxxx,DC=xxxxx,DC=xxxx,DC=uk' 

$ExportPath = '.\Teachers.csv' 

Get-ADUser -Filter * -properties Department,Title,Telephonenumber -SearchBase $OUpath | Select-object DistinguishedName,Name,GivenName,Surname,Title,Department,Telephonenumber,UserPrincipalName | Export-Csv -NoType $ExportPath


Write-Host "All Done"

Start-Sleep -s 30