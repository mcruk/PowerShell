for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="MatchWare MindView 3.0 BE" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="MatchWare MindView 5.0" CALL uninstall /nointeractive