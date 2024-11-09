$csvPath = ".\SEN.csv"

$outputDir = ".\output"

$data = Import-Csv -Path $csvPath 

# Define [SEN] fields
$senFields = @(
    '[SEN] Transition package category',
    '[SEN] Sen status (primary)',
    '[SEN] Sen status notes',
    '[SEN] Diagnosis',
    '[SEN] Attendance (primary)',
    '[SEN] Area of need',
    '[SEN] Cognition and learning details',
    '[SEN] Communication and interaction details',
    '[SEN] Physical and sensory details',
    '[SEN] Semh details',
    '[SEN] Areas of strength',
    '[SEN] External agency involvement',
    '[SEN] Psychometric testing data',
    '[SEN] Primary school interventions',
    '[SEN] Suggested stockport school interventions',
    '[SEN] Family',
    '[SEN] Behaviour'
)

#check if any SEN field is not empty
function ContainsSENData {
    param ($row)
    foreach ($field in $senFields) {
        if ($row.$field -ne $null -and $row.$field -ne '') {
            return $true
        }
    }
    return $false
}

function Remove-SpecificStrings {
    param (
        [string]$inputText
    )

    # Strings to remove
    $stringsToRemove = @(
        "Child's Basic Details",
        "KS2 Attainment Data",
        "SEN"
    )

    # Remove the specified strings
    foreach ($str in $stringsToRemove) {
        $inputText = $inputText -replace [regex]::Escape($str), ""
    }

    # Remove anything between and including []
    $inputText = $inputText -replace "\[.*?\]", ""

    # Return the cleaned text
    return $inputText.Trim()
}

function Get-ImageBase64FromUrl([Uri]$url) {
    $b = Invoke-WebRequest $url;

    $type = $b.Headers["Content-Type"];
    $base64 = [convert]::ToBase64String($b.Content);

    return "data:$type;base64,$base64";
}



$htmlTemplate = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <title>Student Report</title>
</head>
<body style='font-size: 14px;'>
    <div class="container mt-5">
        <h2>Student: {0}</h2>
        <table class="table table-bordered">
            <!--<thead>
                <tr>
                    <th>Field</th>
                    <th>Value</th>
                </tr>
            </thead>-->
            <tbody>
                {1}
            </tbody>
        </table>
    </div>
</body>
</html>
"@








# Strings to match
$patternsToMatch = @(
    "[SEN]",
    "[Child's Basic Details]",
    "[KS2 Attainment Data]"
)

# Hash table to track first occurrence of each pattern
$foundPatterns = @{}

#Blocked Fields
$BlockedFieldMatch = @(
    "[Basic Details]",
    "[Child's Contact Information] Child's personal email",
	"[Child's Basic Details]"
)



