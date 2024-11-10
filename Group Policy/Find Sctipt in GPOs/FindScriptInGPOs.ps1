
$ErrorActionPreference = 'SilentlyContinue'
$scriptName = Read-Host "Please enter the file to query e.g Test.ps1"

# Get all the GPOs in the domain
$gpos = Get-GPO -All

$count = 1
# Loop through each GPO and generate a report
foreach ($gpo in $gpos) {

     
    $gpo.DisplayName = $gpo.DisplayName.replace(':','')
    
    $reportPath = "C:\GpoReport\$($gpo.DisplayName)_Report.html"
    New-Item -Force -Path $reportPath | out-null
    Get-GPOReport -Name $gpo.DisplayName -ReportType HTML -Path $reportPath

    # Search the report for your script name
    $matches = Select-String -Path $reportPath -Pattern $scriptName 

    # If there is a match, print the GPO name and the path to the report
    if ($matches){
        Write-Output "The script '$scriptName' is being used in the GPO '$($gpo.DisplayName)'."
        Write-Output "The report for this GPO can be found at '$reportPath'."
        $count++
    }else{

        # Delete the report
        Remove-Item $reportPath
    
    }

}

if($count -le 1){

    write-host "Nothing to see here"

}

start-sleep -s 999