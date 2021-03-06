﻿#Requires -Version 3.0
Function Get-PatchStatus
{
    # Creating an Update Session Object and storing it in $UpdateSession
    $UpdateSession  = New-Object -ComObject Microsoft.Update.Session

    # Running the methods to query the updates required
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $SearchResult   = $UpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")
    $Critical       = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq "Critical" }
    $important      = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq "Important" }
    $other          = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq $null }
    Write-Host "Total     = $($SearchResult.updates.count)"
    Write-Host "Critical  = $($Critical.count)"
    Write-Host "Important = $($Important.count)"
    Write-Host "Other     = $($other.count)"
}
