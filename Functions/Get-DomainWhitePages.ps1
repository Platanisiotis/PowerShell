function Get-DomainWhitePages
{
    [CmdletBinding()]
    [Alias("DomainWhitePages")]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $HostName
    )
    Begin
    {}
    Process
    {
        $ie = New-Object -ComObject InternetExplorer.Application
        $ie.Navigate2("http://centralops.net/co/DomainDossier.aspx?addr=$HostName&dom_whois=true&dom_dns=true&net_whois=true")
        $ie.Visible = $true
    }
    End
    {}
}
