Function TransferScap {

    $scapresults=Get-ChildItem "$env:userprofile\scc" -filter *XCCDF*.xml -recurse
    $ckls=Get-ChildItem $date