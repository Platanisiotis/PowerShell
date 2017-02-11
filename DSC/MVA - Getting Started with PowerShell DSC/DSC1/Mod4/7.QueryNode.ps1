function QueryNodeInformation
{
  Param (     
       [string] $Uri = "http://dc.company.pri:9080/PSDSCComplianceServer.svc/Status",                         
       [string] $ContentType = "application/json"          
     )
  Write-Output "Querying node information from pull server URI  = $Uri"
  Write-Output "Querying node status in content type  = $ContentType "
 

 $response = Invoke-WebRequest -Uri $Uri -Method Get -ContentType $ContentType -UseDefaultCredentials -Headers @{Accept = $ContentType}
 
 if($response.StatusCode -ne 200)
 {
     Write-Output "node information was not retrieved."
 }
 
 $jsonResponse = ConvertFrom-Json $response.Content
 
 return $jsonResponse

}

$json = QueryNodeInformation –Uri http://dc.company.pri:9080/PSDSCComplianceServer.svc/Status
 
$json.value | Format-Table TargetName, ConfigurationId, ServerChecksum, NodeCompliant, LastComplianceTime, StatusCode
