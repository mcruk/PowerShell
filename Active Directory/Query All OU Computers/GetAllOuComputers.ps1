Get-ADComputer -Filter * -SearchBase "OU=xxxxxx,DC=xxxxx,DC=xxxx,DC=xxxx,DC=uk" | 
  Select-Object Name |
  Export-Csv -Path ".\Staff Computers.csv"
  
  
Write-Host "All Done"

Start-Sleep -s 30