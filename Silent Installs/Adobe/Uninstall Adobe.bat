@Echo off

echo Deactivating Adobe
"adobe-licensing-toolkit\adobe-licensing-toolkit\win64\adobe-licensing-toolkit.exe" --deactivate

echo Removing Adobe
"AdobeCreativeCloudCleanerTool_Win\AdobeCreativeCloudCleanerTool.exe" --cleanupXML="AdobeCreativeCloudCleanerTool_Win\cleanup.xml"
"AdobeCreativeCloudCleanerTool.exe" --removeAll=ALL
"AdobeCreativeCloudCleanerTool.exe" --removeAll=CREATIVECLOUDCS6PRODUCTS
"Uninstall_win_pkg_All_Apps\Uninstall_win64_pkg_All_Apps\AdobeCCUninstaller.exe"

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Adobe CS6 Design and Web Premium" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Adobe AIR" CALL uninstall /nointeractive

for /f "tokens=2 delims==" %%f in ('wmic computersystem get Name /value ^| find "="') do set "compName=%%f"
WMIC /node:"%compName%" product WHERE name="Adobe Acrobat Reader" CALL uninstall /nointeractive

taskkill /IM "armsvc.exe" /F

echo Removing Adobe Leftovers
@RD /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Design and Web Premium CS6"

@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Bridge CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Dreamweaver CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Extension Manager CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Fireworks CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Flash CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe InDesign CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Media Encoder CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Adobe Utilities - CS6"
@RD /S /Q "C:\Program Files (x86)\Adobe\Acrobat Reader DC"
@RD /S /Q "C:\Program Files (x86)\Adobe"

@RD /S /Q "C:\Program Files\Adobe\Adobe Bridge CS6 (64 Bit)"
@RD /S /Q "C:\Program Files\Adobe\Adobe Illustrator CS6 (64 Bit)"
@RD /S /Q "C:\Program Files\Adobe\Adobe Media Encoder CS6"
@RD /S /Q "C:\Program Files\Adobe\Adobe Photoshop CS6 (64 Bit)"
@RD /S /Q "C:\Program Files\Adobe"

@RD /S /Q "C:\ProgramData\Adobe\Extension Manager CS6"
@RD /S /Q "C:\ProgramData\Adobe\Fireworks CS6"
@RD /S /Q "C:\ProgramData\Adobe\InDesign"
@RD /S /Q "C:\ProgramData\Adobe\Setup"
@RD /S /Q "C:\ProgramData\Adobe"

@RD /S /Q "C:\Program Files\Common Files\Adobe\Acrobat"
@RD /S /Q "C:\Program Files\Common Files\Adobe\APE"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Bridge CS6 Extensions"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Camera Raw 7"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Color"
@RD /S /Q "C:\Program Files\Common Files\Adobe\FontsRecommended"
@RD /S /Q "C:\Program Files\Common Files\Adobe\FontsRequired"
@RD /S /Q "C:\Program Files\Common Files\Adobe\HelpCfg"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Installers"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Linguistics"
@RD /S /Q "C:\Program Files\Common Files\Adobe\PDFL"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Plug-Ins"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Scripting Dictionaries CS6"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Shell"
@RD /S /Q "C:\Program Files\Common Files\Adobe\Startup Scripts CS6"
@RD /S /Q "C:\Program Files\Common Files\Adobe\TypeSupport"
@RD /S /Q "C:\Program Files\Common Files\Adobe\XMP"
@RD /S /Q "C:\Program Files\Common Files\Adobe"

@RD /S /Q "C:\Program Files (x86)\Common Files\Adobe"
@RD /S /Q "C:\Program Files (x86)\Common Files\Adobe AIR"


@RD /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe"

DEL /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe*" 
