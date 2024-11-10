@Echo off

echo "Installing ClaroRead v13"

msiexec /i "Claro v13\SE\ClaroReadSE-engb-13.0.24-net.msi" /qr ALLUSERS=1


echo "Installing Voices"
msiexec /i "voices\VA05-BritishEnglish-Daniel.msi" /qr ALLUSERS=1

msiexec /i "voices\VA21-AustralianEnglish-Karen.msi" /qr ALLUSERS=1

msiexec /i "voices\VA22-AustralianEnglish-Lee.msi" /qr ALLUSERS=1

msiexec /i "voices\VE55-Kate-BritishEnglish.msi" /qr ALLUSERS=1







