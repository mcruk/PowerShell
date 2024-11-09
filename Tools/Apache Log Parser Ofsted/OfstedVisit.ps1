function Read-ApacheLog{
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Path
    )

    Get-Content -Path $Path | Foreach-Object {
       # combined format
       if ($_ -notmatch "^(?<Host>.*?) (?<LogName>.*?) (?<User>.*?) \[(?<TimeString>.*?)\] `"(?<Request>.*?)`" (?<Status>.*?) (?<BytesSent>.*?) `"(?<Referer>.*?)`" `"(?<UserAgent>.*?)`"$") {
          throw "Invalid line: $_"
       }
       
       $entry = $matches
       $entry.Time = [DateTime]::ParseExact($entry.TimeString, "dd/MMM/yyyy:HH:mm:ss zzz", [System.Globalization.CultureInfo]::InvariantCulture)
       if ($entry.Request -match "^(?<Method>.*?) (?<Path>.*?) (?<Version>.*)$") {
          $entry.Method = $matches.Method
          $entry.Path = $matches.Path
          $entry.Version = $matches.Version
       }
       
       return New-Object PSObject -Property $entry

    }
}



function Pattern-Match{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $QueryString,
         [Parameter(Mandatory=$true, Position=1)]
         [array] $LookupTable
    )
	
	foreach($Lookup in $LookupTable){
		if($QueryString -match $Lookup){
			return $true
            Break
		}
	}

    return $false
}


function Positive-Match{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $QueryString,
         [Parameter(Mandatory=$true, Position=1)]
         [array] $LookupTable
    )
	
	foreach($Lookup in $LookupTable){
		if($QueryString -match $Lookup){
			return $true
            Break
		}
	}

    return $false
}


function IP-Match{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $QueryString,
         [Parameter(Mandatory=$true, Position=1)]
         [array] $LookupTable
    )
	
	foreach($Lookup in $LookupTable){
		if($QueryString -eq $Lookup){
			return $true
            Break
		}
	}

    return $false
}


Function Convert-ToUnixDate ($PSdate) {
   $epoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
   (New-TimeSpan -Start $epoch -End $PSdate).TotalSeconds
}


function Get-IPGeolocation {
 Param   ([string]$IPAddress)

  $IPInfo = Invoke-RestMethod -Method Get -Uri "http://ip-api.com/json/$IPAddress"

  [PSCustomObject]@{
     IP      = $IPInfo.Query
     City    = $IPInfo.City
     Country = $IPInfo.Country
     Region  = $IPInfo.Region
     Isp     = $IPInfo.Isp   }

}

#relative path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path


$PdfTargetFile = "$($scriptDir)\TargetDocs.txt"

#Import Arrays From Docs
$PdfTargets = Get-Content "$($scriptDir)\TargetDocs.txt"

$IpBlacklist = Get-Content "$($scriptDir)\IpBlackList.txt"

$BotBlacklist = Get-Content "$($scriptDir)\BotBlacklist.txt"

$IpPositiveList = Get-Content "$($scriptDir)\IpPositiveList.txt"


#FTP File extract rename
$FilesAvailable = @{}
$FtpFileDate = "$((Get-Culture).DateTimeFormat.GetAbbreviatedMonthName((Get-Date).Month))-$(get-date -format yyyy)"
$FtpFileNeeded = "test.net-ssl_log-$($FtpFileDate).gz"
$FtpFileExtract = "test.net-ssl_log-$($FtpFileDate)"
$FtpFileExtractExtension = ".NET-SSL_LOG-$($FtpFileDate)"
$ExtractRename = "test.log"
$LogPath = "$($scriptDir)\log.log"

#Check FTP worked
$FtpFS = $false

#min number of docs needed
$MinResultsNeeded = 5

#max days to scan, UNIX time
$TimePast = 259260

#Email Settings
$From = "test@test.uk"
#comma seperate to
$To = "test@test.uk","test2@test.uk"
$ToSystemCheck = "test@test.uk","test2@test.uk"
$Subject = "Ofsted Scool Website"
$SMTPServer = "outlook.office365.com"
$SMTPPort = "25"




