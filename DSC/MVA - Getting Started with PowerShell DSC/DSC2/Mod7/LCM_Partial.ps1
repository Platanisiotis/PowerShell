[DscLocalConfigurationManager()]
Configuration partialMeta
{ 
    Node s3 {
    
    Settings
    {
        RefreshMode = "Pull"
        RefreshFrequencyMins = 30 
        ConfigurationModeFrequencyMins = 15
        ConfigurationMode = "ApplyAndAutoCorrect"
        RebootNodeIfNeeded = $True
        ConfigurationID = $guid
        
    }

    PartialConfiguration WebServer
    {
        RefreshMode = "PUSH"
        Description = "Web server"
    }

    PartialConfiguration NLB
    {
        RefreshMode = "PULL"
        Description = "For NLB"
        ConfigurationSource = "[ConfigurationRepositoryShare]FileShare"
        DependsOn = "[PartialConfiguration]webserver"
    }


    ConfigurationRepositoryShare FileShare
    {
        SourcePath = "\\DC\DSCSMB"
    }
   }
}

# Create Guid for the computers
$guid=[guid]::NewGuid()

# Create the Computer.Meta.Mof in folder
Partialmeta -Guid $guid -OutputPath C:\Scripts\DSC2\mod7\LCM

