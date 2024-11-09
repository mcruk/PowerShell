# Import the Active Directory module
Import-Module ActiveDirectory


$ou = "OU=Test,DC=Test,DC=Test,DC=Test,DC=Test"

$CSVOutput = ".\OneDriveReport.csv"


"ComputerName,ProfileName,OneDriveSize(GB)" | Out-File -FilePath $CSVOutput


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

$computers = Get-ADComputer -Filter * -SearchBase $ou | Select-Object -ExpandProperty Name

function Get-OneDriveSize {
    param (
        [string]$ComputerName
    )

    try {

        $ScriptBlock = {

            $profiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false }

            foreach ($profile in $profiles) {
                $onedrivePath = Join-Path $profile.LocalPath "OneDrive"
                
                if (Test-Path $onedrivePath) {

                    $folderSize = (Get-ChildItem -Recurse -LiteralPath $onedrivePath | Measure-Object -Property Length -Sum).Sum / 1GB
                    
                    if ($folderSize -gt 10) {

                        $result = "$env:COMPUTERNAME,$($profile.LocalPath.Split('\')[-1]),$([math]::Round($folderSize,2))"
                        $result | Out-File -Append -FilePath $using:CSVOutput
                    }
                }
            }
        }

        Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to connect to $ComputerName: $_"
    }
}


$jobs = @()
foreach ($computer in $computers) {
    $jobs += Start-Job -ScriptBlock {
        param($computer)
        Get-OneDriveSize -ComputerName $computer
    } -ArgumentList $computer
}


$jobs | ForEach-Object { 
    $_ | Wait-Job 
    $_ | Receive-Job
}


$jobs | Remove-Job

Write-Host "All Done"

Start-Sleep -s 999