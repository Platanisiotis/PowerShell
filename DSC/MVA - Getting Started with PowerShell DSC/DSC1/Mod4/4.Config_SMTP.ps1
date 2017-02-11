configuration SMTP {

    Node HTTPComputers {

        WindowsFeature SMTP{
            Name = 'SMTP-Server'
            Ensure = 'Present'
        }
    }
}

SMTP -OutputPath C:\DSC\HTTP
