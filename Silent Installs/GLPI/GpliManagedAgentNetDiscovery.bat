msiexec /i "GLPI-Agent-1.9-gitdd4eee63-x64.msi" /quiet SERVER="https://your.domain.uk" ADD_FIREWALL_EXCEPTION=1 EXECMODE=Service ADDLOCAL=feat_NETINV,feat_AGENT,feat_COLLECT RUNNOW=1




