
# 1. Composite resource structure
ise C:\Scripts\DSC2\Mod7\LCM_Partial_Notes.ps1
ise C:\Scripts\DSC2\Mod7\LCM_Partial_Notes2.ps1
# Actual LCM Config
ise C:\Scripts\DSC2\Mod7\LCM_Partial.ps1
# Set the LCM
# Should remove configs Remove-DSCConfigurationDocuments
Set-DscLocalConfigurationManager -Path C:\Scripts\DSC2\mod7\LCm -ComputerName s3 -Verbose

#Test the configs
ise C:\Scripts\DSC2\Mod7\Config_NLB.ps1
# Rename config with GUID and Checksum
# Get the guid, is already assigned
$guid=Get-DscLocalConfigurationManager -CimSession s3 | Select-Object -ExpandProperty ConfigurationID
# Specify source folder of configuration
$source = "C:\DSCSMB\s3.mof"
# Destination is the Sahre on the SMB pull server
# If no share new-smbshare -name DSCSMB -Path C:\DSCSMB -FullAccess everyone
$dest = "\\dc\DSCSMB\$guid.mof"
# Copy
Copy-Item -Path $source -Destination $dest
#Then on Pull server make checksum
New-DSCChecksum $dest
# Test
Explorer C:\dscSMB

# Config for webserver
ise C:\Scripts\dsc2\Mod7\WebServerConfig.ps1

# Test and update
Publish-DscConfiguration -path c:\config -ComputerName s3 -Verbose

update-DscConfiguration -ComputerName s3 -Wait -Verbose

