WMIC /node:"%compName%" product WHERE name="SOLUS 3 Agent" CALL uninstall /nointeractive

rmdir /s /q "C:\ProgramData\Solus 3"

rmdir /s /q "C:\Program Files\Solus3"

rmdir /s /q "C:\ProgramData\Capita"

DEL /q "C:\Windows\SIMS.INI"

COPY /Y "SIMS.INI" "C:\Windows\SIMS.INI"

timeout -t 99