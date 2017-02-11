
configuration TestLog {

    Node s1 {
        Log CreateLogEntry {
            Message = 'This DSC config worked!'
        } 
        
    }
}

TestLog -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
