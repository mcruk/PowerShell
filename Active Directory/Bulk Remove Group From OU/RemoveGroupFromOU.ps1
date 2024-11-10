Import-Module ActiveDirectory

$GroupToAddUsers = Read-Host "Enter Group Name To Remove"

$OU = 'OU=xxxxx,DC=xxxxx,DC=xxxxx,DC=xxxx,DC=uk' 

$users = Get-ADUser -Filter * -SearchBase $OU -Property MemberOf

foreach ($user in $users) {

    Remove-ADGroupMember -Identity $GroupToAddUsers -Members $user -Confirm:$false

    Write-Output "Group has been removed for: $($user.SamAccountName)"
}

Write-Output "All Done.  You Can Close This Script"

Start-Sleep -s 30