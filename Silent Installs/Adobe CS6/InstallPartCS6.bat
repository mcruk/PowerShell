@echo off

msiexec.exe /i "Adobe Design and Web Premium CS6\CS6 All Unatended\Exceptions\AdobePDFSettings11-mul\AdobePDFSettings11-mul.msi" /qn

msiexec.exe /i "Adobe Design and Web Premium CS6\CS6 All Unatended\Build\Unattended Installation.msi" /QN REBOOT=ReallySuppress

msiexec.exe /i "Adobe Design and Web Premium CS6\CS6 All Unatended\Exceptions\AcrobatProfessional10.0-EFG\AcroPro.msi" /QN  EULA_ACCEPT=YES REGISTRATION_SUPPRESS=YES SUITEMODE=1 INSTALLLEVEL=101 AS_DISABLE_LEGACY_COLOR=1 IGNOREAAM=1 TRANSFORMS="Adobe Design and Web Premium CS6\CS6 All Unatended\Exceptions\AcrobatProfessional10.0-EFG\en_GB.mst" REBOOT=ReallySuppress

msiexec.exe /p "Adobe Design and Web Premium CS6\CS6 All Unatended\Exceptions\AcrobatProfessional10.0-EFG\AcrobatUpd1011.msp" /QN

msiexec.exe /p "Adobe Design and Web Premium CS6\Updates\AcrobatUpd10116.msp" /QN

"Adobe Design and Web Premium CS6\Package Creator\CS6 Serial EXE\Serialization\adobe_prtk.exe" --tool=VolumeSerialize --provfile="Adobe Design and Web Premium CS6\Package Creator\CS6 Serial EXE\Serialization\prov.xml"


if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe" rmdir /q /s "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat Distiller X.lnk" move /y "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat Distiller X.lnk" "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Design Standard CS6\Adobe Acrobat Distiller X.lnk"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat X Pro.lnk" move /y "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat X Pro.lnk" "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Design Standard CS6\Adobe Acrobat X Pro.lnk"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe LiveCycle ES2\Adobe LiveCycle Designer ES2.lnk" copy /y "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe LiveCycle ES2\Adobe LiveCycle Designer ES2.lnk" "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe Design Standard CS6\Adobe LiveCycle Designer ES2.lnk"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe LiveCycle ES2" rmdir /q /s "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Adobe LiveCycle ES2"
if exist "%PUBLIC%\Desktop\Adobe Acrobat X Pro.lnk" del /f /q "%PUBLIC%\Desktop\Adobe Acrobat X Pro.lnk"
