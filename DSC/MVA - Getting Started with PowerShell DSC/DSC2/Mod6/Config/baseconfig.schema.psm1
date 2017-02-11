configuration BaseConfig {
    param (
        
        [string]$ServiceName

    )
    # There is no Node

        Service StartAudio {
            Name = $serviceName
            State = 'Running'
            Ensure = 'Present'
        }
        WindowsFeature Backup {
            Name = 'Windows-server-backup'
            Ensure = 'Present'

        } 
}

# Save as BaseConfig.schema.psm1

