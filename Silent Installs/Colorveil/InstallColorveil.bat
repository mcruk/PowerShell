echo "Colorveil"

del "C:\Users\Public\Desktop\ColorVeil.exe"

msiexec /i "colorveil-x64.msi" /qr ALLUSERS=1

copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ColorVeil.lnk" "C:\Users\Public\Desktop\ColorVeil.lnk"