Configuration WebServer {
    
    Node s3 {

        
        WindowsFeature web {
            Name = 'web-server'
            Ensure = 'Present'
        }   

    }

}

webserver -outputpath c:\config

