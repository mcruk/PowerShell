Import-Module ActiveDirectory

function Check-DomainControllerStatus {
    Write-Host "Checking Domain Controller Status"
    Get-ADDomainController -Filter * | Select-Object Name, IPv4Address, Site, OperatingSystem, IsGlobalCatalog, IsReadOnly, Enabled | Format-Table -AutoSize
    Write-Host "`n"
}

function Check-ReplicationStatus {
    Write-Host "Checking Replication Status"
    Get-ADReplicationFailure -Scope Site | Select-Object Server, FirstFailureTime, LastError, ErrorMessage | Format-Table -AutoSize
    Write-Host "`n"
}

function Check-DFSReplication {
    Write-Host "Checking DFS Replication Status"
    dfsrdiag ReplicationState | Format-Table -AutoSize
    Write-Host "`n"
}

function Check-ADServices {
    Write-Host "Checking AD Services"
    $services = @('NTDS', 'DNS', 'W32Time', 'Netlogon', 'kdc')
    foreach ($service in $services) {
        Get-Service -Name $service | Select-Object Name, Status | Format-Table -AutoSize
    }
    Write-Host "`n"
}

function Check-SysvolStatus {
    Write-Host "Checking SYSVOL Status"
    Get-ADDomainController -Filter * | foreach {
        $dc = $_.Name
        $sysvol = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $dc -Filter "DeviceID='C:'" | Select-Object @{Name="DomainController";Expression={$dc}}, FreeSpace, Size
        $sysvol | Format-Table -AutoSize
    }
    Write-Host "`n"
}

function Check-DNSHealth {
    Write-Host "Checking DNS Health"
    Resolve-DnsName -Name _ldap._tcp.dc._msdcs.$((Get-ADDomain).DNSRoot) | Format-Table -AutoSize
    Write-Host "`n"
}

Write-Host "Starting Active Directory Health Check"
Write-Host "======================================="
Check-DomainControllerStatus
Check-ReplicationStatus
Check-DFSReplication
Check-ADServices
Check-SysvolStatus
Check-DNSHealth
Write-Host "Active Directory Health Check Completed!"
Write-Host "======================================="