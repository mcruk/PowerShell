# Import the AD Module
Import-Module ActiveDirectory

$OUpath = 'OU=xxxxxx,DC=xxxx,DC=xxxx,DC=xxxx,DC=uk'
$ExportPath = '.\Dead Profiles.csv'
 

$AliveUsers = Get-ADUser -Filter {(HomeDirectory -like "\\YOUR-SERVER\PATH\PATH\*")} -SearchBase $OUpath -Properties HomeDirectory| Where-Object { ($_.DistinguishedName -notlike "*OU=BOGLINS") } | Select-object Name,UserPrincipalName,HomeDirectory 

$DeadUsers = get-childitem '\\YOUR-SERVER\PATH\PATH\' | % { $_.FullName }


$c = Compare-Object -ReferenceObject $AliveUsers.HomeDirectory -DifferenceObject $DeadUsers -PassThru

$c


Start-Sleep -s 120