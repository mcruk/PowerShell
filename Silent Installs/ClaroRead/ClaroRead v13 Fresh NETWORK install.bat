@Echo off

echo "Installing ClaroRead v13 Network"
msiexec /i "Claro v13\Network Installer\Capture-engb-8.2.5-net.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroIdeas-engb-3.1.0-net.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroRead-engb-13.0.24-net.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroView-engb-3.4.8-net.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\Scan2Text-engb-7.4.19-net.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ScanScreenPlus-int-2.2.4-net.msi" /qr ALLUSERS=1

msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\AudioNote-int-1.1.15.0-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ClaroCapture-engb-5.1.22-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ClaroReadPro-int-9.3.1-net-X.msi" /qr ALLUSERS=1
msiexec /i "Claro v13\Network Installer\ClaroReadPro-9.3.1-UK-NETBUNDLE\ScreenRuler-int-3.4.2-net-X.msi" /qr ALLUSERS=1


echo "Installing Voices"
msiexec /i "voices\VA05-BritishEnglish-Daniel.msi" /qr ALLUSERS=1

msiexec /i "voices\VA21-AustralianEnglish-Karen.msi" /qr ALLUSERS=1

msiexec /i "voices\VA22-AustralianEnglish-Lee.msi" /qr ALLUSERS=1

msiexec /i "voices\VE55-Kate-BritishEnglish.msi" /qr ALLUSERS=1






