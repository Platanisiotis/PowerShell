
configuration TestEnvVar {

    Node s1 {

        Environment NewVar{
            Name = 'MYNEWVAR'
            Value = 'Value to store'
            Ensure = 'Present'
        }
    }
}

TestEnvVar -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose
