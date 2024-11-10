@Echo off

echo "Uninstalling ClaroRead"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroRead SE" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroRead" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Capture" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Claro AudioNote" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroCapture" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroIdeas" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroRead Pro" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ClaroView, ScreenRuler and ScreenMarker" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Scan Screen Plus" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Scan2Text" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="ScreenRuler" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Vocalizer Daniel from Claro Software" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Vocalizer Lee from Claro Software" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Vocalizer Karen from Claro Software" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Vocalizer Expressive Kate - Claro" CALL uninstall /nointeractive

del "C:\ProgramData\Claro Software" /F /S /Q

del "C:\Program Files (x86)\Claro Software" /F /S /Q

del "C:\Program Files (x86)\Nuance\Expressive v1\" /F /S /Q


echo "Installing ClaroReadPro v9 Network"
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\AudioNote-int-1.1.15.0-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ClaroCapture-engb-5.1.22-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ClaroReadPro-int-9.3.1-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ClaroView-int-3.1.0-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ScreenRuler-int-3.4.2-net-X.msi" /qr ALLUSERS=1



echo "Installing Voices"
msiexec /i "voices\VA05-BritishEnglish-Daniel.msi" /qr ALLUSERS=1

msiexec /i "voices\VA21-AustralianEnglish-Karen.msi" /qr ALLUSERS=1

msiexec /i "voices\VA22-AustralianEnglish-Lee.msi" /qr ALLUSERS=1

msiexec /i "voices\VE55-Kate-BritishEnglish.msi" /qr ALLUSERS=1






