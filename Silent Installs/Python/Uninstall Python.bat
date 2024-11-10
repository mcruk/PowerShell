for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
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