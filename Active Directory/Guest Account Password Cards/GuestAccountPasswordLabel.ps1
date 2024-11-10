$ou = "OU=xxxxxxxxxx,DC=xxxxx,DC=xxxxx,DC=xxxxx,DC=uk"

$users = @("guestt1", "guestt2", "guestt3", "guestt4", "guestt5", "guestt6", "guestt7", "guestt8", "guestt9", "guestt10")



function Generate-RandomPassword {
    
    $Characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&=+?'
    $Length = "9"
    $password = -join (1..$length | ForEach-Object { Get-Random -InputObject $characters.ToCharArray() })
    return $password

}

$labelsFile = ".\GuestAccounts.html"
$labelContent = @"
<html>
<head>
    <title>User Passwords</title>
    <style>
		@font-face {
			font-family: 'IBMPlexMonoSmBld';
			src: url('file:///A:/01%20Scripts/Server/AD/Guest%20Account%20Password%20Cards/Fonts/IBM_Plex_Mono/TT/IBMPlexMono-SemiBold.ttf');
		}
        body { font-family: IBMPlexMonoSmBld; }
        .label { 
            width: 74mm;
            height: 35mm;
            border: 1px solid black; 
            margin: 10px;
            padding: 10px;
            display: inline-block;
            page-break-after: always;
        }
        .label-content { text-align: center; font-size: 14px; }
		.SS {color: #1978cb; font-size: 15px;}
		.creds{font-size: 18px;}
		.return{color: #ff0000; font-size: 16px;}
    </style>
</head>
<body>
"@


foreach ($user in $users) {

    $newPassword = Generate-RandomPassword
    
    $adUser = Get-ADUser -Filter { SamAccountName -eq $user } -SearchBase $ou
    
    if ($adUser) {

        Set-ADAccountPassword -Identity $adUser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)
        
        $labelContent += @"
        <div class='label'>
            <div class='label-content'>
				<strong class='SS'>Guest Account</strong><br>
				<br>
                <strong class='creds'>User: $user</strong><br>
                <strong class='creds'>Password: $newPassword</strong><br>
				<br>
				<strong class='return'>Return To Room 101</strong>
            </div>
        </div>
"@
    } else {
        Write-Host "User $user not found in the specified OU"
    }
}


$labelContent += @"
</body>
</html>
"@


$labelContent | Out-File -FilePath $labelsFile -Encoding utf8

Write-Host "All Done"