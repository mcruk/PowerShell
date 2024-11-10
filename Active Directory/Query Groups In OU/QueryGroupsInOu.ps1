# Import the AD Module
Import-Module ActiveDirectory

$OUpath = 'OU=xxxx,DC=xxxx,DC=xxxxx,DC=xxxx,DC=uk' 

$ExportPath = '.\Groups.csv' 

Get-ADGroup -Filter * -properties * -SearchBase $OUpath | Select-object Name,Description,info | Export-Csv -NoType $ExportPath


Write-Host "All Done"

Start-Sleep -s 30