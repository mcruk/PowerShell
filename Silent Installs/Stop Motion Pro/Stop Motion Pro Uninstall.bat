@Echo off
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Stop Motion Pro v8 Action! / Action! Plus Workstation" CALL uninstall /nointeractive