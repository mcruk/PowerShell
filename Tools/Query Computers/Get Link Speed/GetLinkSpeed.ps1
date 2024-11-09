# Import the Active Directory module
Import-Module ActiveDirectory

$ou = "OU=Test,DC=Test,DC=Test,DC=Test,DC=Test"
$outputFile = ".\LinkSpeeds.csv"



#Menu Function
function DrawMenu {
    ## supportfunction to the Menu function below
    param ($menuItems, $menuPosition, $menuTitel)
    $fcolor = $host.UI.RawUI.ForegroundColor = 'Green'
    $bcolor = $host.UI.RawUI.BackgroundColor = 'black'
    $l = $menuItems.length + 1
    cls
    $menuwidth = $menuTitel.length + 4
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) -fore $fcolor -back $bcolor
    Write-Host "`t" -NoNewLine
    Write-Host "* $menuTitel *" -fore $fcolor -back $bcolor
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) -fore $fcolor -back $bcolor
    Write-Host ""
    Write-debug "L: $l MenuItems: $menuItems MenuPosition: $menuposition"
    for ($i = 0; $i -le $l;$i++) {
        Write-Host "`t" -NoNewLine
        if ($i -eq $menuPosition) {
            Write-Host "$($menuItems[$i])" -fore $bcolor -back $fcolor
        } else {
            Write-Host "$($menuItems[$i])" -fore $fcolor -back $bcolor
        }
    }
}


#Menu Function
function Menu {
    ## Generate a small "DOS-like" menu.
    ## Choose a menuitem using up and down arrows, select by pressing ENTER
    param ([array]$menuItems, $menuTitel = "MENU")
    $vkeycode = 0
    $pos = 0
    DrawMenu $menuItems $pos $menuTitel
    While ($vkeycode -ne 13) {
        $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
        $vkeycode = $press.virtualkeycode
        Write-host "$($press.character)" -NoNewLine
        If ($vkeycode -eq 38) {$pos--}
        If ($vkeycode -eq 40) {$pos++}
        if ($pos -lt 0) {$pos = 0}
        if ($pos -ge $menuItems.length) {$pos = $menuItems.length -1}
        DrawMenu $menuItems $pos $menuTitel
    }
    Write-Output $($menuItems[$pos])
}



$options = "All Desktops", "All Laptops"
$selection = Menu $options "Choose a Computer Group:"
$ou = Switch ($selection) {
    "All Desktops" {"OU=Desktops,OU=Test,DC=Test,DC=Test,DC=Test,DC=Test";break}
    "All Laptops" {"OU=Laptops,OU=Test,DC=Test,DC=Test,DC=Test,DC=Test";break}
}
Clear-Host


$computers = Get-ADComputer -Filter * -SearchBase $ou -Property Name | Select-Object -ExpandProperty Name

$scriptBlock = {
    param ($computerName)
    
    try {
        $networkAdapters = Get-CimInstance -ComputerName $computerName -ClassName Win32_NetworkAdapter -Filter "NetConnectionStatus=2"
        
        $results = @()
        foreach ($adapter in $networkAdapters) {
            $results += [PSCustomObject]@{
                ComputerName = $computerName
                AdapterName  = $adapter.Name
                LinkSpeed    = $adapter.Speed
            }
        }
        return $results
    } catch {
        return [PSCustomObject]@{
            ComputerName = $computerName
            AdapterName  = "N/A"
            LinkSpeed    = "Error: $_"
        }
    }
}

$results = @()

foreach ($computer in $computers) {
    $results += Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $computer -ComputerName $computer -ErrorAction SilentlyContinue
}

$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Output "Saved to $outputFile"

Start-Sleep -s 60