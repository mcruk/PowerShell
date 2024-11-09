# Run basic network connectivity tests on IP interfaces.

$passColor = "Green"
$failColor = "Red"
$warningColor = "Yellow"

function TestAddress([string]$label, [string]$address) {
    $formatString = "{0,-17}{1,-27}"
    $text = "$formatString" -f $label, $address
    Write-Host -Object $text -NoNewline
    
    $result = Test-Connection -ComputerName $address `
              -Quiet -BufferSize 16 -Count 1
    $status = If ($result) { "Pass" } Else { "FAIL!" }
    $color = If ($result) { $passColor } Else { $failColor }
    Write-Host $status -ForegroundColor $color
}

Write "`nRunning basic network connectivity tests ...`n"
[array]$nics = Get-WmiObject Win32_NetworkAdapterConfiguration `
               -Filter "IPEnabled = $true"
If ($nics.Length -lt 1) { 
    Write-Host "Warning: No IP-enabled NICs found!"     
               -ForegroundColor $warningColor
}
Else {
    ForEach ($nic In ($nics)) {
        $serviceName = $nic.ServiceName
        Write "`n${env:computername} interface details for ${serviceName}:`n"
        Write $nic
        Write "Connectivity tests:`n"

        $formatString = "{0,-17}{1,-27}{2,-15}"
        $formatString -f "Host", "Address", "Status"
        $formatString -f "====", "=======", "======"

        TestAddress "Localhost" "127.0.0.1"
        
        [array]$addresses = $nic.IPAddress
        If ($addresses.Length -lt 1) { 
            Write-Host "Warning: No IP addresses found for ${serviceName}!" `
                       -ForegroundColor $warningColor
        }
        Else {
            ForEach ($address In $addresses) {    
                TestAddress "Interface" $address
            }
        }
        
        If ($nic.DefaultIPGateway.Length -lt 1) { 
            Write-Host "Warning: No default gateway found for ${serviceName}!" `
                       -ForegroundColor $warningColor
        }
        Else {
            TestAddress "Gateway" $nic.DefaultIPGateway
        }

        [array]$addresses = $nic.DNSServerSearchOrder
        If ($addresses.Length -lt 1) { 
            Write-Host "Warning: No DNS nameservers found for ${serviceName}!" `
                       -ForegroundColor $warningColor
        }
        Else {
            ForEach ($address In $addresses) {    
                TestAddress "Nameserver" $address
            }
        }
    }
}