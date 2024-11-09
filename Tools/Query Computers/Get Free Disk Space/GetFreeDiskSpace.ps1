# Import the Active Directory module
Import-Module ActiveDirectory

$ou = "OU=Test,DC=Test,DC=Test,DC=Test,DC=Test"

$outputFile = ".\FreeSpace.csv"


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
    param($computerName)

    try {
        $freeSpace = Get-WmiObject Win32_LogicalDisk -ComputerName $computerName -Filter "DeviceID='C:'" | Select-Object -ExpandProperty FreeSpace
        $freeSpaceGB = [math]::round($freeSpace / 1GB, 2)
        [PSCustomObject]@{
            ComputerName = $computerName
            FreeSpaceGB  = $freeSpaceGB
        }
    } catch {
        [PSCustomObject]@{
            ComputerName = $computerName
            FreeSpaceGB  = "Error"
        }
    }
}


$jobs = @()


foreach ($computer in $computers) {
    $jobs += Start-Job -ScriptBlock $scriptBlock -ArgumentList $computer
}


$jobs | ForEach-Object { $_ | Wait-Job }


$results = $jobs | ForEach-Object {
    $jobResult = Receive-Job -Job $_
    Remove-Job -Job $_
    $jobResult
}



$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Saved to $outputFile"