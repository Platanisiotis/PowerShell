# 1. Built-in Resources

Get-DscResource -name File | Select-Object -ExpandProperty Properties 
Get-DscResource -name File -Syntax

# Discuss adding resources locally

# discuss Adding resources to a pull server

# Set for Push
ise C:\Scripts\DSC1\Mod5\1.LCM_Push.ps1
# File
ise C:\Scripts\DSC1\Mod5\2.Config_File.ps1
# Archive
ise C:\Scripts\DSC1\Mod5\3.Config_Archive.ps1
# Environment
ise C:\Scripts\DSC1\Mod5\4.Config_EnvironmentVar.ps1
# User
ise C:\Scripts\DSC1\Mod5\5.Config_User.ps1
# Group
ise C:\Scripts\DSC1\Mod5\6.Config_Group.ps1
# Log
# Must enable Analytic and debug logs ON S1
Copy-item -path 'C:\Scripts\Reskit9\All Resources\xDscDiagnostics' -Destination '\\s1\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Import-Module xDSCDiagnostics
Invoke-command -computername s1 {Update-xDscEventLogStatus -Channel Analytic -Status Enabled}
Invoke-command -computername s1 {Update-xDSCEventLogStatus -Channel debug -Status Enabled}
# Old Way
# Invoke-command -ComputerName s1 {wevtutil.exe set-log “Microsoft-Windows-Dsc/Analytic” /q:true /e:true }

ise C:\Scripts\DSC1\Mod5\7.Config_Log.ps1
Get-WinEvent -LogName Microsoft-Windows-DSC/Analytic -Oldest -ComputerName s1 | Where-Object {$_.ID -eq 4098} | Select-Object -ExpandProperty message

# WindowsProcess
ise C:\Scripts\DSC1\Mod5\8.Config_WindowsProcess.ps1
Get-Process -ComputerName s1

# WindowsService
invoke-command -ComputerName s1 {Get-service -name audiosrv}
ise C:\Scripts\DSC1\Mod5\9.Config_WindowsService.ps1
invoke-command -ComputerName s1 {Get-service -name audiosrv}

# Registry
ise C:\Scripts\DSC1\Mod5\10.Config_Registry.ps1
invoke-command -computername s1 {Get-ItemProperty -Path HKLM:\SOFTWARE\DSCTest}

#Script
ise C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\DSCResources\MSFT_ScriptResource\MSFT_ScriptResource.schema.mof
Invoke-Command -ComputerName s1 {Get-Service -name bits}
ise C:\Scripts\DSC1\Mod5\11.Config_Script.ps1
Invoke-Command -ComputerName s1 {Get-Service -name bits}


