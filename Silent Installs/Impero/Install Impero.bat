@Echo off

echo "Kill Adobe Updater"
taskkill /IM "armsvc.exe" /F

echo "Kill Windows Installer"
taskkill /IM "msiexec.exe" /F

timeout /t 1 /nobreak

echo "Installing Impero"
msiexec /i "ImperoClientSetup8626.msi" /qr ALLUSERS=1 /norestart