foreach ($row in $data) {
    if (ContainsSENData $row) {
		#Save file, file name vars
        $studentCode = $row."[Child's Basic Details] Student Code"
		$studentFirstName = $row."[Child's Basic Details] Child's legal forename"
		$studentSurname = $row."[Child's Basic Details] Child's  legal surname"
		
		
		if(!$row."[Child's Basic Details] Please upload a recent passport-style photograph of the child"){
			
			[String]$SudentImage = Get-ImageBase64FromUrl "https://d2ofqkyeey3af7.cloudfront.net/assets/default_avatar-7778faa8247cbe07401966058efb9866937a731f725d592087dfcea9ec740a67.png"

		}else{
			
			[String]$SudentImage = Get-ImageBase64FromUrl $row."[Child's Basic Details] Please upload a recent passport-style photograph of the child"
		}
		
		
        $htmlPath = Join-Path -Path $outputDir -ChildPath "$($studentFirstName) $($studentSurname) $($studentCode).html"

        $tableRows = ""
		
		$tableRows += "<th colspan='3' style='background: #c5dcef !important'>Child's Basic Details</th>"

		$tableRows += "<tr><td>Child's preferred surname</td><td>$($row."[Child's Basic Details] Child's preferred surname")</td><td align='center' rowspan='10' style='vertical-align: middle;width: 360px;padding: 0px'></td></tr>"	
		$tableRows += "<tr><td>Child's preferred forename</td><td>$($row."[Child's Basic Details] Child's preferred forename")</td></tr>"
		$tableRows += "<tr><td>Child's legal surname</td><td>$($row."[Child's Basic Details] Child's  legal surname")</td></tr>"
		$tableRows += "<tr><td>Child's legal middle name</td><td>$($row."[Child's Basic Details] Child's legal middle name")</td></tr>"
		$tableRows += "<tr><td>Child's legal forename</td><td>$($row."[Child's Basic Details] Child's legal forename")</td></tr>"
		$tableRows += "<tr><td>Child's date of birth</td><td>$($row."[Child's Basic Details] Child's date of birth")</td></tr>"
		$tableRows += "<tr><td>Child's legal gender</td><td>$($row."[Child's Basic Details] Child's legal gender")</td></tr>"
		$tableRows += "<tr><td>Child's current school</td><td>$($row."[School History] Child's current school")</td></tr>"
		$tableRows += "<tr><td>Student Code</td><td>$($row."[Basic Details] Student Code")</td></tr>"
		#$tableRows += "<tr><td>APRN (Application Number)</td><td>$($row."APRN (Application Number)")</td></tr>"
		$tableRows += "<tr><td>Transition package category</td><td>$($row."[SEN] Transition package category")</td></tr>"
		
		
		$tableRows += "<th colspan='3' style='background: #c5dcef !important'>SEN</th>"
		$tableRows += "<tr><td>Sen status (primary)</td><td colspan='2'>$($row."[SEN] Sen status (primary)")</td></tr>"
		$tableRows += "<tr><td>Sen status notes</td><td colspan='2'>$($row."[SEN] Sen status notes")</td></tr>"
		$tableRows += "<tr><td>Diagnosis</td><td colspan='2'>$($row."[SEN] Diagnosis")</td></tr>"
		$tableRows += "<tr><td>Attendance (primary)</td><td colspan='2'>$($row."[SEN] Attendance (primary)")</td></tr>"
		$tableRows += "<tr><td>Area of need</td><td colspan='2'>$($row."[SEN] Area of need")</td></tr>"
		$tableRows += "<tr><td>Cognition and learning details</td><td colspan='2'>$($row."[SEN] Cognition and learning details")</td></tr>"
		$tableRows += "<tr><td>Communication and interaction details</td><td colspan='2'>$($row."[SEN] Communication and interaction details")</td></tr>"	
		$tableRows += "<tr><td>Physical and sensory details</td><td colspan='2'>$($row."[SEN] Physical and sensory details")</td></tr>"
		$tableRows += "<tr><td>Semh details</td><td colspan='2'>$($row."[SEN] Semh details")</td></tr>"
		$tableRows += "<tr><td>Areas of strength</td><td colspan='2'>$($row."[SEN] Areas of strength")</td></tr>"
		$tableRows += "<tr><td>External agency involvement</td><td colspan='2'>$($row."[SEN] External agency involvement")</td></tr>"
		$tableRows += "<tr><td>Psychometric testing data</td><td colspan='2'>$($row."[SEN] Psychometric testing data")</td></tr>"
		$tableRows += "<tr><td>Primary school interventions</td><td colspan='2'>$($row."[SEN] Primary school interventions")</td></tr>"
		$tableRows += "<tr><td>Suggested stockport school interventions</td><td colspan='2'>$($row."[SEN] Suggested stockport school interventions")</td></tr>"
		$tableRows += "<tr><td>Family</td><td colspan='2'>$($row."[SEN] Family")</td></tr>"
		$tableRows += "<tr><td>Behaviour</td><td colspan='2'>$($row."[SEN] Behaviour")</td></tr>"

		
		$tableRows += "<th colspan='3' style='background: #c5dcef !important'>KS2 Attainment Data</th>"
		$tableRows += "<tr><td>Sat access arrangements</td><td colspan='2'>$($row."[KS2 Attainment Data] Sat access arrangements")</td></tr>"
		$tableRows += "<tr><td>Ks2 reading</td><td colspan='2'>$($row."[KS2 Attainment Data] Ks2 reading")</td></tr>"
		$tableRows += "<tr><td>Ks2 writing</td><td colspan='2'>$($row."[KS2 Attainment Data] Ks2 writing")</td></tr>"
		$tableRows += "<tr><td>Ks2 spag</td><td colspan='2'>$($row."[KS2 Attainment Data] Ks2 spag")</td></tr>"
		$tableRows += "<tr><td>Ks2 maths</td><td colspan='2'>$($row."[KS2 Attainment Data] Ks2 maths")</td></tr>"
		$tableRows += "<tr><td>Ks2 science</td><td colspan='2'>$($row."[KS2 Attainment Data] Ks2 science")</td></tr>"
		$tableRows += "<tr><td>Additional notes</td><td colspan='2'>$($row."[KS2 Attainment Data] Additional notes")</td></tr>"
	

        $htmlContent = [string]::Format($htmlTemplate, "$($studentFirstName) $($studentSurname)", $tableRows)
        $htmlContent | Out-File -FilePath $htmlPath -Encoding utf8
    }

    $foundPatterns = @{}
}

Write-Output "All done, you may close this window"


Start-Sleep -s 999