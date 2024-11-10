@Echo off

echo Installing Adobe CC
msiexec /i "ALL SEPT 24\Build\ALL SEPT 24.msi" ALLUSERS=1 /qr

msiexec /i "ALL SEPT 24\Build\Setup\APRO24.1\Adobe Acrobat\AcroPro.msi" ALLUSERS=1 /qr


msiexec /p "ALL SEPT 24\Build\Setup\APRO24.1\Adobe Acrobat\AcrobatDCx64Upd2400320112.msp" /QN


