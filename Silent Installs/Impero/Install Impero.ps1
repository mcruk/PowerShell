Start-Process "msiexec.exe" -ArgumentList "/i ImperoClientSetup8626.msi /qr ALLUSERS=1" -PassThru | select -ExpandProperty id | set id
start-sleep -s 180

if (Test-Path "C:\Program Files (x86)\Impero Solutions Ltd") {
   Exit 0
}else{
	kill $id -ea 0
	Exit 1
}