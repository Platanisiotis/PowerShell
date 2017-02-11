Configuration Demo_Class {
    
    Import-DSCResource -ModuleName MVAClassService
    
    Node dc {
        ClassService bits {

            Servicename = 'bits'
            Servicestatus = 'Running'
            Ensure = 'Present'

        }

    }

}

Demo_class


