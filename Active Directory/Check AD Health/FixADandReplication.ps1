function Test-And-Fix-ADHealth {
    Write-Output "Running DCDiag for AD Health"
    $dcdiagResult = dcdiag /c /v /f:dcdiag.log

    if ($dcdiagResult -ne 0) {
        Write-Output "DCDiag found issues. Checking log for common issues"
        $logContent = Get-Content -Path "dcdiag.log"
        
        if ($logContent -match "The server holding the PDC role is down") {
            Write-Output "PDC role is down. Attempting to transfer the PDC role"
            Move-ADDirectoryServerOperationMasterRole -Identity (Get-ADDomainController).Name -OperationMasterRole PDCEmulator -Force
        }
        
        if ($logContent -match "FSMO role holders may not be up to date") {
            Write-Output "FSMO role holders are not up to date. Attempting to seize roles"
            foreach ($role in (Get-ADForest).SchemaMaster, (Get-ADForest).DomainNamingMaster, (Get-ADDomain).InfrastructureMaster, (Get-ADDomain).RIDMaster, (Get-ADDomain).PDCEmulator) {
                Move-ADDirectoryServerOperationMasterRole -Identity (Get-ADDomainController).Name -OperationMasterRole $role -Force
            }
        }
    } else {
        Write-Output "No AD Health issues found."
    }
}


function Test-And-Fix-ReplicationHealth {
    Write-Output "Running RepAdmin for Replication Health"
    $repadminResult = repadmin /replsummary

    if ($repadminResult -match "FAIL") {
        Write-Output "Replication issues found. Attempting to resolve"
        repadmin /syncall /AdeP
    } else {
        Write-Output "No Replication Health issues found."
    }
}


function Test-And-Fix-DNSHealth {
    Write-Output "Running DCDiag for DNS Health"
    $dnsResult = dcdiag /test:DNS /e /v /f:dnsdiag.log

    if ($dnsResult -ne 0) {
        Write-Output "DNS issues found. Checking the log for common issues"
        $dnsLogContent = Get-Content -Path "dnsdiag.log"
        
        if ($dnsLogContent -match "The DNS server is unavailable") {
            Write-Output "DNS server is unavailable. Attempting to restart DNS server"
            Restart-Service -Name "DNS"
        }
        
        if ($dnsLogContent -match "The A record for this DC was not found") {
            Write-Output "A record for this DC was not found. Attempting to register DNS records"
            ipconfig /registerdns
        }
    } else {
        Write-Output "No DNS Health issues found."
    }
}


Write-Output "Starting AD, Replication, and DNS Health Checks"

Test-And-Fix-ADHealth
Test-And-Fix-ReplicationHealth
Test-And-Fix-DNSHealth

Write-Output "Health Checks Complete. Please check the output for manual actions required."
