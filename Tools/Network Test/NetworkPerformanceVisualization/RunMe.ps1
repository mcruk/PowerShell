<# This module can be manually installed by downloading the repo and copying the Network-Performance-Visualization folder to:

%USERPROFILE%\Documents\WindowsPowershell\Modules for PowerShell 5.1
%USERPROFILE%\Documents\Powershell\Modules for PowerShell Core #>


$moduleName = "Network-Performance-Visualization"
$module = Get-Module -ListAvailable -Name $moduleName

if (-not $module) {
    Write-Output "$moduleName is not installed. Installing..."
    try {
        Install-Module -Name $moduleName -Force -Scope CurrentUser
        Write-Output "$moduleName has been installed successfully."
    } catch {
        Write-Error "Failed to install $moduleName. Error: $_"
    }
} 


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






$options = "CTST", "Latte", "NTTCP"
$selection = Menu $options "Which data output program do you want to Graph?:"
$ToDo = Switch ($selection) {
    "CTST" {"1";break}
	"Latte" {"2";break}
    "NTTCP" {"3";break}
}
Clear-Host



if($ToDo -eq "1"){
	
	New-NetworkVisualization -CTStraffic -BaselineDir "$($dl)\Network Test\CTST\Output\" -SavePath "$($dl)\Network Test\NetworkPerformanceVisualization\CTST\CTST.xlsx" -InnerPivot Sessions 
	
}


if($ToDo -eq "2"){
	
	New-NetworkVisualization -LATTE -BaselineDir "$($dl)\Network Test\Latte\Output\" -SavePath "$($dl)\Network Test\NetworkPerformanceVisualization\Latte\Latte.xlsx"  
	
}

if($ToDo -eq "3"){
	
	New-NetworkVisualization -NTTTCP -BaselineDir "$($dl)\Network Test\NTTCP\Output\" -SavePath "$($dl)\Network Test\NetworkPerformanceVisualization\NTTCP\NTTCP.xlsx" 
	
}


Write-Host "All Done"

start-sleep -s 999


<# Get-Help New-NetworkVisualization

New-NetworkVisualization -CTStraffic -BaselineDir C:\Users\pp\Desktop\#TEMP\cts -SavePath C:\Users\pp\Desktop\#TEMP\pp1.xlsx -InnerPivot Sessions 


New-NetworkVisualization -CTStraffic -BaselineDir "$($dl):\Network Test\CTST\Output\" -SavePath C:\Users\pp\Desktop\#TEMP\pp1.xlsx -InnerPivot Sessions 





New-NetworkVisualization -NTTTCP [-BaselineDir <String>] [-BaselineDatasetName <String>] [-TestDir <String>] [-TestDatasetName <String>] [-JsonInputPath <String>] [-InnerPivot <String>] [-OuterPivot <String>] 
[-SavePath <String>] [-JsonSavePath <String>] [-Warmup <Int32>] [-Cooldown <Int32>] [-NoExcel] [<CommonParameters>]

New-NetworkVisualization -LATTE [-NumHistogramBuckets <Int32>] [-BaselineDir <String>] [-BaselineDatasetName <String>] [-TestDir <String>] [-TestDatasetName <String>] [-JsonInputPath <String>] [-InnerPivot <String>] 
[-OuterPivot <String>] [-SavePath <String>] [-JsonSavePath <String>] [-Warmup <Int32>] [-Cooldown <Int32>] [-SubsampleRate <Int32>] [-NoExcel] [<CommonParameters>]

New-NetworkVisualization -CTStraffic [-BaselineDir <String>] [-BaselineDatasetName <String>] [-TestDir <String>] [-TestDatasetName <String>] [-JsonInputPath <String>] [-InnerPivot <String>] [-OuterPivot <String>] 
[-SavePath <String>] [-JsonSavePath <String>] [-Warmup <Int32>] [-Cooldown <Int32>] [-NoExcel] [<CommonParameters>]

New-NetworkVisualization -CPS [-BaselineDir <String>] [-BaselineDatasetName <String>] [-TestDir <String>] [-TestDatasetName <String>] [-JsonInputPath <String>] [-InnerPivot <String>] [-OuterPivot <String>] [-SavePath 
<String>] [-JsonSavePath <String>] [-Warmup <Int32>] [-Cooldown <Int32>] [-SubsampleRate <Int32>] [-NoExcel] [<CommonParameters>]

New-NetworkVisualization -LagScope [-NumHistogramBuckets <Int32>] [-BaselineDir <String>] [-BaselineDatasetName <String>] [-TestDir <String>] [-TestDatasetName <String>] [-JsonInputPath <String>] [-InnerPivot 
<String>] [-OuterPivot <String>] [-SavePath <String>] [-JsonSavePath <String>] [-Warmup <Int32>] [-Cooldown <Int32>] [-SubsampleRate <Int32>] [-NoExcel] [<CommonParameters>] #>