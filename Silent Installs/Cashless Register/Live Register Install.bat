echo Installing Cashless Register

msiexec /i "CCM_x64.msi" /qr ALLUSERS=1

msiexec /i "CRRedist2008_x64.msi" /qr ALLUSERS=1

"windowsdesktop-runtime-6.0.14-win-x86.exe" /S