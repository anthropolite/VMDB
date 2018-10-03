# Set path to Script Files

$global:path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$global:stig_path = "$path\..\STIGS"
$stigarchive = $global:path

# get location of the STIG Archive

while (-not (test-path $stigArchive -PathType leaf) -and ($stigArchive -notlike "*.zip"))
{
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
$Filter = '*_Manual-xccdf.xml'

# load ZIP methods
Add-Type -AssemblyName System.IO.Compression.FileSystem

# open ZIP archive for reading
$zip = [System.IO.Compression.ZipFile]::OpenRead($StigArchive)

# find all files in ZIP that match the filter (i.e. file extension)
$files=$zip.Entries | Where-Object { $_.FullName -like $Filter }

  ForEach($file in $files){ 
    # extract the selected items from the ZIP archive
    # and copy them to the out folder

    $FileName = $_.Name
    
    write-host "Extracting $filename to $stig_path"
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$stig_path\$FileName", $true)
    }

# close ZIP file
$zip.Dispose()