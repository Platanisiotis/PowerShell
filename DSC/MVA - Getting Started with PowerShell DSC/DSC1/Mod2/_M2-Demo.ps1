# 1.Writing a DSC Configuration
Configuration Name
{
    Node s3 
    {
        WindowsFeature Demo
        {
            Name = 'web-server'
            Ensure = 'Present'
        }
    }
}

# 2.Configuring the LCM
Get-Help *-DSC*
Get-Help *localConfig*
Get-DscLocalConfigurationManager -CimSession s1

# Describe basic settings - not too much right now
#Script to change LCM to AutoCorrect - leave at Push LCM_Push.Ps1

ise C:\Scripts\DSC1\Mod2\1.LCM_Push_Oldway.ps1 #Don't run
ise C:\Scripts\DSC1\Mod2\1.LCM_Push_NewWay.ps1 #Run
 
ise c:\DSC\LCM\s1.meta.mof #View 
# Set the LCM on two remote targets
Set-DSCLocalConfigurationManager -ComputerName $computername -Path c:\DSC\LCM –Verbose
#Show change
Get-DscLocalConfigurationManager -CimSession s1,s2
#Show configuration file location on S1
Explorer \\s1\c$\windows\system32\Configuration

# 3. Performing the Push deployment 

# Locate Resources - brief
Get-DscResource
Get-DscResource -Name WindowsFeature | Select-Object -ExpandProperty properties
Get-DscResource -name Windowsfeature -Syntax # Show in ISE

# Create the configuration
ise C:\scripts\DSC1\Mod2\2.SimpleConfig.ps1 #Run
explorer C:\dsc\Config
# Send configuration to target S1
Start-Process -FilePath iexplore http://s1 #should fail
Start-DscConfiguration -Path C:\DSC\Config -ComputerName s1 -Verbose -Wait
# Test on S1 and S2 -- S2 should fail - no config
's1','s2' | Foreach-Object {Start-Process -FilePath iexplore http://$_}

#On S1 -- Remove IIS and reboot - try to catch message
Remove-WindowsFeature -name Web-Server -Restart

Start-Process -FilePath iexplore http://s1 #should fail
Test-DscConfiguration -CimSession s1
Get-DscConfiguration -CimSession s1