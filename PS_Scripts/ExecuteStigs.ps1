# Set path to Script Files

$global:path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$global:stig_path = "$path\..\STIGS"

# Read properties files

Get-Content "$path\properties.txt" | 
    ForEach-Object { $var = $_.split('=') 
        New-Variable -name $var[0] -scope global -Value $var[1]}                                 

#Load function Files

Import-Module "$path\functions\SQL_Functions.psm1"

#Get list of STIIGS for this host

$query = "SELECT c.short_name,c.stigid, c.stig_title
            from $global:sitedb.DBO.Assets A
            JOIN $global:commondb.dbo.JT_MachType_STIGS b
	            on a.S_Machine_Types_PK = b.S_MachType_FK
            join $global:commondb.dbo.S_STIG_TITLES c
	            on b.S_STIGS_Titles_FK = c.Stig_Title_PK
            where a.hostname = '$env:computername'"

$global:StigList = sql_results -sqlcommand $query

#Write CKL Files in Parallel

$stigids = $global:StigList.stigid

$stigsperbatch = 2

$i=0
$j=$stigsperbatch-1
$batch=1
$date=get-date -format yyyyMMdd

while ($i -lt $stigids.count) {
    $stigbatch = $stigids[$i..$j]

    $jobname = "Batch$batch"
    start-job -name $jobname -scriptblock {
        Param ([string[]]$stigids,
               [string[]]$path,
               [string[]]$global:stig_path,
               $date)
       
        Import-Module "$path\functions\cklWriter.psm1"

        foreach ($stigid in $stigids){
            cklwriter -stigid $stigid -date $date
        }
    } -ArgumentList ($stigbatch,$path,$global:stig_path,$date)

    $batch += 1
    $i = $j + 1
    $j += $stigsperbatch

    if ($i -gt $stigids.count) {$i=$stigids.count}
    if ($j -gt $stigids.count) {$j=$stigids.count}
}

# Execute SCAP

start-job -name SCC -scriptblock {
    param ([string[]]$path)

    & $path\..\scc_5.0.1\cscc.exe } -ArgumentList ($path)

# merge SCAP with CKLS in Parallel

$xccdfs=Get-ChildItem "$env:userprofile\scc" -filter *XCCDF*.xml -recurse
$ckls=Get-ChildItem "$env:USERPROFILE\desktop\Checklists_$date" 

$cklsperbatch = 2

$i=0
$j=$cklsperbatch-1
$batch=1

while ($i -lt $ckls.count) {
    $cklsbatch = $ckls[$i..$j]

    $jobname = "Scap-Batch$batch"
    start-job -name $jobname -scriptblock {
        Param ([object[]]$cklsbatch,
               [object[]]$xccdfs
               )
       
        Import-Module "$path\functions\transferscap.psm1"

        foreach ($cklobj in $cklsbatch){
            transferscap -cklobj $cklobj -xccdfs $xccdfs
        }
    } -ArgumentList ($cklsbatch,$xccdfs)

    $batch += 1
    $i = $j + 1
    $j += $cklsperbatch

    if ($i -gt $ckls.count) {$i=$ckls.count}
    if ($j -gt $ckls.count) {$j=$ckls.count}
}

# remove variables

Get-Content "$path\properties.txt" | 
    ForEach-Object { $var = $_.split('=') 
        remove-Variable -name $var[0] -scope global}

# Unload Modules

remove-module SQL_Functions
