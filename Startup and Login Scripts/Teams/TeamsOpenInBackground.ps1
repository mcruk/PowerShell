try{
	# End acitve Teams process
	if(Get-Process ms-teams -ErrorAction SilentlyContinue){
		Get-Process ms-teams | Stop-Process -Force
	}

	# Replace/Set "open_app_in_background" option to true
	$SettingsJSON = "$ENV:LocalAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\app_settings.json"
	(Get-Content $SettingsJSON -ErrorAction Stop).replace('"open_app_in_background":false', '"open_app_in_background":true') | Set-Content $SettingsJSON -Force

}catch{$_}

