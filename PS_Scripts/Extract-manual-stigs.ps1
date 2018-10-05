# Set path to Script Files

$global:path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$global:stig_extract_path = "$env:systemdrive\tmp\STIG-extraction"
$global:stig_path = "$path\..\STIGS"
$stigarchive = $global:path
$date=get-date -format yyyyMMdd

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

Write-host "Backing up $stigarchive to $stigarchive.$date"

Copy-Item $stigarchive -Destination $stigarchive.$date

Write-host "Begin expanding STIG Archive"

While ($zipfiles -ne $null){

    foreach ($archive in $zipfiles){
        
        # extractiarchiveZIP archive
        if ($archive.fullname -eq $null){
            expand-Archive -literalpath $archive -DestinationPath $global:stig_extract_path -ErrorAction SilentlyContinue -ErrorVariable errors
        }else{
            $zip=$archive.fullname
            expand-Archive -literalpath $zip -destinationpath $archive.directoryname  -ErrorAction SilentlyContinue -ErrorVariable errors
        }      

        $errors | out-file "$path\..\logs\extract-manual-stigs-errors.$date.log" -Append
    
    }

    foreach ($archive in $zipfiles){
        write-host "Deleting $archive from $($archive.directoryname)"
        remove-item -LiteralPath $archive
    }

    # find all files in ZIP that match the filter (i.e. file extension)
    $zipfiles = Get-ChildItem -path $global:stig_extract_path -Include *.zip -Recurse
    
}

write-host "Finished extracting Stig Achrive.  checking for errors:"

$file = get-content "$path\..\logs\extract-manual-stigs-errors.$date.log"

$containserrors = $file | where {$_ -match $StigFilter}

if ($containserrors -contains $true){
    write-host "Not all $StigFilter files were properly extracted." -ForegroundColor red
    write-host "Check $path\..\logs\extract-manual-stigs-errors.$date.log for additional details" -ForegroundColor red
    Write-host "Terminating the script" -ForegroundColor red
    exit
}else{
    write-host "All $StigFilter were properly extracted from the STIG Archive" -ForegroundColor green
}

write-host "Start transfering $StigFilter files to $stig_path"

Get-ChildItem -path $global:stig_extract_path -Include $StigFilter -Recurse | move-item -Destination $global:stig_path -ErrorAction SilentlyContinue -ErrorVariable errors

if ($errors -eq $null){
    write-host "All *$StigFilter files successfully moved to $stig_path" -ForegroundColor Green\
    write-host "Deleting $stig_extract_path"
    Remove-Item $stig_extract_path -Recurse
}else{
    $files= Get-ChildItem $stig_extract_path -Include $StigFilter -recurse
    write-host "The following $StigFilter files were not moved to $stig_path" -ForegroundColor Red
    foreach ($file in $files){
        Write-Host "   $file.name" -ForegroundColor Red
    }
    write-host "The above may be duplicate files. Please review $stig_path" -ForegroundColor Red
}