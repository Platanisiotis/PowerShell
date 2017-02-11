Configuration LCM_HTTPSPULL 
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
				ServerUrl = 'https://dc.company.pri:8080/PSDSCPullServer.svc'}
				# AllowUnsecureConnection = 'true' }
		}
	}
}

# Computer list 
$ComputerName='s1', 's2'

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
LCM_HTTPSPULL -ComputerName $ComputerName -Guid $guid -OutputPath c:\DSC\HTTPS

Explorer c:\DSC\HTTPS

# Send to computers LCM
Set-DSCLocalConfigurationManager -ComputerName $computername -Path c:\DSC\HTTPS –Verbose




