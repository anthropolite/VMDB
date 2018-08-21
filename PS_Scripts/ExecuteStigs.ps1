# Set path to Script Files

$path = "$env:userprofile\workspace\vmdb\PS_Scripts"
$global:stig_path = "$env:userprofile\workspace\vmdb\STIGS"

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

# Unload Modules

remove-module SQL_Functions
