[DSCLocalConfigurationManager()]
Configuration LCM_HTTPSPULL 
{
    param
        (
            [Parameter(Mandatory=$true)]
            [string[]]$ComputerName,

            [Parameter(Mandatory=$true)]
            [string]$guid

        )      	
	Node $ComputerName {
	
		Settings {
		
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Pull'
			ConfigurationID = $guid
            }

            ConfigurationRepositoryWeb DSCHTTPS {
                Name= 'DSCHTTPS'
                ServerURL = 'https://s4.company.pri:8080/PSDSCPullServer.svc'
                CertificateID = 'D09D21D12916BFB09B40E7568A7434A6EABFD9BA'
                AllowUnsecureConnection = $False
            }
	}
}

# Computer list 
$ComputerName='s1', 's2'

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
LCM_HTTPSPULL -ComputerName $ComputerName -Guid $guid -OutputPath c:\DSC\HTTPS
