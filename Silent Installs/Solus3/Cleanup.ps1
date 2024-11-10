$UserDir = "C:\Users"
$TargetFolder = "AppData\Local\VirtualStore"
$joined_path = ""

Get-ChildItem $UserDir | foreach {
    
        $joined_path = Join-Path -Path $_.FullName -ChildPath $TargetFolder

        if (Test-Path $joined_path) {
            remove-item "$($joined_path)\Program Files (x86)" -Recurse -Force
			remove-item "$($joined_path)\Windows" -Recurse -Force
			remove-item "$($joined_path)\FMS" -Recurse -Force
            }
        }
