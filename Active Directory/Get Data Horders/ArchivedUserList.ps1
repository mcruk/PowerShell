Import-Module ActiveDirectory

$OU = "OU=XXXX,DCXXXX,DC=XXXX,DC=XXXX,DC=uk"

$outputCSV = ".\ArchivedUsersList.csv"


$users = Get-ADUser -Filter * -SearchBase $OU -Property DisplayName,SamAccountName,UserPrincipalName,HomeDirectory


$users | Select-Object `
    @{Name="Full Name";Expression={$_.DisplayName}}, `
    @{Name="SAM Account Name";Expression={$_.SamAccountName}}, `
    @{Name="UPN Account Name";Expression={$_.UserPrincipalName}}, `
    @{Name="Home Folder Path";Expression={$_.HomeDirectory}} `
    | Export-Csv -Path $outputCSV -NoTypeInformation


Write-Host "Saved to $outputCSV"

Start-Sleep -s 9999