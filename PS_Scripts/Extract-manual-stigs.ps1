# Set path to Script Files

$global:path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$global:stig_extract_path = "$path\..\STIG-extraction"
$global:stig_path = "$path\..\STIGS"
$stigarchive = $global:path

# get location of the STIG Archive

while (-not (test-path $stigArchive -PathType leaf) -and ($stigArchive -notlike "*.zip")){
    $StigArchive = Read-host -prompt "Input the full path to the stig archive (path & filename)"
    
    if (-not (test-path $stigArchive -PathType leaf)) 
    {
        Write-Host "$stigarchive is not a file"
    } elseif ($stigArchive -notlike "*.zip") 
    {
        Write-host "$stigarchive is not a zip file.  File must end in .zip"
    }
}

# extension filter to a file extension that exists
# inside your ZIP file
$zipfiles = $stigarchive
$StigFilter = '*_Manual-xccdf.xml'
$zipfilter = '*.zip'

While ($zipfiles -ne $null){

    foreach ($archive in $zipfiles){
        
        # extractiarchiveZIP archive
        if ($archive.fullname -eq $null){
            write-host "Extracting $archive to $stig_extract_path"
            expand-Archive -literalpath $archive -DestinationPath $global:stig_extract_path
            remove-item -LiteralPath $archive
        }else{
            $zip=$archive.fullname
            write-host "Extracting $archive to $($archive.directoryname)"
            expand-Archive -literalpath $zip -destinationpath $archive.directoryname 
            remove-item -LiteralPath $archive
        }
    }

    # find all files in ZIP that match the filter (i.e. file extension)
    $zipfiles = Get-ChildItem -path $global:stig_extract_path -Include *.zip -Recurse
    
}

<#    iles){ 
            # extract the selected items from the ZIP archive
            # and copy them to the out folder
            #$subzip = [System.IO.Compression.ZipFile]::OpenRead($zip)
        
            $FileName = $zip.Name
    
            write-host "Extracting zip file $filename to $stig_path"
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($arch, "$stig_path\$FileName", $true)
        }
    
        # close ZIP file
        $zip.Dispose()
    } #>
