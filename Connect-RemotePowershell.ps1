#requires -runasadministrator
Function Connect-RemotePowershell($ServerName) 
{
    if ((Get-Service winrm).Status -ne "Running")
    {
        Start-Service WinRM -Confirm:$false
    }
    $curValue = (get-item wsman:\localhost\Client\TrustedHosts).value
    if ($curValue -notlike $ServerName)
    {
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$curValue, $ServerName"
    }
    $Credential = Get-Credential
    Enter-PSSession -ComputerName $ServerName -Credential $Credential -Verbose
}