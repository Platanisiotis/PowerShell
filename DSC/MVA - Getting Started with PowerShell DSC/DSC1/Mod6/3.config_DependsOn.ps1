Configuration InstallIIS {
	
        Node s1 {
		WindowsFeature IIS {
			Ensure = 'Present'
			Name   = 'web-server'
		}

        WindowsFeature IISMgmt {
			Ensure = 'Present'
			Name   = 'web-Mgmt-Service'
            DependsOn = "[WindowsFeature]IIS"
		}

        WindowsFeature IISConsole {
			Ensure = 'Present'
			Name   = 'web-mgmt-console'
		}
        
        File DefaultWebSite {
            Ensure = "Present" 
            Type = "Directory“ # Default is “File”
            Force = $True
            Recurse = $True
            SourcePath = "c:\sites\inetpub\wwwroot\"
            DestinationPath = "C:\inetpub\wwwroot\" 
            DependsOn = "[WindowsFeature]IIS"  
        }
	}
}

InstallIIS 
