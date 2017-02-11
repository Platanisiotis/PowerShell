
# 1. Custom resource structure using classes

# use for example and explain
ise C:\Scripts\DSC2\Mod4\ClassStructure.ps1
ise C:\Scripts\DSC2\Mod4\ClassStructureSimple.ps1
ise C:\Scripts\dsc2\Mod4\ClassManifeststructure.ps1

# 2. Create a class-defined custom resource

ise C:\Scripts\DSC2\Mod4\Class\MVAClassService.psm1

# 3. Create Manifest

New-ModuleManifest -Path 'C:\Scripts\DSC2\Mod4\Class\MVAClassService.psd1' -RootModule MVAClassService.psm1 `
    -Guid ([GUID]::NewGuid()) -ModuleVersion 1.0 -Author MVA `
    -Description 'MVA class resource module' -DscResourcesToExport 'ClassService' #-PowerShellVersion '5.0' `
    
ise C:\Scripts\DSC2\Mod4\Class\MVAClassService.psd1

# Deploy the new resource
New-Item -path 'C:\Program Files\WindowsPowerShell\Modules\MVAClassService' -ItemType directory
Copy-Item -Path C:\Scripts\DSC2\Mod4\Class\*.* -Destination 'C:\Program Files\WindowsPowerShell\Modules\MVAClassService' -Force -Recurse
explorer 'C:\Program Files\WindowsPowerShell\Modules'
Get-DscResource
#Known issue -- set LCM debugmode = 'All'
ise C:\Scripts\DSC2\Mod4\LCM_Class.ps1
#Make configuration 
ise C:\Scripts\DSC2\Mod4\config_class.ps1
Get-Service -name bits
Start-DscConfiguration -Path C:\Scripts\DSC2\Mod4\Demo_Class -cimsession dc -Wait -Verbose

