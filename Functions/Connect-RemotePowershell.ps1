#requires -runasadministrator
Function Connect-RemotePowershell($ServerName) 
{
    if ((Get-Service winrm).Status -ne "Running")
    {
        Start-Service WinRM -Confirm:$false
    }
    $CurrentValue = (get-item wsman:\localhost\Client\TrustedHosts).value
    if ($CurrentValue -notlike "*$ServerName*")
    {
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$CurrentValue, $ServerName"
    }
    $Credential = Get-Credential
    Enter-PSSession -ComputerName $ServerName -Credential $Credential -Verbose
}