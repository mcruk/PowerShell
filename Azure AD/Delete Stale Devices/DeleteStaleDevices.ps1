Install-Module AzureAD
Connect-AzureAD 

$dt = (Get-Date).AddDays(-60)
$Devices = Get-AzureADDevice -All:$true | Where {($_.ApproximateLastLogonTimeStamp -le $dt) -and ($_.AccountEnabled -eq $false)}

foreach ($Device in $Devices) {
	Remove-AzureADDevice -ObjectId $Device.ObjectId
}