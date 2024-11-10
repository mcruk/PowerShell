for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"

WMIC /node:"%compName%" product WHERE name="GLPI Agent 1.7.3" CALL uninstall /nointeractive


timeout /t 10 /nobreak