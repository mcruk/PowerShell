@echo off
msiexec /i "Smart DC.msi" /qn ALLUSERS=1

del "C:\Program Files (x86)\Smart DC\DC4AP_de.qm"
del "C:\Program Files (x86)\Smart DC\DC4AP_es.qm"
del "C:\Program Files (x86)\Smart DC\DC4AP_fr.qm"
del "C:\Program Files (x86)\Smart DC\DC4AP_ja.qm"
del "C:\Program Files (x86)\Smart DC\DC4AP_zh-tw.qm"
