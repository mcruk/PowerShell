Write-Host "Installation requires a reboot"

start-sleep -s 10

$FILE= """\\UNCPATH\HEIF Packages.ps1"""

Start-process powershell.exe -Verb runAs -ArgumentList '-executionpolicy bypass -noexit', '-file',$FILE -WorkingDirectory c:\windows\system32

Exit

