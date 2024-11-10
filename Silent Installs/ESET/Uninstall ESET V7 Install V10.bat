@Echo off

echo "Uninstalling ESET"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
echo %compName%
shutdown -s -t 980
WMIC /node:"%compName%" product WHERE name="ESET Endpoint Antivirus" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="ESET Management Agent" CALL uninstall /nointeractive
shutdown /a



echo "Installing Eset V10"
"PROTECT_Installer_x64_en_US.exe" --silent --accepteula --avr-disable


timeout /t 10 /nobreak


