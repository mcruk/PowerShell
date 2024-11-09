Import-Module ActiveDirectory

$OU = "OU=Test,DC=Test,DC=Test,DC=Test,DC=Test"

$computers = Get-ADComputer -Filter * -SearchBase $OU -Property Name

$outputFile = ".\Get Screen Info\DisplayInfo.csv"

$results = @()

foreach ($computer in $computers) {
    $computerName = $computer.Name

    try {

        $displays = Get-WmiObject -ComputerName $computerName -Class Win32_DisplayConfiguration

        foreach ($display in $displays) {

            $displayInfo = [PSCustomObject]@{
                ComputerName = $computerName
                DeviceName   = $display.DeviceName
                ScreenWidth  = $display.PelsWidth
                ScreenHeight = $display.PelsHeight
                BitsPerPel   = $display.BitsPerPel
                DisplayNumber = $display.SettingID 
            }
            
            $results += $displayInfo
        }
    }
    catch {

        Write-Host "Failed to query display info for $computerName"
        $results += [PSCustomObject]@{
            ComputerName = $computerName
            DeviceName   = "N/A"
            ScreenWidth  = "N/A"
            ScreenHeight = "N/A"
            BitsPerPel   = "N/A"
            DisplayNumber = "N/A"
        }
    }
}


$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Done you may exit"

Start-Sleep 999