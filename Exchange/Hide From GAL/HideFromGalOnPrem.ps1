$UserEmail = Read-Host "Please enter the users email address e.g. B.Simpson@YOURDOMAIN.uk"


Set-Mailbox -Identity $UserEmail -HiddenFromAddressListsEnabled $true

Write-Output "User $UserEmail has been hidden from the Global Address List."

Start-sleep -s 30