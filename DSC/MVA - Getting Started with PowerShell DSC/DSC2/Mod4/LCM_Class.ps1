[DSCLocalConfigurationManager()]
Configuration Debugmode 
{	
	Node dc
	{
		Settings
		{
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Push'
            Debugmode = 'All'	
		}
	}
}


DebugMode -OutputPath C:\scripts\dsc2\Mod4

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName dc -Path C:\scripts\DSC2\Mod4 –Verbose


