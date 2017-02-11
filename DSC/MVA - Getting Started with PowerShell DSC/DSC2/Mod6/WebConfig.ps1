Configuration WebServer {
    Import-DscResource -ModuleName CompositeDSC

    Node s1 {

        baseconfig Base {
            servicename = 'audiosrv'
        }
        
        WindowsFeature web {
            Name = 'web-server'
            Ensure = 'Present'
        }   

    }

}

webserver -outputpath c:\config

Start-DscConfiguration -path c:\config -ComputerName s1 -Wait -Verbose