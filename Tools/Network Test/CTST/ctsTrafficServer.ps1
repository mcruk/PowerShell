#https://github.com/microsoft/Network-Performance-Visualization

$networkDrives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType = 4"

#UNC to Logical
foreach ($drive in $networkDrives) {
    if ($drive.ProviderName -eq "\\test\test") {
        # Output the drive letter
        $dl = $drive.DeviceID
    }
}

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






$options = "Good Starting Point", "Look for data corruption", "Look for connection establishment issues", "Measure a common UDP stream"
$selection = Menu $options "What Do You Want To Do?:"
$ToDo = Switch ($selection) {
    "Good Starting Point" {"1";break}
	"Look for data corruption" {"2";break}
    "Look for connection establishment issues" {"3";break}
	"Measure a common UDP stream" {"4";break}
}
Clear-Host


if($ToDo -eq "1"){
	
	Start-Process "$($dl)\ctsTraffic.exe" -ArgumentList "-listen:* -consoleverbosity:1" -Wait
	
}


if($ToDo -eq "2"){
	
	Start-Process "$($dl)\ctsTraffic.exe" -ArgumentList "-listen:* -consoleverbosity:1 -pattern:duplex" -Wait
	
}


if($ToDo -eq "3"){
	
	Start-Process "$($dl)\ctsTraffic.exe" -ArgumentList "-listen:* -consoleverbosity:1 -transfer:64" -Wait
	
}


if($ToDo -eq "4"){
	
	Start-Process "$($dl)\ctsTraffic.exe" -ArgumentList "-listen:* -protocol:udp -bitspersecond:25000000 -framerate:60 -bufferdepth:1 -streamlength:60 -consoleverbosity:1" -Wait
	
}

Start-Sleep -s 999








