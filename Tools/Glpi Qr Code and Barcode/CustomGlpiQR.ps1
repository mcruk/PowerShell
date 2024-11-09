$pdfFilePath = "Glpi Qr Code\input\"
$popplerRoot = "Glpi Qr Code\output\image"
$outputDirectory = "Glpi Qr Code\output\"
$zxingDllPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Zxing\zxing.dll"
$pdfImageExe = "Glpi Qr Code\dependencies\poppler\Library\bin\pdfimages.exe"
$outputCsvPath = "Glpi Qr Code\output\QRCodeResults.csv"

$outputCsvPath = "Glpi Qr Code\output\QRCodeResults.csv"
$outputHtmlPath = "Glpi Qr Code\output\GeneratedQRCodes.html"
$qrCoderDllPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\QRCoder\QRCoder.dll"

function Get-Code128String {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $Text,

        # Code Type. Not a char because hash lookup below will not work.
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("A", "B", "C")]
        [string] $Type
    )
    
    begin {
        # Codes represent values used to calculate checksum.
        $CODES = 32..126 + 195..206
        switch ($Type) {
            'A' { $Output = [char][byte]203; $ProductSum = 103; break }
            'B' { $Output = [char][byte]204; $ProductSum = 104; break }
            'C' { $Output = [char][byte]205; $ProductSum = 105; break }
        }
        Write-Debug "Test $Output" 
    }
    
    process {
        for ($i = 0; $i -lt $($Text.Length); $i++)
        {
            $Output += $Char = $Text[$i]
            
            # Ensure our input is allowed in this codeset.
            if (-not (Test-Code128Value $Char -Type $Type)) {
                throw "Value `"$Char`" not allowed in Codeset $Type"
            }

            $UnicodeValue = [byte][char]$Char - 32
            $ProductSum += $UnicodeValue * ($i + 1)
            Write-Debug "Unicode value for $Char is $UnicodeValue"
        }
    }
    
    end {
        $Checksum = $ProductSum % 103
        Write-Debug "ProductSum: $ProductSum"
        Write-Debug "Checksum: $Checksum"

        $Output += [char][byte]$CODES[$Checksum]
        $Output += [char][byte]206  # Stop code

        return $Output
    }
}


function Test-Code128Value {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        # Code Type. Not a char because hash lookup below will not work.
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("A", "B", "C")]
        [string] $Type  
    )
    
    # Covers 0-9, A-Z, control codes, special characters, and FNC 1-4
    [byte[]] $CodeSetA = 0..95 + @(202, 197, 196, 201)
    
    # Covers 0-9, A-Z, a-z, special characters, and FNC 1-4
    [byte[]] $CodeSetB = 32..127 + @(207, 202, 201, 205)

    $IsValid = $True
    switch($Type) {
        'A' { if (-not $CodeSetA.Contains([byte][char]$Value)) { $IsValid = $False }; break}
        'B' { if (-not $CodeSetB.Contains([byte][char]$Value)) { $IsValid = $False }; break}
        'C' { if (-not [char]::IsDigit($Value)) { $IsValid = $False }; break}
    }
    return $IsValid
}

if (Test-Path $outputDirectory) {

    $files = Get-ChildItem -LiteralPath $outputDirectory -File


    foreach ($file in $files) {
        Remove-Item $file.FullName -Force
    }

    Write-Host "Output folder cleared"

}



$pdfFiles = Get-ChildItem -LiteralPath $pdfFilePath -Filter *.pdf


foreach ($pdf in $pdfFiles) {

    start-process $pdfImageExe -ArgumentList "-all `"$($pdf.FullName)`" `"$($popplerRoot)`"" -wait -Verb RunAs

    $jpgFiles = Get-ChildItem -LiteralPath $outputDirectory -Filter "*.jpg"

    foreach ($file in $jpgFiles) {

        $randomName = [System.Guid]::NewGuid().ToString().Replace("-", "")
    
        $newFileName = "$randomName.jpg"
    
        while (Test-Path $newFileName) {
            $randomName = [System.Guid]::NewGuid().ToString().Replace("-", "")
            $newFileName = "$randomName.jpg"
        }
    
        Rename-Item -Path $file.FullName -NewName $newFileName
    }



}


Add-Type -Path $zxingDllPath

$qrCodeResults = @()

$imageFiles = Get-ChildItem -LiteralPath $outputDirectory -Filter *.jpg

function Decode-QRCode {
    
    param(
        [string]$imagePath
    )

    $bitmap = [System.Drawing.Bitmap]::FromFile($imagePath)

    $barcodeReader = New-Object ZXing.BarcodeReader

    try {
        $result = $barcodeReader.Decode($bitmap)
        return $result.Text
    } catch {
        return $null
    }

}


foreach ($image in $imageFiles) {

    $imagePath = $image.FullName
    $qrCodeData = Decode-QRCode -imagePath $imagePath

    $qrCodeResults += [PSCustomObject]@{
        ImageName   = $image.Name
        QRCodeData  = $qrCodeData
    }
}


$qrCodeResults | Export-Csv -Path $outputCsvPath -NoTypeInformation


Add-Type -Path $qrCoderDllPath

$csvData = Import-Csv -Path $outputCsvPath

$qrGenerator = New-Object QRCoder.QRCodeGenerator

$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .label {
            width: 57mm;
            height: 32mm;
            display: inline-block;
            margin: 5mm;
            text-align: center;
            border: 1px solid #000;
            box-sizing: border-box;
            page-break-inside: avoid;
        }
        img {
            max-width: 100%;
            max-height: 70%; /* Leave space for text */
        }
        .inventory-number {
            font-size: 10pt;
            font-weight: bold;
        }
        .item-name {
            font-size: 10pt;
            font-weight: bold;
        }
		.bcode {
            font-size: 10pt;
			font-family: "Libre Barcode 128", system-ui;
			font-weight: 400;
			font-size: 25px;
        }
    </style>
    <title>Generated QR Codes</title>
</head>
<script>
	window.onload = function() {
		// Automatically run sorting once the page is fully loaded
		sortDivs('alphabetic'); // You can change 'numeric' to 'alphabetic' for default alphabetical sorting

		// Function to sort divs based on the provided sortType
		function sortDivs(sortType) {
			const container = document.getElementById('container');
			const divs = Array.from(container.getElementsByClassName('label'));

			// Sorting logic
			divs.sort((a, b) => {
				const textA = a.querySelector('.item-name').textContent;
				const textB = b.querySelector('.item-name').textContent;

				if (sortType === 'numeric') {
					return parseFloat(textA) - parseFloat(textB); // Numeric sorting
				} else if (sortType === 'alphabetic') {
					return textA.localeCompare(textB); // Alphabetical sorting
				}
			});

			// Remove existing divs
			container.innerHTML = '';

			// Append sorted divs
			divs.forEach(div => {
				container.appendChild(div);
			});
		}
	};
</script>
<body id="container">
"@


foreach ($row in $csvData) {

    $qrCodeData = $row.QRCodeData


    if (-not [string]::IsNullOrWhiteSpace($qrCodeData)) {

        $qrCodeDataObject = $qrGenerator.CreateQrCode($qrCodeData, [QRCoder.QRCodeGenerator+ECCLevel]::Q)
        $qrCode = New-Object QRCoder.QRCode -ArgumentList $qrCodeDataObject
        $qrBitmap = $qrCode.GetGraphic(20)  # Generate a 20x scale QR code bitmap

        $imageStream = New-Object System.IO.MemoryStream
        $qrBitmap.Save($imageStream, [System.Drawing.Imaging.ImageFormat]::Png)
        $base64Image = [Convert]::ToBase64String($imageStream.ToArray())
		
		
		$qrCodeDataObject2 = $qrGenerator.CreateQrCode("$($qrCodeData -match 'URL = (.*)' | Out-Null; $matches[1])", [QRCoder.QRCodeGenerator+ECCLevel]::Q)
        $qrCode2 = New-Object QRCoder.QRCode -ArgumentList $qrCodeDataObject2
        $qrBitmap2= $qrCode2.GetGraphic(20)  # Generate a 20x scale QR code bitmap

        $imageStream2 = New-Object System.IO.MemoryStream
        $qrBitmap2.Save($imageStream2, [System.Drawing.Imaging.ImageFormat]::Png)
        $base64Image2 = [Convert]::ToBase64String($imageStream2.ToArray())
		
	
		$128Code = Get-Code128String "$($qrCodeData -match 'Inventory number = (.*)' | Out-Null; $matches[1])" -Type 'A'
		
		#<div class="inventory-number">$($qrCodeData -match 'Inventory number = (.*)' | Out-Null; $matches[1])</div>
        $htmlContent += @"
        <div class="label">
            <img src="data:image/png;base64,$base64Image" alt="QR Code">
			<img src="data:image/png;base64,$base64Image2" alt="QR Code">
            <div class="item-name">$($qrCodeData -match 'Item Name = (.+)' | Out-Null; $matches[1])</div>
			<div class="bcode">$128Code</div>
        </div>
"@

        # Clean up
        $qrBitmap.Dispose()
        $imageStream.Dispose()

    }

}


$htmlContent += @"
</body>
</html>
"@


Set-Content -Path $outputHtmlPath -Value $htmlContent -Encoding UTF8





$htmlFiles = Get-ChildItem -LiteralPath $outputDirectory -Filter *.html
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

foreach ($file in $htmlFiles) {
    Start-Process $chromePath $file.FullName
}





Write-Output "All Done"



Start-Sleep -s 999

#DYMO LabelWriter 450
#11354 labels
#57 mm x 32 mm