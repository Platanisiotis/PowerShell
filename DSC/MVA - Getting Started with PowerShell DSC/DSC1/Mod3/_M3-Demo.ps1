

# 1.Configuring SMB Pull Server - NO TARGET LCM Till next module

# Create folder and share on DC for MOF and Resource modules
New-Item -Path C:\DSCSMB -ItemType Directory
New-SmbShare -Name DSCSMB -Path c:\DSCSMB -ReadAccess Everyone -FullAccess Administrator -Description "SMB share for DSC"

# 2. Configuring HTTP pull server

# Need the xPSDesiredStatConfiguration Module on the HTTP Pull Server
# 'C:\Program Files\WindowsPowerShell\Modules'
Find-Module -name xPSDesired*
#Install-Module -name xPSDesired*

# Copy from ResKit 9
Copy-Item -Path 'C:\scripts\Reskit9\All Resources\xPSDesiredStateConfiguration' -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
explorer 'C:\Program Files\WindowsPowerShell\Modules'

# Create configuration for HTTP Pull Server 
ise C:\Scripts\DSC1\Mod3\1.Config_HTTPPullServer.ps1

# Deploy HTTP Pull Server
Start-DscConfiguration -Path C:\DSC\HTTP -ComputerName dc -Verbose -Wait
# TEst the Pull Server
# If fails - change web.config
# <add key="dbprovider" value="System.Data.OleDb" />
# <add key="dbconnectionstr" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files\WindowsPowerShell\DscService\Devices.mdb;" />
Start-Process -FilePath iexplore.exe http://dc:8080/PSDSCPullServer.svc
ise C:\inetpub\wwwroot\PSDSCPullServer\web.config
Copy-Item C:\scripts\DSC1\Mod3\web.config -Destination C:\inetpub\wwwroot\PSDSCPullServer -Force
Start-Process -FilePath iexplore.exe http://dc:8080/PSDSCPullServer.svc

# 3. Configure HTTPS pull server

# On S4
# Copy xPSDesired* to S4
Copy-Item -Path 'C:\scripts\Reskit9\All Resources\xPSDesiredStateConfiguration' -Destination '\\s4\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
explorer '\\s4\c$\Program Files\WindowsPowerShell\Modules'

# Note: Can Create Certificate "CN=PSDSCPullServerCert" in "CERT:\LocalMachine\MY\" store
# Note: A Certificate may be generated using MakeCert.exe: http://msdn.microsoft.com/en-us/library/windows/desktop/aa386968%28v=vs.85%29.aspx

# Make the Cert on S4 - Common Name s4.Company.Pri

#Get ThumbPrint - should be in Configuration as well
Invoke-Command -Computername s4 {Get-Childitem Cert:\LocalMachine\My | Where-Object {$_.FriendlyName -eq "PSDSCPullServerCert"} | Select-Object -ExpandProperty ThumbPrint}
# Create HTTPS Pull server configuration with ThumbPrint
ise C:\Scripts\DSC1\Mod3\2.Config_HTTPSPullServer.ps1

# Deploy HTTPS Pull Server
Start-DscConfiguration -Path C:\DSC\HTTPS -ComputerName s4 -Verbose -Wait

# TEst the Pull Server
# If fails - change web.config
# <add key="dbprovider" value="System.Data.OleDb" />
# <add key="dbconnectionstr" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files\WindowsPowerShell\DscService\Devices.mdb;" />
Start-Process -FilePath iexplore.exe https://s4.company.pri:8080/PSDSCPullServer.svc
Copy-Item C:\scripts\DSC1\Mod3\web.config -Destination \\s4\c$\inetpub\wwwroot\PSDSCPullServer -Force
Start-Process -FilePath iexplore.exe https://s4.company.pri:8080/PSDSCPullServer.svc

