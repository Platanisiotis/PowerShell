
# 1. Composite resource structure
ise C:\Scripts\DSC2\Mod6\Config_composite.psm1
# Save as Baseconfig.schema.psm1 in folder structure
copy-item C:\scripts\dsc2\mod6\Config_composite.psm1 -Destination C:\scripts\DSC2\Mod6\BaseConfig.schema.psm1 -force
#Create new folder and copy composite resource
New-Item -Path c:\CompositeDSC\DSCResources\Baseconfig -ItemType directory -Force
copy-item -Path C:\Scripts\DSC2\mod6\Config\baseconfig.schema.psm1 `
    -Destination C:\CompositeDSC\DSCResources\Baseconfig -force

# Create Manifest for Baseconfig
New-ModuleManifest -Path C:\CompositeDSC\DSCResources\baseconfig\baseconfig.psd1 `
    -ModuleVersion 1.0 -RootModule 'BaseConfig.schema.psm1'

# Create the Manifest for the nested module
New-ModuleManifest -Path C:\CompositeDSC\CompositeDSC.psd1 `
    -Guid ([GUID]::NewGuid()) -ModuleVersion 1.0 -Author MVA -CompanyName MVADemo `
    -Description 'MVA nested resource module'

# Copy to modules folder like a resource
Copy-Item -Path C:\CompositeDSC -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Get-DscResource

# Create a configuration using the composite resource
ise C:\Scripts\DSC2\Mod6\WebConfig.ps1
# Examine mof
ise C:\Config\s1.mof
# Show it worked
Get-WindowsFeature -name *backup* -ComputerName s1
