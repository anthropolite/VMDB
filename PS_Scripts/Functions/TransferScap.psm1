Function TransferScap {
    Params ([object[]] $cklobj,
            [object[]] $xccdfs
    )
    
    $cklname=$($cklobj.Name.Split("."))[1] -replace "_stig",""
    $xccdfobj=$xccdfs | where {$_.name -like "*Results_$cklname*"}
    
    if ($xccdfobj -eq $null){
        write-host "There was no SCAP results for $($cklobj.name)"
    }else{ 
        $ckl = ([xml](get-content -path "$($cklobj.fullname)"))
        $ckl.preservewhitespace = $true
         
        $xccdf = ([xml](get-content -path "$($xccdfobj.fullname)"))
        $xccdf.preservewhitespace = $true   

        $results = $xccdf.Benchmark.TestResult.'rule-result'
        $vulns = $ckl.checklist.stigs.istigs.vuln

        Foreach ($result in $results) {
            $result_rule = $($result.idref -split "stig_rule_")[1]

            $vuln = $vulns | where {$_.stig_data.attribute_data -eq $result_rule}

            if ($result.result -eq "fail"){$vuln.status = "Open"}

            if ($result.result -eq "pass"){$vuln.status = "NotAFinding"}

            $vuln.COMMENTS = "Checked by SCAP"
        }

        $ckl.save($cklobj.FullName)
    }

    Remove-Variable $ckl
    Remove-Variable $xccdf
    Remove-Variable $results
    Remove-Variable $vulns
    Remove-Variable $vuln
}