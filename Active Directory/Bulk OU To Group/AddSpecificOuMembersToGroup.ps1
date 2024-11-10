Import-Module ActiveDirectory

$GroupToAddUsers = Read-Host "Enter Group Name"

$users = Get-ADUser -SearchBase 'OU=xxx,DC=xxxxx,DC=xxxx,DC=uk' -Filter {(enabled -eq $true)}
foreach($user in $users){
    Add-ADGroupMember $GroupToAddUsers -Members $user
}


write-host "All Done"

Start-Sleep -s 30