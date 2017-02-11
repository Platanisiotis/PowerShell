configuration SMTP {

    Node HTTPSComputers {

        WindowsFeature SMTP{
            Name = 'SMTP-Server'
            Ensure = 'Absent'
        }
    }
}

SMTP -OutputPath C:\DSC\HTTPS
