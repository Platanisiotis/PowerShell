# 1. DSC custom resource architecture overview

# 3 Show the three files, then copy to bad location just to show
# that the custom resource works. Then delete.

ise C:\Scripts\DSC2\Mod1\MVAService\MVAService.schema.mof
ise C:\Scripts\dsc2\mod1\MVAService\MVAService.psm1
ise C:\Scripts\DSC2\Mod1\MVAService\MVAService.psd1

### Show how to create with REsourceDdesigner
Copy-Item 'C:\Scripts\Reskit9\All Resources\xDSCResourceDesigner' -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Import-Module xDSCResourceDesigner

#Define properties -- for a service
$ServiceName= New-xDscResourceProperty -Name ServiceName -Type String -Attribute key
$ServiceStatus=New-xDscResourceProperty -name Servicestatus -Type string -Attribute Write -ValidateSet Running, Stopped
$ensure=New-xDscResourceProperty -Name Ensure -Type string -Attribute Write -ValidateSet Present, Absent

# Create the resource files
New-xDscResource -Name MVAService -Property $ServiceName, $Servicestatus, $Ensure `
    -Path 'C:\scripts\DSC2\Mod1'

#Create the module manifest 
New-ModuleManifest -Path 'C:\scripts\DSC2\Mod1\DSCResources\MVAService\MVAService.psd1' `
    -Guid ([GUID]::NewGuid()) -ModuleVersion 1.0 -Author MVA -CompanyName 'MVADemo' `
    -Description 'MVA resource module' -RootModule 'MVAService.psm1'

#Copy the resource - Bad path example

Copy-item -Path C:\Scripts\DSC2\Mod1\DSCResources\MVAService -Destination "$PSHome\Modules\PSDesiredStateConfiguration\DSCResources\MVAService" -Recurse -Force
explorer "$PSHome\Modules\PSDesiredStateConfiguration\DSCResources"
Get-DscResource
Remove-Item -Path "$PSHome\Modules\PSDesiredStateConfiguration\DSCResources\MVAService" -Recurse -Force

### Nested Module - copy to the good location

Import-Module xDSCResourceDesigner

#Define properties -- for a service
$ServiceName= New-xDscResourceProperty -Name ServiceName -Type String -Attribute key
$ServiceStatus=New-xDscResourceProperty -name Servicestatus -Type string -Attribute Write -ValidateSet Running, Stopped
$ensure=New-xDscResourceProperty -Name Ensure -Type string -Attribute Write -ValidateSet Present, Absent

#Define Properties -- for a windows feature install
$FeatureName = New-xDscResourceProperty -Name FeatureName -Type string -Attribute key
$Installed = New-xDscResourceProperty -Name Installed -Type Boolean -Attribute write 
$ensure=New-xDscResourceProperty -Name Ensure -Type string -Attribute Write -ValidateSet Present, Absent

# Create the resource files
New-xDscResource -Name MVAService -Property $ServiceName, $Servicestatus, $Ensure `
    -Path 'C:\scripts\DSC2\mod1\MVADemo'
New-xDscResource -Name MVAFeature -Property $FeatureName, $Installed, $Ensure `
    -Path 'C:\scripts\DSC2\mod1\MVADemo'

#Create the module manifest with the nested module name
New-ModuleManifest -Path 'C:\scripts\DSC2\Mod1\MVADemo\MVADemo.psd1' `
    -Guid ([GUID]::NewGuid()) -ModuleVersion 1.0 -Author MVA -CompanyName MVADemo `
    -Description 'MVA nested resource module'

Copy-item -Path C:\Scripts\DSC2\mod1\MVADemo -Destination 'C:\Program Files\WindowsPowerShell\Modules\MVADemo' -Recurse -Force
explorer 'C:\Program Files\WindowsPowerShell\Modules'
Get-DscResource
Remove-item -Path 'C:\Program Files\WindowsPowerShell\Modules\MVADemo' -Recurse -Force

