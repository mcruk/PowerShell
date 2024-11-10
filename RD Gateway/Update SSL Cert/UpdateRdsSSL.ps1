$PfxFileName = Read-Host "Enter The Name And File Extension Of The PFX Cert.  Cert Must Be In Script Folder"
$PfxPass = Read-Host "Enter The PFX Cert Password"

$pfxFilePath = ".\$($PfxFileName)"

$pfxPassword = ConvertTo-SecureString -String $PfxPass -AsPlainText -Force

$certFriendlyName = "star.xxxxxxxx.uk"

$pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($pfxFilePath, $pfxPassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet)

$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("My", "LocalMachine")
$store.Open("ReadWrite")
$store.Add($pfx)
$store.Close()


$cert = Get-ChildItem -Path cert:\LocalMachine\My | Where-Object { $_.FriendlyName -eq $certFriendlyName }
$thumbprint = $cert.Thumbprint

Set-RDCertificate -Role RDPublishing -ImportPath $pfxFilePath -Password $pfxPassword

Set-RDCertificate -Role RDRedirector -ImportPath $pfxFilePath -Password $pfxPassword

Set-RDCertificate -Role RDWebAccess -ImportPath $pfxFilePath -Password $pfxPassword

Set-RDCertificate -Role RDGateway -ImportPath $pfxFilePath -Password $pfxPassword


#Comment and uncomment below, password field may not work.
Import-RDWebClientBrokerCert $pfxFilePath -Password $pfxPassword
#Import-RDWebClientBrokerCert $pfxFilePath -PromptForPassword



Import-Module WebAdministration
$binding = Get-WebBinding -Name "Default Web Site" -Protocol "https"
$binding.AddSslCertificate($thumbprint, "My")

Write-Output "SSL Certificate has been updated for RD and IIS."

Get-RDCertificate

Start-Sleep -S 999
