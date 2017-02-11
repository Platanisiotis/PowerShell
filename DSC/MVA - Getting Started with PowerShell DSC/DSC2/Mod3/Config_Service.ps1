Configuration Demo_Service {
    
    Import-DSCResource -ModuleName MVADemo
    
    Node s2 {
        MVAService Bits {
        ServiceName = 'bits'
        Servicestatus = 'running'
        Ensure = 'Present'
        }

    }

}

Demo_Service -OutputPath C:\Scripts\DSC2\Mod3\Config


