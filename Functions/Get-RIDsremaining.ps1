function Get-RIDsremaining
{
    $property = Get-ADObject “cn=rid manager$,cn=system,$($(Get-ADDomain).DistinguishedName)” -property ridavailablepool
    $rid = $property.ridavailablepool   
    [int32] $totalSIDS = $($rid) / ([math]::Pow(2,32))
    [int64] $temp64val = $totalSIDS * ([math]::Pow(2,32))
    [int32] $currentRIDPoolCount = $($rid) – $temp64val
    $ridsremaining = $totalSIDS – $currentRIDPoolCount
    Write-Host “RIDs issued: $currentRIDPoolCount”
    Write-Host “RIDs remaining: $ridsremaining”
}
