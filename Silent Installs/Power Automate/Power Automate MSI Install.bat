powershell.exe "Get-AppxPackage *Microsoft.PowerAutomateDesktop* | Remove-AppxPackage"

"Setup.Microsoft.PowerAutomate.exe" -Silent -Install -ACCEPTEULA 
