Function Get-CMApplicationInstallationStatus 
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true)]
        $SoftwareName,
        [switch]$IncludeDeviceDescription=$false,
        [switch]$PersistCMQuery=$false,
        [switch]$OutQueryClipboard=$false,
        [switch]$CreateUninstallDeployment=$false
    )
    begin 
    {
        $collection=@()    
    }
    process 
    {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
        Set-Location $(((Get-PSDrive | ? {$_.Provider -like "AdminUI.PS.Provider\CMSite"})[0].name)+":")
        $CMQueryExpression = `
"select SMS_R_System.NetbiosName, 
SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName from  
SMS_R_System inner join SMS_G_System_ADD_REMOVE_PROGRAMS on 
SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceId = 
SMS_R_System.ResourceId where 
SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName like '%$SoftwareName%'"
        New-CMQuery -Expression $CMQueryExpression -Name $("Installed-$SoftwareName") | Out-Null
        $Values = Invoke-CMQuery -Name $("Installed-$SoftwareName")
        switch ($PersistCMQuery)
        {
            True
            {
                Write-Host "Saved Query $("Installed-$SoftwareName")"
            }
            False
            {
                Remove-CMQuery -Name $("Installed-$SoftwareName") -Force -Confirm:$false
            }
        }
        switch ($IncludeDeviceDescription)
        {
            True 
            {
                foreach ($Value in $Values)
                {
                    $Object = [pscustomobject]@{
                    "ComputerName" = $value.SMS_R_System.NetbiosName
                    "ProgramName" = $value.SMS_G_System_ADD_REMOVE_PROGRAMS.Displayname
                    "DeviceDescription" = (invoke-command -ComputerName $env:LOGONSERVER.replace("\\","") {Get-ADComputer $($Using:value.SMS_R_System.NetbiosName) -Property Description | select Description }).Description
                    }
                $collection += $Object
                }
            }
            False 
            {
                foreach ($Value in $Values)
                {
                    $Object = [pscustomobject]@{
                    "ComputerName" = $value.SMS_R_System.NetbiosName
                    "ProgramName" = $value.SMS_G_System_ADD_REMOVE_PROGRAMS.Displayname
                    }
                $collection += $Object
                }
            }
        }
    }
    end
    {
        switch ($OutQueryClipboard)
        {
            $true {$CMQueryExpression | clip}
            $false {}
        }
        switch ($CreateUninstallDeployment)
        {
            $true 
            {
                $Applications = Get-CMApplication *$SoftwareName* -Fast -Verbose
                foreach ($ApplicationName in $Applications.LocalizedDisplayName)
                {
                    New-CMDeviceCollection `
                        -Name "Uninstall $ApplicationName" `
                        -LimitingCollectionName "All Systems" `
                        -Verbose:$true
                    Add-CMDeviceCollectionQueryMembershipRule `
                        -CollectionName "Uninstall $ApplicationName" `
                        -QueryExpression $CMQueryExpression `
                        -RuleName "$ApplicationName Installed" `
                        -Verbose:$true
                    Start-CMApplicationDeployment `
                        -CollectionName "Uninstall $ApplicationName" `
                        -Name "$ApplicationName" `
                        -DeployAction Uninstall `
                        -DeployPurpose Required `
                        -UserNotification DisplaySoftwareCenterOnly `
                        -Verbose:$true
                }
            }
            $false {$collection}
        }
    }
}
