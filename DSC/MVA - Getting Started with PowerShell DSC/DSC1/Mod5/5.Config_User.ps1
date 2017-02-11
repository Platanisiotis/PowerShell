
configuration TestUser {

    Node s1 {

        User CreateUser {
            Ensure = "Present" 
            UserName= 'TestUser'
            Description = 'This is a DSC test user'
            Disabled = $False
            PasswordChangeNotAllowed = $true
            PasswordNeverExpires = $False
        }
    }
}

TestUser -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
