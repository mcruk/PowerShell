$path = Read-Host "Enter the folder path containing the DOCX files or leave blank to use Temp folder"


if($path -eq ""){
	$path = ".\Temp"
}

Write-Host $path

$msWord = New-Object -ComObject Word.Application

Get-ChildItem -LiteralPath $path -Filter *.doc? -ErrorAction Stop | ForEach-Object {
        $doc = $msWord.Documents.Open($_.FullName)
        $pdf_filename = "$($_.DirectoryName)\$($_.BaseName).pdf"
        $doc.SaveAs([ref] $pdf_filename, [ref] 17)
        $doc.Close() 
		remove-item $_.FullName
    }
$msWord.Quit()

Write-Host "Conversion is complete. PDF files have been saved to $path." -ForegroundColor Green


& ".\PDF Merge Compress Split\Main.ps1" -cli $true -inputDirectory $path -recurse $true -mode compress -translate $false -outName maa

Start-Sleep -s 30






