# Import the Active Directory module
Import-Module ActiveDirectory

#number of days of inactive
$daysInactive = 390

$comparisonDate = (Get-Date).AddDays(-$daysInactive)

$unusedComputers = Get-ADComputer -Filter {LastLogonTimestamp -lt $comparisonDate} -Property LastLogonTimestamp, Name, OperatingSystem, DistinguishedName

$unusedComputerList = @()

foreach ($computer in $unusedComputers) {
    $unusedComputerList += [PSCustomObject]@{
        ComputerName = $computer.Name
        LastLogonTimestamp = [DateTime]::FromFileTime($computer.LastLogonTimestamp)
        OperatingSystem = $computer.OperatingSystem
        DistinguishedName = $computer.DistinguishedName
    }
}

$unusedComputerList | Export-Csv -Path ".\UnusedComputers.csv" -NoTypeInformation

Write-Output "All Done"

Start-Sleep -s 30