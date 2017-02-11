Configuration LCM_Reboot 
{	
	Node s1
	{
		localconfigurationmanager
		{
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Push'
            Debugmode = 'All'
            RebootNodeIfNeeded = $True	
		}
	}
}


LCM_Reboot -OutputPath C:\scripts\dsc2\Mod5\Config

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName s1 -Path C:\scripts\DSC2\Mod5\Config –Verbose


