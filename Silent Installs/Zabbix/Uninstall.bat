rmdir "C:\Program Files\Zabbix Agent" /s /q

"B:\Zabbix\zabbix_agent-6.4.0-windows-amd64-openssl\bin\zabbix_agentd.exe" --uninstall

WMIC /node:"%compName%" product WHERE name="Zabbix Agent (64-bit)" CALL uninstall /nointeractive

sc delete "Zabbix Agent"

::"B:\Zabbix\zabbix_agent-6.4.0-windows-amd64-openssl\bin\zabbix_agentd.exe" --config "B:\Zabbix\zabbix_agent-6.4.0-windows-amd64-openssl\conf\ServerStandard.conf" --install

::zabbix_agentd.exe --start

timeout /t 900