# Demo for slides 2 and 3 of the module

# LCM for SMB pull configuration
Ise C:\Scripts\dsc1\Mod4\1.LCM_SMBPull.oldStyle.ps1
ise C:\Scripts\DSC1\Mod4\1.LCM_SMBPull.ps1 # Run
# Can show MOF
Explorer c:\DSCSMB

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName s1,s2 -Path c:\DSCSMB –Verbose
Get-DscLocalConfigurationManager -CimSession s1,s2

# Create a configuration
ise C:\Scripts\DSC1\Mod4\2.Config_Backup.ps1
# Rename config with GUID and Checksum
# Get the guid, is already assigned
$guid=Get-DscLocalConfigurationManager -CimSession s1 | Select-Object -ExpandProperty ConfigurationID
# Specify source folder of configuration
$source = "C:\DSCSMB\SMBComputers.mof"
# Destination is the Sahre on the SMB pull server
$dest = "\\dc\DSCSMB\$guid.mof"
# Copy
Copy-Item -Path $source -Destination $dest
#Then on Pull server make checksum
New-DSCChecksum $dest
# Test
Explorer C:\dscSMB
# Test and update
Get-WindowsFeature -ComputerName s1 -name *backup* #Shouldn't be installed yet.
Update-DscConfiguration -ComputerName s1 #Check to see if it installs
Get-WindowsFeature -ComputerName s1 -name *backup* # Should now be installed
Get-WindowsFeature -ComputerName s2 -name *backup* #Shouldn't be installed yet.
Test-DscConfiguration -CimSession s1


# Set LCM for HTTP Pull
ise C:\Scripts\DSC1\Mod4\3.LCM_HTTPPull.oldStyle.ps1
ise C:\Scripts\DSC1\Mod4\3.LCM_HTTPPull.ps1 #Run

Can Show MOF
Explorer c:\DSC\HTTP

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName s1,s2 -Path c:\DSC\HTTP –Verbose

# Create simple config
ise C:\Scripts\DSC1\Mod4\4.Config_SMTP.ps1

# Rename config with GUID and Checksum
# Get the guid, is already assigned
$guid=Get-DscLocalConfigurationManager -CimSession s1 | Select-Object -ExpandProperty ConfigurationID
# Specify source folder of configuration
$source = "C:\DSC\HTTP\HTTPComputers.mof"
# Destination is the Share on the SMB pull server
$dest = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\$guid.mof"
Copy-Item -Path $source -Destination $dest
#Then on Pull server make checksum
New-DSCChecksum $dest
# Test
Get-WindowsFeature -ComputerName s1 -name *SMTP* #Shouldn't be installed yet.
Update-DscConfiguration -ComputerName s1 #Check to see if it installs
Get-WindowsFeature -ComputerName s1 -name *SMTP* # Should have installed by now
Get-WindowsFeature -ComputerName s2 -name *SMTP* #Shouldn't be installed yet.
Test-DscConfiguration -CimSession s1


# Configure Client LCM for HTTPS
# Need Certificate ThumbPrint
Invoke-Command -Computername s4 {Get-Childitem Cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq "PSDSCPullServerCert"} | Select-Object -ExpandProperty ThumbPrint}

ise C:\Scripts\DSC1\Mod4\5.LCM_HTTPSPull.oldStyle.ps1
ise C:\Scripts\DSC1\Mod4\5.LCM_HTTPSPull.ps1 #Run

# Can show MOF
Explorer c:\DSC\HTTPS

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName s1,s2 -Path c:\DSC\HTTPS –Verbose

# Create configureation for clients
ise C:\Scripts\DSC1\Mod4\6.Config_RemoveSMTP.ps1

# Rename config with GUID and Checksum
# Get the guid, is already assigned
$guid=Get-DscLocalConfigurationManager -CimSession s1 | Select-Object -ExpandProperty ConfigurationID
# Specify source folder of configuration
$source = "C:\DSC\HTTPS\HTTPSComputers.mof"
# Destination is the pull location on the web server
$dest = "\\s4\c$\Program Files\WindowsPowerShell\DscService\Configuration\$guid.mof"
Copy-Item -Path $source -Destination $dest
Explorer \\s4\c$\Program Files\WindowsPowerShell\DscService\Configuration
#Then on Pull server make checksum
New-DSCChecksum $dest
# Test - ONLY IF TIME
Get-WindowsFeature -ComputerName s1 -name *SMTP* 
Update-DscConfiguration -ComputerName s1 -Wait -Verbose   #Check to see if it installs
Get-WindowsFeature -ComputerName s1 -name *SMTP* #Should be removed
Get-WindowsFeature -ComputerName s2 -name *SMTP* #Shouldn't be installed yet.
Test-DscConfiguration -CimSession s1

# Query node status and other diagnostics
Start-Process -FilePath iexplore http://blogs.msdn.com/b/powershell/archive/2014/05/29/how-to-retrieve-node-information-from-pull-server.aspx
start-process -FilePath iexplore http://dc.company.pri:9080/PSDSCComplianceServer.svc/

# Node status
<#
# DSC function to query node information from pull server.
#>

ise C:\Scripts\dsc1\Mod4\7.QueryNode.ps1

# Checking events
Get-WinEvent -ProviderName Microsoft-Windows-DSC -ComputerName s1
Get-WinEvent -ProviderName Microsoft-Windows-DSC -computername s1 -MaxEvents 5 | Format-Table -Property TimeCreated, Message -AutoSize -Wrap
Get-WinEvent -ProviderName Microsoft-Windows-PowerShell-DesiredStateConfiguration-FileDownloadManager -ComputerName s1
Get-WinEvent -ProviderName Microsoft-Windows-Powershell-DesiredStateConfiguration-PullServer

#
Copy-item -path 'C:\Scripts\Reskit9\All Resources\xDscDiagnostics' -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Import-Module -name XDSCDiagnostics
Get-xDSCOperation
Trace-xDSCOperation -sequnceID
Update-xDSCEventLogStatus -Channel Analtic -Status Enable
Update-xDSCEventLogStatus -Channel debug -Status Enable
