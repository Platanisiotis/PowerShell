Function Get-CMApplicationInstallationStatus 
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true)]
        $SoftwareName,
        [switch]$IncludeDeviceDescription=$false,
        [switch]$PersistCMQuery=$false
    )
    begin 
    {}
    process 
    {
        Set-Location "D:\ConfigMgr\Microsoft Configuration Manager\AdminConsole\bin"                                                                                                                  
        Import-Module ".\ConfigurationManager.psd1"
        Set-Location $(((Get-PSDrive | ? {$_.Provider -like "AdminUI.PS.Provider\CMSite"})[0].name)+":")
        $CMQueryExpression = "select SMS_R_System.NetbiosName, 
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
                    [pscustomobject]@{
                    "ComputerName" = $value.SMS_R_System.NetbiosName
                    "ProgramName" = $value.SMS_G_System_ADD_REMOVE_PROGRAMS.Displayname
                    "DeviceDescription" = (invoke-command -ComputerName $env:LOGONSERVER.replace("\\","") {Get-ADComputer $($Using:value.SMS_R_System.NetbiosName) -Property Description | select Description }).Description
                    }
                }
            }
            False 
            {
                foreach ($Value in $Values)
                {
                    [pscustomobject]@{
                    "ComputerName" = $value.SMS_R_System.NetbiosName
                    "ProgramName" = $value.SMS_G_System_ADD_REMOVE_PROGRAMS.Displayname
                    }
                }
            }
        }
    }
    end
    {}
}
