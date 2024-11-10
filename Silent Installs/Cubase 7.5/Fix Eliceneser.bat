@echo off
echo make sure this is a clean boot, if in doubt restart

timeout 10

echo Checking if eLicenser is installed
IF EXIST "C:\Program Files (x86)\eLicenser\Uninstaller\Uninstall eLicenser Control.exe" (
	echo Uninstalling eLicenser
	"C:\Program Files (x86)\eLicenser\Uninstaller\Uninstall eLicenser Control.exe" --mode unattended --unattendedmodeui none
) ELSE (
    echo Nothing to do eLicenser uninstalled
)

rmdir /s /q "C:\Program Files (x86)\eLicenser"
rmdir /s /q "C:\ProgramData\Syncrosoft"

"Cubase_7.5 Network Install\eLicenserControlSetup.exe" --mode unattended --unattendedmodeui none

