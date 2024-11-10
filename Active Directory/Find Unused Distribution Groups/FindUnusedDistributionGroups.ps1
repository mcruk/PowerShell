# Import the Active Directory module
Import-Module ActiveDirectory

#number of days of inactive
$daysInactive = 390

$comparisonDate = (Get-Date).AddDays(-$daysInactive)

$distributionGroups = Get-ADGroup -Filter {GroupCategory -eq "Distribution"} -Property whenChanged

$unusedGroups = @()

foreach ($group in $distributionGroups) {
    if ($group.whenChanged -lt $comparisonDate) {

        $unusedGroups += [PSCustomObject]@{
            GroupName = $group.Name
            LastModified = $group.whenChanged
			
        }
    }
}

$unusedGroups | Export-Csv -Path ".\UnusedDistributionGroups.csv" -NoTypeInformation

Write-Output "All Done"

Start-Sleep -s 30