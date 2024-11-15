﻿#this page contains all the shared functions and modules

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}

function display($msg,$type = "Information"){
    if($type -eq "Error"){
        $color="Red"
    }elseif($type -eq "Warning" -or $type -eq "Status"){
        $color="Yellow"
    }else{
        $color="Green"
    }

    $msgNew=translate $msg
    
    if($type -eq "Error" -or $type -eq "Status" -or $type -eq "Success"){
        if ($global:flagError -eq $false -or $type -ne "Success"){
            write-host $msgNew -ForegroundColor $color
        }
        $global:progressStatus.Visible=$false
        if($type -eq "Success"){
            if ($global:flagError -eq $false){
                $global:successLabel.Text=$msgNew
                $global:successLabel.Visible=$true
                $global:progressBar.Visible=$false
                $global:errorLabel.Visible=$false
            }          
        }elseif($type -eq "Error"){
            $global:errorLabel.Text=$msgNew
            $global:errorLabel.Visible=$true
            $global:successLabel.Visible=$false
            $global:progressBar.Visible=$false
            $global:flagError=$true
        }elseif($type -eq "Status"){
            $global:progressStatus.Visible=$true
            $global:successLabel.Visible=$false
            $global:errorLabel.Visible=$false
            $global:progressStatus.Text="Processing $($msgNew)..."
        }
        $global:form.Refresh()
    }else{
        write-host $msgNew -ForegroundColor $color
    }

    if($type -eq "Error"){
        cd $global:currentLocation
        #exit
    }
}

function translate($text,$revert){
    if($global:systemLanguage -eq "en" -or $global:translate -eq $false){
        return $text
    }

    if($revert -eq $true){
        $toLang="en"
    }else{
        $toLang=$global:systemLanguage
    }

    $listEscape=[System.Collections.ArrayList]@()
    Select-String "\'(.*?)\'" -input $text -AllMatches | Foreach {$listEscape=@($_.matches.Value -replace "\'","")} | Out-Null
    $tmpText=$text -replace "\'(.*?)\'","X"

    $uri=$global:TranslateTokenURL+"?Subscription-Key="+$global:TranslateAccountKey
    try{
        $token=Invoke-RestMethod -Uri $uri -Method Post -ErrorAction Stop
    
        $auth="Bearer "+$token
        $header=@{Authorization=$auth}
        $fromLang="en"

        $uri=$global:TranslateURL+"?text="+[System.Web.HttpUtility]::UrlEncode($tmpText)+"&from="+$fromLang+"&to="+$toLang+"&contentType=text/plain"

        try{
            $ret=Invoke-RestMethod -Uri $uri -Method Get -Headers $header -ErrorAction Stop
            $ret=$ret.string.'#text'

            [regex]$pattern="X"
            $k=0
            $listEscape | foreach{
                $ret=$pattern.replace($ret,$listEscape[$k],$k+1)
                $k++
            }
            return $ret
        }catch{
            return $text
        }
    }catch{
        return $text
    }
}

function HideShowPageSelection($choice){
    $global:textBox31.Enabled=$choice
    $global:label31.Enabled=$choice
    $global:textBox32.Enabled=$choice
    $global:label32.Enabled=$choice
}

