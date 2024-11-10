write-host "Make Sure You Open This Script And Change The File Path"

Start-Sleep -s 10

Import-RDWebClientBrokerCert ".\xxxxxxxx.crt"


Get-RDCertificate


Start-Sleep -s 30