for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"

shutdown -s -t 980
WMIC /node:"%compName%" product WHERE name="ESET Endpoint Antivirus" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="ESET Management Agent" CALL uninstall /nointeractive
shutdown /a

timeout /t 120 /nobreak