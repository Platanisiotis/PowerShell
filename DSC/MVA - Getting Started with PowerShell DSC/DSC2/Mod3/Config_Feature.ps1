Configuration Demo_Feature {
    
    Import-DSCResource -ModuleName MVADemo
    
    Node s1 {
        MVAFeature Backup {
            FeatureName= 'windows-server-backup'
            Installed= $True
            Ensure = 'Present'
        }

    }

}

Demo_Feature

Start-DscConfiguration -Path .\Demo_Feature -cimsession s1 -Wait -Verbose
Publish-DscConfiguration -Path .\Demo_Feature -CimSession s1 -Verbose