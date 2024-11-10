msiexec /i "luciduniversalthinclient\LucidUniversalThinClient.msi" /qr ALLUSERS=1 

msiexec /i "2008 Native Client\sqlncli_x64.msi" /qr ALLUSERS=1

msiexec /i "2008 Native Client\SqlCmdLnUtils_x64.msi" /qr ALLUSERS=1

msiexec /i "2012 Native Client\sqlncli.msi" /qr ALLUSERS=1

copy "LSECTv603.lnk" "C:\Users\Public\Desktop\LSECTv603.lnk"





