#elevate to admin
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}


Import-Module activedirectory

# Generate a random Alphanumeric string
Function Get-RandomAlphanumericString {
	
	[CmdletBinding()]
	Param (
        [int] $length = 8
	)

	Begin{
	}

	Process{
        Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $length  | % {[char]$_}) )
	}	
}




$UpdateCoverUser = @('User01','User02','User03','User04','User05','User06','User07','User08','User09','User10')



foreach ($User in $UpdateCoverUser){

    $Username = $User
    $Password = Get-RandomAlphanumericString -length 9 | Tee-Object -variable teeTime


	$Pass = ConvertTo-SecureString $Password -AsPlainText -Force 
	Set-ADAccountPassword -Identity $Username -NewPassword $Pass -Reset


	Set-ADUser -Identity $Username -Description $Password
	
	Write-host  "$($Username) : $($Password)"



}

Write-Host "All Done"

Start-Sleep -s 30