msiexec /i "SOLUS3AgentInstaller_x64.msi" AGENTSERVICEADDRESS=net.tcp://localhost:52966 DEPLOYMENTSERVERADDRESS=net.tcp://your-server:52965 RSAKEYPATH="D:\Solus3\Key\" PREDEFINEDAGENTTARGETS="SIMS FMS" /qr

timeout /t 10