MsiExec.exe /i "Setup.msi" ALLUSERS=1 /qn
xcopy /e /v /y "winSensorlab\Installer\SensorLab" "C:\ProgramData\SensorLab"