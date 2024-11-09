# Define the IP addresses for Modem, ISP, and DNS
$addresses = @{
    "Gateway" = "10.0.1.1"  # This will be updated later if needed, or override auto-determination by entering your own.
    "Server" = "10.0.1.35"
    "ISP" = "bbc.co.uk"  # This will be updated later if needed, or override auto-determination by entering your own.
    "DNS" = "8.8.8.8"
}

# Function to determine the first IP outside the local network and the last private IP as the Gateway
function Get-FirstIPOutsideLocalNetwork {
    param (
        [string]$target
    )

    $localIPPattern = '^(192\.168|10\.|172\.1[6-9]|172\.2[0-9]|172\.3[0-1])\.'
    $ISP = $null
    $Gateway = $null
    $lastPrivateIP = $null

    Write-Host "Determining first IP outside local network and Gateway IP."

    # Run tracert and capture the output directly
    $tracerouteOutput = tracert -d $target

    foreach ($line in $tracerouteOutput) {
        if ($line -match '(\d{1,3}\.){3}\d{1,3}') {
            $ip = [regex]::Match($line, '(\d{1,3}\.){3}\d{1,3}').Value

            if ($ip -match $localIPPattern) {
                $lastPrivateIP = $ip
            }

            if ($ip -notmatch $localIPPattern -and $ip -ne $target) {
                $ISP = $ip
                if ($lastPrivateIP) {
                    $Gateway = $lastPrivateIP
                }
                break
            }
        }
    }

    Write-Host "The first IP outside of the local network is: $ISP"
    Write-Host "The Gateway IP address is: $Gateway"
    return @{ ISP = $ISP; Gateway = $Gateway }
}

# Update the Gateway and ISP addresses only if they are "0.0.0.0"
if ($addresses["Gateway"] -eq "0.0.0.0" -or $addresses["ISP"] -eq "0.0.0.0") {
    $results = Get-FirstIPOutsideLocalNetwork -target "8.8.8.8"
    if ($addresses["Gateway"] -eq "0.0.0.0") {
        $addresses["Gateway"] = $results.Gateway
    }
    if ($addresses["ISP"] -eq "0.0.0.0") {
        $addresses["ISP"] = $results.ISP
    }
}

# Example: Print the addresses to verify
$addresses.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }

# Your additional script logic can go here

# Example: Print the addresses to verify
$addresses.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }

# Initialize counters and statistics
$successfulPings = @{}
$unsuccessfulPings = @{}
$pingTimes = @{}
$unsuccessfulPingDetails = @()
$pingCount = 0
foreach ($name in $addresses.Keys) {
    $successfulPings[$name] = 0
    $unsuccessfulPings[$name] = 0
    $pingTimes[$name] = @()
}
$exitLoop = $false

# Define a script block to handle the Escape key press
$scriptBlock = {
    if ([System.Console]::KeyAvailable) {
        $key = [System.Console]::ReadKey($true)
        if ($key.Key -eq [System.ConsoleKey]::Escape) {
            $true
        } else {
            $false
        }
    } else {
        $false
    }
}

# Function to calculate statistics
function Calculate-Statistics {
    param (
        [float[]]$times
    )
    if ($times.Count -gt 0) {
        $lowest = $times | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
        $average = $times | Measure-Object -Average | Select-Object -ExpandProperty Average
        $highest = $times | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    } else {
        $lowest = 0
        $average = 0
        $highest = 0
    }

    return [pscustomobject]@{
        Lowest = "{0:N2}" -f $lowest
        Average = "{0:N2}" -f $average
        Highest = "{0:N2}" -f $highest
    }
}

# Create a Ping object
$ping = New-Object System.Net.NetworkInformation.Ping

