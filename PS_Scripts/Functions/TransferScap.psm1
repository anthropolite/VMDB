Function TransferScap {

    $scapresults=Get-ChildItem "$env:userprofile\scc" -filter *XCCDF*.xml -recurse
    $ckls=Get-ChildItem "$env:USERPROFILE\desktop\Checklists_$date" 
    
    foreach ($ckl in $ckls){
         $cklname=$($ckl.Name.Split("."))[1] -replace "_stig",""
         $xccdf=$scapresults.name | where {$_ -like "*Results_$cklname*"}

