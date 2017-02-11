[DSCLocalConfigurationManager()]
Configuration LCM_Push 
{
	Node s1
	{
		Settings
		{
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Push'
                        	
		}
	}
}

LCM_Push -ComputerName s1 -OutputPath C:\DSC\Mod5Config

Set-DSCLocalConfigurationManager -ComputerName s1 -Path c:\DSC\mod5Config –Verbose