# Loop to ping addresses every second
while (-not $exitLoop) {
    $pingCount++
    $output = @()
    foreach ($name in $addresses.Keys) {
        $address = $addresses[$name]
        $pingResult = $ping.Send($address)
        if ($pingResult.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
            $successfulPings[$name]++
            $pingTime = $pingResult.RoundtripTime
            $pingTimes[$name] += "${pingCount}:$pingTime"
            if ($pingTimes[$name].Count -gt 100) {
                $pingTimes[$name] = $pingTimes[$name][-100..-1]
            }
            $output += "Ping to $name ($address) successful: $pingTime ms"
        } else {
            $unsuccessfulPings[$name]++
            $output += "Ping to $name ($address) failed: Status - $($pingResult.Status)"
            $unsuccessfulPingDetails += "Ping $pingCount to $name ($address) failed: Status - $($pingResult.Status)"
        }
    }

    # Calculate and display statistics
    $output += "Pinging addresses every second. Press Escape to stop."
    $output += "" # Add a blank line
    foreach ($name in $addresses.Keys) {
        $stats = Calculate-Statistics -times ($pingTimes[$name].ForEach({ $_.Split(':')[1] }))
        $output += "${name}: $($addresses[$name])"
        $output += "Successful Pings: $($successfulPings[$name])"
        if ($unsuccessfulPings[$name] -eq 0) {
            $output += "Unsuccessful Pings: $($unsuccessfulPings[$name]) (Green)"
        } else {
            $output += "Unsuccessful Pings: $($unsuccessfulPings[$name]) (Red)"
        }
        $last30PingTimes = $pingTimes[$name][-30..-1]
        $output += "Raw Ping Times (last 30):"
        foreach ($pingTime in $last30PingTimes) {
            $parts = $pingTime -split ":"
            $output += "$($parts[0]):$($parts[1])"
        }
        $output += "" # Ensure a blank line separates raw ping times from lowest ping time
        $output += "Lowest Ping Time: $($stats.Lowest) ms"
        $output += "Average Ping Time: $($stats.Average) ms"
        $output += "Highest Ping Time: $($stats.Highest) ms"
        $output += ""
    }

    # Display the output
    Clear-Host
    foreach ($line in $output) {
        if ($line -match "^Gateway:|^Modem:|^ISP:|^DNS:") {
            Write-Host $line -ForegroundColor White
        } elseif ($line -match "Unsuccessful Pings:.*\(Green\)$") {
            Write-Host ($line.Replace(" (Green)", "")) -ForegroundColor Green
        } elseif ($line -match "Unsuccessful Pings:.*\(Red\)$") {
            Write-Host ($line.Replace(" (Red)", "")) -ForegroundColor Red
        } elseif ($line -match "Raw Ping Times \(last 30\):") {
            Write-Host "Raw Ping Times (last 30):" -NoNewline
        } elseif ($line -match "^\d+:\d+.*$") {
            $parts = $line -split ":"
            Write-Host " " -NoNewline
            Write-Host $parts[0] -ForegroundColor Blue -NoNewline
            Write-Host ":" -ForegroundColor Blue -NoNewline
            Write-Host $parts[1] -ForegroundColor Gray -NoNewline
        } else {
            Write-Host $line
        }
    }

    Start-Sleep -Seconds 1

    # Check for Escape key press
    $exitLoop = & $scriptBlock
}

# Prompt for a filename to save the final statistics
$filename = Read-Host "Enter the filename to save the final statistics (e.g., ping_results.txt)"
$filepath = Join-Path -Path (Get-Location) -ChildPath $filename

# Collect final statistics
$finalStatistics = @()
foreach ($name in $addresses.Keys) {
    $stats = Calculate-Statistics -times ($pingTimes[$name].ForEach({ $_.Split(':')[1] }))
    $finalStatistics += "${name}: $($addresses[$name])"
    $finalStatistics += "Successful Pings: $($successfulPings[$name])"
    $finalStatistics += "Unsuccessful Pings: $($unsuccessfulPings[$name])"
    $finalStatistics += "Raw Ping Times: " + ($pingTimes[$name] -join " ")
    $finalStatistics += "Lowest Ping Time: $($stats.Lowest) ms"
    $finalStatistics += "Average Ping Time: $($stats.Average) ms"
    $finalStatistics += "Highest Ping Time: $($stats.Highest) ms"
    $finalStatistics += ""
}

# Append unsuccessful ping details
$finalStatistics += "Unsuccessful Ping Details:"
foreach ($detail in $unsuccessfulPingDetails) {
    $finalStatistics += $detail
}

# Display and save the final statistics
$finalStatistics | Out-File -FilePath $filepath -Encoding UTF8
Write-Output "Final Statistics saved to $filepath"
$finalStatistics | ForEach-Object { Write-Output $_ }
Write-Output "Script terminated."

start-sleep -s 999