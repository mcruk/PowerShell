@Echo off

echo Installing Adobe CC
msiexec /i "Acrobat Pro CC\Build\Acrobat Pro CC.msi" ALLUSERS=1 /qr

msiexec /i "Acrobat Pro CC\Build\Setup\APRO24.1\Adobe Acrobat\AcroPro.msi" ALLUSERS=1 /qr

msiexec /p "Acrobat Pro CC\Build\Setup\APRO24.1\Adobe Acrobat\AcrobatDCx64Upd2400220759.msp" /QN



