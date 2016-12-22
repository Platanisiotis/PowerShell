Function Get-PatchStatus
{
    [cmdletBinding(ConfirmImpact='Medium')]
    [OutputType([String])]
    Param ()
    Begin 
    {}
    Process
    {
        # Creating an Update Session Object and storing it in $UpdateSession
        $UpdateSession  = New-Object -ComObject Microsoft.Update.Session

        # Running the methods to query the updates required
        $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
        $SearchResult   = $UpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")
        $Critical       = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq "Critical" }
        $important      = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq "Important" }
        $other          = $SearchResult.updates | Where-Object { $_.MsrcSeverity -eq $null }
        Write-Verbose "Total     = $($SearchResult.updates.count)"
        Write-Verbose "Critical  = $($Critical.count)"
        Write-Verbose "Important = $($Important.count)"
        Write-Verbose "Other     = $($other.count)"
    }
    End 
    {}
}