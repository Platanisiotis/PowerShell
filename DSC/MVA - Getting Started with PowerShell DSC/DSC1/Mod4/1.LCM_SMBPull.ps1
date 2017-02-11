[DSCLocalconfigurationManager()]
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
		Settings {
			AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Pull'

			ConfigurationID = $guid
        }
           
            ConfigurationRepositoryShare DSCSMB {
                Name = 'DSCSMB'
                Sourcepath = "\\dc\DSCSMB"
            }   
	}
}

# Computer list 
$ComputerName='s1', 's2'

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
LCM_SMBPULL -ComputerName $ComputerName -Guid $guid -OutputPath c:\DSCSMB



