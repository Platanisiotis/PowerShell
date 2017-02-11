﻿[DSCLocalConfigurationManager()]
Configuration LCMPUSH 
{	
	Node $Computername
	{
		Settings
		{
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Push'	
		}
	}
}

$Computername = 's1','s2'

# Create the Computer.Meta.Mof in folder
LCMPush -OutputPath c:\DSC\LCM