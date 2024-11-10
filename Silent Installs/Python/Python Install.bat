@Echo off


echo Uninstalling Pyhthon 3.8 and 3.6
for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
echo %compName%
WMIC /node:"%compName%" product WHERE name="Python Launcher" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Core Interpreter (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 pip Bootstrap (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Add to Path (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Development Libraries (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Test Suite (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Utility Scripts (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Test Suite (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Documentation (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Executables (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Standard Library (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Standard Library (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.8.3 Utility Scripts (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Tcl/Tk Support (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Executables (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.6.6 Add to Path (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" Python 3.6.6 pip Bootstrap (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" Python 3.8.3 Tcl/Tk Support (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" Python 3.8.3 Documentation (64-bit)" CALL uninstall /nointeractive
rmdir /s /q "C:\Program Files\Python38"
rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Python 3.8"

echo Uninstalling Pyhthon 3.10.7
"python-3.10.7-amd64.exe" /uninstall /quiet
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Tcl/Tk Support (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Executables (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Core Interpreter (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Development Libraries (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Standard Library (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Documentation (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Utility Scripts (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 pip Bootstrap (64-bit)" CALL uninstall /nointeractive
WMIC /node:"%compName%" product WHERE name="Python 3.10.7 Test Suite (64-bit)" CALL uninstall /nointeractive

rmdir /s /q %LOCALAPPDATA%"\Programs\Python"
del /s /q "C:\Users\Default\Desktop\IDLE (Python 3.10 64-bit).lnk"
del /s /q "C:\Users\Default\Desktop\Python 3.10 (64-bit).lnk"
rmdir /s /q %APPDATA%"\Microsoft\Windows\Start Menu\Programs\Python 3.10"

echo installing Python 3.10.7
"python-3.10.7-amd64.exe" /quiet InstallAllUsers=1 TargetDir="C:\Program Files\Python310" DefaultCustomTargetDir="C:\Program Files\Python310" PrependPath=1 AssociateFiles=1 CompileAll=0 PrependPath=0 Shortcuts=1 Include_doc=1 Include_debug=1 Include_dev=1 Include_exe=1 Include_launcher=1 InstallLauncherAllUsers=1 Include_lib=1 Include_pip=1 Include_symbols=0 Include_tcltk=1 Include_test=1 Include_tools=1 LauncherOnly=0




