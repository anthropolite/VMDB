﻿function cklwriter {
    Param (
        $stigid,
        $date,
        $stigpath = "$global:stig_path",
        $stigoutput = "$env:USERPROFILE\desktop\Checklists_$date")
   
    #get the raw STIG

    $cklpath = Get-ChildItem $stigpath | where {$_.name -like "U_$stigid*"}

    $ckl = [xml](get-content -path $stigpath\$($cklpath.name))

    #Create output dir 

    if(!(test-path -path $stigoutput)) {
        new-item -itemtype directory -path $stigoutput
    }
      
    #set output file

    $cklname = "$stigoutput\$env:computername.$Stigid.$env:username.$date.ckl"

    #start writing CKL

    $Encoding = New-Object System.Text.UTF8Encoding $False
    $xmlwritersettings = New-Object System.Xml.XmlWriterSettings
   
    $xmlwriter = New-Object System.Xml.XmlTextWriter($cklname,$encoding)
    
    #set formatting
    $xmlwriter.formatting = "Indented"
    $xmlwriter.indentation = "1"
    $xmlWriter.IndentChar = "`t"
    $xmlwritersettings.NewLineChars = "`n"

    # write the xml decleration
    $xmlwriter.writestartdocument()
           
    #Start the Checklist Element
    $xmlwriter.writestartelement("CHECKLIST")

    #start the Asset Element
    $xmlwriter.writestartelement("ASSET")

    #write Asset Attributes
    $xmlwriter.writeelementString("Role","None")
    $xmlwriter.writeelementString("ASSET_TYPE","Computing")
    $xmlwriter.writeelementString("HOST_NAME","$ENV:computername")
    $xmlwriter.writeelementString("HOST_IP","$(Get-NetIPAddress | WHERE { $_.AddressState -EQ "Preferred" -AND $_.AddressFamily -EQ "ipV4" -and $_.PrefixOrigin -ne "WellKnown"} | select -ExpandProperty ipaddress)")
    $xmlwriter.writeelementString("HOST_MAC","")
    $xmlwriter.writeelementString("HOST_FQDN","$($(Get-WmiObject win32_computersystem) | select -expandproperty Domain)")
    $xmlwriter.writeelementString("TECH_AREA","")
    $xmlwriter.writeelementString("TARGET_KEY","")
    $xmlwriter.writeelementString("WEB_OR_DATABASE","false")
    $xmlwriter.writeelementString("WEB_DB_SITE","")
    $xmlwriter.writeelementString("WEB_DB_INSTANCE","")

    # Close Asset 
    $xmlwriter.writeEndElement()

    # Start STIGS
    $xmlwriter.writestartelement("STIGS")

    #Start iSTIGS
    $xmlwriter.writestartelement("iSTIGS")

    #start STIG_Info
    $xmlwriter.writestartelement("STIG_INFO")

    #write STIG_INFO Attributes

    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("version")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($ckl.Benchmark.version)")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("classification")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("UNCLASSIFIED")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("customname")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("stigid")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($ckl.Benchmark.id)")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("description")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($ckl.Benchmark.description)")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("filename")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($cklpath.Name)")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("releaseinfo")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($ckl.Benchmark.'plain-text'.'#text')")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("title")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("$($ckl.Benchmark.title)")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("uuid")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("notice")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SI_DATA")
    $xmlwriter.writestartelement("SI_NAME")
    $xmlwriter.writestring("source")
    $xmlwriter.writeEndElement()
    $xmlwriter.writestartelement("SID_DATA")
    $xmlwriter.writestring("")
    $xmlwriter.writeEndElement()
    $xmlwriter.writeEndElement()

    # Close STIG_Info
    $xmlwriter.writeEndElement()

    #Get Vulnerabilities
    $vulns=$ckl.Benchmark.Group

    foreach($vuln in $vulns) {

        $xmlwriter.writestartelement("VULN")
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Vuln_Num")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.id)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Severity")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.severity)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Group_Title")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.title)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Rule_ID")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.id)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Rule_Ver")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.version)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Rule_Title")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.title)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Vuln_Discuss")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<VulnDiscussion\>).+(?=\<\/VulnDiscussion\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("IA_Controls")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<IAControls\>).+(?=\<\/IAControls\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Check_Content")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.check.'check-content')")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Fix_Text")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.fixtext.'#text')")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("False_Positives")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<FalsePositives\>).+(?=\<\/FalsePositives\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("False_Negatives")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<FalseNegatives\>).+(?=\<\/FalseNegatives\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Documentable")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<Documentable\>).+(?=\<\/Documentable\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Mitigations")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<Mitigations\>).+(?=\<\/Mitigations\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Potential_Impact")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<PotentialImpacts\>).+(?=\<\/PotentialImpacts\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Third_Party_Tools")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<ThirdPartyTools\>).+(?=\<\/ThirdPartyTools\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Mitigation_Control")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<MitigationControl\>).+(?=\<\/MitigationControl\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Responsability")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<Responsability\>).+(?=\<\/Responsability\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Security_Override_Guidance")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($([regex]::match($($vuln.rule.description),'(?<=\<SeverityOverrideGuidance\>).+(?=\<\/SeverityOverrideGuidance\>)')).value)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Check_Content_Ref")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.check.'check-content-ref'.name)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Weight")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.weight)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("Class")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("UNCLASS")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("STIGRef")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($ckl.Benchmark.title) :: $($ckl.Benchmark.'plain-text'.'#text')")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("TargetKey")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.reference.identifier)")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("STIG_DATA")
            $xmlwriter.WriteStartElement("VULN_ATTRIBUTE")
            $xmlwriter.writestring("CCI_REF")
            $xmlwriter.writeEndElement()
            $xmlwriter.writestartelement("ATTRIBUTE_DATA")
            $xmlwriter.writestring("$($vuln.rule.ident.'#text')")
            $xmlwriter.writeEndElement()
        $xmlwriter.writeEndElement()

        #write eval fields

        $xmlwriter.WriteStartElement("STATUS")
        $xmlwriter.writestring("Not_Reviewed")
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("FINDING_DETAILS")
        $xmlwriter.writestring("")
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("COMMENTS")
        $xmlwriter.writestring("")
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("SEVERITY_OVERRIDE")
        $xmlwriter.writestring("")
        $xmlwriter.writeEndElement()
        $xmlwriter.WriteStartElement("SEVERITY_JUSTIFICATION")
        $xmlwriter.writestring("")
        $xmlwriter.writeEndElement()

        #Close Vulns
        $xmlwriter.writeEndElement()
    }

    #Close iSTIGS
    $xmlwriter.writeEndElement()
    
    #Close StigS
    $xmlwriter.writeEndElement()

    # End the XML Document
    $xmlwriter.WriteEndDocument()
 
    # Finish The Document
    $xmlwriter.Flush()
    $xmlwriter.Close()
}