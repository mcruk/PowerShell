echo Installing Cashless Register Enrollment

msiexec /i "LRDrivers_x64.msi" /qr ALLUSERS=1

msiexec /i "LREnrolment.msi" /qr ALLUSERS=1

"User Manager Files\SgDrvSetupUniversal.exe" /S

"User Manager Files\windowsdesktop-runtime-6.0.14-win-x86.exe" /S