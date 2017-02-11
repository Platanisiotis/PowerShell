configuration HTTPPullServer
{
    # Modules must exist on target pull server
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node dc
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"
        }

        WindowsFeature IISConsole {
            Ensure = "Present"
            Name   = "Web-Mgmt-Console"
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
            UseSecurityBestPractices = $true
        }

        xDscWebService PSDSCComplianceServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCComplianceServer"
            Port                    = 9080
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            State                   = "Started"
            DependsOn               = ("[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer")
            UseSecurityBestPractices = $true
        }
    }
}

# Generate MOF
HTTPPullServer -OutputPath "C:\Program Files\WindowsPowerShell\Modules\DscMetaConfigs"