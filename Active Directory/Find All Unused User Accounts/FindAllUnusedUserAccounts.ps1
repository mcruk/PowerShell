# Import the Active Directory module
Import-Module ActiveDirectory

#number of days of inactive
$daysInactive = 390


$comparisonDate = (Get-Date).AddDays(-$daysInactive)


$unusedUsers = Get-ADUser -Filter {LastLogonDate -lt $comparisonDate -and Enabled -eq $true} -Property LastLogonDate, SamAccountName, Name, EmailAddress


$unusedUserList = @()

foreach ($user in $unusedUsers) {
    $unusedUserList += [PSCustomObject]@{
        UserName = $user.SamAccountName
        Name = $user.Name
        LastLogonDate = $user.LastLogonDate
        EmailAddress = $user.EmailAddress
    }
}


$unusedUserList | Export-Csv -Path ".\UnusedUserAccounts.csv" -NoTypeInformation

Write-Output "All DOne"

Start-Sleep -s 30