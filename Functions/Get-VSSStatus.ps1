# Currently completely broken - DO not use. WMF Patch broke the inputObject I used :( 
Function Get-VSSStatus
{
    [CmdletBinding(SupportsShouldProcess=$false, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$false)]
        [switch]
        $Email,
        
        [Parameter(Mandatory=$false)]
        [switch]
        $SelfHeal,

        [Parameter()]
        $FilePath = ("$ENV:SystemDrive"+"\Windows\temp\$(Get-Date -Format yyy-MM-dd)"),

        [Parameter(Mandatory=$false,
                    ParameterSetName="email")]
        $FromEmail  = "mimi1111@optusnet.com.au",

        [Parameter(Mandatory=$false,
                    ParameterSetName="email")]
        $ToEmail    = "alex@miskle.com.au",

        [Parameter(Mandatory=$false,
                    ParameterSetName="email")]
        $SMTPServer = "mail.optusnet.com.au",

        [Parameter(Mandatory=$false,
                    ParameterSetName="email")]
        $SMTPPort   = "25" 
    )

Begin
{
    Write-Verbose -Message "Collecting the VSSADMIN results, for the first time..."
    $vssadmin = vssadmin list writers
    Write-Verbose -Message "VSSADMIN results collected."
    $vssadminC = @()
}
Process
{
    foreach ($line in $vssadmin) 
    {
        $NameValueC = $line.Trim() -split ': '

        if ($NameValueC[1] -ne $null) 
        {
            if ($NameValueC[0] -eq 'Writer name') 
            {$vssadmino = New-Object PSObject}

            $NameS = $NameValueC[0] -replace " ", "" 
            $ValueS = $NameValueC[1] -replace "'", ""
            $vssadmino | Add-Member -Type NoteProperty -Name $NameS -Value $ValueS

            if ($NameValueC[0] -eq 'Last error') 
            {$vssadminC += $vssadmino}
        }
    }
    Write-Verbose -Message "Checking the VSS writer status..."
    $vssadminf = ($vssadminC | ? {$_.State -ne "[1] Stable" -or $_.Lasterror -ne "No error"})

    $P = @()
    Write-Verbose -Message "Determining if there are errors..."
    $S1 = Switch ($vssadminf) 
    {
        $null
        {
            Write-Output "No VSS Errors" | Out-File -FilePath "$FilePath.htm" 
            Write-Verbose -Message "No VSS Errors"
            Break
        }
    }
    $S2 = Switch -Regex ($vssadminf.writername) 
    {
        "ASR Writer" { $P +="VSS" }
        "Bits Writer" { $P +="BITS" }
        "Certificate Authority" { $P +="EventSystem" }
        "COM+ REGDB Writer" { $P +="VSS" }
        "DFS Replication service writer" { $P +="DFSR" }
        "Dhcp Jet Writer" { $P +="DHCPServer" }
        "FRS Writer" { $P +="NtFrs" }
        "IIS Config Writer" { $P +="AppHostSvc" }
        "IIS Metabase Writer" { $P +="IISADMIN" }
        "Microsoft Exchange Writer" { $P +="MSExchangeIS" }
        "Microsoft Hyper-V VSS Writer" { $P +="vmms" }
        "MSSearch Service Writer" { $P +="EventSystem" }
        "NPS VSS Writer" { $P +="EventSystem" }
        "NTDS" { $P +="EventSystem" }
        "OSearch VSS Writer" { $P +="OSearch" }
        "OSearch14 VSS Writer" { $P +="OSearch14" }
        "Registry Writer" { $P +="VSS" }
        "Shadow Copy Optimization Writer" { $P +="VSS" }
        "Sharepoint Services Writer" { $P +="SPWriter" }
        "SPSearch VSS Writer" { $P +="SPSearch" }
        "SPSearch4 VSS Writer" { $P +="SPSearch4" }
        "SqlServerWriter" { $P +="SQLWriter" }
        "System Writer" { $P +="CryptSvc" }
        "WMI Writer" { $P +="Winmgmt" }
        "TermServLicensing" { $P +="TermServLicensing" }
    }
    If ($SelfHeal.IsPresent -eq $true -and $vssadminf -ne $null) # SelfHeal Switch to restart the services
    {
        Write-Verbose -Message "Restarting required services"
        If ($P -ne $null)
        {
            Stop-Service -Name $p -Force -Verbose
            Start-Service -Name $p -Verbose
        }
    }
}
End # all the fucked vss writer's services are restarted, or if they aren't END will let you know
{
    If ($SelfHeal.IsPresent -eq $true -and $vssadminf.count -gt 0) # If SelfHeal switch is true, run the vssadmin check again
    {
        Write-Verbose -Message "Collecting the VSSADMIN results, for the second time..."
        $vssadmin2 = vssadmin list writers
        $vssadminC2 = @()
        foreach ($line2 in $vssadmin2) 
        {
            $NameValueC2 = $line2.Trim() -split ': '

            if ($NameValueC2[1] -ne $null) 
            {
                if ($NameValueC2[0] -eq 'Writer name') 
                {$vssadmino2 = New-Object PSObject}

                $NameS2 = $NameValueC2[0] -replace " ", "" 
                $ValueS2 = $NameValueC2[1] -replace "'", ""
                $vssadmino2 | Add-Member -Type NoteProperty -Name $NameS2 -Value $ValueS2

                if ($NameValueC2[0] -eq 'Last error') 
                {$vssadminC2 += $vssadmino2}
            }
        }
        Write-Verbose -Message "Confirming results of the VSS writer status..."
        $vssadminF2 = ($vssadminC2 | ? {$_.State -ne "[1] Stable" -or $_.Lasterror -ne "No error"})

        If ($Email.IsPresent -eq $true) # Email switch to define if we should send an email
        {
            If ($vssadminf2 -ne $null) 
            {   
                $body = (Get-Content -Path "$FilePath.htm") # HTML content, need to generate from vssadminc2
                Send-MailMessage `
                -From $FromEmail `
                -To $ToEmail `
                -SmtpServer $SMTPServer `
                -Subject "ATTENTION - VSS Logs $(Get-Date -Format yyy-MM-dd)" `
                -Body "$body" `
                -BodyAsHtml `
                -ErrorAction SilentlyContinue `
                -ErrorVariable +EmailError

                If ($EmailError -ne $null) # Error message if email fails to send
                { 
                    $EmailError > "$FilePath.log"
                    Write-Verbose -Message "Email failed to send, please see error logged stored in $FilePath.log"
                    Write-Verbose -Message "Type (Invoke-Item -Path $FilePath.log) to open the file"
                }
            }
            Else
            {
                $body = (Get-Content -Path "$FilePath.htm") # HTML content, need to generate from vssadminc2
                Send-MailMessage `
                -From $FromEmail `
                -To $ToEmail `
                -SmtpServer $SMTPServer `
                -Subject "SUCCESS - VSS Logs $(Get-Date -Format yyy-MM-dd)" `
                -Body "$body" `
                -BodyAsHtml `
                -ErrorAction SilentlyContinue `
                -ErrorVariable +EmailError

                If ($EmailError.count -gt 0) # Error message if email fails to send
                { 
                    $EmailError > "$FilePath.log"
                    Write-Verbose -Message "Email failed to send, please see error logged stored in $FilePath.log"
                    Write-Verbose -Message "Type (Invoke-Item -Path $FilePath.log) to open the file"
                }   
            }
        }
        If ($vssadminf2 -eq $null) # If there are no issues after the second check
        {Write-Verbose -Message "There are no VSS issues."}
        If ($vssadminF2 -ne $null) # If there are issues that could not be resolved.
        {
            Foreach ($FailedVSSWriter in $vssadminF2.writername)
            {Write-Verbose  -Message "Still in a failed state : $FailedVSSWriter"}
        }
    }

    If ($SelfHeal.IsPresent -eq $true -and $vssadminf.count -eq 0)
    {
        Write-Verbose "There are no VSS writer issues."
    }
    If ($SelfHeal.IsPresent -ne $true)
    {
        If ($vssadminf -eq $null) # If SelfHeal switch isn't used, and there are no isses.
        {
            Write-Verbose "There are no VSS writer issues."
        }
        Else # If SelfHeal switch isn't used and there are issues.
        {
            Foreach ($FailedVSSWriter in $vssadminF2.writername)
            {
                Write-Verbose  -Message "Still in a failed state : $FailedVSSWriter"
            }
        }
    }
}
}
