
Start "Casio Emulator\Casio FX-93GT\CASIO fx-83GT PLUS Emulator Ver. 4.msi" ALLUSERS=1 

# Wait for program to start
Start-Sleep -Seconds 3

$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('CASIO fx-83GT PLUS Emulator Ver.4 (Single License) - InstallSheild Wizard')
Sleep 3
$wshell.SendKeys("{ENTER}")
Sleep 2
$wshell.SendKeys("{UP}")
Sleep 1
$wshell.SendKeys("{ENTER}")
Sleep 1
$wshell.SendKeys("xxxxSERIALXXXXXXXX")
Sleep 2
$wshell.SendKeys("{ENTER}")
Sleep 2
$wshell.SendKeys("{ENTER}")
Sleep 2
$wshell.SendKeys("{ENTER}")
Sleep 60
$wshell.SendKeys("{ENTER}")
