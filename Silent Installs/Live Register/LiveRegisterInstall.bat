"windowsdesktop-runtime-6.0.14-win-x86.exe" /passive /norestart

msiexec /i "CCM_x64.msi" /qr ALLUSERS=1

msiexec /i "usermanager.msi" /qr ALLUSERS=1