@Echo off
echo Checking Motherboard Name
echo:
echo:
echo:
for /f "tokens=2 delims==" %%f in ('wmic baseboard get product /value ^| find "="') do set "compName=%%f"
for /f "tokens=2 delims==" %%f in ('wmic baseboard get Manufacturer /value ^| find "="') do set "compName2=%%f"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get manufacturer /value ^| find "="') do set "computersystem1=%%f"
for /f "tokens=2 delims==" %%f in ('wmic computersystem get model /value ^| find "="') do set "computersystem=%%f"
echo Baseboard ID Product: %compName%
echo:
echo Baseboard ID Manufacturer: %compName2%
echo:
echo:
echo System Manufacturer: %computersystem1%
echo:
echo System Model: %computersystem%
echo:
echo:
echo:
echo:

pause 

