@Echo off

echo "Uninstalling Equatio"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Equatio" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="EquatIO Config" CALL uninstall /nointeractive


del "C:\Program Files (x86)\Texthelp" /F /S /Q


msiexec /i "Setup.msi" /qr ALLUSERS=1
msiexec /i "EquatIOConfig.msi" /qr ALLUSERS=1


