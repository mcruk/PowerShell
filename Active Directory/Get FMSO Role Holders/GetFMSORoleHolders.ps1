# Import the Active Directory module
Import-Module ActiveDirectory

$domain = Get-ADDomain

$forest = Get-ADForest


Write-Host "FSMO Role Holders in the Domain:"
Write-Host "--------------------------------"
Write-Host "PDC Emulator: $($domain.PDCEmulator)"
Write-Host "RID Master: $($domain.RIDMaster)"
Write-Host "Infrastructure Master: $($domain.InfrastructureMaster)"
Write-Host "Domain Naming Master: $($forest.DomainNamingMaster)"
Write-Host "Schema Master: $($forest.SchemaMaster)"


Start-Sleep -s 999