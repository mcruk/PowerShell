#accelerated networking?

$networkDrives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType = 4"

#UNC to logical
foreach ($drive in $networkDrives) {
    if ($drive.ProviderName -eq "\\test\test") {
        # Output the drive letter
        $dl = $drive.DeviceID
    }
}



$ipAddress = Read-Host "Enter the IP address"

Clear-Host



Start-Process "$($dl)\Network Test\Latte\Core\latte.exe" -ArgumentList "-c -a `"$ipAddress`":5100 -i 10000 -csvh -dump `"$($dl)\Network Test\Latte\Output\output`"" -Wait

Copy-Item "C:\Windows\System32\output" "$($dl)\Network Test\Latte\Output\"
Remove-Item "C:\Windows\System32\output" 