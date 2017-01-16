Function New-SCCMUninstallationDeployment {  
    Param($ApplicationName = $(Read-Host)
    )  
    Set-Location "D:\ConfigMgr\Microsoft Configuration Manager\AdminConsole\bin"                                                                                                                    
    Import-Module ".\ConfigurationManager.psd1"  
    Set-Location $(((Get-PSDrive | ? {$_.Provider -like "AdminUI.PS.Provider\CMSite"})[0].name)+":")  
    New-CMDeviceCollection `  
        -Name "Uninstall $ApplicationName" `  
        -LimitingCollectionName "All Systems" `  
        -Verbose:$true
    Add-CMDeviceCollectionQueryMembershipRule `  
        -CollectionName "Uninstall $ApplicationName" `  
        -QueryExpression "select SMS_R_System.NetbiosName, SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName from SMS_R_System inner join SMS_G_System_ADD_REMOVE_PROGRAMS on SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceId = SMS_R_System.ResourceId where SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName like '%$ApplicationName%'" `  
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
