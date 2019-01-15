# Set path to Script Files

$global:path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$global:stig_path = "$path\..\STIGS"

# Read properties files

Get-Content "$path\properties.txt" | 
    ForEach-Object { $var = $_.split('=') 
        New-Variable -name $var[0] -scope global -Value $var[1]}                                 

#Load function Files

Import-Module "$path\functions\SQL_Functions.psm1"

$commonsqlParams="-ServerInstance $sqlsvr\$sqlinst -Database $commondb"

# Get stigs

$stigs = Get-ChildItem -path $global:stig_path

foreach ($stig in $stigs) {

    $stg=[xml](Get-Content -path $stig.FullName)

    #set Input variables

    $version=$stg.Benchmark.version
    $classification="Unclass"
    $filename=$stig.Name
    $releaseinfo=$stg.Benchmark.'plain-text'.'#text'
    $title=$stg.Benchmark.title
    $stigid=$ckl.Benchmark.id
    $desc=$stg.Benchmark.description

    #Get list of STIIGS for this host

    write-host "filename length is $($filename.length)"
    write-host "releaseinfo length is $($releaseinfo.length)"
    write-host "title length is $($title.length)"
    write-host "desc length is $($desc.length)"

    $query = "insert into $global:commondb.DBO.ingest_stigs(version,classification,filename,title,releaseinfo,stigid,description)
                values($version,'$classification','$filename','$title','$releaseinfo','$stigid','$desc')"

    Invoke-Sqlcmd -ServerInstance $sqlsvr\$sqlinst -Database $commondb -Query $query

    write-host "added $($stig.name) to Ingest_stig table"
}
    
