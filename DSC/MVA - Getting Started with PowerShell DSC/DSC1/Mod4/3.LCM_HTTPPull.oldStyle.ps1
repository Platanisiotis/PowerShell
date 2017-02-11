Configuration LCM_HTTPPULL 
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

			DownloadManagerName = 'WebDownloadManager'
			DownloadManagerCustomData = @{
				ServerUrl = 'http://dc:8080/PSDSCPullServer.svc';
				AllowUnsecureConnection = 'true' }
		}
	}
}

# Computer list 
$ComputerName='s1', 's2'

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
LCM_HTTPPULL -ComputerName $ComputerName -Guid $guid -OutputPath c:\DSC\HTTP

Explorer c:\DSC\HTTP

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName $computername -Path c:\DSC\HTTP –Verbose




