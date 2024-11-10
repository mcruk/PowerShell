$ManifestPath = "C:\Windows\SystemApps\Microsoft.PPIProjection_cw5n1h2txyewy\Appxmanifest.xml"

Add-AppxPackage -Path $ManifestPath -Register -DisableDevelopmentMode -verbose

Add-WindowsCapability -Online -Name 'App.WirelessDisplay.Connect~~~~0.0.1.0'


msiexec.exe /i "Bonjour64.msi" /QN
msiexec.exe /i "BonjourPS64.msi" /QN

#Start-Process -FilePath "DirectX\InstallDX.bat" -Wait

msiexec.exe /i "AirServer-5.6.3-x64.msi" /QN /ALLOWNAMING=FALSE AUTOSTART=TRUE PIDKEY=Your@Email CHECKFORUPDATES=ENABLE

start-sleep -s 10

