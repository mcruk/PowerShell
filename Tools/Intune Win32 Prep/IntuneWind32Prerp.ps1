$InputFolder = "A:\Intune Win32 Prep\Input"

$OutputFolder = "A:\Intune Win32 Prep\Output"

$IntuneWinAppUtil = "A:\Intune Win32 Prep\Dependencies\Microsoft-Win32-Content-Prep-Tool-master\IntuneWinAppUtil.exe"


$Files = Get-ChildItem -LiteralPath $InputFolder -Recurse -Include *.exe, *.msi


if ($Files.Count -eq 0) {
    Write-Host "No .exe or .msi files found."
    exit
}


if ($Files.Count -eq 1) {
    $DesiredExeMsi = $Files[0].FullName
	Start-Process "$($IntuneWinAppUtil)" -ArgumentList "-c `"$InputFolder`" -s `"$DesiredExeMsi`" -o `"$OutputFolder`"" -Wait
    Write-Host "All Done, open the output folder"
	Start-Sleep -s 30
    exit
}




$SelectedIndex = 0

function DisplayFiles {
    Clear-Host
    Write-Host "Select a file using the arrow keys and press Enter:"
    for ($i = 0; $i -lt $Files.Count; $i++) {
        if ($i -eq $SelectedIndex) {
            Write-Host "  > $($Files[$i].FullName)" -ForegroundColor Green
        } else {
            Write-Host "    $($Files[$i].FullName)"
        }
    }
}


[void][System.Console]::KeyAvailable
while ($true) {
    DisplayFiles

    $key = [System.Console]::ReadKey($true)

    switch ($key.Key) {
        'UpArrow' {
            if ($SelectedIndex -gt 0) {
                $SelectedIndex--
            }
        }
        'DownArrow' {
            if ($SelectedIndex -lt ($Files.Count - 1)) {
                $SelectedIndex++
            }
        }
        'Enter' {
            $DesiredExeMsi = $Files[$SelectedIndex].Name
			
			Start-Process "$($IntuneWinAppUtil)" -ArgumentList "-c `"$InputFolder`" -s `"$DesiredExeMsi`" -o `"$OutputFolder`"" -Wait
			Clear-Host
			Write-Host "All Done, open the output folder"
			Start-Sleep -s 30
			exit
        }
    }
}



