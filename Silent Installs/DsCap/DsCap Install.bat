"DsCap 3.92\Setup.exe" /Q

mkdir "C:\Users\Default\AppData\Roaming\DsCap"

mkdir "C:\Program Files (x86)\DsCap"

xcopy /s /y "DsCap 3.92\Dscap Roaming\DsCap" "C:\Users\Default\AppData\Roaming\DsCap"

xcopy /s /y "DsCap 3.92\Setup" "C:\Program Files (x86)\DsCap"




set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%PUBLIC%\Desktop\DsCap.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%SYSTEMDRIVE%\Program Files (x86)\DsCap\DsCap.exe" >> %SCRIPT%
echo oLink.WorkingDirectory ="%SYSTEMDRIVE%\Program Files (x86)" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%

del %SCRIPT%