#Get policy PDF link.  All pdfs linked in this page will be added to the TargetDocs.txt file. 
$webpageUrl = "https://school.net/policies/"

Remove-Item $PdfTargetFile -Force

$htmlContent = Invoke-WebRequest -Uri $webpageUrl

$pdfLinks = Select-String -InputObject $htmlContent.Content -Pattern 'href="([^"]+\.pdf)"' -AllMatches

$fileNames = @()

foreach ($match in $pdfLinks.Matches) {

    $pdfUrl = $match.Groups[1].Value

    $fileName = [System.IO.Path]::GetFileName($pdfUrl)

    $fileNames += $fileName

}


$fileNames | Out-File -FilePath $PdfTargetFile






#email Body
$Body = ""

#remove old logs
if (Test-Path $LogPath -PathType Leaf) {
   Remove-Item $LogPath
}

#Remove old Json
if (Test-Path "$($scriptDir)\log.json" -PathType Leaf) {
   Remove-Item "$($scriptDir)\log.json"
}


#FTP time
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Ftp
        HostName = "ftp.school.net"
        UserName = "ftpaccount@school.net"
        Password = "1234567890"
        FtpSecure = [WinSCP.FtpSecure]::Explicit
        TlsHostCertificateFingerprint = "c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77:c4:77"
    }

 
    #$sessionOptions.AddRawSettings("MinTlsVersion", "1.2")

    $session = New-Object WinSCP.Session
 
    try
    {
        
        $remotePath = "/"
        $wildcard = "*ssl_log*"

        # Connect
        $session.Open($sessionOptions)
 
        # Get list of matching files in the directory
        $files =
            $session.EnumerateRemoteFiles(
                $remotePath, $wildcard, [WinSCP.EnumerationOptions]::None)
 
        # Any file matched?
        if ($files.Count -gt 0)
        {
            foreach ($fileInfo in $files)
            {
               <#  Write-Host ("$($fileInfo.Name) with size $($fileInfo.Length), " +
                    "permissions $($fileInfo.FilePermissions) and " +
                    "last modification at $($fileInfo.LastWriteTime)") #>
					#write-host $fileInfo.Name
					
					if((Pattern-Match $fileInfo.Name $FtpFileNeeded) -eq $true){

						write-host $fileInfo.Name
						
						#Download the selected file
						$session.GetFileToDirectory($fileInfo.Name, $scriptDir)
						

                        $7zipPath = "C:\PROGRA~1\7-Zip\7z.exe"
                        $zipFile = "$($scriptDir)\$($fileInfo.Name)"
                        $extractPath = "$($scriptDir)"
 
                        
                        & $7zipPath x $zipFile -o"$($extractPath)"

                        Get-Item "$($scriptDir)\$FtpFileExtract" | Rename-Item -NewName { $_.name -Replace $FtpFileExtractExtension ,'.log' }
                        Rename-Item "$($scriptDir)\$($ExtractRename)" "log.log"

                        Remove-Item "$($scriptDir)\$FtpFileExtract.gz"

                        Break
						
					}
					
            }
        }
        else
        {
            Write-Host "No files matching $wildcard found"
        }
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
	start-sleep -s 15
}

if (Test-Path $LogPath -PathType Leaf) {
	Write-host "FTP Success"
}else{
	Write-host "FTP Failure"
	Send-MailMessage -From $From -to $ToSystemCheck -Subject $Subject -Body "FTP Failure" -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl
	exit
}



#read log file
Read-ApacheLog "$scriptDir\log.log" | ConvertTo-Json | Out-File "$scriptDir\log.json"


# Load JSON file
$json = Get-Content -Path "$($scriptDir)\log.json" -Raw

$data = ConvertFrom-Json $json


$HostDetails= @{}

