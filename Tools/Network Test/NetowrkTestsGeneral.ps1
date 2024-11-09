write-host "Checking Internet Connection" -ForegroundColor Green

remove-item "C:\connecttest.txt" -ErrorAction SilentlyContinue
remove-item "C:\ncsi.txt" -ErrorAction SilentlyContinue

Invoke-WebRequest -URI http://www.msftconnecttest.com/connecttest.txt -OutFile C:\connecttest.txt -ErrorAction SilentlyContinue

Invoke-WebRequest -URI http://www.msftncsi.com/ncsi.txt -OutFile C:\ncsi.txt -ErrorAction SilentlyContinue

if(Test-Path "C:\connecttest.txt" -PathType Leaf){
	write-host "msftncsi.com is online, you have internet" -ForegroundColor Green
	remove-item "C:\connecttest.txt" -ErrorAction SilentlyContinue
}else{
	write-host "msftncsi.com is offline, you have no internet" -ForegroundColor Red
}


if(Test-Path "C:\ncsi.txt" -PathType Leaf){
	write-host "ncsi.com is online, you have internet" -ForegroundColor Green
	remove-item "C:\ncsi.txt" -ErrorAction SilentlyContinue
}else{
	write-host "ncsi.com is offline, you have no internet" -ForegroundColor Red
}



if (Get-Module -ListAvailable -Name PsNetTools) {
    Write-Host "PsNetTools exists"
} 
else {
    Write-Host "PsNetTools does not exist. Installing........"
	Install-Module -Name PsNetTools -Repository PSGallery
}

write-host "Network Adaptor Status" -ForegroundColor Green
& ".\NetworkStatus.ps1"

write-host "Network Adaptor Status Sanity Check" -ForegroundColor Green
& ".\NetworkStatus2.ps1"

write-host "" 
write-host "WAN Speed Test" -ForegroundColor Green
& ".\speedtest.ps1"

write-host "" 
write-host "" 
write-host "Lan Speed Test" -ForegroundColor Green
$argumentList = "-Path '\savepath' -Size 2000"
& ".\Test-NetworkSpeed.ps1" $argumentList


write-host "Checking Microsoft Services" -ForegroundColor Green
& ".\Test-DeviceRegConnectivity.ps1"


write-host "Web Services" -ForegroundColor Green
Test-PsNetDig -Destination microsoft.com,google.com,bbc.co.uk,www.msftncsi.com,www.msftconnecttest.com | Format-Table

write-host "Web Services Port Test" -ForegroundColor Green
Test-PsNetTping -Destination microsoft.com,google.com,bbc.co.uk,www.msftncsi.com,www.msftconnecttest.com -TcpPort 80, 443 -MaxTimeout 100 | Format-Table

write-host "Web Services Trace" -ForegroundColor Green
Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 -Show
Test-PsNetTracert -Destination 'www.bbc.co.uk' -MaxHops 15 -MaxTimeout 1000 -Show

write-host "Web Services Ping Test" -ForegroundColor Green
Test-PsNetWping -Destination 'https://google.com'
Test-PsNetWping -Destination 'https://bbc.co.uk'
Test-PsNetWping -Destination 'https://www.msftconnecttest.com'
Test-PsNetWping -Destination 'https://www.msftncsi.com'

write-host "Get Routing Table" -ForegroundColor Green
Get-PsNetRoutingTable -IpVersion IPv4 | Format-Table


write-host "All Done" -ForegroundColor Green
write-host "All Done" -ForegroundColor Green
write-host "All Done" -ForegroundColor Green
write-host "All Done" -ForegroundColor Green
write-host "All Done" -ForegroundColor Green
write-host "All Done" -ForegroundColor Green


start-sleep -s 999
