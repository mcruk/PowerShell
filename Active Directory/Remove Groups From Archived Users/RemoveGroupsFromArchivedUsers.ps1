Import-Module ActiveDirectory


$OU = 'OU=xxxx,DC=xxxx,DC=xxxx,DC=xxxx,DC=uk' 
$DomainUsersGroup = "Domain Users"

$users = Get-ADUser -Filter * -SearchBase $OU -Property MemberOf

foreach ($user in $users) {
    $groupsToRemove = $user.MemberOf | Where-Object { 
        (Get-ADGroup $_).Name -ne $DomainUsersGroup 
    }

    foreach ($group in $groupsToRemove) {
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    }

    Write-Output "Groups have been removed for: $($user.SamAccountName)"
}

Write-Output "All Done.  You Can Close This Script"

Start-Sleep -s 30