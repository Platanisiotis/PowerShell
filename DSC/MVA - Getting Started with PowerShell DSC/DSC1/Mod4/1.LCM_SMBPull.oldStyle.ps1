Configuration LCM_SMBPULL 
{
    param
        (
            [Parameter(Mandatory=$true)]
            [string[]]$ComputerName,

            [Parameter(Mandatory=$true)]
            [string]$guid
        )
        	
	Node $ComputerName
	{
		LocalConfigurationManager
		{
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Pull'

			ConfigurationID = $guid
			DownloadManagerName = "DscFileDownloadManager"
            DownloadManagerCustomData = @{
	            SourcePath = "\\DC\DSCSMB" }
            	
		}
	}
}

# Computer list 
$ComputerName='s1', 's2'

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
LCM_SMBPULL -ComputerName $ComputerName -Guid $guid -OutputPath c:\DSCSMB

Explorer c:\DSCSMB

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName $computername -Path c:\DSCSMB –Verbose




