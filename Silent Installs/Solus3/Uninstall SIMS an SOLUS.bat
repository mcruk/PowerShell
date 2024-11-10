@echo off
echo "Uninstalling Solus and SIMS"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
echo %compName%
WMIC /node:"%compName%" product WHERE name="SOLUS 3 Agent" CALL uninstall /nointeractive


rmdir "C:\ProgramData\Capita" /s /q

rmdir "C:\ProgramData\Solus 3" /s /q

rmdir "C:\Program Files (x86)\SIMS" /s /q

rmdir "C:\Program Files\Solus3" /s /q