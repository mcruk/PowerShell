function Check-ClusterHealth {
    
    $clusterName = (Get-Cluster).Name
    $output = "Checking health for cluster: $clusterName`n"

    $output += "`nCluster Node Health Status:`n"
    $output += (Get-ClusterNode | Format-Table Name, State, DrainStatus, QuarantineStatus -AutoSize | Out-String)

    $clusterHealth = Get-Cluster | Select-Object -ExpandProperty DynamicQuorumEnabled
    $output += "`nDynamic Quorum Enabled: $clusterHealth`n"

    $clusterHealthReport = Test-Cluster -WarningAction SilentlyContinue
    if ($clusterHealthReport.IsHealthy) {
        $output += "Cluster Health: Healthy`n"
    } else {
        $output += "Cluster Health: Issues detected!`n"
        $output += ($clusterHealthReport | Format-Table Name, HealthStatus -AutoSize | Out-String)
    }

    return $output
}


function Get-VMsOnNodes {
    $output = "`nVMs running on each node:`n"

    $clusterNodes = Get-ClusterNode
    foreach ($node in $clusterNodes) {
        $output += "`nNode: $($node.Name)`n"
        $vms = Get-VM -ComputerName $node.Name
        if ($vms.Count -eq 0) {
            $output += "No VMs running on this node.`n"
        } else {
            $output += ($vms | Format-Table Name, State, CPUUsage, MemoryAssigned, Uptime -AutoSize | Out-String)
        }
    }

    return $output
}



function Send-Email {
    param (
        [string]$Subject,
        [string]$Body
    )

    # Email parameters
    $smtpServer = "" # Replace with your SMTP server
    $smtpFrom = ""      # Replace with your from address
    $smtpTo = ""        # Replace with the recipient email
    $smtpPort = 25                         # SMTP port (e.g., 587 for TLS or 25 for non-secure)
    $smtpUser = ""   # SMTP username for authentication
    $smtpPass = ""              # SMTP password for authentication

    # Send the email
    Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $Subject -Body $Body -SmtpServer $smtpServer -Port $smtpPort -UseSsl
}


Write-Host "Starting Hyper-V Cluster Health Check..." -ForegroundColor Green


$clusterHealthOutput = Check-ClusterHealth
$vmsOutput = Get-VMsOnNodes

$emailBody = $clusterHealthOutput + "`n" + $vmsOutput

Send-Email -Subject "Hyper-V Cluster Health Report" -Body $emailBody

Write-Host "`nHealth check completed and email sent." -ForegroundColor Green