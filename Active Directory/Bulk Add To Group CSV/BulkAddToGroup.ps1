write-host "Be sure the WhatIf is inplace if this is the first run"
write-host "You Have Been Warned"

Start-Sleep -s 10

# Import AD Module
Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv ".\Users.csv"

# Specify target group name
$Group = Read-Host "Enter The Group Name"

foreach ($User in $Users) {
    # Retrieve UPN
    $UPN = $User.UserPrincipalName

    # Retrieve UPN related SamAccountName
    $ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName

    # User from CSV not in AD
    if ($ADUser -eq $null) {
        Write-Host "$UPN does not exist in AD" -ForegroundColor Red
    }
    else {
        # Retrieve AD user group membership
        $ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name

        # User already member of group
        if ($ExistingGroups.Name -eq $Group) {
            Write-Host "$UPN already exists in $Group" -ForeGroundColor Yellow
        }
        else {
            # Add user to group
            Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName -WhatIf  #WHAIF GOES HERE
            Write-Host "Added $UPN to $Group" -ForeGroundColor Green
        }
    }
}


write-host "Remove WhatIf statement if you are sure this will work and fuck things up"
write-host "Be sure to replace the WhatIf when done"
write-host "Be sure to replace the WhatIf when done"
write-host "Be sure to replace the WhatIf when done"
write-host "Be sure to replace the WhatIf when done"

Start-Sleep -s 30