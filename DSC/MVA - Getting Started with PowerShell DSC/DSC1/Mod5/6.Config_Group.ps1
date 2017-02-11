
configuration TestGroup {

    Node s1 {
        Group CreateGroup {
            Ensure = 'Present'
            GroupName = 'TestGroup'
            Description = 'This is a DSC test group'
            Members = 'testuser','administrator'
        } 
        
    }
}

TestGroup -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
