#requires -runasadministrator
Function Connect-Nano01 {
    $ServerName = "nano01.platanisiotis.com"
    Start-Service WinRM -Confirm:$false
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $ServerName
    $Credential = Get-Credential
    Enter-PSSession -ComputerName $ServerName -Credential $Credential -Verbose
}