
$FindGroup = whoami /groups

$GetWordDocs = Get-Childitem –Path N:\ -Include *.DOCX -Recurse -ErrorAction SilentlyContinue
$GetPdfDocs = Get-Childitem –Path N:\ -Include *.PDF -Recurse -ErrorAction SilentlyContinue


if($FindGroup -match "blockallprograms-voice"){
   
    foreach($doc in $GetWordDocs){
     
        & 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE' $doc

    }

    foreach($pdf in $GetPdfDocs){
     
    & 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe' $pdf

    }

    Start-Process "C:\Program Files (x86)\Claro Software\ClaroRead SE\ClaroRead.exe"

    Exit

}



if($FindGroup -match "blockallprograms-cs"){
    
    foreach($doc in $GetWordDocs){
     
        & 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE' $doc

    }

    foreach($pdf in $GetPdfDocs){
     
    & 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe' $pdf

    }

    Exit
}



if($FindGroup -match "blockallprograms"){
    
    foreach($doc in $GetWordDocs){
     
        & 'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE' $doc

    }

    Exit
}
