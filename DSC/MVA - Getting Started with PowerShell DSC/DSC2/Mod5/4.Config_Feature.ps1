Configuration Demo_Feature {
    
    Import-DSCResource -ModuleName MVADemo
    
    Node s1 {
        MVAFeature Backup {
            FeatureName= 'web-server'
            Installed= $False
            Ensure = 'Present'
        }

    }

}

Demo_Feature -outputpath C:\Scripts\DSC2\mod5\config

Start-DscConfiguration -Path C:\Scripts\DSC2\mod5\config -cimsession s1 -Wait -Verbose
