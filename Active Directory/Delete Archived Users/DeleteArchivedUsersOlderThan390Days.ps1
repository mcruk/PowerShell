# Import the Active Directory module
Import-Module ActiveDirectory

#number of days inactive
$daysInactive = 390

# Set the OU path
$ouPath = "OU=xxxxxxx,DC=xxxx,DC=xxxxx,DC=xxxx,DC=uk"

$comparisonDate = (Get-Date).AddDays(-$daysInactive)

$users = Get-ADUser -Filter {LastLogonDate -lt $comparisonDate -and Enabled -eq $true} -SearchBase $ouPath -Property LastLogonDate,ProfilePath

$userProfilePaths = @()

foreach ($user in $users) {

    $userProfilePaths += [PSCustomObject]@{
        UserName = $user.SamAccountName
        ProfilePath = $user.ProfilePath
    }

    Remove-ADUser -Identity $user -Confirm:$false
}

$userProfilePaths | Export-Csv -Path ".\UserProfiles.csv" -NoTypeInformation

Write-Output "User accounts deleted"

Start-Sleep -s 30