foreach ($log in $data.PsObject.Properties.Value)
{
    
	if(!$log.Time){continue}
	
	$LogUnixTime =  Convert-ToUnixDate $log.Time
	
	$CurrentTime = [int][double]::Parse((Get-Date -UFormat %s))
	
	$SubtractTime = $CurrentTime - $LogUnixTime
	
	
	if($SubtractTime -ge $TimePast){continue}
	
    if((IP-Match $log.host $IpPositiveList) -eq $true){
		Write-host "$($log.host) is a Known Ofsted IP Address" -ForegroundColor red
		Send-MailMessage -From $From -to $To -Subject $Subject -Body "Ofsted has visted the website.  $($log.host) is a known Ofsted IP address" -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl
		start-sleep -5
		Exit
	}

    if($log.Method -eq 'POST' -or $log.Method -eq 'HEAD'){continue}

	if(!$log.UserAgent){continue}
	if ((Pattern-Match $log.UserAgent $BotBlacklist) -eq $true){continue}

    if((IP-Match $log.host $IpBlacklist) -eq $true){continue}
	
	



    if((Positive-Match $log.Path $PdfTargets) -eq $true){
				
        $HostIp = $log.host
		
		if(!$HostDetails.ContainsKey($HostIp)){
			
			#$HostDetails.$log.host = $log.host
			
			$HostDetails[$HostIp] = @{}

			
			$HostDetails[$HostIp]["details"] = @{}
			
			$HostDetails[$HostIp]["Counting"] = 0
            #write-host "Is New"

            $HostDetails[$HostIp]["ip"] = $HostIp
 

		}
		
		
		$CountInc = $HostDetails[$HostIp]["counting"]
		$SetCount = $CountInc+1
    
        #write-host $CountInc++

		$HostDetails[$HostIp]["Counting"] = $SetCount
		$HostDetails[$HostIp]["Details"][$SetCount] = @{}
		
		$HostDetails[$HostIp]["Details"][$SetCount]["TimeString"] = $log.TimeString
		$HostDetails[$HostIp]["Details"][$SetCount]["UserAgent"] = $log.UserAgent
		$HostDetails[$HostIp]["Details"][$SetCount]["Path"] = $log.Path

    }
	
	

}


#remove single results
$HostDetailsClone = $HostDetails.Clone()

foreach ($i in $HostDetails.keys) {

    foreach($jj in $HostDetails[$i]['Counting']){
		
		
		if($jj -le $MinResultsNeeded){
			
			$HostDetailsClone.Remove($i) 
			
		}	

    }
	
}



if($HostDetailsClone.Count -gt 0){

	foreach ($i in $HostDetailsClone.keys) {

		#Show IP Address
	   $Body += "================================================================================================== `n"
	   $Body += "Ip Address:  $($i) `n" 
		
		$IPInfo = Get-IPGeoLocation $i
		$Body += "Location:  $($IPInfo.City), $($IPInfo.Country), $($IPInfo.Region) `n"
		$Body += "Serice Provider:  $($IPInfo.Isp) `n"
		$Body += "`n"

		foreach($jj in $HostDetailsClone[$i]['Counting']){
			$Body += "Number of Documents Viewed: $($jj) `n" 
			$Body += "`n"
			$Body += "Douments Viewed: `n"
			$Body += "`n"
		}
		
		foreach($j in $HostDetailsClone[$i]['details'].keys){
			
			foreach($k in $HostDetailsClone[$i]['details'][$j]){
				
				$Body += "Time:  $($k['TimeString']) `n"
				
				$FinalPath = ($k["Path"] -split '/')[-1]
				
				$Body += "Document Viewed:  $($FinalPath) `n"
				
				$Body += "Browser Used:  $($k['UserAgent']) `n"
				
				$Body += "`n"

			}
		
		}

		$Body += "`n"

	}



	Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl

}else{
	
	$Body2 = "There have been no website visitors viewing school policies in the last 1 days. `n"
	$Body2 += "The Sytem is working normally. `n"
	
	Send-MailMessage -From $From -to $ToSystemCheck -Subject $Subject -Body $Body2 -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl
}


write-host "Finished"

start-sleep -s 15
