
configuration TestService {

    Node s1 {
        Service StartAudio {
            Name = 'Audiosrv'
            State = 'Running'
            StartupType = 'Automatic'
        } 
    }
}

TestService -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
