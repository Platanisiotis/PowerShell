# 1. Push Deployment

Copy-item -Path C:\Scripts\DSC2\mod3\MVADemo -Destination 'C:\Program Files\WindowsPowerShell\Modules\MVADemo' -Recurse -Force
explorer 'C:\Program Files\WindowsPowerShell\Modules'
Get-DscResource

# 2. Pull server

# Show module version in .psd1
ise C:\Scripts\dsc2\Mod3\MVADemo\MVADemo.psd1

# Zip using name + version MVADemo_1.0.zip
explorer C:\Scripts\DSC2\Mod3\

# copy Zip to Pull server location
Copy-item -Path C:\Scripts\DSC2\mod3\MVADemo_1.0.zip -Destination 'C:\Program Files\WindowsPowerShell\DscService\Modules' -Recurse -Force
New-DSCCheckSum -path 'C:\Program Files\WindowsPowerShell\DscService\Modules\MVADemo_1.0.zip'
explorer 'C:\Program Files\WindowsPowerShell\DscService\Modules'

# 3. Create Configuration

# If Need to re-make pull server
#ise C:\Scripts\DSC1\Mod3\_M3-Demo.ps1
#ise C:\Scripts\dsc1\Mod3\1.Config_HTTPPullServer.ps1

#Check target LCM for pull

Get-DscLocalConfigurationManager -CimSession s2 #Should be Pull
# If not pull - 
#ise C:\scripts\dsc2\mod3\LCM_HTTPPull.ps1
#Set-DscLocalConfigurationManager -Path C:\DSC\HTTP -ComputerName s2 -Verbose
Get-Service -name bits -ComputerName s2
ise C:\Scripts\DSC2\Mod3\Config_Service.ps1
Start-DscConfiguration -ComputerName s2 -Path C:\Scripts\DSC2\mod3\Config -Wait -Verbose -Force
### Test
explorer '\\s2\c$\Program Files\WindowsPowerShell\Modules'
Get-service -name bits -ComputerName s2
Get-DscConfiguration -CimSession s2

# Remove-DscConfigurationDocument

