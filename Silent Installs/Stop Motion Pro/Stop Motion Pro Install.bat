@Echo off
echo "Installing DirectPlay"
dism /online /Enable-Feature /FeatureName:DirectPlay /All

echo "Installing Stop Motion 8"
msiexec /i "stop_motion_pro_v8_deploy.msi" /qr ALLUSERS=1