function actionFileBrowse($path){
    $path=getRootPath $path
    $fileBox=New-Object System.Windows.Forms.OpenFileDialog
    $fileBox.InitialDirectory=$path
    $fileBox.Filter="pdf files (*.pdf)|*.pdf"
    $fileBox.Multiselect=$true
    $fileBox.Title=translate "Select the file"
    $fileBox.CheckFileExists=$true
    
    $res=$fileBox.ShowDialog()
    if($res -eq "OK"){
        $global:textBox.Text=$fileBox.FileName
    }
}
function actionFolderBrowse($path){
    $path=getRootPath $path
    $folderBox=New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBox.RootFolder="MyComputer"
    $folderBox.SelectedPath=$path
    $folderBox.ShowNewFolderButton=$true
    $folderBox.Description=translate "Select the directory the script will search for pdf files"
    
    $res=$folderBox.ShowDialog()
    if($res -eq "OK"){
        $global:textBox.Text=$folderBox.SelectedPath
    }
}
function actionFileProcess($path){
    if($global:cli -eq $false){
        $global:progressStatus.Visible=$false
        $global:errorLabel.Visible=$false
        $global:successLabel.Visible=$false
    }
    $global:flagError=$false

    if(Test-Path -Path $path -PathType Any){
        $listInput=[System.Collections.ArrayList]@()
        if(Test-Path -Path $path -PathType Leaf){
            $listInput.Add($path) | Out-Null
        }else{
            try{
                if($global:cli -eq $false){
                    $global:recurse=$global:recurseCheckbox.Checked
                }
                if($global:recurse -eq $true){
                    Get-ChildItem -Path "$($path)\*.pdf" -Recurse | Where-Object {$_.PSIsContainer -ne $true -and $_.Name -notmatch "$($global:outName)\d*\.pdf"} -ErrorAction Stop | foreach{
                        $listInput.Add($_.FullName) | Out-Null
                    }
                }else{
                    Get-ChildItem -Path "$($path)\*.pdf" | Where-Object {$_.PSIsContainer -ne $true -and $_.Name -notmatch "$($global:outName)\d*\.pdf"} -ErrorAction Stop | foreach{
                        $listInput.Add($_.FullName) | Out-Null
                    }
                }
            }catch{
                display "Unable to list the item of the requested path!" "Error"
            }
        }
    }else{
        display "The path '$($path)' does not exist" "Error"
    }
        
    if($listInput -eq $null){
        display "Unable to list the item of the requested path!" "Error"
    }

    if(!(Test-Path -Path "$($global:currentLocation)\gswin64c.exe" -PathType Leaf)){
        display "The gswin64c.exe executable is not present in $($global:currentLocation)!" "Error"
    }

    if($global:cli -eq $false){
        $global:progressBar.Visible=$true
        $global:progressBar.Value=0
        $global:progressBar.Maximum=$listInput.Count
        if($global:modeRadio2.Checked -eq $true){
            $global:mode="m"
        }elseif($global:modeRadio1.Checked -eq $true){
            $global:mode="c"
        }elseif($global:modeRadio3.Checked -eq $true){
            $global:mode="s"
            $global:splitStart=$global:textBox31.Text
            $global:splitEnd=$global:textBox32.Text
        }
        $global:autoRotate=$global:autoRotateCheckbox.Checked
    }

    $exe="$($global:currentLocation)\gswin64c.exe"
    if($global:mode -eq "c"){
        for($i=0; $i -lt $listInput.Count; $i++){
            if($global:cli -eq $true){
                Write-Progress -Id 0 -Activity $(translate "Processing pdf files..") `
                -Status "$([math]::Round(($i/($listInput.Count)*100),2)) % - $(translate "Processing '$($listInput[$i])'...")" `
                -PercentComplete $($i/($listInput.Count)*100)
            }else{
                display "Processing $($listInput[$i])..." "Status"
            }
            $outNew=$($listInput[$i] -replace ".pdf$", "2.pdf")

            if($global:autoRotate -eq $true){
                display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dAutoRotatePages=/All`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-sOutputFile=$($outNew)`" `"$($listInput[$i])`"" "Warning"
                &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dAutoRotatePages=/All" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" "$($listInput[$i])" | Tee-Object -Variable res | Out-Null
            }else{
                display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-sOutputFile=$($outNew)`" `"$($listInput[$i])`"" "Warning"
                &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" "$($listInput[$i])" | Tee-Object -Variable res | Out-Null
            }
            
            if($res -ne "" -and $res -ne $null){
                display "Error while processing $($listInput[$i]): $($res)" "Error"
            }

            if($global:cli -eq $false){
                $global:progressBar.Value=$i+1
                $global:form.Refresh()
            }
			
			copy-item -Path "$($global:currentLocation)\$($global:outName)$($i).pdf" -destination "$($listInput[$i])" -force
			remove-item "$($global:currentLocation)\$($global:outName)$($i).pdf"

        }
    }elseif($global:mode -eq "m"){
        display "Processing files..." "Status"
        if($global:autoRotate -eq $true){
            display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dAutoRotatePages=/All`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf`" `"$($listInput -join '`" `"')`"" "Warning"
            &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dAutoRotatePages=/All" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" $listInput | Tee-Object -Variable res | Out-Null
        }else{
            display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf`" `"$($listInput -join '`" `"')`"" "Warning"
            &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" $listInput | Tee-Object -Variable res | Out-Null
        }

        if($res -ne "" -and $res -ne $null){
            display "Error while processing the merge: $($res)" "Error"
        }
    }elseif($global:mode -eq "s"){
        if (![Microsoft.VisualBasic.Information]::isNumeric($global:splitStart) -or ![Microsoft.VisualBasic.Information]::isNumeric($global:splitEnd)){
            display "The start and end page must be a number!" "Error"
        }else{
            if ($global:splitStart -gt $global:splitEnd){
                display "The end page must be greater than the start page!" "Error"
            }else{
                display "Extracting pages from file ..." "Status"
                for($i=0; $i -lt $listInput.Count; $i++){
                    if($global:cli -eq $true){
                        Write-Progress -Id 0 -Activity $(translate "Processing pdf files..") `
                        -Status "$([math]::Round(($i/($listInput.Count)*100),2)) % - $(translate "Processing '$($listInput[$i])'...")" `
                        -PercentComplete $($i/($listInput.Count)*100)
                    }else{
                        display "Processing $($listInput[$i])..." "Status"
                    }
                    $outNew=$($listInput[$i] -replace ".pdf$", "extract.pdf")

                    if($global:autoRotate -eq $true){
                        display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dAutoRotatePages=/All`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-dFirstPage=$($global:splitStart)`" `"-dLastPage=$($global:splitEnd)`" `"-sOutputFile=$($outNew)`" `"$($listInput[$i])`"" "warning"
                        &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dAutoRotatePages=/All" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-dFirstPage=$($global:splitStart)" "-dLastPage=$($global:splitEnd)" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" "$($listInput[$i])" | Tee-Object -Variable res | Out-Null
                    }else{
                        display "&`"$($global:currentLocation)\gswin64c.exe`" `"-sDEVICE=pdfwrite`" `"-dCompatibilityLevel=1.4`" `"-dPDFSETTINGS=/ebook`" `"-dNOPAUSE`" `"-dQUIET`" `"-dBATCH`" `"-dFirstPage=$($global:splitStart)`" `"-dLastPage=$($global:splitEnd)`" `"-sOutputFile=$($outNew)`" `"$($listInput[$i])`"" "warning"
                        &$exe "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dQUIET" "-dBATCH" "-dFirstPage=$($global:splitStart)" "-dLastPage=$($global:splitEnd)" "-sOutputFile=$($global:currentLocation)\$($global:outName)$($i).pdf" "$($listInput[$i])" | Tee-Object -Variable res | Out-Null
                    }
                    
                    if($res -ne "" -and $res -ne $null){
                        display "Error while splitting $($listInput[$i]): $($res)" "Error"
                    }

                    if($global:cli -eq $false){
                        $global:progressBar.Value=$i+1
                        $global:form.Refresh()
                    }
                }
            }
        }
    }
	
	
	
	
    display "The requested pdf files have been successfully processed!" "Success"
}

function getRootPath($path){
    if(Test-Path -Path $path -PathType Any){
        if(Test-Path -Path $path -PathType Leaf){
            try{
                $newPath=Split-Path -Path $path -ErrorAction Stop
            }catch{
                return $global:currentLocation
            }
            return $newPath
        }else{
            return $path
        }
    }else{
        return $global:currentLocation
    }
}

########### end registry functions

Export-ModuleMember -Function "*"