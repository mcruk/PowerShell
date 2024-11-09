$networkDrives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType = 4"

#UNC to logical
foreach ($drive in $networkDrives) {
    if ($drive.ProviderName -eq "\\test\test") {
        # Output the drive letter
        $dl = $drive.DeviceID
    }
}

function Select-Protocol {
    $options = @("TCP", "UDP")
    $selectedIndex = 0

    while ($true) {
        Clear-Host
        Write-Host "Select Protocol (Use Arrow Keys and Enter):" -ForegroundColor Yellow
        for ($i = 0; $i -lt $options.Count; $i++) {
            if ($i -eq $selectedIndex) {
                Write-Host "> $($options[$i])" -ForegroundColor Green
            } else {
                Write-Host "  $($options[$i])"
            }
        }


        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 { # Up arrow
                $selectedIndex = ($selectedIndex - 1) % $options.Count
                if ($selectedIndex -lt 0) { $selectedIndex = $options.Count - 1 }
            }
            40 { # Down arrow
                $selectedIndex = ($selectedIndex + 1) % $options.Count
            }
            13 { # Enter
                return $options[$selectedIndex]
            }
        }
    }
}


Clear-Host
$protocol = Select-Protocol
Write-Host "`nYou selected: $protocol"


Clear-Host
$ipAddress = Read-Host "Enter the IP address"


while (-not [System.Net.IPAddress]::TryParse($ipAddress, [ref]$null)) {
    Write-Host "Invalid IP address. Please try again." -ForegroundColor Red
    $ipAddress = Read-Host "Enter the IP address"
}


Clear-Host
$seconds = Read-Host "Enter the number of seconds"


while (-not [int]::TryParse($seconds, [ref]$null) -or $seconds -lt 0) {
    Write-Host "Invalid number of seconds. Please enter a positive integer." -ForegroundColor Red
    $seconds = Read-Host "Enter the number of seconds of runtime"
}

Clear-Host
Write-Host "`nYou selected:"
Write-Host "Protocol: $protocol"
Write-Host "IP Address: $ipAddress"
Write-Host "Duration: $seconds seconds"
Start-Sleep -s 5
Clear-Host


if($protocol -eq "TCP"){
	
	Start-Process "$($dl)\ntttcp.exe" -ArgumentList "-r -m 2,*,`"$ipAddress`" -l 64k -a 2 -t `"$seconds`" -xml" -Wait

	
}else{
	
	Start-Process "$($dl)\ntttcp.exe" -ArgumentList "-r -m 2,*,`"$ipAddress`" -l 64k -a 2 -u -t `"$seconds`" -xml" -Wait

}

Copy-Item "C:\Windows\System32\xml.txt" "$($dl)\Network Test\NTTCP\Output\"
Remove-Item "C:\Windows\System32\xml.txt" 

$filePath = "$($dl)\Network Test\NTTCP\Output\xml.txt"
$newFilePath = $filePath -replace '.txt','.xml'
Rename-Item -Path $filePath -NewName $newFilePath


Start-Sleep -s 999

