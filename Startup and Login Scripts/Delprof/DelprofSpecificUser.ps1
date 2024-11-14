$profileName = "B.cake"

$userProfilesPath = "C:\Users"

$profilePath = Join-Path $userProfilesPath $profileName

if (Test-Path $profilePath) {
	Start-Process "C:\Program Files\DelProf2\DelProf2.exe" -ArgumentList "/u /i /ed:admin* /ed:beef /ed:Administrator /ed:Public /ed:Default /id:$($profileName)" -Wait
}
	