for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Java 8 Update 351 (64-bit)" CALL uninstall /nointeractive